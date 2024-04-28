
---@type (integer | false)[]
local aviableIDs = {}

local ID_list = ID_list
for i = 1, #ID_list do
	aviableIDs[i] = ID_list[i][1]
end

local lastAviable = #aviableIDs

function getFreeModelId( )
	if lastAviable ~= 0 then
		---@type integer
		local id = aviableIDs[lastAviable]
		aviableIDs[lastAviable] = false
		lastAviable = lastAviable - 1
		return id
	end
	error("No avialable model ID")
end

---@param id integer
function lockId( id )
	local i = table.find( aviableIDs, id )
	if i then
		aviableIDs[i] = aviableIDs[lastAviable]
		aviableIDs[lastAviable] = false
		lastAviable = lastAviable - 1
		return
	end
end

---@param id integer
function resetID( id )
	lastAviable = lastAviable + 1
	aviableIDs[lastAviable] = id
end