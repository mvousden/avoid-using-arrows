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

function Translator:initialise(position, velocity)
   -- Instantiates translator properties. Arguments:
   --  - position: Initial position of translator, in "fractions of domain".
   --  - velocity: Initial velocity of translator, in "fractions of domain" per
   --    second.
   -- Returns nothing.
   self.position = position
   self.velocity = velocity
   self.maxSpeed = 0.5  -- Velocity magnitude limit, above which normalisation
                        -- occurs.
   self.radius = 0.02
end

function Translator:compute_speed()
   -- Returns the speed of the translator, in "fractions of domain" per second.
   return math.sqrt(math.pow(self.velocity[1], 2) +
                    math.pow(self.velocity[2], 2))
end

function Translator:truncate_velocity(maximise)
   -- Truncates the velocity of the translator to its maximum, if
   -- excessive. Arguments:
   --  - maximise: If true, sets the velocity vector such that speed=1
   --    regardless of the current speed.
   -- Returns nothing.
   local speed = self:compute_speed()
   if speed > self.maxSpeed or maximise then
      local normalisation = self.maxSpeed / speed
      for index = 1, 2 do
         self.velocity[index] = self.velocity[index] * normalisation
      end
   end
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
         self.position[index] = 1 - self.radius
         self.velocity[index] = -self.velocity[index]
      elseif self.position[index] < self.radius then
         self.position[index] = self.radius
         self.velocity[index] = -self.velocity[index]
      end
   end
end
