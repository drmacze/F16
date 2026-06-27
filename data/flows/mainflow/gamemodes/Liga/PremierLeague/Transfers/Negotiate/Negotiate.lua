-- @!League Management Module by DAVUNPES
-- A professional, extendable football league simulation framework

local League = {}

-- Configuration Constants
League.Config = {
    MinValue = 0,
    MaxValue = 200000000,
    BaseTransferValue = 15000000,
    BidAdjustments = {
        MinBid = { Id = 1, Step = 50000, Binding = "bnd_min_bid" },
        MaxBid = { Id = 2, Step = 1000000, Binding = "bnd_max_bid" },
        MinBuy = { Id = 3, Step = 100000, Binding = "bnd_min_buy" },
        MaxBuy = { Id = 4, Step = 500000, Binding = "bnd_max_buy" }
    },
    Actions = {
        DecreaseBid = "act_amount_decrease",
        IncreaseBid = "act_amount_increase",
        Search = "act_search",
        Reset = "act_reset",
        AdvanceMatch = "act_advance"
    },
    Bindings = {
        MatchList = "bnd_match_list",
        TeamName = "bnd_teamname_label",
        PlayerInfo = "bnd_player_info_label",
        PlayerHead = "bnd_player_head",
        PlayerName = "bnd_player_name_label",
        PlayerOverall = "bnd_player_overall_label",
        PlayerAge = "bnd_player_age_label",
        PlayerPosition = "bnd_player_position_label",
        Status = "bnd_status_label",
        TransferValue = "bnd_transfervalue_label",
        TeamLogo = "bnd_team_logo",
        TeamMatchProgress = "bnd_teammp_label",
        FinishLabel = "bnd_finish_label"
    }
}

-- Helper Functions
local function adjustBidValue(currentValue, increment, step)
    local newValue = math.floor(currentValue / step) * step + increment
    return math.max(League.Config.MinValue, math.min(newValue, League.Config.MaxValue))
end

-- Constructor
function League:new(options)
    local instance = options or {}
    setmetatable(instance, self)
    self.__index = self

    -- Services and Dependencies (with fallbacks)
    instance.api = instance.api or function(service) 
        print("Mock API call for:", service)
        return { GetCurrentOptions = function() return {} end, GetCurrentPlayerLineup = function() return {} end }
    end
    instance.services = {
        settings = instance.api("SettingsService"),
        squadManagement = instance.api("SquadMgtService")
    }
    instance.currentOptions = instance.services.settings.GetCurrentOptions()
    
    -- Interface Manager (with fallback)
    instance.im = instance.im or {
        Publish = function(binding, value) print("Publishing to", binding, ":", value) end,
        Subscribe = function(binding, fn) print("Subscribing to", binding) end,
        RegisterAction = function(action, fn) print("Registering action", action) end,
        Refresh = function(binding) print("Refreshing", binding) end,
        UnregisterAction = function(action) print("Unregistering action", action) end,
        Unsubscribe = function(binding) print("Unsubscribing from", binding) end
    }
    
    -- Localization (with fallback)
    instance.loc = instance.loc or { LocalizeInteger = function(num) return tostring(num) end, LocalizeString = function(str) return str end }
    
    -- Navigation (with fallback)
    instance.nav = instance.nav or { Event = function(_, evt, data) print("Nav event:", evt, data) end }

    -- Player and Team Visuals
    instance.teamVisuals = {
        crest = { name = "$Crest", id = GLOBAL_TEAMBUY or 1 },
        playerHead = { name = "$Head", id = GLOBAL_PLAYERINSTALL or 1001 }
    }
    
    -- State Initialization
    instance.bidValues = {
        minBid = League.Config.MinValue,
        maxBid = League.Config.MinValue,
        minBuy = League.Config.MinValue,
        maxBuy = League.Config.MinValue
    }
    instance.rejectionCount = 0
    instance.leagueId = 1
    instance.currentMatch = { homeTeamId = 0, awayTeamId = 0, homeKitIndex = 0, awayKitIndex = 1 }
    instance.rivalMatches = {}
    instance.matchesPlayed = 0
    instance.playerStats = { rating = 50, position = "CM", age = 25 }
    
    -- Initialize and Setup
    instance:initialize()
    instance:setupBindings()
    instance:setupBidActions()
    instance:setupSearchActions()
    instance:publishPlayerCount()
    instance:updateBidPlaceholders()
    instance:subscribeToEvents()
    instance:fetchPlayerStats()
    instance:publishMatchLabel() -- Ensure UI updates on initialization
    
    return instance
