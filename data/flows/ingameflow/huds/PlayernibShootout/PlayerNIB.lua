
local PlayerNIB = {}
local OverlayParam, EventManager, TableUtil = ...
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local STATE_INACTIVE = "HIDE"
local STATE_UPDATE = "UPDATE"
local STATE_ACTIVE = "SHOW"
local SIDE_HOME = 0
local SIDE_AWAY = 1
local BND_ALPHA = "bnd_alpha"
local BND_STAMINA = "bnd_stamina"
local BND_PLAYER_INFO = "bnd_player_info"
local BND_ACTIVE = "bnd_active"
local bndHomeCrest = "bnd_home_team_crest"
local bndAwayCrest = "bnd_away_team_crest"
local bndRainVisible = "bnd_rain_visible"
local bndSnowVisible = "bnd_snow_visible"
local bndWeather = "bnd_weather_type"
local ACT_CAMERA_CHANGE = "act_camera_change"

local leagueIDs = {
  England = 13,
  Spain = 53,
  SpainB = 54,
  LigaF = 2222,
  Germany = 19,
  GermanyB = 20,
  GermanyC = 2076,
  France = 16,
  FranceB = 17,
  D1Arkema = 2218,
  Italy = 31,
  ItalyB = 32,
  Indonesia = 2235,
  WorldCup = 78,
  InternationalWomans = 2136,
  SaudiArabia = 350,
  UnitedStates = 39,
  Nwsl = 2221,
  WomensSuperLeague = 2216,
  LeagueOneEfl = 60,
  LeagueTwoEfl = 61,
  ChampionshipEfl = 14,
  Uefa = 2236,
  UefaEropa = 2238,
  UefaWomensLeague = 2240,
  Scotland = 50,
  Portugal = 308,
  Netherlands = 10,
  Belgium = 4,
  Argentina = 353,
  Brazil = 7,
  Classic = 1245,
  Classic2 = 1246,
  Denmark = 1,
  Equador = 2018,
  Egypt = 2231,
  Malaysia = 2237,
  Mexico = 341,
  Rusia = 67,
  SouthAfrica = 347,
  Switzerland = 189,
  Turkey = 68
}

EAFC = {
  bnd_crestBg_left = -357,
  bnd_crestBg_bottom = 0,
  bnd_crest_bottom = 26,
  bnd_crest_height = 30,
  bnd_crest_width = 30,
  bnd_crestBg_width = 0,
  bnd_crestBg_height = 0,
  bnd_crestBg_alpha = 0,
  bnd_crest_bg = "0xffffff",
  bnd_away_crest_bg = "0xffffff",
  bnd_bg = "0x273700",
  bnd_stamina_inner_bg = "0x00b2c3",
  bnd_stamina_outside_bg = "0x555555",
  bnd_stamina_width = 213,
  bnd_stamina_short_width = 0,
  bnd_stamina_bottom = 54,
  bnd_player_number = "",
  bnd_player_name = "",
  bnd_player_info_left = -223,
  bnd_player_number_color = "0xF4C900",
  bnd_player_name_color = "0xffffff",
  bnd_home_team_crest = {
      name = "$Crest64x64",
      id = 0
  },
  bnd_away_team_crest = {
      name = "$Crest64x64",
      id = 0
  }
}
EnglandLeague = {
  bnd_crestBg_left = -347,
  bnd_crestBg_bottom = 15,
  bnd_crest_bottom = 16,
  bnd_crest_height = 30,
  bnd_crest_width = 30,
  bnd_crestBg_width = 33,
  bnd_crestBg_height = 33,
  bnd_crestBg_alpha = 1,
  bnd_crest_bg = "0xffffff",
  bnd_away_crest_bg = "0xffffff",
  bnd_bg = "0x37003B",
  bnd_stamina_inner_bg = "0x090109",
  bnd_stamina_outside_bg = "0x4DE8EF",
  bnd_stamina_width = 213,
  bnd_stamina_short_width = 0,
  bnd_stamina_bottom = 45,
  bnd_player_number = "",
  bnd_player_name = "",
  bnd_player_info_left = -223,
  bnd_player_number_color = "0xffffff",
  bnd_player_name_color = "0xffffff",
  bnd_home_team_crest = {
      name = "$Crest",
      id = 0
  },
  bnd_away_team_crest = {
      name = "$Crest",
      id = 0
  }
}

