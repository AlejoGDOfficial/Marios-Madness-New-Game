
function onCreate()
    local hud = getProperty('stage.config.hud')
    local hudFile = 'NewGameHUD'
    if hud == 'hummer' then hudFile = 'hummerHud'
    end
    callMethod('loadScript', {'scripts/songs/huds/'..hudFile})
end