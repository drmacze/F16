-------------------------------------------
-- MOD BY LAOSIJI --
-------------------------------------------

local Challenge = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
local ACT_RESTART = "act_restart"

challengeId = 2

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

local rivalListData = {}

function Challenge:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService")
  }

  o.currentOptions = o.services.settingsService.GetCurrentOptions()


  o.Init()
  
   o.im.Subscribe(bndMatchList, function()
     o:publishMatchRows()
  end)
   o.im.Subscribe("bnd_match_label", function()
    o:publishMatchLabel()
  end)
  o.im.RegisterAction(ACT_ADVANCE, function(actionName, data)
    if data then
      o:PlayMatch(data)
    end
  end)
  
  o.im.RegisterAction(ACT_RESTART, function(actionName)
    o:EndMatch()
  end)

  

  return o
end

function Challenge:Init()
  local ChallengeGroupingList = ChallengeGrouping[challengeId]
  for i = 1, table.getn(ChallengeGroupingList) do
    local obj = {
      homeID = ChallengeGroupingList[i][1],
      awayID = ChallengeGroupingList[i][2],
      homeScore = ChallengeGroupingList[i][3],
      awayScore = ChallengeGroupingList[i][4],
      
      clickAction = "act_advance",
      isUnlock = ChallengeGroupingList[i][8],
      data = {}
    }
    table.insert(rivalListData, obj)
  end
end


function Challenge:publishMatchRows()
  for i, v in ipairs(rivalListData) do
    v.data.HomeTeamCrest = {
      name = "$Crest",
      id = rivalListData[i].homeID
    }
    v.data.AwayTeamCrest = {
      name = "$Crest",
      id = rivalListData[i].awayID
    }
    v.data.HomeTeamName = self.loc.LocalizeString("TeamName_Abbr15_"..rivalListData[i].homeID)
    v.data.AwayTeamName = self.loc.LocalizeString("TeamName_Abbr15_"..rivalListData[i].awayID)
    v.data.HomeTeamScore = rivalListData[i].homeScore..""
    v.data.AwayTeamScore = rivalListData[i].awayScore..""
    v.data.clickAction = rivalListData[i].clickAction

    v.data.TeamScoreFontColor = "0xFFFFFF"
    v.data.TeamNameFontColor = "0xFFFFFF"
    v.data.FontColor = "0xFFFFFF"
    if not rivalListData[i].isUnlock then
      v.data.Icon = {
        name = "$IconMatchLock",
        id = 1
      }
      v.data.RightText = "Lock"
    else
      v.data.Icon = {
        name = "$IconMatchBall",
        id = 1
      }
      v.data.RightText = "Play"
    end
  end
  self.im.Publish(bndMatchList, rivalListData)
end

function Challenge:publishMatchLabel()
  if currentChallengeInfo[challengeId].isSuccess == 2 then
    self.im.Publish("bnd_match_label", "Congratulations - Successful Challenge")
  elseif currentChallengeInfo[challengeId].isSuccess == 1 then
    self.im.Publish("bnd_match_label", "Unfortunately - Challenge failed")
  else
    self.im.Publish("bnd_match_label", "Season - Challenge")
  end
end


function Challenge:PlayMatch(data)
  local currentMatchIndex = data.id + 1
  currentChallengeData.Index = challengeId
  currentChallengeData.round = currentMatchIndex
  local currentMatchData = ChallengeGrouping[challengeId][currentMatchIndex]

  local index = 0
  if currentMatchData[5] == false and currentMatchData[8] == true then
    index = 1
  elseif currentMatchData[5] == true and currentMatchData[8] == true then
    index = 2
  elseif currentMatchData[5] == true and currentMatchData[7] == false and currentMatchData[8] == true then
    index = 2
  end
  if index == 1 then
    currentChallengeData.homeID = currentChallengeInfo[challengeId].homeID
    currentChallengeData.awayID = currentMatchData[2]
    currentChallengeData.difficulty = currentMatchData[6]
    currentMatch.HomeTeamID = currentChallengeData.homeID
    currentMatch.AwayTeamID = currentChallengeData.awayID
    self.nav.Event(nil, "evt_advance")
  elseif index == 2 then
    currentChallengeData.homeID = currentChallengeInfo[challengeId].homeID
    currentChallengeData.awayID = currentMatchData[2]
    currentChallengeData.difficulty = currentMatchData[6]
    currentMatch.HomeTeamID = currentChallengeData.homeID
    currentMatch.AwayTeamID = currentChallengeData.awayID
    self:ReMatch()
  else
    self:StopMatch()
  end
end

function Challenge:EndMatch()
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
    message = "Do you want to finish the current challenge?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Challenge:ReMatch()
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
    message = "Do you want to challenge again?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Challenge:StopMatch()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "The challenge has not yet been unlocked.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end


function Challenge:finalize()
  self.im.UnregisterAction(ACT_RESTART)
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_match_label")
  rivalListData = {}
  
end

return Challenge
