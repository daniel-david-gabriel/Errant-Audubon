Persistence = {}
Persistence.__index = Persistence

setmetatable(Persistence, {
  __index = Persistence,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Persistence:_init(filename)
    if not filename then
        love.errhand("All persistence objects must have an associated file.")
    end

    self.json = require("lua/persistence/json")

    self.filename = filename
    self.data = {}
end

function Persistence.save(self, filename)
    local fileToSave
    if not filename then
        fileToSave = self.filename
    else
        fileToSave = filename
    end

    local jsonString = self:toJSON(self.data)

    --print(jsonString)
    local success = love.filesystem.write(fileToSave, jsonString)
    if not success then
        love.errhand("Failed to save file: " .. fileToSave)
    end
end

function Persistence.toJSON(self, object)
    return self.json.stringify(self.data)
end

function Persistence.load(self, filename)
    local fileToLoad
    if not filename then
        fileToLoad = self.filename
    else
        fileToLoad = filename
    end

    local jsonString,size = love.filesystem.read(fileToLoad)
    if size < 1 then
        love.errhand("Failed to load file: " .. fileToLoad)
    end

    local data = self:fromJSON(jsonString)
    self.data = data

    --print(self:toJSON(data))
end

function Persistence.fromJSON(self, jsonString)
    return self.json.parse(jsonString)
end
