---- THANKS FOR ALL MODDER --
---- IMPROVED BY MOUNTSA ----
local FUTLoginManager, VirtualButton, TableUtil, EventManager, SKUEnums = ...
local SelectLeagueTeam = {}
local stadiumIdToName = {}
local BND_COUNTRY_NAME = "bnd_country_name"
local BND_LEAGUE_INDEX = "bnd_league_index"
local BND_LEAGUE_LIST = "bnd_league_list"
local BND_SELECTED_LEAGUE_NAME = "bnd_selected_league_name"
local BND_LEAGUE_OVERLAY_VISIBLE = "bnd_league_overlay_visible"
local BND_TEAM_INDEX = "bnd_team_index"
local BND_TEAM_LIST = "bnd_team_list"
local BND_SELECTED_TEAM_NAME = "bnd_selected_team_name"
local BND_TEAM_OVERLAY_VISIBLE = "bnd_team_overlay_visible"
local BND_TEAM_CREST_HOME_KIT = "bnd_home_kit"
local BND_TEAM_CREST_AWAY_KIT = "bnd_away_kit"
local BND_DIFFICULTY_LABEL1 = "bnd_difficulty_label1"
local BND_DIFFICULTY_LABEL2 = "bnd_difficulty_label2"
local BND_DIFFICULTY_LABEL3 = "bnd_difficulty_label3"
local BND_DIFFICULTY_LABEL4 = "bnd_difficulty_label4"
local BND_DIFFICULTY_LABEL5 = "bnd_difficulty_label5"
local BND_STADIUM_NAME = "bnd_stadium_name"
local BND_TEAM_VALUE = "bnd_team_value"
local BND_TRANSFER_BUDGET = "bnd_transfer_budget"
local BND_TEAM_CREST = "bnd_team_crest"
local BND_LEAGUE_CREST = "bnd_league_crest"
local BND_LEAGUE_CREST_ACTIVE = "bnd_league_crest_active"
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
local BND_HOME_COUNTRY_SELECT_VISIBLE = "bnd_home_country_select_visible"
local BND_HOME_TEAM_SELECT_VISIBLE = "bnd_home_team_select_visible"
local BND_HOME_LEAGUE_SELECT_VISIBLE = "bnd_home_league_select_visible"
local BND_MENS_SELECT_VISIBLE = "bnd_mens_select_visible"
local BND_WOMENS_SELECT_VISIBLE = "bnd_womens_select_visible"
local ACT_BTN_CLICK = "act_btn_click"
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local LOGIN_STATUS = FUTLoginManager.FeCards.LoginStatus
local TERMINATION_REASON = SKUEnums.fifaids.TerminationReason
local COUNTRY_H = 2
local TEAM_H = 1
local LEAGUE_H = 3
local NUM_COLUMNS = 4
local MENS = 5
local WOMENS = 6
missionmode = "ER"
ligaId = 1

