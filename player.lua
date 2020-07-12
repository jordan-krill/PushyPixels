local player = {}
local animation = require("animation")

function player:new(color, extension)
    local t = setmetatable(extension or { }, self)
    self.__index = self
    self.color = color
    self.heading = {x = 0, y = 0}
    self.position = {x = 0, y = 0}
    self.strength = 10
    self.speed = 10
    self.currentFrame = 0
    self.name = "arms_" .. color
    self:load()
    return t
end

function player:updatePosition()
    if not (self.heading.x == 0 and self.heading.y == 0) then
        local headingMag = math.sqrt(self.heading.x^2 + self.heading.y^2)
        self.position.x = self.position.x + (self.heading.x / headingMag) * self.speed
        self.position.y = self.position.y + (self.heading.y / headingMag) * self.speed
    end
    self:resetHeading()
end

function player:updateAnimation(dt)
    self.animations.time = self.animations.time + dt
    if (self.animations.time >= self.animations.duration) then
        self.time = 0
        self.animations.index = self.animations.index % #self.animations[self.animations.current_animation]
    end
end

function player:detectCollision()
    -- TODO
end

function player:load()
    self.metadata = json.decode(love.filesystem.read("arms_" .. self.color .. ".json"))
    self.sprite_sheet = love.graphics.newImage("arms_" .. self.color .. ".png")
    self.animations = animation:createSpriteSheetAnimations(self.sprite_sheet, self.metadata, 1)
end

function player:draw()
    love.graphics.draw(self.sprite_sheet, self.animations[self.animations.current_animation][self.animations.index], self.position.x, self.position.y)
end

function player:resetHeading()
    self.heading.x = 0
    self.heading.y = 0
end

function player:incrementXHeading()
    self.heading.x = self.heading.x + 1
end

function player:decrementXHeading()
    self.heading.x = self.heading.x - 1
end

function player:incrementYHeading()
    self.heading.y = self.heading.y + 1
end

function player:decrementYHeading()
    self.heading.y = self.heading.y - 1
end

return player