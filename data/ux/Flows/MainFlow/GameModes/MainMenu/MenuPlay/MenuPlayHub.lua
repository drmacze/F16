-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local MenuPlayHub = {}

local BND_LIVE_TILE_KICKOFF = "bnd_live_tile_kickoff"
local BND_LIVE_TILE_ULTIMATETEAM = "bnd_live_tile_ultimateteam"
local BND_LIVE_TILE_NEWCAREER = "bnd_live_tile_newcareer"
local BND_LIVE_TILE_NEWTOURNAMENT = "bnd_live_tile_newtournament"
local BND_LIVE_TILE_SKILLGAMES = "bnd_live_tile_skillgames"
local BND_LIVE_TILE_BEAPRO_BESTTEAMSTOUR = "bnd_live_tile_beapro_bestteamstour"

function MenuPlayHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

QuickCupGrouping = {}
currentCupData = {
   cupIndex = 0,
   homeID = 0,
   awayID = 0,
   maxMatchSize = 0
}
currentCupInfo = {}
currentMode = 0

  ----------------------------
  -- MENU KICK OFF --
  ----------------------------
  o.im.Subscribe(BND_LIVE_TILE_KICKOFF, function()
    o:BND_LIVE_TILE_KICKOFF()
  end)
function MenuPlayHub:BND_LIVE_TILE_KICKOFF()
  self.im.Publish(BND_LIVE_TILE_KICKOFF, dataToInsert)
end

  --------------------------------------
  -- MENU ULTIMATE TEAM --
  --------------------------------------
  o.im.Subscribe(BND_LIVE_TILE_ULTIMATETEAM, function()
    o:BND_LIVE_TILE_ULTIMATETEAM()
  end)
function MenuPlayHub:BND_LIVE_TILE_ULTIMATETEAM()
  local dataToInsert =
  {
    headline = { "ULTIMATE TEAM™" },
    description = "Server is Closed"
  }
  self.im.Publish(BND_LIVE_TILE_ULTIMATETEAM, dataToInsert)
end

  ----------------------------------
  -- MENU NEW CAREER --
  ----------------------------------
  o.im.Subscribe(BND_LIVE_TILE_NEWCAREER, function()
    o:BND_LIVE_TILE_NEWCAREER()
  end)
function MenuPlayHub:BND_LIVE_TILE_NEWCAREER()
  local dataToInsert =
  {
    headline = { "LEAGUE" },
    description = "Play League And Become a Champion !"
  }
  self.im.Publish(BND_LIVE_TILE_NEWCAREER, dataToInsert)
end

  ------------------------------------------
  -- MENU NEW TOURNAMENT --
  ------------------------------------------
  o.im.Subscribe(BND_LIVE_TILE_NEWTOURNAMENT, function()
    o:BND_LIVE_TILE_NEWTOURNAMENT()
  end)
function MenuPlayHub:BND_LIVE_TILE_NEWTOURNAMENT()
  local dataToInsert =
  {
    headline = { "TOURNAMENT" },
    description = "Play Tournament And Win a Trophies !"
  }
  self.im.Publish(BND_LIVE_TILE_NEWTOURNAMENT, dataToInsert)
end

  ----------------------------------
  -- MENU SKILL GAMES --
  ----------------------------------
  o.im.Subscribe(BND_LIVE_TILE_SKILLGAMES, function()
    o:BND_LIVE_TILE_SKILLGAMES()
  end)
function MenuPlayHub:BND_LIVE_TILE_SKILLGAMES()
  local dataToInsert =
  {
    headline = { "SKILL GAMES" },
    description = "Improve And Test Your FIFA Skill"
  }
  self.im.Publish(BND_LIVE_TILE_SKILLGAMES, dataToInsert)
end

  -----------------------------------------------------------
  -- MENU BE A PRO & BEST TEAMS TOUR --
  -----------------------------------------------------------
  o.MenuBeAProBestTeamsTour = {}
  table.insert(o.MenuBeAProBestTeamsTour, {
    headline = { "BE A PRO" },
    description = "Play Friendly Match With One Player !",
    images = { "$MenuPlay_BeAPro" },
    autoScaleImageToTileHeight = { "true" },
    clickAction = "act_beapro"
  })
  table.insert(o.MenuBeAProBestTeamsTour, {
    headline = { "BEST TEAMS TOUR" },
    description = "Play Tour Match With Best Teams !",
    images = { "$MenuPlay_BestTeamsTour" },
    autoScaleImageToTileHeight = { "true" },
    clickAction = "act_bestteamstour"
  })
  o.im.Subscribe(BND_LIVE_TILE_BEAPRO_BESTTEAMSTOUR, function()
    o:_publishMenuBeAProBestTeamsTour()
  end)
function MenuPlayHub:_publishMenuBeAProBestTeamsTour()
  local dataToPublish = { index = 0, data = self.MenuBeAProBestTeamsTour }
  self.im.Publish(BND_LIVE_TILE_BEAPRO_BESTTEAMSTOUR, dataToPublish)
end

  return o
end

return MenuPlayHub