
--- Latest format
---@param mapPath string
---@return IMapInfo | nil
function readMapLuaV2(mapPath)
    local file = File( mapPath )
    if not file then
        return
    end
    local loadFun = loadstring( file:read( file:getSize(), mapPath ) )

    file:close()

    if not loadFun then
        return
    end
    setfenv( loadFun, {} )

    return loadFun()
end