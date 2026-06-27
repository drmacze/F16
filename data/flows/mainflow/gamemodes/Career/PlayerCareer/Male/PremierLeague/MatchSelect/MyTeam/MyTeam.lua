-- Menu Player Career --
-- Beapro Remode By Septiawan --

local Beapro = {}
local ACT_ADVANCE = "act_advance"
local ACT_OPPONENT = "act_opponent"
local ACT_PLAY = "act_play"
local ACT_RESTART = "act_restart"
local BND_MATCH_VISIBLE  = "bnd_match_visible"
local BND_RESULT_VISIBLE = "bnd_result_visible"
local BND_SUCCESS_VISIBLE = "bnd_success_visible"
local BND_DATE = "bnd_date"
local BND_PROGRESS = "bnd_progress"
local BND_APPEARANCE = "bnd_appearance"
local BND_MATCHDAY = "bnd_matchday"
local BND_MATCH_LIST = "bnd_match_list"
local BND_LOGO_LEAGUE = "bnd_logo_league"
local BND_ACTIVE_HOME_TEAM_CREST = "bnd_active_home_team_crest"
local BND_ACTIVE_AWAY_TEAM_CREST = "bnd_active_away_team_crest"
local BND_ACTIVE_HOME_TEAM_NAME = "bnd_active_home_team_name"
local BND_ACTIVE_AWAY_TEAM_NAME = "bnd_active_away_team_name"
local BND_HOME_TEAM_POSITION = "bnd_home_team_position"
local BND_AWAY_TEAM_POSITION = "bnd_away_team_position"
local BND_HOME_TEAM_POSITION_MARGIN = "bnd_home_team_position_marginLeft"
local BND_AWAY_TEAM_POSITION_MARGIN = "bnd_away_team_position_marginLeft"
beaproId = 1
activeMatchIndex = 1

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

local rivalListData = {}

function Beapro:getCurrentPlayableMatch()
  local lastPlayed = nil
  for i, v in ipairs(rivalListData) do
    local matchData = BeaproGrouping[beaproId][i]
    local isPlayed = matchData[5]
    if v.isUnlock and not isPlayed then
      return i, v
    end
    if v.isUnlock and isPlayed then
      lastPlayed = { i, v }
    end
  end

  if lastPlayed then
    return lastPlayed[1], lastPlayed[2]
  end

  return nil, nil
end

function Beapro:getPlayedMatchCount()
  local count = 0
  local list = BeaproGrouping[beaproId]
  for i = 1, #list do
    if list[i][5] == true then
      count = count + 1
    end
  end
  return count
end

function Beapro:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService")
  }
  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o:Init()
  o.leagueLogo = { name = "$LeaguePlayer", id = 13 }
  o.im.Subscribe(BND_MATCH_LIST, function()
    o:publishMatchRows()
  end)
  o.im.Subscribe(BND_MATCH_VISIBLE, function()
    o:publishMatchVisible()
  end)
  o.im.Subscribe(BND_RESULT_VISIBLE, function()
    o:publishResultVisible()
  end)
  o.im.Subscribe(BND_SUCCESS_VISIBLE, function()
    o:publishSuccessVisible()
  end)
  o.im.Subscribe(BND_LOGO_LEAGUE, function()
    o.im.Publish(BND_LOGO_LEAGUE, o.leagueLogo)
  end)
  o.im.Subscribe(BND_ACTIVE_HOME_TEAM_CREST, function()
    o:publishActiveHomeCrest()
  end)
  o.im.Subscribe(BND_ACTIVE_AWAY_TEAM_CREST, function()
    o:publishActiveAwayCrest()
  end)
  o.im.Subscribe(BND_ACTIVE_HOME_TEAM_NAME, function()
    o:publishActiveHomeTeamName()
  end)
  o.im.Subscribe(BND_ACTIVE_AWAY_TEAM_NAME, function()
    o:publishActiveAwayTeamName()
  end)
  o.im.Subscribe(BND_HOME_TEAM_POSITION, function()
    o:publishHomeTeamPosition()
  end)
  o.im.Subscribe(BND_AWAY_TEAM_POSITION, function()
    o:publishAwayTeamPosition()
  end)
  o.im.Subscribe(BND_HOME_TEAM_POSITION_MARGIN, function()
    o:publishHomeTeamPosition()
  end)
  o.im.Subscribe(BND_AWAY_TEAM_POSITION_MARGIN, function()
    o:publishAwayTeamPosition()
  end)
  o.im.Subscribe(BND_DATE, function()
   o:publishDate()
  end)
  o.im.Subscribe(BND_MATCHDAY, function()
    o:publishMatchday()
  end)
  o.im.Subscribe(BND_APPEARANCE, function()
    o:publishAppearance()
  end)
  o.im.Subscribe(BND_PROGRESS, function()
    o:progressLabel()
  end)
  o.im.RegisterAction(ACT_PLAY, function()
    local index, match = o:getCurrentPlayableMatch()
    if not index then
      o:NoMatch()
      return
    end
    o:PlayMatchday({ id = index })
  end)
  o.im.RegisterAction(ACT_OPPONENT, function()
    local index, match = o:getCurrentPlayableMatch()
    if not index then
      o:NoMatch()
      return
    end
    o:OpponentAnalysis({ id = index })
  end)  
  o.im.RegisterAction(ACT_RESTART, function(actionName)
    o:ResetTeam()
  end)

  return o
