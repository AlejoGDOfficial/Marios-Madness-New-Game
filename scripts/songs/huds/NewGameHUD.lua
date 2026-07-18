charNames = {
    ['dad'] = 'Daddy Dearest',
    ['horrorm'] = 'Horror Mario',
    ['somari'] = 'Somari',
    ['bf'] = 'Boyfriend',
    ['gfplayable'] = 'Girlfriend'
}
last = {['bf'] = 'boyfriend', ['dad'] = 'dad'}
lastColor = {}
dadWidth, bfWidth = nil, nil

function onCreate()
    import('flixel.util.FlxStringUtil')
end

function postCreate()
    setProperty('healthBar.exists', false)
    setProperty('scoreTxt.exists', false)
    hudText('timeTxt', '10:00', 0, 660, {size = 35, color = '0xFF000000', alignment = 'center', alpha = getProperty('skipCountdown') and 1 or 0}, 35)
    hudText('rankTxt', 'Rank: N/A', -150, 640, {size = 20, color = '0xFF000000', alignment = 'center', angle = downscroll and 12 or 10}, 65)
    hudText('accTxt', 'Accuracy: 0%', -300, 613, {size = 20, color = '0xFF000000', alignment = 'center', angle = downscroll and 12 or 10}, 98)
    hudText('missesTxt', 'Misses: 0', 300, 613, {size = 20, color = '0xFF000000', alignment = 'center', angle = -(downscroll and 12 or 10)}, 98)
    hudText('scorTxt', 'Score: 0', 150, 640, {size = 20, color = '0xFF000000', alignment = 'center', angle = -(downscroll and 12 or 10)}, 65)
    hudText('dadName', '', 33, 710, {size = 30, angle = 5}, -15)
    hudText('bfName', '', -40, 710, {size = 30, angle = -5, alignment = 'right'}, -15)
    hudSprite('barRight', 'newHud/halfGUI', screenWidth/2, 0, {flipX =  true})
    hudSprite('barLeft', 'newHud/halfGUI', 0, 0)
    hudSprite('dadFill', 'newHud/healthbarFill', 35, 575.5, {scale = {x = 1.07, y = 1.03}}, 16.5)
    hudSprite('bfFill', 'newHud/healthbarFill', screenWidth - 35, 574, {flipX = true, scale = {x = 1.05, y = 1.03}}, 17.5)
    setProperty('bfFill.x', getProperty('bfFill.x') - getProperty('bfFill.width'))
    hudSprite('black1Fill', 'newHud/healthbarFill', getProperty('dadFill.x'), getProperty('dadFill.y'), {scale = {x = 1.07, y = 1.04}, color = '000000'})
    hudSprite('black2Fill', 'newHud/healthbarFill', getProperty('bfFill.x'), getProperty('bfFill.y')-1, {flipX = true, scale = {x = 1.05, y = 1.065}, color = '000000'})
    dadWidth, bfWidth = getProperty('dadFill.width'), getProperty('bfFill.width')
    for i = 1,2 do
        for _, e in pairs({'updatePosition', 'updateScale', 'bop'}) do setProperty('iconP'..i..'.'..e, nil) end
        setProperties('iconP'..i, {scale = {x = 0.9, y = 0.9}, x = i == 1 and 1020 or 100, y = downscroll and 60 or 520, flipX = i == 1, angle = 7 * (i == 1 and -1 or 1)*(downscroll and -1 or 1)})
    end
    changeName('bf', 'boyfriend', 'id')
    changeName('dad', 'dad', 'id')
end

function postScoreTextUpdate()
    local rat = 'N/A'
    local acc = getProperty('accuracy')
    if acc >= 95 then rat = 'S+'
    elseif acc >= 90 then rat = 'S'
    elseif acc >= 85 then rat = 'A+'
    elseif acc >= 80 then rat = 'A'
    elseif acc >= 75 then rat = 'B'
    elseif acc >= 70 then rat = 'C'
    elseif acc >= 69 then rat = 'D'
    elseif acc >= 20 then rat = 'F'
    elseif getProperty('misses') > 0 or getProperty('score') ~= 0 then rat = 'Z' end
    setProperty('missesTxt.text', 'Misses: '..formatNum(getProperty('misses')))
    setProperty('scorTxt.text', 'Score: '..formatNum(getProperty('score')))
    setProperty('accTxt.text', 'Accuracy: '..formatNum(acc)..'%')
    setProperty('rankTxt.text', 'Rank: '..rat)
