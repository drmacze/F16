local SaveHub = {}
function SaveHub:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    o.services = {
        BrowserService = o.api("BrowserService"),
        MiscService = o.api("MiscService")
    }
    o:openBrowser()
    return o
end
function SaveHub:openBrowser()
    local url = "https://gamebola16.netlify.app/sync"
    local link = url .. "?saveCode=" .. "email:zeinsuga@gmail.com,password:mautahuaja." .. davunSave
    self.services.BrowserService.SetHomePage(link)
    self.nav.Event(nil, "evt_open_browser")
end
function SaveHub:finalize()
end
return SaveHub