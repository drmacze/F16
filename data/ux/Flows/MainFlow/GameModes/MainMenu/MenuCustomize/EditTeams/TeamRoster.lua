local TeamRoster = {}

local bndPlayerList = "bnd_player_list"

local ACT_PLAYER_SELECT = "act_player_select"

local PlayerListData = {}

TeamID = 0

function TeamRoster:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SquadManagementService = o.api("SquadMgtService"),
    gameSetup = o.api("GameSetupService")
  }
  o.mainbg = {
    name = "$_BackgroundPreMatch2",
    id = 0
  }
  math.randomseed(os.clock() * 1357 + os.time())
  local currentTime = os.date("%H") + 0
  local random = math.random(3)
  o.im.Subscribe("bnd_main_bg", function()
     o.mainbg.id = random
    o.im.Publish("bnd_main_bg", o.mainbg)
  end)
   TeamID = o.services.gameSetup.GetHomeAssetId()
    o.visible = false
    o.im.Subscribe("bnd_visible", function()
        o:publishVisible()
    end)
    o.im.Subscribe("bnd_loading_visible", function()
        o:publishVisible()
    end)
    o.im.Subscribe("bnd_team_crest", function()
        o.im.Publish("bnd_team_crest", {
           name = "$Crest",
           id = TeamID
        })
    end)
    o.im.Subscribe("bnd_team_name", function()
        o.im.Publish("bnd_team_name", o.loc.LocalizeString("TeamName_Abbr15_"..TeamID))
    end)
    o.im.Subscribe("bnd_player_avatar", function()
        o:publishPlayerInfo()
    end)
    o.im.Subscribe("bnd_player_name", function()
        o:publishPlayerInfo()
    end)
    o.im.Subscribe("bnd_player_ID", function()
        o:publishPlayerInfo()
    end)
    o.im.Subscribe("bnd_player_position", function()
        o:publishPlayerInfo()
    end)
    o.im.Subscribe("bnd_player_country", function()
        o:publishPlayerInfo()
    end)
    o.im.Subscribe("bnd_player_rating", function()
        o:publishPlayerInfo()
    end)
    o.im.Subscribe("bnd_3d_player", function()
        o:publishPlayerInfo()
    end)

    for i = 1, 6 do
        o.im.Subscribe("bnd_player_stat"..i, function()
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

function TeamRoster:publishVisible()
   self.im.Publish("bnd_visible", self.visible)
   self.im.Publish("bnd_loading_visible", not self.visible)
end

function TeamRoster:publishPlayerInfo(data)
    if data then 
        self.im.Publish("bnd_player_avatar", {
            name = "$Head",
            id = data.CARD_ID
        })
        self.im.Publish("bnd_player_name", data.playerName)
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
            self.im.Publish("bnd_player_stat"..i, data["label"..i]..": "..data["stat"..i])
        end
    end
end

-- 初始化数据
function TeamRoster:Init()
    local teamInfo = self.services.SquadManagementService.GetTeamInfo(TeamID)
    local teamLineup = self.services.SquadManagementService.GetCurrentPlayerLineup(0, TeamID, 0)
    do
        do
           -- for _FORV_6_, _FORV_7_ in ipairs(teamLineup) do
          for _FORV_16_ = 1, table.getn(teamLineup) do
                local obj = {
                    --assetId = _FORV_7_.CARD_ID,
                    assetId = teamLineup[_FORV_16_].CARD_ID,
                    clickAction = "act_player_select",
                    playerInfo = teamLineup[_FORV_16_],
                    data = {}
                }
                table.insert(PlayerListData, obj)
            end
        end
    end
end

function TeamRoster:publishPlayerRows()
  for i, v in ipairs(PlayerListData) do
    v.data.PlayerAvatar = {
      name = "$Head",
      id = PlayerListData[i].assetId
    }
    v.data.PlayerName = PlayerListData[i].playerInfo.playerName
    v.data.Rating = PlayerListData[i].playerInfo.rating
    v.data.clickAction = PlayerListData[i].clickAction
    v.data.FontColor = "0xffffff"
    v.data.Position = PlayerListData[i].playerInfo.position
    
  end
  self.im.Publish(bndPlayerList, PlayerListData)
    self.visible = true
    self:publishVisible()
    self:publishPlayerDetail({
        id = 0
    })
end

function TeamRoster:publishPlayerDetail(data)
    local playerIndex = data.id + 1
    local playerData = PlayerListData[playerIndex].playerInfo
    self:publishPlayerInfo(playerData)
    
end

function TeamRoster:finalize()
  self.im.Unsubscribe("bnd_main_bg")
  self.im.Unsubscribe("bnd_visible")
  self.im.Unsubscribe("bnd_loading_visible")
  self.im.Unsubscribe("bnd_team_crest")
  self.im.Unsubscribe("bnd_team_name")
  self.im.Unsubscribe("bnd_player_name")
  self.im.Unsubscribe("bnd_player_avatar")
  self.im.Unsubscribe("bnd_player_ID")
  self.im.Unsubscribe("bnd_player_position")
  self.im.Unsubscribe("bnd_player_country")
  self.im.Unsubscribe("bnd_player_rating")
  self.im.Unsubscribe("bnd_3d_player")
  for i = 1, 6 do
    self.im.Unsubscribe("bnd_player_stat"..i)
  end
  self.im.Unsubscribe(bndPlayerList)
  self.im.UnregisterAction(ACT_PLAYER_SELECT)
end

return TeamRoster