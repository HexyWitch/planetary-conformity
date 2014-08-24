startState = {
    name = "startState"
}

function startState:enter(statedata)

end

function startState:update(dt)

end

function startState.draw()
    love.graphics.setColor(200, 200, 200, opacity)
    love.graphics.rectangle("fill", 0, 0, 640, 480)
    love.graphics.setColor(40, 40, 40, opacity)
    love.graphics.setNewFont(48)
    love.graphics.printf("Planetary Conformity", 20, 140, 620, "center")
    love.graphics.setNewFont(20)
    love.graphics.printf("click to start", 20, 220, 620, "center")
    love.graphics.printf("press ESC at any time to restart the level", 20, 400, 620, "center")
    love.graphics.setColor(255, 255, 255, 255)
end

function startState:keypressed(key, isrepeat)

end

function startState:keyreleased(key, isrepeat)

end

function startState:mousepressed(x, y, button)
    self.states:pickState("universeState")
end

function startState:mousereleased(x, y, button)

end