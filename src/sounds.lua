sounds = {}
sounds.list = {}
sounds.fadeDuration = 2 -- 2 seconds
sounds.fadeAmount = 1 / sounds.fadeDuration

function sounds.prepareFiles()
    local files = loader.getMusicFiles()
    for i, f in ipairs(files) do
        local sound = {
            file = f,
            source = sounds.getSource(f),
            volume = 0,
            state = 'loading'
        }
        sound.source:setVolume(0)
        sound.source:setLooping(true)
        table.insert(sounds.list, sound)
    end
end

function sounds.getSource(file)
    return love.audio.newSource(loader.dir .. '/' .. file, 'stream')
end

function sounds.update(dt)
    for i, sound in ipairs(sounds.list) do
        local currentVolume = sound.source:getVolume()
        local volumeDir = 1
        if currentVolume > sound.volume then volumeDir = -1
        elseif currentVolume == sound.volume then volumeDir = 0 end

        local newVolume = currentVolume + (volumeDir * sounds.fadeAmount) * dt
        if newVolume < 0.0001 then 
            newVolume = 0
            if sound.source:isPlaying() then sound.source:stop() end
        elseif newVolume > 0.999 then
            newVolume = 1
        else
            if not sound.source:isPlaying() then sound.source:play() end
        end
        sound.source:setVolume(newVolume)

        if volumeDir == 1 then
            sound.state = 'fade in'
        elseif volumeDir == -1 then
            sound.state = 'fade out'
        else
            if sound.source:isPlaying() then sound.state = 'playing'
            else sound.state = 'stopped' end
        end
    end
end

function sounds.get(file)
    for i, sound in ipairs(sounds.list) do
        if file == sound.file then return sound end
    end
    return nil
end

function sounds.toggle(sound)
    for i, otherSound in ipairs(sounds.list) do
        if sound ~= otherSound then otherSound.volume = 0 end
    end
    if sound.volume == 0 then sound.volume = 1
    else sound.volume = 0 end
end