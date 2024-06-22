
---@class IWorldData
---@field name string
---@field imgs string[]
---@field mapPath string
---@field mapType "lua"
---@field formatVersion number
---@field generic boolean
---@field dynamicMapPath string
---@field resource Element
---@field resourceRoot Element
---@field loader string | nil

---@class World : Class
World = class()

---@param data IWorldData
function World:create( data )
	self.name = data.name
	self.imgs = data.imgs
	self.mapPath = data.mapPath
	self.mapType = data.mapType
	self.formatVersion = data.formatVersion
	self.generic = data.generic
	self.dynamicMapPath = data.dynamicMapPath
	self.loader = data.loader

	self.resource = data.resource
	self.resourceRoot = data.resourceRoot
end

function World:destroy( )

end

function World:getDiskUsage( )
	local file
	local usage = 0

	if File.exists( self.mapPath ) then
		file = File.open( self.mapPath )
		if file then
			usage = usage + file:getSize()
			file:close()
		end
	end
	for i = 1, #self.imgs do
		if File.exists( self.imgs[i] ) then
			file = File.open( self.imgs[i] )
			if file then
				usage = usage + file:getSize()
				file:close()
			end
		end
	end

	return usage
end

function World:getIMGs( )
	return self.imgs or {}
end
