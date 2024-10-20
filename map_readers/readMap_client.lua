
---@alias IAtomicDefs number[]
---@alias ITimedDefs number[]
---@alias IClumpDefs number[]

---@alias IObjectPositionDef any[]
---@alias IWaterDef number[]
---@alias IColDef number[]

---@class IDefsMap
---@field atomic number
---@field timed number
---@field clump number
---@field damageable number

---@class IMapInfo
---@field defsmap IDefsMap
---@field defs number[][]
---@field colmap IColDef[]
---@field map IObjectPositionDef[]
---@field water IWaterDef[]
---@field physical IPhysicalData

--- Read world map info
---@param world World
---@return IMapInfo
function readMap( world )
    if world.mapType == 'lua' then
        return readLuaMap(world.mapPath)
    end
    error("Incorrent map type", 2)
end
