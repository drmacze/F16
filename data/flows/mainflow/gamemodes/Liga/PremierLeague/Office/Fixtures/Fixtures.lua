-- Mod By MVN PROD --
-- League Mode Division --

local Liga = {}
local bndLeagueBg = "bnd_league_bg"
local bndLeagueLogo = "bnd_league_logo"
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"

ligaId = 1
if not round then
  round = 1
else 
  round = round
end

if not selectedteam then
  selectedteam = 1
else 
  selectedteam = selectedteam
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

function Liga:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
  }

  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o.Init()
  
  o.im.Subscribe(bndLeagueBg, function()  
    o.im.Publish(bndLeagueBg, {name = "$_LeagueBg", id = currentSelectedTeamID})   
  end)
  
  o.im.Subscribe(bndLeagueLogo, function()  
    o.im.Publish(bndLeagueLogo, {name = "$_LeagueLogo", id = currentSelectedTeamID})   
  end)
  
  o.im.Subscribe(bndMatchList, function()
     o:publishMatchRows()
  end)
  
  o.im.Subscribe("bnd_match_label", function()
    o:publishMatchLabel()
  end)
  
  o.im.Subscribe("bnd_point_label", function()
    o:publishMatchLabel()
  end)
  
  o.im.Subscribe("bnd_finish_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_team_label", function()
    o:publishLabel()
  end)
  
  o.im.Subscribe("bnd_matchup_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_matchday_label", function()
    o:publishLabel()
  end)
  
  o.im.Subscribe("bnd_league_label", function()
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

  return o
end

------------------------------------------------------------------------------------------

function Liga:Init()
  local LigaGroupingList = LigaGrouping[ligaId]
  for i = 1, table.getn(LigaGroupingList) do
    local obj = {
      homeID = LigaGroupingList[i][1],
      awayID = LigaGroupingList[i][2],
      homeScore = LigaGroupingList[i][4],
      awayScore = LigaGroupingList[i][5],
      data = {}
    }
    table.insert(rivalListData, obj)
  end
end

------------------------------------------------------------------------------------------
function Liga:publishLabel()
  self.im.Publish("bnd_matchday_label", "Matchday " .. round)
  if selectedteam == 0 then
    self.im.Publish("bnd_team_label", "By matchday ")
  else
    self.im.Publish("bnd_team_label", self.loc.LocalizeString("TeamName_Abbr15_" .. TeamList[selectedteam]))
  end
end

function Liga:publishMatchRows()
  local filteredRivalListData = {}
  local matchCount = (#TeamList / 2)

  -- Loop through all matches in rivalListData
  for i, v in ipairs(rivalListData) do
    local shouldIncludeMatch = false

    if selectedteam == 0 then
      shouldIncludeMatch = i >= ((round * matchCount) - (matchCount - 1)) and i <= (round * matchCount)
    else
      shouldIncludeMatch = (rivalListData[i].homeID == TeamList[selectedteam] or rivalListData[i].awayID == TeamList[selectedteam])
    end

    if shouldIncludeMatch then
      -- Populate match data
      v.data.TeamHomeCrest = {
        name = "$Crest64x64",
        id = rivalListData[i].homeID
      }
      v.data.TeamAwayCrest = {
        name = "$Crest64x64",
        id = rivalListData[i].awayID
      }
      v.data.TeamHomeName = self.loc.LocalizeString("TeamName_Abbr15_" .. rivalListData[i].homeID)
      v.data.TeamAwayName = self.loc.LocalizeString("TeamName_Abbr15_" .. rivalListData[i].awayID)

      -- Determine how many rows should show scores based on GLOBAL_MATCHUP_COUNT
      local maxRowsWithScores = GLOBAL_MATCHUP_COUNT * 10

      if i <= maxRowsWithScores then
        rivalListData[i].data.MatchScore = rivalListData[i].homeScore .. "        -        " .. rivalListData[i].awayScore
      else
        rivalListData[i].data.MatchScore = "VS"
      end

      v.data.TeamScoreFontColor = "0xffffff"
      v.data.TeamNameFontColor = "0x4A2C6D"
      v.data.FontColor = "0x4A2C6D"

      -- Set icon and right text based on match status
      if not rivalListData[i].isUnlock then
        v.data.Icon = { name = "$", id = 1 }
        v.data.RightText = ""
      else
        v.data.Icon = { name = "$", id = 2 }
        v.data.RightText = ""
      end

      -- Add the match to the filtered list
      table.insert(filteredRivalListData, v)
    end
  end
  
  -- Publish only the filtered matches
  self.im.Publish(bndMatchList, filteredRivalListData)
end

function Liga:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_matchday_label")
  self.im.Unsubscribe("bnd_point_label")
  self.im.Unsubscribe("bnd_team_label")
  self.im.Unsubscribe("bnd_matchup_label")
  self.im.Unsubscribe("bnd_matchdate_label")
  self.im.Unsubscribe("bnd_league_label")
  self.im.Unsubscribe("bnd_advance_label")
  self.im.Unsubscribe("bnd_month_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
end

return Liga

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --