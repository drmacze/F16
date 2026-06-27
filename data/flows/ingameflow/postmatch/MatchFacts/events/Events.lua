-- mod by laosiji --
-- Remod By MounTsa Tournament --
local events = {}
print("loaded events LUA")

local instance = nil

local bndHomeEventsList = "bnd_home_events_list"
local bndAwayEventsList = "bnd_away_events_list"
local bndEmptyRowsData = "bnd_empty_rows_data"
local NUM_EMPTY_LIST_ROWS = 9
local DEFAULT_ICON_HOME_OFFSET = 60
local DEFAULT_ICON_AWAY_OFFSET = 105
local OFFSET_PER_EXTRA_CHAR = 10
local DEFAULT_MINUTE_STRING_LENGTH = 4

-- Inisialisasi global variables dengan nilai default
TournamentStats = TournamentStats or {}
TeamPlayerCache = TeamPlayerCache or {}
GlobalTournamentSettings = GlobalTournamentSettings or { tourId = 1 }
global_currentMatchData = global_currentMatchData or {}
global_currentMatchData.goals = global_currentMatchData.goals or {}

function events:processAndRecordAllMatchStats()
  print("Processing end-of-match stats...")
  if not self.eventsData then
    print("Warning: eventsData is nil. Cannot process stats.")
    return
  end

  local allEvents = {
    {teamId = self.TeamsData[1].assetId, data = self.eventsData.homeData},
    {teamId = self.TeamsData[2].assetId, data = self.eventsData.awayData}
  }

  for _, teamEvents in ipairs(allEvents) do
    if teamEvents.data then
      for _, event in ipairs(teamEvents.data) do
        if event.data.eventId == 0 then -- Goal event
          local minute = event.data.minute
          local teamId = teamEvents.teamId
          local scorerName = event.data.name
          local playerNumber = event.data.number
          
          print("Found Goal Event -> Name:", scorerName, "Num:", playerNumber, "TeamID:", teamId)

          self:updateGoalStats(minute, teamId, scorerName, playerNumber)
        elseif event.data.eventId == 1 then -- Yellow card
          self:updateCardStats(teamEvents.teamId, event.data.name, event.data.number, "yellow")
        elseif event.data.eventId == 2 then -- Red card
          self:updateCardStats(teamEvents.teamId, event.data.name, event.data.number, "red")
        end
      end
    end
  end
  print("Finished processing end-of-match stats.")
end

function events:new(init)
  print("New Function MatchEventsLua")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    matchInfo = o.api("MatchInfoService"),
    SquadManagementService = o.api("SquadMgtService"),
    TeamService = o.api("TeamService")
  }
  
  -- Tambahkan localization service jika diperlukan
  if o.api("LocalizationService") then
    o.services.loc = o.api("LocalizationService")
  end
  
  self.eventsData = o.services.matchInfo.GetMatchEvents()
  o.TeamsData = o.services.matchInfo.GetMatchTeams()
  
  o.homeTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(0, o.TeamsData[1].assetId, 0)
  o.awayTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(1, o.TeamsData[2].assetId, 0)

  o.mAdditionalIconOffset = (string.len("MIN") - DEFAULT_MINUTE_STRING_LENGTH) * OFFSET_PER_EXTRA_CHAR
  
  instance = o

  -- Inisialisasi data tournament jika ada
  o:initializeTournamentData()

  o:processAndRecordAllMatchStats()

  o.im.Subscribe(bndHomeEventsList, function()
    o:publishHomeEventsList()
  end)
  o.im.Subscribe(bndAwayEventsList, function()
    o:publishAwayEventsList()
  end)
  o.im.Subscribe(bndEmptyRowsData, function()
    o:publishEmptyBgRows()
  end)
  return o
end

-- Fungsi baru untuk inisialisasi data tournament
function events:initializeTournamentData()
  -- Cek apakah ini pertandingan tournament
  if currentTourData and currentTourData.tourIndex and currentTourData.tourIndex > 0 then
    print("📊 Tournament match detected. Initializing tournament stats...")
    
    local tourId = currentTourData.tourIndex
    GlobalTournamentSettings.tourId = tourId
    
    -- Inisialisasi stats untuk tournament ini
    TournamentStats[tourId] = TournamentStats[tourId] or {
      Goals = {}, 
      Assists = {}, 
      Appearances = {},
      YellowCards = {},
      RedCards = {}
    }
    
    -- Cache lineup pemain untuk kedua tim
    TeamPlayerCache[tourId] = TeamPlayerCache[tourId] or {}
    TeamPlayerCache[tourId][self.TeamsData[1].assetId] = self.homeTeamlineupData
    TeamPlayerCache[tourId][self.TeamsData[2].assetId] = self.awayTeamlineupData
    
    -- Record appearances untuk semua pemain yang bermain
    self:recordTournamentAppearances(tourId)
  end
