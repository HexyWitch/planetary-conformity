require "planetobject"
require "planetconnection"
require "levels"

universeState = {
    name = "universeState"
}

function universeState:enter(statedata)
    self.statedata = statedata or {levelIndex = 1, introText = ""}

    love.physics.setMeter(50)
    self.world = love.physics.newWorld(0, 0, true)

    self.planets = {}
    self.playerTeam = 2
    self.selectedPlanet = nil
    self.startMessage = nil


    self.fadeInTimer = 0
    self.fadeOutTimer = 0
    self.gameOver = false

    self.connections = {}

    levels[self.statedata.levelIndex](self)

    if self.startMessage then
        self.startMessageTimer = 0
    end
end

function universeState:update(dt)
    self.world:update(dt)

    local mouseX, mouseY = self.screenToWorld(love.mouse.getPosition())


    for _,planet in ipairs(self.planets) do
        planet:update(dt)

        if planet:contains(mouseX, mouseY) then
            universeState:hoverPlanet(planet)
        else
            planet:setHover(false)
        end
    end

    if self.selectedPlanet and self.selectedPlanet.target then
        if not self.selectedPlanet.target:contains(mouseX, mouseY) then
            self.selectedPlanet:setTarget(nil)
        end
    end

    if self:finishedLevel() and not self.gameOver then
        self.statedata.levelIndex = self.statedata.levelIndex + 1
        self.statedata.introText = "well done"
        self.gameOver = true
    end

    if self:isGameOver() and not self.gameOver then
        self.gameOver = true
        self.statedata.introText = "try again"
    end

    if self.fadeInTimer and self.fadeInTimer < 2 then
        self.fadeInTimer = self.fadeInTimer + dt
    elseif self.startMessageTimer and self.startMessageTimer < 4 then
        self.startMessageTimer = self.startMessageTimer + dt
    end

    if self.gameOver and self.fadeOutTimer < 3 then
        self.fadeOutTimer = self.fadeOutTimer + dt
    elseif self.fadeOutTimer >= 3 then
        self.fadeOutTimer = 3

        if self.statedata.levelIndex <= #levels then
            states:pickState("universeState", self.statedata)
        else
            states:pickState("endState")
        end
    end
end


function universeState:draw()
    love.graphics.setBackgroundColor(25, 25, 25)
    love.graphics.clear()

    --We want all lines to be drawn first
    for _,planet in ipairs(self.planets) do
        planet:drawlines()
    end

    for _,connection in ipairs(self.connections) do
        connection:draw()
    end

    for _,planet in ipairs(self.planets) do
        planet:draw()
    end

    -- if self.selectedPlanet then
    -- local text = string.format("%s is at x: %s y: %s", self.selectedPlanet.id, self.selectedPlanet:worldPosition()[1], self.selectedPlanet:worldPosition()[2])
    --     love.graphics.print(text, 10, 10)
    -- end


    --Start message
    if self.startMessage and self.startMessageTimer < 4 then
        love.graphics.setNewFont(20)
        local opacity = math.sin(self.startMessageTimer / 4 * 3.14) * 255
        love.graphics.setColor(255, 255, 255, opacity)
        love.graphics.printf(self.startMessage, 20, 40, 600, "center")
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setNewFont(12)
    end

    --Fade in
    if self.fadeInTimer < 2 then
        local opacity = 255 - math.min(self.fadeInTimer / 2, 1) * 255
        love.graphics.setColor(200, 200, 200, opacity)
        love.graphics.rectangle("fill", 0, 0, 640, 480)
        love.graphics.setColor(40, 40, 40, opacity)
        love.graphics.setNewFont(48)
        love.graphics.printf(self.statedata.introText, 20, 200, 620, "center")
        love.graphics.setNewFont(12)
        love.graphics.setColor(255, 255, 255, 255)
    end

    --Fade out
    if self.gameOver then
        local opacity = math.min(self.fadeOutTimer / 2, 1) * 255
        love.graphics.setColor(200, 200, 200, opacity)
        love.graphics.rectangle("fill", 0, 0, 640, 480)
        love.graphics.setColor(40, 40, 40, opacity)
        love.graphics.setNewFont(48)
        love.graphics.printf(self.statedata.introText, 20, 200, 620, "center")
        love.graphics.setNewFont(12)
        love.graphics.setColor(255, 255, 255, 255)
    end
