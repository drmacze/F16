local VirtualButton = (...)
local SettingsCustomizeModel = {}
function SettingsCustomizeModel:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function SettingsCustomizeModel:showPopup(title, desc, onConfirmAction)
  local buttons = {
    VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconNo",
      label = "Cancel",
      clickEvents = {
        "evt_hide_popup"
      }
    }),
    VirtualButton:new({
      nav = self.nav,
      icon = "$FooterIconYes",
      label = "Confirm",
      clickEvents = {
        "evt_hide_popup"
      },
      clickCallback = function()
        if onConfirmAction then
          onConfirmAction()
        end
      end
      
    })
  }
  local popupData = {
    title = title,
    message = {message = desc, localized = true},
    buttons = buttons
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function SettingsCustomizeModel:finalize()
end

return SettingsCustomizeModel