-- Thanks : Ma'ruf Id & Laosiji --
-- Modified MVN PROD --
-- @mvnprod.official - Remain Be Creative --

local TabModel, EventManager, settings_service = ...
local SettingsCustomize = {}
local BND_IS_IN_GAME = "bnd_is_in_game"
local BND_DEBUG_SETTINGS_TAB_VISIBILITY = "bnd_debug_settings_tab_visibility"
local BND_GAMEPLAY_SETTINGS_TAB_VISIBILITY = "bnd_gameplay_settings_tab_visibility"
local ACT_ACCEPT = "act_accept"
local ACT_CANCEL = "act_cancel"
local AUTO_SWITCH_OPTION_INDEX = 1
local AUTO_SWITCH_MOVE_ASSIST_OPTION_INDEX = 2
local MOVE_ASSISTANCE_OPTION_INDEX = 3
local CONTROL_SCHEME_OPTION_INDEX = 1
local FLOATING_DPAD_OPTION_INDEX = 2
local VBUTTON_POSITION_OPTION_INDEX = 3
local SKILL_MOVES_OPTION_INDEX = 4
local LARGE_BUTTONS_OPTION_INDEX = 5
local LARGE_DPAD_OPTION_INDEX = 6
local LEFT_HANDED_OPTION_INDEX = 7
local CONTROLLERID_GAMEPAD = 0
local VOLUME_ID = settings_service.FE.UXService.BaseService.VOLUME_ID
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
function SettingsCustomize:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.isInGame = type(o.data) == "table" and o.data.ingame or false
  print("[SettingsCustomize]: new(isInGame = " .. tostring(o.isInGame) .. ")")
  o.models = {
    TabModel = TabModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      binding = "bnd_settings_customize_tab_index",
      action = "setSettingsCustomizeTabContext"
    })
  }
  o.services = {
    SaveLoadService = o.api("SaveLoadService"),
    CustomizationService = o.api("FifaCustomizationService"),
    SettingsService = o.api("SettingsService"),
    gameStateService = o.api("GameStateService"),
    AudioService = o.api("AudioService"),
    EventManagerService = o.api("EventManagerService")
  }
  o:makeSettingsDataSnapshot()
  o.im.Subscribe(BND_IS_IN_GAME, function()
    o.im.Publish(BND_IS_IN_GAME, o.isInGame)
  end
  )
  o.nav.AddActionHandler("saveSettings", false, nil, function()
    o:_triggerSaveSettings()
  end
  )
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end
  )
  o.im.RegisterAction(ACT_ACCEPT, function()
    o:saveAndQuit()
  end
  )
  o.im.RegisterAction(ACT_CANCEL, function()
    o:quitAndRevert()
  end
  )
  o.debugTabVisibility = o.services.SettingsService.IsDebugSettingsTabVisible()
  o.im.Subscribe(BND_DEBUG_SETTINGS_TAB_VISIBILITY, function()
    o.im.Publish(BND_DEBUG_SETTINGS_TAB_VISIBILITY, o.debugTabVisibility)
  end
  )
  
  o.gameplayTabVisibility = o.services.SettingsService.IsGameplaySettingsTabVisible()
  o.im.Subscribe(BND_GAMEPLAY_SETTINGS_TAB_VISIBILITY, function()
    o.im.Publish(BND_GAMEPLAY_SETTINGS_TAB_VISIBILITY, o.gameplayTabVisibility)
  end
  )
  return o
end

function SettingsCustomize:saveAndQuit()
  print("[SettingsCustomize]: saveAndQuit()")
  self.nav.Event(nil, "evt_save_settings")
end

function SettingsCustomize:_triggerSaveSettings()
  local touchControllerId = 4
  local customSaveSlot = 5
  local customPendingSaveSlot = 100
  if self.services.CustomizationService.HasPendingKeyboardMouseButtonChanges() then
    self.services.CustomizationService.SetCustomControllerSlot(touchControllerId, customSaveSlot)
    self.services.CustomizationService.SetKeyboardConfiguration(touchControllerId, customPendingSaveSlot)
  end
  self.services.SaveLoadService.CreateAndSendMessage(8)
end

