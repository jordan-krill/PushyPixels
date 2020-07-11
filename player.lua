local player = {}

function Player:new(color, extension)
    local t = setmetatable(extension or { }, self)
    self.__index = self
    self.color = color
    self.heading = {x = 0, y = 0}
    self.position = { x = 0, y = 0}
    self.strength = 10
    self.currentAnimation = "idle"
    self.currentFrame = 0
    self.name = "arms_" .. color
    self:load()
    return t
end

function Player:updatePosition()
    -- TODO
end

function Player:updateAnimation(dt)
    self.animations.time = self.animations.timee + dt
    if (self.animations.time >= self.animations.duration) then
        self.time = 0
        self.animations.index = self.animations.index % #self.animations[self.current_animation]
    end
end

function Player:detectCollision()
    -- TODO
end

function Player:load()
    self.metadata = json.decode(love.filesystem.read("arms_" .. self.color .. ".json"))
    self.animations = createSpriteSheetAnimations(love.graphics.newImage("arms_" .. self.color .. ".png"), self.metadata, 1)
end

function Player:draw()
    -- TODO
end

    function Player:resetHeading()
    self.heading.x = 0
    self.heading.y = 0
end

function Player:incrementXHeading()
    self.heading.x = self.heading.x + 1
end

function Player:decrementXHeading()
    self.heading.x = self.heading.x - 1
end

function Player:incrementYHeading()
    self.heading.y = self.heading.y + 1
end

function Player:decrementYHeading()
    self.heading.y = self.heading.y - 1
end