end

-- Initialization
function League:initialize()
    print("Initializing league...")
    for _, match in ipairs(LigaGrouping and LigaGrouping[self.leagueId] or {}) do
        table.insert(self.rivalMatches, {
            homeId = match[1], awayId = match[2],
            homeScore = match[4], awayScore = match[5],
            homeScorers = match.data and match.data.homeScorers or {},
            awayScorers = match.data and match.data.awayScorers or {},
            clickAction = League.Config.Actions.AdvanceMatch,
            isUnlocked = match[9],
            data = {}
        })
    end
end

-- Player Stats
function League:fetchPlayerStats()
    print("Fetching player stats...")
    local players = self.services.squadManagement.GetCurrentPlayerLineup(0, GLOBAL_TEAMBUY or 1, 0) or {}
    for _, player in ipairs(players) do
        if player.CARD_ID == (GLOBAL_PLAYERINSTALL or 1001) then
            self.playerStats.rating = player.rating or 50
            self.playerStats.position = player.position or "CM"
            self.playerStats.age = GetPlayerAge(GLOBAL_PLAYERINSTALL or 1001) or 25
            print("Player stats updated:", self.playerStats.rating, self.playerStats.position, self.playerStats.age)
            break
        end
    end
end

-- NEW: Publish player name, overall, age and position separadamente
-- Publica em: PlayerName, PlayerOverall, PlayerAge, PlayerPosition e PlayerInfo (composto)
function League:publishPlayerNameAndOverall(playerId, teamId)
    print("publishPlayerNameAndOverall called for", playerId, teamId)
    local playerName = nil
    local playerOverall = nil
    local playerAge = nil
    local playerPosition = nil

    -- Try to use getPlayerInfo if available
    if type(getPlayerInfo) == "function" then
        local pInfo = getPlayerInfo(playerId, teamId)
        if pInfo then
            playerName = pInfo.name or pInfo.displayName or pInfo.playerName or pInfo.fullName
            playerOverall = pInfo.rating or pInfo.overall or pInfo.ovr
            playerAge = pInfo.age or pInfo.years or pInfo.playerAge
            playerPosition = pInfo.position or pInfo.pos or pInfo.playPos or pInfo.playerPosition
        end
    end

    -- Fallback: procurar na linha do elenco
    if not playerName or not playerOverall or not playerAge or not playerPosition then
        local players = (self.services and self.services.squadManagement and self.services.squadManagement.GetCurrentPlayerLineup)
                        and self.services.squadManagement.GetCurrentPlayerLineup(0, teamId, 0) or {}
        for _, p in ipairs(players) do
            if p.CARD_ID == playerId then
                playerName = playerName or p.name or p.displayName or p.playerName or p.fullName
                playerOverall = playerOverall or p.rating or p.overall or p.ovr
                playerAge = playerAge or p.age or p.years or p.playerAge
                playerPosition = playerPosition or p.position or p.pos or p.playPos or p.playerPosition
                break
            end
        end
    end

    -- Try external helper GetPlayerAge if still missing
    if not playerAge and type(GetPlayerAge) == "function" then
        local ok, ageVal = pcall(function() return GetPlayerAge(playerId) end)
        if ok and ageVal then playerAge = ageVal end
    end

    -- Final fallbacks
    playerName = playerName or ("Player_" .. tostring(playerId))
    playerOverall = playerOverall or (self.playerStats and self.playerStats.rating) or 50
    playerAge = playerAge or (self.playerStats and self.playerStats.age) or 25
    playerPosition = playerPosition or (self.playerStats and self.playerStats.position) or "CM"

    -- Publish each piece separately
    self.im.Publish(League.Config.Bindings.PlayerName, tostring(playerName))
    self.im.Publish(League.Config.Bindings.PlayerOverall, tostring(playerOverall))
    self.im.Publish(League.Config.Bindings.PlayerAge, tostring(playerAge))
    self.im.Publish(League.Config.Bindings.PlayerPosition, tostring(playerPosition))

    -- Publish composed binding (PlayerInfo) for convenience
    local composed = tostring(playerName) .. " — OVR " .. tostring(playerOverall) .. " — Age " .. tostring(playerAge) .. " — " .. tostring(playerPosition)
    self.im.Publish(League.Config.Bindings.PlayerInfo, composed)

    print("Published PlayerName:", playerName, "PlayerOverall:", playerOverall, "PlayerAge:", playerAge, "PlayerPosition:", playerPosition)
