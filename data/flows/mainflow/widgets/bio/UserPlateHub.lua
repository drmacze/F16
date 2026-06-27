-- Thanks : Laosiji + Ma'ruf ID
-- Add New Setting By MVNPROD Youtube Channel --

local TableUtil = (...)
local customization = {}
local BND_MATCH_SETTINGS_LIST_DATA = "bnd_match_settings_list_data"

local bndAutoSwitchOptions = "bnd_auto_switch_options"
local bndAutoSwitchMoveAssistOptions = "bnd_auto_switch_move_assist_options"
local bndMoveAssistanceOptions = "bnd_move_assistance_options"
local bndHalfLengthOptions = "bnd_half_length_options"
local bndDifficultyOptions = "bnd_difficulty_options"
local bndCameraOptions = "bnd_camera_options"
local bndLargeButtonsOptions = "bnd_large_buttons_options"
local bndLargeDpadOptions = "bnd_large_dpad_options"
local bndLeftHandedOptions = "bnd_left_handed_options"
local bndCameraZoomValue = "bnd_camera_zoom_value"
local bndCameraHeightValue = "bnd_camera_height_value"
local bndOptionsIndex = "bnd_option_index"
local bndRightSideLabel = "bnd_right_label"
local bndRightSideImage = "bnd_right_image"

local actChangeAutoSwitchOption = "act_change_auto_switch_option"
local actChangeAutoSwitchMoveAssistOption = "act_change_auto_switch_move_assist_option"
local actChangeMoveAssistanceOption = "act_change_move_assistance_option"
local actChangeDifficultyOption = "act_change_difficulty_option"
local actChangeHalfLengthOption = "act_change_half_length_option"
local actChangeWeatherOption = "act_change_weather_option"
local actChangeCameraOption = "act_change_camera_option"
local actChangeLargeButtonsOption = "act_change_large_buttons_option"
local actChangeLargeDpadOption = "act_change_large_dpad_option"
local actChangeLeftHandedOption = "act_change_left_handed_option"
local actChangeCameraZoom = "act_change_camera_zoom"
local actChangeCameraHeight = "act_change_camera_height"
local actChangePlayernibOption = "act_change_playernib_option"
local actChangeHudOption = "act_change_hud_option"
local OPTION_TOGGLE_SFX = "act_option_toggle"

local AUTO_SWITCH_OPTION_INDEX = 1
local AUTO_SWITCH_MOVE_ASSIST_OPTION_INDEX = 2
local MOVE_ASSISTANCE_OPTION_INDEX = 3
local DIFFICULTY_OPTION_INDEX = 5
local HALF_LENGTH_OPTION_INDEX = 4
local CAMERA_OPTION_INDEX = 6
local LARGE_BUTTONS_OPTION_INDEX = 5
local LARGE_DPAD_OPTION_INDEX = 6
local LEFT_HANDED_OPTION_INDEX = 7

