-----------------------------------------------
---- THEME BY SEPTIAWAN ----
-----------------------------------------------

local TeamRoster = {}

------------------------------------------------
-- BINDINGS & ACTIONS
------------------------------------------------
local bndPlayerList        = "bnd_player_list"
local ACT_PLAYER_SELECT   = "act_player_select"

local BND_STARTING_PLAYER = "bnd_starting_player"
local BND_NO_STARTING     = "bnd_no_starting"

local BND_TEAM_RATING        = "bnd_team_rating"
local BND_TEAM_RATING_LABEL  = "bnd_team_rating_label"
local BND_TEAM_OVERALL       = "bnd_team_overall"
local BND_MATCHDAY           = "bnd_matchday"

------------------------------------------------
-- DATA
------------------------------------------------
local PlayerListData = {}

------------------------------------------------
-- 🔧 CUSTOM PLAYER INDEX PER TEAM
------------------------------------------------
local CustomPlayerIndexByTeam = {
    [2]  = {3}, 
    [1925]  = {7},
    [1796] = {3},
    [1799] = {3},
    [144] = {11},
    [8] = {6},
    [10] = {3},
    [11] = {6},
    [13] = {4},
    [14] = {11},
    [18] = {3},
    [19] = {4},
    [110] = {3}
}

------------------------------------------------
-- POSITION NAME MAP
------------------------------------------------
local PositionNames = {
    GK  = "Goalkeeper",
    CB  = "Center Back",
    RCB = "Right Center Back",
    LCB = "Left Center Back",
    RB  = "Right Back",
    LB  = "Left Back",
    RWB = "Right Wing Back",
    LWB = "Left Wing Back",
    CDM = "Defensive Midfielder",
    CM  = "Central Midfielder",
    RCM = "Right Central Midfielder",
    LCM = "Left Central Midfielder",
    CAM = "Attacking Midfielder",
    RM  = "Right Midfielder",
    LM  = "Left Midfielder",
    RW  = "Right Winger",
    LW  = "Left Winger",
    CF  = "Center Forward",
    ST  = "Striker",
    SS  = "Second Striker"
}

------------------------------------------------
-- TEAM ID
------------------------------------------------
TeamID = currentBeaproInfo[beaproId].homeID

------------------------------------------------
-- CONSTRUCTOR
------------------------------------------------
function TeamRoster:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self

    o.services = {
        SquadManagementService = o.api("SquadMgtService"),
        gameSetup              = o.api("GameSetupService")
    }

    TeamID = currentBeaproInfo[beaproId].homeID
    o.visible = false

    o.im.Subscribe("bnd_visible", function()
        o:publishVisible()
    end)

    o.im.Subscribe("bnd_loading_visible", function()
        o:publishVisible()
    end)

    o.im.Subscribe(BND_STARTING_PLAYER, function() end)
    o.im.Subscribe(BND_NO_STARTING, function() end)

    o.im.Subscribe("bnd_team_crest", function()
        o.im.Publish("bnd_team_crest", {
            name = "$Crest",
            id = TeamID
        })
    end)

    o.im.Subscribe("bnd_team_name", function()
        o.im.Publish(
            "bnd_team_name",
            o.loc.LocalizeString("TeamName_Abbr15_" .. TeamID)
        )
    end)

    local playerBindings = {
        "bnd_player_avatar",
        "bnd_player_name",
        "bnd_player_number",
        "bnd_player_ID",
        "bnd_player_position",
        "bnd_player_country",
        "bnd_player_rating",
        "bnd_player_stars",
        "bnd_3d_player"
    }

    for _, bnd in ipairs(playerBindings) do
        o.im.Subscribe(bnd, function()
            o:publishPlayerInfo()
        end)
    end

    for i = 1, 6 do
        o.im.Subscribe("bnd_player_stat" .. i, function()
            o:publishPlayerInfo()
        end)
    end

    o:Init()

    o.im.Subscribe(bndPlayerList, function()
        o:publishPlayerRows()
    end)

    o.im.RegisterAction(ACT_PLAYER_SELECT, function(actionName, data)
        if data then
            o:publishPlayerDetail(data)
        end
    end)

    return o
end

------------------------------------------------
-- CHECK STARTING PLAYER
------------------------------------------------
function TeamRoster:isStartingPlayer(cardId)
    local customIndexes = CustomPlayerIndexByTeam[TeamID]
    if not customIndexes then
        return false
    end

    local lineup =
        self.services.SquadManagementService.GetCurrentPlayerLineup(0, TeamID, 0)

    if not lineup then
        return false
    end

    for _, idx in ipairs(customIndexes) do
        local p = lineup[idx]
        if p and p.CARD_ID == cardId then
            return true
        end
    end

    return false
end

------------------------------------------------
-- VISIBILITY
------------------------------------------------
function TeamRoster:publishVisible()
    self.im.Publish("bnd_visible", self.visible)
    self.im.Publish("bnd_loading_visible", not self.visible)
end