end

-- Event Handling
function League:subscribeToEvents()
    print("Subscribing to events...")
    local eventBindings = {
        League.Config.Bindings.TeamName,
        League.Config.Bindings.PlayerInfo, -- composto (principal)
        League.Config.Bindings.PlayerName, League.Config.Bindings.PlayerOverall, League.Config.Bindings.PlayerAge, League.Config.Bindings.PlayerPosition, -- novos bindings
        League.Config.Bindings.Status, League.Config.Bindings.TransferValue,
        League.Config.Bindings.TeamLogo, League.Config.Bindings.PlayerHead,
        League.Config.Bindings.TeamMatchProgress, League.Config.Bindings.FinishLabel,
        League.Config.Bindings.MatchList
    }
    for _, binding in ipairs(eventBindings) do
        self.im.Subscribe(binding, function() self:publishMatchLabel() end)
    end
    self.im.RegisterAction(League.Config.Actions.AdvanceMatch, function(_, data) self:playMatch(data) end)
end

-- Data Bindings
function League:setupBindings()
    print("Setting up bindings...")
    local function publishBid(binding, value)
        self.im.Publish(binding, { value = 1, locValue = self.loc.LocalizeInteger(value) })
        self:updateBidPlaceholders()
    end
    self.im.Subscribe(League.Config.BidAdjustments.MinBid.Binding, function() publishBid(League.Config.BidAdjustments.MinBid.Binding, self.bidValues.minBid) end)
    self.im.Subscribe(League.Config.BidAdjustments.MaxBid.Binding, function() publishBid(League.Config.BidAdjustments.MaxBid.Binding, TVALUE or 0) end)
    self.im.Subscribe(League.Config.BidAdjustments.MinBuy.Binding, function() publishBid(League.Config.BidAdjustments.MinBuy.Binding, self.bidValues.minBuy) end)
    self.im.Subscribe(League.Config.BidAdjustments.MaxBuy.Binding, function() publishBid(League.Config.BidAdjustments.MaxBuy.Binding, self.bidValues.maxBuy) end)
end

-- Bid Adjustments
function League:setupBidActions()
    print("Setting up bid actions...")
    local function adjustBid(isIncrease, _, id)
        local config = League.Config.BidAdjustments
        local adjustment
        if id == config.MinBid.Id then
            adjustment = config.MinBid
            self.bidValues.minBid = adjustBidValue(self.bidValues.minBid, isIncrease and adjustment.Step or -adjustment.Step, adjustment.Step)
        elseif id == config.MaxBid.Id then
            adjustment = config.MaxBid
            self.bidValues.maxBid = adjustBidValue(self.bidValues.maxBid, isIncrease and adjustment.Step or -adjustment.Step, adjustment.Step)
        elseif id == config.MinBuy.Id then
            adjustment = config.MinBuy
            self.bidValues.minBuy = adjustBidValue(self.bidValues.minBuy, isIncrease and adjustment.Step or -adjustment.Step, adjustment.Step)
        elseif id == config.MaxBuy.Id then
            adjustment = config.MaxBuy
            self.bidValues.maxBuy = adjustBidValue(self.bidValues.maxBuy, isIncrease and adjustment.Step or -adjustment.Step, adjustment.Step)
            WAGEMAX = self.bidValues.maxBuy
        end
        self:publishAmountSelector(adjustment.Binding)
        self:publishPlayerCount()
        self:findPlayerInfo(GLOBAL_PLAYERINSTALL or 1001, GLOBAL_TEAMBUY or 1)
        self:publishMatchLabel()
    end
    
    self.im.RegisterAction(League.Config.Actions.DecreaseBid, function(actionName, id) adjustBid(false, actionName, id) end)
    self.im.RegisterAction(League.Config.Actions.IncreaseBid, function(actionName, id) adjustBid(true, actionName, id) end)
