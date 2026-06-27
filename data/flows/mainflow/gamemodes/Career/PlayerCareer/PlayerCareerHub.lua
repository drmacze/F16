-- Menu Player Career --
-- PlayerCareerHub Remode By Septiawan --

local PlayerCareerHub = {}

function PlayerCareerHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
  }
  o.playerbg = {
    name = "$PLAYER_CUPX",
    id = 0
  }
  math.randomseed(os.clock() * 1357 + os.time())
  local currentTime = os.date("%H") + 0
  local random2 = math.random(10)
  
  o.im.Subscribe("bnd_player_bg", function()
    o.playerbg.id = random2
    o.im.Publish("bnd_player_bg", o.playerbg)
  end)
  
  return o
end

function PlayerCareerHub:finalize()
  self.im.Unsubscribe("bnd_player_bg")
end

return PlayerCareerHub