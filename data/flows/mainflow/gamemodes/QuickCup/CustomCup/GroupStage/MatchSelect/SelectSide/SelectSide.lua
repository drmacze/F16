local KitSelect = {}

local bndHomeTeamData = "bnd_home_team_crest"
local bndAwayTeamData = "bnd_away_team_crest"
local bndAwayReadyLabelVisible = "bnd_away_ready_label_visible"
local bndAwayToggleVisible = "bnd_away_toggle_visible"
local bndAwaySelectingKitMsgVisible = "bnd_away_selecting_kit_msg_visible"
local bndHomeReadyLabelVisible = "bnd_home_ready_label_visible"
local bndHomeToggleVisible = "bnd_home_toggle_visible"
local bndHomeSelectingKitMsgVisible = "bnd_home_selecting_kit_msg_visible"
local bndLatency = "bnd_latency"
local bndLatencyVisible = "bnd_latency_visible"
local bndBackBtnText = "bnd_back_btn_text"
local BND_HOME_KITS = "bnd_home_kits"
local BND_AWAY_KITS = "bnd_away_kits"
local BND_HOME_KITS_INDEX = "bnd_home_kit_index"
local BND_AWAY_KITS_INDEX = "bnd_away_kit_index"
local ACT_HOME_CHANGE = "act_change_home"
local ACT_AWAY_CHANGE = "act_change_away"
local BND_TOGGLE_HOME_KIT_MESSAGE = "bnd_insToggleHomeKitMessage"
local BND_TOGGLE_AWAY_KIT_MESSAGE = "bnd_insToggleAwayKitMessage"
local bndAwayKitSelectorVisible = "bnd_away_kit_selector_visible"
local bndNoOpponentQuestionMarkVisible = "bnd_no_opponent_question_mark_visible"
local bndAwayMatchmakingMessageVisible = "bnd_away_matchmaking_message_visible"
local bndAwayTeamSelector = "bnd_away_team_selector"
local bndAwayLoadingVisible = "bnd_away_loading_visible"
local bnd3DPlayersVisible = "bnd_3d_players_visible"
local bnd2DKitsVisible = "bnd_2d_kits_visible"
local bnd2DHomeKit = "bnd_2d_home_kit"
local bnd3DHomeKit = "bnd_3d_home_kit"
local bnd2DAwayKit = "bnd_2d_away_kit"
local bnd3DAwayKit = "bnd_3d_away_kit"
local bnd2DHomeKit2 = "bnd_2d_home_kit2"
local bnd2DAwayKit2 = "bnd_2d_away_kit2"
local bnd2DHomeKit3 = "bnd_2d_home_kit3"
local bnd2DAwayKit3 = "bnd_2d_away_kit3"
local bnd2DHomeKit4 = "bnd_2d_home_kit4"
local bnd2DAwayKit4 = "bnd_2d_away_kit4"
local bndHomeKitAlpha = "bnd_home_kit_alpha"
local bndAwayKitAlpha = "bnd_away_kit_alpha"
local actAdvance = "act_advance"
local actBack = "act_back"
local actSettings = "act_settings"
local bndDif = "bnd_match_difficulty"
local actHomeKitPrevious = "act_home_kit_previous"
local actHomeKitNext = "act_home_kit_next"
local actAwayKitPrevious = "act_away_kit_previous"
local actAwayKitNext = "act_away_kit_next"
local BND_KIT_HOME_READY = "bnd_kit_home_ready"
local BND_KIT_AWAY_READY = "bnd_kit_away_ready"
local BND_ALL_READY = "bnd_all_ready"
local ACT_SELECTED = "act_selected"
local KIT_HOME = 1
local KIT_AWAY = 2
local ALL_READY = 3
local currentMatch = {
   HomeKitIndex = 0,
   AwayKitIndex = 1
}

function KitSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
    local tourId = GlobalTournamentSettings.tourId or 1
	
  o.services = {
    matchInfo = o.api("MatchInfoService"),
    settingsService = o.api("SettingsService"),
    UserPlate = o.api("UserPlateService"),
    MatchSetup = o.api("MatchSetupService"),
    GameSetup = o.api("GameSetupService"),
    GameState = o.api("GameStateService"),
    Pregame = o.api("PregameService"),
    LoggingService = o.api("LoggingService"),
    ClientServerService = o.api("ClientServerService"),
    EventManagerService = o.api("EventManagerService"),
    SaveLoadService = o.api("SaveLoadService")
  }
  o.nav = init.nav or {}
  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  
  o.homeTeamID = o.services.GameSetup.GetHomeAssetId()
  o.awayTeamID = o.services.GameSetup.GetAwayAssetId()
  local currentdata = nil
  o.TeamsData = o.services.matchInfo.GetMatchTeams()  
  o.im.Subscribe(bndHomeTeamData, function()
    o.im.Publish(bndHomeTeamData, {
      name = "$Crest",
      id = o.homeTeamID
    })
  end
  )
  o.im.Subscribe(bndAwayTeamData, function()
    o.im.Publish(bndAwayTeamData, {
      name = "$Crest",
      id = o.awayTeamID
    })
  end
  )

  o.homeTeamData = {
    { KITTYPE = 0, YEAR = 0, TEAMID = o.homeTeamID }, -- Home kit
    { KITTYPE = 1, YEAR = 0, TEAMID = o.homeTeamID }, -- Away kit
    { KITTYPE = 3, YEAR = 0, TEAMID = o.homeTeamID }, -- Third kit
    { KITTYPE = 4, YEAR = 0, TEAMID = o.homeTeamID }  -- Fourth kit
}
o.awayTeamData = {
    { KITTYPE = 0, YEAR = 0, TEAMID = o.awayTeamID }, -- Home kit
    { KITTYPE = 1, YEAR = 0, TEAMID = o.awayTeamID }, -- Away kit
    { KITTYPE = 3, YEAR = 0, TEAMID = o.awayTeamID }, -- Third kit
    { KITTYPE = 4, YEAR = 0, TEAMID = o.awayTeamID }  -- Fourth kit
}
  o.buttonsID = { KIT_HOME, KIT_AWAY, ALL_READY }
  o.im.Subscribe(BND_KIT_HOME_READY, function()
  end)
  o.im.Subscribe(BND_KIT_AWAY_READY, function()
  end)
  o.im.Subscribe(BND_ALL_READY, function()
  end)

  o.im.Subscribe(BND_TOGGLE_HOME_KIT_MESSAGE, function()
    o:publishHomeKitMessage()
  end
  )
  o.im.Subscribe(BND_TOGGLE_AWAY_KIT_MESSAGE, function()
    o:publishAwayKitMessage()
  end
  )
  o.im.Subscribe("bnd_home_team_name", function()
    o.im.Publish("bnd_home_team_name", o.TeamsData[1].teamName)
  end)
  o.im.Subscribe("bnd_away_team_name", function()
    o.im.Publish("bnd_away_team_name", o.TeamsData[2].teamName)
  end)
  o.im.Subscribe(bnd2DHomeKit, function()
    o:publish2DHomeKit(o.homeTeamData[1])
  end
  )
  o.im.Subscribe(bnd3DHomeKit, function()
    o:publish3DHomeKit(o.homeTeamData[1])
  end
  )
  o.im.Subscribe(bnd2DAwayKit, function()
    o:publish2DAwayKit(o.awayTeamData[2])
  end
  )
  o.im.Subscribe(bnd3DAwayKit, function()
    o:publish3DAwayKit(o.awayTeamData[2])
  end
  )
  o.im.Subscribe(bnd2DHomeKit2, function()
    o:publish2DHomeKit2(o.homeTeamData[3])
  end
  )
  o.im.Subscribe(bnd2DAwayKit2, function()
    o:publish2DAwayKit2(o.awayTeamData[3])
  end
  )
  o.im.Subscribe(bnd2DHomeKit3, function()
    o:publish2DHomeKit3(o.homeTeamData[2])
  end
  )
  o.im.Subscribe(bnd2DAwayKit3, function()
    o:publish2DAwayKit3(o.awayTeamData[1])
  end
  )
  o.im.Subscribe(bnd2DHomeKit4, function()
    o:publish2DHomeKit4(o.homeTeamData[4])
  end
  )
  o.im.Subscribe(bnd2DAwayKit4, function()
    o:publish2DAwayKit4(o.awayTeamData[4])
  end
  )
  
  o.im.Subscribe(bndHomeKitAlpha, function()
    o:publishHomeKitAlpha()
  end
  )
  o.im.Subscribe(bndAwayKitAlpha, function()
    o:publishAwayKitAlpha()
  end
  )
  o.im.RegisterAction(actHomeKitPrevious, function(actionName)
    o:changePreviousHomeKit()
  end
  )
  o.im.RegisterAction(actHomeKitNext, function(actionName)
    o:changeNextHomeKit()
  end
  )
  o.im.RegisterAction(actAwayKitPrevious, function(actionName)
    o:changePreviousAwayKit()
  end
  )
  o.im.RegisterAction(actAwayKitNext, function(actionName)
    o:changeNextAwayKit()
  end
  )
  o.im.RegisterAction(actAdvance, function(actionName, data)
    if o.services.GameState.IsGamepadControllerConnected() and not o.services.SaveLoadService.GetControllerUsed() then
      o.services.SaveLoadService.SetControllerUsed(true)
      o.services.SaveLoadService.CreateAndSendMessage(8)
      local buttonOk = {
        label = "Confirm",
        clickEvents = {
          "evt_hide_popup"
        },
        clickCallback = function()
          o:_advance()
        end
        
      }
      local buttonNo = {
        label = "Cancel",
        clickEvents = {
          "evt_hide_popup"
        }
      }
      local popupData = {
        title = "控制器连接",
        message = "控制器被检测到，你想用其作为你的操作方式吗?按“取消”将更改为“虚拟按钮”。",
        buttons = {buttonNo, buttonOk}
      }
      o.nav.Event(nil, "evt_show_popup", popupData)
    else
      o:_advance()
    end
  end
  )
  o.im.RegisterAction(actBack, function(actionName)
    o:_back()
  end
  )
  o.im.RegisterAction(actSettings, function(actionName, data)
    o.nav.Event(nil, "evt_to_settings")
  end
  )
  o.im.Subscribe(bndDif, function()
      o.im.Publish(bndDif, o.currentOptions.difficulty)
  end
  )

    o:HideSelections()
  o.im.Publish(BND_KIT_HOME_READY, true)
  o.im.RegisterAction(ACT_SELECTED, function(actionName, data)
    o:HideSelections()
    if o.buttonsID[data.buttonID + 1] == KIT_HOME then
      o.im.Publish(BND_KIT_HOME_READY, true)
    elseif o.buttonsID[data.buttonID + 1] == KIT_AWAY then
      o.im.Publish(BND_KIT_AWAY_READY, true)
    elseif o.buttonsID[data.buttonID + 1] == ALL_READY then
      o.im.Publish(BND_ALL_READY, true)
    end
  end)
  if o.nav and o.nav.Event then
  o.nav.Event(nil, "evt_advance")
