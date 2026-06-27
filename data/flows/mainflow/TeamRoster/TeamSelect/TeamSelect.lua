-- New TeamSheets Fifa 16 Improved By MounTsa  --
local TeamSelect = {}
local eventmanager, PregameManager, CommonNavVars, HomeTeamSelectModel, TableUtil, FormationModel = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes
local PRIVATE_MATCH_CONNECTION_STATES = PregameManager.FE.FIFA.PrivateMatchConnectionState
local bndHomeTeamUser = "bnd_panel_home_title"
local bndHomeTeamData = "bnd_home_team_selector"
local bndHome2TeamData = "bnd_home2_team_selector"
local bndHome3TeamData = "bnd_home3_team_selector"
local bndHomeSquadName = "bnd_home_squad_name"
local bndHomeRealTeamVisible = "bnd_home_real_team_visible"
local bndHomeFutSquadVisible = "bnd_home_fut_squad_visible"
local bndHomeFriendlyTeamVisible = "bnd_home_friendly_team_visible"
local bndHomeUserPlate = "bnd_home_user_plate"
local bndHomeTeamSelectorAlpha = "bnd_home_team_selector_alpha"
local bndLabelTickernavpublisher = "bnd_label_tickernavpublisher"
local bndAutodisableTickernavpublisher = "bnd_autodisable_tickernavpublisher"
local bndHomeTeamCountry = "bnd_home_team_country"
local bnd2DHomeKit = "bnd_2d_home_kit"
local bndGkHomeKit = "bnd_gk_kit"
local bndHomeTeamLeague = "bnd_home_team_league"
local bndHomeTeamName = "bnd_home_team_name"
local BND_TEAM_RATING_LABEL = "bnd_team_rating_label"
local BND_TEAM_FORMATION = "bnd_team_formation"
local BND_TEAM_NUMBER = "bnd_team_number"
local BND_HOME_COUNTRY_SELECT_VISIBLE = "bnd_home_country_select_visible"
local BND_HOME_TEAM_SELECT_VISIBLE = "bnd_home_team_select_visible"
local BND_HOME_LEAGUE_SELECT_VISIBLE = "bnd_home_league_select_visible"
local ACT_BTN_CLICK = "act_btn_click"
local bndOptionsEnabled = "bnd_options_enabled"
local actAdvance = "act_advance"
local actBack = "act_back"
local actSettings = "act_settings"
local actSquad = "act_squad"
local actSquadAway = "act_squadaway"
local actHomeCountryPrevious = "act_home_country_previous"
local actHomeCountryNext = "act_home_country_next"
local actHomeLeaguePrevious = "act_home_league_previous"
local actHomeLeagueNext = "act_home_league_next"
local actHomeTeamPrevious = "act_home_team_previous"
local actHomeTeamNext = "act_home_team_next"
local bndPlayer1 = "bnd_player_1"
local bndPlayer2 = "bnd_player_2"
local bndPlayer3 = "bnd_player_3"
local bndPlayer4 = "bnd_player_4"
local bndPlayer5 = "bnd_player_5"
local bndPlayer6 = "bnd_player_6"
local bndPlayer7 = "bnd_player_7"
local bndPlayer8 = "bnd_player_8"
local bndPlayer9 = "bnd_player_9"
local bndPlayer10 = "bnd_player_10"
local bndPlayer11 = "bnd_player_11"
local COUNTRY_H = 2
local TEAM_H = 1
local LEAGUE_H = 3
function TeamSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.navContext = o.data
  o.models = {
    HomeTeamSelectModel = HomeTeamSelectModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      data = o.data
    }),
    FormationModel = FormationModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      teamID = o.teamID,
      gamemode = "real"
    })
  }
  o.services = {
    MatchSetup = o.api("MatchSetupService"),
    UserPlate = o.api("UserPlateService"),
    GameSetup = o.api("GameSetupService"),
    FutSquadMgt = o.api("FUTSquadManagementService"),
    Pregame = o.api("PregameService"),
    gameState = o.api("GameStateService"),
    EventManagerService = o.api("EventManagerService"),
    SocialService = o.api("SocialService"),
     CountryService = o.api("CountryService"),
    TeamService = o.api("TeamService"),
    GameSetupService = o.api("GameSetupService"),
    SquadManagementService = o.api("SquadMgtService"),
    TacticsService = o.api("TacticsService")
  }
  o.teamID = o.services.GameSetupService.GetTeamId(true) or -1
  o.playerID = -1
  o.formationList = o.models.FormationModel:getFormationList()
  o.teamInfo = o.services.SquadManagementService.GetTeamInfo(o.teamID)
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
  o:handleEvent(...)
  end)
  o.USER_SIDE = {HOME = "home", AWAY = "away"}
  o.countryToggleId = 0
  o.leagueToggleId = 1
  o.teamToggleId = 2
  o.toggleSideHome = 0
  o.homeInitialized = false
  o.opponentTeamSelectorAlpha = 1
  o.isSearchingOpponent = false
  o.homeTeam = {}
  o.homeTeamId = -1
  o.initialHomeTeamId = -1
  o.isDynamic = o.models.HomeTeamSelectModel:isDynamic()
  o.userSide = o.USER_SIDE.HOME
  if o.navContext.flow == CommonNavVars.FLOWS.ONLINE or o.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
    o.userSide = o.services.GameSetup.IsHostTeam() and o.USER_SIDE.HOME or o.USER_SIDE.AWAY
  end
  --   if o.userSide == o.USER_SIDE.HOME then