function SettingsCustomize:makeSettingsDataSnapshot()
  local controllerId = self.services.gameStateService.GetPreferedControllerId()
  self.customizationOptions = self.services.SettingsService.GetCustomizationOptions(controllerId)
  self.touchOptions = self.services.CustomizationService.GetTouchOptions(controllerId)
  self.gamepadConfig = self.services.CustomizationService.GetControllerConfiguration()
  self.musicVolume = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.MUSIC_VOLUME_ID)
  self.gamefxVolume = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.GAMEFX_VOLUME_ID)
  self.commentaryVolume = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.COMMENTARY_VOLUME_ID)
  self.crowdVolume = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.CROWD_VOLUME_ID)
  self.currentMusicSource = self.services.AudioService.GetCurrentAudioSource()
  self.pushNotificationsEnabled = self.services.SettingsService.GetPushNotesOn().pushOn
end

function SettingsCustomize:quitAndRevert()
  print("[SettingsCustomize]: quitAndRevert()")
  local controllerId = self.services.gameStateService.GetPreferedControllerId()
  self.services.SettingsService.SaveAutoSwitchValue(controllerId, self.customizationOptions[AUTO_SWITCH_OPTION_INDEX].data.currentValue)
  self.services.SettingsService.SaveAutoSwichMoveAssistanceValue(controllerId, self.customizationOptions[AUTO_SWITCH_MOVE_ASSIST_OPTION_INDEX].data.currentValue)
  self.services.SettingsService.SaveMoveAssistanceValue(controllerId, self.customizationOptions[MOVE_ASSISTANCE_OPTION_INDEX].data.currentValue)
  self.services.CustomizationService.SaveLargeButtonsValue(controllerId, self.touchOptions[LARGE_BUTTONS_OPTION_INDEX].data.currentValue)
  self.services.CustomizationService.SaveLargeDpadValue(controllerId, self.touchOptions[LARGE_DPAD_OPTION_INDEX].data.currentValue)
  self.services.CustomizationService.SaveLeftHandedValue(controllerId, self.touchOptions[LEFT_HANDED_OPTION_INDEX].data.currentValue)
  self.services.CustomizationService.SaveControlSchemeValue(controllerId, self.touchOptions[CONTROL_SCHEME_OPTION_INDEX].data.currentValue)
  self.services.CustomizationService.SaveFloatingDpadValue(controllerId, self.touchOptions[FLOATING_DPAD_OPTION_INDEX].data.currentValue)
  self.services.CustomizationService.SaveVButtonPositionValue(controllerId, self.touchOptions[VBUTTON_POSITION_OPTION_INDEX].data.currentValue)
  self.services.CustomizationService.SaveSkillMovesValue(controllerId, self.touchOptions[SKILL_MOVES_OPTION_INDEX].data.currentValue)
  self.services.CustomizationService.SetKeyboardConfiguration(CONTROLLERID_GAMEPAD, self.gamepadConfig)
  self.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.MUSIC_VOLUME_ID, self.musicVolume)
  self.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.GAMEFX_VOLUME_ID, self.gamefxVolume)
  self.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.PLAYER_CALLS_ID, self.gamefxVolume)
  self.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.COMMENTARY_VOLUME_ID, self.commentaryVolume)
  self.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.CROWD_VOLUME_ID, self.crowdVolume)
  self.services.AudioService.OnToggleUserMusic(self.currentMusicSource)
  self.services.SettingsService.SetPushNotesOn(self.pushNotificationsEnabled)
  self.nav.Event(nil, "evt_exit_settings_customize")
end

function SettingsCustomize:_handleEvent(eventType, data)
  if eventType == EVENT_TYPES.OnUserProfileLoaded then
    self.services.SaveLoadService.CreateAndSendMessage(2)
    self.nav.Event(nil, "evt_exit_settings_customize")
  end
end

function SettingsCustomize:finalize()
  print("[SettingsCustomize]: finalize()")
  self.models.TabModel:finalize()
  self.nav.RemoveActionHandler("saveSettings")
  self.im.Unsubscribe(BND_IS_IN_GAME)
  self.im.Unsubscribe(BND_DEBUG_SETTINGS_TAB_VISIBILITY)
  self.im.Unsubscribe(BND_GAMEPLAY_SETTINGS_TAB_VISIBILITY)
  self.im.UnregisterAction(ACT_ACCEPT)
  self.im.UnregisterAction(ACT_CANCEL)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
end

return SettingsCustomize

-- Thanks : Ma'ruf Id & Laosiji --
-- Modified MVN PROD --
-- @mvnprod.official - Remain Be Creative --