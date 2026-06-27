-- MOD By MounTsa
local ItemModel, TableUtil, FormationModel = ...
local MAX_STARTING = 11
local TeamManagementModel = {}
local BND_AWAYCHEMISTRY_MATRIX = "bnd_awaychemistry_matrix"
local BND_AWAYSTARTING_11 = "bnd_awaystarting_11"
local BND_AWAYSUBS_AND_RES = "bnd_awaysubs_and_res"
local BND_AWAYSBS_AND_RES = "bnd_awaysbs_and_res"
local BND_AWAYRESERVES_ONLY = "bnd_awayreserves_only"
local BND_AWAYTEAM_NAME = "bnd_awayteam_name"
local BND_AWAYTEAM_CREST = "bnd_awayteam_crest"
local BND_AWAYTEAM_MAN = "bnd_awayteam_man"
local BND_AWAYTEAM_RATING = "bnd_awayteam_rating"
local BND_AWAYTEAM_RATING_LABEL = "bnd_awayteam_rating_label"
local BND_AWAYTEAM_OVERALL = "bnd_awayteam_overall"
local BND_AWAYPLAYER_COMPARISON_DATA = "bnd_awayplayer_comparison_data"
local ACT_ITEM_SHOW_BIO = "act_item_show_bio"
local ACT_SWAP_PLAYERS = "act_swap_players"
local ACT_COMPARE_PLAYERS = "act_compare_players"
local BND_AWAYITEM_COLLECTION_CONTEXT_MENU_VISIBLE = "bnd_awaycontext_menu_visible"
local ACT_SWAP_WITH_INVENTORY = "act_swap_with_inventory"
local ACT_ITEM_SWAP_WITH_CLUB = "act_item_swap_with_club"
local ACT_ITEM_REMOVE_FROM_SQUAD = "act_item_remove_from_squad"
local ACT_ITEM_SEND_TO_TRADE_PILE = "act_item_send_to_trade_pile"
local ACT_ITEM_APPLY_CONSUMABLE = "act_item_apply_consumable"
local ACT_ITEM_QUICK_SELL = "act_item_quick_sell"
local ACT_ITEM_QUICK_LIST = "act_item_quick_list"
local ACT_SEND_ITEM_DATA = "act_send_item_data"
local ELIGIBLE_SQUAD_BINDING = "bnd_awayeligible_squad"
local BND_AWAYPLAYER_RATING = "bnd_awayplayer_rating"
local BND_AWAYPLAYER_AVATAR = "bnd_awayplayer_avatar"
local BND_AWAYACTIVE_PLAYER_VISIBLE = "bnd_awayactive_player_visible"
local BND_AWAYPASSIVE_PLAYER_VISIBLE = "bnd_awaypassive_player_visible"
local attributeNames = { "PAC", "SHO", "PAS", "DRI", "DEF", "PHY" }
local NOTICE = "bnd_awayswap_notification"
local BND_AWAYSWAP_LABEL1 = "bnd_awayswap_label1"
local BND_AWAYSWAP_LABEL2 = "bnd_awayswap_label2"
local BND_AWAYSWAP_LABEL3 = "bnd_awayswap_label3"
local BND_AWAYSWAP_LABEL4 = "bnd_awayswap_label4"
local BND_AWAYSWAP_LABEL5 = "bnd_awayswap_label5"
local BND_AWAYSWAP_LABEL6 = "bnd_awayswap_label6"
local BND_AWAYACTIVE_STAT_PREFIX = "bnd_awayactive_stat_"
local BND_AWAYPASSIVE_STAT_PREFIX = "bnd_awaypassive_stat_"
-- Warna dalam format HEX
local BND_AWAYACTIVE_STAT_COLOR_PREFIX = "bnd_awayactive_stat_color_"
local BND_AWAYPASSIVE_STAT_COLOR_PREFIX = "bnd_awaypassive_stat_color_"
local COLOR_RED = 0xFF0000     -- Merah untuk stat 50-70
local COLOR_ORANGE = 0xFFA500  -- Orange untuk stat 70-81
local COLOR_GREEN = 0x00FF00   -- Hijau untuk stat >81
local COLOR_DEFAULT = 0xFFFFFF -- Putih untuk nilai default

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
    o.teamID = currentSelectedTeamID
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
    o.eligibleSquad = 0 -- Initialize eligibleSquad
    o:checkSquadEligibility() -- Initial check

    if TMODE == 1 then
        local players = o.services.SquadManagementService.GetCurrentPlayerLineup(1, currentSelectedTeamID, 0)
        local found = false
        for _, player in ipairs(players) do
            if player.CARD_ID == GLOBAL_PLAYERIN then
                found = true
                break
            end
        end
        if found then
            SUCCESS = 1
        else
            SUCCESS = 2
        end
    end

    o.im.Subscribe(BND_AWAYCHEMISTRY_MATRIX, function()
        o:_publishChemistryMatrix()
        o:checkSquadEligibility()
    end)

    o.im.Subscribe(BND_AWAYSTARTING_11, function()
        o:_publishStarting11()
        o:checkSquadEligibility()
    end)

    o.im.Subscribe(BND_AWAYSUBS_AND_RES, function()
        o:_publishSubsAndRes()
        o:checkSquadEligibility()
    end)
    
    o.im.Subscribe(BND_AWAYRES, function()
        o:_publishRes()
        o:checkSquadEligibility()
    end)
    
    o.im.Subscribe(BND_AWAYSBS_AND_RES, function()
    o:_publishSbsAndRes()
    o:checkSquadEligibility()
  end)

    o.im.Subscribe(BND_AWAYTEAM_NAME, function()
        o:_publishTeamStats(BND_AWAYTEAM_NAME)
    end)

    o.im.Subscribe(BND_AWAYTEAM_CREST, function()
        o:_publishTeamStats(BND_AWAYTEAM_CREST)
    end)

    o.im.Subscribe(BND_AWAYTEAM_MAN, function()
        o:_publishTeamStats(BND_AWAYTEAM_MAN)
    end)

    o.im.Subscribe(BND_AWAYTEAM_RATING, function()
        o:_publishTeamStats(BND_AWAYTEAM_RATING)
    end)

    o.im.Subscribe(BND_AWAYTEAM_RATING_LABEL, function()
        o:_publishTeamRatingLabel()
    end)

    o.im.Subscribe(BND_AWAYTEAM_OVERALL, function()
        o:_publishTeamStats(BND_AWAYTEAM_OVERALL)
    end)

    o.im.Subscribe(BND_AWAYITEM_COLLECTION_CONTEXT_MENU_VISIBLE, function() end)

    o.im.Subscribe(BND_AWAYPLAYER_COMPARISON_DATA, function()
        o:_publishPlayerComparisonData()
    end)

    o.im.Subscribe(ELIGIBLE_SQUAD_BINDING, function()
        o:_publishEligibleSquad()
    end)
  o.im.Subscribe("bnd_awayactive_player_rating", function() end)
  o.im.Subscribe("bnd_awaypassive_player_rating", function() end)
  o.im.Subscribe("bnd_awayactive_player_avatar", function() end)
  o.im.Subscribe("bnd_awaypassive_player_avatar", function() end)
  o.im.Subscribe("bnd_awayswap1_active", function() end)
  o.im.Subscribe("bnd_awayswap2_active", function() end)
  o.im.Subscribe("bnd_awayswap3_active", function() end)
  o.im.Subscribe("bnd_awayswap1_passive", function() end)
  o.im.Subscribe("bnd_awayswap2_passive", function() end)
  o.im.Subscribe("bnd_awayswap3_passive", function() end)
  o.im.Subscribe("bnd_awayactive_player_name", function() end)
  o.im.Subscribe("bnd_awaypassive_player_name", function() end)
  o.im.Subscribe("bnd_awayactive_player_position", function() end)
  o.im.Subscribe("bnd_awaypassive_player_position", function() end)
  o.im.Subscribe("bnd_awayswap_notification", function() end)
  o.im.Subscribe("bnd_awayswap_label1", function() end)
  o.im.Subscribe("bnd_awayswap_label2", function() end)
  o.im.Subscribe("bnd_awayswap_label3", function() end)
  o.im.Subscribe("bnd_awayswap_label4", function() end)
  o.im.Subscribe("bnd_awayswap_label5", function() end)
  o.im.Subscribe("bnd_awayswap_label6", function() end)
  o.im.Subscribe("bnd_awayswap_label7", function() end)
  o.im.Subscribe(BND_AWAYACTIVE_PLAYER_VISIBLE, function() end)
  o.im.Subscribe(BND_AWAYPASSIVE_PLAYER_VISIBLE, function() end)

    o.im.RegisterAction(ACT_ITEM_SHOW_BIO, function(actionName, uniqueID)
        o:showBio(uniqueID.groupID)
    end)

    o.im.RegisterAction(ACT_SWAP_PLAYERS, function(actionName, data)
        o:swapPlayersByIndex(data.activeIndex, data.passiveIndex)
        o:checkSquadEligibility()
    end)

    o.im.RegisterAction(ACT_COMPARE_PLAYERS, function(actionName, data)
        o:comparePlayers(data.activePlayer, data.passivePlayer)
    end)

    o.im.RegisterAction(ACT_SEND_ITEM_DATA, function(actionName, data)
        o:_compareData(data)
    end)
    for i = 1, 6 do
        o.im.Subscribe(BND_AWAYACTIVE_STAT_COLOR_PREFIX..i, function() end)
        o.im.Subscribe(BND_AWAYPASSIVE_STAT_COLOR_PREFIX..i, function() end)
    end
    for i = 1, 6 do
        o.im.Subscribe(BND_AWAYACTIVE_STAT_PREFIX..i, function() end)
        o.im.Subscribe(BND_AWAYPASSIVE_STAT_PREFIX..i, function() end)
    end
    o:clearHelp()

    return o
