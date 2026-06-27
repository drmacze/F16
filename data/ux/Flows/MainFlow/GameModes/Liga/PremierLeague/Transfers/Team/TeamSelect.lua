-- Mod By MVN PROD --
-- League Mode Devision --

local TeamSelect = {}
local bndTeamList = "bnd_team_list"
local ACT_TEAM_SELECT = "act_team_select"

local TeamListData = {}

ligaId = 1
GLOBAL_TEAMBUY = nil
------------------------------------------------------------------------------------------
local function shuffleArray(array)
  math.randomseed(os.time()) -- Initialize random seed
  for i = #array, 2, -1 do
    local j = math.random(i)
    array[i], array[j] = array[j], array[i]
  end
end
Epl = {1,2,7,5,9,10,11,13,14,18,19,110,144,1799,1808,1943,1925,94,17,95}
Ligue = { 69,1815,217,68,71,1738,65,70,72,66,219,73,64,76,378,379,74,1809 }
Laliga = { 448,240,479,1968,450,463,241,1860,110062,110832,480,453,449,243,457,481,1861,472,461,483 }
SerieA = { 111811, 39, 189, 1842, 1746, 110374, 111657, 110556, 206, 44, 45, 46, 347, 47, 48, 52, 110373, 111974, 54, 55 }
shuffleArray(TeamList)
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

function TeamSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SquadManagementService = o.api("SquadMgtService")
  }
   o.visible = false
   o.im.Subscribe("bnd_visible", function()
     o:publishVisible()
  end)
  o.im.Subscribe("bnd_loading_visible", function()
     o:publishVisible()
  end)
  if GLOBAL_TEAMBUY ~= nil then
   
   o.nav.Event(nil, "evt_back")
  else
    o.visible = true
    o:publishVisible()
    o:Init()
    o.im.Subscribe(bndTeamList, function()
      o:publishTeamRows()
    end)
    o.im.RegisterAction(ACT_TEAM_SELECT, function(actionName, data)
            if data then
                o:StartLiga(data)
                GLOBAL_TEAMBUY = TeamListData[data.id + 1].assetId -- Set the selected team ID
            end
        end)
    end
    return o
end

function TeamSelect:publishVisible()
   self.im.Publish("bnd_visible", self.visible)
   self.im.Publish("bnd_loading_visible", not self.visible)
end

-- Initialize data
function TeamSelect:Init()
  -- Determine which league array to use based on GLOBAL_LEAGUE
  local leagueArray = nil

  if GLOBAL_LEAGUE == 2 then
    leagueArray = Laliga
  elseif GLOBAL_LEAGUE == 4 then
    leagueArray = Ligue
  elseif GLOBAL_LEAGUE == 3 then
    leagueArray = SerieA
  else
    leagueArray = Epl -- Default to Epl if GLOBAL_LEAGUE doesn't match
  end

  -- Populate TeamListData with the selected league array
  for i = 1, table.getn(leagueArray) do
    local teamInfo = self.services.SquadManagementService.GetTeamInfo(TeamList[i])
    local obj = {
      assetId = leagueArray[i], -- Use the selected league array
      clickAction = "act_team_select",
      teamName = self.loc.LocalizeString("TeamName_Abbr15_"..leagueArray[i]),
      shortTeamName = self.loc.LocalizeString("TeamName_Abbr3_"..leagueArray[i]),
      data = {},
      rating = teamInfo.starRating
    }
    table.insert(TeamListData, obj)
  end
end


function TeamSelect:publishTeamRows()
  for i, v in ipairs(TeamListData) do
    v.data.TeamCrest = {
      name = "$Crest",
      id = TeamListData[i].assetId
    }
    v.data.TeamName = TeamListData[i].teamName
    v.data.Rating = TeamListData[i].rating
    v.data.clickAction = TeamListData[i].clickAction
    v.data.FontColor = "0xffffff"
    v.data.TeamNameFontColor = "0xffffff"
    v.data.Icon = {
       name = "$IconMatchBall",
       id = 2
    }
    v.data.RightText = "PLAY"
  end
  self.im.Publish(bndTeamList, TeamListData)
end

function TeamSelect:StartLiga(data)
  local currentTeamIndex = data.id + 1

  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Confirm",
    clickEvents = {
      "evt_hide_popup",
      "evt_player"
    }
  }
  
  
  local popupData = {
    title = "INFO",
    message = "Views"..TeamListData[currentTeamIndex].teamName.." To Transfer Player ?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function TeamSelect:finalize()
  self.im.Unsubscribe("bnd_visible")
  self.im.Unsubscribe("bnd_loading_visible")
  self.im.Unsubscribe(bndTeamList)
  self.im.UnregisterAction(ACT_TEAM_SELECT)
  TeamListData = {}
end

return TeamSelect

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --
