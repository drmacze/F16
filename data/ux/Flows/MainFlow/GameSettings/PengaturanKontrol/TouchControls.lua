-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local TouchControls = {}

local SettingsCustomizeModel = (...)
local TableUtil = (...)

----------------------------------------------------------------------------------------------
local bnd_touch_controls_list_data = "bnd_touch_controls_list_data"
----------------------------------------------------------------------------------------------

local bndControlSchemeOptions = "bnd_control_scheme_options"
local bndFloatingDpadOptions = "bnd_floating_dpad_options"
local bndVButtonPositionOptions = "bnd_virtual_button_position_options"
local bndSkillMovesOptions = "bnd_skill_moves_options"
local bndLargeButtonsOptions = "bnd_large_buttons_options"
local bndLargeDpadOptions = "bnd_large_dpad_options"
local bndLeftHandedOptions = "bnd_left_handed_options"

local actChangeControlSchemeOption = "act_change_control_scheme_option"
local actChangeFloatingDpadOption = "act_change_floating_dpad_option"
local actChangeVButtonPositionOption = "act_change_virtual_button_position_option"
local actChangeSkillMovesOption = "act_change_skill_moves_option"
local actChangeLargeButtonsOption = "act_change_large_buttons_option"
local actChangeLargeDpadOption = "act_change_large_dpad_option"
local actChangeLeftHandedOption = "act_change_left_handed_option"

local CONTROL_SCHEME_OPTION_INDEX = 1
local FLOATING_DPAD_OPTION_INDEX = 2
local VBUTTON_POSITION_OPTION_INDEX = 3
local SKILL_MOVES_OPTION_INDEX = 4
local LARGE_BUTTONS_OPTION_INDEX = 5
local LARGE_DPAD_OPTION_INDEX = 6
local LEFT_HANDED_OPTION_INDEX = 7

function TouchControls:new(init)
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
    FifaCustomizationService = o.api("FifaCustomizationService"),
    gameStateService = o.api("GameStateService")
  }
  
  o:initValues()

  ---------------------------------------------------------------------------
  o.im.Subscribe(bnd_touch_controls_list_data, function()
    o:publishTouchControlsListData()
  end)
  ---------------------------------------------------------------------------

  o.im.RegisterDataAction("bnd_control_scheme_index", actChangeControlSchemeOption, function(bindingName, actionName, index)
    o.controlSchemeIndex = index
    local controllerId = o.services.gameStateService.GetPreferedControllerId()
    o.services.FifaCustomizationService.SaveControlSchemeValue(controllerId, index)
    o:publishTouchControlsListData()
  end)
  o.im.RegisterAction(actChangeFloatingDpadOption, function(actionName, data)
    o:onFloatingDpadOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeVButtonPositionOption, function(actionName, data)
    o:onVButtonPositionOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeSkillMovesOption, function(actionName, data)
    o:onSkillMovesOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeLargeButtonsOption, function(actionName, data)
    o:onLargeButtonsOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeLargeDpadOption, function(actionName, data)
    o:onLargeDpadOptionChanged(data)
  end)
  o.im.RegisterAction(actChangeLeftHandedOption, function(actionName, data)
    o:onLeftHandedOptionChanged(data)
  end)

  o.im.Subscribe(bndControlSchemeOptions, function()
    o:publishControlSchemeOptions()
  end)
  o.im.Subscribe(bndFloatingDpadOptions, function()
    o:publishFloatingDpadOptions()
  end)
  o.im.Subscribe(bndVButtonPositionOptions, function()
    o:publishVButtonPositionOptions()
  end)
  o.im.Subscribe(bndSkillMovesOptions, function()
    o:publishSkillMovesOptions()
  end)
  o.im.Subscribe(bndLargeButtonsOptions, function()
    o:publishLargeButtonsOptions()
  end)
  o.im.Subscribe(bndLargeDpadOptions, function()
    o:publishLargeDpadOptions()
  end)
  o.im.Subscribe(bndLeftHandedOptions, function()
    o:publishLeftHandedOptions()
  end)

  return o
