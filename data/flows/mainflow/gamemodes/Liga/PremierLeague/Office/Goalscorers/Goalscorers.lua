-----------------------------------------------
---- THEME BY SEPTIAWAN ----
-----------------------------------------------

local Liga = {}
local bndMatchList = "bnd_match_list"
local bndLeagueBg = "bnd_league_bg"
local bndLeagueLogo = "bnd_league_logo"
local bndTeamLogo = "bnd_team_logo"
local bndTeamName = "bnd_team_name"
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
  
  o.im.Subscribe(bndLeagueBg, function()  
    o.im.Publish(bndLeagueBg, {name = "$_LeagueBg", id = currentSelectedTeamID})   
  end)
  
  o.im.Subscribe(bndLeagueLogo, function()  
    o.im.Publish(bndLeagueLogo, {name = "$_LeagueLogo", id = currentSelectedTeamID})   
  end)
  
  o.im.Subscribe(bndTeamLogo, function()  
    o.im.Publish(bndTeamLogo, {name = "$Crest64x64", id = currentSelectedTeamID})   
  end)
  
  o.im.Subscribe(bndTeamName, function()  
        o.im.Publish(bndTeamName, o.loc.LocalizeString("TeamName_Abbr15_"..currentSelectedTeamID))       
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
      homeScorers = LigaGroupingList[i]["data"].homeScorers,  -- Include home scorers
      awayScorers = LigaGroupingList[i]["data"].awayScorers,  -- Include away scorers
      
      data = {}
    }
    table.insert(rivalListData, obj)
  end
end

------------------------------------------------------------------------------------------

