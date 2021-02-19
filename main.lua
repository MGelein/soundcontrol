require "src.loader"
require "src.sounds"
require "src.buttons"
require "src.remote"

function love.load()
    color = {r = 0.4, g = 0.8, b = 1}
    sounds.prepareFiles()
    buttons.create()

    mainFont = love.graphics.newFont(20)
    smallFont = love.graphics.newFont(16)
end

function love.draw()
    buttons.draw()
end

function love.update(dt)
    sounds.update(dt)
    remote.update(dt)
    buttons.update()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        buttons.click(x, y)
    end
end