function PlayerNIB:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
  GameStateService = o.api("GameStateService"),
    matchInfo = o.api("MatchInfoService"),
    userPlate = o.api("UserPlateService"),
    settingsService = o.api("SettingsService"),
    gameSetupService = o.api("GameSetupService"),
    EventManagerService = o.api("EventManagerService"),
    TeamService = o.api("TeamService")
  }
  o.side = o.data and o.data.side or SIDE_HOME
  o.cameraIndex = cameraIndex
  o.currentLeague = {}
  o.TeamsData = o.services.matchInfo.GetMatchTeams()
  
  local EnglandTeams = o.services.TeamService.GetTeams(leagueIDs.England, 0, 0, true)
  local SpainTeams = o.services.TeamService.GetTeams(leagueIDs.Spain, 0, 0, true)
  local SpainBTeams = o.services.TeamService.GetTeams(leagueIDs.SpainB, 0, 0, true)
  local LigaFTeams = o.services.TeamService.GetTeams(leagueIDs.LigaF, 0, 0, true)
  local GermanyTeams = o.services.TeamService.GetTeams(leagueIDs.Germany, 0, 0, true)
  local GermanyBTeams = o.services.TeamService.GetTeams(leagueIDs.GermanyB, 0, 0, true)
  local GermanyCTeams = o.services.TeamService.GetTeams(leagueIDs.GermanyC, 0, 0, true)
  local FranceTeams = o.services.TeamService.GetTeams(leagueIDs.France, 0, 0, true)
  local FranceBTeams = o.services.TeamService.GetTeams(leagueIDs.FranceB, 0, 0, true)
  local D1ArkemaTeams = o.services.TeamService.GetTeams(leagueIDs.D1Arkema, 0, 0, true)
  local ItalyTeams = o.services.TeamService.GetTeams(leagueIDs.Italy, 0, 0, true)
  local ItalyBTeams = o.services.TeamService.GetTeams(leagueIDs.ItalyB, 0, 0, true)
  local IndonesiaTeams = o.services.TeamService.GetTeams(leagueIDs.Indonesia, 0, 0, true)
  local WorldCupTeams = o.services.TeamService.GetTeams(leagueIDs.WorldCup, 0, 0, true)
  local InternationalWomansTeams = o.services.TeamService.GetTeams(leagueIDs.InternationalWomans, 0, 0, true)
  local SaudiArabiaTeams = o.services.TeamService.GetTeams(leagueIDs.SaudiArabia, 0, 0, true)
  local UnitedStatesTeams = o.services.TeamService.GetTeams(leagueIDs.UnitedStates, 0, 0, true)
  local NwslTeams = o.services.TeamService.GetTeams(leagueIDs.Nwsl, 0, 0, true)
  local WomensSuperLeagueTeams = o.services.TeamService.GetTeams(leagueIDs.WomensSuperLeague, 0, 0, true)
  local LeagueOneEflTeams = o.services.TeamService.GetTeams(leagueIDs.LeagueOneEfl, 0, 0, true)
  local LeagueTwoEflTeams = o.services.TeamService.GetTeams(leagueIDs.LeagueTwoEfl, 0, 0, true)
  local ChampionshipEflTeams = o.services.TeamService.GetTeams(leagueIDs.ChampionshipEfl, 0, 0, true)
  local UefaTeams = o.services.TeamService.GetTeams(leagueIDs.Uefa, 0, 0, true)
  local UefaEropaTeams = o.services.TeamService.GetTeams(leagueIDs.UefaEropa, 0, 0, true)
  local UefaWomensTeams = o.services.TeamService.GetTeams(leagueIDs.UefaWomensLeague, 0, 0, true)
  local ScotlandTeams = o.services.TeamService.GetTeams(leagueIDs.Scotland, 0, 0, true)
  local PortugalTeams = o.services.TeamService.GetTeams(leagueIDs.Portugal, 0, 0, true)
  local NetherlandsTeams = o.services.TeamService.GetTeams(leagueIDs.Netherlands, 0, 0, true)
  local BelgiumTeams = o.services.TeamService.GetTeams(leagueIDs.Belgium, 0, 0, true)
  local ArgentinaTeams = o.services.TeamService.GetTeams(leagueIDs.Argentina, 0, 0, true)
  local BrazilTeams = o.services.TeamService.GetTeams(leagueIDs.Brazil, 0, 0, true)
  local ClassicTeams = o.services.TeamService.GetTeams(leagueIDs.Classic, 0, 0, true)
  local Classic2Teams = o.services.TeamService.GetTeams(leagueIDs.Classic2, 0, 0, true)
  local DenmarkTeams = o.services.TeamService.GetTeams(leagueIDs.Denmark, 0, 0, true)
  local EquadorTeams = o.services.TeamService.GetTeams(leagueIDs.Equador, 0, 0, true)
  local EgyptTeams = o.services.TeamService.GetTeams(leagueIDs.Egypt, 0, 0, true)
  local MalaysiaTeams = o.services.TeamService.GetTeams(leagueIDs.Malaysia, 0, 0, true)
  local MexicoTeams = o.services.TeamService.GetTeams(leagueIDs.Mexico, 0, 0, true)
  local RusiaTeams = o.services.TeamService.GetTeams(leagueIDs.Rusia, 0, 0, true)
  local SouthAfricaTeams = o.services.TeamService.GetTeams(leagueIDs.SouthAfrica, 0, 0, true)
  local SwitzerlandTeams = o.services.TeamService.GetTeams(leagueIDs.Switzerland, 0, 0, true)
  local TurkeyTeams = o.services.TeamService.GetTeams(leagueIDs.Turkey, 0, 0, true)
  
  if currentCupData.cupIndex > 0 then
   if currentCupData.cupIndex == 1 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 2 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 3 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 4 then
      o.currentLeague = EAFC 
   elseif currentCupData.cupIndex == 5 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 6 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 7 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 8 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 9 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 10 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 11 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 12 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 13 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 14 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 15 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 16 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 17 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 18 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 19 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 20 then
      o.currentLeague = EAFC 
   elseif currentCupData.cupIndex == 21 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 22 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 23 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 24 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 25 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 26 then
      o.currentLeague = EAFC 
   elseif currentCupData.cupIndex == 27 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 28 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 29 then
      o.currentLeague = EAFC
   elseif currentCupData.cupIndex == 30 then
      o.currentLeague = EAFC
      end
  else
  if o:isInTable(o.TeamsData[1], EnglandTeams) and o:isInTable(o.TeamsData[2], EnglandTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], LigaFTeams) and o:isInTable(o.TeamsData[2], LigaFTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], Germany2Teams) and o:isInTable(o.TeamsData[2], Germany2Teams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], Germany3Teams) and o:isInTable(o.TeamsData[2], Germany3Teams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], FranceBTeams) and o:isInTable(o.TeamsData[2], FranceBTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], D1ArkemaTeams) and o:isInTable(o.TeamsData[2], D1ArkemaTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], ItalyBTeams) and o:isInTable(o.TeamsData[2], ItalyBTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], IndonesiaTeams) and o:isInTable(o.TeamsData[2], IndonesiaTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], WorldCupTeams) and o:isInTable(o.TeamsData[2], WorldCupTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], InternationalWomansTeams) and o:isInTable(o.TeamsData[2], InternationalWomansTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], SaudiArabiaTeams) and o:isInTable(o.TeamsData[2], SaudiArabiaTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], UnitedStatesTeams) and o:isInTable(o.TeamsData[2], UnitedStatesTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], NwslTeams) and o:isInTable(o.TeamsData[2], NwslTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], WomensSuperLeagueTeams) and o:isInTable(o.TeamsData[2], WomensSuperLeagueTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], LeagueOneEflTeams) and o:isInTable(o.TeamsData[2], LeagueOneEflTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], LeagueTwoEflTeams) and o:isInTable(o.TeamsData[2], LeagueTwoEflTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], ChampionshipEflTeams) and o:isInTable(o.TeamsData[2], ChampionshipEflTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], UefaTeams) and o:isInTable(o.TeamsData[2], UefaTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], UefaEropaTeams) and o:isInTable(o.TeamsData[2], UefaEropaTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], UefaWomensTeams) and o:isInTable(o.TeamsData[2], UefaWomensTeams) then
      o.currentLeague = EAFC
   elseif o:isInTable(o.TeamsData[1], ScotlandTeams) and o:isInTable(o.TeamsData[2], ScotlandTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], PortugalTeams) and o:isInTable(o.TeamsData[2], PortugalTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], NetherlandsTeams) and o:isInTable(o.TeamsData[2], NetherlandsTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], BelgiumTeams) and o:isInTable(o.TeamsData[2], BelgiumTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], ArgentinaTeams) and o:isInTable(o.TeamsData[2], ArgentinaTeams) then
      o.currentLeague = EAFC
   elseif o:isInTable(o.TeamsData[1], BrazilTeams) and o:isInTable(o.TeamsData[2], BrazilTeams) then
      o.currentLeague = EAFC
   elseif o:isInTable(o.TeamsData[1], ClassicTeams) and o:isInTable(o.TeamsData[2], ClassicTeams) then
      o.currentLeague = EAFC
   elseif o:isInTable(o.TeamsData[1], Classic2Teams) and o:isInTable(o.TeamsData[2], Classic2Teams) then
      o.currentLeague = EAFC
   elseif o:isInTable(o.TeamsData[1], DenmarkTeams) and o:isInTable(o.TeamsData[2], DenmarkTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], EquadorTeams) and o:isInTable(o.TeamsData[2], EquadorTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], EgyptTeams) and o:isInTable(o.TeamsData[2], EgyptTeams) then
      o.currentLeague = EAFC
   elseif o:isInTable(o.TeamsData[1], MalaysiaTeams) and o:isInTable(o.TeamsData[2], MalaysiaTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], MexicoTeams) and o:isInTable(o.TeamsData[2], MexicoTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], RusiaTeams) and o:isInTable(o.TeamsData[2], RusiaTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], SouthAfricaTeams) and o:isInTable(o.TeamsData[2], SouthAfricaTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], SwitzerlandTeams) and o:isInTable(o.TeamsData[2], SwitzerlandTeams) then
      o.currentLeague = EAFC
    elseif o:isInTable(o.TeamsData[1], TurkeyTeams) and o:isInTable(o.TeamsData[2], TurkeyTeams) then
      o.currentLeague = EAFC

  else 
    o.currentLeague = EAFC
  end
  end

  o.im.Subscribe(BND_ACTIVE, function()
    o:_publishActivity()
  end
  )