else
  print("[DEBUG] nav atau nav.Event tidak tersedia, tidak bisa advance.")
end
  return o
end
function KitSelect:HideSelections()
  self.im.Publish(BND_KIT_HOME_READY, false)
  self.im.Publish(BND_KIT_AWAY_READY, false)
  self.im.Publish(BND_ALL_READY, false)
end
function KitSelect:publishHomeKitMessage()
    local currentHomeKitIndex = currentMatch.HomeKitIndex
    local toggleHomeMessage = ""
    
    if currentHomeKitIndex == 0 then
        toggleHomeMessage = "Home"
    elseif currentHomeKitIndex == 1 then
        toggleHomeMessage = "Away"
    elseif currentHomeKitIndex == 3 then
        toggleHomeMessage = "Third"
    elseif currentHomeKitIndex == 4 then
        toggleHomeMessage = "Fourth"
    end

    self.im.Publish(BND_TOGGLE_HOME_KIT_MESSAGE, toggleHomeMessage)
    self.services.GameSetup.SetPreferredKitId(0, self.homeTeamID * 4096 + currentHomeKitIndex)
end

function KitSelect:publishAwayKitMessage()
    local currentAwayKitIndex = currentMatch.AwayKitIndex
    local toggleAwayMessage = ""
    
    if currentAwayKitIndex == 0 then
        toggleAwayMessage = "Home"
    elseif currentAwayKitIndex == 1 then
        toggleAwayMessage = "Away"
    elseif currentAwayKitIndex == 3 then
        toggleAwayMessage = "Third"
    elseif currentAwayKitIndex == 4 then
        toggleAwayMessage = "Fourth"
    end

    self.im.Publish(BND_TOGGLE_AWAY_KIT_MESSAGE, toggleAwayMessage)
    self.services.GameSetup.SetPreferredKitId(1, self.awayTeamID * 4096 + currentAwayKitIndex)