end

function TouchControls:initValues()
  local controllerId = self.services.gameStateService.GetPreferedControllerId()
  self.touchOptions = self.services.FifaCustomizationService.GetTouchOptions(controllerId)
  self:initControlSchemeData(self.touchOptions[CONTROL_SCHEME_OPTION_INDEX].data)
  self:initFloatingDpadData(self.touchOptions[FLOATING_DPAD_OPTION_INDEX].data)
  self:initVButtonPositionData(self.touchOptions[VBUTTON_POSITION_OPTION_INDEX].data)
  self:initSkillMovesData(self.touchOptions[SKILL_MOVES_OPTION_INDEX].data)
  self:initLargeButtonsData(self.touchOptions[LARGE_BUTTONS_OPTION_INDEX].data)
  self:initLargeDpadData(self.touchOptions[LARGE_DPAD_OPTION_INDEX].data)
  self:initLeftHandedData(self.touchOptions[LEFT_HANDED_OPTION_INDEX].data)
end

function TouchControls:initControlSchemeData(controlSchemeData)
  self.controlSchemeData = controlSchemeData
  self.controlSchemeData.rowChangeAction = actChangeControlSchemeOption
  self:setSelectedIndex(self.controlSchemeData)
  self.controlSchemeIndex = self.controlSchemeData.currentValue
end
function TouchControls:initFloatingDpadData(floatingDpadData)
  self.floatingDpadData = floatingDpadData
  self.floatingDpadData.currentValue = self:SettingToBoolean(self.floatingDpadData.currentValue)
  self.floatingDpadData.rowChangeAction = "act_change_floating_dpad_option"
  self:setSelectedIndex(self.floatingDpadData)
end
function TouchControls:initVButtonPositionData(vButtonPositionData)
  self.vButtonPositionData = vButtonPositionData
  self.vButtonPositionData.rowChangeAction = "act_change_virtual_button_position_option"
  self:setSelectedIndex(self.vButtonPositionData)
end
function TouchControls:initSkillMovesData(skillMovesData)
  self.skillMovesData = skillMovesData
  self.skillMovesData.currentValue = self:SettingToBoolean(self.skillMovesData.currentValue)
  self.skillMovesData.rowChangeAction = "act_change_skill_moves_option"
  self:setSelectedIndex(self.skillMovesData)
end
function TouchControls:initLargeButtonsData(largeButtonsData)
  self.largeButtonsData = largeButtonsData
  self.largeButtonsData.currentValue = self:SettingToBoolean(self.largeButtonsData.currentValue)
  self.largeButtonsData.rowChangeAction = "act_change_large_buttons_option"
  self:setSelectedIndex(self.largeButtonsData)
end
function TouchControls:initLargeDpadData(largeDpadData)
  self.largeDpadData = largeDpadData
  self.largeDpadData.currentValue = self:SettingToBoolean(self.largeDpadData.currentValue)
  self.largeDpadData.rowChangeAction = "act_change_large_dpad_option"
  self:setSelectedIndex(self.largeDpadData)
end
function TouchControls:initLeftHandedData(leftHandedData)
  self.leftHandedData = leftHandedData
  self.leftHandedData.currentValue = self:SettingToBoolean(self.leftHandedData.currentValue)
  self.leftHandedData.rowChangeAction = "act_change_left_handed_option"
  self:setSelectedIndex(self.leftHandedData)
end

function TouchControls:setSelectedIndex(optionData)
  local selectedIndex = self:GetValueIndex(optionData.data, optionData.currentValue)
  optionData.index = selectedIndex
end

