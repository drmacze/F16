
-------------------------------------------------------
-- REMOD BY LAOSIJI --
-------------------------------------------------------

local EventInfo = {}

local OverlaysIdContainer, OverlayParam, eventmanager = ...
local Overlays = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local initialized = false

local BND_VISIBLE = "bnd_visible"
local BND_NATIONALIZATION = "bnd_nationalization"
local BND_DATA = "bnd_data"
local BND_ALPHA = "bnd_alpha"

local beforeHomeScore = 0
local beforeAwayScore = 0
local nowHomeScore = 0
local nowAwayScore = 0

local goalStatistics = {}
--local isinitialized = 0


function EventInfo:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.nationalization = 2
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    SquadManagementService = o.api("SquadMgtService"),
    MatchInfoService = o.api("MatchInfoService")
  }
   local HOMETEAM = 0
  local AWAYTEAM = 1
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  
  homeTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(HOMETEAM, o.TeamsData[1].assetId, 0)
  
  awayTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(AWAYTEAM, o.TeamsData[2].assetId, 0)
  
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  
  o.isinitialized = 0
  
  local facts = o:getMatchFacts()
  nowHomeScore = facts[1].data.value + 0
  nowAwayScore = facts[1].data.valueRight + 0

  
  teamCrest = {
    name = "$Crest",
    id = 0
  }
  playerAvatar = {
    name = "$Head",
    id = 0
  }
  
  o.im.Subscribe(BND_NATIONALIZATION, function()
  end)
  o.im.Subscribe(BND_VISIBLE, function()
    o.im.Publish(BND_VISIBLE, false)
  end)
  o.im.Subscribe("bnd_player_visible", function()
    o.im.Publish("bnd_player_visible", false)
  end)
  o.im.Subscribe(BND_ALPHA, function()
  end)
  o.im.Subscribe(BND_DATA, function()
  end)
  o.im.Subscribe("bnd_text", function()
  end)
  o.im.Subscribe("bnd_team_crest", function()
  end)
  o.im.Subscribe("bnd_goal_player_avatar", function()
  end)
  o.im.Subscribe("bnd_goal_player_name", function()
  end)
  o.im.Subscribe("bnd_goal_player_level", function()
  end)
  o.im.Subscribe("bnd_goal_player_count", function()
  end)
  o.im.Subscribe("bnd_goal_player_desc", function()
  end)
  o.im.Subscribe("bnd_goal_time", function()
  end)
  o.im.Subscribe("bnd_goal_type", function()
  end)
  o.im.Subscribe("bnd_goal_desc", function()
  end)
  return o
end