function customization:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    FifaCustomizationService = o.api("FifaCustomizationService"),
    settingsService = o.api("SettingsService"),
    gameStateService = o.api("GameStateService"),
    PauseMenuService = o.api("PauseMenuService")
  }
  o:initValues()

  o.im.RegisterAction(actChangeAutoSwitchOption, function(actionName, data)
    o:onAutoSwitchOptionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeAutoSwitchMoveAssistOption, function(actionName, data)
    o:onAutoSwitchMoveAssistOptionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeMoveAssistanceOption, function(actionName, data)
    o:onMoveAssistanceOptionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeDifficultyOption, function(actionName, data)
    o:onDifficultyOptionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeHalfLengthOption, function(actionName, data)
    o:onHalfLengthOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeWeatherOption, function(actionName, data)
    o:onWeatherOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeCameraOption, function(actionName, data)
    o:onCameraOptionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeLargeButtonsOption, function(actionName, data)
    o:onLargeButtonsOptionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeLargeDpadOption, function(actionName, data)
    o:onLargeDpadOptionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeLeftHandedOption, function(actionName, data)
    o:onLeftHandedOptionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeCameraZoom, function(actionName, data)
    o:onCameraZoomChanged(data)
  end
  )
  o.im.RegisterAction(actChangeCameraHeight, function(actionName, data)
    o:onCameraHeightChanged(data)
  end
  )
  o.im.RegisterAction(actChangePlayernibOption, function(actionName, data)
    o:onPlayernibOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeHudOption, function(actionName, data)
    o:onHudOptionChanged(data)
  end)

  o.im.Subscribe(BND_MATCH_SETTINGS_LIST_DATA, function()
    o:publishMatchSettingsListData()
  end
  )

  o.im.Subscribe(bndAutoSwitchOptions, function()
    o:publishAutoSwitchOptions()
  end
  )
  o.im.Subscribe(bndAutoSwitchMoveAssistOptions, function()
    o:publishAutoSwitchMoveAssistOptions()
  end
  )
  o.im.Subscribe(bndMoveAssistanceOptions, function()
    o:publishMoveAssistanceOptions()
  end
  )
  o.im.Subscribe(bndDifficultyOptions, function()
    o:publishDifficultyOptions()
  end
  )
  o.im.Subscribe(bndHalfLengthOptions, function()
    o:publishHalfLengthOptions()
  end)
  o.im.Subscribe(bndCameraOptions, function()
    o:publishCameraOptions()
  end
  )
  o.im.Subscribe(bndLargeButtonsOptions, function()
    o:publishLargeButtonsOptions()
  end
  )
  o.im.Subscribe(bndLargeDpadOptions, function()
    o:publishLargeDpadOptions()
  end
  )
  o.im.Subscribe(bndLeftHandedOptions, function()
    o:publishLeftHandedOptions()
  end
  )
  o.im.Subscribe(bndCameraZoomValue, function()
    o:publishCameraZoomValue()
  end
  )
  o.im.Subscribe(bndCameraHeightValue, function()
    o:publishCameraHeightValue()
  end
  )

  o.im.Subscribe(bndRightSideLabel, function()
    o:publishRightSideLabel()
  end
  )
  o.im.Subscribe(bndRightSideImage, function()
    o:publishRightSideImage()
  end
  )
  return o
end

function customization:initValues()
  local controllerId = self.services.gameStateService.GetPreferedControllerId()
  self.customizationOptions = self.services.settingsService.GetCustomizationOptions(controllerId)
  self:initAutoSwitchData(self.customizationOptions[AUTO_SWITCH_OPTION_INDEX].data)
  self:initAutoSwitchMoveAssistData(self.customizationOptions[AUTO_SWITCH_MOVE_ASSIST_OPTION_INDEX].data)
  self:initMoveAssistanceData(self.customizationOptions[MOVE_ASSISTANCE_OPTION_INDEX].data)
  self:initDifficultyData(self.customizationOptions[DIFFICULTY_OPTION_INDEX].data)
  self:initHalfLengthData(self.customizationOptions[HALF_LENGTH_OPTION_INDEX].data)
  self:initWeatherData(currentMatchWeather)
  self:initPlayernibData(currentPlayernibOption)
  self:initHudData(currentHudOption)
  self:initCameraData(self.customizationOptions[CAMERA_OPTION_INDEX].data)
  self.touchOptions = self.services.FifaCustomizationService.GetTouchOptions(controllerId)
  self:initLargeButtonsData(self.touchOptions[LARGE_BUTTONS_OPTION_INDEX].data)
  self:initLargeDpadData(self.touchOptions[LARGE_DPAD_OPTION_INDEX].data)
  self:initLeftHandedData(self.touchOptions[LEFT_HANDED_OPTION_INDEX].data)
end

function customization:initAutoSwitchData(autoSwitchData)
  self.autoSwitchData = autoSwitchData
  self.autoSwitchData.label= "Auto-Switch Assistance"
  self.autoSwitchData.rowChangeAction = "act_change_auto_switch_option"
  self:setSelectedIndex(self.autoSwitchData)
end
function customization:initAutoSwitchMoveAssistData(autoSwitchMoveAssistData)
  self.autoSwitchMoveAssistData = autoSwitchMoveAssistData
  self.autoSwitchMoveAssistData.label= "Auto-Switch Move Assistance"
  self.autoSwitchMoveAssistData.rowChangeAction = "act_change_auto_switch_move_assist_option"
  self:setSelectedIndex(self.autoSwitchMoveAssistData)
