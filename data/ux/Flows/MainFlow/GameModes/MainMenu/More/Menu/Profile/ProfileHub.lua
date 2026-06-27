-- Modified By MVNPROD Youtube Channel --
local ProfileHub = {}
function ProfileHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    BrowserService = o.api("BrowserService"),
    MiscService = o.api("MiscService")
  }
  return o
end
function ProfileHub:finalize()
end
return ProfileHub