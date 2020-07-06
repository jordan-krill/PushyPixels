function love.load()
    -- love.window.setMode(1280, 800, {resizable=true, vsync=false, minwidth= 400, minheight=300})
    love.window.setFullscreen(true, "desktop")

    -- in this sprite sheet each sprite is 16 pixels wide and 18 pixels high with each sprite showing for 1 sec
    --background = newAnimation(love.graphics.newImage("galaxy-background1.png"), 322, 322, 5)
    
    animation = newAnimation(love.graphics.newImage("oldHero.png"), 16, 18, 1)
    -- grid_x = 600
    -- grid_y = 400
    tile = love.graphics.newImage('floor.png')
    grid_x = math.floor(love.graphics.getWidth()/2) - math.floor(tile:getWidth()/2)
    grid_y = math.floor(love.graphics.getHeight()/2) - math.floor(tile:getHeight()/2)
    floor = {}
    block_width = tile:getWidth()
    block_height = tile:getHeight()
    block_depth = block_height / 2
    grid_size = 15
    grid = {}
    for x = 1, grid_size do 
        grid[x] = {}
        for y = 1, grid_size do
            grid[x][y] = 1
        end
    end
end

function love.draw()
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    local backgroundNum = math.floor(background.currentTime / background.duration * #background.quads) + 1
    --currentTime / duration" is between 0 and 1. Which represents the percentage. 0.25 means 25% of the animation has passed.
    -- love.graphics.draw(background.spriteSheet, background.quads[backgroundNum],0,0,0,3)
    --Considering this we can search for the correct image to use! Since we already have a number between 0 and 1 we can simply multiply this percentage with our total amount of images and get a number between 0 and 6!
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], 0, 0, 0, 4)
    red = 88 / 250
    green = 202 / 250
    blue = 202 / 250
    color = {red, green, blue}
    love.graphics.setBackgroundColor(color)


    for x = 1, grid_size do
        for y = 1, grid_size do
            love.graphics.draw(tile,
                grid_x + ((y-x) * (block_width /2)),
                grid_y + ((x+y) * (block_depth / 2)) - (block_depth * (grid_size / 2)) - block_depth)
        end
    end
    
end


        
-- dt which is delta time which is time since the last frame
function love.update(dt)
    animation.currentTime = animation.currentTime + dt
    background.currentTime = background.currentTime + dt
    --i think this just makes sure each animation is played for the same amount of time
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end

    -- if background.currentTime >= background.duration then
    --     background.currentTime = background.currentTime - background.duration
    -- end

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

