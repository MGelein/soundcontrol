local http = require "socket.http"
remote = {}
remote.countdown = 0
remote.time = 2
remote.isMaster = true
remote.currentFile = ''

function remote.getRole()
    if remote.isMaster then return "server"
    else return "client" end
end

function remote.update(dt)
    if remote.isMaster then return end

    remote.countdown = remote.countdown - dt
    if remote.countdown < 0 then
        remote.countdown = remote.time
        filename = http.request('http://interwing.nl/soundcontrol/song.txt')
        if filename then remote.setFile(filename) end
    end
end

function remote.setTrack(file)
    http.request('http://interwing.nl/soundcontrol/song.php?song=' .. file)
end

function remote.setFile(file)
    if remote.currentFile ~= file then
        remote.currentFile = file
        if remote.isMaster then remote.setTrack(file) end
        local sound = sounds.get(remote.currentFile)
        sounds.setVolume(sound)
    end
end