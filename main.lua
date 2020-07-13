function love.load()
  -- Screen
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.window.setMode(640, 360, {fullscreen = true})

  -- Modules
  json = require("json")
  player = require("player")
  
  -- Transforms
  transform = love.math.newTransform()
  transform:scale(1, .5)
  transform:rotate(math.rad(45))
  transform:scale(math.sin(math.rad(45)) * 64, math.sin(math.rad(45)) * 64)

  objects = {}

  -- Players
  players = {
    player:new("red", transform),
    player:new("blue", transform),
    player:new("cyan", transform),
    player:new("green", transform)
  }

  for i=1, #players do
    table.insert(objects, players[i])
  end

  -- Key Bindings
  keys = {
    w = {player = players[1], func = "decrementYHeading"},
    a = {player = players[1], func = "decrementXHeading"},
    s = {player = players[1], func = "incrementYHeading"},
    d = {player = players[1], func = "incrementXHeading"},
    q = {player = players[1], func = "punch"},

    i = {player = players[2], func = "decrementYHeading"},
    j = {player = players[2], func = "decrementXHeading"},
    k = {player = players[2], func = "incrementYHeading"},
    l = {player = players[2], func = "incrementXHeading"},
    u = {player = players[2], func = "punch"},

    up = {player = players[3], func = "decrementYHeading"},
    left = {player = players[3], func = "decrementXHeading"},
    down = {player = players[3], func = "incrementYHeading"},
    right = {player = players[3], func = "incrementXHeading"},
    rctrl = {player = players[3], func = "punch"},

    kp8 = {player = players[4], func = "decrementYHeading"},
    kp4 = {player = players[4], func = "decrementXHeading"},
    kp5 = {player = players[4], func = "incrementYHeading"},
    kp6 = {player = players[4], func = "incrementXHeading"},
    kp0 = {player = players[4], func = "punch"}
  }

  -- Map generation
  map = {
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
    { 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
    { 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
    { 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  }
  
  floor = {}
  blocks = {}
  for y = 1, #map do
    for x = 1, #map[1] do
      if map[y][x] > 0 then
        local mapFloor = {}
        local objectX = (x - (#map[1] / 2) - .5)
        local objectY = (y - (#map / 2) - .5)
        mapFloor.position = {x = objectX, y = objectY}
        mapFloor.type = "floor"
        table.insert(floor, mapFloor)
        table.insert(objects, mapFloor)
        
        if map[y][x] > 1 then
          local mapBlock = {}
          mapBlock.position = { x = objectX, y = objectY }
          mapBlock.type = "block"
          table.insert(blocks, mapBlock)
          table.insert(objects, mapBlock)
        end
      end
    end
  end

  --tile = love.graphics.newImage('floor.png')
  tile = love.graphics.newImage('metalic_tile.png')

  red = 88 / 250
  green = 202 / 250
  blue = 202 / 250
  color = {red, green, blue}
  love.graphics.setBackgroundColor(color)
end

function love.update(dt)
  -- Player associated key press
  for key, value in pairs(keys) do
    if love.keyboard.isDown(key) then
      value.player[value.func](value.player)
    end
  end

  -- Player update
  for key, value in pairs(players) do
    value:updateAnimation(dt)
    value:updatePosition(objects, dt)
  end

end

function love.draw()
  love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  love.graphics.scale(5, 5)

  -- Generates the arena
  for i = 1, #floor do
    local floorPos = floor[i].position
    -- Bad programmer, don't use magic numbers, BAD
    local floorX, floorY = transform:transformPoint(floorPos.x, floorPos.y)
    love.graphics.draw(tile, floorX - 32, floorY - 16)
  end

  for key, value in pairs(players) do
    value:draw()
  end

end

function love.keypressed(key, u)
  if key == 'escape' then
    love.event.quit()
  end
end


