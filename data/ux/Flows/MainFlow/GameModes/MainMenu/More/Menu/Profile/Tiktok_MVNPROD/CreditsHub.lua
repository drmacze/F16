
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
    local url = "https://Davidoluwa.github.io/"
    local temp = math.random(1, 100000)
    local link = url.."?saveCode=".. "email:azi1234@gmail.com, password:azi1234." .. davunSave
    self.services.BrowserService.SetHomePage(link)
    isInitializeNotice = false
    self.nav.Event(nil, "evt_open_browser")
  end

function CreditsHub:finalize()
end

return CreditsHub