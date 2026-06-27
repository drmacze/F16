-- data.lua
-- Generates a structured davunSave string for DAVUNPES save data
-- Format: v1|complete|<FIELD_NAME>value</FIELD_NAME>|...
-- Delimiters: | (fields), ; (list items), : (key-value pairs)
-- Version: 1.0 (April 2025)
-- Notes: Designed for clarity, extensibility, and robust parsing by the website

-- Configuration
local VERSION = "v1"
local FIELD_DELIMITER = "|"
local LIST_DELIMITER = ";"
local KV_DELIMITER = ":"

-- Constants
local SCORELINE_TO_SYMBOL = {
    ["0-0"]="q", ["1-0"]="w", ["2-0"]="e", ["3-0"]="r", ["4-0"]="t", ["5-0"]="y", ["6-0"]="u", ["7-0"]="i",
    ["1-1"]="o", ["2-2"]="p", ["3-3"]="a", ["4-4"]="s", ["5-5"]="d", ["0-1"]="f", ["0-2"]="g", ["0-3"]="h",
    ["0-4"]="j", ["0-5"]="k", ["0-6"]="@", ["0-7"]="z", ["2-1"]="x", ["3-1"]="c", ["4-1"]="v", ["5-1"]="b",
    ["6-1"]="n", ["7-1"]="m", ["1-2"]="Q", ["1-3"]="W", ["1-4"]="E", ["1-5"]="R", ["1-6"]="T", ["1-7"]="Y",
    ["3-2"]="U", ["4-2"]="*", ["5-2"]="O", ["6-2"]="P", ["7-2"]="A", ["4-3"]="S", ["5-3"]="D", ["6-3"]="F",
    ["7-3"]="G", ["5-4"]="H", ["2-3"]="K", ["2-4"]="L", ["2-5"]="Z", ["2-6"]="X", ["2-7"]="C", ["3-4"]="V",
    ["3-5"]="B", ["3-6"]="N", ["3-7"]="M", ["4-5"]="J"
}

local TEAM_POSITION_TO_SYMBOL = {
    [1]="q", [2]="w", [3]="e", [4]="r", [5]="t", [6]="y", [7]="u", [8]="i", [9]="o", [10]="p",
    [11]="a", [12]="s", [13]="d", [14]="f", [15]="g", [16]="h", [17]="j", [18]="k", [19]="l",
    [20]="z", [21]="x", [22]="c", [23]="v", [24]="b", [25]="n", [26]="m"
}

-- Utility Functions
local function escapeString(str)
    if not str then return "" end
    return tostring(str):gsub("[|;:]", "_")
end

local function safeConcat(tbl, sep, mapFn)
    if not tbl or type(tbl) ~= "table" then return "" end
    local result = {}
    if mapFn then
        if #tbl > 0 then
            for i, v in ipairs(tbl) do
                local mapped = mapFn(i, v)
                if mapped then table.insert(result, mapped) end
            end
        else
            for k, v in pairs(tbl) do
                local mapped = mapFn(k, v)
                if mapped then table.insert(result, mapped) end
            end
        end
    else
        for _, v in ipairs(tbl) do
            table.insert(result, tostring(v))
        end
    end
    return #result > 0 and table.concat(result, sep) or ""
end

local function wrapField(name, value)
    return string.format("<%s>%s</%s>", name, value or "", name)
end

-- Data Builders
local function buildRivalListData()
    local data = {}
    if not (LigaGrouping and ligaId and LigaGrouping[ligaId]) then
        return data, "No valid LigaGrouping data"
    end
    for _, match in ipairs(LigaGrouping[ligaId]) do
        table.insert(data, {
            homeID = match[1] or 0,
            awayID = match[2] or 0,
            homeScore = match[4] or 0,
            awayScore = match[5] or 0,
            homeScorers = match.data and match.data.homeScorers or {},
            awayScorers = match.data and match.data.awayScorers or {},
            data = {}
        })
    end
    return data, nil
end

local function getTeamPosition(teamID)
    if not TeamList then return nil end
    for i, id in ipairs(TeamList) do
        if id == teamID then return i end
    end
    return nil
end

