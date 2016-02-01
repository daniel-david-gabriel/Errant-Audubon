require("lua/sprites/sprite")

Projectile = {}
Projectile.__index = Projectile


setmetatable(Projectile, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Projectile:_init(x, y, width, height, direction, imageName)
	Sprite._init(self, x, y, width, height)
	self.direction = direction

	self.imageName = imageName

	self.speed = 8
	self.toDespawn = false
	self.despawnTime = 0
end

function Projectile.update(self, map, dt)
	if self.toDespawn then
		self.despawnTime = self.despawnTime + dt
		if self.despawnTime > 0.25 then
			self:despawn(map)
		end
		return
	end

	if self:collidesWith(knight) then
		-- use isLeftOf() etc and knight.facingdirection!
		if not knight.toolUsed then
			knight:damage(25)
		end
		self:despawn(map)
	elseif not self:move(self.direction, self.speed) then -- hit a wall or something
		self.toDespawn = true
		self.despawnTime = dt
	end
end

function Projectile.despawn(self, map)
	local toDelete
	for i,bullet in pairs(map.bullets) do
		if bullet == self then
			toDelete = i
		end
	end
	table.remove(map.bullets, toDelete)
end

function Projectile.draw(self)
	local angle = 0
	if self.direction  == "right" then
		angle = 0
	elseif self.direction  == "down" then
		angle = 90
	elseif self.direction  == "left" then
		angle = 180
	elseif self.direction  == "up" then
		angle = 270
	end

	local image = images:getImage(self.imageName)
	love.graphics.setColor(125,109,90, 255)
	love.graphics.draw(image, (self.x)-16, (self.y)-16, math.rad(angle), 1, 1, self.width/2, self.height/2)
end
