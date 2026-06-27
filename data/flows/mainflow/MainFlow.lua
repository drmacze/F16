local FUTLoginManager, EventManager, VirtualButton, CardsErrors, sku_enums = ...
local MainFlow = {}
local LOGIN_STATUS = FUTLoginManager.FeCards.LoginStatus
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local FUT_SERVER_ERRORS = CardsErrors.FUT.FutServerError
local TERMINATION_REASON = sku_enums.fifaids.TerminationReason
local ACT_SHOW_USER_BIO = "act_show_shared_bio_user"
local ACT_SHOW_ITEM_CONTEXT = "act_show_item_context"
isInitalizeNotice = false
gamemode = nil

QuickCupGrouping = {}

currentCupData = {
    cupIndex = 0,
    homeID = 0,
    awayID = 0,
    maxMatchSize = 0,
    currentGroup = nil,
    currentStage = 0,
    isFinished = false
}
currentCupInfo = {}
currentMode = 0
ChallengeGrouping = {}
currentChallengeInfo = {}
currentChallengeData = {
   Index = 0,
   homeID = 0,
   awayID = 0,
   difficulty = 3,
   round = 1
}
LigaGrouping = {}
currentLigaInfo = {}
currentLigaData = {
   Index = 0,
   homeID = 0,
   awayID = 0,
   away2ID = 1,
   difficulty = 10,
   round = 1
}
squadTeamSelectInfo = nil
coachTeamSelectInfo = {
   HomeCountryIndex = 14,
   HomeLeagueIndex = 1,
   HomeTeamIndex = 20,
   AwayCountryIndex = 14,
   AwayLeagueIndex = 1,
   AwayTeamIndex = 19
}
playerTeamSelectInfo = {
  HomeCountryIndex = 29,
   HomeLeagueIndex = 1,
   HomeTeamIndex = 10,
   AwayCountryIndex = 29,
   AwayLeagueIndex = 1,
   AwayTeamIndex = 11
}
BeaproGrouping = {}
currentBeaproInfo = {}
currentBeaproData = {
   Index = 0,
   homeID = 0,
   awayID = 0,
   difficulty = 3,
   round = 1
}
currentDayMatchList = {}
currentMatchWeather = 0
currentPlayernibOption = 1
currentHudOption = 0
function MainFlow:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    UserPlateService = o.api("UserPlateService"),
    FUTUserInfoService = o.api("FUTUserInfoService"),
    EventManagerService = o.api("EventManagerService"),
    ClientServerService = o.api("ClientServerService"),
    GameStateService = o.api("GameStateService"),
    PowService = o.api("PowService"),
    DNFService = o.api("DNFService"),
    SettingsService = o.api("SettingsService"),
    NotificationService = o.api("NotificationService")
  }
  o.favoriteTeamID = -1
  o.requestFavoritesId = -1
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  o.im.Subscribe("bnd_backgrounds_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("Backgrounds")
  end)
  o.im.Subscribe("bnd_gamemodes_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("Gamemodes")
  end)
  o.im.Subscribe("bnd_game_play_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("GamePlay")
  end)
  o.im.Subscribe("bnd_widgets_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("Widgets")
  end)
  o.im.Subscribe("bnd_social_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("Social")
  end)
  o.im.Subscribe("bnd_message_center_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("MessageCenter")
  end)
  o.im.Subscribe("bnd_captured_media_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("CapturedMedia")
  end)
  o.im.Subscribe("bnd_extended_user_plate_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("ExtendedUserPlate")
  end)
  o.im.Subscribe("bnd_shared_user_plate_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("SharedUserPlate")
  end)
  o.im.Subscribe("bnd_accomplishments_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("Accomplishments")
  end)
  o.im.Subscribe("bnd_tutorials_layer_mouse_interactive", function()
    o:_publishLayerMouseInteraction("Tutorials")
  end)
  o.im.Subscribe("bnd_game_play_layer_visible", function()
    o:_publishGamePlayLayerVisiblity(true)
  end)
  local enabledUI
  o.nav.AddActionHandler("enableMainFlowLayerMouseInteraction", false, nil, function(actionName, layerName, enable, negateRest)
    o:enableLayerMouseInteraction(layerName, enable, negateRest)
  end)
  o.nav.AddActionHandler("checkPatchNotes", false, nil, function()
    o:checkPatchNotes()
  end)
  o.nav.AddActionHandler("checkExtendedLoginErrors", false, nil, function()
    o:checkExtendedLoginErrors()
  end)
  o.nav.AddActionHandler("requestFavorites", false, nil, function()
    o:_requestFavorites()
  end)
  o.nav.AddActionHandler("waitOnVictoryLogin", false, nil, function()
    o.services.ClientServerService.CheckVictoryLoginComplete()
  end)
  o.nav.AddActionHandler("checkActiveSquadLiveTileEnabled", false, nil, function()
    o:checkActiveSquadLiveTileEnabled()
  end)
  o.nav.AddActionHandler("checkDNF", false, nil, function(actionName)
    o:checkDNF()
  end)
  o.nav.AddActionHandler("checkAdData", false, nil, function(actionName)
    o:checkAdData()
  end)
  o.nav.AddActionHandler("checkLoginGift", false, nil, function(actionName)
    o:checkLoginGift()
  end)
  o.nav.AddActionHandler("showGamePlayHUDs", false, nil, function(actionName, visibility)
    o:showGamePlayHUDs(visibility)
  end)
  o.nav.AddActionHandler("checkUserUnderAgeMainHubFlow", false, nil, function(funcName)
    local isUserUnderAge = o.services.SettingsService.GetIsUserUnderAge()
    if isUserUnderAge == true then
      o.nav.Event(nil, "evt_skip_fb_login")
    else
      o.nav.Event(nil, "evt_to_fb_login")
    end
  end)
  o.nav.AddActionHandler("checkMainHubTutorialsComplete", false, nil, function(funcName)
    local tutorialsComplete = o.services.SettingsService.GetIsMainHubTutorialsComplete()
    if tutorialsComplete == true then
      o.nav.Event(nil, "evt_redirect_tutorial_complete")
    else
      o.nav.Event(nil, "evt_tutorial_incomplete")
    end
  end)
  o.nav.AddActionHandler("terminateProgramString", false, nil, function(funcName, reason)
    if reason == "Victory" then
      o.services.GameStateService.TerminateProgram(TERMINATION_REASON.VictoryDisconnection)
    elseif reason == "Origin" then
      o.services.GameStateService.TerminateProgram(TERMINATION_REASON.OriginIssues)
    elseif reason == "Jabber" then
      o.services.GameStateService.TerminateProgram(TERMINATION_REASON.JabberDisconnection)
    else
      o.services.GameStateService.TerminateProgram(TERMINATION_REASON.Unknown)
    end
  end)
  o.nav.AddActionHandler("checkFUTConnection", false, nil, function()
    local loginStatus = o.services.FUTUserInfoService.GetLoginStatus()
    if loginStatus == LOGIN_STATUS.LS_CONNECTED or loginStatus == LOGIN_STATUS.LS_CONNECTED_NEW_USER then
      o.nav.Event(nil, "evt_on_fut_connection_success")
    else
      o.nav.Event(nil, "evt_on_fut_connection_fail")
    end
  end)
  o.nav.AddActionHandler("isNewFutUser", false, nil, function()
    local loginStatus = o.services.FUTUserInfoService.GetLoginStatus()
    if loginStatus == LOGIN_STATUS.LS_CONNECTED_NEW_USER then
      o.nav.Event(nil, "evt_on_user_has_no_club")
    else
      o.nav.Event(nil, "evt_on_user_has_club")
    end
  end)
  o.nav.AddActionHandler("showFEUI", false, nil, function(action, gamemode)
    print(string.format("[MainFlow]: %s(%s)", action, gamemode or "nil"))
    if enabledUI == nil or enabledUI == "simulation" or enabledUI == "ftf" or enabledUI == "ingamesim" then
      o.nav.Event(nil, "evt_show_fe_widgets")
      enabledUI = "fe"
    end
    if gamemode == "real" then
      o.nav.Event(nil, "evt_show_match_credits")
    end
    o.nav.Event(nil, "evt_on_show_fe_ui_complete")
  end)
  o.nav.AddActionHandler("showInGameUI", false, nil, function(action, gamemode, flow, type, gameState)
    print(string.format("[MainFlow]: %s(gamemode = %s, flow = %s, type = %s, gameState = %s)", action, tostring(gamemode), tostring(flow), tostring(type), tostring(gameState)))
    if enabledUI == nil or enabledUI == "simulation" then
      o.nav.Event(nil, "evt_show_ingame_widgets", {
        gamemode = gamemode,
        flow = flow,
        type = type,
        gameState = gameState
      })
      o.nav.Event(nil, "evt_hide_social")
      if enabledUI == "simulation" then
        enabledUI = "ingamesim"
      else
        enabledUI = "ingame"
      end
    end
    if gamemode == "real" then
      o.nav.Event(nil, "evt_show_match_credits")
    end
    o.nav.Event(nil, "evt_on_show_in_game_ui_complete")
  end)
  o.nav.AddActionHandler("showSimUI", false, nil, function(action, gamemode, flow, type, gameState)
    print(string.format("[MainFlow]: %s(gamemode = %s, flow = %s, type = %s, gameState = %s)", action, tostring(gamemode), tostring(flow), tostring(type), tostring(gameState)))
    if enabledUI == nil or enabledUI == "fe" or enabledUI == "ingamesim" then
      o.nav.Event(nil, "evt_show_simulation_widgets", {
        gamemode = gamemode,
        flow = flow,
        type = type,
        gameState = gameState
      })
      enabledUI = "simulation"
    end
    o.nav.Event(nil, "evt_on_show_sim_ui_complete")
  end)
  o.nav.AddActionHandler("showFTFUI", false, nil, function(action, gamemode, flow, type, gameState)
    print(string.format("[MainFlow]: %s(gamemode = %s, flow = %s, type = %s, gameState = %s)", action, tostring(gamemode), tostring(flow), tostring(type), tostring(gameState)))
    if enabledUI == "fe" or enabledUI == nil then
      o.nav.Event(nil, "evt_show_ftf_widgets", {
        gamemode = gamemode,
        flow = flow,
        type = type,
        gameState = gameState
      })
      enabledUI = "ftf"
    end
  end)
  o.nav.AddActionHandler("showStageBackground", false, nil, function(action, context)
    o.nav.Event(nil, "evt_show_stage_background")
  end)
  o.nav.AddActionHandler("hideStageBackground", false, nil, function(action)
    o.nav.Event(nil, "evt_hide_background")
  end)
  o.nav.AddActionHandler("hideUI", false, nil, function(action, gamemode)
    print(string.format("[MainFlow]: %s(%s)", action, gamemode or "nil"))
    if gamemode == "real" then
      o.nav.Event(nil, "evt_hide_match_credits")
    else
      o.nav.Event(nil, "evt_hide_widgets")
      o.nav.Event(nil, "evt_hide_social")
    end
    enabledUI = nil
    o.nav.Event(nil, "evt_on_hide_ui_complete")
  end)
  o.nav.AddActionHandler("hideOverlays", false, nil, function()
    o.nav.Event(nil, "evt_hide_overlay")
    o.nav.Event(nil, "evt_exit_bio_hub")
    o.nav.Event(nil, "evt_exit_store")
    o.nav.Event(nil, "evt_exit_settings_customize")
    o.nav.Event(nil, "evt_exit_message_center")
  end)
  o.im.RegisterAction(ACT_SHOW_USER_BIO, function(actionName, data)
    local personaId = o.services.UserPlateService.GetPersonaId()
    if data.UUID_LOWER == personaId.lower and data.UUID_UPPER == personaId.upper then
      o.nav.Event(nil, "evt_to_user_bio", data)
    else
      o.nav.Event(nil, "evt_show_extended_user_bio", data)
    end
  end)
  o.im.RegisterAction(ACT_SHOW_ITEM_CONTEXT, function(actionName, data)
    o.nav.Event(nil, "evt_show_item_context", data)
  end)
  return o