end

function universeState:keypressed(key, isrepeat)
    if key == "escape" then
        self.statedata.introText = ""
        states:pickState("universeState", self.statedata)
    end
end

function universeState:keyreleased(key)

end

function universeState:mousepressed(x, y, button)
    local x, y = self.screenToWorld(x, y)

    for _,planet in ipairs(self.planets) do
        if planet:contains(x, y) then
            self:clickedPlanet(planet, button)
            return
        end
    end

    self:clickedSpace(x, y)
end

function universeState:finishedLevel()
    for _,planet in ipairs(self.planets) do
        if planet.team ~= self.playerTeam then return false end
    end
    return true
end

function universeState:isGameOver()
    for _,planet in ipairs(self.planets) do
        if planet.team == self.playerTeam then return false end
    end
    return true
end

function universeState:hoverPlanet(planet)
    if self.selectedPlanet and planet ~= self.selectedPlanet and planet.team ~= self.selectedPlanet.team then
        self.selectedPlanet:setTarget(planet)
    end

    if planet.team == self.playerTeam then
        planet:setHover(true)
    end
end

function universeState:clickedPlanet(planet, button)
    if button == "l" then
        if planet.team == self.playerTeam then
            planet:setSelected(not planet.selected)

            if planet.selected then
                if self.selectedPlanet then self.selectedPlanet:setSelected(false) end
                self.selectedPlanet = planet
            else
                self.selectedPlanet = nil
            end
        else
            if self.selectedPlanet then
                self.selectedPlanet:stopMoving()

                if self.selectedPlanet:targetInRange(planet) then
                    self.selectedPlanet:enterCombat(planet)
                else
                    local movePos = self.selectedPlanet:attackPointAlongLine()
                    self.selectedPlanet:startMoving(movePos[1], movePos[2], function(movedPlanet)
                        movedPlanet:enterCombat(planet)
                    end)
                end
            end
        end
    elseif button =="r" then
        if self.selectedPlanet and planet.team == self.selectedPlanet.team and planet ~= self.selectedPlanet then
            local connection = self.selectedPlanet:isConnectedTo(planet)
            if connection then
                self:disconnectPlanets(connection)
            else
                if self.selectedPlanet:targetInRange(planet) or planet:targetInRange(self.selectedPlanet) then
                    self:connectPlanets(self.selectedPlanet, planet)
                end
            end
        end
    end
end

function universeState:deselect(planet)
    if self.selectedPlanet == planet then
        self.selectedPlanet = nil
        planet:setSelected(false)
    end
end

function universeState:clickedSpace(x, y)
    if self.selectedPlanet then
        self.selectedPlanet:startMoving(x, y)
    end
end

function universeState.screenToWorld(x, y)
    local scale = love.physics.getMeter()
    return x / scale, y / scale
end

function universeState.worldToScreen(x, y)
    local scale = love.physics.getMeter()
    return x * scale, y * scale
end

function universeState:mousereleasetd(x, y, button)

end

function universeState:newPlanet(x, y, size, team, type)
    local newPlanet = planetObject(self, x, y, size, team, type)
    newPlanet.universe = self
    table.insert(self.planets, newPlanet)
    newPlanet:init()
    return newPlanet
end

function universeState:connectPlanets(firstPlanet, secondPlanet)
    local firstPosition = firstPlanet:worldPosition()
    local secondPosition = secondPlanet:worldPosition()
    local joint = love.physics.newDistanceJoint(firstPlanet.body, secondPlanet.body, firstPosition[1], firstPosition[2], secondPosition[1], secondPosition[2], true)

    local newConnection = planetConnection(firstPlanet, secondPlanet, joint)
    table.insert(self.connections, newConnection)
    table.insert(firstPlanet.connections, newConnection)
    table.insert(secondPlanet.connections, newConnection)
end

function universeState:disconnectPlanets(removeConnection)
    for i,connection in ipairs(self.connections) do
        if connection == removeConnection then
            connection.joint:destroy()
            table.remove(self.connections, i)
            connection.firstPlanet:removeConnection(connection)
            connection.secondPlanet:removeConnection(connection)
        end
    end
end

function universeState:exit()

end
