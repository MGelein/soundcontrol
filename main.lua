require "src.loader"
require "src.sounds"
require "src.buttons"

function love.load()
    color = {r = 0.2, g = 1, b = 0.2}
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

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        buttons.click(x, y)
    end
end