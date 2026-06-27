-- Suporta múltiplos formatos: Group + Knockout, Knockout e League

local TeamSelect = {}

-- Constantes de Binding
local BND_CUP_NAME = "bnd_tour_name"
local BND_CUP_LOGO = "bnd_tour_logo"
local BND_CUP_COLOR = "bnd_tour_color"
local BND_CUP_COLOR_TAB = "bnd_tour_color_tab"
local BND_CUP_LABEL = "bnd_tour_label"
local BND_CUP_BG = "bnd_tour_bg"
local BND_TROPHY = "bnd_trophy"
local BND_TEAM_LIST = "bnd_team_list"
local ACT_TEAM_SELECT = "act_team_select"
local ACT_SELECT_TEAM = "act_select_team"
local ACT_RANDOM_TEAMS = "act_random"
local ACT_CHANGE_TEAM = "act_change_team"
local BND_TEAM_CREST = "bnd_team_crest"
local BND_TEAM_NAME = "bnd_team_name"
local BND_TEAM_KIT_HOME = "bnd_team_kit_home"
local BND_TEAM_KIT_AWAY = "bnd_team_kit_away"
local BND_TEAM_RATING = "bnd_team_rating"
local BND_TEAM_OVERALL = "bnd_rating_team"
local BND_TEAM_STAR_RATING = "bnd_rating_star_team"
local BND_GROUP_NAME = "bnd_group_name"
local BND_TEAM_FLAG = "bnd_flag_team"
local BND_TEAM_NAMES = {}
local BND_TEAM_LOGOS = {}
local ACT_TABS = {}
local BND_VISIBLE_TABS = {}

-- Inicializa com 48 posições (máximo)
for i = 1, 48 do
    BND_TEAM_NAMES[i] = "bnd_name_team" .. i
    BND_TEAM_LOGOS[i] = "bnd_logo_team" .. i
    ACT_TABS[i] = "act_tab_team" .. i
    BND_VISIBLE_TABS[i] = "bnd_visible_team" .. i
end

-- Mapeamento de IDs de Torneio para Nomes
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

-- Mapeamento de IDs de Torneio para Cores
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

-- Mapeamento de IDs de Torneio para Cores de tab
local tourIdToColorTabMap = {
  [1]="0x0000FF", [2]="0xFF8100",
  [3]="0x0000FF", [4]="0x28303B",
  [5]="0x091C96", [6]="0xBFA04E",
  [7]="0x0500AA", [8]="0xE80700",
  [9]="0xD1B14B", [10]="0xDE0001", 
  [11]="0xD60006", [12]="0x464646",
  [13]="0x921913", [14]="0x4AC291",
  [15]="0xC80C00", [16]="0xCFAE00", 
  default = "0x4F4F4F"
}

-- Mapeamento de IDs de Torneio para Árbitros
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

-- Mapeamento de Times para País (para bandeiras)
local teamToCountryMap = {
    --England Teams--
    [1] = 14, [2] = 14, [5] = 14, [9] = 14, [10] = 14, [13] = 14,
    [18] = 14, [7] = 14, [11] = 14, [14] = 14, [8] = 14, [106] = 14,
    [88] = 14, [3] = 14, [95] = 14, [12] = 14, [116009] = 14,
    [116010] = 14, [116011] = 14, [116012] = 14, [116013] = 14,
    [116014] = 14, [116015] = 14, [116016] = 14, [116017] = 14,
    [116020] = 14, [116343] = 14,
    
    --France Teams--
    [73] = 18, [219] = 18, [66] = 18, [69] = 18, [65] = 18,
    [64] = 18, [76] = 18, [217] = 18, [72] = 18,
    [111817] = 18, [74] = 18, [1809] = 18, [71] = 18,
    [1819] = 18, [70] = 18, [379] = 18,
    
    --Germany Teams--
    [21] = 21, [22] = 21, [25] = 21, [32] = 21, [38] = 21, [23] = 21,
    [1824] = 21, [112172] = 21, [175] = 21, [36] = 21,
    [10029] = 21, [31] = 21, [169] = 21, [171] = 21,
    [34] = 21, [110636] = 21, [166] = 21,
    
    --Netherlands
    [245] = 34, [246] = 34, [247] = 34, [1903] = 34,
    
    --Italy Teams--
    [45] = 27, [48] = 27, [50] = 27, [52] = 27, [54] = 27,
    [189] = 27, [206] = 27, [1745] = 27, [1842] = 27,
    [110374] = 27, [110556] = 27, [111434] = 27,
    [115841] = 27, [115845] = 27, [131681] = 27,
    [131682] = 27,
    
    --Scotland
    [78] = 42, [80] = 42, [86] = 42,

    --Spain Teams--
    [240] = 45, [241] = 45, [243] = 45, [448] = 45, [450] = 45, [483] = 45,
    [481] = 45, [449] = 45, [457] = 45, [461] = 45, [1860] = 45,
    [110062] = 45, [472] = 45, [1861] = 45, [467] = 45, [462] = 45,
    [110832] = 45, [116325] = 45, [116326] = 45, [116327] = 45,
    [116328] = 45, [116336] = 45, [116337] = 45,

    --Argentina Teams--
    [1013] = 52, [1876] = 52, [1877] = 52, [101083] = 52, [101085] = 52,
    [110395] = 52, [110580] = 52, [111715] = 52, [113044] = 52,

    --Brazil Teams--
    [383] = 54, [517] = 54, [568] = 54, [569] = 54, [598] = 54, [1035] = 54,
    [1041] = 54, [1043] = 54, [1053] = 54, [1629] = 54, [130361] = 54,
    [567] = 54, [1048] = 54, [111052] = 54, [111050] = 54, [111057] = 54,
    [1598] = 54, [112472] = 54,
    
    --Bolívia
    [110968] = 53, [131795] = 53, [112667] = 53,
    
    --Chile
    [15029] = 55, [110975] = 55, [112531] = 55, [111328] = 55,
    
    --Colombia
    [101099] = 56, [101100] = 56, [112992] = 56,
    
    --Equador
    [110981] = 57, [110986] = 57, [114581] = 57, [114615] = 57,
    
    --Paraguay
    [101108] = 58, [111006] = 58, [111008] = 58, [112716] = 58, 
    
    --Peru
    [111011] = 59, [111014] = 59, [114598] = 59,
    
    --Uruguay
    [101110] = 60, [111329] = 60, [115536] = 60, [112868] = 60,
    
    --Venezuela
    [114611] = 61, [110991] = 61, [110989] = 61,
    
    --Other Teams--
    [191] = 4, [209] = 4, [113888] = 5, [231] = 7, [673] = 7, [2014] = 7, [211] = 10,
    [100135] = 11, [266] = 12, [110468] = 12, [819] = 13, [1516] = 13, [280] = 22,
    [393] = 22, [1884] = 22, [1874] = 23, [100632] = 34, [918] = 36, [919] = 36,
    [234] = 38, [236] = 38, [237] = 38, [1896] = 38, [100761] = 39, [320] = 46,
    [896] = 47, [900] = 47, [325] = 48, [326] = 48, [101059] = 49, [1032] = 83,
    [110147] = 83, [111144] = 95, [112893] = 95, [112996] = 95, [112540] = 155,
    [1473] = 167, [605] = 183, [112139] = 183, [111701] = 190, [131739] = 195,
    
    --National Teams--
    [974] = 75, [1318] = 75, [1322] = 75, [1325] = 75, [1328] = 75,
    [1330] = 75, [1331] = 75, [1335] = 75, [1337] = 75, [1352] = 75,
    [1354] = 75, [1359] = 75, [1362] = 75, [1363] = 75, [1364] = 75,
    [1365] = 75, [1369] = 75, [1370] = 75, [1375] = 75, [1377] = 75,
    [1386] = 75, [1387] = 75, [1391] = 75, [1411] = 75, [1415] = 75,
    [1667] = 75, [105013] = 75, [105035] = 75, [111099] = 75,
    [111108] = 75, [111109] = 75, [111111] = 75, [111112] = 75,
    [111114] = 75, [111115] = 75, [111130] = 75, [111448] = 75,
    [111451] = 75, [111455] = 75, [111459] = 75, [111456] = 75,
    [111462] = 75, [111465] = 75, [111473] = 75, [111475] = 75,
    [111485] = 75, [111487] = 75, [111512] = 75, [111513] = 75,
    [111527] = 75, [111545] = 75, [112048] = 75, [112054] = 75,
}

