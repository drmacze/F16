-- Menu Player Career --
-- Squad Improved Mountsa --
-- Remode By Septiawan --

local ItemModel, TableUtil, FormationModel = ...
local MAX_STARTING = 11
local TeamManagementModel = {}
local BND_CHEMISTRY_MATRIX = "bnd_chemistry_matrix"
local BND_STARTING_11 = "bnd_starting_11"
local BND_SUBS_AND_RES = "bnd_subs_and_res"
local BND_SBS_AND_RES = "bnd_sbs_and_res"
local BND_RESERVES_ONLY = "bnd_reserves_only"
local BND_TEAM_NAME = "bnd_team_name"
local BND_TEAM_CREST = "bnd_team_crest"
local BND_TEAM_MAN = "bnd_team_man"
local BND_TEAM_RATING = "bnd_team_rating"
local BND_TEAM_STARS = "bnd_team_stars"
local BND_TEAM_RATING_LABEL = "bnd_team_rating_label"
local BND_TEAM_OVERALL = "bnd_team_overall"
local BND_PLAYER_COMPARISON_DATA = "bnd_player_comparison_data"
local ACT_ITEM_SHOW_BIO = "act_item_show_bio"
local ACT_SWAP_PLAYERS = "act_swap_players"
local bndBackgroundCareer = "bnd_background_career"
local bndTableCareer = "bnd_table_career"
local ACT_COMPARE_PLAYERS = "act_compare_players"
local BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE = "bnd_context_menu_visible"
local ACT_SWAP_WITH_INVENTORY = "act_swap_with_inventory"
local ACT_ITEM_SWAP_WITH_CLUB = "act_item_swap_with_club"
local ACT_ITEM_REMOVE_FROM_SQUAD = "act_item_remove_from_squad"
local ACT_ITEM_SEND_TO_TRADE_PILE = "act_item_send_to_trade_pile"
local ACT_ITEM_APPLY_CONSUMABLE = "act_item_apply_consumable"
local ACT_ITEM_QUICK_SELL = "act_item_quick_sell"
local ACT_ITEM_QUICK_LIST = "act_item_quick_list"
local ACT_SEND_ITEM_DATA = "act_send_item_data"
local ELIGIBLE_SQUAD_BINDING = "bnd_eligible_squad"
local BND_PLAYER_RATING = "bnd_player_rating"
local BND_PLAYER_AVATAR = "bnd_player_avatar"
local BND_ACTIVE_PLAYER_VISIBLE = "bnd_active_player_visible"
local BND_PASSIVE_PLAYER_VISIBLE = "bnd_passive_player_visible"
local attributeNames = { "PAC", "SHO", "PAS", "DRI", "DEF", "PHY" }
local NOTICE = "bnd_swap_notification"
local BND_SWAP_LABEL1 = "bnd_swap_label1"
local BND_SWAP_LABEL2 = "bnd_swap_label2"
local BND_SWAP_LABEL3 = "bnd_swap_label3"
local BND_SWAP_LABEL4 = "bnd_swap_label4"
local BND_SWAP_LABEL5 = "bnd_swap_label5"
local BND_SWAP_LABEL6 = "bnd_swap_label6"
local BND_ACTIVE_STAT_PREFIX = "bnd_active_stat_"
local BND_PASSIVE_STAT_PREFIX = "bnd_passive_stat_"
local BND_ACTIVE_STAT_COLOR_PREFIX = "bnd_active_stat_color_"
local BND_PASSIVE_STAT_COLOR_PREFIX = "bnd_passive_stat_color_"
local COLOR_RED = 0xc82727
local COLOR_WHITE = 0xFFFFFF
local COLOR_GREEN = 0x28992D

function TeamManagementModel:new(init)
  print("[TeamManagementModel]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    FUTSquadManagementService = o.api("FUTSquadManagementService"),
    SquadManagementService = o.api("SquadMgtService"),
    TacticsService = o.api("TacticsService"),
    GameSetupService = o.api("GameSetupService")
  }
  
  o.teamID = currentBeaproData.awayID
  
  o.models = {
    ItemModel = ItemModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc
    }),
    FormationModel = FormationModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      teamID = o.teamID,
      gamemode = o.gamemode
    })
  }
  o.formationList = o.models.FormationModel:getFormationList()
  o.teamInfo = o.services.SquadManagementService.GetTeamInfo(o.teamID)
  o.players = o:getPlayers(o.teamID)
  o.chemistryMatrix = nil
  o:clearPlayerVisibility()
  o.playerComparisonData = o:getPlayerComparisonData(nil, nil)
  o.im.Subscribe(BND_CHEMISTRY_MATRIX, function()
   o:_publishChemistryMatrix()
   o:checkSquadEligibility()
  end)
  o.im.Subscribe(BND_STARTING_11, function()
   o:_publishStarting11()
   o:checkSquadEligibility()
  end)
  o.im.Subscribe(BND_SUBS_AND_RES, function()
   o:_publishSubsAndRes()
   o:checkSquadEligibility()
  end)   
  o.im.Subscribe(BND_RES, function()
   o:_publishRes()
   o:checkSquadEligibility()
  end) 
  o.im.Subscribe(BND_SBS_AND_RES, function()
   o:_publishSbsAndRes()
   o:checkSquadEligibility()
  end)
  o.im.Subscribe(BND_TEAM_NAME, function()
   o:_publishTeamStats(BND_TEAM_NAME)
  end)
  o.im.Subscribe(BND_TEAM_CREST, function()
   o:_publishTeamStats(BND_TEAM_CREST)
  end)
  o.im.Subscribe(BND_TEAM_STARS, function()
   o:_publishTeamStats(BND_TEAM_STARS)
  end)   
  o.im.Subscribe(BND_TEAM_RATING_LABEL, function()
   o:_publishTeamRatingLabel()
  end)    
  o.im.Subscribe(BND_TEAM_RATING, function()
   o:_publishTeamRating()
  end)
  o.im.Subscribe(BND_TEAM_OVERALL, function()
   o:_publishTeamStats(BND_TEAM_OVERALL)
  end)
  o.im.Subscribe(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE, function() end)
   o.im.Subscribe(BND_PLAYER_COMPARISON_DATA, function()
     o:_publishPlayerComparisonData()
  end)
  o.im.Subscribe(ELIGIBLE_SQUAD_BINDING, function()
     o:_publishEligibleSquad()
  end)
  o.im.Subscribe("bnd_default_player_avatar", function()
    o.im.Publish("bnd_default_player_avatar", { name = "$Head", id = 0 })
  end)
  o.im.Subscribe("bnd_default_sharpness_icons", function()
    o.im.Publish("bnd_default_sharpness_icons", { name = "$SharpnessLow", id = 0 })
  end)
  o.im.Subscribe("bnd_default_fitness_icons", function()
    o.im.Publish("bnd_default_fitness_icons", { name = "$FitnessLow", id = 0 })
  end)
  o.im.Subscribe("bnd_default_playstyles_icons", function()
    o.im.Publish("bnd_default_playstyles_icons", { name = "$PlayStyles_1", id = 0 })
  end)
  o.im.Subscribe("bnd_default_horizontal", function()
    o.im.Publish("bnd_default_horizontal", { name = "$Horizontal_Line", id = 0 })
  end)
  o.im.Subscribe("bnd_default_vertical", function()
    o.im.Publish("bnd_default_vertical", { name = "$Vertical_Line", id = 0 })
  end)
  o.im.Subscribe("bnd_default_info", function()
    o.im.Publish("bnd_default_info", "Player Info")
  end)
  o.im.Subscribe("bnd_default_stat", function()
    o.im.Publish("bnd_default_stat", "-")
  end)
  o.im.Subscribe("bnd_default_label1", function()
    o.im.Publish("bnd_default_label1", "Fitness")
  end)
  o.im.Subscribe("bnd_default_label2", function()
    o.im.Publish("bnd_default_label2", "Sharpness")
  end)
  o.im.Subscribe("bnd_default_label3", function()
    o.im.Publish("bnd_default_label3", "Role")
  end)
  o.im.Subscribe("bnd_default_label4", function()
    o.im.Publish("bnd_default_label4", "Focus")
  end)
  o.im.Subscribe("bnd_default_label5", function()
    o.im.Publish("bnd_default_label5", "Position(s)")
  end)
  o.im.Subscribe("bnd_default_label6", function()
    o.im.Publish("bnd_default_label6", "Number")
  end)
  o.im.Subscribe("bnd_default_label7", function()
    o.im.Publish("bnd_default_label7", "Pace")
  end)
  o.im.Subscribe("bnd_default_label8", function()
    o.im.Publish("bnd_default_label8", "Shooting")
  end)
  o.im.Subscribe("bnd_default_label9", function()
    o.im.Publish("bnd_default_label9", "Passing")
  end)
  o.im.Subscribe("bnd_default_label10", function()
    o.im.Publish("bnd_default_label10", "Dribbling")
  end)
  o.im.Subscribe("bnd_default_label11", function()
    o.im.Publish("bnd_default_label11", "Defending")
  end)
  o.im.Subscribe("bnd_default_label12", function()
    o.im.Publish("bnd_default_label12", "Physical")
  end)
  o.im.Subscribe("bnd_default_label13", function()
    o.im.Publish("bnd_default_label13", "PlayStyles")
  end)
  o.im.Subscribe("bnd_default_player_name", function()
    o.im.Publish("bnd_default_player_name", "N/A")
  end)
  o.im.Subscribe("bnd_default_player_position", function()
    o.im.Publish("bnd_default_player_position", "N/A")
  end)
  o.im.Subscribe("bnd_default_player_rating", function()
    o.im.Publish("bnd_default_player_rating", "99")
  end)
  o.im.Subscribe("bnd_default_player_fitness", function()
    o.im.Publish("bnd_default_player_fitness", "0 %")
  end)
  o.im.Subscribe("bnd_default_player_sharpness", function()
    o.im.Publish("bnd_default_player_sharpness", "0")
  end)
  o.im.Subscribe("bnd_active_player_rating", function() end)
  o.im.Subscribe("bnd_passive_player_rating", function() end)
  o.im.Subscribe("bnd_active_player_avatar", function() end)
  o.im.Subscribe("bnd_active_player_flags", function() end)
  o.im.Subscribe("bnd_passive_player_avatar", function() end)
  o.im.Subscribe("bnd_divider_swap", function() end)
  o.im.Subscribe("bnd_vertical_swap", function() end)
  o.im.Subscribe("bnd_rectangle_swap", function() end)
  o.im.Subscribe("bnd_swap1_active", function() end)
  o.im.Subscribe("bnd_swap2_active", function() end)
  o.im.Subscribe("bnd_swap3_active", function() end)
  o.im.Subscribe("bnd_swap1_passive", function() end)
  o.im.Subscribe("bnd_swap2_passive", function() end)
  o.im.Subscribe("bnd_swap3_passive", function() end)
  o.im.Subscribe("bnd_active_player_name", function() end)
  o.im.Subscribe("bnd_active_player_number", function() end)
  o.im.Subscribe("bnd_passive_player_name", function() end)
  o.im.Subscribe("bnd_active_player_nations", function() end)
  o.im.Subscribe("bnd_passive_player_nations", function() end)
  o.im.Subscribe("bnd_active_player_playstyles", function() end)
  o.im.Subscribe("bnd_active_player_role", function() end)
  o.im.Subscribe("bnd_active_player_focus", function() end)
  o.im.Subscribe("bnd_player_sharpness", function() end)
  o.im.Subscribe("bnd_player_sharpness_icons", function() end)
  o.im.Subscribe("bnd_player_sharpness_color", function() end)
  o.im.Subscribe("bnd_player_fitness", function() end)
  o.im.Subscribe("bnd_player_fitness_color", function() end)
  o.im.Subscribe("bnd_player_fitness_icons", function() end)
  o.im.Subscribe("bnd_active_player_fitness", function() end)
  o.im.Subscribe("bnd_active_player_fitness_color", function() end)
  o.im.Subscribe("bnd_active_player_fitness_icon", function() end)
  o.im.Subscribe("bnd_passive_player_fitness", function() end)
  o.im.Subscribe("bnd_passive_player_fitness_color", function() end)
  o.im.Subscribe("bnd_passive_player_fitness_icon", function() end)
  o.im.Subscribe("bnd_active_player_position", function() end)
  o.im.Subscribe("bnd_active_player_positioning", function() end)
  o.im.Subscribe("bnd_passive_player_position", function() end)
  o.im.Subscribe("bnd_swap_notification", function() end)
  o.im.Subscribe("bnd_swap_info", function() end)
  o.im.Subscribe("bnd_swap_label1", function() end)
  o.im.Subscribe("bnd_swap_label2", function() end)
  o.im.Subscribe("bnd_swap_label3", function() end)
  o.im.Subscribe("bnd_swap_label4", function() end)
  o.im.Subscribe("bnd_swap_label5", function() end)
  o.im.Subscribe("bnd_swap_label6", function() end)
  o.im.Subscribe("bnd_swap_label7", function() end)
  o.im.Subscribe("bnd_swap_label8", function() end)
  o.im.Subscribe("bnd_swap_label9", function() end)
  o.im.Subscribe("bnd_swap_label10", function() end)
  o.im.Subscribe("bnd_swap_label11", function() end)
  o.im.Subscribe("bnd_swap_label12", function() end)
  o.im.Subscribe("bnd_swap_label13", function() end)
  o.im.Subscribe("bnd_swap_label14", function() end)
  o.im.Subscribe("bnd_swap_label15", function() end)
  o.im.Subscribe(BND_ACTIVE_PLAYER_VISIBLE, function() end)
  o.im.Subscribe(BND_PASSIVE_PLAYER_VISIBLE, function() end)

    o.im.RegisterAction(ACT_ITEM_SHOW_BIO, function(actionName, uniqueID)
        o:showBio(uniqueID.groupID)
    end)

    o.im.RegisterAction(ACT_SWAP_PLAYERS, function(actionName, data)
        o:swapPlayersByIndex(data.activeIndex, data.passiveIndex)
        o:checkSquadEligibility()
    end)

    o.im.RegisterAction(ACT_COMPARE_PLAYERS, function(actionName, data)
        o:comparePlayers(data.activePlayer, data.passivePlayer)
    end)

    o.im.RegisterAction(ACT_SEND_ITEM_DATA, function(actionName, data)
        o:_compareData(data)
    end)
    for i = 1, 6 do
        o.im.Subscribe(BND_ACTIVE_STAT_COLOR_PREFIX..i, function() end)
        o.im.Subscribe(BND_PASSIVE_STAT_COLOR_PREFIX..i, function() end)
    end
    for i = 1, 6 do
        o.im.Subscribe(BND_ACTIVE_STAT_PREFIX..i, function() end)
        o.im.Subscribe(BND_PASSIVE_STAT_PREFIX..i, function() end)
    end
    o:clearHelp()
    return o
