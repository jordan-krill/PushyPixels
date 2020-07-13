local player = {}
local animation = require("animation")

function player:new(color, transform, extension)
    local t = setmetatable(extension or { }, self)
    self.__index = self
    t.color = color
    t.heading = {x = 0, y = 0}
    t.position = {x = 0, y = 0}
    t.strength = .025
    t.speed = .025
    t.name = "arms_" .. color
    t.direction = "se"
    t.isPunching = false;
    t.transform = transform
    t.type = "player"
    t.dead = false
    t.isHit = false
    t.hit_object = {heading = {x = 0, y = 0}, time = 0, strength = 0}
    t:load()
    return t
end

function player:updatePosition(objects, dt)
    if not (self.heading.x == 0 and self.heading.y == 0) then
        local heading_mag = math.sqrt(self.heading.x^2 + self.heading.y^2)
        self.position.x = self.position.x + (self.heading.x / heading_mag) * self.speed
        self.position.y = self.position.y + (self.heading.y / heading_mag) * self.speed
    end

    if (self.isHit and not (self.hit_object.heading.x == 0 and self.hit_object.heading.y == 0)) then
        self.hit_object.time = self.hit_object.time - dt
        if self.hit_object.time < 0 then
            self.isHit = false
        end

        local hit_heading_mag = math.sqrt(self.hit_object.heading.x^2 + self.hit_object.heading.y^2)
        self.position.x = self.position.x + (self.hit_object.heading.x / hit_heading_mag) * self.hit_object.strength
        self.position.y = self.position.y + (self.hit_object.heading.y / hit_heading_mag) * self.hit_object.strength
    end

    self:collisionCheck(objects)

    self.heading.x = 0
    self.heading.y = 0
end

function player:updateAnimation(dt)
    if not (self.heading.x == 0 and self.heading.y == 0) then
        local heading_angle = self:getHeadingAngle()
        
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

function player:load()
    self.metadata = json.decode(love.filesystem.read("arms_" .. self.color .. ".json"))
    self.sprite_sheet = love.graphics.newImage("arms_" .. self.color .. ".png")
    self.animations = animation:createSpriteSheetAnimations(self.sprite_sheet, self.metadata, 1)
    self.animations.current_animation = "idle_se"
end

function player:draw()
    if not self.dead then
        local spriteSize = self.metadata.frames[self.animations.current_animation .. self.animations.index].sourceSize
        local transformedX, transformedY = self.transform:transformPoint(self.position.x, self.position.y)
        local x = transformedX - (spriteSize.w * .5)
        local y = transformedY - (spriteSize.h * .75)
        love.graphics.draw(self.sprite_sheet, self.animations[self.animations.current_animation][self.animations.index], x, y)
    end
end

function player:collisionCheck(objects)
    local safe = false;
    local translatedPlayerX = self.position.x + (love.graphics.getWidth() / 2)
    local playerXMin = translatedPlayerX - .5
    local playerXMax = translatedPlayerX + .5
    local translatedPlayerY = self.position.y + (love.graphics.getHeight() / 2)
    local playerYMin = translatedPlayerY - .5
    local playerYMax = translatedPlayerY + .5

    for i=1, #objects do
        if objects[i].type == "floor" then

            local translatedFloorX = objects[i].position.x + (love.graphics.getWidth() / 2)
            local floorXMin = translatedFloorX - .5
            local floorXMax = translatedFloorX + .5
            local translatedFloorY = objects[i].position.y + (love.graphics.getHeight() / 2)
            local floorYMin = translatedFloorY - .5
            local floorYMax = translatedFloorY + .5


            if (
                (
                    ((playerXMax >= floorXMin) and (playerXMax <= floorXMax))
                    or
                    ((playerXMin >= floorXMin) and (playerXMin <= floorXMax))
                )
                and
                (
                    ((playerYMax >= floorYMin) and (playerYMax <= floorYMax))
                    or
                    ((playerYMin >= floorYMin) and (playerYMin <= floorYMax))
                )
            ) then
                safe = true
                break
            end

        end
    end

    if not safe then
        self.dead = true
    end

    for i=1, #objects do
        if ((objects[i].type == "player") and not (objects[i] == self) and self.isPunching and (self.animations.index == 2)) then

            local hit_heading = {x = 0, y = 0}
            if (self.direction == "ne") then
                playerYMin = playerYMin - .5
                hit_heading.y = hit_heading.y - 1
            elseif (self.direction == "nw") then
                playerXMin = playerXMin - .5
                hit_heading.x = hit_heading.x - 1
            elseif (self.direction == "sw") then
                playerYMax = playerYMax + .5
                hit_heading.y = hit_heading.y + 1
            elseif (self.direction == "se") then
                playerXMax = playerXMax + .5
                hit_heading.x = hit_heading.x + 1
            end
            print(self.direction)

            local translatedOtherPlayerX = objects[i].position.x + (love.graphics.getWidth() / 2)
            local otherPlayerXMin = translatedOtherPlayerX - .5
            local otherPlayerXMax = translatedOtherPlayerX + .5
            local translatedOtherPlayerY = objects[i].position.y + (love.graphics.getHeight() / 2)
            local otherPlayerYMin = translatedOtherPlayerY - .5
            local otherPlayerYMax = translatedOtherPlayerY + .5

            if (
                (
                    ((playerXMax >= otherPlayerXMin) and (playerXMax <= otherPlayerXMax))
                    or
                    ((playerXMin >= otherPlayerXMin) and (playerXMin <= otherPlayerXMax))
                )
                and
                (
                    ((playerYMax >= otherPlayerYMin) and (playerYMax <= otherPlayerYMax))
                    or
                    ((playerYMin >= otherPlayerYMin) and (playerYMin <= otherPlayerYMax))
                )
            ) then
                print("HIT")
                local new_hit_object = {}
                new_hit_object.heading = hit_heading
                new_hit_object.time = 1
                new_hit_object.strength = self.strength
                objects[i]:hit(new_hit_object)
            end
        end
    end
end

function player:hit(hit)
    self.isHit = true
    self.hit_object = hit
end

function player:getHeadingAngle()
    local transformedX, transformedY = self.transform:transformPoint(self.heading.x, self.heading.y)
    local heading_mag = math.sqrt(transformedX^2 + transformedY^2)

    local heading_angle = math.acos(transformedX / heading_mag)
    if (transformedY > 0) then
        heading_angle = heading_angle + ((math.pi - heading_angle) * 2)
    end

    return heading_angle
end

function player:incrementXHeading()
    local x, y = self.transform:inverseTransformPoint(1, 0)
    self.heading.x = self.heading.x + x
    self.heading.y = self.heading.y + y
end

function player:decrementXHeading()
    local x, y = self.transform:inverseTransformPoint(-1, 0)
    self.heading.x = self.heading.x + x
    self.heading.y = self.heading.y + y
end

function player:incrementYHeading()
    local x, y = self.transform:inverseTransformPoint(0, 1)
    self.heading.x = self.heading.x + x
    self.heading.y = self.heading.y + y
end

function player:decrementYHeading()
    local x, y = self.transform:inverseTransformPoint(0, -1)
    self.heading.x = self.heading.x + x
    self.heading.y = self.heading.y + y
end

function player:punch()
    self.isPunching = true
end

return player