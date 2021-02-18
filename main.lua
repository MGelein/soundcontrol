require "src.loader"
require "src.sounds"

function love.load()
    sounds.prepareFiles()
end

function love.draw()

end

function love.update(dt)
    sounds.update(dt)
end