function Liga:publishMatchRows()
    -- Check if GLOBAL_MATCHUP_COUNT is zero
    if GLOBAL_MATCHUP_COUNT == 0 then
        print("[Liga:publishMatchRows]: GLOBAL_MATCHUP_COUNT is zero. No matches to process.")
        self:NoScorer()
        return
    end

    -- Initialize an empty table for rival list data
    local filteredRivalListData = {}

    -- Fetch the lineups for all teams in TeamList
    local combinedLineup = {}
    for _, teamID in ipairs(TeamList) do
        local lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
        if lineup and #lineup > 0 then
            for _, player in ipairs(lineup) do
                player.teamID = teamID -- Track the team ID for each player
                table.insert(combinedLineup, player)
            end
        end
    end

    -- Check if the combined lineup is empty
    if #combinedLineup == 0 then
        print("[Liga:publishMatchRows]: Combined lineup for TeamList is empty or invalid.")
        self:Empty()
        return
    end

    -- Function to count goals for a specific CARD_ID, limited by GLOBAL_MATCHUP_COUNT
    local function countPlayerGoals(CARD_ID)
        local totalGoals = 0
        local maxMatches = GLOBAL_MATCHUP_COUNT * 10 -- Determine the number of matches to process

        for i, match in ipairs(rivalListData or {}) do
            if i > maxMatches then break end -- Process matches up to the calculated limit

            -- Check home scorers
            for _, scorer in ipairs(match.homeScorers or {}) do
                if scorer == CARD_ID then
                    totalGoals = totalGoals + 1
                end
            end
            -- Check away scorers
            for _, scorer in ipairs(match.awayScorers or {}) do
                if scorer == CARD_ID then
                    totalGoals = totalGoals + 1
                end
            end
        end
        return totalGoals
    end
    

    -- Add total goal counts to each player (from the limited matches + GOALS[CARD_ID])
    for _, player in ipairs(combinedLineup) do
        local normalGoals = countPlayerGoals(player.CARD_ID)
        local additionalGoals = GOALS[player.CARD_ID] or 0
        player.goalCount = normalGoals + additionalGoals
    end

    -- Sort the combined lineup by goal count (highest to lowest)
    table.sort(combinedLineup, function(a, b)
        return a.goalCount > b.goalCount
    end)

    -- Limit the combined lineup to the top 50 players
    local topPlayers = {}
    for i = 1, math.min(50, #combinedLineup) do
        table.insert(topPlayers, combinedLineup[i])
    end

    -- Iterate through the top 50 players and add them to the data
    for rank, player in ipairs(topPlayers) do
        local playerName = player.playerName
        local position = tostring(player.position)
        local rating = tostring(player.rating)
        local teamName = self.loc.LocalizeString("TeamName_Abbr3_" .. player.teamID)

        -- Create the row with dynamic rank value
        local row = {
            data = {
                PlayerName = playerName,
                Position = position,
                Rating = rating,
                TeamName = teamName,
                Goals = player.goalCount,
                Rank = tostring(rank) .. "", -- Assign the rank based on position
                PlayerHead = {
                    name = "$Head",
                    id = player.CARD_ID
                },
                TeamCrest = {
                    name = "$Crest64x64",
                    id = player.teamID
                },
                Nationality = {
                    name = "$Flag128x128",
                    id = player.nationalityID
                },
            }
        }

        table.insert(filteredRivalListData, row)
    end

    -- Publish the player list
    self.im.Publish(bndMatchList, filteredRivalListData)
end

------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------

function Liga:PlayMatch(data)
    local currentMatchIndex = data.id + 1
    local teamID = currentSelectedTeamID -- Set teamID to GLOBAL_TEAMBUY

    local sourceTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
    local selectedTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)

    -- Check for the player with CARD_ID 263620 in selectedTeamPlayers
    for index, player in ipairs(selectedTeamPlayers) do
	    if player.CARD_ID == 263620 then
	        if currentMatchIndex == index then
	            GLOBAL_TEAMSELL = 1 
	            GLOBAL_REPLAYER = player.CARD_ID
	            self:Transfer()
	            return 
	        end
	    end
	end
	-- If we've reached here, no player matched
	GLOBAL_TEAMSELL = 322

    -- If the currentMatchIndex is below 11 (1-11), call Important function
    if currentMatchIndex >= 1 and currentMatchIndex <= 3 then
        self:Important()
        return
    end

    -- Check squad sizes for GLOBAL_TEAMBUY and currentSelectedTeamID
    if #sourceTeamPlayers <= 20 then
        self:Breakthrough()
        return
    end

    -- Ensure every player has originalTeamID set to GLOBAL_TEAMBUY
    for _, player in ipairs(sourceTeamPlayers) do
        if not player.originalTeamID then
            player.originalTeamID = currentSelectedTeamID
        end
    end

    -- Check if the player index is valid
    if currentMatchIndex > 0 and currentMatchIndex <= #sourceTeamPlayers then
        -- Get the player's details from the lineup at the currentMatchIndex
        local playerToCheck = sourceTeamPlayers[currentMatchIndex]

        -- Ensure there are no other players in the original team playing the same position
        local positionConflict = true
        for _, teammate in ipairs(sourceTeamPlayers) do
            if teammate.originalTeamID == currentSelectedTeamID and
               teammate.position == playerToCheck.position and
               teammate.CARD_ID ~= playerToCheck.CARD_ID then
                positionConflict = false
                break
            end
        end

        -- Call Breakthrough if there's a conflict, or proceed with rating checks
        if positionConflict then
            self:Breakthrough()
            return
        else
            self:Breakthrough() -- Call Breakthrough if funds are sufficient
        end

        -- Proceed with the rest of the logic if needed
        GLOBAL_REPLAYER = playerToCheck.CARD_ID -- Assign the player's CARD_ID to GLOBAL_PLAYERIN

        -- Check if GLOBAL_PLAYERIN is 0 and update GLOBAL_TRANSFERDATE
        if GLOBAL_PLAYERIN > 0 then
            GLOBAL_TRANSFERDATE = GLOBAL_DATE_PLACEHOLDER -- Record the date
        end
    end
end


------------------------------------------------------------------------------------------

function Liga:Breakthrough()
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = {
      "evt_hide_popup"
      
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Finalize",
    clickEvents = {
      "evt_squad",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "RELEASE",
    message = "DO you want to release player?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
  mode = 4
end

function Liga:Transfer()
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = {
      "evt_hide_popup"
      
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Finalize",
    clickEvents = {
      "evt_squad",
      "evt_back",
      "evt_back",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "RELEASE",
    message = "Confirm player transfer?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
  mode = 4
end

function Liga:Important()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "THE BOARD",
    message = "This player is too important \n to the squad",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Liga:NoScorer()

  local buttonYes = {

    icon = "$FooterIconNo",

    label = "Close",

    clickEvents = {

      "evt_hide_popup",
      "evt_back"

    }

  }

  local popupData = {

    title = "",

    message = "No goalscorers yet",

    buttons = {buttonYes}

  }

  self.nav.Event(nil, "evt_show_popup", popupData)

end


function Liga:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_match_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
  
end

return Liga