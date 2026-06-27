-- Menu Player Career --
-- TeamSelect Remode By Septiawan --

local TeamSelect = {}
local NUM_TABS = 20
local BND_TEAM_LIST = "bnd_team_list"
local BND_TEAM_RATING = "bnd_team_rating"
local ACT_TEAM_SELECT = "act_team_select"
local ACT_SELECTED = "act_selected"
local ACT_RANDOM = "act_random"

beaproId = 1
local currentTab = 1
local TeamListData = {}
for i = 1, NUM_TABS do
  _G["TAB" .. i] = i
  _G["BND_TAB" .. i .. "_VISIBLE"] = "bnd_tab" .. i .. "_visible"
end

TeamList = {
  1,2,1943,1925,1808,1796,5,1799,7,144,8,9,10,11,13,14,18,106,19,110
}

local TEAM_FLAG_ID = {
  [1]=14,[2]=14,[5]=14,[7]=14,[8]=14,[9]=14,[10]=14,[11]=14,[13]=14,[14]=14,
  [1799]=14,[18]=14,[19]=14,[106]=14,[110]=14,[144]=14,[1796]=14,[1808]=14,[1925]=14,[1943]=14
}

local function shuffleArray(array)
  math.randomseed(os.time())
  for i = #array, 2, -1 do
    local j = math.random(i)
    array[i], array[j] = array[j], array[i]
  end
end

rivalTeamList = {}
for _, id in ipairs(TeamList) do
  table.insert(rivalTeamList, id)
end
shuffleArray(rivalTeamList)

function TeamSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

  o.services = {
    SquadManagementService = o.api("SquadMgtService")
  }

  o.visible = true
  o.tabTeams = {}
  for i = 1, NUM_TABS do
    o.tabTeams[i] = { TeamList[i] }
  end
  o.teamObjects = {}
  for i = 1, NUM_TABS do
    o.teamObjects[i] = {
      name = "$Crest",
      id = TeamList[i]
    }
  end

  o.im.Subscribe("bnd_visible", function()
    o.im.Publish("bnd_visible", o.visible)
    o.im.Publish("bnd_loading_visible", not o.visible)
  end)

  local firstInit = true
  for i = 1, NUM_TABS do
    local tabKey = "bnd_tab"..i.."_visible"
    o.im.Subscribe(tabKey, function(value)
      if firstInit then return end
      if value then
        for j = 1, NUM_TABS do
          if j ~= i then
            o.im.Publish("bnd_tab"..j.."_visible", false)
          end
        end
        currentTab = i
      end
      o.im.Publish(tabKey, value)
    end)
  end

  o.im.Subscribe(BND_TEAM_LIST, function()
    o:publishTeamRows()
  end)

  o.im.Subscribe(BND_TEAM_RATING, function()
      o:publishTeamRating()
  end)

  o.im.RegisterAction(ACT_SELECTED, function(_, data)
    o:HideSelections()
    currentTab = data.buttonID + 1
    o.im.Publish("bnd_tab"..currentTab.."_visible", true)
    o:Init(currentTab)
    o:publishTeamRows()
    o:publishTeamRating()
  end)

  o.im.RegisterAction(ACT_TEAM_SELECT, function(_, data)
    if data then
      o:StartBeapro(data)
      o:publishTeamRating()
    end
  end)

  o.im.RegisterAction(ACT_RANDOM, function()
    local shuffled = {}
    for i, v in ipairs(TeamList) do
        table.insert(shuffled, v)
    end
    shuffleArray(shuffled)
    for i = 1, NUM_TABS do
        o.tabTeams[i] = { shuffled[i] }
        o.teamObjects[i].id = shuffled[i]
    end

    local randomTabIndex = math.random(1, NUM_TABS)
    currentTab = randomTabIndex
    o:HideSelections()
    o.im.Publish("bnd_tab"..randomTabIndex.."_visible", true)
    o:Init(randomTabIndex)
    o:publishTeamRows()
    o:publishTeamRating()

    for i = 1, NUM_TABS do
        local key = "bnd_team"..i
        o.im.Publish(key, o.teamObjects[i])
    end
end)

  for i = 1, NUM_TABS do
    local key = "bnd_team"..i
    o.im.Subscribe(key, function()
      o.im.Publish(key, o.teamObjects[i])
    end)
  end

currentTab = 1

for i = 1, NUM_TABS do
    o.im.Publish("bnd_tab"..i.."_visible", false)
end

o.im.Publish("bnd_tab1_visible", true)
o:Init(1)
o:publishTeamRows()
o:publishTeamRating()

  return o
end

