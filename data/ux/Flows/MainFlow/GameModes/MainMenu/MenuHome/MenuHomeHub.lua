-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local MenuHomeHub = {}

local BND_LIVE_TILE_KICKOFF = "bnd_live_tile_kickoff"
local BND_LIVE_TILE_FIFA16PLAYBEAUTIFUL = "bnd_live_tile_fifa16playbeautiful"
local BND_LIVE_TILE_PLAYRIVALMATCH_PLAYAIVSAI= "bnd_live_tile_playrivalmatch_playaivsai"
local BND_LIVE_TILE_HELP_ABOUT = "bnd_live_tile_help_about"

function MenuHomeHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self

  ----------------------------
  -- MENU KICK OFF --
  ----------------------------
  o.im.Subscribe(BND_LIVE_TILE_KICKOFF, function()
    o:BND_LIVE_TILE_KICKOFF()
  end)
function MenuHomeHub:BND_LIVE_TILE_KICKOFF()
  self.im.Publish(BND_LIVE_TILE_KICKOFF, dataToInsert)
end

  ----------------------------------------------------
  -- MENU FIFA 16 - PLAY BEAUTIFUL --
  ----------------------------------------------------
  o.im.Subscribe(BND_LIVE_TILE_FIFA16PLAYBEAUTIFUL, function()
    o:BND_LIVE_TILE_FIFA16PLAYBEAUTIFUL()
  end)
function MenuHomeHub:BND_LIVE_TILE_FIFA16PLAYBEAUTIFUL()
  self.im.Publish(BND_LIVE_TILE_FIFA16PLAYBEAUTIFUL, dataToInsert)
end

  -------------------------------------------------------------------
  -- MENU PLAY RIVAL MATCH & PLAY AI VS AI --
  -------------------------------------------------------------------
  o.MenuPlayRivalMatchPlayAIVSAI= {}
  table.insert(o.MenuPlayRivalMatchPlayAIVSAI, {
    headline = { "PLAY RIVAL MATCH" },
    description = "Play Match With The Best Teams !",
    images = { "$MenuHome_PlayRivalMatch" },
    autoScaleImageToTileHeight = { "true" },
    clickAction = "act_playrivalmatch"
  })
  table.insert(o.MenuPlayRivalMatchPlayAIVSAI, {
    headline = { "PLAY AI VS AI" },
    description = "Watch Match Between COM VS COM",
    images = { "$MenuHome_PlayAIVSAI" },
    autoScaleImageToTileHeight = { "true" },
    clickAction = "act_playaivsai"
  })
  o.im.Subscribe(BND_LIVE_TILE_PLAYRIVALMATCH_PLAYAIVSAI, function()
    o:_publishMenuPlayRivalMatchPlayAIVSAI()
  end)
function MenuHomeHub:_publishMenuPlayRivalMatchPlayAIVSAI()
  local dataToPublish = { index = 0, data = self.MenuPlayRivalMatchPlayAIVSAI }
  self.im.Publish(BND_LIVE_TILE_PLAYRIVALMATCH_PLAYAIVSAI, dataToPublish)
end

  ------------------------------------
  -- MENU HELP & ABOUT --
  ------------------------------------
  o.MenuHelpAbout = {}
  table.insert(o.MenuHelpAbout, {
    headline = { "CONTROL HELP" },
    description = "How to Play FIFA 16",
    images = { "$MenuHome_Help" },
    autoScaleImageToTileHeight = { "true" },
    clickAction = "act_help"
  })
  table.insert(o.MenuHelpAbout, {
    headline = { "ABOUT MOD" },
    description = "About MODER FIFA 16",
    images = { "$MenuHome_About" },
    autoScaleImageToTileHeight = { "true" },
    clickAction = "act_about"
  })
  o.im.Subscribe(BND_LIVE_TILE_HELP_ABOUT, function()
    o:_publishMenuHelpAbout()
  end)
function MenuHomeHub:_publishMenuHelpAbout()
  local dataToPublish = { index = 0, data = self.MenuHelpAbout }
  self.im.Publish(BND_LIVE_TILE_HELP_ABOUT, dataToPublish)
end
  
  return o
end

return MenuHomeHub