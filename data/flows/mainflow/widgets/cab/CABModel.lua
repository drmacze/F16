local CABModel = {}
local eventmanager, TableUtil = ...
local EventTypes = eventmanager.FE.FIFA.EventTypes
local BND_BANNER_DATA = "bnd_banner_data"
local BND_BANNER_IMAGE = "bnd_banner_image"
local ACT_CAB_TO_STORE_UNASSIGNED = "act_cab_to_store_unassigned"
local ACT_CAB_BUY_MATCH_CREDITS = "act_cab_buy_match_credits"
local ACT_CAB_TO_FEATURE = "act_cab_to_feature"
local ACT_CAB_DISPLAY_AD_BANNER = "act_cab_display_ad_banner"
local ACT_CAB_TO_ACCOMPLISHMENTS = "act_cab_to_accomplishments"
local actionSetupData = {
  act_cab_to_main_hub = function(self)
    self.nav.Event(nil, "evt_shortcut_to_main_hub")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_hub = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_hub")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_offline_seasons = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_offline_seasons")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_online_seasons = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_online_seasons")
    self:onAdBannerClicked()
  end,
  act_cab_to_feature = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_online_seasons")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_online_tournaments = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_online_tournaments")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_offline_tournaments = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_offline_tournaments")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_totw = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_totw")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_auction_house = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_auction_house")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_player_exchange = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_player_exchange")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_watch_list = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_watch_list")
    self:onAdBannerClicked()
  end,
  act_cab_to_fut_trade_pile = function(self)
    self.nav.Event(nil, "evt_shortcut_to_fut_trade_pile")
    self:onAdBannerClicked()
  end,
  act_cab_buy_match_credits = function(self)
    if self.screenName ~= "worldleagueteamshub" then
      self.nav.Event(nil, "evt_buy_match_credits")
      self:onAdBannerClicked()
    end
  end,
  act_cab_to_store = function(self)
    self.nav.Event(nil, "evt_to_store", {from = "adbanner"})
    self:onAdBannerClicked()
  end,
  act_cab_to_store_my_packs = function(self)
    self.services.FUTStoreService.SetScreenData({event = nil, params = ""})
    self.nav.Event(nil, "evt_to_store", {redirect = "unassigned", from = "adbanner"})
    self:onAdBannerClicked()
  end,
  act_cab_to_store_player = function(self)
    self.services.FUTStoreService.SetScreenData({event = nil, params = ""})
    self.nav.Event(nil, "evt_to_store", {
      redirect = "regularpacks",
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_store_shop = function(self)
    self.services.FUTStoreService.SetScreenData({event = nil, params = ""})
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_store_unassigned = function(self)
    self.services.FUTStoreService.SetScreenData({event = nil, params = ""})
    self.nav.Event(nil, "evt_to_store", {redirect = "unassigned", from = "adbanner"})
    self:onAdBannerClicked()
  end,
  act_cab_to_store_single_category_gold = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "regularpacks",
      data = {id = "gold"},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_store_single_category_silver = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "regularpacks",
      data = {id = "silver"},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_store_single_category_bronze = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "regularpacks",
      data = {id = "bronze"},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_store_single_category_special = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "shop",
      data = {id = "special"},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_buy_fifa_points = function(self)
    self.nav.Event(nil, "evt_to_store", {redirect = "fifapoints", from = "adbanner"})
    self:onAdBannerClicked()
  end,
  act_cab_to_forums = function(self)
    self.services.SocialService.OpenWebsiteURL()
    self:onAdBannerClicked()
  end,
  act_cab_open_link_in_igo_browser = function(self)
    self:openBannerLinkInBrowser(false)
    self:onAdBannerClicked()
  end,
  act_cab_open_link_in_external_browser = function(self)
    self:openBannerLinkInBrowser(true)
    self:onAdBannerClicked()
  end,
  act_cab_to_accomplishments = function(self)
    if not self.services.AccomplishmentsService.IsAccomplishmentsKillSwitchOn() then
      self.nav.Event(nil, "evt_to_user_bio", {isInGame = false})
    else
      self.nav.Event(nil, "evt_shortcut_to_fut_offline_tournaments")
    end
    self:onAdBannerClicked()
  end,
  act_cab_to_shop_fitness_category = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      data = {categoryIndex = 1, visible = false},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_shop_healing_category = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      data = {categoryIndex = 2, visible = false},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_shop_morale_category = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      data = {categoryIndex = 3, visible = false},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_shop_player_training_category = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      data = {categoryIndex = 4, visible = false},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_shop_gk_training_category = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      data = {categoryIndex = 5, visible = false},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_shop_player_position_category = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      data = {categoryIndex = 6, visible = false},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_shop_player_formation_category = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      data = {categoryIndex = 7, visible = false},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end,
  act_cab_to_shop_manager_formation_category = function(self)
    self.nav.Event(nil, "evt_to_store", {
      redirect = "consumablepacks",
      data = {categoryIndex = 8, visible = false},
      from = "adbanner"
    })
    self:onAdBannerClicked()
  end
}
function CABModel:new(init)
  print("[CABModel]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  if o.screenName == nil then
    o.screenName = "worldmainhub"
  end
  o.activeAdBannerIndex = -1
  o.usingFakeData = false
  o.noFutBanners = {}
  o.noFutBanners.worldmainhub = "$AdEmptyMain"
  o.noFutBanners.worldpostmatch = "$PostMatchAdBanner"
  o.noFutBanners.worldleagueteamshub = "$AdEmptyLeague"
  o.noFutBanners.worldfuthub = "$AdEmptyLeague"
  o.noFutBannersTitle = " "
  o.noFutBannersSubtitle = " "
  o.noFutBannersDescription = o.loc.LocalizeString("LTXT_MHUB_LIVE_TILE_TOWT_TEAM")
  o.services = {
    PowService = o.api("PowService"),
    SocialService = o.api("SocialService"),
    FUTStoreService = o.api("FutStoreService"),
    EventManagerService = o.api("EventManagerService"),
    FUTTournamentService = o.api("FUTTournamentService"),
    AccomplishmentsService = o.api("AccomplishmentsService")
  }
  self.allBannerData = {}
  self.bannerData = {}
  o.clickCallback = nil
  o.im.Subscribe(BND_BANNER_DATA, function()
    o.im.Publish(BND_BANNER_DATA, o.bannerData)
  end)
  o.im.Subscribe(BND_BANNER_IMAGE, function()
    o.im.Publish(BND_BANNER_IMAGE, {index = -1, success = false})
  end)
  o:setupShortCuts()
  o.im.RegisterAction(ACT_CAB_DISPLAY_AD_BANNER, function(actionName, bannerIndex)
    o:onAdBannerDisplayed(bannerIndex)
  end)
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  if not o.services.AccomplishmentsService.IsAccomplishmentsKillSwitchOn() or not o.services.FUTTournamentService.IsOfflineTournamentsKillSwitchOn() then
    o.im.ChangeActionState(ACT_CAB_TO_FEATURE, o.im.GetActionState("VALID"))
  else
    o.im.ChangeActionState(ACT_CAB_TO_FEATURE, o.im.GetActionState("INVALID"))
  end
  o.services.PowService.RequestAdBannersByScreen(o.screenName)
  return o
end
function CABModel:getBannerData()
  self.allBannerData = {}
  self.bannerData = {}
  print("CABModel:getBannerData:" .. self.screenName)
  local rawData = self.services.PowService.GetAdBannersByScreen(self.screenName)
  local nData = table.getn(rawData)
  if nData > 0 then
    for i, cache in ipairs(rawData) do
      local processedData = {
        image = cache.image,
        defaultImage = self.noFutBanners[self.screenName],
        downloadState = cache.downloadState,
        imageName = cache.image,
        id = cache.id,
        headline = cache.headline,
        subHeadline = cache.subHeadline,
        startTime = cache.startTime,
        endTime = cache.endTime,
        currentTime = cache.currentTime,
        clickEnable = self.screenName ~= "worldpostmatch",
        clickAction = cache.clickAction,
        description = cache.description,
        isActive = self.services.PowService.IsAdBannerEnabled({
          AdBannerId = cache.id
        }),
        bannerIndex = i - 1,
        browserLink = cache.browserLink
      }
      table.insert(self.allBannerData, processedData)
      if processedData.isActive == true then
        table.insert(self.bannerData, processedData)
      end
    end
  end
end
function CABModel:getFakeData()
  local fakedata = {
    id = -1,
    image = self.noFutBanners[self.screenName] or "$AdEmptyMain",
    clickEnable = false,
    localImage = true
  }
  table.insert(self.allBannerData, fakedata)
  return self.allBannerData
end
function CABModel:onAdBannerClicked()
  if self.activeAdBannerIndex ~= -1 and not self.usingFakeData then
    self.services.PowService.OnAdBannerClicked({
      AdBannerId = self.allBannerData[self.activeAdBannerIndex].id
    })
  end
  if self.clickCallback ~= nil and not self.usingFakeData then
    self.clickCallback()
  end
end
function CABModel:onAdBannerDisplayed(bannerIndex)
  if bannerIndex ~= -1 and not self.usingFakeData then
    self.activeAdBannerIndex = bannerIndex + 1
    self.services.PowService.OnAdBannerDisplayed({
      AdBannerId = self.allBannerData[self.activeAdBannerIndex].id
    })
  end
end
function CABModel:openBannerLinkInBrowser(openInExternalBrowser)
  if self.activeAdBannerIndex ~= -1 and not self.usingFakeData then
    self.services.SocialService.OpenURLInBrowser(self.allBannerData[self.activeAdBannerIndex].browserLink, false, openInExternalBrowser)
  end
end
function CABModel:registerClickCallback(callback)
  self.clickCallback = callback
end
function CABModel:handleEvent(eventType, data)
  if eventType == EventTypes.AdBannersDataAvailable or eventType == EventTypes.AdBannersDataNotAvailable then
    if data.screenName == self.screenName then
      if eventType == EventTypes.AdBannersDataAvailable then
        self.usingFakeData = false
        self:getBannerData()
      else
        self.usingFakeData = true
        self:getFakeData()
      end
      self.im.Publish(bndBannerData, self.bannerData)
      if self.activeAdBannerIndex == -1 then
        self:onAdBannerDisplayed(0)
      end
    end
  elseif eventType == EventTypes.AdBannerImageDownloadComplete then
    print("AdBannerImageDownloadComplete | data.image<" .. data.image .. "> DOWNLOAD SUCCESS: " .. tostring(data.success))
    for i = 1, #self.bannerData do
      if self.screenName .. "\\" .. data.image == self.bannerData[i].imageName then
        self.im.Publish(bndBannerImage, {
          index = i - 1,
          success = data.success
        })
      end
    end
  end
end
function CABModel:setupShortCuts()
  for action, actionFunc in pairs(actionSetupData) do
    self.im.RegisterAction(action, function(action)
      actionFunc(self)
    end)
  end
end
function CABModel:update(delta)
  local hasToUpdate = false
  for i = 1, #self.allBannerData do
    local actualActiveValue = self.services.PowService.IsAdBannerEnabled({
      AdBannerId = self.allBannerData[i].id
    })
    if self.allBannerData[i].isActive and not actualActiveValue then
      table.remove(self.bannerData, i)
      hasToUpdate = true
    end
    if not self.allBannerData[i].isActive and actualActiveValue then
      table.insert(self.bannerData, self.allBannerData[i], i)
      hasToUpdate = true
    end
    self.allBannerData[i].isActive = actualActiveValue
  end
  if hasToUpdate then
    self.im.Publish(BND_BANNER_DATA, self.bannerData)
  end
end
function CABModel:finalize()
  print("[CABModel]: finalize()")
  self.clickCallback = nil
  self.im.Unsubscribe(BND_BANNER_DATA)
  self.im.Unsubscribe(BND_BANNER_IMAGE)
  self.im.UnregisterAction(ACT_CAB_DISPLAY_AD_BANNER)
  for action, v in pairs(actionSetupData) do
    self.im.UnregisterAction(action)
  end
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end
return CABModel
