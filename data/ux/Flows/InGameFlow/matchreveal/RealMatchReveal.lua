-- Thanks : Ma'ruf Id & Laosiji --
-- TLS 26 RealMatchReveral Fc26 --

local RealMatchReveal = {}

weatherRandom = 0
cameraIndex = 0
playernibOption = 0
HudOption = 0
homeTeamlineupData = nil
awayTeamlineupData = nil

leagueIDs = {
  PremierLeague = 13,
  ChampionshipEfl = 14,
  LeagueOneEfl = 60,
  WomenSuperLeague = 2216,
  Ligue1 = 16,
  Ligue2 = 17,
  D1Arkema = 2218,
  Bundesliga = 19,
  Bundesliga2 = 20,
  BRILiga1 = 2235,
  ChampionshipLiga2 = 2254,
  International = 78,
  InternationalWomans = 2136,
  SerieA = 31,
  SerieB = 32,
  Korea = 83,
  Malaysia = 2237,
  LigaMX = 341,
  Morocco = 2250,
  Eredivisie = 10,
  LigaPortugal = 308,
  RestOfWolrd1 = 76,
  RestOfWolrd2 = 77,
  RoshnSaudiLeague = 350,
  Scotland = 50,
  SouthAfrica = 347,
  Laliga = 53,
  LaligaHypermotion = 54,
  LigaF = 2222,
  Thailand = 2252,
  Turkey = 68,
  Ucl = 2236,
  Uel = 2238,
  Uwcl = 2240,
  MLS = 39,
  Nwsl = 2221,
  Vietnam = 2260,
  AFC = 365,
  Argentina = 353,
  Belgium = 4,
  Brazil = 7,
  Classic = 1245,
  Classic2 = 1246,
  Egypt = 2231
}

PremierLeagueTeams = nil
ChampionshipEflTeams = nil
LeagueOneEflTeams = nil
WomenSuperLeagueTeams = nil
Ligue1Teams = nil
Ligue2Teams = nil
D1ArkemaTeams = nil
BundesligaTeams = nil
Bundesliga2Teams = nil
BRILiga1Teams = nil
ChampionshipLiga2Teams = nil
InternationalTeams = nil
InternationalWomansTeams = nil
SerieATeams = nil
SerieBTeams = nil
KoreaTeams = nil
MalaysiaTeams = nil
LigaMXTeams = nil
MoroccoTeams = nil
EredivisieTeams = nil
LigaPortugalTeams = nil
RestOfWolrd1Teams = nil
RestOfWolrd2Teams = nil
RoshnSaudiLeagueTeams = nil
ScotlandTeams = nil
SouthAfricaTeams = nil
LaligaTeams = nil
LaligaHypermotionTeams = nil
LigaFTeams = nil
ThailandTeams = nil
TurkeyTeams = nil
UclTeams = nil
UelTeams = nil
UwclTeams = nil
MLSTeams = nil
NwslTeams = nil
VietnamTeams = nil
AFCTeams = nil
ArgentinaTeams = nil
BelgiumTeams = nil
BrazilTeams = nil
ClassicTeams = nil
Classic2Teams = nil
EgyptTeams = nil

-- Universal

local EAFCInfo = {
  bnd_universal_show = true,
  bnd_cup_show = false,
  bnd_home_stadium_bg = { name = "$StadiumBackground", id = 0 },
  bnd_home_cup_bg = { name = "$X", id = 0 },
  bnd_home_team_name = "",
  bnd_away_team_name = "",
  bnd_home_team_crest = { name = "$Crest", id = 0 },
  bnd_away_team_crest = { name = "$Crest", id = 0 },
  bnd_match_type = "",
  bnd_stadium = "",
  bnd_logo = { name = "$LeagueLogo", id = 0 }
}

-- Cup

local LoadingCupInfo = {
  bnd_universal_show = true,
  bnd_cup_show = false,
  bnd_home_stadium_bg = { name = "$StadiumBackground", id = 0 },
  bnd_home_cup_bg = { name = "$X", id = 0 },
  bnd_home_team_name = "",
  bnd_away_team_name = "",
  bnd_home_team_crest = { name = "$Crest", id = 0 },
  bnd_away_team_crest = { name = "$Crest", id = 0 },
  bnd_match_type = "",
  bnd_stadium = "",
  bnd_logo = { name = "$LeagueLogo", id = 0 }
}

