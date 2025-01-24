
---@class WorldLoader : Class
---@field public worldSA WorldSA
---@field private default World[]
---@field private instances table<World, ILoader>
WorldLoader = class()

function WorldLoader:create( )
    self.worldSA = WorldSA()
    self.default = { self.worldSA }
    self.instances = {}
end;

function WorldLoader:destroy( )
    self:load(self.worldSA)
end;

---@param ... World
function WorldLoader:setDefaultWorld(...)
    self.default = { ... }
end

function WorldLoader:isLoadedAnyWorld()
    return next(self.instances) ~= nil
end

---@param world World
---@return boolean
function WorldLoader:load( world )
    self:unloadAllCurrent()

    outputDebugString("Loading world: " .. tostring(world.name), 3)

    if self:tryLoadWorld(world) then
        return true
    else
        self:loadDefault()
        return false
    end
end;

---@private
---@param world World
---@return boolean
function WorldLoader:unload( world )
    outputDebugString("Unloading world: " .. tostring(world.name), 3)

    self:unloadAllCurrent()
    self:loadDefault()
    return true
end;

---@param world World
---@return boolean
function WorldLoader:tryLoadWorld( world )
    local loaderClass = getLoaderClass( world.loader or "IMGStream" )
    if not loaderClass then
        outputDebugString("Can not find loader for world " .. tostring(world.name), 2)
        return false
    end

    local ticks = getTickCount()

    ---@type ILoader
    local instance = loaderClass(world)
    if instance:load() then
        self.instances[world] = instance

        local finishTick = getTickCount()
        outputDebugString('World was loaded after ' .. (finishTick - ticks)/1000, 3)
        return true
    end

    instance:unload()
    outputDebugString("Error during loading " .. tostring(world.name), 1)
    return false
end;

---@param world World
---@return boolean
function WorldLoader:tryUnloadWorld( world )
    local instance = self.instances[world]
    if instance then
        instance:unload()
        self.instances[world] = nil
        return true
    else
        return false
    end
end;

function WorldLoader:unloadAllCurrent( )
    outputDebugString("Unload all current worlds", 3)

    for world, instance in next, self.instances do
        instance:unload()
        self.instances[world] = nil
    end
end;

function WorldLoader:loadDefault( )
    outputDebugString("Load default world", 3)

    for _, world in ipairs(self.default) do
        self:tryLoadWorld(world)
    end
end

---@param world World
function WorldLoader:removeWorld(world)
    self:tryUnloadWorld(world)
    if self.default == world then
        self.default = {}
    end
end
