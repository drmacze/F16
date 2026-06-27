-- Modified MVNPROD -- Single Player Mode --

local Restart = {}

function Restart:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  currentBeaproData.Index = 0
  currentBeaproData.homeID = 0
  currentBeaproData.awayID = 0
  currentBeaproData.difficulty = 1
  currentBeaproData.round = 1

  currentBeaproInfo[beaproId] = nil
  

  o.nav.Event(nil, "evt_back")
    
  return o
end



function Restart:finalize()
  
end

return Restart

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --
