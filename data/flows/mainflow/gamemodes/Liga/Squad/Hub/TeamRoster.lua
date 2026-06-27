-- Modified By MVNPROD Youtube Channel --
local Timer = ...
local TeamRoster = {}

local bndPlayerList = "bnd_player_list"

local ACT_PLAYER_SELECT = "act_player_select"
local ACT_HIDE = "act_hide"
local ACT_RELEASE = "act_release"
local ACT_TOGGLE = "act_toggle"

local PlayerListData = {}
local teamPlayers = {}
local playerData
local statsubs = {"gs", "cs", "yc", "rc"}
local toggle = false

TeamID = 0

function TeamRoster:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SquadManagementService = o.api("SquadMgtService"),
    gameSetup = o.api("GameSetupService")
  }
  TeamID = currentSelectedTeamID
  o.visible = true
  o.rowvisible = true
  o.panelvisible = false
  o.statvisible = false
  o.infovisible = true
  o.currentIndex = 0
  o.oldIndex = -1
  o.im.Subscribe("bnd_visible", function()
    o:publishVisible()
  end)
  o.im.Subscribe("bnd_loading_visible", function()
    o:publishVisible()
  end)
  o.im.Subscribe("bnd_rowvisible", function()
    o:publishVisible()
  end)
  o.im.Subscribe("bnd_panelvisible", function()
    o:publishVisible()
  end)
  o.im.Subscribe("bnd_panelanim", function()
    o:publishVisible()
  end)
  o.im.Subscribe("bnd_plstat_visible", function()
    o:publishVisible()
  end)
  o.im.Subscribe("bnd_plinfo_visible", function()
    o:publishVisible()
  end)
  o.im.Subscribe("bnd_team_crest", function()
    o.im.Publish("bnd_team_crest", {
      name = "$Crest",
      id = TeamID
    })
  end)
  o.im.Subscribe("bnd_team_name", function()
    o.im.Publish("bnd_team_name", o.loc.LocalizeString("TeamName_Abbr15_"..TeamID))
  end)
  o.im.Subscribe("bnd_player_avatar", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_player_name", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_player_ID", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_player_position", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_value", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_fitness", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_suspstatus", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_player_country", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_player_rating", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_3d_player", function()
    o:publishPlayerInfo()
  end)

  for i = 1, 6 do
    o.im.Subscribe("bnd_player_stat"..i, function()
      o:publishPlayerInfo()
    end)
  end
        
  for i = 1, 4 do
    o.im.Subscribe("bnd_friendly".. statsubs[i], function()
      o:publishPlayerInfo()
    end)
  end
  for i = 1, 4 do
    o.im.Subscribe("bnd_dom".. statsubs[i], function()
      o:publishPlayerInfo()
    end)
  end
  for i = 1, 4 do
    o.im.Subscribe("bnd_total".. statsubs[i], function()
      o:publishPlayerInfo()
    end)
  end

  o:Init()
  o.im.Subscribe(bndPlayerList, function()
    o:publishPlayerRows()
  end)
  o.im.RegisterAction(ACT_PLAYER_SELECT, function(actionName, data)
    if data then
      o:publishPlayerDetail(data)
    end
  end)
  o.im.RegisterAction(ACT_HIDE, function(actionName, data)
    o:hidePanel()
  end)
  o.im.RegisterAction(ACT_RELEASE, function(actionName, data)
    o:releasePlayer()
  end)
  o.im.RegisterAction(ACT_TOGGLE, function(actionName, data)
    o:toggleView()
  end)
  
  return o
end

