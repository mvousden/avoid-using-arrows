-- Defines a player character that can move around the domain. The player is a
-- tank-like sliding entity.

require("math")
require("translator")

Player = {}
Player.__index = Player

setmetatable(Player, {
                __index = Translator,
                __call = function (cls, ...)
                   local self = setmetatable({}, cls)
                   self:initialise(...)
                   return self
                end})

function Player:initialise()
   -- Instantiate player properties. Quantities are normalised with respect to
   -- the size of the domain. Returns nothing.

   -- Initialise position and velocity.
   Translator:initialise({0.5, 0.5}, {0, 0})

   -- Translation control properties:
   self.accelerating = 0  -- 0 if not accelerating, 1 if accelerating, -1 if
                          -- deccelerating.
   self.maxAcceleration = 1

   -- Rotation properties:
   self.rotating = 0  -- 0 if not rotating, 1 if rotating clockwise, -1 if
                      -- rotating anticlockwise.
   self.angle = math.pi / 2  -- Starts facing "up", in radians.
   self.maxRotationSpeed = math.pi * 2  -- In radians per second.

   -- For drawing the little red ball for the "facing" direction.
   self.headRadius = self.radius / 3
end

function Player:draw(domainSize)
   -- Draws the player character using its position and angle. Arguments:
   --  - domainSize: Size of the movement domain, to resolve relative
   --    co-ordinates.
   -- Returns nothing.

   -- Draw body.
   love.graphics.setColor(0, 0, 0)
   love.graphics.circle("fill",
                        self.position[1] * domainSize,
                        self.position[2] * domainSize,
                        self.radius * domainSize)

   -- Draw "facing" indicator.
   love.graphics.setColor(255, 0, 0)
   love.graphics.circle("fill",
        (self.position[1] + math.cos(self.angle) * self.radius) * domainSize,
        (self.position[2] - math.sin(self.angle) * self.radius) * domainSize,
        self.headRadius * domainSize)
end

function Player:accelerate(direction)
   -- Makes the player go. Arguments:
   --  - direction: Accelerates if == 1, deccelerates if == -1, stops
   --  - (eventually) if == 0. Raises otherwise.
   -- Returns nothing.
   if direction == 0 or direction == 1 or direction == -1 then
      self.accelerating = direction
   else
      error("Invalid player acceleration argument: " .. direction)
   end
end

function Player:rotate(direction)
   -- Makes the player spin. Arguments:
   --  - direction: Clockwise if == 1, Anticlockwise if == -1, stops
   --  - immediately if == 0. Raises otherwise.
   -- Returns nothing.
   if direction == 0 or direction == 1 or direction == -1 then
      self.rotating = direction
   else
      error("Invalid player rotation argument: " .. direction)
   end
end

function Player:update(dt)
   -- Updates the player instance. Returns nothing.

   -- Update player angle (if player is rotating).
   self.angle = self.angle - self.maxRotationSpeed * self.rotating * dt

   -- Update player velocity.
   self.velocity[1] = (self.velocity[1] + self.maxAcceleration *
                          self.accelerating * math.cos(self.angle) * dt)
   self.velocity[2] = (self.velocity[2] - self.maxAcceleration *
                          self.accelerating * math.sin(self.angle) * dt)

   -- Normalise player velocity, if too great.
   local playerSpeed = math.sqrt(math.pow(self.velocity[1], 2) +
                                    math.pow(self.velocity[2], 2))
   if playerSpeed > self.maxSpeed then
      local normalisation = self.maxSpeed / playerSpeed
      for index = 1, 2 do
         self.velocity[index] = self.velocity[index] * normalisation
      end
   end

   -- Apply rudimentary friction. This implementation is very basic; if the
   -- player is not accelerating, their velocity decays in time.
   if self.accelerating == 0 then
      for index = 1, 2 do
         self.velocity[index] = self.velocity[index] * (1 - dt)
      end
   end

   -- Use velocity to update position.
   Translator:update(dt)
end
