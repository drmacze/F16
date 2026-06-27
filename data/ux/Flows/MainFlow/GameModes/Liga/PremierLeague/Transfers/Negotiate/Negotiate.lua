-- Mod By MVN PROD --
-- League Mode Division --

local Liga = {}

-- Constants
local PRICEMIN, PRICEMAX, WAGEMIN, WAGEMAX, TVALUE = nil, nil, nil, nil, nil, nil, nil
local ID_MIN_BID, ID_MAX_BID, ID_MIN_BUY, ID_MAX_BUY = 1, 2, 3, 4, 5, 6
local BND_MIN_BID, BND_MAX_BID, BND_MIN_BUY, BND_MAX_BUY = "bnd_min_bid", "bnd_max_bid", "bnd_min_buy", "bnd_max_buy"
local ACT_AMOUNT_DECREASE, ACT_AMOUNT_INCREASE = "act_amount_decrease", "act_amount_increase"
local ACT_SEARCH, ACT_RESET = "act_search", "act_reset"
local MAX_VALUE, MIN_VALUE = 200000000, 1
local BND_MATCH_LIST, ACT_ADVANCE = "bnd_match_list", "act_advance"

local ligaId = 1

local currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

local rivalListData = {}
local matchesPlayed = 0

-- Helper functions
local function adjustBid(currentBid, increment, step)
  local newBid = math.floor(currentBid / step) * step + increment
  return math.max(MIN_VALUE, math.min(newBid, MAX_VALUE))
end

function Liga:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
  }

  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o:Init()
  
  o.playerData = {
    homeTeamCrest = { name = "$Crest", id = GLOBAL_TEAMBUY },
    player = { name = "$Head", id = GLOBAL_PLAYERINSTALL }
  }
  
  o.amountMinBid, o.amountMaxBid, o.amountMinBuy, o.amountMaxBuy = MIN_VALUE, MIN_VALUE, MIN_VALUE, MIN_VALUE
  
  o:addDataBindings()
  o:addChangeBidValueActions()
  o:addSearchActions()
  o:publishPlayerCount()
  o:updatePricePlaceholders()
  o:subscribeEvents()

  return o
end

-- Initialization
function Liga:Init()
  for _, match in ipairs(LigaGrouping[ligaId]) do
    table.insert(rivalListData, {
      homeID = match[1], awayID = match[2], homeScore = match[4], awayScore = match[5],
      homeScorers = match.data.homeScorers, awayScorers = match.data.awayScorers,
      clickAction = ACT_ADVANCE, isUnlock = match[9], data = {}
    })
  end
end

-- Event subscriptions
function Liga:subscribeEvents()
  local function publishMatchLabel() self:publishMatchLabel() end
  local events = {
    "bnd_teamname_label", "bnd_teamstats_label", "bnd_status_label", 
    "bnd_transfervalue_label", "bnd_team_logo", "bnd_player_head", 
    "bnd_teammp_label", "bnd_finish_label", BND_MATCH_LIST
  }
  
  for _, event in ipairs(events) do
    self.im.Subscribe(event, publishMatchLabel)
  end
  
  self.im.RegisterAction(ACT_ADVANCE, function(_, data) self:PlayMatch(data) end)
end

-- Data Binding
function Liga:addDataBindings()
  local function updateBinding(bnd, value)
    self.im.Publish(bnd, { value = 1, locValue = self.loc.LocalizeInteger(value) })
    self:updatePricePlaceholders()
  end

  self.im.Subscribe(BND_MIN_BID, function() updateBinding(BND_MIN_BID, self.amountMinBid) end)
  self.im.Subscribe(BND_MAX_BID, function() updateBinding(BND_MAX_BID, TVALUE) end)
  self.im.Subscribe(BND_MIN_BUY, function() updateBinding(BND_MIN_BUY, self.amountMinBuy) end)
  self.im.Subscribe(BND_MAX_BUY, function() updateBinding(BND_MAX_BUY, self.amountMaxBuy) end)
end

-- Bid value changes
function Liga:addChangeBidValueActions()
  self.im.RegisterAction(ACT_AMOUNT_DECREASE, function(actionName, id)
    local binding = ""
    if id == ID_MIN_BID then
      self.amountMinBid = adjustBid(self.amountMinBid, -50000, 50000)
      binding = BND_MIN_BID
    elseif id == ID_MAX_BID then
      self.amountMaxBid = adjustBid(self.amountMaxBid, -1000000, 1000000)
      binding = BND_MAX_BID
    elseif id == ID_MIN_BUY then
      self.amountMinBuy = adjustBid(self.amountMinBuy, -100000, 100000)
      binding = BND_MIN_BUY
    elseif id == ID_MAX_BUY then
      self.amountMaxBuy = adjustBid(self.amountMaxBuy, -500000, 500000)
      WAGEMAX = self.amountMaxBuy
      binding = BND_MAX_BUY
    end
    self:publishAmountSelector(binding)
    self:publishPlayerCount()
    self:findPlayerInfo(GLOBAL_PLAYERINSTALL, GLOBAL_TEAMBUY)
    self:publishMatchLabel()  -- Update match label after any bid change
  end)

  self.im.RegisterAction(ACT_AMOUNT_INCREASE, function(actionName, id)
    local binding = ""
    if id == ID_MIN_BID then
      self.amountMinBid = adjustBid(self.amountMinBid, 50000, 50000)
      binding = BND_MIN_BID
    elseif id == ID_MAX_BID then
      self.amountMaxBid = adjustBid(self.amountMaxBid, 1000000, 1000000)
      binding = BND_MAX_BID
    elseif id == ID_MIN_BUY then
      self.amountMinBuy = adjustBid(self.amountMinBuy, 100000, 100000)
      binding = BND_MIN_BUY
    elseif id == ID_MAX_BUY then
      self.amountMaxBuy = adjustBid(self.amountMaxBuy, 500000, 500000)
      WAGEMAX = self.amountMaxBuy
      binding = BND_MAX_BUY
    end
    self:publishAmountSelector(binding)
    self:publishPlayerCount()
    self:findPlayerInfo(GLOBAL_PLAYERINSTALL, GLOBAL_TEAMBUY)
    self:publishMatchLabel()  -- Update match label after any bid change
  end)
end

-- Search actions
function Liga:addSearchActions()
  self.im.RegisterAction(ACT_SEARCH, function() self:search() end)
  self.im.RegisterAction(ACT_RESET, function() self:resetAllFilters() end)
end

-- Placeholder management
function Liga:updatePricePlaceholders()
  PRICEMIN, PRICEMAX, WAGEMIN, WAGEMAX = self.amountMinBid, self.amountMaxBid, self.amountMinBuy, self.amountMaxBuy
  TVALUE = self.amountMaxBid + self.amountMinBid
end

-- Cleanup
function Liga:finalize()
  local toUnregister = {ACT_ADVANCE, ACT_AMOUNT_DECREASE, ACT_AMOUNT_INCREASE, ACT_SEARCH, ACT_RESET}
  local toUnsubscribe = {BND_MATCH_LIST, BND_MIN_BID, BND_MAX_BID, BND_MIN_BUY, BND_MAX_BUY, 
                         "bnd_teamname_label", "bnd_teamstats_label", "bnd_status_label", 
                         "bnd_transfervalue_label", "bnd_team_logo", "bnd_player_head", 
                         "bnd_teammp_label", "bnd_finish_label"}

  for _, action in ipairs(toUnregister) do
    self.im.UnregisterAction(action)
  end
  for _, binding in ipairs(toUnsubscribe) do
    self.im.Unsubscribe(binding)
  end
  rivalListData = {}
end

-- Player and Match Management
function Liga:publishMatchLabel()
  local wins, draws, losses = GetTeamWins(currentSelectedTeamID), GetTeamDraws(currentSelectedTeamID), GetTeamLosses(currentSelectedTeamID)
  WINS, DRAWS, LOSSES = wins, draws, losses

  local matchesPlayed = GLOBAL_MATCHUP_COUNT or (wins + draws + losses)
  local winPercentage = matchesPlayed > 0 and (wins / matchesPlayed) * 100 or 0
  winPercentage = string.format("%.2f", winPercentage)

  local space = "                                                    "
  local statsLabel = wins .. space .. draws .. space .. "   " .. losses
  

  self.im.Publish("bnd_teamname_label", "")
  self.im.Publish("bnd_teamstats_label", statsLabel)
  self.im.Publish("bnd_team_logo", self.playerData.homeTeamCrest)
  self.im.Publish("bnd_player_head", self.playerData.player)
  if playerInfo then
    self.im.Publish("bnd_teammp_label", "player replacement count is " .. COUNT .. "the player index is " .. PLAYERINDEX)
  else
    self.im.Publish("bnd_teammp_label", "")
  end
  self.im.Publish("bnd_status_label", "")
  self.im.Publish("bnd_transfervalue_label", "€" .. "1,000,000")
