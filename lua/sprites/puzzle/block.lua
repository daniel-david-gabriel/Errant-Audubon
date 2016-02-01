require("lua/sprites/sprite")

Block = {}
Block.__index = Block


setmetatable(Block, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Block:_init(x, y)
	Sprite._init(self, x, y, 32, 32)
	self.type = "block"
	self.locked = false
end

function Block.draw(self)
	if options.debug then
		love.graphics.setColor(0, 0, 0, 128)
		love.graphics.rectangle("fill", (self.x)-36, (self.y)-36, 40, 40)
		love.graphics.setColor(128, 255, 255, 255)
		love.graphics.rectangle("fill", (self.x)-32, (self.y)-32, 32, 32)
	end
end

function Block.update(self, dt)
	if self.locked then
		return
	end

	local pushSprite = Sprite(self.x-4, self.y-4, 40, 40)
	
	if pushSprite:collidesWith(knight) then
		if knight.facingDirection == "right" then
			self:move("right", 2)
		elseif knight.facingDirection == "left" then
			self:move("left", 2)
		elseif knight.facingDirection == "up" then
			self:move("up", 2)
		elseif knight.facingDirection == "down" then
			self:move("down", 2)
		end
	end
end