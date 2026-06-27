-- Brain.lua
-- Core logic model for LEAGUE DAVUNPES

local Brain = {}
Brain.__index = Brain

function Brain:new(init)
    local o = init or {}
    setmetatable(o, self)
    o.TeamRatingsCache = o.TeamRatingsCache or {}
    o.TeamFunds = o.TeamFunds or {}
    o.gameMode = o.gameMode or "CareerMode"
    return o
end

function Brain:shuffleTeams(teams)
    local shuffled = {}
    for i, v in ipairs(teams) do shuffled[i] = v end
    math.randomseed(os.time())
    for i = #shuffled, 2, -1 do
        local j = math.random(1, i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    return shuffled
end

function Brain:generateAutomaticFixtures(teams)
    local numTeams = #teams
    local matchdays = {}
    local homeAwayBalance = {}
    for _, team in ipairs(teams) do homeAwayBalance[team] = {home = 0, away = 0} end
    
    if numTeams % 2 ~= 0 then table.insert(teams, "BYE") numTeams = numTeams + 1 end
    
    local function canPlayAtGround(team, isHome)
        local balance = homeAwayBalance[team]
        return isHome and balance.home < 2 or balance.away < 2
    end
    
    local function updateBalance(team, isHome)
        local balance = homeAwayBalance[team]
        if isHome then balance.home = balance.home + 1 balance.away = 0
        else balance.away = balance.away + 1 balance.home = 0 end
    end
    
    for i = 1, numTeams - 1 do
        local matchday = {}
        for j = 1, numTeams / 2 do
            local home, away = teams[j], teams[numTeams - j + 1]
            if not canPlayAtGround(home, true) or not canPlayAtGround(away, false) then home, away = away, home end
            if home ~= "BYE" and away ~= "BYE" then
                table.insert(matchday, {home, away})
                updateBalance(home, true)
                updateBalance(away, false)
            end
        end
        table.insert(matchdays, matchday)
        table.insert(teams, 2, table.remove(teams))
    end
    return matchdays
end

function Brain:generateManualFixtures(manualFixtures)
    local matchdays = {}
    for _, fixture in ipairs(manualFixtures) do
        local matchdayIndex = fixture.matchday
        matchdays[matchdayIndex] = matchdays[matchdayIndex] or {}
        table.insert(matchdays[matchdayIndex], {fixture.home, fixture.away})
    end
    local contiguousMatchdays = {}
    for i, matchday in pairs(matchdays) do contiguousMatchdays[i] = matchday end
    return contiguousMatchdays
end

function Brain:generateShuffledReverseFixtures(firstHalf)
    local reverseFixtures = {}
    for _, matchday in ipairs(firstHalf) do
        local reverseDay = {}
        for _, match in ipairs(matchday) do table.insert(reverseDay, {match[2], match[1]}) end
        table.insert(reverseFixtures, reverseDay)
    end
    math.randomseed(os.time())
    for i = #reverseFixtures, 2, -1 do
        local j = math.random(1, i)
        reverseFixtures[i], reverseFixtures[j] = reverseFixtures[j], reverseFixtures[i]
    end
    return reverseFixtures
end

function Brain:generateSchedule(teams, mode, manualFixtures)
    local shuffledTeams = self:shuffleTeams(teams)
    local firstHalf = mode == "manual" and self:generateManualFixtures(manualFixtures) or self:generateAutomaticFixtures(shuffledTeams)
    if mode == "manual" and (not manualFixtures or #manualFixtures == 0) then error("Manual mode requires a non-empty manualFixtures table") end
    if mode ~= "manual" and mode ~= "automatic" then error("Invalid mode: must be 'manual' or 'automatic'") end
    local secondHalf = self:generateShuffledReverseFixtures(firstHalf)
    local allMatchdays = {}
    for _, matchday in ipairs(firstHalf) do table.insert(allMatchdays, matchday) end
    for _, matchday in ipairs(secondHalf) do table.insert(allMatchdays, matchday) end
    return allMatchdays
end

function Brain:calculateTeamFunds(services, teamList)
    local minFunds, maxFunds = 10000000, 200000000
    local roundIncrement = 500000
    local teamRatings = {}
    for _, teamID in ipairs(teamList) do
        local lineup = getCachedTeamPlayers(teamID)
        local totalRating = 0
        if lineup and #lineup >= 11 then
            for i = 1, 11 do totalRating = totalRating + (lineup[i].rating or 0) end
        end
        teamRatings[teamID] = totalRating
    end
    
    local minRating, maxRating = math.huge, -math.huge
    for _, rating in pairs(teamRatings) do
        minRating = math.min(minRating, rating)
        maxRating = math.max(maxRating, rating)
    end
    
    for teamID, rating in pairs(teamRatings) do
        if maxRating == minRating then
            local avgFunds = (minFunds + maxFunds) / 2
            self.TeamFunds[teamID] = math.ceil(avgFunds / roundIncrement) * roundIncrement
        else
            local normalized = (rating - minRating) / (maxRating - minRating)
            local exaggerated = normalized ^ 2
            local rawFunds = minFunds + (exaggerated * (maxFunds - minFunds))
            self.TeamFunds[teamID] = math.ceil(rawFunds / roundIncrement) * roundIncrement
            self.TeamFunds[teamID] = math.max(minFunds, math.min(maxFunds, self.TeamFunds[teamID]))
        end
    end
    return self.TeamFunds
end

function Brain:poisson(lambda)
    local L = math.exp(-lambda)
    local k, p = 0, 1
    while p > L do
        k = k + 1
        p = p * math.random()
    end
    return k - 1
end

function Brain:simSys(startMatchday, endMatchday, teamID, teamRating)
    endMatchday = endMatchday or startMatchday
    teamID = teamID or currentSelectedTeamID
    local numTeams = #TeamList
    local matchesPerDay = math.floor(numTeams / 2)
    local base_lambda, home_advantage = 1.2, 1.15
    
    local position_multipliers = {
        ["ST"] = 4, ["CF"] = 4, ["LF"] = 4, ["RF"] = 4, ["LW"] = 3, ["RW"] = 3, ["LM"] = 3, ["RM"] = 3,
        ["CAM"] = 2, ["CM"] = 1.5, ["CDM"] = 1.5, ["LB"] = 1, ["RB"] = 1, ["CB"] = 1, ["LWB"] = 1, ["RWB"] = 1,
        ["GK"] = 0.1
    }
    
    local function select_scorer(players, weights)
        local total_weight = 0
        for _, w in ipairs(weights) do total_weight = total_weight + w end
        if total_weight <= 0 then return players[math.random(1, #players)].CARD_ID end
        local r = math.random() * total_weight
        local cumulative = 0
        for i, w in ipairs(weights) do
            cumulative = cumulative + w
            if r <= cumulative then return players[i].CARD_ID end
        end
        return players[#players].CARD_ID
    end
    
    local function getMatchdaySquad(allPlayers)
        local squad = {}
        for i = 1, math.min(18, #allPlayers) do table.insert(squad, allPlayers[i]) end
        return squad
    end
    
    for matchday = startMatchday, endMatchday do
        matchdayLoaded[GLOBAL_MATCHUP_COUNT + (matchday - startMatchday) + 1] = "loaded"
        local startIndex = (matchday - 1) * matchesPerDay + 1
        local endIndex = startIndex + matchesPerDay - 1
        
        for i = startIndex, endIndex do
            local matchData = LigaGrouping[ligaId][i]
            if matchData and (calSimMode == 1 or not (startMatchday == endMatchday and (matchData[1] == teamID or matchData[2] == teamID))) then
                local homeTeamID, awayTeamID = matchData[1], matchData[2]
                local homeRating = (homeTeamID == teamID and teamRating) or self.TeamRatingsCache[homeTeamID] or {defense = 0, attack = 0}
                local awayRating = (awayTeamID == teamID and teamRating) or self.TeamRatingsCache[awayTeamID] or {defense = 0, attack = 0}
                
                local home_attack, home_defense = math.max(1, homeRating.attack), math.max(1, homeRating.defense)
                local away_attack, away_defense = math.max(1, awayRating.attack), math.max(1, awayRating.defense)
                
                local lambda_home = base_lambda * ((home_attack / away_defense) ^ 1.15) * home_advantage
                local lambda_away = base_lambda * ((away_attack / home_defense) ^ 1.15)
                local homeGoals, awayGoals = self:poisson(lambda_home), self:poisson(lambda_away)
                
                local homePlayers = getMatchdaySquad(getCachedTeamPlayers(homeTeamID) or {})
                local awayPlayers = getMatchdaySquad(getCachedTeamPlayers(awayTeamID) or {})
                
                local home_weights = {}
                for _, player in ipairs(homePlayers) do
                    local multiplier = position_multipliers[player.position] or 1
                    local form_boost = (GOALS[player.CARD_ID] or 0) * 0.1
                    local match_form_factor = 0.9 + math.random() * 0.2
                    table.insert(home_weights, (player.rating or 1) * multiplier * match_form_factor + form_boost)
                end
                
                local away_weights = {}
                for _, player in ipairs(awayPlayers) do
                    local multiplier = position_multipliers[player.position] or 1
                    local form_boost = (GOALS[player.CARD_ID] or 0) * 0.1
                    local match_form_factor = 0.9 + math.random() * 0.2
                    table.insert(away_weights, (player.rating or 1) * multiplier * match_form_factor + form_boost)
                end
                
                for g = 1, homeGoals do if #homePlayers > 0 then
                    local scorer = select_scorer(homePlayers, home_weights)
                    GOALS[scorer] = (GOALS[scorer] or 0) + 1
                end end
                
                for g = 1, awayGoals do if #awayPlayers > 0 then
                    local scorer = select_scorer(awayPlayers, away_weights)
                    GOALS[scorer] = (GOALS[scorer] or 0) + 1
                end end
                
                matchData[4], matchData[5] = homeGoals, awayGoals
            end
        end
    end
end

function Brain:generateMatchDates(numMatchdays, startYear)
    local matchDates = {}
    local seasonStart = os.time({year = startYear, month = 8, day = 1})
    local seasonEnd = os.time({year = startYear + 1, month = 5, day = 31})
    local seasonDuration = seasonEnd - seasonStart
    local interval = math.max(math.floor(seasonDuration / (numMatchdays - 1)), 5 * 86400)
    
    local currentTime = seasonStart
    for i = 1, numMatchdays do
        table.insert(matchDates, os.date("%m%d", currentTime))
        currentTime = math.min(currentTime + interval, seasonEnd)
    end
    return matchDates
end

function Brain:cacheTeamPowers(services, teamList)
    for _, teamID in ipairs(teamList) do
        local lineup = getCachedTeamPlayers(teamID)
        local defensivePower, attackingPower = 0, 0
        if lineup and #lineup >= 11 then
            for i = 1, 5 do defensivePower = defensivePower + (lineup[i].rating or 0) end
            for i = 8, 11 do attackingPower = attackingPower + (lineup[i].rating or 0) end
            defensivePower, attackingPower = defensivePower / 50, attackingPower / 40
        end
        self.TeamRatingsCache[teamID] = {defense = defensivePower, attack = attackingPower}
    end
end

function Brain:getTeamRatings(teamID)
    return self.TeamRatingsCache[teamID] or {defense = 0, attack = 0}
end

function Brain:loadSaveCodes(services, saveData, squads)
  if savemode == 1 then
    local data = saveData
    GLOBAL_MATCHUP_COUNT = data.GLOBAL_MATCHUP_COUNT
    GLOBAL_DATE_PLACEHOLDER = data.GLOBAL_DATE_PLACEHOLDER
    GLOBAL_FUNDS = data.GLOBAL_FUNDS or 0 -- Load funds, default to 0 if nil
    currentSelectedTeamID = data.currentSelectedTeamID
    local teamList = data.TeamList
    local fixtureCode = data.fixtureCode
    local scoreCode = data.scoreCode
    
    local SYMBOL_TO_SCORELINE = {
        ["q"]={0,0}, ["w"]={1,0}, ["e"]={2,0}, ["r"]={3,0}, ["t"]={4,0}, ["y"]={5,0}, ["u"]={6,0}, ["i"]={7,0},
        ["o"]={1,1}, ["p"]={2,2}, ["a"]={3,3}, ["s"]={4,4}, ["d"]={5,5}, ["f"]={0,1}, ["g"]={0,2}, ["h"]={0,3},
        ["j"]={0,4}, ["k"]={0,5}, ["@"]={0,6}, ["z"]={0,7}, ["x"]={2,1}, ["c"]={3,1}, ["v"]={4,1}, ["b"]={5,1},
        ["n"]={6,1}, ["m"]={7,1}, ["Q"]={1,2}, ["W"]={1,3}, ["E"]={1,4}, ["R"]={1,5}, ["T"]={1,6}, ["Y"]={1,7},
        ["U"]={3,2}, ["#"]={4,2}, ["O"]={5,2}, ["P"]={6,2}, ["A"]={7,2}, ["S"]={4,3}, ["D"]={5,3}, ["F"]={6,3},
        ["G"]={7,3}, ["H"]={5,4}, ["K"]={2,3}, ["L"]={2,4}, ["Z"]={2,5}, ["X"]={2,6}, ["C"]={2,7}, ["V"]={3,4},
        ["B"]={3,5}, ["N"]={3,6}, ["M"]={3,7}, ["J"]={4,5}
    }
    local SYMBOL_TO_TEAM_POSITION = {
        ["q"]=1, ["w"]=2, ["e"]=3, ["r"]=4, ["t"]=5, ["y"]=6, ["u"]=7, ["i"]=8, ["o"]=9, ["p"]=10,
        ["a"]=11, ["s"]=12, ["d"]=13, ["f"]=14, ["g"]=15, ["h"]=16, ["j"]=17, ["k"]=18, ["l"]=19, ["z"]=20,
        ["x"]=21, ["c"]=22, ["v"]=23, ["b"]=24, ["n"]=25, ["m"]=26
    }
    
    if (not fixtureCode or #fixtureCode == 0) and (not scoreCode or #scoreCode == 0) then return false end
    if fixtureCode and #fixtureCode > 0 and #fixtureCode % 2 ~= 0 then return false end
    
    local positionToTeam = {}
    for i, teamId in ipairs(teamList) do positionToTeam[i] = teamId end
    
    -- Initialize sheets array
    sheets = sheets or {}
    for i = 1, 4 do
        sheets[i] = sheets[i] or { players = {}, formationid = nil, status = "empty" }
    end
    
    -- Load sheets from saveData
    if data.Sheets then
        for sheetId, sheetData in pairs(data.Sheets) do
            if sheetId >= 1 and sheetId <= 4 then
                sheets[sheetId] = {
                    players = sheetData.players or {},
                    formationid = sheetData.formationid or nil,
                    status = sheetData.status or "filled"
                }
            end
        end
    end
    
    -- Set lineup and formation for the current selected team (use first filled sheet or default)
    local selectedSheet = nil
    for i = 1, 4 do
        if sheets[i].status == "filled" then
            selectedSheet = sheets[i]
            break
        end
    end
    
    if selectedSheet then
        services.SquadManagementService.SetCurrentPlayerLineup(0, currentSelectedTeamID, 0, 0, selectedSheet.players)        
        services.TacticsService.SetFormation(0, currentSelectedTeamID, selectedSheet.formationid or 7)    
    end
    
    -- Load transfer history
    if data.transferHistory then
        for _, transfer in ipairs(data.transferHistory) do
            if transfer.Player and transfer.Team then
                services.SquadManagementService.SetCurrentPlayerLineup(0, tonumber(transfer.Team), 0, 0, squads:swapSoldPlayer(tonumber(transfer.Player), tonumber(transfer.Team)))
            end
        end
    end
   if data.GOALS then
        for cardID, goalCount in pairs(saveData.GOALS) do
            GOALS[cardID] = (GOALS[cardID] or 0) + goalCount
        end
    end
    injuryRecoveryDates = injuryRecoveryDates or {}
    if data.injuryRecoveryDates then
        for playerId, recoveryDate in pairs(data.injuryRecoveryDates) do
            if playerId and recoveryDate then
                injuryRecoveryDate[tonumber(playerId)] = recoveryDate                
            end
        end
    end
    
    if data.isSuspended then
        for playerId, status in pairs(data.isSuspended) do
            if playerId and status then
                isSuspended[tonumber(playerId)] = status                
            end
        end
    end
    
    if data.redCardMatchCount then
        for playerId, count in pairs(data.redCardMatchCount) do
            if playerId and count then
                redCardMatchCount[tonumber(playerId)] = count                
            end
        end
    end
    
    if data.redCardRecords then
        for playerId, record in pairs(data.redCardRecords) do
            if playerId and record then
                redCardRecords[tonumber(playerId)] = record                
            end
        end
    end
    
    if data.yellowCardRecords then
        for playerId, record in pairs(data.yellowCardRecords) do
            if playerId and record then
                yellowCardRecords[tonumber(playerId)] = record                
            end
        end
    end
    
    local matches = {}
    local matchCount, matchday, maxMatches = 0, 1, math.max(fixtureCode and #fixtureCode / 2 or 0, scoreCode and #scoreCode or 0)
    
    for matchIndex = 1, maxMatches do
        matchCount = matchCount + 1
        if matchCount % 10 == 1 and matchCount > 1 then matchday = matchday + 1 end
        
        local homeId, awayId = 0, 0
        if fixtureCode and #fixtureCode > 0 then
            local i = (matchIndex - 1) * 2 + 1
            local homePos = SYMBOL_TO_TEAM_POSITION[fixtureCode:sub(i,i):lower()]
            local awayPos = SYMBOL_TO_TEAM_POSITION[fixtureCode:sub(i+1,i+1):lower()]
            if homePos and awayPos and homePos <= #teamList and awayPos <= #teamList then
                homeId, awayId = positionToTeam[homePos], positionToTeam[awayPos]
            end
        end
        
        local homeScore, awayScore = 0, 0
        if scoreCode and matchIndex <= #scoreCode then
            local scores = SYMBOL_TO_SCORELINE[scoreCode:sub(matchIndex, matchIndex)] or {0, 0}
            homeScore, awayScore = scores[1], scores[2]
        end
        
        table.insert(matches, {homeId = homeId, awayId = awayId, homeScore = homeScore, awayScore = awayScore, matchday = matchday})
    end
    
    LigaGrouping = LigaGrouping or {}
    LigaGrouping[1] = LigaGrouping[1] or {} -- Hardcoding ligaId as 1 for simplicity
    for i, match in ipairs(matches) do
        LigaGrouping[1][i] = {match.homeId, match.awayId, 0, match.homeScore, match.awayScore, data = {homeScorers = {}, awayScorers = {}}}
    end
    return true
  end
end

function Brain:swapPlayersInTeam(teamId, cardIdToSwap)
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

function Brain:setUpModes(services, missionmode, saveData)
    local modes = {ER = true, CTU = true, UF = true, GP = true, IC = true}
    if not modes[missionmode] then return end
    if savemode == 1 then 
      GLOBAL_MATCHUP_COUNT = saveData.GLOBAL_MATCHUP_COUNT or 0
      GLOBAL_DATE_PLACEHOLDER = saveData.GLOBAL_DATE_PLACEHOLDER or "01/08/24"
    else
      GLOBAL_MATCHUP_COUNT = 0
      GLOBAL_DATE_PLACEHOLDER = "01/08/24"
    end
    if missionmode == "IC" then
        local squadLineup = services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)
        local eligiblePlayers = {}
        for i = 1, math.min(11, #squadLineup) do table.insert(eligiblePlayers, squadLineup[i]) end
        table.sort(eligiblePlayers, function(a, b) return a.rating > b.rating end)
        local numToInjure = math.random(math.ceil(#eligiblePlayers * 0.5), math.ceil(#eligiblePlayers * 0.7))
        numToInjure = math.min(numToInjure, math.max(0, #squadLineup - 18))
        for i = 1, numToInjure do
            local player = eligiblePlayers[i].CARD_ID
            isSuspended[player] = 2
            injuryRecoveryDate[player] = self:addDaysToDate(GLOBAL_DATE_PLACEHOLDER, math.random(21, 150))
        end
    end
end

function Brain:addDaysToDate(dateStr, daysToAdd)
    local d, m, y = dateStr:match("(%d%d)/(%d%d)/(%d%d)")
    local timestamp = os.time({day = tonumber(d), month = tonumber(m), year = 2000 + tonumber(y)})
    return os.date("%d/%m/%y", timestamp + (daysToAdd * 86400))
end

function Brain:calculateTeamPowers(services, teamID)
    local lineup = services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
    local defensivePower, attackingPower = 0, 0
    if lineup and #lineup >= 11 then
        for i = 1, 5 do defensivePower = defensivePower + (lineup[i].rating or 0) end
        for i = 8, 11 do attackingPower = attackingPower + (lineup[i].rating or 0) end
    end
    return defensivePower / 50, attackingPower / 40
end

function Brain:adjustForMissionMode(teamID, defensive, attacking)
    local modeMultipliers = {SCR = {10, 10}, UF = {8, 8}, ER = {2, 2}, IC = {4, 4}, URT = {3, 3}}
    if teamID == currentSelectedTeamID then
        if missionmode == "IC" then return defensive / 2, attacking end
        local multipliers = modeMultipliers[missionmode] or {defensive, attacking}
        return multipliers[1], multipliers[2]
    end
    return defensive, attacking
end

return Brain