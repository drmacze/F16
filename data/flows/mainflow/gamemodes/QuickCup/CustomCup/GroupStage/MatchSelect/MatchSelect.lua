-- Suporta múltiplos formatos: Group + Knockout, Knockout e League

local TabModel = ...
MatchSelect = {}

local BND_COLOR_CUPID = "bnd_color_tourid" 
local BND_ADS_A_VISIBLE = "bnd_ads_a_visible"
local BND_ADS_B_VISIBLE = "bnd_ads_b_visible"
local BND_BUSY_STATE_VISIBLE = "bnd_busy_state_visible"
local BND_LAST_MATCH_RESULT = "bnd_last_match_result"
local BND_HUB_ACTIONS_VISIBLE = "bnd_hub_actions_visible"
local ACT_ADVANCE = "act_advance"
local ACT_RESTART = "act_restart"
local ACT_BELUM = "act_belum"
local BND_REALTIME = "bnd_realtime"
local BND_DATE = "bnd_date"
local BND_CURRENT_ROUND = "bnd_current_round"
local BND_PANEL_LOADING = "bnd_panel_loading"

local currentSimulationPhase = 0
local matchesToSimulate = {}
local bndList = {}
local currentMatchIndex = 1
local tournamentConfig = { useUCLStyle = true, isLeague = false }

currentMatch = { HomeTeamID = 0, AwayTeamID = 0, HomeKitIndex = 0, AwayKitIndex = 1}
QuickTourGrouping = QuickTourGrouping or {}
GroupStandings = GroupStandings or {}
currentTourInfo = currentTourInfo or {}
currentTourData = currentTourData or {}
TeamPlayerCache = TeamPlayerCache or {}
currentPlayedMatchIndex = nil
GOALS = GOALS or {}
TournamentStats = TournamentStats or {}
LeagueStandings = LeagueStandings or {}

local tourIdToNameMap = {
    [1] = "UEFA Champions League", [2] = "UEFA Europa League",
    [3] = "UEFA Euro", [4] = "UEFA Nations League",
    [5] = "UEFA Women CL", [6] = "CONMEBOL Libertadores",
    [7] = "CONMEBOL Sudamericana", [8] = "CONMEBOL Copa America",
    [9] = "FIFA Club World Cup", [10] = "FIFA World Cup 2026",
    [11] = "The Emirates FA Cup", [12] = "Copa del Rey",
    [13] = "Coppa Italia", [14] = "DFB-Pokal",
    [15] = "Coupe de France", [16] = "Copa do Brasil",
    default = "Custom Tournament"
}

local tourIdToColorMap = {
  [1]="0x000026", [2]="0x131313",
  [3]="0x02003D", [4]="0x3C4858",
  [5]="0x02003D", [6]="0x323232",
  [7]="0x02003D", [8]="0x02003D",
  [9]="0x131313", [10]="0x001B96", 
  [11]="0x000147", [12]="0x00072D",
  [13]="0x31A44D", [14]="0x505050", 
  [15]="0x000C44", [16]="0x006726", 
  default = "0x1A1A1A"
}

function MatchSelect:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self

    local tourId = GlobalTournamentSettings.tourId or 1
    o.services = {
        FifaCustomizationService = o.api("FifaCustomizationService"),
        MatchSetup = o.api("MatchSetupService"),
        settingsService = o.api("SettingsService"),
        GameSetup = o.api("GameSetupService"),
        SquadManagementService = o.api("SquadMgtService"),
        gameState = o.api("GameStateService"),
        EventManagerService = o.api("EventManagerService"),
        SocialService = o.api("SocialService")
    }
	
	o.isAdsVisible = true
    o.simulationDelayTimer = nil
    o.isSimulatingWithDelay = false
    o.currentOptions = o.services.settingsService.GetCurrentOptions()
    
    for i = 1, 62 do
        bndList[i] = "bnd_team" .. i .. "_score"
        bndList[i + 62] = "bnd_team" .. i .. "_crest"
    end
    
    currentTourInfo[tourId] = currentTourInfo[tourId] or { homeID = 0 }
    local tournamentDisplayName = tourIdToNameMap[tourId] or tourIdToNameMap.default
    
    o.tourData = {
        tourBg = { name = "$CupBg", id = tourId },
        tourlogo = { name = "$CupLogo", id = tourId },
        trophy = { name = "$CupTrophy", id = tourId },
        championCrest = { name = "$Crest", id = 0 },
        isFinish = false, 
        Round = ""
    }
    
    o.settings = GlobalTournamentSettings or {}
    o.totalGroups = o.settings.totalGroups or 12
    o.teamsPerGroup = o.settings.teamsPerGroup or 4
    o.teamCount = o.settings.teamCount or 32
    o.matchdaysPerGroup = o.settings.matchdaysPerGroup or 6
    o.isLeagueMode = o.settings.isLeagueMode or false
    
    o:setupSubscriptions()
    o:setupActions()
    o.im.Publish("bnd_match_visible", true)
    print(" MatchSelect Initialized")
    
    if o.isLeagueMode then
        print(string.format("   League Mode: %d teams | %d matchdays", o.teamCount, o.matchdaysPerGroup))
    else
        print(string.format("   Groups: %d | Teams/Group: %d | Total Teams: %d | Matchdays: %d", 
            o.totalGroups, o.teamsPerGroup, o.teamCount, o.matchdaysPerGroup))
    end

    self.isSimulating = false
    currentSimulationPhase = 0
    matchesToSimulate = {}
    currentMatchIndex = 1
    self.simulationInProgress = false

    print(" Initializing tournament (no auto-simulation)...")
    o:InitOptions()

	return o
end

function MatchSelect:InitializeLeagueStandings()
    local tourId = GlobalTournamentSettings.tourId or 1
    
    if not self.isLeagueMode then return end
    
    if not LeagueStandings[tourId] then
        LeagueStandings[tourId] = {}
        
        if QuickTourGrouping[tourId] then
            local teamsInitialized = {}
            for _, match in ipairs(QuickTourGrouping[tourId]) do
                if match[9] == "LEAGUE" then
                    if not teamsInitialized[match[1]] then
                        LeagueStandings[tourId][match[1]] = {
                            teamId = match[1],
                            played = 0,
                            wins = 0,
                            draws = 0,
                            losses = 0,
                            goalsFor = 0,
                            goalsAgainst = 0,
                            points = 0
                        }
                        teamsInitialized[match[1]] = true
                    end
                    
                    if not teamsInitialized[match[2]] then
                        LeagueStandings[tourId][match[2]] = {
                            teamId = match[2],
                            played = 0,
                            wins = 0,
                            draws = 0,
                            losses = 0,
                            goalsFor = 0,
                            goalsAgainst = 0,
                            points = 0
                        }
                        teamsInitialized[match[2]] = true
                    end
                end
            end
        end
        
        print(" [LeagueStandings] Initialized with " .. 
            (LeagueStandings[tourId] and (function() local c=0 for _ in pairs(LeagueStandings[tourId]) do c=c+1 end return c end)() or 0) .. " teams")
    end
end

