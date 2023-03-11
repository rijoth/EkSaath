local sounds = {}

-- load sounds
sounds.bgm = love.audio.newSource("assets/bgm.wav", 'stream')
sounds.nav = love.audio.newSource("assets/nav.wav", 'static')
sounds.select = love.audio.newSource("assets/select.wav", 'static')
sounds.jump = love.audio.newSource("assets/jump.wav", 'static')
sounds.walk = love.audio.newSource("assets/walk.wav", 'static')
sounds.teleport = love.audio.newSource("assets/teleport.wav", 'static')
sounds.dead = love.audio.newSource("assets/dead.wav", 'static')
sounds.off = love.audio.newSource("assets/off.wav", 'static')

-- set volume
sounds.bgm:setVolume(0.1)
sounds.bgm:setLooping(true)
sounds.jump:setVolume(0.5)
sounds.jump:setLooping(false)
sounds.walk:setVolume(0.4)
sounds.off:setVolume(0.5)

return sounds
