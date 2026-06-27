-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local MatchInfo = {}

local OverlaysIdContainer, OverlayParam, eventmanager, TableUtil = ...
local OVERLAY_TYPES = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local BND_LOGO_TIM_HOME = "bnd_logo_tim_home"
local BND_LOGO_TIM_AWAY = "bnd_logo_tim_away"

local BND_NAMA_TIM_HOME = "bnd_nama_tim_home"
local BND_NAMA_TIM_AWAY = "bnd_nama_tim_away"

local BND_NAMA_STADION = "bnd_nama_stadion"

function MatchInfo:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SettingsService = o.api("SettingsService"),
    MatchInfoService = o.api("MatchInfoService"),
    EventManagerService = o.api("EventManagerService")
  }
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  o.CurrentOptions = o.services.SettingsService.GetCurrentOptions()

  o.visible = false
  
  homeCrest = {
    name = "$Crest",
    id = o.TeamsData[1].assetId
  }
  awayCrest = {
    name = "$Crest",
    id = o.TeamsData[2].assetId
  }

  o.im.Subscribe("bnd_visible", function()
    o:_publishVisible()
  end)

  o.im.Subscribe(BND_LOGO_TIM_HOME, function()
    o.im.Publish(BND_LOGO_TIM_HOME, homeCrest)
  end)
  o.im.Subscribe(BND_LOGO_TIM_AWAY, function()
    o.im.Publish(BND_LOGO_TIM_AWAY, awayCrest)
  end)

  o.im.Subscribe(BND_NAMA_TIM_HOME, function()
    o.im.Publish(BND_NAMA_TIM_HOME, o.TeamsData[1].teamName)
  end)
  o.im.Subscribe(BND_NAMA_TIM_AWAY, function()
    o.im.Publish(BND_NAMA_TIM_AWAY, o.TeamsData[2].teamName)
  end)

  o.im.Subscribe(BND_NAMA_STADION, function()
    o.im.Publish(BND_NAMA_STADION, o.CurrentOptions.stadium)
  end)

  return o
end

function MatchInfo:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeFixture then
    self:updateMatchInfo(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function MatchInfo:updateMatchInfo(subtype, hideshow, subtypestr, msg)
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    self.visible = true
  else
    self.visible = false
  end
  self:_publishVisible()
end

function MatchInfo:_publishVisible()
  self.im.Publish("bnd_visible", self.visible)
end

function MatchInfo:finalize()

  self.im.Unsubscribe("bnd_visible")
  
  self.im.Unsubscribe(BND_LOGO_TIM_HOME)
  self.im.Unsubscribe(BND_LOGO_TIM_AWAY)

  self.im.Unsubscribe(BND_NAMA_TIM_HOME)
  self.im.Unsubscribe(BND_NAMA_TIM_AWAY)
  
  self.im.Unsubscribe(BND_NAMA_STADION)

  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  
end

return MatchInfo