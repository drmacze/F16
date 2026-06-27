-------------------------------------------
-- MOD Created By Ma'ruf ID --
-- RMOD Created By LAOSIJI --
-------------------------------------------

local Match = {}

function Match:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  o.services = {
    gameSetup = o.api("GameSetupService"),
    gameState = o.api("GameStateService")
  }
  
  o.nav.AddActionHandler("setTeams", false, nil, function()
    o.homeTeamID = currentCupData.homeID
    o.awayTeamID = currentCupData.awayID
    o.homeKitIndex = currentMatch.HomeKitIndex
    o.awayKitIndex = currentMatch.AwayKitIndex
    o.services.gameState.PauseAIandRendering(false)
    o.services.gameSetup.SetTeam(0, o.homeTeamID)
    o.services.gameSetup.SetTeam(1, o.awayTeamID)
    o.services.gameSetup.SetPreferredKitId(0, o.homeTeamID * 4096 + o.homeKitIndex)
    o.services.gameSetup.SetPreferredKitId(1, o.awayTeamID * 4096 + o.awayKitIndex)
    o.services.gameSetup.CommitKitSelect()
    o.services.gameState.SetUserSideAsHome()
  end)
  
  return o
end

return Match