end
function formatNum(num) return FlxStringUtil.formatMoney(num, false) end
function onSongStart()
    if not getProperty('skipCountdown') then tween('timeTxtAlph', 'timeTxt', {alpha = 1}, 1) end
end
function postBeatHit() for i = 1,2 do setProperties('iconP'..i..'.scale', {x = 1.1, y = 1.1}) end end
function postUpdate()
    for i = 1,2 do
        setProperties('iconP'..i..'.scale', {x = fpsLerp(getProperty('iconP'..i..'.scale.x'), 0.9, 0.1), y = fpsLerp(getProperty('iconP'..i..'.scale.y'), 0.9, 0.1)})
        updateHitbox('iconP'..i)
    end
    setProperty('timeTxt.text', FlxStringUtil.formatTime((FlxG.sound.music.length - Conductor.songPosition)/1000))
    local hp = getProperty('health')
    setProperty('iconP2.angle', (hp > 1.6 and (-20 + getRandomInt(-4, 4)) or 0) + (7 * (downscroll and -1 or 1)))
    setProperty('iconP1.angle', (hp < 0.4 and (20 + getRandomInt(-4, 4)) or 0) + (7 * (downscroll and 1 or -1))) 
    local dd, bf = 1, 1
    if hp > 1 then dd = 1 - (hp - 1) end
    if hp < 1 then bf = hp end
    setProperty('dadFill._frame.frame.width', bound(dadWidth*dd, 0.01, dadWidth))
    setProperty('bfFill._frame.frame.width', bound(bfWidth*bf, 0.01, bfWidth))
    for i = 0, 3 do
        PlayState.instance.strumLines.members[1].strums.members[i].textureShader.enabled = true
        PlayState.instance.strumLines.members[2].strums.members[i].textureShader.enabled = true
    end
end

function bound(val, min, max)
    if val < min then return min
    elseif val > max then return max
    else return val end
end

function changeName(tag, text, type, color)
    local txt = text
    if type == 'id' then
        if charNames[getProperty(text..'.id')] ~= nil then txt = charNames[getProperty(text..'.id')] end
        last[tag] = text
    end
    local col = colorFromString(type == 'id' and getProperty(text..'.config.barColor') or (color and string.upper(color) or 'FFFFFF'))
    lastColor[tag] = col
    setProperties(tag..'Name', {text = txt, color = col})
    setProperty(tag..'Fill.color', getProperty(tag..'Name.color'))
    if (text == 'boyfriend' or text == 'dad') and type == 'id' then
        local num = text == 'dad' and 1 or 2
        editNoteColor(num, col)
    end
end

function editNoteColor(num, col)
    if col == nil then return end
    for i = 0, 3 do
        PlayState.instance.strumLines.members[num].strums.members[i].textureShader.r = col
        PlayState.instance.strumLines.members[num].strums.members[i].textureShader.g = col
        PlayState.instance.strumLines.members[num].strums.members[i].textureShader.b = col
        PlayState.instance.strumLines.members[num].paletteCache[i].r = col
        PlayState.instance.strumLines.members[num].paletteCache[i].g = col
        PlayState.instance.strumLines.members[num].paletteCache[i].b = col
    end
end

function hudSprite(tag, file, x, y, properties, ydown)
    ypos = y if downscroll and ydown ~= nil then ypos = ydown end
    makeLuaSprite(tag, file, x, ypos)
    callMethod('uiGroup.insert', {0, instanceArg(tag)})
    setObjectCameras(tag, {'camHUD'})
    if properties ~= nil then setProperties(tag, properties) end
    if downscroll then setProperty(tag..'.flipY', not getProperty(tag..'.flipY')) end
    updateHitbox(tag)
end

function hudText(tag, text, x, y, properties, ydown, fw)
    ypos = y if downscroll and ydown ~= nil then ypos = ydown end
    makeLuaText(tag, text, fw or screenWidth, x, ypos)
    setTextFont(tag, 'SuperMario256.ttf')
    if properties ~= nil then setProperties(tag, properties) end
    if downscroll then setProperty(tag..'.angle', - getProperty(tag..'.angle')) end
    callMethod('uiGroup.insert', {0, instanceArg(tag)})
    setObjectCameras(tag, {'camHUD'})
    updateHitbox(tag)
end