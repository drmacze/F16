local TableUtil, CommonNavVars, GameStateServiceEnums, OverlayParam, EventManager = ...
local GameMenu = {}
local BND_HOME_PAUSES = "bnd_home_team_pauses"
local BND_AWAY_PAUSES = "bnd_away_team_pauses"
local BND_HOME_USER_DATA = "bnd_home_user_data"
local BND_AWAY_USER_DATA = "bnd_away_user_data"
local BND_HOME_TEAM_CREST = "bnd_home_team_crest"
local BND_AWAY_TEAM_CREST = "bnd_away_team_crest"
local BND_HOME_TEAM_NAME_ABBR = "bnd_home_team_name_abbr"
local BND_AWAY_TEAM_NAME_ABBR = "bnd_away_team_name_abbr"
local BND_HOME_TEAM_NAME = "bnd_home_team_name"
local BND_AWAY_TEAM_NAME = "bnd_away_team_name"
local BND_RESULT = "bnd_result"
local BND_KIT_HOME_TEAM = "bnd_kit_home_team"
local BND_KIT_HOMEGK_TEAM = "bnd_kit_homegk_team"
local BND_KIT_AWAY_TEAM = "bnd_kit_away_team"
local BND_KIT_AWAYGK_TEAM = "bnd_kit_awaygk_team"
local BND_SHOOTOUT_RESULT = "bnd_shootout_result"
local BND_MATCH_TYPE = "bnd_match_type"
local BND_GAME_STATE = "bnd_game_state"
local BND_STADIUM_NAME = "bnd_stadium_name"
local BND_TIME = "bnd_time"
local BND_HOME_TEAM_CREST2 = "bnd_home_team_crest2"
local BND_MATCH_FACTS = "bnd_match_facts"
local BND_LIVE_TILE_RESUME = "bnd_live_tile_resume"
local BND_LIVE_TILE_SQUAD = "bnd_live_tile_squad"
local BND_LIVE_TILE_SQUADAWAY = "bnd_live_tile_squadaway"
local BND_LIVE_TILE_CONTROL = "bnd_live_tile_control"
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
local bndRainVisible = "bnd_rain_visible"
local bndSnowVisible = "bnd_snow_visible"
local bndWeather = "bnd_weather_type"
local ACT_TOGGLE_PAUSE = "act_toggle_pause"
local ACT_FORFEIT_MATCH = "act_forfeit_match"
local ACT_QUIT_MATCH = "act_quit_match"
local ACT_RESTART_MATCH = "act_restart_match"
local ACT_TO_INGAME_SQUAD = "act_to_ingame_squad"
local ACT_TO_INGAME_SQUADAWAY = "act_to_ingame_squadaway"
local BND_TOUR_MATCH_ID = "bnd_tour_match_id"
local currentTourMatchIndex = nil

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
  o.playerbg = {
    name = "$_CommentatorNPC",
    id = 0
  }
  math.randomseed(os.clock() * 1357 + os.time())
  local currentTime = os.date("%H") + 0
  local random2 = math.random(2)
  o.im.Subscribe("bnd_main_bg", function()
    if currentTime < 12 and currentTime >= 6 then
        o.mainbg.id = 1
    elseif currentTime >= 12 and currentTime < 18 then
        o.mainbg.id = 2
    elseif currentTime >= 18 or currentTime < 6 then
        o.mainbg.id = 3
    end
    o.im.Publish("bnd_main_bg", o.mainbg)
  end)
  o.im.Subscribe("bnd_player_bg", function()
    o.playerbg.id = random2
    o.im.Publish("bnd_player_bg", o.playerbg)
  end
   )
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
  o.im.RegisterAction(ACT_RESTART_MATCH, function(actionName)
    o:restartMatch()
  end
  )
  o.im.RegisterAction(ACT_TO_INGAME_SQUAD, function(actionName)
    o.nav.Event(nil, "evt_to_ingame_squad")
  end
  )
  o.im.RegisterAction(ACT_TO_INGAME_SQUADAWAY, function(actionName)
    o.nav.Event(nil, "evt_to_ingame_squadaway")
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
  o.im.Subscribe(BND_TOUR_MATCH_ID, function()
    o.im.Publish(BND_TOUR_MATCH_ID, currentTourMatchIndex)
end)
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
  o.im.Subscribe(BND_HOME_TEAM_CREST2, function()
    o.im.Publish(BND_HOME_TEAM_CREST2, o:getTeamCrest2())
  end
  )
  o.im.Subscribe(BND_HOME_TEAM_CREST3, function()
    o.im.Publish(BND_HOME_TEAM_CREST3, o:getTeamCrest3())
  end
   )
  o.im.Subscribe(BND_AWAY_TEAM_CREST3, function()
    o.im.Publish(BND_AWAY_TEAM_CREST3, o:getTeamCrest3(true))
  end
   )
   o.im.Subscribe(BND_KIT_HOME_TEAM, function()
    o.im.Publish(BND_KIT_HOME_TEAM, o:getTeamKit3(true))
  end
   )
  o.im.Subscribe(BND_KIT_HOMEGK_TEAM, function()
    o.im.Publish(BND_KIT_HOMEGK_TEAM, o:getTeamKit4(true))
  end
   )
  o.im.Subscribe(BND_KIT_AWAY_TEAM, function()
    o.im.Publish(BND_KIT_AWAY_TEAM, o:getTeamKit5(true))
  end
   )
  o.im.Subscribe(BND_KIT_AWAYGK_TEAM, function()
    o.im.Publish(BND_KIT_AWAYGK_TEAM, o:getTeamKit6(true))
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
    local currentTime = os.date("%H:%M")
    local state = o:getGameState().." | "..currentTime.." | "..o.services.SettingsService.GetCurrentOptions().stadium.." | "..o:getMatchType()
    o.im.Publish(BND_GAME_STATE, state)
  end
  )
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
    o.im.Publish(BND_LIVE_TILE_RESUME, OverlayParam.split(("RESUME"), " "))
  end
  )
  o.im.Subscribe(BND_LIVE_TILE_SQUAD, function()
    o.im.Publish(BND_LIVE_TILE_SQUAD, {
      ("SQUAD")
    })
  end
  )
  o.im.Subscribe(BND_LIVE_TILE_SQUADAWAY, function()
    o.im.Publish(BND_LIVE_TILE_SQUADAWAY, {
      ("SQUADAWAY")
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
      ("QUIT MATCH")
    })
  end
  )
  o.liveTileLists = {}
  table.insert(o.liveTileLists, {
    headline = {
      "SQUAD"
    },
    subHeadline = "HOME",
    images = {
      o:getTeamCrest()
    },
    autoScaleImageToTileHeight= true,
    clickAction = ACT_TO_INGAME_SQUAD
  })
  table.insert(o.liveTileLists, {
    headline = {
      "SQUAD"
    },
    subHeadline = "AWAY",
    images = {
      o:getTeamCrest()
    },
    autoScaleImageToTileHeight= true,
    clickAction = ACT_TO_INGAME_SQUADAWAY
  })
  o.im.Subscribe(bndLiveTileList, function()
    o:_publishLiveTiles()
  end
  )
  o.liveTileLists2 = {}
  table.insert(o.liveTileLists2, {
    headline = {
      "SETTINGS"
    },
    images = {
      "$_IconSettings"
    },
    autoScaleImageToTileHeight= true,
    clickAction = "act_to_settings"
  })

  if currentMode == 0 then
    table.insert(o.liveTileLists2, {
        headline = {
          "SIDE SELECT"
        },
        images = {
          "$_IconSelectSide"
        },
        autoScaleImageToTileHeight= true,
        clickAction = "act_selectside"
    })
  end
  
  
  o.im.Subscribe(bndLiveTileList2, function()
    o:_publishLiveTiles2()
  end)
  o.im.Subscribe(BND_LIVE_TILE_REPLAY, function()
    o.im.Publish(BND_LIVE_TILE_REPLAY, {
      ("REPLAY")
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
      ("END MATCH")
    })
  end
  )
    o.im.Subscribe(BND_LIVE_TILE_RESTART, function()
    o.im.Publish(BND_LIVE_TILE_RESTART, OverlayParam.split(("RESTART"), " "))
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
  
  weatherType = {
     name = "$Weather",
     id = 0
  }
  random = currentMatchWeather
  if currentMatchWeather == 1 then
    random = math.random(2, 8)
  end
  o.im.Subscribe(bndRainVisible, function()
    if random == 6 then
      o.im.Publish(bndRainVisible, true)
    else 
      o.im.Publish(bndRainVisible, false)
    end
  end
  )
  o.im.Subscribe(bndSnowVisible, function()
    if random == 8 then
      o.im.Publish(bndSnowVisible, true)
    else 
      o.im.Publish(bndSnowVisible, false)
    end
  end
  )
  o.im.Subscribe(bndWeather, function()
    if random == 3 then
      -- Nuansa Sunset 
       weatherType.id = 1
      o.im.Publish(bndWeather, weatherType)
    elseif random == 4 then
       -- Mendung Tanpo Udan
       weatherType.id = 2
    o.im.Publish(bndWeather, weatherType)
       
    elseif random == 5 or random == 6 then
       -- Berkabut Tebal
       weatherType.id = 4
       o.im.Publish(bndWeather, weatherType)
       
    elseif random == 7 or random == 8 then
       -- Salju / Biru+VibeUCL
       weatherType.id = 3
      o.im.Publish(bndWeather, weatherType)
    else
      -- Cerah Polosan
       weatherType.id = 0
       o.im.Publish(bndWeather, weatherType)
    end
    o.im.Publish(bndWeather, weatherType)
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
  elseif screenName == "Customization" or screenName == "TouchControls" 
      or screenName == "AudioVisual" or screenName == "General" 
      or screenName == "ControllerControls" or screenName == "DebugSettings" then
    self.nav.Event(nil, "evt_save_settings")
  elseif self.isGamePaused then
    self.isGamePaused = false
    self.nav.Event(nil, "evt_toggle_pause")
  end
end

-- Menu Restart --
function GameMenu:restartMatch()
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
      "evt_restart_match",
      "evt_hide_popup"
    }
  }
  
  local popupData = {
    title = "RESTART MATCH",
    message = "Are you sure you want to restart this match?",
    buttons = {buttonNo, buttonYes}
  }
  
  local missionModePopup = {
    title = "MISSIONS MODE",
    message = "You can't restart a League match",
    buttons = {buttonNo}
  }
  
  if gamemode == "missionMode" then
    self.nav.Event(nil, "evt_show_popup", missionModePopup)
  else
    self.nav.Event(nil, "evt_show_popup", popupData)
  end  