end

-- Fungsi untuk mencatat penampilan pemain di tournament
function events:recordTournamentAppearances(tourId)
  for _, teamId in ipairs({self.TeamsData[1].assetId, self.TeamsData[2].assetId}) do
    local lineup = TeamPlayerCache[tourId][teamId]
    if lineup then
      for _, player in ipairs(lineup) do
        if player.CARD_ID then
          TournamentStats[tourId].Appearances[player.CARD_ID] = 
            (TournamentStats[tourId].Appearances[player.CARD_ID] or 0) + 1
        end
      end
    end
  end
end

function events:publishHomeEventsList()
  if not self.eventsData or not self.eventsData.homeData then
    print("Warning: No home events data available")
    self.im.Publish(bndHomeEventsList, {})
    return
  end

  local o = self.eventsData.homeData
  for i, v in ipairs(o) do
    local playerInfo = self:getPlayerInfo(self.TeamsData[1].assetId, o[i].data.name, o[i].data.number)
    v.data.image = {
      name = "$Events",
      id = o[i].data.eventId
    }
    v.data.iconOffset = DEFAULT_ICON_HOME_OFFSET + self.mAdditionalIconOffset
    v.data.head = {
      name = "$Head",
      id = playerInfo.assetId or 0
    }
  end
  self.im.Publish(bndHomeEventsList, self.eventsData.homeData)
end

function events:publishAwayEventsList()
  if not self.eventsData or not self.eventsData.awayData then
    print("Warning: No away events data available")
    self.im.Publish(bndAwayEventsList, {})
    return
  end

  local o = self.eventsData.awayData
  for i, v in ipairs(o) do
    local playerInfo = self:getPlayerInfo(self.TeamsData[2].assetId, o[i].data.name, o[i].data.number)
    v.data.image = {
      name = "$Events",
      id = o[i].data.eventId
    }
    v.data.head = {
      name = "$Head",
      id = playerInfo.assetId or 0
    }
    v.data.iconOffset = DEFAULT_ICON_AWAY_OFFSET + self.mAdditionalIconOffset
  end
  self.im.Publish(bndAwayEventsList, self.eventsData.awayData)
end

function events:publishEmptyBgRows()
  local emptyDataArr = {}
  for i = 1, NUM_EMPTY_LIST_ROWS do
    table.insert(emptyDataArr, {
      data = {dummyParam = 0}
    })
  end
  self.im.Publish(bndEmptyRowsData, emptyDataArr)
end

function events:getPlayerInfo(teamID, name, number)
    -- Tentukan skuad mana yang akan dicari (tim tuan rumah atau tandang)
    local lineup = (teamID == self.TeamsData[1].assetId) and self.homeTeamlineupData or self.awayTeamlineupData
    
    if not lineup then
        print("⚠️ Peringatan: Data skuad tidak ditemukan untuk teamID: " .. tostring(teamID))
        -- Kembalikan data dasar jika skuad tidak ada
        return { assetId = 0, jerseyNumber = number, playerName = name }
    end

    -- ## Strategi 1: Cari berdasarkan nomor punggung (paling akurat)
    for _, player in ipairs(lineup) do
        if player.jerseyNumber == number then
            -- Langsung kembalikan data pemain jika nomor punggung cocok
            return {
                assetId = player.CARD_ID or 0,
                jerseyNumber = player.jerseyNumber,
                playerName = player.playerName
            }
        end
    end

    -- ## Strategi 2: Jika nomor punggung tidak cocok, cari berdasarkan nama (sebagai fallback)
    -- Bersihkan nama dari event untuk pencocokan yang lebih baik
    local cleanEventName = string.gsub(name:lower(), "%b()", "")
    cleanEventName = string.gsub(cleanEventName, "^%s*(.-)%s*$", "%1")

    for _, player in ipairs(lineup) do
        local cleanPlayerName = player.playerName:lower()
        -- Cari apakah nama dari event adalah bagian dari nama lengkap pemain di skuad
        if string.find(cleanPlayerName, cleanEventName, 1, true) then
            -- Kembalikan data pemain jika ada kecocokan nama
            return {
                assetId = player.CARD_ID or 0,
                jerseyNumber = player.jerseyNumber,
                playerName = player.playerName
            }
        end
    end

    -- ## Fallback Terakhir: Jika tidak ada yang cocok sama sekali
    print("❓Pemain tidak dapat dicocokkan di skuad: " .. name .. " #" .. number)
    return { assetId = 0, jerseyNumber = number, playerName = name }