function SelectLeagueTeam:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
    o:initLeagueCountryMapping()  -- Tambahkan ini
  o.services = {
    TeamService = o.api("TeamService"),
    CountryService = o.api("CountryService"),
    UserPlateService = o.api("UserPlateService"),
    GameStateService = o.api("GameStateService"),
    FUTUserInfoService = o.api("FUTUserInfoService"),
    EventManagerService = o.api("EventManagerService"),
    settingsService = o.api("SettingsService"),
    GameState = o.api("GameStateService")
  }
  o.currentOptions = o.services.settingsService.GetCurrentOptions()
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
  o:publishTransferBudget()
  o:initStadiumDatabase()
  o:registerLeagueBindings()
  o:registerTeamBindings()
  o.randomDifficultyLabels = nil
  o.hasInitializedDifficulties = false
    o.im.Subscribe("bnd_league_index", function(leagueId)
    local bg = o:getBackgroundByLeagueID(leagueId)
    o.services.MiscService:Log("Set background for leagueId: " .. tostring(leagueId))
    o.im.Publish("bnd_menu_bg", bg)
  end)
  o.im.Subscribe(BND_COUNTRY_NAME, function()
    local countryName = o:getCountryNameByLeagueId(o.currentLeagueID)
    o.im.Publish(BND_COUNTRY_NAME, countryName)
end)
  o.im.Subscribe(BND_TEAM_CREST, function()
    o:publishTeamCrest(o.currentTeamID) 
  end)
  o.im.Subscribe(BND_STADIUM_NAME, function()
        o:publishStadiumName(o.currentTeamID)
    end)
  o.im.Subscribe(BND_TEAM_VALUE, function()
        o:publishTeamValue(o.currentTeamID)  
    end)
  o.im.Subscribe(BND_TRANSFER_BUDGET, function()
        o:calculateTransferBudget(o.currentTeamID)  
    end)
  o.im.Subscribe(BND_TEAM_CREST_HOME_KIT, function()
    o:publishTeamCrestHomeKit(o.currentTeamID) 
  end)
  o.im.Subscribe(BND_TEAM_CREST_AWAY_KIT, function()
    o:publishTeamCrestAwayKit(o.currentTeamID) 
  end)
  o.im.Subscribe(BND_LEAGUE_CREST, function()
    o:publishLeagueCrest()
  end)
  o.im.Subscribe(BND_LEAGUE_CREST_ACTIVE, function()
    o:publishLeagueCrestActive()
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
  o.buttonsID = { TEAM_H, COUNTRY_H, LEAGUE_H, MENS, WOMENS}
  o:HideSelections()
  o.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, true)
  o.im.Subscribe(BND_HOME_COUNTRY_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_HOME_TEAM_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_HOME_LEAGUE_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_MENS_SELECT_VISIBLE, function()
  end)
  o.im.Subscribe(BND_WOMENS_SELECT_VISIBLE, function()
  end)
  o.im.RegisterAction(ACT_BTN_CLICK, function(actionName, data)
    o:HideSelections()
    if o.buttonsID[data.buttonID + 1] == COUNTRY_H then
      o.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TEAM_H then
      o.im.Publish(BND_HOME_TEAM_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == LEAGUE_H then
      o.im.Publish(BND_HOME_LEAGUE_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == MENS then
      o.im.Publish(BND_MENS_SELECT_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == WOMENS then
      o.im.Publish(BND_WOMENS_SELECT_VISIBLE, true)
    end
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

function SelectLeagueTeam:initLeagueCountryMapping()
    self.leagueCountryMap = {
        [14] = "England",   -- Premier League
        [21] = "Germany",   -- Bundesliga
        [18] = "France",   -- Ligue 1
        [27] = "Italy",     -- Serie A
        [45] = "Spain",    -- La Liga
        [54] = "Brazil",    -- Brasileirão
        [7] = "Portugal",    -- Ligapro
        [95] = "America",    -- America
        
        -- Tambahkan mapping lainnya sesuai kebutuhan
    }
end

---- THANKS FOR ALL MODDER --
---- IMPROVED BY MOUNTSA ----
function SelectLeagueTeam:initStadiumDatabase()
    self.stadiumDatabase = {
-- Premier league --
    [1] = "Emirates Stadium",                 -- Arsenal
    [2] = "Villa Park",                       -- Aston Villa
    [3] = "Ewood Park",                       -- Blackburn Rovers
    [4] = "Reebok Stadium",                   -- Bolton Wanderers
    [5] = "Stamford Bridge",                  -- Chelsea
    [7] = "Goodison Park",                    -- Everton
    [9] = "Anfield",                          -- Liverpool
    [10] = "Etihad Stadium",                  -- Manchester City
    [11] = "Old Trafford",                    -- Manchester United
    [12] = "Riverside Stadium",              -- Middlesbrough
    [13] = "St. James' Park",                 -- Newcastle United
    [14] = "City Ground",                     -- Nottingham Forest
    [15] = "Loftus Road",                     -- Queens Park Rangers
    [17] = "St. Mary's Stadium",              -- Southampton
    [18] = "White Hart Lane",                 -- Tottenham Hotspur
    [19] = "Boleyn Ground (Upton Park)",      -- West Ham United
    [88] = "St. Andrew's",                    -- Birmingham City
    [94] = "Portman Road",                    -- Ipswich Town
    [95] = "King Power Stadium",              -- Leicester City
    [106] = "Stadium of Light",               -- Sunderland
    [109] = "The Hawthorns",                  -- West Bromwich Albion
    [110] = "Molineux Stadium",               -- Wolverhampton Wanderers
    [5] = "Stamford Bridge",           -- Chelsea
    [9] = "Anfield",                   -- Liverpool
    [10] = "Etihad Stadium",           -- Manchester City
    [11] = "Old Trafford",             -- Manchester United
    [18] = "Tottenham Hotspur Stadium", -- Tottenham Hotspur
    [19] = "London Stadium",           -- West Ham United
    [95] = "King Power Stadium",       -- Leicester City
    [110] = "Molineux Stadium",        -- Wolverhampton Wanderers
    [1795] = "Vicarage Road",          -- Watford
    [1796] = "Turf Moor",              -- Burnley
    [1799] = "Selhurst Park",          -- Crystal Palace
    [1808] = "American Express Stadium", -- Brighton & Hove Albion
    [1943] = "Vitality Stadium",       -- AFC Bournemouth
    [1960] = "Swansea.com Stadium",    -- Swansea City
    [1961] = "Cardiff City Stadium",   -- Cardiff City
    [335] = "King Power Stadium",      -- Leicester City (alternative ID)
    [340] = "American Express Stadium",-- Brighton (alternative ID)
    [355] = "London Stadium",          -- West Ham (alternative ID)
    [409] = "Tottenham Hotspur Stadium",-- Spurs (alternative ID)
    [432] = "Elland Road",             -- Leeds United
    [433] = "Bramall Lane",            -- Sheffield United
    [450] = "Gtech Community Stadium", -- Brentford
    [460] = "Kenilworth Road",         -- Luton Town
    [494] = "RAMS Park",               -- AFC Bournemouth (alternative)
    [326] = "Stadium of Light",        -- Sunderland
    [327] = "The Hawthorns",           -- West Bromwich Albion
    [328] = "Craven Cottage",          -- Fulham
    [329] = "Carrow Road",             -- Norwich City
    [330] = "Selhurst Park",           -- Crystal Palace (alternative)
    [336] = "Turf Moor",               -- Burnley (alternative)
    [337] = "MATRADE Loftus Road",     -- QPR
    [347] = "Vicarage Road",           -- Watford (alternative)
    [348] = "Vitality Stadium",        -- Bournemouth (alternative)
    [349] = "Riverside Stadium",       -- Middlesbrough
    [350] = "Portman Road",            -- Ipswich Town
    [364] = "Cívitas Metropolitano",   -- (Note: This is actually Atletico Madrid's stadium - likely incorrect mapping)
-- Premier League Teams (2023/24)
    [13] = "St. James' Park",           -- Newcastle United
    [14] = "The City Ground",           -- Nottingham Forest
    [17] = "St. Mary's Stadium",        -- Southampton
    [94] = "Portman Road",              -- Ipswich Town
    [144] = "Craven Cottage",           -- Fulham
    [7] = "Goodison Park",              -- Everton
-- La Liga 2023/24 Teams with Stadiums
    [240] = "Cívitas Metropolitano",       -- Atlético de Madrid
    [241] = "Spotify Camp Nou",            -- FC Barcelona
    [243] = "Estadio Santiago Bernabéu",   -- Real Madrid
    [448] = "San Mamés",                   -- Athletic Club
    [449] = "Estadio Benito Villamarín",   -- Real Betis
    [450] = "Abanca-Balaídos",             -- Celta Vigo
    [452] = "RCDE Stadium",                -- Espanyol
    [453] = "Visit Mallorca Estadi",       -- Mallorca
    [456] = "El Molinón",                  -- Sporting Gijón (Segunda División)
    [457] = "Reale Arena",                 -- Real Sociedad
    [459] = "Estadio Municipal de Butarque", -- Leganés (Segunda)
    [461] = "Estadio Mestalla",            -- Valencia CF
    [462] = "Estadio José Zorrilla",       -- Real Valladolid (Segunda)
    [463] = "Mendizorrotza",               -- Alavés
    [467] = "Ipurua",                      -- Eibar (Segunda)
    [468] = "Martínez Valero",             -- Elche (Segunda)
    [472] = "Estadio Gran Canaria",        -- Las Palmas
    [479] = "El Sadar",                    -- Osasuna
    [480] = "Estadio de Vallecas",         -- Rayo Vallecano
    [481] = "Ramón Sánchez-Pizjuán",       -- Sevilla FC
    [483] = "Estadio de la Cerámica",      -- Villarreal CF
    [1853] = "Estadio Ciudad de Valencia", -- Levante (Segunda)
    [1860] = "Coliseum Alfonso Pérez",     -- Getafe
    [1861] = "Power Horse Stadium",        -- Almería
    [386] = "Estadio de la Cerámica",      -- Villarreal (alternative ID)
    [388] = "San Mamés",                   -- Athletic Bilbao (alternative ID)
    [389] = "Ramón Sánchez-Pizjuán",       -- Sevilla (alternative ID)
    [390] = "Coliseum Alfonso Pérez",      -- Getafe (alternative ID)
    [392] = "Estadio Benito Villamarín",   -- Betis (alternative ID)
    [394] = "Abanca-Balaídos",             -- Celta Vigo (alternative ID)
    [396] = "Estadio Ciutat de València",  -- Levante (alternative)
    [397] = "Reale Arena",                 -- Real Sociedad (alternative)
    [400] = "Estadio Montilivi",           -- Girona
    [427] = "Estadio José Zorrilla",       -- Valladolid (alternative)
    [428] = "Estadio El Alcoraz",          -- Huesca (Segunda)
    [429] = "Estadio de Vallecas",         -- Rayo Vallecano (alternative)
    [437] = "El Sadar",                    -- Osasuna (alternative)
    [440] = "Visit Mallorca Estadi",       -- Mallorca (alternative)
    [455] = "Nuevo Mirandilla",            -- Cádiz CF
    [110062] = "Estadio Montilivi",        -- Girona (alternative ID)
    [110832] = "Nuevo Los Cármenes",       -- Granada CF
    [110839] = "El Alcoraz",               -- SD Huesca (Segunda)
    [1968] = "Nuevo Mirandilla",           -- Cádiz (alternative ID)
-- Bundesliga 2023/24 Teams with Stadiums
    [21] = "Allianz Arena",               -- FC Bayern München
    [22] = "Signal Iduna Park",           -- Borussia Dortmund
    [23] = "Borussia-Park",               -- Borussia Mönchengladbach
    [25] = "Europa-Park Stadion",         -- SC Freiburg
    [32] = "BayArena",                    -- Bayer 04 Leverkusen
    [34] = "VELTINS-Arena",               -- FC Schalke 04 (currently in 2. Bundesliga)
    [36] = "MHPArena",                    -- VfB Stuttgart
    [38] = "Weserstadion",                -- SV Werder Bremen
    [160] = "Vonovia Ruhrstadion",        -- VfL Bochum
    [165] = "Sportpark Ronhof",           -- Greuther Fürth (2. Bundesliga)
    [166] = "Olympiastadion Berlin",      -- Hertha BSC (2. Bundesliga)
    [169] = "MEWA Arena",                 -- 1. FSV Mainz 05
    [171] = "Max-Morlock-Stadion",        -- 1. FC Nürnberg (2. Bundesliga)
    [175] = "Volkswagen Arena",           -- VfL Wolfsburg
    [10029] = "PreZero Arena",            -- TSG Hoffenheim
    [10030] = "Home Deluxe Arena",        -- SC Paderborn 07 (2. Bundesliga)
    [110500] = "Eintracht-Stadion",       -- Eintracht Braunschweig (2. Bundesliga)
    [110502] = "Merck-Stadion am Böllenfalltor", -- SV Darmstadt 98
    [110588] = "MDCC-Arena",              -- 1. FC Magdeburg (2. Bundesliga)
    [110636] = "Merkur Spiel-Arena",      -- Fortuna Düsseldorf (2. Bundesliga)
    [110645] = "Sportpark Höhenberg",     -- Viktoria Köln (3. Liga)
    [110676] = "Stadion Rote Erde",       -- Borussia Dortmund II (3. Liga)
    [111235] = "Voith-Arena",             -- 1. FC Heidenheim
    [112172] = "Red Bull Arena",          -- RB Leipzig
    [343] = "Borussia-Park",              -- Borussia M'gladbach (alternative ID)
    [406] = "Volkswagen Arena",           -- Wolfsburg (alternative ID)
    [407] = "PreZero Arena",              -- Hoffenheim (alternative ID)
    [412] = "WWK Arena",                  -- FC Augsburg
    [413] = "Weserstadion",               -- Werder Bremen (alternative ID)
    [414] = "MEWA Arena",                 -- Mainz 05 (alternative ID)
    [416] = "Deutsche Bank Park",         -- Eintracht Frankfurt
    [417] = "Heinz von Heiden-Arena",     -- Hannover 96 (2. Bundesliga)
    [418] = "MHPArena",                   -- Stuttgart (alternative ID)
    [420] = "Red Bull Arena",             -- RB Leipzig (alternative ID)
    [422] = "Max-Morlock-Stadion",        -- Nürnberg (alternative ID)
    [423] = "RheinEnergieStadion",        -- 1. FC Köln
    [454] = "SchücoArena",                -- Arminia Bielefeld (2. Bundesliga)
    [473] = "Vonovia Ruhrstadion",        -- Bochum (alternative ID)
    [474] = "Sportpark Ronhof",           -- Fürth (alternative ID)
    [485] = "HDI-Arena",                  -- Hannover 96
    [100409] = "WWK Arena",               -- Augsburg (alternative ID)
-- Serie A 2023/2024 Teams with Stadiums
    [45] = "Allianz Stadium",            -- Juventus
    [48] = "Diego Armando Maradona",     -- Napoli
    [50] = "Stadio Ennio Tardini",       -- Parma (Serie B)
    [52] = "Stadio Olimpico",            -- Roma
    [54] = "Stadio Olimpico Grande Torino", -- Torino
    [55] = "Dacia Arena",                -- Udinese
    [1842] = "Unipol Domus",             -- Cagliari
    [1843] = "Stadio Renzo Barbera",     -- Palermo (Serie B)
    [1848] = "Stadio San Nicola",        -- Bari (Serie B)
    [110373] = "Stadio Arechi",          -- Salernitana
    [110374] = "Stadio Artemio Franchi", -- Fiorentina
    [110556] = "Luigi Ferraris",         -- Genoa
    [111657] = "Stadio Benito Stirpe",   -- Frosinone
    [111811] = "U-Power Stadium",        -- Monza
    [111974] = "Mapei Stadium",          -- Sassuolo
    [113973] = "Stadio Mario Rigamonti", -- Brescia (Serie B)
    [113974] = "Stadio Alberto Picco",   -- Spezia (Serie B)
    [116280] = "Allianz Stadium",        -- Juventus (alternative ID)
    [116282] = "Stadio Olimpico",        -- Roma (alternative ID)
    [110738] = "Arena Garibaldi",        -- Pisa (Serie B)
    [110740] = "Stadio Città del Tricolore", -- Reggiana (Serie B)
    [131720] = "Stadio Via del Mare",    -- Lecce
    [131724] = "Stade de la Meinau",     -- Strasbourg (Ligue 1, contoh cross-league)
    [131733] = "Stadio Carlo Castellani", -- Empoli
    [131447] = "Parc des Princes",       -- Paris SG (contoh cross-league)
    [111434] = "Stadio Giovanni Zini",   -- Cremonese (Serie B)
    [111993] = "Stadio Piercesare Tombolato", -- Cittadella (Serie B)
    [112168] = "Stadio San Vito",        -- Cosenza (Serie B)
    [112494] = "Stadio Druso",           -- Südtirol (Serie B)
    [113616] = "Stadio Franz Fekete",    -- Grazer AK (Austria, contoh cross-league)
    [190] = "San Siro (Giuseppe Meazza)",  -- Inter Milan
    [194] = "San Siro (Giuseppe Meazza)",  -- AC Milan
-- Ligue 1 2023/24 Teams with Stadiums
    [57] = "Stade de l'Abbé-Deschamps",       -- AJ Auxerre
    [65] = "Decathlon Arena (Stade Pierre-Mauroy)",  -- LOSC Lille
    [66] = "Groupama Stadium",                 -- Olympique Lyonnais
    [69] = "Stade Louis II",                   -- AS Monaco
    [70] = "Stade de la Mosson",               -- Montpellier HSC
    [71] = "Stade de la Beaujoire",            -- FC Nantes
    [72] = "Allianz Riviera",                  -- OGC Nice
    [73] = "Parc des Princes",                 -- Paris Saint-Germain
    [74] = "Roazhon Park",                     -- Stade Rennais
    [76] = "Stade de la Meinau",               -- Strasbourg
    [217] = "Stade du Moustoir",               -- FC Lorient
    [219] = "Orange Vélodrome",                -- Olympique de Marseille
    [294] = "Stade de l'Aube",                 -- ESTAC Troyes
    [378] = "Stade Francis-Le Blé",            -- Stade Brestois
    [379] = "Stade Auguste-Delaune",           -- Stade de Reims
    [116034] = "Parc des Princes",             -- Paris SG (alternative ID)
    [116035] = "Stade Charléty",               -- Paris FC (Ligue 2)
    [116037] = "Stade de la Mosson",           -- Montpellier (alternative ID)
    [116039] = "Stade Gaston-Gérard",          -- Dijon FCO (Ligue 2)
    [116040] = "Stade Auguste-Delaune",        -- Reims (alternative ID)
    [116044] = "Stade Geoffroy-Guichard",      -- AS Saint-Étienne (Ligue 2)
    [1530] = "Stade Raymond-Kopa",             -- Angers SCO (Ligue 2)
    [1738] = "Stade Océane",                   -- Le Havre AC
    [1809] = "Stadium de Toulouse",            -- Toulouse FC
    [1815] = "Stade Gabriel-Montpied",         -- Clermont Foot
    [1816] = "Stade de la Licorne",            -- Amiens SC (Ligue 2)
    [1819] = "Stade Geoffroy-Guichard",        -- AS Saint-Étienne
    [111817] = "Stade Charléty",               -- Paris FC (alternative ID)
    [111276] = "Stade Marcel-Tribut",          -- USL Dunkerque (Ligue 2)
    [131447] = "Parc des Princes",             -- Paris SG (cross-reference)
-- Brasileirão Série A 2024 Teams with Stadiums
    [383] = "Allianz Parque",                  -- Palmeiras
    [517] = "Estádio Nilton Santos",           -- Botafogo
    [567] = "Maracanã",                        -- Fluminense
    [568] = "Mineirão",                        -- Cruzeiro
    [598] = "MorumBis",                         -- São Paulo
    [1013] = "Estádio Pedro Bidegain",         -- San Lorenzo (Argentina, but in your list)
    [1035] = "Arena MRV",                      -- Atlético Mineiro
    [1039] = "Arena da Baixada",               -- Athletico Paranaense
    [1041] = "Neo Química Arena",              -- Corinthians
    [1043] = "Maracanã",                       -- Flamengo
    [1048] = "Beira-Rio",                      -- Internacional
    [1629] = "Arena do Grêmio",                -- Grêmio
    [112472] = "Estádio Nabi Abi Chedid",      -- RB Bragantino
    [115530] = "Arena Pantanal",               -- Cuiabá
    [111052] = "Castelão (CE)",                -- Fortaleza
    [101100] = "Atanasio Girardot",            -- Atlético Nacional (Colombia, in your list)
    [101101] = "Metropolitano Roberto Meléndez", -- Junior (Colombia, in your list)
    [101105] = "El Campín",                    -- Millonarios (Colombia, in your list)
    [110968] = "Estádio Hernando Siles",       -- Bolívar (Bolivia, in your list)
    [110975] = "Estádio San Carlos de Apoquindo", -- Universidad Católica (Chile, in your list)
    [110980] = "Estádio Monumental",           -- Colo-Colo (Chile, in your list)
    [110986] = "Estádio Rodrigo Paz Delgado",  -- LDU Quito (Ecuador, in your list)
    [112540] = "Estádio do Pacaembu",          -- (Note: Currently not used as main stadium)
    [112996] = "Allianz Parque",               -- (Alternative for Palmeiras)
-- AFC Teams (Top Asian Leagues) with Stadiums
    [605] = "King Fahd International Stadium",  -- Al Hilal (Saudi Arabia)
    [607] = "King Abdullah Sports City",       -- Al Ittihad (Saudi Arabia)
    [980] = "Daejeon World Cup Stadium",       -- Daejeon Hana Citizen (South Korea)
    [982] = "Seoul World Cup Stadium",         -- FC Seoul (South Korea)
    [111674] = "Prince Faisal bin Fahd Stadium", -- Al Shabab (Saudi Arabia)
    [112139] = "Mrsool Park",                  -- Al Nassr (Saudi Arabia)
    [112387] = "King Abdullah Sports City",    -- Al Ahli (Saudi Arabia)
    [112390] = "Prince Abdul Aziz bin Musa'ed", -- Al Fateh (Saudi Arabia)
    [112392] = "King Abdullah Sport City",     -- Al Raed (Saudi Arabia)
    [112393] = "King Abdullah Sport City",     -- Al Taawoun (Saudi Arabia)
    [112408] = "King Abdulaziz Stadium",       -- Al Wehda (Saudi Arabia)
    [113037] = "Prince Turki bin Abdul Aziz",  -- Al Riyadh (Saudi Arabia)
    [113217] = "Prince Sultan bin Abdul Aziz", -- Damac FC (Saudi Arabia)
    [1473] = "Ulsan Munsu Football Stadium",   -- Ulsan Hyundai (South Korea)
    [1474] = "Pohang Steel Yard",              -- Pohang Steelers (South Korea)
    [1477] = "Jeonju World Cup Stadium",       -- Jeonbuk Hyundai (South Korea)
    [1478] = "Jeju World Cup Stadium",         -- Jeju United (South Korea)
    [2055] = "Gimcheon Stadium",               -- Gimcheon Sangmu (South Korea)
    [2056] = "DGB Daegu Bank Park",            -- Daegu FC (South Korea)
    [112258] = "Gwangju Football Stadium",     -- Gwangju FC (South Korea)
    [112558] = "Suwon Sports Complex",         -- Suwon FC (South Korea)
    [111701] = "Hazza bin Zayed Stadium",      -- Al Ain FC (UAE)
    [111724] = "Jinan Olympic Stadium",        -- Shandong Taishan (China)
    [111768] = "Workers' Stadium",             -- Beijing Guoan (China)
    [111769] = "Changchun Stadium",            -- Changchun Yatai (China)
    [111774] = "Tianjin Olympic Center",       -- Tianjin Jinmen Tiger (China)
    [111779] = "Zhengzhou Hanghai Stadium",    -- Henan FC (China)
    [112540] = "Shanghai Stadium",             -- Shanghai Port (China)
    [112979] = "Rugao Olympic Sports Center",  -- Nantong Zhiyun (China)
    [112985] = "Cangzhou Stadium",             -- Cangzhou Mighty Lions (China)
    [113298] = "Fatorda Stadium",              -- FC Goa (India)
    [113299] = "Jawaharlal Nehru Stadium",     -- Kerala Blasters (India)
    [113300] = "Mumbai Football Arena",        -- Mumbai City FC (India)
    [113301] = "GMC Balayogi Stadium",         -- Hyderabad FC (India)
    [113302] = "Sree Kanteerava Stadium",      -- Bengaluru FC (India)
    [113146] = "Salt Lake Stadium",            -- Mohun Bagan SG (India)
    [115202] = "Tau Devi Lal Stadium",         -- Punjab FC (India)
    [111629] = "Salt Lake Stadium",            -- East Bengal (India)
    [111633] = "Salt Lake Stadium",            -- Mohammedan SC (India)
    [918] = "Aspmyra Stadion",                 -- Bodø/Glimt (Norway, but in AFC CL)
    [919] = "Brann Stadion",                   -- SK Brann (Norway, but in AFC CL)
    [922] = "Marienlyst Stadion",              -- Strømsgodset (Norway, but in AFC CL)
-- Liga 1 Indonesia 2023/2024
    [20001] = "Gelora Bung Karno",          -- Persija Jakarta
    [20002] = "Kanjuruhan",                 -- Arema FC
    [20003] = "Gelora Bandung Lautan Api",  -- Persib Bandung
    [20004] = "Kapten I Wayan Dipta",       -- Bali United
    [20005] = "Gelora Bung Tomo",           -- Persebaya Surabaya
    [20006] = "Maguwoharjo",                -- PSS Sleman
    [20007] = "Patriot Candrabhaga",        -- Borneo FC
    [20008] = "Segiri",                     -- Persis Solo
    [20009] = "Gelora Sriwijaya",           -- Sriwijaya FC
    [20010] = "Batakan",                    -- Barito Putera
    [20011] = "Gelora Delta",               -- Persikabo 1973
    [20012] = "Wibawa Mukti",               -- Persik Kediri
    [20013] = "Sultan Agung",               -- PSIS Semarang
    [20014] = "Manahan",                    -- Persis Solo (alternate)
    [20015] = "Pakansari",                  -- Persita Tangerang
    [20016] = "Gelora Joko Samudro",        -- Gresik United
    [20017] = "Si Jalak Harupat",           -- Persib (alternate)
    [20018] = "Gelora Bumi Kartini",        -- Persijap Jepara
    [20019] = "Aji Imbut",                  -- Persis Putra Samarinda
    [20020] = "Gelora Supriyadi",           -- Persela Lamongan
    [20021] = "Merdeka",                    -- PSMS Medan
    [20022] = "Gelora 10 November",         -- Persela (alternate)
    [20023] = "Gelora Bung Karno Madya",    -- Shared venue
    [20024] = "Haji Agus Salim",            -- PSPS Pekanbaru
    [20025] = "Gelora Bumi Kartini",        -- Multi-use

    [245] = "Johan Cruijff ArenA",          -- Ajax
    [246] = "De Kuip",                      -- Feyenoord
    [247] = "Philips Stadion",              -- PSV Eindhoven
    [1903] = "Stadion Galgenwaard",         -- FC Utrecht
    [1904] = "Rat Verlegh Stadion",         -- NAC Breda
    [1905] = "Mandemakers Stadion",         -- RKC Waalwijk
    [1906] = "AFAS Stadion",                -- AZ Alkmaar
    [1907] = "Koning Willem II Stadion",    -- Willem II
    [1908] = "De Grolsch Veste",            -- FC Twente
    [1910] = "Goffertstadion",              -- NEC Nijmegen
    [1913] = "Abe Lenstra Stadion",         -- sc Heerenveen
    [1914] = "MAC PARK Stadion",            -- PEC Zwolle
    [1915] = "Euroborg",                    -- FC Groningen
    [100632] = "De Adelaarshorst",          -- Go Ahead Eagles
    [100634] = "Erve Asito",                -- Heracles Almelo
    [100646] = "Het Kasteel",               -- Sparta Rotterdam
    [111380] = "Yanmar Stadion",            -- Almere City FC

    [234] = "Estádio da Luz",               -- Benfica
    [236] = "Estádio do Dragão",            -- FC Porto
    [237] = "Estádio José Alvalade",        -- Sporting CP
    [10020] = "Estádio António Coimbra da Mota", -- Estoril Praia
    [1887] = "Estádio D. Afonso Henriques", -- Vitória SC
    [1888] = "Estádio Cidade de Barcelos",  -- Gil Vicente
    [1891] = "Estádio da Madeira",          -- Nacional
    [1896] = "Estádio Municipal de Braga",  -- SC Braga
    [1898] = "Estádio do Bessa",            -- Boavista
    [1900] = "Parque de Jogos Comendador Joaquim de Almeida Freitas", -- Moreirense
    [112513] = "Estádio Municipal de Arouca", -- Arouca
    [114510] = "Estádio Pina Manique",      -- Casa Pia
    [112809] = "Estádio Municipal 22 de Junho", -- Famalicão
    [131358] = "Estádio da Luz",            -- Benfica (alternative ID)
    [131463] = "Estádio do Vizela",        -- Vizela
        -- Belgian Pro League --
    [229] = "Constant Vanden Stock",       -- Anderlecht
    [230] = "Bosuilstadion",               -- Antwerp
    [231] = "Jan Breydel Stadion",         -- Club Brugge
    [232] = "Stade Maurice Dufrasne",      -- Standard Liège
    [100081] = "Guldensporenstadion",      -- Kortrijk
    [100087] = "King Power at Den Dreef",  -- OH Leuven
    [670] = "Stade du Pays de Charleroi",  -- Charleroi
    [673] = "Cegeka Arena",                -- Genk
    [674] = "Ghelamco Arena",              -- Gent
    [675] = "Olympisch Stadion",           -- Beerschot
    [680] = "Stayen",                      -- STVV
    [681] = "Het Kuipje",                  -- Westerlo
    [110724] = "AFAS Stadion",             -- Mechelen

        -- MLS (USA/Canada) --
    [687] = "Lower.com Field",             -- Columbus Crew
    [688] = "Audi Field",                  -- DC United
    [689] = "Red Bull Arena",              -- NY Red Bulls
    [691] = "Gillette Stadium",            -- New England Revolution
    [693] = "Soldier Field",               -- Chicago Fire
    [694] = "Dick's Sporting Goods Park",  -- Colorado Rapids
    [695] = "Toyota Stadium",              -- FC Dallas
    [696] = "Children's Mercy Park",       -- Sporting KC
    [697] = "Dignity Health Sports Park",  -- LA Galaxy
    [698] = "Shell Energy Stadium",        -- Houston Dynamo
    [111112] = "BC Place",                 -- Vancouver Whitecaps
    [111138] = "Allianz Field",            -- Minnesota United
    [111139] = "Saputo Stadium",           -- CF Montréal
    [111140] = "Providence Park",          -- Portland Timbers
    [111144] = "Lumen Field",              -- Seattle Sounders
    [111651] = "BMO Field",                -- Toronto FC
    [112828] = "Yankee Stadium",           -- NYCFC
    [112885] = "Mercedes-Benz Stadium",    -- Atlanta United
    [112893] = "DRV PNK Stadium",          -- Inter Miami
    [112996] = "Banc of California",       -- LAFC
    [113018] = "CityPark",                 -- St. Louis CITY
    [114161] = "Q2 Stadium",               -- Austin FC
    [114162] = "Geodis Park",              -- Nashville SC

        -- Turkish Süper Lig --
    [325] = "Nef Stadyumu",                -- Galatasaray
    [326] = "Ülker Stadyumu",              -- Fenerbahçe
    [327] = "Vodafone Park",               -- Beşiktaş
    [436] = "Medical Park Stadyumu",       -- Trabzonspor
    [741] = "Antalya Stadyumu",            -- Antalyaspor
    [748] = "19 Mayıs Stadyumu",           -- Samsunspor
    [495] = "Başakşehir Fatih Terim",     -- İstanbul Başakşehir
    [101014] = "Başakşehir Fatih Terim",  -- Başakşehir (alt)
    [101016] = "Yeni Adana Stadyumu",      -- Adana Demirspor
    [101020] = "Kadir Has Stadyumu",       -- Kayserispor
    [101028] = "Yeni Hatay Stadyumu",      -- Hatayspor
    [101033] = "Konya Büyükşehir",        -- Konyaspor
    [101041] = "Yeni 4 Eylül Stadyumu",    -- Sivasspor
    [111339] = "Recep Tayyip Erdoğan",    -- Kasımpaşa
    [131174] = "Eyüp Stadyumu",            -- Eyüpspor

        -- Liga MX (Mexico) --
    [1386] = "Estadio Azteca",             -- América
    [517] = "Estadio Olímpico Universitario", -- UNAM
    [101099] = "Estadio Azteca",           -- América (alt)
    [112908] = "Estadio Akron",            -- Guadalajara
    [113010] = "Estadio BBVA",             -- Monterrey
    [113029] = "Estadio Olímpico UCV",     -- UCV
    [1386] = "Estadio Jalisco",            -- Atlas
    [1386] = "Estadio Corona",             -- Santos Laguna
    [1386] = "Estadio Cuauhtémoc",         -- Puebla
    [1386] = "Estadio Victoria",           -- Necaxa
    [1386] = "Estadio Hidalgo",            -- Pachuca
    [1386] = "Estadio Caliente",           -- Tijuana
    [1386] = "Estadio Universitario",      -- Tigres
    [1386] = "Estadio Morelos",            -- Morelia
    [1386] = "Estadio León",               -- León
    [1386] = "Estadio Azul"             -- Cruz Azul
    }
end
function SelectLeagueTeam:calculateTeamValue()
    local teamRating = self:getTeamRating()  
    local normalizedRating = (teamRating - 1) / (100 - 1)
    local minValue = 75000000
    local maxValue = 95000000
    local teamValue = minValue + (normalizedRating * (maxValue - minValue))
    teamValue = math.floor(teamValue + 0.5)
    local formattedValue = "$" .. tostring(teamValue):reverse():gsub("(%d%d%d)", "%1."):reverse()
    if formattedValue:sub(1,1) == "." then
        formattedValue = formattedValue:sub(2)
    end
    return formattedValue
end
function SelectLeagueTeam:calculateTransferBudget()
    local teamRating = self:getTeamRating()
    local normalizedRating = (teamRating - 1) / (100 - 1)
    local minBudget = 1000000000  -- 1 miliar
    local maxBudget = 8000000000  -- 8 miliar
    local budget = minBudget + (normalizedRating * (maxBudget - minBudget))
    budget = math.floor(budget / 1000000) * 1000000
    local formatted = "$" .. tostring(budget):reverse():gsub("(%d%d%d)", "%1."):reverse()
    if formatted:sub(2, 2) == "." then
        formatted = formatted:sub(1, 1) .. formatted:sub(3)
    end
    return formatted
end

function SelectLeagueTeam:getBackgroundByLeagueID(leagueId)
  local mapping = {
    [13] = "$Background6",
    [53] = "$Background4",
    [100] = "$Background7"
    -- tambahkan mapping lain di sini
  }

  local name = mapping[leagueId] or "$BackgroundDefault"
  return {
    name = name,
    id = leagueId
  }
end

-- Update the difficulty generation function
function SelectLeagueTeam:ensureDifficultyLabels()
    if not self.randomDifficultyLabels then
        -- Gunakan teamID sebagai seed untuk konsistensi
        math.randomseed(os.time() + (self.currentTeamID or 0))
        
        local allDifficulties = {
            "Very Low", "Low", "Medium", "High", "Critical",
            "Beginner", "Easy", "Normal", "Hard", "Expert"
        }
        for i = #allDifficulties, 2, -1 do
            local j = math.random(i)
            allDifficulties[i], allDifficulties[j] = allDifficulties[j], allDifficulties[i]
        end
        self.randomDifficultyLabels = {
            allDifficulties[1],
            allDifficulties[2],
            allDifficulties[3],
            allDifficulties[4],
            allDifficulties[5]
        }
        print(string.format("Generated new difficulties for Team %d", self.currentTeamID))
    end
end

function SelectLeagueTeam:getDifficultyColor(label)
    local colorMap = {
    ["Very Low"] = 0x2ECC71,   -- Emerald green
    ["Low"] = 0x27AE60,        -- Deep green
    ["Medium"] = 0xF1C40F,     -- Sunflower yellow
    ["High"] = 0xE67E22,       -- Carrot orange
    ["Critical"] = 0xE74C3C,   -- Strong red
    ["Beginner"] = 0x1ABC9C,   -- Aqua (turquoise)
    ["Easy"] = 0x3498DB,       -- Light blue
    ["Normal"] = 0xBDC3C7,     -- Silver/Gray
    ["Hard"] = 0x9B59B6,       -- Amethyst purple
    ["Expert"] = 0xC0392B      -- Dark red
    }
    return colorMap[label or ""] or 0xFFFFFF
end
function SelectLeagueTeam:getCountryNameByLeagueId(leagueId)
    -- Coba dari service
    local success, countryInfo = pcall(function()
        return self.services.CountryService.GetCountryInfoByFUTLeagueId(leagueId)
    end)
    
    if success and countryInfo and countryInfo.id ~= -1 then
        -- Gunakan nama langsung jika tersedia
        if countryInfo.name and countryInfo.name ~= "" then
            return countryInfo.name
        end

        -- Coba dari lokal jika tersedia
        local locName = self.loc.LocalizeString("CountryName_" .. countryInfo.id)
        if locName and locName ~= ("CountryName_" .. countryInfo.id) then
            return locName
        end

        return countryInfo.id or "Unknown Country (Service)"
    end

    -- Fallback manual
    local manualMap = {
        [1120402720] = "Indonesia"
    }
    return manualMap[leagueId] or "Unknown Country (Fallback)"
end

function SelectLeagueTeam:getTeamRating()
    if not self.teamsData or not self.teamsData[self.teamIndex] then
    return 0 end
    local team = self.teamsData[self.teamIndex]
    return (team.offense + team.midfield + team.defense) / 3
end

function SelectLeagueTeam:_juiceSelectLeagueTeam(currentTeamID)
  self.currentTeamID = currentTeamID
  self.favoritePlayerID = self.services.UserPlateService.GetFavoritePlayerByTeamId(self.currentTeamID)
  self.services.FUTUserInfoService.SetUserFavoriteTeam(self.currentTeamID)
end

function SelectLeagueTeam:getLeagues()
  local leagueNames = {}
  self.leagueIDs = {
    13, 14, 16, 19, 2235, 31, 341, 10, 308, 350, 50, 53, 68, 39, 4, 7, 8
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
  self:publishLeagueCrestActive()
  self:getTeams()
  self.im.Refresh(BND_COUNTRY_NAME) -- Refresh nama negara
      
    local countryName = self:getCountryNameByLeagueId(self.currentLeagueID)
    print("Negara untuk liga ini:", countryName)
    self.im.Publish("bnd_country_name", countryName)
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

  local alternateBG = true

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
  for i = 1, 5 do
    local labelBnd = "bnd_difficulty_label"..i
    local colorBnd = "bnd_difficulty_color"..i

    self.im.Subscribe(labelBnd, function()
        self:ensureDifficultyLabels()
        self.im.Publish(labelBnd, self.randomDifficultyLabels[i] or "")
    end)

    self.im.Subscribe(colorBnd, function()
        self:ensureDifficultyLabels()
        local label = self.randomDifficultyLabels[i] or ""
        local color = self:getDifficultyColor(label)
        self.im.Publish(colorBnd, color)
    end)
    end
    self.im.Subscribe("bnd_team_value", function()
    self:publishTeamValue()
    end)
    self.im.Subscribe("bnd_transfer_budget", function()
    self:publishTransferBudget()
    end)
end

function SelectLeagueTeam:refreshAllDifficulties()
    self.randomDifficultyLabels = nil
    self:ensureDifficultyLabels()
    for i = 1, 5 do
    local label = self.randomDifficultyLabels[i] or ""
    local color = self:getDifficultyColor(label)

    self.im.Publish("bnd_difficulty_label"..i, label)
    self.im.Publish("bnd_difficulty_color"..i, color)

    self.im.Refresh("bnd_difficulty_label"..i)
    self.im.Refresh("bnd_difficulty_color"..i)
end
    -- Debug output
    print("Refreshed Difficulties for Team", self.currentTeamID)
    print("Labels:", table.concat(self.randomDifficultyLabels, " | "))
end

function SelectLeagueTeam:reshuffleDifficultyLabels()
    self.randomDifficultyLabels = nil
    self:publishAllDifficultyLabels()
end

function SelectLeagueTeam:setSelectedTeamIndex(index)
    self:setSelectedTeamIndexHelper(index)
    self:publishStadiumName(self.currentTeamID)
    self:publishTeamCrest(self.currentTeamID)
    self:publishTeamCrestHomeKit(self.currentTeamID)
    self:publishTeamCrestAwayKit(self.currentTeamID)
    self:publishTeamValue()
    self:publishTransferBudget()

    self.randomDifficultyLabels = nil
    self:ensureDifficultyLabels()
    for i = 1, 5 do
        local label = self.randomDifficultyLabels[i] or ""
        local color = self:getDifficultyColor(label)
        self.im.Publish("bnd_difficulty_label"..i, label)
        self.im.Publish("bnd_difficulty_color"..i, color)
        self.im.Refresh("bnd_difficulty_label"..i)
        self.im.Refresh("bnd_difficulty_color"..i)
    end
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

function SelectLeagueTeam:publishLeagueCrestActive()
  if self.currentLeagueID ~= -1 then
    local leagueCrestActive = {
      name = "$LeagueActive",
      id = self.currentLeagueID
    }
    self.im.Publish(BND_LEAGUE_CREST_ACTIVE, leagueCrestActive)
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
    self:publishAllDifficultyLabels() 
    for i = 1, 5 do
            self.im.Publish("bnd_difficulty_label"..i, "")
        end
  else
    self.favoritePlayerID = -1
  end
end

function SelectLeagueTeam:publishTeamCrestHomeKit(teamid)
  if self.currentTeamID ~= -1 then
    currentSelectedTeamID = self.currentTeamID 
    local selectedTeamID = teamid or self.currentTeamID 

    self.favoritePlayerID = self.services.UserPlateService.GetFavoritePlayerByTeamId(selectedTeamID)
    local teamCresthomekit = {
      name = "$KitHome",
      id = selectedTeamID
    }

    self.im.Publish(BND_TEAM_CREST_HOME_KIT, teamCresthomekit)

    self:publishTeamStarRating()
    self:publishLeagueToggle()
    self:publishTeamRating()
  else
    self.favoritePlayerID = -1
  end
end

function SelectLeagueTeam:publishTeamCrestAwayKit(teamid)
  if self.currentTeamID ~= -1 then
    currentSelectedTeamID = self.currentTeamID 
    local selectedTeamID = teamid or self.currentTeamID 

    self.favoritePlayerID = self.services.UserPlateService.GetFavoritePlayerByTeamId(selectedTeamID)
    local teamCrestawaykit = {
      name = "$KitAway",
      id = selectedTeamID
    }

    self.im.Publish(BND_TEAM_CREST_AWAY_KIT, teamCrestawaykit)

    self:publishTeamStarRating()
    self:publishLeagueToggle()
    self:publishTeamRating()
  else
    self.favoritePlayerID = -1
  end
end
function SelectLeagueTeam:publishStadiumName(teamid)
    if not self.stadiumDatabase then
        self:initStadiumDatabase()
    end
    local selectedTeamID = teamid or self.currentTeamID
    if not selectedTeamID or selectedTeamID == -1 then
        self.im.Publish(BND_STADIUM_NAME, "")
        return
    end
    local stadiumName = self.stadiumDatabase[selectedTeamID] or "Unknown Name"
    self.currentStadium = {
        id = selectedTeamID,
        name = stadiumName
    }
    self.im.Publish(BND_STADIUM_NAME, stadiumName)
    -- Debug output
    print(string.format("Published stadium for team %d: %s", 
          selectedTeamID, stadiumName))
end
function SelectLeagueTeam:refreshStadiumName()
    if not self.currentStadium or not self.currentStadium.id then
        self.im.Publish(BND_STADIUM_NAME, "")
        return
    end
    local stadiumName = self.stadiumDatabase[self.currentStadium.id] or "Home Stadium"
    self.im.Publish(BND_STADIUM_NAME, stadiumName)
end
function SelectLeagueTeam:publishTransferBudget()
    local budget = self:calculateTransferBudget()
    self.im.Publish("bnd_transfer_budget", budget)
end

function SelectLeagueTeam:publishTeamValue()
    local teamValue = self:calculateTeamValue()
    self.im.Publish("bnd_team_value", teamValue)
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
  self:publishTeamCrest(self.currentTeamID)
  self:publishTeamCrestHomeKit(self.currentTeamID)
  self:publishTeamCrestAwayKit(self.currentTeamID)

  -- Publish the toggle data
  self.im.Publish(BND_TEAM_LIST_TOGGLE, {
    data = teamData,
    index = self.teamIndex - 1
  })
end

function SelectLeagueTeam:publishAllDifficultyLabels()
    self:ensureDifficultyLabels()
    -- Publish semua label sekaligus
    self.im.Publish(BND_DIFFICULTY_LABEL1, self.randomDifficultyLabels[1] or "")
    self.im.Publish(BND_DIFFICULTY_LABEL2, self.randomDifficultyLabels[2] or "")
    self.im.Publish(BND_DIFFICULTY_LABEL3, self.randomDifficultyLabels[3] or "")
    self.im.Publish(BND_DIFFICULTY_LABEL4, self.randomDifficultyLabels[4] or "")
    self.im.Publish(BND_DIFFICULTY_LABEL5, self.randomDifficultyLabels[5] or "")
    -- Force refresh UI
    self.im.Refresh(BND_DIFFICULTY_LABEL1)
    self.im.Refresh(BND_DIFFICULTY_LABEL2)
    self.im.Refresh(BND_DIFFICULTY_LABEL3)
    self.im.Refresh(BND_DIFFICULTY_LABEL4)
    self.im.Refresh(BND_DIFFICULTY_LABEL5)
end

function SelectLeagueTeam:publishTeamIndex()
  self:publishTeamCrest(self.currentTeamID)
    self:publishTeamCrestAwayKit(self.currentTeamID)
  self:publishTeamCrestHomeKit(self.currentTeamID)-- Pass currentTeamID explicitly-- Pass currentTeamID explicitly
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
function SelectLeagueTeam:HideSelections()
  self.im.Publish(BND_HOME_COUNTRY_SELECT_VISIBLE, false)
  self.im.Publish(BND_HOME_TEAM_SELECT_VISIBLE, false)
  self.im.Publish(BND_HOME_LEAGUE_SELECT_VISIBLE, false)
  self.im.Publish(BND_MENS_SELECT_VISIBLE, false)
  self.im.Publish(BND_WOMENS_SELECT_VISIBLE, false)
end
function SelectLeagueTeam:finalize()
self.im.Unsubscribe("bnd_league_index")
  self.im.Unsubscribe(BND_HOME_COUNTRY_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_HOME_TEAM_SELECT_VISIBLE)
  self.im.Unsubscribe(BND_HOME_LEAGUE_SELECT_VISIBLE)
   self.im.UnregisterAction(ACT_BTN_CLICK)
  self.im.Unsubscribe(BND_TRANSFER_BUDGET)
  self.im.Unsubscribe(BND_TEAM_VALUE)
  self.im.Unsubscribe(BND_STADIUM_NAME)
  self.im.Unsubscribe(BND_LEAGUE_LIST)
  self.im.Unsubscribe(BND_SELECTED_LEAGUE_NAME)
  self.im.Unsubscribe(BND_LEAGUE_OVERLAY_VISIBLE)
  self.im.Unsubscribe(BND_TEAM_LIST)
  self.im.Unsubscribe(BND_SELECTED_TEAM_NAME)
  self.im.Unsubscribe(BND_TEAM_OVERLAY_VISIBLE)
  self.im.Unsubscribe(BND_TEAM_CREST)
  self.im.Unsubscribe(BND_LEAGUE_CREST)
  self.im.Unsubscribe(BND_LEAGUE_CREST_ACTIVE)
  self.im.Unsubscribe(BND_TEAM_CREST_HOME_KIT)
  self.im.Unsubscribe(BND_TEAM_CREST_AWAY_KIT)
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
---- THANKS FOR ALL MODDER --
---- IMPROVED BY MOUNTSA ----