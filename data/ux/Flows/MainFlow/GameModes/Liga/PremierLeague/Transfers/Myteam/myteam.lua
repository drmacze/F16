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



    -- Initialize an empty table for rival list data

    local filteredRivalListData = {}



    -- Fetch the lineup for the currentSelectedTeamID

    local teamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)



    if not teamLineup or #teamLineup == 0 then

        print("[Liga:publishMatchRows]: Team lineup for teamID " .. currentSelectedTeamID .. " is empty or invalid.")

        self:Empty()

        return

    end



    -- Iterate through all players in the lineup and add them to the data

    for _, player in ipairs(teamLineup) do

        local playerName = player.playerName .. (isSuspended[playerName] or 0)

        local position = tostring(player.position) .. "now"

        local rating = tostring(player.rating)

        local teamName = self.loc.LocalizeString("TeamName_Abbr3_" .. currentSelectedTeamID)



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

                    id = currentSelectedTeamID

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


------------------------------------------------------------------------------------------

function Liga:PlayMatch(data)



  local currentMatchIndex = data.id + 1

  local teamID = currentSelectedTeamID  -- Set teamID to GLOBAL_TEAMBUY



  local sourceTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)

  local selectedTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)



  -- If the currentMatchIndex is below 11 (1-11), call Small function

  if currentMatchIndex >= 1 and currentMatchIndex <= 3 then

    self:Important()

    return

  end



  -- Check squad sizes for GLOBAL_TEAMBUY and currentSelectedTeamID

  if #sourceTeamPlayers <= 25 then

    self:Small()

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



    -- Call Small if there's a conflict, or proceed with rating checks

    if positionConflict then

      self:Small()

      return

    else

      self:Breakthrough() -- Call Breakthrough if funds are sufficient

    end



    -- Proceed with the rest of the logic if needed

    GLOBAL_REPLAYER = playerToCheck.CARD_ID  -- Assign the player's CARD_ID to GLOBAL_PLAYERIN



    -- Check if GLOBAL_PLAYERIN is 0 and update GLOBAL_TRANSFERDATE

    if GLOBAL_PLAYERIN > 0 then

      GLOBAL_TRANSFERDATE = GLOBAL_DATE_PLACEHOLDER  -- Record the date

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
      "evt_back",
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "RELEASE",
    message = "DO you want to release player?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
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

function Liga:Small()

  local buttonYes = {

    icon = "$FooterIconNo",

    label = "Close",

    clickEvents = {

      "evt_hide_popup"

    }

  }

  local popupData = {

    title = "RELEASE",

    message = "Squad is too small",

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

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --