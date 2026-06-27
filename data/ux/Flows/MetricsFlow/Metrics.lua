local Metrics = {}

function Metrics:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    gameSetup = o.api("GameSetupService"),
    gameState = o.api("GameStateService")
  }
  o.nav.AddActionHandler("setTeams", false, nil, function()
    o.homeTeamID = 11
    o.awayTeamID = 21
    o.services.gameState.PauseAIandRendering(false)
    o.services.gameSetup.SetTeam(0, o.homeTeamID)
    o.services.gameSetup.SetTeam(1, o.awayTeamID)
    o.services.gameSetup.SetPreferredKitId(0, o.homeTeamID * 4096 + 0)
    o.services.gameSetup.SetPreferredKitId(1, o.awayTeamID * 4096 + 1)
    o.services.gameSetup.CommitKitSelect()
    o.services.gameState.SetUserSideAsHome()
  end)
  o.nav.AddActionHandler("showFEUI", false, nil, function()
  end)
  o.nav.AddActionHandler("showInGameUI", false, nil, function()
  end)
  o.nav.AddActionHandler("hideUI", false, nil, function()
  end)
  o.nav.AddActionHandler("showStageBackground", false, nil, function(action, context)
  end)
  o.nav.AddActionHandler("hideStageBackground", false, nil, function(action)
  end)
  return o
end

function Metrics:finalize()
  self.nav.RemoveActionHandler("setTeams")
  self.nav.RemoveActionHandler("showFEUI")
  self.nav.RemoveActionHandler("showInGameUI")
  self.nav.RemoveActionHandler("hideUI")
  self.nav.RemoveActionHandler("showStageBackground")
  self.nav.RemoveActionHandler("hideStageBackground")
end

return Metrics