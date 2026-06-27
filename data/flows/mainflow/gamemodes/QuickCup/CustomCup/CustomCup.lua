-- Gerenciamento de Configuração de Torneios
-- Suporta múltiplos formatos: Group + Knockout, Knockout e League

local CustomCup = {}

do
    CustomCup.BND_TOURNAMENT_TYPE_LABEL = "bnd_tournament_type_toggle"
    CustomCup.BND_TOURNAMENT_TYPE_TEXT = "bnd_tournament_type_text"
    CustomCup.BND_TOURNAMENT_CREST = "bnd_tournament_crest"
    CustomCup.BND_PREV_TOURNAMENT_CREST = "bnd_prev_tournament_crest"
    CustomCup.BND_NEXT_TOURNAMENT_CREST = "bnd_next_tournament_crest"
    CustomCup.BND_TEAM_COUNT_LABEL = "bnd_number_of_teams_toggle"
    CustomCup.BND_TEAM_COUNT_TEXT = "bnd_team_count_text"
    CustomCup.BND_AUTO_FILL_LABEL = "bnd_auto_fills_toggle"
    CustomCup.BND_AUTO_FILL_TEXT = "bnd_auto_fill_text"
    CustomCup.BND_TEAM_GENDER_LABEL = "bnd_team_type_toggle"
    CustomCup.BND_TEAM_GENDER_TEXT = "bnd_team_type_text"
    CustomCup.BND_CUP_ID_LABEL = "bnd_tour_id_toggle"
    CustomCup.BND_CUP_ID_TEXT = "bnd_tour_id_text"
    CustomCup.BND_DESCRIPTION = "bnd_description"
    CustomCup.BND_TAB1_VISIBLE = "bnd_tab1_visible"
    CustomCup.BND_TAB2_VISIBLE = "bnd_tab2_visible"
    CustomCup.BND_TAB3_VISIBLE = "bnd_tab3_visible"
    CustomCup.BND_TAB4_VISIBLE = "bnd_tab4_visible"
    CustomCup.BND_TAB5_VISIBLE = "bnd_tab5_visible"

    CustomCup.ACT_NEXT_TOURNAMENT_TYPE = "act_next_tournament_type"
    CustomCup.ACT_PREV_TOURNAMENT_TYPE = "act_prev_tournament_type"
    CustomCup.ACT_NEXT_TEAM_COUNT = "act_next_team_count"
    CustomCup.ACT_PREV_TEAM_COUNT = "act_prev_team_count"
    CustomCup.ACT_NEXT_AUTO_FILL = "act_next_auto_fill"
    CustomCup.ACT_PREV_AUTO_FILL = "act_prev_auto_fill"
    CustomCup.ACT_NEXT_TEAM_GENDER = "act_next_team_gender"
    CustomCup.ACT_PREV_TEAM_GENDER = "act_prev_team_gender"
    CustomCup.ACT_NEXT_CUP_ID = "act_next_tour_id"
    CustomCup.ACT_PREV_CUP_ID = "act_prev_tour_id"
    CustomCup.ACT_CONFIRM_SETUP = "act_confirm_setup"
    CustomCup.ACT_BNT_CLICK = "act_btn_click"
end

GlobalTournamentSettings = GlobalTournamentSettings or {}