end
function MainFlow:enableLayerMouseInteraction(layerName, enable, negateRest)
  print("[MainFlow]: enableLayerMouseInteraction(layerName = " .. tostring(layerName) .. ", enable = " .. tostring(enable) .. ")")
  self:_publishLayerMouseInteraction(layerName, enable, negateRest)
end
function MainFlow:checkPatchNotes()
  self.nav.Event(nil, "evt_on_check_patch_notes_false")
end
function MainFlow:checkActiveSquadLiveTileEnabled()
  self.nav.Event(nil, "evt_on_check_active_squad_live_tile_enabled_false")
end
function MainFlow:handleEvent(eventType, data)
  if eventType == EVENT_TYPES.UserPlateFavorites then
    self.favoriteTeamID = self.services.UserPlateService.GetFavoriteTeam()
  elseif eventType == EVENT_TYPES.ShowPopupWithOkButton then
    self:showPopupWithOkButton(data.title, data.message)
  end
end

-- Skip [ ©MVNPROD ]

function MainFlow:checkExtendedLoginErrors()
  local noVictoryServerNeeded = self.services.ClientServerService.NoVictoryServerNeeded()
  if noVictoryServerNeeded == false then
    self.nav.Event(nil, "evt_victory_login_skip")
    return
  end
  local isEntitlementCheckFail = self.services.ClientServerService.EntitlementCheckFailed()
  if isEntitlementCheckFail == true then
    local buttonOk = VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconYes",
      label = "LTXT_CMN_OK",
      clickEvents = {
        "evt_hide_warning"
      },
      clickCallback = function()
        self.services.GameStateService.TerminateProgram(TERMINATION_REASON.EntitlementCheckFail)
      end
    })
    local popupData = {
      title = "LTXT_PU_TITLE_BETA_PUBLIC_MESSAGE",
      message = "LTXT_PU_DESC1_BETA_PUBLIC_MESSAGE",
      autoEscape = false,
      buttons = {buttonOk}
    }
    self.nav.Event(nil, "evt_show_warning", popupData)
    self.nav.Event(nil, "evt_extendedLogin_fail")
    return
  end
  local victoryServerFail = self.services.ClientServerService.VictoryServerFailed()
  if victoryServerFail == true then
    local buttonOk = VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconYes",
      label = "LTXT_MOB_PU_RETRYCONNECT",
      clickEvents = {
        "evt_hide_warning"
      },
      clickCallback = function()
        self.nav.Event(nil, "evt_extendedLogin_fail_retry")
      end
    })
    local popupData = {
      title = "LTXT_PU_TITLE_BETA_PUBLIC_MESSAGE",
      message = "LTXT_FTF_NETWORK_ERROR",
      autoEscape = false,
      buttons = {buttonOk}
    }
    self.nav.Event(nil, "evt_show_warning", popupData)
    self.services.ClientServerService.ClearLoginInfo()
    return
  end
  local isServerVersionCheckFail = self.services.ClientServerService.VictoryServerVersionError()
  if isServerVersionCheckFail == true then
    local buttonOk = VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconYes",
      label = "LTXT_CMN_OK",
      clickCallback = function()
        self.services.ClientServerService.GoToUpdates()
      end
    })
    local popupData = {
      title = "LTXT_VERSION_OUT_OF_DATE_TITLE",
      message = "LTXT_VERSION_OUT_OF_DATE_DESC",
      autoEscape = false,
      buttons = {buttonOk}
    }
    self.nav.Event(nil, "evt_show_warning", popupData)
    self.nav.Event(nil, "evt_extendedLogin_fail")
    return
  end
  local isUserBanned = self.services.ClientServerService.VictoryUserBanned()
  if isUserBanned == true then
    local buttonOk = VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconYes",
      label = "LTXT_CMN_OK",
      clickEvents = {
        "evt_hide_warning"
      },
      clickCallback = function()
        self.services.GameStateService.TerminateProgram(TERMINATION_REASON.WrongClientVersion)
      end
    })
    local popupData = {
      title = "LTXT_ERROR_BANNED_PLAYER_TITLE",
      message = "LTXT_ERROR_BANNED_PLAYER_BODY",
      autoEscape = false,
      buttons = {buttonOk}
    }
    self.nav.Event(nil, "evt_show_warning", popupData)
    self.nav.Event(nil, "evt_extendedLogin_fail")
    return
  end
  local isUnderAgeUser = self.services.ClientServerService.VictoryUnderageUser()
  if isUnderAgeUser == true then
    local buttonOk = VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconYes",
      label = "LTXT_CMN_OK",
      clickEvents = {
        "evt_hide_warning"
      },
      clickCallback = function()
        self.services.GameStateService.TerminateProgram(TERMINATION_REASON.UnderAgeUser)
      end
    })
    local popupData = {
      title = "LTXT_PU_WARN_UNDERAGE_TITLE",
      message = "LTXT_PU_WARN_UNDERAGE_DESC",
      autoEscape = false,
      buttons = {buttonOk}
    }
    self.nav.Event(nil, "evt_show_warning", popupData)
    self.nav.Event(nil, "evt_extendedLogin_fail")
    return
  end
  self.nav.Event(nil, "evt_extendedLogin_success")