o.im.Subscribe("bnd_statsPL", function()
    o:_publishPlayerInfo()
  end)
o.im.Subscribe("bnd_style_nib", function()
  o:_publishPlayerInfo()
end)
  o.im.Subscribe(BND_ALPHA, function()
    o:_publishAlpha()
  end
  )
  o.im.Subscribe(BND_PLAYER_INFO, function()
    o:_publishPlayerInfo()
  end
  )
  o.im.Subscribe(BND_STAMINA, function()
    o:_publishStamina()
  end
  )
  
  
  
  o.currentLeague.bnd_home_team_crest.id = o.TeamsData[1].assetId
  o.currentLeague.bnd_away_team_crest.id = o.TeamsData[2].assetId

  for k,v in pairs(o.currentLeague) do
    o.im.Subscribe(k, function()
      if k == "bnd_stamina_width" or k == "bnd_stamina_short_width" then
        o:_publishStamina()
      elseif k == "bnd_player_number" or k == "bnd_player_name" then
        o:_publishPlayerInfo()
      else
        o.im.Publish(k, v)
      end
    end)
  end

  weatherType = {
     name = "$Weathegr",
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
       weatherType.id = 1
      o.im.Publish(bndWeather, weatherType)
    elseif random == 4 then
       weatherType.id = 2
    o.im.Publish(bndWeather, weatherType)      
    elseif random == 5 or random == 6 then
       weatherType.id = 4
      o.im.Publish(bndWeather, weatherType)     
    elseif random == 7 or random == 8 then
       weatherType.id = 3
      o.im.Publish(bndWeather, weatherType)
    else
       weatherType.id = 0
       o.im.Publish(bndWeather, weatherType)
    end
    o.im.Publish(bndWeather, weatherType)
  end
  )

  o.im.RegisterAction("act_camera_change", function(actionName)
    o:_updateCamera()
  end)
  
  o.isUserHome = o.services.gameSetupService.IsHostTeam()
  
  o:setState(STATE_INACTIVE)
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end
  )
  
  return o
