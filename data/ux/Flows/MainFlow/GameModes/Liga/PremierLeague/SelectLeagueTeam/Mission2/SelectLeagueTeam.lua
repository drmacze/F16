local FUTLoginManager, VirtualButton, TableUtil, EventManager, SKUEnums = ...
local SelectLeagueTeam = {}
local BND_LEAGUE_INDEX = "bnd_league_index"
local BND_LEAGUE_LIST = "bnd_league_list"
local BND_SELECTED_LEAGUE_NAME = "bnd_selected_league_name"
local BND_LEAGUE_OVERLAY_VISIBLE = "bnd_league_overlay_visible"
local BND_TEAM_INDEX = "bnd_team_index"
local BND_TEAM_LIST = "bnd_team_list"
local BND_SELECTED_TEAM_NAME = "bnd_selected_team_name"
local BND_TEAM_OVERLAY_VISIBLE = "bnd_team_overlay_visible"
local BND_TEAM_CREST = "bnd_team_crest"
local BND_LEAGUE_CREST = "bnd_league_crest"
local BND_DETERMINED_PACK_VISIBILITY = "bnd_determined_pack_visible"
local BND_REGULAR_BG_VISIBILITY = "bnd_regular_bg_visible"
local BND_DEFAULT_CELL_DATA = "bnd_default_cell_data"
local BND_LEAGUE_LIST_INDEX = "bnd_league_list_index"
local BND_LEAGUE_LIST_TOGGLE = "bnd_league_list_toggle"
local BND_TEAM_LIST_INDEX = "bnd_team_list_index"
local BND_TEAM_LIST_TOGGLE = "bnd_team_list_toggle"
local BND_TEAM_STAR_RATING = "bnd_team_star_rating"
local BND_TEAM_RATING = "bnd_team_rating"
local ACT_SELECT_LEAGUE = "act_select_league"
local ACT_SELECT_TEAM = "act_select_team"
local ACT_SELECTOR_CANCEL = "act_selector_cancel"
local ACT_CHANGE = "act_change"
local ACT_CONFIRM = "act_confirm"
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local LOGIN_STATUS = FUTLoginManager.FeCards.LoginStatus
local TERMINATION_REASON = SKUEnums.fifaids.TerminationReason
local NUM_COLUMNS = 4
missionmode = "IC"
ligaId = 1

