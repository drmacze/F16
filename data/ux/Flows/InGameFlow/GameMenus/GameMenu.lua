-- MVN PROD Modified --

local TableUtil, CommonNavVars, GameStateServiceEnums, OverlayParam, EventManager = ...
local GameMenu = {}
local BND_HOME_PAUSES = "bnd_home_team_pauses"
local BND_AWAY_PAUSES = "bnd_away_team_pauses"
local BND_HOME_USER_DATA = "bnd_home_user_data"
local BND_AWAY_USER_DATA = "bnd_away_user_data"
local BND_HOME_TEAM_CREST = "bnd_home_team_crest"
local BND_AWAY_TEAM_CREST = "bnd_away_team_crest"
local BND_PLAYER = "bnd_player"
local BND_MAN = "bnd_man"
local BND_HOME_TEAM_NAME_ABBR = "bnd_home_team_name_abbr"
local BND_AWAY_TEAM_NAME_ABBR = "bnd_away_team_name_abbr"
local BND_HOME_TEAM_NAME = "bnd_home_team_name"
local BND_AWAY_TEAM_NAME = "bnd_away_team_name"
local BND_RESULT = "bnd_result"
local BND_SHOOTOUT_RESULT = "bnd_shootout_result"
local BND_MATCH_TYPE = "bnd_match_type"
local BND_GAME_STATE = "bnd_game_state"
local BND_STADIUM_NAME = "bnd_stadium_name"
local BND_TIME = "bnd_time"
local BND_MATCH_FACTS = "bnd_match_facts"
local BND_LIVE_TILE_RESUME = "bnd_live_tile_resume"
local BND_LIVE_TILE_SQUADHOME_SQUADAWAY = "bnd_live_tile_squadhome_squadaway"
local bndLiveTileList = "bnd_live_tile_list"
local bndLiveTileList2 = "bnd_live_tile_list2"
local BND_LIVE_TILE_REPLAY = "bnd_live_tile_replay"
local BND_LIVE_TILE_RESTART = "bnd_live_tile_restart"
local BND_LIVE_TILE_SETTINGS = "bnd_live_tile_settings"
local BND_LIVE_TILE_FORFEIT = "bnd_live_tile_forfeit"
local BND_LIVE_TILE_MATCHFACTS = "bnd_live_tile_matchfacts"
local BND_LIVE_TILE_CAPTURED_MEDIA = "bnd_live_tile_captured_media"
local BND_LIVE_TILE_CAPTURED_MEDIA_ENABLED = "bnd_live_tile_captured_media_enabled"
local BND_LIVE_TILE_QUIT = "bnd_live_tile_quit"
local BND_SHOW_ONLINE_INFO = "bnd_show_online_info"
local BND_SHOW_OFFLINE_INFO = "bnd_show_offline_info"
local BND_LIVE_TILE_MATCHHIGHLIGHTS = "bnd_live_tile_matchhighlights"
local BND_LIVE_TILE_MATCHGRADE = "bnd_live_tile_matchgrade"
local BND_LIVE_TILE_REPLAY_ENABLED = "bnd_live_tile_replay_enable"
local ACT_TOGGLE_PAUSE = "act_toggle_pause"
local ACT_FORFEIT_MATCH = "act_forfeit_match"
local ACT_QUIT_MATCH = "act_quit_match"
local ACT_RESTART_MATCH = "act_restart_match"
local ACT_QUITMATCH_TOURNAMENT = "act_quitmatch_tournament"

local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local BACK_KEY_PRESSED = GameStateServiceEnums.FE.UXService.GameStateServiceListener.BACK_KEY_PRESSED



