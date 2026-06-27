-- TeamSelect.lua
-- Main script for LEAGUE DAVUNPES

local Brain, Save, Squads = ... -- Load Brain.lua

local TeamSelect = {}
TeamListData = {}
ligaId = 1
GLOBAL_DATE_PLACEHOLDER = GLOBAL_DATE_PLACEHOLDER or "01/08/24" -- Default value
GLOBAL_MATCHUP_COUNT = GLOBAL_MATCHUP_COUNT or 0 -- Default value
gamemode = "missionMode"

-- Store save data reference
local saveData = Save

-- Function to deep copy a table
local function deepCopy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Debug function to print table contents
local function debugTable(tbl, name)
    print("Debugging " .. name .. ":")
    if not tbl then
        print(name .. " is nil")
        return
    end
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(k .. " = [table]")
        else
            print(k .. " = " .. tostring(v))
        end
    end
end

-- Function to reformat matchDates based on GLOBAL_DATE_PLACEHOLDER
local function reformatMatchDates(matchDates, globalDate)
    local reformattedDates = {}
    local day, month, year = globalDate:match("(%d+)/(%d+)/(%d+)")
    month = tonumber(month)
    year = tonumber(year)
    local oldYear, newYear
    if month >= 8 and month <= 12 then
        oldYear = year
        newYear = year + 1
    else
        oldYear = year - 1
        newYear = year
    end
    print("reformatMatchDates: month=" .. month .. ", year=" .. year .. ", oldYear=" .. oldYear .. ", newYear=" .. newYear)

    for _, date in ipairs(matchDates) do
        local dateStr = tostring(date)
        if #dateStr == 3 then
            dateStr = "0" .. dateStr
        end
        local matchMonth, matchDay = dateStr:match("(%d%d)(%d%d)")
        matchMonth = tonumber(matchMonth)
        local reformattedDate
        if month >= 8 and month <= 12 then
            -- Old year for 0801-1231, new year for 0101-0731
            if matchMonth >= 8 and matchMonth <= 12 then
                reformattedDate = dateStr .. string.format("%02d", oldYear)
            else
                reformattedDate = dateStr .. string.format("%02d", newYear)
            end
        else
            -- New year for 0101-0731, old year for 0801-1231
            if matchMonth >= 1 and matchMonth <= 7 then
                reformattedDate = dateStr .. string.format("%02d", newYear)
            else
                reformattedDate = dateStr .. string.format("%02d", oldYear)
            end
        end
        table.insert(reformattedDates, reformattedDate)
    end
    return reformattedDates
end

function TeamSelect:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    o.services = { SquadManagementService = o.api("SquadMgtService"), TacticsService = o.api("TacticsService") }
    o.squads = Squads:new({services = o.services})
    o.brain = Brain:new({squads = o.squads})

    -- Debug savemode and initial globals
    print("savemode = " .. tostring(savemode))
    print("Initial globals: GLOBAL_MATCHUP_COUNT = " .. tostring(GLOBAL_MATCHUP_COUNT) .. ", GLOBAL_DATE_PLACEHOLDER = " .. tostring(GLOBAL_DATE_PLACEHOLDER))
    debugTable(saveData.TeamList, "saveData.TeamList before reset")

    -- Reset TeamList based on savemode
    if savemode == 1 then
        TeamList = deepCopy(saveData.TeamList)
        print("Reset TeamList to saveData.TeamList in savemode 1")
    else
        TeamList = TeamList or deepCopy(saveData.TeamList)
        print("Using existing TeamList or fallback to saveData.TeamList")
        allMatchdays = o.brain:generateSchedule(TeamList, "automatic")
        print("Generated allMatchdays for new game")
    end
    debugTable(TeamList, "TeamList after reset")

    o:InitGrouping(currentSelectedTeamID)
    o.nav.Event(nil, "evt_team_select")
    return o
end