end

function Beapro:Init()
  rivalListData = {}
  local list = BeaproGrouping[beaproId]
  for i = 1, #list do
    local m = list[i]
    table.insert(rivalListData, {
      homeID   = m[1],
      awayID   = m[2],
      isUnlock = m[8],
      data     = {}
    })
  end
end

function Beapro:publishMatchRows()
  for i, v in ipairs(rivalListData) do
    local m = BeaproGrouping[beaproId][i]
    local homeScore, awayScore, isPlayed = m[3], m[4], m[5]
    v.data.Matchday = i    
    if isPlayed then
      if homeScore > awayScore then
        v.data.MatchdayText = ("Win by score %d - %d"):format(homeScore, awayScore)
        v.data.Icon = { name = "$Icon_Career_Done", id = 3 }
      elseif homeScore < awayScore then
        v.data.MatchdayText = ("Lose by score %d - %d"):format(homeScore, awayScore)
        v.data.Icon = { name = "$Icon_Career_Failed", id = 4 }
      else
        v.data.MatchdayText = ("Draw by score %d - %d"):format(homeScore, awayScore)
        v.data.Icon = { name = "$Icon_Career_Done", id = 3 }
      end
    else
      v.data.MatchdayText = "Matchday " .. i
      v.data.Icon = v.isUnlock
        and { name = "$Icon_Career_Ball", id = 2 }
        or  { name = "$Icon_Career_Lock", id = 1 }
    end
    v.data.HomeTeamCrest = { name = "$Crest64x64", id = v.homeID }
    v.data.AwayTeamCrest = { name = "$Crest64x64", id = v.awayID }
    v.data.HomeTeamName = self.loc.LocalizeString("TeamName_Abbr15_" .. v.homeID)
    v.data.AwayTeamName = self.loc.LocalizeString("TeamName_Abbr15_" .. v.awayID)
    v.data.clickAction = v.clickAction
  end
  self.im.Publish(BND_MATCH_LIST, rivalListData)
  local index = self:getCurrentPlayableMatch()
  if index then activeMatchIndex = index end
  self:publishActiveHomeCrest()
  self:publishActiveAwayCrest()
  self:publishActiveHomeTeamName()
  self:publishActiveAwayTeamName()
  self:publishMatchday()
end

function Beapro:getFormattedDate()
  local days = {
    "Sunday", "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday"
  }
  local months = {
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  }
  local now = os.date("*t")
  local dayName = days[now.wday]
  local monthName = months[now.month]
  local day = string.format("%02d", now.day)
  return string.format("%s, %s %s", dayName, monthName, day)
end

function Beapro:getHomeTeamAlphabetPosition()
  local homeID = currentBeaproInfo[beaproId].homeID
  if not homeID or homeID == 0 then return 0 end
  local teamMap = {}
  local group = BeaproGrouping[beaproId]
  for i = 1, #group do
    local h = group[i][1]
    local a = group[i][2]
    if h then teamMap[h] = true end
    if a then teamMap[a] = true end
  end
  local teamList = {}
  for id in pairs(teamMap) do
    table.insert(teamList, id)
  end
  table.sort(teamList, function(a, b)
    local nameA = self.loc.LocalizeString("TeamName_Abbr15_" .. a)
    local nameB = self.loc.LocalizeString("TeamName_Abbr15_" .. b)
    return nameA < nameB
  end)
  for pos, id in ipairs(teamList) do
    if id == homeID then
      return pos
    end
  end

  return 0
end

