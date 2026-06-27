-- Mod By MVN PROD --
-- League Mode Devision --
-- REMOD BY MOUNTSA --

local PlayerAge, Brain, data = ...
local Liga = {}

local bndmatchscore = "bnd_match_score"
local bndMatchFixtures = "bnd_Match_Fixtures"
local bndTeamCrest = "bnd_team_crest"
local bndTeamName = "bnd_team_name"
local bndmatchstanding = "bnd_match_standing"
local bndLeagueBg = "bnd_league_bg"
local ACT_ADVANCE = "act_advance"
local ACT_EXIT = "act_exit"
local BND_REALTIME = "bnd_realtime"
local PROGRESS = "act_progressdate"

ligaId = 1
mode = 1

if not loaded then
  loaded = "no"
else
  loaded = loaded
end

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1,
  isUserSideHome = 0
}

local rivalListData = {}
local matchesPlayed = 0
local matchday = false
local autoAdvance = false
local currentAdvanceDate = nil
local matchesPerRound = math.floor(#TeamList / 2)

function Liga:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
}
  o.brain = Brain:new()
  o.models = {
   PlayerAge = PlayerAge:new({
      api = o.api,
      loc = o.loc,
      nav = o.nav
    })
}

  o.currentOptions = o.services.settingsService.GetCurrentOptions()

  o.isAdvancingDate = false 
  o.dateAdvanceTimer = 0 
  o.dateAdvanceDelay = 30

  o:Init()

  o.Banner= {
    name = "$_Ads_Insta",
    id = 0
  }
  math.randomseed(os.clock() * 1352 + os.time())
  local currentTime = os.date("%H") + 0
  local random2 = math.random(4)
  o.im.Subscribe("bnd_ads", function()
    o.Banner.id = random2
    o.im.Publish("bnd_ads", o.Banner)
  end)
  o.im.Subscribe(BND_REALTIME, function()
    local currentTime = os.date("%A, %h %d")
    local state = currentTime    
      o.im.Publish(BND_REALTIME, state)   
  end)
  
  o.im.Subscribe(bndmatchscore, function()
     o:publishMatchRows()
  end)
  
  o.im.Subscribe(bndLeagueBg, function()  
    o.im.Publish(bndLeagueBg, {name = "$_LeagueBg", id = currentSelectedTeamID})   
  end)
  
   o.im.Subscribe(bndmatchstanding, function()
     o:publishMatchRows2()
  end)
  
  o.im.Subscribe(bndMatchFixtures, function()
     o:publishMatchRows3()
  end)
  
  o.im.Subscribe(bndTeamCrest, function()  
    o.im.Publish(bndTeamCrest, {name = "$Crest64x64", id = currentSelectedTeamID})   
  end)
  
  o.im.Subscribe(bndTeamName, function()  
        o.im.Publish(bndTeamName, o.loc.LocalizeString("TeamName_Abbr15_"..currentSelectedTeamID))       
    end)
  
  o.im.Subscribe("bnd_epl_visible", function()
    o:publishBg()
  end)
  
  o.im.Subscribe("bnd_standings_teams_label", function()
    o:publishMatchLabel()
  end)
  
  o.im.Subscribe("bnd_point_label", function()
    o:publishMatchLabel()
  end)
  
  o.im.RegisterAction(ACT_ADVANCE, function()
    o:GetBack()
  end)
  o.im.RegisterAction(ACT_EXIT, function(actionName, data)
    o:exitCareer()
  end)
  
  o.im.Subscribe("bnd_finish_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_finance", function()
    o:publishFinance()
  end)
  
  o.im.Subscribe("bnd_financeextra", function()
    o:publishFinance()
  end)
  
  o.im.Subscribe("bnd_date_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_team_crest_home", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_team_crest_away", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_rectangle", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_nextfixture_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_realtime", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_league_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_league_logo", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_logo_checkmark", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_short_name_team_home", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_short_name_team_away", function()
    o:publishFinishLabel()
  end)
  o.im.Subscribe("bnd_abbr_name_team_home", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_abbr_name_team_away", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_checkmark_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_matchup_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_currentdate_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_nextdate_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_previousdate_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_advance_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_month_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.RegisterAction(ACT_ADVANCE, function(actionName, data)
    if data then
      o:PlayMatch(data)
    end
  end)
  o.im.RegisterAction(PROGRESS, function(actionName, data)
    o:NoMatch()
  end)
  o:fitnessRecovery(GLOBAL_DATE_PLACEHOLDER)

  return o
