
-------------------------------------------------------
-- REMOD BY YouTube LAOSIJI --
-------------------------------------------------------

local ScoreClock = {}

local OverlaysIdContainer, OverlayParam, eventmanager, TableUtil = ...
local Overlays = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local BND_NAMA_TIM_HOME = "bnd_nama_tim_home"
local BND_NAMA_TIM_AWAY = "bnd_nama_tim_away"

local leagueIDs = {
   England = 0,
   France = 0,
   Germany = 0,
   Italy = 0,
   Spain = 0,
   ItalyB = 0,
   SpainB = 0,
   FranceB = 0,
   GermanyB = 0,
   UnitedStates = 0,
   Argentina = 0
}


local EAFCScore = {
  bnd_text_bold = false,
  bnd_width = 380,
  bnd_height = 38,
  bnd_top = 0,
  bnd_left = 0,
  bnd_scoreboard_width = 380,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 68,
  bnd_logo_width = 370,
  bnd_logo_top = -4.5,
  bnd_logo_left = 45,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 0
  },
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 90,
  bnd_homeBg_left = 11000000,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 0
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 0,
  bnd_awayBg_right = 1000000,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 0
  },
  bnd_scoreBg_width = 380,
  bnd_scoreBg_height = 38,
  bnd_scoreBg_left = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard"
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 5,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 0,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -136,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 0,
  bnd_awayName_fontColor = "0xFFFFFF",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -30,
  bnd_homeCrest_width = 0,
  bnd_homeCrest_height = 0,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -175,
  bnd_awayCrest_width = 0,
  bnd_awayCrest_height = 0,

  bnd_homeScore_text = "",
  bnd_homeScore_top = -2,
  bnd_homeScore_left = 52,
  bnd_homeScore_fontSize = 0,
  bnd_homeScore_fontColor = "0x1E1E1E",
  bnd_awayScore_text = "",
  bnd_awayScore_top = -2,
  bnd_awayScore_right = -88,
  bnd_awayScore_fontSize = 0,
  bnd_awayScore_fontColor = "0x1E1E1E",

  bnd_score_text = "-",
  bnd_score_top = -3.5,
  bnd_score_left = 71,
  bnd_score_fontSize = 0,
  bnd_score_fontColor = "0x1E1E1E",

  bnd_time_width = 380,
  bnd_time_height = 38,
  bnd_time_top = 50,
  bnd_time_left = 75,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 0
  },
  bnd_time_text = "",
  bnd_time_fontSize = 0,
  bnd_time_fontColor = "0xFFFFFF",
  bnd_time_text_top = 0,
  bnd_time_text_left = -61,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 96,
  bnd_extraTime_height = 62,
  bnd_extraTime_bottom = 0,
  bnd_extraTime_left = 0,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime"
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 0,
  bnd_extraTime_fontColor = "0x1E1E1E",

  bnd_stat_visible = false,
  bnd_stat_top = 0,
  bnd_stat_left = 0,
  bnd_stat_color = "0x25C4CD",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 18,
  bnd_stat_fontColor = "0x25C4CD",
  bnd_home_stat_text_left = -40,
  bnd_home_stat_text_top = 0,
  bnd_home_stat_fontColor = "0xffffff",
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 120,
  bnd_away_stat_text_top = 0,
  bnd_away_stat_fontColor = "0xffffff",
  bnd_stat_text_left = 40,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

