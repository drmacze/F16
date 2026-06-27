--Performance By MounTsa --
local events = {}
print("loaded events LUA")
local bndHomeEventsList = "bnd_home_events_list"
local bndAwayEventsList = "bnd_away_events_list"
local bndEmptyRowsData = "bnd_empty_rows_data"
local BND_HOME_TEAM_CREST = "bnd_home_team_crest"
local bndMatchFacts = "bnd_match_facts"
local NUM_EMPTY_LIST_ROWS = 9
local DEFAULT_ICON_HOME_OFFSET = 60
local DEFAULT_ICON_AWAY_OFFSET = 105
local OFFSET_PER_EXTRA_CHAR = 10
local DEFAULT_MINUTE_STRING_LENGTH = 4

function events:new(init)
  print("New Function MatchEventsLua")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    matchInfo = o.api("MatchInfoService"),
    SquadManagementService = o.api("SquadMgtService"),
    TacticsService = o.api("TacticsService"),
    TeamService = o.api("TeamService")
  }
  
  -- Initialize events data
  o.eventsData = o.services.matchInfo.GetMatchEvents() or {homeData = {}, awayData = {}}
  o.TeamsData = o.services.matchInfo.GetMatchTeams() or {}
  
  -- Get lineup data
  if #o.TeamsData >= 2 then
    o.homeTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(0, o.TeamsData[1].assetId, 0) or {}
    o.awayTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(1, o.TeamsData[2].assetId, 0) or {}
  end
  
  o.mAdditionalIconOffset = (string.len(o.loc.LocalizeString("LTXT_VAR_EISM_MINUTE")) - DEFAULT_MINUTE_STRING_LENGTH) * OFFSET_PER_EXTRA_CHAR
  
  -- Set up subscriptions
  o.im.Subscribe(bndHomeEventsList, function() o:publishHomeEventsList() end)
  o.im.Subscribe(bndAwayEventsList, function() o:publishAwayEventsList() end)
  o.im.Subscribe(bndEmptyRowsData, function() o:publishEmptyBgRows() end)
  o.im.Subscribe(BND_HOME_TEAM_CREST, function() o.im.Publish(BND_HOME_TEAM_CREST, o:getTeamCrest()) end)
  o.im.Subscribe(bndMatchFacts, function() o:publishFactsList() end)
  
  return o
end

function events:shuffleTable(tbl)
  math.randomseed(os.clock() * 1000 + os.time())
  for i = #tbl, 2, -1 do
    local j = math.random(1, i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
end
function events:getMatchResult(isHome)
  local matchInfo = self.services.matchInfo.GetMatchScore()
  if not matchInfo then return "draw" end

  local homeScore = tonumber(matchInfo.homeScore) or 0
  local awayScore = tonumber(matchInfo.awayScore) or 0

  if isHome then
    if homeScore > awayScore then
      return "won"
    elseif homeScore < awayScore then
      return "lost"
    else
      return "draw"
    end
  else
    if awayScore > homeScore then
      return "won"
    elseif awayScore < homeScore then
      return "lost"
    else
      return "draw"
    end
  end
end

function events:assignRandomRating(matchStatus)
  local minRating = 5.0
  local maxRating = 9.0

  if matchStatus == "won" then
    maxRating = 9.5
  elseif matchStatus == "lost" then
    maxRating = 7.0
  elseif matchStatus == "draw" then
    maxRating = 8.0
  end

  local rating = math.random() * (maxRating - minRating) + minRating
  return math.floor(rating * 10 + 0.5) / 10
end

-- Fungsi untuk menentukan icon ID berdasarkan statistik pemain
function events:getStatIconId(stats)
  local rating = stats.rating or 0

  if rating >= 9.0 then
    return 5 -- ⭐ Man of the Match
  elseif rating >= 8.0 then
    return 4 -- 👍 Sangat bagus
  elseif rating >= 7.0 then
    return 3 -- 🟢 Bagus
  elseif rating >= 6.0 then
    return 2 -- 🟡 Cukup
  elseif rating < 6.0 then
    return 1 -- 🔴 Buruk
  end

  return 0 -- Default (tak dikenal)
end

-- HOME
function events:publishHomeEventsList()
  local eventList = {}
  local lineupData = self.homeTeamlineupData or {}

  local selectedPlayers = {}
  for i = 1, math.min(14, #lineupData) do
    table.insert(selectedPlayers, lineupData[i])
  end

  self:shuffleTable(selectedPlayers)

    local matchStatus = self:getMatchResult(true)

  for i, player in ipairs(selectedPlayers) do
    if not player.cachedRating then
      player.cachedRating = self:assignRandomRating(matchStatus)
    end
    local rating = player.cachedRating

    player.stats = player.stats or {}
    player.stats.rating = rating

    local iconId = self:getStatIconId(player.stats)

    table.insert(eventList, {
      data = {
        name = player.playerName,
        number = player.jerseyNumber,
        position = player.position,
        Rating = string.format("%.1f", rating),
        assetId = player.CARD_ID,
        eventId = 0,
        image = {name = "$CircleBar", id = iconId},
        iconOffset = DEFAULT_ICON_HOME_OFFSET + self.mAdditionalIconOffset,
        head = {name = "$Head", id = player.CARD_ID},
        HomeTeamCrest = {name = "$Crest", id = player.teamID}
      }
    })
  end

  -- Urutkan berdasarkan rating tertinggi
 -- table.sort(eventList, function(a, b)
 --   return (a.data.Rating or 0) > (b.data.Rating or 0)
 -- end)

  self.im.Publish(bndHomeEventsList, eventList)
end

-- AWAY
function events:publishAwayEventsList()
  local eventList = {}
  local lineupData = self.awayTeamlineupData or {}

  local selectedPlayers = {}
  for i = 1, math.min(14, #lineupData) do
    table.insert(selectedPlayers, lineupData[i])
  end

  self:shuffleTable(selectedPlayers)

  local matchStatus = self:getMatchResult(false)

for i, player in ipairs(selectedPlayers) do
  if not player.cachedRating then
  player.cachedRating = self:assignRandomRating(matchStatus)
  end
  local rating = player.cachedRating

  player.stats = player.stats or {}
  player.stats.rating = rating

    local iconId = self:getStatIconId(player.stats)

    table.insert(eventList, {
      data = {
        name = player.playerName,
        number = player.jerseyNumber,
        position = player.position,
        Rating = string.format("%.1f", rating),
        assetId = player.CARD_ID,
        eventId = 0,
        image = {name = "$CircleBar", id = iconId},
        iconOffset = DEFAULT_ICON_AWAY_OFFSET + self.mAdditionalIconOffset,
        head = {name = "$Head", id = player.CARD_ID},
        AwayTeamCrest = {name = "$Crest", id = player.teamID}
      }
    })
  end

  -- Urutkan berdasarkan rating tertinggi
 -- table.sort(eventList, function(a, b)
   -- return (a.data.Rating or 0) > (b.data.Rating or 0)
 -- end)

  self.im.Publish(bndAwayEventsList, eventList)
end

function events:getPlayerInfo(teamID, name, number)
  local count = 0
  local specialString = false
  local playerInfo = {
    assetId = 0,
    jerseyNumber = number,
    playerName = name,
    teamName = teamID
  }
  local teamlineupData = nil
  
  if teamID == self.TeamsData[1].assetId then
    teamlineupData = homeTeamlineupData
  else
    teamlineupData = awayTeamlineupData
  end

  if string.find(name, "-") or string.find(name, "%.") then
    specialString = true
  end
 
  if specialString == false then
    count = 0
    playerInfo.playerNam1e =  string.gsub(name, "%b()", " ")
    playerInfo.playerName =  string.gsub(playerInfo.playerName, "^%s*(.-)%s*$", "%1")
  end
  
  for _FORV_6_ = 1, table.getn(teamlineupData) do
    if _FORV_6_ <= 18 then
      if specialString == true then
        if string.find(name, teamlineupData[_FORV_6_].playerName, 1, true) and teamlineupData[_FORV_6_].jerseyNumber == number then 
          if count == 0 then
            count = count + 1
            playerInfo.assetId = teamlineupData[_FORV_6_].CARD_ID
            playerInfo.crestId = teamlineupData[_FORV_6_].teamID
            playerInfo.jerseyNumber = teamlineupData[_FORV_6_].jerseyNumber
            playerInfo.teamName = teamlineupData[_FORV_6_].teamID
            playerInfo.playerName = teamlineupData[_FORV_6_].playerName
            playerInfo.position = teamlineupData[_FORV_6_].position or "??"
            playerInfo.rating = teamlineupData[_FORV_6_].Rating or 0
          end
        end
      else
        if string.find(playerInfo.playerName, teamlineupData[_FORV_6_].playerName,1,true) and playerInfo.playerName == teamlineupData[_FORV_6_].playerName and teamlineupData[_FORV_6_].jerseyNumber == number then
          if count == 0 then
            count = count + 1
            playerInfo.assetId = teamlineupData[_FORV_6_].CARD_ID
            playerInfo.crestId = teamlineupData[_FORV_6_].teamID
            playerInfo.jerseyNumber = teamlineupData[_FORV_6_].jerseyNumber
            playerInfo.teamName = teamlineupData[_FORV_6_].teamID
            playerInfo.playerName = teamlineupData[_FORV_6_].playerName
            playerInfo.position = teamlineupData[_FORV_6_].position or "??"
            playerInfo.rating = teamlineupData[_FORV_6_].Rating or 0
          end
        end
      end
    end
  end
  return playerInfo
end

function events:publishFactsList()
  local listData = self.services.matchInfo.GetMatchFacts(true) or {homeData = {}, awayData = {}}
  local o = listData.homeData
  for i, v in ipairs(o) do
    if listData.awayData[i] then
      v.data.valueRight = listData.awayData[i].data.value
    else
      v.data.valueRight = ""
    end
  end
  self.im.Publish(bndMatchFacts, o)
end

function events:publishEmptyBgRows()
  local emptyDataArr = {}
  for i = 1, NUM_EMPTY_LIST_ROWS do
    table.insert(emptyDataArr, {data = {dummyParam = 0}})
  end
  self.im.Publish(bndEmptyRowsData, emptyDataArr)
end

function events:getTeamCrest(isHome)
  return {
    name = "$Crest",
    id = self:getTeam(isHome).assetId
  }
end

function events:finalize()
  self.im.Unsubscribe(bndHomeEventsList)
  self.im.Unsubscribe(bndAwayEventsList)
  self.im.Unsubscribe(BND_HOME_TEAM_CREST)
  self.im.Unsubscribe(bndEmptyRowsData)
  self.im.Unsubscribe(bndMatchFacts)
end

return events