
---@class MtaObjectStaticStreamer : IStreamer, IWithDestructor
MtaObjectStaticStreamer = class()

---@param map IObjectPositionDef[]
---@param defs IObjectDef[]
function MtaObjectStaticStreamer:create( map, defs )
    ---@private
    self.map = map
    ---@private
    self.defs = defs
    ---@private
    self.enabled = false
    ---@private
    ---@type Object[]
    self.objects = {}
end

function MtaObjectStaticStreamer:destroy( )
    if self.enabled then
        self:stop()
    end
end

function MtaObjectStaticStreamer:start( )
    if self.enabled then
        return false
    end

    self:createAllObjects()
    self.enabled = true
    return true
end

function MtaObjectStaticStreamer:stop( )
    if not self.enabled then
        return false
    end

    self:destroyAllObjects()

    self.enabled = false
    return true
end

---@private
function MtaObjectStaticStreamer:createAllObjects( )
    local objectsData = self.map
    local defs = self.defs

    local objectData, modelID, def, object, lod

    local loadedObjects = {}
    self.objects = loadedObjects

    local setElementInterior = setElementInterior
    local setLowLODElement = setLowLODElement
    local createObject = createObject
    local setElementCollisionsEnabled = setElementCollisionsEnabled

    for i = 1, #objectsData do
        objectData = objectsData[i]
        def = defs[ objectData[2] ]
        modelID = objectData[2] and def[1] or objectData[1]
        object = createObject( modelID, objectData[4], objectData[5], objectData[6], objectData[7], objectData[8], objectData[9], objectData[10] )
        if object then
            if objectData[3] ~= 0 then
                setElementInterior( object, objectData[3] )
            end

            if def and not def[4] then
                setElementCollisionsEnabled( object, false )
            end
            if objectData[11] then
                lod = objectsData[ objectData[11] ]
                if lod then
                    setLowLODElement( object, lod )
                end
            end
        else
            outputDebugString( 'Object can not be created ' ..  modelID, 2 )
        end
        loadedObjects[i] = object
    end
end

---@private
function MtaObjectStaticStreamer:destroyAllObjects( )
    local destroyElement = destroyElement

    local objects = self.objects
    for i = #objects, 1, -1 do
        if objects[i] then
            destroyElement(objects[i])
        end
    end

    self.objects = {}
end
