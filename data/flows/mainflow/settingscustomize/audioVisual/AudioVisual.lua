local VirtualButton, EventManager, settings_service, SettingsCustomizeModel = ...
local BND_MUSIC_VALUE = "bnd_music_value"
local BND_FX_VALUE = "bnd_fx_value"
local BND_COMMENTARY_VALUE = "bnd_commentary_value"
local BND_CROWD_VALUE = "bnd_crowd_value"
local BND_USER_MUSIC_ENABLED = "bnd_user_music_enabled"
local BND_USERMUSIC_TOGGLE_ISCIRCULAR = "bnd_usermusic_toggle_iscircular"
local BND_USERMUSIC_YESNO = "bnd_usermusic_yesno"
local BND_TOGGLE_DEVICE_MUSIC_ENABLED = "bnd_toggle_device_music_enabled"
local BND_SPEECH_DOWNLOAD_VISIBILITY = "bnd_speech_download_visibility"
local BND_DOWNLOAD_SPEECH_DISABLE = "bnd_download_speech_disable"
local ACT_USERMUSIC_TOGGLE = "act_usermusic_toggle"
local BND_USERMUSIC_TOGGLE_INDEX = "bnd_userMusic_toggle_index"
local ACT_RESET = "act_reset_all"
local ACT_MUSIC_CHANGE = "act_music_change"
local ACT_FX_CHANGE = "act_fx_change"
local ACT_COMMENTARY_CHANGE = "act_commentary_change"
local ACT_CROWD_CHANGE = "act_crowd_change"
local ACT_DOWNLOAD_SPEECH = "act_show_speech_download_popup"
local DISABLESETTINGSACTIONS = "disableSettingActions"
local VOLUME_ID = settings_service.FE.UXService.BaseService.VOLUME_ID
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local FULL_SCREEN_MODE = 1
local AudioVisual = {}
function AudioVisual:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.models = {
    SettingsCustomizeModel = SettingsCustomizeModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc
    })
  }
  o.services = {
    SettingsService = o.api("SettingsService"),
    AudioService = o.api("AudioService"),
    GameStateService = o.api("GameStateService")
  }
  o.isInGame = o.services.GameStateService.IsInGame()
  print("[AudioVisual]: new(isInGame = " .. tostring(o.isInGame) .. ")")
  o.noyesList = {}
  table.insert(o.noyesList, {
    name = ("Off")
  })
  table.insert(o.noyesList, {
    name = ("On")
  })
  o.nodesIndex = o.services.AudioService.GetCurrentAudioSource()
  o.areControlsEnabled = o.nodesIndex == 0
  o.im.Subscribe(BND_MUSIC_VALUE, function()
    o:publishMusicValue()
  end
  )
  o.im.Subscribe(BND_FX_VALUE, function()
    o:publishFxValue()
  end
  )
  o.im.Subscribe(BND_COMMENTARY_VALUE, function()
    o:publishCommentaryValue()
  end
  )
  o.im.Subscribe(BND_CROWD_VALUE, function()
    o:publishCrowdValue()
  end
  )
  o.im.Subscribe(BND_USER_MUSIC_ENABLED, function()
    o:toggleControls(o.areControlsEnabled)
  end
  )
  o.im.Subscribe(BND_TOGGLE_DEVICE_MUSIC_ENABLED, function()
    o:toggleDeviceMusicControls(not o.areControlsEnabled)
  end
  )
  o.im.Subscribe(BND_DOWNLOAD_SPEECH_DISABLE, function()
    o:publishDownloadSpeechButton(not o.isInGame)
  end
  )
  o.im.Subscribe(BND_USERMUSIC_TOGGLE_ISCIRCULAR, function()
    o.im.Publish(BND_USERMUSIC_TOGGLE_ISCIRCULAR, false)
  end
  )
  o.im.Subscribe(BND_USERMUSIC_YESNO, function()
    o:publishUserMusic()
  end
  )
  o.im.RegisterDataAction(BND_USERMUSIC_TOGGLE_INDEX, ACT_USERMUSIC_TOGGLE, function(bindingName, actionName, kitIndex)
    o:changeUserMusic(kitIndex)
  end
  )
  o.im.RegisterAction(ACT_RESET, function()
    local title = "Reset"
    local desc = "Are you sure you want to reset back to the default settings?"
    function onConfirmAction()
      o.services.SettingsService.ResetAudioOptionValues()
      o.services.SettingsService.ResetVideoOptionValues()
      o:refreshAudioSettings()
    end
    
    o.models.SettingsCustomizeModel:showPopup(title, desc, onConfirmAction)
  end
  )
  o.im.RegisterAction(ACT_MUSIC_CHANGE, function(actionName, data)
    local value = math.ceil(data)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.MUSIC_VOLUME_ID, value)
    o:refreshAudioSettings()
  end
  )
  o.im.RegisterAction(ACT_FX_CHANGE, function(actionName, data)
    local value = math.ceil(data)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.GAMEFX_VOLUME_ID, value)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.PLAYER_CALLS_ID, value)
    o:refreshAudioSettings()
  end
  )
  o.im.RegisterAction(ACT_COMMENTARY_CHANGE, function(actionName, data)
    local value = math.ceil(data)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.COMMENTARY_VOLUME_ID, value)
    o:refreshAudioSettings()
  end
  )
  o.im.RegisterAction(ACT_CROWD_CHANGE, function(actionName, data)
    local value = math.ceil(data)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.CROWD_VOLUME_ID, value)
    o:refreshAudioSettings()
  end
  )
  o.nav.AddActionHandler(DISABLESETTINGSACTIONS, false, nil, function(action, gamemode)
    o:SetResetButtonEnabled("INVALID")
  end
  )
  function o.SystemMuscChangedListener(...)
    o:updateEnabledControls(...)
  end
  
  o.services.AudioService.RegisterListener(0, o.SystemMuscChangedListener)
  return o
