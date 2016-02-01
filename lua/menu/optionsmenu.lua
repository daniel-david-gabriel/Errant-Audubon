OptionsMenu = {}
OptionsMenu.__index = OptionsMenu

setmetatable(OptionsMenu, {
  __index = OptionsMenu,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function OptionsMenu:_init()
	self.background = love.graphics.newImage("media/menu/mainMenu.png")
end

function OptionsMenu.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.background, 0, 0)
end

function OptionsMenu.keypressed(self, key)
	if key == keyBindings:getMenu() then
		toState = mainMenu
	end
end

function OptionsMenu.keyreleased(self, key)
	--
end

function OptionsMenu.mousepressed(self, x, y, button)
	--
end

function OptionsMenu.update(self, dt)
	--
end