-- Finish

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
  
  liveLogo = {
    name = "$LiveLogo",
    id = 0
  }
  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o.TeamsData = o.services.matchInfo.GetMatchTeams()
  
  o.currentdata = nil

  PremierLeagueTeams = o.services.TeamService.GetTeams(leagueIDs.PremierLeague, 0, 0, true)
  ChampionshipEflTeams = o.services.TeamService.GetTeams(leagueIDs.ChampionshipEfl, 0, 0, true)
  LeagueOneEflTeams = o.services.TeamService.GetTeams(leagueIDs.LeagueOneEfl, 0, 0, true)
  WomenSuperLeagueTeams = o.services.TeamService.GetTeams(leagueIDs.WomenSuperLeague, 0, 0, true)
  Ligue1Teams = o.services.TeamService.GetTeams(leagueIDs.Ligue1, 0, 0, true)
  Ligue2Teams = o.services.TeamService.GetTeams(leagueIDs.Ligue2, 0, 0, true)
  D1ArkemaTeams = o.services.TeamService.GetTeams(leagueIDs.D1Arkema, 0, 0, true)
  BundesligaTeams = o.services.TeamService.GetTeams(leagueIDs.Bundesliga, 0, 0, true)
  Bundesliga2Teams = o.services.TeamService.GetTeams(leagueIDs.Bundesliga2, 0, 0, true)
  BRILiga1Teams = o.services.TeamService.GetTeams(leagueIDs.BRILiga1, 0, 0, true)
  ChampionshipLiga2Teams = o.services.TeamService.GetTeams(leagueIDs.ChampionshipLiga2, 0, 0, true)
  InternationalTeams = o.services.TeamService.GetTeams(leagueIDs.International, 0, 0, true)
  InternationalWomansTeams = o.services.TeamService.GetTeams(leagueIDs.InternationalWomans, 0, 0, true)
  SerieATeams = o.services.TeamService.GetTeams(leagueIDs.SerieA, 0, 0, true)
  SerieBTeams = o.services.TeamService.GetTeams(leagueIDs.SerieB, 0, 0, true)
  KoreaTeams = o.services.TeamService.GetTeams(leagueIDs.Korea, 0, 0, true)
  MalaysiaTeams = o.services.TeamService.GetTeams(leagueIDs.Malaysia, 0, 0, true)
  LigaMXTeams = o.services.TeamService.GetTeams(leagueIDs.LigaMX, 0, 0, true)
  MoroccoTeams = o.services.TeamService.GetTeams(leagueIDs.Morocco, 0, 0, true)
  EredivisieTeams = o.services.TeamService.GetTeams(leagueIDs.Eredivisie, 0, 0, true)
  LigaPortugalTeams = o.services.TeamService.GetTeams(leagueIDs.LigaPortugal, 0, 0, true)
  RestOfWolrd1Teams = o.services.TeamService.GetTeams(leagueIDs.RestOfWolrd1, 0, 0, true)
  RestOfWolrd2Teams = o.services.TeamService.GetTeams(leagueIDs.RestOfWolrd2, 0, 0, true)
  RoshnSaudiLeagueTeams = o.services.TeamService.GetTeams(leagueIDs.RoshnSaudiLeague, 0, 0, true)
  ScotlandTeams = o.services.TeamService.GetTeams(leagueIDs.Scotland, 0, 0, true)
  SouthAfricaTeams = o.services.TeamService.GetTeams(leagueIDs.SouthAfrica, 0, 0, true)
  LaligaTeams = o.services.TeamService.GetTeams(leagueIDs.Laliga, 0, 0, true)
  LaligaHypermotionTeams = o.services.TeamService.GetTeams(leagueIDs.LaligaHypermotion, 0, 0, true)
  LigaFTeams = o.services.TeamService.GetTeams(leagueIDs.LigaF, 0, 0, true)
  ThailandTeams = o.services.TeamService.GetTeams(leagueIDs.Thailand, 0, 0, true)
  TurkeyTeams = o.services.TeamService.GetTeams(leagueIDs.Turkey, 0, 0, true)
  UclTeams = o.services.TeamService.GetTeams(leagueIDs.Ucl, 0, 0, true)
  UelTeams = o.services.TeamService.GetTeams(leagueIDs.Uel, 0, 0, true)
  UwclTeams = o.services.TeamService.GetTeams(leagueIDs.Uwcl, 0, 0, true)
  MLSTeams = o.services.TeamService.GetTeams(leagueIDs.MLS, 0, 0, true)
  NwslTeams = o.services.TeamService.GetTeams(leagueIDs.Nwsl, 0, 0, true)
  VietnamTeams = o.services.TeamService.GetTeams(leagueIDs.Vietnam, 0, 0, true)
  AFCTeams = o.services.TeamService.GetTeams(leagueIDs.AFC, 0, 0, true)
  ArgentinaTeams = o.services.TeamService.GetTeams(leagueIDs.Argentina, 0, 0, true)
  BelgiumTeams = o.services.TeamService.GetTeams(leagueIDs.Belgium, 0, 0, true)
  BrazilTeams = o.services.TeamService.GetTeams(leagueIDs.Brazil, 0, 0, true)
  ClassicTeams = o.services.TeamService.GetTeams(leagueIDs.Classic, 0, 0, true)
  Classic2Teams = o.services.TeamService.GetTeams(leagueIDs.Classic2, 0, 0, true)
  EgyptTeams = o.services.TeamService.GetTeams(leagueIDs.Egypt, 0, 0, true)

  if currentCupData.cupIndex > 0 then
    if currentCupData.cupIndex == 1 then
      o.currentdata = LoadingCupInfo
      o.currentdata.bnd_home_cup_bg.id = 1
      o.currentdata.bnd_logo.id = "2236_1"
      o.currentdata.bnd_match_type = "UEFA CHAMPIONS LEAGUE"
    elseif currentCupData.cupIndex == 16 then
      o.currentdata = LoadingCupInfo
      o.currentdata.bnd_home_cup_bg.id = 16
      o.currentdata.bnd_logo.id = "2240_1"
      o.currentdata.bnd_match_type = "UEFA WOMEN'S CHAMPIONS LEAGUE"
     elseif currentCupData.cupIndex == 3 then
      o.currentdata = LoadingCupInfo
      o.currentdata.bnd_home_cup_bg.id = 3
      o.currentdata.bnd_logo.id = "353_1"
      o.currentdata.bnd_match_type = "LIBERTADORES CHAMPIONS LEAGUE"
   elseif currentCupData.cupIndex == 4 then
      o.currentdata = LoadingCupInfo
      o.currentdata.bnd_home_cup_bg.id = 4
      o.currentdata.bnd_logo.id = "2238_1"
      o.currentdata.bnd_match_type = "UEFA EUROPA LEAGUE"
   end
    
  else
    if o:isInTable(o.TeamsData[1], PremierLeagueTeams) and o:isInTable(o.TeamsData[2], PremierLeagueTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = "13_1"
      liveLogo.id = 1
    elseif o:isInTable(o.TeamsData[1], ChampionshipEflTeams) and o:isInTable(o.TeamsData[2], ChampionshipEflTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 14
    elseif o:isInTable(o.TeamsData[1], LeagueOneEflTeams) and o:isInTable(o.TeamsData[2], LeagueOneEflTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 60
    elseif o:isInTable(o.TeamsData[1], WomenSuperLeagueTeams) and o:isInTable(o.TeamsData[2], WomenSuperLeagueTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2216
    elseif o:isInTable(o.TeamsData[1], Ligue1Teams) and o:isInTable(o.TeamsData[2], Ligue1Teams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 16
    elseif o:isInTable(o.TeamsData[1], Ligue2Teams) and o:isInTable(o.TeamsData[2], Ligue2Teams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 17
    elseif o:isInTable(o.TeamsData[1], D1ArkemaTeams) and o:isInTable(o.TeamsData[2], D1ArkemaTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2218
    elseif o:isInTable(o.TeamsData[1], BundesligaTeams) and o:isInTable(o.TeamsData[2], BundesligaTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 19
    elseif o:isInTable(o.TeamsData[1], Bundesliga2Teams) and o:isInTable(o.TeamsData[2], Bundesliga2Teams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 20
    elseif o:isInTable(o.TeamsData[1], BRILiga1Teams) and o:isInTable(o.TeamsData[2], BRILiga1Teams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = "2235_1"
      liveLogo.id = 10
    elseif o:isInTable(o.TeamsData[1], ChampionshipLiga2Teams) and o:isInTable(o.TeamsData[2], ChampionshipLiga2Teams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2254
    elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 78
    elseif o:isInTable(o.TeamsData[1], InternationalWomansTeams) and o:isInTable(o.TeamsData[2], InternationalWomansTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2136
    elseif o:isInTable(o.TeamsData[1], SerieATeams) and o:isInTable(o.TeamsData[2], SerieATeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 31
     liveLogo.id = 7
    elseif o:isInTable(o.TeamsData[1], SerieBTeams) and o:isInTable(o.TeamsData[2], SerieBTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 32
    elseif o:isInTable(o.TeamsData[1], KoreaTeams) and o:isInTable(o.TeamsData[2], KoreaTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 83
    elseif o:isInTable(o.TeamsData[1], MalaysiaTeams) and o:isInTable(o.TeamsData[2], MalaysiaTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2237
    elseif o:isInTable(o.TeamsData[1], LigaMXTeams) and o:isInTable(o.TeamsData[2], LigaMXTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 341
    elseif o:isInTable(o.TeamsData[1], MoroccoTeams) and o:isInTable(o.TeamsData[2], MoroccoTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2250
    elseif o:isInTable(o.TeamsData[1], EredivisieTeams) and o:isInTable(o.TeamsData[2], EredivisieTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 10
    elseif o:isInTable(o.TeamsData[1], LigaPortugalTeams) and o:isInTable(o.TeamsData[2], LigaPortugalTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 308
    elseif o:isInTable(o.TeamsData[1], RestOfWolrd1Teams) and o:isInTable(o.TeamsData[2], RestOfWolrd1Teams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 76
    elseif o:isInTable(o.TeamsData[1], RestOfWolrd2Teams) and o:isInTable(o.TeamsData[2], RestOfWolrd2Teams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 77
    elseif o:isInTable(o.TeamsData[1], RoshnSaudiLeagueTeams) and o:isInTable(o.TeamsData[2], RoshnSaudiLeagueTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 350
    elseif o:isInTable(o.TeamsData[1], ScotlandTeams) and o:isInTable(o.TeamsData[2], ScotlandTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 50
    elseif o:isInTable(o.TeamsData[1], SouthAfricaTeams) and o:isInTable(o.TeamsData[2], SouthAfricaTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 347
    elseif o:isInTable(o.TeamsData[1], LaligaTeams) and o:isInTable(o.TeamsData[2], LaligaTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = "53_4"
      liveLogo.id = 2
    elseif o:isInTable(o.TeamsData[1], LaligaHypermotionTeams) and o:isInTable(o.TeamsData[2], LaligaHypermotionTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 54
    elseif o:isInTable(o.TeamsData[1], LigaFTeams) and o:isInTable(o.TeamsData[2], LigaFTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = "2222_1"
    elseif o:isInTable(o.TeamsData[1], ThailandTeams) and o:isInTable(o.TeamsData[2], ThailandTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2252
    elseif o:isInTable(o.TeamsData[1], TurkeyTeams) and o:isInTable(o.TeamsData[2], TurkeyTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 68
    elseif o:isInTable(o.TeamsData[1], UclTeams) and o:isInTable(o.TeamsData[2], UclTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = "2236_1"
    elseif o:isInTable(o.TeamsData[1], UelTeams) and o:isInTable(o.TeamsData[2], UelTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2238
    elseif o:isInTable(o.TeamsData[1], UwclTeams) and o:isInTable(o.TeamsData[2], UwclTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2240
    elseif o:isInTable(o.TeamsData[1], MLSTeams) and o:isInTable(o.TeamsData[2], MLSTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 39
    elseif o:isInTable(o.TeamsData[1], NwslTeams) and o:isInTable(o.TeamsData[2], NwslTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2221
    elseif o:isInTable(o.TeamsData[1], VietnamTeams) and o:isInTable(o.TeamsData[2], VietnamTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2260
    elseif o:isInTable(o.TeamsData[1], AFCTeams) and o:isInTable(o.TeamsData[2], AFCTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 365
    elseif o:isInTable(o.TeamsData[1], ArgentinaTeams) and o:isInTable(o.TeamsData[2], ArgentinaTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 353
    elseif o:isInTable(o.TeamsData[1], BelgiumTeams) and o:isInTable(o.TeamsData[2], BelgiumTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 4
    elseif o:isInTable(o.TeamsData[1], BrazilTeams) and o:isInTable(o.TeamsData[2], BrazilTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 7
    elseif o:isInTable(o.TeamsData[1], ClassicTeams) and o:isInTable(o.TeamsData[2], ClassicTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 1245
    elseif o:isInTable(o.TeamsData[1], Classic2Teams) and o:isInTable(o.TeamsData[2], Classic2Teams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 1246
    elseif o:isInTable(o.TeamsData[1], EgyptTeams) and o:isInTable(o.TeamsData[2], EgyptTeams) then
      o.currentdata = EAFCInfo
      o.currentdata.bnd_logo.id = 2231
    else
      o.currentdata = EAFCInfo
      liveLogo.id = 0
    end
  end
   
   o.im.Subscribe("bnd_live_logo", function()
    o.im.Publish("bnd_live_logo", liveLogo)
  end)
  
  o.currentdata.bnd_stadium = o.currentOptions.stadium
  o.currentdata.bnd_home_team_crest.id = o.TeamsData[1].assetId
  o.currentdata.bnd_away_team_crest.id = o.TeamsData[2].assetId
  o.currentdata.bnd_home_team_name = o.TeamsData[1].teamName
  o.currentdata.bnd_away_team_name = o.TeamsData[2].teamName
  o.currentdata.bnd_home_stadium_bg.id = o:GetStadiumID()
  o.gamemode = "fut"
  o.gametype = "real"
  o.flow = "online"
  
  local controllerId = o.services.gameStateService.GetPreferedControllerId()
  o.customizationOptions = o.services.settingsService.GetCustomizationOptions(controllerId)
  o:initCameraData(o.customizationOptions[6].data)
  homeTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(0, o.TeamsData[1].assetId, 0)
  awayTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(1, o.TeamsData[2].assetId, 0)
  currentHomeTeam = o.TeamsData[1].assetId
  currentAwayTeam = o.TeamsData[2].assetId
  
  weatherRandom = currentMatchWeather
  if currentMatchWeather == 1 then
    weatherRandom = math.random(2, 8)
  end
  playernibOption = currentPlayernibOption
  if currentPlayernibOption == 0 then
  end
  HudOption = currentHudOption
  if currentHudOption == 0 then
  end
  if o.TeamsData[1].assetId == 0  then
     o.currentdata.bnd_home_cup_bg.id = 100
  end
  
  
  for k,v in pairs(o.currentdata) do
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
    local stadiumMappings = {
        ["Old Trafford"] = 1, -- Manchester United 
        ["Santiago Bernabéu"] = 2, -- Real Madrid 
        ["Emirates Stadium"] = 156, -- Arsenal 
        ["San Siro"] = 5, -- Ac Milan
        ["Camp Nou"] = 6, -- FC Barcelona 
        ["Signal Iduna Park"] = 9, -- Borussia Dortmund 
        ["Stamford Bridge"] = 28, -- Chelsea 
        ["Estadio Mestalla"] = 10, -- Valencia 
        ["Anfield"] = 13, -- Liverpool 
        ["Parc des Princes"] = 14, -- PSG
        ["Stade Vélodrome"] = 29, -- Marseilleuweuwe 
        ["San Paolo Stadium"] = 32, -- Chelsea 
        ["Estadio Vicente Calderon"] = 42, -- Chelsea 
        ["Stade Louis II"] = 116, -- Chelsea 
        ["Allianz Arena"] = 137, -- Chelsea 
        ["Stadio Olimpico"] = 157, -- Chelsea 
        ["Ramon Sanchez Pizjuan"] = 192, -- Chelsea 
        ["FIFA Stadium"] = 195, -- Chelsea 
        ["Etihad Stadium"] = 246, -- Chelsea 
        ["Juventus Stadium"] = 247, -- Chelsea 


    }

    return stadiumMappings[self.currentOptions.stadium] or 0
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
    self.im.Unsubscribe("bnd_live_logo")
  for k,v in pairs(EAFCInfo) do
    self.im.Unsubscribe(k)
  end
end
return RealMatchReveal

-- Thanks : Ma'ruf Id & Laosiji --
-- And All Modder --
-- RealMatchReveal All League ( @mvnprodreal ) --odreal ) --