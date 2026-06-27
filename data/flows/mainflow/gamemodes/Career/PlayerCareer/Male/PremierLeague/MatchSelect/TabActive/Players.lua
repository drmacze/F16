-----------------------------------------------
---- THEME BY SEPTIAWAN ----
-----------------------------------------------

local TeamRoster = {}
local BND_PLAYER_LIST = "bnd_player_list"
local ACT_PLAYER_SELECT = "act_player_select"
local BND_TEAM_RATING = "bnd_team_rating"
local BND_TEAM_RATING_LABEL = "bnd_team_rating_label"
local BND_TEAM_OVERALL = "bnd_team_overall"
local BND_MATCHDAY = "bnd_matchday"
local PlayerListData = {}
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

TeamID = currentBeaproInfo[beaproId].homeID

function TeamRoster:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self

    o.services = {
        SquadManagementService = o.api("SquadMgtService"),
        gameSetup = o.api("GameSetupService")
    }
    TeamID = currentBeaproInfo[beaproId].homeID
    o.visible = false
    o.im.Subscribe("bnd_visible", function()
        o:publishVisible()
    end)
    o.im.Subscribe("bnd_loading_visible", function()
        o:publishVisible()
    end)
    o.im.Subscribe("bnd_player_rating", function()
        o:publishPlayerInfo()
    end)
   o.im.Subscribe("bnd_icon_central", function()
        o:publishPlayerInfo()
    end)
   o.im.Subscribe("bnd_icon_false", function()
        o:publishIconFalse()
   end)
   o.im.Subscribe("bnd_rating_false", function()
        o:publishRatingFalse()
   end)
    o.im.Subscribe("bnd_team_crest", function()
        o.im.Publish("bnd_team_crest", {
            name = "$Crest",
            id = TeamID
        })
    end)
    o.im.Subscribe("bnd_team_name", function()
        o.im.Publish("bnd_team_name",
            o.loc.LocalizeString("TeamName_Abbr15_" .. TeamID))
    end)
    
    for i = 1, 6 do
        o.im.Subscribe("bnd_player_stat" .. i, function()
            o:publishPlayerInfo()
        end)
    end
    o:Init()
    o.im.Subscribe(BND_PLAYER_LIST, function()
        o:publishPlayerRows()
    end)
    o.im.RegisterAction(ACT_PLAYER_SELECT, function(actionName, data)
        if data then
            o:publishPlayerDetail(data)
        end
    end)

    return o
end

function TeamRoster:publishVisible()
    self.im.Publish("bnd_visible", self.visible)
    self.im.Publish("bnd_loading_visible", not self.visible)
end

function TeamRoster:publishPlayerInfo(data)
    -- 🔥 FALLBACK: ambil dari PlayerListData
    if not data then
        local row = PlayerListData and PlayerListData[1]
        if row then
            data = row.playerInfo
        end
    end

    if not data then return end

    self.im.Publish("bnd_player_avatar", { name = "$Head", id = data.CARD_ID })
    self.im.Publish("bnd_player_name", data.playerName)
    self.im.Publish("bnd_player_number", data.jerseyNumber)
    self.im.Publish("bnd_player_ID", data.CARD_ID)
    self.im.Publish("bnd_player_position", data.position)
    self.im.Publish("bnd_player_country", {
        name = "$Flag128x128",
        id = data.nationalityID
    })
    self.im.Publish("bnd_player_stars", {
        name = "$Emblem",
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

    -- 🔥 TAMBAHAN SAJA: bnd_icon_central
    local rating = data.rating or 0
    local iconCentral

    if rating <= 70 then
        iconCentral = "$Icon_Players_Central_1"
    elseif rating <= 80 then
        iconCentral = "$Icon_Players_Central_2"
    else
        iconCentral = "$Icon_Players_Central_3"
    end

    self.im.Publish("bnd_icon_central", iconCentral)

end

function TeamRoster:publishIconFalse()
    local isCustomTeam = CustomPlayerIndexByTeam[TeamID] ~= nil

    if not isCustomTeam then
        self.im.Publish("bnd_icon_false", "$Icon_Players_Central_1")
    else
        self.im.Publish("bnd_icon_false", nil)
    end
end

function TeamRoster:publishRatingFalse()
    local isCustomTeam = CustomPlayerIndexByTeam[TeamID] ~= nil

    if not isCustomTeam then
        self.im.Publish("bnd_rating_false", "0")
    else
        self.im.Publish("bnd_rating_false", nil)
    end
end

function TeamRoster:Init()
    PlayerListData = {}
    local teamLineup =
        self.services.SquadManagementService.GetCurrentPlayerLineup(0, TeamID, 0)
    if not teamLineup then return end
    local customIndexes = CustomPlayerIndexByTeam[TeamID]
    if customIndexes then
        for _, idx in ipairs(customIndexes) do
            local p = teamLineup[idx]
            if p then
                table.insert(PlayerListData, {
                    assetId = p.CARD_ID,
                    crestId = p.stadiumID,
                    nationalityId = p.nationalityID,
                    jerseyNumber = p.jerseyNumber,
                    clickAction = ACT_PLAYER_SELECT,
                    playerInfo = p,
                    isCustomTeam = true,
                    data = {}
                })
            end
        end
    else        
        table.insert(PlayerListData, {
            assetId = 0,
            nationalityId = 0,
            jerseyNumber = "N/A",
            clickAction = nil,
            playerInfo = nil,
            isCustomTeam = false,
            data = {}
        })
    end
end

function TeamRoster:publishPlayerRows()
    local mdIndex = CurrentMatchdayIndex or 1
    local matchdayText = "Matchday " .. tostring(mdIndex)
    self.im.Publish(BND_MATCHDAY, matchdayText)
    for i, v in ipairs(PlayerListData) do
        if v.isCustomTeam then
            v.data.PlayerAvatar = { name = "$Head", id = v.assetId }
            v.data.PlayerName   = v.playerInfo.playerName
            v.data.Rating       = "OVR: " .. tostring(v.playerInfo.rating)
            v.data.Position     = "POS: " .. tostring(v.playerInfo.position)
            v.data.Number       = "NO: "  .. tostring(v.jerseyNumber)
            v.data.clickAction  = v.clickAction
        else
            v.data.PlayerAvatar = { name = "$Head", id = 0 }
            v.data.PlayerName   = "N/A"
            v.data.Rating       = "N/A"
            v.data.Position     = "N/A"
            v.data.Number       = "N/A"
            v.data.clickAction  = nil
        end
            v.data.HomeTeamCrest     = { name = "$Crest", id = v.crestId }
            v.data.PlayerNationality = { name = "$Role", id = v.nationalityId }
            v.data.Matchday          = matchdayText
            v.data.FontColor         = "0xffffff"
    end
    self.im.Publish(BND_PLAYER_LIST, PlayerListData)
-- tetap boleh
    self:publishIconFalse()
    self:publishRatingFalse()
    self.visible = true
    self:publishVisible()
    self:publishPlayerDetail({ id = 0 })
end


function TeamRoster:publishPlayerDetail(data)
    local index = (data.id or 0) + 1
    local row = PlayerListData[index]
    if row and row.playerInfo then
        self:publishPlayerInfo(row.playerInfo)
    end
end

function TeamRoster:finalize()
    self.im.Unsubscribe("bnd_visible")
    self.im.Unsubscribe("bnd_loading_visible")
    self.im.Unsubscribe("bnd_team_crest")
    self.im.Unsubscribe("bnd_team_name")
    self.im.Unsubscribe(bndPlayerList)
    self.im.UnregisterAction(ACT_PLAYER_SELECT)
end

return TeamRoster