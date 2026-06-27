--- Match Result By MounTsa VIP ---
local TableUtil, eventmanager, CommonNavVars = ...
local MatchResults = {}
local TIME_DELAY = 0.9
local START_TIME = 0.6
local ACT_ADVANCE = "act_advance"

function MatchResults:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    ScreenInfoService = o.api("ScreenInfoService"),
    QuickEventsService = o.api("QuickEventsService"),
    EventManService = o.api("EventManagerService"),
    AudioService = o.api("AudioService"),
    MatchInfoService = o.api("MatchInfoService"),
  }
  o.handlerId = o.services.EventManService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  o.count = 8
  o.startTime = START_TIME
  o.isSwiping = o.services.QuickEventsService.ShouldQuickEventDisplaySwipeText()
  for i = 0, 7 do
    local anim = "bnd_animate_count" .. i
    o.im.Subscribe(anim, function() o.im.Publish(anim, false) end)
  end

  o.im.RegisterAction(ACT_ADVANCE, function()
    print("[MatchResults] act_advance pressed")
    o.nav.Event(nil, "evt_advance")
  end)
  return o
end

function MatchResults:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function MatchResults:update(elapsedTime)
  self.startTime = self.startTime + elapsedTime
  if self.startTime >= TIME_DELAY then
    self.startTime = self.startTime - TIME_DELAY

    if self.count > 0 or (self.count == 0 and self.isSwiping) then
      local isLast = (self.count == 1 and not self.isSwiping)
      local soundId = isLast and "" or "" -- Pake Telolet Kalau Ada, Clue nya ( act_ )
      self.services.AudioService.PlaySoundById(soundId, "root", {
        soundId = "",
        type = "",
        state = { name = "VALID", val = 0 }
      })
      self:_publishCount()
    else
      print("[MatchResults] auto evt_advance")
      self.nav.Event(nil, "") -- Awas Auto Nav
    end
  end
end

function MatchResults:_publishCount()
  for i = 1, 8 do
    self.im.Publish("bnd_panel" .. i .. "_visible", false)
  end
  for i = 0, 7 do
    self.im.Publish("bnd_animate_count" .. i, false)
  end

  local panelId = 9 - self.count
  if panelId >= 1 and panelId <= 8 then
    self.im.Publish("bnd_panel" .. panelId .. "_visible", true)
    self.im.Publish("bnd_animate_count" .. (panelId - 1), true)
  end

  self.count = self.count - 1
end

function MatchResults:handleEvent(eventType)
  print("[MatchResults] Received event:", eventType)
end
--- Match Result By MounTsa VIP ---
function MatchResults:finalize()
  for i = 0, 7 do
    self.im.Unsubscribe("bnd_animate_count" .. i)
  end
  self.services.ScreenInfoService.UnsetScreenName("MatchResults")
  self.services.EventManService.UnregisterHandler(self.handlerId)
  self.im.UnregisterAction(ACT_ADVANCE)
end
--- Match Result By MounTsa VIP ---
return MatchResults