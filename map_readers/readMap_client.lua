
---@alias IObjectDef number[]
---@alias IObjectPositionDef any[]
---@alias IWaterDef number[]
---@alias IColDef number[]

---@class IMapInfo
---@field new IObjectDef[]
---@field colmap IColDef[]
---@field map IObjectPositionDef[]
---@field water IWaterDef[]

--- Read world map info
---@param world any
---@return IMapInfo
function readMap( world )
    if world.mapType == 'lua_v2' then
        return readMapLuaV2(world.mapPath)
    elseif world.mapType == 'lua_v1' then
        return readMapLuaV1(world.mapPath, world.imgs)
    elseif world.mapType == 'JS' then
        return readMapJS(world.mapPath, world.imgs)
    end
    error("Incorrent map type", 2)
end
