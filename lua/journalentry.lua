JournalEntry = {}
JournalEntry.__index = JournalEntry

setmetatable(JournalEntry, {
  __index = JournalEntry,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function JournalEntry:_init(name, goodInformation, badInformation, numberKilled)
	self.name = name
	self.goodInformation = goodInformation
	self.badInformation = badInformation
	self.numberKilled = numberKilled
end

-- Used for saving
function JournalEntry.toString(self)
	return self.name .. " " .. self.goodInformation .. " " .. self.badInformation .. " " .. self.numberKilled .. "\r\n"
end

function JournalEntry.addKill(self)
	self.numberKilled = self.numberKilled + 1
end

function JournalEntry.addGoodCommon(self)
	if (self.goodInformation % 2) == 0 then
		self.goodInformation = self.goodInformation + 1
	end
end

function JournalEntry.addGoodUncommon(self)
	if (self.goodInformation % 4) == 0 then
		self.goodInformation = self.goodInformation + 2
	end
end

function JournalEntry.addGoodRare(self)
	if (self.goodInformation % 8) == 0 then
		self.goodInformation = self.goodInformation + 4
	end
end