function TeamSelect:Init(tabID)
  TeamListData = {}
  local teamId = self.tabTeams[tabID][1]
  local teamInfo = self.services.SquadManagementService.GetTeamInfo(teamId)
  local obj = {
    assetId = teamId,
    clickAction = ACT_TEAM_SELECT,
    teamName = self.loc.LocalizeString("TeamName_Abbr15_"..teamId),
    shortTeamName = self.loc.LocalizeString("TeamName_Abbr3_"..teamId),
    rating = teamInfo.starRating,
    offense = teamInfo.offense,
    midfield = teamInfo.midfield,
    defense = teamInfo.defense,
    data = {},
    flagId = TEAM_FLAG_ID[teamId] or 0
  }

  table.insert(TeamListData, obj)
end

function TeamSelect:publishTeamRows()
  for i, v in ipairs(TeamListData) do
    v.data.TeamCrest = {
      name = "$Crest",
      id = v.assetId
    }
    v.data.flagCrest = {
      name = "$Flag128x128",
      id = v.flagId
    }
    v.data.TeamName = v.teamName
    v.data.Rating = v.rating 
    v.data.clickAction = v.clickAction
    v.data.FontColor = "0xFFFFFF"
    v.data.TeamNameFontColor = "0xFFFFFF"
    v.data.Icon = {
      name = "$IconMatchBall",
      id = 2
    }
    v.data.RightText = "PLAY"
  end

  self.im.Publish(BND_TEAM_LIST, TeamListData)
end

function TeamSelect:getFlagIdByTeamId(teamId)
  return TEAM_FLAG_ID[teamId] or 0
end

function TeamSelect:publishTeamRating()
  local displayIndex = self.selectedTeamIndex or 1
  if not TeamListData or not TeamListData[displayIndex] then
    self.im.Publish(BND_TEAM_RATING, self:createEmptyRating())
    return
  end
  local teamData = TeamListData[displayIndex]
  local teamRating = {
    attackValue = math.floor(teamData.offense or 0),
    middleValue = math.floor(teamData.midfield or 0),
    defenseValue = math.floor(teamData.defense or 0),
    attackLabel = self.loc.LocalizeString("LTXT_CMN_ATT"),
    middleLabel = self.loc.LocalizeString("LTXT_CMN_MID"),
    defenseLabel = self.loc.LocalizeString("LTXT_CMN_DEF"),
    overallRating = string.format("%.1f", teamData.rating or 0),
    teamName = teamData.teamName or ""
  }

  self.im.Publish(BND_TEAM_RATING, teamRating)
end

function TeamSelect:createEmptyRating()
    return {
        attackValue = 0,
        middleValue = 0,
        defenseValue = 0,
        attackLabel = self.loc.LocalizeString("LTXT_CMN_ATT"),
        middleLabel = self.loc.LocalizeString("LTXT_CMN_MID"),
        defenseLabel = self.loc.LocalizeString("LTXT_CMN_DEF"),
        overallRating = "0.0",
        teamName = ""
    }
end

function TeamSelect:InitGrouping(teamId)
  currentBeaproInfo[beaproId] = {
    Index = beaproId,
    homeID = teamId,
    difficulty = 1,
    isSuccess = 0
  }

  local groupingList = {}
  local used = {}

  for i, rivalId in ipairs(rivalTeamList) do
    if rivalId ~= teamId and not used[rivalId] then
      table.insert(groupingList, {
        [1] = teamId,
        [2] = rivalId,
        [3] = "0",
        [4] = "0",
        [5] = false,
        [6] = math.min(i, 8),
        [7] = false,
        [8] = i == 1,
        ["data"] = {}
      })
      used[rivalId] = true
    end
  end

  BeaproGrouping[beaproId] = groupingList
end

function TeamSelect:StartBeapro(data)
  local teamId = TeamListData[data.id + 1].assetId
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = { "evt_hide_popup" }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Confirm",
    clickEvents = { "evt_hide_popup" }
  }
  function buttonYes.clickCallback()
    self:InitGrouping(teamId)
    self.nav.Event(nil, "evt_team_select")
  end
  self.nav.Event(nil, "evt_show_popup", {
    title = "INFO",
    message = "You choose the "..TeamListData[1].teamName.." team to start the Player Career mission?",
    buttons = { buttonNo, buttonYes }
  })
end

function TeamSelect:HideSelections()
  for i = 1, NUM_TABS do
    self.im.Publish("bnd_tab"..i.."_visible", false)
  end
end

function TeamSelect:finalize()
  self.im.Unsubscribe(bndTeamList)
  self.im.UnregisterAction(ACT_TEAM_SELECT)
  self.im.UnregisterAction(ACT_SELECTED)
end

return TeamSelect