-- Suporta múltiplos formatos: Group + Knockout, Knockout e League

local Bracket = {}

local tourId = GlobalTournamentSettings and GlobalTournamentSettings.tourId or 1

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

local STAGE_NAMES = {
    R32 = "Round of 32",
    R16 = "Round of 16",
    QF = "Quarter-Finals",
    SF = "Semi-Finals",
    F = "Final"
}

local bndTeamList = {}

function Bracket:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    o.loc = init.loc
    o.im = init.im
    
    --  LEIA SETTINGS DINÂMICOS
    local settings = GlobalTournamentSettings or {}
    o.teamCount = settings.teamCount or 48
    o.isKnockoutOnly = settings.isKnockoutOnly or false
    
    --  DADOS DO CAMPEÃO
    o.tourData = {
        isFinish = false,
        championCrest = {
            name = "$Crest",
            id = 0
        }
    }
    
    --  CRIAR LISTA DE BINDINGS DO BRACKET (1-62)
    for i = 1, 62 do
        bndTeamList[i] = "bnd_team" .. i .. "_crest"
        bndTeamList[i + 62] = "bnd_team" .. i .. "_abbr"
        bndTeamList[i + 124] = "bnd_team" .. i .. "_score"
    end
    
    o:setupSubscriptions()
    o:publishAllBracketData()
    
    print(string.format(" Bracket initialized | Team Count: %d | Knockout Only: %s", o.teamCount, tostring(o.isKnockoutOnly)))
    return o
end

function Bracket:setupSubscriptions()
    --  SUBSCRIPTIONS PARA BRACKET
    for i = 1, 62 do
        self.im.Subscribe("bnd_team" .. i .. "_crest", function() self:publishBracketData() end)
        self.im.Subscribe("bnd_team" .. i .. "_abbr", function() self:publishBracketData() end)
        self.im.Subscribe("bnd_team" .. i .. "_score", function() self:publishBracketData() end)
    end
    
    --  SUBSCRIPTIONS PARA CAMPEÃO
    self.im.Subscribe("bnd_champion_visible", function() self:publishChampion() end)
    self.im.Subscribe("bnd_champion_crest", function() self:publishChampion() end)
    self.im.Subscribe("bnd_champion_team", function() self:publishChampion() end)
    self.im.Subscribe("bnd_text", function() self:publishChampion() end)
    
    --  SUBSCRIPTIONS PARA INFO DO TORNEIO
    self.im.Subscribe("bnd_tour_label", function() self:publishTourInfo() end)
    self.im.Subscribe("bnd_tour_trophy", function() self:publishTourInfo() end)
    self.im.Subscribe("bnd_bg_tour", function() self:publishTourInfo() end)
    self.im.Subscribe("bnd_tour_map", function() self:publishTourInfo() end)
    self.im.Subscribe("bnd_tour_logo", function() self:publishTourInfo() end)
end

function Bracket:publishAllBracketData()
    self:publishBracketData()
    self:publishChampion()
    self:publishTourInfo()
end

--  PUBLICAR INFORMAÇÕES DO TORNEIO
function Bracket:publishTourInfo()
    local tourName = tourIdToNameMap[tourId] or tourIdToNameMap.default
    
    self.im.Publish("bnd_tour_label", tourName)
    self.im.Publish("bnd_tour_trophy", { name = "$Trophy", id = tourId })
    self.im.Publish("bnd_bg_tour", { name = "$CupBg", id = tourId })
    self.im.Publish("bnd_tour_map", { name = "$CupMap", id = tourId })
    self.im.Publish("bnd_tour_logo", { name = "$CupLogo", id = tourId })
    
    print(string.format(" Tournament info published: %s", tourName))
end

--  DETERMINAR ESTÁGIOS BASEADO NO TOTAL DE TIMES - SINCRONIZADO
function Bracket:getStageOrder()
    local stageOrder = {}
    
    --  SINCRONIZADO COM TeamSelect.lua, MatchSelect.lua E Standings.lua
    -- IMPORTANTE: Para 16 times knockout direto, COMEÇA COM ROUND OF 16 (Oitavas)
    if self.teamCount == 32 then
        -- 32 times: R32 → R16 → QF → SF → F
        stageOrder = {STAGE_NAMES.R32, STAGE_NAMES.R16, STAGE_NAMES.QF, STAGE_NAMES.SF, STAGE_NAMES.F}
        print("    32-team tournament: R32 → R16 → QF → SF → F")
    elseif self.teamCount == 48 then
        -- 48 times: R16 → QF → SF → F
        stageOrder = {STAGE_NAMES.R16, STAGE_NAMES.QF, STAGE_NAMES.SF, STAGE_NAMES.F}
        print("    48-team tournament: R16 → QF → SF → F")
    elseif self.teamCount == 16 then
        --  16 times KNOCKOUT DIRETO: R16 (Oitavas) → QF (Quartas) → SF (Semis) → F (Final)
        stageOrder = {STAGE_NAMES.R16, STAGE_NAMES.QF, STAGE_NAMES.SF, STAGE_NAMES.F}
        print("    16-team knockout tournament: R16 (Oitavas) → QF (Quartas) → SF (Semis) → F (Final)")
    else
        -- Fallback
        stageOrder = {STAGE_NAMES.F}
        print("    Unknown team count: " .. self.teamCount)
    end
    
    return stageOrder
end

