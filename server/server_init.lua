Core = exports.vorp_core:GetCore()
BccUtils = exports['bcc-utils'].initiate()
DBG = BccUtils.Debug:Get('bcc-water', Config.devMode.active)

if DBG then
    DBG:Enable()
    DBG:Info('Water debug initialized')
end
