
---@meta

---@class Element
---@class Object : Element
---@class Building : Element
---@class Water : Element

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

---@type fun()
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