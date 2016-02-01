GameOver = {}
GameOver.__index = GameOver

setmetatable(GameOver, {
  __index = GameOver,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function GameOver:_init()
	self.background = love.graphics.newImage("media/menu/gameOver.png")
end

function GameOver.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.background, 0, 0)
end

function GameOver.keypressed(self, key)
	if key == keyBindings:getMenu() then
		knight = Knight()
		map:reset()
		toMap = maps["001"] --constant for first map?
		toState = mainMenu
	end
end

function GameOver.keyreleased(self, key)
	--
end

function GameOver.mousepressed(self, x, y, button)
	--
end

function GameOver.update(self, dt)
	--
end
