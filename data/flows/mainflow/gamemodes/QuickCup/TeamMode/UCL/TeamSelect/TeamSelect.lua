-- TeamSelect (corrigido + shuffle automático na primeira inicialização)
local TeamSelect = {}

local NUM_TABS = 16
local bndTeamList = "bnd_team_list"
local BND_TEAM_RATING = "bnd_team_rating"
local ACT_TEAM_SELECT = "act_team_select"
local ACT_SELECTED = "act_selected"

local cupId = 1
local OriginalTeamList = { 243, 241, 240, 245, 22, 21, 32, 131681, 131682, 48, 73, 69, 9, 1, 10, 5 }

-- Copiamos apenas os primeiros 16 times
TeamList = {}
for i = 1, 16 do
  table.insert(TeamList, OriginalTeamList[i])
end

-- Função shuffle (Fisher-Yates)
local function shuffleTable(t)
  math.randomseed(os.time())
  for i = #t, 2, -1 do
    local j = math.random(i)
    t[i], t[j] = t[j], t[i]
  end
end

-- Predefined flags (pode editar conforme necessidade)
local TEAM_FLAG_ID = { [243] = 45, [241] = 45, [240] = 45, [245] = 34, [22] = 21, [21] = 21, [32] = 21, [131681] = 27, [131682] = 27, [48] = 27, [73] = 18, [69] = 18, [9] = 14, [1] = 14, [10] = 14, [5] = 14 }

local TeamListData = {}

function TeamSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self  
  o.services = {
    SquadManagementService = o.api("SquadMgtService"),
    CountryService = o.api("CountryService"),
    EventManagerService = o.api("EventManagerService"),
    SaveLoadService = o.api("SaveLoadService")
  }
  
  o.cupData = {
    cupBg = { 
      name = "$CupBg",
      id = cupId
    },
    cupLogo = {
      name = "$CupLogo",
      id = cupId
    }
  }
  o.im.Subscribe("bnd_cup_bg", function()
  o.im.Publish("bnd_cup_bg", o.cupData.cupBg)
  end)
  o.im.Subscribe("bnd_cup_logo", function()
  o.im.Publish("bnd_cup_logo", o.cupData.cupLogo)
  end)

  -- Tabs: 1 time por tab
  o.tabTeams = {}
  for i = 1, 16 do
    o.tabTeams[i] = { TeamList[i] }
  end

  o.teamObjects = {}
  for i = 1, 16 do
    o.teamObjects[i] = { name = "$Crest", id = TeamList[i] }
  end
  
  o.currentTab = 1
  o.selectedTeamIndex = nil

  -- Inscrições
  for i = 1, 16 do
    local tabName = "bnd_tab" .. i .. "_visible"
    o.im.Subscribe(tabName, function() end)

    local key = "bnd_team" .. i
    o.im.Subscribe(key, function()
      o.im.Publish(key, o.teamObjects[i])
    end)
  end

  o.im.Subscribe(BND_TEAM_RATING, function() o:publishTeamRating() end)
  o.im.Subscribe(bndTeamList, function() o:publishTeamRows() end)

  o.im.RegisterAction(ACT_TEAM_SELECT, function(_, data)
    if data then o:StartQuickCup(data) end
  end)

  o.im.RegisterAction(ACT_SELECTED, function(_, data)
    o:HideSelections()
    local idx = (data and data.buttonID) and (data.buttonID + 1) or 1
    o.currentTab = idx
    o.im.Publish("bnd_tab" .. o.currentTab .. "_visible", true)
    o:Init(o.currentTab)
    o:InitGrouping()
    o.selectedTeamIndex = nil
    o:publishTeamRating()
    o:publishTeamRows()
  end)

  -- Cria currentCupInfo se não existir
  if not currentCupInfo[cupId] then
    currentCupInfo[cupId] = { cupIndex = cupId, homeID = 0 }
  end

  -- Primeira vez → shuffle antes de montar confrontos
  if currentCupInfo[cupId].homeID == 0 then
    shuffleTable(TeamList)
    o:Init(o.currentTab)
    o:InitGrouping()
  else
    -- Já existe campanha, não recria nem shuffle
    o.nav.Event(nil, "evt_team_select")
  end

  return o
end

function TeamSelect:Init(tabID)
  tabID = tabID or 1
  TeamListData = {}

  local teamsForTab = self.tabTeams[tabID] or {}
  for _, teamId in ipairs(teamsForTab) do
    local teamInfo = self.services.SquadManagementService.GetTeamInfo(teamId) or {}
    local obj = {
      assetId = teamId,
      clickAction = "act_team_select",
      teamName = self.loc and self.loc.LocalizeString("TeamName_Abbr15_"..teamId) or ("Team "..tostring(teamId)),
      shortTeamName = self.loc and self.loc.LocalizeString("TeamName_Abbr3_"..teamId) or tostring(teamId),
      rating = teamInfo.starRating or 0,
      offense = teamInfo.offense or 0,
      midfield = teamInfo.midfield or 0,
      defense = teamInfo.defense or 0,
      data = {
        TeamCrest = { name = "$Crest", id = teamId },
        flagCrest  = { name = "$Flag128x128", id = TEAM_FLAG_ID[teamId] or 0 },
        TeamName = self.loc and self.loc.LocalizeString("TeamName_Abbr15_"..teamId) or ("Team "..tostring(teamId)),
        Rating = teamInfo.starRating or 0,
        clickAction = "act_team_select",
        FontColor = "0xffffff",
        TeamNameFontColor = "0xffffff",
        Icon = { name = "$IconMatchBall", id = 2 }
      }
    }
    table.insert(TeamListData, obj)
  end
