require("lua/sprites/sprite")

Glove = {}
Glove.__index = Glove


setmetatable(Glove, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Glove:_init()
	Sprite._init(self, 0, 0, 32, 32)

	self.sfx = "jump"

	self.imageName = "glove"
	self.beingUsed = false
end

function Glove.use(self, knight)
	self.beingUsed = true
end

function Glove.draw(self)
	--
end

function Glove.update(self, dt)
	if self.beingUsed then
		if knight.isGrabbing then
			self:release()
		else
			self:grab()
		end
	end
	self.beingUsed = false
end

function Glove.grab(self)
	for i,enemy in pairs(map.enemies) do
		
		if self:isInRange(enemy) and enemy.size == "large" then
			soundEffects:playSoundEffect(self.sfx)
			knight.isGrabbing = true
			knight.grabbedEnemy = enemy
			return
		elseif self:isInRange(enemy) and enemy.size == "small" then
			soundEffects:playSoundEffect(self.sfx)
			knight.isGrabbing = true
			knight.grabbedEnemy = enemy
			return
		end
	end
end

function Glove.release(self)
	soundEffects:playSoundEffect(self.sfx)
	if knight.grabbedEnemy.size == "small" then
		if map:canMove(knight.grabbedEnemy, knight.facingDirection, 64) then
			knight.grabbedEnemy:move(knight.facingDirection, 64)
		end
	elseif knight.grabbedEnemy.size == "large" then
		if map:canMove(knight, knight.facingDirection, 64) then
			knight:move(knight.facingDirection, 64)
		end
	end

	knight.isGrabbing = false
	knight.grabbedEnemy = nil
end

function Glove.isInRange(self, enemy)
	local xWithinRange = math.abs(knight.x - enemy.x) < 96
	local yWithinRange = math.abs(knight.y - enemy.y) < 96

	return (xWithinRange and yWithinRange)
end
