
---@class ColMapLoader : Class, IWithDestructor
ColMapLoader = class()

function ColMapLoader:create( )
    ---@private
    ---@type Element[]
    self.cols = {}

    ---@private
    self.loaded = false
end

function ColMapLoader:destroy( )
    if self.loaded then
        self:unload()
    end
end

function ColMapLoader:getCols( )
    return self.cols
end

---@param content string
---@param colMap table<number, number[]>
function ColMapLoader:load( content, colMap )
    local loadedCols = self.cols

    local string_sub = string.sub
    local engineLoadCOL = engineLoadCOL
    local colinfo
    for i = 1, #colMap do
        colinfo = colMap[i]
        loadedCols[i] = engineLoadCOL( string_sub( content, colinfo[1], colinfo[2] ) )
    end

    self.loaded = true
end

function ColMapLoader:unload( )
    local destroyElement = destroyElement

    local loadedCols = self.cols
    for i = #loadedCols, 1, -1 do
        destroyElement(loadedCols[i])
        loadedCols[i] = nil
    end

    self.loaded = false
end