end
function MainFlow:checkDNF()
  local isDNFDisplayInfoKillSwitchOn = self.services.DNFService.IsDNFDisplayInfoKillSwitchOn()
  if isDNFDisplayInfoKillSwitchOn == false then
    local isLastGameDNF = self.services.DNFService.IsLastGameDNF()
    if isLastGameDNF == true then
      self.nav.Event(nil, "evt_on_check_dnf_true")
    else
      self.nav.Event(nil, "evt_on_check_dnf_false")
    end
  end
end
function MainFlow:showGamePlayHUDs(value)
  self:_publishGamePlayLayerVisiblity(value)
end
function MainFlow:_publishLayerMouseInteraction(layerName, enable, negateRest)
  local flag = enable
  local bindingMap = {
    Backgrounds = "bnd_backgrounds_layer_mouse_interactive",
    Gamemodes = "bnd_gamemodes_layer_mouse_interactive",
    GamePlay = "bnd_game_play_layer_mouse_interactive",
    Widgets = "bnd_widgets_layer_mouse_interactive",
    Social = "bnd_social_layer_mouse_interactive",
    MessageCenter = "bnd_message_center_layer_mouse_interactive",
    CapturedMedia = "bnd_captured_media_layer_mouse_interactive",
    ExtendedUserPlate = "bnd_extended_user_plate_layer_mouse_interactive",
    SharedUserPlate = "bnd_shared_user_plate_layer_mouse_interactive",
    Accomplishments = "bnd_accomplishments_layer_mouse_interactive",
    Tutorials = "bnd_tutorials_layer_mouse_interactive"
  }
  assert(bindingMap[layerName], "Unknown layer name in MainFlow: " .. tostring(layerName))
  if flag == nil then
    flag = true
  end
  for k, v in pairs(bindingMap) do
    if layerName == k then
      self.im.Publish(v, flag)
    elseif negateRest then
      self.im.Publish(v, not flag)
    end
  end
