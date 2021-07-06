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

function Obstacle:initialise(position, velocity)
   -- Initialise position and velocity.
   Translator.initialise(self, position, velocity)

   -- Instantiate obstacle properties. Returns nothing.
   self.maxSpeed = self.maxSpeed / 2
   self.radius = self.radius * 2

   -- Don't exceed maximum velocity to start with
   Translator.truncate_velocity(self)

   -- A flag to denote whether this obstacle has been updated based off a
   -- collision in this iteration.
   self.updated = false
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