end

------------------------------------------------------------------------------------------

function Liga:publishBg()
  self.im.Publish("bnd_epl_visible", self.eplvisible)
end

function Liga:update(elapsedTime)
    if not self.isAdvancingDate then
        return
    end
    self.dateAdvanceTimer = self.dateAdvanceTimer - 1

    if self.dateAdvanceTimer <= 0 then
        self:AdvanceOneDayAndCheck()
        self.dateAdvanceTimer = self.dateAdvanceDelay
    end
end

function Liga:AdvanceOneDayAndCheck()
    local day, month, year, newDate = self:AdvanceDate()
    self:publishFinishLabel() 
    self:fitnessRecovery(newDate)
    self:publishFinance()

    if matchday == true then
        print("Matchday encontrado em: " .. newDate .. ". Parando animação.")
        self.isAdvancingDate = false
        self:PlayMatch()
    end
    if (day == 3 and month == 6) or (day == 2 and month == 6) then
        self:SeasonEnd()
        self.isAdvancingDate = false
    end
end

function Liga:Init()
  local LigaGroupingList = LigaGrouping[ligaId]
  for i = 1, table.getn(LigaGroupingList) do
    local obj = {
      homeID = LigaGroupingList[i][1],
      awayID = LigaGroupingList[i][2],
      homeScore = LigaGroupingList[i][4],
      awayScore = LigaGroupingList[i][5],
      
      clickAction = "act_advance",
      isUnlock = LigaGroupingList[i][9],
      data = {}
    }
    table.insert(rivalListData, obj)
  end
end

-----------------------------------------------------------------------------------------
function Liga:fitnessRecovery(currentDate)
    local lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)
    local teamPlayers = {}
    if lineup then
        for _, player in ipairs(lineup) do
            teamPlayers[player.playerName] = true
        end
    end

    for playerName, recoveryDate in pairs(injuryRecoveryDate) do
        if self:isDateReached(currentDate, recoveryDate) then
            isSuspended[playerName] = 0
            injuryRecoveryDate[playerName] = nil
            if teamPlayers[playerName] then
                self:backFromInjury(playerName)
            end
        end
    end
end

function Liga:isDateReached(currentDate, recoveryDate)
    local function parseDate(dateStr)
        local d, m, y = dateStr:match("(%d%d)/(%d%d)/(%d%d)")
        return os.time({ day = tonumber(d), month = tonumber(m), year = 2000 + tonumber(y) })  
    end

    return parseDate(currentDate) >= parseDate(recoveryDate)
end

------------------------------------------------------------------------------------------
function Liga:publishMatchRows2()
  local teamDataList = {}

  for _, teamID in ipairs(TeamList) do
    local teamData = {}
    teamData.TeamCrest = {
      name = "$Crest64x64",
      id = teamID
    }
    teamData.TeamName = self.loc.LocalizeString("TeamName_Abbr15_" .. teamID)
    teamData.TeamWin = tostring(GetTeamWins(teamID))
    teamData.TeamDraw = tostring(GetTeamDraws(teamID))
    teamData.TeamPoint = tonumber(GetTeamPoints(teamID))
    teamData.TeamLoss = tostring(GetTeamLosses(teamID))
    teamData.TeamGA = tonumber(GetTeamGoalsScored(teamID))
    teamData.TeamGC = tonumber(GetTeamGoalsConceded(teamID))
    teamData.TeamGD = teamData.TeamGA - teamData.TeamGC
    teamData.Teammp = GLOBAL_MATCHUP_COUNT
    teamData.clickAction = "ViewTeamDetails_" .. teamID

    teamData.TeamScoreFontColor = "0xffffff"
    teamData.TeamNameFontColor = "0xffffff"
    teamData.FontColor = "0xffffff"
    teamData.Icon = {
      name = "$IconTeam",
      id = teamID
    }
    teamData.RightText = ""

    table.insert(teamDataList, {data = teamData})
  end

  table.sort(teamDataList, function(a, b)
    if a.data.TeamPoint ~= b.data.TeamPoint then
      return a.data.TeamPoint > b.data.TeamPoint
    end

    if a.data.TeamGD ~= b.data.TeamGD then
      return a.data.TeamGD > b.data.TeamGD
    end

    return a.data.TeamName < b.data.TeamName
  end)

  local allZeroPoints = true
  for _, team in ipairs(teamDataList) do
    if team.data.TeamPoint > 0 then
      allZeroPoints = false
      break
    end
  end

  if allZeroPoints then
    table.sort(teamDataList, function(a, b)
      return a.data.TeamName < b.data.TeamName
    end)
  end

  for i, team in ipairs(teamDataList) do
    team.data.Teampos = tostring(i) .. ""
  end

  self.im.Publish(bndmatchstanding, teamDataList)
