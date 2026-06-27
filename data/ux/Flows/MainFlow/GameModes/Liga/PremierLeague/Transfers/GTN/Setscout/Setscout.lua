-- Mod By MVN PROD --
-- League Mode Division --

local Liga = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
local ACT_NEXT = "act_next"
local ACT_PREVIOUS = "act_decrease"
local ACT_SUBMIT = "act_submit"

ligaId = 1
if not round then
  round = 1
else 
  round = round
end

bnd_fontColor = "0xED1400"

if not selectedteam then
  selectedteam = 1
else 
  selectedteam = selectedteam
end

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

-- Global table to store scout assignments for access by other scripts
ScoutAssignments = ScoutAssignments or {}

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
  currentRowIndex = currentRowIndex or 1 -- Default to first row
  o.setupParams = o.setupParams or {} -- Table to store selected values per row
  -- Initialize all rows with their first values if not already set
  for i = 1, 5 do
    o.setupParams[i] = o.setupParams[i] or self:getParamValues(i)[1]
  end
  o:Init()
  
  o.im.Subscribe(bndMatchList, function()
     o:publishMatchRows()
  end)
  
  o.im.Subscribe("bnd_match_label", function()
    o:publishMatchLabel()
  end)
  
  o.im.Subscribe("bnd_scout", function()
    o:displayImg()
  end)
  
  o.im.Subscribe("bnd_point_label", function()
    o:publishMatchLabel()
  end)
  
  o.im.Subscribe("bnd_finish_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_team_label", function()
    o:publishLabel()
  end)
  
  o.im.Subscribe("bnd_matchup_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_matchday_label", function()
    o:publishLabel()
  end)
  
  o.im.Subscribe("bnd_league_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_fontColor", function()
  end)
  
  o.im.Subscribe("bnd_advance_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_month_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.RegisterAction(ACT_ADVANCE, function(actionName, data)
    if data then
      o:PlayMatch(data)
    end
  end)
  o.im.RegisterAction(ACT_NEXT, function(actionName, data)
    o:toggleNext()
  end)
  o.im.RegisterAction(ACT_PREVIOUS, function(actionName, data)
    o:togglePrevious()
  end)
  o.im.RegisterAction(ACT_SUBMIT, function(actionName, data)
    o:getScoutAssignment()
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
      data = {}
    }
    table.insert(rivalListData, obj)
  end
end

------------------------------------------------------------------------------------------

function Liga:displayImg()
  self.im.Publish("bnd_scout", "$Europe")
end

function Liga:togglePrevious()
    local paramValues = self:getParamValues(currentRowIndex)
    local currentIndex = self:getCurrentParamIndex(paramValues, currentRowIndex)
    if currentIndex > 1 then
        self.setupParams[currentRowIndex] = paramValues[currentIndex - 1]
    end
    self:publishLabel()
    self:publishMatchRows()
end

function Liga:toggleNext()
    local paramValues = self:getParamValues(currentRowIndex)
    local currentIndex = self:getCurrentParamIndex(paramValues, currentRowIndex)
    if currentIndex < #paramValues then
        self.setupParams[currentRowIndex] = paramValues[currentIndex + 1]
    end
    self:publishLabel()
    self:publishMatchRows()
end

function Liga:getParamValues(rowIndex)
    -- Define designated values for each parameter based on rowIndex (order in params)
    local paramOptions = {
        [1] = {"GK", "DEF", "MID", "ATT", "RB", "LB", "CB", "RM", "LM", "CM", "CAM", "CDM", "CF", "LW", "RW", "RF", "LF", "ST"}, -- POSITION
        [2] = {"England", "Spain", "Germany", "Italy", "France", "Netherland", "Brazil", "Portugal", "Scotland", "Belgium"},        -- BASED FROM
        [3] = {"Dribbler", "Prolific", "Dueler", "Speedster", "Fox in the Box", "Poacher", "Playmaker", "Maestro", "Anchor", "Defensive minded"},    -- ATTRIBUTE
        [4] = {"60-69", "70-79", "80-90", "60+", "70+", "80+", "90+"}             -- OVR
    }
    return paramOptions[rowIndex] or {"Not set"}
