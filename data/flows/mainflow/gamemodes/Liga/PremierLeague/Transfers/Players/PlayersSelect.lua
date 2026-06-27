-- Mod By MVN PROD --
-- League Mode Division --

local PlayersSelect = {}
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

function PlayersSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
  }

  o.currentOptions = o.services.settingsService.GetCurrentOptions()

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
  o:safeExit()

  return o
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
function PlayersSelect:safeExit()
  if not teamIDs then
    self:Help()
  end
end

-- Helper function to check if a value exists in a table

function table.contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end



function PlayersSelect:publishMatchRows()
    local filteredRivalListData = {}
    GLOBAL_CARDID_LIST = {}
    GLOBAL_TEAMID_LIST = {}

    local searchText = text and text:lower() or ""
    local textLength = #searchText
    local maxResults = (textLength < 4) and 50 or math.huge  -- 50 if < 4, unlimited if >= 4
    local currentSelectedTeamID = currentSelectedTeamID or CURRENTCLUBID  -- Fallback to CURRENTCLUBID

    -- Precompute lineup cache for current selected team to skip later
    local selectedTeamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)
    local skipPlayers = {}
    if selectedTeamLineup and #selectedTeamLineup > 0 then
        for _, player in ipairs(selectedTeamLineup) do
            skipPlayers[player.CARD_ID] = true
        end
    end

    -- Define the leagues to process
    local leaguesToProcess = {
        teamIDs  -- Assuming teamIDs is a table of team IDs defined elsewhere
    }

    -- Worker function for coroutines
    local function processLeague(league, skipPlayers, searchText, maxResults, results, restrictToClub)
        for _, teamID in ipairs(league) do
            -- If restrictToClub is true, only process CURRENTCLUBID
            if not restrictToClub or teamID == CURRENTCLUBID then
                if teamID ~= currentSelectedTeamID or restrictToClub then  -- Include CURRENTCLUBID if restricted
                    local teamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
                    if teamLineup then
                        for _, player in ipairs(teamLineup) do
                            if not skipPlayers[player.CARD_ID] then
                                local playerNameLower = player.playerName:lower()
                                -- If searchText is empty and restricted, include all players from CURRENTCLUBID
                                if (searchText == "" and restrictToClub) or 
                                   playerNameLower == searchText or 
                                   playerNameLower:find(searchText, 1, true) then
                                    table.insert(results, {
                                        player = player,
                                        teamID = teamID
                                    })
                                    if #results >= maxResults then
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Create coroutines for each league in leaguesToProcess
    local coroutines = {}
    local results = {}
    local restrictToClub = (searchText == "")  -- Restrict to CURRENTCLUBID if text is empty
    for _, league in ipairs(leaguesToProcess) do
        local co = coroutine.create(function()
            processLeague(league, skipPlayers, searchText, maxResults, results, restrictToClub)
        end)
        table.insert(coroutines, co)
    end

    -- Run coroutines in parallel
    local activeCoroutines = #coroutines
    while activeCoroutines > 0 do
        for i, co in ipairs(coroutines) do
            if coroutine.status(co) ~= "dead" then
                local success, err = coroutine.resume(co)
                if not success then
                    print("Coroutine error:", err)
                end
            else
                activeCoroutines = activeCoroutines - 1
            end
        end
    end

    -- Build the final result list
    for i, result in ipairs(results) do
        local player = result.player
        local teamID = result.teamID
        GLOBAL_CARDID_LIST[i] = player.CARD_ID
        GLOBAL_TEAMID_LIST[i] = teamID
        filteredRivalListData[i] = {
            data = {
                PlayerName = player.playerName,
                Rating = tostring(player.rating),
                Position = tostring(player.position),
                PlayerHead = { name = "$Head", id = player.CARD_ID },
                TeamName = self.loc.LocalizeString("TeamName_Abbr3_" .. teamID),
                TeamCrest = { name = "$Crest", id = teamID },
                clickAction = "act_advance"
            }
        }
    end

    -- Publish the filtered players to the UI
    self.im.Publish(bndMatchList, filteredRivalListData)
end

-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

function PlayersSelect:PlayMatch(data)

    -- Get the current match index
    currentMatchIndex = data.id + 1

    -- Check if the player's CARD_ID matches any SLOTPL1-10
    local currentCardID = GLOBAL_CARDID_LIST[currentMatchIndex]
    if currentCardID == SLOTPL1 or currentCardID == SLOTPL2 or currentCardID == SLOTPL3 or 
       currentCardID == SLOTPL4 or currentCardID == SLOTPL5 or currentCardID == SLOTPL6 or 
       currentCardID == SLOTPL7 or currentCardID == SLOTPL8 or currentCardID == SLOTPL9 or 
       currentCardID == SLOTPL10 then
        -- If a match is found, call Present and exit the function
        self:Present()
        return
    end

    -- Assign the CARD_ID and teamID to the first available slot
    if not SLOTPL1 then
        SLOTPL1 = currentCardID
        SLOTTM1 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL2 then
        SLOTPL2 = currentCardID
        SLOTTM2 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL3 then
        SLOTPL3 = currentCardID
        SLOTTM3 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL4 then
        SLOTPL4 = currentCardID
        SLOTTM4 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL5 then
        SLOTPL5 = currentCardID
        SLOTTM5 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL6 then
        SLOTPL6 = currentCardID
        SLOTTM6 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL7 then
        SLOTPL7 = currentCardID
        SLOTTM7 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL8 then
        SLOTPL8 = currentCardID
        SLOTTM8 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL9 then
        SLOTPL9 = currentCardID
        SLOTTM9 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    elseif not SLOTPL10 then
        SLOTPL10 = currentCardID
        SLOTTM10 = GLOBAL_TEAMID_LIST[currentMatchIndex]
    end

    -- Call Breakthrough, passing the current match index
    self:Breakthrough(currentMatchIndex)
end


------------------------------------------------------------------------------------------

function PlayersSelect:Breakthrough()
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
      "evt_back",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "Add player to transfer list?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function PlayersSelect:Empty()
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

function PlayersSelect:Present()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup",
      "evt_back"
    }
  }
  local popupData = {
    title = "FAILED",
    message = "The player is already on the transfer list.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function PlayersSelect:Help()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup",
      "evt_back"
    }
  }
  local popupData = {
    title = "SELECT LEAGUE",
    message = "You have not selected a league.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function PlayersSelect:Full()
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

function PlayersSelect:Small()
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


function PlayersSelect:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_match_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
  
end

return PlayersSelect

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --