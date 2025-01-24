
---@class (exact) MtaBuildingStaticStreamer : IStreamer, IWithDestructor
---@field private map IObjectPositionDef[]
---@field private defs number[][]
---@field private enabled boolean
---@field private elements Element[]
MtaBuildingStaticStreamer = class()

---@param map IObjectPositionDef[]
---@param defs number[][]
function MtaBuildingStaticStreamer:create( map, defs )
    self.map = map
    self.defs = defs
    self.enabled = false
    self.elements = {}
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

    self:destroyAllBuildings()

    self.enabled = false
    return true
end

---@private
function MtaBuildingStaticStreamer:createAllBuilding( )
    local map = self.map
    local defs = self.defs

    local objectData, modelID, def, object, lod

    local loadedElements = {}
    self.elements = loadedElements

    local setElementInterior = setElementInterior
    local setLowLODElement = setLowLODElement
    local createBuilding = createBuilding
    local createObject = createObject
    local setElementCollisionsEnabled = setElementCollisionsEnabled
    local engineGetModelPhysicalPropertiesGroup = engineGetModelPhysicalPropertiesGroup

    for i = 1, #map do
        objectData = map[i]
        def = defs[ objectData[2] ]
        modelID = objectData[2] and def[1] or objectData[1]

        if (engineGetModelPhysicalPropertiesGroup(modelID) ~= -1 or objectData[4] < -3000 or objectData[4] > 3000 or objectData[5] < -3000 or objectData[5] > 3000) then
            -- Load as dummy
            object = createObject( modelID, objectData[4], objectData[5], objectData[6], objectData[7], objectData[8], objectData[9], objectData[10] )
            if object then
                if objectData[3] ~= 0 then
                    setElementInterior( object, objectData[3] )
                end

                if def and not def[4] then
                    setElementCollisionsEnabled( object, false )
                end
            else
                outputDebugString( 'Object can not be created ' ..  modelID, 2 )
            end
            loadedElements[i] = object
        else
            -- Load as building
            object = createBuilding( modelID, objectData[4], objectData[5], objectData[6], objectData[7], objectData[8], objectData[9], objectData[3] )

            if def and not def[4] then
                setElementCollisionsEnabled( object, false )
            end
            if objectData[11] ~= -1 then
                lod = loadedElements[ objectData[11] ]
                if lod then
                    setLowLODElement( object, lod )
                end
            end
            loadedElements[i] = object
        end
    end
end

---@private
function MtaBuildingStaticStreamer:destroyAllBuildings( )
    local destroyElement = destroyElement

    local buildings = self.elements
    for i = #buildings, 1, -1 do
        if buildings[i] then
            destroyElement(buildings[i])
        end
    end

    self.elements = {}
end
