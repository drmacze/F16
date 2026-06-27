
-- New FriendlyTeamSelect by MVNPROD YouTube Channel --

local eventmanager, PregameManager, CommonNavVars, AwayTeamSelectModel, TableUtil = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes
local FriendlyTeamSelect = {}
local PRIVATE_MATCH_CONNECTION_STATES = PregameManager.FE.FIFA.PrivateMatchConnectionState
local bndAwayTeamData = "bnd_away_team_selector"
local bndAway2TeamData = "bnd_away2_team_selector"
local bndAway3TeamData = "bnd_away3_team_selector"
local bndAwayTeamTeamName = "bnd_away_team_team_name"
local bndAwayCountryName = "bnd_away_country_name"
local bndAwayLeagueName = "bnd_away_league_name"
local bndAwayCountryFlag = "bnd_away_country_flag"
local bndAwayLeagueLogo = "bnd_away_league_logo"
local bndAwayUserPlate = "bnd_away_user_plate"
local bndAwayUserPlateVisible = "bnd_away_user_plate_visible"
local bndAwayTeamSelectorAlpha = "bnd_away_team_selector_alpha"
local bndAwayRealTeamVisible = "bnd_away_real_team_visible"
local bndAwayTeamCountry = "bnd_away_team_country"
local bndAwayTeamLeague = "bnd_away_team_league"
local bndAwayTeamName = "bnd_away_team_name"
local bndAwayTeamMessagesVisible = "bnd_away_team_messages_visible"
local bndAwayTeamMessage = "bnd_away_team_message"
local bndAwayRealTeamTogglesVisible = "bnd_away_real_team_toggles_visible"
local BND_HOME_COUNTRY_SELECT_VISIBLE = "bnd_home_country_select_visible"
local BND_HOME_TEAM_SELECT_VISIBLE = "bnd_home_team_select_visible"
local BND_HOME_LEAGUE_SELECT_VISIBLE = "bnd_home_league_select_visible"
local BND_AWAY_COUNTRY_SELECT_VISIBLE = "bnd_away_country_select_visible"
local BND_AWAY_TEAM_SELECT_VISIBLE = "bnd_away_team_select_visible"
local BND_AWAY_LEAGUE_SELECT_VISIBLE = "bnd_away_league_select_visible"
local BND_ALL_READY = "bnd_all_ready"
local act_btn_click = "act_btn_click"
local actAwayCountryPrevious = "act_away_country_previous"
local actAwayCountryNext = "act_away_country_next"
local actAwayLeaguePrevious = "act_away_league_previous"
local actAwayLeagueNext = "act_away_league_next"
local actAwayTeamPrevious = "act_away_team_previous"
local actAwayTeamNext = "act_away_team_next"
local COUNTRY_H = 2
local TEAM_H = 1
local LEAGUE_H = 3
local COUNTRY_A = 4
local TEAM_A = 5
local LEAGUE_A = 6
local ALL_READY = 7
function FriendlyTeamSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.navContext = o.data
  o.services = {
    MatchInfo = o.api("MatchInfoService"),
    MatchSetup = o.api("MatchSetupService"),
    GameSetup = o.api("GameSetupService"),
    Pregame = o.api("PregameService"),
    Country = o.api("CountryService"),
    Logging = o.api("LoggingService"),
    EventManagerService = o.api("EventManagerService")
  }
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
  o:handleEvent(...)
  end)
  o.models = {
    AwayTeamSelectModel = AwayTeamSelectModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      navContext = o.navContext
    })
  }
  o.USER_SIDE = {HOME = "home", AWAY = "away"}
  o.countryToggleId = 0
  o.leagueToggleId = 1
  o.teamToggleId = 2
  o.toggleSideAway = 1
  o.awayInitialized = false
  o.isDynamic = o.models.AwayTeamSelectModel:isDynamic()
  o.userSide = o.USER_SIDE.HOME
  if o.navContext.flow == CommonNavVars.FLOWS.ONLINE or o.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
     o.userSide = o.services.GameSetup.IsHostTeam() and o.USER_SIDE.HOME or o.USER_SIDE.AWAY
  end
  o.awayTeamId = -1
  o.initialAwayTeamId = -1
  o.userPlateVisible = true
  o.opponentTeamSelectorAlpha = 1
  o.opponentUserData = o.models.AwayTeamSelectModel:getOpponentUserData()
  o.unknownTeamData = o.models.AwayTeamSelectModel:getUnknownTeamData()
  o.im.Subscribe(bndAwayTeamMessagesVisible, function()
    o:publishAwayTeamMessagesVisible()
  end)
  o.im.Subscribe(bndAwayTeamMessage, function()
    o:publishAwayTeamMessage()
  end)
  o.im.Subscribe(bndAwayUserPlate, function()
    o:publishAwayUserPlate()
  end)
  o.im.Subscribe(bndAwayTeamSelectorAlpha, function()
    o:publishAwayTeamSelectorAlpha()
  end)
  o.im.Subscribe(bndAwayRealTeamVisible, function()
    o:publishAwayRealTeamVisible()
  end)
  o.im.Subscribe(bndAwayRealTeamTogglesVisible, function()
    o:publishAwayRealTeamTogglesVisible()
  end)
  if o.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
    o.im.Subscribe(bndAwayUserPlateVisible, function()
      o:publishAwayUserPlateVisible()
    end)
  end
  if o.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
    if o.navContext.flow == CommonNavVars.FLOWS.ONLINE or o.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
      local teams = o.services.MatchInfo.GetMatchTeams()
      o:setAwayTeamData(o.unknownTeamData)
    elseif o.navContext.flow == CommonNavVars.FLOWS.OFFLINE then
      local teams = o.services.MatchInfo.GetMatchTeams()
      o:setAwayTeamData(o.models.AwayTeamSelectModel:getSquadDataFromMatchInfo(teams[2]))
      o.models.AwayTeamSelectModel:setTeam(o.awayTeam.teamId)
    end
  else
    if o.isDynamic or o.navContext.flow == CommonNavVars.FLOWS.OFFLINE then
      o.awayTeamId = o.services.MatchSetup.RequestDefaultOptions(o.toggleSideAway)
    elseif o.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
      o:setAwayTeamData(o.unknownTeamData)
    else
      o:setAwayTeamData(o.unknownTeamData)
    end
    o.im.RegisterAction(actAwayCountryPrevious, function(actionName, data)
      o:sendToggleInfo(1, o.countryToggleId, 0)
      o.services.MatchSetup.TogglePrevious(o.toggleSideAway, o.countryToggleId)
    end)
    o.im.RegisterAction(actAwayCountryNext, function(actionName, data)
      o:sendToggleInfo(1, o.countryToggleId, 1)
      o.services.MatchSetup.ToggleNext(o.toggleSideAway, o.countryToggleId)
    end)
    o.im.RegisterAction(actAwayLeaguePrevious, function(actionName, data)
      o:sendToggleInfo(1, o.leagueToggleId, 0)
      o.services.MatchSetup.TogglePrevious(o.toggleSideAway, o.leagueToggleId)
    end)
    o.im.RegisterAction(actAwayLeagueNext, function(actionName, data)
      o:sendToggleInfo(1, o.leagueToggleId, 1)
      o.services.MatchSetup.ToggleNext(o.toggleSideAway, o.leagueToggleId)
    end)
    o.im.RegisterAction(actAwayTeamPrevious, function(actionName, data)
      o:sendToggleInfo(1, o.teamToggleId, 0)
      o.services.MatchSetup.TogglePrevious(o.toggleSideAway, o.teamToggleId)
    end)
    o.im.RegisterAction(actAwayTeamNext, function(actionName, data)
      o:sendToggleInfo(1, o.teamToggleId, 1)
      o.services.MatchSetup.ToggleNext(o.toggleSideAway, o.teamToggleId)
    end)
  end
  if o.isDynamic then
     o.services.Pregame.ListenTeamSelectionEvents()
  end
  o.buttonsID = { TEAM_H, COUNTRY_H, LEAGUE_H, COUNTRY_A, TEAM_A, LEAGUE_A, ALL_READY }
  o:HideSelections()
  o.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, true)
  o.im.Subscribe(BND_HOME_COUNTRY_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_HOME_TEAM_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_HOME_LEAGUE_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_AWAY_COUNTRY_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_AWAY_TEAM_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_AWAY_LEAGUE_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_ALL_READY, function()
  end)
  o.im.RegisterAction(act_btn_click, function(actionName, data)
    o:HideSelections()
    if o.buttonsID[data.buttonID + 1] == COUNTRY_H then
      o.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TEAM_H then
      o.im.Publish(BND_HOME_TEAM_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == LEAGUE_H then
      o.im.Publish(BND_HOME_LEAGUE_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == COUNTRY_A then
      o.im.Publish(BND_AWAY_COUNTRY_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TEAM_A then
      o.im.Publish(BND_AWAY_TEAM_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == LEAGUE_A then
      o.im.Publish(BND_AWAY_LEAGUE_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == ALL_READY then
      o.im.Publish(BND_ALL_READY, true)
    end
  end)
  return o
end
function FriendlyTeamSelect:getPrivateMatchConnetionStatus(state)
  if state == PRIVATE_MATCH_CONNECTION_STATES.NotConnected then
    return self.loc.LocalizeString("LTXT_INV_P2P_STATUS_NOT_CONNECTED")
  elseif state == PRIVATE_MATCH_CONNECTION_STATES.Connected then
    return self.loc.LocalizeString("LTXT_INV_P2P_STATUS_CONNECTED")
  elseif state == PRIVATE_MATCH_CONNECTION_STATES.WaitingForOpponent then
    return self.loc.LocalizeString("LTXT_INV_P2P_STATUS_WAITING")
  else
    error("Invalid private match connection state: " .. tostring(state))
  end
end
function FriendlyTeamSelect:handleEvent(eventType, data)
  if eventType == EventTypes.OnTeamDataChanged then
    self:onTeamDataChanged(data)
  elseif eventType == EventTypes.MatchSetupSelectedTeamChanged then
    self:onToggleCompleted(data.currentTeamInfo, data.resetRoster)
  elseif eventType == EventTypes.PrivateMatchConnectionStatusChanged then
    self:publishAwayTeamMessage()
  end
end
function FriendlyTeamSelect:sendToggleInfo(side, toggle, direction)
  if self.isDynamic == true then
    local teamData = {}
    teamData.DIRECTION = direction
    teamData.SIDE = side
    teamData.TOGGLE = toggle
    self.services.Pregame.HandleTeamChange(teamData)
  end
end
function FriendlyTeamSelect:publishAwayTeamMessagesVisible()
  self.im.Publish(bndAwayTeamMessagesVisible, self.navContext.flow == CommonNavVars.FLOWS.ONLINE or self.navContext.flow == CommonNavVars.TYPES.FRIENDLY)
end
function FriendlyTeamSelect:publishAwayTeamMessage()
  local msg = ""
  if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
    if self.navContext.type == CommonNavVars.TYPES.FRIENDLY then
      msg = self:getPrivateMatchConnetionStatus(self.services.Pregame.GetPrivateMatchConnectionState())
    else
      msg = self.loc.LocalizeString("LTXT_PREGAME_CLICK_SEARCH")
    end
  elseif self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL then
    msg = self.loc.LocalizeString("LTXT_PREGAME_WILL_MATCHMAKE")
  end
  self.im.Publish(bndAwayTeamMessage, msg)
end
function FriendlyTeamSelect:publishAwayRealTeamVisible()
  self.im.Publish(bndAwayRealTeamVisible, self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT and self.navContext.flow == CommonNavVars.FLOWS.OFFLINE)
end
function FriendlyTeamSelect:publishAwayRealTeamTogglesVisible()
  self.im.Publish(bndAwayRealTeamTogglesVisible, self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL and self.navContext.flow == CommonNavVars.FLOWS.OFFLINE or self.isDynamic)
end
function FriendlyTeamSelect:publishAwayUserPlate()
  self.im.Publish(bndAwayUserPlate, self.opponentUserData)
end
function FriendlyTeamSelect:publishAwayUserPlateVisible()
  self.im.Publish(bndAwayUserPlateVisible, self.userSide == self.USER_SIDE.HOME and self.userPlateVisible)
end
function FriendlyTeamSelect:publishAwayTeamSelectorAlpha()
  self.im.Publish(bndAwayTeamSelectorAlpha, self.userSide == self.USER_SIDE.HOME and self.opponentTeamSelectorAlpha or 1)
end
function FriendlyTeamSelect:setAwayTeamData(awayTeamValue)
  self.awayTeamId = awayTeamValue.teamId
  self.im.Subscribe(bndAwayTeamTeamName, function()
    self:publishTeamData(bndAwayTeamTeamName, awayTeamValue.teamName)
  end)
  self.im.Subscribe(bndAwayTeamData, function()
    self:publishTeamData(bndAwayTeamData, awayTeamValue)
  end)
  if self.navContext.flow ~= CommonNavVars.TYPES.FRIENDLY then
    self:setAwayTeamExtraData()
  end
end
function FriendlyTeamSelect:setAwayTeamData(awayTeamValue)
  self.awayTeamId = awayTeamValue.teamId
  self.im.Subscribe(bndAwayTeamTeamName, function()
    self:publishTeamData(bndAwayTeamTeamName, awayTeamValue.teamName)
  end)
  self.im.Subscribe(bndAway2TeamData, function()
    self:publish2TeamData(bndAway2TeamData, awayTeamValue)
  end)
  if self.navContext.flow ~= CommonNavVars.TYPES.FRIENDLY then
    self:setAwayTeamExtraData()
  end
end
function FriendlyTeamSelect:setAwayTeamData(awayTeamValue)
  self.awayTeamId = awayTeamValue.teamId
  self.im.Subscribe(bndAwayTeamTeamName, function()
    self:publishTeamData(bndAwayTeamTeamName, awayTeamValue.teamName)
  end)
  self.im.Subscribe(bndAway3TeamData, function()
    self:publish3TeamData(bndAway3TeamData, awayTeamValue)
  end)
  if self.navContext.flow ~= CommonNavVars.TYPES.FRIENDLY then
    self:setAwayTeamExtraData()
  end
end
function FriendlyTeamSelect:setAwayTeamExtraData()
  self.services.Logging.Log("LUA", "away team id is " .. self.awayTeamId)
  if self.awayTeamId > 0 then
    do
      local league = self.services.Country.GetLeagueInfoByTeamId(self.awayTeamId)
      local country = self.services.Country.GetCountryInfoByLeagueId(league.id)
      self.im.Subscribe(bndAwayCountryName, function()
        self:publishTeamData(bndAwayCountryName, country.name)
      end)
      self.im.Subscribe(bndAwayLeagueName, function()
        self:publishTeamData(bndAwayLeagueName, league.name)
      end)
      self.im.Subscribe(bndAwayCountryFlag, function()
        self:publishTeamData(bndAwayCountryFlag, country.id)
      end)
      self.im.Subscribe(bndAwayLeagueLogo, function()
        self:publishTeamData(bndAwayLeagueLogo, league.id)
      end)
    end
  end
end
function FriendlyTeamSelect:publishTeamData(bindingName, value)
  if bindingName == bndAwayTeamData then
    if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
      if self.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
        self.im.Publish(bndAwayTeamData, {
          chemistry = value.chemistry,
          ratingLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_RATING_LABEL"),
          chemLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_CHEMISTRY_LABEL"),
          crest = {
            name = "$Crest",
            id = string.format("%d", value.crestId)
          },
          starRating = value.starRating,
          overall = value.overall,
          teamRating = value.teamRating
        })
       end
     else
      self.im.Publish(bndAwayTeamData, {
        crest = {
          name = "$Crest",
          id = string.format("%d", value.crestId)
        },
        leagueCrest = {
          name = "$LeagueCrest",
          id = string.format("%s", value.leagueName)
        },
        flagCrest = {
          name = "$Flag128x128",
          id = string.format("%s", value.flagName)
        },
        starRating = value.starRating,
        teamRating = value.teamRating
      })
    end
    if self.navContext.flow == CommonNavVars.FLOWS.OFFLINE or self.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
      self.initialAwayTeamId = value.teamId
      self.models.AwayTeamSelectModel:setAwayTeam(value)
      if self.navContext.fromScreen == "PrematchFlow" then
        self.models.AwayTeamSelectModel:setTeam(self.initialAwayTeamId)
      end
      self.models.AwayTeamSelectModel:setupTeams()
    end
  elseif bindingName == bndAwayTeamCountry then
    self.im.Publish(bndAwayTeamCountry, value)
  elseif bindingName == bndAwayTeamLeague then
    self.im.Publish(bndAwayTeamLeague, value)
  elseif bindingName == bndAwayTeamName then
    self.im.Publish(bndAwayTeamName, value)
  else
    print("FriendlyTeamSelect:: Teamdata out of bounds.")
  end
end
function FriendlyTeamSelect:publish2TeamData(bindingName, value)
  if bindingName == bndAway2TeamData then
    if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
      if self.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
        self.im.Publish(bndAway2TeamData, {
          chemistry = value.chemistry,
          ratingLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_RATING_LABEL"),
          chemLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_CHEMISTRY_LABEL"),
          crest = {
            name = "$Crest",
            id = string.format("%d", value.crestId)
          },
          starRating = value.starRating,
          overall = value.overall,
          teamRating = value.team2Rating
        })
       end
     else
      self.im.Publish(bndAway2TeamData, {
        crest = {
          name = "$Crest",
          id = string.format("%d", value.crestId)
        },
        leagueCrest = {
          name = "$LeagueCrest",
          id = string.format("%s", value.leagueName)
        },
        flagCrest = {
          name = "$Flag128x128",
          id = string.format("%s", value.flagName)
        },
        starRating = value.starRating,
        teamRating = value.team2Rating
      })
    end
    if self.navContext.flow == CommonNavVars.FLOWS.OFFLINE or self.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
      self.initialAwayTeamId = value.teamId
      self.models.AwayTeamSelectModel:setAwayTeam(value)
      if self.navContext.fromScreen == "PrematchFlow" then
        self.models.AwayTeamSelectModel:setTeam(self.initialAwayTeamId)
      end
      self.models.AwayTeamSelectModel:setupTeams()
    end
  elseif bindingName == bndAwayTeamCountry then
    self.im.Publish(bndAwayTeamCountry, value)
  elseif bindingName == bndAwayTeamLeague then
    self.im.Publish(bndAwayTeamLeague, value)
  elseif bindingName == bndAwayTeamName then
    self.im.Publish(bndAwayTeamName, value)
  else
    print("FriendlyTeamSelect:: Teamdata out of bounds.")
  end
end
function FriendlyTeamSelect:publish3TeamData(bindingName, value)
  if bindingName == bndAway3TeamData then
    if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
      if self.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
        self.im.Publish(bndAway3TeamData, {
          chemistry = value.chemistry,
          ratingLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_RATING_LABEL"),
          chemLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_CHEMISTRY_LABEL"),
          crest = {
            name = "$Crest",
            id = string.format("%d", value.crestId)
          },
          starRating = value.starRating,
          overall = value.overall,
          teamRating = value.teamRating
        })
       end
     else
      self.im.Publish(bndAway3TeamData, {
        crest = {
          name = "$Crest",
          id = string.format("%d", value.crestId)
        },
        leagueCrest = {
          name = "$LeagueCrest",
          id = string.format("%s", value.leagueName)
        },
        flagCrest = {
          name = "$Flag128x128",
          id = string.format("%s", value.flagName)
        },
        starRating = value.starRating,
        teamRating = value.teamRating
      })
    end
    if self.navContext.flow == CommonNavVars.FLOWS.OFFLINE or self.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
      self.initialAwayTeamId = value.teamId
      self.models.AwayTeamSelectModel:setAwayTeam(value)
      if self.navContext.fromScreen == "PrematchFlow" then
        self.models.AwayTeamSelectModel:setTeam(self.initialAwayTeamId)
      end
      self.models.AwayTeamSelectModel:setupTeams()
    end
  elseif bindingName == bndAwayTeamCountry then
    self.im.Publish(bndAwayTeamCountry, value)
  elseif bindingName == bndAwayTeamLeague then
    self.im.Publish(bndAwayTeamLeague, value)
  elseif bindingName == bndAwayTeamName then
    self.im.Publish(bndAwayTeamName, value)
  else
    print("FriendlyTeamSelect:: Teamdata out of bounds.")
  end
end
function FriendlyTeamSelect:onToggleCompleted(selected, resetRoster)
  local country = selected.country
  local league = selected.league
  local teamName = selected.team
  local side = selected.side
  local teamData = {
    teamId = selected.teamRatings.teamId,
    teamName = teamName,
    crestId = selected.teamRatings.teamId,
    flagName = selected.countryId,
    leagueName = selected.leagueId,
    starRating = selected.teamRatings.starRating,
    overall = selected.teamRatings.overall,
    teamRating = {
      attackValue = selected.teamRatings.offense,
      middleValue = selected.teamRatings.midfield,
      defenseValue = selected.teamRatings.defense,
      attackLabel = self.loc.LocalizeString("LTXT_CMN_ATT"),
      middleLabel = self.loc.LocalizeString("LTXT_CMN_MID"),
      defenseLabel = self.loc.LocalizeString("LTXT_CMN_DEF")
    },
    team2Rating = {
      attackValueHome = selected.teamRatings.offense,
      middleValueHome = selected.teamRatings.midfield,
      defenseValueHome = selected.teamRatings.defense,
      attackLabelHome = self.loc.LocalizeString("LTXT_CMN_ATT"),
      middleLabelHome = self.loc.LocalizeString("LTXT_CMN_MID"),
      defenseLabelHome = self.loc.LocalizeString("LTXT_CMN_DEF")
    },
    chemistry = 0,
    overall = 0
  }
  if side == self.USER_SIDE.AWAY then
    if self.awayTeamId ~= teamData.teamId then
      self.awayTeamId = teamData.teamId
      if self.initialAwayTeamId ~= self.awayTeamId then
        self.initialAwayTeamId = -1
        if resetRoster or fromScreen == "PrematchFlow" then
          self.models.AwayTeamSelectModel:setTeam(self.awayTeamId)
        end
      end
    end
    if self.awayInitialized == false then
      self.im.Subscribe(bndAwayTeamCountry, function()
        self:publishTeamData(bndAwayTeamCountry, country)
      end)
      self.im.Subscribe(bndAwayTeamLeague, function()
        self:publishTeamData(bndAwayTeamLeague, league)
      end)
      self.im.Subscribe(bndAwayTeamName, function()
        self:publishTeamData(bndAwayTeamName, teamName)
      end)
      self.im.Subscribe(bndAwayTeamData, function()
        self:publishTeamData(bndAwayTeamData, teamData)
      end)
      self.im.Subscribe(bndAway2TeamData, function()
        self:publish2TeamData(bndAway2TeamData, teamData)
      end)
      self.im.Subscribe(bndAway3TeamData, function()
        self:publish3TeamData(bndAway3TeamData, teamData)
      end)
      self.awayInitialized = true
    else
      self:publishTeamData(bndAwayTeamCountry, country)
      self:publishTeamData(bndAwayTeamLeague, league)
      self:publishTeamData(bndAwayTeamName, teamName)
      self:publishTeamData(bndAwayTeamData, teamData)
      self:publish2TeamData(bndAway2TeamData, teamData)
      self:publish3TeamData(bndAway3TeamData, teamData)
    end
  end
end
function FriendlyTeamSelect:onTeamDataChanged(teamData)
  local direction = teamData.DIRECTION
  if direction == 0 then
    self.services.MatchSetup.TogglePrevious(teamData.SIDE, teamData.TOGGLE)
  else
    self.services.MatchSetup.ToggleNext(teamData.SIDE, teamData.TOGGLE)
  end
end
function FriendlyTeamSelect:HideSelections()
  self.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, false)
  self.im.Publish(BND_HOME_TEAM_SELECT_VISIBLE, false)
  self.im.Publish(BND_HOME_LEAGUE_SELECT_VISIBLE, false)
  self.im.Publish(BND_AWAY_COUNTRY_SELECT_VISIBLE, false)
  self.im.Publish(BND_AWAY_TEAM_SELECT_VISIBLE, false)
  self.im.Publish(BND_AWAY_LEAGUE_SELECT_VISIBLE, false)
  self.im.Publish(BND_ALL_READY, false)
end
function FriendlyTeamSelect:finalize()
  self.im.UnregisterAction(act_btn_click)
  self.im.Unsubscribe(bndAwayTeamData)
  self.im.Unsubscribe(bndAway2TeamData)
  self.im.Unsubscribe(bndAway3TeamData)
  self.im.Unsubscribe(bndAwayTeamTeamName)
  self.im.Unsubscribe(bndAwayRealTeamVisible)
  self.im.Unsubscribe(BND_HOME_COUNTRY_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_HOME_TEAM_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_HOME_LEAGUE_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_AWAY_COUNTRY_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_AWAY_TEAM_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_AWAY_LEAGUE_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_ALL_READY)
  if self.navContext.flow ~= CommonNavVars.TYPES.FRIENDLY then
    self.im.Unsubscribe(bndAwayCountryName)
    self.im.Unsubscribe(bndAwayLeagueName)
    self.im.Unsubscribe(bndAwayCountryFlag)
    self.im.Unsubscribe(bndAwayLeagueLogo)
  end
  self.im.Unsubscribe(bndAwayUserPlate)
  self.im.Unsubscribe(bndAwayTeamSelectorAlpha)
  if self.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
    self.im.Unsubscribe(bndAwayUserPlateVisible)
  end
  self.im.Unsubscribe(bndAwayTeamCountry)
  self.im.Unsubscribe(bndAwayTeamLeague)
  self.im.Unsubscribe(bndAwayTeamName)
  self.im.Unsubscribe(bndAwayRealTeamTogglesVisible)
  self.im.Unsubscribe(bndAwayTeamMessagesVisible)
  self.im.Unsubscribe(bndAwayTeamMessage)
  if self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL then
    self.im.UnregisterAction(actAwayCountryPrevious)
    self.im.UnregisterAction(actAwayCountryNext)
    self.im.UnregisterAction(actAwayLeaguePrevious)
    self.im.UnregisterAction(actAwayLeagueNext)
    self.im.UnregisterAction(actAwayTeamPrevious)
    self.im.UnregisterAction(actAwayTeamNext)
  end
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  if self.isDynamic then
    self.services.Pregame.UnlistenTeamSelectionEvents()
  end
  homeInitialized = false
  self.models.AwayTeamSelectModel:finalize()
end
return FriendlyTeamSelect

-- Thanks : Ma'ruf Id & Laosiji --
-- And All Modder --
-- New FriendlyTeamSelect by MVNPROD YouTube Channel --