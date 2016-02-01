LoadingScreen = {}
LoadingScreen.__index = LoadingScreen

setmetatable(LoadingScreen, {
  __index = LoadingScreen,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function LoadingScreen:_init()
	self.loadingText = "Loading Images..."
end

function LoadingScreen.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(self.loadingText, 10, 30)
end

function LoadingScreen.keypressed(self, key)
	--
end

function LoadingScreen.keyreleased(self, key)
	--
end

function LoadingScreen.mousepressed(self, x, y, button)
	--
end

function LoadingScreen.update(self, dt)
	if not images then
		images = Images()
		self.loadingText = "Loading Tiles..."
	elseif not tiles then
		tiles = Tiles()
		self.loadingText = "Loading Portraits..."
	elseif not portraits then
		portraits = Portraits()
		self.loadingText = "Loading Music..."
	elseif not music then
		music = Music()
		self.loadingText = "Loading Sound Effects..."
	elseif not soundEffects then
		soundEffects = SoundEffects()
	end
	
	if images and tiles and portraits and music and soundEffects then
		game = Game()
		toState = mainMenu
	end
end
