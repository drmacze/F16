local Save = ...
local Newgame = {}
local BND_TAB1_VISIBLE = "bnd_tab1_visible"
local BND_TAB2_VISIBLE = "bnd_tab2_visible"
local BND_TAB3_VISIBLE = "bnd_tab3_visible"
local BND_TAB4_VISIBLE = "bnd_tab4_visible"
local BND_TAB5_VISIBLE = "bnd_tab5_visible"
local ACT_BTN_CLICK = "act_btn_click"
local TAB1 = 1
local TAB2 = 2
local TAB3 = 3
local TAB4 = 4
local TAB5 = 5
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
local ACT_NEWGAME = "act_newgame"
local ACT_LOADGAME = "act_loadgame"
local savedata = Save or {}

function Newgame:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    BrowserService = o.api("BrowserService"),
    MiscService = o.api("MiscService"),
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
  }
  
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
  o:handleEvent(...)
  end)
  o.buttonsID = { TAB1, TAB2, TAB3, TAB4, TAB5 }
  o.im.Subscribe(BND_TAB1_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB2_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB3_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB4_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB5_VISIBLE, function()
  end)
  o:HideSelections()
  o.im.Publish(BND_TAB1_VISIBLE, true)
  o.im.RegisterAction(ACT_BTN_CLICK, function(actionName, data)
    o:HideSelections()
    if o.buttonsID[data.buttonID + 1] == TAB1 then
      o.im.Publish(BND_TAB1_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB2 then
      o.im.Publish(BND_TAB2_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB3 then
      o.im.Publish(BND_TAB3_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB4 then
      o.im.Publish(BND_TAB4_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB5 then
      o.im.Publish(BND_TAB5_VISIBLE, true)
    end
  end)
  o.im.Subscribe("bnd_matchday_label", function()
    o:publishLabel()
  end)
  o.im.RegisterAction(ACT_NEWGAME, function(actionName, data)
    o:newGame()
  end)
  o.im.RegisterAction(ACT_LOADGAME, function(actionName, data)
    o:loadGame()
  end)

  return o
end
function Newgame:publishLabel()
local text = ""
    if not LigaGrouping[ligaId] then
      text = "NEW \nCAREER"
    else
      text = "CONTINUE \nCAREER"
    end
  self.im.Publish("bnd_matchday_label", text)
end

function Newgame:newGame()
  savemode = 0
  if LigaGrouping[ligaId] then
    self.nav.Event(nil, "evt_load")  
  else
    self.nav.Event(nil, "evt_new")
  end
end

function Newgame:loadGame()
  if not savedata.TeamList then
    self:noSave()
  else
    savemode = 1
    self.nav.Event(nil, "evt_load")
  end
end

function Newgame:noSave()
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Confirm",
    clickEvents = {
      "evt_hide_popup",
      "evt_back"
    }
  }
  local popupData = {
    title = "INFO",
    message = "You have no saved games",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Newgame:HideSelections()
  self.im.Publish(BND_TAB1_VISIBLE, false)
  self.im.Publish(BND_TAB2_VISIBLE, false)
  self.im.Publish(BND_TAB3_VISIBLE, false)
  self.im.Publish(BND_TAB4_VISIBLE, false)
  self.im.Publish(BND_TAB5_VISIBLE, false)
end

function Newgame:finalize()
  self.im.Unsubscribe(BND_TAB1_VISIBLE)
  self.im.Unsubscribe(BND_TAB2_VISIBLE)
  self.im.Unsubscribe(BND_TAB3_VISIBLE)
  self.im.Unsubscribe(BND_TAB4_VISIBLE)
  self.im.Unsubscribe(BND_TAB5_VISIBLE)
  self.im.UnregisterAction(ACT_BTN_CLICK)
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  self.im.UnregisterAction(ACT_NEWGAME)
  self.im.UnregisterAction(ACT_LOADGAME)
  self.im.Unsubscribe("bnd_matchday_label")
end
return Newgame