end

-- Menu Forfeit Match --
function GameMenu:forfeitMatch()
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
        "evt_quit_from_game",
        "evt_hide_popup"
      }
    }
    local popupData = {
      title = "END MATCH",
      message = "Are you sure you want to end this match?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function GameMenu:quitMatch()
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
      "evt_hide_popup" 
    },
    clickCallback = function()
      print("✅ Quit confirmation received. Handling all match results before exiting...")
      
      self:handleTourResult()
      self:handleCupResult()
      self:handleChallengeResult()
      self:handleMatchDayResult()
      self:handleBeaproResult()
      self:handleLigaResult()

      if currentMode == 4 then
        local index = cameraIndex + 0
        self.services.SettingsService.SaveCameraValue(index)
      end

      self.nav.Event(nil, "evt_quit")
      print("✅ All results handled. Executing quit event.")
    end
  }
  
  local popupData = {
    title = "QUIT MATCH",
    message = "Are you sure you want to quit this match?",
    buttons = {buttonNo, buttonYes}
  }

  self.nav.Event(nil, "evt_show_popup", popupData)
end

function GameMenu:onNumberOfPauseLeftChanged()
  self.im.Refresh(BND_HOME_PAUSES)
  self.im.Refresh(BND_AWAY_PAUSES)
end

