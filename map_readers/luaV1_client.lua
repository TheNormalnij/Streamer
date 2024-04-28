
function convertMapFromLuaV1( mapData, imgs )
    local objectsData = mapData.map
    local def
    for i = 1, #objectsData do
        def = objectsData[i]
        def[11] = def[10] ~= -1 and def[10]
        def[10] = def[10] == -1
    end

    local table_insert = table.insert
    local img = IMG( imgs[1] )
    local files = img:getFilesList()
    img:destroy()

    for i = 2, #imgs do
        img = IMG( imgs[i] )
        for i, path in pairs( img:getFilesList() ) do
            table_insert( files, path )
        end
        img:destroy()
    end

    local table_find = table.find

    local usedDefs = mapData.new
    local def
    for i = 1, #usedDefs do
        def = usedDefs[i]
        def[4] = def[4] and table_find( files, def[2] .. '.col' )
        def[2] = table_find( files, def[2] .. '.dff' )
        def[3] = table_find( files, def[3] .. '.txd' )
    end

    usedDefs = mapData.replace
    if usedDefs then
        for i = 1, #usedDefs do
            def = usedDefs[i]
            def[4] = def[4] and table_find( files, def[2] .. '.col' )
            def[2] = table_find( files, def[2] .. '.dff' )
            def[3] = def[3] and table_find( files, def[3] .. '.txd' )
        end
    end
end

---@param mapPath string
---@param imgs string[]
---@return IMapInfo
function readMapLuaV1(mapPath, imgs)
    local file = File( mapPath )
    if not file then
        return false
    end
    local loadFun = loadstring( file:read( file:getSize(), mapPath ) )

    file:close()
    
    if not loadFun then
        return false
    end
    setfenv( loadFun, {} )

    local mapData = loadFun()

    convertMapFromLuaV1( mapData, imgs )

    return mapData
end