function TouchControls:publishControlSchemeOptions()
  local dataList = {
    {
      text = self.controlSchemeData.data[1].name
    },
    {
      text = self.controlSchemeData.data[2].name
    }
  }
  local dataToPublish = {
    data = dataList,
    index = self.controlSchemeData.index
  }
  self.im.Publish(bndControlSchemeOptions, dataToPublish)
  self:publishTouchControlsListData()
end
function TouchControls:publishFloatingDpadOptions()
  self.im.Publish(bndFloatingDpadOptions, self.floatingDpadData)
end
function TouchControls:publishVButtonPositionOptions()
  self.im.Publish(bndVButtonPositionOptions, self.vButtonPositionData)
end
function TouchControls:publishSkillMovesOptions()
  self.im.Publish(bndSkillMovesOptions, self.skillMovesData)
end
function TouchControls:publishLargeButtonsOptions()
  self.im.Publish(bndLargeButtonsOptions, self.largeButtonsData)
end
function TouchControls:publishLargeDpadOptions()
  self.im.Publish(bndLargeDpadOptions, self.largeDpadData)
end
function TouchControls:publishLeftHandedOptions()
  self.im.Publish(bndLeftHandedOptions, self.leftHandedData)
end

function TouchControls:onControlSchemeOptionChanged(newOption)
  local newValue = newOption.value
  if self.controlSchemeData.currentValue ~= newValue then
    self.controlSchemeData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveControlSchemeValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function TouchControls:onFloatingDpadOptionChanged(newOption)
  local newValue = newOption.value
  if self.floatingDpadData.currentValue ~= newValue then
    self.floatingDpadData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveFloatingDpadValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function TouchControls:onVButtonPositionOptionChanged(newOption)
  local newValue = newOption.value
  if self.vButtonPositionData.currentValue ~= newValue then
    self.vButtonPositionData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveVButtonPositionValue(controllerId, newValue)
  end
end
function TouchControls:onSkillMovesOptionChanged(newOption)
  local newValue = newOption.value
  if self.skillMovesData.currentValue ~= newValue then
    self.skillMovesData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveSkillMovesValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function TouchControls:onLeftHandedOptionChanged(newOption)
  local newValue = newOption.value
  if self.leftHandedData.currentValue ~= newValue then
    self.leftHandedData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveLeftHandedValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function TouchControls:onLargeButtonsOptionChanged(newOption)
  local newValue = newOption.value
  if self.largeButtonsData.currentValue ~= newValue then
    self.largeButtonsData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveLargeButtonsValue(controllerId, self:BooleanToSetting(newValue))
  end
end
function TouchControls:onLargeDpadOptionChanged(newOption)
  local newValue = newOption.value
  if self.largeDpadData.currentValue ~= newValue then
    self.largeDpadData.currentValue = newValue
    local controllerId = self.services.gameStateService.GetPreferedControllerId()
    self.services.FifaCustomizationService.SaveLargeDpadValue(controllerId, self:BooleanToSetting(newValue))
  end
end

function TouchControls:publishTouchControlsListData()
  local dirtyIndices = {}
  local nRows = 10
  for i = 0, nRows do
    table.insert(dirtyIndices, i)
  end
  local dataList = {
    dirty = dirtyIndices,
    data = {
      {
        data = self.vButtonPositionData
      },
      {
        data = self.largeButtonsData
      },
      {
        data = self.largeDpadData
      },
      {
        data = self.skillMovesData
      },
      {
        data = self.floatingDpadData
      },
      {
        data = self.leftHandedData
      }
    }
  }
  self.im.Publish(bnd_touch_controls_list_data, dataList)
end

function TouchControls:BooleanToSetting(value)
  local setting = 1
  if value then
    setting = 0
  end
  return setting
end

function TouchControls:SettingToBoolean(value)
  local boolean = true
  if value == 1 then
    boolean = false
  end
  return boolean
end

function TouchControls:GetValueIndex(data, value)
  local i = 1
  while i <= #data and data[i].value ~= value do
    i = i + 1
  end
  return i - 1
end

return TouchControls