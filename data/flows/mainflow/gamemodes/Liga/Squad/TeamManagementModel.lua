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
local ELIGIBLE_SQUAD_BINDING = "bnd_eligible_squad"

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
        local players = o.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)
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

    o.im.Subscribe(BND_CHEMISTRY_MATRIX, function()
        o:_publishChemistryMatrix()
        o:checkSquadEligibility()
    end)

    o.im.Subscribe(BND_STARTING_11, function()
        o:_publishStarting11()
        o:checkSquadEligibility()
    end)

    o.im.Subscribe(BND_SUBS_AND_RES, function()
        o:_publishSubsAndRes()
        o:checkSquadEligibility()
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

    o.im.Subscribe(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE, function() end)

    o.im.Subscribe(BND_PLAYER_COMPARISON_DATA, function()
        o:_publishPlayerComparisonData()
    end)

    o.im.Subscribe(ELIGIBLE_SQUAD_BINDING, function()
        o:_publishEligibleSquad()
    end)

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
    o:clearHelp()

    return o
end

function TeamManagementModel:clearHelp()
  if newSession == "yes" then
    newSession = "no"
  end
end

function TeamManagementModel:_compareData(itemData)
    -- Existing _compareData implementation...
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

    for index, player in ipairs(players) do
        player.type = ItemModel.TYPE_FIELD_PLAYER
        player.level = self.models.ItemModel:getItemLevelByRating(player.rating)
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

-- Remaining original functions (unchanged except for added eligibility checks where relevant)
function TeamManagementModel:comparePlayers(activePlayer, passivePlayer)
    -- Existing comparePlayers implementation...
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
  self:checkSquadEligibility()
end

function TeamManagementModel:getPlayerComparisonData(activePlayer, passivePlayer)
    -- Existing getPlayerComparisonData implementation...
    print("[TeamManagementModel: getPlayerComparisonData(activePlayer = " .. tostring(activePlayer) .. ", passivePlayer = " .. tostring(passivePlayer) .. "): Listing comparison data...")
    local comparisonData = {}
    local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)
    
    for _, player in ipairs(players) do
        if passivePlayer and player.playerName == passivePlayer.playerName then
            local suspensionStatus = isSuspended[player.playerName] or 0
            if suspensionStatus == 1 or suspensionStatus == 2 then
                comparisonData.attributes = {}
                comparisonData.activeStats = {}
                comparisonData.passiveStats = {}
                for i = 1, 3 do
                    comparisonData.attributes[i] = "nil"
                    comparisonData.activeStats[i] = "nil"
                    comparisonData.passiveStats[i] = "nil"
                end
                TableUtil.print(comparisonData)
                return comparisonData
            end
        end
    end

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
            comparisonData.activeStats[i] = activePlayer["stat" .. i] + 20
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
    -- Existing _publishStarting11 implementation...
    if self.players == nil then return end
    print("[TeamManagementModel]: _publishStarting11()")
    local starting11 = {}
    for _FORV_5_ = 1, MAX_STARTING do
        starting11[_FORV_5_] = self.players[_FORV_5_]
    end
    self.im.Publish(BND_STARTING_11, {data = starting11})
    self:checkSquadEligibility()
end

function TeamManagementModel:_publishSubsAndRes()
    -- Existing _publishSubsAndRes implementation...
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
    table.insert(subsAndRes, {label = ("SUB"), data = subs})
    if nRes > 0 then
        for i = 1, nRes do
            res[i] = self.players[i + MAX_STARTING + nSubs]
        end
        table.insert(subsAndRes, {label = ("RES"), data = res})
    end
    self.im.Publish(BND_SUBS_AND_RES, subsAndRes)
    self:checkSquadEligibility()
end

function TeamManagementModel:_publishChemistryMatrix()
    -- Existing _publishChemistryMatrix implementation...
    print("[TeamManagementModel]: _publishChemistryMatrix()")
    self.chemistryMatrix = self.services.FUTSquadManagementService.GetFormationLinks(self.models.FormationModel:getCurrentFormationID())
    for _FORV_4_, _FORV_5_ in ipairs(self.chemistryMatrix) do
        _FORV_5_.PLAYER_LINKSTRENGTH = -1
    end
    self.im.Publish(BND_CHEMISTRY_MATRIX, {
        formation = self.models.FormationModel:getCurrentFormation(),
        chemistryLinks = self.chemistryMatrix
    })
    self:checkSquadEligibility()
end

function TeamManagementModel:_publishTeamStats(bindingName)
    -- Existing _publishTeamStats implementation...
    if bindingName == nil then
        self:_publishTeamStats(BND_TEAM_NAME)
        self:_publishTeamStats(BND_TEAM_CREST)
        self:_publishTeamStats(BND_TEAM_RATING)
        self:_publishTeamStats(BND_TEAM_OVERALL)
    elseif bindingName == BND_TEAM_NAME then
        self.im.Publish(BND_TEAM_NAME, self.loc.LocalizeString("TeamName_Abbr15_" .. self.teamID))
    elseif bindingName == BND_TEAM_CREST then
        self.im.Publish(BND_TEAM_CREST, {name = "$Crest", id = self.teamID})
    elseif bindingName == BND_TEAM_MAN then
        local ManagerObj = {name = "$ManagerCard", id = 0}
        ManagerObj.id = self.teamID
        self.im.Publish(BND_TEAM_MAN, ManagerObj)
    elseif bindingName == BND_TEAM_RATING then
        self.im.Publish(BND_TEAM_RATING, self.teamInfo.starRating)
    elseif bindingName == BND_TEAM_OVERALL then
        self.im.Publish(BND_TEAM_OVERALL, self.teamInfo.overall)
    else
        print("[TeamManagementModel]: _publishTeamStats(): Team stat unknown.")
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
    -- Existing showBio implementation...
    print("[TeamManagementModel]: showBio(" .. (positionIndex or "nil") .. ")")
    local targetPlayers = {}
    for i, v in ipairs(self.players) do
        local player = TableUtil.shallowcopy(v)
        player.type = self.models.ItemModel:toFEType(player.CARD_TYPE, player.CARD_ID)
        table.insert(targetPlayers, player)
    end
    self.nav.Event(nil, "evt_show_player_bio", {targetPlayers = targetPlayers, targetPositionIndex = positionIndex})
end

function TeamManagementModel:Small()
    -- Existing Small implementation...
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

-- [Previous code remains unchanged until finalize()]

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
    self.im.Unsubscribe(ELIGIBLE_SQUAD_BINDING)
    
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