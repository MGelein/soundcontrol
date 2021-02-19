gui = {}
gui.remote = {
    x = love.graphics.getWidth(),
    y = buttons.padding,
    w = 150,
    h = buttons.spacing - buttons.padding * 2,
    hover = false,
    alpha = 0
}

function gui.draw()
    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.setFont(titleFont)
    love.graphics.print('SoundControl v3', buttons.padding, buttons.padding * 1.5)
    love.graphics.setLineWidth(2)
    love.graphics.line(0, buttons.topBar, love.graphics.getWidth(), buttons.topBar)

    love.graphics.setColor(color.r, color.g, color.b, gui.remote.alpha)
    love.graphics.setLineWidth(gui.getRemoteLineWidth())
    love.graphics.rectangle('line', gui.remote.x, gui.remote.y, gui.remote.w, gui.remote.h)
    love.graphics.setFont(smallFont)
    love.graphics.print('Remote: ' .. remote.getRole(), gui.remote.x + buttons.padding, gui.remote.y + buttons.padding)
end

function gui.update(dt)
    gui.remote.x = love.graphics.getWidth() - gui.remote.w - buttons.padding
    gui.remote.alpha = gui.remote.alpha + (gui.getRemoteAlpha() - gui.remote.alpha) * dt

    local mouseX, mouseY = love.mouse.getPosition()
    gui.remote.hover = gui.isOverRemote(mouseX, mouseY)
end

function gui.getRemoteAlpha()
    if gui.remote.hover then return 1
    else return 0.6 end
end

function gui.isOverRemote(x, y)
    if x > gui.remote.x and x < gui.remote.x + gui.remote.w then
        if y > gui.remote.y and y < gui.remote.y + gui.remote.h then
            return true
        else return false end
    else return false end
end

function gui.getRemoteLineWidth()
    if gui.remote.hover then return 4
    else return 2 end
end

function gui.click(x, y)
    if gui.isOverRemote(x, y) then
        if remote.isMaster then remote.isMaster = false
        else remote.isMaster = true end
    end
end