local screenWidth, screenHeight = love.graphics.getDimensions()
local spriteNum_oldHero = 1
local spriteNum_testSprite = 1

function love.load()
  animation_oldHero = newAnimation(love.graphics.newImage("oldHero.png"), 16, 18, 1)
  animation_testSprite = newAnimation(love.graphics.newImage("testSprite.png"), 16, 18, 1)
end

function love.update(dt)
  animation_oldHero.currentTime = animation_oldHero.currentTime + dt
  if animation_oldHero.currentTime >= animation_oldHero.duration then
    animation_oldHero.currentTime = animation_oldHero.currentTime - animation_oldHero.duration
  end

  animation_testSprite.currentTime = animation_testSprite.currentTime + dt
  if animation_testSprite.currentTime >= animation_testSprite.duration then
    animation_testSprite.currentTime = animation_testSprite.currentTime - animation_testSprite.duration
  end

  if love.keyboard.isDown('w') then
    
    if spriteNum >  then
      spriteNum = 1
    else 
    spriteNum = spriteNum + 1
    end
  elseif love.keyboard.isDown('s') then
    --
  elseif love.keyboard.isDown('a') then
    --
  elseif love.keyboard.isDown('d') then
    --
  end

end

-- remove comments on lines 40 and 41 if you would like to see an animation in process

function love.draw()
  --local spriteNum_oldHero = math.floor(animation_oldHero.currentTime / animation_oldHero.duration * #animation_oldHero.quads) + 1
  --local spriteNum_testSprite = math.floor(animation_testSprite.currentTime / animation_testSprite.duration * #animation_testSprite.quads) + 1
  love.graphics.draw(animation_oldHero.spriteSheet, animation_oldHero.quads[spriteNum_oldHero], (screenWidth/4) - 8, screenHeight/2 - 9, 0, 4)
  love.graphics.draw(animation_testSprite.spriteSheet, animation_testSprite.quads[spriteNum_testSprite], (screenWidth/2) - 8, screenHeight/2 - 9, 0, 4)
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