function GameMenu:getMatchType()
  if currentTourData and currentTourData.tourIndex and currentTourData.tourIndex > 0 then
    local tourName = currentTourData.tourName or "TOURNAMENT MATCH"
    local roundName = currentTourData.roundName or ""
    return roundName ~= "" and (tourName .. "\n" .. string.upper(roundName)) or tourName
  end

  if currentCupData and currentCupData.cupIndex > 0 then
    local cupNames = {
      [1] = "UEFA Champions League", [2] = "UEFA Europa League", [3] = "UEFA Euro",
      [4] = "UEFA Nations League", [5] = "UEFA Women's CL", [6] = "CONMEBOL Libertadores",
      [7] = "CONMEBOL Sudamericana", [8] = "CONMEBOL Copa America", [9] = "FIFA Club World Cup",
      [10] = "FIFA World Cup", [11] = "The Emirates FA Cup", [12] = "Copa del Rey",
      [13] = "Coppa Italia", [14] = "DFB-Pokal", [15] = "Coupe de France",
      [16] = "Copa do Brasil", [17] = "Paulistão 2026"
    }
    return cupNames[currentCupData.cupIndex] or "CUP MATCH"
  end
  
  local homeTeam = self:getTeam(false)
  local awayTeam = self:getTeam(true)
  
  local leagueIDs = {
      PremierLeague = 13, ChampionshipEfl = 14, LeagueOneEfl = 60, WomenSuperLeague = 2216,
      Ligue1 = 16, Ligue2 = 17, D1Arkema = 2218, Bundesliga1 = 19, Bundesliga2 = 20,
      BRILiga1 = 2235, PegadaianLiga2 = 2254, International = 78, InternationalWomans = 2136,
      SerieA = 31, SerieB = 32, Korea = 83, Malaysia = 2237, LigaMX = 341,
      Morocco = 2250, Eredivisie = 10, LigaPortugal = 308, RestOfWolrd1 = 76, RestOfWolrd2 = 77,
      RoshnSaudiLeague = 350, Scotland = 50, SouthAfrica = 347, Laliga = 53, LaligaHypermotion = 54,
      LigaF = 2222, Thailand = 2252, Turkey = 68, Ucl = 2236, Uel = 2238,
      Uwcl = 2240, MLS = 39, Nwsl = 2221, Vietnam = 2260, AFC = 365,
      Argentina = 353, Belgium = 4, Brazil = 7, BrazilB = 8, Classic = 1245, Classic2 = 1246, Egypt = 2231
  }
  
  local leagueDisplayNames = {
      PremierLeague = "Premier League", ChampionshipEfl = "EFL Championship", LeagueOneEfl = "EFL League One",
      WomenSuperLeague = "Women's Super League", Ligue1 = "Ligue 1 Uber Eats", Ligue2 = "Ligue 2 BKT",
      D1Arkema = "D1 Arkema", Bundesliga1 = "Bundesliga", Bundesliga2 = "2. Bundesliga",
      BRILiga1 = "BRI Liga 1", PegadaianLiga2 = "Pegadaian Liga 2", International = "International Match",
      InternationalWomans = "Women's International", SerieA = "Serie A TIM", SerieB = "Serie BKT",
      Korea = "K League 1", Malaysia = "Malaysia Super League", LigaMX = "Liga BBVA MX",
      Morocco = "Botola Pro 1", Eredivisie = "Eredivisie", LigaPortugal = "Liga Portugal",
      RestOfWolrd1 = "Rest of World", RestOfWolrd2 = "Rest of World", RoshnSaudiLeague = "Roshn Saudi League",
      Scotland = "cinch Premiership", SouthAfrica = "DStv Premiership", Laliga = "La Liga",
      LaligaHypermotion = "La Liga Hypermotion", LigaF = "Liga F", Thailand = "Hilux Revo Thai League",
      Turkey = "Trendyol Süper Lig", Ucl = "UEFA Champions League", Uel = "UEFA Europa League",
      Uwcl = "UEFA Women's CL", MLS = "MLS", Nwsl = "NWSL", Vietnam = "V.League 1",
      AFC = "AFC Challenge Cup", Argentina = "Liga Profesional", Belgium = "Jupiler Pro League",
      Brazil = "Brasileirão Serie A", BrazilB = "Brasileirão Serie B", Russia = "Russian League", LeaguePari = "League Pari", Ukraine = "Ukrainian League", Classic = "Classic XI", Classic2 = "Classic XI", Egypt = "Egyptian Premier League"
  }

  for leagueName, leagueID in pairs(leagueIDs) do
      local teamsInLeague = self.services.TeamService.GetTeams(leagueID, 0, 0, true)
      
      if self:isInTable(homeTeam, teamsInLeague) and self:isInTable(awayTeam, teamsInLeague) then
          return leagueDisplayNames[leagueName] or leagueName
      end
  end
  return "Friendly Match"
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
    return ("Ot Halftime")
  elseif self.navContext.gameState == CommonNavVars.GAME_STATES.OT_FULLTIME then
    return ("Ot Fulltime")
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

function GameMenu:getTeamCrest2(isHome)
  return {
    name = "$Crest2",
    id = self:getTeam(isHome).assetId
  }
end

function GameMenu:getTeamCrest(isAway)
  return {
    name = "$Crest",
    id = self:getTeam(isAway).assetId
  }
end

function GameMenu:getTeamKit3()
  return {
    name = "$HomeKit",
    id = self:getTeam().assetId
  }
end

function GameMenu:getTeamKit5(isAway)
  return {
    name = "$AwayKit",
    id = self:getTeam(isAway).assetId
  }
end

function GameMenu:getTeamKit4()
  return {
    name = "$GkKit",
    id = self:getTeam().assetId
  }
end

function GameMenu:getTeamKit6(isAway)
  return {
    name = "$GkKit",
    id = self:getTeam(isAway).assetId
  }
end

