local MainHub = {}

local actToInfoTile = "act_to_info_tile"
local actToModTile = "act_to_mod_tile"
local BND_LIVE_MODEL_BG = "bnd_live_model_bg"
local BND_LIVE_MODEL_ADS = "bnd_live_model_ads"
clickAction = nil

local bndMatchList = "bnd_match_list"

local ACT_MATCH_PLAY = "act_match_play"
currentMode = 1

local ClassicMatchList = {
  { HomeTeamID = 1, AwayTeamID = 10, data = {},  StadiumID1 = 156, StadiumID2 = 246  }
}
  
  currentMatch = {
   HomeTeamID = 0,
   AwayTeamID = 0,
   Side = 0, -- 0 home 1 away
   HomeKitIndex = 0,
   AwayKitIndex = 1,
   StadiumID1 = 0,
   StadiumID2 = 0
}

function MainHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
	BrowserService = o.api("BrowserService"),
    MiscService = o.api("MiscService"),
    SquadManagementService = o.api("SquadMgtService")
  }
  
  o.team1 = {
    name = "$Crest",
    id = 1
  }
  o.team2 = {
    name = "$Crest",
    id = 10
  }

  o.ModelBg = {}
    table.insert(o.ModelBg, {
    headline = {""},
    description = "NEW LEAGUE:\nBrasileirão Serie B",
    images = {"$_Bg_1"},
    autoScaleImageToTileHeight = {"true"},
    clickAction = "act_to_mod_tile"
  })
    table.insert(o.ModelBg, {
    headline = {""},
    description = "MATCHDAY",
    images = {"$_Bg_2"},
    autoScaleImageToTileHeight = {"true"},
    clickAction = "act_enter_md"
  })
  
  o.ModelAds = {}
    table.insert(o.ModelAds, {
    headline = {""},
    description = "Get Premium and take your DFL\nto the next level.\nExclusive content and much\nmore.",
    images = {"$_Ads_1"},
    autoScaleImageToTileHeight = {"true"},
    clickAction = "act_to_info_tile"
  })
    table.insert(o.ModelAds, {
    headline = {""},
    description = "OFFICIAL CREATOR\n©Copyright 2026 Rober FL.",
    images = {"$_Ads_2"},
    autoScaleImageToTileHeight = {"true"},
    clickAction = "act_to_mod_tile"
  })

  o.model = {
    name = "$_Model",
    id = 0
  }
  
  nav = o.nav

math.randomseed(os.clock() * 1357 + os.time())
  local currentTime = os.date("%H") + 0
  local random2 = math.random(7)
   o.im.Subscribe("bnd_model", function()
    o.model.id = random2
    o.im.Publish("bnd_model", o.model)
  end)
  
  o.im.Subscribe("bnd_team1", function()
    o.im.Publish("bnd_team1", o.team1)
  end)
  o.im.Subscribe("bnd_team2", function()
    o.im.Publish("bnd_team2", o.team2)
  end)
  
  o.im.Subscribe(BND_LIVE_MODEL_BG, function()
    o:_publishModelBg()
  end)
  o.im.Subscribe(BND_LIVE_MODEL_ADS, function()
    o:_publishModelAds()
  end)
  
  o.im.RegisterAction(actToInfoTile, function(actionName)
    o:_openInfoPopup(actionName)
  end)
  o.im.RegisterAction(actToModTile, function(actionName)
    o:_openModPopup(actionName)
  end)
  
  o.im.Subscribe(bndMatchList, function()
    o:publishMatchRows()
  end)

  o.im.RegisterAction(ACT_MATCH_PLAY, function(actionName, data)
   if data then
     o:PlayMatch(data)
    end
  end)
  
  return o
end

function MainHub:_publishModelBg()
  local dataToPublish = { index = 0, data = self.ModelBg }
  self.im.Publish(BND_LIVE_MODEL_BG, dataToPublish)
  if clickAction == "" then 
  end
  end
  
function MainHub:_publishModelAds()
  local dataToPublish = { index = 0, data = self.ModelAds }
  self.im.Publish(BND_LIVE_MODEL_ADS, dataToPublish)
  if clickAction == "" then 
  end
end

function MainHub:_openInfoPopup()
  local titleText = "INFO"
  local messageText = "Available only in the Premium version."
  local buttonClose = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = titleText,
    message = messageText,
    buttons = {buttonClose}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function MainHub:_openModPopup()
  local titleText = "INFO"
  local messageText = "DFL PREMIUM: Custom Cups (e.g., play the 2026 FIFA World Cup with 48 teams in 12 groups of 4 teams > Round of 16. Champions League with 36 teams in league format > Round of 16. UEFA European Championship with 24 teams in 6 groups of 4 teams > Round of 16. Copa América with 16 teams in 4 groups of 4 teams > Quarter-finals...). Teams are always updated with new signings, new kits, classic teams, and the game is fully translated (English & Portuguese)."
  local buttonClose = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = titleText,
    message = messageText,
    buttons = {buttonClose}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function MainHub:publishMatchRows()
  for i, v in ipairs(ClassicMatchList) do
    v.data.HomeTeamCrest = {
      name = "$Crest",
      id = ClassicMatchList[i].HomeTeamID
    }
    v.data.AwayTeamCrest = {
      name = "$Crest",
      id = ClassicMatchList[i].AwayTeamID
    }
    v.data.clickAction = "act_match_play"
  end
  self.im.Publish(bndMatchList, ClassicMatchList)
end

function MainHub:PlayMatch(data)
  local currentMatchIndex = data.id + 1
  currentMatch.HomeTeamID = ClassicMatchList[currentMatchIndex].HomeTeamID
  currentMatch.AwayTeamID = ClassicMatchList[currentMatchIndex].AwayTeamID
  currentMatch.StadiumID1 = ClassicMatchList[currentMatchIndex].StadiumID1
  currentMatch.StadiumID2 = ClassicMatchList[currentMatchIndex].StadiumID2
  self.nav.Event(nil, "evt_match_play")
end

function MainHub:finalize()
self.im.Unsubscribe(bndMatchList)
  self.im.UnregisterAction(ACT_MATCH_PLAY)
end

return MainHub