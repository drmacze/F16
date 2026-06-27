-------------------------------------------
-- MOD By LAOSIJI --
-------------------------------------------

local Restart = {}

function Restart:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  currentCupData.cupIndex = 0
  currentCupData.homeID = 0
  currentCupData.awayID = 0
  currentCupData.maxMatchSize = 0

  currentCupInfo[cupId] = nil
  

  o.nav.Event(nil, "evt_back")
    
  return o
end



function Restart:finalize()
  
end

return Restart