function SelectLeagueTeam:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    TeamService = o.api("TeamService"),
    CountryService = o.api("CountryService"),
    UserPlateService = o.api("UserPlateService"),
    GameStateService = o.api("GameStateService"),
    FUTUserInfoService = o.api("FUTUserInfoService"),
    EventManagerService = o.api("EventManagerService"),
    GameState = o.api("GameStateService")
  }
  o.isDeterminationPackKillSwitchOn = o.services.GameStateService.IsDeterminationPackKillSwitchOn()
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end)
  local defaultData = o.services.CountryService.GetDefaultTeamForRegion()
  o.currentCountryID = -1
  o.currentLeagueID = defaultData.leagueID
  o.currentTeamID = defaultData.teamID
  o.favoritePlayerID = -1
  o.countryIndex = 1
  o.leagueIndex = 1
  o.teamIndex = 1
  o.currentTeamName = ""
  o:getLeagues()
  o:registerLeagueBindings()
  o:registerTeamBindings()
  o.im.Subscribe(BND_TEAM_CREST, function()
    o:publishTeamCrest(o.currentTeamID) -- Pass currentTeamID explicitly
  end)
  o.im.Subscribe(BND_LEAGUE_CREST, function()
    o:publishLeagueCrest()
  end)
  o.im.Subscribe(BND_DETERMINED_PACK_VISIBILITY, function()
    o.im.Publish(BND_DETERMINED_PACK_VISIBILITY, not o.isDeterminationPackKillSwitchOn)
  end)
  o.im.Subscribe(BND_REGULAR_BG_VISIBILITY, function()
    o.im.Publish(BND_REGULAR_BG_VISIBILITY, o.isDeterminationPackKillSwitchOn)
  end)
  o.im.Subscribe(BND_LEAGUE_LIST_INDEX, function()
    o:publishLeagueIndex()
  end)
  o.im.Subscribe(BND_LEAGUE_LIST_TOGGLE, function()
    o:publishLeagueToggle()
  end)
  o.im.Subscribe(BND_TEAM_LIST_INDEX, function()
    o:publishTeamIndex()
  end)
  o.im.Subscribe(BND_TEAM_LIST_TOGGLE, function()
    o:publishTeamToggle()
  end)
  o.im.Subscribe(BND_TEAM_STAR_RATING, function()
    o:publishTeamStarRating()
  end)
  o.im.Subscribe(BND_TEAM_RATING, function()
    o:publishTeamRating()
  end)
  o.defaultCellData = {
    label = "",
    image = {},
    id = -1
  }
  o.im.Subscribe(BND_DEFAULT_CELL_DATA, function()
    o.im.Publish(BND_DEFAULT_CELL_DATA, o.defaultCellData)
  end)
  o.im.RegisterAction(ACT_CONFIRM, function(actionName, data)
    o.im.ChangeActionState(ACT_SELECT_LEAGUE, o.im.GetActionState("INVALID"))
    o.im.ChangeActionState(ACT_SELECT_TEAM, o.im.GetActionState("INVALID"))
    o.im.ChangeActionState(ACT_SELECTOR_CANCEL, o.im.GetActionState("INVALID"))
    o.im.ChangeActionState(ACT_CHANGE, o.im.GetActionState("INVALID"))
    o.im.ChangeActionState(ACT_CONFIRM, o.im.GetActionState("INVALID"))
    o.services.FUTUserInfoService.SetUserFavoriteTeam(o.currentTeamID)
  end)
  o.im.RegisterAction(ACT_SELECTOR_CANCEL, function()
    o:onSelectorCancel()
  end)
  o.im.RegisterDataAction(BND_LEAGUE_LIST_INDEX, ACT_CHANGE, function(bindingName, actionName, index)
    index = index + 1
    o.leaguesDataToPublish.data[o.leagueIndex].selected = false
    o.leaguesDataToPublish.data[index].selected = true
    o.leaguesDataToPublish.index = index
    o:setSelectedLeagueIndex(index)
    o.im.Refresh(BND_LEAGUE_LIST)
    o.im.Refresh(BND_TEAM_LIST_TOGGLE)
  end)
  o.im.RegisterDataAction(BND_TEAM_LIST_INDEX, ACT_CHANGE, function(bindingName, actionName, index)
    index = index + 1
    o.teamsDataToPublish.data[o.teamIndex].selected = false
    o.teamsDataToPublish.data[index].selected = true
    o.teamsDataToPublish.index = index
    o:setSelectedTeamIndex(index)
    o.im.Refresh(BND_TEAM_LIST)
  end)
  if automation then
    print("FTFSelectLeagueTeam automation exists")
    automation.Add("FTFSelectLeagueTeam", {
      FTFSelectLeagueTeam = function(currentTeamID)
        o:_juiceSelectLeagueTeam(currentTeamID)
      end
    })
  end
  return o
end

function SelectLeagueTeam:_juiceSelectLeagueTeam(currentTeamID)
  self.currentTeamID = currentTeamID
  self.favoritePlayerID = self.services.UserPlateService.GetFavoritePlayerByTeamId(self.currentTeamID)
  self.services.FUTUserInfoService.SetUserFavoriteTeam(self.currentTeamID)
end

function SelectLeagueTeam:getLeagues()
  local leagueNames = {}
  self.leagueIDs = { -- Predefined league IDs
    13, 14, 16, 19, 31, 341, 10, 308, 350, 50, 53, 68, 39, 4
  }
  local alternateBG = false
  for i = 1, #self.leagueIDs do
    table.insert(leagueNames, {
      label = self.leagueIDs[i], -- Use label based on the ID
      image = {
        name = "$LeagueActive",
        id = self.leagueIDs[i]
      },
      id = i,
      selected = self.currentLeagueID == self.leagueIDs[i] or (self.currentLeagueID == 0 and i == 1),
      alternateBackground = alternateBG
    })
    if self.currentLeagueID == self.leagueIDs[i] or (self.currentLeagueID <= 0 and i == 1) then
      self.currentLeagueID = self.leagueIDs[i]
      self.leagueIndex = i
    end
    if i % NUM_COLUMNS ~= 0 then
      alternateBG = not alternateBG
    end
  end

  self:setSelectedLeagueIndex(self.leagueIndex)
  currentLeagueIndex = self.leagueIndex
  self.leaguesDataToPublish = {
    index = self.leagueIndex,
    data = leagueNames
  }
  self.im.Refresh(BND_LEAGUE_LIST)
end

function SelectLeagueTeam:registerLeagueBindings()
  self.im.Subscribe(BND_LEAGUE_LIST, function()
    self.im.Publish(BND_LEAGUE_LIST, self.leaguesDataToPublish)
  end)
  self.isLeagueSelectorVisible = false
  self.im.Subscribe(BND_LEAGUE_OVERLAY_VISIBLE, function()
    self.im.Publish(BND_LEAGUE_OVERLAY_VISIBLE, self.isLeagueSelectorVisible)
  end)
  self.im.Subscribe(BND_SELECTED_LEAGUE_NAME, function()
    self.im.Publish(BND_SELECTED_LEAGUE_NAME, self.leaguesDataToPublish.data[self.leagueIndex].label)
  end)
  self.im.RegisterAction(ACT_SELECT_LEAGUE, function()
    self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("INVALID"))
    self.im.ChangeActionState(ACT_SELECT_TEAM, self.im.GetActionState("INVALID"))
    self:toggleLeagueSelectorVisibility(true)
  end)
  self.im.RegisterDataAction(BND_LEAGUE_INDEX, ACT_CHANGE, function(bindingName, actionName, index)
    self:toggleLeagueSelectorVisibility(false)
    self:setSelectedLeagueIndexHelper(index)
    self:getLeagues()
    self:publishLeagueToggle()
    self:publishTeamToggle()
    self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("VALID"))
    self.im.ChangeActionState(ACT_SELECT_TEAM, self.im.GetActionState("VALID"))
  end)
end

function SelectLeagueTeam:setSelectedLeagueIndex(index)
  self:setSelectedLeagueIndexHelper(index)
  self:publishLeagueCrest()
  self:getTeams()
end

function SelectLeagueTeam:setSelectedLeagueIndexHelper(index)
  if self.leagueIndex ~= index then
    self.leagueIndex = index
    self.currentLeagueID = self.leagueIDs[index]
    self.im.Refresh(BND_SELECTED_LEAGUE_NAME)
    self.currentTeamID = 0
    self.teamIndex = 1
    self.im.Refresh(BND_SELECTED_TEAM_NAME)
  end
end

-- List of teams to exclude
local EXCLUDED_TEAMS = {}

-- Helper function to check if a team is in the exclusion list
local function isExcluded(teamID)
  for _, id in ipairs(EXCLUDED_TEAMS) do
    if teamID == id then
      return true
    end
  end
  return false
end

