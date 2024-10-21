
---@class EventEmmiter : Class
---@field private events table<string, function[]>
EventEmiter = class()

function EventEmiter:create()
    self.events = {}
end

function EventEmiter:on(eventName, handler)
    local listeners = self.events[eventName]
    if not listeners then
        listeners = { [eventName] = { handler } }
        return
    end
    listeners[eventName] = handler
end

function EventEmiter:emit(eventName, ...)
    local listeners = self.events[eventName]
    if not listeners then
        return
    end
    for _, listener in pairs(listeners) do
        listener()
    end
end