end

-- Search and Reset Actions
function League:setupSearchActions()
    print("Setting up search actions...")
    self.im.RegisterAction(League.Config.Actions.Search, function() self:search() end)
    self.im.RegisterAction(League.Config.Actions.Reset, function() self:resetFilters() end)
end

-- Price Placeholders
function League:updateBidPlaceholders()
    print("Updating bid placeholders...")
    PRICEMIN, PRICEMAX = self.bidValues.minBid, self.bidValues.maxBid
    WAGEMIN, WAGEMAX = self.bidValues.minBuy, self.bidValues.maxBuy
end

-- Cleanup
function League:finalize()
    print("Finalizing league...")
    local actions = {
        League.Config.Actions.AdvanceMatch, League.Config.Actions.DecreaseBid,
        League.Config.Actions.IncreaseBid, League.Config.Actions.Search, League.Config.Actions.Reset
    }
    local bindings = {
        League.Config.Bindings.MatchList, League.Config.BidAdjustments.MinBid.Binding,
        League.Config.BidAdjustments.MaxBid.Binding, League.Config.BidAdjustments.MinBuy.Binding,
        League.Config.BidAdjustments.MaxBuy.Binding, League.Config.Bindings.TeamName,
        League.Config.Bindings.PlayerInfo,
        League.Config.Bindings.PlayerName, League.Config.Bindings.PlayerOverall, League.Config.Bindings.PlayerAge, League.Config.Bindings.PlayerPosition,
        League.Config.Bindings.Status, League.Config.Bindings.TransferValue, League.Config.Bindings.TeamLogo,
        League.Config.Bindings.PlayerHead, League.Config.Bindings.TeamMatchProgress,
        League.Config.Bindings.FinishLabel
    }
    for _, action in ipairs(actions) do self.im.UnregisterAction(action) end
    for _, binding in ipairs(bindings) do self.im.Unsubscribe(binding) end
    self.rivalMatches = {}
end

-- Player and Match Management
function League:publishMatchLabel()
    print("publishMatchLabel called")
    local playerInfo = self:findPlayerInfo(GLOBAL_PLAYERINSTALL or 1001, GLOBAL_TEAMBUY or 1)
    print("PlayerInfo:", playerInfo)
    
    local playerTeam = GLOBAL_TEAMBUY or 1
    local cardID = GLOBAL_PLAYERINSTALL or 1001
    local pInfo = getPlayerInfo and getPlayerInfo(cardID, playerTeam) or nil
    print("pInfo:", pInfo)
    
    local playerRating = pInfo and pInfo.rating or 50
    local playerPosition = pInfo and pInfo.position or (self.playerStats and self.playerStats.position) or "CM"
    local playerIndex = pInfo and pInfo.index or 0
    local repCount = playerReplacementCount(playerTeam, playerPosition) or 0
    local days = daysLeftInTransferWindow(GLOBAL_DATE_PLACEHOLDER or "2025-03-22") or 30
    
    TVALUE, minTValue = computeTransferValue(GetPlayerAge(cardID) or 25, playerRating, playerPosition, playerIndex, repCount, days)
    if not TVALUE then TVALUE = 1000000 end -- Fallback
    if not minTValue then minTValue = 500000 end -- Fallback
    print("TVALUE:", TVALUE, "minTValue:", minTValue)
    
    self.im.Publish(League.Config.Bindings.TeamName, "")
    self.im.Publish(League.Config.Bindings.TeamLogo, self.teamVisuals.crest)
    self.im.Publish(League.Config.Bindings.PlayerHead, self.teamVisuals.playerHead)
    self.im.Publish(League.Config.Bindings.TeamMatchProgress, "€" .. self.loc.LocalizeInteger(GLOBAL_FUNDS))
    self.im.Publish(League.Config.Bindings.Status, "")
    self.im.Publish(League.Config.Bindings.TransferValue, "€" .. self.loc.LocalizeInteger(TVALUE))

    -- Publish name, overall, age and position separadamente (e PlayerInfo composto)
    self:publishPlayerNameAndOverall(cardID, playerTeam)
