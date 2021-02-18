buttons = {}
buttons.list = {}
buttons.padding = 10
buttons.spacing = 60
buttons.width = 100
buttons.height = buttons.spacing - buttons.padding

function buttons.create()
    for i, sound in ipairs(sounds.list) do
        buttons.new(sound, i)
    end
end

function buttons.new(soundObject, index)
    local button = {
        i = index,
        x = ((index + 1) % 2) * buttons.width,
        y = (index - 1) * buttons.spacing,
        sound = soundObject,
        hover = false,
    }
    if button.x > 0 then button.y = button.y - buttons.spacing end
    table.insert(buttons.list, button)
end

function buttons.draw()
    buttons.width = (love.graphics.getWidth() - buttons.padding * 3) / 2

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
        button.x = ((button.i + 1) % 2) * buttons.width + ((button.i + 1) % 2) * buttons.padding
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
    local alpha = buttons.getAlpha(button)
    love.graphics.setLineWidth(buttons.getLineWidth(button))
    love.graphics.setColor(color.r / 3, color.g / 3, color.b / 3, alpha / 3)
    love.graphics.rectangle('fill', 0, 0, buttons.width, buttons.height)
    love.graphics.setColor(color.r, color.g, color.b, alpha)
    love.graphics.rectangle('line', 0, 0, buttons.width, buttons.height)

    love.graphics.print(button.sound.file, buttons.padding, buttons.height * 0.2)
    love.graphics.printf(button.sound.state, 0, buttons.height * 0.2, buttons.width - buttons.padding, 'right')
    love.graphics.pop()
end

function buttons.getLineWidth(button)
    if button.hover then return 3
    else return 2 end
end

function buttons.getAlpha(button)
    if button.hover then return 1
    elseif button.state == 'playing' then return 0.9
    else return 0.6 end
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