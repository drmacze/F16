--- By MounTsa !!

local MatchSelect = {}

local bndHomeTeamData = "bnd_logo_tim_home"
local bndHomeTeamName = "bnd_home_team_name"
local bndAwayTeamName = "bnd_away_team_name"
local bndAwayTeamData = "bnd_logo_tim_away"
local BND_HOME_KITS = "bnd_home_kits"
local BND_AWAY_KITS = "bnd_away_kits"
local BND_HOME_KITS_INDEX = "bnd_home_kit_index"
local BND_AWAY_KITS_INDEX = "bnd_away_kit_index"
local ACT_HOME_CHANGE = "act_change_home"
local ACT_AWAY_CHANGE = "act_change_away"
local bnd3DHomeKit = "bnd_3d_home_kit"
local bnd3DAwayKit = "bnd_3d_away_kit"
local bndHomeKitAlpha = "bnd_home_kit_alpha"
local bndAwayKitAlpha = "bnd_away_kit_alpha"
local bndBackBtnText = "bnd_back_btn_text"
local bndWeatherType = "bnd_weather_type"
local BND_LIVE_TILE_SQUAD = "bnd_live_tile_squad"
local bndStadiumName = "bnd_stadium_name"
local actSettings = "act_settings"
local ACT_PLAYMATCH = "act_playmatch"
local bndDif = "bnd_match_difficulty"

local currentMatch = {
   HomeKitIndex = 0,
   AwayKitIndex = 1,
}

function MatchSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    matchInfo = o.api("MatchInfoService"),
    settingsService = o.api("SettingsService"),
    UserPlate = o.api("UserPlateService"),
    MatchSetup = o.api("MatchSetupService"),
    GameSetup = o.api("GameSetupService"),
    GameState = o.api("GameStateService"),
    Pregame = o.api("PregameService"),
    LoggingService = o.api("LoggingService"),
    ClientServerService = o.api("ClientServerService"),
    EventManagerService = o.api("EventManagerService"),
    SaveLoadService = o.api("SaveLoadService")
  }
  
  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o.TeamsData = o.services.matchInfo.GetMatchTeams()

  o.homeTeamID = o.services.GameSetup.GetHomeAssetId()
  o.awayTeamID = o.services.GameSetup.GetAwayAssetId()

  o.im.Subscribe(bndStadiumName, function()
    o.im.Publish(bndStadiumName, { name = "", id = o.homeTeamID })
  end)

  o.im.Subscribe(bndHomeTeamData, function()
    o.im.Publish(bndHomeTeamData, { name = "$Crest", id = o.homeTeamID })
  end)
  
  o.im.Subscribe(bndAwayTeamData, function()
    o.im.Publish(bndAwayTeamData, { name = "$Crest", id = o.awayTeamID })
  end)

  

  o.homeTeamData = {
    { KITTYPE = 0, YEAR = 0, TEAMID = o.homeTeamID },
    { KITTYPE = 1, YEAR = 0, TEAMID = o.homeTeamID },
    { KITTYPE = 3, YEAR = 0, TEAMID = o.homeTeamID }
  }

  o.awayTeamData = {
    { KITTYPE = 0, YEAR = 0, TEAMID = o.awayTeamID },
    { KITTYPE = 1, YEAR = 0, TEAMID = o.awayTeamID },
    { KITTYPE = 3, YEAR = 0, TEAMID = o.awayTeamID }
  }

  o.im.Subscribe(bndHomeTeamName, function()
    o.im.Publish(bndHomeTeamName, o.TeamsData[1].teamName)
  end)
  
  o.im.Subscribe(bndAwayTeamName, function()
    o.im.Publish(bndAwayTeamName, o.TeamsData[2].teamName)
  end)
  
  o.im.Subscribe(bndStadiumName, function()
    o.im.Publish(bndStadiumName, o.currentOptions.stadium)
  end)


  o.im.Subscribe(bndWeatherType, function()
    o.im.Publish(bndWeatherType, o.currentOptions.weather)
  end)




  o.im.Subscribe(bnd3DHomeKit, function()
    o:publish3DHomeKit(o.homeTeamData[1])
  end)

  o.im.Subscribe(bnd3DAwayKit, function()
    o:publish3DAwayKit(o.awayTeamData[2])
  end)

  o.im.Subscribe(bndHomeKitAlpha, function()
    o:publishHomeKitAlpha()
  end)

  o.im.Subscribe(bndAwayKitAlpha, function()
    o:publishAwayKitAlpha()
  end)

  o.im.RegisterAction(actBack, function(actionName)
    o:_back()
  end)

  o.im.RegisterAction(actSettings, function(actionName, data)
    o.nav.Event(nil, "evt_to_settings")
  end)

  o.im.RegisterAction(actSquad, function(actionName, data)
    o.nav.Event(nil, "evt_to_squad")
  end)

  o.im.RegisterAction(actSquadAway, function(actionName, data)
    o.nav.Event(nil, "evt_to_squadaway")
  end)

  o.im.RegisterAction(ACT_PLAYMATCH, function(actionName)
    o:PlayMatch()
  end)

  o.im.Subscribe(bndDif, function()
    o.im.Publish(bndDif, o.currentOptions.difficulty)
  end)

  return o