function ScoreClock:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    MatchInfoService = o.api("MatchInfoService"),
    EventManagerService = o.api("EventManagerService"),
    GameSetupService = o.api("GameSetupService"),
    OverlayService = o.api("OverlayService"),
    TeamService = o.api("TeamService")
  }
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  
  o.visible = false
  
  local HOMETEAM = 0
  local AWAYTEAM = 1
  o.statType = {
    possession = {
      label = "POSSESSION",
      value = 4
    },
    judul = {
      label = "FIFA 16",
      value = 1
    },
    Shots = {
      label = "SHOTS",
      value = 2
    },
    tackle = {
      label = "TACKLE",
      value = 5
    }

  }
  local currentScoreBoard
  
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  self.homeScore = o.services.OverlayService.GetCurrentScore(HOMETEAM)
  self.awayScore = o.services.OverlayService.GetCurrentScore(AWAYTEAM)
  
  local EnglandTeams = o.services.TeamService.GetTeams(leagueIDs.England, 0, 0, true)
  local FranceTeams = o.services.TeamService.GetTeams(leagueIDs.France, 0, 0, true)
  local GermanyTeams = o.services.TeamService.GetTeams(leagueIDs.Germany, 0, 0, true)
  local SpainTeams = o.services.TeamService.GetTeams(leagueIDs.Spain, 0, 0, true)
  local ItalyTeams = o.services.TeamService.GetTeams(leagueIDs.Italy, 0, 0, true)
  local UnitedStatesTeams = o.services.TeamService.GetTeams(leagueIDs.UnitedStates, 0, 0, true)
  local ArgentinaTeams = o.services.TeamService.GetTeams(leagueIDs.Argentina, 0, 0, true)
  local ItalyBTeams = o.services.TeamService.GetTeams(leagueIDs.ItalyB, 0, 0, true)
  local IndonesiaTeams = o.services.TeamService.GetTeams(leagueIDs.Indonesia, 0, 0, true)
  local SpainBTeams = o.services.TeamService.GetTeams(leagueIDs.SpainB, 0, 0, true)
  local FranceBTeams = o.services.TeamService.GetTeams(leagueIDs.FranceB, 0, 0, true)
  local GermanyBTeams = o.services.TeamService.GetTeams(leagueIDs.GermanyB, 0, 0, true)

  o.statVisible = false
  o.homeStat = "0%"
  o.awayStat = "0%"

  o.facts = nil

  liveLogo = {
    name = "$LiveLogo",
    id = 0
  }

  if o:isInTable(o.TeamsData[1], EnglandTeams) and o:isInTable(o.TeamsData[2], EnglandTeams) then
    currentScoreBoard = EnglandScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, EnglandTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, EnglandTeamsData)
    currentScoreBoard.bnd_homeRect_color = homeColorList[1]
    currentScoreBoard.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 1
  elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
    currentScoreBoard = FranceScore
    liveLogo.id = 2
  elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
    currentScoreBoard = GermanyScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, GermanyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, GermanyTeamsData)
    currentScoreBoard.bnd_homeRect_color = homeColorList[1]
    currentScoreBoard.bnd_homeName_fontColor = homeColorList[2]
    currentScoreBoard.bnd_homeScore_fontColor = homeColorList[2]
    currentScoreBoard.bnd_awayRect_color = awayColorList[1]
    currentScoreBoard.bnd_awayName_fontColor = awayColorList[2]
    currentScoreBoard.bnd_awayScore_fontColor = awayColorList[2]
    liveLogo.id = 4
  elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
    currentScoreBoard = SpainScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, SpainTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, SpainTeamsData)
    currentScoreBoard.bnd_homeRect_color = homeColorList[1]
    currentScoreBoard.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 3
  elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
    currentScoreBoard = ItalyScore
    liveLogo.id = 5
  elseif o:isInTable(o.TeamsData[1], UnitedStatesTeams) and o:isInTable(o.TeamsData[2], UnitedStatesTeams) then
    currentScoreBoard = UnitedStatesScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, UnitedStatesTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, UnitedStatesTeamsData)
    currentScoreBoard.bnd_homeRect_color = homeColorList[1]
    currentScoreBoard.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 11
 elseif o:isInTable(o.TeamsData[1], ArgentinaTeams) and o:isInTable(o.TeamsData[2], ArgentinaTeams) then
    currentScoreBoard = ArgentinaScore
    liveLogo.id = 0
 elseif o:isInTable(o.TeamsData[1], IndonesiaTeams) and o:isInTable(o.TeamsData[2], IndonesiaTeams) then
    currentScoreBoard = IndonesiaScore
    liveLogo.id = 8
 elseif o:isInTable(o.TeamsData[1], ItalyBTeams) and o:isInTable(o.TeamsData[2], ItalyBTeams) then
    currentScoreBoard = ItalyBScore
    liveLogo.id = 6
 elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
    currentScoreBoard = SpainBScore
    liveLogo.id = 3
 elseif o:isInTable(o.TeamsData[1], FranceBTeams) and o:isInTable(o.TeamsData[2], FranceBTeams) then
    currentScoreBoard = FranceBScore 
    liveLogo.id = 15
 elseif o:isInTable(o.TeamsData[1], GermanyBTeams) and o:isInTable(o.TeamsData[2], GermanyBTeams) then
    currentScoreBoard = GermanyBScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, GermanyBTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, GermanyBTeamsData)
    currentScoreBoard.bnd_homeRect_color = homeColorList[1]
    currentScoreBoard.bnd_homeName_fontColor = homeColorList[2]
    currentScoreBoard.bnd_homeScore_fontColor = homeColorList[2]
    currentScoreBoard.bnd_awayRect_color = awayColorList[1]
    currentScoreBoard.bnd_awayName_fontColor = awayColorList[2]
    currentScoreBoard.bnd_awayScore_fontColor = awayColorList[2]
    liveLogo.id = 16
 else 
    currentScoreBoard = EAFCScore
    liveLogo.id = 0
  end

  currentScoreBoard.bnd_homeCrest.id = o.TeamsData[1].assetId
  currentScoreBoard.bnd_awayCrest.id = o.TeamsData[2].assetId

  currentScoreBoard.bnd_homeName_text = o.services.GameSetupService.GetTeamShortName(HOMETEAM)
  currentScoreBoard.bnd_awayName_text = o.services.GameSetupService.GetTeamShortName(AWAYTEAM)

  o.im.Subscribe("bnd_visible", function()
    o:publishVisible()
  end)
  
  o.im.Subscribe(BND_NAMA_TIM_HOME, function()
    o.im.Publish(BND_NAMA_TIM_HOME, o.TeamsData[1].teamName)
  end)
  o.im.Subscribe(BND_NAMA_TIM_AWAY, function()
    o.im.Publish(BND_NAMA_TIM_AWAY, o.TeamsData[2].teamName)
  end)
  
   for k,v in pairs(currentScoreBoard) do
    o.im.Subscribe(k, function()
      if k == "bnd_homeScore_text" then
        o:publishScoreHome()
      elseif k == "bnd_awayScore_text" then
        o:publishScoreAway()
      elseif k == "bnd_time_text" then
        o:publishTime()
      elseif k == "bnd_extraTime_visible" then
        o:publishExtraTimeVisibility(false)
      elseif k == "bnd_extraTime_text" then
        o:publishExtraTime()
      elseif k == "bnd_home_stat_text" or k == "bnd_away_stat_text" then
        o:publishStat()
      else
        o.im.Publish(k, v)
      end
    end)
  end

 
  
  o.im.Subscribe("bnd_live_logo", function()
    o.im.Publish("bnd_live_logo", liveLogo)
  end)

  return o