end

function PlayerNIB:setState(state)
  self.state = state or STATE_INACTIVE
  self:_publishActivity()
end

function PlayerNIB:getPlayerInfo(params)
  local rating = nil
  for i = #params, 1, -1 do
    local v = tonumber(params[i])
    if v and v >= 40 and v <= 99 then
      rating = v
      break
    end
  end

  return {
    name = params[9] or "",
    number = params[12] or "",
    rating = rating or 70
  }
end

function PlayerNIB:getStamina(params)
  return {
    stamina = tonumber(params[1]),
    shortStamina = tonumber(params[2])
  }
end

function PlayerNIB:getStatsAssetByRating(rating)
  if rating >= 85 then
    return { name = "$PlayerNib1", id = 0 }
  elseif rating >= 80 then
    return { name = "$PlayerNib2", id = 0 }
  elseif rating >= 75 then
    return { name = "$PlayerNib3", id = 0 }
  elseif rating >= 70 then
    return { name = "$PlayerNib4", id = 0 }
  elseif rating >= 65 then
    return { name = "$PlayerNib5", id = 0 }
  else
    return { name = "$PlayerNib6", id = 0 }
  end
end

function PlayerNIB:getStatsIconByRating(rating)
  if rating >= 85 then
    return { name = "$PlayerNibIcon1", id = 0 }
  elseif rating >= 80 then
    return { name = "$PlayerNibIcon2", id = 0 }
  elseif rating >= 75 then
    return { name = "$PlayerNibIcon3", id = 0 }
  elseif rating >= 70 then
    return { name = "$PlayerNibIcon4", id = 0 }
  else
    return { name = "$PlayerNibIcon5", id = 0 }
  end