end

function KitSelect:changePreviousHomeKit()
  local currentHomeKitIndex = currentMatch.HomeKitIndex
  if currentHomeKitIndex == 0 then
    currentMatch.HomeKitIndex = 4
    self:publish2DHomeKit(self.homeTeamData[4])
    self:publish3DHomeKit(self.homeTeamData[4])
    self:publish2DHomeKit2(self.homeTeamData[3])
    self:publish2DHomeKit3(self.homeTeamData[2])
    self:publish2DHomeKit4(self.homeTeamData[2])
  elseif currentHomeKitIndex == 1 then
    currentMatch.HomeKitIndex = 0 
    self:publish2DHomeKit(self.homeTeamData[1])
    self:publish3DHomeKit(self.homeTeamData[1])
    self:publish2DHomeKit2(self.homeTeamData[4])
    self:publish2DHomeKit3(self.homeTeamData[3])
    self:publish2DHomeKit4(self.homeTeamData[2])
  elseif currentHomeKitIndex == 3 then
    currentMatch.HomeKitIndex = 1
    self:publish2DHomeKit(self.homeTeamData[2])
    self:publish3DHomeKit(self.homeTeamData[2])
    self:publish2DHomeKit2(self.homeTeamData[1])
    self:publish2DHomeKit3(self.homeTeamData[4])
    self:publish2DHomeKit4(self.homeTeamData[3])
  elseif currentHomeKitIndex == 4 then
    currentMatch.HomeKitIndex = 3
    self:publish2DHomeKit(self.homeTeamData[3])
    self:publish3DHomeKit(self.homeTeamData[3])
    self:publish2DHomeKit2(self.homeTeamData[2])
    self:publish2DHomeKit3(self.homeTeamData[1])
    self:publish2DHomeKit4(self.homeTeamData[4])
  end
  self:publishHomeKitMessage()
end

function KitSelect:changeNextHomeKit()
  local currentHomeKitIndex = currentMatch.HomeKitIndex
  if currentHomeKitIndex == 0 then
    currentMatch.HomeKitIndex = 1
    self:publish2DHomeKit(self.homeTeamData[2])
    self:publish3DHomeKit(self.homeTeamData[2])
    self:publish2DHomeKit2(self.homeTeamData[1])
    self:publish2DHomeKit3(self.homeTeamData[4])
    self:publish2DHomeKit4(self.homeTeamData[3])
  elseif currentHomeKitIndex == 1 then
    currentMatch.HomeKitIndex = 3 
    self:publish2DHomeKit(self.homeTeamData[3])
    self:publish3DHomeKit(self.homeTeamData[3])
    self:publish2DHomeKit2(self.homeTeamData[2])
    self:publish2DHomeKit3(self.homeTeamData[1])
    self:publish2DHomeKit4(self.homeTeamData[4])
  elseif currentHomeKitIndex == 3 then
    currentMatch.HomeKitIndex = 4
    self:publish2DHomeKit(self.homeTeamData[4])
    self:publish3DHomeKit(self.homeTeamData[4])
    self:publish2DHomeKit2(self.homeTeamData[3])
    self:publish2DHomeKit3(self.homeTeamData[2])
    self:publish2DHomeKit4(self.homeTeamData[2])
  elseif currentHomeKitIndex == 4 then
    currentMatch.HomeKitIndex = 0
    self:publish2DHomeKit(self.homeTeamData[1])
    self:publish3DHomeKit(self.homeTeamData[1])
    self:publish2DHomeKit2(self.homeTeamData[4])
    self:publish2DHomeKit3(self.homeTeamData[3])
    self:publish2DHomeKit4(self.homeTeamData[2])
  end
  self:publishHomeKitMessage()
end

