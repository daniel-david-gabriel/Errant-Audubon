require("lua/sprites/sprite")

Switch = {}
Switch.__index = Switch


setmetatable(Switch, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Switch:_init(x, y, type, locks)
	Sprite._init(self, x, y, 32, 32)
	self.type = type
	self.locks = locks
	self.pressed = false
end

function Switch.draw(self)
	if options.debug then
		love.graphics.setColor(128, 128, 128, 255)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
end

function Switch.update(self, dt)
	if self.pressed then
		return
	end

	if (self.type == "light") and self:collidesWith(knight) then
		--print("collision here")
		self:unlock()
	elseif (self.type == "heavy")  then
		--if it collides with a block
		--self:unlock()
		for i,puzzleElement in pairs(map.puzzles) do
			if puzzleElement.type == "block" and puzzleElement:collidesWith(self) then
				self:unlock()
				--lock into position
				puzzleElement.locked = true
				puzzleElement.x = self.x
				puzzleElement.y = self.y
				--play lock sfx
			end
		end
	end
end

function Switch.unlock(self)
	self.pressed = true
	if not self.locks then
		return
	end

	local locks = split(self.locks, "[^,]+")
	for i,lock in pairs(locks) do
		--print(lock)
		map:removeLock(lock)
	end
end