end

function League:publishPlayerCount()
    print("Publishing player count...")
    local players = self.services.squadManagement.GetCurrentPlayerLineup(0, GLOBAL_TEAMBUY or 1, 0) or {}
    local replacementCount = 0
    local playerInfo = self:findPlayerInfo(GLOBAL_PLAYERINSTALL or 1001, GLOBAL_TEAMBUY or 1)
    if playerInfo then
        local position = playerInfo.position
        for i = 12, #players do
            if players[i].position == position then replacementCount = replacementCount + 1 end
        end
    end
    COUNT = replacementCount
end

function League:findPlayerInfo(playerId, teamId)
    print("Finding player info for playerId:", playerId, "teamId:", teamId)
    local players = self.services.squadManagement.GetCurrentPlayerLineup(0, teamId, 0) or {}
    for i, player in ipairs(players) do
        if player.CARD_ID == playerId then 
            print("Player found at index:", i)
            return { index = i, position = player.position } 
        end
    end
    print("Player not found")
    return nil
end

function League:swapPlayersInTeam(teamId, cardIdToSwap)
    print("Swapping players in teamId:", teamId, "cardIdToSwap:", cardIdToSwap)
    local players = self.services.squadManagement.GetCurrentPlayerLineup(0, teamId, 0) or {}
    if #players == 0 then print("[Restart]: No players found for teamID " .. teamId) return end
    
    local swapIdx, swapPos
    for i, player in ipairs(players) do
        if player.CARD_ID == cardIdToSwap then swapIdx, swapPos = i, player.position break end
    end
    if not swapIdx then print("[Restart]: Player with CARD_ID " .. cardIdToSwap .. " not found in teamID " .. teamId) return end
    
    for i = 12, #players do
        if players[i].position == swapPos then
            players[swapIdx], players[i] = players[i], players[swapIdx]
            local updatedPlayerIds = {}
            for _, player in ipairs(players) do table.insert(updatedPlayerIds, player.CARD_ID) end
            self.services.squadManagement.SetCurrentPlayerLineup(0, teamId, 0, 0, updatedPlayerIds)
            print("[Restart]: Swapped player " .. cardIdToSwap .. " with player " .. players[swapIdx].CARD_ID .. " in teamID " .. teamId)
            return
        end
    end
    print("[Restart]: No player outside starting lineup found with position " .. swapPos .. " to swap with CARD_ID " .. cardIdToSwap .. " in teamID " .. teamId)
end

-- Search and Reset
function League:search()
    print("Searching...")
    self:publishPlayerCount()
    local playerInfo = self:findPlayerInfo(GLOBAL_PLAYERINSTALL or 1001, GLOBAL_TEAMBUY or 1)
    local playerIdx = playerInfo and playerInfo.index or 0
    
    local playerTeam = GLOBAL_TEAMBUY or 1
    local cardID = GLOBAL_PLAYERINSTALL or 1001
    local pInfo = getPlayerInfo and getPlayerInfo(cardID, playerTeam) or nil
    local playerRating = pInfo and pInfo.rating or 50
    local playerPosition = pInfo and pInfo.position or "CM"
    local playerIndex = pInfo and pInfo.index or 0
    local repCount = playerReplacementCount(playerTeam, playerPosition) or 0
    local days = daysLeftInTransferWindow(GLOBAL_DATE_PLACEHOLDER or "2025-03-22") or 30
    local sellerPlayers = self.services.squadManagement.GetCurrentPlayerLineup(0, GLOBAL_TEAMBUY, 0) or {}
    
    TVALUE, minTValue = computeTransferValue(GetPlayerAge(cardID) or 25, playerRating, playerPosition, playerIndex, repCount, days)
    if not TVALUE then TVALUE = 1000000 end
    if not minTValue then minTValue = 500000 end
    
    WAGEMAX = WAGEMAX or 0
    GLOBAL_FUNDS = GLOBAL_FUNDS or 10000000
    if WAGEMAX >= minTValue then
        if (COUNT or 0) < 1 then self:failTransfer("No replacements available")
        elseif WAGEMAX > GLOBAL_FUNDS then self:failTransfer("Insufficient funds")
        elseif #sellerPlayers < 24 then self:failTransfer("Team are not looking to sell players right now")
        else
            TVALUE = WAGEMAX >= TVALUE and TVALUE or WAGEMAX
            self:completeTransfer()
            self:clearSlot()
            self.rejectionCount = 0
        end
    else
        self.rejectionCount = self.rejectionCount + 1
        local message = self.loc.LocalizeString("TeamName_Abbr15_" .. (GLOBAL_TEAMBUY or 1)) .. 
                        " are not impressed by your offer of €" .. self.loc.LocalizeInteger(WAGEMAX) .. 
                        " (Target: €" .. self.loc.LocalizeInteger(TVALUE) .. ", Min: €" .. self.loc.LocalizeInteger(minTValue) .. ")"
        self.im.Publish(League.Config.Bindings.Status, message)
        
        if self.rejectionCount >= 3 then self:failTransfer("Club has rejected your offer too many times")
        elseif WAGEMAX < 0.5 * TVALUE then self:failTransfer("Offer is too low compared to market value")
        elseif GLOBAL_FUNDS < WAGEMAX then self:failTransfer("You don't have enough funds to complete this transfer") end
    end

    -- Atualiza também Nome, OVR, Idade e Posição após uma busca (caso o jogador mude)
    self:publishPlayerNameAndOverall(cardID, playerTeam)