end

function Liga:getCurrentParamIndex(paramValues, rowIndex)
    -- Find the current setupParam’s index in its value list for the given row
    local currentValue = self.setupParams[rowIndex] or paramValues[1]
    for i, value in ipairs(paramValues) do
        if value == currentValue then
            return i
        end
    end
    return 1 -- Default to first value if not found
end

function Liga:publishLabel()
    -- Publish the current parameter name and its selected value
    local params = {"POSITION", "BASED FROM", "ATTRIBUTE", "OVR"}
    local paramName = params[currentRowIndex] or "Unknown"
    self.im.Publish("bnd_matchday_label", paramName .. ": " .. (self.setupParams[currentRowIndex] or "Not set"))
end

function Liga:publishMatchRows()
    local filteredRivalListData = {}
    local params = {"POSITION", "BASED FROM", "ATTRIBUTE", "OVR"}
    for i = 1, 4 do
        local v = {}
        v.data = {}
        v.data.Parameter = params[i]
        -- Show the stored value for each row, preserving previous selections
        v.data.Setparameter = self.setupParams[i] or "Not set"
        v.data.clickAction = "act_advance"
        table.insert(filteredRivalListData, v)
    end
    self.im.Publish(bndMatchList, filteredRivalListData)
end

function Liga:PlayMatch(data)
    currentRowIndex = data.id + 1
    -- Ensure the new row has a value if not already set
    if not self.setupParams[currentRowIndex] then
        local paramValues = self:getParamValues(currentRowIndex)
        self.setupParams[currentRowIndex] = paramValues[1] -- Start at first value for the new row
    end
    self:publishLabel()
    self:publishMatchRows()
end

-- Define reusable date utilities outside the function (optional, for modularity)
local function parseDate(dateStr)
    local day, month, year = dateStr:match("(%d%d)/(%d%d)/(%d%d)")
    return tonumber(day) or 1, tonumber(month) or 1, tonumber(year) or 0
end

local function formatDate(day, month, year)
    return string.format("%02d/%02d/%02d", day, month, year)
end

function Liga:getScoutAssignment()
    local assignment = {}
    local params = {"POSITION", "BASED FROM", "ATTRIBUTE", "OVR"}
    
    for i = 1, 4 do
        assignment[params[i]] = self.setupParams[i] or "Not set"
    end
    
    local currentDate = GLOBAL_DATE_PLACEHOLDER
    
    local day, month, year = parseDate(currentDate)
    local newDay = day + 20
    local daysInMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    
    while newDay > daysInMonth[month] do
        newDay = newDay - daysInMonth[month]
        month = month + 1
        if month > 12 then
            month = 1
            year = year + 1
        end
    end
    
    assignment["SCOUT_TIME"] = formatDate(newDay, month, year)
    
    ScoutAssignments = ScoutAssignments or {}
    ScoutAssignments = assignment
    
    print("Scout Assignment Stored for ligaId " .. tostring(ligaId) .. ":")
    for k, v in pairs(assignment) do
        print(k .. ": " .. tostring(v))
    end
    
    self.nav.Event(nil, "evt_back")
end

function Liga:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.UnregisterAction(ACT_NEXT)
  self.im.UnregisterAction(ACT_PREVIOUS)
  self.im.UnregisterAction(ACT_SUBMIT)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_matchday_label")
  self.im.Unsubscribe("bnd_point_label")
  self.im.Unsubscribe("bnd_scout")
  self.im.Unsubscribe("bnd_matchup_label")
  self.im.Unsubscribe("bnd_matchdate_label")
  self.im.Unsubscribe("bnd_league_label")
  self.im.Unsubscribe("bnd_advance_label")
  self.im.Unsubscribe("bnd_month_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
end

return Liga

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --