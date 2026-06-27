-- RMOD BY YouTube laosiji --
local ItemModel, TableUtil, FormationModel = ...
local MAX_STARTING = 11
local TeamManagementModel = {}
local BND_HOME_CHEMISTRY_MATRIX = "bnd_home_chemistry_matrix"
local BND_HOME_STARTING_11 = "bnd_home_starting_11"
local BND_HOME_SUBS_AND_RES = "bnd_home_subs_and_res"
local BND_HOME_TEAM_NAME = "bnd_home_team_name"
local BND_HOME_TEAM_CREST = "bnd_home_team_crest"
local BND_HOME_TEAM_MAN = "bnd_home_team_man"
local BND_HOME_TEAM_RATING = "bnd_home_team_rating"
local BND_HOME_TEAM_RATING_LABEL = "bnd_home_team_rating_label"
local BND_HOME_TEAM_OVERALL = "bnd_home_team_overall"
local BND_HOME_PLAYER_COMPARISON_DATA = "bnd_home_player_comparison_data"
local ACT_SWAP_PLAYERS = "act_swap_players"
local ACT_COMPARE_PLAYERS = "act_compare_players"
function TeamManagementModel:new(init)
  print("[TeamManagementModel]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    FUTSquadManagementService = o.api("FUTSquadManagementService"),
    SquadManagementService = o.api("SquadMgtService"),
    TacticsService = o.api("TacticsService"),
    GameSetupService = o.api("GameSetupService")
  }
  o.teamID = o.services.GameSetupService.GetTeamId(true)
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
      gamemode = o.gamemode
    })
  }
  o.formationList = o.models.FormationModel:getFormationList()
  o.teamInfo = o.services.SquadManagementService.GetTeamInfo(o.teamID)
  o.players = o:getPlayers(o.teamID)
  o.chemistryMatrix = nil
  o.playerComparisonData = o:getPlayerComparisonData(nil, nil)
  o.im.Subscribe(BND_HOME_CHEMISTRY_MATRIX, function()
    o:_publishChemistryMatrix()
  end)
  o.im.Subscribe(BND_HOME_STARTING_11, function()
    o:_publishStarting11()
  end)
  o.im.Subscribe(BND_HOME_SUBS_AND_RES, function()
    o:_publishSubsAndRes()
  end)
  o.im.Subscribe(BND_HOME_TEAM_NAME, function()
    o:_publishTeamStats(BND_HOME_TEAM_NAME)
  end)
  o.im.Subscribe(BND_HOME_TEAM_CREST, function()
    o:_publishTeamStats(BND_HOME_TEAM_CREST)
  end)
  o.im.Subscribe(BND_HOME_TEAM_MAN, function()
    o:_publishTeamStats(BND_HOME_TEAM_MAN)
  end)
  o.im.Subscribe(BND_HOME_TEAM_RATING, function()
    o:_publishTeamStats(BND_HOME_TEAM_RATING)
  end)
  o.im.Subscribe(BND_HOME_TEAM_RATING_LABEL, function()
    o:_publishTeamRatingLabel()
  end)
  o.im.Subscribe(BND_HOME_TEAM_OVERALL, function()
    o:_publishTeamStats(BND_HOME_TEAM_OVERALL)
  end)
  o.im.Subscribe(BND_HOME_PLAYER_COMPARISON_DATA, function()
    o:_publishPlayerComparisonData()
  end)
  o.im.RegisterAction(ACT_SWAP_PLAYERS, function(actionName, data)
    o:swapPlayersByIndex(data.activeIndex, data.passiveIndex)
  end)
  o.im.RegisterAction(ACT_COMPARE_PLAYERS, function(actionName, data)
    o:comparePlayers(data.activePlayer, data.passivePlayer)
  end)
  return o
end
function TeamManagementModel:getPlayers(teamID)
  print("[TeamManagementModel]: getPlayers()")
  local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
  for i, v in ipairs(players) do
    v.id = i - 1
    v.type = ItemModel.TYPE_FIELD_PLAYER
    v.level = self.models.ItemModel:getItemLevelByRating(v.rating)
  end
  return players
end
function TeamManagementModel:comparePlayers(activePlayer, passivePlayer)
  print("[TeamManagementModel]: comparePlayers(activePlayer = " .. tostring(activePlayer) .. ", passivePlayer = " .. tostring(passivePlayer) .. ")")
  self.playerComparisonData = self:getPlayerComparisonData(activePlayer, passivePlayer)
  self:_publishPlayerComparisonData()
end
function TeamManagementModel:swapPlayersByIndex(activeIndex, passiveIndex)
  print("[TeamManagementModel]: swapPlayerByIndex{" .. activeIndex .. ", " .. passiveIndex .. ")")
  print("[TeamManagementModel]: swapPlayerByIndex{" .. self.players[activeIndex + 1].CARD_ID .. ", " .. self.players[passiveIndex + 1].CARD_ID .. ")")
  local passivePlayer = self.players[passiveIndex + 1]
  local activePlayer = self.players[activeIndex + 1]
  local activeID = self.players[activeIndex + 1].id
  local passiveID = self.players[passiveIndex + 1].id
  self.players[passiveIndex + 1] = self.players[activeIndex + 1]
  self.players[passiveIndex + 1].id = passiveID
  self.players[activeIndex + 1] = passivePlayer
  self.players[activeIndex + 1].id = activeID
end
function TeamManagementModel:getPlayerComparisonData(activePlayer, passivePlayer)
  print("[TeamManagementModel: getPlayerComparisonData(activePlayer = " .. tostring(activePlayer) .. ", passivePlayer = " .. tostring(passivePlayer) .. "): Listing comparison data...")
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
  TableUtil.print(comparisonData)
  return comparisonData
