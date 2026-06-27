-- REMOD BY Icelee ID bilibili --
local VirtualButton, eventmanager, CommonNavVars = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes
local KitSelect = {}
local bndHomeTeamUser = "bnd_panel_home_title"
local bndAwayTeamUser = "bnd_panel_away_title"
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
local actHomeKitPrevious = "act_home_kit_previous"
local actHomeKitNext = "act_home_kit_next"
local actAwayKitPrevious = "act_away_kit_previous"
local actAwayKitNext = "act_away_kit_next"
function KitSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.navContext = o.data
  o.services = {
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
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end
  )
  o.services.LoggingService.Log("LUA", o.navContext.flow)
  o.services.LoggingService.Log("LUA", o.navContext.gamemode)
  o.USER_SIDE = {HOME = "home", AWAY = "away"}
  o.TOGGLE_DIRECTION = {PREVIOUS = 0, NEXT = 1}
  o.toggleIndexHome = 0
  o.toggleIndexAway = 1
  o.latency = 0
  o.latencyAverage = 0
  o.useDynamicKitSelection = false
  o.homeTeamData = {}
  o.awayTeamData = {}
  if (o.navContext.flow == CommonNavVars.FLOWS.ONLINE or o.navContext.flow == CommonNavVars.TYPES.FRIENDLY) and o.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
    o.useDynamicKitSelection = true
  else
    o.useDynamicKitSelection = false
  end
  o.userSide = o.USER_SIDE.HOME
  if o.navContext.flow == CommonNavVars.FLOWS.ONLINE or o.navContext.flow == CommonNavVars.TYPES.FRIENDLY then
    o.userSide = o.services.GameSetup.IsHostTeam() and o.USER_SIDE.HOME or o.USER_SIDE.AWAY
  end
  if o.navContext.flow == CommonNavVars.FLOWS.ONLINE and o.navContext.gamemode == CommonNavVars.GAMEMODES.REAL then
    o.services.Pregame.DisableSide(1)
  end
  o.listeningForLatencyUpdate = false
  o.showLatencyWarning = true
  o.latency = 2
  o.latencyAverage = 2
  if o.services ~= nil and o.services.Pregame ~= nil and o.services.Pregame.ListenLatencyUpdateEvents ~= nil then
    o.services.Pregame.ListenLatencyUpdateEvents()
    o.listeningForLatencyUpdate = true
  end
  local toggleHomeMessage = ""
  local toggleAwayMessage = ""
  if o.userSide == o.USER_SIDE.HOME then
    toggleHomeMessage = ("")
    toggleAwayMessage = ("")
  else
    toggleHomeMessage = ("")
    toggleAwayMessage = ("")
  end
  o.im.Subscribe(BND_TOGGLE_HOME_KIT_MESSAGE, function()
    o.im.Publish(BND_TOGGLE_HOME_KIT_MESSAGE, toggleHomeMessage)
  end
  )
  o.im.Subscribe(BND_TOGGLE_AWAY_KIT_MESSAGE, function()
    o.im.Publish(BND_TOGGLE_AWAY_KIT_MESSAGE, toggleAwayMessage)
  end
  )
  o.opponentIsReady = false
  o.userIsReady = false
  o.isSearchingOpponent = false
  o.opponentKitSelectorAlpha = 1
  o.userKitSelectorAlpha = 1
  o.unknownTeamData = {
    teamId = 0,
    teamName = "",
    crest = {name = "$Crest", id = "0"},
    starRating = 0,
    teamRating = {
      attackValue = 0,
      middleValue = 0,
      defenseValue = 0,
      attackLabel = att,
      middleLabel = mid,
      defenseLabel = def
    }
  }
  o.homeTeamData = o.services.MatchSetup.GetTeamKits(true)
  o.awayTeamData = o.services.MatchSetup.GetTeamKits(false)
  o.services.GameSetup.SetPreferredKitId(1, o.awayTeamData[1].ID)
  local userName = o.services.UserPlate.GetDisplayName()
  local opponentName = o.loc.LocalizeString("LTXT_FP_OPPONENT")
  local homeTeamName = o.userSide == o.USER_SIDE.HOME and userName or opponentName
  local awayTeamName = o.userSide == o.USER_SIDE.AWAY and userName or opponentName
  if o.navContext.flow == CommonNavVars.FLOWS.ONLINE and o.navContext.gamemode == CommonNavVars.GAMEMODES.REAL and homeTeamName == opponentName then
    homeTeamName = awayTeamName
    awayTeamName = opponentName
  end
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
  o.im.Subscribe(bndHomeTeamUser, function()
    o.im.Publish(bndHomeTeamUser, homeTeamName)
  end
  )
  o.im.Subscribe(bndAwayTeamUser, function()
    o.im.Publish(bndAwayTeamUser, awayTeamName)
  end
  )
  o.im.Subscribe(bndHomeTeamData, function()
    o.im.Publish(bndHomeTeamData, {
      name = "$Crest",
      id = string.format("%d", o.services.GameSetup.GetHomeAssetId())
    })
  end
  )
  o.im.Subscribe(bndAwayTeamData, function()
    o.im.Publish(bndAwayTeamData, {
      name = "$Crest",
      id = string.format("%d", o.services.GameSetup.GetAwayAssetId())
    })
  end
  )
  o.im.Subscribe(bndAwayReadyLabelVisible, function()
    o:publishAwayReadyLabelVisible()
  end
  )
  o.im.Subscribe(bndAwayToggleVisible, function()
    o:publishAwayToggleVisible()
  end
  )
  o.im.Subscribe(bndAwaySelectingKitMsgVisible, function()
    o:publishAwaySelectingKitMsgVisible()
  end
  )
  o.im.Subscribe(bndHomeReadyLabelVisible, function()
    o:publishHomeReadyLabelVisible()
  end
  )
  o.im.Subscribe(bndHomeToggleVisible, function()
    o:publishHomeToggleVisible()
  end
  )
  o.im.Subscribe(bndHomeSelectingKitMsgVisible, function()
    o:publishHomeSelectingKitMsgVisible()
  end
  )
  o.im.Subscribe(bndLatency, function()
    o:publishLatency()
  end
  )
  o.im.Subscribe(bndLatencyVisible, function()
    o:publishLatencyVisible()
  end
  )
  o.im.Subscribe(bndAwayTeamSelector, function()
    o.im.Publish(bndAwayTeamSelector, o.unknownTeamData)
  end
  )
  o.im.Subscribe(bndAwayKitSelectorVisible, function()
    o:publishAwayKitSelectorVisible()
  end
  )
  o.im.Subscribe(bndNoOpponentQuestionMarkVisible, function()
    o:publishNoOpponentQuestionMarkVisible()
  end
  )
  o.im.Subscribe(bndAwayMatchmakingMessageVisible, function()
    o:publishAwayMatchmakingMessageVisible()
  end
  )
  o.im.Subscribe(bndAwayLoadingVisible, function()
    o:publishAwayLoadingVisible()
  end
  )
  o.im.Subscribe(bnd3DPlayersVisible, function()
    o:publish3DPlayersVisible()
  end
  )
  o.im.Subscribe(bnd2DKitsVisible, function()
    o:publish2DKitsVisible()
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
  o.im.Subscribe(bndBackBtnText, function()
    o.im.Publish(bndBackBtnText, (""))
  end
  )
  o.im.Subscribe(BND_HOME_KITS, function()
    o:publishHomeKits()
  end
  )
  o.im.Subscribe(BND_AWAY_KITS, function()
    o:publishAwayKits()
  end
  )
  o.im.RegisterDataAction(BND_HOME_KITS_INDEX, ACT_HOME_CHANGE, function(bindingName, actionName, kitIndex)
    o:changeHomeKit(kitIndex)
  end
  )
  o.im.RegisterDataAction(BND_AWAY_KITS_INDEX, ACT_AWAY_CHANGE, function(bindingName, actionName, kitIndex)
    o:changeAwayKit(kitIndex)
  end
  )
  o.im.RegisterAction(actAdvance, function(actionName, data)
    if o.services.GameState.IsGamepadControllerConnected() and not o.services.SaveLoadService.GetControllerUsed() then
      o.services.SaveLoadService.SetControllerUsed(true)
      o.services.SaveLoadService.CreateAndSendMessage(8)
      local buttonOk = {
        label = "MATCH",
        clickEvents = {
          "evt_hide_popup"
        },
        clickCallback = function()
          o:_advance()
        end
        
      }
      local buttonNo = {
        label = "BACK",
        clickEvents = {
          "evt_hide_popup"
        }
      }
      local popupData = {
        title = "",
        message = "",
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
  if o.useDynamicKitSelection then
    o.services.Pregame.ListenKitSelectionEvents()
  end
  return o
end

function KitSelect:publishHomeKits()
  local data = {
    data = self.homeTeamData,
    index = 0
  }
  self.im.Publish(BND_HOME_KITS, data)
  self.services.GameSetup.SetPreferredKitId(0, self.homeTeamData[self.toggleIndexHome + 1].ID)
end

function KitSelect:publishAwayKits()
  local data = {
    data = self.awayTeamData,
    index = 1
  }
  self.im.Publish(BND_AWAY_KITS, data)
  self.services.GameSetup.SetPreferredKitId(1, self.awayTeamData[self.toggleIndexAway + 1].ID)
end

function KitSelect:changeHomeKit(kitIndex)
  print("[KitSelect][changeHomeKit] ", kitIndex)
  if kitIndex < self.toggleIndexHome then
    self:sendHomeKitData(self.TOGGLE_DIRECTION.PREVIOUS)
  else
    self:sendHomeKitData(self.TOGGLE_DIRECTION.NEXT)
  end
  self.toggleIndexHome = kitIndex
  self:publishTeamKit(0, self.homeTeamData[self.toggleIndexHome + 1])
end

function KitSelect:changeAwayKit(kitIndex)
  print("[KitSelect][changeAwayKit] ", kitIndex)
  self:publishTeamKit(1, self.awayTeamData[kitIndex + 1])
  if kitIndex < self.toggleIndexAway then
    self:sendAwayKitData(self.TOGGLE_DIRECTION.PREVIOUS)
  else
    self:sendAwayKitData(self.TOGGLE_DIRECTION.NEXT)
  end
  self.toggleIndexAway = kitIndex
  self:publishTeamKit(1, self.awayTeamData[self.toggleIndexAway + 1])
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

function KitSelect:handleEvent(eventType, data)
  if eventType == EventTypes.OnKitDataChanged then
    self:onKitDataChanged(data)
  elseif eventType == EventTypes.OnKitReady then
    self:onKitReady(data)
  elseif eventType == EventTypes.OnLatencyUpdated then
    self:onLatencyUpdated(data)
  elseif eventType == EventTypes.StoreVisibilityChanged then
    if data.storeIsOpen == true then
      self.im.ChangeActionState(actAdvance, self.im.GetActionState("INVALID"))
    else
      self.im.ChangeActionState(actAdvance, self.im.GetActionState("VALID"))
    end
  end
end

function KitSelect:onLatencyUpdated(latencyData)
  self.latency = latencyData.LATENCY
  self.latencyAverage = latencyData.LATENCYAVERAGE
  self.im.Refresh(bndLatency)
  if (self.navContext.flow == CommonNavVars.FLOWS.ONLINE or self.navContext.flow == CommonNavVars.TYPES.FRIENDLY) and self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
    if self.latencyAverage > 450 then
      local buttonBack = VirtualButton:new({
        nav = self.nav,
        icon = "$FooterIconBack",
        label = "BACK",
        clickEvents = {
          "evt_back",
          "evt_hide_popup"
        }
      })
      function buttonBack.clickCallback()
        self:_onExitingOnline()
      end
      
      local popupData = {
        title = "",
        message = "",
        buttons = {buttonBack}
      }
      self.nav.Event(nil, "evt_show_popup", popupData)
    elseif self.latencyAverage > 250 and self.showLatencyWarning then
      self.showLatencyWarning = false
      local buttonBack = VirtualButton:new({
        nav = self.nav,
        icon = "$FooterIconBack",
        label = "BACK",
        clickEvents = {
          "evt_back",
          "evt_hide_popup"
        }
      })
      function buttonBack.clickCallback()
        self:_onExitingOnline()
      end
      
      local buttonOK = VirtualButton:new({
        nav = self.nav,
        icon = "$FooterIconYes",
        label = "MATCH",
        clickEvents = {
          "evt_hide_popup"
        }
      })
      local popupData = {
        title = "",
        message = "",
        buttons = {buttonBack, buttonOK}
      }
      self.nav.Event(nil, "evt_show_popup", popupData)
    end
  end
end

function KitSelect:publish3DPlayersVisible()
  self.im.Publish(bnd3DPlayersVisible, false)
end

function KitSelect:publish2DKitsVisible()
  self.im.Publish(bnd2DKitsVisible, true)
end

function KitSelect:publishAwayReadyLabelVisible()
  local visible = false
  if self.userSide == self.USER_SIDE.HOME then
    if self.opponentIsReady and self.useDynamicKitSelection then
      visible = true
    end
  elseif self.userIsReady then
    visible = true
  end
  self.im.Publish(bndAwayReadyLabelVisible, visible)
end

function KitSelect:publishAwayToggleVisible()
  if self.userSide == self.USER_SIDE.AWAY then
    self.im.Publish(bndAwayToggleVisible, not self.userIsReady)
  else
    self.im.Publish(bndAwayToggleVisible, self.navContext.flow == CommonNavVars.FLOWS.OFFLINE)
  end
end

function KitSelect:publishAwaySelectingKitMsgVisible()
  local visible = false
  if self.userSide == self.USER_SIDE.HOME and not self.opponentIsReady and self.useDynamicKitSelection then
    visible = true
  end
  self.im.Publish(bndAwaySelectingKitMsgVisible, visible)
end

function KitSelect:publishHomeReadyLabelVisible()
  local visible = false
  if self.userSide == self.USER_SIDE.AWAY then
    if self.opponentIsReady and self.useDynamicKitSelection then
      visible = true
    end
  else
    visible = self.userIsReady
  end
  self.im.Publish(bndHomeReadyLabelVisible, visible)
end

function KitSelect:publishHomeToggleVisible()
  if self.userSide == self.USER_SIDE.HOME then
    self.im.Publish(bndHomeToggleVisible, not self.userIsReady)
  else
    self.im.Publish(bndHomeToggleVisible, self.navContext.flow == CommonNavVars.FLOWS.OFFLINE or self.navContext.flow == CommonNavVars.FLOWS.ONLINE and self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL)
  end
end

function KitSelect:publishHomeSelectingKitMsgVisible()
  local visible = false
  if self.userSide == self.USER_SIDE.AWAY and not self.opponentIsReady and self.useDynamicKitSelection then
    visible = true
  end
  self.im.Publish(bndHomeSelectingKitMsgVisible, visible)
end

function KitSelect:publishLatency()
  self.im.Publish(bndLatency, self.latency)
end

function KitSelect:publishLatencyVisible()
  self.im.Publish(bndLatencyVisible, self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT and (self.navContext.flow == CommonNavVars.FLOWS.ONLINE or self.navContext.flow == CommonNavVars.TYPES.FRIENDLY))
end

function KitSelect:publishAwayKitSelectorVisible()
  self.im.Publish(bndAwayKitSelectorVisible, self.useDynamicKitSelection or self.navContext.flow == CommonNavVars.FLOWS.OFFLINE)
end

function KitSelect:publishNoOpponentQuestionMarkVisible()
  self.im.Publish(bndNoOpponentQuestionMarkVisible, self.navContext.gamemode == CommonNavVars.GAMEMODES.REAL and self.navContext.flow == CommonNavVars.FLOWS.ONLINE)
end

function KitSelect:publishAwayMatchmakingMessageVisible()
  self.im.Publish(bndAwayMatchmakingMessageVisible, not self.isSearchingOpponent)
end

function KitSelect:publishAwayLoadingVisible()
  self.im.Publish(bndAwayLoadingVisible, self.isSearchingOpponent)
end

function KitSelect:publishTeamKit(side, kitData)
  if side == 0 then
    self:publish2DHomeKit(kitData)
    self:publish3DHomeKit(kitData)
    self.services.GameSetup.SetPreferredKitId(side, self.homeTeamData[self.toggleIndexHome + 1].ID)
  elseif side == 1 then
    self:publish2DAwayKit(kitData)
    self:publish3DAwayKit(kitData)
    self.services.GameSetup.SetPreferredKitId(side, self.awayTeamData[self.toggleIndexAway + 1].ID)
  else
    print("KitSelect:: Teamdata out of bounds.")
  end
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
  self.nav.Event(nil, "evt_advance")
end

function KitSelect:_advance()
  self.im.ChangeActionState(actAdvance, self.im.GetActionState("INVALID"))
  self.im.ChangeActionState(actBack, self.im.GetActionState("INVALID"))
  if self.navContext.flow == CommonNavVars.TYPES.FRIENDLY or self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT and (self.navContext.flow == CommonNavVars.FLOWS.ONLINE or self.navContext.flow == CommonNavVars.TYPES.FRIENDLY) then
    self.userIsReady = true
    self.userKitSelectorAlpha = self.userIsReady and 0.6 or 1
    if self.userSide == self.USER_SIDE.HOME then
      self:publishHomeToggleVisible()
      self:publishHomeReadyLabelVisible()
      self:publishHomeKitAlpha()
    else
      self:publishAwayToggleVisible()
      self:publishAwayReadyLabelVisible()
      self:publishAwayKitAlpha()
    end
  end
  if self.useDynamicKitSelection then
    local side = 1
    if self.services.GameSetup.IsHostTeam() then
      side = 0
    end
    local kitData = {}
    kitData.SIDE = side
    self.services.Pregame.HandleKitReady(kitData)
    if self.services.Pregame.AreBothSidesReady() then
      self:_doAdvance()
    end
  else
    self:_doAdvance()
  end
end

function KitSelect:_onExitingOnline()
  self.services.ClientServerService.LeavingPreGame()
end

function KitSelect:_back()
  if (self.navContext.flow == CommonNavVars.FLOWS.ONLINE or self.navContext.flow == CommonNavVars.TYPES.FRIENDLY) and self.navContext.gamemode == CommonNavVars.GAMEMODES.FUT then
    local buttonNo = VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconNo",
      label = "BACK",
      clickEvents = {
        "evt_hide_popup"
      }
    })
    local buttonYes = VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconYes",
      label = "MATCH",
      clickEvents = {
        "evt_back",
        "evt_hide_popup"
      }
    })
    function buttonYes.clickCallback()
      self:_onExitingOnline()
    end
    
    local popupData = {
      title = "",
      message = "",
      buttons = {buttonNo, buttonYes}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
  else
    self.nav.Event(nil, "evt_back")
  end
end

function KitSelect:sendKitData(side, direction)
  if self.useDynamicKitSelection == true then
    local kitData = {}
    kitData.DIRECTION = direction
    kitData.SIDE = side
    self.services.Pregame.HandleKitChange(kitData)
  end
end

function KitSelect:sendAwayKitData(direction)
  self:sendKitData(1, direction)
  self.services.GameSetup.ToggleAwayKit(direction)
  self:cancelAllReady()
end

function KitSelect:sendHomeKitData(direction)
  self:sendKitData(0, direction)
  self.services.GameSetup.ToggleHomeKit(direction)
  self:cancelAllReady()
end

function KitSelect:cancelAllReady()
  self.opponentIsReady = false
  self.userIsReady = false
  self.userKitSelectorAlpha = 1
  self.opponentKitSelectorAlpha = 1
  if self.userSide == self.USER_SIDE.HOME then
    self:publishAwaySelectingKitMsgVisible()
    self:publishHomeToggleVisible()
  else
    self:publishHomeSelectingKitMsgVisible()
    self:publishAwayToggleVisible()
  end
  self:publishHomeKitAlpha()
  self:publishAwayKitAlpha()
  self:publishHomeReadyLabelVisible()
  self:publishAwayReadyLabelVisible()
  self.im.ChangeActionState(actAdvance, self.im.GetActionState("VALID"))
  self.im.ChangeActionState(actBack, self.im.GetActionState("VALID"))
end

function KitSelect:onKitDataChanged(kitData)
  side = kitData.SIDE
  direction = kitData.DIRECTION
  self:cancelAllReady()
  if side == 0 then
    if direction == 0 then
      self.toggleIndexHome = (self.toggleIndexHome - 1) % table.getn(self.homeTeamData)
    else
      self.toggleIndexHome = (self.toggleIndexHome + 1) % table.getn(self.homeTeamData)
    end
    self:publishTeamKit(0, self.homeTeamData[self.toggleIndexHome + 1])
  else
    if direction == 0 then
      self.toggleIndexAway = (self.toggleIndexAway - 1) % table.getn(self.awayTeamData)
    else
      self.toggleIndexAway = (self.toggleIndexAway + 1) % table.getn(self.awayTeamData)
    end
    self:publishTeamKit(1, self.awayTeamData[self.toggleIndexAway + 1])
  end
end

function KitSelect:onKitReady(readyData)
  self.opponentIsReady = true
  self.opponentKitSelectorAlpha = self.opponentIsReady and 0.6 or 1
  if self.userSide == self.USER_SIDE.HOME then
    self:publishAwaySelectingKitMsgVisible()
    self:publishAwayReadyLabelVisible()
    self:publishAwayKitAlpha()
  else
    self:publishHomeSelectingKitMsgVisible()
    self:publishHomeReadyLabelVisible()
    self:publishHomeKitAlpha()
  end
  if self.services.Pregame.AreBothSidesReady() then
    self:_doAdvance()
  end
end

function KitSelect:finalize()
  self.opponentIsReady = false
  self.userIsReady = false
  self.isSearchingOpponent = false
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
  self.im.UnregisterAction(actHomeKitPrevious)
  self.im.UnregisterAction(actHomeKitNext)
  self.im.UnregisterAction(actAwayKitPrevious)
  self.im.UnregisterAction(actAwayKitNext)
  self.im.UnregisterDataAction(BND_HOME_KITS_INDEX, ACT_HOME_CHANGE)
  self.im.UnregisterDataAction(BND_AWAY_KITS_INDEX, ACT_AWAY_CHANGE)
  self.im.Unsubscribe(BND_HOME_KITS)
  self.im.Unsubscribe(BND_AWAY_KITS)
  if self.navContext.flow ~= CommonNavVars.FLOWS.ONLINE then
    self.im.Unsubscribe(BND_TOGGLE_HOME_KIT_MESSAGE)
    self.im.Unsubscribe(BND_TOGGLE_AWAY_KIT_MESSAGE)
  end
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  if self.useDynamicKitSelection then
    self.services.Pregame.UnlistenKitSelectionEvents()
  end
  if self.listeningForLatencyUpdate then
    self.services.Pregame.UnlistenLatencyUpdateEvents()
  end
end

return KitSelect
