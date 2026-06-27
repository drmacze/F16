-------------------------------------------
-- MOD By LAOSIJI --
-------------------------------------------

local ClassicMatch = {}

local bndMatchList = "bnd_match_list"

local ACT_MATCH_PLAY = "act_match_play"


local ClassicMatchList = {
  { HomeTeamID = 1,AwayTeamID = 5,StadiumID1 = 156,StadiumID2 = 28,data = {} },
  { HomeTeamID = 10, AwayTeamID = 11, StadiumID1 = 246, StadiumID2 = 1, data = {} },
  { HomeTeamID = 243, AwayTeamID = 241,  data = {},  StadiumID1 = 2, StadiumID2 = 6  },
  { HomeTeamID = 481, AwayTeamID = 461, data = {},  StadiumID1 = 192, StadiumID2 = 10  },
  { HomeTeamID = 47, AwayTeamID = 44, data = {},  StadiumID1 = 5, StadiumID2 = 5  },
  { HomeTeamID = 52, AwayTeamID = 45, data = {},  StadiumID1 = 157, StadiumID2 = 247  },
  { HomeTeamID = 22, AwayTeamID = 21,  data = {},  StadiumID1 = 9, StadiumID2 = 137  },
  { HomeTeamID = 73, AwayTeamID = 219, data = {},  StadiumID1 = 14, StadiumID2 = 29  },
  { HomeTeamID = 111466, AwayTeamID = 1413, data = {},  StadiumID1 = 195, StadiumID2 = 195  },
  { HomeTeamID = 1362, AwayTeamID = 1337, data = {},  StadiumID1 = 195, StadiumID2 = 195  },
  { HomeTeamID = 1369, AwayTeamID = 1370, data = {},  StadiumID1 = 195, StadiumID2 = 195  }
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
    title = "INFO",
    message = " ARE YOU READY TO START THE GAME ? *",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end


function ClassicMatch:finalize()
  self.im.Unsubscribe(bndMatchList)
  self.im.UnregisterAction(ACT_MATCH_PLAY)
end

return ClassicMatch