function Beapro:getTeamAlphabetPosition(teamID)
  if not teamID or teamID == 0 then return 0 end
  local teamMap = {}
  local group = BeaproGrouping[beaproId]
  for i = 1, #group do
    local h = group[i][1]
    local a = group[i][2]
    if h then teamMap[h] = true end
    if a then teamMap[a] = true end
  end
  local teamList = {}
  for id in pairs(teamMap) do
    table.insert(teamList, id)
  end
  table.sort(teamList, function(a, b)
    local nameA = self.loc.LocalizeString("TeamName_Abbr15_" .. a)
    local nameB = self.loc.LocalizeString("TeamName_Abbr15_" .. b)
    return nameA < nameB
  end)
  for pos, id in ipairs(teamList) do
    if id == teamID then
      return pos
    end
  end

  return 0
end

function Beapro:formatOrdinal(pos)
  if pos == 0 then return "0" end
  if pos % 100 >= 11 and pos % 100 <= 13 then
    return pos .. "TH"
  end
  local lastDigit = pos % 10
  if lastDigit == 1 then
    return pos .. "ST"
  elseif lastDigit == 2 then
    return pos .. "ND"
  elseif lastDigit == 3 then
    return pos .. "RD"
  else
    return pos .. "TH"
  end
end

local function calculateMarginLeftFromName(teamName, fontSize)
  if not teamName then return 0 end
  local avgCharWidth = fontSize * 0.6
  return math.floor(#teamName * avgCharWidth) + 10
end

function Beapro:publishHomeTeamPosition()
  local position = self:getHomeTeamAlphabetPosition()
  local text = self:formatOrdinal(position)
  local homeID = currentBeaproInfo[beaproId].homeID
  local teamName = self.loc.LocalizeString("TeamName_Abbr15_" .. homeID)
  local marginLeft = calculateMarginLeftFromName(teamName, 30)
  self.im.Publish(BND_HOME_TEAM_POSITION, text)
  self.im.Publish(BND_HOME_TEAM_POSITION_MARGIN, marginLeft)
end

function Beapro:publishAwayTeamPosition()
  local index, match = self:getCurrentPlayableMatch()
  if not match then return end
  activeMatchIndex = index
  local pos = self:getTeamAlphabetPosition(match.awayID)
  local text = self:formatOrdinal(pos)
  local teamName =
    self.loc.LocalizeString("TeamName_Abbr15_" .. match.awayID)
  local marginLeft = calculateMarginLeftFromName(teamName, 30)
  self.im.Publish(BND_AWAY_TEAM_POSITION, text)
  self.im.Publish(BND_AWAY_TEAM_POSITION_MARGIN, marginLeft)
end

function Beapro:publishDate()
  self.im.Publish(BND_DATE, self:getFormattedDate())
end

function Beapro:publishActiveHomeCrest()
  self.im.Publish(BND_ACTIVE_HOME_TEAM_CREST, {
    name = "$Crest",
    id   = currentBeaproInfo[beaproId].homeID
  })
end

function Beapro:publishActiveAwayCrest()
  local index, match = self:getCurrentPlayableMatch()
  if not match then return end
  activeMatchIndex = index

  self.im.Publish(BND_ACTIVE_AWAY_TEAM_CREST, {
    name = "$Crest",
    id   = match.awayID
  })
end

function Beapro:publishActiveHomeTeamName()
  local id = currentBeaproInfo[beaproId].homeID
  self.im.Publish(
    BND_ACTIVE_HOME_TEAM_NAME,
    self.loc.LocalizeString("TeamName_Abbr15_" .. id)
  )
end

function Beapro:publishActiveAwayTeamName()
  local index, match = self:getCurrentPlayableMatch()
  if not match then return end
  activeMatchIndex = index
  self.im.Publish(
    BND_ACTIVE_AWAY_TEAM_NAME,
    self.loc.LocalizeString("TeamName_Abbr15_" .. match.awayID)
  )
end

function Beapro:publishMatchday()
  local playedCount = self:getPlayedMatchCount()
  local currentDay = playedCount + 1

  self.im.Publish(
    BND_MATCHDAY,
    ("Current matchday: %d"):format(currentDay)
  )
end

function Beapro:progressLabel()
  
  if currentBeaproInfo[beaproId].isSuccess == 1 then
    self.im.Publish(BND_PROGRESS, "FAILED")
  elseif currentBeaproInfo[beaproId].isSuccess == 2 then
    self.im.Publish(BND_PROGRESS, "SUCCESS")
  else
    self.im.Publish(BND_PROGRESS, "IN PROGRESS")
  end
end

function Beapro:publishAppearance()
  local playedCount = self:getPlayedMatchCount()

  -- Belum ada match selesai
  if playedCount == 0 then
    self.im.Publish(BND_APPEARANCE, "N/A")
    return
  end

  -- Match yang sudah SELESAI
  self.im.Publish(
    BND_APPEARANCE,
    ("Appearance %d"):format(playedCount)
  )
end



return Beapro