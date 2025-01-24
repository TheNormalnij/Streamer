
---@class EventEmmiter : Class
---@field private events table<string, function[]>
EventEmiter = class()

function EventEmiter:create()
    self.events = {}
end

---Subscribe
---@param eventName string
---@param handler function
function EventEmiter:on(eventName, handler)
    local listeners = self.events[eventName]
    if not listeners then
        listeners = { [eventName] = { handler } }
        return
    end
    listeners[eventName] = handler
end

---@param eventName string
function EventEmiter:emit(eventName, ...)
    local listeners = self.events[eventName]
    if not listeners then
        return
    end
    for _, listener in pairs(listeners) do
        listener(...)
    end
end
