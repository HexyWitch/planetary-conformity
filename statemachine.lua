stateMachine = {}

function stateMachine.create()
    local stateMachine = {
        states = {},
        currentState = nil
    }

    function stateMachine:addState(state)
        state.states = self
        self.states[state.name] = state
    end

    function stateMachine:pickState(name, statedata)
        self.currentState = self.states[name]
        self.currentState:enter(statedata)
    end

    function stateMachine:update(dt)
        if self.currentState and self.currentState.update then
            self.currentState:update(dt)
        end
    end

    function stateMachine:keypressed(key, isrepeat)
        if self.currentState and self.currentState.keypressed then
            self.currentState:keypressed(key, isrepeat)
        end
    end

    function stateMachine:keyreleased(key)
        if self.currentState and self.currentState.keyreleased then
            self.currentState:keyreleased(key)
        end
    end

    function stateMachine:mousepressed(x, y, button)
        if self.currentState and self.currentState.mousepressed then
            self.currentState:mousepressed(x, y, button)
        end
    end

    function stateMachine:mousereleased(x, y, button)
        if self.currentState and self.currentState.mousereleased then
            self.currentState:mousereleased(x, y, button)
        end
    end

    function stateMachine:draw()
        if self.currentState and self.currentState.draw then
            self.currentState:draw()
        end
    end

    return stateMachine
end