end
function TeamManagementModel:saveSquad()
  print("[TeamManagementModel]: saveSquad()")
  local playerIDs = {}
  for i = 1, #self.players do
    playerIDs[i] = self.players[i].CARD_ID
  end
  self.services.SquadManagementService.SetCurrentPlayerLineup(0, self.teamID, 0, 0, playerIDs)
  self.services.TacticsService.SetFormation(0, self.teamID, self.models.FormationModel:getCurrentFormationID())
end
function TeamManagementModel:_publishStarting11()
  if self.players == nil then
    return
  end
  print("[TeamManagementModel]: _publishStarting11()")
  local starting11 = {}
  for i = 1, MAX_STARTING do
    starting11[i] = self.players[i]
  end
  self.im.Publish(BND_HOME_STARTING_11, {data = starting11})
end
function TeamManagementModel:_publishSubsAndRes()
  if self.players == nil then
    return
  end
  print("[TeamManagementModel]: _publishSubsAndRes()")
  local nSubs = self.services.SquadManagementService.GetNumberOfSubs()
  local nRes = self.services.SquadManagementService.GetNumberOfReserves(self.teamID)
  local subs = {}
  local res = {}
  local subsAndRes = {}
  for i = 1, nSubs do
    subs[i] = self.players[i + MAX_STARTING]
  end
  table.insert(subsAndRes, {
    label = self.loc.LocalizeString("LTXT_SQD_SUBSTITUTES"),
    data = subs
  })
  if 0 < nRes then
    for i = 1, nRes do
      res[i] = self.players[i + MAX_STARTING + nSubs]
    end
    table.insert(subsAndRes, {
      label = self.loc.LocalizeString("LTXT_SQD_RESERVES"),
      data = res
    })
  end
  self.im.Publish(BND_HOME_SUBS_AND_RES, subsAndRes)
end
function TeamManagementModel:_publishChemistryMatrix()
  print("[TeamManagementModel]: _publishChemistryMatrix()")
  self.chemistryMatrix = self.services.FUTSquadManagementService.GetFormationLinks(self.models.FormationModel:getCurrentFormationID())
  for i, v in ipairs(self.chemistryMatrix) do
    v.PLAYER_LINKSTRENGTH = -1
  end
  self.im.Publish(BND_HOME_CHEMISTRY_MATRIX, {
    formation = self.models.FormationModel:getCurrentFormation(),
    chemistryLinks = self.chemistryMatrix
  })
end
function TeamManagementModel:_publishTeamStats(bindingName)
  if bindingName == nil then
    self:_publishTeamStats(BND_HOME_TEAM_NAME)
    self:_publishTeamStats(BND_HOME_TEAM_CREST)
    self:_publishTeamStats(BND_HOME_TEAM_MAN)
    self:_publishTeamStats(BND_HOME_TEAM_RATING)
    self:_publishTeamStats(BND_HOME_TEAM_OVERALL)
  elseif bindingName == BND_HOME_TEAM_NAME then
    self.im.Publish(BND_HOME_TEAM_NAME, self.loc.LocalizeString("TeamName_Abbr15_" .. self.teamID))
  elseif bindingName == BND_HOME_TEAM_CREST then
    self.im.Publish(BND_HOME_TEAM_CREST, {
      name = "$Crest",
      id = self.teamID
    })
  elseif bindingName == BND_HOME_TEAM_MAN then
    self.im.Publish(BND_HOME_TEAM_MAN, {
      name = "$ManagerCard",
      id = self.teamID
    })
  elseif bindingName == BND_HOME_TEAM_RATING then
    self.im.Publish(BND_HOME_TEAM_RATING, self.teamInfo.starRating)
  elseif bindingName == BND_HOME_TEAM_OVERALL then
    self.im.Publish(BND_HOME_TEAM_OVERALL, self.teamInfo.overall)
  else
    print("[TeamManagementModel]: _publishTeamStats(): Team stat unknown.")
  end
end
function TeamManagementModel:_publishPlayerComparisonData()
  self.im.Publish(BND_HOME_PLAYER_COMPARISON_DATA, self.playerComparisonData)
end
function TeamManagementModel:_publishTeamRatingLabel()
  local ratingLabel = self.loc.LocalizeString("LTXT_SQD_TEAM_RATING_LABEL")
  ratingLabel = ratingLabel .. " " .. tostring(self.teamInfo.overall)
  self.im.Publish(BND_HOME_TEAM_RATING_LABEL, ratingLabel)
end
function TeamManagementModel:finalize()
  print("[TeamManagementModel]: finalize()")
  self.models.ItemModel:finalize()
  self.models.FormationModel:finalize()
  self.im.UnregisterAction(ACT_SWAP_PLAYERS)
  self.im.UnregisterAction(ACT_COMPARE_PLAYERS)
  self.im.Unsubscribe(BND_HOME_CHEMISTRY_MATRIX)
  self.im.Unsubscribe(BND_HOME_STARTING_11)
  self.im.Unsubscribe(BND_HOME_SUBS_AND_RES)
  self.im.Unsubscribe(BND_HOME_TEAM_NAME)
  self.im.Unsubscribe(BND_HOME_TEAM_CREST)
  self.im.Unsubscribe(BND_HOME_TEAM_MAN)
  self.im.Unsubscribe(BND_HOME_TEAM_RATING)
  self.im.Unsubscribe(BND_HOME_TEAM_RATING_LABEL)
  self.im.Unsubscribe(BND_HOME_TEAM_OVERALL)
  self.im.Unsubscribe(BND_HOME_PLAYER_COMPARISON_DATA)
end
return TeamManagementModel
