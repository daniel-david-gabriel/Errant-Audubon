Options = {}
Options.__index = Options


setmetatable(Options, {
  __index = Options,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Options:_init()
	self.displayFPS = true --should default to false?
	self.sound = false
	self.debug = true
end
