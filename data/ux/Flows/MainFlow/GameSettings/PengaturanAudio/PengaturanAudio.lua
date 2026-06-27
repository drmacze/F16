-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local AudioVisual = {}

local VirtualButton, EventManager, settings_service, SettingsCustomizeModel = ...

local VOLUME_ID = settings_service.FE.UXService.BaseService.VOLUME_ID

local EVENT_TYPES = EventManager.FE.FIFA.EventTypes

local FULL_SCREEN_MODE = 1

local BND_MUSIC_VALUE = "bnd_music_value"
local BND_FX_VALUE = "bnd_fx_value"
local BND_COMMENTARY_VALUE = "bnd_commentary_value"
local BND_CROWD_VALUE = "bnd_crowd_value"

local BND_SPEECH_DOWNLOAD_VISIBILITY = "bnd_speech_download_visibility"
local BND_DOWNLOAD_SPEECH_DISABLE = "bnd_download_speech_disable"

local ACT_MUSIC_CHANGE = "act_music_change"
local ACT_FX_CHANGE = "act_fx_change"
local ACT_COMMENTARY_CHANGE = "act_commentary_change"
local ACT_CROWD_CHANGE = "act_crowd_change"

local ACT_DOWNLOAD_SPEECH = "act_show_speech_download_popup"

local DISABLESETTINGSACTIONS = "disableSettingActions"

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
  
  o.im.Subscribe(BND_MUSIC_VALUE, function()
    o:publishMusicValue()
  end)
  o.im.Subscribe(BND_FX_VALUE, function()
    o:publishFxValue()
  end)
  o.im.Subscribe(BND_COMMENTARY_VALUE, function()
    o:publishCommentaryValue()
  end)
  o.im.Subscribe(BND_CROWD_VALUE, function()
    o:publishCrowdValue()
  end)
  
  o.im.Subscribe(BND_DOWNLOAD_SPEECH_DISABLE, function()
    o:publishDownloadSpeechButton(not o.isInGame)
  end)
  
  o.im.RegisterAction(ACT_MUSIC_CHANGE, function(actionName, data)
    local value = math.ceil(data)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.MUSIC_VOLUME_ID, value)
    o:refreshAudioSettings()
  end)
  o.im.RegisterAction(ACT_FX_CHANGE, function(actionName, data)
    local value = math.ceil(data)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.GAMEFX_VOLUME_ID, value)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.PLAYER_CALLS_ID, value)
    o:refreshAudioSettings()
  end)
  o.im.RegisterAction(ACT_COMMENTARY_CHANGE, function(actionName, data)
    local value = math.ceil(data)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.COMMENTARY_VOLUME_ID, value)
    o:refreshAudioSettings()
  end)
  o.im.RegisterAction(ACT_CROWD_CHANGE, function(actionName, data)
    local value = math.ceil(data)
    o.services.SettingsService.SaveAudioOptionValue(VOLUME_ID.CROWD_VOLUME_ID, value)
    o:refreshAudioSettings()
  end)
  
  return o
end

function AudioVisual:publishDownloadSpeechButton(enabled)
  self.im.Publish(BND_DOWNLOAD_SPEECH_DISABLE, enabled)
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
  self.im.ChangeActionState(ACT_DOWNLOAD_SPEECH, self.im.GetActionState(valid_state))
end

return AudioVisual