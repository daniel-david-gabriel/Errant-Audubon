require("lua/sprites/sprite")

Shield = {}
Shield.__index = Shield


setmetatable(Shield, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Shield:_init()
	Sprite._init(self, 0, 0, 32, 32)

	self.imageName = "shield"

	self.beingUsed = false
	self.attackAnimation = 1
	self.facingDirection = "down"
	self.enemiesHit = {}
end

function Shield.use(self, knight)
	self.beingUsed = true

	self.x = knight.x
	self.y = knight.y
	self.facingDirection = knight.facingDirection

	if knight.facingDirection == "up" then
		self.y = self.y - 32
	elseif knight.facingDirection == "down" then
		self.y = self.y + 32
	elseif knight.facingDirection == "left" then
		self.x = self.x - 32
	elseif knight.facingDirection == "right" then
		self.x = self.x + 32
	end
end

function Shield.draw(self)
	if self.beingUsed then
		love.graphics.draw(images:getImage(self.imageName), self.x-32, self.y-32)
	end
end

function Shield.update(self, dt)
	if self.beingUsed then
		self:attack()
		self.attackAnimation = self.attackAnimation  + 1
		if self.attackAnimation > 12 then
			self.attackAnimation = 1
			self.beingUsed = false
			self.enemiesHit = {}
		end
	end
end

function Shield.attack(self)
	for i,enemy in pairs(map.enemies) do
		if self:collidesWith(enemy) and self.enemiesHit[enemy] == nil then
			enemy:damage()
			enemy:knockback(self)
			self.enemiesHit[enemy] = enemy
			--self.attackAnimation = 1
			--self.beingUsed = false
			
		end
	end
end
