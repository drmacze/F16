-- Suporta múltiplos formatos: Group + Knockout, Knockout e League

local MatchPlay = {}

local BND_COLOR_CUPID = "bnd_color_tourid"
local BND_PANEL_LOADING = "bnd_panel_loading"
local BND_MATCH_INFO = "bnd_match_info"
local BND_MATCH_HOUR = "bnd_match_hour"
local BND_HOME_SIDE_ICON = "bnd_home_side_icon"
local BND_AWAY_SIDE_ICON = "bnd_away_side_icon"
local bnd2DHomeKit = "bnd_2d_home_kit"
local bnd2DAwayKit = "bnd_2d_away_kit"
local BND_TAB1_VISIBLE = "bnd_tab1_visible"
local BND_TAB2_VISIBLE = "bnd_tab2_visible"
local BND_TAB3_VISIBLE = "bnd_tab3_visible"
local BND_TAB4_VISIBLE = "bnd_tab4_visible"
local ACT_ADVANCE = "act_advance"
local ACT_CUSTOMIZE = "act_customize"
local ACT_BTN_CLICK = "act_btn_click"
local TAB1, TAB2, TAB3, TAB4 = 1, 2, 3, 4

currentMatch = { HomeTeamID = 0, AwayTeamID = 0, HomeKitIndex = 0, AwayKitIndex = 1 }
currentTourData = currentTourData or {}

local tourIdToNameMap = {
    [1] = "UEFA Champions League", [2] = "UEFA Europa League",
    [3] = "UEFA Euro", [4] = "UEFA Nations League",
    [5] = "UEFA Women CL", [6] = "CONMEBOL Libertadores",
    [7] = "CONMEBOL Sudamericana", [8] = "CONMEBOL Copa America",
    [9] = "FIFA Club World Cup", [10] = "FIFA World Cup 2026",
    [11] = "The Emirates FA Cup", [12] = "Copa del Rey",
    [13] = "Coppa Italia", [14] = "DFB-Pokal",
    [15] = "Coupe de France", [16] = "Copa do Brasil",
    default = "Custom Tournament"
}

local tourIdToColorMap = {
  [1]="0x000026", [2]="0x131313",
  [3]="0x02003D", [4]="0x3C4858",
  [5]="0x02003D", [6]="0x323232",
  [7]="0x02003D", [8]="0x02003D",
  [9]="0x131313", [10]="0x001B96", 
  [11]="0x000147", [12]="0x00072D",
  [13]="0x31A44D", [14]="0x505050", 
  [15]="0x000C44", [16]="0x006726", 
  default = "0x1A1A1A"
}

local tourIdToRefereeNameMap = {
    [1] = "Clément Turpin", [2] = "Stéphanie Frappart",
    [3] = "Stéphanie Frappart", [4] = "Stéphanie Frappart", 
    [5] = "Stéphanie Frappart", [6] = "Anderson Daronco",
    [7] = "Anderson Daronco", [8] = "Carlos del Cerro",
    [9] = "Carlos del Cerro", [10] = "Carlos del Cerro",
    [11] = "Stéphanie Frappart", [12] = "Carlos del Cerro",
    [13] = "Carlos del Cerro", [14] = "Stéphanie Frappart",
    [15] = "Clément Turpin", [16] = "Anderson Daronco",
    default = "Default Referee"
}