end

------------------------------------------------------------------------------------------
function Liga:publishMatchRows()
    if GLOBAL_MATCHUP_COUNT == 0 then
        print("[Liga:publishMatchRows]: GLOBAL_MATCHUP_COUNT é zero. Sem partidas para processar.")
        self:NoScorer()
        return
    end

    local filteredRivalListData = {}

    local combinedLineup = {}
    for _, teamID in ipairs(TeamList) do
        local lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
        if lineup and #lineup > 0 then
            for _, player in ipairs(lineup) do
                player.teamID = teamID
                table.insert(combinedLineup, player)
            end
        end
    end

    if #combinedLineup == 0 then
        print("[Liga:publishMatchRows]: Combined lineup para TeamList está vazio ou inválido.")
        self:Empty()
        return
    end

    local function countPlayerGoals(CARD_ID)
        local totalGoals = 0
        local maxMatches = GLOBAL_MATCHUP_COUNT * 10

        for i, match in ipairs(rivalListData or {}) do
            if i > maxMatches then break end

            for _, scorer in ipairs(match.homeScorers or {}) do
                if scorer == CARD_ID then
                    totalGoals = totalGoals + 1
                end
            end

            for _, scorer in ipairs(match.awayScorers or {}) do
                if scorer == CARD_ID then
                    totalGoals = totalGoals + 1
                end
            end
        end
        return totalGoals
    end
    
    for _, player in ipairs(combinedLineup) do
        local normalGoals = countPlayerGoals(player.CARD_ID)
        local additionalGoals = GOALS[player.CARD_ID] or 0
        player.goalCount = normalGoals + additionalGoals
    end

    table.sort(combinedLineup, function(a, b)
        return a.goalCount > b.goalCount
    end)

    local topPlayers = {}
    for i = 1, math.min(50, #combinedLineup) do
        table.insert(topPlayers, combinedLineup[i])
    end

    for rank, player in ipairs(topPlayers) do
        local playerName = player.playerName
        local position = tostring(player.position)
        local rating = tostring(player.rating)
        local teamName = self.loc.LocalizeString("TeamName_Abbr3_" .. player.teamID)

        local row = {
            data = {
                PlayerName = playerName,
                Position = position,
                Rating = rating,
                TeamName = teamName,
                Goals = player.goalCount,
                Rank = tostring(rank) .. "",
                PlayerHead = {
                    name = "$Head",
                    id = player.CARD_ID
                },
                TeamCrest = {
                    name = "$Crest64x64",
                    id = player.teamID
                },
                Nationality = {
                    name = "$Flag128x128",
                    id = player.nationalityID
                },
            }
        }
        table.insert(filteredRivalListData, row)
    end

    self.im.Publish(bndmatchscore, filteredRivalListData)
end

------------------------------------------------------------------------------------------

function Liga:publishMatchRows3()
  local filteredRivalListData = {}

  for i, v in ipairs(rivalListData) do

      v.data.TeamHomeCrest = {
        name = "$Crest64x64",
        id = rivalListData[i].homeID
      }
      v.data.TeamAwayCrest = {
        name = "$Crest64x64",
        id = rivalListData[i].awayID
      }
      v.data.TeamHomeName = self.loc.LocalizeString("TeamName_Abbr3_"..rivalListData[i].homeID)
      v.data.TeamAwayName = self.loc.LocalizeString("TeamName_Abbr3_"..rivalListData[i].awayID)

    local maxRowsWithScores = GLOBAL_MATCHUP_COUNT * 10

    if i <= maxRowsWithScores then
        rivalListData[i].data.MatchScore = rivalListData[i].homeScore .. "  -  " .. rivalListData[i].awayScore
    else
        rivalListData[i].data.MatchScore = "VS"
    end

      v.data.TeamScoreFontColor = "0xffffff"
      v.data.TeamNameFontColor = "0x4A2C6D"
      v.data.FontColor = "0x4A2C6D"

      if not rivalListData[i].isUnlock then
        v.data.Icon = { name = "$", id = 1 }
        v.data.RightText = ""
      else
        v.data.Icon = { name = "$", id = 2 }
        v.data.RightText = ""
      end

      table.insert(filteredRivalListData, v)
    end
  
  self.im.Publish(bndMatchFixtures, filteredRivalListData)
end

function GetLeagueFromTeam(teamID)
    for i, team in ipairs(gTeams) do
        if team.id == teamID then
            return team.leagueID
        end
    end
    return 0
end

function updateTeamFormCache()
    if GLOBAL_MATCHUP_COUNT < 5 then
        return
    end
    TeamFormCache = {}
    for _, teamID in ipairs(TeamList) do
        TeamFormCache[teamID] = { wins = 0, draws = 0, losses = 0 }
    end
    local matchesPerDay = matchesPerRound
    local currentMatchday = GLOBAL_MATCHUP_COUNT + 1
    local startMatchday = math.max(1, currentMatchday - 5)
    local startIndex = (startMatchday - 1) * matchesPerDay + 1
    local endIndex = (currentMatchday - 1) * matchesPerDay
    for i = startIndex, endIndex do
        local matchData = LigaGrouping[ligaId][i]
        if matchData then
            local homeID = matchData[1]
            local awayID = matchData[2]
            local homeScore = matchData[4]
            local awayScore = matchData[5]
            if TeamFormCache[homeID] then
                if homeScore > awayScore then
                    TeamFormCache[homeID].wins = TeamFormCache[homeID].wins + 1
                elseif homeScore == awayScore then
                    TeamFormCache[homeID].draws = TeamFormCache[homeID].draws + 1
                else
                    TeamFormCache[homeID].losses = TeamFormCache[homeID].losses + 1
                end
            end
            if TeamFormCache[awayID] then
                if awayScore > homeScore then
                    TeamFormCache[awayID].wins = TeamFormCache[awayID].wins + 1
                elseif awayScore == homeScore then
                    TeamFormCache[awayID].draws = TeamFormCache[awayID].draws + 1
                else
                    TeamFormCache[awayID].losses = TeamFormCache[awayID].losses + 1
                end
            end
        end
    end
end

function Liga:publishMatchLabel()
    local targetTeamIDs = TeamList
    local teamStats = {}

    for _, teamID in ipairs(targetTeamIDs) do
        teamStats[teamID] = {wins = 0, draws = 0, losses = 0, points = 0, goalsScored = 0, goalsConceded = 0, matchesCount = 0}
    end

    for _, match in ipairs(rivalListData) do
        local homeID = match.homeID
        local awayID = match.awayID
        local homeScore = match.homeScore
        local awayScore = match.awayScore

        for _, teamID in ipairs({homeID, awayID}) do
            if teamStats[teamID] and teamStats[teamID].matchesCount < GLOBAL_MATCHUP_COUNT then
                local isHome = teamID == homeID
                local score = isHome and homeScore or awayScore
                local opponentScore = isHome and awayScore or homeScore

                teamStats[teamID].goalsScored = teamStats[teamID].goalsScored + score
                teamStats[teamID].goalsConceded = teamStats[teamID].goalsConceded + opponentScore
                teamStats[teamID].matchesCount = teamStats[teamID].matchesCount + 1

                if score > opponentScore then
                    teamStats[teamID].wins = teamStats[teamID].wins + 1
                    teamStats[teamID].points = teamStats[teamID].points + 3
                elseif score == opponentScore then
                    teamStats[teamID].draws = teamStats[teamID].draws + 1
                    teamStats[teamID].points = teamStats[teamID].points + 1
                else
                    teamStats[teamID].losses = teamStats[teamID].losses + 1
                end
            end
        end
    end

    function GetTeamPoints(teamID)
        return teamStats[teamID].points or 0
    end

    function GetTeamWins(teamID)
        return teamStats[teamID].wins or 0
    end

    function GetTeamDraws(teamID)
        return teamStats[teamID].draws or 0
    end

    function GetTeamLosses(teamID)
        return teamStats[teamID].losses or 0
    end

    function GetTeamGoalsScored(teamID)
        return teamStats[teamID].goalsScored or 0
    end

    function GetTeamGoalsConceded(teamID)
        return teamStats[teamID].goalsConceded or 0
    end

    for _, teamID in ipairs(TeamList) do
        local points, _ = GetTeamPoints(teamID)
        local wins, _ = GetTeamWins(teamID)
        local draws, _ = GetTeamDraws(teamID)
        local losses, _ = GetTeamLosses(teamID)
        local goalsScored, _ = GetTeamGoalsScored(teamID)
        local goalsConceded, _ = GetTeamGoalsConceded(teamID)

        teamStats[teamID] = {
            points = points,
            wins = wins,
            draws = draws,
            losses = losses,
            goalsScored = goalsScored,
            goalsConceded = goalsConceded
        }
    end

    local sortedTeams = {}
    for teamID, stats in pairs(teamStats) do
        table.insert(sortedTeams, {teamID = teamID, stats = stats})
    end

    table.sort(sortedTeams, function(a, b)
        if a.stats.points == b.stats.points then
            local aGD = a.stats.goalsScored - a.stats.goalsConceded
            local bGD = b.stats.goalsScored - b.stats.goalsConceded
            if aGD == bGD then
                if a.stats.goalsScored == b.stats.goalsScored then
                    local aName = self.loc.LocalizeString("TeamName_Abbr15_" .. a.teamID)
                    local bName = self.loc.LocalizeString("TeamName_Abbr15_" .. b.teamID)
                    return aName < bName
                else
                    return a.stats.goalsScored > b.stats.goalsScored
                end
            else
                return aGD > bGD
            end
        else
            return a.stats.points > b.stats.points
        end
    end)

    local rankingsLabel = "\n"
    local pointsLabel = ""
    local gsLabel = ""
    local gcLabel = ""
    
    -- Armazenar até os 20 primeiros times
    TM1  = sortedTeams[1]  and sortedTeams[1].teamID or nil
    TM2  = sortedTeams[2]  and sortedTeams[2].teamID or nil
    TM3  = sortedTeams[3]  and sortedTeams[3].teamID or nil
    TM4  = sortedTeams[4]  and sortedTeams[4].teamID or nil
    TM5  = sortedTeams[5]  and sortedTeams[5].teamID or nil
    TM6  = sortedTeams[6]  and sortedTeams[6].teamID or nil
    TM7  = sortedTeams[7]  and sortedTeams[7].teamID or nil
    TM8  = sortedTeams[8]  and sortedTeams[8].teamID or nil
    TM9  = sortedTeams[9]  and sortedTeams[9].teamID or nil
    TM10 = sortedTeams[10] and sortedTeams[10].teamID or nil
    
    for position = 1, math.min(4, #sortedTeams) do
        local team = sortedTeams[position]
        local teamName = self.loc.LocalizeString("TeamName_Abbr15_" .. team.teamID)
        rankingsLabel = rankingsLabel .. position .. ". " .. teamName .. "\n"
        pointsLabel = pointsLabel .. team.stats.points .. "\n"
        gsLabel = gsLabel .. team.stats.goalsScored .. "\n"
        gcLabel = gcLabel .. team.stats.goalsConceded .. "\n"
    end

    -- Rebaixamento: pegar os 3 últimos colocados
    local numTeams = #sortedTeams
    if numTeams >= 3 then
        GLOBAL_PLACEHOLDER_REL1 = sortedTeams[numTeams - 2].teamID
        GLOBAL_PLACEHOLDER_REL2 = sortedTeams[numTeams - 1].teamID
        GLOBAL_PLACEHOLDER_REL3 = sortedTeams[numTeams].teamID
    else
        GLOBAL_PLACEHOLDER_REL1 = nil
        GLOBAL_PLACEHOLDER_REL2 = nil
        GLOBAL_PLACEHOLDER_REL3 = nil
    end

    self.im.Publish("bnd_standings_teams_label", rankingsLabel)
    self.im.Publish("bnd_point_label", pointsLabel)
    self.GetTeamPoints = GetTeamPoints
    self.GetTeamWins = GetTeamWins
    self.GetTeamDraws = GetTeamDraws
    self.GetTeamLosses = GetTeamLosses
    self.GetTeamGoalsScored = GetTeamGoalsScored
    self.GetTeamGoalsConceded = GetTeamGoalsConceded
end

lastMatchupCount = GLOBAL_MATCHUP_COUNT or 0

local DAYS_IN_MONTH = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

local function isLeapYear(year)
    return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

local function getDaysInMonth(month, year)
    if month == 2 and isLeapYear(year) then
        return 29
    end
    return DAYS_IN_MONTH[month]
end

local function isValidDate(day, month, year)
    if not (day and month and year) then return false end
    if month < 1 or month > 12 then return false end
    local maxDays = getDaysInMonth(month, year)
    return day >= 1 and day <= maxDays
end

local function isValidMatchDateYY(dateStr)
    if not dateStr or not dateStr:match("^%d%d%d%d%d%d$") then return false end
    local month, day, year = dateStr:match("^(%d%d)(%d%d)(%d%d)$")
    month, day, year = tonumber(month), tonumber(day), tonumber(year)
    if not (month and day and year) then return false end
    if month < 1 or month > 12 or day < 1 or year < 0 or year > 99 then return false end
    local maxDays = getDaysInMonth(month, year)
    return day <= maxDays
end

function Liga:formatFunds(funds)
    if funds >= 1e6 then
        local m = funds / 1e6
        return m < 10 and ("$%.2fM"):format(m) or ("$%.1fM"):format(m):gsub("%.0M", "M")
    elseif funds >= 1e3 then
        return ("$%dK"):format(funds / 1e3)
    else
        return "$" .. funds
    end
end

function Liga:publishFinance()
    self.im.Publish("bnd_finance", self:formatFunds(GLOBAL_FUNDS))
    if revenue and revenue.totalRevenue then
      self.im.Publish("bnd_financeextra", "+ " .. self:formatFunds(revenue.totalRevenue))
    end
end

function Liga:publishFinishLabel()
    self.im.Publish("bnd_date_label", "")
    self.im.Publish("bnd_month_label", "")
    self.im.Publish("bnd_matchup_label", "")
    self.im.Publish("bnd_currentdate_label", "")
    self.im.Publish("bnd_previousdate_label", "")
    self.im.Publish("bnd_nextdate_label", "")
    self.im.Publish("bnd_nextfixture_label", "")
    self.im.Publish("bnd_realtime", "")
    self.im.Publish("bnd_short_name_team_home", "")
    self.im.Publish("bnd_short_name_team_away", "")
    self.im.Publish("bnd_abbr_name_team_home", "") 
    self.im.Publish("bnd_abbr_name_team_away", "") 
    self.im.Publish("bnd_league_logo", {name = "$", id = 0})
    self.im.Publish("bnd_team_crest_home", {name = "$", id = 0})
    self.im.Publish("bnd_team_crest_away", {name = "$", id = 0})
    self.im.Publish("bnd_checkmark_label", "")
    self.im.Publish("bnd_logo_checkmark", {name = "$", id = 0})

    local dateString = GLOBAL_DATE_PLACEHOLDER or "01/08/24"
    if not dateString:match("^%d%d/%d%d/%d%d$") then
        print("Warning: Invalid GLOBAL_DATE_PLACEHOLDER '" .. tostring(dateString) .. "', using default '01/08/24'")
        dateString = "01/08/24"
    end

    local day, month, year = dateString:match("(%d%d)/(%d%d)/(%d%d)")
    local fullYear = "20" .. year
    local timeTable = { day = tonumber(day), month = tonumber(month), year = tonumber(fullYear), hour = 0, min = 0, sec = 0 }
    local time = os.time(timeTable)
    local currentDate = os.date("%A, %b %d", time)
    local prevTime = time - 86400
    local prevDate = os.date("%A, %b %d", prevTime)
    local nextTime = time + 86400
    local nextDate = os.date("%A, %b %d", nextTime)
    local currentHour = os.date("%H:%M %p")
    
    local currentDay, currentMonth, currentYear = tonumber(day), tonumber(month), tonumber(year)
    if not isValidDate(currentDay, currentMonth, currentYear) then
        dateString = "01/08/24"
        currentDay, currentMonth, currentYear = 1, 8, 24
    end

    local mmddyy = string.format("%02d%02d%02d", currentMonth, currentDay, currentYear)
    local isExcludedDate = false
    for _, date in ipairs(matchDates or {}) do
        if mmddyy == date then
            isExcludedDate = true
            break
        end
    end

    local nextDays = {}
    for i = 1, 4 do
        local nextDay, nextMonth, nextYear = currentDay + i, currentMonth, currentYear
        if nextDay > getDaysInMonth(nextMonth, nextYear) then
            nextDay = nextDay - getDaysInMonth(nextMonth, nextYear)
            nextMonth = nextMonth + 1
            if nextMonth > 12 then
                nextMonth = 1
                nextYear = nextYear + 1
            end
        end
        table.insert(nextDays, nextDay)
    end

    local displayDays = string.format(
        "%02d                                        %02d                    %02d                    %02d                    %02d",
        currentDay, nextDays[1], nextDays[2], nextDays[3], nextDays[4]
    )

    local monthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
    local currentMonthName = monthNames[currentMonth] or "Unknown"

    local matchupInfo = ""
    local globalMatchupCount = GLOBAL_MATCHUP_COUNT or 0
    local matchupIndex = 0
    local matchupInfoHomeAbbr, matchupInfoAwayAbbr 
    
    for i, v in ipairs(rivalListData or {}) do
        if v.homeID == currentSelectedTeamID or v.awayID == currentSelectedTeamID then
            if matchupIndex == globalMatchupCount then
                local homeName = self.loc.LocalizeString("TeamName_Abbr15_" .. v.homeID)        
                local awayName = self.loc.LocalizeString("TeamName_Abbr15_" .. v.awayID)
                local homeAbbrName = self.loc.LocalizeString("TeamName_Abbr3_" .. v.homeID)
                local awayAbbrName = self.loc.LocalizeString("TeamName_Abbr3_" .. v.awayID)
                matchupInfo = (v.homeID == currentSelectedTeamID) and "Home" or "Away"
                matchupInfo2 = homeName
                matchupInfo3 = awayName
                IDHome = v.homeID
                IDAway = v.awayID
                IDLeague = currentSelectedTeamID
                matchupInfoHomeAbbr = homeAbbrName
                matchupInfoAwayAbbr = awayAbbrName
                break
            end
            matchupIndex = matchupIndex + 1
        end
    end

    if isExcludedDate and matchupInfo ~= "" then
        self.im.Publish("bnd_matchup_label", matchupInfo)
        self.im.Publish("bnd_currentdate_label", currentDate)
        self.im.Publish("bnd_short_name_team_home", matchupInfo2)
        self.im.Publish("bnd_short_name_team_away", matchupInfo3)
        self.im.Publish("bnd_abbr_name_team_home", matchupInfoHomeAbbr)
        self.im.Publish("bnd_abbr_name_team_away", matchupInfoAwayAbbr)
        self.im.Publish("bnd_nextfixture_label", "Next match in 8 days")
        self.im.Publish("bnd_realtime", currentMonthName .. " " .. currentDay .. " " .. currentHour)
        self.im.Publish("bnd_league_label", "League Match")
        self.im.Publish("bnd_league_logo", {name = "$_LeagueLogo", id = IDLeague})
        self.im.Publish("bnd_team_crest_home", {name = "$Crest", id = IDHome})
        self.im.Publish("bnd_team_crest_away", {name = "$Crest", id = IDAway})
        self.im.Publish("bnd_rectangle", "$_LiveTileGray")
        self.im.Publish("bnd_advance_label", "Advance")
        matchday = true
    else
        self.im.Publish("bnd_date_label", displayDays)        
        self.im.Publish("bnd_checkmark_label", "Preparing for the\nnext match")
        self.im.Publish("bnd_logo_checkmark", "$")
        self.im.Publish("bnd_nextfixture_label", "Next match in 8 days")
        self.im.Publish("bnd_realtime", "")
        self.im.Publish("bnd_league_label", "")
        self.im.Publish("bnd_currentdate_label", currentDate)
        self.im.Publish("bnd_previousdate_label", prevDate)
        self.im.Publish("bnd_nextdate_label", nextDate)
        self.im.Publish("bnd_advance_label", "Advance")
        matchday = false
    end
end

function Liga:AdvanceDate()
    if not GLOBAL_DATE_PLACEHOLDER or not GLOBAL_DATE_PLACEHOLDER:match("^%d%d/%d%d/%d%d$") then
        error("Invalid GLOBAL_DATE_PLACEHOLDER format: " .. tostring(GLOBAL_DATE_PLACEHOLDER))
    end

    local day, month, year = GLOBAL_DATE_PLACEHOLDER:match("(%d%d)/(%d%d)/(%d%d)")
    day, month, year = tonumber(day), tonumber(month), tonumber(year)

    if not isValidDate(day, month, year) then
        error("Invalid date: " .. GLOBAL_DATE_PLACEHOLDER)
    end

    if day == 31 and month == 8 and year == 24 then
        day, month = 1, 9
    else
        day = day + 1
        if day > getDaysInMonth(month, year) then
            day = 1
            month = month + 1
            if month > 12 then
                month = 1
                year = year + 1
            end
        end
    end

    local newDate = string.format("%02d/%02d/%02d", day, month, year)
    if GLOBAL_DATE_PLACEHOLDER ~= newDate then
        GLOBAL_DATE_PLACEHOLDER = newDate
        print("New Date: " .. newDate)
    end

    return day, month, year, newDate
end

function Liga:NoMatch()
    if matchday == true then
        self:PlayMatch()
        return
    end

    if self.isAdvancingDate then
        return
    end

    self.isAdvancingDate = true
    self.dateAdvanceTimer = 0
end

function Liga:PlayMatch()       
    local startIndex = (GLOBAL_MATCHUP_COUNT * matchesPerRound) + 1
    local endIndex = startIndex + (matchesPerRound - 1)
    local foundMatchIndex
    
    for i = startIndex, endIndex do
        local matchData = LigaGrouping[ligaId][i]
        if matchData and (matchData[1] == currentSelectedTeamID or matchData[2] == currentSelectedTeamID) then
            foundMatchIndex = i
            break
        end
    end

    if not foundMatchIndex then
        print("No match found involving currentSelectedTeamID in indexes " .. startIndex .. "-" .. endIndex)
        return
    end

    local currentMatchData = LigaGrouping[ligaId][foundMatchIndex]
    currentLigaData.Index = ligaId
    currentLigaData.round = foundMatchIndex
    currentLigaData.homeID = currentMatchData[1]
    currentLigaData.awayID = currentMatchData[2]
    currentLigaData.difficulty = currentMatchData[7]
    currentMatch.MatchType = "Epl"
    currentMatch.HomeTeamID = currentMatchData[1]
    currentMatch.AwayTeamID = currentMatchData[2]
    currentMatch.isUserSideHome = (currentMatch.HomeTeamID == currentSelectedTeamID) and 0 or 1
    
    local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)
    if not players then
        error("Failed to retrieve player lineup")
    end
    for i = 1, 18 do
        local playerID = players[i].CARD_ID
        if isSuspended[playerID] == 1 or isSuspended[playerID] == 2 then
            self:Ineligible()
            return
        end
    end
    self:KickOff()
end

-----------------------------------------------------------------------------------------
function Liga:KickOff()
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
      "evt_advance",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "Do you want to play this match?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
  if not matchdayLoaded[GLOBAL_MATCHUP_COUNT + 1] then
    self.brain:simSys(GLOBAL_MATCHUP_COUNT + 1)
  end
end

function Liga:SeasonEnd()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup",
      "evt_restart"
    }
  }
  local popupData = {
    title = "END SEASON",
    message = "The mission has been completed. \n End of the season.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:Ineligible()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup",
      "evt_squad"
    }
  }
  local popupData = {
    title = "SQUAD IS INELIGIBLE",
    message = "Your team has an ineligible player.\nResolve in Team management.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:backFromInjury(playerName)
  local buttonYes = {
    icon = "$general_help_squads_icon",
    label = "Close",
    clickEvents = {
      "evt_hide_popup",
      "evt_squad"
    }
  }
  local popupData = {
    title = "PLAYER BACK",
    message = playerName .. " has recovered from the injury.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:exitCareer()
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = {
      "evt_hide_popup",
      "evt_back",
      "evt_back",
      "evt_back"
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Confirm",
    clickEvents = {
    	"evt_hide_popup",
    "evt_savegame"
    }
  }
  local popupData = {
    title = "EXIT CAREER",
    message = "Do you want to save your progress before exiting?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:GetBack()
  -- Função auxiliar para voltar (se necessária)
end

function Liga:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.models.PlayerAge:finalize()
  self.models.FaCup:finalize()
  self.models.Help:finalize()
  self.im.Unsubscribe("bnd_match_score")
  self.im.Unsubscribe("bnd_Match_Fixtures")
  self.im.Unsubscribe("bnd_standings_teams_label")
  self.im.Unsubscribe("bnd_point_label")
  self.im.Unsubscribe("bnd_date_label")
  self.im.Unsubscribe("bnd_match_standing")
  self.im.Unsubscribe("bnd_matchup_label")
  self.im.Unsubscribe("bnd_nextfixture_label")
  self.im.Unsubscribe("bnd_realtime")
  self.im.Unsubscribe("bnd_league_label")
  self.im.Unsubscribe("bnd_nextdate_label")
  self.im.Unsubscribe("bnd_currentdate_label")
  self.im.Unsubscribe("bnd_previousdate_label")
  self.im.Unsubscribe("bnd_advance_label")
  self.im.Unsubscribe("bnd_month_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
end

return Liga

-- Thanks : Ma'ruf Id & Laosiji --
-- REMOD BY MOUNTSA --
-- @mvnprod.official - Remain Be Creative --