end

function TeamManagementModel:clearHelp()
  if newSession == "yes" then
    newSession = "no"
  end
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
            self.im.Publish(BND_AWAYITEM_COLLECTION_CONTEXT_MENU_VISIBLE, false)
        end
    }
    self.im.Publish(BND_AWAYITEM_COLLECTION_CONTEXT_MENU_VISIBLE, true)
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
function TeamManagementModel:_getStatColor(statValue)
    statValue = statValue or 0
    print(string.format("Getting color for stat value: %d", statValue))
    
    if statValue < 50 then
        return COLOR_DEFAULT
    elseif statValue >= 50 and statValue < 70 then
        return COLOR_RED
    elseif statValue >= 70 and statValue < 81 then
        return COLOR_ORANGE
    else
        return COLOR_GREEN
    end
end
function TeamManagementModel:getPlayers(teamID)
    print("[TeamManagementModel]: getPlayers()")
    local players = self.services.SquadManagementService.GetCurrentPlayerLineup(1, teamID, 0)

    for index, player in ipairs(players) do
        player.type = ItemModel.TYPE_FIELD_PLAYER
       -- player.rarity = self.models.ItemModel:getItemRarityByRating(player.rating)
        if isSuspended[player.CARD_ID] == 2 then
            player.position = "INJURED."
            player.level = self.models.ItemModel:getItemLevelByRating(player.rating)
        elseif isSuspended[player.CARD_ID] == 1 then
            player.position = "RED CARD."
            player.level = self.models.ItemModel:getItemLevelByRating(player.rating)
        end
    end

    self.players = players
    self:checkSquadEligibility()
    return players
