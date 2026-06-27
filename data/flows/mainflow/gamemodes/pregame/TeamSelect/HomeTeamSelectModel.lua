
local VirtualButton, PregameManager, CommonNavVars, TableUtil = ...
local HomeTeamSelectModel = {}
function HomeTeamSelectModel:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.navContext = o.data
  o.services = {
    GameState = o.api("GameStateService"),
    GameSetup = o.api("GameSetupService"),
    SquadMgt = o.api("SquadMgtService"),
    FutSquadMgt = o.api("FUTSquadManagementService"),
    MatchInfo = o.api("MatchInfoService"),
    MatchSetup = o.api("MatchSetupService"),
    Pregame = o.api("PregameService")
  }
  print("HomeTeamSelectModel New()")
  o.home = 0
  o.homeTeam = {}
  return o
end

function HomeTeamSelectModel:setTeam(initialHomeTeamId)
  self.services.GameSetup.SetTeam(self.home, initialHomeTeamId)
end

function HomeTeamSelectModel:FUT()
  local userFUTTeamId = self.services.FutSquadMgt.GetFUTTeamId()
  self:setTeam(userFUTTeamId)
  local teams = self.services.MatchInfo.GetMatchTeams()
  self:getSquadDataFromMatchInfo(teams[1])
end

function HomeTeamSelectModel:REAL(toggleSideHome, updateRoster)
  local teams = self.services.MatchInfo.GetMatchTeams()
  self.services.MatchSetup.RequestDefaultOptions(toggleSideHome)
  self:setHomeTeam(teams[1])
  if updateRoster then
    self:setTeam(teams[1].teamId)
  end
  return teams[1].teamId
end

function HomeTeamSelectModel:getSquadDataFromMatchInfo(teamInfo)
  local teamData = self.services.SquadMgt.GetTeamInfo(teamInfo.teamId)
  local teamSquadStats = self.services.FutSquadMgt.GetSquadStats()
  if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
    teamData.starRating = teamSquadStats.starRating
    teamData.overall = teamSquadStats.overall
  end
  teamData.chemistry = teamSquadStats.chemistry
  teamData.crestId = teamInfo.assetId
  teamData.teamId = teamInfo.teamId
  teamData.teamName = teamInfo.teamName
  teamData.teamRating = {
    attackValue = string.format("%d", teamData.offense),
    middleValue = string.format("%d", teamData.midfield),
    defenseValue = string.format("%d", teamData.defense),
    attackLabel = self.loc.LocalizeString("LTXT_CMN_ATT"),
    middleLabel = self.loc.LocalizeString("LTXT_CMN_MID"),
    defenseLabel = self.loc.LocalizeString("LTXT_CMN_DEF")
  }
  self:setHomeTeam(teamData)
  return teamData
end

function HomeTeamSelectModel:getHomeTeam()
  return self.homeTeam
end

function HomeTeamSelectModel:setHomeTeam(value)
  self.homeTeam = value
end

function HomeTeamSelectModel:checkAdvance()
  return true
end

function HomeTeamSelectModel:showDisconnectPopup()
  local buttonClose = VirtualButton:new({
    nav = self.nav,
    icon = "$FooterIconNo",
    label = "LTXT_SOC_CLOSE",
    clickEvents = {
      "evt_hide_popup"
    }
  })
  local popupData = {
    title = "LTXT_GAMEPAD_NOT_CONNECTED_TITLE",
    message = "LTXT_GAMEPAD_NOT_CONNECTED_MSG",
    buttons = {buttonClose}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function HomeTeamSelectModel:advance(isDynamic)
  print("HomeTeamSelectModel:advance(isDynamic)")
  if isDynamic then
    local side = 1
    if self.services.GameSetup.IsHostTeam() then
      side = 0
    end
    local teamData = {}
    teamData.SIDE = side
    self.services.Pregame.HandleTeamReady(teamData)
    if self.services.Pregame.AreBothSidesReady() then
      self:doAdvance()
    end
  else
    self:doAdvance()
  end
end

function HomeTeamSelectModel:doAdvance()
  self.nav.Event(nil, "evt_advance")
  self:setupTeams()
end

function HomeTeamSelectModel:isDynamic()
  return self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL and self.navContext.flow == CommonNavVars.TYPES.FRIENDLY
end

function HomeTeamSelectModel:setupTeams()
  if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
    if self.navContext.flow ~= CommonNavVars.FLOWS.ONLINE then
       self.services.GameSetup.SetTeamIdForNibDisplay(self.home, self.homeTeam.teamId)
    end
  elseif self.navContext.flow == CommonNavVars.FLOWS.ONLINE then
  else
    if self.navContext.flow == CommonNavVars.FLOWS.OFFLINE then
       self.services.GameSetup.SetTeamIdForNibDisplay(self.home, self.homeTeam.teamId)
    else
    end
  end
end

function HomeTeamSelectModel:finalize()
end

return HomeTeamSelectModel
