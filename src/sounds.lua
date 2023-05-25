sounds = {}
sounds.list = {}
sounds.fadeDuration = 2 -- 2 seconds
sounds.fadeAmount = 1 / sounds.fadeDuration
sounds.masterVolume = 1

function sounds.prepareFiles()
    local files = loader.getMusicFiles()
    for i, f in ipairs(files) do
        local sound = {
            file = f,
            source = nil,
            volume = 0,
            state = 'stopped'
        }
        table.insert(sounds.list, sound)
    end
end

function sounds.getSource(file)
    local source = love.audio.newSource(loader.dir .. '/' .. file, 'stream')
    source:setVolume(0)
    source:setLooping(true)
    return source
end

function sounds.update(dt)
    love.audio.setVolume(sounds.masterVolume)
    for i, sound in ipairs(sounds.list) do
        if sound.source then
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
end

function sounds.get(file)
    for i, sound in ipairs(sounds.list) do
        if file == sound.file then return sound end
    end
    return nil
end

function sounds.setVolume(sound, leaveOthers, volume)
    leaveOthers = leaveOthers and true or false

    if not leaveOthers then
        for i, otherSound in ipairs(sounds.list) do
            if sound ~= otherSound then otherSound.volume = 0 end
        end
    end

    if sound == nil then return end
    if sound.source == nil then sound.source = sounds.getSource(sound.file) end
    sound.volume = volume
end

function sounds.getNameWithoutExtension(sound)
    local file = sound.file
    for i, ext in ipairs(loader.acceptedFormats) do
        file = file:gsub(ext, '')
    end
    return file
end
