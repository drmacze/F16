-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local ItemModel, TableUtil, FormationModel, VirtualButton, CommonEnums, card_service = ...
local MAX_STARTING = 11
local GOALKEEPER = 1
local SQUAD_VALIDATION_ERRORS = CommonEnums.SquadValidationErrors
local CardStyle = card_service.FE.UXService.BaseService.CardStyle

local InGameTeamManagementModelHome = {}

local BND_CHEMISTRY_MATRIX = "bnd_chemistry_matrix"
local BND_STARTING_11 = "bnd_starting_11"
local BND_SUBS_AND_RES = "bnd_subs_and_res"
local BND_TEAM_NAME = "bnd_team_name"
local BND_TEAM_CREST = "bnd_team_crest"
local BND_TEAM_RATING = "bnd_team_rating"
local BND_TEAM_OVERALL = "bnd_team_overall"
local BND_PLAYER_COMPARISON_DATA = "bnd_player_comparison_data"
local BND_REVERSE_SWAP = "bnd_reverse_swap"
local BND_SUBS_REMAINING = "bnd_subs_remaining"

local ACT_SWAP_PLAYERS = "act_swap_players"
local ACT_COMPARE_PLAYERS = "act_compare_players"

function InGameTeamManagementModelHome:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    FUTSquadManagementService = o.api("FUTSquadManagementService"),
    SquadManagementService = o.api("SquadMgtService"),
    TacticsService = o.api("TacticsService"),
    GameSetupService = o.api("GameSetupService"),
    PauseMenuService = o.api("PauseMenuService")
  }

  if o.teamID == nil then
    o.teamID = o.services.GameSetupService.GetTeamId(true)
  end
  
  o.isOpponentTeam = false
  
  if o.gamemode == "fut" and o.flow ~= nil and o.flow == "offline" then
    o.isOpponentTeam = o.services.FUTSquadManagementService.GetFUTTeamId() ~= o.teamID and o.services.GameSetupService.IsHostTeam()
  end
  
  o.models = {
    ItemModel = ItemModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc
    }),
    FormationModel = FormationModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      teamID = o.teamID,
      gamemode = o.gamemode,
      flow = o.flow
    })
  }
  
  o.formationList = o.models.FormationModel:getFormationList()
  o.teamInfo = o.services.SquadManagementService.GetTeamInfo(o.teamID)
  o.players = o:getPlayers(o.teamID)
  o.chemistryMatrix = nil
  o.playerComparisonData = o:getPlayerComparisonData(nil, nil)
  o.initialSubs = 0
  local playerIDs = {}
  for i, v in ipairs(o.players) do
    if v.playerOnPitch then
      table.insert(playerIDs, v.playerID)
    end
  end
  if o.services.PauseMenuService.IsOnlineGame() then
    local isHomeTeam = true
    if o.services.GameSetupService.GetTeamId(isHomeTeam) == o.teamID and o.services.GameSetupService.IsHostTeam() then
      o.subsRemaining = o.services.SquadManagementService.GetRemainingSubstitutions(0, playerIDs)
    else
      o.subsRemaining = o.services.SquadManagementService.GetRemainingSubstitutions(1, playerIDs)
    end
  else
    o.subsRemaining = o.services.SquadManagementService.GetRemainingSubstitutions(0, playerIDs)
  end
  o.initialSubs = o.subsRemaining
  o.im.Subscribe(BND_CHEMISTRY_MATRIX, function()
    o:_publishChemistryMatrix()
  end)
  o.im.Subscribe(BND_STARTING_11, function()
    o:_publishStarting11()
  end)
  o.im.Subscribe(BND_SUBS_AND_RES, function()
    o:_publishSubsAndRes()
  end)
  o.im.Subscribe(BND_TEAM_NAME, function()
    o:_publishTeamStats(BND_TEAM_NAME)
  end)
  o.im.Subscribe(BND_TEAM_CREST, function()
    o:_publishTeamStats(BND_TEAM_CREST)
  end)
  o.im.Subscribe(BND_TEAM_RATING, function()
    o:_publishTeamStats(BND_TEAM_RATING)
  end)
  o.im.Subscribe(BND_TEAM_OVERALL, function()
    o:_publishTeamStats(BND_TEAM_OVERALL)
  end)
  o.im.Subscribe(BND_PLAYER_COMPARISON_DATA, function()
    o:_publishPlayerComparisonData()
  end)
  o.im.Subscribe(BND_REVERSE_SWAP, function()
  end)
  o.im.Subscribe(BND_SUBS_REMAINING, function()
    o.im.Publish(BND_SUBS_REMAINING, o.loc.LocalizeInteger(o.subsRemaining))
  end)
  o.im.RegisterAction(ACT_SWAP_PLAYERS, function(actionName, data)
    o:swapPlayersByIndex(data.activeIndex, data.passiveIndex)
  end)
  o.im.RegisterAction(ACT_COMPARE_PLAYERS, function(actionName, data)
    o:comparePlayers(data.activePlayer, data.passivePlayer)
  end)
  return o