end

function TeamSelect:InitGrouping()
  if not currentCupInfo[cupId] then
    currentCupInfo[cupId] = { cupIndex = cupId, homeID = 0 }
  end
  if QuickCupGrouping and QuickCupGrouping[cupId] and currentCupInfo[cupId].homeID ~= 0 then
    return
  end

  local groupingList = {}
  for i = 1, #TeamList, 2 do
    if TeamList[i+1] then
      table.insert(groupingList, {
        [1] = TeamList[i],
        [2] = TeamList[i+1],
        [3] = "0",
        [4] = "0",
        [5] = false,
        [6] = 0,
        [7] = false
      })
    end
  end
  QuickCupGrouping = QuickCupGrouping or {}
  QuickCupGrouping[cupId] = groupingList
end

function TeamSelect:publishTeamRows()
  for i, v in ipairs(TeamListData) do
    v.data.TeamCrest = { name = "$Crest", id = v.assetId }
    v.data.flagCrest = { name = "$Flag128x128", id = TEAM_FLAG_ID[v.assetId] or 0 }
    v.data.TeamName = v.teamName
    v.data.Rating = v.rating
    v.data.clickAction = v.clickAction
    v.data.FontColor = "0xffffff"
    v.data.TeamNameFontColor = "0xffffff"
    v.data.Icon = { name = "$", id = 2 }
  end
  self.im.Publish(bndTeamList, TeamListData)
end

function TeamSelect:publishTeamRating()
  local idx = self.selectedTeamIndex or 1
  if not TeamListData or not TeamListData[idx] then
    self.im.Publish(BND_TEAM_RATING, self:createEmptyRating())
    return
  end
  local t = TeamListData[idx]
  local rating = {
    attackValue = math.floor(t.offense or 0),
    middleValue = math.floor(t.midfield or 0),
    defenseValue = math.floor(t.defense or 0),
    attackLabel = self.loc and self.loc.LocalizeString("LTXT_CMN_ATT") or "ATT",
    middleLabel = self.loc and self.loc.LocalizeString("LTXT_CMN_MID") or "MID",
    defenseLabel = self.loc and self.loc.LocalizeString("LTXT_CMN_DEF") or "DEF",
    overallRating = string.format("%.1f", t.rating or 0),
    teamName = t.teamName or ""
  }
  self.im.Publish(BND_TEAM_RATING, rating)
end

function TeamSelect:createEmptyRating()
  return {
    attackValue = 0, middleValue = 0, defenseValue = 0,
    attackLabel = self.loc and self.loc.LocalizeString("LTXT_CMN_ATT") or "ATT",
    middleLabel = self.loc and self.loc.LocalizeString("LTXT_CMN_MID") or "MID",
    defenseLabel = self.loc and self.loc.LocalizeString("LTXT_CMN_DEF") or "DEF",
    overallRating = "0.0", teamName = ""
  }
end

function TeamSelect:StartQuickCup(data)
  local currentTeamIndex = (data and data.id) and (data.id + 1) or 1
  currentCupInfo[cupId] = currentCupInfo[cupId] or { cupIndex = cupId, homeID = 0 }
  currentCupInfo[cupId].homeID = TeamListData[currentTeamIndex].assetId

  local buttonNo = { icon="$FooterIconNo", label="Cancel", clickEvents={"evt_hide_popup"} }
  local buttonYes = { icon="$FooterIconYes", label="Confirm", clickEvents={"evt_team_select","evt_hide_popup"} }

  local popupData = {
    title = "INFO",
    message = "Do you want to choose "..(TeamListData[currentTeamIndex].teamName or "").." to start the competition?",
    buttons = { buttonNo, buttonYes }
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function TeamSelect:HideSelections()
  for i = 1, 16 do
    self.im.Publish("bnd_tab" .. i .. "_visible", false)
  end
end

function TeamSelect:finalize()
  self.im.Unsubscribe("bnd_cup_bg")
  self.im.Unsubscribe("bnd_cup_logo")
  self.im.Unsubscribe(bndTeamList)
  self.im.Unsubscribe(BND_TEAM_RATING)
  self.im.UnregisterAction(ACT_TEAM_SELECT)
  self.im.UnregisterAction(ACT_SELECTED)
  for i = 1, 16 do self.im.Unsubscribe("bnd_tab"..i.."_visible") end
end

return TeamSelect