end

function PlayerNIB:_onPlayerNIBUpdate(subtype, hideshow, subtypestr, msg)
  self:setState(hideshow)
  if self.state ~= STATE_INACTIVE and msg ~= nil and msg ~= "" then
    local params = OverlayParam.split(msg, "|")
    if table.getn(params) == 1 then
      if tonumber(params[1]) ~= nil then
        local alpha = tonumber(params[1]) / 100
        self:_publishAlpha(alpha)
      end
    elseif table.getn(params) == 2 then
    elseif table.getn(params) == 3 then
    elseif table.getn(params) == 8 then
      self.stamina = self:getStamina(params)
      self:_publishStamina()
    elseif table.getn(params) == 10 then
      self.stamina = self:getStamina(params)
      self:_publishStamina()
    elseif table.getn(params) == 16 then
      self.playerInfo = self:getPlayerInfo(params)
      self.stamina = self:getStamina(params)
      self:_publishPlayerInfo()
      self:_publishStamina()
    elseif table.getn(params) == 17 then
      self.playerInfo = self:getPlayerInfo(params)
      self.stamina = self:getStamina(params)
      self:_publishPlayerInfo()
      self:_publishStamina()
    end
  end
end

function PlayerNIB:_publishActivity()
  self.im.Publish(BND_ACTIVE, self.state ~= STATE_INACTIVE)
end

function PlayerNIB:_publishAlpha(alpha)
  self.im.Publish(BND_ALPHA, alpha or 1)
end

function PlayerNIB:_publishPlayerInfo()
  if self.playerInfo == nil then
    return
  end

  self.im.Publish(BND_PLAYER_INFO, self.playerInfo)
  self.im.Publish("bnd_player_number", tostring(self.playerInfo.number))
  self.im.Publish("bnd_player_name", self.playerInfo.name)

  local rating = self.playerInfo.rating or 70
  print("[NIB DEBUG] Player:", self.playerInfo.name, 
        "Number:", self.playerInfo.number, 
        "Rating:", rating)
  local statsAsset = self:getStatsAssetByRating(rating)
  self.im.Publish("bnd_statsPL", statsAsset)
  local styleIcon = self:getStatsIconByRating(rating)
  self.im.Publish("bnd_style_nib", styleIcon)
end

function PlayerNIB:_publishStamina()
  if self.stamina == nil then
    return
  end
  self.im.Publish(BND_STAMINA, self.stamina)
  self.im.Publish("bnd_stamina_width", self.currentLeague.bnd_stamina_width)
  local r0 = self.stamina["shortStamina"] / self.stamina["stamina"]
  local r1 = self.currentLeague.bnd_stamina_width * r0
  self.im.Publish("bnd_stamina_short_width", r1)
end


function PlayerNIB:_handleEvent(eventType, data)
  if eventType == EVENT_TYPES.OverlayTypeNIBBL and self.side == SIDE_HOME or eventType == EVENT_TYPES.OverlayTypeNIBBR and self.side == SIDE_AWAY then
    self:_onPlayerNIBUpdate(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function PlayerNIB:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function PlayerNIB:getTeamHomeColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.homeColor
      result[2] = v.homeFontColor
    end
  end
  return result
end

function PlayerNIB:getTeamAwayColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.awayColor
      result[2] = v.awayFontColor
    end
  end
  return result
end

function PlayerNIB:_updateCamera()
  if self.cameraIndex >= 7 then
    self.cameraIndex = 0
  else
    self.cameraIndex = self.cameraIndex + 1
  end
  self.services.settingsService.SaveCameraValue(self.cameraIndex)
end

function PlayerNIB:finalize()
  self.im.Unsubscribe("bnd_statsPL")
  self.im.Unsubscribe("bnd_style_nib")
  self.im.Unsubscribe(BND_ACTIVE)
  self.im.Unsubscribe(BND_ALPHA)
  self.im.Unsubscribe(BND_PLAYER_INFO)
  self.im.Unsubscribe(BND_STAMINA)
  self.im.Unsubscribe(bndHomeCrest)
  self.im.Unsubscribe(bndAwayCrest)
  self.im.Unsubscribe(bndRainVisible)
  self.im.Unsubscribe(bndSnowVisible)
  self.im.Unsubscribe(bndWeather)
  for k,v in pairs(EAFC) do
    self.im.Unsubscribe(k)
  end
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
end

return PlayerNIB