function SelectLeagueTeam:getTeams()
  local teamNames = {}
  local teamIDs = self.services.TeamService.GetTeams(self.currentLeagueID, 0, 0, false)
  self.teamsData = {}

  local alternateBG = false

  for _, teamData in ipairs(teamIDs) do
    if not isExcluded(teamData.id) then  -- Exclude teams using a simple list check
      local teamInfo = {
        id = teamData.id,
        name = self.loc.LocalizeString("TeamName_Abbr15_" .. teamData.id),
        starRating = teamData.starRating or 0,
        offense = teamData.offense or 0,
        midfield = teamData.midfield or 0,
        defense = teamData.defense or 0
      }

      table.insert(self.teamsData, teamInfo)
      table.insert(teamNames, {
        label = teamInfo.name,
        image = { name = "$Crest", id = teamInfo.id },
        id = #self.teamsData, -- Use actual index for consistency
        selected = self.currentTeamID == teamInfo.id or (self.currentTeamID == 0 and #self.teamsData == 1),
        alternateBackground = alternateBG,
        stars = teamInfo.starRating
      })

      if self.currentTeamID == teamInfo.id or (self.currentTeamID == 0 and #self.teamsData == 1) then
        self.currentTeamID = teamInfo.id
        self.teamIndex = #self.teamsData
        currentSelectedTeamID = teamInfo.id
      end

      if #self.teamsData % NUM_COLUMNS ~= 0 then
        alternateBG = not alternateBG
      end
    end
  end

  TeamList = {}
	for _, teamData in ipairs(teamIDs) do
	  table.insert(TeamList, teamData.id) -- Add ALL teams, even excluded ones
	end

  self:setSelectedTeamIndex(self.teamIndex)
  self.teamsDataToPublish = { index = self.teamIndex, data = teamNames }
  self.im.Refresh(BND_TEAM_LIST)
end

function SelectLeagueTeam:registerTeamBindings()
  self.im.Subscribe(BND_TEAM_LIST, function()
    self.im.Publish(BND_TEAM_LIST, self.teamsDataToPublish)
  end)
  self.isTeamSelectorVisible = false
  self.im.Subscribe(BND_TEAM_OVERLAY_VISIBLE, function()
    self.im.Publish(BND_TEAM_OVERLAY_VISIBLE, self.isTeamSelectorVisible)
  end)
  self.im.Subscribe(BND_SELECTED_TEAM_NAME, function()
    self.im.Publish(BND_SELECTED_TEAM_NAME, self.teamsDataToPublish.data[self.teamIndex].label)
  end)
  self.im.RegisterAction(ACT_SELECT_TEAM, function()
    self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("INVALID"))
    self.im.ChangeActionState(ACT_SELECT_TEAM, self.im.GetActionState("INVALID"))
    self:toggleTeamSelectorVisibility(true)
  end)
  self.im.RegisterDataAction(BND_TEAM_INDEX, ACT_CHANGE, function(bindingName, actionName, index)
    self:toggleTeamSelectorVisibility(false)
    self:setSelectedTeamIndexHelper(index)
    self:getTeams()
    self:publishTeamToggle()
    self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("VALID"))
    self.im.ChangeActionState(ACT_SELECT_TEAM, self.im.GetActionState("VALID"))
  end)
end

function SelectLeagueTeam:setSelectedTeamIndex(index)
  self:setSelectedTeamIndexHelper(index)
  self:publishTeamCrest(self.currentTeamID) -- Pass currentTeamID explicitly
end

function SelectLeagueTeam:setSelectedTeamIndexHelper(index)
  if self.teamIndex ~= index then
    self.teamIndex = index
    self.currentTeamID = self.teamsData[index].id
    self.im.Refresh(BND_SELECTED_TEAM_NAME)
  end
end

function SelectLeagueTeam:toggleLeagueSelectorVisibility(visible)
  if self.isLeagueSelectorVisible ~= visible then
    self.isLeagueSelectorVisible = visible
    self.im.Refresh(BND_LEAGUE_OVERLAY_VISIBLE)
  end
end

function SelectLeagueTeam:toggleTeamSelectorVisibility(visible)
  if self.isTeamSelectorVisible ~= visible then
    self.isTeamSelectorVisible = visible
    self.im.Refresh(BND_TEAM_OVERLAY_VISIBLE)
  end
end

function SelectLeagueTeam:onSelectorCancel()
  if self.isLeagueSelectorVisible then
    self:toggleLeagueSelectorVisibility(false)
  elseif self.isTeamSelectorVisible then
    self:toggleTeamSelectorVisibility(false)
  end
  self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("VALID"))
  self.im.ChangeActionState(ACT_SELECT_TEAM, self.im.GetActionState("VALID"))
end

