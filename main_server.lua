
---@type WorldManager
local pWorldManager

---@type ServerSettings
local pServerSettings

addEventHandler( "onResourceStart", resourceRoot, function()
	pWorldManager = WorldManager()
    pServerSettings = ServerSettings()
end )

addEventHandler( "onResourceStop", resourceRoot, function()
	pWorldManager:destroy()
    pServerSettings:destroy()
end )

--- Exported function
---@param data IWorldData
function registerWorld( data )
    pWorldManager:register( data )
end

--- Exported function
function getWorlds()
    return pWorldManager:getWorldsInfo()
end
