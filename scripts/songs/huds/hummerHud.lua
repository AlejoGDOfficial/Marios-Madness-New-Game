rings = 5
function postCreate()
    for e, i in pairs({'TIME', 'SCORE', 'RINGS'}) do hudSprite(string.lower(i)..'Hud', 'HUMMERUI/'..i, 50, (e * 50) - 30, {scale = {x = 0.5, y = 0.5}}) end
    for e, i in pairs({'num1', 'num2', 'mid', 'num3', 'num4'}) do hudSprite('time'..i..'Hud', 'HUMMERUI/'..(i == 'mid' and 'DOTS' or e), 60 + getProperty('timeHud.width') + ((e < 3 and (e-1) or e > 3 and (e-1.5) or 1.7) * 40), 20, {scale = {x = 0.5, y = 0.5}}) end
    for i = 1,6 do hudSprite('scoreNum'..i..'Hud', 'HUMMERUI/'..i, 60 + getProperty('scoreHud.width') + ((i-1) * 35), 70, {scale = {x = 0.5, y = 0.5}}) end
    for i = 1,2 do hudSprite('ringsNum'..i..'Hud', 'HUMMERUI/'..i, 60 + getProperty('ringsHud.width') + ((i-1) * 35), 120, {scale = {x = 0.5, y = 0.5}}) end
    for _, i in pairs({'healthBar', 'iconP1', 'iconP2', 'scoreTxt'}) do setProperty(i..'.exists', false) end
    editNoteColor(1, colorFromString(getProperty('dad.config.barColor')))
    editNoteColor(2, colorFromString(getProperty('boyfriend.config.barColor')))
    --for _, strl in ipairs(getProperty('CHART.strumLines')) do
        --strl.file =  'hummer'
    --end
end

function hudSprite(tag, file, x, y, properties)
    makeLuaSprite(tag, file, x, y)
    callMethod('uiGroup.insert', {0, instanceArg(tag)})
    setObjectCameras(tag, {'camHUD'})
    if properties ~= nil then setProperties(tag, properties) end
    updateHitbox(tag)
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

function postUpdate()
    for i = 0, 3 do
        --PlayState.instance.strumLines.members[1].strums.members[i].textureShader.enabled = true
        --PlayState.instance.strumLines.members[2].strums.members[i].textureShader.enabled = true
    end
    local time = math.floor((FlxG.sound.music.length - Conductor.songPosition)/1000)
    local mins = math.floor(time/60)
    local segs = time - (mins*60)
    local vals = {0, 0, 0, 0}
    if mins < 10 then vals[2] = mins
    else
        local minuto = stringSplit(mins, '')
        vals[1] = minuto[1]
        vals[2] = minuto[2]
    end
    if segs < 10 then vals[4] = segs
    else
        local segundo = stringSplit(segs, '')
        vals[3] = segundo[1]
        vals[4] = segundo[2]
    end
    for e, i in pairs({'timenum1Hud', 'timenum2Hud', 'timenum3Hud', 'timenum4Hud'}) do loadGraphic(i, 'HUMMERUI/'..vals[e]) end
    local anillos = {0, 0}
    if rings > 10 then rings = 10 end
    setProperty('health', 2 * (rings/10))
    if rings == 10 then anillos = stringSplit(rings, '')
    else anillos = {0, rings} end
    for i = 1,2 do loadGraphic('ringsNum'..i..'Hud', 'HUMMERUI/'..anillos[i]) end
end

function postScoreTextUpdate()
    local scor = getProperty('score')
    local sc = stringSplit(scor, '')
    local scr = {0,0,0,0,0,0}
    local dif = 6 - #sc
    for e, i in pairs(sc) do scr[dif + e] = i end
    for i = 1,6 do loadGraphic('scoreNum'..i..'Hud', 'HUMMERUI/'..scr[i]) end
end