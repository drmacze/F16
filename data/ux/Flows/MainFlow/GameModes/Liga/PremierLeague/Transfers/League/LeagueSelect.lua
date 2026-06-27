-- Mod By MVN PROD --
-- League Mode Devision --

local LeagueSelect = {}
local bndTeamList = "bnd_team_list"
local ACT_TEAM_SELECT = "act_team_select"

local TeamListData = {}

ligaId = 1
GLOBAL_LEAGUE = nil
------------------------------------------------------------------------------------------
local function shuffleArray(array)
  math.randomseed(os.time()) -- Initialize random seed
  for i = #array, 2, -1 do
    local j = math.random(i)
    array[i], array[j] = array[j], array[i]
  end
end
TeamList = { 1,2,7,5,9,10,11,13,14,18,19,110,1794,1796,1923,144,1799,1808,1943,1925 }
shuffleArray(TeamList)
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

function LeagueSelect:new(init)
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
  if GLOBAL_LEAGUE ~= nil then   
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
      end
    end)
  end
  return o
end

function LeagueSelect:publishVisible()
   self.im.Publish("bnd_visible", self.visible)
   self.im.Publish("bnd_loading_visible", not self.visible)
end

-- Initialize data
function LeagueSelect:Init()
  for i = 1, table.getn(TeamList) do
    local teamInfo = self.services.SquadManagementService.GetTeamInfo(TeamList[i])
    local obj = {
      assetId = TeamList[i],
      clickAction = "act_team_select",
      teamName = self.loc.LocalizeString("TeamName_Abbr15_"..TeamList[i]),
      shortTeamName = self.loc.LocalizeString("TeamName_Abbr3_"..TeamList[i]),
      data = {},
      rating = teamInfo.starRating
    }
    table.insert(TeamListData, obj)
  end
end


function LeagueSelect:publishTeamRows()
  -- Define a hardcoded list of league names
  leagues = {
    {teamName = "Premier League", crest = "$l13"},
    {teamName = "Laliga", crest = "$l53"},
    {teamName = "Serie A", crest = "$l31"},
    {teamName = "Ligue 1", crest = "$l16"},
    {teamName = "Bundesliga", crest = "$l19"}
  }

  -- Create the data structure for each league row
  for i, league in ipairs(leagues) do
    league.data = {}
    league.data.TeamCrest = {
      name = league.crest,  -- Use the crest from the league data
      id = i -- Use the index as the ID
    }
    league.data.TeamName = leagues[i].teamName -- Keep the league name unchanged
    league.data.Rating = "N/A" -- No ratings for leagues
    league.data.clickAction = "act_team_select" -- Example action when a row is clicked
    league.data.FontColor = "0xffffff"
    league.data.TeamNameFontColor = "0xffffff"
    league.data.Icon = {
      name = "$IconMatchBall",
      id = i -- Use the index as the ID for the icon
    }
    league.data.RightText = "SELECT" -- Change "PLAY" to "SELECT" for leagues
  end

  -- Publish the league list to the UI
  self.im.Publish(bndTeamList, leagues)
end

function LeagueSelect:StartLiga(data)
  local currentTeamIndex = data.id + 1
  GLOBAL_LEAGUE = currentTeamIndex

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
      "evt_team"
    }
  }
  
  
  local popupData = {
    title = "INFO",
    message = "Proceed with "..leagues[currentTeamIndex].teamName.." ?",
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function LeagueSelect:finalize()
  self.im.Unsubscribe("bnd_visible")
  self.im.Unsubscribe("bnd_loading_visible")
  self.im.Unsubscribe(bndTeamList)
  self.im.UnregisterAction(ACT_TEAM_SELECT)
  TeamListData = {}
end

return LeagueSelect

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --
