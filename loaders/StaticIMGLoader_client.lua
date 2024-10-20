
-- Stream models from IMG

---@class StaticIMGLoader : ILoader, IWithDestructor
---@field private water WaterLoader
---@field private modelLoader StaticIMGModelLoader
---@field private streamer MtaObjectStaticStreamer
---@field private world World
---@field private loaded boolean
---@field private physical PhysicalPropertiesLoader
StaticIMGLoader = class()

---@param world World
function StaticIMGLoader:create( world )
    self.loaded = false
    self.world = world
    self.streamer = nil
    self.modelLoader = nil
    self.water = nil
    self.physical = nil
end

function StaticIMGLoader:destroy( )
    if self.loaded then
        self:unload()
    end

    safeDestroy(self.streamer)
    safeDestroy(self.water)
    safeDestroy(self.modelLoader)
    safeDestroy(self.physical)
end

function StaticIMGLoader:load( )
    local worldInfo = readMap( self.world )
    if not worldInfo then
        return false
    end

    local currentPoolSize = engineGetPoolCapacity('building')
    local requiredPoolSize = #worldInfo.map + 5000
    if currentPoolSize < requiredPoolSize then
        engineSetPoolCapacity('building', requiredPoolSize)
    end

    local defs = worldInfo.defs
    self.modelLoader = StaticIMGModelLoader(worldInfo.colmap, defs, worldInfo.defsmap, self.world:getIMGs())
    self.modelLoader:load()

    self.physical = PhysicalPropertiesLoader(worldInfo.physical, defs)
    self.physical:load()

    self.streamer = MtaBuildingStaticStreamer(worldInfo.map, defs)
    self.streamer:start()

    self.water = WaterLoader(worldInfo.water)
    self.water:load()

    return true
end

function StaticIMGLoader:unload( )
    if self.water then
        self.water:unload()
    end

    if self.streamer then
        self.streamer:stop()
    end

    if self.physical then
        self.physical:unload()
    end

    if self.modelLoader then
        self.modelLoader:unload()
    end

    return true
end