end
function dC(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end
function MainFlow:_publishGamePlayLayerVisiblity(visiblity)
  self.im.Publish("bnd_game_play_layer_visible", visiblity)
end
function MainFlow:showPopupWithOkButton(popupTitle, popupMessage)
  local buttonOk = VirtualButton:new({
    nav = self.nav,
    label = "LTXT_CMN_OK",
    clickEvents = {
      "evt_hide_popup"
    }
  })
  local popupData = {
    title = popupTitle,
    message = popupMessage,
    buttons = {buttonOk}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end
function MainFlow:checkAdData()
  print("MainFlow:checkAdData")
  local rawData = self.services.PowService.GetAdBannersByScreen("worldappstart")
  local isAvailable = self.services.PowService.IsLoginPopupEnabled()
  local nData = table.getn(rawData)
  self.services.PowService.SetLoginPopupStatus(false)
  if nData > 0 and isAvailable then
    print("MainFlow:checkAdData: evt_ad_data_available")
    self.nav.Event(nil, "evt_ad_data_available")
  else
    print("MainFlow:checkAdData: evt_ad_data_not_available")
    self.nav.Event(nil, "evt_ad_data_not_available")
  end
end
function MainFlow:checkLoginGift()
  local isAvailable = self.services.NotificationService.IsLoginGiftAvailable()
  if isAvailable then
    self.nav.Event(nil, "evt_login_gift_available")
  else
    self.nav.Event(nil, "evt_login_gift_not_available")
  end
end
function MainFlow:finalize()
  print("[MainFlow]: finalize()")
  self.im.Unsubscribe("bnd_backgrounds_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_gamemodes_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_game_play_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_widgets_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_social_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_message_center_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_captured_media_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_shared_user_plate_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_accomplishments_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_tutorials_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_extended_user_plate_layer_mouse_interactive")
  self.im.Unsubscribe("bnd_game_play_layer_visible")
  self.im.UnregisterAction(ACT_SHOW_USER_BIO)
  self.im.UnregisterAction(ACT_SHOW_ITEM_CONTEXT)
  self.nav.RemoveActionHandler("enableMainFlowLayerMouseInteraction")
  self.nav.RemoveActionHandler("checkPatchNotes")
  self.nav.RemoveActionHandler("checkFUTConnection")
  self.nav.RemoveActionHandler("showFEUI")
  self.nav.RemoveActionHandler("showInGameUI")
  self.nav.RemoveActionHandler("showSimUI")
  self.nav.RemoveActionHandler("showFTFUI")
  self.nav.RemoveActionHandler("hideUI")
  self.nav.RemoveActionHandler("showStageBackground")
  self.nav.RemoveActionHandler("hideStageBackground")
  self.nav.RemoveActionHandler("hideOverlays")
  self.nav.RemoveActionHandler("checkActiveSquadLiveTileEnabled")
  self.nav.RemoveActionHandler("isNewFutUser")
  self.nav.RemoveActionHandler("terminateProgramString")
  self.nav.RemoveActionHandler("waitOnVictoryLogin")
  self.nav.RemoveActionHandler("requestFavorites")
  self.nav.RemoveActionHandler("checkExtendedLoginErrors")
  self.nav.RemoveActionHandler("checkDNF")
  self.nav.RemoveActionHandler("checkAdData")
  self.nav.RemoveActionHandler("checkLoginGift")
  self.nav.RemoveActionHandler("showGamePlayHUDs")
  self.nav.RemoveActionHandler("checkUserUnderAgeMainHubFlow")
  self.nav.RemoveActionHandler("checkMainHubTutorialsComplete")
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
end
return MainFlow
