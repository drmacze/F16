-- Patch By Ma'ruf ID YouTube --
local TableUtil, FormationModel, OverlaysIdContainer, OverlayParam, eventmanager = ...
local Starting11 = {}
local OVERLAY_TYPES = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes
function Starting11:new(init)
  print("[Starting11]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    TacticsService = o.api("TacticsService"),
    SquadManagementService = o.api("SquadMgtService"),
    eventManService = o.api("EventManagerService"),
    MatchInfoService = o.api("MatchInfoService")
  }
  o.handlerId = o.services.eventManService.RegisterHandler(function(...)
    o:handleEvent(...)
  end
  )
  o.gamemode = o.data.gamemode or "real"
  o.flow = o.data.flow or "offline"
  o.playerLineup = nil
  o.isActive = false
  o.isVisible = false
  o.models = {
    FormationModel = FormationModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      gamemode = o.gamemode
    })
  }
    o.crest = {
    name = "$Crest",
    id = 0
  }
  
  o.im.Subscribe("bnd_active", function()
    o:_publishActivity()
  end)

  o.im.Subscribe("bnd_team_crest", function()
    o:_publishTeamCrest()
  end)

  o.im.Subscribe("bnd_player_lineup", function()
    o:_publishPlayerLineup()
  end)
  
  return o
end

function Starting11:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeIntroSequenceTeamList then
    self:updatePlayerLineup(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function Starting11:updatePlayerLineup(subtype, hideshow, subtypestr, msg)
  print("[Starting11]: updatePlayerLineup(subtype = " .. tostring(subtype) .. ", hideshow = " .. tostring(hideshow) .. ", subtypestr = " .. tostring(subtypestr) .. ", msg = " .. tostring(msg) .. ")")
  if hideshow ~= "HIDE" then
    self.isActive = true
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      local teamSide = tonumber(params[5])
      local teamID = tonumber(params[3])
      local lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(teamSide, teamID, 4)
      local formationID = self.services.TacticsService.GetFormation(teamSide, teamID)
      local formation = self.models.FormationModel:getFormationByID(formationID)
      local formationCoords = formation.coords
      local formationName = formation.name
      self.playerLineup = {
        starting11Label = "STARTING 11",
        subsLabel = "SUBSTITUTE",
        players = {},
        teamID = params[1],
        teamName = params[2],
        formationName = formationName
      }
      for i = 1, table.getn(lineup) do
        self.playerLineup.players[i] = {}
        self.playerLineup.players[i].name = lineup[i].playerName
        self.playerLineup.players[i].number = lineup[i].jerseyNumber
        self.playerLineup.players[i].hasYellowCard = false
        if i <= 11 then
          self.playerLineup.players[i].coords = formationCoords[i]
          self.playerLineup.players[i].jerseyColor = "0x00FF00"
        end
      end
      self.crest.id= params[1]
      self:_publishPlayerLineup()
      self:_publishTeamCrest()
    end
  else
    self.isActive = false
  end
  self:_publishActivity()
end

function Starting11:_publishActivity()
  self.im.Publish("bnd_active", self.isActive)
end

function Starting11:_publishTeamCrest()
  self.im.Publish("bnd_team_crest", self.crest)
end

function Starting11:_publishPlayerLineup()
  if self.playerLineup == nil then
    return
  end
  self.im.Publish("bnd_player_lineup", self.playerLineup)
end

function Starting11:finalize()
  print("[Starting11]: finalize()")
  self.models.FormationModel:finalize()
  self.im.Unsubscribe("bnd_active")
  self.im.Unsubscribe("bnd_team_crest")
  self.im.Unsubscribe("bnd_player_lineup")
  self.services.eventManService.UnregisterHandler(self.handlerId)
end

return Starting11