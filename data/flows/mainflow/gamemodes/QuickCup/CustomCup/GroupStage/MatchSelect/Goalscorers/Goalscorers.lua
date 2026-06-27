-- Suporta múltiplos formatos: Group + Knockout, Knockout e League

local Tour = {}
local bndMatchList = "bnd_match_list"
local BND_BG_CUP = "bnd_bg_tour"
local bndLogo = "bnd_logo"
local bndTeamLogo = "bnd_team_logo"
local bndTeamName = "bnd_team_name"
local bndTourlabel = "bnd_tour_label"

local bndColorTourId = "bnd_color_tourid"
local bndColorTourId2 = "bnd_color_tourid2"

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

local tourIdToColorMap2 = {
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

function Tour:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    o.im = init.im; o.nav = init.nav; o.loc = init.loc; o.api = init.api

    o.services = {
        squad = o.api("SquadMgtService")
    }

    o.tourId = GlobalTournamentSettings.tourId or 1
    o.playerTeamID = currentTourInfo and currentTourInfo[o.tourId] and currentTourInfo[o.tourId].homeID or 0

    print(" Initializing Goalscorers screen for tourId: " .. o.tourId)

    o:setupSubscriptions()
    o:publishMatchRows()

    return o
end

function Tour:setupSubscriptions()
    self.im.Subscribe(bndMatchList, function() self:publishMatchRows() end)

    self.im.Subscribe(BND_BG_CUP, function()
        self.im.Publish(BND_BG_CUP, {name = "$CupBg", id = self.tourId})
    end)

    self.im.Subscribe(bndLogo, function()
        self.im.Publish(bndLogo, {name = "$CupLogo", id = self.tourId})
    end)

    self.im.Subscribe(bndTeamLogo, function()
        self.im.Publish(bndTeamLogo, {name = "$Crest64x64", id = self.playerTeamID})
    end)

    self.im.Subscribe(bndTeamName, function()
        self.im.Publish(bndTeamName, self.loc.LocalizeString("TeamName_Abbr15_"..self.playerTeamID))
    end)

    self.im.Subscribe(bndTourlabel, function()
        local tourName = tourIdToNameMap[self.tourId] or tourIdToNameMap.default
        self.im.Publish(bndTourlabel, tourName)
    end)

    --  Publish warna 1
    self.im.Subscribe(bndColorTourId, function()
        local clr = tourIdToColorMap[self.tourId] or tourIdToColorMap.default
        self.im.Publish(bndColorTourId, clr)
    end)

    --  Publish warna 2
    self.im.Subscribe(bndColorTourId2, function()
        local clr2 = tourIdToColorMap2[self.tourId] or tourIdToColorMap2.default
        self.im.Publish(bndColorTourId2, clr2)
    end)
end


function Tour:publishMatchRows()
    print("⚙️ Publishing player statistics rows...")
    local tourId = self.tourId

    TournamentStats[tourId] = TournamentStats[tourId] or {
        Goals = {}, Assists = {}, Appearances = {},
        YellowCards = {}, RedCards = {}
    }
    TeamPlayerCache[tourId] = TeamPlayerCache[tourId] or {}

    -------------------------------------------------------
    -- 🔥 FIX: Ganti kiper yang mencetak gol & Prioritaskan Penyerang
    -------------------------------------------------------
    local attackerPositions = { ["ST"] = true, ["CF"] = true, ["RW"] = true, ["LW"] = true, ["LWF"] = true, ["RWF"] = true, ["SS"] = true, ["AMF"] = true }

    for teamID, players in pairs(TeamPlayerCache[tourId]) do
        local designatedScorer = nil

        -- 1. Cari penyerang (ST/CF/RW/LW/SS/AMF) terbaik (rating tertinggi)
        for _, p in ipairs(players) do
            if attackerPositions[p.position] then
                if not designatedScorer or (p.rating or 0) > (designatedScorer.rating or 0) then
                    designatedScorer = p
                end
            end
        end
        
        -- 2. Jika tidak ada penyerang, fallback ke pemain non-GK terbaik (rating tertinggi)
        if not designatedScorer then
            for _, p in ipairs(players) do
                if p.position ~= "GK" then
                    if not designatedScorer or (p.rating or 0) > (designatedScorer.rating or 0) then
                        designatedScorer = p
                    end
                end
            end
        end

        -- Jika ada pemain yang ditunjuk untuk menerima gol
        if designatedScorer then
            for _, p in ipairs(players) do
                local pid = p.CARD_ID
                local goals = TournamentStats[tourId].Goals[pid] or 0

                -- Hanya alihkan gol dari GK (Penjaga Gawang)
                if goals > 0 and p.position == "GK" then 
                    print(" GK Mencetak gol: " .. tostring(pid) .. " → Dialihkan ke penyerang/pemain terbaik: " .. tostring(designatedScorer.CARD_ID))

                    -- Alihkan gol ke pemain lain yang satu tim
                    TournamentStats[tourId].Goals[pid] = 0
                    TournamentStats[tourId].Goals[designatedScorer.CARD_ID] =
                        (TournamentStats[tourId].Goals[designatedScorer.CARD_ID] or 0) + goals
                end
            end
        end
    end
    -------------------------------------------------------
    -- END FIX
    -------------------------------------------------------

    -------------------------------------------------------
    -- LOAD SEMUA PLAYER STATS NORMAL
    -------------------------------------------------------
    local allPlayerStats = {}

    for teamID, players in pairs(TeamPlayerCache[tourId]) do
        for _, player in ipairs(players) do
            if player and player.CARD_ID then
                local playerID = player.CARD_ID
                local playerStats = {
                    cardId = playerID,
                    playerName = player.playerName or "Unknown",
                    position = player.position or "N/A",
                    teamID = teamID,
                    nationalityID = player.nationalityID or 0,
                    goals = TournamentStats[tourId].Goals[playerID] or 0,
                    assists = TournamentStats[tourId].Assists[playerID] or 0,
                    yellowCards = TournamentStats[tourId].YellowCards[playerID] or 0,
                    redCards = TournamentStats[tourId].RedCards[playerID] or 0,
                    appearances = TournamentStats[tourId].Appearances[playerID] or 0,
                    rating = player.rating or 0
                }
                table.insert(allPlayerStats, playerStats)
            end
        end
    end

    -------------------------------------------------------
    -- SORTING
    -------------------------------------------------------
    table.sort(allPlayerStats, function(a, b)
        if a.goals ~= b.goals then return a.goals > b.goals end
        if a.assists ~= b.assists then return a.assists > b.assists end
        if a.rating ~= b.rating then return a.rating > b.rating end
        return a.playerName < b.playerName
    end)

    -------------------------------------------------------
    -- KIRIM KE UI
    -------------------------------------------------------
    local uiDataList = {}
    for rank, p in ipairs(allPlayerStats) do
        if rank > 50 then break end

        table.insert(uiDataList, {
            data = {
                PlayerName = p.playerName,
                Position = p.position,
                Rating = tostring(p.rating),
                TeamName = self.loc.LocalizeString("TeamName_Abbr15_" .. p.teamID),
                Goals = p.goals,
                Assist = p.assists,
                YellowCard = p.yellowCards,
                RedCard = p.redCards,
                Rank = tostring(rank),
                PlayerHead = { name = "$Head", id = p.cardId },
                TeamCrest = { name = "$Crest64x64", id = p.teamID },
                Nationality = { name = "$Flag128x128", id = p.nationalityID }
            }
        })
    end

    self.im.Publish(bndMatchList, uiDataList)
    print(" Published " .. #uiDataList .. " players to the statistics screen.")
end


function Tour:finalize()
    self.im.Unsubscribe(bndMatchList)
    self.im.Unsubscribe(BND_BG_CUP)
    self.im.Unsubscribe(bndLogo)
    self.im.Unsubscribe(bndTeamLogo)
    self.im.Unsubscribe(bndTeamName)
    self.im.Unsubscribe(bndTourlabel)

    --  unsubscribe dua warna
    self.im.Unsubscribe(bndColorTourId)
    self.im.Unsubscribe(bndColorTourId2)

    print(" Goalscorers module finalized.")
end

return Tour