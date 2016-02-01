require("lua/keyBindings")
require("lua/images")
require("lua/music")
require("lua/soundeffects")
require("lua/tiles")
require("lua/portraits")
require("lua/menu/mainMenu")
require("lua/menu/loadingScreen")
require("lua/game")
require("lua/options")

function love.load()
	myFont = love.graphics.newImageFont("media/font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,!?\'\"0123456789-+")
	love.graphics.setFont(myFont)

	keyBindings = KeyBindings()
	options = Options()
	mainMenu = MainMenu()
	activeState = LoadingScreen()
	toState = nil
end

function love.draw()
	activeState:draw()
	
	if options.displayFPS then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(love.timer.getFPS(), 10, 10)
	end
end

function love.keypressed(key)
	if key == keyBindings:getQuit() then
		love.event.push("quit")
		return
	end
	activeState:keypressed(key)
end

function love.keyreleased(key)
	activeState:keyreleased(key)
end

function love.mousepressed(x, y, button)
	activeState:mousepressed(x,y,button)
end

function love.update(dt)
	if toState then
		activeState = toState
		toState = nil
	end
	activeState:update(dt)
end

