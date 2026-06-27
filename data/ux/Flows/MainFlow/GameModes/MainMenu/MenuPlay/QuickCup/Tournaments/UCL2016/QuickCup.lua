local QuickCup = {}

local ACT_ADVANCE = "act_advance"
local ACT_RESTART = "act_restart"

local maxMatchSize = 15

local bndList = {}

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

function QuickCup:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService")
  }

  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  
  for i = 1, 30 do
    bndList[i] = "bnd_team"..i.."_score"
    bndList[i+30] = "bnd_team"..i.."_crest"
  end
  
  o.cupData = {
    championCrest = {
      name = "$Crest",
      id = 0
    },
    homeTeamCrest = {
      name = "$Crest",
      id = currentCupInfo[cupId].homeID
    },
    awayTeamCrest = {
      name = "$Crest",
      id = 0
    },
    isFinish = false,
    Round = ""
  }

  o.im.Subscribe("bnd_match_visible", function()
    o:publishMatchInfo()
  end)

  o.im.Subscribe("bnd_home_crest", function()
    o:publishMatchInfo()
  end)

  o.im.Subscribe("bnd_away_crest", function()
    o:publishMatchInfo()
  end)

  o.im.Subscribe("bnd_home_team", function()
    o:publishMatchInfo()
  end)

  o.im.Subscribe("bnd_away_team", function()
    o:publishMatchInfo()
  end)

  o.im.Subscribe("bnd_text", function()
    o.im.Publish("bnd_text", "")
  end)

  o.im.Subscribe("bnd_champion_visible", function()
    o:publishChampion()
  end)

  o.im.Subscribe("bnd_champion_crest", function()
    o:publishChampion()
  end)
  o.im.Subscribe("bnd_champion_team", function()
    o:publishChampion()
  end)
  
  for k,v in pairs(bndList) do
    o.im.Subscribe(v, function()
      o:InitOptions()
      
    end)
  end

  o.im.RegisterAction(ACT_ADVANCE, function(actionName)
    o:PlayMatch()
  end)
  
  o.im.RegisterAction(ACT_RESTART, function(actionName)
    o:PlayReStart()
  end)

  return o
end

function QuickCup:InitOptions()
    -- 初始化分组配置
    local currentCupGrouping = QuickCupGrouping[cupId]
    for k = 1, table.getn(currentCupGrouping) do
        local index = k * 2 - 1
        local bindingKey = "bnd_team"
        bindingKey = bindingKey..index
        self.im.Publish(bindingKey.."_crest", {
          name = "$Crest",
          id = currentCupGrouping[k][1]
        })
        self.im.Publish(bindingKey.."_score", currentCupGrouping[k][3])
        bindingKey = "bnd_team"
        local i = index + 1
        bindingKey = bindingKey..i
        self.im.Publish(bindingKey.."_crest", {
          name = "$Crest",
          id = currentCupGrouping[k][2]
        })
        self.im.Publish(bindingKey.."_score", currentCupGrouping[k][4])
    end     
    if currentCupGrouping[maxMatchSize][5] then
      if currentCupGrouping[maxMatchSize][6] == currentCupInfo[cupId].homeID then 
        -- 恭喜夺冠
        self.cupData.championCrest.id = currentCupInfo[cupId].homeID      
      else
        -- 遗憾失利
        self.cupData.championCrest.id = currentCupGrouping[maxMatchSize][6]
      end
      self.cupData.isFinish = true
      self:publishChampion()
    end
end

function QuickCup:publishChampion()
  self.im.Publish("bnd_champion_visible", self.cupData.isFinish)
  self.im.Publish("bnd_match_visible", not self.cupData.isFinish)
  if self.cupData.championCrest.id ~= 0 and self.cupData.isFinish == true then
    self.im.Publish("bnd_text", "CHAMPIONS")
    self.im.Publish("bnd_champion_crest", self.cupData.championCrest)
    self.im.Publish("bnd_champion_team", self.loc.LocalizeString("TeamName_Abbr15_"..self.cupData.championCrest.id))
  end
end