function GameMenu:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.navContext = o.data
  o.flow = o.navContext.flow
  print("[GameMenu]: new(gamemode = " .. tostring(o.navContext.gamemode) .. ", flow = " .. tostring(o.navContext.flow) .. ", type = " .. tostring(o.navContext.type) .. ", gameState = " .. tostring(o.navContext.gameState) .. ")")
  o.services = {
    GameStateService = o.api("GameStateService"),
    liveTilesService = o.api("FUTLiveTilesService"),
    MatchInfoService = o.api("MatchInfoService"),
    OverlayService = o.api("OverlayService"),
    GameSetupService = o.api("GameSetupService"),
    SocialService = o.api("SocialService"),
    PauseMenuService = o.api("PauseMenuService"),
    SeasonProgressService = o.api("SeasonProgressService"),
    SettingsService = o.api("SettingsService"),
    UserPlateService = o.api("UserPlateService"),
    MediaCaptureService = o.api("MediaCaptureService"),
    ReplayService = o.api("ReplayService"),
    ScreenInfoService = o.api("ScreenInfoService"),
    DNFService = o.api("DNFService"),
    EventManagerService = o.api("EventManagerService"),
    TeamService = o.api("TeamService"),
    SquadManagementService = o.api("SquadMgtService")
  }
  EnglandTeams = o.services.TeamService.GetTeams(leagueIDs.England, 0, 0, true)
  InternationalTeams = o.services.TeamService.GetTeams(leagueIDs. International, 0, 0, true)
  UEFATeams = o.services.TeamService.GetTeams(leagueIDs. UEFA, 0, 0, true)
  UEFAELTeams = o.services.TeamService.GetTeams(leagueIDs. UEFAEL, 0, 0, true)
  FranceTeams = o.services.TeamService.GetTeams(leagueIDs.France, 0, 0, true)
  GermanyTeams = o.services.TeamService.GetTeams(leagueIDs.Germany, 0, 0, true)
  SpainTeams = o.services.TeamService.GetTeams(leagueIDs.Spain, 0, 0, true)
  ItalyTeams = o.services.TeamService.GetTeams(leagueIDs.Italy, 0, 0, true)
  
  
  o.im.RegisterAction(ACT_TOGGLE_PAUSE, function(actionName)
    o:resumeMatch()
  end
  )
  o.im.RegisterAction(ACT_FORFEIT_MATCH, function(actionName)
    o:forfeitMatch()
  end)
  o.im.RegisterAction(ACT_QUIT_MATCH, function(actionName)
    o:quitMatch()
  end)
  o.im.RegisterAction(ACT_QUITMATCH_TOURNAMENT, function(actionName)
    o:QuitMatchTournament()
  end)
  
  o.im.RegisterAction(ACT_RESTART_MATCH, function(actionName)
    o:restartMatch()
  end
  )

  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end
  )
  o.im.Subscribe(BND_HOME_PAUSES, function()
    o.im.Publish(BND_HOME_PAUSES, o:getPausesRemaining())
  end
  )
  o.im.Subscribe(BND_AWAY_PAUSES, function()
    o.im.Publish(BND_AWAY_PAUSES, o:getPausesRemaining(true))
  end
  )
  o.im.Subscribe(BND_HOME_USER_DATA, function()
    o.im.Publish(BND_HOME_USER_DATA, {
      userImage = o:getAvatarPath(),
      team = o:getTeam().assetId
    })
  end
  )
  o.im.Subscribe(BND_AWAY_USER_DATA, function()
    o.im.Publish(BND_AWAY_USER_DATA, {
      userImage = o:getAvatarPath(true),
      team = o:getTeam(true).assetId
    })
  end
  )
  o.im.Subscribe(BND_HOME_TEAM_CREST, function()
    o.im.Publish(BND_HOME_TEAM_CREST, o:getTeamCrest())
  end
  )
  o.im.Subscribe(BND_AWAY_TEAM_CREST, function()
    o.im.Publish(BND_AWAY_TEAM_CREST, o:getTeamCrest(true))
  end
  )
  o.im.Subscribe(BND_PLAYER, function()
    o.im.Publish(BND_PLAYER, o:getPlayer())
  end
  )
    o.im.Subscribe(BND_MAN, function()
    o.im.Publish(BND_MAN, o:getMan())
  end
  )
  o.im.Subscribe(BND_HOME_TEAM_NAME_ABBR, function()
    o.im.Publish(BND_HOME_TEAM_NAME_ABBR, o:getTeam().teamNameAbbr)
  end
  )
  o.im.Subscribe(BND_AWAY_TEAM_NAME_ABBR, function()
    o.im.Publish(BND_AWAY_TEAM_NAME_ABBR, o:getTeam(true).teamNameAbbr)
  end
  )
  o.im.Subscribe(BND_HOME_TEAM_NAME, function()
    o.im.Publish(BND_HOME_TEAM_NAME, o:getTeam().teamName)

  end
  )
  o.im.Subscribe(BND_AWAY_TEAM_NAME, function()
    o.im.Publish(BND_AWAY_TEAM_NAME, o:getTeam(true).teamName)
    
  end
  )
  o.im.Subscribe(BND_RESULT, function()
    o.im.Publish(BND_RESULT, o.services.MatchInfoService.GetMatchResult())
  end
  )
  o.im.Subscribe(BND_SHOOTOUT_RESULT, function()
    o.im.Publish(BND_SHOOTOUT_RESULT, o:getShootoutResult())
  end
  )
  o.im.Subscribe(BND_MATCH_TYPE, function()
    o.im.Publish(BND_MATCH_TYPE, o:getMatchType("Friendly match"))
  end
  )
  o.im.Subscribe(BND_GAME_STATE, function()
    o.im.Publish(BND_GAME_STATE, o:getGameState())
  end)
  o.im.Subscribe(BND_STADIUM_NAME, function()
    o.im.Publish(BND_STADIUM_NAME, o.services.SettingsService.GetCurrentOptions().stadium)
  end
  )
  o.im.Subscribe(BND_TIME, function()
    o.im.Publish(BND_TIME, o.services.OverlayService.GetGameClockString())
  end
  )
  o.im.Subscribe(BND_MATCH_FACTS, function()
    o.im.Publish(BND_MATCH_FACTS, o:getMatchFacts())
  end)
  o.im.Subscribe(BND_LIVE_TILE_RESUME, function()
    o.im.Publish(BND_LIVE_TILE_RESUME, {
      ("RESUME"), ("MATCH")
    })
  end
  )
 o.im.Subscribe(BND_LIVE_TILE_MATCHFACTS, function()
    o.im.Publish(BND_LIVE_TILE_MATCHFACTS, {
      ("STATS & EVENTS")
    })
  end
  )
  o.im.Subscribe(BND_LIVE_TILE_MATCHGRADE, function()
    o:BND_LIVE_TILE_MATCHGRADE()
  end
  )
  o.im.Subscribe(BND_LIVE_TILE_MATCHHIGHLIGHTS, function()
    o.im.Publish(BND_LIVE_TILE_MATCHHIGHLIGHTS, {
      ("HIGHLIGHTS")
    })
  end
  )
  o.im.Subscribe(BND_LIVE_TILE_QUIT, function()
    o.im.Publish(BND_LIVE_TILE_QUIT, {
      ("EXIT"), ("MENU")
    })
  end
  )
  
  
  

  ---------------------------------------------------------
  -- MENU SQUAD HOME & SQUAD AWAY --
  ---------------------------------------------------------
  o.MenuSquadHomeSquadAway = {}
  table.insert(o.MenuSquadHomeSquadAway, {
    headline = { "SQUAD" },
    description = "Manage Squad HOME",
    images = { "$IconFormations" },
    autoScaleImageToTileHeight = { "true" },
    clickAction = "act_ingamesquad_home"
  })
  table.insert(o.MenuSquadHomeSquadAway, {
    headline = { "SQUAD" },
    description = "Manage Squad AWAY",
    images = { "$IconFormations" },
    autoScaleImageToTileHeight = { "true" },
    clickAction = "act_ingamesquad_away"
  })
  o.im.Subscribe(BND_LIVE_TILE_SQUADHOME_SQUADAWAY, function()
    o:_publishMenuSquadHomeSquadAway()
  end)
function GameMenu:_publishMenuSquadHomeSquadAway()
  local dataToPublish = { index = 0, data = self.MenuSquadHomeSquadAway }
  self.im.Publish(BND_LIVE_TILE_SQUADHOME_SQUADAWAY, dataToPublish)