end

function Liga:publishPlayerCount()
  local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, GLOBAL_TEAMBUY, 0)
  local replacementCount = 0
  
  if players then
    -- Find the player's position first
    local playerInfo = self:findPlayerInfo(GLOBAL_PLAYERINSTALL, GLOBAL_TEAMBUY)
    if playerInfo then
      local playerPosition = playerInfo.position
      
      -- Count players with the same position but not in the starting lineup
      for index = 12, #players do  -- Start from 12 to avoid starting lineup
        local player = players[index]
        if player.position == playerPosition then
          replacementCount = replacementCount + 1
        end
      end
    end
  end
  
  self.im.Publish("bnd_status_label", replacementCount .. " replacements for playerID " .. GLOBAL_PLAYERINSTALL .. " in teamID " .. GLOBAL_TEAMBUY)
  COUNT = replacementCount
end

function Liga:findPlayerInfo(playerID, teamID)
  local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
  
  if players then
    for index, player in ipairs(players) do
      if player.CARD_ID == playerID then
        return { index = index, position = player.position }
      end
    end
  end

  return nil
end

function Liga:swapPlayersInTeam(teamID, cardIDToSwap)
  local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
  
  if not players or #players == 0 then
    print("[Restart]: No players found for teamID " .. teamID)
    return
  end

  local playerToSwap, playerToSwapIndex, playerPositionToMatch = nil, nil, nil
  
  for index, player in ipairs(players) do
    if player.CARD_ID == cardIDToSwap then
      playerToSwap, playerToSwapIndex, playerPositionToMatch = player, index, player.position
      break
    end
  end

  if not playerToSwap then
    print("[Restart]: Player with CARD_ID " .. cardIDToSwap .. " not found in teamID " .. teamID)
    return
  end

  -- Look for a player outside of indices 1-11 with the same position
  for index = 12, #players do  -- Start from 12 to avoid starting lineup
    local player = players[index]
    if player.position == playerPositionToMatch then
      -- Swap players
      players[playerToSwapIndex], players[index] = players[index], players[playerToSwapIndex]
      
      local updatedPlayerIDs = {}
      for _, player in ipairs(players) do
        table.insert(updatedPlayerIDs, player.CARD_ID)
      end
      self.services.SquadManagementService.SetCurrentPlayerLineup(0, teamID, 0, 0, updatedPlayerIDs)
      
      print("[Restart]: Swapped player " .. cardIDToSwap .. " with player " .. players[playerToSwapIndex].CARD_ID .. " in teamID " .. teamID)
      return  
    end
  end

  print("[Restart]: No player outside starting lineup found with position " .. playerPositionToMatch .. " to swap with CARD_ID " .. cardIDToSwap .. " in teamID " .. teamID)
end

-- Match Play
function Liga:PlayMatch(data)
  local currentMatchIndex = data.id + 1
  currentLigaData.Index = ligaId
  currentLigaData.round = currentMatchIndex
  local currentMatchData = LigaGrouping[ligaId][currentMatchIndex]
  
  local index = 0
  if currentMatchData[6] == false and currentMatchData[9] == true then
    index = 1
  elseif currentMatchData[6] == true and currentMatchData[9] == true then
    index = 2
  elseif currentMatchData[6] == true and currentMatchData[8] == false and currentMatchData[9] == true then
    index = 2
  end

  if index == 1 then
    currentLigaData.homeID, currentLigaData.awayID = currentLigaInfo[ligaId].homeID, currentMatchData[2]
    currentLigaData.difficulty = currentMatchData[7]
    currentMatch.HomeTeamID, currentMatch.AwayTeamID = currentLigaData.homeID, currentLigaData.awayID
    self:KickOff()
    matchesPlayed = matchesPlayed + 1
  elseif index == 2 then
    currentLigaData.homeID, currentLigaData.awayID = currentLigaInfo[ligaId].homeID, currentMatchData[2]
    currentLigaData.difficulty = currentMatchData[7]
    currentMatch.HomeTeamID, currentMatch.AwayTeamID = currentLigaData.homeID, currentLigaData.awayID
  else
    self:StopMatch()
  end
