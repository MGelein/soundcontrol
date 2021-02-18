sounds = {}
sounds.list = {}

function sounds.prepareFiles()
    local files = loader.getMusicFiles()
    for i, f in ipairs(files) do
        local sound = {
            file = f,
            source = sounds.getSource(f),
            volume = 0
        }
        sound.source:setVolume(0)
        table.insert(sounds.list, sound)
    end
end

function sounds.getSource(file)
    return love.audio.newSource(loader.dir .. '/' .. file, 'stream')
end

function sounds.update()
    for i, sound in ipairs(sounds.list) do
        local currentVolume = sound.source:getVolume()
        local newVolume = currentVolume + (sound.volume - currentVolume) * 0.1
        if newVolume < 0.01 then 
            newVolume = 0
            if sound.source:isPlaying then sound.source:stop() end
        elseif newVolume > 0.99 then
            newVolume = 1
        else
            if not sound.source:isPlaying() then sound.source:play() end
        end
        sound.source:setVolume(newVolume)
        print(sound.file, currentVolume)
    end
end

function sounds.get(file)
    for i, sound in ipairs(sounds.list) do
        if file == sound.file then return sound end
    end
    return nil
end