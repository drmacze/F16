-- MOD BY LAOSIJI --
local ItemModel, TableUtil, FormationModel = ...
local MAX_STARTING = 11
local TeamManagementModel = {}
local BND_CHEMISTRY_MATRIX = "bnd_chemistry_matrix"
local BND_STARTING_11 = "bnd_starting_11"
local BND_SUBS_AND_RES = "bnd_subs_and_res"
local BND_TEAM_NAME = "bnd_team_name"
local BND_TEAM_CREST = "bnd_team_crest"
local BND_TEAM_MAN = "bnd_team_man"
local BND_TEAM_RATING = "bnd_team_rating"
local BND_TEAM_RATING_LABEL = "bnd_team_rating_label"
local BND_TEAM_OVERALL = "bnd_team_overall"
local BND_PLAYER_COMPARISON_DATA = "bnd_player_comparison_data"
local ACT_ITEM_SHOW_BIO = "act_item_show_bio"
local ACT_SWAP_PLAYERS = "act_swap_players"
local ACT_COMPARE_PLAYERS = "act_compare_players"
local BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE = "bnd_context_menu_visible"
local ACT_SWAP_WITH_INVENTORY = "act_swap_with_inventory"
local ACT_ITEM_SWAP_WITH_CLUB = "act_item_swap_with_club"
local ACT_ITEM_REMOVE_FROM_SQUAD = "act_item_remove_from_squad"
local ACT_ITEM_SEND_TO_TRADE_PILE = "act_item_send_to_trade_pile"
local ACT_ITEM_APPLY_CONSUMABLE = "act_item_apply_consumable"
local ACT_ITEM_QUICK_SELL = "act_item_quick_sell"
local ACT_ITEM_QUICK_LIST = "act_item_quick_list"
local ACT_SEND_ITEM_DATA = "act_send_item_data"


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
  
  o.teamID = currentMatch.SquadId == 0 and currentMatch.HomeTeamID or currentMatch.AwayTeamID
  
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
  o.im.Subscribe(BND_TEAM_MAN, function()
    o:_publishTeamStats(BND_TEAM_MAN)
  end)
  o.im.Subscribe(BND_TEAM_RATING, function()
    o:_publishTeamStats(BND_TEAM_RATING)
  end)
  o.im.Subscribe(BND_TEAM_RATING_LABEL, function()
    o:_publishTeamRatingLabel()
  end)
  o.im.Subscribe(BND_TEAM_OVERALL, function()
    o:_publishTeamStats(BND_TEAM_OVERALL)
  end)
  o.im.Subscribe(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE, function()
  end)
  o.im.Subscribe(BND_PLAYER_COMPARISON_DATA, function()
    o:_publishPlayerComparisonData()
  end)
  o.im.RegisterAction(ACT_ITEM_SHOW_BIO, function(actionName, uniqueID)
    o:showBio(uniqueID.groupID)
  end)
  o.im.RegisterAction(ACT_SWAP_PLAYERS, function(actionName, data)
    o:swapPlayersByIndex(data.activeIndex, data.passiveIndex)
  end)
  o.im.RegisterAction(ACT_COMPARE_PLAYERS, function(actionName, data)
    o:comparePlayers(data.activePlayer, data.passivePlayer)
  end)
  o.im.RegisterAction(ACT_SEND_ITEM_DATA, function(actionName, data)
    o:_compareData(data)
  end)
  
  return o
end



