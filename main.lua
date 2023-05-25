require "src.loader"
require "src.sounds"
require "src.buttons"
require "src.gui"
require "src.sliders"

function love.load()
    color = { r = 0.4, g = 0.8, b = 1 }
    sounds.prepareFiles()
    buttons.create()

    titleFont = love.graphics.newFont(24)
    mainFont = love.graphics.newFont(20)
    smallFont = love.graphics.newFont(16)
    smallerFont = love.graphics.newFont(12)
end

function love.draw()
    buttons.draw()
    sliders.draw()
    gui.draw()
end

function love.update(dt)
    sounds.update(dt)
    buttons.update()
    sliders.update()

    handleMaster()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        buttons.click(x, y)
        sliders.click(x, y)
    end
end

function handleMaster()
    local masterDown = love.keyboard.isDown("down")
    local masterUp = love.keyboard.isDown("up")
    local currentVolume = sliders.masterVolume.value
    local delta = 0
    if masterUp then delta = 0.2 end
    if masterDown then delta = -0.2 end
    if currentVolume > 20 then delta = delta * 3 end

    local max = sliders.masterVolume.max
    local min = sliders.masterVolume.min
    local newValue = currentVolume + delta
    if newValue > max then newValue = max end
    if newValue < min then newValue = min end
    sliders.masterVolume.value = newValue
    sounds.masterVolume = newValue / 100
end