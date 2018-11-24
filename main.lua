require("math")
playerLib = require("player")

function love.load()
   player = Player:create()
end

function love.draw()
   -- Draw domain.
   love.graphics.setColor(255, 255, 255)
   love.graphics.rectangle("fill", 0, 0, domainSize, domainSize)

   player:draw(domainSize)
end

function love.update(dt)
   -- Handle window resizing, maintaining equal aspect ratio of movement
   -- domain.
   domainSize = math.min(love.graphics.getDimensions())

   -- Process held keys
   local accelerate = 0
   if love.keyboard.isDown("up") then
      accelerate = 1
   end
   if love.keyboard.isDown("down") then
      accelerate = accelerate - 1
   end

   local rotate = 0
   if love.keyboard.isDown("right") then
      rotate = 1
   end
   if love.keyboard.isDown("left") then
      rotate = rotate - 1
   end

   player:accelerate(accelerate)
   player:rotate(rotate)

   -- Update player
   player:update(dt)
end
