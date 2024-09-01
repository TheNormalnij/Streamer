
addEvent("World:requestLoad", true)

---@type WorldLoader | nil
local pWorldLoader
---@type WorldManager | nil
local pWorldManager

addEventHandler( "onClientResourceStart", resourceRoot, function()
    ---@type WorldManager
	pWorldManager = WorldManager()
    ---@type WorldLoader
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

-- Exported function
function registerWorld( data )
    if pWorldManager ~= nil then
        pWorldManager:register(data)
    else
        error("World manager is not ready", 2)
    end

end

-- Exported function
function getWorlds()
    if pWorldManager ~= nil then
        return pWorldManager:getWorldsInfo()
    else
        error("World manager is not ready", 2)
    end
end
