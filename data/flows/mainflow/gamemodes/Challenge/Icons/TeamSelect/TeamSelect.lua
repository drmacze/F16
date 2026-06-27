-------------------------------------------
-- MOD By LAOSIJI --
-------------------------------------------

local TeamSelect = {}

local bndTeamList = "bnd_team_list"

local ACT_TEAM_SELECT = "act_team_select"

local TeamListData = {}

local challengeId = 1
TeamList = {
  10, 241, 21, 48, 73
}

rivalTeamList = {
  128322, 127925, 111072, 111205
}

function TeamSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SquadManagementService = o.api("SquadMgtService")
  }
   o.visible = false
   o.im.Subscribe("bnd_visible", function()
     o:publishVisible()
  end)
  o.im.Subscribe("bnd_loading_visible", function()
     o:publishVisible()
  end)
  if currentChallengeInfo[challengeId] and currentChallengeInfo[challengeId].homeID ~= 0 then
   
   o.nav.Event(nil, "evt_team_select")
  else
    o.visible = true
    o:publishVisible()
    o:Init()
    --o:InitGrouping()
    o.im.Subscribe(bndTeamList, function()
      o:publishTeamRows()
    end)
    o.im.RegisterAction(ACT_TEAM_SELECT, function(actionName, data)
     if data then
       o:StartChallenge(data)
      end
    end)
  end
  
  
  
  
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

-- 初始化对战信息
function TeamSelect:InitGrouping(teamId)
  currentChallengeInfo[challengeId] = {
    Index = challengeId,
    homeID = teamId,
    difficulty = 1,
    isSuccess = 0
  }
  local groupingList = {}
  for i = 1, table.getn(rivalTeamList) do
     local difficulty = i > 4 and 4 or i
     local isUnlock = i == 1 and true or false
   
    table.insert(groupingList, {
      [1] = teamId,
      [2] = rivalTeamList[i],
      [3] = "0", -- homescroe
      [4] = "0", -- awayscore
      [5] = false, -- 是否比完
      [6] = difficulty, --比赛难度
      [7] = false, -- 是否获胜
      [8] = isUnlock, --是否解锁
      ["data"] = {}
    })
  end
  ChallengeGrouping[challengeId] = groupingList
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
       id = 2
    }
    v.data.RightText = "Play"
  end
  self.im.Publish(bndTeamList, TeamListData)
end

function TeamSelect:StartChallenge(data)
  local currentTeamIndex = data.id + 1
  --currentCupInfo[cupId].homeID = TeamListData[currentTeamIndex].assetId
  
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
      "evt_hide_popup"
    }
  }
  
  function buttonYes.clickCallback()
    self:InitGrouping(TeamListData[currentTeamIndex].assetId)
    self.nav.Event(nil, "evt_team_select")
  end
  
  local popupData = {
    title = "INFO",
    message = "Do you want to choose the "..TeamListData[currentTeamIndex].teamName.." to start the challenge?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end


function TeamSelect:finalize()
  self.im.Unsubscribe("bnd_visible")
  self.im.Unsubscribe("bnd_loading_visible")
  self.im.Unsubscribe(bndTeamList)
  self.im.UnregisterAction(ACT_TEAM_SELECT)
  TeamListData = {}
end

return TeamSelect
