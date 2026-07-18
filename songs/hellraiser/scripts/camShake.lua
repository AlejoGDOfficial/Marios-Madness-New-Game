function onNoteHit()
    if getProperty('lastHitNoteCharacter.type') == 'opponent' then
        cameraShake('camGame', 0.1, 0.004)
    end
end