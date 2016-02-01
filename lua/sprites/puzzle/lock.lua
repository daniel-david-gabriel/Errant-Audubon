require("lua/sprites/sprite")

Lock = {}
Lock.__index = Lock


setmetatable(Lock, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Lock:_init(x, y, name)
	Sprite._init(self, x, y, 32, 32)
	self.name = name
end

function Lock.draw(self)
	if options.debug then
		love.graphics.setColor(255, 255, 128, 255)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
end

function Lock.update(self, dt)
	--noop
end