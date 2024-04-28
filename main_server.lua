
---@type WorldManager
local pWorldManager

addEventHandler( "onResourceStart", resourceRoot, function()
	pWorldManager = WorldManager()
end )

addEventHandler( "onResourceStop", resourceRoot, function()
	pWorldManager:destroy()
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
