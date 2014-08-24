endState = {
    name = "endState"
}

function endState:enter(statedata)

end

function endState:update(dt)

end

function endState.draw()
    love.graphics.setColor(200, 200, 200, opacity)
    love.graphics.rectangle("fill", 0, 0, 640, 480)
    love.graphics.setColor(40, 40, 40, opacity)
    love.graphics.setNewFont(36)
    love.graphics.printf("You have successfully converted the entire universe to green. All hail green", 20, 140, 620, "center")
    love.graphics.setNewFont(20)
    love.graphics.printf("The End, thank you for playing. Click to restart the game.", 20, 400, 620, "center")
    love.graphics.setColor(255, 255, 255, 255)
end

function endState:keypressed(key, isrepeat)

end

function endState:keyreleased(key, isrepeat)

end

function endState:mousepressed(x, y, button)
    self.states:pickState("startState")
end

function endState:mousereleased(x, y, button)

end