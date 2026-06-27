local Animated = {}
local TIME_DELAY = 0.5
local START_TIME = 0.2

function Animated:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

  o.services = {
    ScreenInfoService = o.api("ScreenInfoService"),
    QuickEventsService = o.api("QuickEventsService"),
    AudioService = o.api("AudioService")
  }

  o.count = 2
  o.startTime = START_TIME
  o.isSwiping = o.services.QuickEventsService.ShouldQuickEventDisplaySwipeText()

  -- subscribe hanya 3 animasi
  for i = 0, 1 do
    local anim = "bnd_animate_count" .. i
    o.im.Subscribe(anim, function() o.im.Publish(anim, false) end)
  end

  o.services.ScreenInfoService.SetScreenName("Animated")

  return o
end

function Animated:update(elapsedTime)
  self.startTime = self.startTime + elapsedTime
  if self.startTime >= TIME_DELAY then
    self.startTime = self.startTime - TIME_DELAY

    if self.count > 0 or (self.count == 0 and self.isSwiping) then
      local isLast = (self.count == 1 and not self.isSwiping)
      local soundId = isLast and "" or ""

      self.services.AudioService.PlaySoundById(soundId, "root", {
        soundId = "",
        type = "",
        state = { name = "VALID", val = 0 }
      })

      self:_publishCount()
    else
      self.nav.Event(nil, "")
    end
  end
end

function Animated:_publishCount()
  -- hanya panel 1-3
  for i = 1, 2 do
    self.im.Publish("bnd_panel" .. i .. "_visible", false)
  end
  -- hanya animasi 0-2
  for i = 0, 1 do
    self.im.Publish("bnd_animate_count" .. i, false)
  end

  local panelId = 3 - self.count
  if panelId >= 1 and panelId <= 2 then
    self.im.Publish("bnd_panel" .. panelId .. "_visible", true)
    self.im.Publish("bnd_animate_count" .. (panelId - 1), true)
  end

  self.count = self.count - 1
end

function Animated:finalize()
  for i = 0, 1 do
    self.im.Unsubscribe("bnd_animate_count" .. i)
  end

  self.services.ScreenInfoService.UnsetScreenName("Animated")
end

return Animated