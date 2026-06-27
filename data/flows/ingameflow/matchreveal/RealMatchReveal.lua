-- MOD BY LAOSIJI --
local RealMatchReveal = {}

weatherRandom = 0
cameraIndex = 0
homeTeamlineupData = nil
awayTeamlineupData = nil


leagueIDs = {
  England = 13,
  France = 16,
  Germany = 19,
  Germany2 = 20,
  Italy = 31,
  Spain = 53,
  SpainB = 54,
  Brazil = 7,
  BrazilB = 8,
  Mexico = 341,
  Argentina = 353,
  WomensSuperLeague = 2216,
  Indonesia = 2235,
  SaudiArabia = 350,
  UnitedStates = 39,
  Russia = 67,
  LeaguePari  = 2245,
  Ukraine = 332,
  International = 78
}

EnglandTeams = nil
FranceTeams = nil
GermanyTeams = nil
Germany2Teams = nil
SpainTeams = nil
SpainBTeams = nil
ItalyTeams = nil
BrazilTeams = nil
BrazilBTeams = nil
MexicoTeams = nil
ArgentinaTeams = nil
WomensSuperLeagueTeams = nil
IndonesiaTeams = nil
SaudiArabiaTeams = nil
UnitedStatesTeams = nil
RussiaTeams = nil
LeaguePariTeams = nil
UkraineTeams = nil
InternationalTeams = nil

local EAFCInfo = {
  bnd_shadow_visible = true,
  bnd_home_stadium_bg = {
    name = "$StadiumBackground off",
    id = 0
  },
  bnd_match_info_alignH = "LEFT",
  bnd_match_info_right = 0,
  bnd_match_info_left = -600,
  bnd_loadingIcon_right = -1300000,
  bnd_loadingIcon_bottom = -320,
  bnd_loadingIcon_width = 0,
  bnd_loadingIcon_height = 0,
  bnd_loading_text = "",
  bnd_loading_text_left = 0,
  bnd_loading_text_top = 0,
  bnd_home_team_name = "",
  bnd_home_team_name_left = -120,
  bnd_home_team_name_top = -10,
  bnd_team_name_size = 25,
  bnd_away_team_name = "",
  bnd_away_team_name_left = 120,
  bnd_away_team_name_top = -10,
  bnd_home_team_crest = {
    name = "$Crest",
    id = 0
  },
  bnd_home_team_crest_right = 120,
  bnd_home_team_crest_bottom = 120,
  bnd_team_crest_width = 128,
  bnd_team_crest_height = 128,
  bnd_away_team_crest = {
    name = "$Crest",
    id = 0
  },
  bnd_away_team_crest_right = -120,
  bnd_away_team_crest_bottom = 120,
  bnd_match_type = "",
  bnd_match_type_top = -240,
  bnd_match_type_left = 0,
  bnd_match_vs = "VS",
  bnd_match_vs_bottom = 1200,
  bnd_match_vs_right = 0,
  bnd_match_vs_size = 28,
  bnd_match_stadium_bottom = -100,
  bnd_match_stadium_right = 0,
  bnd_stadium_title = "Stadium",
  bnd_stadium = "",
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 0
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_width = 1,
  bnd_logo_height = 1,
  bnd_logo_left = 50,
  bnd_logo_right = 0,
  bnd_logo_top = 50,
  bnd_logo_bottom = 0,
  
  bnd_BgLoading = {
    name = "$BgLoading",
    id = 0
  },
  bnd_BgLoading_alignV = "CENTER",
  bnd_BgLoading_alignH = "FILL",
  bnd_BgLoading_width = 0,
  bnd_BgLoading_height = 760,
  bnd_BgLoading_left = 0,
  bnd_BgLoading_right = 0,
  bnd_BgLoading_top = 0,
  bnd_BgLoading_bottom = 0
}