function MatchPlay:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self

    local tourId = GlobalTournamentSettings.tourId or 1
    o.services = {
        FifaCustomizationService = o.api("FifaCustomizationService"),
        MatchSetup = o.api("MatchSetupService"),
        settingsService = o.api("SettingsService"),
        GameSetup = o.api("GameSetupService"),
        SquadManagementService = o.api("SquadMgtService")
    }

    o.isAdsVisible = true
    o.currentOptions = o.services.settingsService.GetCurrentOptions()

    o.tourData = {
        tourBg = { name = "$CupBg", id = tourId },
        tourlogo = { name = "$CupLogo", id = tourId },
        trophy = { name = "$CupTrophy", id = tourId }
    }

    o.buttonsID = { TAB1, TAB2, TAB3, TAB4 }

    o:setupSubscriptions()
    o:setupActions()
    
    o.im.Publish("bnd_match_visible", true)
    o:HideSelections()
    o.im.Publish(BND_TAB1_VISIBLE, true)

    print(" MatchPlay Initialized for Tour: " .. tourIdToNameMap[tourId] .. " (ID: " .. tostring(tourId) .. ")")
    return o
end

function MatchPlay:HideSelections()
    self.im.Publish(BND_TAB1_VISIBLE, false)
    self.im.Publish(BND_TAB2_VISIBLE, false)
    self.im.Publish(BND_TAB3_VISIBLE, false)
    self.im.Publish(BND_TAB4_VISIBLE, false)
end

function MatchPlay:setupSubscriptions()
    local tourId = GlobalTournamentSettings.tourId or 1

    --  SUBSCRIPTIONS BÁSICAS
    self.im.Subscribe(BND_COLOR_CUPID, function()
        local currentTourId = GlobalTournamentSettings.tourId or 1
        local color = tourIdToColorMap[currentTourId] or tourIdToColorMap.default
        self.im.Publish(BND_COLOR_CUPID, color)
    end)

    self.im.Subscribe(BND_PANEL_LOADING, function(isVisible) end)
    self.im.Subscribe(bnd2DHomeKit, function() end)
    self.im.Subscribe(bnd2DAwayKit, function() end)

    --  SUBSCRIPTIONS DE INFORMAÇÕES DO MATCH
    self.im.Subscribe("bnd_bg_tour", function() self.im.Publish("bnd_bg_tour", self.tourData.tourBg) end)
    self.im.Subscribe("bnd_tour_logo", function() self.im.Publish("bnd_tour_logo", self.tourData.tourlogo) end)
    self.im.Subscribe("bnd_trophy", function() self.im.Publish("bnd_trophy", self.tourData.trophy) end)

    --  SUBSCRIPTION PARA INFORMAÇÕES COMPLETAS DO MATCH (Hora, Estádio, Árbitro, Dificuldade)
    self.im.Subscribe(BND_MATCH_INFO, function()
        local halfLength = self.currentOptions.halfLengthData or "6 minutes"
        local currentDate = os.date("%d %B %Y")
        local stadiumName = self.currentOptions.stadium or "Default Stadium"
        local weather = self.currentOptions.weather or "Clear"
        local refereeName = "Referee: " .. (tourIdToRefereeNameMap[tourId] or "Default Referee")
        local currentHour = tonumber(os.date("%H"))
        local difficulty = self.currentOptions.difficulty or "Legendary"

        local dynamicTimeOfDay
        if currentHour >= 5 and currentHour < 12 then
            dynamicTimeOfDay = "Morning"
        elseif currentHour >= 12 and currentHour < 18 then
            dynamicTimeOfDay = "Afternoon"
        else
            dynamicTimeOfDay = "Night"
        end

        local line1 = string.format("%s | %s | %s | %s", stadiumName, currentDate, refereeName, difficulty)
        local line2 = string.format("%s | %s | %s", halfLength, dynamicTimeOfDay, weather)
        local matchTimeString = line1 .. "\n" .. line2

        self.im.Publish(BND_MATCH_INFO, matchTimeString)
    end)

    --  SUBSCRIPTION PARA MOSTRAR APENAS A HORA (9:00 PM)
    self.im.Subscribe(BND_MATCH_HOUR, function()
        local matchHour = self:getMatchHour()
        self.im.Publish(BND_MATCH_HOUR, matchHour)
    end)

    --  SUBSCRIPTIONS PARA MATCH INFO
    for _, k in ipairs({
        "bnd_home_side_icon", "bnd_away_side_icon", "bnd_user_side_icon",
        "bnd_match_visible", "bnd_home_crest", "bnd_away_crest",
        "bnd_home_team", "bnd_away_team", "bnd_group_label",
        "bnd_home_team_short", "bnd_away_team_short", "bnd_team_crest", "bnd_team_name"
    }) do
        self.im.Subscribe(k, function() self:publishMatchInfo() end)
    end

    --  SUBSCRIPTIONS PARA TABS
    self.im.Subscribe(BND_TAB1_VISIBLE, function() end)
    self.im.Subscribe(BND_TAB2_VISIBLE, function() end)
    self.im.Subscribe(BND_TAB3_VISIBLE, function() end)
    self.im.Subscribe(BND_TAB4_VISIBLE, function() end)

    self.im.Subscribe("bnd_tour_label", function() self:publishMatchInfo() end)
