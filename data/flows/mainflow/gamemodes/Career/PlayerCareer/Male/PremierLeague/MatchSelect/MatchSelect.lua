-- Menu Player Career --
-- Beapro Remode By Septiawan --

local MatchSelect = {}
local ACT_ADVANCE = "act_advance"
local ACT_OPPONENT = "act_opponent"
local ACT_PLAY = "act_play"
local ACT_RESTART = "act_restart"
local ACT_EXIT = "act_exit"
local ACT_END_CAREER = "act_end_career"
local ACT_END_TAB_VISIBLE   = "act_end_tab_visible"
local ACT_TABLE_TAB_VISIBLE = "act_table_tab_visible"
local ACT_END2_TAB_VISIBLE   = "act_end2_tab_visible"
local ACT_TABLE2_TAB_VISIBLE = "act_table2_tab_visible"
local BND_TABLE_TAB_VISIBLE = "bnd_table_tab_visible"
local BND_END_TAB_VISIBLE   = "bnd_end_tab_visible"
local BND_END2_TAB_VISIBLE   = "bnd_end2_tab_visible"
local BND_TABLE2_TAB_VISIBLE = "bnd_table2_tab_visible"
local BND_MATCH_VISIBLE  = "bnd_match_visible"
local BND_RESULT_VISIBLE = "bnd_result_visible"
local BND_SUCCESS_VISIBLE = "bnd_success_visible"
local BND_DATE = "bnd_date"
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
local BND_FAILED_LABEL  = "bnd_failed_label"
local BND_FINISH_LABEL = "bnd_finish_label"
beaproId = 1
activeMatchIndex = 1

-- Limite de derrotas/empates antes de falhar na missão
local MAX_FAILURES = 3

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

local rivalListData = {}

function MatchSelect:getCurrentPlayableMatch()
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

-- Nova função: Contar derrotas e empates
function MatchSelect:countFailures()
  local failures = 0
  local group = BeaproGrouping[beaproId]
  
  for i = 1, #group do
    local m = group[i]
    if m[5] == true then  -- Se a partida foi jogada
      if m[3] < m[4] then -- Derrota
        failures = failures + 1
      elseif m[3] == m[4] then -- Empate
        failures = failures + 1
      end
    end
  end
  
  return failures
end

-- Nova função: Verificar se a missão deve falhar
function MatchSelect:shouldMissionFail()
  return self:countFailures() >= MAX_FAILURES
end

function MatchSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService")
  }
  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o:Init()
  o.tableTabVisible = true
  o.endTabVisible   = false
  o.table2TabVisible = true
  o.end2TabVisible   = false
  o.leagueLogo = { name = "$LeagueLogo", id = 13 }
  o.im.Subscribe(BND_MATCH_LIST, function()
    o:publishMatchRows()
  end)
  o.im.Subscribe(BND_TABLE_TAB_VISIBLE, function()
    o.im.Publish(BND_TABLE_TAB_VISIBLE, o.tableTabVisible)
  end)
  o.im.Subscribe(BND_END_TAB_VISIBLE, function()
    o.im.Publish(BND_END_TAB_VISIBLE, o.endTabVisible)
  end)
  o.im.Subscribe(BND_TABLE2_TAB_VISIBLE, function()
    o.im.Publish(BND_TABLE2_TAB_VISIBLE, o.table2TabVisible)
  end)
  o.im.Subscribe(BND_END2_TAB_VISIBLE, function()
    o.im.Publish(BND_END2_TAB_VISIBLE, o.end2TabVisible)
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
  o.im.Subscribe(BND_FAILED_LABEL, function()
    o:publishFailedLabel()
  end)
  o.im.Subscribe(BND_FINISH_LABEL, function()
    o:publishFinishLabel()
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
  o.im.RegisterAction(ACT_END_TAB_VISIBLE, function()
    if currentBeaproInfo[beaproId].isSuccess == 1 then
      o.tableTabVisible = false
      o.endTabVisible   = true
      o.im.Publish(BND_TABLE_TAB_VISIBLE, false)
      o.im.Publish(BND_END_TAB_VISIBLE, true)
    end
  end)
  o.im.RegisterAction(ACT_TABLE_TAB_VISIBLE, function()
    if currentBeaproInfo[beaproId].isSuccess == 1 then
      o.tableTabVisible = true
      o.endTabVisible   = false
      o.im.Publish(BND_TABLE_TAB_VISIBLE, true)
      o.im.Publish(BND_END_TAB_VISIBLE, false)
    end
  end)
  o.im.RegisterAction(ACT_END2_TAB_VISIBLE, function()
    if currentBeaproInfo[beaproId].isSuccess == 2 then
      o.table2TabVisible = false
      o.end2TabVisible   = true
      o.im.Publish(BND_TABLE2_TAB_VISIBLE, false)
      o.im.Publish(BND_END2_TAB_VISIBLE, true)
    end
  end)
  o.im.RegisterAction(ACT_TABLE2_TAB_VISIBLE, function()
    if currentBeaproInfo[beaproId].isSuccess == 2 then
      o.table2TabVisible = true
      o.end2TabVisible   = false
      o.im.Publish(BND_TABLE2_TAB_VISIBLE, true)
      o.im.Publish(BND_END2_TAB_VISIBLE, false)
    end
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
  o.im.RegisterAction(ACT_EXIT, function(actionName)
    o:ExitMenu()
  end)
  o.im.RegisterAction(ACT_RESTART, function(actionName)
    o:ResetTeam()
  end)
  o.im.RegisterAction(ACT_END_CAREER, function(actionName)
    o:EndCareer()
  end)

  return o
end

function MatchSelect:Init()
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

function MatchSelect:publishMatchRows()
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

function MatchSelect:getFormattedDate()
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

function MatchSelect:getHomeTeamAlphabetPosition()
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

function MatchSelect:getTeamAlphabetPosition(teamID)
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

function MatchSelect:formatOrdinal(pos)
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

function MatchSelect:publishHomeTeamPosition()
  local position = self:getHomeTeamAlphabetPosition()
  local text = self:formatOrdinal(position)
  local homeID = currentBeaproInfo[beaproId].homeID
  local teamName = self.loc.LocalizeString("TeamName_Abbr15_" .. homeID)
  local marginLeft = calculateMarginLeftFromName(teamName, 30)
  self.im.Publish(BND_HOME_TEAM_POSITION, text)
  self.im.Publish(BND_HOME_TEAM_POSITION_MARGIN, marginLeft)
end

function MatchSelect:publishAwayTeamPosition()
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

function MatchSelect:publishDate()
  self.im.Publish(BND_DATE, self:getFormattedDate())
end

function MatchSelect:publishActiveHomeCrest()
  self.im.Publish(BND_ACTIVE_HOME_TEAM_CREST, {
    name = "$Crest",
    id   = currentBeaproInfo[beaproId].homeID
  })
end

function MatchSelect:publishActiveAwayCrest()
  local index, match = self:getCurrentPlayableMatch()
  if not match then return end
  activeMatchIndex = index

  self.im.Publish(BND_ACTIVE_AWAY_TEAM_CREST, {
    name = "$Crest",
    id   = match.awayID
  })
end

function MatchSelect:publishActiveHomeTeamName()
  local id = currentBeaproInfo[beaproId].homeID
  self.im.Publish(
    BND_ACTIVE_HOME_TEAM_NAME,
    self.loc.LocalizeString("TeamName_Abbr15_" .. id)
  )
end

function MatchSelect:publishActiveAwayTeamName()
  local index, match = self:getCurrentPlayableMatch()
  if not match then return end
  activeMatchIndex = index
  self.im.Publish(
    BND_ACTIVE_AWAY_TEAM_NAME,
    self.loc.LocalizeString("TeamName_Abbr15_" .. match.awayID)
  )
end

function MatchSelect:publishMatchday()
  self.im.Publish(
    BND_MATCHDAY,
    ("Matchday %d / %d"):format(activeMatchIndex, #rivalListData)
  )
end

function MatchSelect:calculateCareerResult()
  local totalPlayed, win, lose, draw = 0, 0, 0, 0

  local group = BeaproGrouping[beaproId]
  for i = 1, #group do
    local m = group[i]
    if m[5] == true then
      totalPlayed = totalPlayed + 1
      if m[3] > m[4] then
        win = win + 1
      elseif m[3] < m[4] then
        lose = lose + 1
      else
        draw = draw + 1
      end
    end
  end

  return totalPlayed, win, lose, draw
end

function MatchSelect:publishFailedLabel()
  if currentBeaproInfo[beaproId].isSuccess == 1 then
    local totalPlayed, win, lose, draw = self:calculateCareerResult()
    local totalAllMatch = #BeaproGrouping[beaproId]
    local failures = lose + draw

    local text = string.format(
      "You reached the failure limit with %d losses and draws combined. You completed %d out of %d matches, winning %d.",
      failures,
      totalPlayed,
      totalAllMatch,
      win
    )

    self.im.Publish(BND_FAILED_LABEL, text)
  else
    self.im.Publish(BND_FAILED_LABEL, "")
  end
end

function MatchSelect:publishFinishLabel()
  if currentBeaproInfo[beaproId].isSuccess == 2 then
    local totalPlayed, win, lose, draw = self:calculateCareerResult()
    local totalAllMatch = #BeaproGrouping[beaproId]

    local homeID = currentBeaproInfo[beaproId].homeID
    local teamName = self.loc.LocalizeString("TeamName_Abbr15_" .. homeID)

    local text = string.format(
      "Congratulations, you have completed Player Career mode as a %s player with a perfect winning record. Out of %d matches, you achieved %d wins with %d losses and %d draws.",
      teamName,
      totalAllMatch,
      win,
      lose,
      draw
    )

    self.im.Publish(BND_FINISH_LABEL, text)
  end
end

function MatchSelect:publishMatchVisible()
  local visible = true
  if currentBeaproInfo[beaproId].isSuccess == 1 then
    visible = false
  end
  if currentBeaproInfo[beaproId].isSuccess == 2 then
    visible = false
  end
  self.im.Publish(BND_MATCH_VISIBLE, visible)
end

function MatchSelect:publishResultVisible()
  local visible = false
  if currentBeaproInfo[beaproId].isSuccess == 1 then
    visible = true
    self.tableTabVisible = false
    self.endTabVisible   = true
    self.im.Publish(BND_TABLE_TAB_VISIBLE, false)
    self.im.Publish(BND_END_TAB_VISIBLE, true)
  end
  self.im.Publish(BND_RESULT_VISIBLE, visible)
end

function MatchSelect:publishSuccessVisible()
  local visible = false
  if currentBeaproInfo[beaproId].isSuccess == 2 then
    visible = true
    self.table2TabVisible = false
    self.end2TabVisible   = true
    self.im.Publish(BND_TABLE2_TAB_VISIBLE, false)
    self.im.Publish(BND_END2_TAB_VISIBLE, true)
  end
  self.im.Publish(BND_SUCCESS_VISIBLE, visible)
end

function MatchSelect:PlayMatchday(data)
  activeMatchIndex = data.id
  local m = BeaproGrouping[beaproId][activeMatchIndex]
  currentBeaproData.Index = beaproId
  currentBeaproData.round = activeMatchIndex
  currentBeaproData.homeID = currentBeaproInfo[beaproId].homeID
  currentBeaproData.awayID = m[2]
  currentBeaproData.difficulty = m[6]
  currentMatch.HomeTeamID = currentBeaproData.homeID
  currentMatch.AwayTeamID = currentBeaproData.awayID
  
  -- POPUP DE CONFIRMAÇÃO
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = { "evt_hide_popup" }
  }
  
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Confirm",
    clickEvents = { "evt_hide_popup" },
    clickCallback = function()
      if m[5] == false and m[8] == true then
        self.nav.Event(nil, "evt_advance")
      elseif m[5] == true and m[8] == true then
        self:ReMatch()
      else
        self:NoMatch()
      end
    end
  }
  
  local popupData = {
    title = "PLAY MATCH",
    message = "Are you sure you want to play this match?",
    buttons = { buttonNo, buttonYes }
  }
  
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function MatchSelect:OpponentAnalysis(data)
  activeMatchIndex = data.id
  local m = BeaproGrouping[beaproId][activeMatchIndex]
  currentBeaproData.Index = beaproId
  currentBeaproData.round = activeMatchIndex
  currentBeaproData.homeID = currentBeaproInfo[beaproId].homeID
  currentBeaproData.awayID = m[2]
  currentBeaproData.difficulty = m[6]
  currentMatch.HomeTeamID = currentBeaproData.homeID
  currentMatch.AwayTeamID = currentBeaproData.awayID
  if m[5] == false and m[8] == true then
    self.nav.Event(nil, "evt_opponent")
  end
end

function MatchSelect:ResetTeam()
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
    message = "Are you sure you want to change teams and end this Player Career mission?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function MatchSelect:EndCareer()
  self.nav.Event(nil, "evt_restart")
  self.nav.Event(nil, "evt_hide_popup")
end

function MatchSelect:ExitMenu()
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
      "evt_back",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "If you exit this menu, the player career mission will end and you will have to start from the beginning.",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function MatchSelect:NoMatch()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "LOCKED",
    message = "Can't start this game, you have to play the previous game first",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

return MatchSelect