function CustomCup:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self

    o.services = { settingsService = o.api("SettingsService") }
    
    -- Configurações de contagem de times por formato de torneio
    o.teamCountLists = {
        full = {
            { name = "16 Teams", value = 16 },
            { name = "24 Teams", value = 24 },
            { name = "32 Teams", value = 32 },
            { name = "48 Teams", value = 48 }
        },
        knockout = {
            { name = "16 Teams", value = 16 }
        },
        groupKnockoutOnly = {
            { name = "16 Teams", value = 16 },
            { name = "24 Teams", value = 24 },
            { name = "32 Teams", value = 32 },
            { name = "48 Teams", value = 48 }
        },
        league = {
            { name = "36 Teams", value = 36 }
        }
    }
    
    -- Todas as ligas disponíveis
    o.allTournaments = {
        { name = "UEFA Champions League", value = 1, availableTeamCounts = {16, 32, 36} },
        { name = "UEFA Europa League", value = 2, availableTeamCounts = {16, 32, 36} },
        { name = "UEFA Euro", value = 3, availableTeamCounts = {16, 24} },
        { name = "UEFA Nations League", value = 4, availableTeamCounts = {16} },
        { name = "UEFA Women CL", value = 5, availableTeamCounts = {16, 32, 36} },
        { name = "CONMEBOL Libertadores", value = 6, availableTeamCounts = {16, 32, 36} },
        { name = "CONMEBOL Sudamericana", value = 7, availableTeamCounts = {16, 32, 36} },
        { name = "CONMEBOL Copa America", value = 8, availableTeamCounts = {16} },
        { name = "FIFA Club World Cup", value = 9, availableTeamCounts = {32, 36} },
        { name = "FIFA World Cup 2026", value = 10, availableTeamCounts = {16, 32, 36, 48} },
        
        { name = "The Emirates FA Cup", value = 11, availableTeamCounts = {16} },
        { name = "Copa del Rey", value = 12, availableTeamCounts = {16} },
        { name = "Coppa Italia", value = 13, availableTeamCounts = {16} },
        { name = "DFB-Pokal", value = 14, availableTeamCounts = {16} },
        { name = "Coupe de France", value = 15, availableTeamCounts = {16} },
        { name = "Copa do Brasil", value = 16, availableTeamCounts = {16} }
    }
    
    o.options = {
        tournamentType = {
            { name = "Group + Knockout", value = 1 },
            { name = "Knockout", value = 2 },
            { name = "League", value = 3 }
        },
        teamCount = o.teamCountLists.full,
        autoFill  = { { name = "Yes", value = 1 }, { name = "No", value = 2 } },
        teamGender = { { name = "Men's Team", value = "Men" }, { name = "Women's Team", value = "Women" } },
        defaultTourIdList = {},
        leagueTourIdList = {}
    }
    
    o.options.tourId = {}
    o.options.menDefaultTours = {}
    o.options.womenDefaultTours = {}
    o.options.menLeagueTours = {}
    o.options.womenLeagueTours = {}
    
    -- Separa ligas por gênero (Women/Men)
    local womenKeywords = {"Women", "W World Tour", "Féminine", "Frauen-Bundesliga", "NWSL", "Liga F"}
    local function containsWomenKeyword(name)
        for _, keyword in ipairs(womenKeywords) do
            if string.find(name, keyword) then
                return true
            end
        end
        return false
    end

    for _, tour in ipairs(o.allTournaments) do
        if containsWomenKeyword(tour.name) then
            table.insert(o.options.womenDefaultTours, tour)
        else
            table.insert(o.options.menDefaultTours, tour)
        end
    end

    o.selectedIndices = {
        tournamentType = 1,
        teamCount = 2,
        autoFill = 1,
        teamGender = 1,
        tourId = 1
    }
    o.tournamentName = "Tournament"

    o:RegisterBindingsAndActions()
    o:PublishInitialData()
    
    o.tabBindings = { self.BND_TAB1_VISIBLE, self.BND_TAB2_VISIBLE, self.BND_TAB3_VISIBLE, self.BND_TAB4_VISIBLE, self.BND_TAB5_VISIBLE }
    for _, binding in ipairs(o.tabBindings) do
        o.im.Subscribe(binding, function() end)
    end
    o:HideSelections()
    o.im.Publish(self.BND_TAB1_VISIBLE, true)

    o.im.RegisterAction(self.ACT_BNT_CLICK, function(_, data)
        o:HideSelections()
        local tabIndex = data.buttonID + 1
        if o.tabBindings[tabIndex] then
            o.im.Publish(o.tabBindings[tabIndex], true)
        end
    end)
    
    return o
end

