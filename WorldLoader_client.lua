
---@class WorldLoader : Class
WorldLoader = class()

function WorldLoader:create( )
    ---@private
    ---@type WorldSA
    self.default = WorldSA()
    ---@private
    ---@type World[]
    self.currentWorlds = { self.default }
    ---@private
    ---@type World[]
    self.defaultLoaded = { self.default }
    ---@private
    self.instances = {}
end;

function WorldLoader:destroy( )
    self:load(self.default)
end;

---@private
---@param world World
---@return boolean
function WorldLoader:load( world )
    self:unloadAllCurrent()

    outputDebugString("Loading world: " .. tostring(world.name), 3)

    if self:tryLoadWorld(world) then
        table.insert(self.currentWorlds, world)
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
        return true
    else
        return false
    end
end;

function WorldLoader:unloadAllCurrent( )
    outputDebugString("Unload all current worlds", 3)

    for i = #self.currentWorlds, 1, -1 do
        self:tryUnloadWorld(self.currentWorlds[i])
        self.currentWorlds[i] = nil
    end
end;

function WorldLoader:loadDefault( )
    outputDebugString("Load default world", 3)

    for _, world in ipairs(self.defaultLoaded) do
        self:tryLoadWorld(world)
        table.insert(self.currentWorlds, world)
    end
end
