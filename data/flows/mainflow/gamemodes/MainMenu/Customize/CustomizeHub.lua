local VirtualButton, EventManager = ...
local CustomizeHub = {}
local BND_LIVE_TILE_SETTINGS = "bnd_live_tile_settings"
local BND_LIVE_TILE_EASPORTSTRACK = "bnd_live_tile_easportstrack"
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
local actToMusicTile = "act_to_music_tile"
local actToInfoTile = "act_to_info_tile"
local actToUpdateTile = "act_to_update_tile"
local URL_BASE_EULA = "https://zhong_wei_peng.gitee.io/footballclub/en/update.html"
local URL_BASE_IOS_EULA = "http://tos.ea.com/legalapp/mobileeula/US/%s/OTHER/"
local URL_BASE_TOS = "http://tos.ea.com/legalapp/WEBTERMS/US/%s/PC/"
local URL_BASE_PRIVACY = "http://tos.ea.com/legalapp/WEBPRIVACY/US/%s/PC/"
local URL_BASE_ABOUT = "https://zhong_wei_peng.gitee.io/footballclub/en/about.html"
local URL_BASE_CREDITS = "http://www.ea.com/1/%s/fifa-mobile-credits/"

local BND_TAB1_VISIBLE = "bnd_tab1_visible"
local BND_TAB2_VISIBLE = "bnd_tab2_visible"
local BND_TAB3_VISIBLE = "bnd_tab3_visible"
local BND_TAB4_VISIBLE = "bnd_tab4_visible"
local BND_TAB5_VISIBLE = "bnd_tab5_visible"
local BND_TAB6_VISIBLE = "bnd_tab6_visible"
local BND_TAB7_VISIBLE = "bnd_tab7_visible"
local BND_TAB8_VISIBLE = "bnd_tab8_visible"
local ACT_BTN_CLICK = "act_btn_click"
local TAB1 = 1
local TAB2 = 2
local TAB3 = 3
local TAB4 = 4
local TAB5 = 5
local TAB6 = 6
local TAB7 = 7
local TAB8 = 8

function CustomizeHub:new(init)
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

  o.im.Subscribe(BND_LIVE_TILE_SETTINGS, function()
    o:BND_LIVE_TILE_SETTINGS()
  end)
  function CustomizeHub:BND_LIVE_TILE_SETTINGS()
    local dataToInsert =
    {
      headline = { "SETTINGS" }
    }
    self.im.Publish(BND_LIVE_TILE_SETTINGS, dataToInsert)
  end

  o.im.Subscribe(BND_LIVE_TILE_EASPORTSTRACK, function()
    o:BND_LIVE_TILE_EASPORTSTRACK()
  end)
  function CustomizeHub:BND_LIVE_TILE_EASPORTSTRACK()
    local dataToInsert =
    {
      headline = { "MUSIC" }
    }
    self.im.Publish(BND_LIVE_TILE_EASPORTSTRACK, dataToInsert)
  end

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
    -- o:openBrowser(actionName)
    o.nav.Event(nil, "evt_team_roster")
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
  o.im.RegisterAction(actToMusicTile, function(actionName)
    o:_openMusicPopup(actionName)
  end)
  o.im.RegisterAction(actToInfoTile, function(actionName)
    o:_openInfoPopup(actionName)
  end)
  o.im.RegisterAction(actToUpdateTile, function(actionName)
    o:_openUpdatePopup(actionName)
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
  
  o.buttonsID = { TAB1, TAB2, TAB3, TAB4, TAB5, TAB6, TAB7, TAB8 }
  o.im.Subscribe(BND_TAB1_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB2_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB3_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB4_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB5_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB6_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB7_VISIBLE, function()
  end)
  o.im.Subscribe(BND_TAB8_VISIBLE, function()
  end)
  o:HideSelections()
  o.im.Publish(BND_TAB1_VISIBLE, true)
  o.im.RegisterAction(ACT_BTN_CLICK, function(actionName, data)
    o:HideSelections()
    if o.buttonsID[data.buttonID + 1] == TAB1 then
      o.im.Publish(BND_TAB1_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB2 then
      o.im.Publish(BND_TAB2_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB3 then
      o.im.Publish(BND_TAB3_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB4 then
      o.im.Publish(BND_TAB4_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB5 then
      o.im.Publish(BND_TAB5_VISIBLE, true)
      elseif o.buttonsID[data.buttonID + 1] == TAB6 then
      o.im.Publish(BND_TAB6_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB7 then
      o.im.Publish(BND_TAB7_VISIBLE, true)
    elseif o.buttonsID[data.buttonID + 1] == TAB8 then
      o.im.Publish(BND_TAB8_VISIBLE, true)
    end
  end)
  
  return o
end

function CustomizeHub:_handleEvent(eventType, data)
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
function CustomizeHub:initLanguages()
  local deviceCountry = self.services.GameStateService.GetCountry()
  local deviceLang = self.services.GameStateService.GetLang()
  local lang = "en"
  print("CustomizeHub:deviceCountry() " .. deviceCountry)
  print("CustomizeHub:deviceLang() " .. deviceLang)
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
function CustomizeHub:openBrowser(actionName)
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
  print("CustomizeHub:openBrowser " .. url)
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
function CustomizeHub:publishGeneralAboutData()
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT")
  local subHeadlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_SUB")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = subHeadlineText
  }
  self.im.Publish(bndGeneralAbout, dataToInsert)
end
function CustomizeHub:publishPrivacyAboutData(actionName)
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_PRIVACY_COOKIE")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = ""
  }
  self.im.Publish(bndPrivacyAbout, dataToInsert)
end
function CustomizeHub:publishLicenseagreementAboutData(actionName)
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_EULA")
  local dataToInsert = {
    headline = {"SQUAD"},
    subHeadline = ""
  }
  self.im.Publish(bndLicenseagreementAbout, dataToInsert)
end
function CustomizeHub:publishDisableshareAboutData()
  local titleText = self.loc.LocalizeString("LTXT_MOB_ABOUT_ENABLE_SHARE")
  local usageSharing = self.services.HelpAndAboutService.GetUsageSharing()
  if usageSharing then
    titleText = self.loc.LocalizeString("LTXT_MOB_ABOUT_DISABLE_SHARE")
    messageText = self.loc.LocalizeString("LTXT_MOB_DATA_DISABLE_SHARE")
  end
  local headlineText = titleText
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = ""
  }
  self.im.Publish(bndDisableshareAbout, dataToInsert)
end
function CustomizeHub:publishTermsofserviceAboutData(actionName)
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_TOS")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = ""
  }
  self.im.Publish(bndTermsofserviceAbout, dataToInsert)
end
function CustomizeHub:publishCreditsAboutData()
  local headlineText = self.loc.LocalizeString("LTXT_MOB_ABOUT_CREDITS")
  local dataToInsert = {
    headline = {headlineText},
    subHeadline = ""
  }
  self.im.Publish(bndCreditsAbout, dataToInsert)
end
function CustomizeHub:publishBackVisibility()
  self.im.Publish(bndBackVisibility, self.hideButton)
end
function CustomizeHub:_openMusicPopup()
  local titleText = "MUSICS"
  local messageText = "Slaptop - Sunrise.\nJungle - Busy Earnin."
  local buttonClose = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = titleText,
    message = messageText,
    buttons = {buttonClose}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end
function CustomizeHub:_openInfoPopup()
  local titleText = "INFO"
  local messageText = "Not Available"
  local buttonClose = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = titleText,
    message = messageText,
    buttons = {buttonClose}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end
function CustomizeHub:_openUpdatePopup()
  local titleText = "UPDATE"
  local messageText = "Update your DFL 26:\n \nSearch for the Rober FL channel (YouTube). If there are any new updates, you'll find them on the Rober FL channel!"
  local buttonClose = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = titleText,
    message = messageText,
    buttons = {buttonClose}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end
function CustomizeHub:_openUsageSharingPopup()
  local usageSharing = self.services.HelpAndAboutService.GetUsageSharing()
  local titleText = "Enable Sharing"
  local messageText = self.loc.LocalizeString("LTXT_MOB_DATA_ENABLE_SHARE")
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
      "evt_hide_popup"
    }
    
  }
  if usageSharing then
    titleText = "Disable Sharing"
    messageText = self.loc.LocalizeString("LTXT_MOB_DATA_DISABLE_SHARE")
  end
  if usageSharing then
    usageSharing = false
  else
    usageSharing = true
  end
  function buttonYes.clickCallback()
    self.services.HelpAndAboutService.SetUsageSharing(usageSharing)
    self:publishDisableshareAboutData()
  end
  local popupData = {
    title = titleText,
    message = messageText,
    buttons = {buttonNo, buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function CustomizeHub:HideSelections()
  self.im.Publish(BND_TAB1_VISIBLE, false)
  self.im.Publish(BND_TAB2_VISIBLE, false)
  self.im.Publish(BND_TAB3_VISIBLE, false)
  self.im.Publish(BND_TAB4_VISIBLE, false)
  self.im.Publish(BND_TAB5_VISIBLE, false)
  self.im.Publish(BND_TAB6_VISIBLE, false)
  self.im.Publish(BND_TAB7_VISIBLE, false)
  self.im.Publish(BND_TAB8_VISIBLE, false)
end

function CustomizeHub:finalize()
  print("CustomizeHub:finalize()")
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
  self.im.UnregisterAction(actToMusicTile)
  self.im.Unsubscribe(BND_TAB1_VISIBLE)
  self.im.Unsubscribe(BND_TAB2_VISIBLE)
  self.im.Unsubscribe(BND_TAB3_VISIBLE)
  self.im.Unsubscribe(BND_TAB4_VISIBLE)
  self.im.Unsubscribe(BND_TAB5_VISIBLE)
  self.im.Unsubscribe(BND_TAB6_VISIBLE)
  self.im.Unsubscribe(BND_TAB7_VISIBLE)
  self.im.Unsubscribe(BND_TAB8_VISIBLE)
  self.im.UnregisterAction(ACT_BTN_CLICK)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  self.nav.RemoveActionHandler("showBackButton")
end
return CustomizeHub
