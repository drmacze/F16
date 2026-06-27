local TableUtil, EventManager = ...
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local Popup = {}
local ACT_POPUP_BUTTON_CLICK = "act_popup_button_click"
local ACT_POPUP_BUTTON_ROLL_OVER = "act_popup_button_roll_over"
local ACT_POPUP_BUTTON_ROLL_OUT = "act_popup_button_roll_out"
local BND_POPUP_TITLE = "bnd_popup_title"
local BND_POPUP_BUTTONS = "bnd_popup_buttons"
local BND_POPUP_MESSAGE = "bnd_popup_message"
local BND_ESCAPE_ACTION = "bnd_escape_action"
local BND_AUTO_ESCAPE = "bnd_auto_escape"
local BND_POPUP_LOADER_VISIBLE = "bnd_popup_loader_visible"
local BND_LABEL_X_OFFSET = "bnd_label_x_offset"
function Popup:new(init)
  print("[Popup]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    ScreenInfoService = o.api("ScreenInfoService"),
    EventManagerService = o.api("EventManagerService")
  }
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end
  )
  TableUtil.print(o.data)
  o.title = o.data.title ~= nil and (o.data.title) or ""
  o.buttons = o.data.buttons or {}
  o.message = ""
  o.escapeAction = o.data.escapeAction
  o.autoEscape = true
  o.loader = o.data.loader
  if o.loader == nil then
    o.loader = false
  end
  if o.data.autoEscape ~= nil then
    o.autoEscape = o.data.autoEscape
  end
  if o.data.message ~= nil then
    if type(o.data.message) == "string" then
      o.message = (o.data.message)
    elseif o.data.message.localized == true then
      o.message = o.data.message.message or ""
    elseif o.data.message.message ~= nil then
      o.message = (o.data.message.message)
    end
  end
  o.im.Subscribe(BND_POPUP_TITLE, function()
    o:_publishTitle()
  end
  )
  o.im.Subscribe(BND_POPUP_BUTTONS, function()
    o:_publishButtons()
  end
  )
  o.im.Subscribe(BND_POPUP_MESSAGE, function()
    o:_publishMessage()
  end
  )
  o.im.Subscribe(BND_ESCAPE_ACTION, function()
    o:_publishEscapeAction()
  end
  )
  o.im.Subscribe(BND_AUTO_ESCAPE, function()
    o:_publishAutoEscape()
  end
  )
  o.im.Subscribe(BND_POPUP_LOADER_VISIBLE, function()
    o:_publishLoader()
  end
  )
  o.im.Subscribe(BND_LABEL_X_OFFSET, function()
    o:_publishLabelXoffset()
  end
  )
  o.im.RegisterAction(ACT_POPUP_BUTTON_CLICK, function(actionName, id)
    o:_buttonClick(id + 1)
  end
  )
  o.im.RegisterAction(ACT_POPUP_BUTTON_ROLL_OVER, function(actionName, id)
    o:_buttonRollOver(id + 1)
  end
  )
  o.im.RegisterAction(ACT_POPUP_BUTTON_ROLL_OUT, function(actionName, id)
    o:_buttonRollOut(id + 1)
  end
  )
  if automation then
    print("PopupGetTitle automation exists")
    automation.Add("PopupAutomationTitle", {
      PopupGetTitle = function(callback)
        return callback(o.title)
      end
      
    })
    automation.Add("PopupAutomationMessage", {
      PopupGetMessage = function(callback)
        return callback(o.message)
      end
      
    })
    automation.Add("PopupAutomationButtons", {
      PopupGetButtons = function(callback)
        local buttonData = {}
        do
          do
            for _FORV_5_, _FORV_6_ in ipairs(o.buttons) do
              buttonData[_FORV_5_] = (_FORV_6_.label)
            end
          end
        end
        return callback(buttonData)
      end
      
    })
    automation.Add("PopupAutomationClickButton", {
      PopupClickButton = function(buttonString)
        local buttonId
        do
          do
            for _FORV_5_, _FORV_6_ in ipairs(o.buttons) do
              if (_FORV_6_.label) == buttonString then
                buttonId = _FORV_5_
              end
            end
          end
        end
        o:_buttonClick(buttonId)
      end
      
    })
  end
  o.services.ScreenInfoService.SetScreenName("GenericPopup")
  return o
end

function Popup:_publishTitle()
  self.im.Publish(BND_POPUP_TITLE, self.title)
end

