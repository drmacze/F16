local VirtualButton, EventManager = ...
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local AboutHub = {}
local bndGeneralAbout = "bnd_general_about"
local bndPrivacyAbout = "bnd_privacy_about"
local bndLicenseagreementAbout = "bnd_licenseagreement_about"
local bndDisableshareAbout = "bnd_disableshare_about"
local bndTermsofserviceAbout = "bnd_termsofservice_about"
local bndCreditsAbout = "bnd_credits_about"
local bndBackVisibility = "bnd_back_visibility"
local actToDisableshareTile = "act_to_disableshare_tile"
local actToPrivacyTile = "act_to_privacy_tile"
local actToLicenseagreementTile = "act_to_licenseagreement_tile"
local actToTermsofserviceTile = "act_to_termsofservice_tile"
local actToCreditsTile = "act_to_credits_tile"
local actToAboutTile = "act_to_about_tile"
local URL_BASE_EULA = "https://zhong_wei_peng.gitee.io/footballclub/en/update.html1"
local URL_BASE_IOS_EULA = "http://tos.ea.com/legalapp/mobileeula/US/%s/OTHER/"
local URL_BASE_TOS = "http://tos.ea.com/legalapp/WEBTERMS/US/%s/PC/"
local URL_BASE_PRIVACY = "http://tos.ea.com/legalapp/WEBPRIVACY/US/%s/PC/"
local URL_BASE_ABOUT = "https://zhong_wei_peng.gitee.io/footballclub/en/about.html1"
local URL_BASE_CREDITS = "http://www.ea.com/1/%s/fifa-mobile-credits/"
function AboutHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    HelpAndAboutService = o.api("HelpAndAboutService"),
    GameStateService = o.api("GameStateService"),
    BrowserService = o.api("BrowserService"),
    MiscService = o.api("MiscService")
  }
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end)
  o.hideButton = false
  o.overlayVisible = false
  o.im.Subscribe(bndGeneralAbout, function()
    o:publishGeneralAboutData()
  end)
  o.im.Subscribe(bndPrivacyAbout, function()
    o:publishPrivacyAboutData()
  end)
  o.im.Subscribe(bndLicenseagreementAbout, function()
    o:publishLicenseagreementAboutData()
  end)
  o.im.Subscribe(bndDisableshareAbout, function()
    o:publishDisableshareAboutData()
  end)
  o.im.Subscribe(bndTermsofserviceAbout, function()
    o:publishTermsofserviceAboutData()
  end)
  o.im.Subscribe(bndCreditsAbout, function()
    o:publishCreditsAboutData()
  end)
  o.im.Subscribe(bndBackVisibility, function()
    o:publishBackVisibility()
  end)
  o.im.RegisterAction(actToDisableshareTile, function(actionName, data)
    o:_openUsageSharingPopup()
  end)
  o.im.RegisterAction(actToPrivacyTile, function(actionName)
    o:openBrowser(actionName)
  end)
  o.im.RegisterAction(actToLicenseagreementTile, function(actionName)
    o:openBrowser(actionName)
  end)
  o.im.RegisterAction(actToTermsofserviceTile, function(actionName)
    o:openBrowser(actionName)
  end)
  o.im.RegisterAction(actToCreditsTile, function(actionName)
    o:openBrowser(actionName)
  end)
  o.im.RegisterAction(actToAboutTile, function(actionName)
    o:openBrowser(actionName)
  end)
  o.nav.AddActionHandler("showBackButton", false, nil, function(action, id)
    o.hideButton = false
    o.overlayVisible = false
    o:publishBackVisibility()
  end)
  o.languages = {
    EULA = {
      "en",
      "br",
      "sc",
      "cs",
      "da",
      "nl",
      "fi",
      "fr",
      "de",
      "hu",
      "it",
      "ja",
      "ko",
      "no",
      "pl",
      "ro",
      "ru",
      "es",
      "co",
      "sv",
      "tr"
    },
    TOSandPRIVACY = {
      "en",
      "sc",
      "tc",
      "nl",
      "fr",
      "de",
      "it",
      "ja",
      "ko",
      "pl",
      "br",
      "ru",
      "es",
      "th",
      "tr"
    }
  }
  o.lang = {
    EULA = "en",
    TOSandPRIVACY = "en",
    ABOUT = "en"
  }
  o:initLanguages()
  return o
end
function AboutHub:_handleEvent(eventType, data)
  if eventType == EVENT_TYPES.OnBackPressed then
    if self.overlayVisible then
      self.nav.Event(nil, "evt_close_browser")
      self.nav.Event(nil, "evt_hide_popup")
      self.overlayVisible = false
    else
      self.nav.Event(nil, "evt_back")
    end
  end
end
function AboutHub:initLanguages()
  local deviceCountry = self.services.GameStateService.GetCountry()
  local deviceLang = self.services.GameStateService.GetLang()
  local lang = "en"
  print("AboutHub:deviceCountry() " .. deviceCountry)
  print("AboutHub:deviceLang() " .. deviceLang)
  if deviceLang == "eng" then
    lang = "en"
  elseif deviceLang == "por" then
    if deviceCountry == "br" then
      lang = "br"
    else
      lang = "pt"
    end
  elseif deviceLang == "rus" then
    lang = "ru"
  elseif deviceLang == "spa" then
    lang = "es"
  elseif deviceLang == "tur" then
    lang = "tr"
  elseif deviceLang == "pol" then
    lang = "pl"
  elseif deviceLang == "fre" then
    lang = "fr"
  elseif deviceLang == "ger" then
    lang = "de"
  elseif deviceLang == "ita" then
    lang = "it"
  end
  self.lang.ABOUT = lang
  for i = 1, #self.languages.EULA do
    if self.languages.EULA[i] == lang then
      self.lang.EULA = lang
      break
    end
  end
  for i = 1, #self.languages.TOSandPRIVACY do
    if self.languages.TOSandPRIVACY[i] == lang then
      self.lang.TOSandPRIVACY = lang
      break
    end
  end
end
function AboutHub:openBrowser(actionName)
  if self.overlayVisible then
    return
  end
  if not self.services.MiscService.IsInternetConnectionAvailable() then
    self.nav.Event(nil, "evt_networkstatus_showpopup")
    return
  end
  local url = ""
  local homePageFile = true
  self.overlayVisible = true
  self.hideButton = true
  self:publishBackVisibility()
  if actionName == actToLicenseagreementTile then
    if self.services.GameStateService == 1 then
      url = string.format(URL_BASE_IOS_EULA, self.lang.EULA)
    else
      url = string.format(URL_BASE_EULA, self.lang.EULA)
    end
    homePageFile = false
  elseif actionName == actToTermsofserviceTile then
    url = string.format(URL_BASE_TOS, self.lang.TOSandPRIVACY)
    homePageFile = false
  elseif actionName == actToPrivacyTile then
    url = string.format(URL_BASE_PRIVACY, self.lang.TOSandPRIVACY)
    homePageFile = false
  elseif actionName == actToCreditsTile then
    url = string.format(URL_BASE_CREDITS, self.lang.TOSandPRIVACY)
    homePageFile = false
  elseif actionName == actToAboutTile then
    url = string.format(URL_BASE_ABOUT, self.lang.TOSandPRIVACY)
    homePageFile = false
  end
  print("AboutHub:openBrowser " .. url)
  if homePageFile then
    local urlTemp = ""
    self.services.BrowserService.SetHomePage(urlTemp)
    self.services.BrowserService.SetHomePageFile(url)
  else
    local temp = math.random(1, 100000)
    local link = url.."?temp="..temp
    self.services.BrowserService.SetHomePage(link)
  end
  self.nav.Event(nil, "evt_open_browser")
end
function AboutHub:publishGeneralAboutData()
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT")
  local subHeadlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_SUB")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = subHeadlineText,
    images = {
      "$GeneralAbout"
    }
  }
  self.im.Publish(bndGeneralAbout, dataToInsert)