function RealMatchReveal:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    matchInfo = o.api("MatchInfoService"),
    userPlate = o.api("UserPlateService"),
    settingsService = o.api("SettingsService"),
    gameSetupService = o.api("GameSetupService"),
    gameStateService = o.api("GameStateService"),
    EventManService = o.api("EventManagerService"),
    socialService = o.api("SocialService"),
    TeamService = o.api("TeamService"),
    SquadManagementService = o.api("SquadMgtService")
  }

  weatherRandom = currentMatchWeather
  if currentMatchWeather == 1 then
    weatherRandom = math.random(2, 8)
  end
  
  o.currentEvent = nil

  EnglandTeams = o.services.TeamService.GetTeams(leagueIDs.England, 0, 0, true)
  FranceTeams = o.services.TeamService.GetTeams(leagueIDs.France, 0, 0, true)
  GermanyTeams = o.services.TeamService.GetTeams(leagueIDs.Germany, 0, 0, true)
  Germany2Teams = o.services.TeamService.GetTeams(leagueIDs.Germany2, 0, 0, true)
  SpainTeams = o.services.TeamService.GetTeams(leagueIDs.Spain, 0, 0, true)
  SpainBTeams = o.services.TeamService.GetTeams(leagueIDs.SpainB, 0, 0, true)
  ItalyTeams = o.services.TeamService.GetTeams(leagueIDs.Italy, 0, 0, true)
  BrazilTeams = o.services.TeamService.GetTeams(leagueIDs.Brazil, 0, 0, true)
  BrazilBTeams = o.services.TeamService.GetTeams(leagueIDs.BrazilB, 0, 0, true)
  MexicoTeams = o.services.TeamService.GetTeams(leagueIDs.Mexico, 0, 0, true)
  ArgentinaTeams = o.services.TeamService.GetTeams(leagueIDs.Argentina, 0, 0, true)
  WomensSuperLeagueTeams = o.services.TeamService.GetTeams(leagueIDs.WomensSuperLeague, 0, 0, true)
  IndonesiaTeams = o.services.TeamService.GetTeams(leagueIDs.Indonesia, 0, 0, true)
  SaudiArabiaTeams = o.services.TeamService.GetTeams(leagueIDs.SaudiArabia, 0, 0, true)
  UnitedStatesTeams = o.services.TeamService.GetTeams(leagueIDs.UnitedStates, 0, 0, true)
  InternationalTeams = o.services.TeamService.GetTeams(leagueIDs.International, 0, 0, true)
 
  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o.TeamsData = o.services.matchInfo.GetMatchTeams()

  if currentCupData.cupIndex > 0 then
    if currentCupData.cupIndex == 1 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 2236
    elseif currentCupData.cupIndex == 2 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 3 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 4 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
   elseif currentCupData.cupIndex == 5 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 7
    elseif currentCupData.cupIndex == 6 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 7 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 8 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 9 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 10 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 11 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 12 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 13 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 14 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 15 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 16 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif currentCupData.cupIndex == 17 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 7
    else 
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    end
    
    elseif currentTourData and currentTourData.tourIndex and currentTourData.tourIndex > 0 then
    if currentTourData.tourIndex == 1 then
    o.currentEvent = EAFCInfo
    o.currentEvent.bnd_BgLoading.id = 2236
  elseif currentTourData.tourIndex == 5 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
  elseif currentTourData.tourIndex == 6 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
  elseif currentTourData.tourIndex == 10 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
  else 
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    end
    
  else
    if o:isInTable(o.TeamsData[1], EnglandTeams) and o:isInTable(o.TeamsData[2], EnglandTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 13
    elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 53
    elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 53
    elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 19
    elseif o:isInTable(o.TeamsData[1], Germany2Teams) and o:isInTable(o.TeamsData[2], Germany2Teams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 19
    elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 16
    elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
     elseif o:isInTable(o.TeamsData[1], BrazilTeams) and o:isInTable(o.TeamsData[2], BrazilTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 7
    elseif o:isInTable(o.TeamsData[1], BrazilBTeams) and o:isInTable(o.TeamsData[2], BrazilBTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 7
    elseif o:isInTable(o.TeamsData[1], MexicoTeams) and o:isInTable(o.TeamsData[2], MexicoTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif o:isInTable(o.TeamsData[1], ArgentinaTeams) and o:isInTable(o.TeamsData[2], ArgentinaTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif o:isInTable(o.TeamsData[1], IndonesiaTeams) and o:isInTable(o.TeamsData[2], IndonesiaTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif o:isInTable(o.TeamsData[1], SaudiArabiaTeams) and o:isInTable(o.TeamsData[2], SaudiArabiaTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 350
    elseif o:isInTable(o.TeamsData[1], WomensSuperLeagueTeams) and o:isInTable(o.TeamsData[2], WomensSuperLeagueTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif o:isInTable(o.TeamsData[1], UnitedStatesTeams) and o:isInTable(o.TeamsData[2], UnitedStatesTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 39
    elseif o:isInTable(o.TeamsData[1], RussiaTeams) and o:isInTable(o.TeamsData[2], RussiaTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 67
    elseif o:isInTable(o.TeamsData[1], LeaguePariTeams) and o:isInTable(o.TeamsData[2], LeaguePariTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 67
    elseif o:isInTable(o.TeamsData[1], UkraineTeams) and o:isInTable(o.TeamsData[2], UkraineTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    else 
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_BgLoading.id = 0
    end
  end

  o.currentEvent.bnd_stadium = o.currentOptions.stadium
  o.currentEvent.bnd_home_team_crest.id = o.TeamsData[1].assetId
  o.currentEvent.bnd_away_team_crest.id = o.TeamsData[2].assetId
  o.currentEvent.bnd_home_team_name = o.TeamsData[1].teamName
  o.currentEvent.bnd_away_team_name = o.TeamsData[2].teamName
  o.currentEvent.bnd_home_stadium_bg.id = o:GetStadiumID()
  
  if o.TeamsData[1].assetId == 243  then
     o.currentEvent.bnd_home_openAnim.id = 1
  end

  local controllerId = o.services.gameStateService.GetPreferedControllerId()
  o.customizationOptions = o.services.settingsService.GetCustomizationOptions(controllerId)
  o:initCameraData(o.customizationOptions[6].data)

  homeTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(0, o.TeamsData[1].assetId, 0)
  awayTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(1, o.TeamsData[2].assetId, 0)
  
  for k,v in pairs(o.currentEvent) do
    o.im.Subscribe(k, function()
      o.im.Publish(k, v)
    end)
  end
  
  return o
end

function RealMatchReveal:initCameraData(cameraData)
  cameraIndex = cameraData.currentValue
end

function RealMatchReveal:GetStadiumID()
  if self.currentOptions.stadium == "Old Trafford" then
    return 1
  elseif self.currentOptions.stadium == "Santiago Bernabéu" then
    return 2
  elseif self.currentOptions.stadium == "San Siro" then
    return 5
  elseif self.currentOptions.stadium == "Camp Nou" then
    return 6
  elseif self.currentOptions.stadium == "Anfield" then
    return 13
  elseif self.currentOptions.stadium == "Parc des Princes" then
    return 14
  elseif self.currentOptions.stadium == "Amsterdam ArenA" then
    return 15
  elseif self.currentOptions.stadium == "Maracanã" then
    return 26
  elseif self.currentOptions.stadium == "Stamford Bridge" then
    return 28
  elseif self.currentOptions.stadium == "Arena MRV" then
    return 30
  elseif self.currentOptions.stadium == "Union Park Stadium" then
    return 33
  elseif self.currentOptions.stadium == "Estádio da Luz" then
    return 34
  elseif self.currentOptions.stadium == "Neo Química Arena" then
    return 42
  elseif self.currentOptions.stadium == "Estadio Azteca" then
    return 104
  elseif self.currentOptions.stadium == "White Hart Lane" then
    return 116
  elseif self.currentOptions.stadium == "Allianz Arena" then
    return 137
  elseif self.currentOptions.stadium == "Beijing Olympic Stadium" then
    return 147
  elseif self.currentOptions.stadium == "Arena Fonte Nova" then
    return 153
  elseif self.currentOptions.stadium == "Wembley Stadium" then
    return 155
  elseif self.currentOptions.stadium == "Emirates Stadium" then
    return 156
  elseif self.currentOptions.stadium == "Stadio Olimpico" then
    return 157
  elseif self.currentOptions.stadium == "Beira Rio" then
    return 158
  elseif self.currentOptions.stadium == "Mineirão" then
    return 172
  elseif self.currentOptions.stadium == "Allianz Parque" then
    return 174
  elseif self.currentOptions.stadium == "Waldstadion" then
    return 176
  elseif self.currentOptions.stadium == "São Januário" then
    return 177
  elseif self.currentOptions.stadium == "Ivy Lane" then
    return 180
  elseif self.currentOptions.stadium == "Civitas Metropolitano" then
    return 183
  elseif self.currentOptions.stadium == "La Bombonera" then
    return 264
  elseif self.currentOptions.stadium == "Stadion Olympik" then
    return 195
  elseif self.currentOptions.stadium == "Olympic Stadium London" then
    return 196
  elseif self.currentOptions.stadium == "MorumBis" then
    return 229
  elseif self.currentOptions.stadium == "Etihad Stadium" then
    return 246
  elseif self.currentOptions.stadium == "Juventus Stadium" then
    return 247
  elseif self.currentOptions.stadium == "Molton Road" then
    return 249
  elseif self.currentOptions.stadium == "Olympiastadion Berlin" then
    return 135
  elseif self.currentOptions.stadium == "Mrsool Park Stadium" then
    return 100
  elseif self.currentOptions.stadium == "St James' Park" then
    return 177
  elseif self.currentOptions.stadium == "The Amex Stadium" then
    return 115
  elseif self.currentOptions.stadium == "Al Janoub Stadium" then
    return 265
  elseif self.currentOptions.stadium == "Goodison Park" then
    return 35
  elseif self.currentOptions.stadium == "Lusail Stadium" then
    return 228
  elseif self.currentOptions.stadium == "Vila Belmiro" then
    return 260
  else
    return 0
  end
end

function RealMatchReveal:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function RealMatchReveal:finalize()
  for k,v in pairs(EAFCInfo) do
    self.im.Unsubscribe(k)
  end
end
return RealMatchReveal