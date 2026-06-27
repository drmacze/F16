-- Patch By Ma'ruf ID YouTube --

-------------------------------------------------------
-- MOD Keren dari YouTube Ma'ruf ID --
-------------------------------------------------------

local IntroLogoFIFA = {}

function IntroLogoFIFA:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
 
  -- Durasi Intro Logo FIFA --
  o.waitTime = 200
  
  return o
end

function IntroLogoFIFA:update(elapsedTime)
  if self.waitTime == nil then
    return
  end
  self.waitTime = self.waitTime - 1
  if self.waitTime == 0 then
    self.nav.Event(nil, "evt_advance")
  end
end

return IntroLogoFIFA