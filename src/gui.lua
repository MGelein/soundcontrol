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

    love.graphics.setFont(smallerFont)
    love.graphics.print('copyright 2021, Mees Gelein', 220, buttons.padding * 2 + 5)
end