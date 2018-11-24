-- Defines an obstacle that translates across the domain.

require("translator")

Obstacle = {}
Obstacle.__index = Obstacle

setmetatable(Obstacle, {
                __index = Translator,
                __call = function (cls, ...)
                   local self = setmetatable({}, cls)
                   self:initialise(...)
                   return self
                end})

function Obstacle:initialise()
   -- Instantiate obstacle properties. Returns nothing.

   -- Initialise position and velocity.
   Translator.initialise(self, {0.2, 0.3}, {-1, -1})

   -- Maximise velocity
   Translator.truncate_velocity(self, true)
end

function Obstacle:draw(domainSize)
   -- Draws the obstacle using its position. Arguments:
   --  - domainSize: Size of the movement domain, to resolve relative
   --    co-ordinates.
   -- Returns nothing.

   -- It's just a circle.
   love.graphics.setColor(255, 0, 0)
   love.graphics.circle("fill",
                        self.position[1] * domainSize,
                        self.position[2] * domainSize,
                        self.radius * domainSize)
end

function Obstacle:update(dt)
   -- Updates the obstacle. Returns nothing.
   Translator.update(self, dt)
end