end

function InGameTeamManagementModelHome:getPlayers(teamID)
  local playerLineup
  local players = {}
  if self.services.PauseMenuService.IsOnlineGame() then
    local isHomeTeam = true
    if self.services.GameSetupService.GetTeamId(isHomeTeam) == teamID and self.services.GameSetupService.IsHostTeam() then
      playerLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
    else
      playerLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(1, teamID, 0)
    end
  else
    playerLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
  end
  if self.gamemode == "fut" then
    local activeSquad
    if self.isOpponentTeam then
      activeSquad = self.models.ItemModel:getItemStructureByID(self.services.FUTSquadManagementService.GetOpponentSquadLineup(), ItemModel.CONTEXT_FIELD)
    else
      activeSquad = self.models.ItemModel:getItemStructureByID(self.services.FUTSquadManagementService.GetSquadLineup(), ItemModel.CONTEXT_FIELD)
    end
    for i, realPlayer in ipairs(playerLineup) do
      for j, futPlayer in ipairs(activeSquad) do
        if realPlayer.playerID == futPlayer.playerID then
          futPlayer.id = i - 1
          futPlayer.originalID = i - 1
          futPlayer.isRedcarded = realPlayer.isRedcarded
          futPlayer.isYellowcarded = realPlayer.isYellowcarded
          futPlayer.isInjured = realPlayer.isInjured
          futPlayer.stamina = realPlayer.stamina
          futPlayer.playerOnPitch = realPlayer.playerOnPitch
          futPlayer.isCurrentGK = realPlayer.isCurrentGK
          players[i] = futPlayer
          break
        end
      end
    end
  else
    for i, realPlayer in ipairs(playerLineup) do
      realPlayer.id = i - 1
      realPlayer.originalID = i - 1
      realPlayer.type = ItemModel.TYPE_FIELD_PLAYER
      realPlayer.cardStyle = CardStyle.FIFA_LATEST
      realPlayer.level = self.models.ItemModel:getItemLevelByRating(realPlayer.rating)
      players[i] = realPlayer
    end
  end
  return players
end

function InGameTeamManagementModelHome:comparePlayers(activePlayer, passivePlayer)
  self.playerComparisonData = self:getPlayerComparisonData(activePlayer, passivePlayer)
  self:_publishPlayerComparisonData()
end

