
---@class IdManager : Class
IdManager = class();

---@param avialableList number[] list with all ids
---@param name string name of manager
function IdManager:create(avialableList, name)
    local lastFreePos = #avialableList

    self.getAvialableCount = function()
        return lastFreePos
    end

    --- Removes ID from list and returns it
    ---@return integer
    self.getFreeID = function()
        if lastFreePos == 0 then
            error("Can not return free id in " .. name, 2)
        end
        local id = avialableList[lastFreePos]
        lastFreePos = lastFreePos - 1
        return id
    end

    --- Adds ID to list
    ---@param id integer
    self.restoreID = function(id)
        lastFreePos = lastFreePos + 1
        avialableList[lastFreePos] = id
    end

    --- Removes selected ID from list
    ---@param id integer
    ---@return boolean
    self.lockID = function(id)
        for index = 1, lastFreePos do
            if avialableList[index] == id then
                table.remove(avialableList, index)
                lastFreePos = lastFreePos - 1
                return true
            end
        end
        return false
    end
end
