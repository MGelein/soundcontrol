function love.conf(t)
    t.window.width = 1280
    t.window.height = 720
    t.window.resizable = true
    t.window.minwidth = 640
    t.window.minheight = 480
    t.window.borderless = false
    t.window.icon = 'data/icon.png'
    t.window.title = 'SoundControl v.3'

    t.modules.joystick = false
    t.modules.physics = false
    t.modules.thread = false
    t.modules.touch = false
    t.modules.video = false
end