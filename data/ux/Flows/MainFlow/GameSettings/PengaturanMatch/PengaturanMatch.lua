-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local PengaturanMatch = {}

local TableUtil = (...)

--------------------------------------------------------------------------------------------
local bnd_data_pengaturan_match = "bnd_data_pengaturan_match"
--------------------------------------------------------------------------------------------

local bndCameraOptions = "bnd_camera_options"
local bndAutoSwitchOptions = "bnd_auto_switch_options"
local bndAutoSwitchMoveAssistOptions = "bnd_auto_switch_move_assist_options"
local bndMoveAssistanceOptions = "bnd_move_assistance_options"
local bndDifficultyOptions = "bnd_difficulty_options"
local bndHalfLengthOptions = "bnd_half_length_options"

local actChangeCameraOption = "act_change_camera_option"
local actChangeAutoSwitchOption = "act_change_auto_switch_option"
local actChangeAutoSwitchMoveAssistOption = "act_change_auto_switch_move_assist_option"
local actChangeMoveAssistanceOption = "act_change_move_assistance_option"
local actChangeDifficultyOption = "act_change_difficulty_option"
local actChangeHalfLengthOption = "act_change_half_length_option"

local CAMERA_OPTION_INDEX = 6
local AUTO_SWITCH_OPTION_INDEX = 1
local AUTO_SWITCH_MOVE_ASSIST_OPTION_INDEX = 2
local MOVE_ASSISTANCE_OPTION_INDEX = 3
local DIFFICULTY_OPTION_INDEX = 5
local HALF_LENGTH_OPTION_INDEX = 4

function PengaturanMatch:new(init)
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

  ---------------------------------------------------------------------------
  o.im.Subscribe(bnd_data_pengaturan_match, function()
    o:publishPengaturanMatch()
  end)
  ---------------------------------------------------------------------------

  o.im.RegisterAction(actChangeCameraOption, function(actionName, data)
    o:onCameraOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeAutoSwitchOption, function(actionName, data)
    o:onAutoSwitchOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeAutoSwitchMoveAssistOption, function(actionName, data)
    o:onAutoSwitchMoveAssistOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeMoveAssistanceOption, function(actionName, data)
    o:onMoveAssistanceOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeDifficultyOption, function(actionName, data)
    o:onDifficultyOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeHalfLengthOption, function(actionName, data)
    o:onHalfLengthOptionChanged(data)
  end)
  
  o.im.Subscribe(bndCameraOptions, function()
    o:publishCameraOptions()
  end)
  o.im.Subscribe(bndAutoSwitchOptions, function()
    o:publishAutoSwitchOptions()
  end)
  o.im.Subscribe(bndAutoSwitchMoveAssistOptions, function()
    o:publishAutoSwitchMoveAssistOptions()
  end)
  o.im.Subscribe(bndMoveAssistanceOptions, function()
    o:publishMoveAssistanceOptions()
  end)
  o.im.Subscribe(bndDifficultyOptions, function()
    o:publishDifficultyOptions()
  end)
  o.im.Subscribe(bndHalfLengthOptions, function()
    o:publishHalfLengthOptions()
  end)
  
  return o
end

function PengaturanMatch:initValues()
  local controllerId = self.services.gameStateService.GetPreferedControllerId()
  self.customizationOptions = self.services.settingsService.GetCustomizationOptions(controllerId)
  self:initCameraData(self.customizationOptions[CAMERA_OPTION_INDEX].data)
  self:initAutoSwitchData(self.customizationOptions[AUTO_SWITCH_OPTION_INDEX].data)
  self:initAutoSwitchMoveAssistData(self.customizationOptions[AUTO_SWITCH_MOVE_ASSIST_OPTION_INDEX].data)
  self:initMoveAssistanceData(self.customizationOptions[MOVE_ASSISTANCE_OPTION_INDEX].data)
  self:initDifficultyData(self.customizationOptions[DIFFICULTY_OPTION_INDEX].data)
  self:initHalfLengthData(self.customizationOptions[HALF_LENGTH_OPTION_INDEX].data)
end

function PengaturanMatch:initCameraData(cameraData)
  self.cameraData = cameraData
  self.cameraData.rowChangeAction = "act_change_camera_option"
  self:setSelectedIndex(self.cameraData)
end
function PengaturanMatch:initAutoSwitchData(autoSwitchData)
  self.autoSwitchData = autoSwitchData
  self.autoSwitchData.rowChangeAction = "act_change_auto_switch_option"
  self:setSelectedIndex(self.autoSwitchData)
end
function PengaturanMatch:initAutoSwitchMoveAssistData(autoSwitchMoveAssistData)
  self.autoSwitchMoveAssistData = autoSwitchMoveAssistData
  self.autoSwitchMoveAssistData.rowChangeAction = "act_change_auto_switch_move_assist_option"
  self:setSelectedIndex(self.autoSwitchMoveAssistData)
