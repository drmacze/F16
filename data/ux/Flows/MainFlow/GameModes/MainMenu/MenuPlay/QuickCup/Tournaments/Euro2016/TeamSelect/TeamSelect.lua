local TeamSelect = {}

local bndTeamList = "bnd_team_list"

local ACT_TEAM_SELECT = "act_team_select"

local TeamListData = {}

-- All Teams for Tournament UEFA Euro 2016
local originalTeamList = {
  1318,1335,1337,1369,1343,1353,1354,1362,1367,1325,1365,1363,1413,1370,105035,111466
}

cupId = 1

----------------------------------------------------------------------------------------------------------
-- Function to Shuffle an Array
local function shuffleArray(array)
  local n = #array
  for i = n, 2, -1 do
    local j = math.random(i)
    array[i], array[j] = array[j], array[i]
  end
end

-- Shuffle the TeamList
shuffleArray(originalTeamList)

-- Take The First 16 Teams
TeamList = {}
for i = 1, 16 do
  table.insert(TeamList, originalTeamList[i])
end
-----------------------------------------------------------------------------------------------------------

function TeamSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SquadManagementService = o.api("SquadMgtService")
  }
  o.visible = false
 if currentCupInfo[cupId] and currentCupInfo[cupId].homeID ~= 0 then
    
    o.nav.Event(nil, "evt_team_select")
  else
    o.visible = true
    o:Init()
    o:InitGrouping()
    o.im.Subscribe(bndTeamList, function()
      o:publishTeamRows()
    end)
  
    o.im.RegisterAction(ACT_TEAM_SELECT, function(actionName, data)
     if data then
       o:StartQuickCup(data)
      end
    end)
  end
  
  o.im.Subscribe("bnd_visible", function()
     o:publishVisible()
  end)
  o.im.Subscribe("bnd_loading_visible", function()
     o:publishVisible()
  end)
  
  return o
end

function TeamSelect:publishVisible()
   self.im.Publish("bnd_visible", self.visible)
   self.im.Publish("bnd_loading_visible", not self.visible)
end

-- 初始化数据
function TeamSelect:Init()
  for i = 1, table.getn(TeamList) do
    local teamInfo = self.services.SquadManagementService.GetTeamInfo(TeamList[i])
    local obj = {
      assetId = TeamList[i],
      clickAction = "act_team_select",
      teamName = self.loc.LocalizeString("TeamName_Abbr15_"..TeamList[i]),
      shortTeamName = self.loc.LocalizeString("TeamName_Abbr3_"..TeamList[i]),
      data = {},
      rating = teamInfo.starRating
    }
    table.insert(TeamListData, obj)
  end
end

-- 初始化分组信息
function TeamSelect:InitGrouping()
  currentCupInfo[cupId] = {
    cupIndex = cupId,
    homeID = 0
  }
  local groupingList = {}
  for i = 1, table.getn(TeamList) do
    local temp = i * 2 - 1
    if temp < #TeamList then
      table.insert(groupingList, {
        [1] = TeamList[temp],
        [2] = TeamList[temp+1],
        [3] = "0",
        [4] = "0",
        [5] = false,
        [6] = 0,
        [7] = false
      })
    end
  end
  QuickCupGrouping[cupId] = groupingList
end

function TeamSelect:publishTeamRows()
  for i, v in ipairs(TeamListData) do
    v.data.TeamCrest = {
      name = "$Crest",
      id = TeamListData[i].assetId
    }
    v.data.TeamName = TeamListData[i].teamName
    v.data.Rating = TeamListData[i].rating
    v.data.clickAction = TeamListData[i].clickAction
    v.data.FontColor = "0xffffff"
    v.data.TeamNameFontColor = "0xffffff"
    v.data.Icon = {
       name = "$IconMatchBall",
       id = 1
    }
  end
  self.im.Publish(bndTeamList, TeamListData)
end

function TeamSelect:StartQuickCup(data)
  local currentTeamIndex = data.id + 1
  currentCupInfo[cupId].homeID = TeamListData[currentTeamIndex].assetId
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
      "evt_team_select",
      "evt_hide_popup"
    }
  }
  local popupData = {
    message = " ARE YOU SURE TO SELECT "..TeamListData[currentTeamIndex].teamName.." ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function TeamSelect:finalize()
  self.im.Unsubscribe("bnd_visible")
  self.im.Unsubscribe("bnd_loading_visible")
  self.im.Unsubscribe(bndTeamList)
  self.im.UnregisterAction(ACT_TEAM_SELECT)
end

return TeamSelect