end

function AudioVisual:toggleControls(enabled)
  self.im.Publish(BND_USER_MUSIC_ENABLED, enabled)
  self:toggleDeviceMusicControls(not enabled)
end

function AudioVisual:publishDownloadSpeechButton(enabled)
  self.im.Publish(BND_DOWNLOAD_SPEECH_DISABLE, enabled)
end

function AudioVisual:toggleDeviceMusicControls(enabled)
  self.im.Publish(BND_TOGGLE_DEVICE_MUSIC_ENABLED, enabled)
end

function AudioVisual:publishMusicValue()
  local value = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.MUSIC_VOLUME_ID)
  self.im.Publish(BND_MUSIC_VALUE, value)
end

function AudioVisual:publishFxValue()
  local value = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.GAMEFX_VOLUME_ID)
  self.im.Publish(BND_FX_VALUE, value)
end

function AudioVisual:publishCommentaryValue()
  local value = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.COMMENTARY_VOLUME_ID)
  self.im.Publish(BND_COMMENTARY_VALUE, value)
end

function AudioVisual:publishCrowdValue()
  local value = self.services.SettingsService.GetAudioOptionValue(VOLUME_ID.CROWD_VOLUME_ID)
  self.im.Publish(BND_CROWD_VALUE, value)
end

function AudioVisual:refreshAudioSettings()
  self:publishMusicValue()
  self:publishFxValue()
  self:publishCommentaryValue()
  self:publishCrowdValue()
end

function AudioVisual:GetValueIndex(data, value)
  local i = 1
  while i <= #data and data[i].value ~= value do
    i = i + 1
  end
  return i - 1
end

function AudioVisual:SetResetButtonEnabled(valid_state)
  self.im.ChangeActionState(ACT_RESET, self.im.GetActionState(valid_state))
  self.im.ChangeActionState(ACT_DOWNLOAD_SPEECH, self.im.GetActionState(valid_state))
end

function AudioVisual:publishUserMusic()
  local datatopublish = {
    data = self.noyesList,
    index = self.nodesIndex
  }
  self.im.Publish(BND_USERMUSIC_YESNO, datatopublish)
end

function AudioVisual:changeUserMusic(kitIndex)
  self.services.AudioService.OnToggleUserMusic(kitIndex)
end

function AudioVisual:updateEnabledControls(data)
  self.nodesIndex = data
  self.areControlsEnabled = data == 0
  self:publishUserMusic()
  self:toggleControls(self.areControlsEnabled)
end

function AudioVisual:finalize()
  if not self.isInGame then
    self.services.SettingsService.SaveVideoSettings()
  end
  self.im.Unsubscribe(BND_MUSIC_VALUE)
  self.im.Unsubscribe(BND_FX_VALUE)
  self.im.Unsubscribe(BND_CROWD_VALUE)
  self.im.Unsubscribe(BND_COMMENTARY_VALUE)
  self.im.Unsubscribe(BND_USER_MUSIC_ENABLED)
  self.im.Unsubscribe(BND_DOWNLOAD_SPEECH_DISABLE)
  self.im.UnregisterAction(ACT_RESET)
  self.im.UnregisterAction(ACT_MUSIC_CHANGE)
  self.im.UnregisterAction(ACT_FX_CHANGE)
  self.im.UnregisterAction(ACT_COMMENTARY_CHANGE)
  self.im.UnregisterAction(ACT_CROWD_CHANGE)
  self.im.Unsubscribe(BND_USERMUSIC_YESNO)
  self.im.UnregisterDataAction(BND_USERMUSIC_TOGGLE_INDEX, ACT_USERMUSIC_TOGGLE)
  self.im.Unsubscribe(BND_USERMUSIC_TOGGLE_ISCIRCULAR)
  self.im.Unsubscribe(BND_TOGGLE_DEVICE_MUSIC_ENABLED)
  self.nav.RemoveActionHandler(DISABLESETTINGSACTIONS)
  self.services.AudioService.UnRegisterListener(0)
end

return AudioVisual