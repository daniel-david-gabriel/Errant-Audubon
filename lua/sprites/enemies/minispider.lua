require("lua/sprites/enemy")

Minispider = {}
Minispider.__index = Minispider


setmetatable(Minispider, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Minispider:_init(x, y)
	Enemy._init(self, x, y, 24, 24, "small", 1, "claw", "eye", "tuft")

	self.moveTimer = 0
	self.spriteCounter = 1

	self.speed = 8
	self.direction = "down"
	self.spriteName = "minispider"
	self.name = "minispider"
end

function Minispider.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	love.graphics.draw(sprites["image"], sprites["quads"][self.direction][self.spriteCounter], (self.x)-32, (self.y)-32)
end

function Minispider.update(self, map, dt)
	if self:collidesWith(knight) then
		--knight:knockback(self, 5)
		knight:damage(2)
	end

	self.moveTimer = self.moveTimer + dt
	if self.moveTimer < 0.25 then
		return
	end
	self.moveTimer = 0
	self.spriteCounter = self.spriteCounter + 1
	if self.spriteCounter > 2 then
		self.spriteCounter = 1
	end

	local roll = math.random(4)
	if roll == 1 then
		self:move("right", self.speed)
		self.direction = "right"
	elseif roll == 2 then
		self:move("left", self.speed)
		self.direction = "left"
	elseif roll == 3 then
		self:move("down", self.speed)
		self.direction = "down"
	elseif roll == 4 then
		self:move("up", self.speed)
		self.direction = "up"
	end
end
