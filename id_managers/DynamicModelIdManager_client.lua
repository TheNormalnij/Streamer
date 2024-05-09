
---@class DynamicModelIdManager : Class
DynamicModelIdManager = class()

---comment
---@param modelType 'object' | 'clump' | 'timed-object' | 'ped' | 'vehicle'
function DynamicModelIdManager:create(modelType)
    local engineRequestModel = engineRequestModel

    ---@return number
    self.getFreeID = function()
        local id = engineRequestModel(modelType)
        if not id then
            error("Can not allocate model for " .. modelType)
        end
        return id
    end

    self.restoreID = engineFreeModel
end