function TeamManagementModel:_compareData(itemData)
  local UUID_UPPER_INDEX = 1
  local UUID_LOWER_INDEX = 2
  local CARD_TYPE_INDEX = 3
  local CARD_ID_INDEX = 4
  local POSITION_ID = 5
  local itemIds = {}
  local currentItemIndex = -1
  if self.players ~= nil then
    for i, playersList in ipairs(self.players) do
      table.insert(itemIds, {
        UUID_LOWER = playersList.UUID_LOWER,
        UUID_UPPER = playersList.UUID_UPPER,
        CARD_TYPE = playersList.CARD_TYPE,
        CARD_ID = playersList.CARD_ID,
        POS_IN_SQUAD = playersList.id
      })
    end
  end
  if self.manager ~= nil then
    table.insert(itemIds, {
      UUID_LOWER = self.manager.UUID_LOWER,
      UUID_UPPER = self.manager.UUID_UPPER,
      CARD_TYPE = self.manager.CARD_TYPE,
      CARD_ID = self.manager.CARD_ID,
      POS_IN_SQUAD = MANAGER_POSITION_INDEX
    })
  end
  currentItemIndex = itemData[POSITION_ID] - 1
  quickSellItemFunc = {
    quickSellItem = function(positionIndex)
      self:quickSellItem(positionIndex)
    end
  }
  swapWithClubFunc = {
    swapWithClub = function(positionIndex)
      self:swapWithClub(positionIndex)
    end
  }
  hideItemContextCallbackFunc = {
    hideItemContextCallback = function()
      self.im.Publish(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE, false)
    end
  }
  self.im.Publish(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE, true)
  self.nav.Event(nil, "evt_show_item_context", {
    itemIdList = itemIds,
    itemIndex = currentItemIndex,
    isSquad = true,
    squadId = self.squad.id,
    quickSellItemFunc = quickSellItemFunc,
    swapWithClubFunc = swapWithClubFunc,
    hideItemContextCallbackFunc = hideItemContextCallbackFunc
  })
end

function TeamManagementModel:getPlayers(teamID)
  print("[TeamManagementModel]: getPlayers()")
  local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
  do
    do
      for _FORV_6_, _FORV_7_ in ipairs(players) do
        _FORV_7_.id = _FORV_6_ - 1
        _FORV_7_.type = ItemModel.TYPE_FIELD_PLAYER
        
        _FORV_7_.level = self.models.ItemModel:getItemLevelByRating(_FORV_7_.rating)
      end
    end
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
    assert(activePlayer, "The active player must not be null to start a player comparison.")
    comparisonData.attributes = {}
    comparisonData.activeStats = {}
    comparisonData.passiveStats = {}
    do
      for _FORV_7_ = 1, 6 do
        comparisonData.attributes[_FORV_7_] = activePlayer["label" .. _FORV_7_]
        comparisonData.activeStats[_FORV_7_] = activePlayer["stat" .. _FORV_7_]
        if passivePlayer and passivePlayer.isGoalie == activePlayer.isGoalie then
          comparisonData.passiveStats[_FORV_7_] = passivePlayer["stat" .. _FORV_7_]
        else
          comparisonData.passiveStats[_FORV_7_] = "--"
        end
      end
    end
  end
  TableUtil.print(comparisonData)
  return comparisonData
end

function TeamManagementModel:saveSquad()
  print("[TeamManagementModel]: saveSquad()")
  local playerIDs = {}
  do
    do
      for _FORV_5_ = 1, #self.players do
        playerIDs[_FORV_5_] = self.players[_FORV_5_].CARD_ID
      end
    end
  end
  self.services.SquadManagementService.SetCurrentPlayerLineup(currentMatch.SquadId, self.teamID, 0, 0, playerIDs)
  self.services.TacticsService.SetFormation(currentMatch.SquadId, self.teamID, self.models.FormationModel:getCurrentFormationID())
end

function TeamManagementModel:_publishStarting11()
  if self.players == nil then
    return
  end
  print("[TeamManagementModel]: _publishStarting11()")
  local starting11 = {}
  do
    do
      for _FORV_5_ = 1, MAX_STARTING do
        starting11[_FORV_5_] = self.players[_FORV_5_]
      end
    end
  end
  self.im.Publish(BND_STARTING_11, {data = starting11})
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
  do
    do
      for _FORV_9_ = 1, nSubs do
        subs[_FORV_9_] = self.players[_FORV_9_ + MAX_STARTING]
      end
    end
  end
  table.insert(subsAndRes, {
    label = ("SUB"),
    data = subs
  })
  if nRes > 0 then
    do
      do
        for _FORV_9_ = 1, nRes do
          res[_FORV_9_] = self.players[_FORV_9_ + MAX_STARTING + nSubs]
        end
      end
    end
    table.insert(subsAndRes, {
      label = ("RES"),
      data = res
    })
  end
  self.im.Publish(BND_SUBS_AND_RES, subsAndRes)
end

