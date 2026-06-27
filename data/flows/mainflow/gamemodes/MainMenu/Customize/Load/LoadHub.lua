
local LoadHub = {}

function LoadHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
 
  -- Durasi --
  o.waitTime = 150
  
  return o
end

function LoadHub:update(elapsedTime)
  if self.waitTime == nil then
    return
  end
  self.waitTime = self.waitTime - 1
  if self.waitTime == 0 then
    self.nav.Event(nil, "evt_back")
  end
end

return LoadHub