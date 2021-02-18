buttons = {}
buttons.list = {}
buttons.padding = 20
buttons.spacing = 80
buttons.width = 100

function buttons.create()
    for i, sound in ipairs(sounds.list) do
        buttons.new(sound, i)
    end
end

function buttons.new(soundObject, index)
    local button = {
        x = 0,
        y = (index - 1) * buttons.spacing,
        sound = soundObject,
        hover = false
    }
    table.insert(buttons.list, button)
end

function buttons.draw()
    buttons.width = love.graphics.getWidth() - buttons.padding * 2
    love.graphics.push()
    love.graphics.translate(buttons.padding, buttons.padding)
    for i, button in ipairs(buttons.list) do
        buttons.drawSingle(button)
    end
    love.graphics.pop()
end

function buttons.update()
    local mouseX, mouseY = love.mouse.getPosition()
    for i, button in ipairs(buttons.list) do
        if buttons.isOverButton(button, mouseX, mouseY) then
            button.hover = true	
        else
            button.hover = false
        end
    end
end

function buttons.drawSingle(button)
    love.graphics.push()
    love.graphics.translate(button.x, button.y)
    love.graphics.rectangle('line', 0, 0, buttons.width, buttons.spacing - buttons.padding)
    love.graphics.pop()
end

function buttons.isOverButton(button, x, y)
    x = x - buttons.padding
    y = y - buttons.padding
    if x > button.x and x < button.x + buttons.width then
        if y > button.y and y < button.y + (buttons.spacing - buttons.padding) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function buttons.click(x, y)
    for i, button in ipairs(buttons.list) do
        if buttons.isOverButton(button, x, y) then
            sounds.toggle(button.sound)
        end
    end
end