function TeamRoster:publishVisible()
  self.im.Publish("bnd_visible", self.visible)
  if self.panelvisible then
    self.im.Publish("bnd_rowvisible", false)
  else
    self.im.Publish("bnd_rowvisible", self.rowvisible)
  end
  self.im.Publish("bnd_panelvisible", self.panelvisible)
  self.im.Publish("bnd_panelanim", 0.0)
  self.im.Publish("bnd_plstat_visible", self.statvisible)
  self.im.Publish("bnd_plinfo_visible", self.infovisible)
  self.im.Publish("bnd_loading_visible", not self.visible)

  if self.panelvisible then
    local animValues = {0.1, 0.3, 0.4, 0.6, 0.7, 0.8, 1.0}

    -- Recursive function to handle animation steps
    local function setNextAnim(index)
      if index > #animValues then
        print("[TeamRoster]: Animation sequence completed")
        self.panelAnimTimer = nil -- Clean up
        return
      end

      local value = animValues[index]
      local delay = 0.05 -- 2 seconds for first step, 1 second for others

      self.panelAnimTimer = Timer:new({
        id = "panelAnimTimer_" .. index,
        interval = delay,
        reps = 1,
        onTimerComplete = function(id, repsCount)
          print(string.format("[TeamRoster]: Timer completed, setting bnd_panelanim to %.1f", value))
          self.im.Publish("bnd_panelanim", value)
          setNextAnim(index + 1) -- Move to next animation step
        end
      })
      self.panelAnimTimer:start()
      print(string.format("[TeamRoster]: Started %d-second timer to set bnd_panelanim to %.1f", delay, value))
    end

    -- Start the animation sequence
    setNextAnim(1)
  end
end

function TeamRoster:publishPlayerInfo(data)
  local suspStatus = "Eligible"
  local fitnessStatus = "Match Fit"
  local plgoals = 0
  local plcleansheets = 0
  local plyellowcard = 0
  local plredcard = 0
  if data then 
    self.im.Publish("bnd_player_avatar", {
      name = "$Head",
      id = data.CARD_ID
    })
    self.im.Publish("bnd_player_name", data.playerName)
    self.im.Publish("bnd_player_ID", data.CARD_ID)
    self.im.Publish("bnd_player_position", data.position)
    self.im.Publish("bnd_player_country", {
      name = "$Flag128x128",
      id = data.nationalityID
    })
    if isSuspended[data.CARD_ID] == 2 then
      fitnessStatus = "Injured. Back (" .. injuryRecoveryDate[data.CARD_ID] .. ")"
    elseif isSuspended[data.CARD_ID] == 1 then
      suspStatus = "Red Carded"
    end
    local playerInfo = getPlayerInfo(data.CARD_ID, currentSelectedTeamID)
    local Index = playerInfo and playerInfo.index
    local repCount = playerReplacementCount(currentSelectedTeamID, data.position)
    local days = daysLeftInTransferWindow(GLOBAL_DATE_PLACEHOLDER)
    local playervalue, minvalue = computeTransferValue(GetPlayerAge(data.CARD_ID), data.rating, data.position, Index, repCount, days)
    self.im.Publish("bnd_value", "$" .. self.loc.LocalizeInteger(playervalue))
    self.im.Publish("bnd_suspstatus", suspStatus)
    self.im.Publish("bnd_fitness", fitnessStatus)
    self.im.Publish("bnd_player_rating", data.rating)
    self.im.Publish("bnd_3d_player", {
      name = "$PLAYER_ID",
      id = data.CARD_ID
    })
    for i = 1, 6 do
      self.im.Publish("bnd_player_stat"..i, data["stat"..i])
    end
    plgoals = GOALS[data.CARD_ID] or 0
    plcleansheets = 0
    plyellowcard = yellowCardRecords[data.CARD_ID] or 0
    plredcard = redCardRecords[data.CARD_ID] or 0
    local stats = {plgoals, plcleansheets, plyellowcard, plredcard}
    for i = 1, 4 do
      self.im.Publish("bnd_dom" .. statsubs[i], stats[i])
      self.im.Publish("bnd_friendly" .. statsubs[i], 0)
      self.im.Publish("bnd_total" .. statsubs[i], stats[i])
    end
  end
end

