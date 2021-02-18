require "src.loader"
require "src.sounds"
require "src.buttons"

function love.load()
    sounds.prepareFiles()
    buttons.create()
    love.graphics.setNewFont(20)
end

function love.draw()
    buttons.draw()
end

function love.update(dt)
    sounds.update(dt)
    buttons.update()
end