
local DetailStats = {}

local eventmanager, PregameManager, CommonNavVars, TableUtil = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes

local BND_LOGO_TIM_HOME = "bnd_logo_tim_home"
local BND_LOGO_TIM_AWAY = "bnd_logo_tim_away"

local BND_NAMA_TIM_HOME = "bnd_nama_tim_home"
local BND_NAMA_TIM_AWAY = "bnd_nama_tim_away"

local bndDif = "bnd_match_difficulty"

function DetailStats:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    matchSetup = o.api("MatchSetupService"),
    gameSetup = o.api("GameSetupService"),
    gameState = o.api("GameStateService"),
    preGame = o.api("PregameService"),
    MatchInfoService = o.api("MatchInfoService"),
    settingsService = o.api("SettingsService"),
    EventManagerService = o.api("EventManagerService")
  }
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)

  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()

  o.currentOptions = o.services.settingsService.GetCurrentOptions()

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
o.im.Subscribe(bndDif, function()
      o.im.Publish(bndDif, o.currentOptions.difficulty)
  end)
  o.im.RegisterAction(ACT_PLAYMATCH, function(actionName)
    o:PlayMatch()
  end)

  return o
end

function DetailStats:finalize()

  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  
  self.im.Unsubscribe(BND_LOGO_TIM_HOME)
  self.im.Unsubscribe(BND_LOGO_TIM_AWAY)    
  self.im.Unsubscribe(BND_NAMA_TIM_HOME)
  self.im.Unsubscribe(BND_NAMA_TIM_AWAY)
  self.im.Unsubscribe(bndDif)
  
end

return DetailStats 

-- Created By Ma'ruf ID YouTube --