end
  
  
  
-----------------------------
  -- MENU SETTINGS --
  -----------------------------
  o.im.Subscribe(BND_LIVE_TILE_SETTINGS, function()
    o:BND_LIVE_TILE_SETTINGS()
  end)
function GameMenu:BND_LIVE_TILE_SETTINGS()
  local dataToInsert =
  {
    headline = { "SETTINGS" }
  }
  self.im.Publish(BND_LIVE_TILE_SETTINGS, dataToInsert)
end
  
  
  

  
  o.im.Subscribe(bndLiveTileList2, function()
    o:_publishLiveTiles2()
  end)
  o.im.Subscribe(BND_LIVE_TILE_REPLAY, function()
    o.im.Publish(BND_LIVE_TILE_REPLAY, {
      ("INSTANT"), ("REPLAY")
    })
  end
  )
  o.im.Subscribe(BND_LIVE_TILE_SETTINGS, function()
    o.im.Publish(BND_LIVE_TILE_SETTINGS, {
      ("SETTINGS")
    })
  end
  )
  
  o.im.Subscribe(BND_LIVE_TILE_CAPTURED_MEDIA_ENABLED, function()
    o.im.Publish(BND_LIVE_TILE_CAPTURED_MEDIA_ENABLED, o.services.MediaCaptureService.HasCapturedMedia())
  end
  )
  o.im.Subscribe(BND_LIVE_TILE_FORFEIT, function()
    o.im.Publish(BND_LIVE_TILE_FORFEIT, {
      ("QUIT"), ("MATCH")
    })
  end
  )
    o.im.Subscribe(BND_LIVE_TILE_RESTART, function()
    o.im.Publish(BND_LIVE_TILE_RESTART, {
      ("RESTART"), ("MATCH")
    })
  end
  )
  o.im.Subscribe(BND_SHOW_ONLINE_INFO, function()
    o.im.Publish(BND_SHOW_ONLINE_INFO, o.navContext.flow == CommonNavVars.FLOWS.ONLINE)
  end
  )
  o.im.Subscribe(BND_SHOW_OFFLINE_INFO, function()
    o.im.Publish(BND_SHOW_OFFLINE_INFO, o.navContext.flow == CommonNavVars.FLOWS.OFFLINE)
  end
  )

  o.im.Subscribe(BND_LIVE_TILE_REPLAY_ENABLED, function()
    o.im.Publish(BND_LIVE_TILE_REPLAY_ENABLED, not o.services.PauseMenuService.IsOnlineGame())
  end
  )
  if o.flow == CommonNavVars.FLOWS.OFFLINE then
    o.services.ScreenInfoService.SetScreenName("PauseMenuOffline")
  end
  function o.resumeGameListener(...)
    o:resumeMatch()
  end
  
  o.services.GameStateService.RegisterListener(BACK_KEY_PRESSED, o.resumeGameListener)
  o.isGamePaused = true
  return o
end

function GameMenu:BND_LIVE_TILE_MATCHGRADE()
  local MatchGrade = self:GetMatchGrade()
  local dataToInsert = {
    headline = { "" },
    description = "",
    images = {
      {
        name = "$Grade",
        id = MatchGrade
      }
    }
  }
  self.im.Publish(BND_LIVE_TILE_MATCHGRADE, dataToInsert)
end

function GameMenu:_publishLiveTiles()
  local dataToPublish = {
    index = 0,
    data = self.liveTileLists
  }
  self.im.Publish(bndLiveTileList, dataToPublish)
end

function GameMenu:_publishLiveTiles2()
  local dataToPublish = {
    index = 0,
    data = self.liveTileLists2
  }
  self.im.Publish(bndLiveTileList2, dataToPublish)
end

function GameMenu:handleEvent(eventType, data)
  if eventType == EVENT_TYPES.UpdateNumberOfPausesLeft then
    self:onNumberOfPauseLeftChanged()
  end
end

function GameMenu:resumeMatch()
  print("[GameMenu]: resumeMatch()")
  local screenName = self.services.ScreenInfoService.GetCurrentScreenName()
  print("[GameMenu]: resumeMatch: self.isGamePaused = " .. tostring(self.isGamePaused) .. ", GetCurrentScreenName: " .. tostring(screenName))
  if screenName == "GenericPopup" then
    self.nav.Event(nil, "evt_hide_popup")
  elseif screenName == "Customization" or screenName == "TouchControls" or screenName == "AudioVisual" or screenName == "General" or screenName == "ControllerControls" or screenName == "DebugSettings" then
    self.nav.Event(nil, "evt_save_settings")
  elseif screenName == "SpeechDownloadPopup" then
    self.nav.Event(nil, "evt_hide_speechdownload_popup")
  elseif self.isGamePaused then
    self.isGamePaused = false
    self.nav.Event(nil, "evt_toggle_pause")
  end
end

