
--- Latest format
---@param mapPath string
---@return IMapInfo
function readLuaMap(mapPath)
    local file = File( mapPath )
    if not file then
        error("Can not read map file")
    end
    local loadFun = loadstring( file:read( file:getSize(), mapPath ) )

    file:close()

    if not loadFun then
        error("Can not load map data")
    end
    setfenv( loadFun, {} )

    return loadFun()
end
