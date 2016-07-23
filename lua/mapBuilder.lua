require("lua/tiles")

MapBuilder = {}
MapBuilder.__index = MapBuilder

setmetatable(MapBuilder, {
  __index = MapBuilder,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

tilesets = {
    "cave",
    "field",
    "interior",
    "town"
}
tileCounter = 1
tileset = tilesets[tileCounter]

layers = {
    "map",
    "foreground"
}
layerCounter = 1
layer = layers[layerCounter]

function MapBuilder._init()
    tiles = Tiles()
    
    map = {}
    local x = 1
    local y = 1
    if love.filesystem.exists("map") then
        local mapData = love.filesystem.lines("map")
        for line in mapData do
            map[y] = {}
            x = 1
            -- string.match?
            for tile in string.gmatch (line, "%d+") do
                map[y][x] = tile
                x = x + 1
            end
            y = y +1
        end
    else
        for i=1,19 do
            map[y] = {}
            x = 1
            for j=1,25 do
                map[y][x] = 1
                x = x + 1
            end
            y = y+1
        end
    end

    foreground = {}
    x = 1
    y = 1
    if love.filesystem.exists("foreground") then
        local mapData = love.filesystem.lines("foreground")
        for line in mapData do
            foreground[y] = {}
            x = 1
            -- string.match?
            for tile in string.gmatch (line, "%d+") do
                foreground[y][x] = tile
                x = x + 1
            end
            y = y +1
        end
    else
        for i=1,19 do
            foreground[y] = {}
            x = 1
            for j=1,25 do
                foreground[y][x] = 1
                x = x + 1
            end
            y = y+1
        end
    end
    
    if love.filesystem.exists("tileset") then
        local tsData = love.filesystem.lines("tileset")
        for line in tsData do
            tileset = line
        end
    end

    currentTile = 1
end

function MapBuilder.draw(self)
    --draw menu
    local x = 800
    local y = 0
    for tile,v in pairs(tiles.tilesets[tileset].tiles) do
        love.graphics.setColor(255,0,0,255)
        love.graphics.line(x,0,x,600)
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(tiles:getTileSet(tileset), tiles:getTile(tileset, tile), x, y)
        x = x + 32
        if x > 1280 then
            love.graphics.setColor(255,0,0,255)
            love.graphics.line(800,y,1312,y)
            love.graphics.setColor(255,255,255,255)
            x = 800
            y = y +32
        end
    end

    --draw map
    x = 0
    y = 0
    for i=1,19 do
        for j=1,25 do
            love.graphics.draw(tiles:getTileSet(tileset), tiles:getTile(tileset, map[i][j]), x, y)
            x = x + 32
            if x > 768 then
                x = 0
                y = y +32
            end
        end
    end

    --draw foreground
    x = 0
    y = 0
    for i=1,19 do
        for j=1,25 do
            local tile = foreground[i][j]
            if not (tile == "1") and not (tile == 1) then
                love.graphics.draw(tiles:getTileSet(tileset), tiles:getTile(tileset, tile), x, y)
            end
            x = x + 32
            if x > 768 then
                x = 0
                y = y +32
            end
        end
    end
    
    --draw cursor
    local mouseX, mouseY = love.mouse.getPosition( )
    local xFloor = math.floor(mouseX/32)
    local yFloor = math.floor(mouseY/32)
    love.graphics.setColor(255,255,255,128)
    love.graphics.rectangle("fill", xFloor*32, yFloor*32, 32, 32)

    love.graphics.setColor(255,255,255,255)
    love.graphics.print(layer, 10, 10)
end

function MapBuilder.keypressed(self, key)
    if key == "escape" then
        love.event.push("quit")
    end

    if key == "return" then
        local saveData = ""

        for i=1,19 do
            for j=1,25 do
                saveData = saveData .. map[i][j] .. " "
            end
            saveData = saveData .. "\r\n"
        end
        love.filesystem.write("map", saveData)

        saveData = ""

        for i=1,19 do
            for j=1,25 do
                saveData = saveData .. foreground[i][j] .. " "
            end
            saveData = saveData .. "\r\n"
        end
        love.filesystem.write("foreground", saveData)
        
        love.filesystem.write("tileset", tileset)
    end

    if key == "m" then
        tileCounter = tileCounter + 1
        if tileCounter > table.getn(tilesets) then
            tileCounter = 1
        end
        tileset = tilesets[tileCounter]
    end
end

function MapBuilder.keyreleased(self, key)
    --
end

function MapBuilder.mousepressed(self, x, y, button)
    if x > 800 then
        local xFloor = math.floor(x/32)
        local yFloor = math.floor(y/32)
        local myX = 800
        local myY = 0
        for tile,v in pairs(tiles.tilesets[tileset].tiles) do
            if math.floor(myX/32) == xFloor then
                if math.floor(myY/32) == yFloor then
                    currentTile = tile
                    print(currentTile)
                end
            end

            myX = myX + 32
            if myX > 1280 then
                myX = 800
                myY = myY +32
            end
        end
    end
end

function MapBuilder.wheelmoved(self, x, y)
    if y > 0 then
        layerCounter = layerCounter + 1
        if layerCounter > table.getn(layers) then
            layerCounter = 1
        end
        layer = layers[layerCounter]
    else
        layerCounter = layerCounter - 1
        if layerCounter < 1 then
            layerCounter = table.getn(layers)
        end
        layer = layers[layerCounter]
    end
end

function MapBuilder.update(self, dt)

    if love.mouse.isDown(1) then
        local x,y = love.mouse.getPosition( )
    
        if layer == "map" then
            local xFloor = math.floor(x/32)+1
            local yFloor = math.floor(y/32)+1

            map[yFloor][xFloor] = currentTile

            print("X: " .. xFloor .. ", Y: " .. yFloor)
        else
            local xFloor = math.floor(x/32)+1
            local yFloor = math.floor(y/32)+1

            foreground[yFloor][xFloor] = currentTile
        end
    end

end

return MapBuilder()
