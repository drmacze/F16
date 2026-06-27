local SelectLeagueTeam = {}

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
local NUM_COLUMNS = 4
local rivalListData = {}

function SelectLeagueTeam:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {SquadManagementService = o.api("SquadMgtService"), TeamService = o.api("TeamService")}  
  -- Ensure nav is set, with a loud fallback if missing
  o.nav = init and init.nav or { Event = function(_, event, data) print("Fallback Nav Event Triggered: " .. event .. ", Data: " .. tostring(data)) end }
  if not init or not init.nav then print("WARNING: self.nav not provided in init, using fallback!") end
  o.Init()
  o.playerIndex = 1
  o:getPlayers()
  o:registerBindings()
  o.im.Subscribe("bnd_playervalue", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_playerstats", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_playerhead", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_playerteamcrest", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_playername", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_playerteam", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_playerrating", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_scoutcomment", function()
    o:publishPlayerInfo()
  end)
  o.im.Subscribe("bnd_goalscount", function()
    o:publishPlayerInfo()
  end)
  for i = 1, 6 do
        o.im.Subscribe("bnd_player_stat"..i, function()
            o:publishPlayerInfo()
        end)
    end
    for i = 1, 6 do
        o.im.Subscribe("bnd_player_statname"..i, function()
            o:publishPlayerInfo()
        end)
    end
  o.im.Subscribe(BND_LEAGUE_CREST, function()
    o:publishPlayerHead()
  end)
  o.im.Subscribe(bnd_player_list_INDEX, function()
    o:publishPlayerIndex()
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
  -- Grid selection action: Only updates selection, no popup
  o.im.RegisterDataAction(bnd_player_list_INDEX, ACT_CHANGE, function(bindingName, actionName, index)
    index = index + 1
    print("GRID CLICK DETECTED! Binding: " .. bindingName .. ", Action: " .. actionName .. ", New index: " .. index)
    if o.playersDataToPublish.data[o.playerIndex] then
      o.playersDataToPublish.data[o.playerIndex].selected = false
    end
    if o.playersDataToPublish.data[index] then
      o.playersDataToPublish.data[index].selected = true
      o.playersDataToPublish.index = index
      o:setSelectedPlayerIndex(index)
      o.im.Refresh(bnd_player_list)
      o:publishPlayerHead()
      print("Grid selection updated to player: " .. o.playersDataToPublish.data[index].label)
    else
      print("Index " .. index .. " out of bounds! Total players: " .. #o.playersDataToPublish.data)
    end
  end)
  -- Confirmation action: Triggers popup when selection is finalized
  o.im.RegisterDataAction(bnd_player_index, ACT_CHANGE, function(bindingName, actionName, index)
    print("CONFIRMATION DETECTED! Binding: " .. bindingName .. ", Action: " .. actionName .. ", Index: " .. index)
    o:toggleSelectorVisibility(false)
    o:setSelectedPlayerIndex(index)
    o:publishPlayerInfo()
    o.im.ChangeActionState(ACT_SELECT_LEAGUE, o.im.GetActionState("VALID"))
    print("Selection finalized for player: " .. o.playersDataToPublish.data[index].label)
  end)
  o.im.RegisterAction(ACT_TOSHORTLIST, function(actionName, data)
    o:sendToShortlist()
  end)
  o.im.RegisterAction(ACT_REMOVE, function(actionName, data)
    o:removeFromScoutlist()
  end)
  -- Add a test action to manually trigger the popup for debugging
  o.im.RegisterAction("test_popup", function()
    print("Manual test_popup triggered!")
    o:publishPlayerInfo()
  end)
  return o
end

function SelectLeagueTeam:Init()
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
    
function SelectLeagueTeam:cacheTeamPlayers(teamID)
    local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
    TeamPlayerCache[teamID] = players or {}
end
function SelectLeagueTeam:publishPlayerInfo()
  local playerTeam = (self.playersDataToPublish.data[self.playerIndex]).image.teamID
  self:cacheTeamPlayers(playerTeam)
  local cardID = (self.playersDataToPublish.data[self.playerIndex]).image.id  -- Get the current player's CARD_ID
  local playerInfo = getPlayerInfo(cardID, playerTeam)  -- Use cardID instead of 239085
  local playerRating = playerInfo and playerInfo.rating
  local playerPosition = playerInfo and playerInfo.position
  local Index = playerInfo and playerInfo.index
  local repCount = playerReplacementCount(playerTeam, playerPosition)
  local days = daysLeftInTransferWindow(GLOBAL_DATE_PLACEHOLDER)
  local playervalue, minvalue = computeTransferValue(GetPlayerAge(cardID), playerRating, playerPosition, Index, repCount, days)
  statsInfo = { statsname1 = "Pace", statsname2 = "Shooting", statsname3 = "Passing", statsname4 = "Dribbling", statsname5 = "Defending", statsname6 = "Physical", statsnamegk1 = "Diving", statsnamegk2 = "Handling", statsnamegk3 = "Kicking", statsnamegk4 = "Reflexes", statsnamegk5 = "Speed", statsnamegk6 = "Positioning"}
  
  -- Debug output
  print("Computed values - Final: " .. tostring(playervalue) .. ", Min: " .. tostring(latestvalue))
  
    self.im.Publish("bnd_playervalue", "€" .. self.loc.LocalizeInteger(minvalue) .. "  –  " ..  "€" .. self.loc.LocalizeInteger(playervalue))
  for i = 1, 6 do
    self.im.Publish("bnd_player_stat"..i, ":  " .. playerInfo["stats"..i])
  end
  for i = 1, 6 do
    if playerInfo.position == "GK" then
      self.im.Publish("bnd_player_statname"..i, statsInfo["statsnamegk"..i])
    else
      self.im.Publish("bnd_player_statname"..i, statsInfo["statsname"..i])
    end
  end
  playerhead = { name = "$Head", id = cardID}
  playerteamcrest = { name = "$Crest", id = playerInfo.teamID}
  self.im.Publish("bnd_playerhead", playerhead)
  self.im.Publish("bnd_playerteamcrest", playerteamcrest)
  self.im.Publish("bnd_playername", playerInfo.name)
  self.im.Publish("bnd_playerteam", self.loc.LocalizeString("TeamName_Abbr15_" .. playerInfo.teamID))
  self.im.Publish("bnd_playerrating", playerInfo.rating)
  self.im.Publish("bnd_scoutcomment", "player scouting is still in progress")
  self.im.Publish("bnd_goalscount", (GOALS[cardID] or 0) + countPlayerGoals(cardID) or 0)
  -- Refresh UI (if needed, depending on your framework)
end
local countryLeagues = {
    ["England"] = {13, 14, 60},
    ["Spain"] = {53, 54},
    ["France"] = {16, 17},
    ["Italy"] = {31, 32},
    ["Germany"] = {19, 20},
    ["Netherland"] = {10},
    ["Scotland"] = {50},
    ["Portugal"] = {308},
    ["Brazil"] = {7},
    ["Belgium"] = {4}
}

-- Define position groups
local positionGroups = {
    ["ATT"] = {["ST"] = true, ["CF"] = true, ["LF"] = true, ["RF"] = true, ["LW"] = true, ["RW"] = true, ["LM"] = true, ["RM"] = true},
    ["MID"] = {["CAM"] = true, ["CM"] = true, ["CDM"] = true},
    ["DEF"] = {["LB"] = true, ["RB"] = true, ["CB"] = true, ["LWB"] = true, ["RWB"] = true}
}

-- Define attribute conditions
local attributeConditions = {
    ["Dribbler"] = function(player) return player.stat1 >= 80 and player.stat4 >= 82 end,
    ["Prolific"] = function(player) return player.stat1 >= 80 and player.stat2 >= 80 and player.stat3 >= 80 end,
    ["Dueler"] = function(player) return player.stat5 >= 75 and player.stat6 >= 84 end,
    ["Speedster"] = function(player) return player.stat1 >= 85 end,
    ["Fox in the Box"] = function(player) return player.stat2 >= 83 and player.stat3 >= 80 and player.stat1 >= 75 end,
    ["Poacher"] = function(player) return player.stat2 >= 85 end,
    ["Playmaker"] = function(player) return player.stat3 >= 85 and player.stat4 >= 75 end,
    ["Maestro"] = function(player) return player.stat3 >= 85 end,
    ["Anchor"] = function(player) return player.stat3 >= 80 and player.stat5 >= 75 and player.stat6 >= 75 end,
    ["Defensive minded"] = function(player) return player.stat5 >= 83 and player.stat6 >= 80 end
}

function SelectLeagueTeam:getPlayers()
    local scoutNetwork = ScoutAssignments
    local Table = {}

    -- Define rating filter within the function scope
    local ratingFilter = function(playerRating)
        if scoutNetwork["OVR"] == "90+" then
            return playerRating > 90
        elseif scoutNetwork["OVR"] == "80-89" then
            return playerRating >= 80 and playerRating <= 90
        elseif scoutNetwork["OVR"] == "70-79" then
            return playerRating >= 70 and playerRating <= 79
        elseif scoutNetwork["OVR"] == "60-69" then
            return playerRating >= 60 and playerRating <= 69
        elseif scoutNetwork["OVR"] == "60+" then
            return playerRating > 60        
        elseif scoutNetwork["OVR"] == "70+" then
            return playerRating > 70    
        elseif scoutNetwork["OVR"] == "80+" then
            return playerRating > 80           
        else
            return true
        end
    end

    -- Get league IDs based on scoutNetwork["BASED ON"]
    local selectedCountry = scoutNetwork["BASED FROM"]
    local leagueIDs = countryLeagues[selectedCountry]
    local targetPosition = scoutNetwork["POSITION"]
    local targetAttribute = scoutNetwork["ATTRIBUTE"]

    if not leagueIDs then
        print("Error: No league found for country - " .. tostring(selectedCountry))
        return
    end

    -- Fetch teams using TeamService
    for _, leagueID in ipairs(leagueIDs) do
        local teams = self.services.TeamService.GetTeams(leagueID, 0, 0, false)

        if teams then
            for _, team in ipairs(teams) do
                local dummyPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, team.id, 0)
                if dummyPlayers then
                    for _, player in ipairs(dummyPlayers) do
                        -- Check position match
                        local playerPos = player.position
                        local isPositionMatch = false
                        if positionGroups[targetPosition] then
                            isPositionMatch = positionGroups[targetPosition][playerPos] or false
                        else
                            isPositionMatch = (playerPos == targetPosition)
                        end

                        -- Check attribute match if an attribute is specified
                        local isAttributeMatch = true
                        if targetAttribute and attributeConditions[targetAttribute] then
                            isAttributeMatch = attributeConditions[targetAttribute](player)
                        end

                        -- Check rating match
                        local isRatingMatch = ratingFilter(player.rating)

                        -- Only add player if all conditions are met
                        if isPositionMatch and isAttributeMatch and isRatingMatch then
                            table.insert(Table, player)
                        end
                    end
                end
            end
        end
    end

    -- Prepare player data for display
    local playerData = {}
    local alternateBG = false
    if #Table < 1 then
      self:noSuccess()
    end
    for i, player in ipairs(Table) do
        table.insert(playerData, {
            label = player.playerName,
            image = {
                name = "$Head",
                id = player.CARD_ID,
                teamID = player.teamID
            },
            id = i,
            selected = (i == 0),
            alternateBackground = alternateBG
        })

        if i % NUM_COLUMNS == 0 then
            alternateBG = not alternateBG
        end
    end

    self.playersDataToPublish = {
        index = 1,
        data = playerData
    }

    print("Players data to publish: " .. tostring(#playerData) .. " players")
    for i, p in ipairs(playerData) do
        print("Player " .. i .. ": " .. p.label .. ", CARD_ID: " .. p.image.id .. ", Selected: " .. tostring(p.selected))
    end

    self.im.Refresh(bnd_player_list)
end
-- !pO player object table
slot = slot or {}

function SelectLeagueTeam:sendToShortlist()
  local pO = self.playersDataToPublish.data[self.playerIndex].image

  -- Check if the player already exists in any slot
  for i = 1, 30 do
    if _G["SLOTPL" .. i] == pO.id then
      return  -- Player already in the list, do nothing
    end
  end

  -- Find the first empty slot and assign the player
  for i = 1, 30 do
    if not _G["SLOTPL" .. i] then
      _G["SLOTTM" .. i], _G["SLOTPL" .. i] = pO.teamID, pO.id
      break
    end
  end
end
  
function SelectLeagueTeam:registerBindings()
  self.im.Subscribe(bnd_player_list, function()
    print("Publishing to bnd_player_list: " .. tostring(#self.playersDataToPublish.data) .. " players")
    self.im.Publish(bnd_player_list, self.playersDataToPublish)
  end)
  self.isSelectorVisible = false
  self.im.Subscribe(BND_LEAGUE_OVERLAY_VISIBLE, function()
    self.im.Publish(BND_LEAGUE_OVERLAY_VISIBLE, self.isSelectorVisible)
  end)
  self.im.Subscribe(BND_SELECTED_LEAGUE_NAME, function()
    local name = self.playersDataToPublish.data[self.playerIndex] and self.playersDataToPublish.data[self.playerIndex].label or "No Player"
    print("Publishing selected player name: " .. name)
    self.im.Publish(BND_SELECTED_LEAGUE_NAME, name)
  end)
  self.im.RegisterAction(ACT_SELECT_LEAGUE, function()
    self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("INVALID"))
    self:toggleSelectorVisibility(true)
    print("Selector opened")
  end)
end

function SelectLeagueTeam:setSelectedPlayerIndex(index)
  self.playerIndex = index
  self.im.Refresh(BND_SELECTED_LEAGUE_NAME)
  self:publishPlayerHead()
  print("Selected player index set to: " .. index)
end

function SelectLeagueTeam:publishPlayerHead()
  local player = self.playersDataToPublish.data[self.playerIndex]
  if player then
    local playerHead = {
      name = "$Head",
      id = player.image.id
    }
    print("Publishing player head for CARD_ID: " .. playerHead.id)
    self.im.Publish(BND_LEAGUE_CREST, playerHead)
  end
end

function SelectLeagueTeam:publishPlayerIndex()
  self.im.Publish(bnd_player_list_INDEX, self.playerIndex)
  print("Published player index: " .. self.playerIndex)
end

function SelectLeagueTeam:noSuccess()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Ver elenco",
    clickEvents = {"evt_hide_popup", "evt_back"}
  }
  local popupData = {
    title = "",
    message = "Nenhum jogador que corresponda aos seus critérios foi encontrado.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function SelectLeagueTeam:toggleSelectorVisibility(visible)
  if self.isSelectorVisible ~= visible then
    self.isSelectorVisible = visible
    self.im.Refresh(BND_LEAGUE_OVERLAY_VISIBLE)
    print("Selector visibility toggled to: " .. tostring(visible))
  end
end

function SelectLeagueTeam:onSelectorCancel()
  if self.isSelectorVisible then
    self:toggleSelectorVisibility(false)
    print("Selector cancelled")
  end
  self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("VALID"))
end

function SelectLeagueTeam:finalize()
  self.im.Unsubscribe(bnd_player_list)
  self.im.Unsubscribe(BND_SELECTED_LEAGUE_NAME)
  self.im.Unsubscribe(BND_LEAGUE_OVERLAY_VISIBLE)
  self.im.Unsubscribe(BND_LEAGUE_CREST)
  self.im.Unsubscribe(bnd_player_list_INDEX)
  self.im.Unsubscribe(BND_DEFAULT_CELL_DATA)
  self.im.UnregisterDataAction(bnd_player_list_INDEX, ACT_CHANGE)
  self.im.UnregisterDataAction(bnd_player_index, ACT_CHANGE)
  self.im.UnregisterAction(ACT_SELECTOR_CANCEL)
  self.im.UnregisterAction(ACT_SELECT_LEAGUE)
  self.im.UnregisterAction("test_popup")
  print("Finalized SelectLeagueTeam")
end

return SelectLeagueTeam