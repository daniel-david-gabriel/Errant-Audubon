require("lua/sprites/projectile")

Bullet = {}
Bullet.__index = Bullet


setmetatable(Bullet, {
  __index = Projectile,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Bullet:_init(x, y, direction)
	Projectile._init(self, x, y, 16, 16, direction, "bullet")
end