function GameMenu:handleChallengeResult()
  local Index = currentChallengeData.Index
  local round = currentChallengeData.round
  if Index > 0 then
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
        local matchScore = self.services.MatchInfoService.GetMatchScore()
        local time = self.services.OverlayService.GetGameClockString()
        local gameTime = string.sub(time, 1, string.find(time, ":") - 1)
        local homeShootoutScore = matchScore.homeShootout
        local awayShootoutScore = matchScore.awayShootout
        local facts = self:getMatchFacts()
        local homeScore = facts[1].data.value
        local awayScore = facts[1].data.valueRight

        -- Aplica o resultado real mesmo se o jogo for quitado
        if homeShootoutScore ~= -1 or awayShootoutScore ~= -1 then
            homeScore = homeScore + homeShootoutScore
            awayScore = awayScore + awayShootoutScore
        end

        -- Salva o placar final atual (sem sobrescrever)
        LigaGrouping[Index][round][4] = homeScore
        LigaGrouping[Index][round][5] = awayScore

        local bigMatchTeams = {9, 10, 1, 5, 18, 11, 241, 243, 240, 69, 65, 66, 219, 73, 32, 22, 21, 112172, 36, 44, 45, 47, 48, 52, 39, 245, 246, 247, 234, 236, 237, 86, 78, 327, 326, 325}
        local isBigMatch = false
        for _, teamID in ipairs(bigMatchTeams) do
            if teamID == currentHomeTeam or teamID == currentSelectedTeamID then
                isBigMatch = true
                break
            end
        end

        local isHomeGame = (currentHomeTeam == currentSelectedTeamID)
        local isWin = (isHomeGame and homeScore > awayScore) or (not isHomeGame and awayScore > homeScore)

        local function roundToClean(num, step)
            return math.floor(num / step + 0.5) * step
        end

        revenue = {}
        if isBigMatch then
            if isHomeGame then
                if isWin then
                    revenue.prizeMoney = 200000
                    revenue.gateReceipts = roundToClean(math.random(3000000, 3500000), 100000)
                    revenue.sponsorships = 600000
                    revenue.merchandise = roundToClean(math.random(600000, 800000), 100000)
                else
                    revenue.prizeMoney = 100000
                    revenue.gateReceipts = roundToClean(math.random(2500000, 3000000), 100000)
                    revenue.sponsorships = 400000
                    revenue.merchandise = roundToClean(math.random(400000, 600000), 100000)
                end
            else
                if isWin then
                    revenue.prizeMoney = 200000
                    revenue.gateReceipts = roundToClean(math.random(800000, 1200000), 100000)
                    revenue.sponsorships = 600000
                    revenue.merchandise = roundToClean(math.random(400000, 600000), 100000)
                else
                    revenue.prizeMoney = 100000
                    revenue.gateReceipts = 500000
                    revenue.sponsorships = 400000
                    revenue.merchandise = 300000
                end
            end
        else
            if isHomeGame then
                revenue.prizeMoney = 50000
                revenue.gateReceipts = roundToClean(math.random(1000000, 1500000), 100000)
                revenue.sponsorships = 200000
                revenue.merchandise = roundToClean(math.random(200000, 300000), 10000)
            else
                revenue.prizeMoney = 50000
                revenue.gateReceipts = roundToClean(math.random(200000, 400000), 10000)
                revenue.sponsorships = 200000
                revenue.merchandise = roundToClean(math.random(100000, 200000), 10000)
            end
        end

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

-- ===================================================================
-- CUSTOM CUP
-- ===================================================================
function GameMenu:GetTeamRealScore(teamA, teamB)
    local teamAInfo = self.services.SquadManagementService.GetTeamInfo(teamA) or { overall = 75 }
    local teamBInfo = self.services.SquadManagementService.GetTeamInfo(teamB) or { overall = 75 }
    
    local scoreA = math.random(0, 5)
    local scoreB = math.random(0, 5)
    
    local overallDiff = (teamAInfo.overall or 75) - (teamBInfo.overall or 75)
    local winBias = 50 + (overallDiff * 2)
    
    if math.random(1, 100) <= winBias then
        if scoreA < scoreB then scoreA, scoreB = scoreB, scoreA end
    else
        if scoreB < scoreA then scoreA, scoreB = scoreB, scoreA end
    end
    
    if scoreA == scoreB then
        if math.random(1, 100) <= winBias then
            scoreA = scoreA + 1
        else
            scoreB = scoreB + 1
        end
    end
    
    return { [teamA] = scoreA, [teamB] = scoreB }
end

