local player = {}
local animation = require("animation")

function player:new(color, transform, extension)
    local t = setmetatable(extension or { }, self)
    self.__index = self
    t.color = color
    t.heading = {x = 0, y = 0}
    t.position = {x = 0, y = 0}
    t.strength = 1
    t.speed = .25
    t.name = "arms_" .. color
    t.direction = "se"
    t.isPunching = false;
    t.transform = transform
    t.type = "player"
    t.dead = false
    t:load()
    return t
end

function player:updatePosition(objects)
    if not (self.heading.x == 0 and self.heading.y == 0) then
        local heading_mag = math.sqrt(self.heading.x^2 + self.heading.y^2)
        self.position.x = self.position.x + (self.heading.x / heading_mag) * self.speed
        self.position.y = self.position.y + (self.heading.y / heading_mag) * self.speed
    end
    self:checkFall(objects)

    self.heading.x = 0
    self.heading.y = 0
end

function player:updateAnimation(dt)
    if not (self.heading.x == 0 and self.heading.y == 0) then
        local transformedX, transformedY = self.transform:transformPoint(self.heading.x, self.heading.y)
        local heading_mag = math.sqrt(transformedX^2 + transformedY^2)

        local heading_angle = math.acos(transformedX / heading_mag)
        if (transformedY > 0) then
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

function player:checkFall(objects)
    local safe = false;
    for i=1, #objects do
        if objects[i].type == "floor" then

            local translatedFloorX = objects[i].position.x +10
            local floorXMin = translatedFloorX - .5
            local floorXMax = translatedFloorX + .5
            local translatedFloorY = objects[i].position.y + 10
            local floorYMin = translatedFloorY - .5
            local floorYMax = translatedFloorY + .5

            local translatedPlayerX = self.position.x +10
            local playerXMin = translatedPlayerX - .5
            local playerXMax = translatedPlayerX + .5
            local translatedPlayerY = self.position.y + 10
            local playerYMin = translatedPlayerY - .5
            local playerYMax = translatedPlayerY + .5

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
    if not (safe or self.dead) then
        self.dead = true
    end
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