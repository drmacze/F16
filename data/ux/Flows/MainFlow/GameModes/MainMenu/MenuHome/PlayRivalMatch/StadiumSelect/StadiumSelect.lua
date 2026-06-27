-- MOD BY LAOSIJI --
local StadiumSelect = {}
local bndHomeTeamCrest = "bnd_home_team_crest"
local bndAwayTeamCrest = "bnd_away_team_crest"
local bndStadiumName = "bnd_stadium_name"
local bndStadiumBg = "bnd_stadium_bg"
local actAdvance = "act_advance"
local actBack = "act_back"
local actStadiumPrevious = "act_stadium_previous"
local actStadiumNext = "act_stadium_next"

function StadiumSelect:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    matchInfo = o.api("MatchInfoService"),
    settingsService = o.api("SettingsService"),
    UserPlate = o.api("UserPlateService"),
    MatchSetup = o.api("MatchSetupService"),
    GameSetup = o.api("GameSetupService"),
    GameState = o.api("GameStateService"),
    Pregame = o.api("PregameService"),
    LoggingService = o.api("LoggingService"),
    ClientServerService = o.api("ClientServerService"),
    EventManagerService = o.api("EventManagerService"),
    SaveLoadService = o.api("SaveLoadService")
  }

  o.homeTeamID = currentMatch.HomeTeamID
  o.awayTeamID = currentMatch.AwayTeamID

  o.currentStadium = {
    name = "",
    bg = {
      name = "$StadiumBackground",
      id = 0
    }
  }

  o:initOptions()


  o.im.Subscribe(bndHomeTeamCrest, function()
    o:publishHomeCrest()
  end
  )
  o.im.Subscribe(bndAwayTeamCrest, function()
    o:publishAwayCrest()
  end
  )

  o.im.Subscribe(bndStadiumName, function()
    o:publishStadiumName()
  end
  )

  o.im.Subscribe(bndStadiumBg, function()
    o:publishStadiumBg()
  end
  )
  
  o.im.RegisterAction(actStadiumPrevious, function(actionName)
    o:changePreviousStadium()
  end
  )
  o.im.RegisterAction(actStadiumNext, function(actionName)
    o:changeNextStadium()
  end
  )
  
  return o
end

function StadiumSelect:initOptions()
  local currentHomeTeam = currentMatch.HomeTeamID
  if currentHomeTeam == self.awayTeamID then
    self.currentStadium.bg.id = currentMatch.StadiumID2
  elseif currentHomeTeam == self.homeTeamID then
    self.currentStadium.bg.id = currentMatch.StadiumID1
  end
  
  self.currentStadium.name = self.loc.LocalizeString("StadiumName_"..self.currentStadium.bg.id)
end

function StadiumSelect:publishHomeCrest()
  self.im.Publish(bndHomeTeamCrest, {
    name = "$Crest",
    id = currentMatch.HomeTeamID
  })
end

function StadiumSelect:publishAwayCrest()
  self.im.Publish(bndAwayTeamCrest, {
    name = "$Crest",
    id = currentMatch.AwayTeamID
  })
end


function StadiumSelect:publishStadiumName()
  self.im.Publish(bndStadiumName, self.currentStadium.name)
end

function StadiumSelect:publishStadiumBg()
  self.im.Publish(bndStadiumBg, self.currentStadium.bg)
end

function StadiumSelect:changePreviousStadium()
  local currentHomeTeam = currentMatch.HomeTeamID
  if currentHomeTeam == self.awayTeamID then
    currentMatch.HomeTeamID = self.homeTeamID
    currentMatch.AwayTeamID = self.awayTeamID
  elseif currentHomeTeam == self.homeTeamID then
    currentMatch.HomeTeamID = self.awayTeamID
    currentMatch.AwayTeamID = self.homeTeamID
  end
  self:publishHomeCrest()
  self:publishAwayCrest()
  self:initOptions()
  self:publishStadiumName()
  self:publishStadiumBg()
end

function StadiumSelect:changeNextStadium()
  local currentHomeTeam = currentMatch.HomeTeamID
  if currentHomeTeam == self.awayTeamID then
    currentMatch.HomeTeamID = self.homeTeamID
    currentMatch.AwayTeamID = self.awayTeamID
  elseif currentHomeTeam == self.homeTeamID then
    currentMatch.HomeTeamID = self.awayTeamID
    currentMatch.AwayTeamID = self.homeTeamID
  end
  self:publishHomeCrest()
  self:publishAwayCrest()
  self:initOptions()
  self:publishStadiumName()
  self:publishStadiumBg()
end



function StadiumSelect:finalize()
  self.im.Unsubscribe(bndHomeTeamCrest)
  self.im.Unsubscribe(bndAwayTeamCrest)
  self.im.Unsubscribe(bndStadiumName)
  self.im.Unsubscribe(bndStadiumBg)
  self.im.UnregisterAction(actAdvance)
  self.im.UnregisterAction(actBack)
  self.im.UnregisterAction(actStadiumPrevious)
  self.im.UnregisterAction(actStadiumNext)
end

return StadiumSelect