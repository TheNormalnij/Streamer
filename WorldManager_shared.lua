addEvent( 'World:onRegister' )

---@class WorldManager : Class
WorldManager = class()

function WorldManager:create()
	---@private
	---@type World[]
	self.pool = {}
end

function WorldManager:destroy()
	for i = #self.pool, 1, -1 do
		self.pool[i]:destroy()
		self.pool[i] = nil
	end
end

---@param name string
---@return World | false
function WorldManager:getFromName( name )
	local _, world = table.findIn( self.pool, 'name', name )
	if world then
		return world
	end
	return false
end

---@param data IWorldData
---@return World
function WorldManager:register( data )
	local sourceResource = sourceResource or resource
	local resourceRoot = sourceResourceRoot or resourceRoot

	local pathPreffix = ':' .. sourceResource:getName() .. '/'
	if type( data.mapPath ) == 'table' then
		for key, value in pairs( data.mapPath ) do
			data.mapPath[key] = pathPreffix .. value
		end
	else
		data.mapPath = pathPreffix .. data.mapPath
	end

	if data.imgs then
		for i = 1, #data.imgs do
			data.imgs[i] = pathPreffix .. data.imgs[i]
		end
	end

	data.resource = sourceResource
	data.resourceRoot = resourceRoot

	local world = World( data )
	self:addWorld( world )

	return world
end

---@param pWorld World
function WorldManager:addWorld( pWorld )
	table.insert( self.pool, pWorld )

	if pWorld.resourceRoot then
		addEventHandler( 'onElementDestroy', pWorld.resourceRoot, function()
			self:removeWorld( pWorld )
			pWorld:destroy()
		end )
	end

	triggerEvent( 'World:onRegister', pWorld.resourceRoot or resourceRoot, pWorld )
end

---@param pWorld World
function WorldManager:removeWorld( pWorld )
	table.removeValue( self.pool, pWorld )
end

function WorldManager:getWorlds()
	return self.pool
end

---@return IWorldData[]
function WorldManager:getWorldsInfo()
	local o = {}
	local pool = self.pool
	for i = 1, #pool do
		o[i] = table.copy( pool[i] )
		o[i].__parent = nil
	end
	return o
end