end

-- Search and Reset
function Liga:search()
  self:publishPlayerCount()
  if WAGEMAX >= 1000000 then
    if COUNT < 1 then
      self:Failed()
    else
      self:Successful()
      self:clearSlot()
    end
  else
    self.im.Publish("bnd_status_label", self.loc.LocalizeString("TeamName_Abbr15_" .. GLOBAL_TEAMBUY) .. " are not impressed by your offer")
  end
end

function Liga:resetAllFilters()
  self.amountMinBid, self.amountMaxBid, self.amountMinBuy, self.amountMaxBuy = MIN_VALUE, MIN_VALUE, MIN_VALUE, MIN_VALUE
  self:publishAmountSelector()
  self:updatePricePlaceholders()
end

function Liga:publishAmountSelector(bindingName)
  if bindingName == nil then
    self:publishAmountSelector(BND_MIN_BID)
    self:publishAmountSelector(BND_MAX_BID)
    self:publishAmountSelector(BND_MIN_BUY)
    self:publishAmountSelector(BND_MAX_BUY)
  else
    self.im.Refresh(bindingName)
  end
end

function Liga:clearSlot()
  if SCOUTINDEX == 1 then
    SLOTTM1, SLOTPL1 = nil, nil
  elseif SCOUTINDEX == 2 then
    SLOTTM2, SLOTPL2 = nil, nil
  elseif SCOUTINDEX == 3 then
    SLOTTM3, SLOTPL3 = nil, nil
  elseif SCOUTINDEX == 4 then
    SLOTTM4, SLOTPL4 = nil, nil
  elseif SCOUTINDEX == 5 then
    SLOTTM5, SLOTPL5 = nil, nil
  elseif SCOUTINDEX == 6 then
    SLOTTM6, SLOTPL6 = nil, nil
  elseif SCOUTINDEX == 7 then
    SLOTTM7, SLOTPL7 = nil, nil
  elseif SCOUTINDEX == 8 then
    SLOTTM8, SLOTPL8 = nil, nil
  elseif SCOUTINDEX == 9 then
    SLOTTM9, SLOTPL9 = nil, nil
  elseif SCOUTINDEX == 10 then
    SLOTTM10, SLOTPL10 = nil, nil
  end
end

-- Success and Failure Scenarios
function Liga:Failed()
  local buttonYes = {
    icon = "",
    label = " CLOSE *",
    clickEvents = {"evt_back", "evt_hide_popup"}
  }
  local popupData = {
    title = "TRANSFERS FAILED",
    message = " THE PLAYER CHOOSE TO STAY IN " .. self.loc.LocalizeString("TeamName_Abbr15_" .. GLOBAL_TEAMBUY),
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:Successful()
  local buttonYes = {
    icon = "$IconButton_X",
    label = "LTXT_CMN_OK",
    clickEvents = {"evt_hide_popup"}
  }
  local popupData = {
    title = "TRANSFER SUCCESSFUL",
    message = " PLAYER HAS JOINED UP WITH THE TEAM *",
    buttons = {buttonYes}
  }
  
  self.nav.Event(nil, "evt_show_popup", popupData)
  
  local playerInfo = self:findPlayerInfo(GLOBAL_PLAYERINSTALL, GLOBAL_TEAMBUY)
  if playerInfo and playerInfo.index >= 1 and playerInfo.index <= 11 then
    self:swapPlayersInTeam(GLOBAL_TEAMBUY, GLOBAL_PLAYERINSTALL)
    transferPlayer(GLOBAL_PLAYERINSTALL, GLOBAL_TEAMBUY, currentSelectedTeamID)
  else
    transferPlayer(GLOBAL_PLAYERINSTALL, GLOBAL_TEAMBUY, currentSelectedTeamID)
  end
end

return Liga