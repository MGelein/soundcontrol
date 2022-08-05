local ez = {}
ez.list = {}
ez.toRem = {}
ez.elasticConst = (math.pi * 2) / 3
ez.elasticConst2 = (math.pi * 2) / 4.5
ez.shape = 'Cubic'

function ez.easeLinear(object, tweens, props)
    return ez.ease(object, tweens, props, 'linear')
end

function ez.easeIn(object, tweens, props)
    return ez.ease(object, tweens, props, 'in')
end

function ez.easeOut(object, tweens, props)
    return ez.ease(object, tweens, props, 'out')
end

function ez.easeInOut(object, tweens, props)
    return ez.ease(object, tweens, props, 'inOut')
end

function ez.ease(object, tweenAbles, props, easeFn)
    easeFn = easeFn or 'linear'
    easeFn = '_' .. easeFn .. ez.shape
    props = props or {}

    local tweenTargets = {}
    for attribute, targetValue in pairs(tweenAbles) do
        local tween = {
            attr = attribute,
            start = object[attribute],
            target = targetValue,
            delta = targetValue - object[attribute]
        }
        table.insert(tweenTargets, tween)
    end

    local e = {
        obj = object,
        tweens = tweenTargets,
        fn = ez[easeFn],
        time = props.time or 1,
        delay = props.delay or 0,
        elapsed = 0,
        timeRatio = 0,
        valueRatio = 0,
        onCompletion = props.complete,
        onUpdate = props.update,

        remove = ez._remove,
        complete = ez._complete,
        update = ez._update,
    }
    return ez._add(e)
end

function ez.update(dt)
    for i, e in ipairs(ez.list) do
        e.delay = e.delay - dt
        if e.delay <= 0 then
            e.elapsed = e.elapsed + dt
            e.timeRatio = e.elapsed / e.time
            e.valueRatio = e.fn(e.timeRatio)
            if e.onUpdate then e.onUpdate(e.valueRatio) end
            if e.elapsed >= e.time then 
                e.valueRatio = 1
                if e.onCompletion then e.onCompletion() end
                e:remove() 
            end
            for i, tween in ipairs(e.tweens) do
                e.obj[tween.attr] = tween.start + e.valueRatio * tween.delta
            end
        end
    end

    if #ez.toRem > 0 then
        for i, obj in ipairs(ez.toRem) do
            local foundIndex = -1
            for j, object in ipairs(ez.list) do
                if object == obj then 
                    foundIndex = j
                    break
                end
            end
            if foundIndex > -1 then table.remove(ez.list, foundIndex) end
        end
        ez.toRem = {}
    end
end

function ez.setShape(shape)
    shape = shape or 'cubic'
    shape = shape:lower()
    ez.shape = shape:sub(1, 1):upper() .. shape:sub(2)
end

function ez._complete(self, fn)
    self.onCompletion = fn
    return self
end

function ez._update(self, fn)
    self.onUpdate = fn
    return self
end

function ez._remove(self)
    table.insert(ez.toRem, self)
    return self
end

function ez._add(self)
    table.insert(ez.list, self)
    return self
end

function ez._linearCubic(timeRatio)
    return timeRatio
end
ez._linearElastic = ez._linearCubic
ez._linearSine = ez._linearCubic

function ez._inOutCubic(t)
    if t < 0.5 then return 4 * t * t * t
    else return 1 - math.pow(-2 * t + 2, 3) / 2 end
end

function ez._inOutSine(t)
    return -(math.cos(math.pi * t) - 1) / 2;
end

function ez._inOutElastic(t)
    if t == 0 then return 0
    elseif t == 1 then return 1
    elseif t <= 0.5 then return -(math.pow(2, 20 * t - 10) * math.sin((20 * t - 11.125) * ez.elasticConst2)) / 2
    else return (math.pow(2, -20 * t + 10) * math.sin((20 * t - 11.125) * ez.elasticConst2)) / 2 + 1 end
end

function ez._inCubic(t)
    return t * t * t
end

function ez._inSine(t)
    return 1 - math.cos((t * math.pi) / 2)
end

function ez._inElastic(t)
    if t == 0 then return 0
    elseif t == 1 then return 1
    else return -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * ez.elasticConst); end
end

function ez._outCubic(t)
    local invTime = 1 - t
    return 1 - invTime * invTime * invTime
end

function ez._outSine(t)
    return math.sin((t * math.pi) / 2)
end

function ez._outElastic(t)
    if t == 0 then return 0
    elseif t == 1 then return 1
    else return math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * ez.elasticConst) + 1 end
end

return ez