function CustomCup:RegisterBindingsAndActions()
    self.im.RegisterAction(self.ACT_NEXT_TOURNAMENT_TYPE, function() self:nextTournamentType() end)
    self.im.RegisterAction(self.ACT_PREV_TOURNAMENT_TYPE, function() self:prevTournamentType() end)
    self.im.Subscribe(self.BND_TOURNAMENT_TYPE_TEXT, function() self:updateTournamentTypeUI() end)
    self.im.Subscribe(self.BND_TOURNAMENT_CREST, function() self:updateTournamentTypeUI() end)
    self.im.Subscribe(self.BND_PREV_TOURNAMENT_CREST, function() self:updateTournamentTypeUI() end)
    self.im.Subscribe(self.BND_NEXT_TOURNAMENT_CREST, function() self:updateTournamentTypeUI() end)
    
    self.im.RegisterAction(self.ACT_NEXT_TEAM_COUNT, function() self:nextTeamCount() end)
    self.im.RegisterAction(self.ACT_PREV_TEAM_COUNT, function() self:prevTeamCount() end)
    self.im.Subscribe(self.BND_TEAM_COUNT_TEXT, function() self:updateTeamCountUI() end)

    self.im.RegisterAction(self.ACT_NEXT_AUTO_FILL, function() self:nextAutoFill() end)
    self.im.RegisterAction(self.ACT_PREV_AUTO_FILL, function() self:prevAutoFill() end)
    self.im.Subscribe(self.BND_AUTO_FILL_TEXT, function() self:updateAutoFillUI() end)
    
    self.im.RegisterAction(self.ACT_NEXT_TEAM_GENDER, function() self:nextTeamGender() end)
    self.im.RegisterAction(self.ACT_PREV_TEAM_GENDER, function() self:prevTeamGender() end)
    self.im.Subscribe(self.BND_TEAM_GENDER_TEXT, function() self:updateTeamGenderUI() end)
    
    self.im.RegisterAction(self.ACT_NEXT_CUP_ID, function() self:nexttourId() end)
    self.im.RegisterAction(self.ACT_PREV_CUP_ID, function() self:prevtourId() end)
    self.im.Subscribe(self.BND_CUP_ID_TEXT, function() self:updatetourIdUI() end)
    
    self.im.Subscribe(self.BND_DESCRIPTION, function() self:PublishDescription() end)
    self.im.RegisterAction(self.ACT_CONFIRM_SETUP, function() self:ConfirmAndProceed() end)
end

function CustomCup:navigate(settingName, direction)
    local options = self.options[settingName]
    local currentIndex = self.selectedIndices[settingName]
    local newIndex = currentIndex + direction
    
    if newIndex > #options then newIndex = 1
    elseif newIndex < 1 then newIndex = #options end
    
    self.selectedIndices[settingName] = newIndex
end

function CustomCup:nextTournamentType() self:navigate("tournamentType", 1); self:updateTournamentTypeUI() end
function CustomCup:prevTournamentType() self:navigate("tournamentType", -1); self:updateTournamentTypeUI() end
function CustomCup:nextTeamCount() self:navigate("teamCount", 1); self:updateTeamCountUI() end
function CustomCup:prevTeamCount() self:navigate("teamCount", -1); self:updateTeamCountUI() end
function CustomCup:nexttourId() self:navigate("tourId", 1); self:updatetourIdUI() end
function CustomCup:prevtourId() self:navigate("tourId", -1); self:updatetourIdUI() end
function CustomCup:nextAutoFill() self:navigate("autoFill", 1); self:updateAutoFillUI() end
function CustomCup:prevAutoFill() self:navigate("autoFill", -1); self:updateAutoFillUI() end
function CustomCup:nextTeamGender() self:navigate("teamGender", 1); self:updateTeamGenderUI() end
function CustomCup:prevTeamGender() self:navigate("teamGender", -1); self:updateTeamGenderUI() end

-- Filtra torneios disponíveis por contagem de times e gênero
function CustomCup:getAvailableTournamentsForTeamCount(teamCount, gender)
    local baseTournaments = (gender == "Women") and self.options.womenDefaultTours or self.options.menDefaultTours
    local filteredTournaments = {}
    
    for _, tour in ipairs(baseTournaments) do
        for _, availableCount in ipairs(tour.availableTeamCounts) do
            if availableCount == teamCount then
                table.insert(filteredTournaments, tour)
                break
            end
        end
    end
    
    return filteredTournaments
end

