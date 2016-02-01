Shop = {}
Shop.__index = Shop

setmetatable(Shop, {
  __index = Shop,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Shop:_init()
	self.dialogText = {}
	self.dialogTextCounter = 1
	self.portraitName = nil
	self.name = nil
	
	self.state = "dialog"
	self.items = {}
end

function Shop.set(self, name, portraitName, dialogText, items)
	self.dialogTextCounter = 1
	self.dialogText = dialogText
	self.portraitName = portraitName
	self.name = name
	self.items = items
	self.selectedItem = 1
end

function Shop.reset(self)
	self.dialogText = {}
	self.dialogTextCounter = 1
	self.portraitName = nil
	self.name = nil
	
	self.state = "dialog"
	self.items = {}
	self.selectedItem = 1
end

function Shop.isSet(self)
	return table.getn(self.dialogText) > 0
end

function Shop.draw(self)
	if self.state == "dialog" then
		love.graphics.setColor(0, 0, 0, 128)
		love.graphics.rectangle("fill", 0, 400, 800, 600)
	
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(portraits:getPortrait(self.portraitName), 10, 410)
	
		love.graphics.setColor(255, 96, 96, 255)
		love.graphics.print(self.name, 276, 410)
	
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf(self.dialogText[self.dialogTextCounter], 276, 430, 500, "left")
	elseif self.state == "storefront" then
		love.graphics.setColor(0, 0, 0, 128)
		love.graphics.rectangle("fill", 0, 0, 800, 600)
		
		for i,item in pairs(self.items) do
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(item.icon, 50, 10 + (50*i-1))
			love.graphics.print(item.name, 90,10 + (50*i-1))
		end
		
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("fill", 20, 10 + (50*self.selectedItem-1), 25, 25)
		
		love.graphics.setColor(0, 0, 0, 128)
		love.graphics.rectangle("fill", 0, 400, 800, 600)
		
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(portraits:getPortrait(self.portraitName), 10, 410)
	
		love.graphics.setColor(255, 96, 96, 255)
		love.graphics.print(self.name, 276, 410)
	
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf(self.items[self.selectedItem].description, 276, 430, 500, "left")
	end
end

function Shop.update(self, dt)
	if self.state == "dialog" then
		if self.dialogTextCounter == table.getn(self.dialogText) + 1 then
			self.state = "storefront"
		end
	end
	
	if self.state == "leaving" then
		self:reset()
	end
end

function Shop.keypressed(self, key)
	if self.state == "dialog" then
		if key == keyBindings:getTool() then
			self.dialogTextCounter = self.dialogTextCounter + 1
		end
	elseif self.state == "storefront" then
		if key == keyBindings:getSubtool() then
			self.state = "leaving"
		elseif key == keyBindings:getUp() then
			self.selectedItem = self.selectedItem - 1
			if self.selectedItem < 1 then
				self.selectedItem = table.getn(self.items)
			end
		elseif key == keyBindings:getDown() then
			self.selectedItem = self.selectedItem + 1
			if self.selectedItem > table.getn(self.items) then
				self.selectedItem = 1
			end
		elseif key == keyBindings:getTool() then
			if self.items[self.selectedItem]:buy() then
				print("Remove item from store")
				table.remove(self.items, self.selectedItem)	
				if table.getn(self.items) < self.selectedItem then
					self.selectedItem = table.getn(self.items)
				end
				if table.getn(self.items) == 0 then
					self.state = "leaving"
				end
			else
				print("Make buzzing sound?")
			end
		end
	end
end
