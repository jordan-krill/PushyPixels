function love.load()
    love.window.setMode(1280, 800, {resizable=true, vsync=false, minwidth= 400, minheight=300})
    grid_x = 600
    grid_y = 400
    floor = {}
    tile = love.graphics.newImage('floor.png')
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