function SelectLeagueTeam:checkFUTConnection()
  local loginStatus = self.services.FUTUserInfoService.GetLoginStatus()
  if loginStatus == LOGIN_STATUS.LS_FAILED or loginStatus == LOGIN_STATUS.LS_DISCONNECTED then
    self.im.ChangeActionState(ACT_CONFIRM, self.im.GetActionState("INVALID"))
    self.im.ChangeActionState(ACT_CHANGE, self.im.GetActionState("INVALID"))
    local buttonOk = VirtualButton:new({
      nav = self.nav,
      label = "LTXT_CMN_OK",
      clickEvents = {
        "evt_hide_popup"
      },
      clickCallback = function()
        self:_enableScreen()
      end
    })
    popupData = {
      title = "LTXT_INV_RESULTS_ERROR",
      message = "LTXT_NETWORK_ERROR",
      buttons = {buttonOk}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
  end
end

function SelectLeagueTeam:_enableScreen()
  self.im.ChangeActionState(ACT_SELECT_LEAGUE, self.im.GetActionState("VALID"))
  self.im.ChangeActionState(ACT_SELECT_TEAM, self.im.GetActionState("VALID"))
  self.im.ChangeActionState(ACT_SELECTOR_CANCEL, self.im.GetActionState("VALID"))
  self.im.ChangeActionState(ACT_CHANGE, self.im.GetActionState("VALID"))
  self.im.ChangeActionState(ACT_CONFIRM, self.im.GetActionState("VALID"))
end

function SelectLeagueTeam:_handleEvent(eventType, data)
  if eventType == EVENT_TYPES.FosFavoriteTeamComplete then
    if data.success then
      self.currentCountryID = self.services.CountryService.GetCountryInfoByFUTLeagueId(self.currentLeagueID).id
      self.services.UserPlateService.SetFavorites(self.currentCountryID, self.currentTeamID, self.favoritePlayerID)
      self.nav.Event(nil, "evt_advance")
    else
      local buttonOk = {
        label = "LTXT_CMN_OK",
        clickEvents = {
          "evt_hide_popup"
        },
        clickCallback = function()
          self:_enableScreen()
        end
      }
      local popupData = {
        title = "LTXT_CMN_FUT_ERROR_TITLE",
        message = "LTXT_SERVER_UNAVAILABLE",
        buttons = {buttonOk}
      }
      self.nav.Event(nil, "evt_show_popup", popupData)
    end
  elseif eventType == EVENT_TYPES.OnBackPressed then
  end
end

function SelectLeagueTeam:_publishData(bindingName)
  if bindingName == BND_LEAGUE_LIST then
    self.im.Publish(bindingName, self.leagues)
  elseif bindingName == BND_TEAM_LIST then
    self.im.Publish(bindingName, self.clubs)
  end
end

function SelectLeagueTeam:_publishTeamName()
  if self.currentTeamID == -1 then
    self.currentTeamName = ""
  end
  self.im.Publish(BND_TEAM_NAME, self.currentTeamName)
end

function SelectLeagueTeam:publishLeagueCrest()
  if self.currentLeagueID ~= -1 then
    local leagueCrest = {
      name = "$LeagueCrest",
      id = self.currentLeagueID
    }
    self.im.Publish(BND_LEAGUE_CREST, leagueCrest)
  end
end

function SelectLeagueTeam:publishTeamCrest(teamid)
  if self.currentTeamID ~= -1 then
    currentSelectedTeamID = self.currentTeamID 
    local selectedTeamID = teamid or self.currentTeamID 

    self.favoritePlayerID = self.services.UserPlateService.GetFavoritePlayerByTeamId(selectedTeamID)
    local teamCrest = {
      name = "$Crest",
      id = selectedTeamID
    }

    self.im.Publish(BND_TEAM_CREST, teamCrest)

    self:publishTeamStarRating()
    self:publishLeagueToggle()
    self:publishTeamRating()
  else
    self.favoritePlayerID = -1
  end
end

function SelectLeagueTeam:publishLeagueToggle()
  local leagueData = {}
  for i = 1, #self.leagueIDs do
    local name = self.loc.LocalizeString("LeagueName_Abbr15_" .. self.leagueIDs[i])
    table.insert(leagueData, {
      name = name,
      id = i,
      styles = {
        "TF_SELECT_FAVORITE_LEAGUE_TOGGLE"
      }
    })
  end
  self.im.Publish(BND_LEAGUE_LIST_TOGGLE, {
    data = leagueData,
    index = self.leagueIndex - 1
  })
end

function SelectLeagueTeam:publishTeamToggle()
  local teamData = {}
  for i, team in ipairs(self.teamsData) do
    table.insert(teamData, {
      name = team.name,
      assetid = team.id, 
      id = i,
      styles = { "TF_SELECT_FAVORITE_TEAM_TOGGLE" }
    })
  end

  -- Ensure the crest is updated when the toggle changes
  self:publishTeamCrest(self.currentTeamID)

  -- Publish the toggle data
  self.im.Publish(BND_TEAM_LIST_TOGGLE, {
    data = teamData,
    index = self.teamIndex - 1
  })
end

function SelectLeagueTeam:publishTeamIndex()
  self:publishTeamCrest(self.currentTeamID) -- Pass currentTeamID explicitly
  self.im.Publish(BND_TEAM_LIST_INDEX, self.teamIndex)
end

function SelectLeagueTeam:publishTeamStarRating()
  self.im.Publish(BND_TEAM_STAR_RATING, self.teamsData[self.teamIndex].starRating)
end

function SelectLeagueTeam:publishTeamRating()
  local teamRating = {
    attackValue = string.format("%d", self.teamsData[self.teamIndex].offense),
    middleValue = string.format("%d", self.teamsData[self.teamIndex].midfield),
    defenseValue = string.format("%d", self.teamsData[self.teamIndex].defense),
    attackLabel = self.loc.LocalizeString("LTXT_CMN_ATT"),
    middleLabel = self.loc.LocalizeString("LTXT_CMN_MID"),
    defenseLabel = self.loc.LocalizeString("LTXT_CMN_DEF")
  }
  self.im.Publish(BND_TEAM_RATING, teamRating)
end

function SelectLeagueTeam:finalize()
  self.im.Unsubscribe(BND_LEAGUE_LIST)
  self.im.Unsubscribe(BND_SELECTED_LEAGUE_NAME)
  self.im.Unsubscribe(BND_LEAGUE_OVERLAY_VISIBLE)
  self.im.Unsubscribe(BND_TEAM_LIST)
  self.im.Unsubscribe(BND_SELECTED_TEAM_NAME)
  self.im.Unsubscribe(BND_TEAM_OVERLAY_VISIBLE)
  self.im.Unsubscribe(BND_TEAM_CREST)
  self.im.Unsubscribe(BND_LEAGUE_CREST)
  self.im.Unsubscribe(BND_DETERMINED_PACK_VISIBILITY)
  self.im.Unsubscribe(BND_REGULAR_BG_VISIBILITY)
  self.im.Unsubscribe(BND_LEAGUE_LIST_TOGGLE)
  self.im.Unsubscribe(BND_TEAM_LIST_INDEX)
  self.im.Unsubscribe(BND_TEAM_LIST_TOGGLE)
  self.im.Unsubscribe(BND_TEAM_STAR_RATING)
  self.im.Unsubscribe(BND_TEAM_RATING)
  self.im.Unsubscribe(BND_LEAGUE_LIST_INDEX)
  self.im.Unsubscribe(BND_DEFAULT_CELL_DATA)
  self.im.UnregisterDataAction(BND_LEAGUE_LIST_INDEX, ACT_CHANGE)
  self.im.UnregisterDataAction(BND_TEAM_LIST_INDEX, ACT_CHANGE)
  self.im.UnregisterDataAction(BND_LEAGUE_INDEX, ACT_CHANGE)
  self.im.UnregisterDataAction(BND_TEAM_INDEX, ACT_CHANGE)
  self.im.UnregisterAction(ACT_CONFIRM)
  self.im.UnregisterAction(ACT_SELECTOR_CANCEL)
  self.im.UnregisterAction(ACT_SELECT_LEAGUE)
  self.im.UnregisterAction(ACT_SELECT_TEAM)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
end

return SelectLeagueTeam