local function buildCodes(rivalListData)
    local saveCodes = {}
    local fixturesCodes = {}
    local scorersByMatchday = {}
    local games_in_a_season = (#TeamList - 1) * 2
    for matchday = 1, games_in_a_season do
        local startMatch = (matchday - 1) * 10 + 1
        local endMatch = math.min(startMatch + 9, #rivalListData)
        for i = startMatch, endMatch do
            local match = rivalListData[i]
            if match then
                local scoreKey = string.format("%d-%d", match.homeScore or 0, match.awayScore or 0)
                table.insert(saveCodes, SCORELINE_TO_SYMBOL[scoreKey] or "?")
                local homePos = getTeamPosition(match.homeID)
                local awayPos = getTeamPosition(match.awayID)
                table.insert(fixturesCodes, (homePos and awayPos and homePos <= 26 and awayPos <= 26) and
                    (TEAM_POSITION_TO_SYMBOL[homePos] .. TEAM_POSITION_TO_SYMBOL[awayPos]) or "??")
                for _, scorer in ipairs(match.homeScorers or {}) do
                    scorersByMatchday[scorer] = scorersByMatchday[scorer] or {}
                    scorersByMatchday[scorer][matchday] = (scorersByMatchday[scorer][matchday] or 0) + 1
                end
                for _, scorer in ipairs(match.awayScorers or {}) do
                    scorersByMatchday[scorer] = scorersByMatchday[scorer] or {}
                    scorersByMatchday[scorer][matchday] = (scorersByMatchday[scorer][matchday] or 0) + 1
                end
            else
                table.insert(saveCodes, "q")
                table.insert(fixturesCodes, "??")
            end
        end
    end
    return table.concat(saveCodes), table.concat(fixturesCodes), scorersByMatchday, nil
end

local function buildSheetsData()
    local data = {}
    if not sheets then return data, "No sheets data" end
    for sheetIndex = 1, 4 do
        local sheet = sheets[sheetIndex]
        if sheet and sheet.status == "filled" then
            table.insert(data, {
                sheetIndex = sheetIndex,
                players = safeConcat(sheet.players, ","),
                formationId = sheet.formationid or 6
            })
        end
    end
    return data, nil
end

local function buildGoalsData(scorersByMatchday)
    local data = {}
    if GOALS and next(GOALS) then
        for cardID, goals in pairs(GOALS) do
            data[cardID] = goals
        end
    else
        for cardID, matchdays in pairs(scorersByMatchday) do
            local totalGoals = 0
            for _, goals in pairs(matchdays) do
                totalGoals = totalGoals + goals
            end
            data[cardID] = totalGoals
        end
    end
    return data, nil
end

-- Validation
local function isDataComplete()
    local required = {
        currentSelectedTeamID = currentSelectedTeamID,
        GLOBAL_DATE_PLACEHOLDER = GLOBAL_DATE_PLACEHOLDER,
        GLOBAL_MATCHUP_COUNT = GLOBAL_MATCHUP_COUNT,
        GLOBAL_FUNDS = GLOBAL_FUNDS,
        TeamList = TeamList,
        origMatchDates = origMatchDates
    }
    for key, value in pairs(required) do
        if not value then
            return false, "Missing required field: " .. key
        end
    end
    return true, nil
end

-- Main Processing
local function generateDavunSave()
    local errors = {}
    local rivalListData, rivalError = buildRivalListData()
    if rivalError then table.insert(errors, rivalError) end

    local saveCode, fixturesCode, scorersByMatchday, codesError = buildCodes(rivalListData)
    if codesError then table.insert(errors, codesError) end

    local sheetsData, sheetsError = buildSheetsData()
    if sheetsError then table.insert(errors, sheetsError) end

    local goalsData, goalsError = buildGoalsData(scorersByMatchday)
    if goalsError then table.insert(errors, goalsError) end

    local isComplete, completeError = isDataComplete()
    if completeError then table.insert(errors, completeError) end

    -- Construct fields
    local fields = {
        {
            name = "Version",
            value = VERSION
        },
        {
            name = "Status",
            value = isComplete and "complete" or "incomplete"
        },
        {
            name = "TeamID",
            value = tostring(currentSelectedTeamID or 1)
        },
        {
            name = "Date",
            value = GLOBAL_DATE_PLACEHOLDER or "02/01/25"
        },
        {
            name = "MatchupCount",
            value = tostring(GLOBAL_MATCHUP_COUNT or 20)
        },
        {
            name = "Fixtures",
            value = fixturesCode or ""
        },
        {
            name = "Results",
            value = saveCode or ""
        },
        {
            name = "Sheets",
            value = safeConcat(sheetsData, LIST_DELIMITER, function(i, t)
                return string.format("%d:%s:%d", t.sheetIndex, t.players, t.formationId)
            end) or "none"
        },
        {
            name = "Goals",
            value = safeConcat(goalsData, LIST_DELIMITER, function(cardID, goals)
                return string.format("%s:%s", cardID, goals)
            end) or "none"
        },
        {
            name = "Injuries",
            value = safeConcat(injuryRecoveryDate, LIST_DELIMITER, function(playerName, dates)
                return string.format("%s:%s", escapeString(playerName), dates)
            end) or "none"
        },
        {
            name = "Suspensions",
            value = safeConcat(isSuspended, LIST_DELIMITER, function(playerName, status)
                if status then
                    return string.format("%s:%s", escapeString(playerName), status)
                end
                return nil
            end) or "none"
        },
        {
            name = "RedCardMatchCount",
            value = safeConcat(redCardMatchCount, LIST_DELIMITER, function(playerName, count)
                if count then
                    return string.format("%s:%s", escapeString(playerName), count)
                end
                return nil
            end) or "none"
        },
        {
            name = "RedCardCount",
            value = safeConcat(redCardRecords, LIST_DELIMITER, function(playerName, count)
                if count then
                    return string.format("%s:%s", escapeString(playerName), count)
                end
                return nil
            end) or "none"
        },
        {
            name = "YellowCardCount",
            value = safeConcat(yellowCardRecords, LIST_DELIMITER, function(playerName, count)
                if count then
                    return string.format("%s:%s", escapeString(playerName), count)
                end
                return nil
            end) or "none"
        },
        {
            name = "Teams",
            value = safeConcat(TeamList, ",")
        },
        {
            name = "MatchDates",
            value = safeConcat(origMatchDates, ",", function(i, date)
                return string.format("%04d", date)
            end)
        },
        {
            name = "Funds",
            value = tostring(GLOBAL_FUNDS or 0)
        },
        {
            name = "Transfers",
            value = safeConcat(transferHistory, LIST_DELIMITER, function(i, t)
                if t.Player and t.Team then
                    return string.format("%s:%s", escapeString(t.Player), t.Team)
                end
                return nil
            end) or "none"
        }
    }

    -- Construct davunSave
    local saveParts = {}
    for _, field in ipairs(fields) do
        table.insert(saveParts, wrapField(field.name, field.value))
    end
    davunSave = table.concat(saveParts, FIELD_DELIMITER)

    return {
        rivalListData = rivalListData,
        davunSave = davunSave,
        errors = errors
    }
end

-- Execute and return
return generateDavunSave()