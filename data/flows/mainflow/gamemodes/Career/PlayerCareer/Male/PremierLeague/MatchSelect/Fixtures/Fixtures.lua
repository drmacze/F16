-- Menu Player Career --
-- Fixtures Remode By Septiawan --

local Fixtures = {}
local BND_LOGO_LEAGUE = "bnd_logo_league"
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
local ACT_RESTART = "act_restart"

beaproId = 1

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

local rivalListData = {}

function Fixtures:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

  o.services = {
    settingsService = o.api("SettingsService")
  }

  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o:Init()
  
  o.leagueLogo = { name = "$LeagueLogo", id = 13 }
  
  o.im.Subscribe(bndMatchList, function()
    o:publishMatchRows()
  end)
  
  o.im.Subscribe(BND_LOGO_LEAGUE, function()
    o.im.Publish(BND_LOGO_LEAGUE, o.leagueLogo)
  end)

  return o
end

function Fixtures:Init()
  local BeaproGroupingList = BeaproGrouping[beaproId]

  for i = 1, table.getn(BeaproGroupingList) do
    local obj = {
      homeID = BeaproGroupingList[i][1],
      awayID = BeaproGroupingList[i][2],
      homeScore = BeaproGroupingList[i][3],
      awayScore = BeaproGroupingList[i][4],
      clickAction = "act_advance",
      isUnlock = BeaproGroupingList[i][8],
      data = {}
    }
    table.insert(rivalListData, obj)
  end
end

function Fixtures:getCurrentMatchIndex()
  for i, v in ipairs(rivalListData) do
    if v.isUnlock
    and (type(v.homeScore) ~= "number"
    or type(v.awayScore) ~= "number") then
      return i
    end
  end
  return 1
end

function Fixtures:publishMatchRows()
  local currentMatchIndex = self:getCurrentMatchIndex()
  for i, v in ipairs(rivalListData) do
    v.data.HomeTeamCrest = { name = "$Crest", id = v.homeID }
    v.data.AwayTeamCrest = { name = "$Crest64x64", id = v.awayID }
    v.data.HomeTeamName =
      self.loc.LocalizeString("TeamName_Abbr15_" .. v.homeID)
    v.data.AwayTeamName =
      self.loc.LocalizeString("TeamName_Abbr15_" .. v.awayID)
    v.data.HomeTeamShortName =
      self.loc.LocalizeString("TeamName_Abbr3_" .. v.homeID)
    v.data.clickAction = v.clickAction
    v.data.TeamScoreFontColor = "0xffffff"
    v.data.TeamNameFontColor  = "0xffffff"
    v.data.FontColor          = "0xffffff"
    v.data.Icon = v.isUnlock
      and { name = "$icon_match_ball_3X", id = 2 }
      or  { name = "$icon_match_lock_3X", id = 1 }

    local matchData = BeaproGrouping[beaproId][i]
    local homeScore = matchData[3]
    local awayScore = matchData[4]
    local isPlayed  = matchData[5]

    v.data.HomeScoreText  = ""
    v.data.AwayScoreText  = ""
    v.data.DashText       = "-"
    v.data.HomeScoreColor = "0xFFFFFF"
    v.data.AwayScoreColor = "0xFFFFFF"
    if not isPlayed then
      v.data.DashText = "VS"
    else
      local hs = tonumber(homeScore) or 0
      local as = tonumber(awayScore) or 0

      v.data.HomeScoreText = tostring(hs)
      v.data.AwayScoreText = tostring(as)

      if hs > as then
        v.data.AwayScoreColor = "0x929294"
      elseif as > hs then
        v.data.HomeScoreColor = "0x929294"
      end
    end

    v.data.Matchday = "Matchday " .. i

    if isPlayed then
      v.data.Matchday = (tonumber(homeScore) or 0) < (tonumber(awayScore) or 0)
        and "Failed"
        or  "Played"
    elseif i == currentMatchIndex then
      v.data.Matchday = "Today"
    end
  end

  self.im.Publish(bndMatchList, rivalListData)
end

function Fixtures:finalize()
  self.im.UnregisterAction(ACT_RESTART)
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_match_label")
  self.im.Unsubscribe("bnd_finish_label")
  self.im.Unsubscribe("bnd_finish_label1")
  rivalListData = {}
end

return Fixtures