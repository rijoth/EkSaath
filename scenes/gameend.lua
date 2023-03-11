local game_end = {}

function game_end:load()
  self.bg_image = love.graphics.newImage("assets/bg.png")
  self.image = love.graphics.newImage("assets/gameend.png")
  self.text = "Thank You !"
  self.text2 = "Press enter to return to main menu."
end

function game_end:draw()
  love.graphics.draw(self.bg_image, 0, 0, 0, _G.push:getWidth()/self.bg_image:getWidth(), _G.push:getHeight()/self.bg_image:getHeight())
  love.graphics.draw(self.image, 0, 0)
  love.graphics.print(self.text, _G.push:getWidth() - 385, _G.push:getHeight() - 215)
  love.graphics.print(self.text2, _G.push:getWidth() - 485, _G.push:getHeight() - 25)
end

function game_end:keypressed(key)
  if key == "return" or key == "x" then
    setScene("menu")
  end
end

return game_end
