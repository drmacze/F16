-- Modified By MVNPROD Youtube Channel --
local MenuHub = {}
local BND_SETTINGS_SELECT = "bnd_settings_select"
local BND_PROFILE_SELECT = "bnd_profile_select"
local BND_UPDATE_SELECT = "bnd_update_select"
local BND_ROSTER_SELECT = "bnd_roster_select"
local BND_FREE1_SELECT = "bnd_free1_select"
local BND_FREE2_SELECT = "bnd_free2_select"
local BND_FREE3_SELECT = "bnd_free3_select"
local BND_FREE4_SELECT = "bnd_free4_select"
local ACT_MVNPROD = "act_mvnprod"
local SETTINGS = 1
local PROFILE = 2
local UPDATE = 3
local ROSTER = 4
local FREE1 = 5
local FREE2 = 6
local FREE3 = 7
local FREE4 = 8
function MenuHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    EventManagerService = o.api("EventManagerService")
  }
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
  o:handleEvent(...)
  end)
  o.buttonsID = { SETTINGS, PROFILE, UPDATE, ROSTER, FREE1, FREE2, FREE3, FREE4 }
  o.im.Subscribe(BND_SETTINGS_SELECT, function()
  end)
  o.im.Subscribe(BND_PROFILE_SELECT, function()
  end)
  o.im.Subscribe(BND_UPDATE_SELECT, function()
  end)
  o.im.Subscribe(BND_ROSTER_SELECT, function()
  end)
  o.im.Subscribe(BND_FREE1_SELECT, function()
  end)
  o.im.Subscribe(BND_FREE2_SELECT, function()
  end)
  o.im.Subscribe(BND_FREE3_SELECT, function()
  end)
  o.im.Subscribe(BND_FREE4_SELECT, function()
  end)
  o:HideSelections()
  o.im.RegisterAction(ACT_MVNPROD, function(actionName, data)
    o:HideSelections()
    if o.buttonsID[data.buttonID + 1] == SETTINGS then
      o.im.Publish(BND_SETTINGS_SELECT, true)
    elseif o.buttonsID[data.buttonID + 1] == PROFILE then
      o.im.Publish(BND_PROFILE_SELECT, true)
    elseif o.buttonsID[data.buttonID + 1] == UPDATE then
      o.im.Publish(BND_UPDATE_SELECT, true)
    elseif o.buttonsID[data.buttonID + 1] == ROSTER then
      o.im.Publish(BND_ROSTER_SELECT, true)
    elseif o.buttonsID[data.buttonID + 1] == FREE1 then
      o.im.Publish(BND_FREE1_SELECT, true)
    elseif o.buttonsID[data.buttonID + 1] == FREE2 then
      o.im.Publish(BND_FREE2_SELECT, true)
    elseif o.buttonsID[data.buttonID + 1] == FREE3 then
      o.im.Publish(BND_FREE3_SELECT, true)
    elseif o.buttonsID[data.buttonID + 1] == FREE4 then
      o.im.Publish(BND_FREE4_SELECT, true)
    end
  end)
   o.im.RegisterAction("act_update", function(actionName)
    local buttonYes = {
      icon = "$FooterIconYes",
      label = "Ok",
      clickEvents = {
        "evt_hide_popup"
      }
    }
    local popupData = {
      title = "Update",
      message = "***** \n FC25 [ MVNPROD ] \n You Are Already Using the Latest Version \n ******",
      buttons = {buttonYes}
    }
    o.nav.Event(nil, "evt_show_popup", popupData)
  end)
  return o
end
function MenuHub:HideSelections()
  self.im.Publish(BND_SETTINGS_SELECT, false)
  self.im.Publish(BND_PROFILE_SELECT, false)
  self.im.Publish(BND_UPDATE_SELECT, false)
  self.im.Publish(BND_ROSTER_SELECT, false)
  self.im.Publish(BND_FREE1_SELECT, false)
  self.im.Publish(BND_FREE2_SELECT, false)
  self.im.Publish(BND_FREE3_SELECT, false)
  self.im.Publish(BND_FREE4_SELECT, false)
end
function MenuHub:finalize()
  self.im.Unsubscribe(BND_SETTINGS_SELECT)
  self.im.Unsubscribe(BND_PROFILE_SELECT)
  self.im.Unsubscribe(BND_UPDATE_SELECT)
  self.im.Unsubscribe(BND_ROSTER_SELECT)
  self.im.Unsubscribe(BND_FREE1_SELECT)
  self.im.Unsubscribe(BND_FREE2_SELECT)
  self.im.Unsubscribe(BND_FREE3_SELECT)
  self.im.Unsubscribe(BND_FREE4_SELECT)
  self.im.UnregisterAction(ACT_MVNPROD)
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end
return MenuHub