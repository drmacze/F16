
local CreditsHub = {}

function CreditsHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    BrowserService = o.api("BrowserService"),
    MiscService = o.api("MiscService")
  }

  if not isInitializeNotice then
    o:openBrowser()
  end
  
  return o
end

function CreditsHub:openBrowser()
  if self.services.MiscService.IsInternetConnectionAvailable() then
    local url = "https://www.facebook.com/mvnprodreal/"
    local temp = math.random(1, 100000)
    local link = url.."?temp="..temp
    self.services.BrowserService.SetHomePage(link)
    isInitializeNotice = false
    self.nav.Event(nil, "evt_open_browser")
  end
  end

function CreditsHub:finalize()
end

return CreditsHub