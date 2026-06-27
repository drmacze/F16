local Sheets = {}

-- Required bindings (unchanged)
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

lastSelectedSheetIndex = lastSelectedSheetIndex or 1

function Sheets:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    o.services = {SquadManagementService = o.api("SquadMgtService"), TacticsService = o.api("TacticsService")}
    o.nav = init and init.nav or { Event = function(_, event, data) print("Fallback Nav Event Triggered: " .. event .. ", Data: " .. tostring(data)) end }
    if not init or not init.nav then print("WARNING: self.nav not provided in init, using fallback!") end
    o.playerIndex = init and init.lastSelectedIndex or lastSelectedSheetIndex or 1
    o.sheetID = o.playerIndex
    o:getSheets()
    o:registerBindings()

    -- Subscriptions
    o.im.Subscribe("bnd_playervalue", function() o:publishSheetInfo() end)
    o.im.Subscribe("bnd_playerstats", function() o:publishSheetInfo() end)
    o.im.Subscribe("bnd_sheet", function() o:publishSheetInfo() end)
    o.im.Subscribe("bnd_crest", function() o:publishSheetInfo() end)
    o.im.Subscribe("bnd_sheetname", function() o:publishSheetInfo() end)
    o.im.Subscribe("bnd_playerteam", function() o:publishSheetInfo() end)
    o.im.Subscribe("bnd_playerrating", function() o:publishSheetInfo() end)
    o.im.Subscribe("bnd_scoutcomment", function() o:publishSheetInfo() end)
    o.im.Subscribe("bnd_goalscount", function() o:publishSheetInfo() end)
    for i = 1, 6 do o.im.Subscribe("bnd_player_stat"..i, function() o:publishSheetInfo() end) end
    for i = 1, 6 do o.im.Subscribe("bnd_player_statname"..i, function() o:publishSheetInfo() end) end
    o.im.Subscribe(BND_LEAGUE_CREST, function() o:publishSheetHead() end)
    o.im.Subscribe(bnd_player_list_INDEX, function() o:publishSheetIndex() end)

    o.defaultCellData = { label = "", image = {}, id = -1 }
    o.im.Subscribe(BND_DEFAULT_CELL_DATA, function() o.im.Publish(BND_DEFAULT_CELL_DATA, o.defaultCellData) end)

    -- Actions
    o.im.RegisterAction(ACT_SELECTOR_CANCEL, function() o:onSelectorCancel() end)
    o.im.RegisterDataAction(bnd_player_list_INDEX, ACT_CHANGE, function(bindingName, actionName, index)
        index = index + 1
        print("GRID CLICK DETECTED! Binding: " .. bindingName .. ", Action: " .. actionName .. ", New index: " .. index)
        for _, sheet in ipairs(o.sheetsDataToPublish.data) do
            sheet.selected = false
        end
        o.im.Refresh(bnd_player_list)
        if o.sheetsDataToPublish.data[index] then
            o.sheetsDataToPublish.data[index].selected = true
            o.sheetsDataToPublish.index = index
            o:setSelectedSheetIndex(index)
            o.im.Refresh(bnd_player_list)
            o:publishSheetHead()
            print("Grid selection updated to sheet: " .. o.sheetsDataToPublish.data[index].label)
        else
            print("ERROR: Invalid index " .. index .. " clicked, no action taken")
        end
        for i, s in ipairs(o.sheetsDataToPublish.data) do
            print("Sheet " .. i .. ": " .. s.label .. ", Selected: " .. tostring(s.selected))
        end
    end)
    o.im.RegisterDataAction(bnd_player_index, ACT_CHANGE, function(bindingName, actionName, index)
        print("CONFIRMATION DETECTED! Binding: " .. bindingName .. ", Action: " .. actionName .. ", Index: " .. index)
        o:toggleSelectorVisibility(false)
        o:setSelectedSheetIndex(index)
        o:publishSheetInfo()
        o.im.ChangeActionState(ACT_SELECT_LEAGUE, o.im.GetActionState("VALID"))
        print("Selection finalized for sheet: " .. o.sheetsDataToPublish.data[index].label)
    end)
    o.im.RegisterAction(ACT_TOSHORTLIST, function(actionName, data) o:sendToShortlist() end)
    o.im.RegisterAction(ACT_REMOVE, function(actionName, data) o:removeFromSheet() end)
    o.im.RegisterAction("test_popup", function() print("Manual test_popup triggered!") o:publishSheetInfo() end)
    return o
end

