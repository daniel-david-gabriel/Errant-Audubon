require("lua/journalentry")

Save = {}
Save.__index = Save

setmetatable(Save, {
  __index = Save,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Save:_init(saveFile)
	self.saveFilename = saveFile
end

function Save.save(self, knight)
	local saveData = ""

	saveData = saveData .. "MONEY " .. knight.money .. "\r\n"
	saveData = saveData .. "AREA " .. knight.area .. "\r\n"
	saveData = saveData .. "JOURNAL\r\n"
	for name,entry in pairs(knight.journal) do
		saveData = saveData .. entry:toString()
	end
	saveData = saveData .. "FLAGS\r\n"
	for name,entry in pairs(knight.flags) do
		saveData = saveData .. name .. " " .. entry .. "\r\n"
	end

	love.filesystem.write(self.saveFilename, saveData)
end


function Save.load(self)
	local loadData = love.filesystem.lines(self.saveFilename)
	local knight = Knight()

	local loadJournal = false
	local loadFlags = false

	for line in loadData do
		local lineTokens = split(line, "%S+")
		if lineTokens[1] == "MONEY" then
			knight.money = tonumber(lineTokens[2])
		elseif lineTokens[1] == "AREA" then
			knight.area = tonumber(lineTokens[2])
		elseif lineTokens[1] == "JOURNAL" then
			loadJournal = true
			loadFlags = false
		elseif lineTokens[1] == "FLAGS" then
			loadFlags = true
			loadJournal = false
		else
			if loadJournal then
				knight.journal[lineTokens[1]] = JournalEntry(lineTokens[1], tonumber(lineTokens[2]), tonumber(lineTokens[3]), tonumber(lineTokens[4]))
			end

			if loadFlags then
				knight.flags[lineTokens[1]] = tonumber(lineTokens[2])
			end
		end
		
	end

	return knight
	
end
