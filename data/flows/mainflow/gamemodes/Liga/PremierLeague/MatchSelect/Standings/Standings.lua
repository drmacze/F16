-- Mod By MVN PROD --
-- League Mode Devision --

local Standings = {}
local bndMatchList = "bnd_match_list"
local bndLeagueBg = "bnd_league_bg"
local bndLeagueLogo = "bnd_league_logo"
local ACT_ADVANCE = "act_advance"

ligaId = 1

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 1,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}
-- Dev1
local rivalListData = {}

function Standings:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService")
}

  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o.Init()
  
  o.im.Subscribe(bndMatchList, function()
     o:publishMatchRows2()
  end)
  
  o.im.Subscribe(bndLeagueBg, function()  
    o.im.Publish(bndLeagueBg, {name = "$_LeagueBg", id = currentSelectedTeamID})   
  end)
  
  o.im.Subscribe(bndLeagueLogo, function()  
    o.im.Publish(bndLeagueLogo, {name = "$_LeagueLogo", id = currentSelectedTeamID})   
  end)
  
   o.im.Subscribe("bnd_match_label", function()
    o:publishMatchLabel()
  end)
  o.im.Subscribe("bnd_finish_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.RegisterAction(ACT_ADVANCE, function(actionName, data)
    if data then
      o:PlayMatch2(data)
    end
  end)
  
  return o
end
------------------------------------------------------------------------------------------

function Standings:Init()
  local LigaGroupingList = LigaGrouping[ligaId]
  for i = 1, table.getn(LigaGroupingList) do
    local obj2 = {
      homeID = LigaGroupingList[i][1],
      awayID = LigaGroupingList[i][3],
      homeScore = LigaGroupingList[i][4],
      awayScore = LigaGroupingList[i][5],
      
      clickAction = "act_advance",
      isUnlock = LigaGroupingList[i][9],
      data = {}
    }
    table.insert(rivalListData, obj2)
  end
end

------------------------------------------------------------------------------------------

function Standings:publishMatchRows2()
  local teamDataList = {}

  -- Loop through all teams in TeamList
  for _, teamID in ipairs(TeamList) do
    local teamData = {}
    teamData.TeamCrest = {
      name = "$Crest64x64",
      id = teamID
    }
    teamData.TeamName = self.loc.LocalizeString("TeamName_Abbr15_" .. teamID)
    teamData.TeamWin = tostring(GetTeamWins(teamID))
    teamData.TeamDraw = tostring(GetTeamDraws(teamID))
    teamData.TeamPoint = tonumber(GetTeamPoints(teamID)) -- Convert to number for sorting
    teamData.TeamLoss = tostring(GetTeamLosses(teamID))
    teamData.TeamGA = tonumber(GetTeamGoalsScored(teamID)) -- Convert for calculations
    teamData.TeamGC = tonumber(GetTeamGoalsConceded(teamID)) -- Convert for calculations
    teamData.TeamGD = teamData.TeamGA - teamData.TeamGC -- Calculate Goal Difference
    teamData.Teammp = GLOBAL_MATCHUP_COUNT
    teamData.clickAction = "ViewTeamDetails_" .. teamID

    -- Set default font and icon properties
    teamData.TeamScoreFontColor = "0xffffff"
    teamData.TeamNameFontColor = "0xffffff"
    teamData.FontColor = "0xffffff"
    teamData.Icon = {
      name = "$IconTeam",
      id = teamID
    }
    teamData.RightText = ""

    -- Add team data to the list
    table.insert(teamDataList, {data = teamData})
  end

  -- Sort the team list
  table.sort(teamDataList, function(a, b)
    -- Primary sort: Points (descending)
    if a.data.TeamPoint ~= b.data.TeamPoint then
      return a.data.TeamPoint > b.data.TeamPoint
    end

    -- Secondary sort: Goal Difference (descending)
    if a.data.TeamGD ~= b.data.TeamGD then
      return a.data.TeamGD > b.data.TeamGD
    end

    -- Tertiary sort: Alphabetical order by TeamName (ascending)
    return a.data.TeamName < b.data.TeamName
  end)

  -- Special case: If all points are 0, sort alphabetically
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

  -- Assign Teampos based on sorted order
  for i, team in ipairs(teamDataList) do
    team.data.Teampos = tostring(i) .. "."
  end

  -- Publish the sorted team list
  self.im.Publish(bndMatchList, teamDataList)
end

------------------------------------------------------------------------------------------

function Standings:publishMatchLabel()
  
  if League == 13 then
    self.im.Publish("bnd_match_label", "Epl")
  elseif League == 14 then
    self.im.Publish("bnd_match_label", "La liga")
  elseif League == 60 then
    self.im.Publish("bnd_match_label", "Serie A")
  elseif League == 2216 then
    self.im.Publish("bnd_match_label", "Bundesliga")
  else
    self.im.Publish("bnd_match_label", "")
  end
end



------------------------------------------------------------------------------------------

function Standings:PlayMatch2(data)
  local currentMatchIndex = data.id + 1
  currentLigaData.Index = ligaId
  currentLigaData.round = currentMatchIndex
  local currentMatchData = LigaGrouping[ligaId][currentMatchIndex]
  
  local index = 0
  if currentMatchData[6] == false and currentMatchData[9] == true then
    index = 1
  elseif currentMatchData[6] == true and currentMatchData[9] == true then
    index = 2
  elseif currentMatchData[6] == true and currentMatchData[8] == false and currentMatchData[9] == true then
    index = 2
  end
  if index == 1 then
    currentLigaData.homeID = currentLigaInfo[ligaId].homeID
    currentLigaData.awayID = currentMatchData[3]
    currentLigaData.difficulty = currentMatchData[7]
    currentMatch.HomeTeamID = currentLigaData.homeID
    currentMatch.AwayTeamID = currentLigaData.awayID
    self:Reload()
  elseif index == 2 then
    currentLigaData.homeID = currentLigaInfo[ligaId].homeID
    currentLigaData.awayID = currentMatchData[3]
    currentLigaData.difficulty = currentMatchData[7]
    currentMatch.HomeTeamID = currentLigaData.homeID
    currentMatch.AwayTeamID = currentLigaData.awayID
    self:KickOff()
  else
    self:StopMatch()
  end
end

------------------------------------------------------------------------------------------
function Standings:KickOff()
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
    message = "Are you ready to play this match?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Standings:Reload()
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Confirm",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "It will be unlocked after you complete The Division 2",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Standings:StopMatch()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "NEXT MATCH",
    message = "It will be unlocked after you complete The Division 2",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

------------------------------------------------------------------------------------------

function Standings:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_match_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
  
end

return Standings

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --
