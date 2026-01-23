local MaxCanteenDrinks = Config.maxCanteenDrinks
local SickPlayers = {}

---@param src number
---@param canteenId number
---@param drinksLeft number
---@param durability number
local function updateCanteenMetadata(src, canteenId, drinksLeft, durability)
    local description = _U('canteenDesc') .. '<br>'
    .. _U('drinksLeft') .. ' : ' .. tostring(drinksLeft) .. '/' .. tostring(MaxCanteenDrinks) .. '<br>'
    .. _U('Durability') .. ' : ' .. tostring(durability) .. '%'
    exports.vorp_inventory:setItemMetadata(src, canteenId, {
        description = description,
        drinksLeft = drinksLeft,
        durability = durability
    })
    DBG:Info(string.format('Updated canteen metadata for source %d: Drinks Left = %d, Durability = %d%%', src, drinksLeft, durability))
end

-- Manage Filling a New or Empty Canteen
Core.Callback.Register('bcc-water:GetCanteenLevel', function(source, cb)
    local src = source
    local user = Core.getUser(src)
    -- Check if the user exists
    if not user then
        DBG:Error(string.format('User not found for source: %d', src))
        return cb(false)
    end
    local itemCanteen = Config.canteen
    local canteen = exports.vorp_inventory:getItem(src, itemCanteen)
    -- Check if the canteen exists in the inventory
    if not canteen then
        Core.NotifyRightTip(src, _U('needCanteen'), 4000)
        DBG:Warning(string.format('Canteen not found for source: %d', src))
        return cb(false)
    end
    local meta = canteen['metadata']
    local isNewCanteen = next(meta) == nil
    -- Fill the canteen if it's new or not full
    if isNewCanteen then
        updateCanteenMetadata(src, canteen.id, MaxCanteenDrinks, 100)
        DBG:Info(string.format('Filled new canteen for source: %d', src))
    else
        local drinksLeft = meta.drinksLeft
        local durability = meta.durability
        if drinksLeft < MaxCanteenDrinks then
            updateCanteenMetadata(src, canteen.id, MaxCanteenDrinks, durability)
            DBG:Info(string.format('Refilled canteen for source: %d', src))
        else
            Core.NotifyRightTip(src, _U('fullCanteen'), 4000)
            DBG:Info(string.format('Canteen already full for source: %d', src))
            return cb(false)
        end
    end
    cb(true)
end)

-- Manage Drinking from Canteen
Core.Callback.Register('bcc-water:UpdateCanteen', function(source, cb)
    local src = source
    local user = Core.getUser(src)
    -- Check if the user exists
    if not user then
        DBG:Error(string.format('User not found for source: %d', src))
        return cb(false)
    end
    local itemCanteen = Config.canteen
    local canteen = exports.vorp_inventory:getItem(src, itemCanteen)
    local meta = canteen['metadata']
    local drinksLeft = meta.drinksLeft
    local durability = meta.durability
    local canteenUsage = Config.durability.canteen
    local newDurability = durability and durability - canteenUsage or 100
    -- Decrement drinks left and update durability
    if drinksLeft and drinksLeft > 0 then
        updateCanteenMetadata(src, canteen.id, drinksLeft - 1, newDurability)
        DBG:Info(string.format('Used canteen for source %d: Drinks Left = %d, New Durability = %d%%', src, drinksLeft - 1, newDurability))
        -- Remove the canteen if durability is too low
        if newDurability and newDurability < canteenUsage then
            exports.vorp_inventory:subItemById(src, canteen.id)
            Core.NotifyRightTip(src, _U('brokeCanteen'), 4000)
            DBG:Info(string.format('Canteen broke for source: %d', src))
        end
    else
        Core.NotifyRightTip(src, _U('emptyCanteen'), 4000)
        DBG:Info(string.format('Canteen empty for source: %d', src))
        return cb(false)
    end
    cb(true)
end)

RegisterNetEvent('bcc-water:UpdateSickness', function(isSick)
    local src = source
    local user = Core.getUser(src)
    -- Check if the user exists
    if not user then
        DBG:Error(string.format('User not found for source: %d', src))
        return
    end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier
    DBG:Info(string.format('Updating sickness for character ID: %d', charid))
    SickPlayers[charid] = isSick and true or nil
    DBG:Info(string.format('Sickness status for character ID %d: %s', charid, tostring(isSick)))
end)

Core.Callback.Register('bcc-water:CheckSickness', function(source, cb)
    local src = source
    local user = Core.getUser(src)
    -- Check if the user exists
    if not user then
        DBG:Error(string.format('User not found for source: %d', src))
        return cb(false)
    end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier
    if SickPlayers[charid] then
        DBG:Info(string.format('Sickness detected for character ID %d: %s', charid, tostring(SickPlayers[charid])))
        return cb(true)
    else
        DBG:Info(string.format('No sickness detected for character ID %d', charid))
        return cb(false)
    end
end)

-- Check if Player has an Item and Update Inventory
---@param itemType string
---@param itemAmount number
---@param pump boolean
Core.Callback.Register('bcc-water:GetItem', function(source, cb, itemType, itemAmount, pump)
    local src = source
    local user = Core.getUser(src)
    -- Check if the user exists
    if not user then
        DBG:Error(string.format('User not found for source: %d', src))
        return cb(false)
    end
    -- Set empty item and notifications based on item type
    local emptyItem = itemType == 'bucket' and Config.emptyBucket or Config.emptyBottle
    local notification = itemType == 'bucket' and _U('needBucket') or _U('needBottle')
    -- Check if the player has the required item
    local item = exports.vorp_inventory:getItem(src, emptyItem)
    if not item or item.count < itemAmount then
        Core.NotifyRightTip(src, notification, 4000)
        DBG:Warning(string.format('Source %d does not have the required item: %s', src, emptyItem))
        return cb(false)
    end
    -- Remove empty items
    exports.vorp_inventory:subItem(src, emptyItem, itemAmount)
    for i = 1, itemAmount do
        local sourceType = pump and 'pump' or 'wild'
        if itemType == 'bottle' then
            local itemName = pump and Config.cleanBottle or Config.dirtyBottle
            exports.vorp_inventory:addItem(src, itemName, 1, { source = sourceType })
            DBG:Info(string.format('Added item to source %d: %s, Pump: %s', src, itemName, tostring(pump)))
        elseif itemType == 'bucket' then
            local itemName = pump and Config.cleanBucket or Config.dirtyBucket
            exports.vorp_inventory:addItem(src, itemName, 1, { source = sourceType })
            DBG:Info(string.format('Added item to source %d: %s, Pump: %s', src, itemName, tostring(pump)))
        end
    end
    cb(true)
end)

-- Register the canteen as a usable item
exports.vorp_inventory:registerUsableItem(Config.canteen, function(data)
    local src = data.source
    exports.vorp_inventory:closeInventory(src)
    local itemCanteen = Config.canteen
    local canteen = exports.vorp_inventory:getItem(src, itemCanteen)
    local meta = canteen['metadata']
    local durability = meta.durability
    local canteenUsage = Config.durability.canteen
    -- Check if the canteen can be used
    if durability == nil or durability >= canteenUsage then
        TriggerClientEvent('bcc-water:UseCanteen', src)
        DBG:Info(string.format('Canteen used by source: %d', src))
    else
        DBG:Warning(string.format('Canteen cannot be used by source: %d', src))
    end
end)

-- Clean Bottle (no sickness)
if Config.useable.cleanBottle then
    DBG:Info('Registering clean bottle as usable item')
    exports.vorp_inventory:registerUsableItem(Config.cleanBottle, function(data)
        local src = data.source
        local emptyBottle = Config.emptyBottle
        exports.vorp_inventory:closeInventory(src)
        exports.vorp_inventory:subItemById(src, data.item.id)
        if exports.vorp_inventory:canCarryItem(src, emptyBottle, 1) then
            exports.vorp_inventory:addItem(src, emptyBottle, 1)
        end
        TriggerClientEvent('bcc-water:DrinkBottle', src, false)
    end)
end

-- Dirty Bottle (sickness chance)
if Config.useable.dirtyBottle then
    DBG:Info('Registering dirty bottle as usable item')
    exports.vorp_inventory:registerUsableItem(Config.dirtyBottle, function(data)
        local src = data.source
        local emptyBottle = Config.emptyBottle
        exports.vorp_inventory:closeInventory(src)
        exports.vorp_inventory:subItemById(src, data.item.id)
        if exports.vorp_inventory:canCarryItem(src, emptyBottle, 1) then
            exports.vorp_inventory:addItem(src, emptyBottle, 1)
        end
        TriggerClientEvent('bcc-water:DrinkBottle', src, true)
    end)
end

if Config.useable.antidoteItem then
    DBG:Info('Registering antidote item as usable item')
    exports.vorp_inventory:registerUsableItem(Config.antidoteItem, function(data)
        local src = data.source
        exports.vorp_inventory:closeInventory(src)
        exports.vorp_inventory:subItem(src, Config.antidoteItem, 1)
        TriggerClientEvent('bcc-water:CureSickness', src)
    end)
end

-- Check if Player has a specific item
Core.Callback.Register('bcc-water:CheckItem', function(source, cb, itemName)
    local src = source
    local user = Core.getUser(src)
    if not user then
        DBG:Error(string.format('User not found for source: %d', src))
        return cb(false)
    end

    local item = exports.vorp_inventory:getItem(src, itemName)
    local hasItem = item and item.count > 0

    DBG:Info(string.format('CheckItem for source %d, item %s: %s', src, itemName, tostring(hasItem)))
    cb(hasItem)
end)

-- Remove a specific item from Player inventory
Core.Callback.Register('bcc-water:RemoveItem', function(source, cb, itemName, amount)
    local src = source
    local user = Core.getUser(src)
    if not user then
        DBG:Error(string.format('User not found for source: %d', src))
        return cb(false)
    end

    local item = exports.vorp_inventory:getItem(src, itemName)
    if not item or item.count < amount then
        DBG:Warning(string.format('Source %d does not have enough of item: %s (required: %d, has: %d)', src, itemName, amount, item and item.count or 0))
        return cb(false)
    end

    exports.vorp_inventory:subItem(src, itemName, amount)
    DBG:Info(string.format('Removed %d of item %s from source %d', amount, itemName, src))
    cb(true)
end)

BccUtils.Versioner.checkFile(GetCurrentResourceName(), 'https://github.com/BryceCanyonCounty/bcc-water')
