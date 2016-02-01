Dialog = {}
Dialog.__index = Dialog

setmetatable(Dialog, {
  __index = Dialog,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Dialog:_init()
	self.dialogText = {}
	self.dialogTextCounter = 1
	self.portraitName = nil
	self.name = nil
end

function Dialog.set(self, name, portraitName, dialogText)
	self.dialogTextCounter = 1
	self.dialogText = dialogText
	self.portraitName = portraitName
	self.name = name
end

function Dialog.reset(self)
	self.dialogText = {}
	self.dialogTextCounter = 1
	self.portraitName = nil
	self.name = nil
end

function Dialog.isSet(self)
	return table.getn(self.dialogText) > 0
end

function Dialog.draw(self)
	love.graphics.setColor(0, 0, 0, 128)
	love.graphics.rectangle("fill", 0, 400, 800, 600)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(portraits:getPortrait(self.portraitName), 10, 410)

	love.graphics.setColor(255, 96, 96, 255)
	love.graphics.print(self.name, 276, 410)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf(self.dialogText[self.dialogTextCounter], 276, 430, 500, "left")
end

function Dialog.update(self, dt)
	if self.dialogTextCounter == table.getn(self.dialogText) + 1 then
		self:reset()
	end
end

function Dialog.keypressed(self, key)
	if key == keyBindings:getTool() then
		self.dialogTextCounter = self.dialogTextCounter + 1
	end
end
