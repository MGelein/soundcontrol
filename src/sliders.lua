sliders = {}
sliders.list = {}

function sliders.new(x, y, w, h, value, min, max, title)
    local slider = {
        x = x,
        y = y,
        w = w,
        h = h,
        value = value,
        min = min,
        max = max,
        draw = sliders.drawSingle,
        alpha = 1,
        title = title,
        range = max - min
    }
    table.insert(sliders.list, slider)
    return slider
end

function sliders.click(x, y)
    for i, slider in ipairs(sliders.list) do
        if x > slider.x and x < (slider.x + slider.w) then
            if y > slider.y and y < (slider.y + slider.h) then
                sliders.singleClick(slider, (x - slider.x) / slider.w)
                break
            end
        end
    end
end

function sliders.singleClick(slider, ratio)
    slider.value = ratio * slider.range + slider.min
end

function sliders.update()
    for i, slider in ipairs(sliders.list) do
        local minDelta = slider.value - slider.min
        slider.ratio = minDelta / slider.range
    end
end

function sliders.draw()
    for i, slider in ipairs(sliders.list) do
        slider:draw()
    end
end

function sliders.drawSingle(self)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.setLineWidth(4)
    love.graphics.setColor(color.r / 3, color.g / 3, color.b / 3, self.alpha * 0.5)
    love.graphics.rectangle('fill', 0, 0, self.w * self.ratio, self.h)
    love.graphics.setColor(color.r, color.g, color.b, self.alpha)
    love.graphics.rectangle('line', 0, 0, self.w, self.h)

    love.graphics.setFont(mainFont)
    love.graphics.print(self.title .. math.floor(self.value), self.h / 2, self.h * 0.2)
    love.graphics.pop()
end

sliders.masterVolume = sliders.new(love.graphics.getWidth() - 300 - buttons.padding, 8, 300, gui.remote.h, 75, 0, 100, 'master: ')