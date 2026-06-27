-- MOD Created By Ma'ruf ID --
-- RMOD Created By LAOSIJI --
-------------------------------------------

local Match = {}

-- Create a global placeholder to track unique matchups and their counts
GLOBAL_MATCHUP_COUNT = GLOBAL_MATCHUP_COUNT
GLOBAL_MATCH = "what"
GLOBAL_MATCHUPS_PLAYED = {} -- Table to store unique matchups and their occurrence count

function Match:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    -- Dev1
    o.services = {
        gameSetup = o.api("GameSetupService"),
        gameState = o.api("GameStateService")
    }

    o.nav.AddActionHandler("setTeams", false, nil, function()
        local homeID = currentMatch.HomeTeamID
        local awayID = currentMatch.AwayTeamID

        o.homeTeamID = homeID
        o.awayTeamID = awayID
        o.homeKitIndex = currentMatch.HomeKitIndex
        o.awayKitIndex = currentMatch.AwayKitIndex

        -- Generate a unique identifier for the matchup
        local matchupKey = string.format("%d_vs_%d", math.min(homeID, awayID), math.max(homeID, awayID))

        -- Initialize the matchup count if it doesn't exist yet
        if not GLOBAL_MATCHUPS_PLAYED[matchupKey] then
            GLOBAL_MATCHUPS_PLAYED[matchupKey] = 0
        end

        -- Check if this matchup has occurred less than twice
        if GLOBAL_MATCHUPS_PLAYED[matchupKey] < 2 then
    -- Increment the matchup count for this matchup
    GLOBAL_MATCHUPS_PLAYED[matchupKey] = GLOBAL_MATCHUPS_PLAYED[matchupKey] + 1
    GLOBAL_MATCHUP_COUNT = GLOBAL_MATCHUP_COUNT + 1

    -- Update the global placeholder for the date by incrementing the day
    local dateString = GLOBAL_DATE_PLACEHOLDER
    local day, month, year = dateString:match("^(%d%d)/(%d%d)/(%d%d)$")  -- Extract day, month, year

    -- Convert to numbers and increment the day
    day = tonumber(day)
    month = tonumber(month)
    year = tonumber(year)

    -- Check if the day exceeds the number of days in the month
    local daysInMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}  -- Assume non-leap year for now
    if day < daysInMonth[month] then
        day = day + 1
    else
        -- If the day exceeds, move to the next month
        day = 1
        month = month + 1
        if month > 12 then
            month = 1
            year = year + 1  -- Increment the year if December is passed
        end
    end

    -- Format the new date
    local newDate = string.format("%02d/%02d/%02d", day, month, year)

    -- Update the global date placeholder
    GLOBAL_DATE_PLACEHOLDER = newDate

    -- Print the updated date and matchup information
	    print("New matchup recorded: " .. matchupKey)
	    print("Total matchups played: " .. GLOBAL_MATCHUP_COUNT)
	    print("New date: " .. GLOBAL_DATE_PLACEHOLDER)
	else
	    print("Matchup " .. matchupKey .. " has already occurred twice, not counting further.")
	end

        o.services.gameState.PauseAIandRendering(false)

        if homeID == currentSelectedTeamID then
            -- Current team is the home team
            o.services.gameSetup.SetTeam(0, homeID)
            o.services.gameSetup.SetTeam(1, awayID)
            o.services.gameState.SetUserSideAsHome()
        elseif awayID == currentSelectedTeamID then
            -- Current team is the away team
            o.services.gameSetup.SetTeam(1, awayID)
            o.services.gameSetup.SetTeam(0, homeID)
            o.services.gameState.SetUserSideAsAway()
        end

        o.services.gameSetup.SetPreferredKitId(0, o.homeTeamID * 4096 + o.homeKitIndex)
        o.services.gameSetup.SetPreferredKitId(1, o.awayTeamID * 4096 + o.awayKitIndex)
        o.services.gameSetup.CommitKitSelect()
    end)

    return o
end

return Match