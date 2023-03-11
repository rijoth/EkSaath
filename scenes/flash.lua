local flash = {}

function flash:load()
self.font = love.graphics.newImageFont("assets/font.png",
  " abcdefghijklmnopqrstuvwxyz" ..
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
  "123456789.,!?-+/():;%&`'*#=[]\"")
  love.graphics.setFont(self.font)
  --
  self.logo = {
    img = love.graphics.newImage("assets/EvolvedAntLogo.png"),
    text = "EvolvedAnt",
    x = _G.push:getWidth()/2 - 80 ,
    y = _G.push:getHeight()/2 - 80
  }
  --
  self.timer = {
    curr = 0,
    max = 10,
    speed = 5
  }
end

function flash:update(dt)
  self.timer.curr = self.timer.curr + self.timer.speed * dt
  if self.timer.curr > self.timer.max then
    setScene("menu")
  end
end

function flash:draw()
  love.graphics.draw(self.logo.img, self.logo.x, self.logo.y)
  love.graphics.print(self.logo.text, self.logo.x + 24, self.logo.y + self.logo.img:getHeight() + 16)
end

return flash
