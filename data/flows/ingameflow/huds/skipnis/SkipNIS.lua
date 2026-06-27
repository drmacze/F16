-- REMOD BY YOUTUBE LAOSIJI --
local SkipNIS = {}
local BND_NIS_SKIP_LABEL = "bnd_nis_skip_label"
local ACT_SKIP_NIS = "act_skip_nis"
function SkipNIS:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    gameState = o.api("GameStateService"),
    gameControlsService = o.api("GameControlsService")
  }
  local label = o.services.gameState.GetControllerSide(0) == 0 and "Press any button to skip" or "Press any key to skip"
  o.im.Subscribe(BND_NIS_SKIP_LABEL, function()
    o.im.Publish(BND_NIS_SKIP_LABEL, label)
  end
  )
  o.im.RegisterAction(ACT_SKIP_NIS, function()
    o.services.gameControlsService.SkipNIS()
  end
  )
  return o
end

function SkipNIS:finalize()
  self.im.Unsubscribe(BND_NIS_SKIP_LABEL)
  self.im.UnregisterAction(ACT_SKIP_NIS)
end

return SkipNIS
