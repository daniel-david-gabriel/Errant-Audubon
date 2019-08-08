Music = {}
Music.__index = Music

setmetatable(Music, {
  __index = Music,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Music:_init()
	self.music = {}

	self.music["title"] = love.audio.newSource("media/music/Title Theme.ogg", "stream")
	self.music["title"]:setLooping(true)

	self.music["mystery"] = love.audio.newSource("media/music/Island of Mystery.ogg", "stream")
	self.music["mystery"]:setLooping(true)

	self.music["cave"] = love.audio.newSource("media/music/Cave.ogg", "stream")
	self.music["cave"]:setLooping(true)
	
	self.music["nexus"] = love.audio.newSource("media/music/OceanWaves.ogg", "stream")
	self.music["nexus"]:setLooping(true)

	self.currentSong = ""
end

function Music.playMusic(self, songName)
	if not options.sound then
		return
	end

	local song = self.music[songName]

	if self.currentSong == song then
		return
	end

	if self.currentSong ~= "" then
		self.currentSong:stop()
	end

	song:play()
	self.currentSong = song
end
