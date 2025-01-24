
addEvent("World:onSettingChanged", true)
addEvent("World:onSettingSync", true)

---@class ClientSettins : EventEmmiter
---@field private settings table<setting, any>
ClientSettings = EventEmiter:inherit()

function ClientSettings:create()
    self.settings = {}
    self.rpc = getElementsByType("StreamerSettingsRoot", resourceRoot)[1]
    for key, value in pairs(SETTINGS_DEFAULT) do
        self.settings[key] = self.rpc:getData(key) or value
    end

    local this = self
    addEventHandler("onClientElementDataChange", self.rpc, function (dataName, old, new)
        this:set(dataName, new)
    end)
end

---@param key setting
---@param param any
function ClientSettings:set(key, param)
    self.settings[key] = param
    self:emit("changed", key, param)
end

---@param key setting
function ClientSettings:get(key)
    return self.settings[key]
end
