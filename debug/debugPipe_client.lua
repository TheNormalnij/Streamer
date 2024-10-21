
local lastElement = nil

local function actionSearch()
	local camX, camY, camZ = getCameraMatrix()
	local rX, rY, wX, wY, wZ = getCursorPosition()

	local isHit, hitX, hitY, hitZ, hitElement,
	normalX, normalY, normalZ, material, lighting,
	piece, wolrdModelID, wmx, wmy, wmz, wmrx, wmry, wmrz, wmlod = processLineOfSight( camX, camY, camZ, wX, wY, wZ, 
		true, true, true, true, true, false, 
		false, false, localPlayer, true, true
	)

	if isHit then
		if hitElement then
			lastElement = hitElement
			dxDrawText( hitElement:getModel(), 100, 300, 200, 320 )
			dxDrawText( tostring( hitElement:getData( 'def' ) ), 100, 320, 200, 340 )
			dxDrawText( tostring( hitElement:getData( 'previd' ) ), 100, 340, 200, 360 )
			dxDrawText( tostring( hitElement:getPosition( ) ), 100, 360, 200, 380 )
			dxDrawText( tostring( hitElement:getRotation( ) ), 100, 380, 200, 400 )
		else
			dxDrawText( wolrdModelID, 100, 300, 200, 320 )
			if wmz then
				dxDrawText( wmx .. ' ' ..  wmy .. ' ' .. wmz, 100, 320, 200, 340 )
				dxDrawText( wmrx .. ' ' ..  wmry .. ' ' .. wmrz, 100, 340, 200, 360 )
			end
			if wmlod then
				dxDrawText( wmlod, 100, 360, 200, 380 )
			end
		end
	end

	return hitElement
end

local function startActionHandling()
	showCursor( true )
	addEventHandler( 'onClientRender', root, actionSearch )
end

local function stopActionHandling()
	showCursor( false )
	removeEventHandler( 'onClientRender', root, actionSearch )
end

local function deleteElement()
	local element = actionSearch()
	if element then
		element:destroy()
	end
end

local function tryRotate(key, state, rx, ry, rz)
	if isElement(lastElement) then
		lastElement:setRotation(lastElement:getRotation() + Vector3(rx, ry, rz) * 5)
	end
end

bindKey( 'b', 'down', startActionHandling )
bindKey( 'b', 'up', stopActionHandling )
bindKey( 'delete', 'down', deleteElement )


bindKey('num_1', 'down', tryRotate, -1, 0, 0)
bindKey('num_3', 'down', tryRotate, 1, 0, 0)
bindKey('num_4', 'down', tryRotate, 0, -1, 0)
bindKey('num_6', 'down', tryRotate, 0, 1, 0)
bindKey('num_7', 'down', tryRotate, 0, 0, -1)
bindKey('num_9', 'down', tryRotate, 0, 0, 1)


addCommandHandler( 'loadworld', function( cmd, ... )
	local worldName = table.concat( { ... }, ' ' )
	triggerEvent( 'World:requestLoad', localPlayer, worldName, 0 )
	localPlayer:setDimension( 0 )
end  )

addCommandHandler( 'loadworldeditor', function( cmd, ... )
	local worldName = table.concat( { ... }, ' ' )
	triggerEvent( 'World:requestLoad', localPlayer, worldName, 200 )
end )
