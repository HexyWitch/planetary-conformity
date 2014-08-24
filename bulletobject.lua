require "vec2"

function bulletObject(source, target)
    local bulletSpeed = 40

    local bullet = {
        position = {source.position[1], source.position[2]},
        goalPosition = {target.position[1], target.position[2]},
        source = source,
        target = target,
        distance = vec2.magnitude(source.position, target.position),
        rotation = 0
    }

    function bullet:update(dt)
        local targetVector = vec2.distance(source.position, target.position)
        local normVector = vec2.normalize(targetVector)

        self.distance = self.distance - bulletSpeed * dt

        self.position = vec2.add(target.position, vec2.mul(normVector, self.distance))

        local scale = love.physics.getMeter()
        if self.distance <= target.size * scale then
            self:destroy()
            return
        end
    end

    function bullet:destroy()
        source:removeBullet(self)
    end

    function bullet:draw()
        love.graphics.setColor(source:getColor())
        love.graphics.circle("fill", self.position[1], self.position[2], 4, 10)
        love.graphics.setColor(255, 255, 255)
    end

    return bullet
end