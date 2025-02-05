
---@meta

---@class Element
---@field destroy fun(this: self): boolean
---@class Object : Element
---@class Building : Element
---@class Water : Element
---@class IMG : Element

---@type fun(element: Element): boolean
destroyElement = nil

---@type fun(content: string): Element
engineLoadCOL = nil

---@type fun(modelId: number, x: number, y: number, z: number, rx: number, ry: number, rz: number, isLowLOD: boolean): Object
createObject = nil

---@type fun(modelId: number, x: number, y: number, z: number, rx: number, ry: number, rz: number, interior: number): Building
createBuilding = nil

---@type fun(x: number, y: number, z: number, x2: number, y2: number, z2: number, x3: number, y3: number, z3: number, shallow: boolean): Water
createWater = nil

---@type fun(x: number, y: number, z: number, x2: number, y2: number, z2: number, x3: number, y3: number, z3: number,  x4: number, y4: number, z4: number, shallow: boolean): Water
createWater = nil

---@type fun(element: Element, int: integer): boolean
setElementInterior = nil
---@type fun(element: Element, lod: Element): boolean
setLowLODElement = nil
---@type fun(element: Element, enabled: boolean): boolean
setElementCollisionsEnabled = nil

---@type fun(reloadBigLods?: boolean)
engineRestreamWorld = nil

---@type fun(modelID: number, redius: number, x: number, y: number, z: number): boolean
restoreWorldModel = nil

---@type fun(modelID: number, redius: number, x: number, y: number, z: number): boolean
removeWorldModel = nil

---@type fun(message: string, level?: number): boolean
outputDebugString = nil

---@type fun(modelId: number): number
engineGetModelTXDID = nil

---@type fun(state: boolean): boolean
setOcclusionsEnabled = nil

---@type fun(modelId: number, on: number, off: number): boolean
engineSetModelVisibleTime = nil

---@type fun(modelId: number): number, number
engineGetModelVisibleTime = nil

---@type fun(type: 'object' | 'clump' | 'timed-object' | 'ped' | 'vehicle' | 'damageable-object'): number | false
engineRequestModel = nil

---@type fun(id: number): boolean
engineFreeModel = nil

---@type Element
root = nil

---@type Element
resourceRoot = nil

---@type Element
sourceResourceRoot = nil

---@type fun(): number
getTickCount = nil


---@type fun(eventName: string, remote?: boolean)
addEvent = nil

---@type fun(eventName: string, root: Element, handler: function)
addEventHandler = nil

---@type fun(eventName: string, root: Element, ...: any)
triggerEvent = nil

---@type fun()
restoreGameWorld = nil

---@type fun()
removeGameWorld = nil

---@type fun()
resetWaterLevel = nil

---@type fun(modelId: number): number
engineGetModelPhysicalPropertiesGroup = nil

---@type fun(modelId: number, group: number): boolean
engineSetModelPhysicalPropertiesGroup = nil
