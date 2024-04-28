
---@class ILoader : Class
---@field destroy fun(this: self): nil
---@field load fun(this: self): boolean
---@field unload fun(this: self): boolean

--- Return loader class
---@param loaderType "SA" | "IMGStream"
---@return ILoader | nil
function getLoaderClass( loaderType )
    if loaderType == "SA" then
        return SanAndreasWorldLoader
    elseif loaderType == "IMGStream" then
        return StaticIMGLoader
    end
end