end
function AboutHub:publishPrivacyAboutData(actionName)
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_PRIVACY_COOKIE")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = "",
    images = {
      "$PrivacyAbout"
    }
  }
  self.im.Publish(bndPrivacyAbout, dataToInsert)
end
function AboutHub:publishLicenseagreementAboutData(actionName)
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_EULA")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = "",
    images = {"$EULAAbout"}
  }
  self.im.Publish(bndLicenseagreementAbout, dataToInsert)
end
function AboutHub:publishDisableshareAboutData()
  local titleText = self.loc.LocalizeString("LTXT_MOB_ABOUT_ENABLE_SHARE")
  local usageSharing = self.services.HelpAndAboutService.GetUsageSharing()
  if usageSharing then
    titleText = self.loc.LocalizeString("LTXT_MOB_ABOUT_DISABLE_SHARE")
    messageText = self.loc.LocalizeString("LTXT_MOB_DATA_DISABLE_SHARE")
  end
  local headlineText = titleText
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = "",
    images = {
      "$ShareUsageAbout"
    }
  }
  self.im.Publish(bndDisableshareAbout, dataToInsert)
end
function AboutHub:publishTermsofserviceAboutData(actionName)
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_TOS")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = "",
    images = {
      "$TermsAbout"
    }
  }
  self.im.Publish(bndTermsofserviceAbout, dataToInsert)
end
function AboutHub:publishCreditsAboutData()
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_CREDITS")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = "",
    images = {
      "$CreditsAbout"
    }
  }
  self.im.Publish(bndCreditsAbout, dataToInsert)
end
function AboutHub:publishBackVisibility()
  self.im.Publish(bndBackVisibility, self.hideButton)
end
function AboutHub:_openUsageSharingPopup()
  if self.overlayVisible then
    return
  end
  local usageSharing = self.services.HelpAndAboutService.GetUsageSharing()
  local titleText = "Desativar compartilhamento"
  local messageText = self.loc.LocalizeString("LTXT_MOB_DATA_ENABLE_SHARE")
  local buttonCancel = VirtualButton:new({
    nav = self.nav,
    icon = "",
    label = "Cancelar",
    clickEvents = {
      "evt_hide_popup"
    }
  })
  local buttonOK = VirtualButton:new({
    nav = self.nav,
    icon = "",
    label = "Confirmar",
    clickEvents = {
      "evt_hide_popup"
    }
  })
  if usageSharing then
    titleText = "Desativar compartilhamento"
    messageText = self.loc.LocalizeString("LTXT_MOB_DATA_DISABLE_SHARE")
  end
  if usageSharing then
    usageSharing = false
  else
    usageSharing = true
  end
  self.overlayVisible = true
  function buttonOK.clickCallback()
    self.services.HelpAndAboutService.SetUsageSharing(usageSharing)
    self:publishDisableshareAboutData()
    self.overlayVisible = false
  end
  function buttonCancel.clickCallback()
    self.overlayVisible = false
  end
  local popupMessageObject = {}
  popupMessageObject.localized = true
  popupMessageObject.message = messageText
  local popupData = {
    title = titleText,
    message = popupMessageObject,
    buttons = {buttonCancel, buttonOK},
    loader = false
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end
function AboutHub:finalize()
  print("AboutHub:finalize()")
  self.im.Unsubscribe(bndGeneralAbout)
  self.im.Unsubscribe(bndPrivacyAbout)
  self.im.Unsubscribe(bndLicenseagreementAbout)
  self.im.Unsubscribe(bndDisableshareAbout)
  self.im.Unsubscribe(bndTermsofserviceAbout)
  self.im.Unsubscribe(bndCreditsAbout)
  self.im.Unsubscribe(bndBackVisibility)
  self.im.UnregisterAction(actToDisableshareTile)
  self.im.UnregisterAction(actToPrivacyTile)
  self.im.UnregisterAction(actToLicenseagreementTile)
  self.im.UnregisterAction(actToTermsofserviceTile)
  self.im.UnregisterAction(actToCreditsTile)
  self.im.UnregisterAction(actToAboutTile)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  self.nav.RemoveActionHandler("showBackButton")
end
return AboutHub
