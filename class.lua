
local rawget = rawget
local setmetatable = setmetatable

local class_mt = {}

function class_mt:inherit( newClass )
	newClass = newClass or {}
	newClass.__parent = self
	return setmetatable( newClass, class_mt )
end

function class_mt:__index( key )
	local get = rawget( self, key )
	if get == nil then
		return rawget( self, '__parent' )[key]
	else
		return get
	end
end

function class_mt:__call( ... )
	local child = setmetatable( {}, class_mt )
	child.__parent = self
	if child.create then
        child:create( ... )
	end
    return child
end

---@class Class
---@field protected __parent Class Base class
---@field private create fun(this: self): self
---@field inherit fun(this: table): self

---@generic T : Class
---@param newClass? T
---@return T
function class( newClass )
	newClass = newClass or {}
	newClass.__index = newClass
	newClass.__parent = class_mt
	return setmetatable( newClass, class_mt )
end