end
function customization:initMoveAssistanceData(moveAssistanceData)
  self.moveAssistanceData = moveAssistanceData
  self.moveAssistanceData.currentValue = self:SettingToBoolean(self.moveAssistanceData.currentValue)
  self.moveAssistanceData.label= "Auto-Movement Assistance"
  self.moveAssistanceData.rowChangeAction = "act_change_move_assistance_option"
  self.moveAssistanceData.clickSFX = OPTION_TOGGLE_SFX
  if self.services.PauseMenuService.IsOnlineGame() then
    self.moveAssistanceData.isEnabled = false
  else
    self.moveAssistanceData.isEnabled = true
  end
  self:setSelectedIndex(self.moveAssistanceData)
end
function customization:initDifficultyData(difficultyData)
  self.difficultyData = difficultyData
  self.difficultyData.rowChangeAction = "act_change_difficulty_option"
  self:setSelectedIndex(self.difficultyData)
end
function customization:initHalfLengthData(halfLengthData)
  self.halfLengthData = halfLengthData
  self.halfLengthData.rowChangeAction = "act_change_half_length_option"
  self:setSelectedIndex(self.halfLengthData)
end
function customization:initWeatherData(weatherData)
    local weatherdata = {
       currentValue = weatherData,
       data = {
            { value = 0, name = "Off" },
            { value = 1, name = "Random" },
            { value = 2, name = "Sunny" },
            { value = 3, name = "Little Fog" },
            { value = 4, name = "Dense Fog" },
            { value = 5, name = "Cloudy" },
            { value = 6, name = "Rainy" },
            { value = 7, name = "Winter" },
            { value = 8, name = "Snowy" }
       }
    }
    self.weatherData = weatherdata
    self.weatherData.label= "Weather"
    self.weatherData.rowChangeAction = "act_change_weather_option"
    self:setSelectedIndex(self.weatherData)
end
function customization:initCameraData(cameraData)
  self.cameraData = cameraData
  self.cameraData.rowChangeAction = "act_change_camera_option"
  self:setSelectedIndex(self.cameraData)
end
function customization:initLargeButtonsData(largeButtonsData)
  self.largeButtonsData = largeButtonsData
  self.largeButtonsData.currentValue = self:SettingToBoolean(self.largeButtonsData.currentValue)
  self.largeButtonsData.rowChangeAction = "act_change_large_buttons_option"
  self.largeButtonsData.clickSFX = OPTION_TOGGLE_SFX
  self:setSelectedIndex(self.largeButtonsData)
end
function customization:initLargeDpadData(largeDpadData)
  self.largeDpadData = largeDpadData
  self.largeDpadData.currentValue = self:SettingToBoolean(self.largeDpadData.currentValue)
  self.largeDpadData.rowChangeAction = "act_change_large_dpad_option"
  self.largeDpadData.clickSFX = OPTION_TOGGLE_SFX
  self:setSelectedIndex(self.largeDpadData)
end
function customization:initLeftHandedData(leftHandedData)
  self.leftHandedData = leftHandedData
  self.leftHandedData.currentValue = self:SettingToBoolean(self.leftHandedData.currentValue)
  self.leftHandedData.rowChangeAction = "act_change_left_handed_option"
  self.leftHandedData.clickSFX = OPTION_TOGGLE_SFX
  self:setSelectedIndex(self.leftHandedData)
end
function customization:initPlayernibData(playernibData)
    local playernibData = {
       currentValue = playernibData,
       data = {
            { value = 0, name = "Bottom Side " },
            { value = 1, name = "Bottom Center" },
            { value = 2, name = "Single [ Career ]" },
            { value = 3, name = "Hide" }
       }
    }
    self.playernibData = playernibData
    self.playernibData.label= "Nibs / Player Name"
    self.playernibData.rowChangeAction = "act_change_playernib_option"
    self:setSelectedIndex(self.playernibData)
end
function customization:initHudData(hudData)
    local hudData = {
       currentValue = hudData,
       data = {
            { value = 0, name = "Show" },
            { value = 1, name = "Hide" }
       }
    }
    self.hudData = hudData
    self.hudData.label= "HUD"
    self.hudData.rowChangeAction = "act_change_hud_option"
    self:setSelectedIndex(self.hudData)
