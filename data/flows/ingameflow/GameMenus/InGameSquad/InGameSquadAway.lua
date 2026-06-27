-- REMOD BY YOUTUBE LAOSIJI --
local InGameTeamManagementModel, VirtualButton, CommonEnums, EventManager = ...
local SQUAD_VALIDATION_ERRORS = CommonEnums.SquadValidationErrors
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local InGameSquad = {}
local ACT_ADVANCE = "act_advance"
local ACT_BACK = "act_back"
function InGameSquad:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.models = {
    InGameTeamManagementModel = InGameTeamManagementModel:new({
      im = o.im,
      api = o.api,
      loc = o.loc,
      nav = o.nav,
      gamemode = o.data.gamemode,
      flowState = o.data.flowState
    })
  }
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    ScreenInfoService = o.api("ScreenInfoService")
  }
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end
  )
  o.im.RegisterAction(ACT_ADVANCE, function(actionName, data)
    local squadValidError = o.models.InGameTeamManagementModel:validateSquad()
    if squadValidError == SQUAD_VALIDATION_ERRORS.SquadValidationNoError then
      o.models.InGameTeamManagementModel:saveSquad()
      o.nav.Event(nil, "evt_advance")
    else
      o:showInvalidSquadPopup(squadValidError)
    end
  end
  )
  o.im.RegisterAction(ACT_BACK, function(actionName, data)
    local squadValidError = o.models.InGameTeamManagementModel:validateSquad()
    if squadValidError == SQUAD_VALIDATION_ERRORS.SquadValidationNoError then
      local buttonNo = VirtualButton:new({
        nav = o.nav,
        label = "Cancel",
        icon = "$FooterIconNo",
        clickEvents = {
          "evt_hide_popup"
        }
      })
      local buttonYes = VirtualButton:new({
        nav = o.nav,
        label = "Confirm",
        icon = "$FooterIconYes",
        clickEvents = {
          "evt_back",
          "evt_hide_popup"
        }
      })
      local popupData = {
        title = "WARNING",
        message = "Are you sure you want to return without saving? All lineup adjustments will be lost",
        buttons = {buttonNo, buttonYes}
      }
      o.nav.Event(nil, "evt_show_popup", popupData)
    else
      o:showInvalidSquadPopup(squadValidError)
    end
  end
  )
  return o
end

function InGameSquad:showInvalidSquadPopup(squadValidError)
  local errorMsg = ""
  local buttonYes = VirtualButton:new({
    nav = self.nav,
    label = "OK",
    clickEvents = {
      "evt_hide_popup"
    }
  })
  if squadValidError == SQUAD_VALIDATION_ERRORS.SquadValidationGKRedcarded then
    errorMsg = "There is a red card player in your goalkeeper position. Before continuing, please replace him to another location"
  elseif squadValidError == SQUAD_VALIDATION_ERRORS.SquadValidationInjuredPlayerOnFormation then
    errorMsg = "One of your starting 11 players has been injured. Please replace him before continuing"
  end
  local popupData = {
    title = "WARNING",
    message = errorMsg,
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function InGameSquad:_handleEvent(eventType, data)
  if eventType == EVENT_TYPES.OnUnpause then
    self.models.InGameTeamManagementModel:forceSubstitution()
  elseif eventType == EVENT_TYPES.OnBackPressed then
    local screenName = self.services.ScreenInfoService.GetCurrentScreenName()
    print("[InGameSquad]: handleEvent: GetCurrentScreenName: " .. tostring(screenName))
    if screenName == "GenericPopup" then
      self.nav.Event(nil, "evt_hide_popup")
    else
      self.models.InGameTeamManagementModel:forceSubstitution()
      self.nav.Event(nil, "evt_back")
      self.nav.Event(nil, "evt_hide_popup")
    end
  end
end

function InGameSquad:finalize()
  self.models.InGameTeamManagementModel:finalize()
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  self.im.UnregisterAction(ACT_BACK)
  self.im.UnregisterAction(ACT_ADVANCE)
end

return InGameSquad
