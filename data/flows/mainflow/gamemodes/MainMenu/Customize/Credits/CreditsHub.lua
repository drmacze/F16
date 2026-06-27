-------------------------------------------------------
-- BY ROBER FL --
-------------------------------------------------------


local CreditsHub = {}
local actToDFLinfoTile = "act_to_DFLinfo_tile"

function CreditsHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    BrowserService = o.api("BrowserService"),
    MiscService = o.api("MiscService")
  }
  
  ---------------------------------
  -- DFL 24 INFO --
  ---------------------------------
  o.im.RegisterAction(actToDFLinfoTile, function(actionName)
    o:_openDFLinfoPopup(actionName)
  end)
  function CreditsHub:_openDFLinfoPopup()
  local titleText = "DREAM FOOTBALL LEAGUE 2025*"
  local messageText = "Versão 2.0*                                                                                        !ATTENTION!                                                                            The creators of this mod (DFL) do not allow link changes in any way to profit from our work. Respect the Mod Creators!"
  local buttonClose = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = titleText,
    message = messageText,
    buttons = {buttonClose}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end
  
  return o
end

function CreditsHub:finalize()
end

return CreditsHub