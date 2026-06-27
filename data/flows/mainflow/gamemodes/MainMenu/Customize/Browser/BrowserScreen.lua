local BrowserScreen = {}
local bndFooter = "bnd_footer"
function BrowserScreen:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    BrowserService = o.api("BrowserService"),
    ViewportService = o.api("ViewportService")
  }
  local labelText = "Back"
  o.footer = {
    {
      label = labelText,
      icon = "$SimMatchIcon3",
      clickAction = "act_back"
    }
  }
  local browser_height
  if o.services.ViewportService.IsWideScreen() then
    browser_height = 0.9219
  else
    browser_height = 0.9219
  end
  o.services.BrowserService.OpenBrowser(0, 0, o.services.ViewportService.GetScreenWidth(), math.ceil(o.services.ViewportService.GetScreenHeight() * browser_height))
  o.im.Subscribe(bndFooter, function()
    o:_publishFooter()
  end)
  return o
end
function BrowserScreen:_publishFooter()
  self.im.Publish(bndFooter, self.footer)
end
function BrowserScreen:finalize()
  print("[BrowserScreen::finalize()]")
  self.services.BrowserService.CloseBrowser()
  self.im.Unsubscribe(bndFooter)
end
return BrowserScreen
