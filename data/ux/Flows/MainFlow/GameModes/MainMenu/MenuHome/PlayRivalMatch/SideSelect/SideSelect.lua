-- MOD BY LAOSIJI --
local SelectSide = {}

local eventmanager, PregameManager, CommonNavVars, TableUtil = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes

local LABEL_USER = "PLAYER"
local LABEL_CPU = "COM"

local ICON_USER = "$IconUser"
local ICON_CPU = "$IconCPU"

local BND_LOGO_TIM_HOME = "bnd_logo_tim_home"
local BND_LOGO_TIM_AWAY = "bnd_logo_tim_away"

local actToggleHome = "act_toggle_home"
local actToggleAway = "act_toggle_away"

local bndSideHomeLabel = "bnd_side_home_label"
local bndSideAwayLabel = "bnd_side_away_label"
local bndSideHomeIcon = "bnd_side_home_icon"
local bndSideAwayIcon = "bnd_side_away_icon"

function SelectSide:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  o.services = {
    matchSetup = o.api("MatchSetupService"),
    gameSetup = o.api("GameSetupService"),
    gameState = o.api("GameStateService"),
    preGame = o.api("PregameService"),
    EventManagerService = o.api("EventManagerService"),
    MatchInfoService = o.api("MatchInfoService")
  }
  
  
  --o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
   -- o:handleEvent(...)
  --end)
  
  o:setUserSideAsHome()
  
  --o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  LOGO_HOME = {
    name = "$Crest",
    id = currentMatch.HomeTeamID
  }
  LOGO_AWAY = {
    name = "$Crest",
    id = currentMatch.AwayTeamID
  }

  o.im.Subscribe(BND_LOGO_TIM_HOME, function()
    o.im.Publish(BND_LOGO_TIM_HOME, LOGO_HOME)
  end)
  o.im.Subscribe(BND_LOGO_TIM_AWAY, function()
    o.im.Publish(BND_LOGO_TIM_AWAY, LOGO_AWAY)
  end)
  
  o.im.Subscribe(bndSideHomeLabel, function()
    o:publishSideHomeLabel()
  end)
  o.im.Subscribe(bndSideAwayLabel, function()
    o:publishSideAwayLabel()
  end)
  
  o.im.Subscribe(bndSideHomeIcon, function()
    o:publishSideHomeIcon()
  end)
  o.im.Subscribe(bndSideAwayIcon, function()
    o:publishSideAwayIcon()
  end)
  
  o.im.RegisterAction(actToggleHome, function(actionName)
    o:swapSides()
  end)
  o.im.RegisterAction(actToggleAway, function(actionName)
    o:swapSides()
  end)
  
  return o
end

function SelectSide:getTeamCrest(isAway)
  return {
    name = "$Crest",
    id = self:getTeam(isAway).assetId
  }
end

function SelectSide:publishSideHomeLabel()
  self.im.Publish(bndSideHomeLabel, self.homeSideLabel)
end
function SelectSide:publishSideHomeIcon()
  self.im.Publish(bndSideHomeIcon, self.homeSideIcon)
end
function SelectSide:publishSideAwayLabel()
  self.im.Publish(bndSideAwayLabel, self.awaySideLabel)
end
function SelectSide:publishSideAwayIcon()
  self.im.Publish(bndSideAwayIcon, self.awaySideIcon)
end

function SelectSide:swapSides()
  if currentMatch.Side == 0 then
    self:setUserSideAsAway()
  else
    self:setUserSideAsHome()
  end
  self:publishSideHomeLabel()
  self:publishSideHomeIcon()
  self:publishSideAwayLabel()
  self:publishSideAwayIcon()
end

function SelectSide:setUserSideAsHome()
  --self.services.gameState.SetUserSideAsHome()
  self.homeSideLabel = LABEL_USER
  self.homeSideIcon = ICON_USER
  self.awaySideLabel = LABEL_CPU
  self.awaySideIcon = ICON_CPU
  currentMatch.Side = 0
end

function SelectSide:setUserSideAsAway()
 -- self.services.gameState.SetUserSideAsAway()
  self.homeSideLabel = LABEL_CPU
  self.homeSideIcon = ICON_CPU
  self.awaySideLabel = LABEL_USER
  self.awaySideIcon = ICON_USER
  currentMatch.Side = 1
end


function SelectSide:finalize()
--  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end

return SelectSide