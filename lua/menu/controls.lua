Controls = {}
Controls.__index = Controls

setmetatable(Controls, {
  __index = Controls,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Controls:_init()
	self.background = love.graphics.newImage("media/menu/controls.png")
end

function Controls.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.background, 0, 0)
end

function Controls.keypressed(self, key)
	if key == keyBindings:getMenu() then
		toState = mainMenu
	end
end

function Controls.keyreleased(self, key)
	--
end

function Controls.mousepressed(self, x, y, button)
	--
end

function Controls.update(self, dt)
	--
end