function Popup:_publishButtons()
  local buttonData = {}
  do
    do
      for _FORV_5_, _FORV_6_ in ipairs(self.buttons) do
        buttonData[_FORV_5_] = {}
        buttonData[_FORV_5_].label = (_FORV_6_.label)
        buttonData[_FORV_5_].icon = _FORV_6_.icon
        buttonData[_FORV_5_].clickSFXID = _FORV_6_.clickSFXID
        buttonData[_FORV_5_].clickAction = ACT_POPUP_BUTTON_CLICK
        buttonData[_FORV_5_].rollOverAction = ACT_POPUP_BUTTON_ROLL_OVER
        buttonData[_FORV_5_].rollOutAction = ACT_POPUP_BUTTON_ROLL_OUT
      end
    end
  end
  self.im.Publish(BND_POPUP_BUTTONS, buttonData)
end

function Popup:_publishMessage()
  self.im.Publish(BND_POPUP_MESSAGE, self.message)
end

function Popup:_publishEscapeAction()
  if self.escapeAction ~= nil then
    self.im.Publish(BND_ESCAPE_ACTION, self.escapeAction)
  end
end

function Popup:_publishAutoEscape()
  self.im.Publish(BND_AUTO_ESCAPE, self.autoEscape)
end

function Popup:_publishLoader()
  self.im.Publish(BND_POPUP_LOADER_VISIBLE, self.loader)
end

function Popup:_publishLabelXoffset()
  if self.loader then
    self.im.Publish(BND_LABEL_X_OFFSET, 25)
  else
    self.im.Publish(BND_LABEL_X_OFFSET, 0)
  end
end

function Popup:_buttonClick(id)
  print("[Popup]: _buttonClick " .. (id or "nil"))
  local button = self.buttons[id]
  if button.click == nil then
    if button.clickCallback ~= nil then
      button.clickCallback(button.clickCallbackParams)
    end
    if button.clickEvents ~= nil then
      do
        for _FORV_6_, _FORV_7_ in ipairs(button.clickEvents) do
          self.nav.Event(nil, _FORV_7_)
        end
      end
    end
  else
    button.click()
  end
end

function Popup:_buttonRollOver(id)
  print("[Popup]: _buttonRollOver" .. (id or "nil") .. ")")
  local button = self.buttons[id]
  if button.rollOver == nil then
    if button.rollOverCallback ~= nil then
      button.rollOverCallback(button.rollOverCallbackParams)
    end
    if button.rollOverEvents ~= nil then
      do
        for _FORV_6_, _FORV_7_ in ipairs(button.rollOverEvents) do
          self.nav.Event(nil, _FORV_7_)
        end
      end
    end
  else
    button.rollOver()
  end
end

function Popup:_buttonRollOut(id)
  print("[Popup]: _buttonRollOut" .. (id or "nil") .. ")")
  local button = self.buttons[id]
  if button.rollOut == nil then
    if button.rollOutCallback ~= nil then
      button.rollOutCallback(button.rollOutCallbackParams)
    end
    if button.rollOutEvents ~= nil then
      do
        for _FORV_6_, _FORV_7_ in ipairs(button.rollOutEvents) do
          self.nav.Event(nil, _FORV_7_)
        end
      end
    end
  else
    button.rollOut()
  end
end

function Popup:_handleEvent(eventType, data)
  print("Popup:_handleEvent")
  if eventType == EVENT_TYPES.OnBackPressed then
    print("Popup:_handleEvent OnBackPressed")
    self:_buttonClick(1)
  end
end

function Popup:finalize()
  self.im.UnregisterAction(ACT_POPUP_BUTTON_CLICK)
  self.im.UnregisterAction(ACT_POPUP_BUTTON_ROLL_OVER)
  self.im.UnregisterAction(ACT_POPUP_BUTTON_ROLL_OUT)
  self.im.Unsubscribe(BND_POPUP_TITLE)
  self.im.Unsubscribe(BND_POPUP_BUTTONS)
  self.im.Unsubscribe(BND_POPUP_MESSAGE)
  self.im.Unsubscribe(BND_ESCAPE_ACTION)
  self.im.Unsubscribe(BND_AUTO_ESCAPE)
  self.im.Unsubscribe(BND_POPUP_LOADER_VISIBLE)
  self.im.Unsubscribe(BND_LABEL_X_OFFSET)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  self.services.ScreenInfoService.UnsetScreenName("GenericPopup")
end

return Popup