end








-- Menu Play Match --
function MatchSelect:PlayMatch()
  local buttonNo = { icon = "$FooterIconNo", label = "Cancel", clickEvents = { "evt_hide_popup" } }
  local buttonYes = { icon = "$FooterIconYes", label = "Confirm", clickEvents = { "evt_playmatch", "evt_hide_popup" } }
  local popupData = { title = " PLAY MATCH ", message = " Are You Ready To Play Match Now? ", buttons = { buttonNo, buttonYes } }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function MatchSelect:checkAdvance()
  if self.services.GameState.GetControllerSide(0) == 0 then
    if not self.services.GameState.IsGamepadControllerConnected() and not self.data.skipFE then
      return false
    else
      return true
    end
  end
  return true
end

function MatchSelect:publish3DHomeKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd3DHomeKit, { name = "$playerkits", id = kitId })
end

function MatchSelect:publish3DAwayKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd3DAwayKit, { name = "$playerkits", id = kitId })
end

function MatchSelect:publishHomeKitAlpha()
  self.im.Publish(bndHomeKitAlpha, self.userSide == self.USER_SIDE.HOME and self.userKitSelectorAlpha or self.opponentKitSelectorAlpha)
end

function MatchSelect:publishAwayKitAlpha()
  self.im.Publish(bndAwayKitAlpha, self.userSide == self.USER_SIDE.AWAY and self.userKitSelectorAlpha or self.opponentKitSelectorAlpha)
end

function MatchSelect:finalize()
self.im.Unsubscribe(bndWeatherType)
  self.im.Unsubscribe(bndHomeTeamUser)
  self.im.Unsubscribe(bndHomeTeamData)
  self.im.Unsubscribe(bndAwayTeamData)
  self.im.Unsubscribe(bndAwayTeamUser)
  self.im.Unsubscribe(bndStadiumName)
  self.im.Unsubscribe(bnd3DPlayersVisible)
  self.im.Unsubscribe(bnd3DHomeKit)
  self.im.Unsubscribe(bnd3DAwayKit)
  self.im.Unsubscribe(bndHomeKitAlpha)
  self.im.Unsubscribe(bndAwayKitAlpha)
  self.im.Unsubscribe(bndBackBtnText)
  self.im.UnregisterAction(actSettings)
  self.im.UnregisterAction(actSquad)
  self.im.UnregisterAction(actSquadAway)
  self.im.Unsubscribe(bndDif)
  self.im.Unsubscribe(BND_HOME_KITS)
  self.im.Unsubscribe(BND_AWAY_KITS)
end

return MatchSelect