function KitSelect:changePreviousAwayKit()
  local currentAwayKitIndex = currentMatch.AwayKitIndex
  if currentAwayKitIndex == 0 then
    currentMatch.AwayKitIndex = 4
    self:publish2DAwayKit(self.awayTeamData[4])
    self:publish3DAwayKit(self.awayTeamData[4])
    self:publish2DAwayKit2(self.awayTeamData[3])
    self:publish2DAwayKit3(self.awayTeamData[2])
    self:publish2DAwayKit4(self.awayTeamData[2])
  elseif currentAwayKitIndex == 1 then
    currentMatch.AwayKitIndex = 0 
    self:publish2DAwayKit(self.awayTeamData[1])
    self:publish3DAwayKit(self.awayTeamData[1])
    self:publish2DAwayKit2(self.awayTeamData[4])
    self:publish2DAwayKit3(self.awayTeamData[3])
    self:publish2DAwayKit4(self.awayTeamData[2])
  elseif currentAwayKitIndex == 3 then
    currentMatch.AwayKitIndex = 1
    self:publish2DAwayKit(self.awayTeamData[2])
    self:publish3DAwayKit(self.awayTeamData[2])
    self:publish2DAwayKit2(self.awayTeamData[1])
    self:publish2DAwayKit3(self.awayTeamData[4])
    self:publish2DAwayKit4(self.awayTeamData[3])
  elseif currentAwayKitIndex == 4 then
    currentMatch.AwayKitIndex = 3
    self:publish2DAwayKit(self.awayTeamData[3])
    self:publish3DAwayKit(self.awayTeamData[3])
    self:publish2DAwayKit2(self.awayTeamData[2])
    self:publish2DAwayKit3(self.awayTeamData[1])
    self:publish2DAwayKit4(self.awayTeamData[4])
  end
  self:publishAwayKitMessage()
end

function KitSelect:changeNextAwayKit()
  local currentAwayKitIndex = currentMatch.AwayKitIndex
  if currentAwayKitIndex == 0 then
    currentMatch.AwayKitIndex = 1
    self:publish2DAwayKit(self.awayTeamData[2])
    self:publish3DAwayKit(self.awayTeamData[2])
    self:publish2DAwayKit2(self.awayTeamData[1])
    self:publish2DAwayKit3(self.awayTeamData[4])
    self:publish2DAwayKit4(self.awayTeamData[3])
  elseif currentAwayKitIndex == 1 then
    currentMatch.AwayKitIndex = 3 
    self:publish2DAwayKit(self.awayTeamData[3])
    self:publish3DAwayKit(self.awayTeamData[3])
    self:publish2DAwayKit2(self.awayTeamData[2])
    self:publish2DAwayKit3(self.awayTeamData[1])
    self:publish2DAwayKit4(self.awayTeamData[4])
  elseif currentAwayKitIndex == 3 then
    currentMatch.AwayKitIndex = 4
    self:publish2DAwayKit(self.awayTeamData[4])
    self:publish3DAwayKit(self.awayTeamData[4])
    self:publish2DAwayKit2(self.awayTeamData[3])
    self:publish2DAwayKit3(self.awayTeamData[2])
    self:publish2DAwayKit4(self.awayTeamData[2])
  elseif currentAwayKitIndex == 4 then
    currentMatch.AwayKitIndex = 0
    self:publish2DAwayKit(self.awayTeamData[1])
    self:publish3DAwayKit(self.awayTeamData[1])
    self:publish2DAwayKit2(self.awayTeamData[4])
    self:publish2DAwayKit3(self.awayTeamData[3])
    self:publish2DAwayKit4(self.awayTeamData[2])
  end
  self:publishAwayKitMessage()
end


function KitSelect:checkAdvance()
  if self.services.GameState.GetControllerSide(0) == 0 then
    if not self.services.GameState.IsGamepadControllerConnected() and not self.data.skipFE then
      return false
    else
      return true
    end
  end
  return true
end


function KitSelect:publish2DHomeKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DHomeKit, {name = "$Kits", id = kitId})
end

function KitSelect:publish3DHomeKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd3DHomeKit, {name = "$playerkits", id = kitId})
end

function KitSelect:publish2DAwayKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DAwayKit, {name = "$Kits", id = kitId})
end

function KitSelect:publish3DAwayKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd3DAwayKit, {name = "$playerkits", id = kitId})
end

function KitSelect:publish2DHomeKit2(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DHomeKit2, {name = "$Kits", id = kitId})
end
function KitSelect:publish2DAwayKit2(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DAwayKit2, {name = "$Kits", id = kitId})
end  
function KitSelect:publish2DHomeKit3(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DHomeKit3, {name = "$Kits", id = kitId})
end
function KitSelect:publish2DAwayKit3(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DAwayKit3, {name = "$Kits", id = kitId})
end  

