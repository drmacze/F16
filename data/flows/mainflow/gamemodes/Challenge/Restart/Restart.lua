-------------------------------------------
-- MOD By LAOSIJI --
-------------------------------------------

local Restart = {}

function Restart:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  currentChallengeData.Index = 0
  currentChallengeData.homeID = 0
  currentChallengeData.awayID = 0
  currentChallengeData.difficulty = 1
  currentChallengeData.round = 1

  currentChallengeInfo[challengeId] = nil
  

  o.nav.Event(nil, "evt_back")
    
  return o
end



function Restart:finalize()
  
end

return Restart
