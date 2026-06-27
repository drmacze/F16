local SideSelect = {}
local eventmanager, PregameManager, CommonNavVars, TableUtil = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes
local ICON_HOME = "$IconHome"
local ICON_AWAY = "$IconAway"
local ICON_HIDE = "$"
local actToggleHome = "act_toggle_home"
local actToggleAway = "act_toggle_away"
local bndSideHomeIcon = "bnd_side_home_icon"
local bndSideAwayIcon = "bnd_side_away_icon"
function SideSelect:new(init)
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
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  o:setUserSideAsHome()
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
function SideSelect:publishSideHomeIcon()
  self.im.Publish(bndSideHomeIcon, self.homeSideIcon)
end
function SideSelect:publishSideAwayIcon()
  self.im.Publish(bndSideAwayIcon, self.awaySideIcon)
end
function SideSelect:swapSides()
  if self.isUserSideHome then
    self:setUserSideAsAway()
  else
    self:setUserSideAsHome()
  end
  self:publishSideHomeIcon()
  self:publishSideAwayIcon()
end
function SideSelect:setUserSideAsHome()
  self.services.gameState.SetUserSideAsHome()
  self.homeSideIcon = ICON_HOME
  self.awaySideIcon = ICON_HIDE
  self.isUserSideHome = true
end
function SideSelect:setUserSideAsAway()
  self.services.gameState.SetUserSideAsAway()
  self.homeSideIcon = ICON_HIDE
  self.awaySideIcon = ICON_AWAY
  self.isUserSideHome = false
end
function SideSelect:finalize()
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end
return SideSelect