end

function TeamManagementModel:clearHelp()
  if newSession == "yes" then
    newSession = "no"
  end
end

function TeamManagementModel:getCurrentLeague()
    if not GLOBAL_CURRENT_OPPONENT_TEAM_ID then return 0 end
    
    local countryService = self.api("CountryService")
    local teamService = self.api("TeamService")
    
    if countryService and teamService then
        local countries = countryService.GetIDs() or {}
        
        for _, country in ipairs(countries) do
            if type(country) == "table" and country.id then
                local leagues = countryService.GetLeaguesIDsByCountry(country.id) or {}
                
                for _, leagueID in ipairs(leagues) do
                    local teams = teamService.GetTeams(leagueID, 0, 0, false) or {}
                    
                    for _, team in ipairs(teams) do
                        if team.id == GLOBAL_CURRENT_OPPONENT_TEAM_ID then
                            print("[SUCCESS] Equipo encontrado en liga: " .. leagueID)
                            return leagueID
                        end
                    end
                end
            end
        end
    end
    
    return 0
end

function TeamManagementModel:_compareData(itemData)
    local UUID_UPPER_INDEX = 1
    local UUID_LOWER_INDEX = 2
    local CARD_TYPE_INDEX = 3
    local CARD_ID_INDEX = 4
    local POSITION_ID = 5
    local itemIds = {}
    local currentItemIndex = -1
    if self.players ~= nil then
        for i, playersList in ipairs(self.players) do
            table.insert(itemIds, {
                UUID_LOWER = playersList.UUID_LOWER,
                UUID_UPPER = playersList.UUID_UPPER,
                CARD_TYPE = playersList.CARD_TYPE,
                CARD_ID = playersList.CARD_ID,
                POS_IN_SQUAD = playersList.id
            })
        end
    end
    if self.manager ~= nil then
        table.insert(itemIds, {
            UUID_LOWER = self.manager.UUID_LOWER,
            UUID_UPPER = self.manager.UUID_UPPER,
            CARD_TYPE = self.manager.CARD_TYPE,
            CARD_ID = self.manager.CARD_ID,
            POS_IN_SQUAD = MANAGER_POSITION_INDEX
        })
    end
    currentItemIndex = itemData[POSITION_ID] - 1
    quickSellItemFunc = {
        quickSellItem = function(positionIndex)
            self:quickSellItem(positionIndex)
        end
    }
    swapWithClubFunc = {
        swapWithClub = function(positionIndex)
            self:swapWithClub(positionIndex)
        end
    }
    hideItemContextCallbackFunc = {
        hideItemContextCallback = function()
            self.im.Publish(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE, false)
        end
    }
    self.im.Publish(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE, true)
    self.nav.Event(nil, "evt_show_item_context", {
        itemIdList = itemIds,
        itemIndex = currentItemIndex,
        isSquad = true,
        squadId = self.squad.id,
        quickSellItemFunc = quickSellItemFunc,
        swapWithClubFunc = swapWithClubFunc,
        hideItemContextCallbackFunc = hideItemContextCallbackFunc
    })
end
function TeamManagementModel:_getStatColor(statValue)
    statValue = statValue or 0
    print(string.format("Getting color for stat value: %d", statValue))
    
    if statValue < 50 then
        return COLOR_DEFAULT
    elseif statValue >= 50 and statValue < 70 then
        return COLOR_RED
    elseif statValue >= 70 and statValue < 81 then
        return COLOR_ORANGE
    else
        return COLOR_GREEN
    end
end

function TeamManagementModel:getPlayers(teamID)
  print("[TeamManagementModel]: getPlayers()")
  local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
  do
    do
      for _FORV_6_, _FORV_7_ in ipairs(players) do
        _FORV_7_.id = _FORV_6_ - 1
        _FORV_7_.type = ItemModel.TYPE_FIELD_PLAYER
        
        _FORV_7_.level = self.models.ItemModel:getItemLevelByRating(_FORV_7_.rating)
      end
    end
  end
  return players
end

