-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local MatchSelect = {}

local eventmanager, PregameManager, CommonNavVars, TableUtil = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes

local BND_LOGO_TIM_HOME = "bnd_logo_tim_home"
local BND_LOGO_TIM_AWAY = "bnd_logo_tim_away"

local BND_NAMA_TIM_HOME = "bnd_nama_tim_home"
local BND_NAMA_TIM_AWAY = "bnd_nama_tim_away"

local BND_NAMA_STADION = "bnd_nama_stadion"

local ACT_PLAYMATCH = "act_playmatch"

function MatchSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    matchSetup = o.api("MatchSetupService"),
    gameSetup = o.api("GameSetupService"),
    gameState = o.api("GameStateService"),
    preGame = o.api("PregameService"),
    MatchInfoService = o.api("MatchInfoService"),
    SettingsService = o.api("SettingsService"),
    EventManagerService = o.api("EventManagerService")
  }
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)

  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()

  o.CurrentOptions = o.services.SettingsService.GetCurrentOptions()

  o.im.Subscribe(BND_LOGO_TIM_HOME, function()
    o.im.Publish(BND_LOGO_TIM_HOME, {
      name = "$Crest",
      id = string.format("%d", o.services.gameSetup.GetHomeAssetId())
    })
  end)
  o.im.Subscribe(BND_LOGO_TIM_AWAY, function()
    o.im.Publish(BND_LOGO_TIM_AWAY, {
      name = "$Crest",
      id = string.format("%d", o.services.gameSetup.GetAwayAssetId())
    })
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

  o.im.RegisterAction(ACT_PLAYMATCH, function(actionName)
    o:PlayMatch()
  end)

  return o
end

-- Menu Play Match --
function MatchSelect:PlayMatch()
  local buttonNo = {
    icon = "$IconButton_O",
    label = "LTXT_CMN_NO",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$IconButton_X",
    label = "LTXT_CMN_YES",
    clickEvents = {
      "evt_playmatch",
      "evt_hide_popup"
    }
  }
  local popupData = {
    message = " ARE YOU READY TO PLAY THIS MATCH NOW ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function MatchSelect:finalize()
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end

return MatchSelect