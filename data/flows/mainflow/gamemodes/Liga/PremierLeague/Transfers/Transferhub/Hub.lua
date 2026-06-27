-- Mod By MVN PROD --
-- League Mode Division --

local Liga = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
GLOBAL_PLAYERIN = 0

ligaId = 1

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

-- Dev2
local rivalListData = {}
local matchesPlayed = 0  -- Counter to track the number of matches played

function Liga:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
  }

  o.currentOptions = o.services.settingsService.GetCurrentOptions()
  o.Init()

  o.im.Subscribe(bndMatchList, function()
     o:publishMatchRows()
  end)

  o.im.Subscribe("bnd_match_label", function()
    o:publishMatchLabel()
  end)

  o.im.Subscribe("bnd_finish_label", function()
    o:publishFinishLabel()
  end)

  o.im.RegisterAction(ACT_ADVANCE, function(actionName, data)
    if data then
      o:PlayMatch(data)
    end
  end)

  return o
end

------------------------------------------------------------------------------------------

function Liga:Init()
  local LigaGroupingList = LigaGrouping[ligaId]
  for i = 1, table.getn(LigaGroupingList) do
    local obj = {
      homeID = LigaGroupingList[i][1],
      awayID = LigaGroupingList[i][2],
      homeScore = LigaGroupingList[i][4],
      awayScore = LigaGroupingList[i][5],
      
      clickAction = "act_advance",
      isUnlock = LigaGroupingList[i][9],
      data = {}
    }
    table.insert(rivalListData, obj)
  end
end

------------------------------------------------------------------------------------------

function Liga:publishMatchRows()
    local filteredRivalListData = {}
    
    local function createRow(teamID, playerID, rowIndex)
        local teamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
        
        if not teamLineup or #teamLineup == 0 then
            print("[Liga:publishMatchRows]: Team lineup for teamID " .. teamID .. " is empty or invalid.")
            self:Empty()
            return nil
        end
        
        local selectedPlayer = nil
        for _, player in ipairs(teamLineup) do
            if player.CARD_ID == playerID then
                selectedPlayer = player
                break
            end
        end
        
        if not selectedPlayer then
            print("[Liga:publishMatchRows]: No player found with CARD_ID " .. playerID .. " in teamID " .. teamID)
            return nil
        end
        
        local teamName = self.loc.LocalizeString("TeamName_Abbr15_" .. teamID)
        return {
            id = rowIndex - 1, -- Zero-based index for click action
            data = {
                PlayerName = selectedPlayer.playerName,
                Position = selectedPlayer.position,
                Rating = selectedPlayer.rating,
                PlayerHead = { name = "$Head", id = selectedPlayer.CARD_ID },
                TeamCrest = { name = "$Crest", id = teamID },
                TeamName = self.loc.LocalizeString("TeamName_Abbr3_" .. teamID),
                clickAction = "act_advance",
                TeamNameFontColor = "0x4A2C6D",
                FontColor = "0x4A2C6D"
            }
        }
    end

    for i = 1, 30 do
        local teamVar = _G["SLOTTM" .. i]
        local playerVar = _G["SLOTPL" .. i]
        
        if teamVar and playerVar then
            local row = createRow(teamVar, playerVar, i)
            if row then
                table.insert(filteredRivalListData, row)
            end
        end
    end
    
    self.im.Publish(bndMatchList, filteredRivalListData)
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

function Liga:PlayMatch(data)
    local currentMatchIndex = data.id + 1

    -- Reindex slots if there are empty (nil) slots or duplicates
    local tempSLOTTM = {}
    local tempSLOTPL = {}
    local seenPairs = {}
    local players = getCachedTeamPlayers(currentSelectedTeamID)
    
    
    if #players > 49 then
	    self:Full()
	    return
	end
   
	-- Football transfer windows (typical periods: Summer ~June-August, Winter ~January)
	local date = GLOBAL_DATE_PLACEHOLDER
	local day, month, year = date:match("(%d+)/(%d+)/(%d+)")
	month = tonumber(month)
	
	if not ((month >= 6 and month <= 8) or month == 1) then
	    self:Unavailable()
	    return
	end
    
    for i = 1, 30 do
        local tmKey = _G["SLOTTM" .. i]
        local plKey = _G["SLOTPL" .. i]

        if tmKey and plKey then
            local pairKey = tostring(tmKey) .. ":" .. tostring(plKey)
            if not seenPairs[pairKey] then
                seenPairs[pairKey] = true
                table.insert(tempSLOTTM, tmKey)
                table.insert(tempSLOTPL, plKey)
            end
        end
    end

    -- Clear original slots and reassign unique valid values sequentially
    for i = 1, 30 do
        _G["SLOTTM" .. i] = tempSLOTTM[i] or nil
        _G["SLOTPL" .. i] = tempSLOTPL[i] or nil
    end

    -- Assign teamID and player ID based on currentMatchIndex
    if currentMatchIndex <= #tempSLOTTM then  -- Ensure index is within bounds
        GLOBAL_TEAMBUY = tempSLOTTM[currentMatchIndex]
        GLOBAL_PLAYERINSTALL = tempSLOTPL[currentMatchIndex]
        SCOUTINDEX = currentMatchIndex
    else
        print("[Liga:PlayMatch]: Index out of bounds. No match data for index " .. currentMatchIndex)
        return  -- or handle this case appropriately
    end

    -- Check if there is a selected match index
    if currentMatchIndex then
        self:Breakthrough() -- Call self:Breakthrough()
    end
end
------------------------------------------------------------------------------------------

function Liga:Breakthrough()
  local buttonRemove = {
    icon = "$FooterIconNo",
    label = "Remove",
    clickEvents = {
      "evt_remove",
      "evt_hide_popup"
    }
  }
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Negotiate",
    clickEvents = {
      "evt_squad",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "NEGOTIATION",
    message = "Do you want to try to negotiate with the player's representatives?",
    buttons = {buttonRemove, buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:Empty()
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Not now",
    clickEvents = {
      "evt_back",	
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Analyze",
    clickEvents = {
      "evt_team",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "SELECT TEAM",
    message = "You have not selected a team.",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:Unavailable()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "END",
    message = "The transfer window is currently closed.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:uninterested()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "FAILED",
    message = "The team does not want to sell this player at the moment.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:Full()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "FAILED",
    message = "Your team has reached the maximum player limit.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:Small()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "FAILED",
    message = "The team does not want to sell any players at the moment.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:Continue()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "FAILED",
    message = "The team does not want to sell any players at the moment.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_hide_popup", popupData)
end


function Liga:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_match_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
  
end

return Liga

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --