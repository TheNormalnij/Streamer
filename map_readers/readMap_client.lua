
---@alias IAtomicDefs number[]
---@alias ITimedDefs number[]
---@alias IClumpDefs number[]

---@class IDefs
---@field atomic IAtomicDefs[]
---@field timed ITimedDefs[]
---@field clump IClumpDefs[]

---@alias IObjectPositionDef any[]
---@alias IWaterDef number[]
---@alias IColDef number[]

---@class IMapInfo
---@field defs IDefs
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