end

function MatchPlay:setupActions()
    --  ACTION PARA INICIAR MATCH
    self.im.RegisterAction(ACT_ADVANCE, function()
        self:Advance()
    end)

    --  ACTION PARA CUSTOMIZAR MATCH
    self.im.RegisterAction(ACT_CUSTOMIZE, function()
        self:CustomizeMatch()
    end)

    --  ACTION PARA TABS
    self.im.RegisterAction(ACT_BTN_CLICK, function(actionName, data)
        self:HideSelections()
        if self.buttonsID[data.buttonID + 1] == TAB1 then
            self.im.Publish(BND_TAB1_VISIBLE, true)
        elseif self.buttonsID[data.buttonID + 1] == TAB2 then
            self.im.Publish(BND_TAB2_VISIBLE, true)
        elseif self.buttonsID[data.buttonID + 1] == TAB3 then
            self.im.Publish(BND_TAB3_VISIBLE, true)
        elseif self.buttonsID[data.buttonID + 1] == TAB4 then
            self.im.Publish(BND_TAB4_VISIBLE, true)
        end
    end)
end

--  FUNÇÃO PARA OBTER APENAS A HORA (9:00 PM)
function MatchPlay:getMatchHour()
    local hour = tonumber(os.date("%H"))
    local minute = os.date("%M")
    local ampm = hour >= 12 and "PM" or "AM"
    
    if hour > 12 then
        hour = hour - 12
    elseif hour == 0 then
        hour = 12
    end
    
    return string.format("%d:%s %s", hour, minute, ampm)
end

--  PUBLICAR INFORMAÇÕES DO MATCH
function MatchPlay:publishMatchInfo()
    local tourId = GlobalTournamentSettings.tourId or 1
    local tourName = tourIdToNameMap[tourId] or tourIdToNameMap.default

    self.im.Publish(BND_PANEL_LOADING, true)

    if not currentTourData or not currentTourData.homeID or not currentTourData.awayID then
        self.im.Publish("bnd_text", "Loading match data...")
        self.im.Publish(BND_PANEL_LOADING, false)
        return
    end

    local homeTeamId = currentTourData.homeID
    local awayTeamId = currentTourData.awayID
    local roundName = currentTourData.roundName or "Group Stage"

    self.im.Publish("bnd_text", roundName)
    self.im.Publish("bnd_match_visible", true)
    self.im.Publish("bnd_home_crest", { name = "$Crest", id = homeTeamId })
    self.im.Publish("bnd_away_crest", { name = "$Crest", id = awayTeamId })
    self.im.Publish("bnd_home_team", self.loc.LocalizeString("TeamName_Abbr15_" .. homeTeamId))
    self.im.Publish("bnd_away_team", self.loc.LocalizeString("TeamName_Abbr15_" .. awayTeamId))

    --  USAR currentMatch DIRETAMENTE (como no arquivo que funciona)
    print("DEBUG: Publishing kits - HomeKitIndex=" .. tostring(currentMatch.HomeKitIndex) .. ", AwayKitIndex=" .. tostring(currentMatch.AwayKitIndex))
    self:publish2DKit(bnd2DHomeKit, homeTeamId, currentMatch.HomeKitIndex or 0)
    self:publish2DKit(bnd2DAwayKit, awayTeamId, currentMatch.AwayKitIndex or 1)

    --  PUBLICAR ÍCONE DE CONTROLE (Qual time o usuário controla)
    local userTeamId = currentTourInfo[tourId] and currentTourInfo[tourId].homeID or 0
    if userTeamId == homeTeamId then
        self.im.Publish(BND_HOME_SIDE_ICON, "$_IconController")
        self.im.Publish(BND_AWAY_SIDE_ICON, nil)
    else
        self.im.Publish(BND_HOME_SIDE_ICON, nil)
        self.im.Publish(BND_AWAY_SIDE_ICON, "$_IconController")
    end

    self.im.Publish(BND_PANEL_LOADING, false)
    self.im.Publish("bnd_tour_label", tourName)

    print(" MatchPlay: Informações do match publicadas")
    print("   -> Home Kit Index: " .. tostring(currentMatch.HomeKitIndex))
    print("   -> Away Kit Index: " .. tostring(currentMatch.AwayKitIndex))