--  PUBLICAR BRACKET DE FORMA COMPATÍVEL COM O LAYOUT
function Bracket:publishBracketData()
    local playerTeamID = currentTourInfo[tourId] and currentTourInfo[tourId].homeID or 0
    
    if not QuickTourGrouping or not QuickTourGrouping[tourId] then
        print(" No bracket data available")
        return
    end
    
    --  VERIFICAR CONCLUSÃO DO TORNEIO
    self:checkTournamentCompletion()
    
    --  DETERMINAR ESTÁGIOS BASEADO NO TOTAL DE TIMES
    local stageOrder = self:getStageOrder()
    
    --  COLETAR MATCHES POR ESTÁGIO
    local bracketMatches = {}
    for _, stage in ipairs(stageOrder) do
        bracketMatches[stage] = {}
    end
    
    --  ADICIONAR MATCHES AO BRACKET
    for _, match in ipairs(QuickTourGrouping[tourId]) do
        local stage = match[9]
        -- Verificar se é um match knockout (match[7] == true)
        if match[7] and bracketMatches[stage] then
            table.insert(bracketMatches[stage], match)
        end
    end
    
    --  DEBUG: Mostrar matches coletados
    print(string.format(" Bracket data collection for %d teams:", self.teamCount))
    for _, stage in ipairs(stageOrder) do
        print(string.format("   %s: %d matches", stage, #bracketMatches[stage]))
    end
    
    --  PREENCHER DADOS DOS 62 SLOTS
    local slotIndex = 1
    
    for _, stage in ipairs(stageOrder) do
        if #bracketMatches[stage] > 0 then
            print(string.format("   Publishing %s matches to bracket...", stage))
            
            --  ORDENAR MATCHES POR MATCHDAY PARA CONSISTÊNCIA
            table.sort(bracketMatches[stage], function(a, b)
                return a[10] < b[10]  -- Ordenar por matchday (índice 10)
            end)
            
            for _, match in ipairs(bracketMatches[stage]) do
                if slotIndex <= 62 then
                    local homeTeamID = match[1]
                    local awayTeamID = match[2]
                    local homeScore = match[3] or 0
                    local awayScore = match[4] or 0
                    
                    --  PUBLICAR HOME TEAM
                    self.im.Publish("bnd_team" .. slotIndex .. "_crest", {
                        name = "$Crest",
                        id = homeTeamID
                    })
                    self.im.Publish("bnd_team" .. slotIndex .. "_abbr", 
                        self.loc.LocalizeString("TeamName_Abbr3_" .. homeTeamID))
                    self.im.Publish("bnd_team" .. slotIndex .. "_score", tostring(homeScore))
                    
                    slotIndex = slotIndex + 1
                    
                    --  PUBLICAR AWAY TEAM
                    if slotIndex <= 62 then
                        self.im.Publish("bnd_team" .. slotIndex .. "_crest", {
                            name = "$Crest",
                            id = awayTeamID
                        })
                        self.im.Publish("bnd_team" .. slotIndex .. "_abbr", 
                            self.loc.LocalizeString("TeamName_Abbr3_" .. awayTeamID))
                        self.im.Publish("bnd_team" .. slotIndex .. "_score", tostring(awayScore))
                        
                        slotIndex = slotIndex + 1
                    end
                end
            end
        end
    end
    
    --  LIMPAR SLOTS VAZIOS
    while slotIndex <= 62 do
        self.im.Publish("bnd_team" .. slotIndex .. "_crest", { name = "$Crest", id = 0 })
        self.im.Publish("bnd_team" .. slotIndex .. "_abbr", "")
        self.im.Publish("bnd_team" .. slotIndex .. "_score", "")
        slotIndex = slotIndex + 1
    end
    
    print(string.format(" Bracket published successfully (slots filled: %d)", slotIndex - 1))
end

--  PUBLICAR CAMPEÃO
function Bracket:publishChampion()
    if self.tourData.isFinish and self.tourData.championCrest.id ~= 0 then
        local championId = self.tourData.championCrest.id
        print(" Displaying champion: " .. self.loc.LocalizeString("TeamName_Abbr15_" .. championId))
        self.im.Publish("bnd_champion_visible", true)
        self.im.Publish("bnd_text", "THE CHAMPION")
        self.im.Publish("bnd_champion_crest", self.tourData.championCrest)
        self.im.Publish("bnd_champion_team", self.loc.LocalizeString("TeamName_Abbr15_" .. championId))
    else
        self.im.Publish("bnd_champion_visible", false)
    end
end

--  VERIFICAR E ATUALIZAR STATUS DO CAMPEÃO
function Bracket:checkTournamentCompletion()
    if not QuickTourGrouping or not QuickTourGrouping[tourId] then
        return
    end
    
    --  Verificar se o final foi jogado
    local finalMatch = nil
    for _, match in ipairs(QuickTourGrouping[tourId]) do
        if match[9] == STAGE_NAMES.F then
            finalMatch = match
            break
        end
    end
    
    if finalMatch and finalMatch[5] then  -- Match played
        self.tourData.isFinish = true
        self.tourData.championCrest.id = finalMatch[6] or 0  -- Winner ID
        self:publishChampion()
        print(" Tournament completed! Champion: " .. tostring(finalMatch[6]))
    end
end

function Bracket:finalize()
    local subsToClean = {
        "bnd_champion_visible", "bnd_champion_crest", "bnd_champion_team", "bnd_text",
        "bnd_tour_label", "bnd_tour_trophy", "bnd_bg_tour", "bnd_tour_map", "bnd_tour_logo"
    }
    
    for _, s in ipairs(subsToClean) do 
        self.im.Unsubscribe(s) 
    end
    
    -- Limpar subscriptions do bracket
    for i = 1, 62 do
        self.im.Unsubscribe("bnd_team" .. i .. "_crest")
        self.im.Unsubscribe("bnd_team" .. i .. "_abbr")
        self.im.Unsubscribe("bnd_team" .. i .. "_score")
    end
    
    print(" Bracket module finalized")
end

return Bracket