end

function events:updateGoalStats(minute, teamId, scorerName, playerNumber)
    local tourId = GlobalTournamentSettings.tourId or 1
    
    -- Initialize stats if needed
    TournamentStats[tourId] = TournamentStats[tourId] or { 
        Goals = {}, 
        Assists = {}, 
        Appearances = {},
        YellowCards = {},
        RedCards = {}
    }
    
    -- Find player ID
    local playerId = self:findPlayerId(teamId, scorerName, playerNumber)
    if not playerId then 
        print("⚠️ Player not found for stat update:", scorerName, "#"..playerNumber)
        return 
    end
    
    -- Update goal count
    TournamentStats[tourId].Goals[playerId] = (TournamentStats[tourId].Goals[playerId] or 0) + 1
    
    print("⚽ Goal Stat Recorded:", scorerName, "| Team:", teamId, "| Total Goals:", TournamentStats[tourId].Goals[playerId])
    
    -- Also update global match data
    table.insert(global_currentMatchData.goals, {
        minute = minute,
        playerId = playerId,
        playerName = scorerName,
        teamId = teamId,
        teamName = self:getTeamName(teamId)
    })
end

function events:updateCardStats(teamId, playerName, playerNumber, cardType)
    local tourId = GlobalTournamentSettings.tourId or 1
    
    TournamentStats[tourId] = TournamentStats[tourId] or { 
        Goals = {}, 
        Assists = {}, 
        Appearances = {},
        YellowCards = {},
        RedCards = {}
    }
    
    local playerId = self:findPlayerId(teamId, playerName, playerNumber)
    if not playerId then return end
    
    if cardType == "yellow" then
        TournamentStats[tourId].YellowCards[playerId] = (TournamentStats[tourId].YellowCards[playerId] or 0) + 1
        print("🟨 Yellow Card Recorded:", playerName, "| Team:", teamId)
    elseif cardType == "red" then
        TournamentStats[tourId].RedCards[playerId] = (TournamentStats[tourId].RedCards[playerId] or 0) + 1
        print("🟥 Red Card Recorded:", playerName, "| Team:", teamId)
    end
end

function events:findPlayerId(teamId, playerName, playerNumber)
    local tourId = GlobalTournamentSettings.tourId or 1
    
    -- Initialize cache if needed
    if not TeamPlayerCache[tourId] then TeamPlayerCache[tourId] = {} end
    if not TeamPlayerCache[tourId][teamId] then
        TeamPlayerCache[tourId][teamId] = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamId, 0) or {}
    end

    -- First try to match by jersey number
    for _, player in ipairs(TeamPlayerCache[tourId][teamId]) do
        if player.jerseyNumber == playerNumber then
            return player.CARD_ID
        end
    end
    
    -- Fallback to name matching
    local cleanName = string.gsub(playerName:lower(), "%b()", "")
    cleanName = string.gsub(cleanName, "^%s*(.-)%s*$", "%1")
    
    for _, player in ipairs(TeamPlayerCache[tourId][teamId]) do
        if string.find(player.playerName:lower(), cleanName, 1, true) then
            return player.CARD_ID
        end
    end
    
    return nil
end

function events:getTeamName(teamId)
    -- Coba dapatkan nama tim dari service
    local teamInfo = self.services.TeamService.GetTeamInfo(teamId)
    if teamInfo and teamInfo.teamName then
        return teamInfo.teamName
    end
    
    -- Fallback ke ID jika tidak ditemukan
    return "Team " .. tostring(teamId)
end

function onGoalScored(minute, scorerJerseyNumber, scorerName, teamId, teamName)
  if instance then
      instance:updateGoalStats(minute, teamId, scorerName, scorerJerseyNumber)
  end

  local playerId = 0
  if instance then
    playerId = instance:findPlayerId(teamId, scorerName, scorerJerseyNumber) or 0
  end

  table.insert(global_currentMatchData.goals, {
      minute = minute,
      playerId = playerId,
      playerName = scorerName,
      teamId = teamId,
      teamName = teamName
  })
end

function events:finalize()
  self.im.Unsubscribe(bndHomeEventsList)
  self.im.Unsubscribe(bndAwayEventsList)
  self.im.Unsubscribe(bndEmptyRowsData)
  
  -- Simpan stats tournament jika perlu
  if currentTourData and currentTourData.tourIndex then
    print("💾 Finalizing tournament stats for tour:", currentTourData.tourIndex)
  end
  
  instance = nil
end

return events