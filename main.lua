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
json = require "json"

function love.load(args)
    shader = love.graphics.newShader("shader.fs")

	for _,flag in ipairs(args) do
		print(flag)
    	if flag == "-t" or flag == "--test" then
    		local lovetest = require("test/lovetest")
    		lovetest.run()
			love.event.push("quit")
			return
    	elseif flag == "-m" or flag == "--map" then
    		mapBuilder = require("lua/mapBuilder")
    	else
    		--unrecognized flag
    	end
	end

	-- Basic utils needed for game or map mode
	keyBindings = KeyBindings()

	if mapBuilder then
		activeState = mapBuilder
		love.window.setMode(1312, 600)
	else
		myFont = love.graphics.newImageFont("media/font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,!?\'\"0123456789-+")
		love.graphics.setFont(myFont)

		options = Options()
		mainMenu = MainMenu()
		activeState = LoadingScreen()
		toState = nil
	end
end

function love.draw()
	activeState:draw()
	
	if options and options.displayFPS then
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
	if mapBuilder then
		activeState:mousepressed(x,y,button)
	end
end

function love.wheelmoved(x, y)
	if mapBuilder then
		activeState:wheelmoved(x, y)
	end
end

function love.update(dt)
	if toState then
		activeState = toState
		toState = nil
	end
	activeState:update(dt)
end

