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


--TODO fix this bad boy
function love.run()

	local fps = 60

    math.randomseed(os.time())
    math.random() math.random() --LOL

    if love.load then love.load(arg) end

    local dt = 0

    -- Main loop time.
    while true do
	local frame_start_time = love.timer.getMicroTime()

        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
        if love.graphics then
            love.graphics.clear()
            if love.draw then love.draw() end
        end

        if love.graphics then love.graphics.present() end

	 local frame_end_time = love.timer.getMicroTime() -- Takes a time measurement for the stop time of the frame.
        local frame_time = frame_end_time - frame_start_time -- The time it took for this frame to be completed.
        if frame_time < 1 / fps then
            love.timer.sleep(1/ fps - frame_time)
        end

    end
end
