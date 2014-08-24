function planetConnection(firstplanet, secondplanet, joint)
    local connection = {
        firstPlanet = firstplanet,
        secondPlanet = secondplanet,
        joint = joint
    }

    function connection:draw()
        local firstPosition = self.firstPlanet:screenPosition()
        local secondPosition = self.secondPlanet:screenPosition()
        love.graphics.setColor(self.firstPlanet:getColor())
        love.graphics.line(firstPosition[1], firstPosition[2], secondPosition[1], secondPosition[2])
        love.graphics.setColor(255, 255, 255)
    end

    return connection
end