function KitSelect:publish2DHomeKit4(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DHomeKit4, {name = "$Kits", id = kitId})
end
function KitSelect:publish2DAwayKit4(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DAwayKit4, {name = "$Kits", id = kitId})
end  

function KitSelect:publishHomeKitAlpha()
  self.im.Publish(bndHomeKitAlpha, self.userSide == self.USER_SIDE.HOME and self.userKitSelectorAlpha or self.opponentKitSelectorAlpha)
end

function KitSelect:publishAwayKitAlpha()
  self.im.Publish(bndAwayKitAlpha, self.userSide == self.USER_SIDE.AWAY and self.userKitSelectorAlpha or self.opponentKitSelectorAlpha)
end

function KitSelect:_doAdvance()
  self.nav.Event(nil, "evt_advance")
end
  
function KitSelect:_advance()
  self.im.ChangeActionState(actAdvance, self.im.GetActionState("INVALID"))
  self.im.ChangeActionState(actBack, self.im.GetActionState("INVALID"))
  self:_doAdvance()
end

function KitSelect:_back()
  self.nav.Event(nil, "evt_back")
end

function KitSelect:finalize()
  self.im.Unsubscribe(bndHomeTeamUser)
  self.im.Unsubscribe(bndHomeTeamData)
  self.im.Unsubscribe(bndAwayTeamData)
  self.im.Unsubscribe(bndAwayTeamUser)
  self.im.Unsubscribe(bndAwayReadyLabelVisible)
  self.im.Unsubscribe(bndAwayToggleVisible)
  self.im.Unsubscribe(bndAwaySelectingKitMsgVisible)
  self.im.Unsubscribe(bndHomeReadyLabelVisible)
  self.im.Unsubscribe(bndHomeToggleVisible)
  self.im.Unsubscribe(bndHomeSelectingKitMsgVisible)
  self.im.Unsubscribe(bndLatency)
  self.im.Unsubscribe(bndLatencyVisible)
  self.im.Unsubscribe(bndAwayKitSelectorVisible)
  self.im.Unsubscribe(bndNoOpponentQuestionMarkVisible)
  self.im.Unsubscribe(bndAwayMatchmakingMessageVisible)
  self.im.Unsubscribe(bndAwayTeamSelector)
  self.im.Unsubscribe(bndAwayLoadingVisible)
  self.im.Unsubscribe(bnd3DPlayersVisible)
  self.im.Unsubscribe(bnd2DKitsVisible)
  self.im.Unsubscribe(bnd2DHomeKit)
  self.im.Unsubscribe(bnd3DHomeKit)
  self.im.Unsubscribe(bnd2DAwayKit)
  self.im.Unsubscribe(bnd3DAwayKit)
  self.im.Unsubscribe(bnd2DHomeKit2)
  self.im.Unsubscribe(bnd2DAwayKit2)
  self.im.Unsubscribe(bnd2DHomeKit3)
  self.im.Unsubscribe(bnd2DAwayKit3)
  self.im.Unsubscribe(bnd2DHomeKit4)
  self.im.Unsubscribe(bnd2DAwayKit4)
  self.im.Unsubscribe(bndHomeKitAlpha)
  self.im.Unsubscribe(bndAwayKitAlpha)
  self.im.Unsubscribe(bndBackBtnText)
  self.im.UnregisterAction(actAdvance)
  self.im.UnregisterAction(actBack)
  self.im.UnregisterAction(actSettings)
  self.im.Unsubscribe(bndDif)
  self.im.UnregisterAction(actHomeKitPrevious)
  self.im.UnregisterAction(actHomeKitNext)
  self.im.UnregisterAction(actAwayKitPrevious)
  self.im.UnregisterAction(actAwayKitNext)
  self.im.UnregisterDataAction(BND_HOME_KITS_INDEX, ACT_HOME_CHANGE)
  self.im.UnregisterDataAction(BND_AWAY_KITS_INDEX, ACT_AWAY_CHANGE)
  self.im.Unsubscribe(BND_HOME_KITS)
  self.im.Unsubscribe(BND_AWAY_KITS)
end

return KitSelect