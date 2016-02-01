require("lua/sprites/sprite")

Turret = {}
Turret.__index = Turret


setmetatable(Turret, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Turret:_init(x, y)
	Sprite._init(self, x, y, 32, 32)
	self.bulletTimer = 0

	self.imageName = "turret"
end

function Turret.draw(self)
	local image = images:getImage(self.imageName)
	love.graphics.setColor(255,255,255, 255)
	love.graphics.draw(image, self.x-32, self.y-32)
end

function Turret.update(self, map, dt)
	self.bulletTimer = self.bulletTimer + dt
	if self.bulletTimer > 1 then
		self:fireBullets(map)
		self.bulletTimer = 0
	end
end

function Turret.fireBullets(self, map)
	local x = self.x
	local y = self.y
	table.insert(map.bullets, Arrow(x, y, "right"))
	table.insert(map.bullets, Arrow(x, y, "left"))
	table.insert(map.bullets, Arrow(x, y, "down"))
	table.insert(map.bullets, Arrow(x, y, "up"))
end

function Turret.damage(self)
	--
end