function InGameTeamManagementModelHome:swapPlayersByIndex(activeIndex, passiveIndex)
  if (not (passiveIndex >= 11) or not (activeIndex >= 11)) and (not (passiveIndex < 11) or not (activeIndex < 11)) then
    if activeIndex >= 11 and 11 > self.players[activeIndex + 1].originalID and 11 <= self.players[passiveIndex + 1].originalID or activeIndex < 11 and 11 > self.players[passiveIndex + 1].originalID and 11 <= self.players[activeIndex + 1].originalID then
      self.subsRemaining = self.subsRemaining + 1
    elseif 11 > self.players[activeIndex + 1].originalID and 11 > self.players[passiveIndex + 1].originalID and (self.players[activeIndex + 1].isRedcarded == true or self.players[passiveIndex + 1].isRedcarded == true) then
      if not self:isSubValid(activeIndex, passiveIndex, true) then
        self.im.Publish(BND_REVERSE_SWAP, {activeIndex = activeIndex, passiveIndex = passiveIndex})
        return
      end
    elseif 11 > self.players[activeIndex + 1].originalID and 11 > self.players[passiveIndex + 1].originalID or 11 <= self.players[passiveIndex + 1].originalID and 11 <= self.players[activeIndex + 1].originalID then
    elseif not self:isSubValid(activeIndex, passiveIndex, true) then
      self.im.Publish(BND_REVERSE_SWAP, {activeIndex = activeIndex, passiveIndex = passiveIndex})
      return
    else
      self.subsRemaining = self.subsRemaining - 1
    end
    self.im.Publish(BND_SUBS_REMAINING, self.loc.LocalizeInteger(self.subsRemaining))
  elseif not self:isSubValid(activeIndex, passiveIndex, false) then
    self.im.Publish(BND_REVERSE_SWAP, {activeIndex = activeIndex, passiveIndex = passiveIndex})
    return
  end
  local passivePlayer = self.players[passiveIndex + 1]
  local activePlayer = self.players[activeIndex + 1]
  local activeID = self.players[activeIndex + 1].id
  local passiveID = self.players[passiveIndex + 1].id
  if passivePlayer.isCurrentGK then
    passivePlayer.isCurrentGK = false
    activePlayer.isCurrentGK = true
  elseif activePlayer.isCurrentGK then
    passivePlayer.isCurrentGK = true
    activePlayer.isCurrentGK = false
  end
  if passivePlayer.playerOnPitch == true and activePlayer.playerOnPitch == false then
    passivePlayer.playerOnPitch = false
    activePlayer.playerOnPitch = true
  elseif passivePlayer.playerOnPitch == false and activePlayer.playerOnPitch == true then
    passivePlayer.playerOnPitch = true
    activePlayer.playerOnPitch = false
  end
  self.players[passiveIndex + 1] = self.players[activeIndex + 1]
  self.players[passiveIndex + 1].id = passiveID
  self.players[activeIndex + 1] = passivePlayer
  self.players[activeIndex + 1].id = activeID
end

function InGameTeamManagementModelHome:getPlayerComparisonData(activePlayer, passivePlayer)
  local comparisonData = {}
  if activePlayer == nil and passivePlayer == nil then
    comparisonData.attributes = -1
    comparisonData.activeStats = -1
    comparisonData.passiveStats = -1
  else
    assert(activePlayer, "Active player must not be nil to initiate a player comparison.")
    comparisonData.attributes = {}
    comparisonData.activeStats = {}
    comparisonData.passiveStats = {}
    for i = 1, 6 do
      comparisonData.attributes[i] = activePlayer["label" .. i]
      comparisonData.activeStats[i] = activePlayer["stat" .. i]
      if passivePlayer and passivePlayer.isGoalie == activePlayer.isGoalie then
        comparisonData.passiveStats[i] = passivePlayer["stat" .. i]
      else
        comparisonData.passiveStats[i] = "--"
      end
    end
  end
  return comparisonData
end

