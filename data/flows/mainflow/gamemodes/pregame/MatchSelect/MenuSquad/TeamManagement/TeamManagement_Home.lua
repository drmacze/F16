local TeamManagementModel = (...)
local Squad = {}
function Squad:new(init)
  print("[Squad]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.models = {
    TeamManagementModel = TeamManagementModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      gamemode = o.data.gamemode
    })
  }
  return o
end

function Squad:finalize()
  print("[Squad]: finalize()")
  self.models.TeamManagementModel:saveSquad()
  self.models.TeamManagementModel:finalize()
end

return Squad