end

function TeamManagementModel:checkSquadEligibility()
    print("[TeamManagementModel]: checkSquadEligibility()")
    
    if not self.players or #self.players == 0 then
        print("[TeamManagementModel]: No players available for eligibility check")
        self.eligibleSquad = 0
        SquadElig = self.eligibleSquad
        self:_publishEligibleSquad()
        return
    end

    local hasSuspendedPlayer = false
    for i = 1, math.min(18, #self.players) do
        local player = self.players[i]
        if player and player.playerName then
            if isSuspended[player.playerName] == 1 then
                print("[TeamManagementModel]: Found suspended player " .. player.playerName .. " at index " .. i)
                hasSuspendedPlayer = true
                break
            end
        else
            print("[TeamManagementModel]: Warning: Invalid player data at index " .. i)
        end
    end

    self.eligibleSquad = hasSuspendedPlayer and 1 or 0
    SquadElig = self.eligibleSquad
    print("[TeamManagementModel]: Squad eligibility status: " .. self.eligibleSquad)
    self:_publishEligibleSquad()
end

function TeamManagementModel:_publishEligibleSquad()
    print("[TeamManagementModel]: _publishEligibleSquad() - Status: " .. self.eligibleSquad)
    self.im.Publish(ELIGIBLE_SQUAD_BINDING, {
        eligibleSquad = self.eligibleSquad,
        teamID = self.teamID,
        timestamp = os.time()
    })
end

function TeamManagementModel:comparePlayers(activePlayer, passivePlayer)
    self:clearPlayerVisibility()
    if activePlayer or passivePlayer then
        if activePlayer then
            self.im.Publish("bnd_awayactive_player_name", activePlayer.playerName)
            self.im.Publish("bnd_awayactive_player_position", activePlayer.position)
            self.im.Publish("bnd_awayactive_player_rating", activePlayer.rating)
            self.im.Publish("bnd_awayactive_player_avatar", {
                name = "$Head",
                id = activePlayer.CARD_ID or 0
            })
            self:_publishPlayerStats(activePlayer, BND_AWAYACTIVE_STAT_PREFIX)
            self.im.Publish(BND_AWAYACTIVE_PLAYER_VISIBLE, true)
        end
        if passivePlayer then
            self.im.Publish("bnd_awaypassive_player_name", passivePlayer.playerName)
            self.im.Publish("bnd_awaypassive_player_position", passivePlayer.position)
            self.im.Publish("bnd_awaypassive_player_rating", passivePlayer.rating)
            self.im.Publish("bnd_awaypassive_player_avatar", {
                name = "$Head",
                id = passivePlayer.CARD_ID or 0
            })
            self:_publishPlayerStats(passivePlayer, BND_AWAYPASSIVE_STAT_PREFIX)
            self.im.Publish(BND_AWAYPASSIVE_PLAYER_VISIBLE, true)
        end
    end
    self.playerComparisonData = self:getPlayerComparisonData(activePlayer, passivePlayer)
    self:_publishPlayerComparisonData()
end

function TeamManagementModel:clearPlayerVisibility()
  self.im.Publish(BND_AWAYACTIVE_PLAYER_VISIBLE, false)
  self.im.Publish(BND_AWAYPASSIVE_PLAYER_VISIBLE, false)
  self:publishSwapAssets()
end

function TeamManagementModel:_publishPlayerStats(player, prefix)
    if not player then 
        for i = 1, 6 do
            self.im.Publish(prefix..i, 0)
            self.im.Publish(prefix.."color_"..i, COLOR_DEFAULT)
        end
        return 
    end
    for i = 1, 6 do
        local statValue = player["stat"..i] or 0
        local color = self:_getStatColor(statValue)
        print(string.format("Publishing %s stat %d: %d (color: %x)", 
              prefix, i, statValue, color))
        
        self.im.Publish(prefix..i, statValue)
        self.im.Publish(prefix.."color_"..i, color)
    end
end
function TeamManagementModel:publishSwapAssets()
  self.im.Publish("bnd_awayswap1_active", {
    name = "$Swap1",
    id = 0
  })
  self.im.Publish("bnd_awayswap2_passive", {
    name = "$Swap2",
    id = 0
  })
  self.im.Publish("bnd_awayswap3_active", {
    name = "$Swap3",
    id = 0
  })
    self.im.Publish("bnd_awayswap_label1", "OVR")
    self.im.Publish("bnd_awayswap_label2", "PAC")
    self.im.Publish("bnd_awayswap_label3", "SHOT")
    self.im.Publish("bnd_awayswap_label4", "PASS")
    self.im.Publish("bnd_awayswap_label5", "DRI")
    self.im.Publish("bnd_awayswap_label6", "DEF")
    self.im.Publish("bnd_awayswap_label7", "PHY")
    self.im.Publish("bnd_awayswap_notification", "OnlyFans MounTsa")
end

function TeamManagementModel:swapPlayersByIndex(activeIndex, passiveIndex)
    print("[TeamManagementModel]: swapPlayersByIndex{" .. activeIndex .. ", " .. passiveIndex .. "}")
    if not self.players[activeIndex + 1] or not self.players[passiveIndex + 1] then
        print("Invalid swap indices")
        return
    end
    local passivePlayer = self.players[passiveIndex + 1]
    local activePlayer = self.players[activeIndex + 1]
    
    self.players[passiveIndex + 1] = activePlayer
    self.players[activeIndex + 1] = passivePlayer

    self:clearPlayerVisibility()
  self:checkSquadEligibility()
end
function TeamManagementModel:_updateAfterSwap(activeIndex, passiveIndex)
    self:clearPlayerVisibility()
    local newActivePlayer = self.players[activeIndex + 1]
    local newPassivePlayer = self.players[passiveIndex + 1]
    if newActivePlayer then
        
        self.im.Publish("bnd_awayactive_player_name", newActivePlayer.playerName)
        self.im.Publish("bnd_awayactive_player_position", newActivePlayer.position)
        self.im.Publish("bnd_awayactive_player_rating", newActivePlayer.rating)
        self.im.Publish("bnd_awayactive_player_avatar", {
            name = "$Head",
            id = newActivePlayer.CARD_ID or 0
        })
        for i = 1, 6 do
            self.im.Publish(BND_AWAYACTIVE_STAT_PREFIX..i, newActivePlayer["stat"..i] or 0)
        end
        self.im.Publish(BND_AWAYACTIVE_PLAYER_VISIBLE, true)
    end
    if newPassivePlayer then
        self.im.Publish("bnd_awaypassive_player_name", newPassivePlayer.playerName)
        self.im.Publish("bnd_awaypassive_player_position", newPassivePlayer.position)
        self.im.Publish("bnd_awaypassive_player_rating", newPassivePlayer.rating)
        self.im.Publish("bnd_awaypassive_player_avatar", {
            name = "$Head",
            id = newPassivePlayer.CARD_ID or 0
        })
        for i = 1, 6 do
            self.im.Publish(BND_AWAYPASSIVE_STAT_PREFIX..i, newPassivePlayer["stat"..i] or 0)
        end
        self.im.Publish(BND_AWAYPASSIVE_PLAYER_VISIBLE, true)
    end
end
function TeamManagementModel:showPlayerComparison(show)
    if show then
        local activePlayer = self.currentActivePlayer
        local passivePlayer = self.currentPassivePlayer
        self:comparePlayers(activePlayer, passivePlayer)
    else
        self:clearPlayerVisibility()
    end
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

    local customLabels = {
      " ", 
      " ", 
      " ", 
      " ", 
      " ", 
      " "
    }
    
    for i = 1, 6 do

      comparisonData.attributes[i] = customLabels[i] -- Ganti activePlayer["label" .. i] dengan customLabels[i]
      comparisonData.activeStats[i] = activePlayer["stat" .. i]
      comparisonData.passiveStats[i] = passivePlayer["stat" .. i]
    end
  end
  TableUtil.print(comparisonData)
  return comparisonData
end

function TeamManagementModel:saveSquad()
    print("[TeamManagementModel]: saveSquad()")
    local playerIDs = {}
    for _FORV_5_ = 1, #self.players do
        playerIDs[_FORV_5_] = self.players[_FORV_5_].CARD_ID
    end
    sheets[SHEETID].players = playerIDs
    sheets[SHEETID].formationid = self.models.FormationModel:getCurrentFormationID()
    sheets[SHEETID].status = "filled"
    self.services.TacticsService.SetFormation(0, self.teamID, self.models.FormationModel:getCurrentFormationID())
    self:checkSquadEligibility()
end

function TeamManagementModel:_publishStarting11()
    if self.players == nil then return end
    print("[TeamManagementModel]: _publishStarting11()")
    local starting11 = {}
    for _FORV_5_ = 1, MAX_STARTING do
        starting11[_FORV_5_] = self.players[_FORV_5_]
    end
    self.im.Publish(BND_AWAYSTARTING_11, {data = starting11})
    self:checkSquadEligibility()
end

function TeamManagementModel:_publishSubsAndRes()
    if self.players == nil then return end
    print("[TeamManagementModel]: _publishSubsAndRes()")
    local nSubs
    if self.teamID == currentSelectedTeamID then
        if GLOBAL_DATE_PLACEHOLDER == "16/08/24" then
            nSubs = self.services.SquadManagementService.GetNumberOfSubs()
        else
            nSubs = self.services.SquadManagementService.GetNumberOfSubs()
        end
    elseif self.teamID == 9 then
        nSubs = self.services.SquadManagementService.GetNumberOfSubs()
    else
        nSubs = self.services.SquadManagementService.GetNumberOfSubs()
    end
    local nRes = self.services.SquadManagementService.GetNumberOfReserves(self.teamID)
    local subs = {}
    local res = {}
    local subsAndRes = {}
    for i = 1, nSubs do
        subs[i] = self.players[i + MAX_STARTING]
    end
    table.insert(subsAndRes, {label = (""), data = subs})
    if nRes > 0 then
        for i = 1, nRes do
            res[i] = self.players[i + MAX_STARTING + nSubs]
        end
        table.insert(subsAndRes, {label = (""), data = res})
    end
    self.im.Publish(BND_AWAYSUBS_AND_RES, subsAndRes)
    self:checkSquadEligibility()
end

function TeamManagementModel:_publishSbsAndRes()
    if self.players == nil then return end
    print("[TeamManagementModel]: _publishSbsAndRes()")
    local nSubs
    if self.teamID == currentSelectedTeamID then
        if GLOBAL_DATE_PLACEHOLDER == "16/08/24" then
            nSubs = self.services.SquadManagementService.GetNumberOfSubs()
        else
            nSubs = self.services.SquadManagementService.GetNumberOfSubs()
        end
    elseif self.teamID == 9 then
        nSubs = self.services.SquadManagementService.GetNumberOfSubs()
    else
        nSubs = self.services.SquadManagementService.GetNumberOfSubs()
    end
    local nRes = self.services.SquadManagementService.GetNumberOfReserves(self.teamID)
    local subs = {}
    local res = {}
    local sbsAndRes = {}
    for i = 1, nSubs do
        subs[i] = self.players[i + MAX_STARTING]
    end
    table.insert(sbsAndRes, {label = (""), data = subs})
    if nRes > 0 then
        for i = 1, nRes do
            res[i] = self.players[i + MAX_STARTING + nSubs]
        end
        table.insert(sbsAndRes, {label = (""), data = res})
    end
    self.im.Publish(BND_AWAYSBS_AND_RES, sbsAndRes)
    self:checkSquadEligibility()
end

function TeamManagementModel:_publishChemistryMatrix()
    print("[TeamManagementModel]: _publishChemistryMatrix()")
    self.chemistryMatrix = self.services.FUTSquadManagementService.GetFormationLinks(self.models.FormationModel:getCurrentFormationID())
    for _FORV_4_, _FORV_5_ in ipairs(self.chemistryMatrix) do
        _FORV_5_.PLAYER_LINKSTRENGTH = -1
    end
    self.im.Publish(BND_AWAYCHEMISTRY_MATRIX, {
        formation = self.models.FormationModel:getCurrentFormation(),
        chemistryLinks = self.chemistryMatrix
    })
    self:checkSquadEligibility()
end

function TeamManagementModel:_publishTeamStats(bindingName)
    if bindingName == nil then
        self:_publishTeamStats(BND_AWAYTEAM_NAME)
        self:_publishTeamStats(BND_AWAYTEAM_CREST)
        self:_publishTeamStats(BND_AWAYTEAM_RATING)
        self:_publishTeamStats(BND_AWAYTEAM_OVERALL)
    elseif bindingName == BND_AWAYTEAM_NAME then
        self.im.Publish(BND_AWAYTEAM_NAME, self.loc.LocalizeString("TeamName_Abbr15_" .. self.teamID))
    elseif bindingName == BND_AWAYTEAM_CREST then
        self.im.Publish(BND_AWAYTEAM_CREST, {name = "$Crest", id = self.teamID})
    elseif bindingName == BND_AWAYTEAM_MAN then
        local ManagerObj = {name = "$ManagerCard", id = 0}
        ManagerObj.id = self.teamID
        self.im.Publish(BND_AWAYTEAM_MAN, ManagerObj)
    elseif bindingName == BND_AWAYTEAM_RATING then
        self.im.Publish(BND_AWAYTEAM_RATING, self.teamInfo.starRating)
    elseif bindingName == BND_AWAYTEAM_OVERALL then
        self.im.Publish(BND_AWAYTEAM_OVERALL, self.teamInfo.overall)
    else
        print("[TeamManagementModel]: _publishTeamStats(): Team stat unknown.")
    end
end

function TeamManagementModel:_publishPlayerComparisonData()
    self.im.Publish(BND_AWAYPLAYER_COMPARISON_DATA, self.playerComparisonData)
end

function TeamManagementModel:_publishTeamRatingLabel()
    local ratingLabel = ("RATING:")
    ratingLabel = ratingLabel..""..tostring(self.teamInfo.overall)
    self.im.Publish(BND_AWAYTEAM_RATING_LABEL, ratingLabel)
end

function TeamManagementModel:showBio(positionIndex)
    print("[TeamManagementModel]: showBio(" .. (positionIndex or "nil") .. ")")
    local targetPlayers = {}
    for i, v in ipairs(self.players) do
        local player = TableUtil.shallowcopy(v)
        player.type = self.models.ItemModel:toFEType(player.CARD_TYPE, player.CARD_ID)
        table.insert(targetPlayers, player)
    end

    -- Publish player info for selected index (without name)
    local selectedPlayer = self.players[positionIndex + 1]
    if selectedPlayer then
        self.im.Publish("bnd_awayplayer_rating", selectedPlayer.rating)
        self.im.Publish("bnd_awayplayer_avatar", {
            name = "$Head",
            id = selectedPlayer.CARD_ID
        })
    end

    self.nav.Event(nil, "evt_show_player_bio", {
        targetPlayers = targetPlayers,
        targetPositionIndex = positionIndex
    })
end

function TeamManagementModel:_setPlayerVisibility(activeVisible, passiveVisible)
  self.im.Publish(BND_AWAYACTIVE_PLAYER_VISIBLE, activeVisible)
  self.im.Publish(BND_AWAYPASSIVE_PLAYER_VISIBLE, passiveVisible)
end
function TeamManagementModel:clearPlayerVisibility()
    self.im.Publish("bnd_awayactive_player_name", "")
    self.im.Publish("bnd_awayactive_player_position", "")
    self.im.Publish("bnd_awayactive_player_rating", 0)
    self.im.Publish("bnd_awayactive_player_avatar", {
        name = "$Head",
        id = 0
    })
    
    self.im.Publish("bnd_awaypassive_player_name", "")
    self.im.Publish("bnd_awaypassive_player_position", "")
    self.im.Publish("bnd_awaypassive_player_rating", 0)
    self.im.Publish("bnd_awaypassive_player_avatar", {
        name = "$Head",
        id = 0
    })
    for i = 1, 6 do
        self.im.Publish(BND_AWAYACTIVE_STAT_PREFIX..i, 0)
        self.im.Publish(BND_AWAYPASSIVE_STAT_PREFIX..i, 0)
        self.im.Publish(BND_AWAYACTIVE_STAT_COLOR_PREFIX..i, COLOR_DEFAULT)
        self.im.Publish(BND_AWAYPASSIVE_STAT_COLOR_PREFIX..i, COLOR_DEFAULT)
    end
    self.im.Publish(BND_AWAYACTIVE_PLAYER_VISIBLE, false)
    self.im.Publish(BND_AWAYPASSIVE_PLAYER_VISIBLE, false)
    self:publishSwapAssets()
end
function TeamManagementModel:Small()
    local buttonYes = {
        icon = "$FooterIconNo",
        label = "Close",
        clickEvents = {"evt_hide_popup"}
    }
    local popupData = {
        title = "SELECTION ERROR",
        message = "Player is injured",
        buttons = {buttonYes}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
end

function TeamManagementModel:finalize()
    print("[TeamManagementModel]: finalize()")
    self.models.ItemModel:finalize()
    self.models.FormationModel:finalize()
    self.im.UnregisterAction(ACT_SWAP_PLAYERS)
    self.im.UnregisterAction(ACT_COMPARE_PLAYERS)
    self.im.UnregisterAction(ACT_ITEM_SHOW_BIO)
    self.im.UnregisterAction(ACT_SEND_ITEM_DATA)    
    self.im.Unsubscribe(BND_AWAYCHEMISTRY_MATRIX)
    self.im.Unsubscribe(BND_AWAYSTARTING_11)
    self.im.Unsubscribe(BND_AWAYSUBS_AND_RES)
    self.im.Unsubscribe(BND_AWAYSBS_AND_RES)
    self.im.Unsubscribe(BND_AWAYRES)
    self.im.Unsubscribe(BND_AWAYRESERVES_ONLY)
    self.im.Unsubscribe(BND_AWAYTEAM_NAME)
    self.im.Unsubscribe(BND_AWAYTEAM_CREST)
    self.im.Unsubscribe(BND_AWAYTEAM_MAN)
    self.im.Unsubscribe(BND_AWAYTEAM_RATING)
    self.im.Unsubscribe(BND_AWAYTEAM_RATING_LABEL)
    self.im.Unsubscribe(BND_AWAYTEAM_OVERALL)
    self.im.Unsubscribe(BND_AWAYPLAYER_COMPARISON_DATA)
    self.im.Unsubscribe(BND_AWAYITEM_COLLECTION_CONTEXT_MENU_VISIBLE)
    self.im.Unsubscribe(ELIGIBLE_SQUAD_BINDING)
    self.im.Unsubscribe(BND_AWAYPLAYER_AVATAR)
    self.im.Unsubscribe(BND_AWAYPLAYER_RATING)
    self.im.Unsubscribe("bnd_awayactive_player_rating")
    self.im.Unsubscribe("bnd_awaypassive_player_rating")
    self.im.Unsubscribe("bnd_awayactive_player_avatar")
    self.im.Unsubscribe("bnd_awaypassive_player_avatar")
    self.im.Unsubscribe("bnd_awayswap1_active")
    self.im.Unsubscribe("bnd_awayswap2_active")
    self.im.Unsubscribe("bnd_awayswap3_active")
    self.im.Unsubscribe("bnd_awayswap1_passive")
    self.im.Unsubscribe("bnd_awayswap2_passive")
    self.im.Unsubscribe("bnd_awayswap3_passive")
    self.im.Unsubscribe(NOTICE)
    self.im.Unsubscribe(BND_AWAYSWAP_LABEL1)
    self.im.Unsubscribe(BND_AWAYSWAP_LABEL2)
    self.im.Unsubscribe(BND_AWAYSWAP_LABEL3)
    self.im.Unsubscribe(BND_AWAYSWAP_LABEL4)
    self.im.Unsubscribe(BND_AWAYSWAP_LABEL5)
    self.im.Unsubscribe(BND_AWAYSWAP_LABEL6)
    self.im.Unsubscribe(BND_AWAYACTIVE_PLAYER_VISIBLE)
    self.im.Unsubscribe(BND_AWAYPASSIVE_PLAYER_VISIBLE)
    -- Check for suspended players (isSuspended = 1 or 2) in indices 1-18
    local hasSuspendedPlayer = false
    for i = 1, math.min(18, #self.players) do
        local player = self.players[i]
        if player and player.playerName and (isSuspended[player.playerName] == 1 or isSuspended[player.playerName] == 2) then
            hasSuspendedPlayer = true
            break
        end
    end
    
    -- Only call Small() if there’s a suspended player
    if hasSuspendedPlayer then
        eligibilityStatus = 1
    else
        eligibilityStatus = 0
    end
end

-- [Rest of the code remains unchanged]
return TeamManagementModel