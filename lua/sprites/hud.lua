Hud = {}
Hud.__index = Hud


setmetatable(Hud, {
  __index = Hud,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Hud:_init()
	self.healthAlpha = 255
	self.healthFade = true

	self.toolAlpha = 255
	self.toolFade = true
	self.toolFadeTimer = 0
end

function Hud.draw(self, knight)
	love.graphics.setColor(255, 255, 255, self.healthAlpha)
	love.graphics.draw(love.graphics.newImage("media/menu/hud.png"), 0, 0)

	love.graphics.setColor(255, 0, 0, self.healthAlpha)
	love.graphics.rectangle("fill", 15, 15, 2 * knight.health, 20)

	love.graphics.setColor(0, 0, 0, self.toolAlpha)
	love.graphics.rectangle("fill", 670, 15, 40, 40)
	if knight.subtool then
		love.graphics.setColor(255, 255, 255, self.toolAlpha)
		love.graphics.draw(images:getImage(knight.subtool.imageName), 670, 15)
	end

	love.graphics.setColor(0, 0, 0, self.toolAlpha)
	love.graphics.rectangle("fill", 720, 15, 60, 60)
	if knight.tool then
		love.graphics.setColor(255, 255, 255, self.toolAlpha)
        local image = images:getImage(knight.tool.imageName)
        love.graphics.draw(image, 720, 15, 0, 2, 2)
		--love.graphics.draw(images:getImage(knight.tool.imageName), 720, 15, 0, 2, 2)
	end
end

function Hud.update(self, dt, knight)
	if knight.health == 100 then
		self.healthFade = true
	else
		self.healthFade = false
		
	end

	if self.healthFade then
		self.healthAlpha = self.healthAlpha - 8
		if self.healthAlpha < 0 then
			self.healthAlpha = 0
		end
	else
		self.healthAlpha = 255
	end

	if knight.toolPressed or knight.subtoolPressed then
		self.toolFade = false
		self.toolFadeTimer = 0
	else
		self.toolFadeTimer = self.toolFadeTimer + dt
		if self.toolFadeTimer > 5 then
			self.toolFade = true
		end
	end

	
	if self.toolFade then
		self.toolAlpha = self.toolAlpha - 8
		if self.toolAlpha < 0 then
			self.toolAlpha = 0
		end
	else
		self.toolAlpha = 255
	end
end