end



-----------------------------------------------------------------------------------------------------------
function ScoreClock:publishScoreHome()
  self.im.Publish("bnd_homeScore_text", tostring(self.homeScore))
end
function ScoreClock:publishScoreAway()
  self.im.Publish("bnd_awayScore_text", tostring(self.awayScore))
end
function ScoreClock:publishTime()
  if self.gameTime ~= "" and self.gameTime ~= nil then
    self.im.Publish("bnd_time_text", tostring(self.gameTime))
  end
end
function ScoreClock:publishExtraTime()
  if self.gameExtraTime ~= "" and self.gameExtraTime ~= nil then
    self.im.Publish("bnd_extraTime_text", tostring(self.gameExtraTime))
  end
end

function ScoreClock:publishStat()
  local statTypeLabel = ""
  local statTypeValue = 0
  if self.gameTime ~= "" and self.gameTime ~= nil then
    local gameTime = string.sub(self.gameTime, 1, string.find(self.gameTime, ":") - 1)
    if (gameTime + 0 > 25 and gameTime + 0 < 28) or (gameTime + 0 > 70 and gameTime + 0 < 73) then
      statTypeLabel = self.statType.possession.label
      statTypeValue = self.statType.possession.value
    elseif (gameTime + 0 > -1 and gameTime + 0 < 2) or (gameTime + 0 > 45 and gameTime + 0 < 48) then
      statTypeLabel = self.statType.judul.label
      statTypeValue = self.statType.judul.value
    elseif (gameTime + 0 > 15 and gameTime + 0 < 18) or (gameTime + 0 > 60 and gameTime + 0 < 63) then
      statTypeLabel = self.statType.Shots.label
      statTypeValue = self.statType.Shots.value
    elseif (gameTime + 0 > 35 and gameTime + 0 < 38) or (gameTime + 0 > 80 and gameTime + 0 < 83) then
      statTypeLabel = self.statType.tackle.label
      statTypeValue = self.statType.tackle.value
    else
      self.facts = nil
      self.statVisible = false
    end
    if statTypeValue > 0 then
      if self.facts == nil then
        self.facts = self:getMatchFacts()
      end
      self.homeStat = self.facts[statTypeValue].data.value
      self.awayStat = self.facts[statTypeValue].data.valueRight
      self.statVisible = true
    end
    -- self.statVisible = true
    self.im.Publish("bnd_stat_text", statTypeLabel)
    self.im.Publish("bnd_stat_visible", self.statVisible)
    self.im.Publish("bnd_home_stat_text", tostring(self.homeStat))
    self.im.Publish("bnd_away_stat_text", tostring(self.awayStat))
  end
