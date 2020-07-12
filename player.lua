local player = {}
local animation = require("animation")

function player:new(color, extension)
    local t = setmetatable(extension or { }, self)
    self.__index = self
    t.color = color
    t.heading = {x = 0, y = 0}
    t.position = {x = 0, y = 0}
    t.strength = 10
    t.speed = 2
    t.currentFrame = 0
    t.name = "arms_" .. color
    t.direction = "se"
    t.isPunching = false;
    t:load()
    return t
end

function player:updatePosition()
    if not (self.heading.x == 0 and self.heading.y == 0) then
        local heading_mag = math.sqrt(self.heading.x^2 + self.heading.y^2)
        self.position.x = self.position.x + (self.heading.x / heading_mag) * self.speed
        self.position.y = self.position.y + (self.heading.y / heading_mag) * self.speed
    end

    self.heading.x = 0
    self.heading.y = 0
end

function player:updateAnimation(dt)
    if not (self.heading.x == 0 and self.heading.y == 0) then
        local heading_mag = math.sqrt(self.heading.x^2 + self.heading.y^2)

        local heading_angle = math.acos(self.heading.x / heading_mag)
        if (self.heading.y > 0) then
            heading_angle = heading_angle + ((math.pi - heading_angle) * 2)
        end
        
        if ((heading_angle >= 0) and (heading_angle < (math.pi / 2))) then
            self.direction = "ne"
        elseif ((heading_angle >= (math.pi / 2)) and (heading_angle < math.pi)) then
            self.direction = "nw"
        elseif ((heading_angle >= math.pi) and (heading_angle < (3 * math.pi / 2))) then
            self.direction = "sw"
        else
            self.direction = "se"
        end
    end

    self.animations.time = self.animations.time + dt
    if (self.animations.time >= (self.animations.duration * self.animations.index)) then
        self.animations.index = self.animations.index + 1
        if (self.animations.index > #self.animations[self.animations.current_animation]) then
            self.animations.index = 1
            self.animations.time = 0
            if self.isPunching then
                self.isPunching = false
            end
        end
    end

    if (self.isPunching) then
        self.animations.current_animation = "punch_" .. self.direction
    else
        self.animations.current_animation = "idle_" .. self.direction
    end

end

function player:detectCollision()
    -- TODO
end

function player:load()
    self.metadata = json.decode(love.filesystem.read("arms_" .. self.color .. ".json"))
    self.sprite_sheet = love.graphics.newImage("arms_" .. self.color .. ".png")
    self.animations = animation:createSpriteSheetAnimations(self.sprite_sheet, self.metadata, 1)
    self.animations.current_animation = "idle_se"
end

function player:draw()
    love.graphics.draw(self.sprite_sheet, self.animations[self.animations.current_animation][self.animations.index], self.position.x, self.position.y)
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

function player:punch()
    self.isPunching = true
end

return player