function InGameTeamManagementModelHome:isSubValid(activePlayerIndex, passivePlayerIndex, subsNeeded)
  local isValid = true
  local errorMsg = ""
  local activePlayer = self.players[activePlayerIndex + 1]
  local passivePlayer = self.players[passivePlayerIndex + 1]
  local playerGoingIn = activePlayerIndex < 11 and passivePlayer or activePlayer
  if activePlayerIndex < 11 and passivePlayerIndex < 11 then
    if activePlayer.isCurrentGK == true and activePlayer.isRedcarded == false or passivePlayer.isCurrentGK == true and passivePlayer.isRedcarded == false then
      errorMsg = "LTXT_MOB_CANT_SWAP_GOALKEEPER"
      isValid = false
    else
      return true
    end
  end
  if self.subsRemaining <= 0 and subsNeeded == true then
    errorMsg = "LTXT_PAUSE_OUT_OF_SUBS"
    isValid = false
  end
  if activePlayer.isRedcarded == true or passivePlayer.isRedcarded == true then
    errorMsg = "LTXT_PAUSE_RED_CARD_SUBS"
    isValid = false
  end
  if playerGoingIn.isInjured == true or playerGoingIn.stamina == 0 then
    errorMsg = "LTXT_PAUSE_INJURED"
    isValid = false
  end
  if playerGoingIn.wasPlayerSubed == true then
    errorMsg = "LTXT_ALREADY_SUBBED"
    isValid = false
  end
  if not isValid then
    local buttonOk = VirtualButton:new({
      nav = self.nav,
      label = "LTXT_CMN_OK",
      icon = "$IconButton_X",
      clickEvents = {
        "evt_hide_popup"
      }
    })
    local popupData = {
      message = errorMsg,
      buttons = {buttonOk}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
  end
  return isValid
end

function InGameTeamManagementModelHome:validateSquad()
  local validFormation = SQUAD_VALIDATION_ERRORS.SquadValidationNoError
  for i, v in ipairs(self.players) do
    if i <= MAX_STARTING then
      local isRedCarded = v.isRedcarded
      local isCurrentGK = v.isCurrentGK
      local isInjured = v.isInjured
      if i == GOALKEEPER and isRedCarded then
        validFormation = SQUAD_VALIDATION_ERRORS.SquadValidationGKRedcarded
        break
      elseif isInjured and (self.initialSubs ~= 0 or isCurrentGK) then
        validFormation = SQUAD_VALIDATION_ERRORS.SquadValidationInjuredPlayerOnFormation
        break
      end
    end
  end
  return validFormation
end

function InGameTeamManagementModelHome:forceSubstitution()
  local injuredPlayer = -1
  for i, v in ipairs(self.players) do
    if v.playerOnPitch and (v.isInjured == true or v.stamina == 0) then
      injuredPlayer = i
    end
  end
  if injuredPlayer > 0 then
    for i, v in ipairs(self.players) do
      if v.playerOnPitch == false and self:isSubValid(injuredPlayer - 1, i - 1, true) then
        self:swapPlayersByIndex(injuredPlayer - 1, i - 1)
        self:saveSquad()
        return
      end
    end
  end
end

function InGameTeamManagementModelHome:saveSquad()
  local playerIDs = {}
  for i = 1, #self.players do
    playerIDs[i] = self.players[i].CARD_ID
  end
  if self.services.PauseMenuService.IsOnlineGame() then
    local isHomeTeam = true
    if self.services.GameSetupService.GetTeamId(isHomeTeam) == self.teamID and self.services.GameSetupService.IsHostTeam() then
      self.services.SquadManagementService.SetCurrentPlayerLineup(0, self.teamID, 0, 0, playerIDs)
      self.services.TacticsService.SetFormation(0, self.teamID, self.models.FormationModel:getCurrentFormationID())
    else
      self.services.SquadManagementService.SetCurrentPlayerLineup(1, self.teamID, 0, 0, playerIDs)
      self.services.TacticsService.SetFormation(1, self.teamID, self.models.FormationModel:getCurrentFormationID())
    end
  else
    self.services.SquadManagementService.SetCurrentPlayerLineup(0, self.teamID, 0, 0, playerIDs)
    self.services.TacticsService.SetFormation(0, self.teamID, self.models.FormationModel:getCurrentFormationID())
  end
end

function InGameTeamManagementModelHome:_publishStarting11()
  if self.players == nil then
    return
  end
  local starting11 = {}
  for i = 1, MAX_STARTING do
    starting11[i] = self.players[i]
  end
  self.im.Publish(BND_STARTING_11, {data = starting11})
end

function InGameTeamManagementModelHome:_publishSubsAndRes()
  if self.players == nil then
    return
  end
  local nSubs = self.services.SquadManagementService.GetNumberOfSubs()
  local subs = {}
  local subsAndRes = {}
  for i = 1, nSubs do
    subs[i] = self.players[i + MAX_STARTING]
  end
  table.insert(subsAndRes, {
    label = self.loc.LocalizeString("LTXT_SQD_SUBSTITUTES"),
    data = subs
  })
  self.im.Publish(BND_SUBS_AND_RES, subsAndRes)
end

function InGameTeamManagementModelHome:_publishChemistryMatrix()
  if self.isOpponentTeam then
    self.chemistryMatrix = self.services.FUTSquadManagementService.GetOpponentFormationLinks(self.models.FormationModel:getCurrentFormationID())
  else
    self.chemistryMatrix = self.services.FUTSquadManagementService.GetFormationLinks(self.models.FormationModel:getCurrentFormationID())
  end
  for i, v in ipairs(self.chemistryMatrix) do
    v.PLAYER_LINKSTRENGTH = -1
  end
  self.im.Publish(BND_CHEMISTRY_MATRIX, {
    formation = self.models.FormationModel:getCurrentFormation(),
    chemistryLinks = self.chemistryMatrix
  })
end

function InGameTeamManagementModelHome:_publishTeamStats(bindingName)
  if bindingName == nil then
    self:_publishTeamStats(BND_TEAM_NAME)
    self:_publishTeamStats(BND_TEAM_CREST)
    self:_publishTeamStats(BND_TEAM_RATING)
    self:_publishTeamStats(BND_TEAM_OVERALL)
  elseif bindingName == BND_TEAM_NAME then
    if self.services.PauseMenuService.IsOnlineGame() then
      local isHomeTeam = true
      if self.services.GameSetupService.GetTeamId(isHomeTeam) == self.teamID and self.services.GameSetupService.IsHostTeam() then
        self.im.Publish(BND_TEAM_NAME, self.services.GameSetupService.GetTeamLongName(0))
      else
        self.im.Publish(BND_TEAM_NAME, self.services.GameSetupService.GetTeamLongName(1))
      end
    else
      self.im.Publish(BND_TEAM_NAME, self.services.GameSetupService.GetTeamLongName(0))
    end
  elseif bindingName == BND_TEAM_CREST then
    self.im.Publish(BND_TEAM_CREST, {
      name = "$Crest64x64",
      id = self.teamID
    })
  elseif bindingName == BND_TEAM_RATING then
    self.im.Publish(BND_TEAM_RATING, self.teamInfo.starRating)
  elseif bindingName == BND_TEAM_OVERALL then
    self.im.Publish(BND_TEAM_OVERALL, self.teamInfo.overall)
  else
  end
end

function InGameTeamManagementModelHome:_publishPlayerComparisonData()
  self.im.Publish(BND_PLAYER_COMPARISON_DATA, self.playerComparisonData)
end

function InGameTeamManagementModelHome:getLineUpBySideAndTeamID(teamSide, teamID)
  local lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(teamSide, teamID, 4)
  return lineup
end

function InGameTeamManagementModelHome:finalize()
  self.models.ItemModel:finalize()
  self.models.FormationModel:finalize()
  self.im.UnregisterAction(ACT_SWAP_PLAYERS)
  self.im.UnregisterAction(ACT_COMPARE_PLAYERS)
  self.im.Unsubscribe(BND_CHEMISTRY_MATRIX)
  self.im.Unsubscribe(BND_STARTING_11)
  self.im.Unsubscribe(BND_SUBS_AND_RES)
  self.im.Unsubscribe(BND_TEAM_NAME)
  self.im.Unsubscribe(BND_TEAM_CREST)
  self.im.Unsubscribe(BND_TEAM_RATING)
  self.im.Unsubscribe(BND_TEAM_OVERALL)
  self.im.Unsubscribe(BND_PLAYER_COMPARISON_DATA)
  self.im.Unsubscribe(BND_REVERSE_SWAP)
  self.im.Unsubscribe(BND_SUBS_REMAINING)
end

return InGameTeamManagementModelHome