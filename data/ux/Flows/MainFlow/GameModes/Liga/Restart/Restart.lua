-------------------------------------------
-- MOD By LAOSIJI --
-------------------------------------------

local Restart = {}


function Restart:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

  LigaGrouping[ligaId] = nil
  sheets[1] = nil
  sheets[2] = nil
  sheets[3] = nil
  sheets[4] = nil

  o.nav.Event(nil, "evt_back")
  o.nav.Event(nil, "evt_back")
  o.nav.Event(nil, "evt_back")
  o.nav.Event(nil, "evt_back")
    
  return o
end

function Restart:finalize()
  
end



return Restart