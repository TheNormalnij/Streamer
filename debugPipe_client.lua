
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
			dxDrawText( hitElement:getModel(), 100, 300, 200, 320 )
			dxDrawText( tostring( hitElement:getData( 'def' ) ), 100, 320, 200, 340 )
			dxDrawText( tostring( hitElement:getData( 'previd' ) ), 100, 340, 200, 360 )
			dxDrawText( tostring( hitElement:getPosition( ) ), 100, 360, 200, 360 )
			dxDrawText( tostring( hitElement:getRotation( ) ), 100, 380, 200, 360 )
		else
			dxDrawText( wolrdModelID, 100, 300, 200, 320 )
			if wmz then
				dxDrawText( wmx .. ' ' ..  wmy .. ' ' .. wmz, 100, 320, 200, 340 )
				dxDrawText( wmrx .. ' ' ..  wmry .. ' ' .. wmrz, 100, 340, 200, 360 )
			end
			if wmlod then
				dxDrawText( wmlod, 100, 360, 200, 360 )
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

bindKey( 'z', 'down', startActionHandling )
bindKey( 'z', 'up', stopActionHandling )
bindKey( 'delete', 'down', deleteElement )


addCommandHandler( 'loadworld', function( cmd, ... )
	local worldName = table.concat( { ... }, ' ' )
	triggerEvent( 'World:requestLoad', localPlayer, worldName, 0 )
	localPlayer:setDimension( 0 )
end  )

addCommandHandler( 'loadworldeditor', function( cmd, ... )
	local worldName = table.concat( { ... }, ' ' )
	triggerEvent( 'World:requestLoad', localPlayer, worldName, 200 )
end )