function TeamSelect:InitGrouping(teamId)
    if not LigaGrouping[ligaId] then
        -- Initialize global tables
        yellowCardRecords, redCardRecords, TeamFunds, injuryRecords, isSuspended, redCardMatchCount, injuryRecoveryDate, GOALS, matchdayLoaded, transferredPlayers = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
        revenue = {}
        TeamPlayerCache = {}
        FREE_AGENTS = {}
        hGs = {} -- highest goalscorer
        nFs = {} -- next fixture
        sheets = sheets or {}
        transferHistory = {}
        sheets[1] = {players = {}, formationid = nil, status = "empty"}
        sheets[2] = {players = {}, formationid = nil, status = "empty"}
        sheets[3] = {players = {}, formationid = nil, status = "empty"}
        sheets[4] = {players = {}, formationid = nil, status = "empty"}
        matchDates, origMatchDates = {}, {}
        newSession = "yes"
        currentLigaInfo[ligaId] = { Index = ligaId, homeID = teamId, difficulty = 1, isSuccess = 0 }
        
        -- Immediately reformat matchDates if they exist
    if matchDates and #matchDates > 0 then
        matchDates = reformatMatchDates(matchDates, GLOBAL_DATE_PLACEHOLDER)
        print("Reformatted matchDates: " .. table.concat(matchDates, ", "))
    end

        -- Use the reset TeamList
        self.brain:calculateTeamFunds(self.services, TeamList)
        local numMatchdays = (#TeamList * 2) - 2
        if #matchDates == 0 then
            matchDates = self.brain:generateMatchDates(numMatchdays, 2024)
            -- Reformat newly generated matchDates
            origMatchDates = matchDates
            matchDates = reformatMatchDates(matchDates, GLOBAL_DATE_PLACEHOLDER)
            print("Generated and reformatted matchDates: " .. table.concat(matchDates, ", "))
        end
        self.brain:cacheTeamPowers(self.services, TeamList)
        self:cacheAllTeamPlayers()
        GLOBAL_FUNDS = self.brain.TeamFunds[currentSelectedTeamID]

        -- Moves player in team to reserves if in starting lineup
        function swapPlayersInTeam(teamPlayers, cardIDToSwap)
            local playerToSwap, playerToSwapIndex, playerPositionToMatch = nil, nil, nil
            for index, player in ipairs(teamPlayers) do
                if player.CARD_ID == cardIDToSwap then
                    playerToSwap, playerToSwapIndex, playerPositionToMatch = player, index, player.position
                    break
                end
            end
            if not playerToSwap then
                return false
            end
            if playerToSwapIndex > 11 then
                return true
            end
            for index = 12, #teamPlayers do
                local player = teamPlayers[index]
                if player.position == playerPositionToMatch then
                    teamPlayers[playerToSwapIndex], teamPlayers[index] = teamPlayers[index], teamPlayers[playerToSwapIndex]
                    return true
                end
            end
            return false
        end

        -- Moves player object from sourceTeam to targetTeam
        function transferPlayer(playerID, sourceTeamID, targetTeamID)
		    if transferredPlayers[playerID] then
		        print("[TeamManagementModel]: Player with CARD_ID " .. playerID .. " already transferred")
		        return
		    end
		
		    local sourceTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, sourceTeamID, 0)
		    if not sourceTeamPlayers or #sourceTeamPlayers == 0 then
		        error("[TeamManagementModel]: No players found for source teamID " .. sourceTeamID)
		    end
		
		    if sourceTeamID == currentSelectedTeamID then
		        local swapSuccess = swapPlayersInTeam(sourceTeamPlayers, playerID)
		        if not swapSuccess then
		            -- Placeholder for swap failure handling
		        end
		    end
		
		    local playerToTransfer, playerIndex = nil, nil
		    for index, player in ipairs(sourceTeamPlayers) do
		        if player.CARD_ID == playerID then
		            playerToTransfer = player
		            playerIndex = index
		            break
		        end
		    end
		    if not playerToTransfer then
		        print("[TeamManagementModel]: Player with CARD_ID " .. playerID .. " not found in source team")
		        return
		    end
		
		    -- Remove player from source team
		    table.remove(sourceTeamPlayers, playerIndex)
		    local updatedSourceTeamPlayerIDs = {}
		    for _, player in ipairs(sourceTeamPlayers) do
		        if player then
		            table.insert(updatedSourceTeamPlayerIDs, player.CARD_ID)
		        end
		    end
		    self.services.SquadManagementService.SetCurrentPlayerLineup(0, sourceTeamID, 0, 0, updatedSourceTeamPlayerIDs)
		    TeamPlayerCache[sourceTeamID] = sourceTeamPlayers
		
		    -- Add player to target team
		    local targetTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, targetTeamID, 0)
		    if not targetTeamPlayers or #targetTeamPlayers == 0 then
		        targetTeamPlayers = {}
		    end
		    playerToTransfer.teamID = targetTeamID
		    table.insert(targetTeamPlayers, playerToTransfer)
		    local updatedTargetTeamPlayerIDs = {}
		    for _, player in ipairs(targetTeamPlayers) do
		        table.insert(updatedTargetTeamPlayerIDs, player.CARD_ID)
		    end
		    self.services.SquadManagementService.SetCurrentPlayerLineup(0, targetTeamID, 0, 0, updatedTargetTeamPlayerIDs)
		    TeamPlayerCache[targetTeamID] = targetTeamPlayers
		
		    -- Update local players if relevant
		    if targetTeamID == teamID then
		        players = targetTeamPlayers
		    end
		    if sourceTeamID == teamID then
		        players = sourceTeamPlayers
		    end
		
		    transferredPlayers[playerID] = true
		    print("[TeamManagementModel]: Transferred player with CARD_ID " .. playerID .. " from teamID " .. sourceTeamID .. " to teamID " .. targetTeamID)
		end

        -- Releases a player from their team and adds them to the FREE_AGENTS table
        function releasePlayer(playerID, sourceTeamID)
            local swapPlayer = false

            -- Get the source team's current lineup
            local sourceTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, sourceTeamID, 0)
            if not sourceTeamPlayers or #sourceTeamPlayers == 0 then
                error("[TeamManagementModel]: No players found for source teamID " .. sourceTeamID)
            end

            -- If the source team is the currently selected team, try to swap the player to reserves first
            if sourceTeamID == currentSelectedTeamID then
                for i = 1, #sourceTeamPlayers do
                    if sourceTeamPlayers[i].CARD_ID == playerID then
                        if i <= 11 then
                            swapPlayer = true
                        end
                    end
                end
                if swapPlayer == true then
                    local swapSuccess = swapPlayersInTeam(sourceTeamPlayers, playerID)
                    if not swapSuccess then
                    end
                end
            end

            -- Find the player in the source team
            local playerToRelease, playerIndex = nil, nil
            for index, player in ipairs(sourceTeamPlayers) do
                if player.CARD_ID == playerID then
                    playerToRelease = player
                    playerIndex = index
                    break
                end
            end

            if not playerToRelease then
                return false
            end

            -- Remove the player from the source team
            table.remove(sourceTeamPlayers, playerIndex)

            -- Update the source team's lineup
            local updatedSourceTeamPlayerIDs = {}
            for _, player in ipairs(sourceTeamPlayers) do
                if player then
                    table.insert(updatedSourceTeamPlayerIDs, player.CARD_ID)
                end
            end
            self.services.SquadManagementService.SetCurrentPlayerLineup(0, sourceTeamID, 0, 0, updatedSourceTeamPlayerIDs)
            TeamPlayerCache[sourceTeamID] = sourceTeamPlayers

            -- Update the local players table if the source team is the current team
            if sourceTeamID == teamID then
                players = sourceTeamPlayers
            end

            playerToRelease.teamID = nil
            transferredPlayers[playerID] = true
            return true
        end

        -- Load or generate LigaGrouping and handle globals
        if savemode == 1 then
            print("Loading save data for savemode 1")
            self.brain:loadSaveCodes(self.services, Save, self.squads) -- This sets globals and LigaGrouping[1]
            LigaGrouping[ligaId] = deepCopy(LigaGrouping[1])
            print("Copied LigaGrouping[1] to LigaGrouping[" .. ligaId .. "] from loadSaveCodes")
            print("Loaded globals from save: GLOBAL_MATCHUP_COUNT = " .. tostring(GLOBAL_MATCHUP_COUNT) .. ", GLOBAL_DATE_PLACEHOLDER = " .. tostring(GLOBAL_DATE_PLACEHOLDER))
            local fixedDates = {}
            for _, date in ipairs(saveData.Dates) do
                local dateStr = tostring(date)
                if #dateStr == 3 then
                    dateStr = "0" .. dateStr
                end
                table.insert(fixedDates, dateStr)
            end
            origMatchDates = fixedDates
            matchDates = reformatMatchDates(fixedDates, GLOBAL_DATE_PLACEHOLDER) -- Reformat loaded dates
            print("Reformatted loaded matchDates: " .. table.concat(matchDates, ", "))
        else
            print("Not in savemode, generating new LigaGrouping")
            -- Reset globals for new game
            self:generateLigaGrouping()
        end
        self.brain:setUpModes(self.services, missionmode, Save)
        debugTable(LigaGrouping[ligaId], "LigaGrouping after setup")
    end
end

function TeamSelect:generateLigaGrouping()
    local groupingList = {}
    globalTeamPowers = {}
    for _, team in ipairs(TeamList) do
        local defensive, attacking = self.brain:calculateTeamPowers(self.services, team)
        defensive, attacking = self.brain:adjustForMissionMode(team, defensive, attacking)
        globalTeamPowers[team] = { defensive = defensive, attacking = attacking, totalPower = defensive + attacking }
    end
    for matchdayIndex, matchday in ipairs(allMatchdays) do
        for _, fixture in ipairs(matchday) do
            table.insert(groupingList, {
                [1] = fixture[1], [2] = fixture[2], [3] = nil, [4] = "0", [5] = "0",
                [6] = false, [7] = 1, [8] = false, [9] = true, ["data"] = { homeScorers = {}, awayScorers = {} }
            })
        end
    end
    LigaGrouping[ligaId] = groupingList
    print("Generated new LigaGrouping with " .. #groupingList .. " fixtures")
end

function TeamSelect:cacheAllTeamPlayers()
    TeamPlayerCache = {}
    for _, teamID in ipairs(TeamList) do
        local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
        if players then
            TeamPlayerCache[teamID] = players
        else
            TeamPlayerCache[teamID] = {}
        end
    end
end

function getNextFixture()
    local matchupIndex = GLOBAL_MATCHUP_COUNT + 1
    local foundMatches = 0
    local nextFixture = nil

    for i, match in ipairs(rivalListData) do
        if match.homeID == currentSelectedTeamID or match.awayID == currentSelectedTeamID then
            foundMatches = foundMatches + 1
            if foundMatches == matchupIndex then
                nextFixture = { homeID = match.homeID, awayID = match.awayID }
                break
            end
        end
    end

    if nextFixture then
        nFs = nextFixture
    else
        nFs = nil -- No fixture found for the given count
    end
end

function getCachedTeamPlayers(teamID)
    return TeamPlayerCache[teamID] or {}
end

function TeamSelect:finalize()
end

return TeamSelect
-- LEAGUE BY DAVUNPES --
-- REMODIFIED BY DAVUNPES --