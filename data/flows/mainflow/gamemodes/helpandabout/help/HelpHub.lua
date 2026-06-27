-- REMOD BY YOUTUBE LAOSIJI --
local HelpHub = {}
local eventmanager = (...)
local EVENT_TYPES = eventmanager.FE.FIFA.EventTypes
local bndGeneralHelp = "bnd_general_help"
local bndControlsHelp = "bnd_controls_help"
local bndSimulationHelp = "bnd_simulation_help"
local BND_CUSTOMER_EXPERIENCE_HELP = "bnd_customer_experience_help"
local BND_BACK_VISIBILITY = "bnd_back_visibility"
local ACT_TO_CUSTOMER_EXPERIENCE = "act_to_customer_experience"
function HelpHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    GameStateService = o.api("GameStateService"),
    BrowserService = o.api("BrowserService"),
    MiscService = o.api("MiscService")
  }
  o.hideButton = false
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end
  )
  o.im.Subscribe(bndGeneralHelp, function()
    o:publishGeneralHelpData()
  end
  )
  o.im.Subscribe(bndControlsHelp, function()
    o:publishControlsHelpData()
  end
  )
  o.im.Subscribe(bndSimulationHelp, function()
    o:publishSimulationHelpData()
  end
  )
  o.im.Subscribe(BND_CUSTOMER_EXPERIENCE_HELP, function()
    o:publishCustomerExperienceHelpData()
  end
  )
  o.im.Subscribe(BND_BACK_VISIBILITY, function()
    o:publishBackVisibility()
  end
  )
  o.im.RegisterAction(ACT_TO_CUSTOMER_EXPERIENCE, function()
    o:goToCustomerExperience()
  end
  )
  o.nav.AddActionHandler("showBackButton", false, nil, function(action, id)
    o.hideButton = false
    o.overlayVisible = false
    o:publishBackVisibility()
  end
  )
  return o
end

function HelpHub:publishGeneralHelpData()
  local headlineText = self.loc.LocalizeString("LTXT_MOB_HELP_GENERAL_HELP")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = "",
    images = {
      "$general_help"
    }
  }
  self.im.Publish(bndGeneralHelp, dataToInsert)
end

function HelpHub:publishControlsHelpData()
  local dataToInsert = {
    headline = {"AJUDA COM CONTROLES"},
    subHeadline = "",
    images = {
      "$controls_help"
    }
  }
  self.im.Publish(bndControlsHelp, dataToInsert)
end

function HelpHub:publishSimulationHelpData()
  local headlineText = self.loc.LocalizeString("LTXT_MOB_HELP_SIMULATION")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = "",
    images = {
      "$simulation_help"
    }
  }
  self.im.Publish(bndSimulationHelp, dataToInsert)
end

function HelpHub:publishCustomerExperienceHelpData()
  local headlineText = self.loc.LocalizeString("LTXT_MOB_HELP_CUSTOMER_EXPERIENCE")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = "",
    images = {
      "$customer_experience_help"
    }
  }
  self.im.Publish(BND_CUSTOMER_EXPERIENCE_HELP, dataToInsert)
end

function HelpHub:goToCustomerExperience()
  self.nav.Event(nil, "evt_show_blocking_load")
  self.services.MiscService.RequestCustomerSupportURL()
end

function HelpHub:publishBackVisibility()
  print("publishing BND_BACK_VISIBILITY - ", self.hideButton)
  self.im.Publish(BND_BACK_VISIBILITY, self.hideButton)
end

function HelpHub:openBrowser(url)
  if self.overlayVisible then
    return
  end
  self.overlayVisible = true
  self.hideButton = true
  self:publishBackVisibility()
  self.services.BrowserService.SetHomePage(url)
  self.nav.Event(nil, "evt_open_browser")
end

function HelpHub:_handleEvent(eventType, data)
  print("[HelpHub]:_handleEvent event type =" .. tostring(eventType))
  if eventType == EVENT_TYPES.CustomerExperienceURLReady then
    self.nav.Event(nil, "evt_hide_blocking_load")
    self:openBrowser(data.url)
  elseif eventType == EVENT_TYPES.OnBackPressed then
    if self.overlayVisible then
      self.nav.Event(nil, "evt_close_browser")
      self.nav.Event(nil, "evt_hide_popup")
      self.overlayVisible = false
    else
      self.nav.Event(nil, "evt_back")
    end
  end
end

function HelpHub:finalize()
  print("HelpHub:finalize()")
  self.im.Unsubscribe(bndGeneralHelp)
  self.im.Unsubscribe(bndControlsHelp)
  self.im.Unsubscribe(bndSimulationHelp)
  self.im.Unsubscribe(BND_CUSTOMER_EXPERIENCE_HELP)
  self.im.Unsubscribe(BND_BACK_VISIBILITY)
  self.im.UnregisterAction(ACT_TO_CUSTOMER_EXPERIENCE)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  self.nav.RemoveActionHandler("showBackButton")
end

return HelpHub
-- REMOD BY YOUTUBE LAOSIJI --