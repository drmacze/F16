-------------------------------------------
-- MOD By LAOSIJI --
-------------------------------------------

local ClassicMatch = {}

local bndMatchList = "bnd_match_list"

local ACT_MATCH_PLAY = "act_match_play"
currentMode = 1

local ClassicMatchList = {
  { HomeTeamID = 241,AwayTeamID = 243,StadiumID1 = 6,StadiumID2 = 2,data = {} },
  { HomeTeamID = 10, AwayTeamID = 11, StadiumID1 = 246, StadiumID2 = 1, data = {} },
  { HomeTeamID = 11, AwayTeamID = 9,  data = {},  StadiumID1 = 1, StadiumID2 = 13  },
  { HomeTeamID = 1, AwayTeamID = 5, data = {},  StadiumID1 = 156, StadiumID2 = 28  },
  { HomeTeamID = 21, AwayTeamID = 22, data = {},  StadiumID1 = 137, StadiumID2 = 195  },
  { HomeTeamID = 73, AwayTeamID = 69, data = {},  StadiumID1 = 14, StadiumID2 = 33  },
  { HomeTeamID = 131682, AwayTeamID = 131681,  data = {},  StadiumID1 = 5, StadiumID2 = 5  },
  { HomeTeamID = 131681, AwayTeamID = 9, data = {},  StadiumID1 = 5, StadiumID2 = 13  },
  { HomeTeamID = 1876, AwayTeamID = 1877, data = {},  StadiumID1 = 195, StadiumID2 = 195  },
  { HomeTeamID = 598, AwayTeamID = 1041, data = {},  StadiumID1 = 229, StadiumID2 = 42  },
  { HomeTeamID = 1053, AwayTeamID = 598, data = {},  StadiumID1 = 260, StadiumID2 = 229  },
  { HomeTeamID = 1041, AwayTeamID = 383, data = {},  StadiumID1 = 42, StadiumID2 = 174  },
  { HomeTeamID = 383, AwayTeamID = 598, data = {},  StadiumID1 = 174, StadiumID2 = 229  },
  { HomeTeamID = 1043, AwayTeamID = 383, data = {},  StadiumID1 = 26, StadiumID2 = 174  },
  { HomeTeamID = 1043, AwayTeamID = 569, data = {},  StadiumID1 = 26, StadiumID2 = 177  },
  { HomeTeamID = 567, AwayTeamID = 1043, data = {},  StadiumID1 = 26, StadiumID2 = 26  },
  { HomeTeamID = 517, AwayTeamID = 1043, data = {},  StadiumID1 = 195, StadiumID2 = 26  },
  { HomeTeamID = 1035, AwayTeamID = 568, data = {},  StadiumID1 = 30, StadiumID2 = 172  },
  { HomeTeamID = 1629, AwayTeamID = 1048, data = {},  StadiumID1 = 195, StadiumID2 = 158  },
  { HomeTeamID = 1598, AwayTeamID = 1719, data = {},  StadiumID1 = 153, StadiumID2 = 195  },
  { HomeTeamID = 111052, AwayTeamID = 110059, data = {},  StadiumID1 = 195, StadiumID2 = 195  },
  { HomeTeamID = 111205, AwayTeamID = 111072,  data = {},  StadiumID1 = 1, StadiumID2 = 6 },
  { HomeTeamID = 1335, AwayTeamID = 1369, data = {},  StadiumID1 = 14, StadiumID2 = 264  },
  { HomeTeamID = 1370, AwayTeamID = 1337, data = {},  StadiumID1 = 195, StadiumID2 = 135  },
  { HomeTeamID = 1362, AwayTeamID = 1354, data = {},  StadiumID1 = 2, StadiumID2 = 34  }
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

function ClassicMatch:new(init)
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


function ClassicMatch:publishMatchRows()
  for i, v in ipairs(ClassicMatchList) do
    v.data.HomeTeamCrest = {
      name = "$Crest",
      id = ClassicMatchList[i].HomeTeamID
    }
    v.data.AwayTeamCrest = {
      name = "$Crest",
      id = ClassicMatchList[i].AwayTeamID
    }
    v.data.HomeTeamName = self.loc.LocalizeString("TeamName_Abbr15_"..ClassicMatchList[i].HomeTeamID)
    v.data.AwayTeamName = self.loc.LocalizeString("TeamName_Abbr15_"..ClassicMatchList[i].AwayTeamID)
    v.data.HomeTeamShortName = self.loc.LocalizeString("TeamName_Abbr3_"..ClassicMatchList[i].HomeTeamID)
    v.data.AwayTeamShortName = self.loc.LocalizeString("TeamName_Abbr3_"..ClassicMatchList[i].AwayTeamID)
    v.data.clickAction = "act_match_play"
  end
  self.im.Publish(bndMatchList, ClassicMatchList)
end

function ClassicMatch:PlayMatch(data)
  local currentMatchIndex = data.id + 1
  currentMatch.HomeTeamID = ClassicMatchList[currentMatchIndex].HomeTeamID
  currentMatch.AwayTeamID = ClassicMatchList[currentMatchIndex].AwayTeamID
  
  currentMatch.StadiumID1 = ClassicMatchList[currentMatchIndex].StadiumID1
  currentMatch.StadiumID2 = ClassicMatchList[currentMatchIndex].StadiumID2
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Confirm",
    clickEvents = {
      "evt_match_play",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "Do you want to play this match?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end


function ClassicMatch:finalize()
  self.im.Unsubscribe(bndMatchList)
  self.im.UnregisterAction(ACT_MATCH_PLAY)
end

return ClassicMatch
