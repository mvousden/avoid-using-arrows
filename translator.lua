-- Defines a circular actor that can translate across the domain, and can
-- bounce off walls.

require("math")

Translator = {}
Translator.__index = Translator

setmetatable(Translator, {
                __call = function (cls, ...)
                   local self = setmetatable({}, cls)
                   self:initialise(...)
                   return self
                end,})

function Translator:initialise(position, velocity, radius)
   -- Instantiates translator properties. Arguments:
   --  - position: Initial position of translator, in "fractions of domain".
   --  - velocity: Initial velocity of translator, in "fractions of domain" per
   --    second.
   --  - radius: Radius of circular bounding box, in "fractions of domain".
   -- Returns nothing.
   self.position = position
   self.velocity = velocity
   self.maxSpeed = 0.5  -- Velocity magnitude limit, above which normalisation
                        -- occurs.
   self.radius = 0.02
end

function Translator:update(dt)
   -- Updates the translator instance, just the position vector for
   -- now. Returns nothing.
   for index = 1, 2 do
      self.position[index] = self.position[index] + self.velocity[index] * dt
   end

   -- Bounds check: reflect velocity if out of bounds, and move translator back
   -- into bounds.
   for index = 1, 2 do
      if self.position[index] > 1 - self.radius then
         self.position[index] = 2 - self.radius * 2 - self.position[index]
         self.velocity[index] = -self.velocity[index]
      elseif self.position[index] < self.radius then
         self.position[index] = self.position[index] + self.radius
         self.velocity[index] = -self.velocity[index]
      end
   end
end
