-- Defines behaviours of colliding translators.

function collision_distance(inner, outer)
   local xDiff = outer.position[1] - inner.position[1]
   local yDiff = outer.position[2] - inner.position[2]
   return math.sqrt(xDiff * xDiff + yDiff * yDiff)
end

function overlapping(inner, outer)
   -- Returns true if the two translators `inner`, and `outer` are
   -- overlapping,  and false otherwise.
   local distance = collision_distance(inner, outer)
   return distance < outer.radius + inner.radius
end

function update_collisions(player, obstacles, dt)
   -- Triggers collision behaviour for each collision detected between
   -- obstacles with each other, and obstacles with the player.

   -- Figure out which obstacles have collided.
   local collisions = {}
   for outerKey, outer in pairs(obstacles) do
      for innerKey, inner in pairs(obstacles) do
         if outerKey < innerKey and overlapping(inner, outer) then
            -- print("boing!")
            table.insert(collisions, {inner, outer})
         end
      end
   end

   -- Resolve each collision in turn. "inner" and "outer" are just names, and
   -- don't imply any "preference" to the collision.
   for _, collisions in pairs(collisions) do
      local inner = collisions[1]
      local outer = collisions[2]

      -- print(string.format("Resolving collision between:\n" ..
      --                     " - px=%f, py=%f, vx=%f, vy=%f\n" ..
      --                     " - px=%f, py=%f, vx=%f, vy=%f\n" ..
      --                     "with distance %f (crit=%f).",
      --                     inner.position[1], inner.position[2],
      --                     inner.velocity[1], inner.velocity[2],
      --                     outer.position[1], outer.position[2],
      --                     outer.velocity[1], outer.velocity[2],
      --                     collision_distance(inner, outer),
      --                     inner.radius + outer.radius))

      -- Tersely put, we swap the velocity components parallel to the axis of
      -- the collision of the two bodies. Precompute where possible.
      local transformAngle = -math.atan2(inner.velocity[2] - outer.velocity[2],
                                         inner.velocity[1] - outer.velocity[1])
      -- print(string.format("Collision is at an angle of %f degrees.",
      --                     transformAngle * 180 / math.pi))
      local cosT = math.cos(transformAngle)
      local cosTT = cosT * cosT
      local sinT = math.sin(transformAngle)
      local sinTT = sinT * sinT
      -- print(string.format("cosT = %f\n" ..
      --                     "sinT = %f", cosT, sinT))

      -- Compute velocities as a copy
      local oldParaInner =
         inner.velocity[1] * cosT -
         inner.velocity[2] * sinT
      local oldPerpInner =
         inner.velocity[1] * sinT +
         inner.velocity[2] * cosT
      local oldParaOuter =
         outer.velocity[1] * cosT -
         outer.velocity[2] * sinT
      local oldPerpOuter =
         outer.velocity[1] * sinT +
         outer.velocity[2] * cosT

      local newParaInner = oldParaOuter
      local newPerpInner = oldPerpInner
      local newParaOuter = oldParaInner
      local newPerpOuter = oldPerpOuter

      local newVelInnerX = newParaInner * cosT + newPerpInner * sinT
      local newVelInnerY = -newParaInner * sinT + newPerpInner * cosT
      local newVelOuterX = newParaOuter * cosT + newPerpOuter * sinT
      local newVelOuterY = -newParaOuter * sinT + newPerpOuter * cosT

      -- Map copies
      inner.velocity[1] = newVelInnerX
      inner.velocity[2] = newVelInnerY
      outer.velocity[1] = newVelOuterX
      outer.velocity[2] = newVelOuterY

      -- Update the two collided translators far enough so that they don't
      -- re-collide immediately. It's a hack, but a glorious one.
      while overlapping(inner, outer) do
         -- print(string.format("Translators now have:\n" ..
         --                     " - px=%f, py=%f, vx=%f, vy=%f\n" ..
         --                     " - px=%f, py=%f, vx=%f, vy=%f\n" ..
         --                     "with distance %f.",
         --                     inner.position[1], inner.position[2],
         --                     inner.velocity[1], inner.velocity[2],
         --                     outer.position[1], outer.position[2],
         --                     outer.velocity[1], outer.velocity[2],
         --                     collision_distance(inner, outer)))
         -- print("Forcing away...")
         inner:update(dt)
         outer:update(dt)
         inner.updated = true
         outer.updated = true
      end

      -- print(string.format("Translators now have:\n" ..
      --                     " - px=%f, py=%f, vx=%f, vy=%f\n" ..
      --                     " - px=%f, py=%f, vx=%f, vy=%f\n" ..
      --                     "with distance %f.",
      --                     inner.position[1], inner.position[2],
      --                     inner.velocity[1], inner.velocity[2],
      --                     outer.position[1], outer.position[2],
      --                     outer.velocity[1], outer.velocity[2],
      --                     collision_distance(inner, outer)))
      -- print("=====")

      -- io.read()
   end
end
