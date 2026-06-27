-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local AudioVisualConfirmation = {}

local BND_MESSAGE = "bnd_message"

local ACT_CANCEL = "act_cancel"
local ACT_CONFIRM = "act_confirm"

function AudioVisualConfirmation:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  o.cancelCallback = o.data.cancelCallback
  o.confirmCallback = o.data.confirmCallback
  
  o.timerToRevert = o.data.timerToRevert
  
  o.popupText = o.data.popupText
  
  o.im.Subscribe(BND_MESSAGE, function()
    o:_publishMessage()
  end)
  o.im.RegisterAction(ACT_CANCEL, function()
    o:cancelChange()
  end)
  o.im.RegisterAction(ACT_CONFIRM, function()
    o:confirmChange()
  end)
  
  return o
end

function AudioVisualConfirmation:_publishMessage()
  local message = string.format(self.loc.LocalizeString(self.popupText), math.ceil(self.timerToRevert / 60))
  self.im.Publish(BND_MESSAGE, message)
end

function AudioVisualConfirmation:confirmChange()
  self.nav.Event(nil, "evt_hide_overlay")
  self.confirmCallback()
end

function AudioVisualConfirmation:cancelChange()
  self.nav.Event(nil, "evt_hide_overlay")
  self.cancelCallback()
end

function AudioVisualConfirmation:update(elapsedTime)
  if self.timerToRevert == nil then
    return
  end
  self.timerToRevert = self.timerToRevert - 1
  self:_publishMessage()
  if self.timerToRevert == 0 then
    self:cancelChange()
  end
end

return AudioVisualConfirmation