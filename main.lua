require("math")

require("collisions")
require("obstacle")
require("player")


function love.load()
   player = Player()
   obstacles = {}
   for obstacleNumber = 1, 5 do
      local initPosition = {math.random(), math.random()}
      local initVelocity = {math.random() * 2 - 1, math.random() * 2 - 1}
      table.insert(obstacles, Obstacle(initPosition, initVelocity))
   end

   -- Along horizontal axis
   --table.insert(obstacles, Obstacle({0.1, 0.5}, {0.1, 0}))
   --table.insert(obstacles, Obstacle({0.9, 0.5}, {-0.1, 0}))

   -- Along vertical axis
   --table.insert(obstacles, Obstacle({0.5, 0.1}, {0, 0.1}))
   --table.insert(obstacles, Obstacle({0.5, 0.9}, {0, -0.1}))

   -- Along negative diagonal
   --table.insert(obstacles, Obstacle({0.1, 0.1}, {0.1, 0.1}))
   --table.insert(obstacles, Obstacle({0.9, 0.9}, {-0.1, -0.1}))

   -- Catchup (1d, positive diagonal)
   --table.insert(obstacles, Obstacle({0.9, 0.1}, {-0.1, 0.1}))
   --table.insert(obstacles, Obstacle({0.5, 0.5}, {0.0, 0.0}))

   -- Cross-bounce
   --table.insert(obstacles, Obstacle({0.1, 0.1}, {0.1, 0.1}))
   --table.insert(obstacles, Obstacle({0.9, 0.1}, {-0.1, 0.1}))

   -- Weird Y-shape
   --table.insert(obstacles, Obstacle({0.5, 0.9}, {0.0, -0.1}))
   --table.insert(obstacles, Obstacle({0.9, 0.1}, {-0.1, 0.1}))

   -- Slice
   --table.insert(obstacles, Obstacle({0.7, 0.9}, {-0.04, -0.1}))
   --table.insert(obstacles, Obstacle({0.3, 0.1}, {0.04, 0.1}))

end

function love.draw()
   -- Draw domain.
   love.graphics.setColor(255, 255, 255)
   love.graphics.rectangle("fill", 0, 0, domainSize, domainSize)

   player:draw(domainSize)
   for _, obstacle in pairs(obstacles) do
      obstacle:draw(domainSize)
   end
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

   -- Detect translator collisions, and update those translators accordingly.
   update_collisions(player, obstacles, dt)

   -- Update player
   player:update(dt)

   -- Update obstacles that have not been updated by collision detection.
   for _, obstacle in pairs(obstacles) do
      if not obstacle.updated then
         obstacle:update(dt)
      else
         obstacle.updated = false
      end
   end
end
