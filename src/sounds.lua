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
            volume = 0
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
        otherSound.volume = 0
    end
    if sound.volume == 0 then sound.volume = 1
    else sound.volume = 0 end
end