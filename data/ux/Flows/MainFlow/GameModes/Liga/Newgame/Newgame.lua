local Save = ...
local Newgame = {}
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
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
  }
  
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

function Newgame:finalize()
  self.im.UnregisterAction(ACT_NEWGAME)
  self.im.UnregisterAction(ACT_LOADGAME)
  self.im.Unsubscribe("bnd_matchday_label")
end
return Newgame