local OverlayParam, EventManager, TableUtil = ...
local BND_ACTIVE = "bnd_active"
local BND_SCORE = "bnd_score"
local BND_HOME_TEAM = "bnd_home_team"
local BND_AWAY_TEAM = "bnd_away_team"
local BND_SIDE = "bnd_side"
local BND_HOME_HISTORY = "bnd_home_history"
local BND_AWAY_HISTORY = "bnd_away_history"
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local STATE_INACTIVE = "HIDE"
local STATE_ACTIVE = "SHOW"
local SIDE_HOME = 0
local SIDE_AWAT = 1
local Shootout = {}
function Shootout:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    MatchInfoService = o.api("MatchInfoService"),
    EventManagerService = o.api("EventManagerService")
  }
  o.teamData = o.services.MatchInfoService.GetMatchTeams()
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end)
  o.im.Subscribe(BND_ACTIVE, function()
    o:_publishActivity()
  end)
  o.im.Subscribe(BND_SCORE, function()
    o:_publishScore()
  end)
  o.im.Subscribe(BND_HOME_TEAM, function()
    o:_publishTeam()
  end)
  o.im.Subscribe(BND_AWAY_TEAM, function()
    o:_publishTeam(true)
  end)
  o.im.Subscribe(BND_SIDE, function()
    o:_publishSide()
  end)
  o.im.Subscribe(BND_HOME_HISTORY, function()
    o:_publishHistory()
  end)
  o.im.Subscribe(BND_AWAY_HISTORY, function()
    o:_publishHistory(true)
  end)
  o:setState(STATE_INACTIVE)
  return o
end
function Shootout:setState(state)
  self.state = state or STATE_INACTIVE
  self:_publishActivity()
end
function Shootout:_onShootoutUpdate(data)
  assert(data, "Overlay data is nil.")
  assert(data.hideshow, "Overlay data contains no \"hideshow\" property.")
  assert(data.msg, "Overlay data contains no \"msg\" property.")
  local params = OverlayParam.split(data.msg, "|")
  local homeTeamID = self.teamData[1].assetId
  local awayTeamID = self.teamData[2].assetId
  if self.teamData[1].teamId == awayTeamID then
    homeTeamID = self.teamData[2].assetId
    awayTeamID = self.teamData[1].assetId
  end
  self.homeTeam = {
    id = homeTeamID,
    name = tostring(params[2])
  }
  self.awayTeam = {
    id = awayTeamID,
    name = tostring(params[9])
  }
  self.homeHistory = {
    tonumber(params[3]),
    tonumber(params[4]),
    tonumber(params[5]),
    tonumber(params[6]),
    tonumber(params[7])
  }
  self.awayHistory = {
    tonumber(params[10]),
    tonumber(params[11]),
    tonumber(params[12]),
    tonumber(params[13]),
    tonumber(params[14])
  }
  self.side = tonumber(params[17])
  self:_publishTeam()
  self:_publishTeam(true)
  self:_publishHistory()
  self:_publishHistory(true)
  self:_publishSide()
  self:_publishScore()
  self:setState(data.hideshow)
end
function Shootout:_publishActivity()
  self.im.Publish(BND_ACTIVE, self.state ~= STATE_INACTIVE)
end
function Shootout:_publishScore()
  local matchScore = self.services.MatchInfoService.GetMatchScore()
  local homeScore = matchScore.homeShootout
  local awayScore = matchScore.awayShootout
  local shootoutScore = string.format("%s - %s", tostring(homeScore), tostring(awayScore))
  self.im.Publish(BND_SCORE, shootoutScore)
end
function Shootout:_publishTeam(isAway)
  if isAway then
    if self.awayTeam ~= nil then
      self.im.Publish(BND_AWAY_TEAM, self.awayTeam)
    end
  elseif self.homeTeam ~= nil then
    self.im.Publish(BND_HOME_TEAM, self.homeTeam)
  end
end
function Shootout:_publishSide()
  self.im.Publish(BND_SIDE, self.side or -1)
end
function Shootout:_publishHistory(isAway)
  if isAway then
    if self.awayHistory ~= nil then
      self.im.Publish(BND_AWAY_HISTORY, self.awayHistory)
    end
  elseif self.homeHistory ~= nil then
    self.im.Publish(BND_HOME_HISTORY, self.homeHistory)
  end
end
function Shootout:_handleEvent(eventType, data)
  if eventType == EVENT_TYPES.OverlayTypeShootoutHistory then
    self:_onShootoutUpdate(data)
  end
end
function Shootout:finalize()
  self.im.Unsubscribe(BND_ACTIVE)
  self.im.Unsubscribe(BND_SCORE)
  self.im.Unsubscribe(BND_HOME_TEAM)
  self.im.Unsubscribe(BND_AWAY_TEAM)
  self.im.Unsubscribe(BND_SIDE)
  self.im.Unsubscribe(BND_HOME_HISTORY)
  self.im.Unsubscribe(BND_AWAY_HISTORY)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
end
return Shootout
