
---@param mapPath string
---@param imgs table<string>
---@return IMapInfo
function readMapJS(mapPath, imgs)
    local table_insert = table.insert
    local split = split

    local file =  fileOpen( mapPath[1] )
    local data =  file:read( file:getSize() )
    local proccessed = split(data,10)
    fileClose (file)

    local haveLod = {}

    local SplitA
    local new = {}
    for i = 1, #proccessed do
        SplitA = split(proccessed[i],",")
        if SplitA then
            table_insert( new, { i, SplitA[2], SplitA[3], true, tonumber( SplitA[5] ), 0, tonumber(SplitA[9]) or nil, tonumber(SplitA[10]) or nil } )
            if SplitA[8] == 'true' then
                table_insert( haveLod, i )
            end
        end
    end

    local file = fileOpen( mapPath[2] )
    local data = file:read( file:getSize())
    local proccessed = split(data,10)
    fileClose (file)

    local map = {}
    local standart = {}

    local SplitA = split( proccessed[1], ',' )
    local x, y, z = tonumber(SplitA[1]),tonumber(SplitA[2]),tonumber(SplitA[3])

    local c
    local pos = 0
    for i = 2, #proccessed do
        SplitA = split(proccessed[i],",")
        if SplitA[1] ~= '!' then
            c = table.findIn( new, 2, SplitA[1] )

            if c then
                pos = pos + 1
                table_insert( map, { c, c, tonumber(SplitA[2]), tonumber(SplitA[4]), tonumber(SplitA[5]), tonumber(SplitA[6]), tonumber(SplitA[7]),tonumber(SplitA[8]),tonumber(SplitA[9]), -1 } )
                if table.find( haveLod, c ) then
                    table_insert( map, { c, c, tonumber(SplitA[2]), tonumber(SplitA[4]), tonumber(SplitA[5]), tonumber(SplitA[6]), tonumber(SplitA[7]),tonumber(SplitA[8]),tonumber(SplitA[9]), pos } )
                    pos = pos + 1
                end
            else
                -- local c = table.findIn( ID_list, 2, SplitA[1] )
                -- if c then
                -- 	pos = pos + 1
                -- 	table_insert( standart, ID_list[c][1] )
                -- 	table_insert( map, { ID_list[c][1], false, tonumber(SplitA[2]), tonumber(SplitA[4]), tonumber(SplitA[5]), tonumber(SplitA[6]), tonumber(SplitA[7]),tonumber(SplitA[8]),tonumber(SplitA[9]), -1 } )

                -- else
                --	outputDebugString( 'Can not find def for ' .. tostring( SplitA[1] ) )
                -- end
            end
        end
    end

    proccessed = { new = new, map = map, standart = standart }

    convertMapFromLuaV1( proccessed, imgs )

    return proccessed
end