-- 初始化数据
function TeamRoster:Init()
  local teamInfo = self.services.SquadManagementService.GetTeamInfo(TeamID)
  local teamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, TeamID, 0)
  
  -- Original logic to populate PlayerListData
  do
    do
      for _FORV_16_ = 1, table.getn(teamLineup) do
        local obj = {
          assetId = teamLineup[_FORV_16_].CARD_ID,
          clickAction = "act_player_select",
          playerInfo = teamLineup[_FORV_16_],
          data = {}
        }
        table.insert(PlayerListData, obj)
      end
    end
  end
end

function TeamRoster:publishPlayerRows()
  for i, v in ipairs(PlayerListData) do
    v.data.PlayerAvatar = {
      name = "$Head",
      id = PlayerListData[i].assetId
    }
    v.data.PlayerName = PlayerListData[i].playerInfo.playerName
    v.data.Rating = PlayerListData[i].playerInfo.rating
    v.data.clickAction = PlayerListData[i].clickAction
    v.data.FontColor = "0xffffff"
    v.data.Position = PlayerListData[i].playerInfo.position
  end
  self.im.Publish(bndPlayerList, PlayerListData)
  self.visible = true
  self:publishVisible()
  self:publishPlayerDetail({
    id = 0
  })
end

function TeamRoster:publishPlayerDetail(data)
  local playerIndex = data.id + 1
  self.oldIndex = self.currentIndex
  self.currentIndex = playerIndex
  if self.oldIndex == self.currentIndex then
    self.panelvisible = true
    self.im.Publish("bnd_panelvisible", self.panelvisible)
    self.im.Publish("bnd_rowvisible", false)
    self:publishVisible()
  end
  playerData = PlayerListData[playerIndex].playerInfo    
  self:publishPlayerInfo(playerData)  
end

function TeamRoster:hidePanel()
  self.panelvisible = false
  self.im.Publish("bnd_panelvisible", self.panelvisible)
  self.im.Publish("bnd_rowvisible", true)
  self:publishVisible()
end

function TeamRoster:toggleView()
  if toggle == false then
    self.im.Publish("bnd_plinfo_visible", false)
    self.im.Publish("bnd_plstat_visible", true)
    toggle = true
  else
    self.im.Publish("bnd_plinfo_visible", true)
    self.im.Publish("bnd_plstat_visible", false)
    toggle = false
  end
end

function TeamRoster:releasePlayer()
  releasePlayer(playerData.CARD_ID, currentSelectedTeamID)
  PlayerListData = {}
  self:Init()
  self:publishPlayerRows()
  self.panelvisible = false 
  self.im.Publish("bnd_panelvisible", self.panelvisible)
  self.im.Publish("bnd_rowvisible", true)
  self:publishVisible()
end

function TeamRoster:update(elapsedTime)
  if self.panelAnimTimer then
    self.panelAnimTimer:update(elapsedTime)
  end
end

function TeamRoster:finalize()
  if self.panelAnimTimer then
    self.panelAnimTimer:finalize()
    self.panelAnimTimer = nil
    print("[TeamRoster]: Panel anim timer finalized")
  end
  self.im.Unsubscribe("bnd_visible")
  self.im.Unsubscribe("bnd_loading_visible")
  self.im.Unsubscribe("bnd_team_crest")
  self.im.Unsubscribe("bnd_team_name")
  self.im.Unsubscribe("bnd_player_name")
  self.im.Unsubscribe("bnd_player_avatar")
  self.im.Unsubscribe("bnd_player_ID")
  self.im.Unsubscribe("bnd_player_position")
  self.im.Unsubscribe("bnd_player_country")
  self.im.Unsubscribe("bnd_player_rating")
  self.im.Unsubscribe("bnd_3d_player")
  for i = 1, 6 do
    self.im.Unsubscribe("bnd_player_stat"..i)
  end
  self.im.Unsubscribe(bndPlayerList)
  self.im.UnregisterAction(ACT_PLAYER_SELECT)
end

return TeamRoster