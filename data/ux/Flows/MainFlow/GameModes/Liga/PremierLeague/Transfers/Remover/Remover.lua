-- Mod By MVN PROD --
-- League Mode Division --

local Remover = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
local BND_ELIGIBLE_SQUAD = "bnd_eligible_squad" -- New binding for squad eligibility
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
local matchesPlayed = 0
local eligibleSquad = 0 -- New variable to track squad eligibility

function Remover:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    o.services = {
        settingsService = o.api("SettingsService"),
        SquadManagementService = o.api("SquadMgtService")
    }

    o.currentOptions = o.services.settingsService.GetCurrentOptions()
    o.eligibleSquad = 0 -- Initialize eligibleSquad
    o.Init()
    o:checkSquadEligibility() -- Initial eligibility check

    o.im.Subscribe(bndMatchList, function()
        o:publishMatchRows()
        o:checkSquadEligibility() -- Check eligibility after publishing match rows
    end)

    o.im.Subscribe("bnd_match_label", function()
        o:publishMatchLabel()
    end)

    o.im.Subscribe("bnd_finish_label", function()
        o:publishFinishLabel()
    end)

    -- New subscription for squad eligibility
    o.im.Subscribe(BND_ELIGIBLE_SQUAD, function()
        o:_publishEligibleSquad()
    end)

    o.im.RegisterAction(ACT_ADVANCE, function(actionName, data)
        if data then
            o:PlayMatch(data)
            o:checkSquadEligibility() -- Check eligibility after match play attempt
        end
    end)

    return o
end

------------------------------------------------------------------------------------------

function Remover:Init()
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

-- New function to check squad eligibility
function Remover:checkSquadEligibility()
    print("[Remover]: checkSquadEligibility()")
    
    local teamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)
    
    if not teamLineup or #teamLineup == 0 then
        print("[Remover]: No players available for eligibility check")
        self.eligibleSquad = 0
        SquadElig = self.eligibleSquad
        self:_publishEligibleSquad()
        return
    end

    local hasSuspendedPlayer = false
    
    -- Check players in indexes 1-18 for suspension
    for i = 1, math.min(18, #teamLineup) do
        local player = teamLineup[i]
        if player and player.playerName then
            if isSuspended[player.playerName] == 2 then
                print("[Remover]: Found suspended player " .. player.playerName .. " at index " .. i)
                hasSuspendedPlayer = true
                break
            end
        else
            print("[Remover]: Warning: Invalid player data at index " .. i)
        end
    end

    self.eligibleSquad = hasSuspendedPlayer and 1 or 0
    SquadElig = self.eligibleSquad
    print("[Remover]: Squad eligibility status: " .. self.eligibleSquad)
    self:_publishEligibleSquad()
end

-- New function to publish squad eligibility status
function Remover:_publishEligibleSquad()
    print("[Remover]: _publishEligibleSquad() - Status: " .. self.eligibleSquad)
    self.im.Publish(BND_ELIGIBLE_SQUAD, {
        eligibleSquad = self.eligibleSquad,
        teamID = currentSelectedTeamID,
        timestamp = os.time()
    })
end


------------------------------------------------------------------------------------------

function Remover:publishMatchRows()
    local filteredRivalListData = {}
    local teamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)

    if not teamLineup or #teamLineup == 0 then
        print("[Remover:publishMatchRows]: Team lineup for teamID " .. currentSelectedTeamID .. " is empty or invalid.")
        self:Empty()
        return
    end

    -- Update eligibility before publishing match rows
    self:checkSquadEligibility()

    for _, player in ipairs(teamLineup) do
        local playerName = player.playerName
        -- Append eligibility status to player name for display
        if self.eligibleSquad == 1 and isSuspended[player.playerName] == 2 then
            playerName = playerName .. " (SUSPENDED)"
        end
        
        local position = tostring(player.position) .. SquadElig
        local rating = tostring(player.rating)
        local teamName = self.loc.LocalizeString("TeamName_Abbr3_" .. currentSelectedTeamID)

        local row = {
            data = {
                PlayerName = playerName,
                Position = position,
                Rating = rating,
                PlayerHead = {
                    name = "$Head",
                    id = player.CARD_ID
                },
                TeamName = teamName,
                TeamCrest = {
                    name = "$Crest",
                    id = currentSelectedTeamID
                },
                clickAction = "act_advance",
                EligibleSquad = self.eligibleSquad -- Add eligibility status to row data
            }
        }
        table.insert(filteredRivalListData, row)
    end

    self.im.Publish(bndMatchList, filteredRivalListData)
end

------------------------------------------------------------------------------------------

function Remover:PlayMatch(data)
    local currentMatchIndex = data.id + 1
    local teamID = currentSelectedTeamID

    local sourceTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
    local selectedTeamPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, currentSelectedTeamID, 0)

    -- Check squad eligibility before allowing match play

    if currentMatchIndex >= 1 and currentMatchIndex <= 3 then
        self:Important()
        return
    end

    if #sourceTeamPlayers <= 25 then
        self:Small()
        return
    end

    for _, player in ipairs(sourceTeamPlayers) do
        if not player.originalTeamID then
            player.originalTeamID = currentSelectedTeamID
        end
    end

    if currentMatchIndex > 0 and currentMatchIndex <= #sourceTeamPlayers then
        local playerToCheck = sourceTeamPlayers[currentMatchIndex]
        local positionConflict = true
        for _, teammate in ipairs(sourceTeamPlayers) do
            if teammate.originalTeamID == currentSelectedTeamID and
               teammate.position == playerToCheck.position and
               teammate.CARD_ID ~= playerToCheck.CARD_ID then
                positionConflict = false
                break
            end
        end

        if positionConflict then
            self:Small()
            return
        else
            self:Breakthrough()
        end

        GLOBAL_REPLAYER = playerToCheck.CARD_ID
        if GLOBAL_PLAYERIN > 0 then
            GLOBAL_TRANSFERDATE = GLOBAL_DATE_PLACEHOLDER
        end
    end

    self:checkSquadEligibility() -- Check eligibility after match play
end

------------------------------------------------------------------------------------------

-- New error popup for suspended squad
function Remover:SuspendedSquadError()
    local buttonYes = {
        icon = "$FooterIconNo",
        label = "Close",
        clickEvents = {
            "evt_hide_popup"
        }
    }
    local popupData = {
        title = "SQUAD INELIGIBLE",
        message = "Cannot play match: Squad contains suspended players",
        buttons = {buttonYes}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
end

function Remover:Breakthrough()
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

function Remover:Important()
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

function Remover:Small()
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

function Remover:finalize()
    self.im.UnregisterAction(ACT_ADVANCE)
    self.im.Unsubscribe("bnd_match_list")
    self.im.Unsubscribe("bnd_match_label")
    self.im.Unsubscribe("bnd_finish_label")
    self.im.Unsubscribe(BND_ELIGIBLE_SQUAD) -- Clean up new binding
    rivalListData = {}
end

return Remover

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --