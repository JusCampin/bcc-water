local InputMenu = FeatherMenu:RegisterMenu('input:menu', {
    top = '3%',
    left = '3%',
    ['720width'] = '400px',
    ['1080width'] = '500px',
    ['2kwidth'] = '600px',
    ['4kwidth'] = '800px',
    style = {},
    contentslot = {
        style = {
            ['height'] = '6.019vh',
            ['min-height'] = '6.019vh'
        }
    },
    draggable = true,
    canclose = true
}, {
    -- opened = function()
    --     DisplayRadar(false)
    -- end,
    -- closed = function()
    --     DisplayRadar(true)
    -- end
})

---@param itemType string
---@param pump boolean
function OpenInputMenu(itemType, pump)
    local InputPage = InputMenu:RegisterPage('input:page')
    local itemAmount
    local headerText = itemType == 'bucket' and _U('headerFillBuckets') or _U('headerFillBottles')
    local configKey = pump and Config.pump.multi or Config.wild.multi
    local amountKey = itemType == 'bucket' and 'bucketAmount' or 'bottleAmount'
    local maxAmount = configKey[amountKey]

    InputPage:RegisterElement('header', {
        value = headerText,
        slot = 'header',
        style = {}
    })

    InputPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })

    InputPage:RegisterElement('slider', {
        label = _U('quantity'),
        start = 1,
        min = 1,
        max = maxAmount,
        steps = 1
    }, function(data)
        itemAmount = data.value
    end)

    InputPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    InputPage:RegisterElement('button', {
        label = _U('confirm'),
        slot = 'footer',
        style = {}
    }, function()
        local hasItems = Core.Callback.TriggerAwait('bcc-water:GetItem', itemType, itemAmount or 1, pump)
        if hasItems then
            InputMenu:Close()
            if itemType == 'bucket' then
                BucketFill(pump)
            else
                BottleFill(pump)
            end
        end
    end)

    InputPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    InputMenu:Open({
        startupPage = InputPage
    })
end