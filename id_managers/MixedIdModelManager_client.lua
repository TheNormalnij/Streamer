
---@class MixedModelIdManager : Class
MixedModelIdManager = class()

---@param static IdManager
---@param dynamic DynamicModelIdManager
function MixedModelIdManager:create(static, dynamic)
    ---@type table<number, true>
    local dynamicAllocatedSet = {}

    local getStaticAvialableCount = static.getAvialableCount
    local getStaticFreeId = static.getFreeID
    local restoreStaticId = static.restoreID

    local getDynamicFreeId = dynamic.getFreeID
    local restoreDynamicId = dynamic.restoreID

    ---@return number
    self.getFreeID = function()
        -- Do faster later
        if getStaticAvialableCount() > 0 then
            return getStaticFreeId()
        else
            local id = getDynamicFreeId()
            dynamicAllocatedSet[id] = true
            return id
        end
    end

    ---@param id number
    self.restoreID = function(id)
        if dynamicAllocatedSet[id] then
            restoreDynamicId(id)
        else
            restoreStaticId(id)
        end
    end
end
