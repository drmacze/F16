local Calendar = {}

-- Required bindings
local bnd_player_index = "bnd_player_index"
local bnd_player_list = "bnd_player_list"
local BND_SELECTED_LEAGUE_NAME = "bnd_selected_league_name"
local BND_LEAGUE_OVERLAY_VISIBLE = "bnd_league_overlay_visible"
local BND_LEAGUE_CREST = "bnd_league_crest"
local BND_DEFAULT_CELL_DATA = "bnd_default_cell_data"
local bnd_player_list_INDEX = "bnd_player_list_index"
local ACT_SELECT_LEAGUE = "act_select_league"
local ACT_SELECTOR_CANCEL = "act_selector_cancel"
local ACT_CHANGE = "act_change"
local ACT_TOSHORTLIST = "act_toshortlist"
local ACT_REMOVE = "act_remove"
local NUM_COLUMNS = 4 -- Kept for reference, but not used for grid sets
local rivalListData = {}

function Calendar:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {SquadManagementService = o.api("SquadMgtService"), TeamService = o.api("TeamService")}  
  o.nav = init and init.nav or { Event = function(_, event, data) print("Fallback Nav Event Triggered: " .. event .. ", Data: " .. tostring(data)) end }
  if not init or not init.nav then print("WARNING: self.nav not provided in init, using fallback!") end
  o.Init()
  o.playerIndex = 1
  o:getPlayers()
  o:registerBindings()
  o.im.Subscribe("bnd_teamcrest", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_simicon", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_simtext", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_date", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_teamname", function()
    o:publishPlayerInfo()
  end)
  for i = 1, 4 do
    o.im.Subscribe("bnd_groundcol".. i, function()
      o:publishPlayerInfo()
    end)
  end
  o.im.Subscribe("bnd_result", function()
    o:publishPlayerInfo()
  end)
  o.defaultCellData = {
    label = "",
    image = {},
    id = -1
  }
  o.im.Subscribe(BND_DEFAULT_CELL_DATA, function()
    o.im.Publish(BND_DEFAULT_CELL_DATA, o.defaultCellData)
  end)
  o.im.RegisterAction(ACT_SELECTOR_CANCEL, function()
    o:onSelectorCancel()
  end)
  o.im.RegisterDataAction(bnd_player_list_INDEX, ACT_CHANGE, function(bindingName, actionName, index)
    index = index + 1
    print("GRID CLICK DETECTED! Binding: " .. bindingName .. ", Action: " .. actionName .. ", New index: " .. index)
    for _, item in ipairs(o.playersDataToPublish.data) do
      item.selected = false
    end
    o.im.Refresh(bnd_player_list)
    if o.playersDataToPublish.data[index] then
      o.playersDataToPublish.data[index].selected = true
      o.playersDataToPublish.index = index
      o:setSelectedPlayerIndex(index)
      o.im.Refresh(bnd_player_list)
      print("Grid selection updated to: " .. o.playersDataToPublish.data[index].label)
    else
      print("Index " .. index .. " out of bounds! Total items: " .. #o.playersDataToPublish.data)
    end
  end)
  o.im.RegisterDataAction(bnd_player_index, ACT_CHANGE, function(bindingName, actionName, index)
    print("CONFIRMATION DETECTED! Binding: " .. bindingName .. ", Action: " .. actionName .. ", Index: " .. index)
    o:toggleSelectorVisibility(false)
    o:setSelectedPlayerIndex(index)
    o:publishPlayerInfo()
    o.im.ChangeActionState(ACT_SELECT_LEAGUE, o.im.GetActionState("VALID"))
    print("Selection finalized for: " .. o.playersDataToPublish.data[index].label)
  end)
  o.im.RegisterAction("test_popup", function()
    print("Manual test_popup triggered!")
    o:publishPlayerInfo()
  end)
  return o
end

function Calendar:Init()
  local LigaGroupingList = LigaGrouping[ligaId] or {}
  for i = 1, table.getn(LigaGroupingList) do
    local obj = {
      homeID = LigaGroupingList[i][1],
      awayID = LigaGroupingList[i][2],
      homeScore = LigaGroupingList[i][4],
      awayScore = LigaGroupingList[i][5],
      homeScorers = LigaGroupingList[i]["data"].homeScorers or {},
      awayScorers = LigaGroupingList[i]["data"].awayScorers or {},
      data = {}
    }
    table.insert(rivalListData, obj)
  end
end

function Calendar:publishPlayerInfo()
  local selectedItem = self.playersDataToPublish.data[self.playerIndex]
  local simtext = ""
  local simicon = ""
  local teamcrest = {name = "nil", id = 0}
  local date = "No date selected"
  local teamname = "N/A"
  local result = ""
  local ground = ""

  -- Debug: Check if selectedItem exists
  print("selectedItem:", selectedItem)
  if not selectedItem then
    print("No selectedItem")
    self.im.Publish("bnd_teamcrest", teamcrest)
    self.im.Publish("bnd_date", date)
    self.im.Publish("bnd_teamname", teamname)
    self.im.Publish("bnd_result", result)
    self.im.Publish("bnd_simtext", simtext)
    self.im.Publish("bnd_simicon", simicon)
    return
  end

  -- Debug: Check selectedItem.image
  print("selectedItem.image:", selectedItem.image)
  if not selectedItem.image then
    print("No selectedItem.image")
    self.im.Publish("bnd_teamcrest", teamcrest)
    self.im.Publish("bnd_date", selectedItem.month and (selectedItem.month .. " " .. selectedItem.day .. ", " .. selectedItem.year) or date)
    self.im.Publish("bnd_teamname", teamname)
    self.im.Publish("bnd_result", result)
    self.im.Publish("bnd_simtext", simtext)
    self.im.Publish("bnd_simicon", simicon)
    return
  end

  -- Check if the selected date is past or current
  local isPastOrCurrentDate = false
  if selectedItem.month and selectedItem.day and selectedItem.year then
    local monthMap = {
      January = 1, February = 2, March = 3, April = 4, May = 5,
      June = 6, July = 7, August = 8, September = 9, October = 10,
      November = 11, December = 12
    }
    local selectedMonthNum = monthMap[selectedItem.month]
    local selectedDay = tonumber(selectedItem.day)
    local selectedYear = tonumber(selectedItem.year)

    -- Parse GLOBAL_DATE_PLACEHOLDER (e.g., "29/03/25")
    local currentDateStr = GLOBAL_DATE_PLACEHOLDER
    local currDay, currMonth, currYear = currentDateStr:match("(%d%d)/(%d%d)/(%d%d)")
    currDay = tonumber(currDay)
    currMonth = tonumber(currMonth)
    currYear = 2000 + tonumber(currYear)

    -- Convert dates to YYYYMMDD for comparison
    local selectedDateNum = selectedYear * 10000 + selectedMonthNum * 100 + selectedDay
    local currDateNum = currYear * 10000 + currMonth * 100 + currDay

    isPastOrCurrentDate = selectedDateNum <= currDateNum
    print("Selected date:", selectedDateNum, "Current date:", currDateNum, "Is past or current date:", isPastOrCurrentDate)
  end

  -- Debug: Check image.id
  print("selectedItem.image.id:", selectedItem.image.id)
  if selectedItem.image.id and selectedItem.image.id ~= 0 then
    local opponentID = selectedItem.image.id
    local teamName = self.loc and self.loc.LocalizeString("TeamName_Abbr15_" .. opponentID) or "Team " .. opponentID
    local homeScore = selectedItem.homeScore
    local awayScore = selectedItem.awayScore
    result = ""
    local GLOBAL_MATCHUP_COUNT = GLOBAL_MATCHUP_COUNT

    -- Determine ground based on team IDs
    print("currentSelectedTeamID:", currentSelectedTeamID, "homeID:", selectedItem.homeID, "awayID:", selectedItem.awayID)
    if currentSelectedTeamID == selectedItem.homeID then
      ground = "HOME"
    elseif currentSelectedTeamID == selectedItem.awayID then
      ground = "AWAY"
    else
      ground = "N/A"
      print("Warning: currentSelectedTeamID does not match homeID or awayID")
    end

    -- Check if match has been played
    print("homeScore:", homeScore, "awayScore:", awayScore, "matchIndex:", selectedItem.matchIndex)
    if selectedItem.matchIndex and selectedItem.matchIndex <= GLOBAL_MATCHUP_COUNT and homeScore ~= nil and awayScore ~= nil then
      if currentSelectedTeamID == selectedItem.homeID then
        if homeScore > awayScore then
          result = "W " .. homeScore .. " - " .. awayScore
        elseif homeScore < awayScore then
          result = "L " .. homeScore .. " - " .. awayScore
        else
          result = "D " .. homeScore .. " - " .. awayScore
        end
      elseif currentSelectedTeamID == selectedItem.awayID then
        if awayScore > homeScore then
          result = "W " .. homeScore .. " - " .. awayScore
        elseif awayScore < homeScore then
          result = "L " .. homeScore .. " - " .. awayScore
        else
          result = "D " .. homeScore .. " - " .. awayScore
        end
      end
    else
      result = "the match hasn't started yet"
    end

    teamcrest = {name = "$Crest", id = opponentID}
    date = selectedItem.month .. " " .. selectedItem.day .. ", " .. selectedItem.year
    teamname = "vs " .. teamName
    simtext = isPastOrCurrentDate and "" or " "
    simicon = isPastOrCurrentDate and {} or " "

    -- Publish groundcol values
    for i = 1, 4 do
      self.im.Publish("bnd_groundcol" .. i, string.sub(ground, i, i))
    end    
  else
    date = selectedItem.month and selectedItem.day and selectedItem.year and (selectedItem.month .. " " .. selectedItem.day .. ", " .. selectedItem.year) or "No date"
    teamname = "No match scheduled"
    simtext = isPastOrCurrentDate and "" or "Sim to Date"
    simicon = isPastOrCurrentDate and {} or "$SimMatchIcon2"
    ground = "N/A"
    -- Publish empty groundcol for non-match days
    for i = 1, 4 do
      self.im.Publish("bnd_groundcol" .. i, "")
    end
  end

  -- Debug: Log final values before publishing
  print("Publishing - simtext:", simtext, "simicon:", simicon, "teamcrest:", teamcrest, "date:", date, "teamname:", teamname, "result:", result, "ground:", ground)

  -- Publish all values
  self.im.Publish("bnd_teamcrest", teamcrest)
  self.im.Publish("bnd_date", date)
  self.im.Publish("bnd_teamname", teamname)
  self.im.Publish("bnd_result", result)
end

function Calendar:getPlayers()
  local gridData = {}
  local alternateBG = false
  local GRIDS_PER_SET = 35 -- Each month gets exactly 35 slots (5x7 grid)

  -- Get the current date from GLOBAL_DATE_PLACEHOLDER (e.g., "29/03/25")
  local dateStr = GLOBAL_DATE_PLACEHOLDER or "29/03/25"
  local day, month, year = dateStr:match("(%d%d)/(%d%d)/(%d%d)")
  day = tonumber(day)
  month = tonumber(month)
  year = tonumber(year)
  if year then
    year = 2000 + year
  else
    year = 2025
  end

  -- Function to check if it's a leap year
  local function isLeapYear(y)
    return (y % 4 == 0 and y % 100 ~= 0) or (y % 400 == 0)
  end

  -- Define all 12 months starting from the current month
  local baseMonths = {
    {month = "January", short = "JAN", days = 31, mm = "01"},
    {month = "February", short = "FEB", days = isLeapYear(year) and 29 or 28, mm = "02"},
    {month = "March", short = "MAR", days = 31, mm = "03"},
    {month = "April", short = "APR", days = 30, mm = "04"},
    {month = "May", short = "MAY", days = 31, mm = "05"},
    {month = "June", short = "JUN", days = 30, mm = "06"},
    {month = "July", short = "JUL", days = 31, mm = "07"},
    {month = "August", short = "AUG", days = 31, mm = "08"},
    {month = "September", short = "SEP", days = 30, mm = "09"},
    {month = "October", short = "OCT", days = 31, mm = "10"},
    {month = "November", short = "NOV", days = 30, mm = "11"},
    {month = "December", short = "DEC", days = 31, mm = "12"}
  }

  -- Reorder months starting from the current month
  local monthDays = {}
  for i = 0, 11 do
    local monthIndex = (month - 1 + i) % 12 + 1 -- Wrap around from current month
    local baseMonth = baseMonths[monthIndex]
    local monthYear = year + math.floor((month - 1 + i) / 12) -- Adjust year for wrap-around
    table.insert(monthDays, {
      month = baseMonth.month,
      short = baseMonth.short,
      days = baseMonth.days == 28 and isLeapYear(monthYear) and 29 or baseMonth.days, -- Adjust February for leap year
      mm = baseMonth.mm,
      year = monthYear
    })
  end

  -- Map all excludedDates to opponent IDs and store match data
  local matchDates = {}
  if not rivalListData then rivalListData = {} end
  local excludedDates = origMatchDates
  if not excludedDates then excludedDates = {} end

  local matchIndex = 1
  local matchCount = 0
  for i, date in ipairs(excludedDates) do
    while matchIndex <= #rivalListData do
      local match = rivalListData[matchIndex]
      local opponentID
      if match.homeID == currentSelectedTeamID then
        opponentID = match.awayID
      elseif match.awayID == currentSelectedTeamID then
        opponentID = match.homeID
      end
      if opponentID then
        matchCount = matchCount + 1
        matchDates[date] = {
          opponentID = opponentID,
          homeID = match.homeID,
          awayID = match.awayID,
          homeScore = match.homeScore,
          awayScore = match.awayScore,
          matchIndex = matchCount -- Track the match number
        }
        matchIndex = matchIndex + 1
        break
      end
      matchIndex = matchIndex + 1
    end
    if matchIndex > #rivalListData then break end
  end

  -- Generate grid with each month as a 35-item set
  local itemCount = 1
  for _, monthInfo in ipairs(monthDays) do
    for day = 1, monthInfo.days do
      local dateKey = monthInfo.mm .. string.format("%02d", day)
      local matchData = matchDates[dateKey]
      local isCrest = matchData ~= nil
      table.insert(gridData, {
        label = isCrest and ("vs " .. (self.loc and self.loc.LocalizeString("TeamName_Abbr15_" .. matchData.opponentID) or "Team " .. matchData.opponentID)) or (monthInfo.short .. " " .. day),
        id = itemCount,
        selected = false,  -- All grids start unselected
        alternateibilitiesBackground = alternateBG,
        image = isCrest and {name = "$Crest64x64", id = matchData.opponentID} or {name = "nil", id = 0},
        month = monthInfo.month,
        day = day,
        year = monthInfo.year,
        homeID = isCrest and matchData.homeID or nil,
        awayID = isCrest and matchData.awayID or nil,
        homeScore = isCrest and matchData.homeScore or nil,
        awayScore = isCrest and matchData.awayScore or nil,
        matchIndex = isCrest and matchData.matchIndex or nil
      })
      itemCount = itemCount + 1
    end

    local remainingGrids = GRIDS_PER_SET - monthInfo.days
    for fill = 1, remainingGrids do
      table.insert(gridData, {
        label = "",
        id = itemCount,
        selected = false,  -- All grids start unselected
        alternateBackground = alternateBG,
        month = monthInfo.month,
        day = nil,
        year = monthInfo.year
      })
      itemCount = itemCount + 1
    end

    alternateBG = not alternateBG
  end

  self.playersDataToPublish = { index = 1, data = gridData }

  -- No default selection; all items remain unselected
  self.currentOpponentID = nil
  self.currentCalDate = nil

  print("Grid data to publish: " .. #gridData .. " items")
  print("Starting month: " .. monthDays[1].month .. " " .. monthDays[1].year)
  print("Ending month: " .. monthDays[#monthDays].month .. " " .. monthDays[#monthDays].year)
  print("Total matches mapped: " .. matchCount)
  print("Initial state: No grids selected")
  self.im.Refresh(bnd_player_list)
end

function Calendar:registerBindings()
  self.im.Subscribe(bnd_player_list, function()
    print("Publishing to bnd_player_list: " .. tostring(#self.playersDataToPublish.data) .. " items")
    self.im.Publish(bnd_player_list, self.playersDataToPublish)
  end)
  self.isSelectorVisible = false
  self.im.Subscribe(BND_LEAGUE_OVERLAY_VISIBLE, function()
    self.im.Publish(BND_LEAGUE_OVERLAY_VISIBLE, self.isSelectorVisible)
  end)
  self.im.Subscribe(BND_SELECTED_LEAGUE_NAME, function()
    local name = self.playersDataToPublish.data[self.playerIndex] and self.playersDataToPublish.data[self.playerIndex].label or "No Date"
    print("Publishing selected date: " .. name)
    self.im.Publish(BND_SELECTED_LEAGUE_NAME, name)
  end)
  self.im.RegisterAction(ACT_SELECT_LEAGUE, function()
    self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("INVALID"))
    self:toggleSelectorVisibility(true)
    print("Selector opened")
  end)
end

function Calendar:setSelectedPlayerIndex(index)
  if not self.playersDataToPublish.data[index] then
    print("ERROR: Invalid index " .. index .. ", aborting")
    return
  end
  for _, item in ipairs(self.playersDataToPublish.data) do
    item.selected = false
  end
  self.playersDataToPublish.data[index].selected = true
  self.playerIndex = index
  self.playersDataToPublish.index = index
  self.im.Refresh(BND_SELECTED_LEAGUE_NAME)
  self:publishPlayerHead()
  print("Selected index set to: " .. index)
end

function Calendar:publishPlayerHead()
  local item = self.playersDataToPublish.data[self.playerIndex]
  if item then
    local crestData = {
      name = item.image.name,
      id = item.image.id
    }
    print("Publishing crest for ID: " .. crestData.id)
    self.im.Publish(BND_LEAGUE_CREST, crestData)
  end
end

function Calendar:publishPlayerIndex()
  self.im.Publish(bnd_player_list_INDEX, self.playerIndex)
  print("Published player index: " .. self.playerIndex)
end

function Calendar:noSuccess()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "View Squad",
    clickEvents = {"evt_hide_popup", "evt_back"}
  }
  local popupData = {
    title = "",
    message = "No matches scheduled",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Calendar:toggleSelectorVisibility(visible)
  if self.isSelectorVisible ~= visible then
    self.isSelectorVisible = visible
    self.im.Refresh(BND_LEAGUE_OVERLAY_VISIBLE)
    print("Selector visibility toggled to: " .. tostring(visible))
  end
end

function Calendar:onSelectorCancel()
  if self.isSelectorVisible then
    self:toggleSelectorVisibility(false)
    print("Selector cancelled")
  end
  self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("VALID"))
end

function Calendar:finalize()
  self.im.Unsubscribe(bnd_player_list)
  self.im.Unsubscribe(BND_SELECTED_LEAGUE_NAME)
  self.im.Unsubscribe(BND_LEAGUE_OVERLAY_VISIBLE)
  self.im.Unsubscribe(BND_LEAGUE_CREST)
  self.im.Unsubscribe(bnd_player_list_INDEX)
  self.im.Unsubscribe(BND_DEFAULT_CELL_DATA)
  self.im.Unsubscribe("bnd_teamcrest")
  self.im.Unsubscribe("bnd_result")
  self.im.Unsubscribe("bnd_date")
  self.im.Unsubscribe("bnd_teamname")
  self.im.UnregisterDataAction(bnd_player_list_INDEX, ACT_CHANGE)
  self.im.UnregisterDataAction(bnd_player_index, ACT_CHANGE)
  self.im.UnregisterAction(ACT_SELECTOR_CANCEL)
  self.im.UnregisterAction(ACT_SELECT_LEAGUE)
  self.im.UnregisterAction("test_popup")
  self.im.UnregisterAction(ACT_TOSHORTLIST)
  self.im.UnregisterAction(ACT_REMOVE)
  print("Finalized Calendar")
end

return Calendar