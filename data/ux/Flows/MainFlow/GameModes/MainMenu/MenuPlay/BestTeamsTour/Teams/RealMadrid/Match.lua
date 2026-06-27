-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local Match = {}

local bndMatchList = "bnd_match_list"

local ACT_MATCH_PLAY = "act_match_play"

local MatchList = {
  
  -- Match Real Madrid --
  { HomeTeamID = 243, AwayTeamID = 11, data = {} },
  { HomeTeamID = 243, AwayTeamID = 21, data = {} },
  { HomeTeamID = 243, AwayTeamID = 22, data = {} },
  { HomeTeamID = 243, AwayTeamID = 241, data = {} },
  { HomeTeamID = 243, AwayTeamID = 5, data = {} },
  { HomeTeamID = 243, AwayTeamID = 73, data = {} },
  { HomeTeamID = 243, AwayTeamID = 45, data = {} }
  
}

-- Kode Untuk Mengacak Pilihan & Urutan --
local function shuffleArray(array)
  math.randomseed(os.time()) -- Initialize random seed
  for i = #array, 2, -1 do
    local j = math.random(i)
    array[i], array[j] = array[j], array[i]
  end
end
shuffleArray(MatchList)

currentMatch = {
   HomeTeamID = 0,
   AwayTeamID = 0,
   HomeKitIndex = 0,
   AwayKitIndex = 1
}

function Match:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  o.services = {
    SquadManagementService = o.api("SquadMgtService")
  }

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

function Match:publishMatchRows()
  for i, v in ipairs(MatchList) do
    v.data.HomeTeamCrest = {
      name = "$Crest",
      id = MatchList[i].HomeTeamID
    }
    v.data.AwayTeamCrest = {
      name = "$Crest",
      id = MatchList[i].AwayTeamID
    }
    v.data.HomeTeamName = self.loc.LocalizeString("TeamName_Abbr15_"..MatchList[i].HomeTeamID)
    v.data.AwayTeamName = self.loc.LocalizeString("TeamName_Abbr15_"..MatchList[i].AwayTeamID)
    v.data.HomeTeamShortName = self.loc.LocalizeString("TeamName_Abbr3_"..MatchList[i].HomeTeamID)
    v.data.AwayTeamShortName = self.loc.LocalizeString("TeamName_Abbr3_"..MatchList[i].AwayTeamID)
    v.data.clickAction = "act_match_play"
  end
  self.im.Publish(bndMatchList, MatchList)
end

function Match:PlayMatch(data)
  local currentMatchIndex = data.id + 1
  currentMatch.HomeTeamID = MatchList[currentMatchIndex].HomeTeamID
  currentMatch.AwayTeamID = MatchList[currentMatchIndex].AwayTeamID
  local buttonNo = {
    icon = "$IconButton_O",
    label = "LTXT_CMN_NO",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$IconButton_X",
    label = "LTXT_CMN_YES",
    clickEvents = {
      "evt_match_play",
      "evt_hide_popup"
    }
  }
  local popupData = {
    message = " ARE YOU READY TO PLAY THIS MATCH ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

return Match