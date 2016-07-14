require("lua/sprites/sprite")
require("lua/sprites/effects/smoke")

Enemy = {}
Enemy.__index = Enemy


setmetatable(Enemy, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Enemy:_init(x, y, width, height, size, health, common, uncommon, rare)
	Sprite._init(self, x, y, width, height)

	self.size = size
	self.health = health
	self.common = common
	self.uncommon = uncommon
	self.rare = rare
end

function Enemy.damage(self)
	self.health = self.health - 1

	if self.health <= 0 then
		self.health = 0
		lootGenerator:generate(self)
		self:despawn(map)

		if knight.isGrabbing and knight.grabbedEnemy == self then
			knight.isGrabbing = false
			knight.grabbedEnemy = nil
		end
	end
end

function Enemy.despawn(self, map)
	for i=1, 8 do
		table.insert(map.effects, Smoke(self.x+32+(math.random()*(1.5)*32)-64, self.y+32+(math.random()*32)-64))
	end
	
	local toDelete
	for i,enemy in pairs(map.enemies) do
		if enemy == self then
			toDelete = i
		end
	end
	table.remove(map.enemies, toDelete)
end

function Enemy.knockback(self, other)
	if other.facingDirection == "up" then
		self:move("up", 32)
	elseif other.facingDirection == "down" then
		self:move("down", 32)
	elseif other.facingDirection == "left" then
		self:move("left", 32)
	elseif other.facingDirection == "right" then
		self:move("right", 32)
	end
end

function Enemy.isGrabbed(self)
	return knight.isGrabbing and knight.grabbedEnemy == self
end

function Enemy.moveToward(self, other)
	if self:xDistance(other) > self:yDistance(other) then
		if self:isLeftOf(other) then
			self:move("right", self.speed)
		else
			self:move("left", self.speed)
		end
	else
		if self:isAbove(other) then
			self:move("down", self.speed)
			self.direction = "down"
		else
			self:move("up", self.speed)
			self.direction = "up"
		end
	end
end