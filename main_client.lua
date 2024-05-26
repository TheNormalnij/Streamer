
addEvent("World:requestLoad", true)

---@type WorldLoader | nil
local pWorldLoader
---@type WorldManager | nil
local pWorldManager

addEventHandler( "onClientResourceStart", resourceRoot, function()
	pWorldManager = WorldManager()
    pWorldLoader = WorldLoader()

    pWorldLoader:loadDefault()
end )

addEventHandler( "onClientResourceStop", resourceRoot, function()
    if pWorldManager then
        pWorldManager:destroy()
        pWorldManager = nil
    end

    if pWorldLoader then
        pWorldLoader:destroy()
        pWorldLoader = nil
    end
end )

---@param worldName string
---@param dimension number
local function loadWorldRPC(worldName, dimension)
    if pWorldLoader and pWorldManager then
        local world = pWorldManager:getFromName(worldName)
        if world then
            pWorldLoader:load(world)
        else
            outputDebugString("Server request load unregister world", 1)
        end
    end
end
addEventHandler( "World:requestLoad", root, loadWorldRPC )

function registerWorld( data )
    pWorldManager:register( data )

end

function getWorlds()
    return pWorldManager:getWorldsInfo()
end