function TeamManagementModel:checkSquadEligibility()
    print("[TeamManagementModel]: checkSquadEligibility()")
    
    if not self.players or #self.players == 0 then
        print("[TeamManagementModel]: No players available for eligibility check")
        self.eligibleSquad = 0
        SquadElig = self.eligibleSquad
        self:_publishEligibleSquad()
        return
    end

    local hasSuspendedPlayer = false
    for i = 1, math.min(18, #self.players) do
        local player = self.players[i]
        if player and player.playerName then
            if isSuspended[player.playerName] == 1 then
                print("[TeamManagementModel]: Found suspended player " .. player.playerName .. " at index " .. i)
                hasSuspendedPlayer = true
                break
            end
        else
            print("[TeamManagementModel]: Warning: Invalid player data at index " .. i)
        end
    end

    self.eligibleSquad = hasSuspendedPlayer and 1 or 0
    SquadElig = self.eligibleSquad
    print("[TeamManagementModel]: Squad eligibility status: " .. self.eligibleSquad)
    self:_publishEligibleSquad()
end

function TeamManagementModel:_publishEligibleSquad()
    print("[TeamManagementModel]: _publishEligibleSquad() - Status: " .. self.eligibleSquad)
    self.im.Publish(ELIGIBLE_SQUAD_BINDING, {
        eligibleSquad = self.eligibleSquad,
        teamID = self.teamID,
        timestamp = os.time()
    })
end

function TeamManagementModel:comparePlayers(activePlayer, passivePlayer)
    self:clearPlayerVisibility()
    if activePlayer or passivePlayer then
    local nationsNames = {
    [1] = "Albania",
    [2] = "Andorra",
    [3] = "Armenia",
    [4] = "Austria",
    [5] = "Azerbaijan",
    [6] = "Belarus",
    [7] = "Belgium",
    [8] = "Bosnia",
    [9] = "Bulgaria",
    [10] = "Croatia",
    [11] = "Cyprus",
    [12] = "Czech Republic",
    [13] = "Denmark",
    [14] = "England",
    [15] = "Montenegro",
    [16] = "Faroe Islands",
    [17] = "Finland",
    [18] = "France",
    [19] = "FYR Macedonia",
    [20] = "Georgia",
    [21] = "Germany",
    [22] = "Greece",
    [23] = "Hungary",
    [24] = "Iceland",
    [25] = "Republic of Ireland",
    [26] = "Israel",
    [27] = "Italy",
    [28] = "Latvia",
    [29] = "Liechtenstein",
    [30] = "Lithuania",
    [31] = "Luxembourg",
    [32] = "Malta",
    [33] = "Moldova",
    [34] = "Netherlands",
    [35] = "Northern Ireland",
    [36] = "Norway",
    [37] = "Poland",
    [38] = "Portugal",
    [39] = "Romania",
    [40] = "Russia",
    [41] = "San Marino",
    [42] = "Scotland",
    [43] = "Slovakia",
    [44] = "Slovenia",
    [45] = "Spain",
    [46] = "Sweden",
    [47] = "Switzerland",
    [48] = "Turkey",
    [49] = "Ukraine",
    [50] = "Wales",
    [51] = "Serbia",
    [52] = "Argentina",
    [53] = "Bolivia",
    [54] = "Brazil",
    [55] = "Chile",
    [56] = "Colombia",
    [57] = "Ecuador",
    [58] = "Paraguay",
    [59] = "Peru",
    [60] = "Uruguay",
    [61] = "Venezuela",
    [62] = "Anguilla",
    [63] = "Antigua and Barbuda",
    [64] = "Aruba",
    [65] = "Bahamas",
    [66] = "Barbados",
    [67] = "Belize",
    [68] = "Bermuda",
    [69] = "British Virgin Islands",
    [70] = "Canada",
    [71] = "Cayman Islands",
    [72] = "Costa Rica",
    [73] = "Cuba",
    [74] = "Dominica",
    [75] = "International",
    [76] = "El Salvador",
    [77] = "Grenada",
    [78] = "Guatemala",
    [79] = "Guyana",
    [80] = "Haiti",
    [81] = "Honduras",
    [82] = "Jamaica",
    [83] = "Mexico",
    [84] = "Montserrat",
    [85] = "Curaçao",
    [86] = "Nicaragua",
    [87] = "Panama",
    [88] = "Puerto Rico",
    [89] = "St. Kitts and Nevis",
    [90] = "St. Lucia",
    [91] = "St. Vincent and the Grenadines",
    [92] = "Suriname",
    [93] = "Trinidad and Tobago",
    [94] = "Turks and Caicos Islands",
    [95] = "United States",
    [96] = "US Virgin Islands",
    [97] = "Algeria",
    [98] = "Angola",
    [99] = "Benin",
   [100] = "Botswana",
   [101] = "Burkina Faso",
   [102] = "Burundi",
   [103] = "Cameroon",
   [104] = "Cape Verde",
   [105] = "Central African Republic",
   [106] = "Chad",
   [107] = "Congo",
   [108] = "Côte d'Ivoire",
   [109] = "Djibouti",
   [110] = "Congo DR",
   [111] = "Egypt",
   [112] = "Equatorial Guinea",
   [113] = "Eritrea",
   [114] = "Ethiopia",
   [115] = "Gabon",
   [116] = "Gambia",
   [117] = "Ghana",
   [118] = "Guinea",
   [119] = "Guinea-Bissau",
   [120] = "Kenya",
   [121] = "Lesotho",
   [122] = "Liberia",
   [123] = "Libya",
   [124] = "Madagascar",
   [125] = "Malawi",
   [126] = "Mali",
   [127] = "Mauritania",
   [128] = "Mauritius",
   [129] = "Morocco",
   [130] = "Mozambique",
   [131] = "Namibia",
   [132] = "Niger",
   [133] = "Nigeria",
   [134] = "Rwanda",
   [135] = "São Tomé e Príncipe",
   [136] = "Senegal",
   [137] = "Seychelles",
   [138] = "Sierra Leone",
   [139] = "Somalia",
   [140] = "South Africa",
   [141] = "Sudan",
   [142] = "Swaziland",
   [143] = "Tanzania",
   [144] = "Togo",
   [145] = "Tunisia",
   [146] = "Uganda",
   [147] = "Zambia",
   [148] = "Zimbabwe",
   [149] = "Afghanistan",
   [150] = "Bahrain",
   [151] = "Bangladesh",
   [152] = "Bhutan",
   [153] = "Brunei Darussalam",
   [154] = "Cambodia",
   [155] = "China PR",
   [157] = "Guam",
   [158] = "Hong Kong",
   [159] = "India",
   [160] = "Indonesia",
   [161] = "Iran",
   [162] = "Iraq",
   [163] = "Japan",
   [164] = "Jordan",
   [165] = "Kazakhstan",
   [166] = "Korea DPR",
   [167] = "Korea Republic",
   [168] = "Kuwait",
   [169] = "Kyrgyzstan",
   [170] = "Laos",
   [171] = "Lebanon",
   [172] = "Macau",
   [173] = "Malaysia",
   [174] = "Maldives",
   [175] = "Mongolia",
   [176] = "Myanmar",
   [177] = "Nepal",
   [178] = "Oman",
   [179] = "Pakistan",
   [180] = "Palestine",
   [181] = "Philippines",
   [182] = "Qatar",
   [183] = "Saudi Arabia",
   [184] = "Singapore",
   [185] = "Sri Lanka",
   [186] = "Syria",
   [187] = "Tajikistan",
   [188] = "Thailand",
   [189] = "Turkmenistan",
   [190] = "UAE",
   [191] = "Uzbekistan",
   [192] = "Vietnam",
   [193] = "Yemen",
   [194] = "American Samoa",
   [195] = "Australia",
   [196] = "Cook Islands",
   [197] = "Fiji",
   [198] = "New Zealand",
   [199] = "Papua New Guinea",
   [200] = "Samoa",
   [201] = "Solomon Islands",
   [202] = "Tahiti",
   [203] = "Tonga",
   [204] = "Vanuatu",
   [205] = "Gibraltar",
   [206] = "Greenland",
   [207] = "Dominican Republic",
   [208] = "Estonia",
   [211] = "Rest of World",
   [212] = "Timor-Leste",
   [213] = "Chinese Taipei",
   [214] = "Comoros",
   [215] = "New Caledonia",
   [219] = "Kosovo",
   [250] = "Other",
   [249] = "World Cup",
   [222] = "International Women"
}
        if activePlayer then
        local nationsNames = {
    [1] = "Albania",
    [2] = "Andorra",
    [3] = "Armenia",
    [4] = "Austria",
    [5] = "Azerbaijan",
    [6] = "Belarus",
    [7] = "Belgium",
    [8] = "Bosnia",
    [9] = "Bulgaria",
    [10] = "Croatia",
    [11] = "Cyprus",
    [12] = "Czech Republic",
    [13] = "Denmark",
    [14] = "England",
    [15] = "Montenegro",
    [16] = "Faroe Islands",
    [17] = "Finland",
    [18] = "France",
    [19] = "FYR Macedonia",
    [20] = "Georgia",
    [21] = "Germany",
    [22] = "Greece",
    [23] = "Hungary",
    [24] = "Iceland",
    [25] = "Republic of Ireland",
    [26] = "Israel",
    [27] = "Italy",
    [28] = "Latvia",
    [29] = "Liechtenstein",
    [30] = "Lithuania",
    [31] = "Luxembourg",
    [32] = "Malta",
    [33] = "Moldova",
    [34] = "Netherlands",
    [35] = "Northern Ireland",
    [36] = "Norway",
    [37] = "Poland",
    [38] = "Portugal",
    [39] = "Romania",
    [40] = "Russia",
    [41] = "San Marino",
    [42] = "Scotland",
    [43] = "Slovakia",
    [44] = "Slovenia",
    [45] = "Spain",
    [46] = "Sweden",
    [47] = "Switzerland",
    [48] = "Turkey",
    [49] = "Ukraine",
    [50] = "Wales",
    [51] = "Serbia",
    [52] = "Argentina",
    [53] = "Bolivia",
    [54] = "Brazil",
    [55] = "Chile",
    [56] = "Colombia",
    [57] = "Ecuador",
    [58] = "Paraguay",
    [59] = "Peru",
    [60] = "Uruguay",
    [61] = "Venezuela",
    [62] = "Anguilla",
    [63] = "Antigua and Barbuda",
    [64] = "Aruba",
    [65] = "Bahamas",
    [66] = "Barbados",
    [67] = "Belize",
    [68] = "Bermuda",
    [69] = "British Virgin Islands",
    [70] = "Canada",
    [71] = "Cayman Islands",
    [72] = "Costa Rica",
    [73] = "Cuba",
    [74] = "Dominica",
    [75] = "International",
    [76] = "El Salvador",
    [77] = "Grenada",
    [78] = "Guatemala",
    [79] = "Guyana",
    [80] = "Haiti",
    [81] = "Honduras",
    [82] = "Jamaica",
    [83] = "Mexico",
    [84] = "Montserrat",
    [85] = "Curaçao",
    [86] = "Nicaragua",
    [87] = "Panama",
    [88] = "Puerto Rico",
    [89] = "St. Kitts and Nevis",
    [90] = "St. Lucia",
    [91] = "St. Vincent and the Grenadines",
    [92] = "Suriname",
    [93] = "Trinidad and Tobago",
    [94] = "Turks and Caicos Islands",
    [95] = "United States",
    [96] = "US Virgin Islands",
    [97] = "Algeria",
    [98] = "Angola",
    [99] = "Benin",
   [100] = "Botswana",
   [101] = "Burkina Faso",
   [102] = "Burundi",
   [103] = "Cameroon",
   [104] = "Cape Verde",
   [105] = "Central African Republic",
   [106] = "Chad",
   [107] = "Congo",
   [108] = "Côte d'Ivoire",
   [109] = "Djibouti",
   [110] = "Congo DR",
   [111] = "Egypt",
   [112] = "Equatorial Guinea",
   [113] = "Eritrea",
   [114] = "Ethiopia",
   [115] = "Gabon",
   [116] = "Gambia",
   [117] = "Ghana",
   [118] = "Guinea",
   [119] = "Guinea-Bissau",
   [120] = "Kenya",
   [121] = "Lesotho",
   [122] = "Liberia",
   [123] = "Libya",
   [124] = "Madagascar",
   [125] = "Malawi",
   [126] = "Mali",
   [127] = "Mauritania",
   [128] = "Mauritius",
   [129] = "Morocco",
   [130] = "Mozambique",
   [131] = "Namibia",
   [132] = "Niger",
   [133] = "Nigeria",
   [134] = "Rwanda",
   [135] = "São Tomé e Príncipe",
   [136] = "Senegal",
   [137] = "Seychelles",
   [138] = "Sierra Leone",
   [139] = "Somalia",
   [140] = "South Africa",
   [141] = "Sudan",
   [142] = "Swaziland",
   [143] = "Tanzania",
   [144] = "Togo",
   [145] = "Tunisia",
   [146] = "Uganda",
   [147] = "Zambia",
   [148] = "Zimbabwe",
   [149] = "Afghanistan",
   [150] = "Bahrain",
   [151] = "Bangladesh",
   [152] = "Bhutan",
   [153] = "Brunei Darussalam",
   [154] = "Cambodia",
   [155] = "China PR",
   [157] = "Guam",
   [158] = "Hong Kong",
   [159] = "India",
   [160] = "Indonesia",
   [161] = "Iran",
   [162] = "Iraq",
   [163] = "Japan",
   [164] = "Jordan",
   [165] = "Kazakhstan",
   [166] = "Korea DPR",
   [167] = "Korea Republic",
   [168] = "Kuwait",
   [169] = "Kyrgyzstan",
   [170] = "Laos",
   [171] = "Lebanon",
   [172] = "Macau",
   [173] = "Malaysia",
   [174] = "Maldives",
   [175] = "Mongolia",
   [176] = "Myanmar",
   [177] = "Nepal",
   [178] = "Oman",
   [179] = "Pakistan",
   [180] = "Palestine",
   [181] = "Philippines",
   [182] = "Qatar",
   [183] = "Saudi Arabia",
   [184] = "Singapore",
   [185] = "Sri Lanka",
   [186] = "Syria",
   [187] = "Tajikistan",
   [188] = "Thailand",
   [189] = "Turkmenistan",
   [190] = "UAE",
   [191] = "Uzbekistan",
   [192] = "Vietnam",
   [193] = "Yemen",
   [194] = "American Samoa",
   [195] = "Australia",
   [196] = "Cook Islands",
   [197] = "Fiji",
   [198] = "New Zealand",
   [199] = "Papua New Guinea",
   [200] = "Samoa",
   [201] = "Solomon Islands",
   [202] = "Tahiti",
   [203] = "Tonga",
   [204] = "Vanuatu",
   [205] = "Gibraltar",
   [206] = "Greenland",
   [207] = "Dominican Republic",
   [208] = "Estonia",
   [211] = "Rest of World",
   [212] = "Timor-Leste",
   [213] = "Chinese Taipei",
   [214] = "Comoros",
   [215] = "New Caledonia",
   [219] = "Kosovo",
   [250] = "Other",
   [249] = "World Cup",
   [222] = "International Women"
}       
 local function getActiveFitness(activePlayer)   
    if activePlayer.position == "GK" then
        if activePlayer.rating >= 99 then
            return "70"
        elseif activePlayer.rating >= 95 then
            return "45"
        elseif activePlayer.rating >= 90 then
            return "80"
        elseif activePlayer.rating >= 85 then
            return "89"
        elseif activePlayer.rating >= 80 then
            return "94"
        elseif activePlayer.rating >= 75 then
            return "25"
        elseif activePlayer.rating >= 70 then
            return "55"
        elseif activePlayer.rating >= 65 then
            return "35"
        else
            return "100"
        end

    elseif activePlayer.position == "CB" then
        if activePlayer.rating >= 99 then
            return "53"
        elseif activePlayer.rating >= 95 then
            return "85"
        elseif activePlayer.rating >= 90 then
            return "73"
        elseif activePlayer.rating >= 85 then
            return "91"
        elseif activePlayer.rating >= 80 then
            return "45"
        elseif activePlayer.rating >= 75 then
            return "59"
        elseif activePlayer.rating >= 70 then
            return "64"
        elseif activePlayer.rating >= 65 then
            return "77"
        else
            return "100"
        end

    elseif activePlayer.position == "RB" or activePlayer.position == "LB" then
        if activePlayer.rating >= 99 then
            return "66"
        elseif activePlayer.rating >= 95 then
            return "98"
        elseif activePlayer.rating >= 90 then
            return "99"
        elseif activePlayer.rating >= 85 then
            return "58"
        elseif activePlayer.rating >= 80 then
            return "69"
        elseif activePlayer.rating >= 75 then
            return "52"
        elseif activePlayer.rating >= 70 then
            return "96"
        elseif activePlayer.rating >= 65 then
            return "40"
        else
            return "100"
        end

    elseif activePlayer.position == "RWB" or activePlayer.position == "LWB" then
        if activePlayer.rating >= 99 then
            return "37"
        elseif activePlayer.rating >= 95 then
            return "33"
        elseif activePlayer.rating >= 90 then
            return "64"
        elseif activePlayer.rating >= 85 then
            return "30"
        elseif activePlayer.rating >= 80 then
            return "79"
        elseif activePlayer.rating >= 75 then
            return "57"
        elseif activePlayer.rating >= 70 then
            return "82"
        elseif activePlayer.rating >= 65 then
            return "77"
        else
            return "100"
        end

    elseif activePlayer.position == "CM" then
        if activePlayer.rating >= 99 then
            return "27"
        elseif activePlayer.rating >= 95 then
            return "76"
        elseif activePlayer.rating >= 90 then
            return "83"
        elseif activePlayer.rating >= 85 then
            return "69"
        elseif activePlayer.rating >= 80 then
            return "73"
        elseif activePlayer.rating >= 75 then
            return "76"
        elseif activePlayer.rating >= 70 then
            return "55"
        elseif activePlayer.rating >= 65 then
            return "86"
        else
            return "100"
        end
        
    elseif activePlayer.position == "CDM" then
        if activePlayer.rating >= 99 then
            return "20"
        elseif activePlayer.rating >= 95 then
            return "46"
        elseif activePlayer.rating >= 90 then
            return "89"
        elseif activePlayer.rating >= 85 then
            return "72"
        elseif activePlayer.rating >= 80 then
            return "90"
        elseif activePlayer.rating >= 75 then
            return "33"
        elseif activePlayer.rating >= 70 then
            return "77"
        elseif activePlayer.rating >= 65 then
            return "43"
        else
            return "100"
        end
        
     elseif activePlayer.position == "CAM" then
        if activePlayer.rating >= 99 then
            return "66"
        elseif activePlayer.rating >= 95 then
            return "54"
        elseif activePlayer.rating >= 90 then
            return "79"
        elseif activePlayer.rating >= 85 then
            return "95"
        elseif activePlayer.rating >= 80 then
            return "74"
        elseif activePlayer.rating >= 75 then
            return "88"
        elseif activePlayer.rating >= 70 then
            return "80"
        elseif activePlayer.rating >= 65 then
            return "64"
        else
            return "100"
        end
        
    elseif activePlayer.position == "LM" or activePlayer.position == "RM" then
        if activePlayer.rating >= 99 then
            return "73"
        elseif activePlayer.rating >= 95 then
            return "70"
        elseif activePlayer.rating >= 90 then
            return "66"
        elseif activePlayer.rating >= 85 then
            return "53"
        elseif activePlayer.rating >= 80 then
            return "51"
        elseif activePlayer.rating >= 75 then
            return "49"
        elseif activePlayer.rating >= 70 then
            return "69"
        elseif activePlayer.rating >= 65 then
            return "60"
        else
            return "100"
        end
        
    elseif activePlayer.position == "RW"  then
        if activePlayer.rating >= 99 then
            return "76"
        elseif activePlayer.rating >= 95 then
            return "72"
        elseif activePlayer.rating >= 90 then
            return "83"
        elseif activePlayer.rating >= 85 then
            return "68"
        elseif activePlayer.rating >= 80 then
            return "59"
        elseif activePlayer.rating >= 75 then
            return "75"
        elseif activePlayer.rating >= 70 then
            return "78"
        elseif activePlayer.rating >= 65 then
            return "32"
        else
            return "100"
        end
        
    elseif activePlayer.position == "LW"  then
        if activePlayer.rating >= 99 then
            return "57"
        elseif activePlayer.rating >= 95 then
            return "84"
        elseif activePlayer.rating >= 90 then
            return "48"
        elseif activePlayer.rating >= 85 then
            return "59"
        elseif activePlayer.rating >= 80 then
            return "94"
        elseif activePlayer.rating >= 75 then
            return "90"
        elseif activePlayer.rating >= 70 then
            return "76"
        elseif activePlayer.rating >= 65 then
            return "65"
        else
            return "100"
        end
        
    elseif activePlayer.position == "CF" or activePlayer.position == "ST" then
        if activePlayer.rating >= 99 then
            return "32"
        elseif activePlayer.rating >= 95 then
            return "75"
        elseif activePlayer.rating >= 90 then
            return "79"
        elseif activePlayer.rating >= 85 then
            return "81"
        elseif activePlayer.rating >= 80 then
            return "78"
        elseif activePlayer.rating >= 75 then
            return "64"
        elseif activePlayer.rating >= 70 then
            return "62"
        elseif activePlayer.rating >= 65 then
            return "56"
        else
            return "100"
        end
    end
end

local function getActiveFitnes(activePlayer)   
    if activePlayer.position == "GK" then
        if activePlayer.rating >= 99 then
            return "70 %"
        elseif activePlayer.rating >= 95 then
            return "45 %"
        elseif activePlayer.rating >= 90 then
            return "80 %"
        elseif activePlayer.rating >= 85 then
            return "89 %"
        elseif activePlayer.rating >= 80 then
            return "94 %"
        elseif activePlayer.rating >= 75 then
            return "25 %"
        elseif activePlayer.rating >= 70 then
            return "55 %"
        elseif activePlayer.rating >= 65 then
            return "35 %"
        else
            return "100 %"
        end

    elseif activePlayer.position == "CB" then
        if activePlayer.rating >= 99 then
            return "53 %"
        elseif activePlayer.rating >= 95 then
            return "85 %"
        elseif activePlayer.rating >= 90 then
            return "73 %"
        elseif activePlayer.rating >= 85 then
            return "91 %"
        elseif activePlayer.rating >= 80 then
            return "45 %"
        elseif activePlayer.rating >= 75 then
            return "59 %"
        elseif activePlayer.rating >= 70 then
            return "64 %"
        elseif activePlayer.rating >= 65 then
            return "77 %"
        else
            return "100 %"
        end

    elseif activePlayer.position == "RB" or activePlayer.position == "LB" then
        if activePlayer.rating >= 99 then
            return "66 %"
        elseif activePlayer.rating >= 95 then
            return "98 %"
        elseif activePlayer.rating >= 90 then
            return "99 %"
        elseif activePlayer.rating >= 85 then
            return "58 %"
        elseif activePlayer.rating >= 80 then
            return "69 %"
        elseif activePlayer.rating >= 75 then
            return "52 %"
        elseif activePlayer.rating >= 70 then
            return "96 %"
        elseif activePlayer.rating >= 65 then
            return "40 %"
        else
            return "100 %"
        end

    elseif activePlayer.position == "RWB" or activePlayer.position == "LWB" then
        if activePlayer.rating >= 99 then
            return "37 %"
        elseif activePlayer.rating >= 95 then
            return "33 %"
        elseif activePlayer.rating >= 90 then
            return "64 %"
        elseif activePlayer.rating >= 85 then
            return "30 %"
        elseif activePlayer.rating >= 80 then
            return "79 %"
        elseif activePlayer.rating >= 75 then
            return "57 %"
        elseif activePlayer.rating >= 70 then
            return "82 %"
        elseif activePlayer.rating >= 65 then
            return "77 %"
        else
            return "100 %"
        end

    elseif activePlayer.position == "CM" then
        if activePlayer.rating >= 99 then
            return "27 %"
        elseif activePlayer.rating >= 95 then
            return "76 %"
        elseif activePlayer.rating >= 90 then
            return "83 %"
        elseif activePlayer.rating >= 85 then
            return "69 %"
        elseif activePlayer.rating >= 80 then
            return "73 %"
        elseif activePlayer.rating >= 75 then
            return "76 %"
        elseif activePlayer.rating >= 70 then
            return "55 %"
        elseif activePlayer.rating >= 65 then
            return "86 %"
        else
            return "100 %"
        end
        
    elseif activePlayer.position == "CDM" then
        if activePlayer.rating >= 99 then
            return "20 %"
        elseif activePlayer.rating >= 95 then
            return "46 %"
        elseif activePlayer.rating >= 90 then
            return "89 %"
        elseif activePlayer.rating >= 85 then
            return "72 %"
        elseif activePlayer.rating >= 80 then
            return "90 %"
        elseif activePlayer.rating >= 75 then
            return "33 %"
        elseif activePlayer.rating >= 70 then
            return "77 %"
        elseif activePlayer.rating >= 65 then
            return "43 %"
        else
            return "100 %"
        end
        
     elseif activePlayer.position == "CAM" then
        if activePlayer.rating >= 99 then
            return "66 %"
        elseif activePlayer.rating >= 95 then
            return "54 %"
        elseif activePlayer.rating >= 90 then
            return "79 %"
        elseif activePlayer.rating >= 85 then
            return "95 %"
        elseif activePlayer.rating >= 80 then
            return "74 %"
        elseif activePlayer.rating >= 75 then
            return "88 %"
        elseif activePlayer.rating >= 70 then
            return "80 %"
        elseif activePlayer.rating >= 65 then
            return "64 %"
        else
            return "100 %"
        end
        
    elseif activePlayer.position == "LM" or activePlayer.position == "RM" then
        if activePlayer.rating >= 99 then
            return "73 %"
        elseif activePlayer.rating >= 95 then
            return "70 %"
        elseif activePlayer.rating >= 90 then
            return "66 %"
        elseif activePlayer.rating >= 85 then
            return "53 %"
        elseif activePlayer.rating >= 80 then
            return "51 %"
        elseif activePlayer.rating >= 75 then
            return "49 %"
        elseif activePlayer.rating >= 70 then
            return "69 %"
        elseif activePlayer.rating >= 65 then
            return "60 %"
        else
            return "100 %"
        end
        
    elseif activePlayer.position == "RW"  then
        if activePlayer.rating >= 99 then
            return "76 %"
        elseif activePlayer.rating >= 95 then
            return "72 %"
        elseif activePlayer.rating >= 90 then
            return "83 %"
        elseif activePlayer.rating >= 85 then
            return "68 %"
        elseif activePlayer.rating >= 80 then
            return "59 %"
        elseif activePlayer.rating >= 75 then
            return "75 %"
        elseif activePlayer.rating >= 70 then
            return "78 %"
        elseif activePlayer.rating >= 65 then
            return "32 %"
        else
            return "100 %"
        end
        
    elseif activePlayer.position == "LW"  then
        if activePlayer.rating >= 99 then
            return "57 %"
        elseif activePlayer.rating >= 95 then
            return "84 %"
        elseif activePlayer.rating >= 90 then
            return "48 %"
        elseif activePlayer.rating >= 85 then
            return "59 %"
        elseif activePlayer.rating >= 80 then
            return "94 %"
        elseif activePlayer.rating >= 75 then
            return "90 %"
        elseif activePlayer.rating >= 70 then
            return "76 %"
        elseif activePlayer.rating >= 65 then
            return "65 %"
        else
            return "100 %"
        end
        
    elseif activePlayer.position == "CF" or activePlayer.position == "ST" then
        if activePlayer.rating >= 99 then
            return "32 %"
        elseif activePlayer.rating >= 95 then
            return "75 %"
        elseif activePlayer.rating >= 90 then
            return "79 %"
        elseif activePlayer.rating >= 85 then
            return "81 %"
        elseif activePlayer.rating >= 80 then
            return "78 %"
        elseif activePlayer.rating >= 75 then
            return "64 %"
        elseif activePlayer.rating >= 70 then
            return "62 %"
        elseif activePlayer.rating >= 65 then
            return "56 %"
        else
            return "100 %"
        end
    end
end
  
local function getActiveFocus(activePlayer)   
    if activePlayer.position == "GK" then
        if activePlayer.rating >= 99 then
            return "Refleks"
        elseif activePlayer.rating >= 95 then
            return "Holding"
        elseif activePlayer.rating >= 90 then
            return "Build-Up"
        elseif activePlayer.rating >= 85 then
            return "Build-Up"
        elseif activePlayer.rating >= 80 then
            return "Penalty"
        elseif activePlayer.rating >= 75 then
            return "Sweeper"
        elseif activePlayer.rating >= 70 then
            return "Build Up"
        elseif activePlayer.rating >= 65 then
            return "Refleks"
        else
            return "Sweeper"
        end

    elseif activePlayer.position == "CB" then
        if activePlayer.rating >= 99 then
            return "Build-,Up"
        elseif activePlayer.rating >= 95 then
            return "Tackle"
        elseif activePlayer.rating >= 90 then
            return "Build-Up"
        elseif activePlayer.rating >= 85 then
            return "Pressing"
        elseif activePlayer.rating >= 80 then
            return "Defensive"
        elseif activePlayer.rating >= 75 then
            return "Block"
        elseif activePlayer.rating >= 70 then
            return "Tackle"
        elseif activePlayer.rating >= 65 then
            return "Tackle"
        else
            return "Tackle"
        end

    elseif activePlayer.position == "RB" or activePlayer.position == "LB" then
        if activePlayer.rating >= 99 then
            return "Speed"
        elseif activePlayer.rating >= 95 then
            return "Marking"
        elseif activePlayer.rating >= 90 then
            return "Tackle"
        elseif activePlayer.rating >= 85 then
            return "Sprint"
        elseif activePlayer.rating >= 80 then
            return "Marking"
        elseif activePlayer.rating >= 75 then
            return "Block"
        elseif activePlayer.rating >= 70 then
            return "Passes"
        elseif activePlayer.rating >= 65 then
            return "Speed"
        else
            return "Sprint"
        end

    elseif activePlayer.position == "RWB" or activePlayer.position == "LWB" then
        if activePlayer.rating >= 99 then
            return "Speed"
        elseif activePlayer.rating >= 95 then
            return "Marking"
        elseif activePlayer.rating >= 90 then
            return "Tackle"
        elseif activePlayer.rating >= 85 then
            return "Sprint"
        elseif activePlayer.rating >= 80 then
            return "Marking"
        elseif activePlayer.rating >= 75 then
            return "Block"
        elseif activePlayer.rating >= 70 then
            return "Passes"
        elseif activePlayer.rating >= 65 then
            return "Speed"
        else
            return "Sprint"
        end

    elseif activePlayer.position == "CM" then
        if activePlayer.rating >= 99 then
            return "Defend"
        elseif activePlayer.rating >= 95 then
            return "Passes"
        elseif activePlayer.rating >= 90 then
            return "Dribble"
        elseif activePlayer.rating >= 85 then
            return "Key Pass"
        elseif activePlayer.rating >= 80 then
            return "Controll"
        elseif activePlayer.rating >= 75 then
            return "Build-Up"
        elseif activePlayer.rating >= 70 then
            return "Passes"
        elseif activePlayer.rating >= 65 then
            return "Dribble"
        else
            return "Controll"
        end
        
    elseif activePlayer.position == "CDM" then
        if activePlayer.rating >= 99 then
            return "Defend"
        elseif activePlayer.rating >= 95 then
            return "Passes"
        elseif activePlayer.rating >= 90 then
            return "Block"
        elseif activePlayer.rating >= 85 then
            return "Tackle"
        elseif activePlayer.rating >= 80 then
            return "Controll"
        elseif activePlayer.rating >= 75 then
            return "Build-Up"
        elseif activePlayer.rating >= 70 then
            return "Pressing"
        elseif activePlayer.rating >= 65 then
            return "Dribble"
        else
            return "Pressing"
        end
        
     elseif activePlayer.position == "CAM" then
        if activePlayer.rating >= 99 then
            return "Defend"
        elseif activePlayer.rating >= 95 then
            return "Key Pass"
        elseif activePlayer.rating >= 90 then
            return "Dribble"
        elseif activePlayer.rating >= 85 then
            return "Controll"
        elseif activePlayer.rating >= 80 then
            return "Assister"
        elseif activePlayer.rating >= 75 then
            return "Build-Up"
        elseif activePlayer.rating >= 70 then
            return "Passes"
        elseif activePlayer.rating >= 65 then
            return "Dribble"
        else
            return "Controll"
        end
        
    elseif activePlayer.position == "LM" or activePlayer.position == "RM" then
        if activePlayer.rating >= 99 then
            return "Two Touch"
        elseif activePlayer.rating >= 95 then
            return "Controll"
        elseif activePlayer.rating >= 90 then
            return "Sprint"
        elseif activePlayer.rating >= 85 then
            return "Keyy"
        elseif activePlayer.rating >= 80 then
            return "Passes"
        elseif activePlayer.rating >= 75 then
            return "Marking"
        elseif activePlayer.rating >= 70 then
            return "Dribble"
        elseif activePlayer.rating >= 65 then
            return "Speed"
        else
            return "Dribble"
        end
        
    elseif activePlayer.position == "RW"  then
        if activePlayer.rating >= 99 then
            return "Two Touch"
        elseif activePlayer.rating >= 95 then
            return "Cornering"
        elseif activePlayer.rating >= 90 then
            return "Sprint"
        elseif activePlayer.rating >= 85 then
            return "Shooting"
        elseif activePlayer.rating >= 80 then
            return "Passes"
        elseif activePlayer.rating >= 75 then
            return "Assister"
        elseif activePlayer.rating >= 70 then
            return "Dribble"
        elseif activePlayer.rating >= 65 then
            return "Speed"
        else
            return "Dribble"
        end
        
    elseif activePlayer.position == "LW"  then
        if activePlayer.rating >= 99 then
            return "Two Touch"
        elseif activePlayer.rating >= 95 then
            return "Dribble"
        elseif activePlayer.rating >= 90 then
            return "Sprint"
        elseif activePlayer.rating >= 85 then
            return "Passes"
        elseif activePlayer.rating >= 80 then
            return "Heading"
        elseif activePlayer.rating >= 75 then
            return "Shooting"
        elseif activePlayer.rating >= 70 then
            return "Penalty"
        elseif activePlayer.rating >= 65 then
            return "Speed"
        else
            return "Dribble"
        end
        
    elseif activePlayer.position == "CF" or activePlayer.position == "ST" then
        if activePlayer.rating >= 99 then
            return "First Touch"
        elseif activePlayer.rating >= 95 then
            return "Dribble"
        elseif activePlayer.rating >= 90 then
            return "Sprint"
        elseif activePlayer.rating >= 85 then
            return "Controll"
        elseif activePlayer.rating >= 80 then
            return "Heading"
        elseif activePlayer.rating >= 75 then
            return "Positioning"
        elseif activePlayer.rating >= 70 then
            return "Finisher"
        elseif activePlayer.rating >= 65 then
            return "Speed"
        else
            return "Finisher"
        end
    end
end

local function getActiveSharpness(activePlayer)   
    if activePlayer.position == "GK" then
        if activePlayer.rating >= 95 then
            return "77"
        elseif activePlayer.rating >= 85 then
            return "75"
        elseif activePlayer.rating >= 75 then
            return "90"
        elseif activePlayer.rating >= 65 then
            return "60"     
        else
            return "100"
        end

    elseif activePlayer.position == "CB" then
        if activePlayer.rating >= 95 then
            return "67"
        elseif activePlayer.rating >= 85 then
            return "73"
        elseif activePlayer.rating >= 75 then
            return "86"
        elseif activePlayer.rating >= 65 then
            return "90"     
        else
            return "100"
        end

    elseif activePlayer.position == "RB" or activePlayer.position == "RWB" or activePlayer.position == "LB" or activePlayer.position == "LWB" then
        if activePlayer.rating >= 95 then
            return "66"
        elseif activePlayer.rating >= 90 then
            return "52"
        elseif activePlayer.rating >= 85 then
            return "75"
        elseif activePlayer.rating >= 80 then
            return "49"
        elseif activePlayer.rating >= 75 then
            return "99"
        elseif activePlayer.rating >= 70 then
            return "74"
        elseif activePlayer.rating >=65 then
            return "98"
        elseif activePlayer.rating >= 60 then
            return "55"
        else
            return "100"
        end

    elseif activePlayer.position == "CM" or activePlayer.position == "CDM" or activePlayer.position == "CAM" then
        if activePlayer.rating >= 95 then
            return "86"
        elseif activePlayer.rating >= 90 then
            return "92"
        elseif activePlayer.rating >= 85 then
            return "95"
        elseif activePlayer.rating >= 80 then
            return "84"
        elseif activePlayer.rating >= 75 then
            return "79"
        elseif activePlayer.rating >= 70 then
            return "58"
        elseif activePlayer.rating >=65 then
            return "70"
        elseif activePlayer.rating >= 60 then
            return "94"
        else
            return "100"
        end
        
    elseif activePlayer.position == "LM" or activePlayer.position == "RM" then
        if activePlayer.rating >= 95 then
            return "54"
        elseif activePlayer.rating >= 85 then
            return "90"
        elseif activePlayer.rating >= 75 then
            return "35"
        elseif activePlayer.rating >= 65 then
            return "43"     
        else
            return "100"
        end
        
    elseif activePlayer.position == "RW"  then
        if activePlayer.rating >= 95 then
            return "77"
        elseif activePlayer.rating >= 85 then
            return "74"
        elseif activePlayer.rating >= 75 then
            return "85"
        elseif activePlayer.rating >= 65 then
            return "54"     
        else
            return "100"
        end
        
    elseif activePlayer.position == "LW"  then
        if activePlayer.rating >= 95 then
            return "68"
        elseif activePlayer.rating >= 85 then
            return "93"
        elseif activePlayer.rating >= 75 then
            return "88"
        elseif activePlayer.rating >= 65 then
            return "80"     
        else
            return "100"
        end
        
    elseif activePlayer.position == "CF" or activePlayer.position == "ST" then
        if activePlayer.rating >= 95 then
            return "84"
        elseif activePlayer.rating >= 85 then
            return "70"
        elseif activePlayer.rating >= 75 then
            return "65"
        elseif activePlayer.rating >= 65 then
            return "83"     
        else
            return "100"
        end
    end
end
      
local function getFitnessColor(fitnessName)
    if not fitnessName then return "0xFFFFFF" end
local colors = {
    ["99"]  = "0x28992D",   ["84"]  = "0x28992D",   ["73"]  = "0xE2BA00",   ["58"]  = "0xFF9420",   ["45"]  = "0xc82727",
    ["98"]  = "0x28992D",   ["83"]  = "0x28992D",   ["72"]  = "0xE2BA00",   ["57"]  = "0xFF9420",   ["43"]  = "0xc82727",
    ["96"]  = "0x28992D",   ["82"]  = "0x28992D",   ["70"]  = "0xE2BA00",   ["56"]  = "0xFF9420",   ["40"]  = "0xc82727",
    ["95"]  = "0x28992D",   ["81"]  = "0x28992D",   ["69"]  = "0xE2BA00",   ["55"]  = "0xFF9420",   ["37"]  = "0xc82727",
    ["94"]  = "0x28992D",   ["80"]  = "0x28992D",   ["68"]  = "0xE2BA00",   ["54"]  = "0xFF9420",   ["35"]  = "0xc82727",
    ["91"]  = "0x28992D",   ["79"]  = "0x28992D",   ["66"]  = "0xE2BA00",   ["53"]  = "0xFF9420",   ["33"]  = "0xc82727",
    ["90"]  = "0x28992D",   ["78"]  = "0x28992D",   ["65"]  = "0xE2BA00",   ["52"]  = "0xFF9420",   ["32"]  = "0xc82727",
    ["89"]  = "0x28992D",   ["77"]  = "0x28992D",   ["64"]  = "0xE2BA00",   ["51"]  = "0xFF9420",   ["30"]  = "0xc82727",
    ["88"]  = "0x28992D",   ["76"]  = "0x28992D",   ["62"]  = "0xE2BA00",   ["49"]  = "0xFF9420",   ["27"]  = "0xc82727",
    ["86"]  = "0x28992D",    ["75"]  = "0xE2BA00",   ["60"]  = "0xE2BA00",   ["48"]  = "0xFF9420",   ["25"]  = "0xc82727",
    ["85"]  = "0x28992D",    ["74"]  = "0xE2BA00",   ["59"]  = "0xFF9420",   ["46"]  = "0xFF9420",   ["20"]  = "0xc82727",
}
    return colors[fitnessName] or "0xFFFFFF"
end    

local function getFitnesColor(fitnesName)
    if not fitnesName then return "0xFFFFFF" end
local colors = {
    ["99 %"]  = "0x28992D",   ["84 %"]  = "0x28992D",   ["73 %"]  = "0xE2BA00",   ["58 %"]  = "0xFF9420",   ["45 %"]  = "0xc82727",
    ["98 %"]  = "0x28992D",   ["83 %"]  = "0x28992D",   ["72 %"]  = "0xE2BA00",   ["57 %"]  = "0xFF9420",   ["43 %"]  = "0xc82727",
    ["96 %"]  = "0x28992D",   ["82 %"]  = "0x28992D",   ["70 %"]  = "0xE2BA00",   ["56 %"]  = "0xFF9420",   ["40 %"]  = "0xc82727",
    ["95 %"]  = "0x28992D",   ["81 %"]  = "0x28992D",   ["69 %"]  = "0xE2BA00",   ["55 %"]  = "0xFF9420",   ["37 %"]  = "0xc82727",
    ["94 %"]  = "0x28992D",   ["80 %"]  = "0x28992D",   ["68 %"]  = "0xE2BA00",   ["54 %"]  = "0xFF9420",   ["35 %"]  = "0xc82727",
    ["91 %"]  = "0x28992D",   ["79 %"]  = "0x28992D",   ["66 %"]  = "0xE2BA00",   ["53 %"]  = "0xFF9420",   ["33 %"]  = "0xc82727",
    ["90 %"]  = "0x28992D",   ["78 %"]  = "0x28992D",   ["65 %"]  = "0xE2BA00",   ["52 %"]  = "0xFF9420",   ["32 %"]  = "0xc82727",
    ["89 %"]  = "0x28992D",   ["77 %"]  = "0x28992D",   ["64 %"]  = "0xE2BA00",   ["51 %"]  = "0xFF9420",   ["30 %"]  = "0xc82727",
    ["88 %"]  = "0x28992D",   ["76 %"]  = "0x28992D",   ["62 %"]  = "0xE2BA00",   ["49 %"]  = "0xFF9420",   ["27 %"]  = "0xc82727",
    ["86 %"]  = "0x28992D",    ["75 %"]  = "0xE2BA00",   ["60 %"]  = "0xE2BA00",   ["48 %"]  = "0xFF9420",   ["25 %"]  = "0xc82727",
    ["85 %"]  = "0x28992D",    ["74 %"]  = "0xE2BA00",   ["59 %"]  = "0xFF9420",   ["46 %"]  = "0xFF9420",   ["20 %"]  = "0xc82727",
}
    return colors[fitnesName] or "0xFFFFFF"
end    
 
local function getSharpnessColor(sharpnessName)
    if not sharpnessName then return "0xFFFFFF" end
local colors = {
    ["99"]  = "0x28992D",   ["83"]  = "0x28992D",   ["65"]  = "0xE2BA00",   
    ["98"]  = "0x28992D",   ["80"]  = "0x28992D",   ["60"]  = "0xE2BA00",   
    ["95"]  = "0x28992D",   ["79"]  = "0x28992D",   ["58"]  = "0xFF9420",   
    ["94"]  = "0x28992D",   ["77"]  = "0x28992D",   ["55"]  = "0xFF9420",   
    ["93"]  = "0x28992D",   ["75"]  = "0xE2BA00",   ["54"]  = "0xFF9420",   
    ["92"]  = "0x28992D",   ["74"]  = "0xE2BA00",   ["52"]  = "0xFF9420",   
    ["90"]  = "0x28992D",   ["73"]  = "0xE2BA00",   ["49"]  = "0xc82727",   
    ["88"]  = "0x28992D",   ["70"]  = "0xE2BA00",   ["43"]  = "0xc82727",   
    ["86"]  = "0x28992D",   ["68"]  = "0xE2BA00",   ["35"]  = "0xc82727", 
    ["85"]  = "0x28992D",    ["67"]  = "0xE2BA00", 
    ["84"]  = "0x28992D",    ["66"]  = "0xE2BA00",   
}
    return colors[sharpnessName] or "0xFFFFFF"
end    
     
local function getSharpnessIcons(sharpnessName)
    if not sharpnessName then return "0xFFFFFF" end
local icons = {
    ["99"]  = "$SharpnessHigh",   ["83"]  = "$SharpnessHigh",   ["65"]  = "$SharpnessMid",   
    ["98"]  = "$SharpnessHigh",   ["80"]  = "$SharpnessHigh",   ["60"]  = "$SharpnessMid",   
    ["95"]  = "$SharpnessHigh",   ["79"]  = "$SharpnessHigh",   ["58"]  = "$SharpnessLowMid",   
    ["94"]  = "$SharpnessHigh",   ["77"]  = "$SharpnessHigh",   ["55"]  = "$SharpnessLowMid",   
    ["93"]  = "$SharpnessHigh",   ["75"]  = "$SharpnessMid",   ["54"]  = "$SharpnessLowMid",   
    ["92"]  = "$SharpnessHigh",   ["74"]  = "$SharpnessMid",   ["52"]  = "$SharpnessLowMid",   
    ["90"]  = "$SharpnessHigh",   ["73"]  = "$SharpnessMid",   ["49"]  = "$SharpnessLow",   
    ["88"]  = "$SharpnessHigh",   ["70"]  = "$SharpnessMid",   ["43"]  = "$SharpnessLow",   
    ["86"]  = "$SharpnessHigh",   ["68"]  = "$SharpnessMid",   ["35"]  = "$SharpnessLow", 
    ["85"]  = "$SharpnessHigh",    ["67"]  = "$SharpnessMid", 
    ["84"]  = "$SharpnessHigh",    ["66"]  = "$SharpnessMid",   
}
    return icons[sharpnessName] or "0xFFFFFF"
end    
  
local function getFitnessIcons(fitnessName)
    if not fitnessName then return "0xFFFFFF" end
local icons = {
    ["99"]  = "$FitnessHigh",   ["84"]  = "$FitnessHigh",   ["73"]  = "$FitnessMid",   ["58"]  = "$FitnessLowMid",   ["45"]  = "$FitnessLow",
    ["98"]  = "$FitnessHigh",   ["83"]  = "$FitnessHigh",   ["72"]  = "$FitnessMid",   ["57"]  = "$FitnessLowMid",   ["43"]  = "$FitnessLow",
    ["96"]  = "$FitnessHigh",   ["82"]  = "$FitnessHigh",   ["70"]  = "$FitnessMid",   ["56"]  = "$FitnessLowMid",   ["40"]  = "$FitnessLow",
    ["95"]  = "$FitnessHigh",   ["81"]  = "$FitnessHigh",   ["69"]  = "$FitnessMid",   ["55"]  = "$FitnessLowMid",   ["37"]  = "$FitnessLow",
    ["94"]  = "$FitnessHigh",   ["80"]  = "$FitnessHigh",   ["68"]  = "$FitnessMid",   ["54"]  = "$FitnessLowMid",   ["35"]  = "$FitnessLow",
    ["91"]  = "$FitnessHigh",   ["79"]  = "$FitnessHigh",   ["66"]  = "$FitnessMid",   ["53"]  = "$FitnessLowMid",   ["33"]  = "$FitnessLow",
    ["90"]  = "$FitnessHigh",   ["78"]  = "$FitnessHigh",   ["65"]  = "$FitnessMid",   ["52"]  = "$FitnessLowMid",   ["32"]  = "$FitnessLow",
    ["89"]  = "$FitnessHigh",   ["77"]  = "$FitnessHigh",   ["64"]  = "$FitnessMid",   ["51"]  = "$FitnessLowMid",   ["30"]  = "$FitnessLow",
    ["88"]  = "$FitnessHigh",   ["76"]  = "$FitnessHigh",   ["62"]  = "$FitnessMid",   ["49"]  = "$FitnessLowMid",   ["27"]  = "$FitnessLow",
    ["86"]  = "$FitnessHigh",    ["75"]  = "$FitnessMid",   ["60"]  = "$FitnessMid",   ["48"]  = "$FitnessLowMid",   ["25"]  = "$FitnessLow",
    ["85"]  = "$FitnessHigh",    ["74"]  = "$FitnessMid",   ["59"]  = "$FitnessLowMid",   ["46"]  = "$FitnessLowMid",   ["20"]  = "$FitnessLow",
}
    return icons[fitnessName] or "0xFFFFFF"
end  
  
  local function getFitnesIcons(fitnesName)
    if not fitnesName then return "0xFFFFFF" end
local icons = {
    ["99 %"]  = "$PlayStyles_7",   ["84 %"]  = "$PlayStyles_2",   ["73 %"]  = "$PlayStyles_3",   ["58 %"]  = "$PlayStyles_5",   ["45 %"]  = "$PlayStyles_6",
    ["98 %"]  = "$PlayStyles_7",   ["83 %"]  = "$PlayStyles_1",   ["72 %"]  = "$PlayStyles_3",   ["57 %"]  = "$PlayStyles_4",   ["43 %"]  = "$PlayStyles_6",
    ["96 %"]  = "$PlayStyles_6",   ["82 %"]  = "$PlayStyles_1",   ["70 %"]  = "$PlayStyles_2",   ["56 %"]  = "$PlayStyles_4",   ["40 %"]  = "$PlayStyles_5",
    ["95 %"]  = "$PlayStyles_6",   ["81 %"]  = "$PlayStyles_7",   ["69 %"]  = "$PlayStyles_2",   ["55 %"]  = "$PlayStyles_3",   ["37 %"]  = "$PlayStyles_5",
    ["94 %"]  = "$PlayStyles_5",   ["80 %"]  = "$PlayStyles_7",   ["68 %"]  = "$PlayStyles_1",   ["54 %"]  = "$PlayStyles_3",   ["35 %"]  = "$PlayStyles_4",
    ["91 %"]  = "$PlayStyles_5",   ["79 %"]  = "$PlayStyles_6",   ["66 %"]  = "$PlayStyles_1",   ["53 %"]  = "$PlayStyles_2",   ["33 %"]  = "$PlayStyles_4",
    ["90 %"]  = "$PlayStyles_4",   ["78 %"]  = "$PlayStyles_6",   ["65 %"]  = "$PlayStyles_7",   ["52 %"]  = "$PlayStyles_2",   ["32 %"]  = "$PlayStyles_3",
    ["89 %"]  = "$PlayStyles_4",   ["77 %"]  = "$PlayStyles_5",   ["64 %"]  = "$PlayStyles_7",   ["51 %"]  = "$PlayStyles_1",   ["30 %"]  = "$PlayStyles_3",
    ["88 %"]  = "$PlayStyles_3",   ["76 %"]  = "$PlayStyles_5",   ["62 %"]  = "$PlayStyles_6",   ["49 %"]  = "$PlayStyles_1",   ["27 %"]  = "$PlayStyles_2",
    ["86 %"]  = "$PlayStyles_3",    ["75 %"]  = "$PlayStyles_4",   ["60 %"]  = "$PlayStyles_6",   ["48 %"]  = "$PlayStyles_7",   ["25 %"]  = "$PlayStyles_2",
    ["85 %"]  = "$PlayStyles_2",    ["74 %"]  = "$PlayStyles_4",   ["59 %"]  = "$PlayStyles_5",   ["46 %"]  = "$PlayStyles_7",   ["20 %"]  = "$PlayStyles_1",
}
    return icons[fitnesName] or "0xFFFFFF"
end    
  
 local positionIDs = {
    GK = "Goalkeeper",
    RWB = "Defender",
    RB = "Defender",
    RCB = "Defender",
    CB = "Defender",
    LCB = "Defender",
    LB = "Defender",
    LWB = "Defender",
    RDM = "Middfilder",
    CDM = "Middfilder",
    LDM = "Middfilder",
    RM = "Middfilder",
    RCM = "Middfilder",
    CM = "Middfilder",
    LCM = "Middfilder",
    LM = "Middfilder",
    RAM = "Middfilder",
    CAM = "Middfilder",
    LAM = "Middfilder",
    RF = "Attacker",
    CF =  "Attacker",
    LF =  "Attacker",
    RW =  "Attacker",
    ST =  "Attacker",
    LW =  "Attacker"   
}
local positioningIDs = {
    GK = "GK",
    RWB = "RM/RB",
    RB = "RWB/RB",
    RCB = "CB/RB",
    CB = "RB/LB",
    LCB = "LB/LCB",
    LB = "LWB/LB",
    LWB = "LM/LB",
    RDM = "RM/CDM",
    CDM = "CM/CB",
    LDM = "LM/CDM",
    RM = "RW/RCM",
    RCM = "RM/CM",
    CM = "CDM/CAM",
    LCM = "RM/CM",
    LM = "LW/LCM",
    RAM = "RM/CAM",
    CAM = "CM/CDM",
    LAM = "LM/CAM",
    RF = "CF/RW",
    CF =  "RW/LW",
    LF =  "CF/LW",
    RW =  "LW/ST",
    ST =  "RW/LW",
    LW =  "RW/ST"   
}
        local activeNationName = nationsNames[activePlayer.nationalityID] or "Unknown"
        local fitnessName = getActiveFitness(activePlayer)
        local fitnesName = getActiveFitnes(activePlayer)
        local sharpnessName = getActiveSharpness(activePlayer)
        local fitnessColor = getFitnessColor(fitnessName)  
        local fitnesColor = getFitnesColor(fitnesName) 
        local sharpnessColor = getSharpnessColor(sharpnessName)  
        local fitnessIcons = getFitnessIcons(fitnessName)    
        local fitnesIcons = getFitnesIcons(fitnesName)  
        local sharpnessIcons = getSharpnessIcons(sharpnessName)
            self.im.Publish("bnd_active_player_name", activePlayer.playerName)
            self.im.Publish("bnd_active_player_nations", activeNationName)
            self.im.Publish("bnd_active_player_focus", getActiveFocus(activePlayer))
            self.im.Publish("bnd_active_player_fitness", getActiveFitness(activePlayer))
            self.im.Publish("bnd_active_player_fitness_color", fitnessColor)
            self.im.Publish("bnd_player_sharpness", getActiveSharpness(activePlayer))
            self.im.Publish("bnd_player_sharpness_color", sharpnessColor)
            self.im.Publish("bnd_player_sharpness_icons", sharpnessIcons)
            self.im.Publish("bnd_player_fitness", getActiveFitnes(activePlayer))
            self.im.Publish("bnd_player_fitness_icons", fitnesIcons)
            self.im.Publish("bnd_player_fitness_color", fitnesColor)
            self.im.Publish("bnd_active_player_fitness_icon", fitnessIcons)
            self.im.Publish("bnd_active_player_position", activePlayer.position)
            self.im.Publish("bnd_active_player_role", positionIDs[activePlayer.position])
            self.im.Publish("bnd_active_player_positioning", positioningIDs[activePlayer.position])
            self.im.Publish("bnd_active_player_number", activePlayer.jerseyNumber)
            self.im.Publish("bnd_active_player_rating", activePlayer.rating)
            self.im.Publish("bnd_active_player_avatar", {
                name = "$Head",
                id = activePlayer.CARD_ID or 0
            })           
            self.im.Publish("bnd_active_player_flags", {
                name = "$Flag64x64",
                id = activePlayer.nationalityID or 0
            })           
            self:_publishComparisonStats(activePlayer, passivePlayer, BND_ACTIVE_STAT_PREFIX, BND_PASSIVE_STAT_PREFIX)
            self.im.Publish(BND_ACTIVE_PLAYER_VISIBLE, true)
            self.im.Publish("bnd_default_player_avatar", "")
            self.im.Publish("bnd_default_sharpness_icons", "")
            self.im.Publish("bnd_default_fitness_icons", "")
            self.im.Publish("bnd_default_playstyles_icons", "")
            self.im.Publish("bnd_default_horizontal", "")
            self.im.Publish("bnd_default_vertical", "")
            self.im.Publish("bnd_default_info", "")
            self.im.Publish("bnd_default_label1", "")
            self.im.Publish("bnd_default_label2", "")
            self.im.Publish("bnd_default_label3", "")
            self.im.Publish("bnd_default_label4", "")
            self.im.Publish("bnd_default_label5", "")
            self.im.Publish("bnd_default_label6", "") 
            self.im.Publish("bnd_default_label7", "")
            self.im.Publish("bnd_default_label8", "")
            self.im.Publish("bnd_default_label9", "")
            self.im.Publish("bnd_default_label10", "")
            self.im.Publish("bnd_default_label11", "")
            self.im.Publish("bnd_default_label12", "") 
            self.im.Publish("bnd_default_label13", "") 
            self.im.Publish("bnd_default_label14", "") 
            self.im.Publish("bnd_default_stat", "")
            self.im.Publish("bnd_default_player_name", "")
            self.im.Publish("bnd_default_player_position", "")
            self.im.Publish("bnd_default_player_rating", "")
            self.im.Publish("bnd_default_player_fitness", "")   
            self.im.Publish("bnd_default_player_sharpness", "")
        end
        if passivePlayer then
        local function getPassiveFitness(passivePlayer)   
    if passivePlayer.position == "GK" then
        if passivePlayer.rating >= 99 then
            return "70"
        elseif passivePlayer.rating >= 95 then
            return "45"
        elseif passivePlayer.rating >= 90 then
            return "80"
        elseif passivePlayer.rating >= 85 then
            return "89"
        elseif passivePlayer.rating >= 80 then
            return "94"
        elseif passivePlayer.rating >= 75 then
            return "25"
        elseif passivePlayer.rating >= 70 then
            return "55"
        elseif passivePlayer.rating >= 65 then
            return "35"
        else
            return "100"
        end

    elseif passivePlayer.position == "CB" then
        if passivePlayer.rating >= 99 then
            return "53"
        elseif passivePlayer.rating >= 95 then
            return "85"
        elseif passivePlayer.rating >= 90 then
            return "73"
        elseif passivePlayer.rating >= 85 then
            return "91"
        elseif passivePlayer.rating >= 80 then
            return "45"
        elseif passivePlayer.rating >= 75 then
            return "59"
        elseif passivePlayer.rating >= 70 then
            return "64"
        elseif passivePlayer.rating >= 65 then
            return "77"
        else
            return "100"
        end

    elseif passivePlayer.position == "RB" or passivePlayer.position == "LB" then
        if passivePlayer.rating >= 99 then
            return "66"
        elseif passivePlayer.rating >= 95 then
            return "98"
        elseif passivePlayer.rating >= 90 then
            return "99"
        elseif passivePlayer.rating >= 85 then
            return "58"
        elseif passivePlayer.rating >= 80 then
            return "69"
        elseif passivePlayer.rating >= 75 then
            return "52"
        elseif passivePlayer.rating >= 70 then
            return "96"
        elseif passivePlayer.rating >= 65 then
            return "40"
        else
            return "100"
        end

    elseif passivePlayer.position == "RWB" or passivePlayer.position == "LWB" then
        if passivePlayer.rating >= 99 then
            return "37"
        elseif passivePlayer.rating >= 95 then
            return "33"
        elseif passivePlayer.rating >= 90 then
            return "64"
        elseif passivePlayer.rating >= 85 then
            return "30"
        elseif passivePlayer.rating >= 80 then
            return "79"
        elseif passivePlayer.rating >= 75 then
            return "57"
        elseif passivePlayer.rating >= 70 then
            return "82"
        elseif passivePlayer.rating >= 65 then
            return "77"
        else
            return "100"
        end

    elseif passivePlayer.position == "CM" then
        if passivePlayer.rating >= 99 then
            return "27"
        elseif passivePlayer.rating >= 95 then
            return "76"
        elseif passivePlayer.rating >= 90 then
            return "83"
        elseif passivePlayer.rating >= 85 then
            return "69"
        elseif passivePlayer.rating >= 80 then
            return "73"
        elseif passivePlayer.rating >= 75 then
            return "76"
        elseif passivePlayer.rating >= 70 then
            return "55"
        elseif passivePlayer.rating >= 65 then
            return "86"
        else
            return "100"
        end
        
    elseif passivePlayer.position == "CDM" then
        if passivePlayer.rating >= 99 then
            return "20"
        elseif passivePlayer.rating >= 95 then
            return "46"
        elseif passivePlayer.rating >= 90 then
            return "89"
        elseif passivePlayer.rating >= 85 then
            return "72"
        elseif passivePlayer.rating >= 80 then
            return "90"
        elseif passivePlayer.rating >= 75 then
            return "33"
        elseif passivePlayer.rating >= 70 then
            return "77"
        elseif passivePlayer.rating >= 65 then
            return "43"
        else
            return "100"
        end
        
     elseif passivePlayer.position == "CAM" then
        if passivePlayer.rating >= 99 then
            return "66"
        elseif passivePlayer.rating >= 95 then
            return "54"
        elseif passivePlayer.rating >= 90 then
            return "79"
        elseif passivePlayer.rating >= 85 then
            return "95"
        elseif passivePlayer.rating >= 80 then
            return "74"
        elseif passivePlayer.rating >= 75 then
            return "88"
        elseif passivePlayer.rating >= 70 then
            return "80"
        elseif passivePlayer.rating >= 65 then
            return "64"
        else
            return "100"
        end
        
    elseif passivePlayer.position == "LM" or passivePlayer.position == "RM" then
        if passivePlayer.rating >= 99 then
            return "73"
        elseif passivePlayer.rating >= 95 then
            return "70"
        elseif passivePlayer.rating >= 90 then
            return "66"
        elseif passivePlayer.rating >= 85 then
            return "53"
        elseif passivePlayer.rating >= 80 then
            return "51"
        elseif passivePlayer.rating >= 75 then
            return "49"
        elseif passivePlayer.rating >= 70 then
            return "69"
        elseif passivePlayer.rating >= 65 then
            return "60"
        else
            return "100"
        end
        
    elseif passivePlayer.position == "RW"  then
        if passivePlayer.rating >= 99 then
            return "76"
        elseif passivePlayer.rating >= 95 then
            return "72"
        elseif passivePlayer.rating >= 90 then
            return "83"
        elseif passivePlayer.rating >= 85 then
            return "68"
        elseif passivePlayer.rating >= 80 then
            return "59"
        elseif passivePlayer.rating >= 75 then
            return "75"
        elseif passivePlayer.rating >= 70 then
            return "78"
        elseif passivePlayer.rating >= 65 then
            return "32"
        else
            return "100"
        end
        
    elseif passivePlayer.position == "LW"  then
        if passivePlayer.rating >= 99 then
            return "57"
        elseif passivePlayer.rating >= 95 then
            return "84"
        elseif passivePlayer.rating >= 90 then
            return "48"
        elseif passivePlayer.rating >= 85 then
            return "59"
        elseif passivePlayer.rating >= 80 then
            return "94"
        elseif passivePlayer.rating >= 75 then
            return "90"
        elseif passivePlayer.rating >= 70 then
            return "76"
        elseif passivePlayer.rating >= 65 then
            return "65"
        else
            return "100"
        end
        
    elseif passivePlayer.position == "CF" or passivePlayer.position == "ST" then
        if passivePlayer.rating >= 99 then
            return "32"
        elseif passivePlayer.rating >= 95 then
            return "75"
        elseif passivePlayer.rating >= 90 then
            return "79"
        elseif passivePlayer.rating >= 85 then
            return "81"
        elseif passivePlayer.rating >= 80 then
            return "78"
        elseif passivePlayer.rating >= 75 then
            return "64"
        elseif passivePlayer.rating >= 70 then
            return "62"
        elseif passivePlayer.rating >= 65 then
            return "56"
        else
            return "100"
        end
    end
end

local function getFitnessColor(fitnessName)
    if not fitnessName then return "0xFFFFFF" end
local colors = {
    ["99"]  = "0x28992D",   ["84"]  = "0x28992D",   ["73"]  = "0xE2BA00",   ["58"]  = "0xFF9420",   ["45"]  = "0xc82727",
    ["98"]  = "0x28992D",   ["83"]  = "0x28992D",   ["72"]  = "0xE2BA00",   ["57"]  = "0xFF9420",   ["43"]  = "0xc82727",
    ["96"]  = "0x28992D",   ["82"]  = "0x28992D",   ["70"]  = "0xE2BA00",   ["56"]  = "0xFF9420",   ["40"]  = "0xc82727",
    ["95"]  = "0x28992D",   ["81"]  = "0x28992D",   ["69"]  = "0xE2BA00",   ["55"]  = "0xFF9420",   ["37"]  = "0xc82727",
    ["94"]  = "0x28992D",   ["80"]  = "0x28992D",   ["68"]  = "0xE2BA00",   ["54"]  = "0xFF9420",   ["35"]  = "0xc82727",
    ["91"]  = "0x28992D",   ["79"]  = "0x28992D",   ["66"]  = "0xE2BA00",   ["53"]  = "0xFF9420",   ["33"]  = "0xc82727",
    ["90"]  = "0x28992D",   ["78"]  = "0x28992D",   ["65"]  = "0xE2BA00",   ["52"]  = "0xFF9420",   ["32"]  = "0xc82727",
    ["89"]  = "0x28992D",   ["77"]  = "0x28992D",   ["64"]  = "0xE2BA00",   ["51"]  = "0xFF9420",   ["30"]  = "0xc82727",
    ["88"]  = "0x28992D",   ["76"]  = "0x28992D",   ["62"]  = "0xE2BA00",   ["49"]  = "0xFF9420",   ["27"]  = "0xc82727",
    ["86"]  = "0x28992D",    ["75"]  = "0xE2BA00",   ["60"]  = "0xE2BA00",   ["48"]  = "0xFF9420",   ["25"]  = "0xc82727",
    ["85"]  = "0x28992D",    ["74"]  = "0xE2BA00",   ["59"]  = "0xFF9420",   ["46"]  = "0xFF9420",   ["20"]  = "0xc82727",
}
    return colors[fitnessName] or "0xFFFFFF"
end

local function getFitnessIcons(fitnessName)
    if not fitnessName then return "0xFFFFFF" end
local icons = {
    ["99"]  = "$FitnessHigh",   ["84"]  = "$FitnessHigh",   ["73"]  = "$FitnessMid",   ["58"]  = "$FitnessLowMid",   ["45"]  = "$FitnessLow",
    ["98"]  = "$FitnessHigh",   ["83"]  = "$FitnessHigh",   ["72"]  = "$FitnessMid",   ["57"]  = "$FitnessLowMid",   ["43"]  = "$FitnessLow",
    ["96"]  = "$FitnessHigh",   ["82"]  = "$FitnessHigh",   ["70"]  = "$FitnessMid",   ["56"]  = "$FitnessLowMid",   ["40"]  = "$FitnessLow",
    ["95"]  = "$FitnessHigh",   ["81"]  = "$FitnessHigh",   ["69"]  = "$FitnessMid",   ["55"]  = "$FitnessLowMid",   ["37"]  = "$FitnessLow",
    ["94"]  = "$FitnessHigh",   ["80"]  = "$FitnessHigh",   ["68"]  = "$FitnessMid",   ["54"]  = "$FitnessLowMid",   ["35"]  = "$FitnessLow",
    ["91"]  = "$FitnessHigh",   ["79"]  = "$FitnessHigh",   ["66"]  = "$FitnessMid",   ["53"]  = "$FitnessLowMid",   ["33"]  = "$FitnessLow",
    ["90"]  = "$FitnessHigh",   ["78"]  = "$FitnessHigh",   ["65"]  = "$FitnessMid",   ["52"]  = "$FitnessLowMid",   ["32"]  = "$FitnessLow",
    ["89"]  = "$FitnessHigh",   ["77"]  = "$FitnessHigh",   ["64"]  = "$FitnessMid",   ["51"]  = "$FitnessLowMid",   ["30"]  = "$FitnessLow",
    ["88"]  = "$FitnessHigh",   ["76"]  = "$FitnessHigh",   ["62"]  = "$FitnessMid",   ["49"]  = "$FitnessLowMid",   ["27"]  = "$FitnessLow",
    ["86"]  = "$FitnessHigh",    ["75"]  = "$FitnessMid",   ["60"]  = "$FitnessMid",   ["48"]  = "$FitnessLowMid",   ["25"]  = "$FitnessLow",
    ["85"]  = "$FitnessHigh",    ["74"]  = "$FitnessMid",   ["59"]  = "$FitnessLowMid",   ["46"]  = "$FitnessLowMid",   ["20"]  = "$FitnessLow",
}
    return icons[fitnessName] or "0xFFFFFF"
end
local nationsNamesa = {
    [1] = "Albania",
    [2] = "Andorra",
    [3] = "Armenia",
    [4] = "Austria",
    [5] = "Azerbaijan",
    [6] = "Belarus",
    [7] = "Belgium",
    [8] = "Bosnia",
    [9] = "Bulgaria",
    [10] = "Croatia",
    [11] = "Cyprus",
    [12] = "Czech Republic",
    [13] = "Denmark",
    [14] = "England",
    [15] = "Montenegro",
    [16] = "Faroe Islands",
    [17] = "Finland",
    [18] = "France",
    [19] = "FYR Macedonia",
    [20] = "Georgia",
    [21] = "Germany",
    [22] = "Greece",
    [23] = "Hungary",
    [24] = "Iceland",
    [25] = "Republic of Ireland",
    [26] = "Israel",
    [27] = "Italy",
    [28] = "Latvia",
    [29] = "Liechtenstein",
    [30] = "Lithuania",
    [31] = "Luxembourg",
    [32] = "Malta",
    [33] = "Moldova",
    [34] = "Netherlands",
    [35] = "Northern Ireland",
    [36] = "Norway",
    [37] = "Poland",
    [38] = "Portugal",
    [39] = "Romania",
    [40] = "Russia",
    [41] = "San Marino",
    [42] = "Scotland",
    [43] = "Slovakia",
    [44] = "Slovenia",
    [45] = "Spain",
    [46] = "Sweden",
    [47] = "Switzerland",
    [48] = "Turkey",
    [49] = "Ukraine",
    [50] = "Wales",
    [51] = "Serbia",
    [52] = "Argentina",
    [53] = "Bolivia",
    [54] = "Brazil",
    [55] = "Chile",
    [56] = "Colombia",
    [57] = "Ecuador",
    [58] = "Paraguay",
    [59] = "Peru",
    [60] = "Uruguay",
    [61] = "Venezuela",
    [62] = "Anguilla",
    [63] = "Antigua and Barbuda",
    [64] = "Aruba",
    [65] = "Bahamas",
    [66] = "Barbados",
    [67] = "Belize",
    [68] = "Bermuda",
    [69] = "British Virgin Islands",
    [70] = "Canada",
    [71] = "Cayman Islands",
    [72] = "Costa Rica",
    [73] = "Cuba",
    [74] = "Dominica",
    [75] = "International",
    [76] = "El Salvador",
    [77] = "Grenada",
    [78] = "Guatemala",
    [79] = "Guyana",
    [80] = "Haiti",
    [81] = "Honduras",
    [82] = "Jamaica",
    [83] = "Mexico",
    [84] = "Montserrat",
    [85] = "Curaçao",
    [86] = "Nicaragua",
    [87] = "Panama",
    [88] = "Puerto Rico",
    [89] = "St. Kitts and Nevis",
    [90] = "St. Lucia",
    [91] = "St. Vincent and the Grenadines",
    [92] = "Suriname",
    [93] = "Trinidad and Tobago",
    [94] = "Turks and Caicos Islands",
    [95] = "United States",
    [96] = "US Virgin Islands",
    [97] = "Algeria",
    [98] = "Angola",
    [99] = "Benin",
   [100] = "Botswana",
   [101] = "Burkina Faso",
   [102] = "Burundi",
   [103] = "Cameroon",
   [104] = "Cape Verde",
   [105] = "Central African Republic",
   [106] = "Chad",
   [107] = "Congo",
   [108] = "Côte d'Ivoire",
   [109] = "Djibouti",
   [110] = "Congo DR",
   [111] = "Egypt",
   [112] = "Equatorial Guinea",
   [113] = "Eritrea",
   [114] = "Ethiopia",
   [115] = "Gabon",
   [116] = "Gambia",
   [117] = "Ghana",
   [118] = "Guinea",
   [119] = "Guinea-Bissau",
   [120] = "Kenya",
   [121] = "Lesotho",
   [122] = "Liberia",
   [123] = "Libya",
   [124] = "Madagascar",
   [125] = "Malawi",
   [126] = "Mali",
   [127] = "Mauritania",
   [128] = "Mauritius",
   [129] = "Morocco",
   [130] = "Mozambique",
   [131] = "Namibia",
   [132] = "Niger",
   [133] = "Nigeria",
   [134] = "Rwanda",
   [135] = "São Tomé e Príncipe",
   [136] = "Senegal",
   [137] = "Seychelles",
   [138] = "Sierra Leone",
   [139] = "Somalia",
   [140] = "South Africa",
   [141] = "Sudan",
   [142] = "Swaziland",
   [143] = "Tanzania",
   [144] = "Togo",
   [145] = "Tunisia",
   [146] = "Uganda",
   [147] = "Zambia",
   [148] = "Zimbabwe",
   [149] = "Afghanistan",
   [150] = "Bahrain",
   [151] = "Bangladesh",
   [152] = "Bhutan",
   [153] = "Brunei Darussalam",
   [154] = "Cambodia",
   [155] = "China PR",
   [157] = "Guam",
   [158] = "Hong Kong",
   [159] = "India",
   [160] = "Indonesia",
   [161] = "Iran",
   [162] = "Iraq",
   [163] = "Japan",
   [164] = "Jordan",
   [165] = "Kazakhstan",
   [166] = "Korea DPR",
   [167] = "Korea Republic",
   [168] = "Kuwait",
   [169] = "Kyrgyzstan",
   [170] = "Laos",
   [171] = "Lebanon",
   [172] = "Macau",
   [173] = "Malaysia",
   [174] = "Maldives",
   [175] = "Mongolia",
   [176] = "Myanmar",
   [177] = "Nepal",
   [178] = "Oman",
   [179] = "Pakistan",
   [180] = "Palestine",
   [181] = "Philippines",
   [182] = "Qatar",
   [183] = "Saudi Arabia",
   [184] = "Singapore",
   [185] = "Sri Lanka",
   [186] = "Syria",
   [187] = "Tajikistan",
   [188] = "Thailand",
   [189] = "Turkmenistan",
   [190] = "UAE",
   [191] = "Uzbekistan",
   [192] = "Vietnam",
   [193] = "Yemen",
   [194] = "American Samoa",
   [195] = "Australia",
   [196] = "Cook Islands",
   [197] = "Fiji",
   [198] = "New Zealand",
   [199] = "Papua New Guinea",
   [200] = "Samoa",
   [201] = "Solomon Islands",
   [202] = "Tahiti",
   [203] = "Tonga",
   [204] = "Vanuatu",
   [205] = "Gibraltar",
   [206] = "Greenland",
   [207] = "Dominican Republic",
   [208] = "Estonia",
   [211] = "Rest of World",
   [212] = "Timor-Leste",
   [213] = "Chinese Taipei",
   [214] = "Comoros",
   [215] = "New Caledonia",
   [219] = "Kosovo",
   [250] = "Other",
   [249] = "World Cup",
   [222] = "International Women"
}
        local passiveNationNamre = nationsNamesa[passivePlayer.nationalityID] or "Unknown"
        local fitnessName = getPassiveFitness(passivePlayer)
        local fitnessColor = getFitnessColor(fitnessName)    
        local fitnessIcons = getFitnessIcons(fitnessName)    
            self.im.Publish("bnd_passive_player_name", passivePlayer.playerName)
            self.im.Publish("bnd_passive_player_nations", passiveNationNamre)
            self.im.Publish("bnd_passive_player_fitness", getPassiveFitness(passivePlayer))
            self.im.Publish("bnd_passive_player_fitness_color", fitnessColor)
            self.im.Publish("bnd_passive_player_fitness_icon", fitnessIcons)
            self.im.Publish("bnd_passive_player_position", passivePlayer.position)
            self.im.Publish("bnd_passive_player_rating", passivePlayer.rating)
            self.im.Publish("bnd_passive_player_avatar", {
                name = "$Head",
                id = passivePlayer.CARD_ID or 0
            })
            self:_publishComparisonStats(activePlayer, passivePlayer, BND_ACTIVE_STAT_PREFIX, BND_PASSIVE_STAT_PREFIX)
            self.im.Publish(BND_ACTIVE_PLAYER_VISIBLE, false)
            self.im.Publish(BND_PASSIVE_PLAYER_VISIBLE, true)
            self.im.Publish("bnd_default_player_avatar", "")
            self.im.Publish("bnd_default_sharpness_icons", "")
            self.im.Publish("bnd_default_fitness_icons", "")
            self.im.Publish("bnd_default_playstyles_icons", "")
            self.im.Publish("bnd_default_horizontal", "")
            self.im.Publish("bnd_default_vertical", "")
            self.im.Publish("bnd_default_info", "")
            self.im.Publish("bnd_default_label1", "")
            self.im.Publish("bnd_default_label2", "")
            self.im.Publish("bnd_default_label3", "")
            self.im.Publish("bnd_default_label4", "")
            self.im.Publish("bnd_default_label5", "")
            self.im.Publish("bnd_default_label6", "") 
            self.im.Publish("bnd_default_label7", "")
            self.im.Publish("bnd_default_label8", "")
            self.im.Publish("bnd_default_label9", "")
            self.im.Publish("bnd_default_label10", "")
            self.im.Publish("bnd_default_label11", "")
            self.im.Publish("bnd_default_label12", "") 
            self.im.Publish("bnd_default_label13", "") 
            self.im.Publish("bnd_default_label14", "") 
            self.im.Publish("bnd_default_stat", "")
            self.im.Publish("bnd_default_player_name", "")
            self.im.Publish("bnd_default_player_position", "")
            self.im.Publish("bnd_default_player_rating", "")
            self.im.Publish("bnd_default_player_fitness", "")
            self.im.Publish("bnd_default_player_sharpness", "")
        end
    end
    self.playerComparisonData = self:getPlayerComparisonData(activePlayer, passivePlayer)
    self:_publishPlayerComparisonData()
end

function TeamManagementModel:clearPlayerVisibility()
  self.im.Publish(BND_ACTIVE_PLAYER_VISIBLE, false)
  self.im.Publish(BND_PASSIVE_PLAYER_VISIBLE, false)
  self:publishSwapAssets()
end

function TeamManagementModel:_publishPlayerStats(player, prefix)
    if not player then 
        for i = 1, 6 do
            self.im.Publish(prefix..i, 0)
            self.im.Publish(prefix.."color_"..i, COLOR_DEFAULT)
        end
        return 
    end
    for i = 1, 6 do
        local statValue = player["stat"..i] or 0
        local color = self:_getStatColor(statValue)
        print(string.format("Publishing %s stat %d: %d (color: %x)", 
              prefix, i, statValue, color))
        
        self.im.Publish(prefix..i, statValue)
        self.im.Publish(prefix.."color_"..i, color)
    end
end

function TeamManagementModel:_publishComparisonStats(activePlayer, passivePlayer, prefixActive, prefixPassive)
    for i = 1, 6 do
        local activeStat = activePlayer and (activePlayer["stat"..i] or 0) or 0
        local passiveStat = passivePlayer and (passivePlayer["stat"..i] or 0) or 0
        local activeColor, passiveColor
        if activeStat > passiveStat then
            activeColor  = COLOR_GREEN
            passiveColor = COLOR_RED
        elseif activeStat < passiveStat then
            activeColor  = COLOR_RED
            passiveColor = COLOR_GREEN
        else
            activeColor  = COLOR_WHITE
            passiveColor = COLOR_WHITE
        end

        self.im.Publish(prefixActive..i, activeStat)
        self.im.Publish(prefixActive.."color_"..i, activeColor)

        self.im.Publish(prefixPassive..i, passiveStat)
        self.im.Publish(prefixPassive.."color_"..i, passiveColor)
    end
end

function TeamManagementModel:publishSwapAssets()
  self.im.Publish("bnd_swap1_active", {
    name = "$Swap1Off",
    id = 0
  })
  self.im.Publish("bnd_swap2_passive", {
    name = "$Swap2Off",
    id = 0
  })
  self.im.Publish("bnd_swap3_active", {
    name = "$Compare_Icon",
    id = 0
  })
    self.im.Publish("bnd_divider_swap", "$Horizontal_Line")
    self.im.Publish("bnd_vertical_swap", "$Vertical_Line")
    self.im.Publish("bnd_rectangle_swap", "$RectangleSwap")
    self.im.Publish("bnd_active_player_playstyles", "$PlayStyleOff") 
    self.im.Publish("bnd_swap_label1", "Name")
    self.im.Publish("bnd_swap_label2", "Fitness")
    self.im.Publish("bnd_swap_label3", "Nations")
    self.im.Publish("bnd_swap_label4", "Pace")
    self.im.Publish("bnd_swap_label5", "Shooting")
    self.im.Publish("bnd_swap_label6", "Passing")
    self.im.Publish("bnd_swap_label7", "Dribbling")
    self.im.Publish("bnd_swap_label8", "Defending")
    self.im.Publish("bnd_swap_label9", "Physical")
    self.im.Publish("bnd_swap_label10", "PlayStyles")
    self.im.Publish("bnd_swap_label11", "Number")
    self.im.Publish("bnd_swap_label12", "Position(s)")
    self.im.Publish("bnd_swap_label13", "Role")
    self.im.Publish("bnd_swap_label14", "Focus")
    self.im.Publish("bnd_swap_label15", "Sharpness")
    self.im.Publish("bnd_swap_notification", "Player Info Comparison")
    self.im.Publish("bnd_swap_info", "Player Info")
end

function TeamManagementModel:swapPlayersByIndex(activeIndex, passiveIndex)
    print("[TeamManagementModel]: swapPlayersByIndex{" .. activeIndex .. ", " .. passiveIndex .. "}")
    if not self.players[activeIndex + 1] or not self.players[passiveIndex + 1] then
        print("Invalid swap indices")
        return
    end
    local passivePlayer = self.players[passiveIndex + 1]
    local activePlayer = self.players[activeIndex + 1]
    
    self.players[passiveIndex + 1] = activePlayer
    self.players[activeIndex + 1] = passivePlayer

    self:clearPlayerVisibility()
  self:checkSquadEligibility()
end
function TeamManagementModel:_updateAfterSwap(activeIndex, passiveIndex)
    self:clearPlayerVisibility()
    local newActivePlayer = self.players[activeIndex + 1]
    local newPassivePlayer = self.players[passiveIndex + 1]
    if newActivePlayer then
        
        self.im.Publish("bnd_active_player_name", newActivePlayer.playerName)
        self.im.Publish("bnd_active_player_nations", activeNationName)
        self.im.Publish("bnd_active_player_fitness", getActiveFitness(activePlayer))
        self.im.Publish("bnd_player_fitnes", getActiveFitnes(activePlayer))
        self.im.Publish("bnd_active_player_position", newActivePlayer.position)
        self.im.Publish("bnd_active_player_rating", newActivePlayer.rating)
        self.im.Publish("bnd_active_player_number", newActivePlayer.jerseyNumber)
        self.im.Publish("bnd_active_player_positioning", positioningIDs[activePlayer.position])
        self.im.Publish("bnd_active_player_avatar", {
            name = "$Head",
            id = newActivePlayer.CARD_ID or 0
        })
             
            self.im.Publish("bnd_active_player_flags", {
                name = "$Flags128x128",
                id = newActivePlayer.countryID or 0
                })
        for i = 1, 6 do
            self.im.Publish(BND_ACTIVE_STAT_PREFIX..i, newActivePlayer["stat"..i] or 0)
        end
        self.im.Publish(BND_ACTIVE_PLAYER_VISIBLE, true)
    end
    if newPassivePlayer then
        self.im.Publish("bnd_passive_player_name", newPassivePlayer.playerName)
        self.im.Publish("bnd_passive_player_nations", passiveNationNamre)
        self.im.Publish("bnd_passive_player_fitness", getPassiveFitness(passivePlayer))
        self.im.Publish("bnd_passive_player_position", newPassivePlayer.position)
        self.im.Publish("bnd_passive_player_rating", newPassivePlayer.rating)
        self.im.Publish("bnd_passive_player_avatar", {
            name = "$Head",
            id = newPassivePlayer.CARD_ID or 0
        })
        for i = 1, 6 do
            self.im.Publish(BND_PASSIVE_STAT_PREFIX..i, newPassivePlayer["stat"..i] or 0)
        end
        self.im.Publish(BND_PASSIVE_PLAYER_VISIBLE, true)
    end
end
function TeamManagementModel:showPlayerComparison(show)
    if show then
        local activePlayer = self.currentActivePlayer
        local passivePlayer = self.currentPassivePlayer
        self:comparePlayers(activePlayer, passivePlayer)
    else
        self:clearPlayerVisibility()
    end
end

function TeamManagementModel:getPlayerComparisonData(activePlayer, passivePlayer)
  print("[TeamManagementModel: getPlayerComparisonData(activePlayer = " .. tostring(activePlayer) .. ", passivePlayer = " .. tostring(passivePlayer) .. "): Listing comparison data...")
  local comparisonData = {}
  if activePlayer == nil and passivePlayer == nil then
    comparisonData.attributes = -1
    comparisonData.activeStats = -1
    comparisonData.passiveStats = -1
  else
    assert(activePlayer, "Active player must not be nil to initiate a player comparison.")
    comparisonData.attributes = {}
    comparisonData.activeStats = {}
    comparisonData.passiveStats = {}

    local customLabels = {
      " ", 
      " ", 
      " ", 
      " ", 
      " ", 
      " "
    }
    
    for i = 1, 6 do

      comparisonData.attributes[i] = customLabels[i] -- Ganti activePlayer["label" .. i] dengan customLabels[i]
      comparisonData.activeStats[i] = activePlayer["stat" .. i]
      comparisonData.passiveStats[i] = passivePlayer["stat" .. i]
    end
  end
  TableUtil.print(comparisonData)
  return comparisonData
end

function TeamManagementModel:saveSquad()
  print("[TeamManagementModel]: saveSquad()")
  local playerIDs = {}
  do
    do
      for _FORV_5_ = 1, #self.players do
        playerIDs[_FORV_5_] = self.players[_FORV_5_].CARD_ID
      end
    end
  end
  self.services.SquadManagementService.SetCurrentPlayerLineup(0, self.teamID, 0, 0, playerIDs)
  self.services.TacticsService.SetFormation(0, self.teamID, self.models.FormationModel:getCurrentFormationID())
end

function TeamManagementModel:_publishStarting11()
  if self.players == nil then
    return
  end
  print("[TeamManagementModel]: _publishStarting11()")
  local starting11 = {}
  do
    do
      for _FORV_5_ = 1, MAX_STARTING do
        starting11[_FORV_5_] = self.players[_FORV_5_]
      end
    end
  end
  self.im.Publish(BND_STARTING_11, {data = starting11})
end

function TeamManagementModel:_publishSubsAndRes()
  if self.players == nil then
    return
  end
  print("[TeamManagementModel]: _publishSubsAndRes()")
  local nSubs = self.services.SquadManagementService.GetNumberOfSubs()
  local nRes = self.services.SquadManagementService.GetNumberOfReserves(self.teamID)
  local subs = {}
  local res = {}
  local subsAndRes = {}
  do
    do
      for _FORV_9_ = 1, nSubs do
        subs[_FORV_9_] = self.players[_FORV_9_ + MAX_STARTING]
      end
    end
  end
  table.insert(subsAndRes, {
    label = (""),
    data = subs
  })
  if nRes > 0 then
    do
      do
        for _FORV_9_ = 1, nRes do
          res[_FORV_9_] = self.players[_FORV_9_ + MAX_STARTING + nSubs]
        end
      end
    end
    table.insert(subsAndRes, {
      label = (""),
      data = res
    })
  end
  self.im.Publish(BND_SUBS_AND_RES, subsAndRes)
end

function TeamManagementModel:_publishChemistryMatrix()
  print("[TeamManagementModel]: _publishChemistryMatrix()")
  self.chemistryMatrix = self.services.FUTSquadManagementService.GetFormationLinks(self.models.FormationModel:getCurrentFormationID())
  do
    do
      for _FORV_4_, _FORV_5_ in ipairs(self.chemistryMatrix) do
        _FORV_5_.PLAYER_LINKSTRENGTH = -1
      end
    end
  end
  self.im.Publish(BND_CHEMISTRY_MATRIX, {
    formation = self.models.FormationModel:getCurrentFormation(),
    chemistryLinks = self.chemistryMatrix
  })
end

function TeamManagementModel:_publishTeamStats(bindingName)
    if bindingName == nil then
        self:_publishTeamStats(BND_TEAM_NAME)
        self:_publishTeamStats(BND_TEAM_CREST)
        self:_publishTeamStats(BND_TEAM_RATING)
        self:_publishTeamStats(BND_TEAM_OVERALL)
    elseif bindingName == BND_TEAM_NAME then
        self.im.Publish(BND_TEAM_NAME, self.loc.LocalizeString("TeamName_Abbr15_" .. self.teamID))
    elseif bindingName == BND_TEAM_CREST then
        self.im.Publish(BND_TEAM_CREST, {name = "$Crest", id = self.teamID})
    elseif bindingName == BND_TEAM_MAN then
        local ManagerObj = {name = "$ManagerCard", id = 0}
        ManagerObj.id = self.teamID
        self.im.Publish(BND_TEAM_MAN, ManagerObj)
    elseif bindingName == BND_TEAM_STARS then
        self.im.Publish(BND_TEAM_STARS, self.teamInfo.starRating)
    elseif bindingName == BND_TEAM_OVERALL then
        self.im.Publish(BND_TEAM_OVERALL, self.teamInfo.overall)
    else
        print("[TeamManagementModel]: _publishTeamStats(): Team stat unknown.")
    end
end

function TeamManagementModel:_publishPlayerComparisonData()
    self.im.Publish(BND_PLAYER_COMPARISON_DATA, self.playerComparisonData)
end

function TeamManagementModel:_publishTeamRatingLabel()
  local ratingLabel = ("RATING:")
  ratingLabel = ratingLabel..""..tostring(self.teamInfo.overall)
  self.im.Publish(BND_TEAM_RATING_LABEL, ratingLabel)
end

function TeamManagementModel:showBio(positionIndex)
    print("[TeamManagementModel]: showBio(" .. (positionIndex or "nil") .. ")")
    local targetPlayers = {}
    for i, v in ipairs(self.players) do
        local player = TableUtil.shallowcopy(v)
        player.type = self.models.ItemModel:toFEType(player.CARD_TYPE, player.CARD_ID)
        table.insert(targetPlayers, player)
    end

    -- Publish player info for selected index (without name)
    local selectedPlayer = self.players[positionIndex + 1]
    if selectedPlayer then
        self.im.Publish("bnd_player_rating", selectedPlayer.rating)
        self.im.Publish("bnd_player_avatar", {
            name = "$Head",
            id = selectedPlayer.CARD_ID
        })
    end

    self.nav.Event(nil, "evt_show_player_bio", {
        targetPlayers = targetPlayers,
        targetPositionIndex = positionIndex
    })
end

function TeamManagementModel:_setPlayerVisibility(activeVisible, passiveVisible)
  self.im.Publish(BND_ACTIVE_PLAYER_VISIBLE, activeVisible)
  self.im.Publish(BND_PASSIVE_PLAYER_VISIBLE, passiveVisible)
end
function TeamManagementModel:clearPlayerVisibility()  
    self.im.Publish("bnd_passive_player_name", "TEST")
    self.im.Publish("bnd_passive_player_position", "GAY")
    self.im.Publish("bnd_passive_player_rating", 99)
    self.im.Publish("bnd_passive_player_avatar", {
        name = "$Head",
        id = 27364
    })
    self.im.Publish(BND_ACTIVE_PLAYER_VISIBLE, true)
    self.im.Publish(BND_PASSIVE_PLAYER_VISIBLE, false)
    self.im.Publish("bnd_default_player_avatar", "")
    self.im.Publish("bnd_default_sharpness_icons", "")
    self.im.Publish("bnd_default_fitness_icons", "")
    self.im.Publish("bnd_default_playstyles_icons", "")
    self.im.Publish("bnd_default_horizontal", "")
    self.im.Publish("bnd_default_vertical", "")
    self.im.Publish("bnd_default_info", "")
    self.im.Publish("bnd_default_label1", "")
    self.im.Publish("bnd_default_label2", "")
    self.im.Publish("bnd_default_label3", "")
    self.im.Publish("bnd_default_label4", "")
    self.im.Publish("bnd_default_label5", "")
    self.im.Publish("bnd_default_label6", "") 
    self.im.Publish("bnd_default_label7", "")
    self.im.Publish("bnd_default_label8", "")
    self.im.Publish("bnd_default_label9", "")
    self.im.Publish("bnd_default_label10", "")
    self.im.Publish("bnd_default_label11", "")
    self.im.Publish("bnd_default_label12", "") 
    self.im.Publish("bnd_default_label13", "") 
    self.im.Publish("bnd_default_label14", "") 
    self.im.Publish("bnd_default_stat", "")
    self.im.Publish("bnd_default_player_name", "")
    self.im.Publish("bnd_default_player_position", "")
    self.im.Publish("bnd_default_player_rating", "")
    self.im.Publish("bnd_default_player_fitness", "")
    self.im.Publish("bnd_default_player_sharpness", "")
    self:publishSwapAssets()
end
function TeamManagementModel:Small()
    local buttonYes = {
        icon = "$FooterIconNo",
        label = "Close",
        clickEvents = {"evt_hide_popup"}
    }
    local popupData = {
        title = "SELECTION ERROR",
        message = "Player is injured",
        buttons = {buttonYes}
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
end

function TeamManagementModel:finalize()
    print("[TeamManagementModel]: finalize()")
    self.models.ItemModel:finalize()
    self.models.FormationModel:finalize()
    self.im.UnregisterAction(ACT_SWAP_PLAYERS)
    self.im.UnregisterAction(ACT_COMPARE_PLAYERS)
    self.im.UnregisterAction(ACT_ITEM_SHOW_BIO)
    self.im.UnregisterAction(ACT_SEND_ITEM_DATA)    
    self.im.Unsubscribe(BND_CHEMISTRY_MATRIX)
    self.im.Unsubscribe(BND_STARTING_11)
    self.im.Unsubscribe(BND_SUBS_AND_RES)
    self.im.Unsubscribe(BND_SBS_AND_RES)
    self.im.Unsubscribe(BND_RES)
    self.im.Unsubscribe(BND_RESERVES_ONLY)
    self.im.Unsubscribe(BND_TEAM_NAME)
    self.im.Unsubscribe(BND_TEAM_CREST)
    self.im.Unsubscribe(BND_TEAM_MAN)
    self.im.Unsubscribe(BND_TEAM_RATING)
    self.im.Unsubscribe(BND_TEAM_STARS)
    self.im.Unsubscribe(BND_TEAM_RATING_LABEL)
    self.im.Unsubscribe(BND_TEAM_OVERALL)
    self.im.Unsubscribe(BND_PLAYER_COMPARISON_DATA)
    self.im.Unsubscribe(BND_ITEM_COLLECTION_CONTEXT_MENU_VISIBLE)
    self.im.Unsubscribe(ELIGIBLE_SQUAD_BINDING)
    self.im.Unsubscribe(BND_PLAYER_AVATAR)
    self.im.Unsubscribe(BND_PLAYER_RATING)
    self.im.Unsubscribe("bnd_active_player_rating")
    self.im.Unsubscribe("bnd_passive_player_rating")
    self.im.Unsubscribe("bnd_active_player_avatar")
    self.im.Unsubscribe("bnd_passive_player_avatar")
    self.im.Unsubscribe("bnd_swap1_active")
    self.im.Unsubscribe("bnd_swap2_active")
    self.im.Unsubscribe("bnd_swap3_active")
    self.im.Unsubscribe("bnd_swap1_passive")
    self.im.Unsubscribe("bnd_swap2_passive")
    self.im.Unsubscribe("bnd_swap3_passive")
    self.im.Unsubscribe(NOTICE)
    self.im.Unsubscribe(BND_SWAP_LABEL1)
    self.im.Unsubscribe(BND_SWAP_LABEL2)
    self.im.Unsubscribe(BND_SWAP_LABEL3)
    self.im.Unsubscribe(BND_SWAP_LABEL4)
    self.im.Unsubscribe(BND_SWAP_LABEL5)
    self.im.Unsubscribe(BND_SWAP_LABEL6)
    self.im.Unsubscribe(BND_ACTIVE_PLAYER_VISIBLE)
    self.im.Unsubscribe(BND_PASSIVE_PLAYER_VISIBLE)
    -- Check for suspended players (isSuspended = 1 or 2) in indices 1-18
    local hasSuspendedPlayer = false
    for i = 1, math.min(18, #self.players) do
        local player = self.players[i]
        if player and player.playerName and (isSuspended[player.playerName] == 1 or isSuspended[player.playerName] == 2) then
            hasSuspendedPlayer = true
            break
        end
    end
    
    if hasSuspendedPlayer then
        eligibilityStatus = 1
    else
        eligibilityStatus = 0
    end
end

return TeamManagementModel