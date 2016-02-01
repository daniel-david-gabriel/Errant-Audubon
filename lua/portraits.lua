Portraits = {}
Portraits.__index = Portraits


setmetatable(Portraits, {
  __index = Portraits,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Portraits:_init()
	--can probably make this look better. Like take a list of string and load the table in a loop.

	self.portraits = {}
	self.portraits["lucinda"] = love.graphics.newImage("media/portrait/lucinda.png")
	self.portraits["marcy"] = love.graphics.newImage("media/portrait/marcy.png")
	self.portraits["yome"] = love.graphics.newImage("media/portrait/yome.png")
	self.portraits["bird-knight"] = love.graphics.newImage("media/portrait/bird-knight.png")
	self.portraits["apothecary"] = love.graphics.newImage("media/portrait/apothecary.png")
	self.portraits["necromancer"] = love.graphics.newImage("media/portrait/necromancer.png")
end

function Portraits.getPortrait(self, portraitName)
	return self.portraits[portraitName]
end