local function getFlagIdByTeamId(teamId)
    return teamToCountryMap[teamId] or 0
end

-- Inicializar tabelas globais
GroupStandings = GroupStandings or {}
QuickTourGrouping = QuickTourGrouping or {}
currentTourInfo = currentTourInfo or {}
currentTourData = currentTourData or {}
TeamPlayerCache = TeamPlayerCache or {}
TournamentStats = TournamentStats or {}
GroupStageTeams = GroupStageTeams or {}
LeagueStandings = LeagueStandings or {}
GOALS = GOALS or {}

-- Banco de Dados de Times por Torneio
local TeamDatabase = {
	--UEFA Champions League--
    [1] = { 1, 2, 5, 9, 10, 13, 18, 21, 22, 32, 45, 48, 69, 73, 219, 231, 234, 237, 240, 241, 243, 245, 247, 266, 280, 325, 448, 483, 819, 918, 1824, 2014, 100135, 101059, 131681, 131682, 115845, 113888 },
    
    --UEFA Europa League--
    [2] = { 2, 896, 189, 1896, 919, 450, 78, 266, 100761, 326, 1874, 246, 25, 673, 211, 100632, 65, 1842, 66, 80, 320, 1516, 72, 14, 1884, 393, 236, 86, 449, 52, 191, 209, 36, 1903, 110468, 900 },
    
    --UEFA Euro--
    [3] = { 1318, 1322, 1325, 1328, 1330, 1331, 1335, 1337, 1343, 1352, 1353, 1354, 1355, 1356, 1359, 1362, 1363, 1364, 1365, 1366, 1367, 1886, 105013, 105035 },
    
    --UEFA Nations League--
    [4] = { 1337, 1352, 1362, 1343, 1318, 1331, 1335, 1353, 1354, 1359, 1363, 1328, 1330, 1886, 105035, 1356 },
 
    --UEFA Women Champions League--
    [5] = { 116009, 116015, 116010, 116013, 116016, 116020, 116343, 116017, 116012, 116011, 116033, 116014, 116037, 116039, 116416, 116417, 116034, 116035, 116044, 115995, 115997, 115996, 115998, 115999, 116021, 116004, 116325, 116326, 116328, 116327, 116336, 116337 },
    
    --CONMEBOL Libertadores--
    [6] = { 568, 383, 1043, 517, 130361, 1041, 110580, 1877, 110395, 101083, 110968, 112716, 111008, 110986, 101110, 111014, 1629, 569, 598, 1035, 1053, 1876, 111715, 101085, 1013, 101108, 114581, 15029, 115536, 111011, 101100, 101099 },
    
    --CONMEBOL Sudamericana--
    [7] = { 101099, 111715, 110975, 114598, 598, 115536, 112868, 131795, 101085, 110989, 112531, 517, 101108, 569, 111006, 113044, 1035, 111011, 114611, 110981, 1053, 1013, 114615, 112667, 1629, 111328, 111329, 112992, 1876, 112472, 1598, 110991 },
    
    --CONMEBOL Copa America--
    [8] = { 1369, 1370, 1375, 1377, 1386, 1387, 111108, 111109, 111451, 111455, 111459, 111465, 111475, 111487, 112048, 112054 },
    
    --FIFA Club World Cup--
    [9] = { 236, 112893, 112139, 383, 1877, 21, 234, 131739, 1876, 131682, 112540, 1032, 111701, 10, 241, 45, 517, 111144, 73, 240, 5, 9, 112996, 1043, 325, 567, 1473, 22, 191, 605, 110147, 243 },
    
    --FIFA World Cup 2026--
    [10] = { 1386, 111099, 974, 1330, 111455, 105013, 111527, 1364, 1370, 111111, 112048, 1359, 1387, 1375, 1415, 1365, 1337, 112054, 111112, 111465, 105035, 1411, 1363, 1391, 1325, 111130, 111115, 111473, 1362, 111456, 111114, 1377, 1335, 1667, 111512, 1352, 1369, 111448, 1322, 111513, 1354, 111545, 111485, 111109, 1318, 1328, 111462, 111475 },
    
    --The Emirates FA Cup--
    [11] = { 1, 2, 7, 5, 9, 10, 11, 13, 14, 18, 8, 106, 88, 3, 95, 12 },
    
    --Copa del Rey--
    [12] = { 243, 241, 240, 481, 449, 457, 461, 483, 448, 1860, 110062, 472, 1861, 467, 462, 110832 },
    
    --Coppa Italia--
    [13] = { 45, 48, 50, 52, 54, 189, 206, 1745, 1842, 110374, 110556, 111434, 115841, 115845, 131681, 131682 },
    
    --DFB Pokal--
    [14] = { 21, 22, 32, 38, 23, 1824, 112172, 175, 36, 10029, 31, 169, 171, 34, 110636, 166 },
    
    --Coupe de France--
    [15] = { 73, 219, 66, 69, 65, 64, 76, 217, 72, 111817, 74, 1809, 71, 1819, 70, 379 },
    
    --Copa do Brasil--
    [16] = { 598, 383, 1041, 1053, 1043, 569, 567, 517, 1048, 1629, 568, 1035, 111052, 111050, 111057, 1598 }
}

-- Variáveis Locais
local TeamList, TeamListData = {}, {}

-- Remove duplicatas de um array
local function removeDuplicates(array)
    local seen, result = {}, {}
    for _, v in ipairs(array) do
        if not seen[v] then
            table.insert(result, v)
            seen[v] = true
        end
    end
    return result
end

-- Embaralha um array aleatoriamente
local function shuffleArray(array)
    math.randomseed(os.time())
    for i = #array, 2, -1 do
        local j = math.random(i)
        array[i], array[j] = array[j], array[i]
    end
end

