-- Mod By MVN PROD --
-- League Mode Devision --
local PlayerAge, Brain, data = ...
local matchesPerRound = math.floor(#TeamList / 2)
local Liga = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
local ACT_EXIT = "act_exit"
local BND_REALTIME = "bnd_realtime"
local PROGRESS = "act_progressdate"
local bndBackgroundCareer = "bnd_background_career"

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
  AwayKitIndex = 1
}
-- Dev2
local rivalListData = {}
local matchesPlayed = 0  -- Counter to track the number of matches played
local matchday = false

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
  o:Init()
  
  o.Banner= {
    name = "$Tab_CupInfo",
    id = 0
  }
  math.randomseed(os.clock() * 1352 + os.time())
  local currentTime = os.date("%H") + 0
  local random2 = math.random(3)
  o.im.Subscribe("bnd_ads", function()
    o.Banner.id = random2
    o.im.Publish("bnd_ads", o.Banner)
  end)
  o.im.Subscribe(BND_NEWS, function()
    local currentTime = os.date("Football news %H:%M")
    local state = currentTime
    o.im.Publish(BND_NEWS, state)
  end)
  o.im.Subscribe(BND_REALTIME, function()
    local currentTime = os.date("")
    local state = currentTime
    o.im.Publish(BND_REALTIME, GLOBAL_DATE_PLACEHOLDER)
  end)
  
  o.im.Subscribe(bndMatchList, function()
     o:publishMatchRows()
  end)

  o.im.Subscribe(bndBackgroundCareer, function()  
    o.im.Publish(bndBackgroundCareer, {name = "$BackgroundCareer", id = currentSelectedTeamID})   
  end)  

  o.im.Subscribe("bnd_standings_teams_label", function()
    o:publishMatchLabel()
  end)
  
  o.im.Subscribe("bnd_match_label", function()
    o:publishMatchLabel()
  end)

  o.im.Subscribe("bnd_epl_visible", function()
    o:publishBg()
  end)
  
  o.im.Subscribe("bnd_team_crest", function()
    o.im.Publish("bnd_team_crest", { name = "$Crest", id = currentSelectedTeamID or 0 })
  end)
  
  o.im.Subscribe("bnd_team_name", function()
    o.im.Publish("bnd_team_name", o.loc.LocalizeString("TeamName_Abbr15_"..currentSelectedTeamID))
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
  
  o.im.Subscribe("bnd_logo_league", function()
    local currentLeague = o:getCurrentLeague()
    o.im.Publish("bnd_logo_league", {name = "$LogoCareer", id = currentLeague})
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

  o.im.Subscribe("bnd_logo_checkmark", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_team_crest_home", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_team_crest_away", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_short_name_team_home", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_short_name_team_away", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_matchup_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_matchdate_label", function()
    o:publishFinishLabel()
  end)

  o.im.Subscribe("bnd_matchtag", function()

    o:publishFinishLabel()

  end)
  
  o.im.Subscribe("bnd_league_label", function()

    o:publishFinishLabel()

  end)
  
  o.im.Subscribe("bnd_advance_label", function()

    o:publishFinishLabel()

end)
  
  o.im.Subscribe("bnd_advances_label", function()

    o:publishFinishLabel()
    

  end)
  
  o.im.Subscribe("bnd_month_label", function()

    o:publishFinishLabel()

  end)
  
  o.im.Subscribe("bnd_day_label", function()

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
  o.im.Publish(BND_TAB1_VISIBLE, true)

  o:fitnessRecovery(GLOBAL_DATE_PLACEHOLDER)
  return o
end
------------------------------------------------------------------------------------------


function Liga:getCurrentLeague()
    if not currentSelectedTeamID then
        return 0
    end


    local teamService = self.api("TeamService")
    if teamService and teamService.GetTeamLeague then
        local leagueID = teamService.GetTeamLeague(currentSelectedTeamID)
        if leagueID and leagueID > 0 then
            return leagueID
        end
    end


    local leagueMap = {

[1]=13, [2]=13, [1943]=13, [5]=13, [1799]=13, [7]=13, [95]=13, [9]=13,
[10]=13, [11]=13, [13]=13, [1792]=13, [17]=13, [1806]=13, [106]=13,
[1960]=13, [18]=13, [1795]=13, [109]=13, [19]=13,


[1530]=16, [69]=16, [1819]=16, [62]=16, [294]=16, [217]=16, [71]=16,
[110316]=16, [59]=16, [65]=16, [70]=16, [72]=16, [66]=16,
[219]=16, [73]=16, [58]=16, [210]=16, [379]=16, [74]=16, [1809]=16,


[10029]=19, [31]=19, [169]=19, [21]=19, [32]=19, [22]=19, [23]=19,
[1824]=19, [100409]=19, [111239]=19, [34]=19, [110596]=19, [28]=19,
[485]=19, [166]=19, [112172]=19, [110502]=19, [36]=19, [175]=19, [38]=19,


[47]=31, [52]=31, [39]=31, [189]=31, [112409]=31, [192]=31, [1746]=31,
[110374]=31, [111657]=31, [110556]=31, [206]=31, [44]=31, [45]=31, [46]=31,
[48]=31, [1843]=31, [1837]=31, [111974]=31, [54]=31, [55]=31,


[448]=53, [240]=53, [450]=53, [241]=53, [1860]=53, [110832]=53, [1853]=53,
[573]=53, [480]=53, [452]=53, [242]=53, [449]=53, [243]=53, [457]=53,
[467]=53, [481]=53, [459]=53, [472]=53, [461]=53, [483]=53
    }

    return leagueMap[currentSelectedTeamID] or 0
end


------------------------------------------------------------------------------------------

function Liga:publishBg()
  self.im.Publish("bnd_epl_visible", self.eplvisible)
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
    -- Get the lineup for the current selected team
    local lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)
    local teamPlayers = {}  -- Cache player names from the current team for quick lookup
    if lineup then
        for _, player in ipairs(lineup) do
            teamPlayers[player.playerName] = true  -- Store player names as keys
        end
    end

    -- Check each injured player
    for playerName, recoveryDate in pairs(injuryRecoveryDate) do
        if self:isDateReached(currentDate, recoveryDate) then
            isSuspended[playerName] = 0  -- Remove suspension
            injuryRecoveryDate[playerName] = nil  -- Clear record
            -- Only call backFromInjury if the player is from currentSelectedTeamID
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

-- Local function to sample from a Poisson distribution

function updateTeamFormCache()
    if GLOBAL_MATCHUP_COUNT < 5 then
        return
    end
    TeamFormCache = {}
    for _, teamID in ipairs(TeamList) do
        TeamFormCache[teamID] = { wins = 0, draws = 0, losses = 0 }
    end
        
    local matchesPerDay = matchesPerRound -- 使用上面定义的变量9.15
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

    -- Initialize stats for each team
    for _, teamID in ipairs(targetTeamIDs) do
        teamStats[teamID] = {wins = 0, draws = 0, losses = 0, points = 0, goalsScored = 0, goalsConceded = 0, matchesCount = 0}
    end

    -- Iterate through rivalListData to process matches, but only for the first 2 matches per team
    for _, match in ipairs(rivalListData) do
        local homeID = match.homeID
        local awayID = match.awayID
        local homeScore = match.homeScore
        local awayScore = match.awayScore

        -- Check if homeID or awayID is in targetTeamIDs
        for _, teamID in ipairs({homeID, awayID}) do
            if teamStats[teamID] and teamStats[teamID].matchesCount < GLOBAL_MATCHUP_COUNT then
                local isHome = teamID == homeID
                local score = isHome and homeScore or awayScore
                local opponentScore = isHome and awayScore or homeScore

                teamStats[teamID].goalsScored = teamStats[teamID].goalsScored + score
                teamStats[teamID].goalsConceded = teamStats[teamID].goalsConceded + opponentScore
                teamStats[teamID].matchesCount = teamStats[teamID].matchesCount + 1

                -- Process results
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

    -- Helper functions to get specific stats
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

        local goalsScored, _ = GetTeamGoalsScored(teamID)  -- Get goals scored for team

        local goalsConceded, _ = GetTeamGoalsConceded(teamID)  -- Get goals conceded for team



        teamStats[teamID] = {

            points = points,

            wins = wins,

            draws = draws,

            losses = losses,

            goalsScored = goalsScored,

            goalsConceded = goalsConceded

        }

    end



    -- Sort the teams by points, then by goals scored, and finally by goals conceded in descending order

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

                -- If points, GD, and GS are all equal, sort alphabetically

                local aName = self.loc.LocalizeString("TeamName_Abbr15_" .. a.teamID)

                local bName = self.loc.LocalizeString("TeamName_Abbr15_" .. b.teamID)

                return aName < bName

            else

                return a.stats.goalsScored > b.stats.goalsScored  -- More goals scored is better when GD is equal

            end

        else

            return aGD > bGD  -- Higher GD is better

        end

    else

        return a.stats.points > b.stats.points  -- More points is always better

    end

end)


    -- Create a label to display the top 5 teams ranked by points, goals scored, and goals conceded

    local rankingsLabel = "\n"

    local pointsLabel = ""

    local gsLabel = ""  -- Label for goals scored

    local gcLabel = ""  -- Label for goals conceded



    for position = 1, math.min(5, #sortedTeams) do

        local team = sortedTeams[position]

        TM1 = sortedTeams[1].teamID 

	    TM2 = sortedTeams[2].teamID 


	    TM3 = sortedTeams[3].teamID 


	    TM4 = sortedTeams[4].teamID 


	    TM5 = sortedTeams[5].teamID 


	    TM6 = sortedTeams[6].teamID 


	    TM7 = sortedTeams[7].teamID 

	    TM8 = sortedTeams[8].teamID 


	    TM9 = sortedTeams[9].teamID 


	    TM10 = sortedTeams[10].teamID 
	    TM18 = sortedTeams[18].teamID 
    	TM19 = sortedTeams[19].teamID 
    	TM20 = sortedTeams[20].teamID 
        local teamName = self.loc.LocalizeString("TeamName_Abbr15_" .. team.teamID)



        -- Append team position, name, and stats to rankingsLabel

        rankingsLabel = rankingsLabel .. position .. ". " .. teamName .. "\n"



        -- Append the points, goals scored, and goals conceded for each team to their respective labels

        pointsLabel = pointsLabel .. team.stats.points .. "\n"

        gsLabel = gsLabel .. team.stats.goalsScored .. "\n"

        gcLabel = gcLabel .. team.stats.goalsConceded .. "\n"

    end



    -- Save 18th, 19th, and 20th ranked teams to global placeholders with their lineup ratings

    if sortedTeams[18] then

        local teamID18 = sortedTeams[18].teamID

        GLOBAL_PLACEHOLDER_REL1 = teamID18

    else

        GLOBAL_PLACEHOLDER_REL1 = 9

    end



    if sortedTeams[19] then

        local teamID19 = sortedTeams[19].teamID

        GLOBAL_PLACEHOLDER_REL2 = teamID19

    else

        GLOBAL_PLACEHOLDER_REL2 = "No team at 19th position"

    end



    if sortedTeams[20] then

        local teamID20 = sortedTeams[20].teamID

        GLOBAL_PLACEHOLDER_REL3 = teamID20

    else

        GLOBAL_PLACEHOLDER_REL3 = "No team at 20th position"

    end



    -- Publish the rankings label

    self.im.Publish("bnd_match_label", rankingsLabel)

    -- Publish the rankings label
    self.im.Publish("bnd_standings_teams_label", rankingsLabel)

    -- Publish the points label

    self.im.Publish("bnd_point_label", pointsLabel)
    self.GetTeamPoints = GetTeamPoints
    self.GetTeamWins = GetTeamWins
    self.GetTeamDraws = GetTeamDraws
    self.GetTeamLosses = GetTeamLosses
    self.GetTeamGoalsScored = GetTeamGoalsScored
    self.GetTeamGoalsConceded = GetTeamGoalsConceded
end

lastMatchupCount = GLOBAL_MATCHUP_COUNT or 0 -- Track the last known matchup count

-- Lookup table for days in each month (non-leap year)
local DAYS_IN_MONTH = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

-- Lookup table for days in each month (non-leap year)
local DAYS_IN_DAY = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31}

-- Utility function to check if a year is a leap year
local function isLeapYear(year)
    return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

-- Utility function to get days in a given month
local function getDaysInMonth(month, year)
    if month == 2 and isLeapYear(year) then
        return 29
    end
    return DAYS_IN_MONTH[month]
end

-- Utility function to validate a date (DD/MM/YY)
local function isValidDate(day, month, year)
    if not (day and month and year) then return false end
    if month < 1 or month > 12 then return false end
    local maxDays = getDaysInMonth(month, year)
    return day >= 1 and day <= maxDays
end

-- Utility function to validate a match date (mmddyy)
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
        return m < 10 and ("€%.2fM"):format(m) or ("$%.1fM"):format(m):gsub("%.0M", "M")
    elseif funds >= 1e3 then
        return ("€%dK"):format(funds / 1e3)
    else
        return "€" .. funds
    end
end

function Liga:publishFinance()
    self.im.Publish("bnd_finance", self:formatFunds(GLOBAL_FUNDS))
    if revenue.totalRevenue then
      self.im.Publish("bnd_financeextra", "+ " .. self:formatFunds(revenue.totalRevenue))
    end
end

function Liga:publishFinishLabel()
    -- Validate GLOBAL_DATE_PLACEHOLDER
    local dateString = GLOBAL_DATE_PLACEHOLDER or "01/08/24"
    if not dateString:match("^%d%d/%d%d/%d%d$") then
        print("Warning: Invalid GLOBAL_DATE_PLACEHOLDER '" .. tostring(dateString) .. "', using default '01/08/24'")
        dateString = "01/08/24"
    end

    -- Parse current date (DD/MM/YY)
    local currentDay, currentMonth, currentYear = dateString:match("^(%d%d)/(%d%d)/(%d%d)")
    currentDay, currentMonth, currentYear = tonumber(currentDay), tonumber(currentMonth), tonumber(currentYear)
    if not isValidDate(currentDay, currentMonth, currentYear) then
        print("Warning: Invalid date '" .. dateString .. "', using default '01/08/24'")
        dateString = "01/08/24"
        currentDay, currentMonth, currentYear = 1, 8, 24
    end

    -- Format MMDDYY for excludedDates comparison
    local mmddyy = string.format("%02d%02d%02d", currentMonth, currentDay, currentYear)

    -- Check if current date is in excludedDates
    local isExcludedDate = false
    for _, date in ipairs(matchDates or {}) do
        if mmddyy == date then
            isExcludedDate = true
            break
        end
    end

    -- Calculate next four days for display
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

    -- Format display days
    local displayDays = string.format(
        "%02d                                        %02d                    %02d                    %02d                    %02d",
        currentDay, nextDays[1], nextDays[2], nextDays[3], nextDays[4]
    )

    -- Get current month name
    local monthNames = {
        "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
        "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    }
    local currentMonthName = monthNames[currentMonth] or "Unknown"
    
    -- Get current day name
    local dayNames = {
"MONDAY,", "TUESDAY,", "WEDNESDAY,", "THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", 
"MONDAY,", "TUESDAY,", "WEDNESDAY,", "THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", 
"MONDAY,", "TUESDAY,", "WEDNESDAY,", "THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", 
"MONDAY,", "TUESDAY,", "WEDNESDAY,", "THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", 
"MONDAY,", "TUESDAY,", "WEDNESDAY,",
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,", 
"THURSDAY,", "FRIDAY,", "SATURDAY,", "SUNDAY,", "MONDAY,", "TUESDAY,", "WEDNESDAY,"
    }
    local currentDayName = dayNames[currentDay] or "Unknown"

    -- Get matchup info for the current team
    local matchupInfo = ""
    local globalMatchupCount = GLOBAL_MATCHUP_COUNT or 0
    local matchupIndex = 0
    for i, v in ipairs(rivalListData or {}) do
        if v.homeID == currentSelectedTeamID or v.awayID == currentSelectedTeamID then
            if matchupIndex == globalMatchupCount then
                local opponentID = (v.homeID == currentSelectedTeamID) and v.awayID or v.homeID
                local opponentName = self.loc.LocalizeString("TeamName_Abbr15_" .. opponentID)
                local homeName = self.loc.LocalizeString("TeamName_Abbr3_" .. currentSelectedTeamID)        
                local awayName = self.loc.LocalizeString("TeamName_Abbr3_" .. opponentID)
                local currentTeamRole = (v.homeID == currentSelectedTeamID) and "Home" or "Away"
                matchupInfo = string.format("%s", currentTeamRole)
                matchupInfo1 = string.format("%s", homeName)
                matchupInfo2 = string.format("%s", awayName)
                matchupInfo = string.format("%s vs %s", currentTeamRole, opponentName)                
                IDHome = string.format("%s", currentSelectedTeamID)
                IDAway = string.format("%s", opponentID)
                IDLeague = string.format("%s", currentSelectedTeamID)
                break
            end
            matchupIndex = matchupIndex + 1
        end
    end

    -- Update UI based on date and matchup state
    if isExcludedDate and matchupInfo ~= "" then
        -- Match day: show matchup info
        self.im.Publish("bnd_date_label", displayDays)
        self.im.Publish("bnd_team_crest_home", {name = "$Crest", id = IDHome})
        self.im.Publish("bnd_team_crest_away", {name = "$Crest", id = IDAway})
        self.im.Publish("bnd_month_label", currentMonthName)
        self.im.Publish("bnd_day_label", currentDayName)
        self.im.Publish("bnd_matchup_label", matchupInfo)
        self.im.Publish("bnd_matchdate_label", "Play the Match !")
        self.im.Publish("bnd_league_label", "League Match")
        self.im.Publish("bnd_matchtag", "Matchday !")
        self.im.Publish("bnd_advance_label", "Kick off")
        self.im.Publish("bnd_advances_label", "v")
        matchday = true
    else
        -- Non-match day: show calendar info
        self.im.Publish("bnd_date_label", displayDays)
        self.im.Publish("bnd_month_label", currentMonthName)
        self.im.Publish("bnd_day_label", currentDayName)
        self.im.Publish("bnd_matchup_label", "")
        self.im.Publish("bnd_matchdate_label", "Skip Date")
        self.im.Publish("bnd_league_label", "No Schedule")
        self.im.Publish("bnd_matchtag", "Rest and Training")
        self.im.Publish("bnd_logo_checkmark", "$Icon_Rest")
        self.im.Publish("bnd_advance_label", "Advance")
        matchday = false
    end
end

-- Function to advance the date by one day
function Liga:AdvanceDate()
    -- Validate GLOBAL_DATE_PLACEHOLDER
    if not GLOBAL_DATE_PLACEHOLDER or not GLOBAL_DATE_PLACEHOLDER:match("^%d%d/%d%d/%d%d$") then
        error("Invalid GLOBAL_DATE_PLACEHOLDER format: " .. tostring(GLOBAL_DATE_PLACEHOLDER))
    end

    local day, month, year = GLOBAL_DATE_PLACEHOLDER:match("(%d%d)/(%d%d)/(%d%d)")
    day, month, year = tonumber(day), tonumber(month), tonumber(year)

    -- Validate current date
    if not isValidDate(day, month, year) then
        error("Invalid date: " .. GLOBAL_DATE_PLACEHOLDER)
    end

    -- Handle special case for skipping to 01/09/24
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

-- Function to handle no-match scenarios
function Liga:NoMatch()
  if matchday == true then
    self:PlayMatch()
    return
  end
    -- Prevent infinite date advancement
    if not self.dateAdvanceCount then self.dateAdvanceCount = 0 end
    if self.dateAdvanceCount >= 365 then
        error("Maximum date advances reached; check matchDates configuration")
    end
    self.dateAdvanceCount = self.dateAdvanceCount + 1
    local day, month, year, newDate = self:AdvanceDate()
    self.nav.Event(nil, "evt_progress")
    if day == 3 and month == 6 then
        self.nav.Event(nil, "evt_end", popupData)
    elseif day == 2 and month == 6 then
        self:SeasonEnd()
    end    
    self.dateAdvanceCount = 0 -- Reset after successful NoMatch
end

-- Function to play a match
function Liga:PlayMatch()       
        -- Find match for the current team9.15
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
    icon = "$IconButton_O",
    label = "LTXT_CMN_NO",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$IconButton_X",
    label = "LTXT_CMN_YES",
    clickEvents = {
      "evt_advance",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = " DO YOU WANT TO PLAY THIS MATCH ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
  if not matchdayLoaded[GLOBAL_MATCHUP_COUNT + 1] then
    self.brain:simSys(GLOBAL_MATCHUP_COUNT + 1)
  end
end

function Liga:SeasonEnd()
  local buttonYes = {
    icon = "$IconButton_X",
    label = "LTXT_CMN_OK",
    clickEvents = {
      "evt_hide_popup",
      "evt_restart"
    }
  }
  local popupData = {
    title = "END SEASON",
    message = " CONGRATULATIONS * \n YOU'VE FINISHED THE SEASON",
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
    message = "Your squad has an ineligible player. \n Fix in Team Management",
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
    message = playerName .. " is back from injury",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:exitCareer()
  local buttonNo = {
    icon = "$IconButton_O",
    label = "LTXT_CMN_NO",
    clickEvents = {
    	"evt_hide_popup",
    "evt_savegame"
    }
  }
  local buttonYes = {
    icon = "$IconButton_X",
    label = "LTXT_CMN_YES",
    clickEvents = {
      "evt_hide_popup",
      "evt_back",
      "evt_back",
      "evt_back"
    }
  }
  local popupData = {
    title = "EXIT CAREER",
    message = " HAVE YOU SAVED YOUR PROGRESS ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.models.PlayerAge:finalize()
  self.models.FaCup:finalize()
  self.models.Help:finalize()
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_team_crest")
  self.im.Unsubscribe("bnd_team_name")
  self.im.Unsubscribe("bnd_match_label")
  self.im.Unsubscribe("bnd_team_crest_home")
  self.im.Unsubscribe("bnd_team_crest_away")
  self.im.Unsubscribe("bnd_standings_teams_label")  
  self.im.Unsubscribe("bnd_point_label")
  self.im.Unsubscribe("bnd_date_label")
  self.im.Unsubscribe("bnd_matchup_label")
  self.im.Unsubscribe("bnd_matchtag")
  self.im.Unsubscribe("bnd_matchdate_label")
  self.im.Unsubscribe("bnd_league_label")
  self.im.Unsubscribe("bnd_advance_label")
  self.im.Unsubscribe("bnd_advances_label")
  self.im.Unsubscribe("bnd_month_label")
  self.im.Unsubscribe("bnd_day_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
  
end

return Liga

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --
