local EventManager, TableUtil = ...
local BND_HOME_MENTALITY = "bnd_home_mentality"
local BND_HOME_LABEL = "bnd_home_label"
local BND_HOME_ACTIVE = "bnd_home_active"
local BND_AWAY_MENTALITY = "bnd_away_mentality"
local BND_AWAY_LABEL = "bnd_away_label"
local BND_AWAY_ACTIVE = "bnd_away_active"
local SIDE_HOME = 0
local SIDE_AWAY = 1
local MENTALITY_MAX = 4
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local Mentality = {}
function Mentality:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    settingsService = o.api("SettingsService")
  }
  o.cameraIndex = cameraIndex
  o.homeMentality = 2
  o.awayMentality = 2
  o.isDefault = true
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end)
  if currentMode == 4 then
    o.isDefault = false
  end
  o.im.Subscribe("bnd_home_mentality_default_visible", function()
    o:_publishMentalityVisible(SIDE_HOME)
  end)
  o.im.Subscribe("bnd_home_mentality_new_visible", function()
    o:_publishMentalityVisible(SIDE_HOME)
  end)
  o.im.Subscribe(BND_HOME_MENTALITY, function()
    o:_publishMentality(SIDE_HOME)
  end)
  o.im.Subscribe(BND_HOME_LABEL, function()
    o:_publishLabel(SIDE_HOME)
  end)
  o.im.Subscribe(BND_HOME_ACTIVE, function()
    o:_publishActive(SIDE_HOME, false)
  end)
  o.im.Subscribe(BND_AWAY_MENTALITY, function()
    o:_publishMentality(SIDE_AWAY)
  end)
  o.im.Subscribe(BND_AWAY_LABEL, function()
    o:_publishLabel(SIDE_AWAY)
  end)
  o.im.Subscribe(BND_AWAY_ACTIVE, function()
    o:_publishActive(SIDE_AWAY, false)
  end)
  o.im.Subscribe("bnd_home_mentality_index", function()
    o:_publishTeamMentality(SIDE_HOME)
  end)
  o.im.RegisterAction("act_defend", function(actionName)
    o:_updateTeamMentality(SIDE_HOME, 0)
  end)
  o.im.RegisterAction("act_balance", function(actionName)
    o:_updateTeamMentality(SIDE_HOME, 1)
  end)
  o.im.RegisterAction("act_attack", function(actionName)
    o:_updateTeamMentality(SIDE_HOME, 2)
  end)
  o.im.RegisterAction("act_camera_change", function(actionName)
    o:_updateCamera()
  end)
  return o
end
function Mentality:getMentalityLabel(mentality)
  if mentality == 0 then
    return self.loc.LocalizeString("LTXT_MOB_MENT_UDEF")
  elseif mentality == 1 then
    return self.loc.LocalizeString("LTXT_MOB_MENT_DEF")
  elseif mentality == 2 then
    return self.loc.LocalizeString("LTXT_MOB_MENT_BAL")
  elseif mentality == 3 then
    return self.loc.LocalizeString("LTXT_MOB_MENT_ATT")
  elseif mentality == 4 then
    return self.loc.LocalizeString("LTXT_MOB_MENT_UATT")
  end
end
function Mentality:_publishMentality(side)
  if side == SIDE_HOME then
    self.im.Publish(BND_HOME_MENTALITY, self.homeMentality)
  else
    self.im.Publish(BND_HOME_MENTALITY, MENTALITY_MAX - self.awayMentality)
  end
end
function Mentality:_publishMentalityVisible(side)
  self.im.Publish("bnd_home_mentality_default_visible", self.isDefault)
  self.im.Publish("bnd_home_mentality_new_visible", not self.isDefault)
end
function Mentality:_publishTeamMentality(side)
  self.im.Publish("bnd_home_mentality_index", self.homeMentality - 1)
end
function Mentality:_publishLabel(side)
  if side == SIDE_HOME then
    self.im.Publish(BND_HOME_LABEL, self:getMentalityLabel(self.homeMentality))
  else
    self.im.Publish(BND_AWAY_LABEL, self:getMentalityLabel(self.awayMentality))
  end
end
function Mentality:_publishActive(side, active)
  if side == SIDE_HOME then
    self.im.Publish(BND_HOME_ACTIVE, active)
  else
    self.im.Publish(BND_AWAY_ACTIVE, active)
  end
end
function Mentality:_updateMentality(side, subtype, hideShow, subTypeStr, msg)
  if hideShow == "HIDE" then
    self:_publishActive(side, false)
  else
    print(msg)
    local mentality = tonumber(msg)
    if mentality and 0 <= mentality and mentality <= 4 then
      if side == SIDE_HOME then
        self.homeMentality = mentality
      else
        self.awayMentality = mentality
      end
      self:_publishLabel(side)
      self:_publishMentality(side)
      self:_publishActive(side, true)
    end
  end
end
function Mentality:_updateTeamMentality(side, index)
  local mentality = index + 1
  if mentality and 0 <= mentality and mentality <= 4 then
    if side == SIDE_HOME then
      self.homeMentality = mentality
    else
      self.awayMentality = mentality
    end
    self:_publishMentality(side)
    self:_publishTeamMentality(side)
  end
end
function Mentality:_updateCamera()
  if self.cameraIndex >= 7 then
    self.cameraIndex = 0
  else
    self.cameraIndex = self.cameraIndex + 1
  end
  self.services.settingsService.SaveCameraValue(self.cameraIndex)
end
function Mentality:_handleEvent(eventType, data)
  if currentMode ~= 4 then
    if eventType == EVENT_TYPES.UpdateTeamMentality then
    elseif eventType == EVENT_TYPES.OverlayTypePressureBarRight then
      self:_updateMentality(SIDE_HOME, data.subtype, data.hideshow, data.subtypestr, data.msg)
    elseif eventType == EVENT_TYPES.OverlayTypePressureBarLeft then
      self:_updateMentality(SIDE_HOME, data.subtype, data.hideshow, data.subtypestr, data.msg)
    end
  end
end
function Mentality:finalize()
  self.im.Unsubscribe(BND_HOME_MENTALITY)
  self.im.Unsubscribe(BND_HOME_LABEL)
  self.im.Unsubscribe(BND_HOME_ACTIVE)
  self.im.Unsubscribe(BND_AWAY_MENTALITY)
  self.im.Unsubscribe(BND_AWAY_LABEL)
  self.im.Unsubscribe(BND_AWAY_ACTIVE)
  self.im.Unsubscribe("bnd_home_mentality_default_visible")
  self.im.Unsubscribe("bnd_home_mentality_new_visible")
  self.im.Unsubscribe("bnd_home_mentality_index")
  self.im.UnregisterAction("act_defend")
  self.im.UnregisterAction("act_balance")
  self.im.UnregisterAction("act_attack")
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
end
return Mentality
