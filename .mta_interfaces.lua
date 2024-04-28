
---@meta

---@class Element
---@class Object : Element

---@type fun(element: Element): boolean
destroyElement = nil

---@type fun(content: string): Element
engineLoadCOL = nil

---@type fun(modelId: number, x: number, y: number, z: number, rx: number, ry: number, rz: number, isLowLOD: boolean): Object
createObject = nil

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
