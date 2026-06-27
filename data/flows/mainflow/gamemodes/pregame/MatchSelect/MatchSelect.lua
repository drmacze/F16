--- By MounTsa !!
local MatchSelect = {}
local eventmanager, PregameManager, CommonNavVars, TableUtil = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes

local BND_INFO_MATCH = "bnd_info_match"
local bndHomeTeamCrest = "bnd_logo_team_home"
local bndAwayTeamCrest = "bnd_logo_team_away"
local bndHomeTeamName = "bnd_home_team_name"
local bndAwayTeamName = "bnd_away_team_name"
local BND_MAN_TEAM_HOME = "bnd_man_team_home"
local BND_MAN_TEAM_AWAY = "bnd_man_team_away"
local bndWeatherType = "bnd_weather_type"
local bndStadiumName = "bnd_stadium_name"
local actSettings = "act_settings"
local ACT_ADVANCE = "act_advance"
local bndDif = "bnd_match_difficulty"

local BND_TAB1_VISIBLE = "bnd_tab1_visible"
local BND_TAB2_VISIBLE = "bnd_tab2_visible"
local BND_TAB3_VISIBLE = "bnd_tab3_visible"
local BND_TAB4_VISIBLE = "bnd_tab4_visible"
local ACT_BTN_CLICK = "act_btn_click"
local TAB1 = 1
local TAB2 = 2
local TAB3 = 3
local TAB4 = 4

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

  o.homeTeamID = o.services.gameSetup.GetHomeAssetId()
  o.awayTeamID = o.services.gameSetup.GetAwayAssetId()

  o.im.Subscribe(bndStadiumName, function()
    o.im.Publish(bndStadiumName, { name = "", id = o.homeTeamID })
  end)

  o.im.Subscribe(bndHomeTeamCrest, function()
    o.im.Publish(bndHomeTeamCrest, { name = "$Crest", id = o.homeTeamID })
  end)
  
  o.im.Subscribe(bndAwayTeamCrest, function()
    o.im.Publish(bndAwayTeamCrest, { name = "$Crest", id = o.awayTeamID })
  end)
  
  o.im.Subscribe(BND_MAN_TEAM_HOME, function()
    o.im.Publish(BND_MAN_TEAM_HOME, { name = "$PlayersPM", id = string.format("%d", o.homeTeamID)})
  end)
  
  o.im.Subscribe(BND_MAN_TEAM_AWAY, function()
    o.im.Publish(BND_MAN_TEAM_AWAY, { name = "$PlayersPM", id = string.format("%d", o.awayTeamID)})
  end)

  o.im.Subscribe(bndHomeTeamName, function()
    o.im.Publish(bndHomeTeamName, o.TeamsData[1].teamName)
  end)
  
  o.im.Subscribe(bndAwayTeamName, function()
    o.im.Publish(bndAwayTeamName, o.TeamsData[2].teamName)
  end)
  
  o.im.Subscribe(bndStadiumName, function()
    o.im.Publish(bndStadiumName, o.CurrentOptions.stadium)
  end)

  o.im.Subscribe(bndWeatherType, function()
    o.im.Publish(bndWeatherType, o.CurrentOptions.weather)
  end)
  
  o.im.RegisterAction(ACT_ADVANCE, function(actionName)
    o:PlayMatch()
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

  o.im.Subscribe(bndDif, function()
    o.im.Publish(bndDif, o.CurrentOptions.difficulty)
  end)

  o.im.Subscribe(BND_INFO_MATCH, function()
  local weather = o.CurrentOptions.weather or "Random"

  local currentDate = os.date("%I:%M %p")
  local state = "Stadium : " .. o.CurrentOptions.stadium ..
                "          Length : 4 - Half Length" ..
                "          Difficulty : " .. o.CurrentOptions.difficulty ..
                "          Condition: " .. weather .. " | " .. currentDate
  o.im.Publish(BND_INFO_MATCH, state)
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
    end
  end)

  return o
end

function MatchSelect:HideSelections()
  self.im.Publish(BND_TAB1_VISIBLE, false)
  self.im.Publish(BND_TAB2_VISIBLE, false)
  self.im.Publish(BND_TAB3_VISIBLE, false)
  self.im.Publish(BND_TAB4_VISIBLE, false)
end

-- Popup Play Match --
function MatchSelect:PlayMatch()
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Confirm",
    clickEvents = {
      "evt_advance",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = " PLAY MATCH ",
    message = " Are You Ready To Play Match Now ? ",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function MatchSelect:finalize()
  self.im.Unsubscribe(bndHomeTeamCrest)
  self.im.Unsubscribe(bndAwayTeamCrest)
  self.im.Unsubscribe(BND_MAN_TEAM_HOME)
  self.im.Unsubscribe(BND_MAN_TEAM_AWAY)
  self.im.Unsubscribe(bndWeatherType)
  self.im.Unsubscribe(bndStadiumName)
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.UnregisterAction(actSettings)
  self.im.UnregisterAction(actSquad)
  self.im.UnregisterAction(actSquadAway)
  self.im.Unsubscribe(bndDif)
  self.im.Unsubscribe(BND_TAB1_VISIBLE)
  self.im.Unsubscribe(BND_TAB2_VISIBLE)
  self.im.Unsubscribe(BND_TAB3_VISIBLE)
  self.im.Unsubscribe(BND_TAB4_VISIBLE)
  self.im.UnregisterAction(ACT_BTN_CLICK)
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end

return MatchSelect