end


function ScoreClock:getMatchFacts()
  local facts = self.services.MatchInfoService.GetMatchFacts(true)
  local o = facts.homeData
  for i, v in ipairs(o) do
    v.data.valueRight = facts.awayData[i].data.value
  end
  return o
end
-----------------------------------------------------------------------------------------------------------

function ScoreClock:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeGumby then
    self:updateGameTime(data.subtype, data.hideshow, data.subtypestr, data.msg)
  elseif eventType == EventTypes.OverlayTypeGoal or eventType == EventTypes.OverlayTypeMatchEvents then
    self:updateGameScore(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function ScoreClock:updateGameTime(subtype, hideshow, subtypestr, msg)
  local params = OverlayParam.split(msg, "|")
  self.gameTime = ""
  self.gameExtraTime = ""
  if #params == 3 then
    if string.find(params[1], ":") then
      self.gameExtraTime = params[3]
      self:publishExtraTime()
      self:publishExtraTimeVisibility(true)
    end
    self.gameTime = params[1]
    self:publishTime()
    self:publishStat()
  elseif #params == 4 then
    self.im.Publish(bndAlpha, params[1] / 100)
  elseif params and table.getn(params) > 0 then
    if string.find(params[1], ":") then
      self.gameTime = params[1]
    end
    if params[1] == "" then
      self:publishExtraTimeVisibility(false)
    end
    self:publishTime()
    self:publishStat()
  end
  self.visible = hideshow == "SHOW" or hideshow == "UPDATE"
  self:publishVisible()
end

function ScoreClock:updateGameScore(subtype, hideshow, subtypestr, msg)
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) >= 6 then
      self.homeScore = params[5]
      self.awayScore = params[6]
      self:publishScoreHome()
      self:publishScoreAway()
    end
  end
end

function ScoreClock:publishExtraTimeVisibility(visible)
  self.im.Publish("bnd_extraTime_visible", visible)
end

function ScoreClock:publishVisible()
  self.im.Publish("bnd_visible", self.visible)
end

function ScoreClock:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function ScoreClock:getTeamHomeColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.homeColor
      result[2] = v.homeFontColor
    end
  end
  return result
end

function ScoreClock:getTeamAwayColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.awayColor
      result[2] = v.awayFontColor
    end
  end
  return result
end
    
function ScoreClock:finalize()
  for k,v in pairs(EAFCScore) do
    self.im.Unsubscribe(k)
  end
  self.im.Unsubscribe("bnd_live_logo")
  self.im.Unsubscribe(BND_NAMA_TIM_HOME)
  self.im.Unsubscribe(BND_NAMA_TIM_AWAY)
  self.im.Unsubscribe("bnd_visible")
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
end

return ScoreClock