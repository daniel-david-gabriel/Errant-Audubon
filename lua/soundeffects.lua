SoundEffects = {}
SoundEffects.__index = SoundEffects

setmetatable(SoundEffects, {
  __index = SoundEffects,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function SoundEffects:_init()
	self.soundEffects = {}

	self.soundEffects["menu"] = love.audio.newSource("media/soundEffects/191754__fins__button-5.wav", "static")
	self.soundEffects["item"] = love.audio.newSource("media/soundEffects/146723__fins__coin-object.wav", "static")
	self.soundEffects["jump"] = love.audio.newSource("media/soundEffects/146726__fins__jumping.wav", "static")
end

function SoundEffects.playSoundEffect(self, name)
	if not options.sound then
		return
	end

	local soundEffect = self.soundEffects[name]
	if not soundEffect:isStopped() then
		soundEffect:stop()
	end	
	soundEffect:play()
end