-- Menu Restart --
function GameMenu:restartMatch()
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
      "evt_restart_match",
      "evt_hide_popup"
    }
  }
  local popupData = {
    message = " ARE YOU SURE YOU WANT TO RESTART THIS MATCH ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

-- Menu Forfeit Match --
function GameMenu:forfeitMatch()
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
        "evt_quit_from_game",
      "evt_hide_popup"
    }
  }
  local popupData = {
    message = " ARE YOU SURE YOU WANT TO QUIT THIS MATCH ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

-- Menu Quit Match --
function GameMenu:quitMatch()
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
      "evt_quit",
      "evt_hide_popup"
    }
  }
  function buttonYes.clickCallback()
    self:handleCupResult()
    self:handleChallengeResult()
    self:handleMatchDayResult()
    self:handleBeaproResult()
    self:handleLigaResult()
    self.nav.Event(nil, "evt_quit")
  end
  local popupData = {
    title = " QUIT MATCH ",
    message = " ARE YOU SURE YOU WANT TO BACK INTO MENU? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end


-- Action Menu Quit Match Tournament --
function GameMenu:QuitMatchTournament()
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
      "evt_quit",
      "evt_hide_popup"
    }
  }
  function buttonYes.clickCallback()
    self:handleCupResult()
    self.nav.Event(nil, "evt_quit")
  end
  local popupData = {
    message = " QUIT TO MAIN MENU TOURNAMENT ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end



function GameMenu:onNumberOfPauseLeftChanged()
  self.im.Refresh(BND_HOME_PAUSES)
  self.im.Refresh(BND_AWAY_PAUSES)
end

function GameMenu:getMatchType()
  -- if self.navContext.gamemode == CommonNavVars.GAMEMODES.FTF then
    --return ("Friendly match")
 -- elseif self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL then
   -- return ("Real Team")
--  else
   -- return self.loc.LocalizeString(string.format("%s_%s_%s", self.navContext.gamemode, self.navContext.flow, self.navContext.type))
  -- end
  if currentCupData.cupIndex > 0 then
    if currentCupData.cupIndex == 1 then
      return "UEFA Champions League"
    elseif currentCupData.cupIndex == 2 then
      return "WORD CUP"
    elseif currentCupData.cupIndex == 3 then
      return "UEFA Europa League"
    elseif currentCupData.cupIndex == 4 then
      return "GRMEAN CUP"
    elseif currentCupData.cupIndex == 5 then
      return "La Liga BBVA"
    elseif currentCupData.cupIndex == 6 then
      return "Serie A"
    elseif currentCupData.cupIndex == 7 then
      return "Premier League"
    elseif currentCupData.cupIndex == 8 then
      return "Ligue 1"
    end
  else
  if self:isInTable(self:getTeam(), EnglandTeams) and self:isInTable(self:getTeam(true), EnglandTeams) then
    return "Premier League"
  elseif self:isInTable(self:getTeam(), SpainTeams) and self:isInTable(self:getTeam(true), SpainTeams) then
    return "La Liga BBVA"
  elseif self:isInTable(self:getTeam(), InternationalTeams) and self:isInTable(self:getTeam(true), InternationalTeams) then
    return "WORD CUP"
  elseif self:isInTable(self:getTeam(), UEFATeams) and self:isInTable(self:getTeam(true), UEFATeams) then
    return "UEFA Champions League"
  elseif self:isInTable(self:getTeam(), UEFAELTeams) and self:isInTable(self:getTeam(true), UEFAELTeams) then
    return "UEFA Europa League"
  elseif self:isInTable(self:getTeam(), GermanyTeams) and self:isInTable(self:getTeam(true), GermanyTeams) then
    return "Bundesliga"
  elseif self:isInTable(self:getTeam(), FranceTeams) and self:isInTable(self:getTeam(true), FranceTeams) then
    return "Ligue 1"
  elseif self:isInTable(self:getTeam(), ItalyTeams) and self:isInTable(self:getTeam(true),ItalyTeams) then
    return "Serie A"
  else 
    return "Ea Sports"
  end
  end
end

function GameMenu:getShootoutResult()
  local matchScore = self.services.MatchInfoService.GetMatchScore()
  local homeScore = matchScore.homeShootout
  local awayScore = matchScore.awayShootout
  if homeScore == -1 or awayScore == -1 then
    return ""
  else
    return string.format("(%s - %s) %s", tostring(homeScore), tostring(awayScore), ("PEN"))
  end
end

function GameMenu:getGameState()
  if self.navContext.gameState == CommonNavVars.GAME_STATES.PAUSE then
    return ("Game Paused")
  elseif self.navContext.gameState == CommonNavVars.GAME_STATES.HALFTIME then
    return ("Halftime")
  elseif self.navContext.gameState == CommonNavVars.GAME_STATES.FULLTIME then
    return ("Fulltime")
  elseif self.navContext.gameState == CommonNavVars.GAME_STATES.OT_HALFTIME then
    return ("Halftime ET")
  elseif self.navContext.gameState == CommonNavVars.GAME_STATES.OT_FULLTIME then
    return ("Fulltime ET")
  elseif self.navContext.gameState == CommonNavVars.GAME_STATES.SHOOTOUT_PAUSE then
    return ("Shootout Pause")
  else
    return nil
  end
end

function GameMenu:getAvatarPath(isAway)
  local userIsHostTeam = self.services.GameSetupService.IsHostTeam()
  if userIsHostTeam and isAway or not userIsHostTeam and not isAway then
    if self.navContext.flow ~= CommonNavVars.FLOWS.ONLINE then
      return nil
    else
      return self.services.SocialService.GetImagePathForOpponent(true)
    end
  else
    return self.services.SocialService.GetImagePathForUser(true)
  end
end

function GameMenu:getTeam(isAway)
  local teamData = self.services.MatchInfoService.GetMatchTeams()
  if isAway then
    return teamData[2]
  else
    return teamData[1]
  end
end

function GameMenu:handleCupResult()
  local cupIndex = currentCupData.cupIndex
  if cupIndex > 0 then
    local currentCupGrouping = QuickCupGrouping[cupIndex]
    local matchScore = self.services.MatchInfoService.GetMatchScore()
    local time = self.services.OverlayService.GetGameClockString()
    local gameTime = string.sub(time, 1, string.find(time, ":") - 1)
    local homeShootoutScore = matchScore.homeShootout
    local awayShootoutScore = matchScore.awayShootout
    local facts = self:getMatchFacts()
    local homeScore = facts[1].data.value
    local awayScore = facts[1].data.valueRight
    if homeShootoutScore ~= -1 or awayShootoutScore ~= -1 then
        homeScore = homeScore + homeShootoutScore
        awayScore = awayScore + awayShootoutScore
    end
    if gameTime + 0 < 90 then
        homeScore = 0
        awayScore = 3
    end  
    
    for i = 1, table.getn(QuickCupGrouping[cupIndex]) do
      if not QuickCupGrouping[cupIndex][i][5] then
        if QuickCupGrouping[cupIndex][i][1] == currentCupData.homeID then
          QuickCupGrouping[cupIndex][i][3] = tostring(homeScore)
          QuickCupGrouping[cupIndex][i][4] = tostring(awayScore)
          QuickCupGrouping[cupIndex][i][5] = true
          if homeScore + 0 > awayScore + 0 then
            QuickCupGrouping[cupIndex][i][6] = currentCupData.homeID
          else
            QuickCupGrouping[cupIndex][i][6] = currentCupData.awayID
          end
        elseif QuickCupGrouping[cupIndex][i][2] == currentCupData.homeID then
          QuickCupGrouping[cupIndex][i][3] = tostring(awayScore)
          QuickCupGrouping[cupIndex][i][4] = tostring(homeScore)
          QuickCupGrouping[cupIndex][i][5] = true
          if homeScore + 0 > awayScore + 0 then
            QuickCupGrouping[cupIndex][i][6] = currentCupData.homeID
          else
            QuickCupGrouping[cupIndex][i][6] = currentCupData.awayID
          end
        else
            local teamA = QuickCupGrouping[cupIndex][i][1]
            local teamB = QuickCupGrouping[cupIndex][i][2]
            local scoreList = self:GetTeamRealScore(teamA, teamB)
            QuickCupGrouping[cupIndex][i][3] = tostring(scoreList[teamA])
            QuickCupGrouping[cupIndex][i][4] = tostring(scoreList[teamB])
            QuickCupGrouping[cupIndex][i][5] = true
            if scoreList[teamA] > scoreList[teamB] then
                QuickCupGrouping[cupIndex][i][6] = QuickCupGrouping[cupIndex][i][1]
            else
                QuickCupGrouping[cupIndex][i][6] = QuickCupGrouping[cupIndex][i][2]
            end
        end
      end
    end
    -- 根据胜负关系生成下一轮的对阵表
    local isExist = false
    local length = #QuickCupGrouping[cupIndex]
    local index = 0
    for j = length, 1,  -1 do
        if QuickCupGrouping[cupIndex][j][1] == currentCupData.homeID or QuickCupGrouping[cupIndex][j][2] == currentCupData.homeID then     
          index = index + 1    
          if QuickCupGrouping[cupIndex][j][6] == currentCupData.homeID and index == 1 then
              isExist = true
              break
          end
        end
    end
    if isExist then
        if length < currentCupData.maxMatchSize then
            for k = 1, length do
              local temp = k * 2 - 1
              if temp < length then
                if not QuickCupGrouping[cupIndex][temp][7] and not QuickCupGrouping[cupIndex][temp+1][7] and QuickCupGrouping[cupIndex][temp][5] == true and QuickCupGrouping[cupIndex][temp+1][5] == true then
                  QuickCupGrouping[cupIndex][temp][7] = true
                  QuickCupGrouping[cupIndex][temp+1][7] = true
                  local l = #QuickCupGrouping[cupIndex] + 1
                  QuickCupGrouping[cupIndex][l] = {
                    [1] = 0,
                    [2] = 0,
                    [3] = "0",
                    [4] = "0",
                    [5] = false,
                    [6] = 0,
                    [7] = false
                  }
                  QuickCupGrouping[cupIndex][l][1] = QuickCupGrouping[cupIndex][temp][6]
                  QuickCupGrouping[cupIndex][l][2] = QuickCupGrouping[cupIndex][temp+1][6]
                  QuickCupGrouping[cupIndex][l][3] = "0"
                  QuickCupGrouping[cupIndex][l][4] = "0"
                  QuickCupGrouping[cupIndex][l][5] = false
                  QuickCupGrouping[cupIndex][l][6] = 0
                end
              end
            end
        end
    else
        if length < currentCupData.maxMatchSize then
            for k = 1, table.getn(QuickCupGrouping[cupIndex]) do
              local temp = k * 2 - 1
              if temp < #QuickCupGrouping[cupIndex] then
                if not QuickCupGrouping[cupIndex][temp][7] and not QuickCupGrouping[cupIndex][temp+1][7] and QuickCupGrouping[cupIndex][temp][5] == true and QuickCupGrouping[cupIndex][temp+1][5] == true then
                  QuickCupGrouping[cupIndex][temp][7] = true
                  QuickCupGrouping[cupIndex][temp+1][7] = true
                  local l = #QuickCupGrouping[cupIndex] + 1
                  QuickCupGrouping[cupIndex][l] = {
                    [1] = 0,
                    [2] = 0,
                    [3] = "0",
                    [4] = "0",
                    [5] = false,
                    [6] = 0,
                    [7] = false
                  }
                  QuickCupGrouping[cupIndex][l][1] = QuickCupGrouping[cupIndex][temp][6]
                  QuickCupGrouping[cupIndex][l][2] = QuickCupGrouping[cupIndex][temp+1][6]
                  if QuickCupGrouping[cupIndex][temp][6] ~= currentCupData.homeID and QuickCupGrouping[cupIndex][temp+1][6] ~= currentCupData.homeID then
                    local teamA = QuickCupGrouping[cupIndex][temp][6]
                    local teamB = QuickCupGrouping[cupIndex][temp+1][6]
                    local scoreList = self:GetTeamRealScore(teamA, teamB)
                    QuickCupGrouping[cupIndex][l][3] = tostring(scoreList[teamA])
                    QuickCupGrouping[cupIndex][l][4] = tostring(scoreList[teamB])
                    QuickCupGrouping[cupIndex][l][5] = true
                    if scoreList[teamA] > scoreList[teamB] then
                      QuickCupGrouping[cupIndex][l][6] = QuickCupGrouping[cupIndex][temp][6]
                    else
                      QuickCupGrouping[cupIndex][l][6] = QuickCupGrouping[cupIndex][temp+1][6]
                    end
                  else
                    QuickCupGrouping[cupIndex][l][3] = "0"
                    QuickCupGrouping[cupIndex][l][4] = "0"
                    QuickCupGrouping[cupIndex][l][5] = false
                    QuickCupGrouping[cupIndex][l][6] = 0
                  end
                end
              end
            end
        end
    end
    
    
  end
end

function GameMenu:GetRandomScore(v1, v2)
  if not v1 then
    v1 = 0
  end
  if not v2 then
    v2 = 5
  end
  --math.randomseed(os.clock() * 1357 + os.time())
  local randomScore = math.random(v1, v2)
  return randomScore
end

function GameMenu:GetTeamRealScore(teamA, teamB)
    local teamA_Info = self.services.SquadManagementService.GetTeamInfo(teamA)
    local teamB_Info = self.services.SquadManagementService.GetTeamInfo(teamB)
    local randomTeamA = self:GetRandomScore(1,100)
    local randomTeamB = self:GetRandomScore(1,100)
    local scoreTeamA = self:GetRealScore(randomTeamA)
    local scoreTeamB = self:GetRealScore(randomTeamB)
    local scoreList = {}
    scoreList[teamA] = 0
    scoreList[teamB] = 0
    local poor = math.abs(teamA_Info.overall - teamB_Info.overall)
    local radio = self:GetTeamWinRatio(poor)
    local random = self:GetRandomScore(1,100)
    if teamA_Info.overall > teamB_Info.overall then
        if random <= radio then
            if scoreTeamA > scoreTeamB then
                scoreList[teamA] = scoreTeamA
                scoreList[teamB] = scoreTeamB
            elseif scoreTeamA < scoreTeamB then
                scoreList[teamA] = scoreTeamB
                scoreList[teamB] = scoreTeamA
            else
                scoreList[teamA] = scoreTeamA + 1
                scoreList[teamB] = scoreTeamB
            end
        else
            -- 爆冷
            if scoreTeamA > scoreTeamB then
                scoreList[teamA] = scoreTeamB
                scoreList[teamB] = scoreTeamA
            elseif scoreTeamA < scoreTeamB then
                scoreList[teamA] = scoreTeamA
                scoreList[teamB] = scoreTeamB
            else
                scoreList[teamA] = scoreTeamA
                scoreList[teamB] = scoreTeamB + 1
            end
        end
    elseif teamA_Info.overall < teamB_Info.overall then
        if random <= radio then
            if scoreTeamA > scoreTeamB then
                scoreList[teamA] = scoreTeamB
                scoreList[teamB] = scoreTeamA
            elseif scoreTeamA < scoreTeamB then
                scoreList[teamA] = scoreTeamA
                scoreList[teamB] = scoreTeamB
            else
                scoreList[teamA] = scoreTeamA
                scoreList[teamB] = scoreTeamB + 1
            end
        else
            -- 爆冷
            if scoreTeamA > scoreTeamB then
                scoreList[teamA] = scoreTeamA
                scoreList[teamB] = scoreTeamB
            elseif scoreTeamA < scoreTeamB then
                scoreList[teamA] = scoreTeamB
                scoreList[teamB] = scoreTeamA
            else
                scoreList[teamA] = scoreTeamA + 1
                scoreList[teamB] = scoreTeamB
            end
        end
    else 
        scoreList[teamA] = scoreTeamA
        scoreList[teamB] = scoreTeamB
        if scoreTeamA == scoreTeamB then
            local x = math.random(1, 2)
            if x == 1 then
                scoreList[teamA] = scoreTeamA + 1
            else
                scoreList[teamB] = scoreTeamB + 1
            end
        end
    end
    return scoreList
end

function GameMenu:GetRealScore(random)
    if random > 0 and random <= 15 then
        return 0
    elseif random > 15 and random <= 40 then
        return 1
    elseif random > 40 and random <= 70 then
        return 2
    elseif random > 70 and random <= 85 then
        return 3
    elseif random > 85 and random <= 95 then
        return 4
    elseif random > 95 and random <= 100 then
        return 5
    end
end

function GameMenu:GetTeamWinRatio(poor)
    if poor <= 0 then
        return 50
    elseif poor > 0 and poor <= 3 then
        return 65
    elseif poor > 3 and poor <= 5 then
        return 75
    elseif poor > 5 and poor <= 10 then
        return 85
    elseif poor > 10 and poor <= 15 then
        return 90
    elseif random > 15 and random <= 20 then
        return 95
    else
        return 98
    end
end


function GameMenu:getTeamCrest(isAway)
  return {
    name = "$Crest",
    id = self:getTeam(isAway).assetId
  }
end


function GameMenu:handleChallengeResult()
  local Index = currentChallengeData.Index
  local round = currentChallengeData.round
  if Index > 0 then
     -- local currentMatchData = ChallengeGrouping[Index][round]
      local matchScore = self.services.MatchInfoService.GetMatchScore()
      local time = self.services.OverlayService.GetGameClockString()
      local gameTime = string.sub(time, 1, string.find(time, ":") - 1)
      local homeShootoutScore = matchScore.homeShootout
      local awayShootoutScore = matchScore.awayShootout
      local facts = self:getMatchFacts()
      local homeScore = facts[1].data.value
      local awayScore = facts[1].data.valueRight
      if homeShootoutScore ~= -1 or awayShootoutScore ~= -1 then
          homeScore = homeScore + homeShootoutScore
          awayScore = awayScore + awayShootoutScore
      end
      if gameTime + 0 < 90 then
          homeScore = 0
          awayScore = 3
      end
      ChallengeGrouping[Index][round][3] = homeScore
      ChallengeGrouping[Index][round][4] = awayScore
      ChallengeGrouping[Index][round][5] = true
      if homeScore + 0 > awayScore + 0 then
          ChallengeGrouping[Index][round][7] = true
          -- 解锁下一个比赛
          if round + 0 < #ChallengeGrouping[Index] then
             local nextIndex = round + 1
             ChallengeGrouping[Index][nextIndex][8] = true
          else
              currentChallengeInfo[Index].isSuccess = 2
          end
      else
          currentChallengeInfo[Index].isSuccess = 1
      end

  end
end

function GameMenu:handleLigaResult()
    local Index = currentLigaData.Index
    local round = currentLigaData.round
    if Index > 0 then
        -- Check if the match type is not "FaCup"
            local matchScore = self.services.MatchInfoService.GetMatchScore()
            local time = self.services.OverlayService.GetGameClockString()
            local gameTime = string.sub(time, 1, string.find(time, ":") - 1)
            local homeShootoutScore = matchScore.homeShootout
            local awayShootoutScore = matchScore.awayShootout
            local facts = self:getMatchFacts()
            local homeScore = facts[1].data.value
            local awayScore = facts[1].data.valueRight
            if homeShootoutScore ~= -1 or awayShootoutScore ~= -1 then
                homeScore = homeScore + homeShootoutScore
                awayScore = awayScore + awayShootoutScore
            end
            if gameTime + 0 < 90 then
                if currentHomeTeam == currentSelectedTeamID then
                    homeScore = 0
                    awayScore = 3
                else
                    homeScore = 3
                    awayScore = 0
                end
            end
            LigaGrouping[Index][round][4] = homeScore
            LigaGrouping[Index][round][5] = awayScore

            -- Define big match teams
            local bigMatchTeams = {9, 10, 1, 5, 18, 11, 241, 243, 240, 69, 65, 66, 219, 73, 32, 22, 21, 112172, 36, 44, 45, 47, 48, 52, 39, 245, 246, 247, 234, 236, 237, 86, 78, 327, 326, 325}
            local isBigMatch = false
            for _, teamID in ipairs(bigMatchTeams) do
                if teamID == currentHomeTeam or teamID == currentSelectedTeamID then
                    isBigMatch = true
                    break
                end
            end

            -- Determine if it's a home or away game and if it's a win
            local isHomeGame = (currentHomeTeam == currentSelectedTeamID)
            local isWin = (isHomeGame and homeScore > awayScore) or (not isHomeGame and awayScore > homeScore)

            -- Helper function to round to nearest 10000 or 100000
            local function roundToClean(num, step)
                return math.floor(num / step + 0.5) * step
            end

            -- Calculate and store revenue in a table with standardized digits
            revenue = {}
            if isBigMatch then
                if isHomeGame then
                    if isWin then
                        revenue.prizeMoney = 200000
                        revenue.gateReceipts = roundToClean(math.random(3000000, 3500000), 100000) -- €3M-€3.5M
                        revenue.sponsorships = 600000
                        revenue.merchandise = roundToClean(math.random(600000, 800000), 100000) -- €600K-€800K
                    else
                        revenue.prizeMoney = 100000
                        revenue.gateReceipts = roundToClean(math.random(2500000, 3000000), 100000) -- €2.5M-€3M
                        revenue.sponsorships = 400000
                        revenue.merchandise = roundToClean(math.random(400000, 600000), 100000) -- €400K-€600K
                    end
                else -- Away game
                    if isWin then
                        revenue.prizeMoney = 200000
                        revenue.gateReceipts = roundToClean(math.random(800000, 1200000), 100000) -- €800K-€1.2M
                        revenue.sponsorships = 600000
                        revenue.merchandise = roundToClean(math.random(400000, 600000), 100000) -- €400K-€600K
                    else
                        revenue.prizeMoney = 100000
                        revenue.gateReceipts = 500000 -- Fixed for €1.3M total
                        revenue.sponsorships = 400000
                        revenue.merchandise = 300000
                    end
                end
            else -- Regular match
                if isHomeGame then
                    revenue.prizeMoney = 50000
                    revenue.gateReceipts = roundToClean(math.random(1000000, 1500000), 100000) -- €1M-€1.5M
                    revenue.sponsorships = 200000
                    revenue.merchandise = roundToClean(math.random(200000, 300000), 10000) -- €200K-€300K
                else
                    revenue.prizeMoney = 50000
                    revenue.gateReceipts = roundToClean(math.random(200000, 400000), 10000) -- €200K-€400K
                    revenue.sponsorships = 200000
                    revenue.merchandise = roundToClean(math.random(100000, 200000), 10000) -- €100K-€200K
                end
            end
            -- Calculate total revenue
            revenue.totalRevenue = revenue.prizeMoney + revenue.gateReceipts + revenue.sponsorships + revenue.merchandise
            GLOBAL_FUNDS = GLOBAL_FUNDS + revenue.totalRevenue
    end
end

function GameMenu:resetSuspensions(currentMatchCount)
  for playerId, matchCount in pairs(redCardMatchCount) do
    if currentMatchCount >= matchCount + 2 then
      isSuspended[playerId] = 0 -- Reset suspension after 2 games
      redCardMatchCount[playerId] = nil -- Remove record to avoid unnecessary checks
    end
  end
end
function GameMenu:handleMatchDayResult()
  if currentMode == 6 then
    local matchScore = self.services.MatchInfoService.GetMatchScore()
    local time = self.services.OverlayService.GetGameClockString()
    local gameTime = string.sub(time, 1, string.find(time, ":") - 1)
    local homeShootoutScore = matchScore.homeShootout
    local awayShootoutScore = matchScore.awayShootout
    local facts = self:getMatchFacts()
    local homeScore = facts[1].data.value
    local awayScore = facts[1].data.valueRight
    if homeShootoutScore ~= -1 or awayShootoutScore ~= -1 then
      homeScore = homeScore + homeShootoutScore
      awayScore = awayScore + awayShootoutScore
    end
    if gameTime + 0 < 90 then
      homeScore = 0
      awayScore = 3
    end
    currentDayMatchList[currentMatch.MatchIndex].score = homeScore.." - "..awayScore
  end
end

function GameMenu:handleBeaproResult()
  local Index = currentBeaproData.Index
  local round = currentBeaproData.round
  if Index > 0 then
     -- local currentMatchData = BeaproGrouping[Index][round]
      local matchScore = self.services.MatchInfoService.GetMatchScore()
      local time = self.services.OverlayService.GetGameClockString()
      local gameTime = string.sub(time, 1, string.find(time, ":") - 1)
      local homeShootoutScore = matchScore.homeShootout
      local awayShootoutScore = matchScore.awayShootout
      local facts = self:getMatchFacts()
      local homeScore = facts[1].data.value
      local awayScore = facts[1].data.valueRight
      if homeShootoutScore ~= -1 or awayShootoutScore ~= -1 then
          homeScore = homeScore + homeShootoutScore
          awayScore = awayScore + awayShootoutScore
      end
      if gameTime + 0 < 90 then
          homeScore = 0
          awayScore = 3
      end
      BeaproGrouping[Index][round][3] = homeScore
      BeaproGrouping[Index][round][4] = awayScore
      BeaproGrouping[Index][round][5] = true
      if homeScore + 0 > awayScore + 0 then
          BeaproGrouping[Index][round][7] = true
          -- 解锁下一个比赛
          if round + 0 < #BeaproGrouping[Index] then
             local nextIndex = round + 1
             BeaproGrouping[Index][nextIndex][8] = true
          else
              currentBeaproInfo[Index].isSuccess = 2
          end
      else
          currentBeaproInfo[Index].isSuccess = 1
      end

  end
end

function GameMenu:GetMatchGrade()
  -- 共五个评级 A B C D F
  local Grade = 0
  local homeScore = self:getGoals(false)
  local awayScore = self:getGoals(true)
  local diffScore = math.abs(homeScore - awayScore)
  if homeScore > awayScore then
    if diffScore >= 2 then
      Grade = 0
    else
      Grade = 1
    end
  elseif homeScore == awayScore then
    Grade = 2
  else
    if diffScore >= 2 then
      Grade = 4
    else
      Grade = 3
    end
  end
  return Grade
end


function GameMenu:getMatchFacts()
  local facts = self.services.MatchInfoService.GetMatchFacts(true)
  local o = facts.homeData
  for i, v in ipairs(o) do
    v.data.valueRight = facts.awayData[i].data.value
  end
  return o
end

function GameMenu:getPausesRemaining(isAway)
  if self.navContext == CommonNavVars.FLOWS.OFFLINE then
    return nil
  end
  local userIsHostTeam = self.services.GameSetupService.IsHostTeam()
  if userIsHostTeam and isAway or not userIsHostTeam and not isAway then
    return tostring(self.services.PauseMenuService.GetOponentPausesLeft())
  else
    return tostring(self.services.PauseMenuService.GetLocalPausesLeft())
  end
end

function GameMenu:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function GameMenu:getGoals(isAway)
  local matchResults = self.services.MatchInfoService.GetMatchResult()
  local dashIdx = string.find(matchResults, self.loc.LocalizeString("LTXT_COMMON_SCORE_SEPARATOR"))
  local homeGoals = tonumber(string.sub(matchResults, 1, dashIdx - 2))
  local awayGoals = tonumber(string.sub(matchResults, dashIdx + 2))
  if isAway then
    return awayGoals
  else
    return homeGoals
  end
end

function GameMenu:finalize()
  print("[GameMenu]: finalize()")
  self.services.GameStateService.UnRegisterListener(BACK_KEY_PRESSED)
  self.im.Unsubscribe(BND_HOME_PAUSES)
  self.im.Unsubscribe(BND_AWAY_PAUSES)
  self.im.Unsubscribe(BND_HOME_USER_DATA)
  self.im.Unsubscribe(BND_AWAY_USER_DATA)
  self.im.Unsubscribe(BND_HOME_TEAM_CREST)
  self.im.Unsubscribe(BND_AWAY_TEAM_CREST)
  self.im.Unsubscribe(BND_HOME_TEAM_NAME_ABBR)
  self.im.Unsubscribe(BND_AWAY_TEAM_NAME_ABBR)
  self.im.Unsubscribe(BND_HOME_TEAM_NAME)
  self.im.Unsubscribe(BND_AWAY_TEAM_NAME)
  self.im.Unsubscribe(BND_RESULT)
  self.im.Unsubscribe(BND_SHOOTOUT_RESULT)
  self.im.Unsubscribe(BND_MATCH_TYPE)
  self.im.Unsubscribe(BND_GAME_STATE)
  self.im.Unsubscribe(BND_STADIUM_NAME)
  self.im.Unsubscribe(BND_TIME)
  self.im.Unsubscribe(BND_LIVE_TILE_MATCHFACTS)
  self.im.Unsubscribe(BND_LIVE_TILE_RESUME)
  self.im.Unsubscribe(BND_LIVE_TILE_SQUAD)
  self.im.Unsubscribe(BND_LIVE_TILE_SQUADAWAY)
  self.im.Unsubscribe(BND_LIVE_TILE_REPLAY)
  self.im.Unsubscribe(BND_LIVE_TILE_CONTROL)
  self.im.Unsubscribe(BND_LIVE_TILE_SETTINGS)
  self.im.Unsubscribe(BND_LIVE_TILE_FORFEIT)
  self.im.Unsubscribe(BND_LIVE_TILE_MATCH_FACTS)
  self.im.Unsubscribe(BND_LIVE_TILE_CAPTURED_MEDIA)
  self.im.Unsubscribe(BND_LIVE_TILE_CAPTURED_MEDIA_ENABLED)
  self.im.Unsubscribe(BND_LIVE_TILE_QUIT)
  self.im.Unsubscribe(BND_SHOW_ONLINE_INFO)
  self.im.Unsubscribe(BND_SHOW_OFFLINE_INFO)
  self.im.Unsubscribe(BND_LIVE_TILE_HIGHLIGHTS)
  self.im.Unsubscribe(BND_LIVE_TILE_REPLAY_ENABLED)
  self.im.UnregisterAction(ACT_TOGGLE_PAUSE)
  self.im.UnregisterAction(ACT_FORFEIT_MATCH)
  self.im.UnregisterAction(ACT_QUIT_MATCH)
  self.im.UnregisterAction(ACT_TO_INGAME_SQUAD)
  self.im.UnregisterAction(ACT_TO_INGAME_SQUADAWAY)
  self.im.UnregisterAction(ACT_RESTART_MATCH)
  self.im.UnregisterAction(ACT_QUITMATCH_TOURNAMENT)
  elf.im.Unsubscribe(BND_LIVE_TILE_MATCHGRADE)
  self.im.Unsubscribe(bndRainVisible)
  self.im.Unsubscribe(bndSnowVisible)
  self.im.Unsubscribe(bndWeather)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  if self.flow == CommonNavVars.FLOWS.OFFLINE then
    self.services.ScreenInfoService.UnsetScreenName("PauseMenuOffline")
  end
end

return GameMenu