--     o.services.gameState.SetUserSideAsHome()
--   else
--     o.services.gameState.SetUserSideAsAway()
--   end
    o.im.Subscribe(bnd2DHomeKit, function()
        o:publish2DHomeKit(o.homeTeam[1])
    end)
    o.im.Subscribe(bndGkHomeKit, function()
        o:publishGkHomeKit(o.homeTeam[2])
    end)
    for i = 1, 11 do
        o.im.Subscribe("bnd_player_"..i, function()
            print("[BINDING] bnd_player_"..i.." triggered")
        end)
    end

	o.im.Subscribe("bnd_team_id", function()
    o:publishTeamID(o.services.gameSetup.GetHomeAssetId())
  end)
  o.im.Subscribe("bnd_team_formation", function()
    o:_publishTeamFormation()
  end
  )
  o.im.Subscribe("bnd_team_number", function()
    o:_publishTeamNumber()
  end)
  o.im.Subscribe(BND_TEAM_RATING_LABEL, function()
    o:_publishTeamRatingLabel()
  end)
  o.im.Subscribe(bndOptionsEnabled, function()
    o:publishOptionsEnabled()
  end)
  o.im.Subscribe(bndHomeUserPlate, function()
    o:publishHomeUserPlate()
  end)
  o.im.Subscribe(bndHomeTeamSelectorAlpha, function()
    o:publishHomeTeamSelectorAlpha()
  end)
  o.im.Subscribe(bndHomeRealTeamVisible, function()
    o:publishHomeRealTeamVisible()
  end)
  o.im.Subscribe(bndHomeFriendlyTeamVisible, function()
    o:publishHomeFriendlyTeamVisible()
  end)
  o.im.Subscribe(bndHomeFutSquadVisible, function()
    o:publishHomeFutSquadVisible()
  end)
  o.im.Subscribe(bndLabelTickernavpublisher, function()
    o:publishLabelTickernavpublisher()
  end)
  o.im.Subscribe(bndAutodisableTickernavpublisher, function()
    o:publishAutodisableTickernavpublisher()
  end)
  if o.navContext.gamemode == CommonNavVars.GAMEMODES.FUT or o.navContext.type == CommonNavVars.TYPES.TOURNAMENTS then
    o.models.HomeTeamSelectModel:FUT()
    o:setHomeTeamData(o.models.HomeTeamSelectModel:getHomeTeam())
  else
    o.initialHomeTeamId = o.models.HomeTeamSelectModel:REAL(o.toggleSideHome, o.navContext.fromScreen == "PrematchFlow")
    o.im.RegisterAction(actHomeCountryPrevious, function(actionName, data)
      o:sendToggleInfo(o.toggleSideHome, o.countryToggleId, 0)
      o.services.MatchSetup.TogglePrevious(o.toggleSideHome, o.countryToggleId)
    end)
    o.im.RegisterAction(actHomeCountryNext, function(actionName, data)
      o:sendToggleInfo(o.toggleSideHome, o.countryToggleId, 1)
      o.services.MatchSetup.ToggleNext(o.toggleSideHome, o.countryToggleId)
    end)
    o.im.RegisterAction(actHomeLeaguePrevious, function(actionName, data)
      o:sendToggleInfo(o.toggleSideHome, o.leagueToggleId, 0)
      o.services.MatchSetup.TogglePrevious(o.toggleSideHome, o.leagueToggleId)
    end)
    o.im.RegisterAction(actHomeLeagueNext, function(actionName, data)
      o:sendToggleInfo(o.toggleSideHome, o.leagueToggleId, 1)
      o.services.MatchSetup.ToggleNext(o.toggleSideHome, o.leagueToggleId)
    end)
    o.im.RegisterAction(actHomeTeamPrevious, function(actionName, data)
      o:sendToggleInfo(o.toggleSideHome, o.teamToggleId, 0)
      o.services.MatchSetup.TogglePrevious(o.toggleSideHome, o.teamToggleId)
    end)
    o.im.RegisterAction(actHomeTeamNext, function(actionName, data)
      o:sendToggleInfo(o.toggleSideHome, o.teamToggleId, 0)
      o.services.MatchSetup.ToggleNext(o.toggleSideHome, o.teamToggleId)
    end)
  end
  o.im.RegisterAction(actAdvance, function(actionName, data)
    if o.navContext.gamemode == CommonNavVars.GAMEMODES.FUT and o.navContext.flow == CommonNavVars.FLOWS.ONLINE then
      if o.models.HomeTeamSelectModel:checkAdvance() == true then
        o.im.ChangeActionState(actAdvance, o.im.GetActionState("INVALID"))
        o.models.HomeTeamSelectModel:advance(o.isDynamic)
      else
        o.models.HomeTeamSelectModel:showDisconnectPopup()
      end
    else
      o.models.HomeTeamSelectModel:advance(o.isDynamic)
    end
  end)
  o.im.RegisterAction(actBack, function(actionName, data)
    if o.navContext.type == CommonNavVars.TYPES.FRIENDLY and o.navContext.flow == CommonNavVars.FLOWS.ONLINE then
      local popupData = {
        message = "LTXT_INV_CANCEL_INVITE_POPUP_BODY",
        buttons = {
          {
            label = "LTXT_CMN_NO",
            clickEvents = {
              "evt_hide_popup"
            }
          },
          {
            label = "LTXT_CMN_YES",
            clickEvents = {
              "evt_hide_popup",
              "evt_back"
            }
          }
        }
      }
      o.nav.Event(nil, "evt_show_popup", popupData)
    else
      o.nav.Event(nil, "evt_back")
    end
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
  if o.isDynamic then
    o.services.Pregame.ListenTeamSelectionEvents()
  end
  o.buttonsID = { TEAM_H, COUNTRY_H, LEAGUE_H }
  o:HideSelections()
  o.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, true)
  o.im.Subscribe(BND_HOME_COUNTRY_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_HOME_TEAM_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_HOME_LEAGUE_SELECT_VISIBLE, function()
  end)
  o.im.RegisterAction(ACT_BTN_CLICK, function(actionName, data)
    o:HideSelections()
    if o.buttonsID[data.buttonID + 1] == COUNTRY_H then
      o.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TEAM_H then
      o.im.Publish(BND_HOME_TEAM_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == LEAGUE_H then
      o.im.Publish(BND_HOME_LEAGUE_SELECT_VISIBLE, true)
    end
  end)
    o:_debugPlayerBindings()
    return o
end
function TeamSelect:_debugPlayerBindings()
    print("[DEBUG] Testing player bindings...")
    for i = 1, 11 do
        local bindingName = "bnd_player_"..i
        local success, err = pcall(function()
            self.im.Publish(bindingName, testValue)
        end)
        if success then
            print("[DEBUG] Published to", bindingName, "successfully")
        else
            print("[ERROR] Failed to publish to", bindingName, ":", err)
        end
    end
end

function TeamSelect:publishLabelTickernavpublisher()
  if self.navContext.flow == CommonNavVars.FLOWS.ONLINE and (self.navContext.type == CommonNavVars.TYPES.TOURNAMENTS or self.navContext.type == CommonNavVars.TYPES.SEASONS) then
    self.im.Publish(bndLabelTickernavpublisher, self.loc.LocalizeString("LTXT_CMN_SEARCH"))
  else
    self.im.Publish(bndLabelTickernavpublisher, self.loc.LocalizeString("LTXT_CMN_CONTINUE"))
  end
end
function TeamSelect:publishAutodisableTickernavpublisher()
  if self.navContext.flow == CommonNavVars.FLOWS.ONLINE and (self.navContext.type == CommonNavVars.TYPES.TOURNAMENTS or self.navContext.type == CommonNavVars.TYPES.SEASONS or self.navContext.type == CommonNavVars.TYPES.FRIENDLY) then
    self.im.Publish(bndAutodisableTickernavpublisher, false)
  end
end
function TeamSelect:handleEvent(eventType, data)
  if eventType == EventTypes.OnTeamDataChanged then
    self:onTeamDataChanged(data)
  elseif eventType == EventTypes.OnTeamReady then
    self:onTeamReady(data)
  elseif eventType == EventTypes.MatchSetupSelectedTeamChanged then
    self:onToggleCompleted(data.currentTeamInfo, data.resetRoster)
  end
end
function TeamSelect:sendToggleInfo(side, toggle, direction)
  if self.isDynamic == true then
    local teamData = {}
    teamData.DIRECTION = direction
    teamData.SIDE = side
    teamData.TOGGLE = toggle
    self.services.Pregame.HandleTeamChange(teamData)
  end
end
function TeamSelect:publishOptionsEnabled()
  self.im.Publish(bndOptionsEnabled, not isSearchingOpponent)
end
function TeamSelect:publishHomeUserData()
  self.im.Publish(bndHomeTeamUser, self.services.UserPlate.GetDisplayName())
end
function TeamSelect:publishHomeRealTeamVisible()
  self.im.Publish(bndHomeRealTeamVisible, self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL)
end
function TeamSelect:publishHomeFutSquadVisible()
  self.im.Publish(bndHomeFutSquadVisible, self.navContext.gamemode ~= CommonNavVars.GAMEMODES.REAL)
end
function TeamSelect:publishHomeFriendlyTeamVisible()
  self.im.Publish(bndHomeFriendlyTeamVisible, self.userSide == self.USER_SIDE.AWAY and self.navContext.type == CommonNavVars.TYPES.FRIENDLY)
end
function TeamSelect:publishHomeUserPlate()
  self.im.Publish(bndHomeUserPlate, self.opponentUserData)
end
function TeamSelect:publishHomeTeamSelectorAlpha()
  self.im.Publish(bndHomeTeamSelectorAlpha, self.userSide == self.USER_SIDE.AWAY and opponentTeamSelectorAlpha or 1)
end
function TeamSelect:_publishTeamRatingLabel()
  local ratingLabel = ("")
  ratingLabel = ratingLabel..""..tostring(self.teamInfo.overall)
  self.im.Publish(BND_TEAM_RATING_LABEL, ratingLabel)
end
function TeamSelect:_publishTeamFormation()
local lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(teamID)
      local formationID = self.services.TacticsService.GetFormation(teamID)
      if self.gamemode == "fut" then
        formationID = self.services.SquadManagementService.GetFUTRelativeSquadFormation(formationID)
      end
      local formation = self.models.FormationModel:getFormationInfoByID(formationID)
      local formationName = formation.name
      local formationPosition = formation.positions
  self.formationName = formationName
  self.im.Publish("bnd_team_formation", formationName)
end
function TeamSelect:_publishTeamNumber()
      local teamSquadData = self.services.SquadManagementService.GetCurrentPlayerLineup(teamID)
      local teamSquadData = #teamSquadData
  self.teamSquadData = teamSquadData 
  self.im.Publish("bnd_team_number", teamSquadData)
end
function TeamSelect:setHomeTeamData(homeTeamValue)
  self.homeTeamId = homeTeamValue.teamId
  self.im.Subscribe(bndHomeTeamUser, function()
    self:publishHomeUserData()
  end)
  self.im.Subscribe(bndHomeSquadName, function()
    self:publishTeamData(bndHomeSquadName, self:getSelectedSquadName())
  end)
  self.im.Subscribe(bndHomeTeamData, function()
    self:publishTeamData(bndHomeTeamData, homeTeamValue)
  end)
end
function TeamSelect:setHomeTeamData(homeTeamValue)
  self.homeTeamId = homeTeamValue.teamId
  self.im.Subscribe(bndHomeTeamUser, function()
    self:publishHomeUserData()
  end)
  self.im.Subscribe(bndHomeSquadName, function()
    self:publishTeamData(bndHomeSquadName, self:getSelectedSquadName())
  end)
  self.im.Subscribe(bndHome2TeamData, function()
    self:publish2TeamData(bndHome2TeamData, homeTeamValue)
  end)
end
function TeamSelect:setHomeTeamData(homeTeamValue)
  self.homeTeamId = homeTeamValue.teamId
  self.im.Subscribe(bndHomeTeamUser, function()
    self:publishHomeUserData()
  end)
  self.im.Subscribe(bndHomeSquadName, function()
    self:publishTeamData(bndHomeSquadName, self:getSelectedSquadName())
  end)
  self.im.Subscribe(bndHome3TeamData, function()
    self:publish3TeamData(bndHome3TeamData, homeTeamValue)
  end)
end
function TeamSelect:getSelectedSquadName()
  local squadList = self.services.FutSquadMgt.GetSquadList()
  local currSquadID = self.services.FutSquadMgt.GetCurrentSquadID()
  for i = 1, table.getn(squadList) do
    if squadList[i].id == currSquadID then
      return squadList[i].name
    end
  end
  return ""
end
function TeamSelect:publishTeamData(bindingName, value)
  if bindingName == bndHomeTeamData then
    if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
      self.im.Publish(bndHomeTeamData, {
        chemistry = value.chemistry,
        ratingLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_RATING_LABEL"),
        chemLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_CHEMISTRY_LABEL"),
        crest = {
          name = "$Crest",
          id = string.format("%d", value.crestId)
        },
        starRating = value.starRating,
        overall = value.overall,
        teamRating = value.teamRating,
        userSide = true,
        avatar = self.services.SocialService.GetImagePathForUser(true)
      })
    else
	local displayedTeamName = value.teamName
      if not string.find(displayedTeamName, "Default") then
        displayedTeamName = displayedTeamName .. " Default"
      end
	  
		self.im.Publish(bndHomeTeamData, {
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
        teamRating = value.teamRating,
        userSide = false
      })
    end
    self.initialHomeTeamId = value.teamId
    self.models.HomeTeamSelectModel:setHomeTeam(value)
    self:publishTeamID(self.initialHomeTeamId)
    if self.navContext.fromScreen == "PrematchFlow" then
      self.models.HomeTeamSelectModel:setTeam(self.initialHomeTeamId)
      self:publishTeamID(self.initialHomeTeamId)
    end
    self:publish2DHomeKit({
      KITTYPE = 0,
      TEAMID = value.teamId,
      YEAR = 0 -- Replace with actual year if needed
    })
	self:publishGkHomeKit({
      KITTYPE = 2,
      TEAMID = value.teamId,
      YEAR = 0 -- Replace with actual year if needed
    })
	self.models.HomeTeamSelectModel:setupTeams()
  elseif bindingName == bndHomeSquadName then
    self.im.Publish(bndHomeSquadName, value)
  elseif bindingName == bndHomeTeamCountry then
    self.im.Publish(bndHomeTeamCountry, value)
  elseif bindingName == bndHomeTeamLeague then
    self.im.Publish(bndHomeTeamLeague, value)
  elseif bindingName == bndHomeTeamName then
    self.im.Publish(bndHomeTeamName, value)
  else
  end
end
function TeamSelect:publish2TeamData(bindingName, value)
  if bindingName == bndHome2TeamData then
    if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
      self.im.Publish(bndHome2TeamData, {
        chemistry = value.chemistry,
        ratingLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_RATING_LABEL"),
        chemLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_CHEMISTRY_LABEL"),
        crest = {
          name = "$Crest",
          id = string.format("%d", value.crestId)
        },
        starRating = value.starRating,
        overall = value.overall,
        teamRating = value.teamRating,
        userSide = true,
        avatar = self.services.SocialService.GetImagePathForUser(true)
      })
    else
		
		local displayedTeamName = value.teamName
      if not string.find(displayedTeamName, "Default") then
        displayedTeamName = displayedTeamName .. " Default"
      end
	  
      self.im.Publish(bndHome2TeamData, {
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
        teamRating = value.team2Rating,
        userSide = false
      })
    end
    self.initialHomeTeamId = value.teamId
    self.models.HomeTeamSelectModel:setHomeTeam(value)
    self:publishTeamID(self.initialHomeTeamId)
    if self.navContext.fromScreen == "PrematchFlow" then
      self.models.HomeTeamSelectModel:setTeam(self.initialHomeTeamId)
      self:publishTeamID(self.initialHomeTeamId)
    end
    self.models.HomeTeamSelectModel:setupTeams()
  elseif bindingName == bndHomeSquadName then
    self.im.Publish(bndHomeSquadName, value)
  elseif bindingName == bndHomeTeamCountry then
    self.im.Publish(bndHomeTeamCountry, value)
  elseif bindingName == bndHomeTeamLeague then
    self.im.Publish(bndHomeTeamLeague, value)
  elseif bindingName == bndHomeTeamName then
    self.im.Publish(bndHomeTeamName, value)
  else
  end
end
function TeamSelect:publish3TeamData(bindingName, value)
  if bindingName == bndHome3TeamData then
    if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
      self.im.Publish(bndHome3TeamData, {
        chemistry = value.chemistry,
        ratingLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_RATING_LABEL"),
        chemLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_CHEMISTRY_LABEL"),
        crest = {
          name = "$Crest",
          id = string.format("%d", value.crestId)
        },
        starRating = value.starRating,
        overall = value.overall,
        teamRating = value.teamRating,
        userSide = true,
        avatar = self.services.SocialService.GetImagePathForUser(true)
      })
    else
		
		local displayedTeamName = value.teamName
      if not string.find(displayedTeamName, "Default") then
        displayedTeamName = displayedTeamName .. " Default"
      end
	  
      self.im.Publish(bndHome3TeamData, {
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
        teamRating = value.teamRating,
        userSide = false
      })
    end
    self.initialHomeTeamId = value.teamId
    self.models.HomeTeamSelectModel:setHomeTeam(value)
    self:publishTeamID(self.initialHomeTeamId)
    if self.navContext.fromScreen == "PrematchFlow" then
      self.models.HomeTeamSelectModel:setTeam(self.initialHomeTeamId)
      self:publishTeamID(self.initialHomeTeamId)
    end
    self.models.HomeTeamSelectModel:setupTeams()
  elseif bindingName == bndHomeSquadName then
    self.im.Publish(bndHomeSquadName, value)
  elseif bindingName == bndHomeTeamCountry then
    self.im.Publish(bndHomeTeamCountry, value)
  elseif bindingName == bndHomeTeamLeague then
    self.im.Publish(bndHomeTeamLeague, value)
  elseif bindingName == bndHomeTeamName then
    self.im.Publish(bndHomeTeamName, value)
  else
  end
end

function TeamSelect:_getFallbackPlayerNames(teamId)
    local fallbackNames = {
        "Kiper", "Bek Kanan", "Bek Tengah 1", "Bek Tengah 2", "Bek Kiri",
        "Gelandang 1", "Gelandang 2", "Gelandang 3", "Sayap Kanan", 
        "Penyerang", "Sayap Kiri"
    }

    local success, teamOrErr = pcall(function()
        return self.services.TeamService.GetTeamInfo(teamId)
    end)

    if not success then
        print("[ERROR] _getFallbackPlayerNames: TeamService gagal", teamOrErr)
        return fallbackNames
    end

    local team = teamOrErr
    if team and team.players and #team.players > 0 then
        local names = {}
        for i = 1, math.min(11, #team.players) do
            names[i] = team.players[i].name or ("Pemain "..i)
        end
        return names
    else
        print("[WARN] _getFallbackPlayerNames: data kosong, gunakan default fallback")
        return fallbackNames
    end
end

function TeamSelect:_publishPlayerNames()
    local playerNames = {"", "", "", "", "", "", "", "", "", "", ""}
    if self.teamID and self.teamID ~= -1 then
        local success, lineupOrErr = pcall(function()
            return self.services.SquadManagementService.GetCurrentPlayerLineup(0, self.teamID, 0)
        end)
        if success and lineupOrErr and #lineupOrErr > 0 then
            for i = 1, math.min(11, #lineupOrErr) do
                local player = lineupOrErr[i]
                if player then
                    playerNames[i] = player.name or player.playerName or player.fullName or ("Pemain "..i)
                else
                    playerNames[i] = "Pemain "..i
                end
            end
        else
            local fallbackSuccess, teamOrErr = pcall(function()
                return self.services.TeamService.GetTeamInfo(self.teamID)
            end)
            if fallbackSuccess and teamOrErr and teamOrErr.players and #teamOrErr.players > 0 then
                for i = 1, math.min(11, #teamOrErr.players) do
                    playerNames[i] = teamOrErr.players[i].name or ("Pemain "..i)
                end
            else
                print("[WARN] _publishPlayerNames: fallback final default names digunakan")
                local fallbackNames = self:_getFallbackPlayerNames(self.teamID)
                for i = 1, 11 do
                    playerNames[i] = fallbackNames[i]
                end
            end
        end
    else
        print("[WARN] _publishPlayerNames: teamID tidak valid, fallback default")
        local fallbackNames = self:_getFallbackPlayerNames(-1)
        for i = 1, 11 do
            playerNames[i] = fallbackNames[i]
        end
    end
    for i = 1, 11 do
        if playerNames[i] == "" or playerNames[i] == nil then
            playerNames[i] = "Pemain "..i
        end
    end
    for i = 1, 11 do
        self.im.Publish("bnd_player_"..i, playerNames[i])
        print(string.format("[DEBUG] bnd_player_%d = %s", i, playerNames[i]))
    end
end

function TeamSelect:onToggleCompleted(selected, resetRoster)
    if not selected then
        print("[ERROR] onToggleCompleted: selected is nil")
        return
    end

    local country = selected.country or "UNKNOWN_COUNTRY"
    local league = selected.league or "UNKNOWN_LEAGUE"
    local teamName = selected.team or "UNKNOWN_TEAM"

    if teamName and not string.find(teamName, "Default") then
        teamName = teamName .. " Default"
    end

    local side = selected.side or self.USER_SIDE.HOME

    local teamRatings = selected.teamRatings or {}
    local teamId = teamRatings.teamId or -1
    local starRating = teamRatings.starRating or 0
    local offense = teamRatings.offense or 0
    local midfield = teamRatings.midfield or 0
    local defense = teamRatings.defense or 0

    local attackLabel, middleLabel, defenseLabel = "ATT", "MID", "DEF"
    local success, locLabels = pcall(function()
        return {
            attack = self.loc.LocalizeString("LTXT_CMN_ATT"),
            middle = self.loc.LocalizeString("LTXT_CMN_MID"),
            defense = self.loc.LocalizeString("LTXT_CMN_DEF"),
        }
    end)
    if success and locLabels then
        attackLabel = locLabels.attack
        middleLabel = locLabels.middle
        defenseLabel = locLabels.defense
    else
        print("[WARN] localize label fallback ke default ATT/MID/DEF")
    end

    local teamData = {
        teamId = teamId,
        teamName = teamName,
        crestId = teamId,
        flagName = selected.countryId or "UNKNOWN_FLAG",
        leagueName = selected.leagueId or "UNKNOWN_LEAGUE",
        starRating = starRating,
        overall = teamRatings.overall or 0,
        teamRating = {
            attackValue = offense,
            middleValue = midfield,
            defenseValue = defense,
            attackLabel = attackLabel,
            middleLabel = middleLabel,
            defenseLabel = defenseLabel
        },
        team2Rating = {
            attackValueHome = offense,
            middleValueHome = midfield,
            defenseValueHome = defense,
            attackLabelHome = attackLabel,
            middleLabelHome = middleLabel,
            defenseLabelHome = defenseLabel
        },
        chemistry = 0,
        overall = 0
    }

    if side == self.USER_SIDE.HOME then
        local statusDebug, debugErr = pcall(function()
            self:_debugPlayerBindings()
        end)
        if not statusDebug then
            print("[ERROR] _debugPlayerBindings error:", debugErr)
        end

        print("[TEAM CHANGE] New team selected:", teamId)
        self.teamID = teamId

        -- Update team data with safety
        if resetRoster or (self.navContext and self.navContext.fromScreen == "PrematchFlow") then
            local statusSet, errSet = pcall(function()
                self.models.HomeTeamSelectModel:setTeam(teamData.teamId)
            end)
            if not statusSet then
                print("[ERROR] setTeam gagal:", errSet)
            end
        end

        if not self.homeInitialized then
            local okInit, errInit = pcall(function()
                self:_initializeHomeTeamBindings(country, league, teamName, teamData)
            end)
            if not okInit then
                print("[ERROR] _initializeHomeTeamBindings gagal:", errInit)
            end
            self.homeInitialized = true
        else
            local okUpdate, errUpdate = pcall(function()
                self:_updateHomeTeamData(country, league, teamName, teamData)
            end)
            if not okUpdate then
                print("[ERROR] _updateHomeTeamData gagal:", errUpdate)
            end
        end

        local okFormation, errFormation = pcall(function()
            self:_publishTeamFormation()
        end)
        if not okFormation then
            print("[ERROR] _publishTeamFormation gagal:", errFormation)
        end

        local okNumber, errNumber = pcall(function()
            self:_publishTeamNumber()
        end)
        if not okNumber then
            print("[ERROR] _publishTeamNumber gagal:", errNumber)
        end

        local okRating, errRating = pcall(function()
            self:_publishTeamRatingLabel()
        end)
        if not okRating then
            print("[ERROR] _publishTeamRatingLabel gagal:", errRating)
        end

        local okPlayerNames, errPlayerNames = pcall(function()
            self:_publishPlayerNames()
        end)
        if not okPlayerNames then
            print("[ERROR] _publishPlayerNames gagal:", errPlayerNames)
        end
    end
end
    
function TeamSelect:_initializeHomeTeamBindings(country, league, teamName, teamData)
    self.im.Subscribe(bndHomeTeamUser, function()
        self:publishHomeUserData()
    end)
    self.im.Subscribe(bndHomeTeamCountry, function()
        self:publishTeamData(bndHomeTeamCountry, country)
    end)
    self.im.Subscribe(bndHomeTeamLeague, function()
        self:publishTeamData(bndHomeTeamLeague, league)
    end)
    self.im.Subscribe(bndHomeTeamName, function()
        self:publishTeamData(bndHomeTeamName, teamName)
    end)
    self.im.Subscribe(bndHomeTeamData, function()
        self:publishTeamData(bndHomeTeamData, teamData)
    end)
    self.im.Subscribe(bndHome2TeamData, function()
        self:publish2TeamData(bndHome2TeamData, teamData)
    end)
    self.im.Subscribe(bndHome3TeamData, function()
        self:publish3TeamData(bndHome3TeamData, teamData)
    end)
    
    -- Initialize player name bindings
    for i = 1, 11 do
        self.im.Subscribe("bnd_player_"..i, function()
            self:_publishPlayerNames()
        end)
    end
end

function TeamSelect:_updateHomeTeamData(country, league, teamName, teamData)
    self:publishTeamData(bndHomeTeamCountry, country)
    self:publishTeamData(bndHomeTeamLeague, league)
    self:publishTeamData(bndHomeTeamName, teamName)
    self:publishTeamData(bndHomeTeamData, teamData)
    self:publish2TeamData(bndHome2TeamData, teamData)
    self:publish3TeamData(bndHome3TeamData, teamData)
end

function TeamSelect:onTeamDataChanged(teamData)
  local direction = teamData.DIRECTION
  if direction == 0 then
    self.services.MatchSetup.TogglePrevious(teamData.SIDE, teamData.TOGGLE)
  else
    self.services.MatchSetup.ToggleNext(teamData.SIDE, teamData.TOGGLE)
  end
end
function TeamSelect:onTeamReady(readyData)
  if self.isDynamic and self.services.Pregame.AreBothSidesReady() then
    self.models.HomeTeamSelectModel:doAdvance()
  end
end
function TeamSelect:publish2DHomeKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DHomeKit, {name = "$Kits", id = kitId})
end
function TeamSelect:publishGkHomeKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bndGkHomeKit, {name = "$Kits", id = kitId})
end

function TeamSelect:publishTeamID(teamid)
    self.im.Publish("bnd_team_id", ""..teamid)
end
function TeamSelect:HideSelections()
  self.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, false)
  self.im.Publish(BND_HOME_TEAM_SELECT_VISIBLE, false)
  self.im.Publish(BND_HOME_LEAGUE_SELECT_VISIBLE, false)
end
function TeamSelect:finalize()
    for i = 1, 11 do
        self.im.Unsubscribe("bnd_player_"..i)
    end
  self.im.Unsubscribe(bnd2DHomeKit)
  self.im.Unsubscribe("bnd_team_id")
  self.im.Unsubscribe("bnd_team_crest")
  self.im.Unsubscribe(bndHomeTeamUser)
  self.im.Unsubscribe(bndHomeTeamData)
  self.im.Unsubscribe(bndHome2TeamData)
  self.im.Unsubscribe(bndHome3TeamData)
  self.im.Unsubscribe(bndHomeSquadName)
  self.im.Unsubscribe(bndHomeRealTeamVisible)
  self.im.Unsubscribe(bndHomeFutSquadVisible)
  self.im.Unsubscribe(bndHomeFriendlyTeamVisible)
  self.im.Unsubscribe(bndHomeUserPlate)
  self.im.Unsubscribe(bndHomeTeamSelectorAlpha)
  self.im.Unsubscribe(bndHomeTeamCountry)
  self.im.Unsubscribe(bndHomeTeamLeague)
  self.im.Unsubscribe(bndHomeTeamName)
  self.im.Unsubscribe(BND_HOME_COUNTRY_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_HOME_TEAM_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_HOME_LEAGUE_SELECT_VISIBLE)
  self.im.Unsubscribe(bndOptionsEnabled)
  self.im.Unsubscribe(bndLabelTickernavpublisher)
  self.im.UnregisterAction(ACT_BTN_CLICK)
  self.im.Unsubscribe(bndAutodisableTickernavpublisher)
  if self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL then
    self.im.UnregisterAction(actHomeCountryPrevious)
    self.im.UnregisterAction(actHomeCountryNext)
    self.im.UnregisterAction(actHomeLeaguePrevious)
    self.im.UnregisterAction(actHomeLeagueNext)
    self.im.UnregisterAction(actHomeTeamPrevious)
    self.im.UnregisterAction(actHomeTeamNext)
  end
  self.im.UnregisterAction(actBack)
  self.im.UnregisterAction(actAdvance)
  self.im.UnregisterAction(actSettings)
  self.im.UnregisterAction(actSquad)
  self.im.UnregisterAction(actSquadAway)
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  if self.isDynamic then
    self.services.Pregame.UnlistenTeamSelectionEvents()
  end
  self.homeInitialized = false
  self.models.HomeTeamSelectModel:finalize()
  self.models.FormationModel:finalize()
end
return TeamSelect