end

function customization:setSelectedIndex(optionData)
  local selectedIndex = self:GetValueIndex(optionData.data, optionData.currentValue)
  optionData.index = selectedIndex
end

function customization:publishAutoSwitchOptions()
  self.im.Publish(bndAutoSwitchOptions, self.autoSwitchData)
end
function customization:publishAutoSwitchMoveAssistOptions()
  self.im.Publish(bndAutoSwitchMoveAssistOptions, self.autoSwitchMoveAssistData)
end
function customization:publishMoveAssistanceOptions()
  self.im.Publish(bndMoveAssistanceOptions, self.moveAssistanceData)
end
function customization:publishDifficultyOptions()
  self.im.Publish(bndDifficultyOptions, self.difficultyData)
end
function customization:publishHalfLengthOptions()
  self.im.Publish(bndHalfLengthOptions, self.halfLengthData)
end
function customization:publishCameraOptions()
  self.im.Publish(bndCameraOptions, self.cameraData)
end
function customization:publishLargeButtonsOptions()
  self.im.Publish(bndLargeButtonsOptions, self.largeButtonsData)
end
function customization:publishLargeDpadOptions()
  self.im.Publish(bndLargeDpadOptions, self.largeDpadData)
end
function customization:publishLeftHandedOptions()
  self.im.Publish(bndLeftHandedOptions, self.leftHandedData)
end
function customization:publishCameraZoomValue()
  local cameraZoom = self.services.settingsService.GetCurrentCameraZoom()
  self.im.Publish(bndCameraZoomValue, cameraZoom)
end
function customization:publishCameraHeightValue()
  local cameraHeight = self.services.settingsService.GetCurrentCameraHeight()
  self.im.Publish(bndCameraHeightValue, cameraHeight)
end

function customization:publishRightSideLabel()
  self.im.Publish(bndRightSideLabel, self.label)
end
function customization:publishRightSideImage()
  self.im.Publish(bndRightSideImage, {
    name = self.imagetype,
    id = self.imageID
  })
end

function customization:BooleanToSetting(value)
  local setting = 1
  if value then
    setting = 0
  end
  return setting
end
function customization:SettingToBoolean(value)
  local boolean = true
  if value == 1 then
    boolean = false
  end
  return boolean
end

function customization:onAutoSwitchOptionChanged(newOption)
  local newValue = newOption.value
  if self.autoSwitchData.currentValue ~= newValue then
    self.autoSwitchData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.settingsService.SaveAutoSwitchValue(controllerId, newValue)
  end
end
function customization:onAutoSwitchMoveAssistOptionChanged(newOption)
  local newValue = newOption.value
  if self.autoSwitchMoveAssistData.currentValue ~= newValue then
    self.autoSwitchMoveAssistData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.settingsService.SaveAutoSwichMoveAssistanceValue(controllerId, newValue)
  end
end
function customization:onMoveAssistanceOptionChanged(newOption)
  local newValue = newOption.value
  if self.moveAssistanceData.currentValue ~= newValue then
    self.moveAssistanceData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.settingsService.SaveMoveAssistanceValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function customization:onDifficultyOptionChanged(newOption)
  local newValue = newOption.value
  if self.difficultyData.currentValue ~= newValue then
    self.difficultyData.currentValue = newValue
    self.services.settingsService.SaveDifficultyValue(newValue)
  end
end
function customization:onHalfLengthOptionChanged(newOption)
  local newValue = newOption.value
  if self.halfLengthData.currentValue ~= newValue then
    self.halfLengthData.currentValue = newValue
    self.services.settingsService.SaveHalfLengthValue(newValue)
  end
end
function customization:onWeatherOptionChanged(newOption)
    local newValue = newOption.value
    if self.weatherData.currentValue ~= newValue then
      self.weatherData.currentValue = newValue
      currentMatchWeather = newValue
    end
  end
function customization:onCameraOptionChanged(newOption)
  local newValue = newOption.value
  if self.cameraData.currentValue ~= newValue then
    self.cameraData.currentValue = newValue
    self.services.settingsService.SaveCameraValue(newValue)
  end