function CustomCup:updateTournamentTypeUI()
    local options = self.options.tournamentType
    local totalOptions = #options
    local currentIndex = self.selectedIndices.tournamentType
    local currentOpt = options[currentIndex]
    if not currentOpt then return end

    -- Atualiza lista de times permitidos conforme tipo de torneio
    if currentOpt.name == "Group + Knockout" then
        self.options.teamCount = self.teamCountLists.groupKnockoutOnly
        self.selectedIndices.teamCount = 1
    elseif currentOpt.name == "Knockout" then
        self.options.teamCount = self.teamCountLists.knockout
        self.selectedIndices.teamCount = 1
    elseif currentOpt.name == "League" then
        self.options.teamCount = self.teamCountLists.league
        self.selectedIndices.teamCount = 1
    else
        self.options.teamCount = self.teamCountLists.full
        if self.selectedIndices.teamCount > #self.options.teamCount then
            self.selectedIndices.teamCount = #self.options.teamCount
        end
    end
    self:updateTourIdListBasedOnSelections()
    self:updateTeamCountUI()

    local prevIndex = (currentIndex - 2 + totalOptions) % totalOptions + 1
    local nextIndex = (currentIndex % totalOptions) + 1
    
    self.im.Publish(self.BND_TOURNAMENT_TYPE_LABEL, { data = {{ name = currentOpt.name }}, index = 0 })
    self.im.Publish(self.BND_TOURNAMENT_TYPE_TEXT, currentOpt.name)
    self.im.Publish(self.BND_TOURNAMENT_CREST, { name = "$CupIcon", id = currentOpt.value })
    self.im.Publish(self.BND_PREV_TOURNAMENT_CREST, { name = "$CupIcon", id = options[prevIndex].value })
    self.im.Publish(self.BND_NEXT_TOURNAMENT_CREST, { name = "$CupIcon", id = options[nextIndex].value })
    
    self:PublishDescription()
end

function CustomCup:updateTourIdListBasedOnSelections()
    local typeOpt = self.options.tournamentType[self.selectedIndices.tournamentType]
    local genderOpt = self.options.teamGender[self.selectedIndices.teamGender]
    local teamCountOpt = self.options.teamCount[self.selectedIndices.teamCount]
    
    local teamCount = teamCountOpt and teamCountOpt.value or 16

    -- Filtra torneios de acordo com contagem de times e gênero
    if typeOpt.name == "League" then
        self.options.tourId = self:getAvailableTournamentsForTeamCount(teamCount, genderOpt.value)
    else
        self.options.tourId = self:getAvailableTournamentsForTeamCount(teamCount, genderOpt.value)
    end
    
    self.selectedIndices.tourId = 1
    self:updatetourIdUI()
end

function CustomCup:updateTeamCountUI()
    local current = self.options.teamCount[self.selectedIndices.teamCount]
    if current then
        self.im.Publish(self.BND_TEAM_COUNT_TEXT, current.name)
        self:updateTourIdListBasedOnSelections()
        self:PublishDescription()
    end
end

function CustomCup:updateAutoFillUI()
    local current = self.options.autoFill[self.selectedIndices.autoFill]
    if current then
        self.im.Publish(self.BND_AUTO_FILL_LABEL, { data = {{ name = current.name }}, index = 0 })
        self.im.Publish(self.BND_AUTO_FILL_TEXT, current.name)
        self:PublishDescription()
    end
end

function CustomCup:updatetourIdUI()
    local current = self.options.tourId[self.selectedIndices.tourId]
    if current then
        self.im.Publish(self.BND_CUP_ID_TEXT, current.name)
        self:PublishDescription()
    end
end

function CustomCup:updateTeamGenderUI()
    local current = self.options.teamGender[self.selectedIndices.teamGender]
    if current then
        self.im.Publish(self.BND_TEAM_GENDER_LABEL, { data = {{ name = current.name }}, index = 0 })
        self.im.Publish(self.BND_TEAM_GENDER_TEXT, current.name)
        self:updateTourIdListBasedOnSelections()
        self:PublishDescription()
    end
end

function CustomCup:PublishInitialData()
    self:updateTournamentTypeUI()
    self:updateTeamCountUI()
    self:updateAutoFillUI()
    self:updatetourIdUI()
    self:updateTeamGenderUI()
end

function CustomCup:PublishDescription()
    local typeOpt = self.options.tournamentType[self.selectedIndices.tournamentType]
    local teamsOpt = self.options.teamCount[self.selectedIndices.teamCount]
    local tourOpt = self.options.tourId[self.selectedIndices.tourId]
    local genderOpt = self.options.teamGender[self.selectedIndices.teamGender]

    if typeOpt and teamsOpt and tourOpt and genderOpt then
        local desc = string.format(
            "You are creating a %s tournament named '%s' with %s %s teams, featuring the %s branding.",
            string.upper(typeOpt.name),
            self.tournamentName,
            teamsOpt.name,
            genderOpt.name,
            tourOpt.name
        )
        self.im.Publish(self.BND_DESCRIPTION, desc)
    end
