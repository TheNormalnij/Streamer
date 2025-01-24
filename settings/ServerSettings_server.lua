
---@alias setting  "default_world"

---@class ServerSettings : Class
---@field private settings table<setting, any>
---@field private rootElement Element
ServerSettings = class()

function ServerSettings:create()
    self.rootElement = Element("StreamerSettingsRoot", "StreamerSettingsRoot")

    local this = self
    self:syncWithRegistry()

    addEventHandler("onSettingChange", root, function (setting, _, newValue)
        local _, to = setting:find("^%*Streamer")
        if not to then
            return
        end
        this:set(setting:sub(11, -1), fromJSON(newValue))
    end)
end

function ServerSettings:destroy()
    self.rootElement:destroy()
end

---@private
---@param param setting
function ServerSettings:getFromRegistry(param)
    return get(param) or SETTINGS_DEFAULT[param]
end

---@private
function ServerSettings:syncWithRegistry()
    for param in pairs(SETTINGS_DEFAULT) do
        self:set(param, self:getFromRegistry(param))
    end
end

---@private
---@param param setting
---@param value any
function ServerSettings:set(param, value)
    self.rootElement:setData(param, value, "broadcast", "deny")
end
