-- Mod By MVN PROD --
-- League Mode Devision --

local Standings = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"

ligaId = 1

--  FULL FIXED LEAGUE LABEL SCRIPT --

local LeagueIDs = {
  {ids={1,2,1943,5,1799,7,95,9,10,11,13,1792,17,1806,106,1960,18,1795,109,19},compID=13}, -- Barclays PL
  {ids={448,240,450,241,1860,110832,1853,573,480,452,242,449,243,457,467,481,459,472,483,483},compID=53}, -- Liga BBVA
  {ids={47,52,39,189,112409,192,1746,110374,111657,110556,206,44,45,48,46,1843,1837,111974,54,55},compID=31}, -- Serie A TIM
  {ids={10029,31,169,21,32,22,23,1824,100409,111239,34,110596,28,485,166,112172,110502,36,175,38},compID=19}, -- Bundesliga
  {ids={1530,69,1819,62,294,217,71,110316,59,65,70,72,66,219,73,58,210,379,74,1809},compID=16}, -- Ligue 1
}

local LeagueMap = {}
for _,v in ipairs(LeagueIDs) do
  for _,id in ipairs(v.ids) do
    LeagueMap[id] = v.compID
  end
end
LeagueMap[-1] = 0

local LeagueNames = {
  [13] = "BARCLAYS PL",
  [53] = "LIGA BBVA",
  [31] = "SERIE A TIM",
  [19] = "BUNDESLIGA",
  [16] = "LIGUE 1"
}

local function getLeague(teamID, name)
  return { name = name, id = LeagueMap[teamID] or 0 }
end

if not round then round = 1 end
if not selectedteam then selectedteam = 0 end

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
  

  --  Tambahan label liga
  o.im.Subscribe("bnd_league_label", function()
    o:publishLeagueLabel()
  end)



  
  o.im.Subscribe(bndMatchList, function()
     o:publishMatchRows2()
  end)
  
   o.im.Subscribe("bnd_match_label", function()
    o:publishMatchLabel()
  end)
  o.im.Subscribe("bnd_team_crest", function()
    o.im.Publish("bnd_team_crest", { name = "$Crest", id = currentSelectedTeamID or 0 })
  end)  
  o.im.Subscribe("bnd_team_name", function()
    o.im.Publish("bnd_team_name", o.loc.LocalizeString("TeamName_Abbr15_"..currentSelectedTeamID))
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


function Standings:publishLeagueLabel()
  local teamID = currentSelectedTeamID or selectedteam or 0
  local leagueID = LeagueMap[teamID] or 0
  local leagueName = LeagueNames[leagueID]

  --  Default fallback
  if not leagueName or leagueName == "" then
    leagueName = "EA SPORTS"
  end
  
  self.im.Publish("bnd_league_label", leagueName)
end


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
    message = "Do You Want To Play Match ?",
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
    message = "Will Unlock After You Complete Division 2",
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
    title = "Next Match",
    message = "Will Unlock After You Complete Division 2",
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