end

--  PUBLICAR KITS 2D
function MatchPlay:publish2DKit(binding, teamId, kitType)
    if not teamId or teamId == 0 then return end
    local kitId = string.format("%s_%s_%s", kitType, teamId, 0)
    self.im.Publish(binding, {name = "$Kits", id = kitId})
end

--  INICIAR MATCH
function MatchPlay:Advance()
    local buttonNo = {
        icon = "$FooterIconNo",
        label = "Cancel",
        clickEvents = { "evt_hide_popup", "evt_refresh_on_resize" }
    }
    local buttonYes = {
        icon = "$FooterIconYes",
        label = "Confirm",
        clickEvents = { "evt_hide_popup" }
    }

    function buttonYes.clickCallback()
        self.nav.Event(nil, "evt_advance")
    end

    local popupData = {
        title = "Play Match",
        message = "Are you ready to start the match?",
        buttons = { buttonNo, buttonYes }
    }

    self.nav.Event(nil, "evt_show_popup", popupData)
    print(" MatchPlay: Mostrando diálogo de confirmação de match")
end

--  CUSTOMIZAR MATCH (Kits, Táticas, etc)
function MatchPlay:CustomizeMatch()
    self.nav.Event(nil, "evt_customize")
    print(" MatchPlay: Abrindo tela de customização")
end

--  LIMPAR TUDO AO FINALIZAR
function MatchPlay:finalize()
    -- Unsubscribe Actions
    self.im.UnregisterAction(ACT_ADVANCE)
    self.im.UnregisterAction(ACT_CUSTOMIZE)
    self.im.UnregisterAction(ACT_BTN_CLICK)

    -- Unsubscribe Bindings
    local subsToClean = {
        BND_COLOR_CUPID, BND_PANEL_LOADING, BND_MATCH_INFO, BND_MATCH_HOUR,
        BND_HOME_SIDE_ICON, BND_AWAY_SIDE_ICON, bnd2DHomeKit, bnd2DAwayKit,
        BND_TAB1_VISIBLE, BND_TAB2_VISIBLE, BND_TAB3_VISIBLE, BND_TAB4_VISIBLE,
        "bnd_bg_tour", "bnd_tour_logo", "bnd_trophy",
        "bnd_match_visible", "bnd_home_crest", "bnd_away_crest",
        "bnd_home_team", "bnd_away_team", "bnd_group_label",
        "bnd_home_team_short", "bnd_away_team_short",
        "bnd_team_crest", "bnd_team_name", "bnd_tour_label"
    }

    for _, s in ipairs(subsToClean) do
        self.im.Unsubscribe(s)
    end

    print(" MatchPlay module finalized")
end

return MatchPlay