end
function customization:onPlayernibOptionChanged(newOption)
    local newValue = newOption.value
    if self.playernibData.currentValue ~= newValue then
      self.playernibData.currentValue = newValue
      currentPlayernibOption = newValue
    end
  end
function customization:onHudOptionChanged(newOption)
    local newValue = newOption.value
    if self.hudData.currentValue ~= newValue then
      self.hudData.currentValue = newValue
      currentHudOption = newValue
    end
  end
function customization:onLargeButtonsOptionChanged(newOption)
  local newValue = newOption.value
  if self.largeButtonsData.currentValue ~= newValue then
    self.largeButtonsData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveLargeButtonsValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function customization:onLargeDpadOptionChanged(newOption)
  local newValue = newOption.value
  if self.largeDpadData.currentValue ~= newValue then
    self.largeDpadData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveLargeDpadValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function customization:onLeftHandedOptionChanged(newOption)
  local newValue = newOption.value
  if self.leftHandedData.currentValue ~= newValue then
    self.leftHandedData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveLeftHandedValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function customization:onCameraZoomChanged(newValue)
  self.services.settingsService.SaveCameraZoomValue(newValue)
end
function customization:onCameraHeightChanged(newValue)
  self.services.settingsService.SaveCameraHeightValue(newValue)
end

function customization:publishMatchSettingsListData(pDirtyIndices)
  local dirtyIndices = {}
  local nRows = 9
  if pDirtyIndices == nil or #pDirtyIndices == 0 then
    do
      for i = 0, nRows do
        table.insert(dirtyIndices, i)
      end
    end
  else
    dirtyIndices = pDirtyIndices
  end
  local dataList = {
    dirty = dirtyIndices,
    data = {
      {
        data = self.hudData
      },
      {
        data = self.weatherData
      },
      {
        data = self.playernibData
      }
    }
  }
  self.autoSwitchMoveAssistData.isEnabled = self.autoSwitchData.currentValue ~= 0
  self.im.Publish(BND_MATCH_SETTINGS_LIST_DATA, dataList)
end

function customization:GetValueIndex(data, value)
  local i = 1
  while i <= #data and data[i].value ~= value do
    i = i + 1
  end
  return i - 1
end

function customization:finalize()
  self.im.Unsubscribe(BND_MATCH_SETTINGS_LIST_DATA)

  self.im.Unsubscribe(bndAutoSwitchOptions)
  self.im.Unsubscribe(bndAutoSwitchMoveAssistOptions)
  self.im.Unsubscribe(bndMoveAssistanceOptions)
  self.im.Unsubscribe(bndDifficultyOptions)
  self.im.Unsubscribe(bndCameraOptions)
  self.im.Unsubscribe(bndLargeButtonsOptions)
  self.im.Unsubscribe(bndLargeDpadOptions)
  self.im.Unsubscribe(bndLeftHandedOptions)
  self.im.Unsubscribe(bndCameraZoomValue)
  self.im.Unsubscribe(bndCameraHeightValue)
  self.im.Unsubscribe(bndRightSideLabel)
  self.im.Unsubscribe(bndRightSideImage)

  self.im.UnregisterAction(actChangeAutoSwitchOption)
  self.im.UnregisterAction(actChangeAutoSwitchMoveAssistOption)
  self.im.UnregisterAction(actChangeMoveAssistanceOption)
  self.im.UnregisterAction(actChangeDifficultyOption)
  self.im.UnregisterAction(actChangeCameraOption)
  self.im.UnregisterAction(actChangeLargeButtonsOption)
  self.im.UnregisterAction(actChangeLargeDpadOption)
  self.im.UnregisterAction(actChangeLeftHandedOption)
  self.im.UnregisterAction(actChangeCameraZoom)
  self.im.UnregisterAction(actChangeCameraHeight)
  self.im.UnregisterAction(actChangeWeatherOption)
  self.im.UnregisterAction(actChangePlayernibOption)
  self.im.UnregisterAction(actChangeHudOption)
end

return customization

-- Modified By MVNPROD Youtube Channel --