
---@class IWithDestructor
---@field destroy fun(self: self)

---@param object IWithDestructor
function safeDestroy(object)
    if object then
        object:destroy()
    end
end

---@generic T : table
---@param t T
---@param recursive? boolean
---@return T
function table.copy( t, recursive )
	if type( t ) ~= 'table' then
		error( 'Bad argument #1, got ' .. type( t ), 2 )
	end
	local new = {}
	for key, value in pairs( t ) do
		if type( value ) ~= 'table' or not recursive then
			new[key] = value;
		else
			new[key] = table.copy( value, recursive )
		end
	end
	return new
end

---@generic V
---@param t V[]
---@return V[]
function table.copyArray(t)
	local new = {}
	for i = 1, #t do
		new[i] = t[i]
	end
	return new
end

---@generic V
---@param first V[]
---@param ... V[]
---@return V[]
function table.uniteArrays(first, ...)
	local args = {...}
	local new = table.copyArray(first)
	for tIndex = 1, #args do
		local offset = #new
		local t = args[tIndex]
		for i = 1, #t do
			new[offset + i] = t[i]
		end
	end
	return new
end

---@generic K
---@generic V
---@param t table<K, V>
---@param value V
---@return K | false
function table.removeValue( t, value )
	if type( t ) ~= 'table' then
		error( 'Bad argument #1, got ' .. type( t ), 2 )
	end
	for i, _value in pairs( t ) do
		if _value == value then
			table.remove( t, i )
			return i
		end
	end
	return false
end

---@generic K
---@generic V
---@param t table<K, V>
---@param value V
---@return K
function table.find( t, value )
	if type( t ) ~= 'table' then
		error( 'Bad argument #1, got ' .. type( t ), 2 )
	end
	for i, _value in pairs( t ) do
		if _value == value then
			return i
		end
	end
	return false
end

---@generic K
---@generic V
---@param t table<K, V>
---@param In any
---@param value any
---@return K | false, V | nil
function table.findIn( t, In, value )
	if type( t ) ~= 'table' then
		error( 'Bad argument #1, got ' .. type( t ), 2 )
	end
	if In == nil then
		error( 'Bad argument #2, got nil', 2 )
	end
	for i, data in pairs( t ) do
		if data[In] == value then
			return i, data
		end
	end
	return false
end