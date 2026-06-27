local QuickCup = {}

local ACT_ADVANCE = "act_advance"
local ACT_RESTART = "act_restart"
local BND_REALTIME = "bnd_realtime"

local maxMatchSize = 15
cupId = 5

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
  bndList[i + 30] = "bnd_team"..i.."_crest"
  bndList[i + 60] = "bnd_team"..i.."_abbr" -- Adiciona o binding para o nome do time
end
  
  o.cupData = {
    cupBg = { 
      name = "$CupBg",
      id = cupId
    },
    cupLogo = {
      name = "$CupLogo",
      id = cupId
    },
    cupMap = {
      name = "$CupMap",
      id = cupId
    },
    trophy = {
      name = "$_Trophies",
      id = cupId
    },
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
  
  o.im.Subscribe("bnd_cup_bg", function()
  o.im.Publish("bnd_cup_bg", o.cupData.cupBg)
  end)
  o.im.Subscribe("bnd_cup_logo", function()
  o.im.Publish("bnd_cup_logo", o.cupData.cupLogo)
  end)
  o.im.Subscribe("bnd_cup_map", function()
    o.im.Publish("bnd_cup_map", o.cupData.cupMap)
  end)
  o.im.Subscribe("bnd_trophy", function()
    o.im.Publish("bnd_trophy", o.cupData.trophy)
  end)
  
  o.Banner= {
    name = "$_Ads_Insta",
    id = 0
  }
  math.randomseed(os.clock() * 1352 + os.time())
  local currentTime = os.date("%H") + 0
  local random2 = math.random(4)
  o.im.Subscribe("bnd_ads", function()
    o.Banner.id = random2
    o.im.Publish("bnd_ads", o.Banner)
  end)
  o.im.Subscribe(BND_REALTIME, function()
    local currentTime = os.date("%d %h %Y %H:%M")
    local state = currentTime
    o.im.Publish(BND_REALTIME, state)
  end)
  
  for k,v in pairs(bndList) do
    o.im.Subscribe(v, function()
      o:InitOptions()
    end)
  end

  o.im.Subscribe("bnd_match_visible", function()
    o:publishMatchInfo()
  end)
  o.im.Subscribe("bnd_home_team_crest", function()
    o:publishMatchInfo()
  end)
  o.im.Subscribe("bnd_away_team_crest", function()
    o:publishMatchInfo()
  end)
  o.im.Subscribe("bnd_home_team_name", function()
    o:publishMatchInfo()
  end)
  o.im.Subscribe("bnd_away_team_name", function()
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
  o.im.RegisterAction(ACT_ADVANCE, function(actionName)
    o:PlayMatch()
  end)
  o.im.RegisterAction(ACT_RESTART, function(actionName)
    o:PlayReStart()
  end)
  
  return o
end

function QuickCup:InitOptions()
    -- Inicializar configuração do grupo
    local currentCupGrouping = QuickCupGrouping[cupId]
 for k = 1, table.getn(currentCupGrouping) do
    local index = k * 2 - 1
    local bindingKey = "bnd_team"

    -- Publica o crest e score do time da casa
    bindingKey = bindingKey .. index
    self.im.Publish(bindingKey .. "_crest", {
      name = "$Crest",
      id = currentCupGrouping[k][1]
    })
    self.im.Publish(bindingKey .. "_score", currentCupGrouping[k][3])
    self.im.Publish(bindingKey .. "_abbr", self.loc.LocalizeString("TeamName_Abbr3_" .. currentCupGrouping[k][1]))  -- Publica a abreviatura do time da casa

    -- Publica o crest e score do time visitante
    bindingKey = "bnd_team"
    local i = index + 1
    bindingKey = bindingKey .. i
    self.im.Publish(bindingKey .. "_crest", {
      name = "$Crest",
      id = currentCupGrouping[k][2]
    })
    self.im.Publish(bindingKey .. "_score", currentCupGrouping[k][4])
    self.im.Publish(bindingKey .. "_abbr", self.loc.LocalizeString("TeamName_Abbr3_" .. currentCupGrouping[k][2]))  -- Publica a abreviatura do time visitante
end
    if currentCupGrouping[maxMatchSize][5] then
      if currentCupGrouping[maxMatchSize][6] == currentCupInfo[cupId].homeID then 
        -- Parabéns por vencer a copa
        self.cupData.championCrest.id = currentCupInfo[cupId].homeID
      else
        -- Derrota lamentável
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
    self.im.Publish("bnd_text", "Competition Winner")
    self.im.Publish("bnd_champion_crest", self.cupData.championCrest)
    self.im.Publish("bnd_champion_team", self.loc.LocalizeString("TeamName_Abbr15_"..self.cupData.championCrest.id))
  end
end

function QuickCup:publishMatchInfo()
  if self.cupData.championCrest.id == 0 and self.cupData.isFinish == false then
    self.im.Publish("bnd_match_visible", not self.cupData.isFinish)
    self.im.Publish("bnd_text", self.cupData.Round)
    self.im.Publish("bnd_home_team_crest", self.cupData.homeTeamCrest)
    self.im.Publish("bnd_home_team_name", self.loc.LocalizeString("TeamName_Abbr15_"..self.cupData.homeTeamCrest.id))
    self.cupData.awayTeamCrest.id = self:GetMatchAwayTeamId()
    self.im.Publish("bnd_away_team_crest", self.cupData.awayTeamCrest)
    self.im.Publish("bnd_away_team_name", self.loc.LocalizeString("TeamName_Abbr15_"..self.cupData.awayTeamCrest.id))
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
    return "Round Of 16"
  elseif index > 8 and index <= 12 then
    return "Quater Finals"
  elseif index > 12 and index <= 14 then
    return "Semi Final"
  else
    return "Final"
  end
end

function QuickCup:PlayMatch()
  currentCupData.maxMatchSize = maxMatchSize
  currentCupData.cupIndex = cupId
  local currentCupGrouping = QuickCupGrouping[cupId]
  local index = 0
  for i = 1, table.getn(currentCupGrouping) do
    if currentCupGrouping[i][5] == false then
      if currentCupGrouping[i][1] == currentCupInfo[cupId].homeID then
        index = i
        currentCupData.homeID = currentCupInfo[cupId].homeID
        currentCupData.awayID = currentCupGrouping[i][2]
      elseif currentCupGrouping[i][2] == currentCupInfo[cupId].homeID then
        index = i
        currentCupData.homeID = currentCupInfo[cupId].homeID
        currentCupData.awayID = currentCupGrouping[i][1]
      end
    end
  end

  currentMatch.HomeTeamID = currentCupData.homeID
  currentMatch.AwayTeamID = currentCupData.awayID
  if index > 0 then
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
      buttons = { buttonNo, buttonYes }
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
  else
    self:StopMatch()
  end
end

function QuickCup:PlayReStart()
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
    message = "Do you want to end the current competition?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function QuickCup:StopMatch()
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "No",
    clickEvents = {
      "evt_hide_popup",
      "evt_refresh_on_resize"
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Yes",
    clickEvents = {
       "evt_restart",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "The competition has ended. Do you want to restart this competition?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function QuickCup:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.UnregisterAction(ACT_RESTART)
  self.im.Unsubscribe(BND_REALTIME)
  self.im.Unsubscribe("bnd_champion_crest")
  self.im.Unsubscribe("bnd_text")
  self.im.Unsubscribe("bnd_cup_bg")
  self.im.Unsubscribe("bnd_cup_logo")
  self.im.Unsubscribe("bnd_trophy")
  self.im.Unsubscribe("bnd_cup_map")
  self.im.Unsubscribe("bnd_champion_visible")
  self.im.Unsubscribe("bnd_match_visible")
  self.im.Unsubscribe("bnd_champion_team")
  self.im.Unsubscribe("bnd_home_team_crest")
  self.im.Unsubscribe("bnd_away_team_crest")
  self.im.Unsubscribe("bnd_home_team")
  self.im.Unsubscribe("bnd_away_team")
  self.im.Unsubscribe("bnd_home_team_name")
  self.im.Unsubscribe("bnd_away_team_name")
  self.im.Unsubscribe("bnd_ads")
  for k,v in pairs(bndList) do
    self.im.Unsubscribe(v)
  end
end

return QuickCup
