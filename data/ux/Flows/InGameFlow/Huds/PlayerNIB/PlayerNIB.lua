-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local PlayerNIB = {}

local OverlayParam, EventManager, TableUtil = ...
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes

local STATE_INACTIVE = "HIDE"
local STATE_UPDATE = "UPDATE"
local STATE_ACTIVE = "SHOW"

local SIDE_HOME = 0
local SIDE_AWAY = 1

local BND_STAMINA = "bnd_stamina"
local BND_PLAYER_INFO = "bnd_player_info"
local BND_ACTIVE = "bnd_active"

local bndHomeCrest = "bnd_home_team_crest"
local bndAwayCrest = "bnd_away_team_crest"

local ACT_CAMERA_CHANGE = "act_camera_change"

EAFC = {
  bnd_crest_bg = "0x39003E",
  bnd_crestBg_width = 0,
  bnd_crestBg_height = 0,
  bnd_crestBg_bottom = 0,
  bnd_crest_width = 0,
  bnd_crest_height = 0,
  bnd_crest_bottom = 0,
  bnd_bg = "0xFFFFFF",
  bnd_bg_bottom = 0,
  bnd_stamina_inner_bg = "0x00b2c3",
  bnd_stamina_outside_bg = "0x000000",
  bnd_stamina_width = 190,
  bnd_stamina_short_width = 0,
  bnd_stamina_bottom = 50.5,
  bnd_player_number = "",
  bnd_player_name = "",
  bnd_player_info_left = 0,
  bnd_player_number_color = "0xffffff",
  bnd_player_name_color = "0x99B903",
  bnd_home_team_crest = { name = "", id = 0 },
  bnd_away_team_crest = { name = "", id = 0 }
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
  o.currentLeague = nil
  o.TeamsData = o.services.matchInfo.GetMatchTeams()
  

  if currentCupData.cupIndex > 0 then
    if currentCupData.cupIndex == 1 then
      o.currentLeague = EAFC
    elseif currentCupData.cupIndex == 2 then
      o.currentLeague = EAFC
    end
    
  else
    if o:isInTable(o.TeamsData[1], PremierLeagueTeams) and o:isInTable(o.TeamsData[2], PremierLeagueTeams) then
      o.currentLeague = EAFC

    elseif o:isInTable(o.TeamsData[1], Ligue2Teams) and o:isInTable(o.TeamsData[2], Ligue2Teams) then
      o.currentLeague = EAFC
      o.currentLeague.bnd_crest_bg = "0x00FFCF"

    elseif o:isInTable(o.TeamsData[1], LaligaHypermotionTeams) and o:isInTable(o.TeamsData[2], LaligaHypermotionTeams) then
      o.currentLeague = EAFC
      o.currentLeague.bnd_stamina_inner_bg = "0x04D4D4"

    elseif o:isInTable(o.TeamsData[1], EgyptTeams) and o:isInTable(o.TeamsData[2], EgyptTeams) then
      o.currentLeague = EAFC
    else
      o.currentLeague = EAFC
    end
  end





  o.im.Subscribe(BND_ACTIVE, function()
    o:_publishActivity()
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
  
  o.TeamsData = o.services.matchInfo.GetMatchTeams()
  
  o.isUserHome = o.services.gameSetupService.IsHostTeam()
  
  homeCrest = {
    name = "$Crest",
    id = o.TeamsData[1].assetId
  }
  awaycrest = {
    name = "$Crest",
    id = o.TeamsData[2].assetId
  }
  
  o.im.Subscribe(bndHomeCrest, function()
    o.im.Publish(bndHomeCrest, homeCrest)
  end)
  o.im.Subscribe(bndAwayCrest, function()
    o.im.Publish(bndAwayCrest, awaycrest)
  end)
  
  o:setState(STATE_INACTIVE)
  
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end
  )

  o.im.RegisterAction("act_camera_change", function(actionName)
    o:_updateCamera()
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

function PlayerNIB:_publishPlayerInfo()
  if self.playerInfo == nil then
    return
  end
  self.im.Publish(BND_PLAYER_INFO, self.playerInfo)
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
  self.im.Unsubscribe(BND_PLAYER_INFO)
  self.im.Unsubscribe(BND_STAMINA)
  
  self.im.Unsubscribe(bndHomeCrest)
  self.im.Unsubscribe(bndAwayCrest)
  
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  
end

return PlayerNIB