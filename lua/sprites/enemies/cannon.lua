require("lua/sprites/sprite")

Cannon = {}
Cannon.__index = Cannon


setmetatable(Cannon, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Cannon:_init(x, y)
	Sprite._init(self, x, y, 32, 32)
	self.bulletTimer = 0
end

function Cannon.draw(self)
	love.graphics.setColor(128, 0, 128, 255)
	love.graphics.rectangle("fill", (self.x)-32, (self.y)-32, 32, 32)
end

function Cannon.update(self, map, dt)
	
	self.bulletTimer = self.bulletTimer + dt
	if self.bulletTimer > 1 then
		self:fireBullet(map)
		self.bulletTimer = 0
	end
end

function Cannon.fireBullet(self, map)
	local x = self.x
	local y = self.y
	if self:isLeftOf(knight) then
		table.insert(map.bullets, Bullet(x, y, "right"))
	elseif self:isRightOf(knight) then
		table.insert(map.bullets, Bullet(x, y, "left"))
	elseif self:isAbove(knight) then
		table.insert(map.bullets, Bullet(x, y, "down"))
	elseif self:isBelow(knight) then
		table.insert(map.bullets, Bullet(x, y, "up"))
	end
end

function Cannon.damage(self)
	--
end
