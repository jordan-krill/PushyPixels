local animation = {}

function animation:createSpriteSheetAnimations(img, metadata, frameDuration)
    local animations = {}
    
    for key, value in pairs(metadata.meta.frameTags) do
      local tag = {}
      local counter = 1
      for i=value.from, value.to do
        -- WARNING frames index could change based off export
        local frame = metadata.frames[value.name .. counter].frame
        table.insert(tag, love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h, img:getDimensions()))
        counter = counter + 1
      end
      animations[value.name] = tag
    end
  
    -- TODO could use metadata to determine duration
    animations.duration = frameDuration
    animations.time = 0
    animations.current_animation = metadata.meta.frameTags[1].name
    animations.index = 1
  
    return animations
  end

return animation