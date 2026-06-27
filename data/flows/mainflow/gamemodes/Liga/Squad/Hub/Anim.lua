local Anim = {}

function Anim:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.Timer = init.Timer
  o.im = init.im
  return o
end

function Anim:setNextAnim(index, animValues)
      if index > #animValues then
        print("[TeamRoster]: Animation sequence completed")
        self.panelAnimTimer = nil -- Clean up
        return
      end

      local value = animValues[index]
      local delay = 0.05 -- 2 seconds for first step, 1 second for others

      self.panelAnimTimer = self.Timer:new({
        id = "panelAnimTimer_" .. index,
        interval = delay,
        reps = 1,
        onTimerComplete = function(id, repsCount)
          print(string.format("[TeamRoster]: Timer completed, setting bnd_panelanim to %.1f", value))
          self.im.Publish("bnd_panelanim", value)
          setNextAnim(index + 1) -- Move to next animation step
        end
      })
      self.panelAnimTimer:start()
      print(string.format("[TeamRoster]: Started %d-second timer to set bnd_panelanim to %.1f", delay, value))
    end

    -- Start the animation sequence
  end
  
  function Anim:update(elapsedTime)
  if self.panelAnimTimer then
    self.panelAnimTimer:update(elapsedTime)
  end
end

function Anim:finalize()
  if self.panelAnimTimer then
    self.panelAnimTimer:finalize()
    self.panelAnimTimer = nil
    print("[TeamRoster]: Panel anim timer finalized")
  end
  
  return Anim
  