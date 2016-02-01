require("lua/save")

GameMenu = {}
GameMenu.__index = GameMenu

setmetatable(GameMenu, {
  __index = GameMenu,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function GameMenu:_init()
	self.background = love.graphics.newImage("media/menu/gameMenu.png")

	self.cursor = "journal"

	self.tools = {}
	self.tools["item1"] = nil
	self.tools["item2"] = nil
	self.tools["item3"] = nil
	self.tools["item4"] = nil
	self.tools["item5"] = nil
	self.tools["item6"] = nil
	self.tools["item7"] = nil
	self.tools["item8"] = nil
end

function GameMenu.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.background, 0, 0)

	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle("fill", 20, 20, 750 * (knight.health/100), 50)

	if not (knight.tool == nil) then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(images:getImage(knight.tool.imageName), 100, 130)
	end

	if not (knight.subtool == nil) then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(images:getImage(knight.subtool.imageName), 300, 130)
	end

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(knight.money, 700, 130, 0, 2, 2)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Journal", 500, 130, 0, 2, 2)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Save", 500, 180, 0, 2, 2)

	local x = 50
	local i = 1
	for index,tool in pairs(knight.tools) do
		local image = images:getImage(tool.imageName)
		love.graphics.draw(image, x, 350)
		x = x + 200
		self.tools["item" .. i] = index
		i = i + 1
	end

	if self.cursor == "journal" then
		love.graphics.rectangle("fill", 475, 130, 10, 10)
	elseif self.cursor == "save" then
		love.graphics.rectangle("fill", 475, 180, 10, 10)
	elseif self.cursor == "item1" then
		love.graphics.rectangle("fill", 25, 350, 10, 10)
	elseif self.cursor == "item2" then
		love.graphics.rectangle("fill", 225, 350, 10, 10)
	elseif self.cursor == "item3" then
		love.graphics.rectangle("fill", 425, 350, 10, 10)
	elseif self.cursor == "item4" then
		love.graphics.rectangle("fill", 625, 350, 10, 10)
	elseif self.cursor == "item5" then
		love.graphics.rectangle("fill", 25, 450, 10, 10)
	elseif self.cursor == "item6" then
		love.graphics.rectangle("fill", 225, 450, 10, 10)
	elseif self.cursor == "item7" then
		love.graphics.rectangle("fill", 425, 450, 10, 10)
	elseif self.cursor == "item8" then
		love.graphics.rectangle("fill", 625, 450, 10, 10)
	end

	
end

function GameMenu.keypressed(self, key)
	if key == keyBindings:getMenu() then
		toState = game
	elseif key == keyBindings:getTool() then
		if self.cursor == "journal" then
			print("journal menu here")
		elseif self.cursor == "save" then
			local save = Save("save.dat")
			save:save(knight)
		else
			print("item slot")
			--print(self.cursor)
			--print(self.tools[self.cursor])
			--more better stuff here
			knight.tool = knight.tools[self.tools[self.cursor]]
		end
	elseif key == keyBindings:getSubtool() then
		print("subtool pressed")
		knight.subtool = knight.tools["glove"]
	elseif key == keyBindings:getDown() then
		self:goDown()
	elseif key == keyBindings:getUp() then
		self:goUp()
	elseif key == keyBindings:getLeft() then
		self:goLeft()
	elseif key == keyBindings:getRight() then
		self:goRight()
	end
end

function GameMenu.keyreleased(self, key)
	--
end

function GameMenu.mousepressed(self, x, y, button)
	--
end

function GameMenu.update(self, dt)
	--
end

--wow is this the most bone-headed way to do it...
function GameMenu.goDown(self)
	if self.cursor == "journal" then
		self.cursor = "save"
	elseif self.cursor == "save" then
		self.cursor = "item1"
	elseif self.cursor == "item1" then
		self.cursor = "item5"
	elseif self.cursor == "item2" then
		self.cursor = "item6"
	elseif self.cursor == "item3" then
		self.cursor = "item7"
	elseif self.cursor == "item4" then
		self.cursor = "item8"
	elseif self.cursor == "item5" then
		self.cursor = "journal"
	elseif self.cursor == "item6" then
		self.cursor = "journal"
	elseif self.cursor == "item7" then
		self.cursor = "journal"
	elseif self.cursor == "item8" then
		self.cursor = "journal"
	end
end

function GameMenu.goUp(self)
	if self.cursor == "journal" then
		self.cursor = "item8"
	elseif self.cursor == "save" then
		self.cursor = "journal"
	elseif self.cursor == "item1" then
		self.cursor = "save"
	elseif self.cursor == "item2" then
		self.cursor = "save"
	elseif self.cursor == "item3" then
		self.cursor = "save"
	elseif self.cursor == "item4" then
		self.cursor = "save"
	elseif self.cursor == "item5" then
		self.cursor = "item1"
	elseif self.cursor == "item6" then
		self.cursor = "item2"
	elseif self.cursor == "item7" then
		self.cursor = "item3"
	elseif self.cursor == "item8" then
		self.cursor = "item4"
	end
end

function GameMenu.goLeft(self)
	if self.cursor == "journal" then
		self.cursor = "journal"
	elseif self.cursor == "save" then
		self.cursor = "save"
	elseif self.cursor == "item1" then
		self.cursor = "item4"
	elseif self.cursor == "item2" then
		self.cursor = "item1"
	elseif self.cursor == "item3" then
		self.cursor = "item2"
	elseif self.cursor == "item4" then
		self.cursor = "item3"
	elseif self.cursor == "item5" then
		self.cursor = "item8"
	elseif self.cursor == "item6" then
		self.cursor = "item5"
	elseif self.cursor == "item7" then
		self.cursor = "item6"
	elseif self.cursor == "item8" then
		self.cursor = "item7"
	end
end

function GameMenu.goRight(self)
	if self.cursor == "journal" then
		self.cursor = "journal"
	elseif self.cursor == "save" then
		self.cursor = "save"
	elseif self.cursor == "item1" then
		self.cursor = "item2"
	elseif self.cursor == "item2" then
		self.cursor = "item3"
	elseif self.cursor == "item3" then
		self.cursor = "item4"
	elseif self.cursor == "item4" then
		self.cursor = "item1"
	elseif self.cursor == "item5" then
		self.cursor = "item6"
	elseif self.cursor == "item6" then
		self.cursor = "item7"
	elseif self.cursor == "item7" then
		self.cursor = "item8"
	elseif self.cursor == "item8" then
		self.cursor = "item1"
	end
end
