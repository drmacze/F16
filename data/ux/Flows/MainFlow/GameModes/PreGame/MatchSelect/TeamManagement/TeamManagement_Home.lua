-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local TeamManagement_Home = {}

local TeamManagementModel = (...)

function TeamManagement_Home:new(init)
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

function TeamManagement_Home:finalize()

  self.models.TeamManagementModel:saveSquad()
  self.models.TeamManagementModel:finalize()
  
end

return TeamManagement_Home