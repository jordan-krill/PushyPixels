local screenWidth, screenHeight = love.graphics.getDimensions()
local spriteNum_testSprite = 1
local xPos_testSprite = (screenWidth / 2)
local yPos_testSprite = (screenHeight / 2)
local xPos_rate_yPos_testSprite = 1
local yPos_rate_yPos_testSprite = 1
local enemies = {}

function love.load()
  -- Screen
  screen_scalar = 3;
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.window.setMode(640, 360, {fullscreen = true})
  screenWidth, screenHeight = love.graphics.getDimensions()

  -- Modules
  json = require("json")
  player = require("player")
  
  -- Transforms
  objectTransform = love.math.newTransform()
  objectTransform:scale(1, .5)
  objectTransform:rotate(math.rad(45))

  arenaTransform = objectTransform:clone()
  arenaTransform:scale(math.sin(math.rad(45)) * 64, math.sin(math.rad(45)) * 64)

  -- Players
  players = {
    player:new("red", objectTransform),
    player:new("blue", objectTransform),
    player:new("cyan", objectTransform),
    player:new("green", objectTransform),
  }

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

  map = {
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  }

  -- Misc. sprites
  --tile = love.graphics.newImage('floor.png')
  tile = love.graphics.newImage('metalic_tile.png')
  animation_testSprite = newAnimation(love.graphics.newImage("testSprite.png"), 16, 18, 10)
  
  grid_x = math.floor(love.graphics.getWidth()/2) - math.floor(tile:getWidth()/2)
  grid_y = math.floor(love.graphics.getHeight()/2) - math.floor(tile:getHeight()/2)
  block_width = tile:getWidth()
  block_height = tile:getHeight()
  block_depth = block_height / 2
  
  for x = 1, 5 do 
      local sub_table_item = {}
      sub_table_item['animation'] = newAnimation(love.graphics.newImage("arms_red.png"), 64, 64, 1)
      sub_table_item['x_location'] = math.random(grid_x)
      sub_table_item['y_location'] = math.random(grid_y)
      enemies[x] = sub_table_item
  end

  grid_size = 12

  red = 88 / 250
  green = 202 / 250
  blue = 202 / 250
  color = {red, green, blue}
  love.graphics.setBackgroundColor(color)
end

function love.update(dt)
  updateSpritePositionDelta()

  animation_testSprite.currentTime = animation_testSprite.currentTime + dt
  if animation_testSprite.currentTime >= animation_testSprite.duration then
    animation_testSprite.currentTime = animation_testSprite.currentTime - animation_testSprite.duration
  end

  for x=1,5 do 
    enemies[x]['animation'].currentTime = enemies[x]['animation'].currentTime + dt
    if enemies[x]['animation'].currentTime >= enemies[x]['animation'].duration then
      enemies[x]['animation'].currentTime = enemies[x]['animation'].currentTime - enemies[x]['animation'].duration
    end
  end
  
  -- Player associated key press
  for key, value in pairs(keys) do
    if love.keyboard.isDown(key) then
      value.player[value.func](value.player)
    end
  end

  -- Player update
  for key, value in pairs(players) do
    value:updateAnimation(dt)
    value:updatePosition()
  end

  -- Jordan Test Sprite Update
  if not love.keyboard.isDown('w','a','s','d') then
    spriteNum_testSprite = 9
  end

 -- testSprite Keyboard Control --
  if love.keyboard.isDown('w') then
    spriteNum_testSprite = 1
    yPos_testSprite = yPos_testSprite - yPos_rate_yPos_testSprite
    if love.keyboard.isDown('d') then
      spriteNum_testSprite = 6
    end
    if love.keyboard.isDown('a') then
      spriteNum_testSprite = 7
    end
  end

  if love.keyboard.isDown('s') then
    spriteNum_testSprite = 2
    yPos_testSprite = yPos_testSprite + yPos_rate_yPos_testSprite
    if love.keyboard.isDown('d') then
      spriteNum_testSprite = 8
    end
    if love.keyboard.isDown('a') then
      spriteNum_testSprite = 5
    end
  end

  if love.keyboard.isDown('a') then
    spriteNum_testSprite = 4
    xPos_testSprite = xPos_testSprite - xPos_rate_yPos_testSprite
    if love.keyboard.isDown('w') then
    spriteNum_testSprite = 7
    end
    if love.keyboard.isDown('s') then
      spriteNum_testSprite = 5
    end
  end

  if love.keyboard.isDown('d') then
    spriteNum_testSprite = 3
    xPos_testSprite = xPos_testSprite + xPos_rate_yPos_testSprite
    if love.keyboard.isDown('w') then
    spriteNum_testSprite = 6
    end
    if love.keyboard.isDown('s') then
      spriteNum_testSprite = 8
    end
  end

end

-- remove comments on lines 40 and 41 if you would like to see an animation in process

function love.draw()
  love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  love.graphics.scale(2, 2)

    -- Generates the arena
    for y = 1, #map do
        for x = 1, #map[1] do
          if map[y][x] == 1 then
            local transformedX, transformedY = arenaTransform:transformPoint(x - (#map[1] / 2) - .5, y - (#map / 2) - .5)
            love.graphics.draw(tile, transformedX - 32, transformedY - 16)
          end
        end
    end

  love.graphics.print("testSprite position:", 50, 50)
  love.graphics.print("testSprite Position:", 50, 70)
  love.graphics.print(xPos_testSprite, 170, 50)
  love.graphics.print(yPos_testSprite, 170, 70)

  for x = 1, 5 do
    local n = math.floor(enemies[x]['animation'].currentTime / enemies[x]['animation'].duration * #enemies[x]['animation'].quads) + 1
    love.graphics.draw(enemies[x]['animation'].spriteSheet, enemies[x]['animation'].quads[n], enemies[x]['x_location'] + 1, enemies[x]['y_location'],0, 2)
    updateEnemieMovement(x)
  end

  love.graphics.draw(animation_testSprite.spriteSheet, animation_testSprite.quads[spriteNum_testSprite], xPos_testSprite, yPos_testSprite, 0, 4)

  for key, value in pairs(players) do
    value:draw()
  end
end

function updateEnemieMovement(i)
  enemies[i]['x_location'] = enemies[i]['x_location'] + 0.5
end

-- TODO do we need this?
function newAnimation(image, width, height)
  local animation = {}
  animation.spriteSheet = image;
  animation.quads = {};

  for y = 0, image:getHeight() - height, height do
    for x = 0, image:getWidth() - width, width do
      table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
    end
  end

  animation.duration = duration or 1
  animation.currentTime = 0

  return animation
end

function updateSpritePositionDelta()
  if love.keyboard.isDown('kp+') then

    if not love.keyboard.isDown('kp+') then
      xPos_rate_yPos_testSprite = xPos_rate_yPos_testSprite + 1
      yPos_rate_yPos_testSprite = yPos_rate_yPos_testSprite + 1
    end

    if love.keyboard.isDown('kp-') then
    end

  end
end

function love.keypressed(key, u)
  if key == "lctrl" then
    debug.debug()
  end

  if key == 'escape' then
    love.event.quit()
  end
end


