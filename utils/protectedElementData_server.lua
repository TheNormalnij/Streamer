---@diagnostic disable: undefined-global

local function changeHandler(dataName, oldValue, newValue)
    if client then
        source:setData(dataName, oldValue)
    end
end

---Disable element data changes from client
---@param element Element
function protectElementData(element)
    addEventHandler("onElementDataChange", element, changeHandler)
end