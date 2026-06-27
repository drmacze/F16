local TableUtil = (...)
local debugSettings = {}
local bndRenderResolution = "bnd_render_resolution"
local bndCrowdModeDefault = "bnd_crowd_mode_default"
local bndCrowdModeReplay = "bnd_crowd_mode_replay"
local bndCrowdModeNis = "bnd_crowd_mode_nis"
local bndCrowdModeHighlight = "bnd_crowd_mode_highlight"
local bndCrowdModeSetpiece = "bnd_crowd_mode_setpiece"
local BND_DEBUG_SETTINGS_LIST_DATA = "bnd_debug_settings_list_data"
local bndOptionsIndex = "bnd_option_index"
local bndRightSideLabel = "bnd_right_label"
local bndRightSideImage = "bnd_right_image"
local actChangeRenderResolution = "act_change_render_resolution"
local actChangeCrowdModeDefault = "act_change_crowd_mode_default"
local actChangeCrowdModeReplay = "act_change_crowd_mode_replay"
local actChangeCrowdModeNis = "act_change_crowd_mode_nis"
local actChangeCrowdModeHighlight = "act_change_crowd_mode_highlight"
local actChangeCrowdModeSetpiece = "act_change_crowd_mode_setpiece"
local DISABLESETTINGSACTIONS = "disableSettingActions"
local RENDER_RESOLUTION_INDEX = 1
local CROWD_MODE_INDEX_DEFAULT = 2
local CROWD_MODE_INDEX_REPLAY = 3
local CROWD_MODE_INDEX_NIS = 4
local CROWD_MODE_INDEX_HIGHLIGHT = 5
local CROWD_MODE_INDEX_SETPIECE = 6
local CrowdModeDefaultServiceIndex = 0
local CrowdModeReplayServiceIndex = 1
local CrowdModeNisServiceIndex = 2
local CrowdModeHighlightServiceIndex = 3
local CrowdModeSetpieceServiceIndex = 4
function debugSettings:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService"),
    gameStateService = o.api("GameStateService")
  }
  o:initValues()
  o.im.RegisterAction(actChangeRenderResolution, function(actionName, data)
    o:onRenderResolutionChanged(data)
  end
  )
  o.im.RegisterAction(actChangeCrowdModeDefault, function(actionName, data)
    o:onCrowdModeDefaultChanged(data)
  end
  )
  o.im.RegisterAction(actChangeCrowdModeReplay, function(actionName, data)
    o:onCrowdModeReplayChanged(data)
  end
  )
  o.im.RegisterAction(actChangeCrowdModeNis, function(actionName, data)
    o:onCrowdModeNisChanged(data)
  end
  )
  o.im.RegisterAction(actChangeCrowdModeHighlight, function(actionName, data)
    o:onCrowdModeHighlightChanged(data)
  end
  )
  o.im.RegisterAction(actChangeCrowdModeSetpiece, function(actionName, data)
    o:onCrowdModeSetpieceChanged(data)
  end
  )
  o.nav.AddActionHandler(DISABLESETTINGSACTIONS, false, nil, function(action, gamemode)
  end
  )
  o.im.Subscribe(bndRenderResolution, function()
    o:publishRenderResolution()
  end
  )
  o.im.Subscribe(bndCrowdModeDefault, function()
    o:publishCrowdModeDefault()
  end
  )
  o.im.Subscribe(bndCrowdModeReplay, function()
    o:publishCrowdModeReplay()
  end
  )
  o.im.Subscribe(bndCrowdModeNis, function()
    o:publishCrowdModeNis()
  end
  )
  o.im.Subscribe(bndCrowdModeHighlight, function()
    o:publishCrowdModeHighlight()
  end
  )
  o.im.Subscribe(bndCrowdModeSetpiece, function()
    o:publishCrowdModeSetpiece()
  end
  )
  o.im.Subscribe(BND_DEBUG_SETTINGS_LIST_DATA, function()
    o:publishDebugSettingsListData()
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

function debugSettings:initValues()
  self.customizationOptions = self.services.settingsService.GetDebugSetting()
  self:initRenderResolutionData(self.customizationOptions[RENDER_RESOLUTION_INDEX].data)
  self:initCrowdModeDefaultData(self.customizationOptions[CROWD_MODE_INDEX_DEFAULT].data)
  self:initCrowdModeReplayData(self.customizationOptions[CROWD_MODE_INDEX_REPLAY].data)
  self:initCrowdModeNisData(self.customizationOptions[CROWD_MODE_INDEX_NIS].data)
  self:initCrowdModeHighlightData(self.customizationOptions[CROWD_MODE_INDEX_HIGHLIGHT].data)
  self:initCrowdModeSetpieceData(self.customizationOptions[CROWD_MODE_INDEX_SETPIECE].data)
end

function debugSettings:initRenderResolutionData(renderResolutionData)
  self.renderResolutionData = renderResolutionData
  self.renderResolutionData.rowChangeAction = "act_change_render_resolution"
  self:setSelectedIndex(self.renderResolutionData)
end

function debugSettings:initCrowdModeDefaultData(crowdModeDefaultData)
  self.crowdModeDefaultData = crowdModeDefaultData
  self.crowdModeDefaultData.rowChangeAction = "act_change_crowd_mode_default"
  self:setSelectedIndex(self.crowdModeDefaultData)
end

function debugSettings:initCrowdModeReplayData(crowdModeReplayData)
  self.crowdModeReplayData = crowdModeReplayData
  self.crowdModeReplayData.rowChangeAction = "act_change_crowd_mode_replay"
  self:setSelectedIndex(self.crowdModeReplayData)
end

function debugSettings:initCrowdModeNisData(crowdModeNisData)
  self.crowdModeNisData = crowdModeNisData
  self.crowdModeNisData.rowChangeAction = "act_change_crowd_mode_nis"
  self:setSelectedIndex(self.crowdModeNisData)
end

function debugSettings:initCrowdModeHighlightData(crowdModeHighlightData)
  self.crowdModeHighlightData = crowdModeHighlightData
  self.crowdModeHighlightData.rowChangeAction = "act_change_crowd_mode_highlight"
  self:setSelectedIndex(self.crowdModeHighlightData)
end

function debugSettings:initCrowdModeSetpieceData(crowdModeSetpieceData)
  self.crowdModeSetpieceData = crowdModeSetpieceData
  self.crowdModeSetpieceData.rowChangeAction = "act_change_crowd_mode_setpiece"
  self:setSelectedIndex(self.crowdModeSetpieceData)
end

function debugSettings:setSelectedIndex(optionData)
  local selectedIndex = self:GetValueIndex(optionData.data, optionData.currentValue)
  optionData.index = selectedIndex
end

function debugSettings:publishRenderResolution()
  self.im.Publish(bndRenderResolution, self.renderResolutionData)
end

function debugSettings:publishCrowdModeDefault()
  self.im.Publish(bndCrowdModeDefault, self.crowdModeDefaultData)
end

function debugSettings:publishCrowdModeReplay()
  self.im.Publish(bndCrowdModeReplay, self.crowdModeReplayData)
end

function debugSettings:publishCrowdModeNis()
  self.im.Publish(bndCrowdModeNis, self.crowdModeNisData)
end

function debugSettings:publishCrowdModeHighlight()
  self.im.Publish(bndCrowdModeHighlight, self.crowdModeHighlightData)
end

function debugSettings:publishCrowdModeSetpiece()
  self.im.Publish(bndCrowdModeSetpiece, self.crowdModeSetpieceData)
end

function debugSettings:publishRightSideLabel()
  self.im.Publish(bndRightSideLabel, self.label)
end

function debugSettings:publishRightSideImage()
  self.im.Publish(bndRightSideImage, {
    name = self.imagetype,
    id = self.imageID
  })
end

function debugSettings:onRenderResolutionChanged(newOption)
  local newValue = newOption.value
  if self.renderResolutionData.currentValue ~= newValue then
    self.renderResolutionData.currentValue = newValue
    self.services.settingsService.SaveRenderResolutionValue(newValue)
  end
end

function debugSettings:onCrowdModeDefaultChanged(newOption)
  local newValue = newOption.value
  if self.crowdModeDefaultData.currentValue ~= newValue then
    self.crowdModeDefaultData.currentValue = newValue
    self.services.settingsService.SaveCrowdModeValue(newValue, CrowdModeDefaultServiceIndex)
  end
end

function debugSettings:onCrowdModeReplayChanged(newOption)
  local newValue = newOption.value
  if self.crowdModeReplayData.currentValue ~= newValue then
    self.crowdModeReplayData.currentValue = newValue
    self.services.settingsService.SaveCrowdModeValue(newValue, CrowdModeReplayServiceIndex)
  end
end

function debugSettings:onCrowdModeNisChanged(newOption)
  local newValue = newOption.value
  if self.crowdModeNisData.currentValue ~= newValue then
    self.crowdModeNisData.currentValue = newValue
    self.services.settingsService.SaveCrowdModeValue(newValue, CrowdModeNisServiceIndex)
  end
end

function debugSettings:onCrowdModeHighlightChanged(newOption)
  local newValue = newOption.value
  if self.crowdModeHighlightData.currentValue ~= newValue then
    self.crowdModeHighlightData.currentValue = newValue
    self.services.settingsService.SaveCrowdModeValue(newValue, CrowdModeHighlightServiceIndex)
  end
end

function debugSettings:onCrowdModeSetpieceChanged(newOption)
  print("onCrowdModeSetpieceChanged")
  local newValue = newOption.value
  if self.crowdModeSetpieceData.currentValue ~= newValue then
    self.crowdModeSetpieceData.currentValue = newValue
    self.services.settingsService.SaveCrowdModeValue(newValue, CrowdModeSetpieceServiceIndex)
  end
end

function debugSettings:publishDebugSettingsListData()
  local dirtyIndices = {}
  local nRows = 6
  do
    do
      for _FORV_6_ = 0, nRows do
        table.insert(dirtyIndices, _FORV_6_)
      end
    end
  end
  local dataList = {
    dirty = dirtyIndices,
    data = {
      {
        data = self.renderResolutionData
      },
      {
        data = self.crowdModeDefaultData
      },
      {
        data = self.crowdModeReplayData
      },
      {
        data = self.crowdModeNisData
      },
      {
        data = self.crowdModeHighlightData
      },
      {
        data = self.crowdModeSetpieceData
      }
    }
  }
  self.im.Publish(BND_DEBUG_SETTINGS_LIST_DATA, dataList)
end

function debugSettings:GetValueIndex(data, value)
  local i = 1
  while i <= #data and data[i].value ~= value do
    i = i + 1
  end
  return i - 1
end

function debugSettings:finalize()
  self.im.Unsubscribe(bndRenderResolution)
  self.im.Unsubscribe(bndCrowdModeDefault)
  self.im.Unsubscribe(bndCrowdModeReplay)
  self.im.Unsubscribe(bndCrowdModeNis)
  self.im.Unsubscribe(bndCrowdModeHighlight)
  self.im.Unsubscribe(bndCrowdModeSetpiece)
  self.im.Unsubscribe(BND_DEBUG_SETTINGS_LIST_DATA)
  self.im.Unsubscribe(bndRightSideLabel)
  self.im.Unsubscribe(bndRightSideImage)
  self.im.UnregisterAction(actChangeRenderResolution)
  self.im.UnregisterAction(actChangeCrowdModeDefault)
  self.im.UnregisterAction(actChangeCrowdModeReplay)
  self.im.UnregisterAction(actChangeCrowdModeNis)
  self.im.UnregisterAction(actChangeCrowdModeHighlight)
  self.im.UnregisterAction(actChangeCrowdModeSetpiece)
  self.nav.RemoveActionHandler(DISABLESETTINGSACTIONS)
end

return debugSettings