------------------------------------------------
-- PLAYER INFO + STARTING / NO STARTING LOGIC
------------------------------------------------
function TeamRoster:publishPlayerInfo(data)
    if not data then
        self.im.Publish(BND_STARTING_PLAYER, "")
        self.im.Publish(BND_NO_STARTING, "•   Random Player who plays starter")
        return
    end

    self.im.Publish("bnd_player_avatar", { name = "$Head", id = data.CARD_ID })
    self.im.Publish("bnd_player_name", data.playerName)
    self.im.Publish("bnd_player_number", data.jerseyNumber)
    self.im.Publish("bnd_player_ID", data.CARD_ID)
    self.im.Publish("bnd_player_position", data.position)

    self.im.Publish("bnd_player_country", {
        name = "$Flag128x128",
        id = data.nationalityID
    })

    self.im.Publish("bnd_player_rating", data.rating)

    self.im.Publish("bnd_3d_player", {
        name = "$_FC_PLAYER3D",
        id = data.CARD_ID
    })

    for i = 1, 6 do
        self.im.Publish("bnd_player_stat" .. i, data["stat" .. i])
    end

    ------------------------------------------------
    -- ⭐ STARTING / NO STARTING (FINAL)
    ------------------------------------------------
    local customIndexes = CustomPlayerIndexByTeam[TeamID]

    self.im.Publish(BND_STARTING_PLAYER, "")
    self.im.Publish(BND_NO_STARTING, "")

    if not customIndexes then
        self.im.Publish(
            BND_NO_STARTING,
            "•   Random Player who plays starter"
        )
        return
    end

    if not self:isStartingPlayer(data.CARD_ID) then
        self.im.Publish(
            BND_NO_STARTING,
            "•   Random Player who plays starter"
        )
        return
    end

    self.im.Publish(
        BND_STARTING_PLAYER,
        "•   Play as a starter with the " .. data.position .. " position"
    )
end

------------------------------------------------
-- INIT PLAYER LIST
------------------------------------------------
function TeamRoster:Init()
    PlayerListData = {}

    local lineup =
        self.services.SquadManagementService.GetCurrentPlayerLineup(0, TeamID, 0)

    if not lineup then return end

    local customIndexes = CustomPlayerIndexByTeam[TeamID]

    if customIndexes then
        for _, idx in ipairs(customIndexes) do
            local p = lineup[idx]
            if p then
                table.insert(PlayerListData, {
                    assetId     = p.CARD_ID,
                    crestId     = TeamID,
                    nationalityId = p.nationalityID,
                    jerseyNumber  = p.jerseyNumber,
                    clickAction   = ACT_PLAYER_SELECT,
                    playerInfo    = p,
                    isCustomTeam  = true,
                    data = {}
                })
            end
        end
    else
        table.insert(PlayerListData, {
            assetId     = 0,
            crestId     = 130000,
            nationalityId = 0,
            jerseyNumber  = "N/A",
            clickAction   = nil,
            playerInfo    = nil,
            isCustomTeam  = false,
            data = {}
        })
    end
end

------------------------------------------------
-- PUBLISH PLAYER ROWS
------------------------------------------------
function TeamRoster:publishPlayerRows()
    for _, v in ipairs(PlayerListData) do
        if v.isCustomTeam and v.playerInfo then
            local posCode = v.playerInfo.position
            local posName = PositionNames[posCode] or posCode

            v.data.PlayerAvatar = { name = "$Head", id = v.assetId }
            v.data.PlayerName   = v.playerInfo.playerName
            v.data.Rating       = v.playerInfo.rating
            v.data.Position     = posName
            v.data.Number       = v.jerseyNumber
            v.data.clickAction  = v.clickAction
        else
            v.data.PlayerAvatar = { name = "$Head", id = 0 }
            v.data.PlayerName   = "N/A"
            v.data.Rating       = "N/A"
            v.data.Position     = "N/A"
            v.data.Number       = "N/A"
            v.data.clickAction  = nil
        end

        v.data.HomeTeamCrest     = { name = "$Crest64x64", id = v.crestId }
        v.data.PlayerNationality = { name = "$Role", id = v.nationalityId }
        v.data.Matchday          = matchdayText
        v.data.FontColor         = "0xffffff"
    end

    self.im.Publish(bndPlayerList, PlayerListData)

    self.im.Publish(BND_STARTING_PLAYER, "")
    self.im.Publish(BND_NO_STARTING, "")

    self.visible = true
    self:publishVisible()

    self:publishPlayerDetail({ id = 0 })
end

------------------------------------------------
-- PLAYER DETAIL
------------------------------------------------
function TeamRoster:publishPlayerDetail(data)
    local index = (data.id or 0) + 1
    local row = PlayerListData[index]

    if row and row.playerInfo then
        self:publishPlayerInfo(row.playerInfo)
    else
        self.im.Publish(BND_STARTING_PLAYER, "")
        self.im.Publish(
            BND_NO_STARTING,
            "•   Random Player who plays starter"
        )
    end
end

------------------------------------------------
-- FINALIZE
------------------------------------------------
function TeamRoster:finalize()
    self.im.Unsubscribe("bnd_visible")
    self.im.Unsubscribe("bnd_loading_visible")
    self.im.Unsubscribe("bnd_team_crest")
    self.im.Unsubscribe("bnd_team_name")
    self.im.Unsubscribe(bndPlayerList)
    self.im.UnregisterAction(ACT_PLAYER_SELECT)
end

return TeamRoster