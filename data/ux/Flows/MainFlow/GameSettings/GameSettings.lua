-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local GameSettings = {}

local TabModel, EventManager, settings_service = ...
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local VOLUME_ID = settings_service.FE.UXService.BaseService.VOLUME_ID

local BND_IS_IN_GAME = "bnd_is_in_game"

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

local ACT_SAVE = "act_save"

function GameSettings:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

  o.isInGame = type(o.data) == "table" and o.data.ingame or false
  
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
  end)
  
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end)
  
  o.im.RegisterAction(ACT_SAVE, function()
    o:saveAndQuit()
  end)

  o.nav.AddActionHandler("saveSettings", false, nil, function()
    o:_triggerSaveSettings()
  end)
    
  return o
end

function GameSettings:saveAndQuit()
  self.nav.Event(nil, "evt_save_settings")
end

function GameSettings:_triggerSaveSettings()
  local touchControllerId = 4
  local customSaveSlot = 5
  local customPendingSaveSlot = 100
  if self.services.CustomizationService.HasPendingKeyboardMouseButtonChanges() then
    self.services.CustomizationService.SetCustomControllerSlot(touchControllerId, customSaveSlot)
    self.services.CustomizationService.SetKeyboardConfiguration(touchControllerId, customPendingSaveSlot)
  end
  self.services.SaveLoadService.CreateAndSendMessage(8)
end

function GameSettings:makeSettingsDataSnapshot()
  local controllerId = self.services.gameStateService.GetPreferedControllerId()
  self.customizationOptions = self.services.SettingsService.GetCustomizationOptions(controllerId)
  self.touchOptions = self.services.CustomizationService.GetTouchOptions(controllerId)
  self.gamepadConfig = self.services.CustomizationService.GetControllerConfiguration()  
  self.musicVolume = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.MUSIC_VOLUME_ID)
  self.gamefxVolume = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.GAMEFX_VOLUME_ID)
  self.commentaryVolume = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.COMMENTARY_VOLUME_ID)
  self.crowdVolume = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.CROWD_VOLUME_ID)
end

return GameSettings