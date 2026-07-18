-- Script made by Speg
camOfs, charPos = 30, {}
function onCreate()
    registerGlobalLuaFunction('centerCam')
    registerGlobalLuaFunction('snapCam')
    registerGlobalLuaFunction('doZoom')
end
function postUpdate()
	if not getProperty('shouldMoveCamera') then return end
	local anim = getProperty('cameraTarget.animation.name')
    callMethod('moveCamera', {instanceArg('cameraTarget')})
	charPos = callMethod('getCharacterCamera', {instanceArg('cameraTarget')})
	local ofs = camOfs/getProperty('camGame.zoom')
    setProperties('camGame.position', {x = charPos.x + ofs * (anim:find('LEFT') and -1 or anim:find('RIGHT') and 1 or 0), y = charPos.y + ofs * (anim:find('DOWN') and 1 or anim:find('UP') and -1 or 0)})
end
function getCenter(char1, char2)
    d, b = callMethod('getCharacterCamera', {instanceArg(char1 or 'dad')}), callMethod('getCharacterCamera', {instanceArg(char2 or 'boyfriend')})
    return {x = d.x + (b.x - d.x) / 2, y = d.y + (b.y - d.y) / 2}
end
function centerCam(center, zoom)
	setProperty('shouldMoveCamera', not center)
	if center then
        d, b = callMethod('getCharacterCamera', {instanceArg('dad')}), callMethod('getCharacterCamera', {instanceArg('boyfriend')})
        setProperties('camGame.position', {x = d.x + (b.x - d.x) / 2, y = d.y + (b.y - d.y) / 2})
	end
	if zoom ~= nil then doZoom(zoom) end
end
function snapCam(target, force, xPlus, yPlus, zoom)
	setProperty('shouldMoveCamera', true)
    callMethod('moveCamera', {instanceArg(target)})
	setProperties('camGame.position', {x = charPos.x + (xPlus or 0), y = charPos.y + (yPlus or 0)})
	callMethod('camGame.snapToTarget')
	if zoom ~= nil then doZoom(zoom, 0) end
	setProperty('shouldMoveCamera', not force)
end
function doZoom(zom, st, eas)
    setProperty('camGame.targetZoom', zom)
	if st == nil then return end
	if st > 0 then tween('camG', 'camGame', {zoom = zom}, getStep(st), {ease = eas})
	else setProperty('camGame.zoom', zom) end
end
function tweenCam(camX, camY, time, eas, restore)
    cancelTweensOf('camGame.position')
	setProperty('shouldMoveCamera', false)
    tween('camGameMove'..(restore and 'RES' or ''), 'camGame.position', {x = camX, y = camY}, time, {ease = eas})
end
function onTweenComplete(tag)
    if tag == 'camGameMoveRES' then
    	setProperty('shouldMoveCamera', true)
    end
end