function GameMenu:RecordAIMatchStats(teamA, teamB, scoreA, scoreB)
    local tourId = GlobalTournamentSettings.tourId or 1
    
    TournamentStats[tourId] = TournamentStats[tourId] or {
        Goals = {}, Assists = {}, Appearances = {},
        YellowCards = {}, RedCards = {}
    }
    TeamPlayerCache[tourId] = TeamPlayerCache[tourId] or {}
    TeamPlayerCache[tourId][teamA] = TeamPlayerCache[tourId][teamA] or self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamA, 0) or {}
    TeamPlayerCache[tourId][teamB] = TeamPlayerCache[tourId][teamB] or self.services.SquadManagementService.GetCurrentPlayerLineup(1, teamB, 0) or {}

    for _ = 1, scoreA do
        local lineup = TeamPlayerCache[tourId][teamA]
        if #lineup > 1 then

            local scorerIndex = math.random(#lineup)
            local scorer = lineup[scorerIndex]
            
            local assisterIndex = math.random(#lineup)

            while assisterIndex == scorerIndex do
                assisterIndex = math.random(#lineup)
            end
            local assister = lineup[assisterIndex]

            if scorer and scorer.CARD_ID then
                TournamentStats[tourId].Goals[scorer.CARD_ID] = (TournamentStats[tourId].Goals[scorer.CARD_ID] or 0) + 1
                print(string.format("⚽ AI Goal: %s (%s) for %s", scorer.playerName, scorer.CARD_ID, teamA))
            end

            if assister and assister.CARD_ID then
                TournamentStats[tourId].Assists[assister.CARD_ID] = (TournamentStats[tourId].Assists[assister.CARD_ID] or 0) + 1
                print(string.format("🤝 AI Assist: %s (%s) for %s", assister.playerName, assister.CARD_ID, teamA))
            end
        end
    end


    for _ = 1, scoreB do
        local lineup = TeamPlayerCache[tourId][teamB]
        if #lineup > 1 then
            local scorerIndex = math.random(#lineup)
            local scorer = lineup[scorerIndex]
            
            local assisterIndex = math.random(#lineup)
            while assisterIndex == scorerIndex do
                assisterIndex = math.random(#lineup)
            end
            local assister = lineup[assisterIndex]

            if scorer and scorer.CARD_ID then
                TournamentStats[tourId].Goals[scorer.CARD_ID] = (TournamentStats[tourId].Goals[scorer.CARD_ID] or 0) + 1
                print(string.format("⚽ AI Goal: %s (%s) for %s", scorer.playerName, scorer.CARD_ID, teamB))
            end

            if assister and assister.CARD_ID then
                TournamentStats[tourId].Assists[assister.CARD_ID] = (TournamentStats[tourId].Assists[assister.CARD_ID] or 0) + 1
                print(string.format("🤝 AI Assist: %s (%s) for %s", assister.playerName, assister.CARD_ID, teamB))
            end
        end
    end

    for _, player in ipairs(TeamPlayerCache[tourId][teamA]) do
        if player.CARD_ID then
            TournamentStats[tourId].Appearances[player.CARD_ID] = (TournamentStats[tourId].Appearances[player.CARD_ID] or 0) + 1
        end
    end
    for _, player in ipairs(TeamPlayerCache[tourId][teamB]) do
        if player.CARD_ID then
            TournamentStats[tourId].Appearances[player.CARD_ID] = (TournamentStats[tourId].Appearances[player.CARD_ID] or 0) + 1
        end
    end
end

-- ✅ SINCRONIZA MATCHDAYS QUANDO INICIA UMA PARTIDA
-- Garante que todos os times joguem no mesmo matchday
function GameMenu:synchronizeCurrentMatchday()
    if not currentPlayedMatchIndex or not GlobalTournamentSettings then
        return
    end
    
    local tourId = GlobalTournamentSettings.tourId or 1
    local match = QuickTourGrouping[tourId] and QuickTourGrouping[tourId][currentPlayedMatchIndex]
    
    if not match or not match[8] then  -- Só para group stage
        return
    end
    
    local currentMatchday = match[10]
    local userTeamId = currentTourInfo[tourId].homeID
    local groupLetter = match[9]
    
    print("🔄 Synchronizing matchday " .. currentMatchday .. " for group " .. groupLetter)
    
    -- ✅ ENCONTRA TODOS OS MATCHES DESTE MATCHDAY/GRUPO
    local groupMatches = {}
    for i, m in ipairs(QuickTourGrouping[tourId]) do
        if m[8] and m[9] == groupLetter and m[10] == currentMatchday then
            table.insert(groupMatches, {index = i, data = m})
        end
    end
    
    -- ✅ VERIFICA SE TODOS OS TIMES TÊM A MESMA QUANTIDADE DE MATCHES NÃO JOGADOS
    local teamMatchCount = {}
    for _, match_info in ipairs(groupMatches) do
        local m = match_info.data
        if not m[5] then  -- Match não foi jogado
            teamMatchCount[m[1]] = (teamMatchCount[m[1]] or 0) + 1
            teamMatchCount[m[2]] = (teamMatchCount[m[2]] or 0) + 1
        end
    end
    
    -- ✅ PRINT DEBUG
    print("⚽ Teams in this matchday:")
    for teamID, count in pairs(teamMatchCount) do
        print(string.format("   Team %d: %d unplayed matches", teamID, count))
    end
    
    return true
end

-- 🔧 NOVA FUNÇÃO: Atualizar LeagueStandings após match do usuário
function GameMenu:UpdateLeagueStandingsAfterUserMatch(tourId, match, homeScore, awayScore)
    print("🔧 [GameMenu] Updating League Standings after user match...")
    
    if not GlobalTournamentSettings.isLeagueMode then
        print("   Not in League mode, skipping...")
        return
    end
    
    -- Inicializar LeagueStandings se não existir
    if not LeagueStandings[tourId] then
        LeagueStandings[tourId] = {}
        
        if QuickTourGrouping[tourId] then
            local teamsInitialized = {}
            for _, m in ipairs(QuickTourGrouping[tourId]) do
                if m[9] == "LEAGUE" then
                    if not teamsInitialized[m[1]] then
                        LeagueStandings[tourId][m[1]] = {
                            teamId = m[1],
                            played = 0,
                            wins = 0,
                            draws = 0,
                            losses = 0,
                            goalsFor = 0,
                            goalsAgainst = 0,
                            points = 0
                        }
                        teamsInitialized[m[1]] = true
                    end
                    
                    if not teamsInitialized[m[2]] then
                        LeagueStandings[tourId][m[2]] = {
                            teamId = m[2],
                            played = 0,
                            wins = 0,
                            draws = 0,
                            losses = 0,
                            goalsFor = 0,
                            goalsAgainst = 0,
                            points = 0
                        }
                        teamsInitialized[m[2]] = true
                    end
                end
            end
        end
    end
    
    -- Atualizar standings
    local homeId = match[1]
    local awayId = match[2]
    
    if not LeagueStandings[tourId][homeId] or not LeagueStandings[tourId][awayId] then
        print("   ERROR: Teams not found in LeagueStandings")
        return
    end
    
    local lsHome = LeagueStandings[tourId][homeId]
    local lsAway = LeagueStandings[tourId][awayId]
    
    lsHome.played = lsHome.played + 1
    lsAway.played = lsAway.played + 1
    lsHome.goalsFor = lsHome.goalsFor + homeScore
    lsHome.goalsAgainst = lsHome.goalsAgainst + awayScore
    lsAway.goalsFor = lsAway.goalsFor + awayScore
    lsAway.goalsAgainst = lsAway.goalsAgainst + homeScore
    
    if homeScore > awayScore then
        lsHome.wins = lsHome.wins + 1
        lsHome.points = lsHome.points + 3
        lsAway.losses = lsAway.losses + 1
    elseif awayScore > homeScore then
        lsAway.wins = lsAway.wins + 1
        lsAway.points = lsAway.points + 3
        lsHome.losses = lsHome.losses + 1
    else
        lsHome.draws = lsHome.draws + 1
        lsAway.draws = lsAway.draws + 1
        lsHome.points = lsHome.points + 1
        lsAway.points = lsAway.points + 1
    end
    
    print(string.format("   ✅ Updated: %d (%.0d pts) vs %d (%d pts)", homeId, lsHome.points, awayId, lsAway.points))
end

-- 🔧 NOVA FUNÇÃO: Atualizar LeagueStandings após matches de IA
function GameMenu:UpdateLeagueStandingsForAIMatch(tourId, match, homeScore, awayScore)
    print(string.format("🔧 [GameMenu] Updating League Standings for AI match: %d vs %d", match[1], match[2]))
    
    if not GlobalTournamentSettings.isLeagueMode then
        return
    end
    
    if not LeagueStandings[tourId] then
        print("   ERROR: LeagueStandings not initialized")
        return
    end
    
    local homeId = match[1]
    local awayId = match[2]
    
    if not LeagueStandings[tourId][homeId] or not LeagueStandings[tourId][awayId] then
        print("   ERROR: Teams not found in LeagueStandings")
        return
    end
    
    local lsHome = LeagueStandings[tourId][homeId]
    local lsAway = LeagueStandings[tourId][awayId]
    
    lsHome.played = lsHome.played + 1
    lsAway.played = lsAway.played + 1
    lsHome.goalsFor = lsHome.goalsFor + homeScore
    lsHome.goalsAgainst = lsHome.goalsAgainst + awayScore
    lsAway.goalsFor = lsAway.goalsFor + awayScore
    lsAway.goalsAgainst = lsAway.goalsAgainst + homeScore
    
    if homeScore > awayScore then
        lsHome.wins = lsHome.wins + 1
        lsHome.points = lsHome.points + 3
        lsAway.losses = lsAway.losses + 1
    elseif awayScore > homeScore then
        lsAway.wins = lsAway.wins + 1
        lsAway.points = lsAway.points + 3
        lsHome.losses = lsHome.losses + 1
    else
        lsHome.draws = lsHome.draws + 1
        lsAway.draws = lsAway.draws + 1
        lsHome.points = lsHome.points + 1
        lsAway.points = lsAway.points + 1
    end
end

-- ✅ PROCESSA RESULTADO DO MATCH DO USUÁRIO E SINCRONIZA MATCHDAYS
function GameMenu:handleTourResult()
    if not currentPlayedMatchIndex or not GlobalTournamentSettings or not GlobalTournamentSettings.tourId then
        print("❌ [handleTourResult] Error: Missing required tournament data")
        return
    end

    -- ✅ SINCRONIZA OS MATCHDAYS PRIMEIRO
    self:synchronizeCurrentMatchday()

    local tourId = GlobalTournamentSettings.tourId
    local matchIndex = currentPlayedMatchIndex
    local match = QuickTourGrouping[tourId] and QuickTourGrouping[tourId][matchIndex]

    if not match then
        print("❌ [handleTourResult] Error: Match data not found for tourId:", tourId, "matchIndex:", matchIndex)
        return
    end

    print("🔧 [handleTourResult] Processing tournament match results...")

    local matchScore = self.services.MatchInfoService.GetMatchScore() or {}
    local time = self.services.OverlayService.GetGameClockString() or "90:00"
    local gameTime = tonumber(string.match(time, "^(%d+):")) or 90

    local homeScore, awayScore
    if instance and instance.eventsData then
        homeScore = #(instance.eventsData.homeData or {})
        awayScore = #(instance.eventsData.awayData or {})
    else
        local facts = self:getMatchFacts() or {}
        homeScore = facts[1] and facts[1].data.value or 0
        awayScore = facts[1] and facts[1].data.valueRight or 0
    end

    if matchScore.homeShootout and matchScore.awayShootout and 
       matchScore.homeShootout > -1 and matchScore.awayShootout > -1 then
        homeScore = matchScore.homeShootout
        awayScore = matchScore.awayShootout
    end

    local winnerId = 0
    if homeScore > awayScore then
        winnerId = match[1]
    elseif awayScore > homeScore then
        winnerId = match[2]
    end

    if gameTime < 90 then
    local userTeamId = currentTourInfo[tourId].homeID
    
    -- ✅ GRUPO ou LEAGUE: manter placar atual
    if match[8] or match[9] == "LEAGUE" then
        print(string.format("📝 [handleTourResult] Group/League Mode: Keeping current score %d-%d", homeScore, awayScore))
        -- Placar já está correto em homeScore e awayScore, não muda nada
    else
        -- ✅ KNOCKOUT: forçar derrota 3-0
        print("❌ [handleTourResult] Knockout Mode: Forcing 0-3 loss")
        if match[1] == userTeamId then
            homeScore, awayScore, winnerId = 0, 3, match[2]  -- User loses 0-3 at home
        else
            homeScore, awayScore, winnerId = 0, 3, match[1]  -- User loses 0-3 away
        end
    end
end

    if match[7] and winnerId == 0 then
        local userTeamId = currentTourInfo[tourId].homeID
        winnerId = (match[1] == userTeamId) and match[2] or match[1]
    end

    match[3], match[4], match[5], match[6] = homeScore, awayScore, true, winnerId
    print(string.format("✅ Match result saved: Score %d-%d, Winner: %d", homeScore, awayScore, winnerId))
    
    -- 🔧 NOVO: Atualizar LeagueStandings após match do usuário
    if GlobalTournamentSettings.isLeagueMode and match[9] == "LEAGUE" then
        self:UpdateLeagueStandingsAfterUserMatch(tourId, match, homeScore, awayScore)
    end
    
    currentPlayedMatchIndex = nil

    if match[8] then -- Group stage
        self:processGroupStage(tourId, match)
    else -- Knockout stage
        self:processKnockoutStage(tourId, match)
    end

    print("🧹 [handleTourResult] All processes completed.")
end

-- ✅ PROCESSA GROUP STAGE COM SINCRONIZAÇÃO COMPLETA DE MATCHDAYS
function GameMenu:processGroupStage(tourId, currentMatch)
    print("-> Group stage detected. Simulating remaining matches in the same matchday...")
    local matchday = currentMatch[10]
    local userTeamId = currentTourInfo[tourId].homeID

    -- ✅ SIMULA TODOS OS MATCHES DO MATCHDAY ATUAL (exceto do usuário)
    for _, m in ipairs(QuickTourGrouping[tourId]) do
        if m[8] and m[10] == matchday and not m[5] and m[1] ~= userTeamId and m[2] ~= userTeamId then
            local scores = self:GetTeamRealScore(m[1], m[2])
            local homeScore, awayScore = scores[m[1]], scores[m[2]]
            
            m[3], m[4], m[5] = homeScore, awayScore, true
            m[6] = (homeScore > awayScore and m[1]) or (awayScore > homeScore and m[2]) or 0
            
            print(string.format("   -> Recording stats for AI match: %s vs %s (%d-%d)", m[1], m[2], homeScore, awayScore))
            self:RecordAIMatchStats(m[1], m[2], homeScore, awayScore)
        end
    end

    if QuickTour and QuickTour.SaveMatchResult then 
        QuickTour:SaveMatchResult() 
    end

    local allGroupMatchesDone = true
    for _, m in ipairs(QuickTourGrouping[tourId]) do
        if m[8] and not m[5] then 
            allGroupMatchesDone = false
            break 
        end
    end
    
    -- ✅ SE NÃO TERMINOU TUDO, SIMULA OS PRÓXIMOS MATCHDAYS SINCRONIZADOS
    if not allGroupMatchesDone then
        print("🔄 Not all group matches done. Simulating next matchdays progressively...")
        self:simulateNextMatchdaysProgressively(tourId, userTeamId)
    end
    
    if allGroupMatchesDone and QuickTour and QuickTour.GenerateKnockoutFromGroupStandings then
        print("🏁 All group matches completed. Generating Round of 16...")
        QuickTour:GenerateKnockoutFromGroupStandings()
    end
end

-- ✅ NOVA FUNÇÃO: Simula próximos matchdays de forma sincronizada
-- Garante que TODOS os times em TODOS os grupos joguem o mesmo número de partidas
function GameMenu:simulateNextMatchdaysProgressively(tourId, userTeamId)
    print("📊 Starting progressive matchday simulation...")
    local simulated = 0
    
    -- ✅ ENCONTRA O PRÓXIMO MATCHDAY COM MATCHES NÃO JOGADOS
    for nextMatchday = 1, 6 do
        local hasUnplayedMatches = false
        local hasUserMatchThisDay = false
        local matchesSimulatedThisDay = 0
        
        -- ✅ PRIMEIRO PASSA: Verifica se há matches do usuário neste matchday
        for _, m in ipairs(QuickTourGrouping[tourId]) do
            if m[8] and m[10] == nextMatchday and not m[5] then
                hasUnplayedMatches = true
                if m[1] == userTeamId or m[2] == userTeamId then
                    hasUserMatchThisDay = true
                    print(string.format("⏸️ User match found at matchday %d. Stopping simulation.", nextMatchday))
                    break
                end
            end
        end
        
        if hasUserMatchThisDay then
            print(string.format("✅ Progressive simulation complete: %d matches simulated", simulated))
            if QuickTour and QuickTour.SaveMatchResult then 
                QuickTour:SaveMatchResult() 
            end
            self:debugTeamMatchCounts(tourId)
            return
        end
        
        -- ✅ SEGUNDO PASSES: Simula todos os outros matches deste matchday
        if hasUnplayedMatches then
            print(string.format("🔄 Simulating matchday %d...", nextMatchday))
            
            for _, m in ipairs(QuickTourGrouping[tourId]) do
                if m[8] and m[10] == nextMatchday and not m[5] then
                    local scores = self:GetTeamRealScore(m[1], m[2])
                    m[3], m[4], m[5] = scores[m[1]], scores[m[2]], true
                    m[6] = (m[3] > m[4] and m[1]) or (m[4] > m[3] and m[2]) or 0
                    
                    self:RecordAIMatchStats(m[1], m[2], m[3], m[4])
                    
                    -- 🔧 NOVO: Atualizar LeagueStandings para matches de IA
                    if GlobalTournamentSettings.isLeagueMode and m[9] == "LEAGUE" then
                        self:UpdateLeagueStandingsForAIMatch(tourId, m, m[3], m[4])
                    end
                    
                    matchesSimulatedThisDay = matchesSimulatedThisDay + 1
                    simulated = simulated + 1
                end
            end
            
            if matchesSimulatedThisDay > 0 then
                print(string.format("   ✅ Matchday %d: Simulated %d matches", nextMatchday, matchesSimulatedThisDay))
            end
        end
    end
    
    print(string.format("✅ Progressive simulation complete: %d matches simulated", simulated))
    if QuickTour and QuickTour.SaveMatchResult then 
        QuickTour:SaveMatchResult() 
    end
    self:debugTeamMatchCounts(tourId)
end

-- ✅ FUNÇÃO DEBUG, Verifica sincronização de matchdays
function GameMenu:debugTeamMatchCounts(tourId)
    if not QuickTourGrouping[tourId] then return end
    
    local teamMatchCount = {}
    local teamGroups = {}
    
    for _, matchData in ipairs(QuickTourGrouping[tourId]) do
        if matchData[8] then
            if matchData[5] then
                teamMatchCount[matchData[1]] = (teamMatchCount[matchData[1]] or 0) + 1
                teamMatchCount[matchData[2]] = (teamMatchCount[matchData[2]] or 0) + 1
                teamGroups[matchData[1]] = matchData[9]
                teamGroups[matchData[2]] = matchData[9]
            end
        end
    end
    
    local minMatches = math.huge
    local maxMatches = 0
    
    for teamId, count in pairs(teamMatchCount) do
        if count < minMatches then minMatches = count end
        if count > maxMatches then maxMatches = count end
    end
    
    if minMatches == math.huge then
        print("📊 No matches played yet")
        return
    end
    
    print(string.format("📊 Team matches: Min=%d, Max=%d, Diff=%d", minMatches, maxMatches, maxMatches - minMatches))
    
    if maxMatches - minMatches == 0 then
        print("✅ PERFECT SYNCHRONIZATION: All teams have exactly the same number of matches!")
    elseif maxMatches - minMatches == 1 then
        print("✅ BALANCED: Teams differ by at most 1 match (acceptable)")
    else
        print("⚠️ UNBALANCED: Teams have significantly different match counts")
        print("Teams with different match counts:")
        for teamId, count in pairs(teamMatchCount) do
            if count ~= maxMatches and count ~= minMatches then
                print(string.format("   Team %d (Group %s): %d matches", teamId, teamGroups[teamId], count))
            end
        end
    end
end

function GameMenu:processKnockoutStage(tourId, currentMatch)
    local currentRoundName = currentMatch[9] or "Unknown Round"
    print("-> Knockout stage detected ("..currentRoundName.."). Simulating remaining matches in this round...")

    for _, m in ipairs(QuickTourGrouping[tourId]) do
        if m[9] == currentRoundName and not m[5] then
            local scores = self:GetTeamRealScore(m[1], m[2])
            local homeScore, awayScore = scores[m[1]], scores[m[2]]

            m[3], m[4], m[5] = homeScore, awayScore, true
            m[6] = (homeScore > awayScore and m[1]) or m[2]

            print(string.format("   -> Recording stats for AI knockout match: %s vs %s (%d-%d)", m[1], m[2], homeScore, awayScore))
            self:RecordAIMatchStats(m[1], m[2], homeScore, awayScore)
        end
    end

    local winners = {}
    for _, m in ipairs(QuickTourGrouping[tourId]) do
        if m[9] == currentRoundName and m[6] then
            table.insert(winners, m[6])
        end
    end

    if #winners > 0 then
        if #winners == 1 then
            print("🏆 Tournament Completed! Champion has been determined.")
        elseif QuickTour and QuickTour.GenerateNextKnockoutRound then
            print("Advancing to the next round...")
            QuickTour:GenerateNextKnockoutRound(winners)
        end
    end
end

function GameMenu:SimulateTournamentMatch(teamA, teamB)
    print("🤖 Simulating FULL STATS for AI match: " .. tostring(teamA) .. " vs " .. tostring(teamB))
    
    local teamA_Info = self.services.SquadManagementService.GetTeamInfo(teamA) or {}
    local teamB_Info = self.services.SquadManagementService.GetTeamInfo(teamB) or {}
    local teamA_Lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamA, 0) or {}
    local teamB_Lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(1, teamB, 0) or {}

    local overallDiff = (teamA_Info.overall or 75) - (teamB_Info.overall or 75)
    local winBias = 50 + (overallDiff * 2)
    local scoreA = math.random(0, 4)
    local scoreB = math.random(0, 4)
    
    if math.random(1, 100) <= winBias then
        if scoreA < scoreB then scoreA, scoreB = scoreB, scoreA end
    else
        if scoreB < scoreA then scoreA, scoreB = scoreB, scoreA end
    end
    
    local tourId = GlobalTournamentSettings and GlobalTournamentSettings.tourId or 1
    TournamentStats[tourId] = TournamentStats[tourId] or { 
        Goals = {}, 
        Assists = {}, 
        Appearances = {} 
    }

    if scoreA > 0 and #teamA_Lineup > 0 then
        for i = 1, scoreA do
            local randomPlayerIndex = math.random(1, #teamA_Lineup)
            local scorer = teamA_Lineup[randomPlayerIndex]
            if scorer and scorer.CARD_ID then
                TournamentStats[tourId].Goals[scorer.CARD_ID] = (TournamentStats[tourId].Goals[scorer.CARD_ID] or 0) + 1
                print("⚽ Simulated Goal for (Team A - " .. tostring(teamA_Info.teamName) .. "):", tostring(scorer.playerName))
            end
        end
    end

    if scoreB > 0 and #teamB_Lineup > 0 then
        for i = 1, scoreB do
            local randomPlayerIndex = math.random(1, #teamB_Lineup)
            local scorer = teamB_Lineup[randomPlayerIndex]
            if scorer and scorer.CARD_ID then
                TournamentStats[tourId].Goals[scorer.CARD_ID] = (TournamentStats[tourId].Goals[scorer.CARD_ID] or 0) + 1
                print("⚽ Simulated Goal for (Team B - " .. tostring(teamB_Info.teamName) .. "):", tostring(scorer.playerName))
            end
        end
    end

    for _, player in ipairs(teamA_Lineup) do
        if player.CARD_ID then
            TournamentStats[tourId].Appearances[player.CARD_ID] = (TournamentStats[tourId].Appearances[player.CARD_ID] or 0) + 1
        end
    end
    for _, player in ipairs(teamB_Lineup) do
        if player.CARD_ID then
            TournamentStats[tourId].Appearances[player.CARD_ID] = (TournamentStats[tourId].Appearances[player.CARD_ID] or 0) + 1
        end
    end
    
    print("✅ Appearances for simulated match recorded.")
    
    return { [teamA] = scoreA, [teamB] = scoreB }
end

-- Helper functions
function GameMenu:simulateSameMatchdayMatchesExceptUser(teamID, matchday, tourIndex)
    for _, match in ipairs(QuickTourGrouping[tourIndex] or {}) do
        if match[8] and match[10] == matchday and not match[5] then
            if match[1] ~= teamID and match[2] ~= teamID then
                local scoreList = self:GetTeamRealScore(match[1], match[2])
                match[3], match[4] = tostring(scoreList[match[1]]), tostring(scoreList[match[2]])
                match[5] = true
                match[6] = (scoreList[match[1]] == scoreList[match[2]]) and 0 or 
                          (scoreList[match[1]] > scoreList[match[2]] and match[1] or match[2])
                match[7] = (scoreList[match[1]] == scoreList[match[2]])
                match[8] = true
                match[9] = match[9] or "Group"
                match[10] = matchday
            end
        end
    end
end

local function getNextStageName(grouping)
    if not grouping then return "knockout" end
    
    for i = #grouping, 1, -1 do
        if grouping[i][9] then
            if grouping[i][9] == "Round of 16" then return "Quarterfinal" end
            if grouping[i][9] == "Quarterfinal" then return "Semifinal" end
            if grouping[i][9] == "Semifinal" then return "Final" end
        end
    end
    return "knockout"
end

function GameMenu:UpdateGroupStandings(tourIndex)
    print("Updating group standings for tour", tourIndex)
    -- Função placeholder para atualizar standings dos grupos
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
      
      -- NÃO FORCE 3-0 EM MODO BEAPRO
      -- if gameTime + 0 < 90 then
      --     homeScore = 0
      --     awayScore = 3
      -- end
      
      BeaproGrouping[Index][round][3] = homeScore
      BeaproGrouping[Index][round][4] = awayScore
      BeaproGrouping[Index][round][5] = true
      
      if homeScore + 0 > awayScore + 0 then
          -- VITÓRIA: Desbloqueia próximo confronto
          BeaproGrouping[Index][round][7] = true
          if round + 0 < #BeaproGrouping[Index] then
             local nextIndex = round + 1
             BeaproGrouping[Index][nextIndex][8] = true
          else
              -- Completou todos os confrontos com vitórias
              currentBeaproInfo[Index].isSuccess = 2
          end
      else
          -- DERROTA ou EMPATE
          -- Contar falhas acumuladas
          local failures = self:countBeaproFailures(Index)
          
          if failures >= 3 then
              -- Atingiu 3 derrotas/empates: FALHA NA MISSÃO
              currentBeaproInfo[Index].isSuccess = 1
          else
              -- Ainda tem chances: Desbloqueia próximo confronto
              if round + 0 < #BeaproGrouping[Index] then
                 local nextIndex = round + 1
                 BeaproGrouping[Index][nextIndex][8] = true
              else
                  -- Completou mas com derrota/empate no último
                  currentBeaproInfo[Index].isSuccess = 1
              end
          end
      end
  end
end

function GameMenu:countBeaproFailures(Index)
  local failures = 0
  local group = BeaproGrouping[Index]
  
  if not group then return 0 end

  for i = 1, #group do
    local m = group[i]
    if m[5] == true then  -- Se a partida foi jogada
      if m[3] < m[4] then -- Derrota
        failures = failures + 1
      elseif m[3] == m[4] then -- Empate
        failures = failures + 1
      end
    end
  end
  
  return failures
end

function GameMenu:GetMatchGrade()
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
  self.im.Unsubscribe(BND_HOME_TEAM_CREST2)
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