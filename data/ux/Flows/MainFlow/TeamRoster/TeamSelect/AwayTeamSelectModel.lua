
local VirtualButton, PregameManager, CommonNavVars, TableUtil = ...
local AwayTeamSelectModel = {}
function AwayTeamSelectModel:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    GameState = o.api("GameStateService"),
    UserPlate = o.api("UserPlateService"),
    GameSetup = o.api("GameSetupService"),
    SquadMgt = o.api("SquadMgtService"),
    FutSquadMgt = o.api("FUTSquadManagementService")
  }
  o.away = 1
  o.awayTeam = {}
  return o
end

function AwayTeamSelectModel:setTeam(initialAwayTeamId)
  self.services.GameSetup.SetTeam(self.away, initialAwayTeamId)
end

function AwayTeamSelectModel:getOpponentUserData()
  local opponentUserData = {
    displayName = self.services.UserPlate.GetDisplayName(),
    coins = self.services.UserPlate.GetCashBalance(),
    points = self.services.UserPlate.GetFifaPoints(),
    currentXP = self.services.UserPlate.GetExperience(),
    targetXP = self.services.UserPlate.GetExperienceForNextLevel(),
    currentLevel = self.services.UserPlate.GetLevel(),
    nextLevel = self.services.UserPlate.GetLevel()
  }
  return opponentUserData
end

function AwayTeamSelectModel:getUnknownTeamData()
  local unknownTeamData = {
    teamId = -1,
    teamName = "",
    crestId = 0,
    starRating = 0,
    overall = 0,
    teamRating = {
      attackValue = 0,
      middleValue = 0,
      defenseValue = 0,
      attackLabel = self.loc.LocalizeString("LTXT_CMN_ATT"),
      middleLabel = self.loc.LocalizeString("LTXT_CMN_MID"),
      defenseLabel = self.loc.LocalizeString("LTXT_CMN_DEF")
    },
    chemistry = 0
  }
  return unknownTeamData
end

function AwayTeamSelectModel:getSquadDataFromMatchInfo(teamInfo)
  local teamData = self.services.SquadMgt.GetTeamInfo(teamInfo.teamId)
  teamData.chemistry = self.services.FutSquadMgt.GetSquadStats().chemistry
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
  self:setAwayTeam(teamData)
  return teamData
end

function AwayTeamSelectModel:getAwayTeam()
  return self.awayTeam
end

function AwayTeamSelectModel:setAwayTeam(value)
  self.awayTeam = value
end

function AwayTeamSelectModel:showDisconnectPopup()
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

function AwayTeamSelectModel:isDynamic()
  return self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL and self.navContext.flow == CommonNavVars.TYPES.FRIENDLY
end

function AwayTeamSelectModel:setupTeams()
  if self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
    local awayTeamId = 0
    if self.awayTeam.teamId then
      awayTeamId = self.awayTeam.teamId
    end
    self.services.GameSetup.SetTeamIdForNibDisplay(self.away, awayTeamId)
  elseif self.navContext.flow == CommonNavVars.FLOWS.ONLINE then
  else
    if self.navContext.flow == CommonNavVars.FLOWS.OFFLINE then
     self.services.GameSetup.SetTeamIdForNibDisplay(self.away, self.awayTeam.teamId)
    else
    end
  end
end

function AwayTeamSelectModel:finalize()
end

return AwayTeamSelectModel
