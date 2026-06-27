-- MOD BY LAOSIJI --
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
function KitSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
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

  
  o.homeTeamID = currentMatch.HomeTeamID
  o.awayTeamID = currentMatch.AwayTeamID
  
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
    {
      KITTYPE = 0,
      YEAR = 0,
      TEAMID = o.homeTeamID
    },
    {
      KITTYPE = 1,
      YEAR = 0,
      TEAMID = o.homeTeamID
    }
  }
  o.awayTeamData = {
    {
      KITTYPE = 0,
      YEAR = 0,
      TEAMID = o.awayTeamID
    },
    {
      KITTYPE = 1,
      YEAR = 0,
      TEAMID = o.awayTeamID
    }
  }

  o.im.Subscribe(BND_TOGGLE_HOME_KIT_MESSAGE, function()
    o:publishHomeKitMessage()
  end
  )
  o.im.Subscribe(BND_TOGGLE_AWAY_KIT_MESSAGE, function()
    o:publishAwayKitMessage()
  end
  )

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
        label = "CONFIRM",
        clickEvents = {
          "evt_hide_popup"
        },
        clickCallback = function()
          o:_advance()
        end
        
      }
      local buttonNo = {
        label = "CANCEL",
        clickEvents = {
          "evt_hide_popup"
        }
      }
      local popupData = {
        title = "Controller Connection",
        message = "The controller has been detected, do you want to use it as your operating mode? Press Cancel to change to Virtual Button",
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
  return o
end

function KitSelect:publishHomeKitMessage()
  local currentHomeKitIndex = currentMatch.HomeKitIndex
  local toggleHomeMessage = ""
  if currentHomeKitIndex == 0 then
    toggleHomeMessage = "HOME"
  elseif currentHomeKitIndex == 1 then
    toggleHomeMessage = "AWAY"

  end
  self.im.Publish(BND_TOGGLE_HOME_KIT_MESSAGE, toggleHomeMessage)
end

function KitSelect:publishAwayKitMessage()
  local currentAwayKitIndex = currentMatch.AwayKitIndex
  local toggleAwayMessage = ""
  if currentAwayKitIndex == 0 then
    toggleAwayMessage = "HOME"
  elseif currentAwayKitIndex == 1 then
    toggleAwayMessage = "AWAY"

  end
  self.im.Publish(BND_TOGGLE_AWAY_KIT_MESSAGE, toggleAwayMessage)
end


function KitSelect:changePreviousHomeKit()
  local currentHomeKitIndex = currentMatch.HomeKitIndex
  if currentHomeKitIndex == 0 then
    currentMatch.HomeKitIndex = 1
    self:publish2DHomeKit(self.homeTeamData[2])
    self:publish3DHomeKit(self.homeTeamData[2])
    
  elseif currentHomeKitIndex == 1 then
    currentMatch.HomeKitIndex = 0 
    self:publish2DHomeKit(self.homeTeamData[1])
    self:publish3DHomeKit(self.homeTeamData[1])

  end
  self:publishHomeKitMessage()
end

function KitSelect:changeNextHomeKit()
  local currentHomeKitIndex = currentMatch.HomeKitIndex
  if currentHomeKitIndex == 0 then
    currentMatch.HomeKitIndex = 1
    self:publish2DHomeKit(self.homeTeamData[2])
    self:publish3DHomeKit(self.homeTeamData[2])
    
  elseif currentHomeKitIndex == 1 then
    currentMatch.HomeKitIndex = 0 
    self:publish2DHomeKit(self.homeTeamData[1])
    self:publish3DHomeKit(self.homeTeamData[1])

  end
  self:publishHomeKitMessage()
end

function KitSelect:changePreviousAwayKit()
  local currentAwayKitIndex = currentMatch.AwayKitIndex
  if currentAwayKitIndex == 0 then
    currentMatch.AwayKitIndex = 1
    self:publish2DAwayKit(self.awayTeamData[2])
    self:publish3DAwayKit(self.awayTeamData[2])
    
  elseif currentAwayKitIndex == 1 then
    currentMatch.AwayKitIndex = 0 
    self:publish2DAwayKit(self.awayTeamData[1])
    self:publish3DAwayKit(self.awayTeamData[1])
    
  end
  self:publishAwayKitMessage()
end

function KitSelect:changeNextAwayKit()
  local currentAwayKitIndex = currentMatch.AwayKitIndex
  if currentAwayKitIndex == 0 then
    currentMatch.AwayKitIndex = 1
    self:publish2DAwayKit(self.awayTeamData[2])
    self:publish3DAwayKit(self.awayTeamData[2])
    
  elseif currentAwayKitIndex == 1 then
    currentMatch.AwayKitIndex = 0 
    self:publish2DAwayKit(self.awayTeamData[1])
    self:publish3DAwayKit(self.awayTeamData[1])

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
  self.im.Publish(bnd3DHomeKit, {name = "$Kitss", id = kitId})
end

function KitSelect:publish2DAwayKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd2DAwayKit, {name = "$Kits", id = kitId})
end

function KitSelect:publish3DAwayKit(kitData)
  local kitId = string.format("%s_%s_%s", kitData.KITTYPE, kitData.TEAMID, kitData.YEAR)
  self.im.Publish(bnd3DAwayKit, {name = "$Kitss", id = kitId})
end



function KitSelect:publishHomeKitAlpha()
  self.im.Publish(bndHomeKitAlpha, self.userSide == self.USER_SIDE.HOME and self.userKitSelectorAlpha or self.opponentKitSelectorAlpha)
end

function KitSelect:publishAwayKitAlpha()
  self.im.Publish(bndAwayKitAlpha, self.userSide == self.USER_SIDE.AWAY and self.userKitSelectorAlpha or self.opponentKitSelectorAlpha)
end

function KitSelect:_doAdvance()
    local buttonNo = {
    icon = "$IconButton_O",
    label = "LTXT_CMN_NO",
    clickEvents = {
      "evt_hide_popup",
      "evt_refresh_on_resize"
    }
  }
  local buttonYes = {
    icon = "$IconButton_X",
    label = "LTXT_CMN_YES",
    clickEvents = {
      "evt_advance",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "PLAY MATCH",
    message = " ARE YOU READY TO PLAY THIS MATCH NOW ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
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