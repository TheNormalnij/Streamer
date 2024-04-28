
-- Stream models from IMG

---@class StaticIMGLoader : ILoader, IWithDestructor
---@field private water WaterLoader
---@field private modelLoader StaticIMGModelLoader
---@field private streamer MtaObjectStaticStreamer
---@field private world World
---@field private loaded boolean
StaticIMGLoader = class()

---@param world World
function StaticIMGLoader:create( world )
    self.loaded = false
    self.world = world
    self.streamer = nil
    self.modelLoader = nil
    self.water = nil
end

function StaticIMGLoader:destroy( )
    if self.loaded then
        self:unload()
    end

    safeDestroy(self.streamer)
    safeDestroy(self.water)
    safeDestroy(self.modelLoader)
end

function StaticIMGLoader:load( )
    local worldInfo = readMap( self.world )
    if not worldInfo then
        return false
    end

    self.modelLoader = StaticIMGModelLoader(worldInfo.colmap, worldInfo.new, self.world:getIMGs())
    self.modelLoader:load()

    self.streamer = MtaObjectStaticStreamer(worldInfo.map, worldInfo.new)
    self.streamer:start()

    self.water = WaterLoader(worldInfo.water)
    self.water:load()

    return true
end

function StaticIMGLoader:unload( )
    if self.streamer then
        self.streamer:stop()
    end

    if self.water then
        self.water:unload()
    end

    if self.modelLoader then
        self.modelLoader:unload()
    end

    return true
end
