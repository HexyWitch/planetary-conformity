require "util"
require "graphics"

require "gameconf"
require "statemachine"
require "universestate"
require "startstate"
require "endstate"

assets = {
	graphics = {},
	sounds = {},
	fonts = {}
}

function love.load()

	love.graphics.setLineStyle(config.graphics.lineStyle)

	states = stateMachine.create()

	states:addState(universeState)
	states:addState(startState)
	states:addState(endState)

	states:pickState("startState")

end

function love.draw()
	states:draw()
end

function love.update(dt)
	states:update(dt)
end

function love.keypressed(key, isrepeat)
	states:keypressed(key, isrepeat)
end

function love.keyreleased(key)
	states:keyreleased(key)
end

function love.mousepressed(x, y, button)
	states:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	states:mousereleased(x, y, button)
end

