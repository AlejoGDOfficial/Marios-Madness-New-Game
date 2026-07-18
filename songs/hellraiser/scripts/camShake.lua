function onNoteHit()
    if getProperty('nextNoteToHitCharacter.type') == 'opponent' then
        cameraShake('camGame', 0.1, 0.004)
    end
end
