require("lua/map/map")

Sprite = {}
Sprite.__index = Sprite

setmetatable(Sprite, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Sprite:_init(x, y, width, height)
	self.x = x
	self.y = y	

	self.width = width
	self.height = height
end

function Sprite.move(self, direction, speed)
	local newX = self.x
	local newY = self.y

	if direction == "up" then
		newY = newY - speed
	elseif direction == "down" then
		newY = newY + speed
	elseif direction == "left" then
		newX = newX - speed
	elseif direction == "right" then
		newX = newX + speed
	end

	if not map:canMove(self, direction, speed) then
		return false
	end
	
	local collisionSprite = Sprite(newX, newY, 32, 32)
	if self == knight then
		for k,enemy in pairs(map.enemies) do
			if (not Enemy.isGrabbed(enemy)) and collisionSprite:collidesWith(enemy) then
				return false
			end
		end
	end
	
	--can't move into npcs
	for k,npc in pairs(map.npcs) do
		if collisionSprite:collidesWith(npc) then
			return false
		end
	end
	
	--can't move into locked doors
	for k,lock in pairs(map.locks) do
		if collisionSprite:collidesWith(lock) then
			return false
		end
	end
	
	--can't move into blocks
	for k,puzzle in pairs(map.puzzles) do
		if (puzzle~=self) and (puzzle.type == "block") and collisionSprite:collidesWith(puzzle) then
			return false
		end
	end
	
	self.x = newX
	self.y = newY
	
	return true
end

function Sprite.isLeftOf(self, other)
	return self.x < other.x
end

function Sprite.isRightOf(self, other)
	return self.x > other.x
end

function Sprite.isAbove(self, other)
	return self.y < other.y
end

function Sprite.isBelow(self, other)
	return self.y > other.y
end

function Sprite.xDistance(self, other)
	return math.abs((self.x + (self.width/2)) - (other.x + (other.width/2)))
end

function Sprite.yDistance(self, other)
	return math.abs((self.y + self.height/2) - (other.y + other.height/2))
end

function Sprite.collidesWith(self, other)
	--Use circles to determine collision. Lazy?

	local xDifference = self:xDistance(other)
	local yDifference = self:yDistance(other)
	
	local distance = math.sqrt(xDifference*xDifference + yDifference*yDifference)
	return distance < ((self.height/2) + (other.height/2))
end

--[[
function Sprite.collidesWith(self, other)
	--Use circles to determine collision. Lazy?

	local xDifference = math.abs((self.x + (self.width/2)) - (other.x + (other.width/2)))
	local yDifference = math.abs((self.y + self.height/2) - (other.y + other.height/2))
	
	local distance = math.sqrt(xDifference*xDifference + yDifference*yDifference)
	return distance < ((self.height/2) + (other.height/2))
end
--]]