end
function PengaturanMatch:initMoveAssistanceData(moveAssistanceData)
  self.moveAssistanceData = moveAssistanceData
  self.moveAssistanceData.currentValue = self:SettingToBoolean(self.moveAssistanceData.currentValue)
  self.moveAssistanceData.rowChangeAction = "act_change_move_assistance_option"
  self:setSelectedIndex(self.moveAssistanceData)
end
function PengaturanMatch:initDifficultyData(difficultyData)
  self.difficultyData = difficultyData
  self.difficultyData.rowChangeAction = "act_change_difficulty_option"
  self:setSelectedIndex(self.difficultyData)
end
function PengaturanMatch:initHalfLengthData(halfLengthData)
  self.halfLengthData = halfLengthData
  self.halfLengthData.rowChangeAction = "act_change_half_length_option"
  self:setSelectedIndex(self.halfLengthData)
end

function PengaturanMatch:setSelectedIndex(optionData)
  local selectedIndex = self:GetValueIndex(optionData.data, optionData.currentValue)
  optionData.index = selectedIndex
end

function PengaturanMatch:publishCameraOptions()
  self.im.Publish(bndCameraOptions, self.cameraData)
end
function PengaturanMatch:publishAutoSwitchOptions()
  self.im.Publish(bndAutoSwitchOptions, self.autoSwitchData)
end
function PengaturanMatch:publishAutoSwitchMoveAssistOptions()
  self.im.Publish(bndAutoSwitchMoveAssistOptions, self.autoSwitchMoveAssistData)
end
function PengaturanMatch:publishMoveAssistanceOptions()
  self.im.Publish(bndMoveAssistanceOptions, self.moveAssistanceData)
end
function PengaturanMatch:publishDifficultyOptions()
  self.im.Publish(bndDifficultyOptions, self.difficultyData)
end
function PengaturanMatch:publishHalfLengthOptions()
  self.im.Publish(bndHalfLengthOptions, self.halfLengthData)
end

function PengaturanMatch:onCameraOptionChanged(newOption)
  local newValue = newOption.value
  if self.cameraData.currentValue ~= newValue then
    self.cameraData.currentValue = newValue
    self.services.settingsService.SaveCameraValue(newValue)
  end
end
function PengaturanMatch:onAutoSwitchOptionChanged(newOption)
  local newValue = newOption.value
  if self.autoSwitchData.currentValue ~= newValue then
    self.autoSwitchData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.settingsService.SaveAutoSwitchValue(controllerId, newValue)
  end
end
function PengaturanMatch:onAutoSwitchMoveAssistOptionChanged(newOption)
  local newValue = newOption.value
  if self.autoSwitchMoveAssistData.currentValue ~= newValue then
    self.autoSwitchMoveAssistData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.settingsService.SaveAutoSwichMoveAssistanceValue(controllerId, newValue)
  end
end
function PengaturanMatch:onMoveAssistanceOptionChanged(newOption)
  local newValue = newOption.value
  if self.moveAssistanceData.currentValue ~= newValue then
    self.moveAssistanceData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.settingsService.SaveMoveAssistanceValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function PengaturanMatch:onDifficultyOptionChanged(newOption)
  local newValue = newOption.value
  if self.difficultyData.currentValue ~= newValue then
    self.difficultyData.currentValue = newValue
    self.services.settingsService.SaveDifficultyValue(newValue)
  end
end
function PengaturanMatch:onHalfLengthOptionChanged(newOption)
  local newValue = newOption.value
  if self.halfLengthData.currentValue ~= newValue then
    self.halfLengthData.currentValue = newValue
    self.services.settingsService.SaveHalfLengthValue(newValue)
  end
end

function PengaturanMatch:publishPengaturanMatch(pDirtyIndices)
  local dirtyIndices = {}
  local nRows = 10
  if pDirtyIndices == nil or #pDirtyIndices == 0 then
    for i = 0, nRows do
      table.insert(dirtyIndices, i)
    end
  else
    dirtyIndices = pDirtyIndices
  end
  local dataList = {
    dirty = dirtyIndices,
    data = {
      {
        data = self.cameraData
      },
      {
        data = self.autoSwitchData
      },
      {
        data = self.autoSwitchMoveAssistData
      },
      {
        data = self.moveAssistanceData
      },
      {
        data = self.difficultyData
      },
      {
        data = self.halfLengthData
      }
    }
  }
  self.autoSwitchMoveAssistData.isEnabled = self.autoSwitchData.currentValue ~= 0
  self.im.Publish(bnd_data_pengaturan_match, dataList)
end

function PengaturanMatch:BooleanToSetting(value)
  local setting = 1
  if value then
    setting = 0
  end
  return setting
end

function PengaturanMatch:SettingToBoolean(value)
  local boolean = true
  if value == 1 then
    boolean = false
  end
  return boolean
end

function PengaturanMatch:GetValueIndex(data, value)
  local i = 1
  while i <= #data and data[i].value ~= value do
    i = i + 1
  end
  return i - 1
end

return PengaturanMatch