-- Inicializa lista de times para o torneio
local function initTeamList()
    local settings = GlobalTournamentSettings or {}
    local tourId = settings.tourId or 1
    local teamCount = settings.teamCount or 32
    
    local potentialTeams = TeamDatabase[tourId] or TeamDatabase[1]
    local uniqueTeams = removeDuplicates(potentialTeams)
    -- shuffleArray(uniqueTeams)  -- COMENTADO: Times agora começam ordenados por ID
    
    TeamList = {}
    for i = 1, math.min(teamCount, #uniqueTeams) do
        table.insert(TeamList, uniqueTeams[i])
    end
    print(string.format(" Tournament team list created: %d teams for Tour ID %d", #TeamList, tourId))
end

-- Inicializa estrutura de estatísticas do torneio
local function InitializeTournamentStats(tourId)
    if not TournamentStats[tourId] then
        TournamentStats[tourId] = {
            Goals = {},
            Assists = {},
            YellowCards = {},
            RedCards = {},
            Appearances = {}
        }
    end
end

-- Distribui confrontos balanceadamente entre matchdays globais (GROUP STAGE)
-- COM EMBARALHAMENTO E SINCRONIZAÇÃO PERFEITA
-- GARANTINDO: Nunca 2 confrontos seguidos com o mesmo time
-- GARANTINDO: 2 confrontos por rodada com 4 times diferentes
local function distributeMatchdaysBalanced(groupSchedules, totalGroups, teamCount)
    local fixtureList = {}
    
    local isHomeAndAway = (teamCount == 32)
    local matchdaysPerGroup = isHomeAndAway and 6 or 3
    
    print(string.format(" Creating synchronized distribution: %d teams (%d matchdays)", 
        teamCount, matchdaysPerGroup))
    
    -- ========================================
    -- STEP 1: Embaralhar as partidas dentro de cada grupo
    -- ========================================
    local shuffledGroupSchedules = {}
    for gIndex = 1, totalGroups do
        shuffledGroupSchedules[gIndex] = {}
        
        -- Copia as partidas do grupo
        for _, matchPair in ipairs(groupSchedules[gIndex]) do
            table.insert(shuffledGroupSchedules[gIndex], matchPair)
        end
        
        -- Embaralha
        for i = #shuffledGroupSchedules[gIndex], 2, -1 do
            local j = math.random(i)
            shuffledGroupSchedules[gIndex][i], shuffledGroupSchedules[gIndex][j] = 
                shuffledGroupSchedules[gIndex][j], shuffledGroupSchedules[gIndex][i]
        end
        
        print(string.format(" Group %s matches shuffled: %d matches", 
            string.char(64 + gIndex), #shuffledGroupSchedules[gIndex]))
    end
    
    -- ========================================
    -- STEP 2: Rastrear quais matches foram usados POR GRUPO
    -- ========================================
    local usedMatchesByGroup = {}
    for gIndex = 1, totalGroups do
        usedMatchesByGroup[gIndex] = {}
    end
    
    local matchesPerGroup = #shuffledGroupSchedules[1]
    local confrontosPerMatchday = 2
    local matchdaysPerGroupCalculated = math.ceil(matchesPerGroup / confrontosPerMatchday)
    
    print(string.format(" Matches per group: %d | Confrontos per matchday: %d | Matchdays: %d", 
        matchesPerGroup, confrontosPerMatchday, matchdaysPerGroupCalculated))
    
    -- ========================================
    -- STEP 3: SINCRONIZAÇÃO GLOBAL COM VALIDAÇÃO PERFEITA
    -- ========================================
    for globalMatchday = 1, matchdaysPerGroupCalculated do
        print(string.format("\n GLOBAL MATCHDAY %d:", globalMatchday))
        
        local totalMatchesThisRound = 0
        
        for gIndex = 1, totalGroups do
            local schedule = shuffledGroupSchedules[gIndex]
            local groupLetter = string.char(64 + gIndex)
            
            --  Encontra 2 confrontos válidos para este matchday
            local selectedMatches = {}
            local usedTeamsThisMatchday = {}
            
            --  Percorre os matches e seleciona 2 que não foram usados e não compartilhem times
            for idx = 1, #schedule do
                if #selectedMatches < confrontosPerMatchday then
                    local match = schedule[idx]
                    local teamA, teamB = match[1], match[2]
                    
                    --  Verifica se este match já foi usado
                    local matchAlreadyUsed = false
                    for _, usedIdx in ipairs(usedMatchesByGroup[gIndex]) do
                        if usedIdx == idx then
                            matchAlreadyUsed = true
                            break
                        end
                    end
                    
                    --  Verifica se os times já jogaram nesta rodada
                    local teamAlreadyPlaying = usedTeamsThisMatchday[teamA] or usedTeamsThisMatchday[teamB]
                    
                    --  Valida se é um match válido (times diferentes)
                    local isValidMatch = (teamA ~= teamB)
                    
                    if not matchAlreadyUsed and not teamAlreadyPlaying and isValidMatch then
                        table.insert(selectedMatches, {idx = idx, match = match})
                        table.insert(usedMatchesByGroup[gIndex], idx)
                        usedTeamsThisMatchday[teamA] = true
                        usedTeamsThisMatchday[teamB] = true
                    end
                end
            end
            
            --  Se não encontrou 2, tenta forçar puxando matches não importa o quê
            if #selectedMatches < confrontosPerMatchday then
                print(string.format("   Group %s: Only found %d valid matches, attempting fallback...", 
                    groupLetter, #selectedMatches))
                
                for idx = 1, #schedule do
                    if #selectedMatches < confrontosPerMatchday then
                        local match = schedule[idx]
                        local teamA, teamB = match[1], match[2]
                        
                        local matchAlreadyUsed = false
                        for _, usedIdx in ipairs(usedMatchesByGroup[gIndex]) do
                            if usedIdx == idx then
                                matchAlreadyUsed = true
                                break
                            end
                        end
                        
                        if not matchAlreadyUsed and teamA ~= teamB then
                            table.insert(selectedMatches, {idx = idx, match = match})
                            table.insert(usedMatchesByGroup[gIndex], idx)
                        end
                    end
                end
            end
            
            --  Adiciona os matches selecionados à fixtureList
            print(string.format("  Group %s (Matchday %d): %d matches found", 
                groupLetter, globalMatchday, #selectedMatches))
            
            for _, selected in ipairs(selectedMatches) do
                local matchPair = selected.match
                local teamA, teamB = matchPair[1], matchPair[2]
                
                if teamA ~= teamB then
                    table.insert(fixtureList, {
                        teamA, teamB,
                        0, 0,
                        false,
                        0,
                        false,
                        true,
                        groupLetter,
                        globalMatchday
                    })
                    
                    totalMatchesThisRound = totalMatchesThisRound + 1
                    print(string.format("     Added: %d vs %d", teamA, teamB))
                end
            end
        end
        
        print(string.format("  Global Matchday %d Total: %d matches", globalMatchday, totalMatchesThisRound))
    end
    
    -- ========================================
    -- VERIFICAÇÃO E VALIDAÇÃO FINAL RIGOROSA
    -- ========================================
    print("\n ========================================")
    print(" VERIFICATION")
    print(" ========================================")
    
    local teamMatchCount = {}
    local groupTeamCount = {}
    local matchdayTeamCount = {}
    local groupMatchdayTeams = {}
    local errorCount = 0
    
    for _, match in ipairs(fixtureList) do
        local home, away = match[1], match[2]
        local group = match[9]
        local matchday = match[10]
        
        --  Erro 1: Mesmo time acima/abaixo?
        if home == away then
            print(string.format("  ERROR: Match %d vs %d (SAME TEAM!)", home, away))
            errorCount = errorCount + 1
        end
        
        teamMatchCount[home] = (teamMatchCount[home] or 0) + 1
        teamMatchCount[away] = (teamMatchCount[away] or 0) + 1
        
        groupTeamCount[group] = (groupTeamCount[group] or {})
        groupTeamCount[group][home] = (groupTeamCount[group][home] or 0) + 1
        groupTeamCount[group][away] = (groupTeamCount[group][away] or 0) + 1
        
        matchdayTeamCount[matchday] = (matchdayTeamCount[matchday] or {})
        matchdayTeamCount[matchday][home] = (matchdayTeamCount[matchday][home] or 0) + 1
        matchdayTeamCount[matchday][away] = (matchdayTeamCount[matchday][away] or 0) + 1
        
        --  Erro 2: Time aparece 2x no mesmo matchday/grupo?
        local key = group .. "_" .. matchday
        if not groupMatchdayTeams[key] then
            groupMatchdayTeams[key] = {}
        end
        
        if groupMatchdayTeams[key][home] then
            print(string.format("  ERROR: Team %d appears 2x in %s", home, key))
            errorCount = errorCount + 1
        end
        if groupMatchdayTeams[key][away] then
            print(string.format("  ERROR: Team %d appears 2x in %s", away, key))
            errorCount = errorCount + 1
        end
        
        groupMatchdayTeams[key][home] = true
        groupMatchdayTeams[key][away] = true
    end
    
    --  Resultado de erros
    if errorCount == 0 then
        print("  ZERO ERRORS: All validations passed!")
    else
        print(string.format("  %d CRITICAL ERRORS FOUND!", errorCount))
    end
    
    -- Verificar cada grupo
    print("\n Group verification:")
    for groupLetter, teams in pairs(groupTeamCount) do
        local minTeamMatches = math.huge
        local maxTeamMatches = 0
        local teamsList = {}
        
        for teamId, count in pairs(teams) do
            minTeamMatches = math.min(minTeamMatches, count)
            maxTeamMatches = math.max(maxTeamMatches, count)
            table.insert(teamsList, string.format("T%d:%d", teamId, count))
        end
        
        table.sort(teamsList)
        print(string.format("  %s: %s", groupLetter, table.concat(teamsList, " | ")))
        
        if minTeamMatches == maxTeamMatches then
            print(string.format("      PERFECT: All teams have %d matches", minTeamMatches))
        else
            print(string.format("      IMBALANCE: Min=%d, Max=%d", minTeamMatches, maxTeamMatches))
        end
    end
    
    -- Verificar cada matchday global
    print("\n Matchday verification (SINCRONIZAÇÃO):")
    for matchday = 1, matchdaysPerGroupCalculated do
        local teamsPlaying = matchdayTeamCount[matchday] or {}
        local totalTeams = 0
        local matchesCount = 0
        
        for _ in pairs(teamsPlaying) do
            totalTeams = totalTeams + 1
        end
        
        for _, match in ipairs(fixtureList) do
            if match[10] == matchday then
                matchesCount = matchesCount + 1
            end
        end
        
        print(string.format("  Matchday %d: %d teams playing, %d matches", 
            matchday, totalTeams, matchesCount))
        
        if totalTeams == teamCount then
            print(string.format("      PERFECT: All %d teams playing", teamCount))
        else
            print(string.format("      Only %d/%d teams", totalTeams, teamCount))
        end
        
        -- Verificar 2 matches por grupo
        local matchesPerGroup = {}
        for _, match in ipairs(fixtureList) do
            if match[10] == matchday then
                local group = match[9]
                matchesPerGroup[group] = (matchesPerGroup[group] or 0) + 1
            end
        end
        
        local allGroupsHave2 = true
        for group, count in pairs(matchesPerGroup) do
            if count ~= 2 then
                print(string.format("      Group %s: %d matches (expected 2)", group, count))
                allGroupsHave2 = false
            end
        end
        if allGroupsHave2 then
            print(string.format("      All groups have exactly 2 matches this matchday"))
        end
    end
    
    -- Verificar contagem total
    print("\n Overall verification:")
    local minMatches = math.huge
    local maxMatches = 0
    
    for teamId, count in pairs(teamMatchCount) do
        minMatches = math.min(minMatches, count)
        maxMatches = math.max(maxMatches, count)
    end
    
    print(string.format("  Total matches: %d", #fixtureList))
    print(string.format("  Matches per team - Min: %d, Max: %d", minMatches, maxMatches))
    
    if maxMatches - minMatches == 0 then
        print("    PERFECT GLOBAL SYNCHRONIZATION!")
    else
        print("    IMBALANCE: Difference of " .. (maxMatches - minMatches) .. " matches")
    end
    
    print(string.format("\n FINAL: %d total matches | %d matchdays | %d groups", 
        #fixtureList, matchdaysPerGroupCalculated, totalGroups))
    
    return fixtureList
end

-- Cria confrontos para modo League: 36 times, 8 jogos cada
local function createLeagueFixtures(teamList)
    local fixtureList = {}
    local numTeams = #teamList
    local gamesPerTeam = 8
    local matchdaysPerTeam = 8

    print(string.format(" Creating LEAGUE mode: %d teams, %d matches per team, %d matchdays", 
        numTeams, gamesPerTeam, matchdaysPerTeam))

    local allPossibleMatches = {}
    for i = 1, numTeams do
        for j = i + 1, numTeams do
            table.insert(allPossibleMatches, {teamList[i], teamList[j]})
        end
    end

    print(string.format(" Total possible matchups: %d", #allPossibleMatches))

    for i = #allPossibleMatches, 2, -1 do
        local j = math.random(i)
        allPossibleMatches[i], allPossibleMatches[j] = allPossibleMatches[j], allPossibleMatches[i]
    end

    local matchdayMatches = {}
    local createdMatches = {}
    local teamGameCount = {}
    local teamPlayedByMatchday = {}

    for md = 1, matchdaysPerTeam do
        matchdayMatches[md] = {}
    end

    for _, teamId in ipairs(teamList) do
        teamGameCount[teamId] = 0
    end

    for md = 1, matchdaysPerTeam do
        teamPlayedByMatchday[md] = {}
        for _, teamId in ipairs(teamList) do
            teamPlayedByMatchday[md][teamId] = 0
        end
    end

    for _, matchPair in ipairs(allPossibleMatches) do
        local teamA, teamB = matchPair[1], matchPair[2]
        local matchKey = (teamA < teamB) and (teamA .. "-" .. teamB) or (teamB .. "-" .. teamA)
        
        if not createdMatches[matchKey] then
            if teamGameCount[teamA] < gamesPerTeam and teamGameCount[teamB] < gamesPerTeam then
                local placed = false
                for md = 1, matchdaysPerTeam do
                    if teamPlayedByMatchday[md][teamA] == 0 and teamPlayedByMatchday[md][teamB] == 0 then
                        table.insert(matchdayMatches[md], matchPair)
                        teamPlayedByMatchday[md][teamA] = 1
                        teamPlayedByMatchday[md][teamB] = 1
                        createdMatches[matchKey] = true
                        teamGameCount[teamA] = teamGameCount[teamA] + 1
                        teamGameCount[teamB] = teamGameCount[teamB] + 1
                        placed = true
                        break
                    end
                end
            end
        end
    end

    for md = 1, matchdaysPerTeam do
        for _, matchPair in ipairs(matchdayMatches[md]) do
            table.insert(fixtureList, {
                matchPair[1], matchPair[2],
                0, 0,
                false,
                0,
                false,
                true,
                "LEAGUE",
                md
            })
        end
    end

    print(string.format(" LEAGUE: %d total matches created", #fixtureList))
    
    return fixtureList
end

-- Inicializa nova instância de TeamSelect
function TeamSelect:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    o.im = init.im
    o.nav = init.nav
    o.loc = init.loc
    o.api = init.api
    
    local tourId = GlobalTournamentSettings.tourId or 1
    o.tourData = {
        name = tourIdToNameMap[tourId] or tourIdToNameMap.default,
        color = tourIdToColorMap[tourId] or tourIdToColorMap.default,
        colorTab = tourIdToColorTabMap[tourId] or tourIdToColorTabMap.default,
        referee = tourIdToRefereeNameMap[tourId] or tourIdToRefereeNameMap.default,
        tourId = tourId,
        tourBg = { name = "$CupBg", id = tourId },
        tourlogo = { name = "$CupLogo", id = tourId },
        trophy = { name = "$TourTrophy", id = tourId }
    }
    
    o.services = {
        SquadManagementService = o.api("SquadMgtService"),
        AudioService = o.api("AudioService")
    }
    o.visible = false
    o.currentSelectedIdx = 1
    o.swapSourceIdx = nil
    
    o.im.Publish(BND_CUP_NAME, o.tourData.name)
    o.im.Publish(BND_CUP_COLOR, o.tourData.color)
    o.im.Publish(BND_CUP_COLOR_TAB, o.tourData.colorTab)
    o.im.Publish("bnd_referee_name", o.tourData.referee)
    o.im.Publish(BND_CUP_BG, o.tourData.tourBg)
    o.im.Publish(BND_CUP_LOGO, o.tourData.tourlogo)
    o.im.Publish(BND_TROPHY, o.tourData.trophy)
    
    GlobalTourData = o.tourData
    
    o.im.Subscribe("bnd_visible", function() o:publishVisible() end)
    o.im.Subscribe("bnd_loading_visible", function() o:publishVisible() end)

    o.im.Subscribe(BND_CUP_BG, function()
        o.im.Publish(BND_CUP_BG, o.tourData.tourBg)
    end)
    
    o.im.Subscribe(BND_CUP_LOGO, function()
        o.im.Publish(BND_CUP_LOGO, o.tourData.tourlogo)
    end)
    
    o.im.Subscribe(BND_CUP_NAME, function()
        o.im.Publish(BND_CUP_NAME, o.tourData.name)
    end)
    
    o.im.Subscribe(BND_CUP_COLOR, function()
        o.im.Publish(BND_CUP_COLOR, o.tourData.color)
    end)
    
    o.im.Subscribe(BND_CUP_COLOR_TAB, function()
        o.im.Publish(BND_CUP_COLOR_TAB, o.tourData.colorTab)
    end)

    GroupStandings[tourId] = GroupStandings[tourId] or {}
    QuickTourGrouping[tourId] = QuickTourGrouping[tourId] or {}
    LeagueStandings[tourId] = LeagueStandings[tourId] or {}

    initTeamList()
    o:cacheAllTeamPlayers()
    InitializeTournamentStats(tourId)
    
    if currentTourInfo[tourId] and currentTourInfo[tourId].homeID ~= 0 then
        o.nav.Event(nil, "evt_team_select")
    else
        o.visible = true
        o:publishVisible()
        o:Init()
        o:InitGrouping()
        o.im.Subscribe(BND_TEAM_LIST, function() o:publishTeamRows() end)
        
        o:setupDynamicActions()
        
        if TeamListData[1] then
            o:updateTeamVisualsByIndex(1)
        end
    end
    
    print(" TeamSelect initialized for Tour: " .. o.tourData.name)
    
    return o
end

-- Atualiza visuais de um time pelo índice
function TeamSelect:updateTeamVisualsByIndex(idx)
    if TeamListData[idx] then
        local team = TeamListData[idx]
        local teamId = team.assetId
        
        self.im.Publish(BND_TEAM_CREST, { name = "$Crest", id = teamId })
        
        local flagId = getFlagIdByTeamId(teamId)
        self.im.Publish(BND_TEAM_FLAG, { name = "$Flag128x128", id = flagId })
        
        local localizedName = self.loc.LocalizeString("TeamName_Abbr15_" .. teamId)
        self.im.Publish(BND_TEAM_NAME, localizedName)

        self.im.Publish(BND_TEAM_KIT_HOME, { name = "$KitHome", id = teamId })
        self.im.Publish(BND_TEAM_KIT_AWAY, { name = "$KitAway", id = teamId })

        self.im.Publish(BND_TEAM_OVERALL, team.rating or 0)

        self.im.Publish(BND_TEAM_RATING, {
            attackValue = team.offense or 0,
            middleValue = team.midfield or 0,
            defenseValue = team.defense or 0,
            attackLabel = self.loc.LocalizeString("LTXT_CMN_ATT"),
            middleLabel = self.loc.LocalizeString("LTXT_CMN_MID"),
            defenseLabel = self.loc.LocalizeString("LTXT_CMN_DEF")
        })

        self.im.Publish(BND_TEAM_STAR_RATING, team.starRating or 0)

        local settings = GlobalTournamentSettings or {}
        local isLeagueMode = settings.isLeagueMode or false
        
        if isLeagueMode then
            self.im.Publish(BND_GROUP_NAME, "LEAGUE")
        else
            local teamsPerGroup = settings.teamsPerGroup or 4
            local groupIndex = math.ceil(idx / teamsPerGroup)
            local groupLetter = string.char(64 + groupIndex)
            self.im.Publish(BND_GROUP_NAME, "Group " .. groupLetter)
        end
    end
end

-- Configura ações dinâmicas para interface
function TeamSelect:setupDynamicActions()
    local teamCount = #TeamList
    
    self.im.RegisterAction(ACT_TEAM_SELECT, function(_, data)
       if data then self:StartQuickTour(data) end
    end)

    self.im.RegisterAction(ACT_SELECT_TEAM, function(_, data)
        local tourData = {
            id = self.currentSelectedIdx - 1
        }
        self:StartQuickTour(tourData)
    end)

    self.im.RegisterAction(ACT_RANDOM_TEAMS, function()
        self.services.AudioService.PlaySoundById("act_home_kit_next", "root", {
            soundId = "", type = "", state = { name = "VALID", val = 0 }
        })
        self:RandomizeTeams()
    end)

    self.im.RegisterAction(ACT_CHANGE_TEAM, function()
        if self.swapSourceIdx == nil then
            self.services.AudioService.PlaySoundById("act_move_to_club", "root", {
                soundId = "", type = "", state = { name = "VALID", val = 0 }
            })
            
            self.swapSourceIdx = self.currentSelectedIdx
            
            -- ========================================
            -- ATUALIZAR VISIBILIDADE QUANDO INICIA SWAP
            -- ========================================
            for i = 1, 48 do
                if not TeamListData[i] then
                    self.im.Publish(BND_VISIBLE_TABS[i], false)
                else
                    local isVisible = (i == self.currentSelectedIdx) or (i == self.swapSourceIdx)
                    self.im.Publish(BND_VISIBLE_TABS[i], isVisible)
                end
            end
            
            print(" Swap Source Locked: Team " .. self.swapSourceIdx)
            
        else
            self.services.AudioService.PlaySoundById("act_home_kit_next", "root", {
                soundId = "", type = "", state = { name = "VALID", val = 0 }
            })

            local source = self.swapSourceIdx
            local target = self.currentSelectedIdx

            if source ~= target then
                local tempId = TeamList[source]
                TeamList[source] = TeamList[target]
                TeamList[target] = tempId

                self:Init()
                self:InitGrouping()
                self:publishTeamRows()

                for i = 1, teamCount do
                    if TeamListData[i] then
                        local tId = TeamListData[i].assetId
                        self.im.Publish(BND_TEAM_LOGOS[i], { name = "$Crest", id = tId })
                        self.im.Publish(BND_TEAM_NAMES[i], self.loc.LocalizeString("TeamName_Abbr15_" .. tId))
                    end
                end
                
                self:updateTeamVisualsByIndex(target)
            end
            
            self.swapSourceIdx = nil
            
            -- ========================================
            -- RESETAR VISIBILIDADE APÓS SWAP
            -- ========================================
            for i = 1, 48 do
                if not TeamListData[i] then
                    self.im.Publish(BND_VISIBLE_TABS[i], false)
                else
                    local isVisible = (i == self.currentSelectedIdx)
                    self.im.Publish(BND_VISIBLE_TABS[i], isVisible)
                end
            end
        end
    end)

    -- ========================================
    -- REGISTRAR AÇÕES PARA TODOS OS TIMES
    -- ========================================
    for i = 1, teamCount do
        self.im.RegisterAction(ACT_TABS[i], function()
            self.services.AudioService.PlaySoundById("act_move_to_club", "root", {
                soundId = "", type = "", state = { name = "VALID", val = 0 }
            })
            self.currentSelectedIdx = i
            self:updateTeamVisualsByIndex(i)
            
            -- ========================================
            -- ATUALIZAR VISIBILIDADE AO CLICAR
            -- ========================================
            for j = 1, 48 do
                if not TeamListData[j] then
                    self.im.Publish(BND_VISIBLE_TABS[j], false)
                else
                    local isVisible = (j == i) or (j == self.swapSourceIdx)
                    self.im.Publish(BND_VISIBLE_TABS[j], isVisible)
                end
            end
        end)
    end

    -- ========================================
    -- SUBSCRIBE PARA LOGOS
    -- ========================================
    for i = 1, 48 do
        self.im.Subscribe(BND_TEAM_LOGOS[i], function()
            if TeamListData[i] then
                self.im.Publish(BND_TEAM_LOGOS[i], { name = "$Crest", id = TeamListData[i].assetId })
            end
        end)
    end

    -- ========================================
    -- SUBSCRIBE PARA NOMES
    -- ========================================
    for i = 1, 48 do
        self.im.Subscribe(BND_TEAM_NAMES[i], function()
            if TeamListData[i] then
                local teamId = TeamListData[i].assetId
                local name = self.loc.LocalizeString("TeamName_Abbr15_" .. teamId)
                self.im.Publish(BND_TEAM_NAMES[i], name)
            end
        end)
    end

    -- ========================================
    -- SUBSCRIBE PARA VISIBILIDADE
    -- ========================================
    for i = 1, 48 do
        self.im.Subscribe(BND_VISIBLE_TABS[i], function()
            -- Se não tem dados de time, nunca fica visível
            if not TeamListData[i] then
                self.im.Publish(BND_VISIBLE_TABS[i], false)
                return
            end
            
            local isVisible = (i == self.currentSelectedIdx) or (i == self.swapSourceIdx)
            self.im.Publish(BND_VISIBLE_TABS[i], isVisible)
        end)
    end

    self.im.Subscribe(BND_TEAM_RATING, function() 
        if TeamListData[1] then self:updateTeamVisualsByIndex(1) end 
    end)
    
    self.im.Subscribe(BND_TEAM_OVERALL, function()
        if TeamListData[1] then 
            self.im.Publish(BND_TEAM_OVERALL, TeamListData[1].rating or 0) 
        end
    end)
    
    self.im.Subscribe(BND_TEAM_STAR_RATING, function()
        if TeamListData[1] then 
            self.im.Publish(BND_TEAM_STAR_RATING, TeamListData[1].starRating or 0) 
        end
    end)
    
    self.im.Subscribe(BND_GROUP_NAME, function()
        local settings = GlobalTournamentSettings or {}
        local isLeagueMode = settings.isLeagueMode or false
        if isLeagueMode then
            self.im.Publish(BND_GROUP_NAME, "LEAGUE")
        else
            local teamsPerGroup = settings.teamsPerGroup or 4
            local groupIndex = math.ceil(1 / teamsPerGroup)
            self.im.Publish(BND_GROUP_NAME, "Group " .. string.char(64 + groupIndex))
        end
    end)
    
    self.im.Subscribe(BND_TEAM_CREST, function()
        if TeamListData[1] then 
            self.im.Publish(BND_TEAM_CREST, { name = "$Crest", id = TeamListData[1].assetId }) 
        end
    end)
    
    self.im.Subscribe(BND_TEAM_NAME, function()
        if TeamListData[1] then
            local initialName = self.loc.LocalizeString("TeamName_Abbr15_" .. TeamListData[1].assetId)
            self.im.Publish(BND_TEAM_NAME, initialName)
        end
    end)
    
    self.im.Subscribe(BND_TEAM_KIT_HOME, function()
        if TeamListData[1] then 
            self.im.Publish(BND_TEAM_KIT_HOME, { name = "$HomeKit", id = TeamListData[1].assetId }) 
        end
    end)
    
    self.im.Subscribe(BND_TEAM_KIT_AWAY, function()
        if TeamListData[1] then 
            self.im.Publish(BND_TEAM_KIT_AWAY, { name = "$AwayKit", id = TeamListData[1].assetId }) 
        end
    end)
    
    self.im.Subscribe(BND_TEAM_FLAG, function()
        if TeamListData[1] then
            local teamId = TeamListData[1].assetId
            local flagId = getFlagIdByTeamId(teamId)
            self.im.Publish(BND_TEAM_FLAG, { name = "$Flag128x128", id = flagId })
        end
    end)
end

-- Publica estado de visibilidade
function TeamSelect:publishVisible()
    self.im.Publish("bnd_visible", self.visible)
    self.im.Publish("bnd_loading_visible", not self.visible)
end

-- Publica linhas de times para exibição
function TeamSelect:publishTeamRows()
    for _, team in ipairs(TeamListData) do
        team.data = {
            TeamCrest = { name = "$Crest", id = team.assetId },
            TeamName = team.teamName,
            Rating = team.rating,
            clickAction = team.clickAction,
            FontColor = "0xffffff",
            TeamNameFontColor = "0xffffff",
            Icon = { name = "$IconMatchBall", id = 2 }
        }
    end
    self.im.Publish(BND_TEAM_LIST, TeamListData)
end

-- Inicializa dados de times
function TeamSelect:Init()
    TeamListData = {}
    for _, id in ipairs(TeamList) do
        local info = self.services.SquadManagementService.GetTeamInfo(id)
        
        local starRating = info.starRating or 0
        local ratingPuluhan = info.overall or info.starRating or 0
        
        if ratingPuluhan > 99 then ratingPuluhan = 99 end

        table.insert(TeamListData, {
            assetId = id,
            clickAction = ACT_TEAM_SELECT,
            teamName = self.loc.LocalizeString("TeamName_Abbr15_" .. id),
            shortTeamName = self.loc.LocalizeString("TeamName_Abbr3_" .. id),
            rating = ratingPuluhan,
            starRating = starRating,
            offense = info.offense or 70,
            midfield = info.midfield or 70,
            defense = info.defense or 70,
            data = {}
        })
    end
end

-- Inicializa agrupamento de times e gera confrontos
function TeamSelect:InitGrouping()
    local tourId = GlobalTournamentSettings.tourId or 1
    local teamCount = #TeamList
    local settings = GlobalTournamentSettings or {}
    local totalGroups = settings.totalGroups or math.ceil(teamCount / 4)
    local teamsPerGroup = settings.teamsPerGroup or 4
    local isKnockoutOnly = settings.isKnockoutOnly or false
    local isLeagueMode = settings.isLeagueMode or false

    local isGroupStage = not isKnockoutOnly and not isLeagueMode and (teamCount >= 16)

    currentTourInfo[tourId] = {
        tourIndex = tourId,
        homeID = 0,
        stage = isLeagueMode and "LEAGUE" or (isGroupStage and "GROUP" or "KNOCKOUT"),
        isKnockoutOnly = isKnockoutOnly,
        isLeagueMode = isLeagueMode,
        totalMatches = 0
    }

    if isLeagueMode then
        print(" LEAGUE MODE INITIALIZATION")
        local fixtureList = createLeagueFixtures(TeamList)
        
        LeagueStandings[tourId] = {}
        for _, teamId in ipairs(TeamList) do
            LeagueStandings[tourId][teamId] = {
                teamId = teamId,
                played = 0,
                wins = 0,
                draws = 0,
                losses = 0,
                goalsFor = 0,
                goalsAgainst = 0,
                points = 0
            }
        end
        
        QuickTourGrouping[tourId] = fixtureList
        GroupStageTeams[tourId] = {}
        currentTourInfo[tourId].totalLeagueMatches = #fixtureList
        
        print(string.format(" LEAGUE MODE: %d teams, %d total matches", teamCount, #fixtureList))
        
    elseif isGroupStage then
        print(" GROUP STAGE MODE INITIALIZATION")
        print(string.format(" Total teams: %d | Total groups: %d | Teams per group: %d", 
            teamCount, totalGroups, teamsPerGroup))
        
        -- ========================================
        -- STEP 1: Distribuir times em grupos
        -- ========================================
        local groupList = {}
        for g = 1, totalGroups do
            groupList[g] = {}
            for i = 1, teamsPerGroup do
                local index = (g - 1) * teamsPerGroup + i
                if TeamList[index] then
                    table.insert(groupList[g], TeamList[index])
                end
            end
        end

        print("\n Grupos criados:")
        for g, group in ipairs(groupList) do
            local teamNames = {}
            for _, teamId in ipairs(group) do
                table.insert(teamNames, "T" .. teamId)
            end
            print(string.format("  Group %s: %s", string.char(64 + g), table.concat(teamNames, " | ")))
        end

        -- ========================================
        -- STEP 2: Gerar confrontos por grupo
        -- ========================================
        local isHomeAndAway = (teamCount == 32)
        
        local groupSchedules = {}
        for gIndex, group in ipairs(groupList) do
            local schedule = {}
            
            if isHomeAndAway then
                print(string.format("\n Group %s (HOME AND AWAY):", string.char(64 + gIndex)))
                -- Primeira rodada: times como mandante
                for i = 1, #group do
                    for j = i + 1, #group do
                        table.insert(schedule, {group[i], group[j]})
                        print(string.format("  Match %d: %d (H) vs %d (A)", 
                            #schedule, group[i], group[j]))
                    end
                end
                
                -- Segunda rodada: times como visitante (invertido)
                for i = 1, #group do
                    for j = i + 1, #group do
                        table.insert(schedule, {group[j], group[i]})
                        print(string.format("  Match %d: %d (H) vs %d (A)", 
                            #schedule, group[j], group[i]))
                    end
                end
            else
                print(string.format("\n Group %s (ONE MATCH):", string.char(64 + gIndex)))
                for i = 1, #group do
                    for j = i + 1, #group do
                        table.insert(schedule, {group[i], group[j]})
                        print(string.format("  Match %d: %d vs %d", #schedule, group[i], group[j]))
                    end
                end
            end
            
            print(string.format("  Total: %d matches, %d matches per team", 
                #schedule, #schedule / #group * 2))
            
            groupSchedules[gIndex] = schedule
        end
        
        -- ========================================
        -- STEP 3: Distribuir matches sincronizadamente
        -- ========================================
        local fixtureList = distributeMatchdaysBalanced(groupSchedules, totalGroups, teamCount)

        GroupStageTeams[tourId] = groupList
        QuickTourGrouping[tourId] = fixtureList
        currentTourInfo[tourId].totalGroupMatches = #fixtureList
        
        print(string.format("\n GROUP STAGE COMPLETE: %d groups, %d total matches", 
            totalGroups, #fixtureList))
        
    else
        print(" KNOCKOUT ONLY MODE INITIALIZATION")
        
        local fixtureList = {}
        local shuffledTeams = {}
        for _, team in ipairs(TeamList) do
            table.insert(shuffledTeams, team)
        end
        for i = #shuffledTeams, 2, -1 do
            local j = math.random(i)
            shuffledTeams[i], shuffledTeams[j] = shuffledTeams[j], shuffledTeams[i]
        end
        
        for i = 1, teamCount/2 do
            table.insert(fixtureList, {
                shuffledTeams[i], shuffledTeams[teamCount-i+1],
                0, 0, false, 0, true, false, "Round of 16", 1
            })
        end
        
        QuickTourGrouping[tourId] = fixtureList
        GroupStageTeams[tourId] = {}
        currentTourInfo[tourId].stage = "KNOCKOUT"
        
        print(string.format(" KNOCKOUT STAGE: %d teams, %d matches", teamCount, #fixtureList))
    end
end

-- Embaralha times aleatoriamente e reinicializa
function TeamSelect:RandomizeTeams()
    shuffleArray(TeamList)
    self:Init()
    self:InitGrouping()
    self:publishTeamRows()

    local teamCount = #TeamList

    self.currentSelectedIdx = 1
    
    -- ========================================
    -- ATUALIZAR LOGOS, NOMES E VISIBILIDADE
    -- ========================================
    for i = 1, 48 do
        if TeamListData[i] then
            local tId = TeamListData[i].assetId
            
            self.im.Publish(BND_TEAM_LOGOS[i], { 
                name = "$Crest", 
                id = tId 
            })

            local localizedName = self.loc.LocalizeString("TeamName_Abbr15_" .. tId)
            self.im.Publish(BND_TEAM_NAMES[i], localizedName)
            
            -- Apenas o primeiro time fica visível
            self.im.Publish(BND_VISIBLE_TABS[i], i == 1)
        else
            -- Times vazios sempre invisíveis
            self.im.Publish(BND_VISIBLE_TABS[i], false)
        end
    end

    if TeamListData[1] then
        local team = TeamListData[1]
        local teamId = team.assetId
        
        self.im.Publish(BND_TEAM_CREST, { 
            name = "$Crest", 
            id = teamId 
        })
        
        local flagId = getFlagIdByTeamId(teamId)
        self.im.Publish(BND_TEAM_FLAG, { name = "$Flag128x128", id = flagId })
        
        local mainName = self.loc.LocalizeString("TeamName_Abbr15_" .. teamId)
        self.im.Publish(BND_TEAM_NAME, mainName)

        self.im.Publish(BND_TEAM_KIT_HOME, { 
            name = "$HomeKit", 
            id = teamId 
        })
        self.im.Publish(BND_TEAM_KIT_AWAY, { 
            name = "$AwayKit", 
            id = teamId 
        })

        local settings = GlobalTournamentSettings or {}
        local isLeagueMode = settings.isLeagueMode or false
        
        if isLeagueMode then
            self.im.Publish(BND_GROUP_NAME, "LEAGUE")
        else
            local teamsPerGroup = settings.teamsPerGroup or 4
            local groupIndex = math.ceil(1 / teamsPerGroup)
            self.im.Publish(BND_GROUP_NAME, "Group " .. string.char(64 + groupIndex))
        end

        self.im.Publish(BND_TEAM_OVERALL, team.rating or 0)

        self.im.Publish(BND_TEAM_RATING, {
            attackValue = team.offense or 0,
            middleValue = team.midfield or 0,
            defenseValue = team.defense or 0,
            attackLabel = self.loc.LocalizeString("LTXT_CMN_ATT"),
            middleLabel = self.loc.LocalizeString("LTXT_CMN_MID"),
            defenseLabel = self.loc.LocalizeString("LTXT_CMN_DEF")
        })

        self.im.Publish(BND_TEAM_STAR_RATING, team.starRating or 0)
    end
    
    print(" Teams randomized successfully")
end

-- Inicia o torneio com time selecionado
function TeamSelect:StartQuickTour(data)
    local tourId = GlobalTournamentSettings.tourId or 1
    local teamIndex = data.id + 1
    
    if not TeamListData[teamIndex] then return end
    
    local selectedID = TeamListData[teamIndex].assetId
    local settings = GlobalTournamentSettings or {}
    local isKnockoutOnly = settings.isKnockoutOnly or false
    local isLeagueMode = settings.isLeagueMode or false
    
    currentTourInfo[tourId] = currentTourInfo[tourId] or {}
    currentTourInfo[tourId].homeID = selectedID
    currentTourInfo[tourId].referee = self.tourData.referee
    currentTourInfo[tourId].isKnockoutOnly = isKnockoutOnly
    currentTourInfo[tourId].isLeagueMode = isLeagueMode
    
    currentTourData = {
        matchIndex = 0,
        tourIndex = tourId,
        homeID = selectedID,
        awayID = 0
    }

    local isGroupStage = not isKnockoutOnly and not isLeagueMode and (#TeamList >= 16)
    currentTourInfo[tourId].stage = isGroupStage and "GROUP" or (isLeagueMode and "LEAGUE" or "KNOCKOUT")
    
    local popupTitle = isLeagueMode and "LEAGUE" or (isGroupStage and "GROUP STAGE" or "KNOCKOUT")
    local tournamentName = self.tourData.name
    local teamName = TeamListData[teamIndex].teamName
    
    local popupMessage
    if isLeagueMode then
        popupMessage = string.format(
            "%s, %s, LEAGUE\nReady To Begin?",
            tournamentName, teamName
        )
        currentTourInfo[tourId].groupIndex = 0
        currentTourInfo[tourId].groupLabel = "LEAGUE"
    elseif isGroupStage then
        local groupLabel = ""
        for g, group in ipairs(GroupStageTeams[tourId] or {}) do
            for _, teamID in ipairs(group) do
                if teamID == selectedID then
                    groupLabel = "Group " .. string.char(64 + g)
                    break
                end
            end
            if groupLabel ~= "" then break end
        end
        
        currentTourInfo[tourId].groupIndex = groupLabel:sub(-1):byte() - 64
        currentTourInfo[tourId].groupLabel = groupLabel
        
        popupMessage = string.format(
            "%s, %s, %s\nReady To Begin?",
            tournamentName, teamName, groupLabel
        )
    else
        currentTourInfo[tourId].groupIndex = 0
        currentTourInfo[tourId].groupLabel = "Round of 16"
        
        popupMessage = string.format(
            "%s, %s, %s\nReady To Begin Your KNOCKOUT Challenge?",
            tournamentName, teamName, currentTourInfo[tourId].groupLabel
        )
    end

    local popupData = {
        title = popupTitle,
        message = popupMessage,
        buttons = {
            { 
                icon = "$FooterIconNo", 
                label = "Cancel", 
                clickEvents = { "evt_hide_popup" } 
            },
            { 
                icon = "$FooterIconYes", 
                label = "Confirm", 
                clickEvents = { "evt_team_select", "evt_hide_popup" } 
            }
        }
    }
    self.nav.Event(nil, "evt_show_popup", popupData)
end

-- Faz cache de dados de jogadores de todos os times
function TeamSelect:cacheAllTeamPlayers()
    local tourId = GlobalTournamentSettings.tourId or 1
    
    TeamPlayerCache[tourId] = TeamPlayerCache[tourId] or {}
 
    for i, teamID in ipairs(TeamList) do
        if not TeamPlayerCache[tourId][teamID] then
            local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
            TeamPlayerCache[tourId][teamID] = players
            print(string.format("  Cached team %d (%d/%d)", teamID, i, #TeamList))
        end
    end
    
    GOALS[tourId] = GOALS[tourId] or {}
    print(" Player caching completed for " .. #TeamList .. " teams")
end

-- Limpa recursos ao finalizar
function TeamSelect:finalize()
    local tourId = GlobalTournamentSettings.tourId or 1
    local teamCount = #TeamList
    
    self.im.Unsubscribe("bnd_visible")
    self.im.Unsubscribe("bnd_loading_visible")
    self.im.Unsubscribe(BND_TEAM_LIST)
    self.im.Unsubscribe(BND_CUP_LOGO)
    self.im.Unsubscribe(BND_CUP_COLOR)
    self.im.Unsubscribe(BND_CUP_COLOR_TAB)
    self.im.Unsubscribe(BND_CUP_LABEL)
    self.im.Unsubscribe(BND_CUP_BG)
    self.im.Unsubscribe(BND_TROPHY)
    self.im.Unsubscribe(BND_TEAM_CREST)
    self.im.Unsubscribe(BND_TEAM_NAME)
    self.im.Unsubscribe(BND_TEAM_KIT_HOME)
    self.im.Unsubscribe(BND_TEAM_KIT_AWAY)
    self.im.Unsubscribe(BND_TEAM_RATING)
    self.im.Unsubscribe(BND_TEAM_STAR_RATING)
    self.im.Unsubscribe(BND_TEAM_OVERALL)
    self.im.Unsubscribe(BND_GROUP_NAME)
    self.im.Unsubscribe(BND_TEAM_FLAG)
    self.im.Unsubscribe(BND_CUP_NAME)
    
    self.im.UnregisterAction(ACT_TEAM_SELECT)
    self.im.UnregisterAction(ACT_SELECT_TEAM)
    self.im.UnregisterAction(ACT_RANDOM_TEAMS)
    self.im.UnregisterAction(ACT_CHANGE_TEAM)
    
    for i = 1, 48 do
        self.im.Unsubscribe(BND_TEAM_LOGOS[i])
        self.im.Unsubscribe(BND_TEAM_NAMES[i])
        self.im.Unsubscribe(BND_VISIBLE_TABS[i])
        self.im.UnregisterAction(ACT_TABS[i])
    end
    
    print(" TeamSelect finalized")
end

return TeamSelect