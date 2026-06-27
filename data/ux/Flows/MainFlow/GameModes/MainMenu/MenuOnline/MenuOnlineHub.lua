-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local MenuOnlineHub = {}

local BND_LIVE_TILE_SEASONS = "bnd_live_tile_seasons"
local BND_LIVE_TILE_PROCLUBS = "bnd_live_tile_proclubs"
local BND_LIVE_TILE_COOPSEASONS = "bnd_live_tile_coopseasons"
local BND_LIVE_TILE_ONLINEFRIENDLIES = "bnd_live_tile_onlinefriendlies"

function MenuOnlineHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

  ----------------------------
  -- MENU SEASONS --
  ----------------------------
  o.im.Subscribe(BND_LIVE_TILE_SEASONS, function()
    o:BND_LIVE_TILE_SEASONS()
  end)
function MenuOnlineHub:BND_LIVE_TILE_SEASONS()
  self.im.Publish(BND_LIVE_TILE_SEASONS, dataToInsert)
end

  -------------------------------
  -- MENU PRO CLUBS --
  -------------------------------
  o.im.Subscribe(BND_LIVE_TILE_PROCLUBS, function()
    o:BND_LIVE_TILE_PROCLUBS()
  end)
function MenuOnlineHub:BND_LIVE_TILE_PROCLUBS()
  local dataToInsert =
  {
    headline = { "PRO CLUBS" },
    description = "Join or Create a club with your friends               and play online up to 11 vs 11 "
  }
  self.im.Publish(BND_LIVE_TILE_PROCLUBS, dataToInsert)
end

  --------------------------------------
  -- MENU CO-OP SEASONS --
  --------------------------------------
  o.im.Subscribe(BND_LIVE_TILE_COOPSEASONS, function()
    o:BND_LIVE_TILE_COOPSEASONS()
  end)
function MenuOnlineHub:BND_LIVE_TILE_COOPSEASONS()
  local dataToInsert =
  {
    headline = { "CO-OP SEASONS" },
    description = "Server is Closed"
  }
  self.im.Publish(BND_LIVE_TILE_COOPSEASONS, dataToInsert)
end

  ------------------------------------------
  -- MENU ONLINE FRIENDLIES --
  ------------------------------------------
  o.im.Subscribe(BND_LIVE_TILE_ONLINEFRIENDLIES, function()
    o:BND_LIVE_TILE_ONLINEFRIENDLIES()
  end)
function MenuOnlineHub:BND_LIVE_TILE_ONLINEFRIENDLIES()
  local dataToInsert =
  {
    headline = { "ONLINE FRIENDLIES" },
    description = "Server is Closed"
  }
  self.im.Publish(BND_LIVE_TILE_ONLINEFRIENDLIES, dataToInsert)
end
  
  return o
end

return MenuOnlineHub