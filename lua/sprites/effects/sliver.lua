require("lua/sprites/sprite")
require("lua/images")
require("lua/sprites/effects/slivershine")

Sliver = {}
Sliver.__index = Sliver


setmetatable(Sliver, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Sliver:_init(x, y)
	Sprite._init(self, x, y, 32, 32)

    self.spriteName = "Sliver"

	self.angle = 0
	
	self.x_vel = math.random(5) - 3
	self.y_vel = (math.random(3) - 2)/4
	self.y_offset_vel = 3
	self.height = -3
	self.y_offset = self.height
	
	self.despawn_counter = 0
end

function Sliver.draw(self)

	if options.debug then
		love.graphics.setColor(255, 0, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
    
	love.graphics.setColor(0, 100, 100, 128)
	love.graphics.ellipse("fill", self.x-16, self.y-16, 6, 3)
	
    love.graphics.setColor(255, 255, 255, 255)
    local sprites = images:getImage(self.spriteName)
	love.graphics.draw(sprites["image"], sprites["quads"][1], self.x-16, self.y-12+self.y_offset, self.angle, 1, 1, 8, 8)
	
end

function Sliver.update(self, dt)
	if math.random(10) == 1 then
		table.insert(map.effects, SliverShine(self.x-16+math.random()*16, self.y-12+self.y_offset))
	end
	if self.angle > math.pi*2 then
		self.angle = 0
	else
		self.angle = self.angle + math.pi*(1/15)
	end
    
	if self.y_offset_vel > self.height then
		if self.x_vel < 0 then
			self:move("left", math.abs(self.x_vel))
		else
			self:move("right", self.x_vel)
		end
		if self.y_vel < 0 then
			self:move("up", math.abs(self.y_vel))
		else
			self:move("down", self.y_vel)
		end
		self.y_offset = self.y_offset - self.y_offset_vel
		self.y_offset_vel = self.y_offset_vel - 0.05
		if self.x_vel > 0 then
			self.x_vel = self.x_vel - 0.01
		end
		if self.x_vel < 0 then
			self.x_vel = self.x_vel + 0.01
		end
	else
		self.despawn_counter = self.despawn_counter + 1
		self.y_offset = 0
		self.y_offset_vel = 2
		self.height = -2
	end
    
	if self:collidesWith(knight) and self.height == -2 then
		self:despawn(map)
		soundEffects:playSoundEffect("item")
    end
    
    if self.despawn_counter >= 20 then
		self:despawn(map)
    end
    
end

function Sliver.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end
