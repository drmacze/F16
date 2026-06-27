-- Mod By MVN PROD --
-- League Mode Division --

local PlayerSelect = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
GLOBAL_PLAYERIN = 0

ligaId = 1
mode = 2

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

-- Dev2
local rivalListData = {}
local matchesPlayed = 0  -- Counter to track the number of matches played

function PlayerSelect:new(init)
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

function PlayerSelect:Init()
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

function PlayerSelect:publishMatchRows()



    -- Initialize an empty table for rival list data

    local filteredRivalListData = {}



    -- Fetch the lineup for the currentSelectedTeamID

    local teamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, GLOBAL_TEAMBUY, 0)
    if not GLOBAL_TEAMBUY then

        print("[PlayerSelect:publishMatchRows]: Team lineup for teamID " .. currentSelectedTeamID .. " is empty or invalid.")

        self:Empty()

        return

    end



    if not teamLineup or #teamLineup == 0 then

        print("[PlayerSelect:publishMatchRows]: Team lineup for teamID " .. currentSelectedTeamID .. " is empty or invalid.")

        self:Empty()

        return

    end
    
    



    -- Iterate through all players in the lineup and add them to the data

    for _, player in ipairs(teamLineup) do

        local playerName = player.playerName

        local position = tostring(player.position)

        local rating = tostring(player.rating)

        local teamName = self.loc.LocalizeString("TeamName_Abbr3_" .. GLOBAL_TEAMBUY)



        local row = {

            data = {

                PlayerName = playerName,

                Position = position,

                Rating = rating,

                PlayerTeam = teamName,

                PlayerHead = {

                    name = "$Head",

                    id = player.CARD_ID

                },

                Player1Team = {

                    name = "$Crest",

                    id = GLOBAL_TEAMBUY

                },

                clickAction = "act_advance",

            }

        }



        table.insert(filteredRivalListData, row)

    end



    -- Publish the player list

    self.im.Publish(bndMatchList, filteredRivalListData)

end

------------------------------------------------------------------------------------------

function PlayerSelect:publishMatchLabel()
  -- Initialize match count
  local totalMatchesPlayed = 1
  local matchInfoLabel = ""  -- Variable to store match info

  -- Always display the total matches played, global matchup count, and the date
  local matchLabel = "Matches Played: " .. GLOBAL_REPLAYER ..
                     " | Unique Matchups: " .. GLOBAL_TEAMBUY .. 
                     " | Date: " .. GLOBAL_DATE_PLACEHOLDER

  -- Now append match information (team names and scores) for Team ID 1 vs Team ID 110
  for _, match in ipairs(rivalListData) do
    local homeID = match.homeID
    local awayID = match.awayID
    local homeScore = match.homeScore
    local awayScore = match.awayScore

    -- Check if the match is between Team ID 1 and Team ID 110
    if (homeID == 144 and awayID == 9) or (homeID == 144 and awayID == 9) then
      -- Get the team names
      local homeTeamName = self.loc.LocalizeString("TeamName_Abbr15_" .. homeID)
      local awayTeamName = self.loc.LocalizeString("TeamName_Abbr15_" .. awayID)

      -- Append the match details to the matchInfoLabel
      matchInfoLabel = matchInfoLabel .. "\n" .. homeTeamName .. " vs " .. awayTeamName ..
                       " | " .. homeScore .. " - " .. awayScore
    end
  end

  -- Publish the match label with match information
  self.im.Publish("bnd_match_label", matchLabel .. matchInfoLabel)
end

------------------------------------------------------------------------------------------
function PlayerSelect:PlayMatch(data)
  local currentMatchIndex = data.id + 1
  local teamID = GLOBAL_TEAMBUY  -- Set teamID to GLOBAL_TEAMBUY
  local sourceTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)

  -- Ensure every player has originalTeamID set to GLOBAL_TEAMBUY
  for _, player in ipairs(sourceTeamPlayers) do
    if not player.originalTeamID then
      player.originalTeamID = GLOBAL_TEAMBUY
    end
  end

  -- Check if the player index is valid
  if currentMatchIndex > 0 and currentMatchIndex <= #sourceTeamPlayers then
    -- Get the player's details from the lineup at the currentMatchIndex
    local playerToCheck = sourceTeamPlayers[currentMatchIndex]

    -- Ensure there are no other players in the original team playing the same position
    local positionConflict = true
    for _, teammate in ipairs(sourceTeamPlayers) do
      if teammate.originalTeamID == GLOBAL_TEAMBUY and
         teammate.position == playerToCheck.position and
         teammate.CARD_ID ~= playerToCheck.CARD_ID then
        positionConflict = false
        break
      end
    end

    -- Call Insufficient if there's a conflict, or proceed with rating checks
    if positionConflict then
      self:Small()
      return
    elseif playerToCheck.rating > 95 then
      self:Insufficient() -- Call Insufficient if rating is greater than 95
      return
    else
      -- Check GLOBAL_FUNDS
      if GLOBAL_FUNDS < 10000000 then
        self:Insufficient() -- Call Insufficient if funds are insufficient
        return
      else
        self:Breakthrough() -- Call Breakthrough if funds are sufficient
        GLOBAL_FUNDS = GLOBAL_FUNDS - 10000000 -- Subtract 50000000 from GLOBAL_FUNDS
        print("[PlayerSelect]: Deducted 50000000 from GLOBAL_FUNDS. Remaining funds: " .. GLOBAL_FUNDS)
      end
    end

    -- Proceed with the rest of the logic if needed
    GLOBAL_PLAYERIN = playerToCheck.CARD_ID  -- Assign the player's CARD_ID to GLOBAL_PLAYERIN

    -- Check if GLOBAL_PLAYERIN is 0 and update GLOBAL_TRANSFERDATE
    if GLOBAL_PLAYERIN > 0 then
      GLOBAL_TRANSFERDATE = GLOBAL_DATE_PLACEHOLDER  -- Record the date
    end
  end
end


------------------------------------------------------------------------------------------

function PlayerSelect:Breakthrough()
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
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "Negotiation",
    message = "Proceed with transfer?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function PlayerSelect:Empty()

  local buttonNo = {

    icon = "$FooterIconNo",

    label = "Not Now",

    clickEvents = {

      "evt_back",	
      "evt_hide_popup"

    }

  }

  local buttonYes = {

    icon = "$FooterIconYes",

    label = "Take Me There",

    clickEvents = {

      "evt_team",
      "evt_hide_popup"

    }

  }

  local popupData = {

    title = "SELECT TEAM",

    message = "You haven't selected a Team",

    buttons = {buttonNo, buttonYes}

  }

  self.nav.Event(nil, "evt_show_popup", popupData)

end

function PlayerSelect:Insufficient()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "Tranfer Negotiation failed",
    message = "Not enough Transfer funds",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function PlayerSelect:Full()

  local buttonYes = {

    icon = "$FooterIconNo",

    label = "Close",

    clickEvents = {

      "evt_hide_popup"

    }

  }

  local popupData = {

    title = "Transfer Failed",

    message = "Squad size is too full",

    buttons = {buttonYes}

  }

  self.nav.Event(nil, "evt_show_popup", popupData)

end

function PlayerSelect:Small()

  local buttonYes = {

    icon = "$FooterIconNo",

    label = "Close",

    clickEvents = {

      "evt_hide_popup"

    }

  }

  local popupData = {

    title = "Transfer Failed",

    message = "We are not looking to sell \n any of our players at this time",

    buttons = {buttonYes}

  }

  self.nav.Event(nil, "evt_show_popup", popupData)

end


function PlayerSelect:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_match_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
  
end

return PlayerSelect

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --