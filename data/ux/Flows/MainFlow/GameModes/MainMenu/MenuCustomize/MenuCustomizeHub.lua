-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local MenuCustomizeHub = {}

local BND_LIVE_TILE_SETTINGS = "bnd_live_tile_settings"
local BND_LIVE_TILE_PROFILE = "bnd_live_tile_profile"
local BND_LIVE_TILE_ONLINESETTINGS = "bnd_live_tile_onlinesettings"
local BND_LIVE_TILE_CATALOGUE = "bnd_live_tile_catalogue"
local BND_LIVE_TILE_EDITTEAMS = "bnd_live_tile_editteams"
local BND_LIVE_TILE_TEAMSHEETS = "bnd_live_tile_teamsheets"
local BND_LIVE_TILE_CREATEPLAYER = "bnd_live_tile_createplayer"
local BND_LIVE_TILE_EASPORTSTRACK = "bnd_live_tile_easportstrack"

function MenuCustomizeHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

  ----------------------------
  -- MENU SETTINGS --
  ----------------------------
  o.im.Subscribe(BND_LIVE_TILE_SETTINGS, function()
    o:BND_LIVE_TILE_SETTINGS()
  end)
function MenuCustomizeHub:BND_LIVE_TILE_SETTINGS()
  self.im.Publish(BND_LIVE_TILE_SETTINGS, dataToInsert)
end

  ---------------------------
  -- MENU PROFILE --
  ---------------------------
  o.im.Subscribe(BND_LIVE_TILE_PROFILE, function()
    o:BND_LIVE_TILE_PROFILE()
  end)
function MenuCustomizeHub:BND_LIVE_TILE_PROFILE()
  local dataToInsert =
  {
    headline = { "PROFILE" },
    description = "User Name :        ROBBI AREZA       User ID :       04062003"
  }
  self.im.Publish(BND_LIVE_TILE_PROFILE, dataToInsert)
end

  ---------------------------------------
  -- MENU ONLINE SETTINGS --
  ---------------------------------------
  o.im.Subscribe(BND_LIVE_TILE_ONLINESETTINGS, function()
    o:BND_LIVE_TILE_ONLINESETTINGS()
  end)
function MenuCustomizeHub:BND_LIVE_TILE_ONLINESETTINGS()
  local dataToInsert =
  {
    headline = { "ONLINE SETTINGS" },
    description = "Customize Your FIFA 16 Online Settings"
  }
  self.im.Publish(BND_LIVE_TILE_ONLINESETTINGS, dataToInsert)
end

  -------------------------------
  -- MENU CATALOGUE --
  -------------------------------
  o.im.Subscribe(BND_LIVE_TILE_CATALOGUE, function()
    o:BND_LIVE_TILE_CATALOGUE()
  end)
function MenuCustomizeHub:BND_LIVE_TILE_CATALOGUE()
  local dataToInsert =
  {
    headline = { "CATALOGUE" },
    description = "Server is Closed"
  }
  self.im.Publish(BND_LIVE_TILE_CATALOGUE, dataToInsert)
end

  --------------------------------
  -- MENU EDIT TEAMS --
  --------------------------------
  o.im.Subscribe(BND_LIVE_TILE_EDITTEAMS, function()
    o:BND_LIVE_TILE_EDITTEAMS()
  end)
function MenuCustomizeHub:BND_LIVE_TILE_EDITTEAMS()
  local dataToInsert =
  {
    headline = { "EDIT TEAMS" },
    description = "Check All Teams Squad"
  }
  self.im.Publish(BND_LIVE_TILE_EDITTEAMS, dataToInsert)
end

  -----------------------------------
  -- MENU TEAM SHEETS --
  -----------------------------------
  o.im.Subscribe(BND_LIVE_TILE_TEAMSHEETS, function()
    o:BND_LIVE_TILE_TEAMSHEETS()
  end)
function MenuCustomizeHub:BND_LIVE_TILE_TEAMSHEETS()
  local dataToInsert =
  {
    headline = { "TEAM SHEETS" },
    description = "Create multiple squads per team and manage their lineups, formation, and tactics"
  }
  self.im.Publish(BND_LIVE_TILE_TEAMSHEETS, dataToInsert)
end

  -------------------------------------
  -- MENU CREATE PLAYER --
  -------------------------------------
  o.im.Subscribe(BND_LIVE_TILE_CREATEPLAYER, function()
    o:BND_LIVE_TILE_CREATEPLAYER()
  end)
function MenuCustomizeHub:BND_LIVE_TILE_CREATEPLAYER()
  local dataToInsert =
  {
    headline = { "CREATE PLAYER" },
    description = "Server is Closed"
  }
  self.im.Publish(BND_LIVE_TILE_CREATEPLAYER, dataToInsert)
end

  -----------------------------------------
  -- MENU EA SPORTS TRACK --
  -----------------------------------------
  o.im.Subscribe(BND_LIVE_TILE_EASPORTSTRACK, function()
    o:BND_LIVE_TILE_EASPORTSTRACK()
  end)
function MenuCustomizeHub:BND_LIVE_TILE_EASPORTSTRACK()
  local dataToInsert =
  {
    headline = { "EA SPORTS™ TRACK" },
    description = "Shine A Light       Dreams             Soy Yo                     All It Ever Was                       . . ."
  }
  self.im.Publish(BND_LIVE_TILE_EASPORTSTRACK, dataToInsert)
end
  
  return o
end

return MenuCustomizeHub