end

function CustomCup:ConfirmAndProceed()
    local selectedTourId = self.options.tourId[self.selectedIndices.tourId].value
    local selectedTeamCount = self.options.teamCount[self.selectedIndices.teamCount].value
    local selectedTournamentType = self.options.tournamentType[self.selectedIndices.tournamentType].name

    local totalGroups = 0
    local teamsPerGroup = 4
    local isKnockoutOnly = false
    local matchdaysPerGroup = 0
    local isLeagueMode = false
    
    -- Define configurações específicas para cada formato
    if selectedTournamentType == "League" then
        isLeagueMode = true
        totalGroups = 1
        teamsPerGroup = 36
        matchdaysPerGroup = 0
    elseif selectedTournamentType == "Knockout" then
        isKnockoutOnly = true
        totalGroups = 0
        matchdaysPerGroup = 0
    elseif selectedTeamCount == 16 then
        totalGroups = 4
        matchdaysPerGroup = 3
    elseif selectedTeamCount == 24 then
        totalGroups = 6
        matchdaysPerGroup = 3
    elseif selectedTeamCount == 32 then
        totalGroups = 8
        matchdaysPerGroup = 6
    elseif selectedTeamCount == 48 then
        totalGroups = 12
        matchdaysPerGroup = 3
    end
    
    GlobalTournamentSettings = {
        tourId = selectedTourId,
        teamCount = selectedTeamCount,
        tournamentType = selectedTournamentType,
        tournamentName = self.tournamentName,
        selectedTourId = selectedTourId,
        teamsPerGroup = teamsPerGroup,
        totalGroups = totalGroups,
        isKnockoutOnly = isKnockoutOnly,
        matchdaysPerGroup = matchdaysPerGroup,
        isLeagueMode = isLeagueMode,
        useUCLStyle = (selectedTournamentType == "Group + Knockout"),
    }

    print("Tournament Settings Saved")
    print("Type:", GlobalTournamentSettings.tournamentType)
    print("Teams:", GlobalTournamentSettings.teamCount)
    print("League Mode:", GlobalTournamentSettings.isLeagueMode)
    
    self.nav.Event(nil, "evt_group_stage")
end

function CustomCup:HideSelections()
    for _, binding in ipairs(self.tabBindings or {}) do
        self.im.Publish(binding, false)
    end
end

function CustomCup:finalize()
    local actions = {
        self.ACT_NEXT_TOURNAMENT_TYPE, self.ACT_PREV_TOURNAMENT_TYPE,
        self.ACT_NEXT_TEAM_COUNT, self.ACT_PREV_TEAM_COUNT,
        self.ACT_NEXT_AUTO_FILL, self.ACT_PREV_AUTO_FILL,
        self.ACT_NEXT_CUP_ID, self.ACT_PREV_CUP_ID,
        self.ACT_NEXT_TEAM_GENDER, self.ACT_PREV_TEAM_GENDER,
        self.ACT_CONFIRM_SETUP, self.ACT_BNT_CLICK
    }
    for _, action in ipairs(actions) do
        self.im.UnregisterAction(action)
    end

    local subscriptions = {
        self.BND_TOURNAMENT_TYPE_LABEL, self.BND_TOURNAMENT_TYPE_TEXT,
        self.BND_TOURNAMENT_CREST, self.BND_PREV_TOURNAMENT_CREST, self.BND_NEXT_TOURNAMENT_CREST,
        self.BND_TEAM_COUNT_LABEL, self.BND_TEAM_COUNT_TEXT,
        self.BND_AUTO_FILL_LABEL, self.BND_AUTO_FILL_TEXT,
        self.BND_CUP_ID_LABEL, self.BND_CUP_ID_TEXT,
        self.BND_TEAM_GENDER_LABEL, self.BND_TEAM_GENDER_TEXT,
        self.BND_DESCRIPTION,
        self.BND_TAB1_VISIBLE, self.BND_TAB2_VISIBLE, self.BND_TAB3_VISIBLE,
        self.BND_TAB4_VISIBLE, self.BND_TAB5_VISIBLE
    }
    for _, sub in ipairs(subscriptions) do
        self.im.Unsubscribe(sub)
    end
end

return CustomCup