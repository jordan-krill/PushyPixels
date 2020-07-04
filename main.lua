function love.draw()
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    --currentTime / duration" is between 0 and 1. Which represents the percentage. 0.25 means 25% of the animation has passed.
    --Considering this we can search for the correct image to use! Since we already have a number between 0 and 1 we can simply multiply this percentage with our total amount of images and get a number between 0 and 6!
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], 0, 0, 0, 10)
end

function love.load()
    -- in this sprite sheet each sprite is 16 pixels wide and 18 pixels high with each sprite showing for 1 sec
    animation = newAnimation(love.graphics.newImage("oldHero.png"), 16, 18, 1)
end

-- dt which is delta time which is time since the last frame
function love.update(dt)
    animation.currentTime = animation.currentTime + dt
    --i think this just makes sure each animation is played for the same amount of time
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end

    -- currentTime / duration * #quads
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