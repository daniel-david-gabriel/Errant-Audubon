require("lua/sprites/projectile")

Arrow = {}
Arrow.__index = Arrow


setmetatable(Arrow, {
  __index = Projectile,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Arrow:_init(x, y, direction)
	Projectile._init(self, x, y, 16, 16, direction, "arrow")
end