end

function League:resetFilters()
    print("Resetting filters...")
    self.bidValues.minBid, self.bidValues.maxBid = League.Config.MinValue, League.Config.MinValue
    self.bidValues.minBuy, self.bidValues.maxBuy = League.Config.MinValue, League.Config.MinValue
    self.rejectionCount = 0
    self:publishAmountSelector()
    self:updateBidPlaceholders()
end

function League:publishAmountSelector(bindingName)
    print("Publishing amount selector for:", bindingName)
    if not bindingName then
        for _, adjustment in pairs(League.Config.BidAdjustments) do
            self:publishAmountSelector(adjustment.Binding)
        end
    else
        self.im.Refresh(bindingName)
    end
end

function League:clearSlot()
    print("Clearing slot...")
    SCOUTINDEX = SCOUTINDEX or 1
    _G["SLOTTM" .. SCOUTINDEX] = nil
    _G["SLOTPL" .. SCOUTINDEX] = nil
end

-- Transfer Outcomes
function League:failTransfer(reason)
    print("Transfer failed:", reason)
    local buttonYes = { icon = "$FooterIconNo", label = "Close", clickEvents = {"evt_back", "evt_hide_popup"} }
    local popupData = {
        title = "TRANSFER FAILED",
        message = reason or "Player is too important to " .. self.loc.LocalizeString("TeamName_Abbr15_" .. (GLOBAL_TEAMBUY or 1)),
        buttons = {buttonYes}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
end

function League:completeTransfer()
    print("Transfer completed")
    local buttonYes = { icon = "$FooterIconYes", label = "Done", clickEvents = {"evt_back", "evt_back", "evt_squad", "evt_hide_popup"} }
    local popupData = {
        title = "TRANSFER SUCCESSFUL",
        message = "Player has joined for €" .. self.loc.LocalizeInteger(WAGEMAX) .. ". View in squad",
        buttons = {buttonYes}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
    
    local playerInfo = self:findPlayerInfo(GLOBAL_PLAYERINSTALL or 1001, GLOBAL_TEAMBUY or 1)
    if playerInfo and playerInfo.index >= 1 and playerInfo.index <= 11 then
        self:swapPlayersInTeam(GLOBAL_TEAMBUY or 1, GLOBAL_PLAYERINSTALL or 1001)
    end
    transferPlayer = transferPlayer or function(pId, fromTeam, toTeam) print("Transferring player", pId, "from", fromTeam, "to", toTeam) end
    transferPlayer(GLOBAL_PLAYERINSTALL or 1001, GLOBAL_TEAMBUY or 1, currentSelectedTeamID or 2)
    
    -- Insert a transfer record as a table with Player and Team fields
    table.insert(transferHistory, {
        Player = GLOBAL_PLAYERINSTALL,
        Team = GLOBAL_TEAMBUY
    })
    
    GLOBAL_FUNDS = (GLOBAL_FUNDS or 10000000) - WAGEMAX
end

return League