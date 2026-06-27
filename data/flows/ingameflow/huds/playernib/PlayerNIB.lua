--- By Laosiji Edit Rober FL---

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


EAFC = {
  bnd_crest_bg = "0x151515",
  bnd_away_crest_bg = "0x151515",
  bnd_crestBg_width = 0,
  bnd_crestBg_height = 0,
  bnd_crestBg_left = -359,
  bnd_crestBg_bottom = 24,
  bnd_crest_width = 28,
  bnd_crest_height = 28,
  bnd_crest_bottom = 26,
  bnd_bg = "0xFFFFFF",
  bnd_bg_bottom = -20028.5,
  bnd_stamina_inner_bg = "0x00C9D9",
  bnd_stamina_outside_bg = "0x000000",
  bnd_stamina_width = 208,
  bnd_stamina_short_width = 0,
  bnd_stamina_bottom = 54,
  bnd_player_number = "",
  bnd_player_name = "",
  bnd_player_info_left = -223,
  bnd_player_number_color = "0xffffff",
  bnd_player_name_color = "0x8FA649",
  bnd_home_team_crest = {
      name = "$Crest64x64",
      id = 0
  },
  bnd_away_team_crest = {
      name = "$Crest64x64",
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
  o.currentEvent = nil
  o.TeamsData = o.services.matchInfo.GetMatchTeams()
  
  if currentCupData.cupIndex > 0 then
   if currentCupData.cupIndex == 1 then
      o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 2 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 3 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 4 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 5 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 6 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 7 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 8 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 9 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 10 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 11 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 12 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 13 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 14 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 15 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 16 then
    o.currentEvent = EAFC
  elseif currentCupData.cupIndex == 17 then
    o.currentEvent = EAFC
    else
    o.currentEvent = EAFC
  end
      
  elseif currentTourData and currentTourData.tourIndex and currentTourData.tourIndex > 0 then
  if currentTourData.tourIndex == 1 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 2 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 3 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 4 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 5 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 6 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 7 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 8 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 9 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 10 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 11 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 12 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 13 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 14 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 15 then
    o.currentEvent = EAFC
  elseif currentTourData.tourIndex == 16 then
    o.currentEvent = EAFC
      else
    o.currentEvent = EAFC
   end
      
  else
  if o:isInTable(o.TeamsData[1], EnglandTeams) and o:isInTable(o.TeamsData[2], EnglandTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], Germany2Teams) and o:isInTable(o.TeamsData[2], Germany2Teams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
    o.currentEvent = EAFC  
  elseif o:isInTable(o.TeamsData[1], BrazilTeams) and o:isInTable(o.TeamsData[2], BrazilTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], BrazilBTeams) and o:isInTable(o.TeamsData[2], BrazilBTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], ArgentinaTeams) and o:isInTable(o.TeamsData[2], ArgentinaTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], MexicoTeams) and o:isInTable(o.TeamsData[2], MexicoTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], IndonesiaTeams) and o:isInTable(o.TeamsData[2], IndonesiaTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], SaudiArabiaTeams) and o:isInTable(o.TeamsData[2], SaudiArabiaTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], WomensSuperLeagueTeams) and o:isInTable(o.TeamsData[2], WomensSuperLeagueTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], UnitedStatesTeams) and o:isInTable(o.TeamsData[2], UnitedStatesTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], RussiaTeams) and o:isInTable(o.TeamsData[2], RussiaTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], LeaguePariTeams) and o:isInTable(o.TeamsData[2], LeaguePariTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], UkraineTeams) and o:isInTable(o.TeamsData[2], UkraineTeams) then
    o.currentEvent = EAFC
  elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
    o.currentEvent = EAFC
  else  
    o.currentEvent = EAFC
  end
  end

  o.im.Subscribe(BND_ACTIVE, function()
    o:_publishActivity()
  end
  )
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
  
  o.currentEvent.bnd_home_team_crest.id = o.TeamsData[1].assetId
  o.currentEvent.bnd_away_team_crest.id = o.TeamsData[2].assetId

  for k,v in pairs(o.currentEvent) do
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
  end)
  o.im.Subscribe(bndSnowVisible, function()
    if random == 8 then
      o.im.Publish(bndSnowVisible, true)
    else 
      o.im.Publish(bndSnowVisible, false)
    end
  end)
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
  end)

  o.im.RegisterAction("act_camera_change", function(actionName)
    o:_updateCamera()
  end)
  
  o.isUserHome = o.services.gameSetupService.IsHostTeam()
  
  o:setState(STATE_INACTIVE)
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end)
  
  return o
end

function PlayerNIB:setState(state)
  self.state = state or STATE_INACTIVE
  self:_publishActivity()
end

function PlayerNIB:getPlayerInfo(params)
  return {
    name = params[9],
    number = params[12]
  }
end

function PlayerNIB:getStamina(params)
  return {
    stamina = tonumber(params[1]),
    shortStamina = tonumber(params[2])
  }
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
 self.im.Publish("bnd_player_number", tostring(self.playerInfo["number"]))
 self.im.Publish("bnd_player_name", self.playerInfo["name"])
end

function PlayerNIB:_publishStamina()
  if self.stamina == nil then
    return
  end
  self.im.Publish(BND_STAMINA, self.stamina)
  self.im.Publish("bnd_stamina_width", self.currentEvent.bnd_stamina_width)
  local r0 = self.stamina["shortStamina"] / self.stamina["stamina"]
  local r1 = self.currentEvent.bnd_stamina_width * r0
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