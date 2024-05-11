
---@class (exact) MtaBuildingStaticStreamer : IStreamer, IWithDestructor
---@field private map IObjectPositionDef[]
---@field private defs IDefs
---@field private enabled boolean
---@field private buildings Building[]
MtaBuildingStaticStreamer = class()

---@param map IObjectPositionDef[]
---@param defs IDefs
function MtaBuildingStaticStreamer:create( map, defs )
    self.map = map
    self.defs = defs
    self.enabled = false
    self.buildings = {}
end

function MtaBuildingStaticStreamer:destroy( )
    if self.enabled then
        self:stop()
    end
end

function MtaBuildingStaticStreamer:start( )
    if self.enabled then
        return false
    end

    self:createAllBuilding()
    self.enabled = true
    return true
end

function MtaBuildingStaticStreamer:stop( )
    if not self.enabled then
        return false
    end

    self:destroyAllObjects()

    self.enabled = false
    return true
end

---@private
function MtaBuildingStaticStreamer:createAllBuilding( )
    local map = self.map
    local defs = table.uniteArrays(self.defs.atomic, self.defs.timed, self.defs.clump)

    local objectData, modelID, def, building, lod

    local loadedBuildings = {}
    self.buildings = loadedBuildings

    local setLowLODElement = setLowLODElement
    local createBuilding = createBuilding
    local setElementCollisionsEnabled = setElementCollisionsEnabled

    for i = 1, #map do
        objectData = map[i]
        def = defs[ objectData[2] ]
        modelID = objectData[2] and def[1] or objectData[1]
        building = createBuilding( modelID, objectData[4], objectData[5], objectData[6], objectData[7], objectData[8], objectData[9], objectData[3] )
        if building then

            if def and not def[4] then
                setElementCollisionsEnabled( building, false )
            end
            if objectData[11] then
                lod = map[ objectData[11] ]
                if lod then
                    setLowLODElement( building, lod )
                end
            end
        else
            outputDebugString( 'Building can not be created ' ..  modelID, 2 )
        end
        loadedBuildings[i] = building
    end
end

---@private
function MtaBuildingStaticStreamer:destroyAllObjects( )
    local destroyElement = destroyElement

    local buildings = self.buildings
    for i = #buildings, 1, -1 do
        if buildings[i] then
            destroyElement(buildings[i])
        end
    end

    self.buildings = {}
end
