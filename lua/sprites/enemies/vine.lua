require("lua/sprites/enemy")

Vine = {}
Vine.__index = Vine


setmetatable(Vine, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Vine:_init(x, y, last_angle, depth)
	Enemy._init(self, x, y, 32, 32, "small", 1, "slimeball", "eye", "diamond")

	self.name = "Vine"
	self.depth = depth
	
	self.last_angle = last_angle
	
	self.angle = last_angle + math.random(160) - 80
	--self.angle = math.random(361) - 1
	
	self.x = x-16-math.cos(math.rad(self.angle+45))*21
	self.y = y-16-math.sin(math.rad(self.angle+45))*21
	
	self.spriteTimer = 0
end

function Vine.draw(self)
	
	if options.debug then
		love.graphics.setColor(255, 0, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.name)
	
	local frame = 1
	if self.depth == 0 or self.depth == -1 then
		frame = 2
	end
	
	love.graphics.draw(sprites["image"], sprites["quads"][frame], (self.x)-16, (self.y)-16,
					   math.rad(self.angle), 1, 1, self.width/2, self.height/2)
end

function Vine.update(self, map, dt)
	if self.depth <= 0 then
		--self:despawn(map)
		return
	end	
	
	if self.spriteTimer == 10 then
		table.insert(map.effects, Smoke(self.x-math.cos(math.rad(self.angle+45))*21,
								        self.y-math.sin(math.rad(self.angle+45))*21))
		table.insert(map.effects, Smoke(self.x-math.cos(math.rad(self.angle+45))*21,
								        self.y-math.sin(math.rad(self.angle+45))*21))
		table.insert(map.effects, Smoke(self.x-math.cos(math.rad(self.angle+45))*21,
								        self.y-math.sin(math.rad(self.angle+45))*21))
		--table.insert(map.enemies, Vine(self.x+16-math.cos(math.rad(self.angle+45))*19,
		--						       self.y+16-math.sin(math.rad(self.angle+45))*19, self.angle, self.depth-2))
		table.insert(map.enemies, Vine(self.x+16-math.cos(math.rad(self.angle+45))*19,
								       self.y+16-math.sin(math.rad(self.angle+45))*19, self.angle, self.depth-1))
		
	end
	if self.spriteTimer <= 10 then
		self.spriteTimer = self.spriteTimer + 1
	end
	
	--[[
	if self.angle > 360 then
		self.angle = 0
	else
		self.angle = self.angle + 1
	end
	--]]
	
end

function Vine.knockback(self)
	--
end

function Vine.damage(self)
	self.health = self.health - 1

	if self.health <= 0 then
		self.health = 0
		self:despawn(map)

		if knight.isGrabbing and knight.grabbedEnemy == self then
			knight.isGrabbing = false
			knight.grabbedEnemy = nil
		end
	end
end