function Sheets:getSheets()
    local sheetData = {}
    for i = 1, 4 do
        if not sheets[i] then
            print("[ERROR] sheets[" .. i .. "] is nil!")
            break
        end
        local sheetimage = sheets[i].status == "empty" and { name = "$SquadBuilderIcon", id = 0 } or { name = "$AHIconFormation", id = sheets[i].formationid or 0 }
        table.insert(sheetData, {
            label = "SHEET " .. i,
            image = sheetimage,
            id = i,
            selected = (i == self.playerIndex),
            alternateBackground = (i % 2 == 0)
        })
    end
    self.sheetsDataToPublish = {
        index = self.playerIndex,
        data = sheetData
    }
    local selectedSheet = self.sheetsDataToPublish.data[self.playerIndex]
    if selectedSheet and sheets[selectedSheet.id] and sheets[selectedSheet.id].status == "empty" then
        SHEETID = selectedSheet.id
        self.sheetID = SHEETID
        self.nav.Event(nil, "evt_squad", { sheetID = SHEETID })
        self:loadSheets()
        print("[Sheets]: Selected sheet " .. SHEETID .. " is empty, triggering evt_squad")
    end
    print("Sheets data to publish: " .. tostring(#sheetData) .. " sheets")
    for i, s in ipairs(sheetData) do
        print("Sheet " .. i .. ": " .. s.label .. ", ID: " .. s.id .. ", Selected: " .. tostring(s.selected))
    end
    self.im.Refresh(bnd_player_list)
    self:publishSheetInfo()
end

function Sheets:publishSheetInfo()
    local sheet = self.sheetsDataToPublish.data[self.playerIndex]
    if sheet then
        self.im.Publish("bnd_sheetname", sheet.label)
        SHEETID = sheet.id
        self.sheetID = SHEETID
        self.im.Publish("bnd_sheet", team_sheets)
        self.im.Publish("bnd_crest", { name = "$Crest", id = currentSelectedTeamID or 0 })
    end
    if sheets[SHEETID] and sheets[SHEETID].status == "filled" then
        self:loadSheets()
    end
end

function Sheets:loadSheets()
    if not sheets[SHEETID] or not sheets[SHEETID].players or not sheets[SHEETID].formationid then
        print("[TeamManagementModel]: loadSheets() - Invalid or incomplete sheets data for SHEETID " .. tostring(SHEETID))
        return
    end

    local teamID = currentSelectedTeamID or 0
    if not currentSelectedTeamID then
        print("WARNING: currentSelectedTeamID is nil, using fallback teamID = " .. teamID)
    end

    local currentPlayers = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
    if not currentPlayers then
        print("ERROR: GetCurrentPlayerLineup returned nil for teamID " .. teamID)
        return
    end

    -- Create a set of current player CARD_IDs
    local currentCardIDs = {}
    for _, player in ipairs(currentPlayers) do
        if player.CARD_ID then
            currentCardIDs[player.CARD_ID] = true
        else
            print("WARNING: Player missing CARD_ID in currentPlayers")
        end
    end

    local sheetPlayerIDs = sheets[SHEETID].players

    -- Find CARD_IDs in currentPlayers that are missing from sheetPlayerIDs (to append)
    local missingCardIDs = {}
    for cardID in pairs(currentCardIDs) do
        local found = false
        for _, sheetCardID in ipairs(sheetPlayerIDs) do
            if sheetCardID == cardID then
                found = true
                break
            end
        end
        if not found then
            table.insert(missingCardIDs, cardID)
        end
    end

    -- Append missing CARD_IDs to the sheet
    if #missingCardIDs > 0 then
        print("[TeamManagementModel]: loadSheets() - Found " .. #missingCardIDs .. " missing CARD_IDs, appending to sheets[SHEETID].players")
        for _, cardID in ipairs(missingCardIDs) do
            table.insert(sheets[SHEETID].players, cardID)
        end
    end

    -- Find CARD_IDs in sheetPlayerIDs that are no longer in currentPlayers (to remove)
    local removedCardIDs = {}
    local updatedSheetPlayerIDs = {}
    for _, sheetCardID in ipairs(sheetPlayerIDs) do
        if currentCardIDs[sheetCardID] then
            -- Keep players who are still in the current lineup
            table.insert(updatedSheetPlayerIDs, sheetCardID)
        else
            -- Track players to be removed
            table.insert(removedCardIDs, sheetCardID)
        end
    end

    -- Update the sheet's player list and log removed players
    if #removedCardIDs > 0 then
        print("[TeamManagementModel]: loadSheets() - Found " .. #removedCardIDs .. " CARD_IDs no longer in team, removing from sheets[SHEETID].players")
        for _, cardID in ipairs(removedCardIDs) do
            print("[TeamManagementModel]: Removed CARD_ID " .. cardID .. " from sheets[SHEETID].players")
        end
        sheets[SHEETID].players = updatedSheetPlayerIDs
    end

    -- Update the lineup and formation if the sheet has enough players
    if #sheets[SHEETID].players > 11 then
        self.services.SquadManagementService.SetCurrentPlayerLineup(0, teamID, 0, 0, sheets[SHEETID].players)
        self.services.TacticsService.SetFormation(0, teamID, sheets[SHEETID].formationid)
        currentFormationId = sheets[SHEETID].formationid
        print("[TeamManagementModel]: loadSheets() - Successfully set lineup and formation for SHEETID " .. tostring(SHEETID))
    else
        print("[TeamManagementModel]: loadSheets() - Not enough players (" .. #sheets[SHEETID].players .. ") to set lineup")
    end

    self:updateTeamCache(currentSelectedTeamID)
end

function Sheets:updateTeamCache(teamID)
    if not teamID then
        return false, "No teamID provided"
    end
    
    local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
    if players then
        TeamPlayerCache[teamID] = players
        return true, "Team cache updated successfully"
    else
        TeamPlayerCache[teamID] = {}
        return false, "No players found for teamID"
    end
end

function Sheets:registerBindings()
    self.im.Subscribe(bnd_player_list, function()
        print("Publishing to bnd_player_list: " .. tostring(#self.sheetsDataToPublish.data) .. " sheets")
        self.im.Publish(bnd_player_list, self.sheetsDataToPublish)
    end)
    self.isSelectorVisible = false
    self.im.Subscribe(BND_LEAGUE_OVERAY_VISIBLE, function()
        self.im.Publish(BND_LEAGUE_OVERLAY_VISIBLE, self.isSelectorVisible)
    end)
    self.im.Subscribe(BND_SELECTED_LEAGUE_NAME, function()
        local name = self.sheetsDataToPublish.data[self.playerIndex] and self.sheetsDataToPublish.data[self.playerIndex].label or "No Sheet"
        print("Publishing selected sheet name: " .. name)
        self.im.Publish(BND_SELECTED_LEAGUE_NAME, name)
    end)
    self.im.RegisterAction(ACT_SELECT_LEAGUE, function()
        self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("INVALID"))
        self:toggleSelectorVisibility(true)
        print("Selector opened")
    end)
end

function Sheets:setSelectedSheetIndex(index)
    if not self.sheetsDataToPublish.data[index] then
        print("ERROR: Invalid index " .. index .. ", aborting")
        return
    end
    for _, sheet in ipairs(self.sheetsDataToPublish.data) do
        sheet.selected = false
    end
    self.sheetsDataToPublish.data[index].selected = true
    self.playerIndex = index
    lastSelectedSheetIndex = index
    SHEETID = self.sheetsDataToPublish.data[index].id
    self.sheetID = SHEETID
    self.im.Refresh(BND_SELECTED_LEAGUE_NAME)
    self.im.Refresh(bnd_player_list)
    self:publishSheetHead()
    if sheets[SHEETID] and sheets[SHEETID].status == "empty" then
        self.nav.Event(nil, "evt_squad", { sheetID = SHEETID })
        print("[Sheets]: Newly selected sheet " .. SHEETID .. " is empty, triggering evt_squad")
    end
    print("Selected sheet index set to: " .. index)
end

function Sheets:publishSheetHead()
    local sheet = self.sheetsDataToPublish.data[self.playerIndex]
    if sheet then
        local sheetHead = { name = "$Sheet", id = sheet.id }
        print("Publishing sheet head for ID: " .. sheetHead.id)
        self.im.Publish(BND_LEAGUE_CREST, sheetHead)
    end
end

function Sheets:publishSheetIndex()
    self.im.Publish(bnd_player_list_INDEX, self.playerIndex)
    print("Published sheet index: " .. self.playerIndex)
end

function Sheets:sendToShortlist()
    local sheet = self.sheetsDataToPublish.data[self.playerIndex].image
    self.nav.Event(nil, "evt_squad")
    print("Sending sheet " .. self.sheetID .. " to shortlist")
end

function Sheets:removeFromSheet()
    local sheet = self.sheetsDataToPublish.data[self.playerIndex].image
    print("Removing sheet " .. self.sheetID .. " from selection")
end

function Sheets:toggleSelectorVisibility(visible)
    if self.isSelectorVisible ~= visible then
        self.isSelectorVisible = visible
        self.im.Refresh(BND_LEAGUE_OVERLAY_VISIBLE)
        print("Selector visibility toggled to: " .. tostring(visible))
    end
end

function Sheets:onSelectorCancel()
    if self.isSelectorVisible then
        self:toggleSelectorVisibility(false)
        print("Selector cancelled")
    end
    self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("VALID"))
end

function Sheets:finalize()
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
    print("Finalized Sheets")
end

return Sheets