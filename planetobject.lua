require "teamcolors"
require "vec2"
require "bulletobject"

function planetObject(universe, x, y, size, team, type)
    if type == nil then type = "normal" end

    local worldCircleSegments = 50
    local selectedExtraRadius = 0.025
    local flashDuration = 0.5
    local selectedColorModifier = {50, 50, 50}
    local minSpeed = 1
    local maxSpeed = 5 --This is multiplied by the distance for uniform acceleration

    local attackRadiusMultiplier = 4
    local attackInterval = 0.5

    local planetObject = {
        position = {x, y},
        goalPosition = {x, y},
        moving = false,
        moveDistance = 0,

        type = type,

        colorModifier = {0, 0, 0},

        size = size,

        team = team,
        selected = false,
        hover = false,
        connections = {},
        childJoints = {},

        attackRate = 1,
        combatTargets = {},
        damageSource = self,

        flashTimer = 0,

        bullets = {},
        attackTimer = 0,

        healTimer = 0
    }

    function planetObject:init()
        self.maxHealth = self.size

        if self.type == "healthy" then
            self.maxHealth = self.size * 2
        end

        if self.type == "strong" or self.type == "support" then
            self.maxHealth = self.size * 0.75
        end

        self.health = self.maxHealth

        self.id = math.random(1, 9999)

        local scale = love.physics.getMeter()
        self.body = love.physics.newBody(self.universe.world, self.position[1], self.position[2], "dynamic")
        self.shape = love.physics.newCircleShape(self.size)
        self.fixture = love.physics.newFixture(self.body, self.shape, 1)

        self.body:setLinearDamping(3, 3)
    end

    function planetObject:attackRadius()
        return self.size * attackRadiusMultiplier
    end

    function planetObject:healAmount()
        if self.type == "healthy" then
            return self.size * 2
        end

        if self.type == "support" then
            return self.size * 0.05
        end

        return self.size * 0.1
    end

    function planetObject:setSelected(selected)
        self.selected = selected
        if self.selected then
            self.body:setLinearDamping(100, 100)
        else
            self.body:setLinearDamping(3, 3)
        end
    end

    function planetObject:screenPosition()
        local x, y = self.body:getPosition()
        local scale = love.physics.getMeter()

        return {x * scale, y * scale}
    end

    function planetObject:worldPosition()
        local x, y = self.body:getPosition()
        return {x, y}
    end

    function planetObject:setHover(hover)
        self.hover = hover
    end

    function planetObject:setTarget(target)
        self.target = target
    end

    function planetObject:area()
        return self.size * self.size * 3.14
    end

    function planetObject:contains(x, y)
        local magnitude = vec2.magnitude({x, y}, self:worldPosition())

        if magnitude <= self.size then
            return true
        else
            return false
        end
    end

    function planetObject:isConnectedTo(planet)
        for _,connection in ipairs(self.connections) do
            if connection.firstPlanet == planet or connection.secondPlanet == planet then
                return connection
            end
        end
        return false
    end

    function planetObject:update(dt)
        local mousePos = {}
        mousePos[1], mousePos[2] = love.mouse.getPosition()
        local mouseDistance = vec2.magnitude(mousePos, self.position)

        self:flash(-dt) --Remove dt from timer

        if self.moving then
            self:move(dt)
        end

        if self.inCombat then
            self:combat(dt)
        else
            if self.type ~= "strong" then
                self:healConnected(dt)
            end
        end

        if #self.combatTargets == 0 and #self.connections == 0 then
            self.health = self.maxHealth
            self.bullets = {}
        end

        for _,bullet in ipairs(self.bullets) do
            bullet:update(dt)
        end

        self.position = self:screenPosition()

        if not self.selected then self.target = nil end
    end

    function planetObject:startMoving(x, y, callback)
        self.movedCallback = nil
        if callback then self.movedCallback = callback end

        self.goalPosition = {x, y}
        self.moving = true
        self.moveDistance = vec2.magnitude(self:worldPosition(), self.goalPosition)
    end

    function planetObject:move(dt)
        local position = self:worldPosition()

        local magnitude = vec2.magnitude(position, self.goalPosition)

        if magnitude < 0.01 then
            self.body:setPosition(self.goalPosition[1], self.goalPosition[2])
            self:stopMoving() 
            return
        end

        local speed = math.sin((magnitude / self.moveDistance) * 3.14) * maxSpeed + minSpeed --Smooth acceleration and deceleration

        local distance = vec2.distance(self.goalPosition, position) --Vector from position to goal position
        local velocity = vec2.mul(vec2.normalize(distance), speed)

        self.body:setLinearVelocity(velocity[1], velocity[2])
    end

    function planetObject:stopMoving()
            self.body:setLinearVelocity(0, 0)
            self.moving = false
            if self.movedCallback then self.movedCallback(self) end
    end

    function planetObject:healConnected(dt)
        local healed = false
        for _,connection in ipairs(self.connections) do
            local planet = connection.firstPlanet
            if planet == self then planet = connection.secondPlanet end

            if planet.health < planet.maxHealth then
                healed = true

                local maxHeal = self:healAmount()
                if maxHeal > planet.maxHealth - planet.health then maxHeal = planet.maxHealth - planet.health end
                maxHeal = maxHeal * dt
                planet.health = planet.health + maxHeal
                self:damage(maxHeal, planet.damageSource, false)
                if self.healTimer > 0.5 then
                    self:spawnBullet(planet)
                    self.healTimer = 0
                end
                self.healTimer = self.healTimer + dt
            end
        end
        if not healed then self.healTimer = 0 end
    end

    function planetObject:fullyHealAllConnected()
        for _,connection in ipairs(self.connections) do
            local planet = connection.firstPlanet
            if planet == self then planet = connection.secondPlanet end

            if #planet.combatTargets == 0 and planet.health < planet.maxHealth then
                planet.health = planet.maxHealth
                planet:fullyHealAllConnected()
            end
        end
    end

    function planetObject:combat(dt)
        for _,combatTarget in ipairs(self.combatTargets) do
            if (not self:targetInRange(combatTarget) and not combatTarget:targetInRange(self)) or self.team == combatTarget.team then
                self:stopCombatWith(combatTarget)
                return
            end

            if self.team ~= 1 then --Team 1 is neutral and doesn't give a damn
                if self.attackTimer > attackInterval then
                    self:spawnBullet(combatTarget)
                    self.attackTimer = 0
                end
                self.attackTimer = self.attackTimer + dt

                combatTarget:damage(self:damageAmount() * dt, self)
            end
        end
    end

    function planetObject:spawnBullet(target)
        local newBullet = bulletObject(self, target)

        table.insert(self.bullets, newBullet)
    end

    function planetObject:removeBullet(removeBullet)
        for i,bullet in ipairs(self.bullets) do
            if bullet == removeBullet then
                table.remove(self.bullets, i)
            end
        end
    end

    function planetObject:enterCombat(target, force)
        if self:targetInRange(target) or force then
            table.insert(self.combatTargets, target)
            self.inCombat = true
            self.attackTimer = attackInterval
            if not target:inCombatWith(self) then target:enterCombat(self, true) end
        end
    end

    function planetObject:leaveCombat()
        for i = #self.combatTargets, 1, -1 do
            self:stopCombatWith(self.combatTargets[i])
        end
        self:fullHeal()
        self.inCombat = false
        self.bullets = {}
    end

    function planetObject:inCombatWith(target)
        for i,combatTarget in ipairs(self.combatTargets) do
            if combatTarget == target then return true end
        end
        return false
    end

    function planetObject:stopCombatWith(target)
        for i,combatTarget in ipairs(self.combatTargets) do
            if combatTarget == target then
                table.remove(self.combatTargets, i)
                if target:inCombatWith(self) then 
                    target:stopCombatWith(self) 
                end
            end
        end

        if #self.combatTargets == 0 then
            self:leaveCombat()
        end
        for i = #self.bullets, 1, -1 do
            if self.bullets[i].target == target then
                table.remove(self.bullets, i)
            end
        end
    end

    function planetObject:damageAmount()
        local damage = self.size * 0.25

        if self.type == "healthy" or self.type == "support" then
            damage = self.size * 0.125
        end

        if self.type == "strong" then
            damage = self.size * 0.5
        end

        for x = 1, self:numConnectedSupports() do
            damage = damage * 1.5
        end

        return damage
    end

    function planetObject:numConnectedSupports()
        local sum = 0
        for _,connection in ipairs(self.connections) do
            local planet = connection.firstPlanet
            if planet == self then planet = connection.secondPlanet end

            if planet.type == "support" then sum = sum + 1 end
        end
        return sum
    end

    function planetObject:damage(amount, source, connectOnDeath)
        if connectOnDeath == nil then connectOnDeath = true end

        self.health = self.health - amount
        self.damageSource = source

        if self.health <= 0 then
            self:fullyHealAllConnected()
            self:removeAllConnections()
            self:flash(0.5)

            self.team = source.team
            self.universe:deselect(self)

            if connectOnDeath then self.universe:connectPlanets(self, source) end

            self:leaveCombat()
        end
    end

    function planetObject:fullHeal()
        self.health = self.maxHealth
        self:fullyHealAllConnected()
    end

    function planetObject:defend(target, dt)
        target:damage(self:damageAmount() * dt, self)
    end

    function planetObject:removeAllConnections()
        for i = #self.connections, 1, -1 do
            self.universe:disconnectPlanets(self.connections[i])
        end
    end

    function planetObject:removeConnection(removeConnection)
        for i,connection in ipairs(self.connections) do
            if connection == removeConnection then
                table.remove(self.connections, i)
            end
        end
    end

    function planetObject:targetInRange(target)
        local range = self:targetAttackRange(target)
        local distance = vec2.magnitude(self:worldPosition(), target:worldPosition())

        return distance <= range
    end

    function planetObject:flash(addTime)
        self.flashTimer = self.flashTimer + addTime
        if self.flashTimer < 0 then self.flashTimer = 0 end

        self.colorModifier = {
            100 * (self.flashTimer / flashDuration),
            100 * (self.flashTimer / flashDuration),
            100 * (self.flashTimer / flashDuration),
        }
    end

    function planetObject:getColor()
        local teamColor = {teamColors[self.team][1], teamColors[self.team][2], teamColors[self.team][3]}
        teamColor[1] = math.min(teamColor[1] + self.colorModifier[1], 255)
        teamColor[2] = math.min(teamColor[2] + self.colorModifier[2], 255)
        teamColor[3] = math.min(teamColor[3] + self.colorModifier[3], 255)


        if self.selected then
            teamColor[1] = math.min(teamColor[1] + selectedColorModifier[1], 255)
            teamColor[2] = math.min(teamColor[2] + selectedColorModifier[2], 255)
            teamColor[3] = math.min(teamColor[3] + selectedColorModifier[3], 255)
        end


        return teamColor
    end

    function planetObject:targetAttackRange(target)
        local scale = love.physics.getMeter()
        return self:attackRadius() + target.size
    end

    function planetObject:attackPointAlongLine()
        local targetVector = vec2.distance(self.target:worldPosition(), self:worldPosition())
        local normTargetVector = vec2.normalize(targetVector)
        local distance = vec2.length(targetVector)
        local targetRange = self:targetAttackRange(self.target) - 0.05 --Reduce radius a bit to make sure that it gets in range

        if distance < targetRange then 
            return self:worldPosition() 
        end

        local moveDistance = distance - targetRange
        return vec2.add(self:worldPosition(), vec2.mul(normTargetVector, moveDistance))
    end

    function planetObject:drawlines()
        if self.inCombat then
            self:drawCombatLines()
        end

        self:drawBullets()

        self:drawMovementLines()
    end

    function planetObject:drawCombatLines()
        local scale = love.physics.getMeter()

        for _,combatTarget in ipairs(self.combatTargets) do
            love.graphics.setColor(self:getColor())
            love.graphics.line(combatTarget.position[1], combatTarget.position[2], self.position[1], self.position[2])
            love.graphics.setColor(teamColors.default[1], teamColors.default[2], teamColors.default[3])
        end

    end

    function planetObject:drawBullets()
        for _,bullet in ipairs(self.bullets) do
            bullet:draw()
        end
    end

    function planetObject:drawMovementLines()
        local goalPosition = {self.universe.worldToScreen(self.goalPosition[1], self.goalPosition[2])}
        local scale = love.physics.getMeter()

        if self.target then
            local moveTo = self:attackPointAlongLine()
            moveTo[1], moveTo[2] = self.universe.worldToScreen(moveTo[1], moveTo[2])

            love.graphics.dashline(moveTo[1], moveTo[2], self.position[1], self.position[2], 5, 5)


            love.graphics.setColor(self:getColor())
            love.graphics.line(self.target.position[1], self.target.position[2], moveTo[1], moveTo[2])
            love.graphics.circle("fill", self.target.position[1], self.target.position[2], (self.target.size + selectedExtraRadius) * scale, worldCircleSegments)

            --Draw outline of world
            love.graphics.setColor(150, 150, 150)
            self:drawPositionMarker(moveTo[1], moveTo[2])

            love.graphics.setColor(teamColors.default[1], teamColors.default[2], teamColors.default[3])

        elseif self.moving then
            love.graphics.setColor(self:getColor())
            love.graphics.dashline(goalPosition[1], goalPosition[2], self.position[1], self.position[2], 5, 5)

            love.graphics.setColor(150, 150, 150)
            love.graphics.setColor(teamColors.default[1], teamColors.default[2], teamColors.default[3])
            self:drawPositionMarker(goalPosition[1], goalPosition[2])
        elseif self.selected then
            local mouseX, mouseY = love.mouse.getPosition()

            love.graphics.setColor(150, 150, 150)
            love.graphics.dashline(mouseX, mouseY, self.position[1], self.position[2], 5, 5)
            self:drawPositionMarker(mouseX, mouseY)

        end
    end

    function planetObject:drawPositionMarker(x, y)
            local scale = love.physics.getMeter()
            love.graphics.setColor(150, 150, 150)
            love.graphics.circle("line", x, y, self.size * scale, worldCircleSegments)
            love.graphics.circle("fill", x, y, 5, worldCircleSegments)
            love.graphics.setColor(teamColors.default[1], teamColors.default[2], teamColors.default[3])
    end

    function planetObject:draw()
        local scale = love.physics.getMeter()
        love.graphics.setColor(self:getColor())


        if self.hover then
            love.graphics.circle("fill", self.position[1], self.position[2], (self.size + selectedExtraRadius) * scale, worldCircleSegments)
            love.graphics.setColor(150, 150, 150)
            love.graphics.circle("line", self.position[1], self.position[2], (self:attackRadius()) * scale, worldCircleSegments)
        end

        if self.health < self.maxHealth and self.damageSource then
            love.graphics.setColor(self.damageSource:getColor())
            love.graphics.circle("fill", self.position[1], self.position[2], self.size * scale, worldCircleSegments)
        end

        love.graphics.setColor(self:getColor())
        love.graphics.circle("fill", self.position[1], self.position[2], self.size * scale * (self.health / self.maxHealth), worldCircleSegments)

        love.graphics.setColor(30, 30, 30)

        if self.type == "healthy" then
            love.graphics.rectangle("fill", self.position[1] - 4, self.position[2] - 1, 8, 2)
            love.graphics.rectangle("fill", self.position[1] - 1, self.position[2] - 4, 2, 8)
        end

        if self.type == "strong" then
            love.graphics.line(self.position[1] - 3, self.position[2] - 3, self.position[1] + 3, self.position[2] + 3)
            love.graphics.line(self.position[1] - 3, self.position[2] + 3, self.position[1] + 3, self.position[2] - 3)
        end

        if self.type == "support" then
            love.graphics.circle("line", self.position[1], self.position[2], 3, worldCircleSegments)
        end

        love.graphics.setColor(teamColors.default[1], teamColors.default[2], teamColors.default[3])

        --Debug
        -- love.graphics.print(string.format("%s", self.id), self.position[1]-10, self.position[2] + 20)
        -- love.graphics.print(string.format("%s / %s", self.health, self.maxHealth), self.position[1]-10, self.position[2] + 40)
    end

    return planetObject
end