local screenWidth, screenHeight = love.graphics.getDimensions()
local spriteNum_oldHero = 1
local spriteNum_testSprite = 1
local xPos_testSprite = (screenWidth / 2)
local yPos_testSprite = (screenHeight / 2)
local xPos_oldHero = (screenWidth / 2)
local yPos_oldHero = (screenHeight / 2)
local xPos_rate_yPos_oldHero = 1
local yPos_rate_yPos_oldHero = 1
local xPos_rate_yPos_testSprite = 1
local yPos_rate_yPos_testSprite = 1
local enemies = {}

function love.load()

    -- Load sprite metadata
    json = require("json")
    fileContents = love.filesystem.read("arms_SE_red.json")
    arms_se_red_meta = json.decode(fileContents)
local screenWidth, screenHeight = love.graphics.getDimensions()
print(arms_se_red_meta['frames']['arms_se_red 0.aseprite']['sourceSize']['w'])
    animation = newAnimation(love.graphics.newImage("oldHero.png"), 16, 18, 1)
    -- grid_x = 600
    -- grid_y = 400
    tile = love.graphics.newImage('metalic_tile.png')
    animation_oldHero = newAnimation(love.graphics.newImage("oldHero.png"), 16, 18, 1)
    animation_testSprite = newAnimation(love.graphics.newImage("testSprite.png"), 16, 18, 10)
    
    grid_x = math.floor(love.graphics.getWidth()/2) - math.floor(tile:getWidth()/2)
    grid_y = math.floor(love.graphics.getHeight()/2) - math.floor(tile:getHeight()/2)
    block_width = tile:getWidth()
    block_height = tile:getHeight()
    block_depth = block_height / 2
    
    for x = 1, 5 do 
        local sub_table_item = {}
        sub_table_item['animation'] = newAnimation(love.graphics.newImage("arms_SE_red.png"), 64, 64, 1)
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
  animation_oldHero.currentTime = animation_oldHero.currentTime + dt
  if animation_oldHero.currentTime >= animation_oldHero.duration then
    animation_oldHero.currentTime = animation_oldHero.currentTime - animation_oldHero.duration
  end

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

-- OldHero Keyboard Control --
  if love.keyboard.isDown('up') then
    yPos_oldHero = yPos_oldHero - 10
  end

  if love.keyboard.isDown('down') then
    yPos_oldHero = yPos_oldHero + 10
  end

  if love.keyboard.isDown('left') then
    xPos_oldHero = xPos_oldHero - 10
  end

  if love.keyboard.isDown('right') then
    xPos_oldHero = xPos_oldHero + 10
  end


end

-- remove comments on lines 40 and 41 if you would like to see an animation in process

function love.draw()
  love.graphics.print("testSprite position:", 50, 50)
  love.graphics.print("testSprite Position:", 50, 70)
  love.graphics.print(xPos_testSprite, 170, 50)
  love.graphics.print(yPos_testSprite, 170, 70)

  love.graphics.print("oldHero position:", 50, 130)
  love.graphics.print("oldHero Position:", 50, 150)
  love.graphics.print(xPos_oldHero, 170, 130)
  love.graphics.print(yPos_oldHero, 170, 150)

      -- this generates the arena
    for x = 1, grid_size do
        for y = 1, grid_size do
            love.graphics.draw(tile,
                grid_x + ((y-x) * (block_width /2)),
                grid_y + ((x+y) * (block_depth / 2)) - (block_depth * (grid_size / 2)) - block_depth)
        end
    end

    for x = 1, 5 do
        local n = math.floor(enemies[x]['animation'].currentTime / enemies[x]['animation'].duration * #enemies[x]['animation'].quads) + 1
        love.graphics.draw(enemies[x]['animation'].spriteSheet, enemies[x]['animation'].quads[n], enemies[x]['x_location'] + 1, enemies[x]['y_location'],0, 2)
        updateEnemieMovement(x)
    end

  local spriteNum_oldHero = math.floor(animation_oldHero.currentTime / animation_oldHero.duration * #animation_oldHero.quads) + 1 
  print(spriteNum_oldHero)
  love.graphics.draw(animation_oldHero.spriteSheet, animation_oldHero.quads[spriteNum_oldHero], xPos_oldHero, yPos_oldHero, 0, 4)
  love.graphics.draw(animation_testSprite.spriteSheet, animation_testSprite.quads[spriteNum_testSprite], xPos_testSprite, yPos_testSprite, 0, 4)
end

function updateEnemieMovement(i)
  enemies[i]['x_location'] = enemies[i]['x_location'] + 0.5
end

function newAnimation(image, width, height, duration)
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
      xPos_rate_yPos_oldHero = xPos_rate_yPos_oldHero + 1
      yPos_rate_yPos_oldHero =  yPos_rate_yPos_oldHero + 1
      xPos_rate_yPos_testSprite = xPos_rate_yPos_testSprite + 1
      yPos_rate_yPos_testSprite = yPos_rate_yPos_testSprite + 1
    end
  end

  if love.keyboard.isDown('kp-') then

  end
end

function love.keypressed(key, u)
    --Debug
    if key == "rctrl" then --set to whatever key you want to use
       debug.debug()
    end

    if k == 'escape' then
        love.event.quit()
    end
 end