function EventInfo:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeIngameCardInjury then
    self:updateEventInfo(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
  if eventType == EventTypes.OverlayTypeGoal then
    self:updateGoalScored(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function EventInfo:updateEventInfo(subtype, hideshow, subtypestr, msg)
  local params = OverlayParam.split(msg, "|")
  if hideshow == "SHOW" then
    if initialized == false then
      self.im.Publish(BND_NATIONALIZATION, self.nationalization)
      initialized = true
    end
    if params and table.getn(params) > 0 then
      self.im.Publish(BND_VISIBLE, true)
      local bottomText = ""
      local showBottomText = false
      if #params == 7 then
        bottomText = params[7]
        showBottomText = true
      end
      local eventInfo = {
        team = params[3],
        kitNumber = params[5],
        playerName = params[6],
        bottomText = bottomText,
        showBottomText = showBottomText,
        iconType = params[4] + 0
      }
      teamCrest.id = params[2] + 0
      self.im.Publish("bnd_team_crest", teamCrest)
      
      
      
      local eventdesc = ""
      -- 0 injure
      -- 1 yellow
      -- 2 red
      local eventtype = params[4] + 0
      if eventtype == 0 then 
        eventdesc = "Cidera"
      elseif eventtype == 1 then
        eventdesc = "Yellow Card"
      elseif eventtype == 2 then
        eventdesc = "Red Card"
      elseif eventtype == 3 then
        eventdesc = "Red Card"
      end
      self.im.Publish("bnd_goal_time")
      self.im.Publish("bnd_goal_type", eventdesc)
      self.im.Publish("bnd_goal_player_name", params[6])
      
      self.im.Publish(BND_DATA, eventInfo)
    end
  elseif hideshow == "UPDATE" then
    self.im.Publish(BND_ALPHA, params[1] / 100)
  else
    self.im.Publish(BND_VISIBLE, false)
  end
end

function EventInfo:addDaysToDate(dateStr, daysToAdd)
    local d, m, y = dateStr:match("(%d%d)/(%d%d)/(%d%d)")
    local timestamp = os.time({ day = tonumber(d), month = tonumber(m), year = 2000 + tonumber(y) })  
    local newTimestamp = timestamp + (daysToAdd * 86400)  -- Add days in seconds
    local newDate = os.date("%d/%m/%y", newTimestamp)  
    return newDate
end

function EventInfo:updateGoalScored(subtype, hideshow, subtypestr, msg)
  if hideshow ~= "HIDE" then
    if initialized == false then
      self.im.Publish(BND_NATIONALIZATION, self.nationalization)
      initialized = true
    end
    local params = OverlayParam.split(msg, "|")
    local teamside
    if params and table.getn(params) > 0 then
      self.isinitialized = self.isinitialized + 1
      
      if self.isinitialized == 1 then
        beforeHomeScore = nowHomeScore
        beforeAwayScore = nowAwayScore
      end
      -- self.im.Publish(BND_VISIBLE, true)
      -- self.im.Publish("bnd_player_visible", true)
      
      local bottomText = ""
      local showBottomText = false
      local goalScored = {
        kitNumber = "",
        bottomText = bottomText,
        showBottomText = showBottomText,
        iconType = params[13] + 0,
        playerName = params[14],
        team = params[15]
      }
      nowHomeScore = params[5] + 0
      nowAwayScore = params[6] + 0
      local isOg = string.find(goalScored.playerName, "(OG)")
      local isPenalty = string.find(goalScored.playerName, "(pen)")
      local currentTime = string.gsub(params[7], "%'", " ")
      
      -- if isPenalty then
      --   goalScored.playerName = string.gsub(goalScored.playerName, "点球", "(点球)")
      -- end
      
      if nowHomeScore > beforeHomeScore then
        teamCrest.id = params[1] + 0
        teamside = 0
        if isOg then 
          teamCrest.id = params[3] + 0
        end
      elseif nowAwayScore > beforeAwayScore then
        teamCrest.id = params[3] + 0
        teamside = 1
        if isOg then 
          teamCrest.id = params[1] + 0
        end
      end
      
      self.im.Publish("bnd_team_crest", teamCrest)

      if currentTime + 0 > 90 then
        self.im.Publish("bnd_goal_desc", "ExtraTime Goal: ")
      else
        self.im.Publish("bnd_goal_desc", "Match Goal: ")
      end
      
      local playerName = goalScored.playerName
      local playerInfo = self:getPlayerInfo(teamside, teamCrest.id, playerName, isOg)
      playerAvatar.id = playerInfo.assetId
      
      if self.isinitialized == 1 then
        -- Update goalStatistics
        if goalStatistics[playerInfo.assetId] then
          goalStatistics[playerInfo.assetId] = goalStatistics[playerInfo.assetId] + 1
        else
          goalStatistics[playerInfo.assetId] = 1
        end

        -- Add to GOALS placeholder for any player
        if not GOALS then
          GOALS = {}
        end
        if not GOALS[playerInfo.assetId] then
          GOALS[playerInfo.assetId] = 0
        end
        GOALS[playerInfo.assetId] = GOALS[playerInfo.assetId] + 1
      end
      local goalDesc = "text"
      if goalStatistics[playerInfo.assetId] == 1 then
        goalDesc = "One Goal"
      elseif goalStatistics[playerInfo.assetId] == 2 then
        goalDesc = "Brace"
      elseif goalStatistics[playerInfo.assetId] == 3 then
        goalDesc = "Hat Trick"
      elseif goalStatistics[playerInfo.assetId] == 4 then
        goalDesc = "Quat Trick"
      elseif goalStatistics[playerInfo.assetId] == 5 then
        goalDesc = "Palm Trick"
      elseif goalStatistics[playerInfo.assetId] == 6 then
        goalDesc = "Super Hero"
      end


      local goalType = ""
      if isOg then 
        goalType = "Own Goal"
      elseif isPenalty then
        goalType = "Penalty"
      else
        goalType = "Goal"
      end

      self.im.Publish("bnd_goal_player_name", string.gsub(playerInfo.playerName, "%b()", " "))
      self.im.Publish("bnd_goal_player_avatar", playerAvatar)
      self.im.Publish("bnd_goal_player_level", ""..playerInfo.level)
      if currentTime + 0 > 90 then
        self.im.Publish("bnd_goal_player_desc", "Min")
      else
        self.im.Publish("bnd_goal_player_desc", goalDesc)
      end
      
      self.im.Publish("bnd_goal_time"," ".. params[7])
      self.im.Publish("bnd_goal_type", goalType)
      self.im.Publish("bnd_goal_player_count", "Today's Goal     "..goalStatistics[playerInfo.assetId])

      self.im.Publish(BND_VISIBLE, true)
      if playerInfo.assetId == 0 then
        self.im.Publish("bnd_player_visible", false)
      else
        self.im.Publish("bnd_player_visible", true)
      end
    
      self.im.Publish(BND_DATA, goalScored)
     -- isinitialized = 2
    end
  else
    self.im.Publish(BND_VISIBLE, false)
    self.im.Publish("bnd_player_visible", false)
    if self.isinitialized >= 2 then
      self.isinitialized = 0
    end
  end
end

function EventInfo:split(str, delimiter)
  local index = {}
  local oid = {}
  for k = 1,string.len(str) do
    if string.sub(str,k,k) == delimiter then
      table.insert(index,k)
    end
  end

  table.insert(oid,string.sub(str,1,index[1]-1))
    for k=1,#index-1 do
      table.insert(oid,string.sub(str,index[k]+1,index[k+1]-1))
    end
  table.insert(oid,string.sub(str,index[#index]+1,string.len(str)))
  return oid
end


function EventInfo:getPlayerInfo(teamSide, teamID, playername, isOg)
  local count = 0
  local specialString = false
  local playerInfo = {
    assetId = 0,
    level = 0,
    playerName = playername
  }
  local teamlineupData = nil
  if isOg then 
    if teamSide == 0 then
       teamSide = 1
    else
       teamSide = 0
    end
  end
  
  if teamSide == 0 then
    teamlineupData = homeTeamlineupData
  else
    teamlineupData = awayTeamlineupData
  end
  if string.find(playername, "-") or string.find(playername, "%.") then
    specialString = true
    --count = 0
  end
 
  if specialString == false then
    count = 0
    playerInfo.playerName =  string.gsub(playername, "%b()", " ")
    playerInfo.playerName =  string.gsub(playerInfo.playerName, "^%s*(.-)%s*$", "%1")
  end
  
  for _FORV_6_ = 1, table.getn(teamlineupData) do
    if specialString == true then
       if string.find(playername, teamlineupData[_FORV_6_].playerName,1,true) then 
        if count == 0 then
          count = count + 1
          playerInfo.assetId = teamlineupData[_FORV_6_].CARD_ID
          playerInfo.level = teamlineupData[_FORV_6_].jerseyNumber
          playerInfo.playerName = teamlineupData[_FORV_6_].playerName
        end
      end
    else
    if string.find(playerInfo.playerName, teamlineupData[_FORV_6_].playerName,1,true) and playerInfo.playerName == teamlineupData[_FORV_6_].playerName then
      if count == 0 then
       count = count + 1
       playerInfo.assetId = teamlineupData[_FORV_6_].CARD_ID
       playerInfo.level = teamlineupData[_FORV_6_].jerseyNumber
       playerInfo.playerName = teamlineupData[_FORV_6_].playerName
      end
    end
    end
  end
  return playerInfo
end

function EventInfo:k_include(tab, value)
  for k,v in pairs(tab) do
    if k == value then
        return true
    end
  end
  return false
end

function EventInfo:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function EventInfo:getMatchFacts()
  local facts = self.services.MatchInfoService.GetMatchFacts(true)
  local o = facts.homeData
  for i, v in ipairs(o) do
    v.data.valueRight = facts.awayData[i].data.value
  end
  return o
end

function EventInfo:finalize()
  self.im.Unsubscribe(BND_VISIBLE)
  self.im.Unsubscribe(BND_ALPHA)
  self.im.Unsubscribe(BND_DATA)
  self.im.Unsubscribe(BND_NATIONALIZATION)
  self.im.Unsubscribe("bnd_text")
  self.im.Unsubscribe("bnd_team_crest")
  self.im.Unsubscribe("bnd_goal_player_avatar")
  self.im.Unsubscribe("bnd_goal_player_name")
  self.im.Unsubscribe("bnd_goal_player_level")
  self.im.Unsubscribe("bnd_goal_player_desc")
  self.im.Unsubscribe("bnd_goal_player_count")
  self.im.Unsubscribe("bnd_player_visible")
  self.im.Unsubscribe("bnd_goal_time")
  self.im.Unsubscribe("bnd_goal_type")
  self.im.Unsubscribe("bnd_goal_desc")
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  
end

return EventInfo