function MatchSelect:InitOptions()
    local tourId = GlobalTournamentSettings.tourId or 1
    
    print(" [InitOptions] Called - isLeagueMode:", tostring(self.isLeagueMode))
    
    if not QuickTourGrouping or not QuickTourGrouping[tourId] then 
        for i = 1, 124 do
            self.im.Publish("bnd_team"..i.."_crest", { name = "$Crest", id = 0 })
            self.im.Publish("bnd_team"..i.."_score", "0")
        end
        return 
    end
    
    -- Se for LEAGUE, usar LeagueStandings
    if self.isLeagueMode then
        print(" [InitOptions] Exibindo LEAGUE standings...")
        
        if LeagueStandings[tourId] and next(LeagueStandings[tourId]) then
            print(" [InitOptions] LeagueStandings encontrado")
            
            local teamList = {}
            for teamId, stats in pairs(LeagueStandings[tourId]) do
                table.insert(teamList, { teamId = teamId, stats = stats })
            end
            
            table.sort(teamList, function(a, b)
                if a.stats.points ~= b.stats.points then return a.stats.points > b.stats.points end
                local gdA = a.stats.goalsFor - a.stats.goalsAgainst
                local gdB = b.stats.goalsFor - b.stats.goalsAgainst
                if gdA ~= gdB then return gdA > gdB end
                return a.stats.goalsFor > b.stats.goalsFor
            end)
            
            print(" [InitOptions] Tabela tem " .. #teamList .. " times")
            
            for k = 1, #teamList do
                local team = teamList[k]
                local i = (k - 1) * 2 + 1
                
                self.im.Publish("bnd_team" .. i .. "_crest", { name = "$Crest", id = team.teamId })
                self.im.Publish("bnd_team" .. i .. "_score", tostring(team.stats.points))
                
                if k < #teamList then
                    local nextTeam = teamList[k + 1]
                    self.im.Publish("bnd_team" .. (i + 1) .. "_crest", { name = "$Crest", id = nextTeam.teamId })
                    self.im.Publish("bnd_team" .. (i + 1) .. "_score", tostring(nextTeam.stats.points))
                else
                    self.im.Publish("bnd_team" .. (i + 1) .. "_crest", { name = "$Crest", id = 0 })
                    self.im.Publish("bnd_team" .. (i + 1) .. "_score", "0")
                end
            end
        else
            print(" [InitOptions] LeagueStandings vazio ou não inicializado")
            for i = 1, 124 do
                self.im.Publish("bnd_team"..i.."_crest", { name = "$Crest", id = 0 })
                self.im.Publish("bnd_team"..i.."_score", "0")
            end
        end
        return
    end
    
    -- Modo GROUP (código original)
    local g = QuickTourGrouping[tourId]
    for k = 1, #g do
        local m = g[k]
        local i = (k - 1) * 2 + 1
        self.im.Publish("bnd_team" .. i .. "_crest", { name = "$Crest", id = m[1] })
        self.im.Publish("bnd_team" .. i .. "_score", tostring(m[3]))
        self.im.Publish("bnd_team" .. (i + 1) .. "_crest", { name = "$Crest", id = m[2] })
        self.im.Publish("bnd_team" .. (i + 1) .. "_score", tostring(m[4]))
    end
    
    if #g > 0 then
        local final = g[#g]
        if final and final[9] == "Final" and final[5] and final[6] ~= 0 then
            self.tourData.championCrest.id = final[6]
            self.tourData.isFinish = true
            self:publishChampion()
        else
            self.tourData.isFinish = false
            self.tourData.championCrest.id = 0
        end
    end
end

function MatchSelect:setupSubscriptions()
    local tourId = GlobalTournamentSettings.tourId or 1
    local tournamentDisplayName = tourIdToNameMap[tourId] or tourIdToNameMap.default
    
	self.im.Subscribe(BND_PANEL_LOADING, function(isVisible) end)
    
    self.im.Subscribe(BND_COLOR_CUPID, function()
        local currentTourId = GlobalTournamentSettings.tourId or 1
        local color = tourIdToColorMap[currentTourId] or tourIdToColorMap.default
        self.im.Publish(BND_COLOR_CUPID, color)
    end)

	self.im.Subscribe(BND_CURRENT_ROUND, function() 
        local round = "Group Stage"
        local tourId = GlobalTournamentSettings.tourId or 1
        
        if QuickTourGrouping[tourId] then
            for i = #QuickTourGrouping[tourId], 1, -1 do
                local match = QuickTourGrouping[tourId][i]
                if match[7] then
                    round = match[9]
                    break
                end
            end
        end
        
        self.im.Publish(BND_CURRENT_ROUND, round)
	end)
    
    self.im.Subscribe(BND_BUSY_STATE_VISIBLE, function(isVisible) end)
    self.im.Subscribe("bnd_bg_tour", function() self.im.Publish("bnd_bg_tour", self.tourData.tourBg) end)
    self.im.Subscribe("bnd_tour_logo", function() self.im.Publish("bnd_tour_logo", self.tourData.tourlogo) end)
    self.im.Subscribe("bnd_trophy", function() self.im.Publish("bnd_trophy", self.tourData.trophy) end)
    
    self.Banner = { name = "$_Ads_Insta", id = math.random(4) }
    self.im.Subscribe("bnd_last_match_result", function() self:publishMatchInfo() end)
    self.im.Subscribe("bnd_ads", function() self.im.Publish("bnd_ads", self.Banner) end)
    self.im.Subscribe(BND_REALTIME, function() self.im.Publish(BND_REALTIME, os.date(tournamentDisplayName .. " %h %d | %I:%M %p")) end)
    self.im.Subscribe("bnd_date", function()
        local currentDate = os.date("%A, %b %d")
        self.im.Publish("bnd_date", currentDate)
    end)
    
    self.im.Subscribe("bnd_home_score", function() self:publishMatchInfo() end)
    self.im.Subscribe("bnd_away_score", function() self:publishMatchInfo() end)
    self.im.Subscribe("bnd_tour_label", function() self:publishMatchInfo() end)
    self.im.Subscribe(BND_ADS_A_VISIBLE, function() self.im.Publish(BND_ADS_A_VISIBLE, self.isAdsVisible) end)
    self.im.Subscribe(BND_ADS_B_VISIBLE, function() self.im.Publish(BND_ADS_B_VISIBLE, not self.isAdsVisible) end)
    
    for _, v in ipairs(bndList) do self.im.Subscribe(v, function() self:InitOptions() end) end
    for _, k in ipairs({ "bnd_match_visible", "bnd_home_crest", "bnd_away_crest", "bnd_home_team", "bnd_away_team","bnd_group_label", "bnd_home_team_short", "bnd_away_team_short", "bnd_team_crest", "bnd_team_name" }) do self.im.Subscribe(k, function() self:publishMatchInfo() end) end
    for _, k in ipairs({"bnd_text", "bnd_champion_visible", "bnd_champion_crest", "bnd_champion_team"}) do self.im.Subscribe(k, function() self:publishChampion() end) end
end

function MatchSelect:setupActions()
    self.im.RegisterAction(ACT_ADVANCE, function() self:PlayMatch() end)
    self.im.RegisterAction(ACT_RESTART, function() self:PlayReStart() end)
    self.im.RegisterAction(ACT_BELUM, function() self:Belum() end)

    self.im.RegisterAction("act_simulate", function()
    if self.simulationInProgress then 
        print(" Simulation already in progress. Please wait...")
        return 
    end
    self.simulationInProgress = true

    local tourId = GlobalTournamentSettings.tourId or 1
    local userTeamId = currentTourInfo[tourId] and currentTourInfo[tourId].homeID
    local group = QuickTourGrouping[tourId]
    local isLeagueMode = self.isLeagueMode
    
    if not group or not userTeamId then
        self.simulationInProgress = false
        return
    end

    print(" act_simulate clicked")
    
    local userMatchIndex = nil
    local isLeagueMatch = false
    local isKnockoutMatch = false
    
    for i, match in ipairs(group) do
        if not match[5] and (match[1] == userTeamId or match[2] == userTeamId) then
            userMatchIndex = i
            isLeagueMatch = (match[9] == "LEAGUE")
            isKnockoutMatch = match[7]
            print(string.format(" Found user match at index %d (League: %s, Knockout: %s)", 
                i, tostring(isLeagueMatch), tostring(isKnockoutMatch)))
            break
        end
    end
    
    if not userMatchIndex then
        print(" No unplayed user match found")
        self.simulationInProgress = false
        self:InitOptions()
        self:publishMatchInfo()
        return
    end

    local userMatch = group[userMatchIndex]
    
    if isLeagueMode and isLeagueMatch then
        -- ========================================
        -- LEAGUE MODE
        -- ========================================
        self:InitializeLeagueStandings()
        local matchday = userMatch[10]
        print(string.format(" Simulating League Matchday %d", matchday))
        
        --  PREENCHER CACHE
        TournamentStats[tourId] = TournamentStats[tourId] or {
            Goals = {}, Assists = {}, Appearances = {},
            YellowCards = {}, RedCards = {}
        }
        TeamPlayerCache[tourId] = TeamPlayerCache[tourId] or {}
        
        for _, match in ipairs(group) do
            if match[9] == "LEAGUE" and match[10] == matchday and not match[5] then
                -- Preencher cache se necessário
                for _, teamId in ipairs({match[1], match[2]}) do
                    if not TeamPlayerCache[tourId][teamId] then
                        local teamPlayers = self.services.SquadManagementService.GetTeamPlayers(teamId) or {}
                        TeamPlayerCache[tourId][teamId] = {}
                        for _, player in ipairs(teamPlayers) do
                            if player and player.CARD_ID then
                                table.insert(TeamPlayerCache[tourId][teamId], {
                                    CARD_ID = player.CARD_ID,
                                    playerName = player.playerName or "Unknown",
                                    position = player.position or "N/A",
                                    rating = player.rating or 75,
                                    jerseyNumber = player.jerseyNumber or 0,
                                    nationalityID = player.nationalityID or 0
                                })
                            end
                        end
                    end
                end
                
                local scores = self:GetTeamRealScore(match[1], match[2], true)
                match[3] = scores[match[1]]
                match[4] = scores[match[2]]
                match[5] = true
                match[6] = (match[3] > match[4]) and match[1] or (match[4] > match[3]) and match[2] or 0
                
                --  REGISTRAR APARIÇÕES E GOLS
                local homeLineup = TeamPlayerCache[tourId][match[1]] or {}
                local awayLineup = TeamPlayerCache[tourId][match[2]] or {}
                
                for _, p in ipairs(homeLineup) do 
                    self:RecordPlayerStats(p.CARD_ID, {appearance = 1}) 
                end
                for _, p in ipairs(awayLineup) do 
                    self:RecordPlayerStats(p.CARD_ID, {appearance = 1}) 
                end
                
                local function recordGoals(numGoals, players, teamId)
                    for _ = 1, numGoals do
                        if #players > 0 then
                            local p = players[math.random(#players)]
                            if p and p.CARD_ID then
                                self:RecordPlayerStats(p.CARD_ID, {goals = 1})
                            end
                        end
                    end
                end
                
                recordGoals(match[3], homeLineup, match[1])
                recordGoals(match[4], awayLineup, match[2])
                
                self:UpdateLeagueStandings(match[1], match[2], match[3], match[4])
            end
        end
        
        self:SaveMatchResult()
        
        if self:CheckLeagueCompletion() then
            print(" LEAGUE COMPLETED! Generating Round of 16...")
            self:GenerateKnockoutFromLeague()
        end
        
    elseif isKnockoutMatch then
        -- ========================================
        -- KNOCKOUT MODE
        -- ========================================
        local currentRound = userMatch[9]
        print(string.format(" Simulating ALL matches in %s", currentRound))
        
        --  PREENCHER CACHE
        TournamentStats[tourId] = TournamentStats[tourId] or {
            Goals = {}, Assists = {}, Appearances = {},
            YellowCards = {}, RedCards = {}
        }
        TeamPlayerCache[tourId] = TeamPlayerCache[tourId] or {}
        
        for i, match in ipairs(group) do
            if match[9] == currentRound and not match[5] then
                -- Preencher cache se necessário
                for _, teamId in ipairs({match[1], match[2]}) do
                    if not TeamPlayerCache[tourId][teamId] then
                        local teamPlayers = self.services.SquadManagementService.GetTeamPlayers(teamId) or {}
                        TeamPlayerCache[tourId][teamId] = {}
                        for _, player in ipairs(teamPlayers) do
                            if player and player.CARD_ID then
                                table.insert(TeamPlayerCache[tourId][teamId], {
                                    CARD_ID = player.CARD_ID,
                                    playerName = player.playerName or "Unknown",
                                    position = player.position or "N/A",
                                    rating = player.rating or 75,
                                    jerseyNumber = player.jerseyNumber or 0,
                                    nationalityID = player.nationalityID or 0
                                })
                            end
                        end
                    end
                end
                
                self:SimulateKnockoutMatch(i)
                
                --  REGISTRAR APARIÇÕES E GOLS
                local homeLineup = TeamPlayerCache[tourId][match[1]] or {}
                local awayLineup = TeamPlayerCache[tourId][match[2]] or {}
                
                for _, p in ipairs(homeLineup) do 
                    self:RecordPlayerStats(p.CARD_ID, {appearance = 1}) 
                end
                for _, p in ipairs(awayLineup) do 
                    self:RecordPlayerStats(p.CARD_ID, {appearance = 1}) 
                end
                
                local function recordGoals(numGoals, players, teamId)
                    for _ = 1, numGoals do
                        if #players > 0 then
                            local p = players[math.random(#players)]
                            if p and p.CARD_ID then
                                self:RecordPlayerStats(p.CARD_ID, {goals = 1})
                            end
                        end
                    end
                end
                
                recordGoals(match[3], homeLineup, match[1])
                recordGoals(match[4], awayLineup, match[2])
            end
        end
        
        local winners = {}
        for _, match in ipairs(group) do
            if match[9] == currentRound and match[5] then
                if match[6] and match[6] ~= 0 then
                    table.insert(winners, match[6])
                    print(string.format(" Winner: %d (from %d vs %d)", 
                        match[6], match[1], match[2]))
                end
            end
        end
        
        print(string.format(" Total winners from %s: %d", currentRound, #winners))
        
        if #winners > 0 then
            print(" Generating next round...")
            self:GenerateNextKnockoutRound(winners)
        end
        
    else
        -- ========================================
        -- GROUP STAGE - Simula todos da mesma rodada
        -- ========================================
        print(" Mode: GROUP STAGE")
        
        local matchday = userMatch[10]
        
        print(string.format(" Simulating ALL matches for global matchday %d", matchday))
        
        --  PREENCHER CACHE
        TournamentStats[tourId] = TournamentStats[tourId] or {
            Goals = {}, Assists = {}, Appearances = {},
            YellowCards = {}, RedCards = {}
        }
        TeamPlayerCache[tourId] = TeamPlayerCache[tourId] or {}
        
        --  Simula TODOS os matches do mesmo matchday
        for _, match in ipairs(group) do
            if match[8] and match[10] == matchday and not match[5] then
                -- Preencher cache se necessário
                for _, teamId in ipairs({match[1], match[2]}) do
                    if not TeamPlayerCache[tourId][teamId] then
                        local teamPlayers = self.services.SquadManagementService.GetTeamPlayers(teamId) or {}
                        TeamPlayerCache[tourId][teamId] = {}
                        for _, player in ipairs(teamPlayers) do
                            if player and player.CARD_ID then
                                table.insert(TeamPlayerCache[tourId][teamId], {
                                    CARD_ID = player.CARD_ID,
                                    playerName = player.playerName or "Unknown",
                                    position = player.position or "N/A",
                                    rating = player.rating or 75,
                                    jerseyNumber = player.jerseyNumber or 0,
                                    nationalityID = player.nationalityID or 0
                                })
                            end
                        end
                    end
                end
                
                local scores = self:GetTeamRealScore(match[1], match[2], true)
                match[3], match[4], match[5] = scores[match[1]], scores[match[2]], true
                match[6] = (match[3] > match[4]) and match[1] or (match[4] > match[3]) and match[2] or 0
                
                --  REGISTRAR APARIÇÕES E GOLS
                local homeLineup = TeamPlayerCache[tourId][match[1]] or {}
                local awayLineup = TeamPlayerCache[tourId][match[2]] or {}
                
                for _, p in ipairs(homeLineup) do 
                    self:RecordPlayerStats(p.CARD_ID, {appearance = 1}) 
                end
                for _, p in ipairs(awayLineup) do 
                    self:RecordPlayerStats(p.CARD_ID, {appearance = 1}) 
                end
                
                local function recordGoals(numGoals, players, teamId)
                    for _ = 1, numGoals do
                        if #players > 0 then
                            local p = players[math.random(#players)]
                            if p and p.CARD_ID then
                                self:RecordPlayerStats(p.CARD_ID, {goals = 1})
                            end
                        end
                    end
                end
                
                recordGoals(match[3], homeLineup, match[1])
                recordGoals(match[4], awayLineup, match[2])
                
                print(string.format("   Simulated: %d vs %d = %d-%d (Group %s)", 
                    match[1], match[2], match[3], match[4], match[9]))
            end
        end

        self:SaveMatchResult()
        
        --  Verifica se TODOS os matches de grupo terminaram
        local isLastGroupMatch = true
        for _, m in ipairs(group) do
            if m[8] and not m[5] then 
                isLastGroupMatch = false
                break 
            end
        end
        
        if isLastGroupMatch then
            print("  All group matches done. Generating knockout...")
            self:GenerateKnockoutFromGroupStandings()
        end

        print(" Group Stage Simulation Complete!")
    end

    self:InitOptions()
    
    --  Aguarda antes de publicar
    local waitTime = 0.5
    if os and os.clock then
        local startTime = os.clock()
        while os.clock() - startTime < waitTime do end
    end
    
    self:publishMatchInfo()
    self.simulationInProgress = false
    print(" Simulation Complete!")
end)
    
    self.im.RegisterAction("act_ads", function()
        self.isAdsVisible = not self.isAdsVisible
        self.im.Publish(BND_ADS_A_VISIBLE, self.isAdsVisible)
        self.im.Publish(BND_ADS_B_VISIBLE, not self.isAdsVisible)
    end)
end

-- ===== LEAGUE STANDINGS FUNCTIONS =====
function MatchSelect:UpdateLeagueStandings(homeId, awayId, homeScore, awayScore)
    local tourId = GlobalTournamentSettings.tourId or 1
    
    if not LeagueStandings[tourId] then
        print("ERROR: LeagueStandings not initialized for tourId: " .. tourId)
        return
    end
    
    local lsHome = LeagueStandings[tourId][homeId]
    local lsAway = LeagueStandings[tourId][awayId]
    
    if not lsHome or not lsAway then
        print(string.format("ERROR: Team %d or %d not found in LeagueStandings", homeId, awayId))
        return
    end
    
    lsHome.played = lsHome.played + 1
    lsAway.played = lsAway.played + 1
    lsHome.goalsFor = lsHome.goalsFor + homeScore
    lsHome.goalsAgainst = lsHome.goalsAgainst + awayScore
    lsAway.goalsFor = lsAway.goalsFor + awayScore
    lsAway.goalsAgainst = lsAway.goalsAgainst + homeScore
    
    if homeScore > awayScore then
        lsHome.wins = lsHome.wins + 1
        lsHome.points = lsHome.points + 3
        lsAway.losses = lsAway.losses + 1
    elseif awayScore > homeScore then
        lsAway.wins = lsAway.wins + 1
        lsAway.points = lsAway.points + 3
        lsHome.losses = lsHome.losses + 1
    else
        lsHome.draws = lsHome.draws + 1
        lsAway.draws = lsAway.draws + 1
        lsHome.points = lsHome.points + 1
        lsAway.points = lsAway.points + 1
    end
    
    print(string.format(" [UpdateLeagueStandings] %d: %d pts | %d: %d pts", 
        homeId, lsHome.points, awayId, lsAway.points))
end

function MatchSelect:CheckLeagueCompletion()
    local tourId = GlobalTournamentSettings.tourId or 1
    local group = QuickTourGrouping[tourId]
    
    if not group then return false end
    
    local leagueMatches = 0
    local leaguePlayed = 0
    
    for _, match in ipairs(group) do
        if match[9] == "LEAGUE" then
            leagueMatches = leagueMatches + 1
            if match[5] then leaguePlayed = leaguePlayed + 1 end
        end
    end
    
    return leaguePlayed == leagueMatches and leagueMatches > 0
end

function MatchSelect:GenerateKnockoutFromLeague()
    local tourId = GlobalTournamentSettings.tourId or 1
    
    if not LeagueStandings[tourId] then
        print("ERROR: LeagueStandings not found")
        return
    end
    
    print(" Generating Round of 16 from League standings...")
    
    local ranking = {}
    for _, teamStats in pairs(LeagueStandings[tourId]) do
        table.insert(ranking, teamStats)
    end
    
    table.sort(ranking, function(a, b)
        if a.points ~= b.points then return a.points > b.points end
        local gdA = a.goalsFor - a.goalsAgainst
        local gdB = b.goalsFor - b.goalsAgainst
        if gdA ~= gdB then return gdA > gdB end
        return a.goalsFor > b.goalsFor
    end)
    
    local qualifiedTeams = {}
    for i = 1, 16 do
        if ranking[i] then
            table.insert(qualifiedTeams, ranking[i].teamId)
        end
    end
    
    self:ShuffleArray(qualifiedTeams)
    
    print(" Generating Round of 16...")
    
    for i = 1, #qualifiedTeams, 2 do
        if qualifiedTeams[i] and qualifiedTeams[i+1] then
            table.insert(QuickTourGrouping[tourId], {
                qualifiedTeams[i],
                qualifiedTeams[i+1],
                0, 0, false, 0,
                true,
                false,
                "Round of 16",
                math.ceil(i/2)
            })
        end
    end
    
    print(string.format(" Round of 16 created with %d matches", math.floor(#qualifiedTeams / 2)))
end

function MatchSelect:SimulateAllGroupMatches()
    local tourId = GlobalTournamentSettings.tourId or 1
    local group = QuickTourGrouping[tourId]
    
    if not group then return end
    
    local userTeamId = currentTourInfo[tourId] and currentTourInfo[tourId].homeID
    if not userTeamId then return end
    
    print(string.format(" [SimulateAllGroupMatches] User Team: %d", userTeamId))
    
    TournamentStats[tourId] = TournamentStats[tourId] or {
        Goals = {}, Assists = {}, Appearances = {},
        YellowCards = {}, RedCards = {}
    }
    
    local userCompletedMatchdays = 0
    for _, match in ipairs(group) do
        if match[8] and match[5] and (match[1] == userTeamId or match[2] == userTeamId) then
            userCompletedMatchdays = math.max(userCompletedMatchdays, match[10])
        end
    end
    
    print(string.format(" User completed matchdays: %d", userCompletedMatchdays))
    
    local maxIterations = 500
    local iteration = 0
    local simulatedCount = 0
    
    while iteration < maxIterations do
        iteration = iteration + 1
        
        local foundMatch = false
        
        for _, match in ipairs(group) do
            if match[8] and not match[5] then
                local homePlayedCount = 0
                local awayPlayedCount = 0
                
                for _, m in ipairs(group) do
                    if m[8] and m[5] then
                        if m[1] == match[1] then homePlayedCount = homePlayedCount + 1 end
                        if m[2] == match[2] then awayPlayedCount = awayPlayedCount + 1 end
                    end
                end
                
                if homePlayedCount == awayPlayedCount and homePlayedCount <= userCompletedMatchdays then
                    if match[1] == userTeamId or match[2] == userTeamId then
                        print(string.format("  Skipping user match: %d vs %d", match[1], match[2]))
                    else
                        local scores = self:GetTeamRealScore(match[1], match[2], true)
                        match[3] = scores[match[1]]
                        match[4] = scores[match[2]]
                        match[5] = true
                        match[6] = (match[3] > match[4] and match[1]) or 
                                   (match[4] > match[3] and match[2]) or 0
                        
                        print(string.format("  Simulated: %d vs %d = %d-%d (Matchday %d)", 
                            match[1], match[2], match[3], match[4], match[10]))
                        
                        simulatedCount = simulatedCount + 1
                        foundMatch = true
                        break
                    end
                end
            end
        end
        
        if not foundMatch then
            print(string.format(" No more matches to simulate (iteration %d)", iteration))
            break
        end
    end
    
    print(string.format(" [SimulateAllGroupMatches] Complete - Simulated %d matches", simulatedCount))
    
    self:SaveMatchResult()
end

function MatchSelect:OnUserMatchEnd(statsPackage)
    print(" MatchSelect received stats package from GameMenu.")
    if not currentPlayedMatchIndex then 
        print(" Error: MatchSelect received stats but no match was recorded as being played.")
        return 
    end

    local tourId = GlobalTournamentSettings.tourId or 1
    local group = QuickTourGrouping[tourId]
    local match = group[currentPlayedMatchIndex]

    match[3] = statsPackage.homeScore
    match[4] = statsPackage.awayScore
    match[5] = true
    if match[3] > match[4] then match[6] = match[1] elseif match[4] > match[3] then match[6] = match[2] else match[6] = 0 end

    local homeTeamId = match[1]
    local awayTeamId = match[2]
    local allEvents = {}
    if statsPackage.matchEvents.homeData then for _, e in ipairs(statsPackage.matchEvents.homeData) do table.insert(allEvents, {event=e.data, teamId=homeTeamId}) end end
    if statsPackage.matchEvents.awayData then for _, e in ipairs(statsPackage.matchEvents.awayData) do table.insert(allEvents, {event=e.data, teamId=awayTeamId}) end end

    local function findId(teamId, number)
        if not TeamPlayerCache[tourId] or not TeamPlayerCache[tourId][teamId] then return nil end
        for _, p in ipairs(TeamPlayerCache[tourId][teamId]) do
            if p.jerseyNumber == number then return p.CARD_ID end
        end
        return nil
    end

    local homeLineup = TeamPlayerCache[tourId][homeTeamId] or {}
    local awayLineup = TeamPlayerCache[tourId][awayTeamId] or {}
    for _, p in ipairs(homeLineup) do self:RecordPlayerStats(p.CARD_ID, {appearance = 1}) end
    for _, p in ipairs(awayLineup) do self:RecordPlayerStats(p.CARD_ID, {appearance = 1}) end
    
    for _, item in ipairs(allEvents) do
        local playerId = findId(item.teamId, item.event.number)
        if playerId then
            if item.event.eventId == 0 then self:RecordPlayerStats(playerId, {goals = 1}) end
            if item.event.eventId == 11 then self:RecordPlayerStats(playerId, {assists = 1}) end
            if item.event.eventId == 2 then self:RecordPlayerStats(playerId, {yellow_cards = 1}) end
            if item.event.eventId == 3 then self:RecordPlayerStats(playerId, {red_cards = 1}) end
        end
    end
    
    currentPlayedMatchIndex = nil

    --  Atualizar LeagueStandings se for League
    if self.isLeagueMode and match[9] == "LEAGUE" then
        print(" Updating League Standings...")
        self:InitializeLeagueStandings()
        self:UpdateLeagueStandings(homeTeamId, awayTeamId, match[3], match[4])
    end

    self:SaveMatchResult()
    print(" User-played match results saved.")

    --  SIMULAR OUTROS MATCHES DA MESMA RODADA
    print(" Simulating all OTHER matches from the same matchday...")
    
    local matchday = match[10]
    local userTeamId = currentTourInfo[tourId] and currentTourInfo[tourId].homeID
    
    if match[8] then  -- Group Stage
        for _, m in ipairs(group) do
            if m[8] and m[10] == matchday and not m[5] then
                if m[1] == userTeamId or m[2] == userTeamId then
                    print(string.format("   Skipping user match: %d vs %d", m[1], m[2]))
                else
                    local scores = self:GetTeamRealScore(m[1], m[2], true)
                    m[3], m[4], m[5] = scores[m[1]], scores[m[2]], true
                    m[6] = (m[3] > m[4]) and m[1] or (m[4] > m[3]) and m[2] or 0
                    
                    print(string.format("   Simulated: %d vs %d = %d-%d", m[1], m[2], m[3], m[4]))
                end
            end
        end
    end

    self:InitOptions()
    
    --  AGUARDA UM POUCO ANTES DE PUBLICAR (evita race condition)
    local waitTime = 0.5
    print(string.format(" Waiting %.1f seconds before publishing match info...", waitTime))
    
    -- Se possível usar timer do Lua
    if os and os.clock then
        local startTime = os.clock()
        while os.clock() - startTime < waitTime do
            -- Aguarda
        end
    end
    
    self:publishMatchInfo()
    print(" Complete!")
end

function MatchSelect:OnMatchEnd(stats)
    print(" Match ended. Processing stats...")
    if not currentPlayedMatchIndex then
        print(" Error: No match index was recorded.")
        return
    end

    local tourId = GlobalTournamentSettings.tourId or 1
    local g = QuickTourGrouping[tourId]
    local m = g[currentPlayedMatchIndex]
    
    m[3] = stats.HomeScore
    m[4] = stats.AwayScore
    m[5] = true
    m[6] = (stats.HomeScore > stats.AwayScore) and m[1] or (stats.AwayScore > stats.HomeScore) and m[2] or 0

    local currentStats = TournamentStats[tourId]

    for _, scorer in ipairs(stats.GoalScorers or {}) do
        currentStats.Goals[scorer.PlayerID] = (currentStats.Goals[scorer.PlayerID] or 0) + 1
    end

    for _, assister in ipairs(stats.Assisters or {}) do
        currentStats.Assists[assister.PlayerID] = (currentStats.Assists[assister.PlayerID] or 0) + 1
    end
    
    for _, player in ipairs(stats.YellowCardPlayers or {}) do
        currentStats.YellowCards[player.PlayerID] = (currentStats.YellowCards[player.PlayerID] or 0) + 1
    end

    for _, player in ipairs(stats.RedCardPlayers or {}) do
        currentStats.RedCards[player.PlayerID] = (currentStats.RedCards[player.PlayerID] or 0) + 1
    end

    print(" Match results saved.")
    currentPlayedMatchIndex = nil

    print(" Simulating ALL group matches to synchronize...")
    self:SimulateAllGroupMatches()

    self:InitOptions()
    self:publishMatchInfo()
    print(" Complete!")
end

function MatchSelect:publishChampion()
    local tourId = GlobalTournamentSettings.tourId or 1
    if self.tourData.isFinish and self.tourData.championCrest.id ~= 0 then
        local championId = self.tourData.championCrest.id
        print(" Displaying champion: " .. championId)
        self.im.Publish("bnd_champion_visible", true)
        self.im.Publish("bnd_match_visible", false)
        self.im.Publish(BND_HUB_ACTIONS_VISIBLE, false)
		self.im.Publish(BND_PANEL_LOADING, false)
        self.im.Publish("bnd_text", "THE CHAMPION")
        self.im.Publish("bnd_champion_crest", self.tourData.championCrest)
        self.im.Publish("bnd_champion_team", self.loc.LocalizeString("TeamName_Abbr15_" .. championId))
        self.im.Publish("bnd_home_crest", nil)
        self.im.Publish("bnd_away_crest", nil)
        self.im.Publish("bnd_home_team", "")
        self.im.Publish("bnd_away_team", "")
        self.im.Publish("bnd_home_team_short", "")
        self.im.Publish("bnd_away_team_short", "")
        self.im.Publish(BND_LAST_MATCH_RESULT, "Tournament Completed")
    else
        self.im.Publish("bnd_champion_visible", false)
    end
end

function MatchSelect:publishMatchInfo()
    local tourId = GlobalTournamentSettings.tourId or 1
    local tourName = tourIdToNameMap[tourId] or tourIdToNameMap.default
    
    if self.tourData.isFinish then 
        self:publishChampion() 
        return 
    end
    
    self.im.Publish(BND_PANEL_LOADING, true)
    if not QuickTourGrouping or not QuickTourGrouping[tourId] or not currentTourInfo[tourId] then
        self.im.Publish("bnd_text", "Loading tournament data...")
        self.im.Publish(BND_PANEL_LOADING, false)
        return
    end

    local g = QuickTourGrouping[tourId]
    local userTeamId = currentTourInfo[tourId].homeID or 0
    self.im.Publish("bnd_team_crest", { name = "$Crest", id = userTeamId })
    self.im.Publish("bnd_team_name", self.loc.LocalizeString("TeamName_Abbr15_" .. userTeamId))

    local nextMatchFound = false
    
    --  PRIMEIRO: Procura matches de grupo/league pendentes
    for _, match in ipairs(g) do
        if not match[5] and (match[1] == userTeamId or match[2] == userTeamId) then
            local roundName = match[9]
            if match[7] then
                -- Knockout
                self.im.Publish("bnd_text", roundName)
            elseif match[8] then
                -- Group Stage
                self.im.Publish("bnd_text", "Group Stage - Group " .. roundName)
            elseif self.isLeagueMode then
                -- League
                self.im.Publish("bnd_text", "LEAGUE - Matchday " .. (match[10] or "?"))
            end

            self.im.Publish("bnd_match_visible", true)
            self.im.Publish(BND_HUB_ACTIONS_VISIBLE, false)
            self.im.Publish("bnd_home_crest", { name = "$Crest", id = match[1] })
            self.im.Publish("bnd_away_crest", { name = "$Crest", id = match[2] })
            self.im.Publish("bnd_home_team", self.loc.LocalizeString("TeamName_Abbr15_" .. match[1]))
            self.im.Publish("bnd_away_team", self.loc.LocalizeString("TeamName_Abbr15_" .. match[2]))
            
            print(string.format(" Match found: %d vs %d (Matchday %d)", match[1], match[2], match[10] or 0))
            nextMatchFound = true
            self.im.Publish(BND_PANEL_LOADING, false)
            self.im.Publish("bnd_tour_label", tourName)
            break
        end
    end

    --  Se não encontrou match pendente do usuário
    if not nextMatchFound then
        print(" No pending user match found")
        
        --  VERIFICA SE PRECISA GERAR PRÓXIMA RODADA KNOCKOUT
        print("\n [publishMatchInfo] Checking if knockout round is complete...")
        
        -- Percorre TODAS as rodadas knockout para ver qual é a atual
        local knockoutRounds = {}
        for _, match in ipairs(g) do
            if match[7] then  -- É knockout
                if not knockoutRounds[match[9]] then
                    knockoutRounds[match[9]] = {
                        name = match[9],
                        total = 0,
                        played = 0,
                        matches = {}
                    }
                end
                knockoutRounds[match[9]].total = knockoutRounds[match[9]].total + 1
                if match[5] then
                    knockoutRounds[match[9]].played = knockoutRounds[match[9]].played + 1
                end
                table.insert(knockoutRounds[match[9]].matches, match)
            end
        end
        
        -- Verifica cada rodada na ordem correta
        local roundOrder = {"Round of 32", "Round of 16", "Quarter-Finals", "Semi-Finals", "Final"}
        for _, roundName in ipairs(roundOrder) do
            if knockoutRounds[roundName] then
                local roundData = knockoutRounds[roundName]
                print(string.format("    Round: %s | %d/%d played", roundName, roundData.played, roundData.total))
                
                -- Se TODOS os matches desta rodada foram jogados
                if roundData.played == roundData.total and roundData.total > 0 then
                    print(string.format("    %s is COMPLETE! Checking for next round...", roundName))
                    
                    -- Verifica se a próxima rodada já existe
                    local nextRoundName = ""
                    if roundName == "Round of 32" then nextRoundName = "Round of 16"
                    elseif roundName == "Round of 16" then nextRoundName = "Quarter-Finals"
                    elseif roundName == "Quarter-Finals" then nextRoundName = "Semi-Finals"
                    elseif roundName == "Semi-Finals" then nextRoundName = "Final"
                    end
                    
                    if nextRoundName ~= "" then
                        local nextRoundExists = false
                        for _, m in ipairs(g) do
                            if m[9] == nextRoundName then
                                nextRoundExists = true
                                break
                            end
                        end
                        
                        if not nextRoundExists then
                            print(string.format("    Next round (%s) DOES NOT EXIST! Generating...", nextRoundName))
                            
                            -- Coleta vencedores desta rodada
                            local winners = {}
                            for _, match in ipairs(roundData.matches) do
                                if match[6] and match[6] ~= 0 then
                                    table.insert(winners, match[6])
                                    print(string.format("       Winner: %d", match[6]))
                                end
                            end
                            
                            print(string.format("    Collected %d winners from %s", #winners, roundName))
                            
                            if #winners > 0 then
                                self:GenerateNextKnockoutRound(winners)
                                print("    Next round generated!")
                                -- Republica os dados
                                self:InitOptions()
                                self:publishMatchInfo()
                                return
                            end
                        else
                            print(string.format("    Next round (%s) already exists", nextRoundName))
                        end
                    end
                end
            end
        end
        
        --  Verifica se todos os matches de grupo terminaram
        local allGroupMatchesDone = true
        local stillHasGroupMatches = false
        
        for _, m in ipairs(g) do
            if m[8] and not m[5] then
                allGroupMatchesDone = false
                stillHasGroupMatches = true
                break
            end
        end
        
        --  Se acabou a fase de grupos e o usuário foi eliminado
        if allGroupMatchesDone and stillHasGroupMatches == false then
            print(" All group matches finished. Checking knockout generation...")
            
            -- Verifica se knockout já existe
            local knockoutExists = false
            for _, m in ipairs(g) do
                if m[7] then  -- Match é knockout
                    knockoutExists = true
                    break
                end
            end
            
            if not knockoutExists then
                print(" Generating knockout from group standings...")
                if not self.isLeagueMode then
                    --  GARANTIR QUE GroupStandings ESTÁ PREENCHIDO
                    if not GroupStandings or not GroupStandings[tourId] or not next(GroupStandings[tourId]) then
                        print(" GroupStandings empty! Recalculating before knockout generation...")
                        GroupStandings[tourId] = {}
                        for _, m in ipairs(g) do
                            if m[8] and m[5] then
                                local groupName = "GROUP " .. m[9]
                                if not GroupStandings[tourId][groupName] then
                                    GroupStandings[tourId][groupName] = {}
                                end
                                local st = GroupStandings[tourId][groupName]
                                for _, tid in ipairs({m[1], m[2]}) do
                                    if not st[tid] then
                                        st[tid] = {
                                            teamId = tid, played = 0, win = 0, draw = 0, loss = 0,
                                            goalsFor = 0, goalsAgainst = 0, points = 0
                                        }
                                    end
                                end
                                local hs, as = st[m[1]], st[m[2]]
                                hs.played, as.played = hs.played + 1, as.played + 1
                                hs.goalsFor, hs.goalsAgainst = hs.goalsFor + m[3], hs.goalsAgainst + m[4]
                                as.goalsFor, as.goalsAgainst = as.goalsFor + m[4], as.goalsAgainst + m[3]
                                if m[3] > m[4] then
                                    hs.win, as.loss, hs.points = hs.win + 1, as.loss + 1, hs.points + 3
                                elseif m[4] > m[3] then
                                    as.win, hs.loss, as.points = as.win + 1, hs.loss + 1, as.points + 3
                                else
                                    hs.draw, as.draw = hs.draw + 1, as.draw + 1
                                    hs.points, as.points = hs.points + 1, as.points + 1
                                end
                            end
                        end
                    end
                    self:GenerateKnockoutFromGroupStandings()
                end
            end
            
            --  Busca por matches de knockout do usuário
            for _, match in ipairs(g) do
                if not match[5] and match[7] and (match[1] == userTeamId or match[2] == userTeamId) then
                    print(string.format(" User knockout match found: %d vs %d (%s)", 
                        match[1], match[2], match[9]))
                    
                    self.im.Publish("bnd_match_visible", true)
                    self.im.Publish(BND_HUB_ACTIONS_VISIBLE, false)
                    self.im.Publish("bnd_home_crest", { name = "$Crest", id = match[1] })
                    self.im.Publish("bnd_away_crest", { name = "$Crest", id = match[2] })
                    self.im.Publish("bnd_home_team", self.loc.LocalizeString("TeamName_Abbr15_" .. match[1]))
                    self.im.Publish("bnd_away_team", self.loc.LocalizeString("TeamName_Abbr15_" .. match[2]))
                    self.im.Publish("bnd_text", match[9] or "Knockout")
                    
                    nextMatchFound = true
                    self.im.Publish(BND_PANEL_LOADING, false)
                    self.im.Publish("bnd_tour_label", tourName)
                    return
                end
            end
        end
        
        --  Se não encontrou nenhum match (usuário eliminado ou fase finalizada)
        if not nextMatchFound then
            print(" User has no more matches. Showing standings...")
            
            self.im.Publish("bnd_match_visible", false)
            self.im.Publish(BND_HUB_ACTIONS_VISIBLE, true)
            self:InitOptions()
            
            local stillUnplayedMatches = false
            for _, m in ipairs(g) do
                if not m[5] then
                    stillUnplayedMatches = true
                    break
                end
            end

            if stillUnplayedMatches then
                print(" Tournament has unplayed matches. Simulating rest...")
                self:SimulateRestOfTournament(true)
            else
                print(" Tournament fully completed or user eliminated.")
                
                -- Tenta encontrar campeão
                if g and #g > 0 then
                    local final = g[#g]
                    if final and final[9] == "Final" and final[5] then
                        self.tourData.championCrest.id = final[6]
                        self.tourData.isFinish = true
                        print(" Champion found: " .. final[6])
                        self:InitOptions()
                        self:publishChampion()
                        self.im.Publish(BND_PANEL_LOADING, false)
                        return
                    end
                end
                
                self.im.Publish("bnd_text", "Tournament ended")
            end
        end
    end

    self.im.Publish(BND_PANEL_LOADING, false)
    self.im.Publish("bnd_tour_label", tourName)
end

function MatchSelect:ShuffleArray(array)
    for i = #array, 2, -1 do
        local j = math.random(i)
        array[i], array[j] = array[j], array[i]
    end
    return array
end

function MatchSelect:SimulateCurrentMatchday()
    local tourId = GlobalTournamentSettings.tourId or 1
    local group = QuickTourGrouping[tourId]
    if not group then return end

    local matchday = -1
    for _, match in ipairs(group) do
        if not match[5] and match[8] then
            matchday = match[10]
            break
        end
    end
    if matchday == -1 then 
        print(" No unplayed group matches found")
        return 
    end

    print(" Simulating Matchday " .. matchday)

    TournamentStats[tourId] = TournamentStats[tourId] or {
        Goals = {}, Assists = {}, Appearances = {},
        YellowCards = {}, RedCards = {}
    }

    local matchesSimulated = 0
    for _, match in ipairs(group) do
        local homeId, awayId = match[1], match[2]
        if match[8] and match[10] == matchday and not match[5] then
            matchesSimulated = matchesSimulated + 1

            local scores = self:GetTeamRealScore(homeId, awayId, true)
            match[3], match[4], match[5] = scores[homeId], scores[awayId], true
            if match[3] > match[4] then match[6] = homeId
            elseif match[4] > match[3] then match[6] = awayId
            else match[6] = 0 end

            local homePlayers = TeamPlayerCache[tourId] and TeamPlayerCache[tourId][homeId] or {}
            local awayPlayers = TeamPlayerCache[tourId] and TeamPlayerCache[tourId][awayId] or {}

            local function recordGoals(numGoals, players, teamId)
                for _ = 1, numGoals do
                    if #players > 0 then
                        local p = players[math.random(#players)]
                        if p and p.CARD_ID then
                            TournamentStats[tourId].Goals[p.CARD_ID] = (TournamentStats[tourId].Goals[p.CARD_ID] or 0) + 1
                        end
                    end
                end
            end

            recordGoals(match[3], homePlayers, homeId)
            recordGoals(match[4], awayPlayers, awayId)

            local function recordAppearances(players)
                for _, p in ipairs(players) do
                    if p.CARD_ID then
                        TournamentStats[tourId].Appearances[p.CARD_ID] = (TournamentStats[tourId].Appearances[p.CARD_ID] or 0) + 1
                    end
                end
            end

            recordAppearances(homePlayers)
            recordAppearances(awayPlayers)
        end
    end

    if matchesSimulated > 0 then
        print(" Simulated " .. matchesSimulated .. " matches for matchday " .. matchday)
    end

    self:SaveMatchResult()

    local allGroupDone = true
    for _, match in ipairs(group) do
        if match[8] and not match[5] then
            allGroupDone = false
            break
        end
    end

    if allGroupDone then
        print(" All group matches finished. Proceeding to Knockout...")
        self:GenerateKnockoutFromGroupStandings()
    end

    self:InitOptions()
end

function MatchSelect:SimulateCurrentKnockoutRound()
    local tourId = GlobalTournamentSettings.tourId or 1
    if not QuickTourGrouping[tourId] then return end

    local group = QuickTourGrouping[tourId]
    local round = nil

    for _, m in ipairs(group) do 
        if not m[5] and m[7] then 
            round = m[9] 
            break 
        end 
    end

    if not round then
        print(" No current knockout round found to simulate.")
        return
    end

    print(" Simulating all other matches in " .. round .. "...")
    
    local userTeamId = currentTourInfo[tourId].homeID
    local allOtherMatchesPlayed = true

    for i, m in ipairs(group) do
        if m[9] == round and not m[5] then
            if m[1] == userTeamId or m[2] == userTeamId then
                print("--> Skipping simulation for user's match: " .. m[1] .. " vs " .. m[2])
                allOtherMatchesPlayed = false
            else
                self:SimulateKnockoutMatch(i)
            end
        end
    end
    
    local isRoundFinished = true
    for _, m in ipairs(group) do
        if m[9] == round and not m[5] then
            isRoundFinished = false
            break
        end
    end

    if isRoundFinished then
        print(" All matches in " .. round .. " are complete. Generating next round...")
        local winners = {}
        for _, m in ipairs(group) do
            if m[9] == round then
                table.insert(winners, m[6])
            end
        end
        if #winners > 0 then
            self:GenerateNextKnockoutRound(winners)
        end
    else
        print("--> User must play their match before the next round can be generated.")
    end

    self:InitOptions()
    self:publishMatchInfo()
end

function MatchSelect:SimulateKnockoutMatch(index)
    local tourId = GlobalTournamentSettings.tourId or 1
    if not QuickTourGrouping[tourId] or not QuickTourGrouping[tourId][index] then 
        print(" Invalid match index: " .. index)
        return
    end
    
    local m = QuickTourGrouping[tourId][index]
    if m[5] then return end
    
    local s1, s2 = math.random(0, 4), math.random(0, 4)
    local w = (s1 > s2) and m[1] or (s2 > s1) and m[2] or ((math.random(1, 2) == 1) and m[1] or m[2])
    
    if s1 == s2 then 
        if w == m[1] then s1 = s1 + 1 else s2 = s2 + 1 end
    end
    
    m[3], m[4], m[5], m[6] = s1, s2, true, w
    print(" Match " .. index .. ": " .. m[1] .. " " .. s1 .. "-" .. s2 .. " " .. m[2] .. " | Winner: " .. w)
end

function MatchSelect:GenerateNextKnockoutRound(teams)
    local tourId = GlobalTournamentSettings.tourId or 1
    if #teams < 2 then
        if #teams == 1 then 
            print(" Final match winner determined. Tournament ends.")
        else 
            print(" Not enough teams for next round: " .. #teams)
        end
        return
    end
    
    local currentRoundName = ""
    for i = #QuickTourGrouping[tourId], 1, -1 do 
        if QuickTourGrouping[tourId][i][7] then 
            currentRoundName = QuickTourGrouping[tourId][i][9]
            break
        end 
    end
    
    local nextRoundName = ""
    if currentRoundName == "Round of 32" then 
        nextRoundName = "Round of 16"
    elseif currentRoundName == "Round of 16" then 
        nextRoundName = "Quarter-Finals"
    elseif currentRoundName == "Quarter-Finals" then 
        nextRoundName = "Semi-Finals"
    elseif currentRoundName == "Semi-Finals" then 
        nextRoundName = "Final"
    else 
        print(" Unknown or final round: " .. tostring(currentRoundName))
        return
    end
    
    print(" Generating " .. nextRoundName .. " with " .. #teams .. " teams")
    self:ShuffleArray(teams)
    
    for i = 1, #teams, 2 do
        if teams[i] and teams[i+1] then
            table.insert(QuickTourGrouping[tourId], {
                teams[i], 
                teams[i+1], 
                0, 0, 
                false,
                0,
                true,
                false,
                nextRoundName, 
                1
            })
            print(" Created match: " .. teams[i] .. " vs " .. teams[i+1])
        end
    end
    
    self:InitOptions()
    self:publishMatchInfo()
end

function MatchSelect:SimulateRestOfKnockout()
    local tourId = GlobalTournamentSettings.tourId or 1
    local group = QuickTourGrouping[tourId]
    
    if not group then return end
    
    print(" Simulating remaining knockout matches...")
    
    local maxIterations = 100
    local iteration = 0
    local userTeamId = currentTourInfo[tourId] and currentTourInfo[tourId].homeID
    
    while iteration < maxIterations do
        iteration = iteration + 1
        
        local simulatedAny = false
        local userMatchExists = false
        
        for i, match in ipairs(group) do
            if match[7] and not match[5] then
                if match[1] == userTeamId or match[2] == userTeamId then
                    print(string.format("  [User Match] Found unplayed user match: %d vs %d", match[1], match[2]))
                    userMatchExists = true
                else
                    print(string.format("  [Simulating] %d vs %d", match[1], match[2]))
                    self:SimulateKnockoutMatch(i)
                    simulatedAny = true
                    break
                end
            end
        end
        
        if userMatchExists then
            print(" User has unplayed knockout match. Stopping simulation.")
            self:InitOptions()
            self:publishMatchInfo()
            return
        end
        
        if not simulatedAny then
            print(" No matches to simulate. Checking for round completion...")
            
            local lastRound = ""
            for i = #group, 1, -1 do
                if group[i][7] then
                    lastRound = group[i][9]
                    break
                end
            end
            
            if lastRound == "" then
                print(" No knockout rounds found")
                break
            end
            
            print(" Round found: " .. lastRound)
            
            local winners = {}
            local roundComplete = true
            local roundMatchCount = 0
            
            for _, match in ipairs(group) do
                if match[9] == lastRound then
                    roundMatchCount = roundMatchCount + 1
                    if not match[5] then
                        roundComplete = false
                        print(string.format("  Unplayed match in %s: %d vs %d", lastRound, match[1], match[2]))
                    else
                        if match[6] and match[6] ~= 0 then
                            table.insert(winners, match[6])
                        end
                    end
                end
            end
            
            print(string.format(" Round Status - Matches: %d, Winners: %d, Complete: %s", 
                roundMatchCount, #winners, tostring(roundComplete)))
            
            if roundComplete and #winners > 0 then
                print(" Round " .. lastRound .. " complete!")
                
                if #winners == 1 then
                    self.tourData.championCrest.id = winners[1]
                    self.tourData.isFinish = true
                    print(" CHAMPION: " .. winners[1])
                    self:InitOptions()
                    self:publishChampion()
                    return
                else
                    print(" Generating next knockout round with " .. #winners .. " teams...")
                    self:GenerateNextKnockoutRound(winners)
                    
                    print(" Checking for user match in new round...")
                    local userHasMatchInNewRound = false
                    for _, match in ipairs(group) do
                        if not match[5] and (match[1] == userTeamId or match[2] == userTeamId) then
                            print(string.format(" User match found: %d vs %d", match[1], match[2]))
                            userHasMatchInNewRound = true
                            break
                        end
                    end
                    
                    if userHasMatchInNewRound then
                        print(" User has match in new round. Stopping simulation.")
                        self:InitOptions()
                        self:publishMatchInfo()
                        return
                    else
                        print(" User not in new round. Continuing simulation...")
                    end
                end
            else
                print(" Round not complete or no winners. Breaking simulation.")
                break
            end
        end
    end
    
    print(" Simulation loop ended (maxIterations or break)")
    
    if iteration >= maxIterations then
        print(" Max iterations reached")
    end
    
    self:InitOptions()
    self:publishMatchInfo()
end

function MatchSelect:GenerateKnockoutFromGroupStandings()
    local tourId = GlobalTournamentSettings.tourId or 1
    if not GroupStandings or not GroupStandings[tourId] then 
        print(" ERROR: Group standings data not found for tourId: " .. tourId)
        return 
    end

    local totalGroups = self.totalGroups or 12
    local teamsCount = self.teamCount or 32
    local knockoutRound = "Round of 16"
    
    if teamsCount == 16 then
        knockoutRound = "Quarter-Finals"
    elseif teamsCount == 24 then
        knockoutRound = "Round of 16"
    elseif teamsCount == 32 then
        knockoutRound = "Round of 16"
    elseif teamsCount == 48 then
        knockoutRound = "Round of 32"
    end

    print(" Generating knockout stage with " .. knockoutRound .. " for " .. teamsCount .. "-team tournament...")
    QuickTourGrouping[tourId] = QuickTourGrouping[tourId] or {}

    local standings = GroupStandings[tourId]
    local groupWinners, groupRunnersUp, thirdPlaceds, groupNames = {}, {}, {}, {}

    for groupName, _ in pairs(standings) do 
        table.insert(groupNames, groupName) 
    end
    table.sort(groupNames, function(a, b)
        return a:sub(-1) < b:sub(-1)
    end)

    for _, groupName in ipairs(groupNames) do
        local groupData = standings[groupName]
        local teamsArray = {}
        for _, stats in pairs(groupData) do table.insert(teamsArray, stats) end

        table.sort(teamsArray, function(a, b)
            if a.points ~= b.points then return a.points > b.points end
            local diffA = a.goalsFor - a.goalsAgainst
            local diffB = b.goalsFor - b.goalsAgainst
            if diffA ~= diffB then return diffA > diffB end
            if a.goalsFor ~= b.goalsFor then return a.goalsFor > b.goalsFor end
            return a.teamId < b.teamId
        end)

        if #teamsArray >= 1 then table.insert(groupWinners, teamsArray[1].teamId) end
        if #teamsArray >= 2 then table.insert(groupRunnersUp, teamsArray[2].teamId) end
        if #teamsArray >= 3 then table.insert(thirdPlaceds, teamsArray[3]) end
    end

    local knockoutTeams = {}
    
    if teamsCount == 16 then
        for _, id in ipairs(groupWinners) do table.insert(knockoutTeams, id) end
        for _, id in ipairs(groupRunnersUp) do table.insert(knockoutTeams, id) end
    elseif teamsCount == 24 then
        table.sort(thirdPlaceds, function(a, b)
            if a.points ~= b.points then return a.points > b.points end
            local gdA = (a.goalsFor or 0) - (a.goalsAgainst or 0)
            local gdB = (b.goalsFor or 0) - (b.goalsAgainst or 0)
            if gdA ~= gdB then return gdA > gdB end
            return a.goalsFor > b.goalsFor
        end)
        
        local bestThirds = {}
        for i = 1, 4 do
            if thirdPlaceds[i] then table.insert(bestThirds, thirdPlaceds[i].teamId) end
        end

        for _, id in ipairs(groupWinners) do table.insert(knockoutTeams, id) end
        for _, id in ipairs(groupRunnersUp) do table.insert(knockoutTeams, id) end
        for _, id in ipairs(bestThirds) do table.insert(knockoutTeams, id) end
    elseif teamsCount == 32 then
        for _, id in ipairs(groupWinners) do table.insert(knockoutTeams, id) end
        for _, id in ipairs(groupRunnersUp) do table.insert(knockoutTeams, id) end
    elseif teamsCount == 48 then
        table.sort(thirdPlaceds, function(a, b)
            if a.points ~= b.points then return a.points > b.points end
            local gdA = (a.goalsFor or 0) - (a.goalsAgainst or 0)
            local gdB = (b.goalsFor or 0) - (b.goalsAgainst or 0)
            if gdA ~= gdB then return gdA > gdB end
            return a.goalsFor > b.goalsFor
        end)
        
        local bestThirds = {}
        for i = 1, 8 do
            if thirdPlaceds[i] then table.insert(bestThirds, thirdPlaceds[i].teamId) end
        end

        for _, id in ipairs(groupWinners) do table.insert(knockoutTeams, id) end
        for _, id in ipairs(groupRunnersUp) do table.insert(knockoutTeams, id) end
        for _, id in ipairs(bestThirds) do table.insert(knockoutTeams, id) end
    end

    print(" Knockout teams (" .. #knockoutTeams .. "): qualifying for " .. knockoutRound)

    self:ShuffleArray(knockoutTeams)
    local matchday = 1

    for i = 1, #knockoutTeams, 2 do
        if knockoutTeams[i] and knockoutTeams[i+1] then
            table.insert(QuickTourGrouping[tourId], {
                knockoutTeams[i],
                knockoutTeams[i+1],
                0, 0,
                false,
                0,
                true,
                false,
                knockoutRound,
                matchday
            })
            matchday = matchday + 1
        end
    end
    print(" " .. knockoutRound .. " created with " .. matchday - 1 .. " matches")
end

function MatchSelect:RecordPlayerStats(playerID, statsToRecord)
    local tourId = GlobalTournamentSettings.tourId or 1
    if not playerID or not TournamentStats[tourId] then return end

    local stats = TournamentStats[tourId]
    
    if statsToRecord.goals then
        stats.Goals[playerID] = (stats.Goals[playerID] or 0) + statsToRecord.goals
    end
    if statsToRecord.assists then
        stats.Assists[playerID] = (stats.Assists[playerID] or 0) + statsToRecord.assists
    end
    if statsToRecord.yellow_cards then
        stats.YellowCards[playerID] = (stats.YellowCards[playerID] or 0) + statsToRecord.yellow_cards
    end
    if statsToRecord.red_cards then
        stats.RedCards[playerID] = (stats.RedCards[playerID] or 0) + statsToRecord.red_cards
    end
    if statsToRecord.appearance then
        stats.Appearances[playerID] = (stats.Appearances[playerID] or 0) + statsToRecord.appearance
    end
end

function MatchSelect:PlayMatch()
    local tourId = GlobalTournamentSettings.tourId or 1
    local g = QuickTourGrouping[tourId]

    if not g or #g == 0 then
        print(" MatchSelect: No tournament schedule found.")
        return
    end

    local userTeamId = currentTourInfo[tourId] and currentTourInfo[tourId].homeID
    if not userTeamId or userTeamId == 0 then
        print(" MatchSelect: Invalid user team ID.")
        return
    end

    for i, matchData in ipairs(g) do
        if not matchData[5] and (matchData[1] == userTeamId or matchData[2] == userTeamId) then
            print(" MatchSelect: Match found at index:", i)
            currentPlayedMatchIndex = i

            local tourName = tourIdToNameMap[tourId] or tourIdToNameMap.default
            local roundName = ""
            if matchData[7] then
                roundName = matchData[9]
            elseif matchData[8] then
                if self.isLeagueMode then
                    roundName = "LEAGUE MATCHDAY " .. matchData[10]
                else
                    roundName = "GROUP " .. matchData[9]
                end
            end

            currentTourData.homeID = matchData[1]
            currentTourData.awayID = matchData[2]
            currentTourData.isUserSideHome = (matchData[1] == userTeamId) and 0 or 1
            currentTourData.homeKitIndex = 0
            currentTourData.awayKitIndex = 1
            currentTourData.tourIndex = tourId
            currentTourData.tourName = tourName
            currentTourData.roundName = roundName

            currentMatch.HomeTeamID = matchData[1]
            currentMatch.AwayTeamID = matchData[2]
            currentMatch.HomeKitIndex = 0
            currentMatch.AwayKitIndex = 1

            self.nav.Event(nil, "evt_show_popup", {
                title = "INFO",
                message = "Are you ready to play this match?",
                buttons = {
                    {
                        icon = "$FooterIconNo",
                        label = "Cancel",
                        clickEvents = { "evt_hide_popup" }
                    },
                    {
                        icon = "$FooterIconYes",
                        label = "Confirm",
                        clickEvents = {
                            "evt_advance",
                            "evt_hide_popup"
                        }
                    }
                }
            })

            return
        end
    end

    print(" MatchSelect: No match available for your team.")
end

function MatchSelect:Belum()
    self.nav.Event(nil, "evt_show_popup", {
        title = "INFO",
        message = "We're working on it. \nPlease check back for upcoming updates.",
        buttons = {
            {
                icon = "$FooterIconYes",
                label = "OK",
                clickEvents = { "evt_hide_popup" }
            }
        }
    })
end

function MatchSelect:StopMatch() 
    self:SimulateRestOfTournament(true) 
end

function MatchSelect:GetTeamRealScore(a, b, allowDraw)
    local ai = self.services.SquadManagementService.GetTeamInfo(a)
    local bi = self.services.SquadManagementService.GetTeamInfo(b)

    local sa, sb = math.random(0, 5), math.random(0, 5)
    local diff = (ai.overall or 75) - (bi.overall or 75)
    local bias = 50 + (diff * 2)

    if math.random(1, 100) <= bias then
        if sa < sb then sa, sb = sb, sa end
    else
        if sb < sa then sa, sb = sb, sa end
    end

    if sa == sb and not allowDraw then
        if math.random(1, 100) <= bias then
            sa = sa + 1
        else
            sb = sb + 1
        end
    end

    local r = {}
    r[a] = sa
    r[b] = sb
    return r
end

function MatchSelect:SaveMatchResult()
    local tourId = GlobalTournamentSettings.tourId or 1
    local group = QuickTourGrouping[tourId]
    if not group then return end

    print(" Recalculating all standings...")
    GroupStandings[tourId] = {}

    for _, m in ipairs(group) do
        if m[8] and m[5] then
            local home, away, hs, as = m[1], m[2], m[3], m[4]
            local groupName = "GROUP " .. m[9]
            
            if not GroupStandings[tourId][groupName] then
                GroupStandings[tourId][groupName] = {}
            end
            local g = GroupStandings[tourId][groupName]

            for _, tid in ipairs({home, away}) do
                if not g[tid] then
                    g[tid] = { teamId = tid, played = 0, win = 0, draw = 0, loss = 0, goalsFor = 0, goalsAgainst = 0, points = 0 }
                end
            end
            
            local hstat = g[home]
            local astat = g[away]
            hstat.played = hstat.played + 1
            astat.played = astat.played + 1
            hstat.goalsFor = hstat.goalsFor + hs
            hstat.goalsAgainst = hstat.goalsAgainst + as
            astat.goalsFor = astat.goalsFor + as
            astat.goalsAgainst = astat.goalsAgainst + hs
            
            if hs > as then 
                hstat.win = hstat.win + 1
                astat.loss = astat.loss + 1
                hstat.points = hstat.points + 3
            elseif as > hs then 
                astat.win = astat.win + 1
                hstat.loss = hstat.loss + 1
                astat.points = astat.points + 3
            else 
                hstat.draw = hstat.draw + 1
                astat.draw = astat.draw + 1
                hstat.points = hstat.points + 1
                astat.points = astat.points + 1
            end
        end
    end
    print(" Standings recalculation complete.")
end

function MatchSelect:SimulateRestOfTournament(forceSim)
    local tourId = GlobalTournamentSettings.tourId or 1
    local userTeamId = currentTourInfo[tourId] and currentTourInfo[tourId].homeID

    print(" Simulating rest of tournament... (forceSim: " .. tostring(forceSim) .. ")")
    local simulationLimit = 150
    local count = 0
    local lastMatchCount = -1
    local noProgressCount = 0
    
    while not self.tourData.isFinish and count < simulationLimit do
        count = count + 1
        
        local currentMatchCount = 0
        if QuickTourGrouping[tourId] then
            for _, m in ipairs(QuickTourGrouping[tourId]) do
                if m[5] then currentMatchCount = currentMatchCount + 1 end
            end
        end
        
        if currentMatchCount == lastMatchCount then
            noProgressCount = noProgressCount + 1
            if noProgressCount > 5 then
                print(" Simulation stuck (no progress). Breaking...")
                break
            end
        else
            noProgressCount = 0
        end
        lastMatchCount = currentMatchCount
        
        local groupMatchesLeft = false
        if QuickTourGrouping[tourId] then 
            for _, m in ipairs(QuickTourGrouping[tourId]) do 
                if m[8] and not m[5] then 
                    if not forceSim and (m[1] == userTeamId or m[2] == userTeamId) then
                        print(" Simulation paused: Next match is user's match (Group Stage).")
                        return 
                    end
                    groupMatchesLeft = true
                    break 
                end 
            end
        end
        
        if groupMatchesLeft then 
            print(" Simulating group matches... (iteration " .. count .. ")")
            self:SimulateCurrentMatchday()
        else
            local knockoutMatchesLeft = false
            if QuickTourGrouping[tourId] then 
                for _, m in ipairs(QuickTourGrouping[tourId]) do 
                    if m[7] and not m[5] then 
                        if not forceSim and (m[1] == userTeamId or m[2] == userTeamId) then
                            print(" Simulation paused: Next match is user's match (Knockout Stage).")
                            return
                        end
                        knockoutMatchesLeft = true
                        break 
                    end 
                end
            end
            
            if knockoutMatchesLeft then 
                print(" Simulating knockout matches... (iteration " .. count .. ")")
                self:SimulateCurrentKnockoutRound() 
            else
                print(" No more matches. Checking for tournament completion...")
                if QuickTourGrouping[tourId] and #QuickTourGrouping[tourId] > 0 then
                    local final = QuickTourGrouping[tourId][#QuickTourGrouping[tourId]]
                    if final and final[9] == "Final" and final[5] then
                        self.tourData.championCrest.id = final[6]
                        self.tourData.isFinish = true
                        print(" Simulation complete. Champion: " .. final[6])
                    else
                        print(" Final not yet played or not found. Breaking.")
                        break
                    end
                else 
                    self.tourData.isFinish = true
                    print(" No matches left. Tournament marked as finished.")
                end
                
                if self.tourData.isFinish then break end
            end
        end
    end
    
    if count >= simulationLimit then
        print(" Simulation hit iteration limit (" .. simulationLimit .. "). Forcing finish...")
        self.tourData.isFinish = true
    end
    
    self:publishChampion()
end

function MatchSelect:PlayReStart()
    local buttonNo = {
        icon = "$FooterIconNo",
        label = "Cancel",
        clickEvents = {
            "evt_hide_popup"
        }
    }
    local buttonYes = {
        icon = "$FooterIconYes",
        label = "Confirm",
        clickEvents = {
            "evt_restart",
            "evt_hide_popup"
        }
    }
    local popupData = {
        title = "INFO",
        message = "Do you want to end the current competition?",
        buttons = {buttonNo, buttonYes}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
end

-- Verifica e gera próxima rodada knockout se necessário
function MatchSelect:CheckAndGenerateNextKnockoutRound()
    local tourId = GlobalTournamentSettings.tourId or 1
    local group = QuickTourGrouping[tourId]
    
    if not group then return end
    
    print("\n [CheckAndGenerateNextKnockoutRound] Checking for completed knockout round...")
    
    -- Encontra a última rodada de knockout
    local lastRound = nil
    local lastRoundMatches = {}
    
    for _, match in ipairs(group) do
        if match[7] then  -- É knockout
            if lastRound ~= match[9] then
                lastRound = match[9]
                lastRoundMatches = {}
            end
            table.insert(lastRoundMatches, match)
        end
    end
    
    if not lastRound then
        print("    No knockout round found")
        return
    end
    
    print(string.format("    Last knockout round: %s", lastRound))
    print(string.format("    Total matches in this round: %d", #lastRoundMatches))
    
    -- Verifica se TODOS os matches desta rodada foram jogados
    local allPlayed = true
    local winners = {}
    
    for _, match in ipairs(lastRoundMatches) do
        if not match[5] then
            allPlayed = false
            print(string.format("       UNPLAYED: %d vs %d", match[1], match[2]))
        else
            if match[6] and match[6] ~= 0 then
                table.insert(winners, match[6])
                print(string.format("       PLAYED: %d vs %d = Winner: %d", match[1], match[2], match[6]))
            end
        end
    end
    
    if allPlayed then
        print(string.format("    ALL MATCHES PLAYED! Found %d winners", #winners))
        
        if #winners == 1 then
            print("    CHAMPION CROWNED!")
            return
        elseif #winners > 1 then
            print(string.format("    GENERATING NEXT ROUND with %d teams", #winners))
            self:GenerateNextKnockoutRound(winners)
            return
        end
    else
        print("   ⏳ Not all matches in this round are complete")
        return
    end
end

function MatchSelect:finalize()
    self.im.UnregisterAction(ACT_RESTART)
    self.im.UnregisterAction(ACT_ADVANCE)
    self.im.UnregisterAction(ACT_BELUM)
    self.im.UnregisterAction("act_simulate")
    self.im.UnregisterAction("act_ads") 
    self.im.Publish(BND_PANEL_LOADING, false)
    self.im.Unsubscribe(BND_PANEL_LOADING)

    for _, b in ipairs({ 
        BND_ADS_A_VISIBLE, BND_ADS_B_VISIBLE, BND_COLOR_CUPID, BND_REALTIME, BND_DATE, 
        BND_LAST_MATCH_RESULT, BND_HUB_ACTIONS_VISIBLE, "bnd_bg_tour", "bnd_tour_logo", 
        "bnd_trophy", "bnd_ads", "bnd_match_visible","bnd_group_label", "bnd_home_crest", 
        "bnd_away_crest", "bnd_home_team", "bnd_away_team", "bnd_home_team_short", 
        "bnd_away_team_short", "bnd_text", "bnd_champion_visible", "bnd_champion_crest", 
        "bnd_champion_team", "bnd_home_score", "bnd_away_score", "bnd_tour_label" 
    }) do 
        self.im.Unsubscribe(b) 
    end
    
    for _, v in pairs(bndList) do self.im.Unsubscribe(v) end
    print(" MatchSelect module finalized")
end

return MatchSelect