function QuickCup:publishMatchInfo()
  if self.cupData.championCrest.id == 0 and self.cupData.isFinish == false then
    self.im.Publish("bnd_match_visible", not self.cupData.isFinish)
    self.im.Publish("bnd_text", self.cupData.Round)
    self.im.Publish("bnd_home_crest", self.cupData.homeTeamCrest)
    self.cupData.awayTeamCrest.id = self:GetMatchAwayTeamId()
    self.im.Publish("bnd_home_team", self.loc.LocalizeString("TeamName_Abbr15_"..self.cupData.homeTeamCrest.id))
    self.im.Publish("bnd_away_crest", self.cupData.awayTeamCrest)
    self.im.Publish("bnd_away_team", self.loc.LocalizeString("TeamName_Abbr15_"..self.cupData.awayTeamCrest.id))
  end
end

function QuickCup:GetMatchAwayTeamId()
  local currentCupGrouping = QuickCupGrouping[cupId]
  local index = 0
  for i = 1, table.getn(currentCupGrouping) do
    if currentCupGrouping[i][5] == false then
      if currentCupGrouping[i][1] == currentCupInfo[cupId].homeID then
        index = currentCupGrouping[i][2]
        self.cupData.Round = self:GetMatchRound(i)
      elseif currentCupGrouping[i][2] == currentCupInfo[cupId].homeID then
        index = currentCupGrouping[i][1]
        self.cupData.Round = self:GetMatchRound(i)
      end
    end
  end
  return index
end

function QuickCup:GetMatchRound(index)
  if index > 0 and index <= 8 then
    return "ROUND OF 16"
  elseif index > 8 and index <= 12 then
    return "QUARTER FINAL"
  elseif index > 12 and index <= 14 then
    return "SEMI FINAL"
  else
    return "FINAL"
  end
end

function QuickCup:PlayMatch()
  currentCupData.maxMatchSize = maxMatchSize
  local currentCupGrouping = QuickCupGrouping[cupId]
  local index = 0
  for i = 1, table.getn(currentCupGrouping) do
    if currentCupGrouping[i][5] == false then
      if currentCupGrouping[i][1] == currentCupInfo[cupId].homeID then
        index = i
        currentCupData.homeID = currentCupInfo[cupId].homeID
        currentCupData.cupIndex = cupId
        currentCupData.awayID = currentCupGrouping[i][2]
      elseif currentCupGrouping[i][2] == currentCupInfo[cupId].homeID then
        index = i
        currentCupData.homeID = currentCupInfo[cupId].homeID
        currentCupData.cupIndex = cupId
        currentCupData.awayID = currentCupGrouping[i][1]
      end
    end
  end
  currentMatch.HomeTeamID = currentCupData.homeID
  currentMatch.AwayTeamID = currentCupData.awayID
  if index > 0 then
    self.nav.Event(nil, "evt_advance")
  else
    self:StopMatch()
  end
end

function QuickCup:PlayReStart()
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
      "evt_restart",
      "evt_hide_popup"
    }
  }
  local popupData = {
    message = " DO YOU WANT TO END THE CURRENT TOURNAMENT ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function QuickCup:StopMatch()
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
       "evt_restart",
      "evt_hide_popup"
    }
  }
  local popupData = {
    message = " THE TOURNAMENT HAS ENDED :) *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function QuickCup:finalize()
  self.im.UnregisterAction(ACT_RESTART)
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_champion_crest")
  self.im.Unsubscribe("bnd_text")
  self.im.Unsubscribe("bnd_trophy")
  self.im.Unsubscribe("bnd_cup_map")
  self.im.Unsubscribe("bnd_champion_visible")
  self.im.Unsubscribe("bnd_match_visible")
  self.im.Unsubscribe("bnd_champion_team")
  self.im.Unsubscribe("bnd_home_crest")
  self.im.Unsubscribe("bnd_away_crest")
  self.im.Unsubscribe("bnd_home_team")
  self.im.Unsubscribe("bnd_away_team")
  for k,v in pairs(bndList) do
    self.im.Unsubscribe(v)
  end
end

return QuickCup