function TeamManagementModel:_publishChemistryMatrix()
  print("[TeamManagementModel]: _publishChemistryMatrix()")
  self.chemistryMatrix = self.services.FUTSquadManagementService.GetFormationLinks(self.models.FormationModel:getCurrentFormationID())
  do
    do
      for _FORV_4_, _FORV_5_ in ipairs(self.chemistryMatrix) do
        _FORV_5_.PLAYER_LINKSTRENGTH = -1
      end
    end
  end
  self.im.Publish(BND_CHEMISTRY_MATRIX, {
    formation = self.models.FormationModel:getCurrentFormation(),
    chemistryLinks = self.chemistryMatrix
  })
end

function TeamManagementModel:_publishTeamStats(bindingName)
  if bindingName == nil then
    self:_publishTeamStats(BND_TEAM_NAME)
    self:_publishTeamStats(BND_TEAM_CREST)
    self:_publishTeamStats(BND_TEAM_RATING)
    self:_publishTeamStats(BND_TEAM_OVERALL)
  elseif bindingName == BND_TEAM_NAME then
    self.im.Publish(BND_TEAM_NAME, self.loc.LocalizeString("TeamName_Abbr15_" .. self.teamID))
  elseif bindingName == BND_TEAM_CREST then
    self.im.Publish(BND_TEAM_CREST, {
      name = "$Crest",
      id = self.teamID
    })
  elseif bindingName == BND_TEAM_MAN then
    local ManagerObj = {
      name = "$ManagerCard",
      id = 0
    }
    ManagerObj.id = self.teamID
    self.im.Publish(BND_TEAM_MAN, ManagerObj)
    
  elseif bindingName == BND_TEAM_RATING then
    self.im.Publish(BND_TEAM_RATING, self.teamInfo.starRating)
  elseif bindingName == BND_TEAM_OVERALL then
    self.im.Publish(BND_TEAM_OVERALL, self.teamInfo.overall)
  else
    print("[TeamManagementModel]: _publishTeamStats(): Estatística da equipe desconhecida.")
  end
  
end

function TeamManagementModel:_publishPlayerComparisonData()
  self.im.Publish(BND_PLAYER_COMPARISON_DATA, self.playerComparisonData)
end


function TeamManagementModel:_publishTeamRatingLabel()
  local ratingLabel = ("RATING:")
  ratingLabel = ratingLabel..""..tostring(self.teamInfo.overall)
  self.im.Publish(BND_TEAM_RATING_LABEL, ratingLabel)
end


function TeamManagementModel:showBio(positionIndex)
  print("[TeamManagementModel]: showBio(" .. (positionIndex or "nil") .. ")")
  local targetPlayers = {}
  for i, v in ipairs(self.players) do
    local player = TableUtil.shallowcopy(v)
    player.type = self.models.ItemModel:toFEType(player.CARD_TYPE, player.CARD_ID)
    table.insert(targetPlayers, player)
  end
  self.nav.Event(nil, "evt_show_player_bio", {targetPlayers = targetPlayers, targetPositionIndex = positionIndex})
end




function TeamManagementModel:finalize()
  print("[TeamManagementModel]: finalize()")
  self.models.ItemModel:finalize()
  self.models.FormationModel:finalize()
  self.im.UnregisterAction(ACT_SWAP_PLAYERS)
  self.im.UnregisterAction(ACT_COMPARE_PLAYERS)
  self.im.UnregisterAction(ACT_ITEM_SHOW_BIO)
  self.im.UnregisterAction(ACT_SEND_ITEM_DATA)
  
  self.im.Unsubscribe(BND_CHEMISTRY_MATRIX)
  self.im.Unsubscribe(BND_STARTING_11)
  self.im.Unsubscribe(BND_SUBS_AND_RES)
  self.im.Unsubscribe(BND_TEAM_NAME)
  self.im.Unsubscribe(BND_TEAM_CREST)
  self.im.Unsubscribe(BND_TEAM_MAN)
  self.im.Unsubscribe(BND_TEAM_RATING)
  self.im.Unsubscribe(BND_TEAM_RATING_LABEL)
  self.im.Unsubscribe(BND_TEAM_OVERALL)
  self.im.Unsubscribe(BND_PLAYER_COMPARISON_DATA)
  self.im.Unsubscribe(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE)
end
return TeamManagementModel




