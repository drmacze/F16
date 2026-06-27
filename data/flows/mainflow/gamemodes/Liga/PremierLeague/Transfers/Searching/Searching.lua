local AuctionHouseModel, TableUtil, FormationModel = ...
local Searching = {}
CURRENTCLUBID = nil
CURRENTLEAGUEID = nil
CURRENTNATIONALITYID = nil
-- Add more as needed for other filters
LEAGUEINE = nil
LASTACCESSEDFILTER = nil
local DEFAULT_SEARCH_TYPE = AuctionHouseModel.SEARCH_TYPE_PLAYER
local ID_MIN_BID = 1
local ID_MAX_BID = 2
local ID_MIN_BUY = 3
local ID_MAX_BUY = 4
local BND_MIN_BID = "bnd_min_bid"
local BND_MAX_BID = "bnd_max_bid"
local BND_MIN_BUY = "bnd_min_buy"
local BND_MAX_BUY = "bnd_max_buy"
local BND_SEARCH_BY_NAME_VISIBLE = "bnd_search_by_name_visible"
local BND_AUTO_COMPLETE_LIST_VISIBLE = "bnd_auto_complete_list_visible"
local BND_AUTO_COMPLETE_LIST = "bnd_auto_complete_list"
local BND_AUTO_COMPLETE_TEXT = "bnd_auto_complete_text"
local BND_CLUB_FILTER_ENABLED = "bnd_club_filter_enabled"
local BND_SEARCH_TYPE_ENABLED = "bnd_search_type_enabled"
local filterCategoryDescBindings = {
  "bnd_filter_category_desc_1",
  "bnd_filter_category_desc_2",
  "bnd_filter_category_desc_3",
  "bnd_filter_category_desc_4",
  "bnd_filter_category_desc_5",
  "bnd_filter_category_desc_6"
}
local bndSearchTypeList = "bnd_search_type_list"
local bndSearchTypeIndex = "bnd_search_type_index"
local BND_FILTER_INDEX = "bnd_filter_index"
local ACT_CHANGE_FILTER_INDEX = "act_change_filter_index"
local BND_MAX_VALUE = "bnd_max_value"
local BND_MIN_VALUE = "bnd_min_value"
local BND_FILTER_CATEGORY_DATA = "bnd_filter_category_data"
local BND_FILTER_OVERLAY_VISIBILITY = "bnd_filter_overlay_visibility"
local BND_FILTER_OVERLAY_TITLE = "bnd_filter_overlay_title"
local BND_DEFAULT_CELL_DATA = "bnd_default_cell_data"
local BND_FILTER_TABLE_ROWS = "bnd_filter_table_rows"
local BND_FILTER_TABLE_COLUMNS = "bnd_filter_table_columns"
local BND_FILTER_TABLE_WIDTH = "bnd_filter_table_width"
local BND_FILTER_TABLE_HEIGHT = "bnd_filter_table_height"
local BND_FILTER_TABLE_CELL_STYLE = "bnd_filter_table_cell_style"
local BND_FILTER_TABLE_HAS_BULLETS = "bnd_filter_table_has_bullets"
local BND_FILTER_GRID_Y_POS = "bnd_filter_grid_y_pos"
local BND_COUNTRY_INITIALS_VISIBLE = "bnd_country_initials_visible"
local BND_FILTER_TABLE_CONTAINER_HEIGHT = "bnd_filter_table_container_height"
local ACT_AMOUNT_DECREASE = "act_amount_decrease"
local ACT_AMOUNT_INCREASE = "act_amount_increase"
local actSearchTypeChange = "act_change"
local actReset = "act_reset"
local actSearch = "act_search"
local actMinBidChange = "act_min_bid_change"
local actMaxBidChange = "act_max_bid_change"
local actMinBuyChange = "act_min_buy_change"
local actMaxBuyChange = "act_max_buy_change"
local ACT_MIN_BID_FOCUSOUT = "act_min_bid_focusOut"
local ACT_MAX_BID_FOCUSOUT = "act_max_bid_focusOut"
local ACT_MIN_BUY_FOCUSOUT = "act_min_buy_focusOut"
local ACT_MAX_BUY_FOCUSOUT = "act_max_buy_focusOut"
local ACT_TEXT_CHANGE = "act_text_change"
local ACT_CHANGE_OPTION = "act_change_option"
local ACT_FOCUS_OUT = "act_focus_out"
local ACT_FILTER_CATEGORY = {
  "act_ab",
  "act_cf",
  "act_gl",
  "act_mp",
  "act_qs",
  "act_tz"
}
local BND_FILTER_COLOR = {
  "bnd_filter1_color",
  "bnd_filter2_color",
  "bnd_filter3_color",
  "bnd_filter4_color",
  "bnd_filter5_color",
  "bnd_filter6_color"
}
local showFilterOverlayActions = {
  "act_show_filter1_overlay",
  "act_show_filter2_overlay",
  "act_show_filter3_overlay",
  "act_show_filter4_overlay",
  "act_show_filter5_overlay",
  "act_show_filter6_overlay"
}
local ACT_FILTER_OVERLAY_CANCEL = "act_filter_overlay_cancel"
local ACT_FILTER_OVERLAY_ANY = "act_filter_overlay_any"
local FILTERS_COUNT = 6
local LEVEL_OVERLAY_TABLE_WIDTH = 600
local LEVEL_OVERLAY_TABLE_HEIGHT = 316
local LEVEL_OVERLAY_TABLE_CELL_STYLE = "FilterCellLevel"
local DEFAULT_OVERLAY_TABLE_WIDTH = 800
local DEFAULT_OVERLAY_TABLE_HEIGHT = 390
local DEFAULT_OVERLAY_TABLE_CELL_STYLE = "FilterCellGeneric"
local OVERLAY_COUNTRIES_INITIALS_HEIGHT = 56
local COLOR_NORMAL = "0x1E1E1E"
local COLOR_SELECTED = "0x197FC5"
local MAX_VALUE = 15000000
local MIN_VALUE = 150
local NIL_VALUE = 0
local INVALID_GRID_INDEX = -1
local FILTER_ID_ANY = -1
local DEFAULT_FORMATION_ID = 0
local DEFAULT_COUNTRY_ID = 75
local DEFAULT_LEAGUE_ID = 76
local DEFAULT_CLUB_ID = 130000

function setPlayerFilter()
  playerFilter = "INPUT NAME"
  -- Override with text if it exists
    if text then  -- Assuming text is defined somewhere, e.g., as a global or parameter
      playerFilter = text:upper()
    end
    if text == "" then
      playerFilter = "INPUT NAME"
    end
end
function Searching:new(init)
  print("Searching:new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    squadmgt = o.api("FUTSquadManagementService"),
    TeamService = o.api("TeamService"),
    myClub = o.api("MyClubService"),
    country = o.api("CountryService"),
    items = o.api("ItemsService"),
    card = o.api("CardService")
  }
  o.playerNameSearchDisabled = o.services.card.IsPlayerNameSearchKillSwitchOn()
  o.teamID = o.services.squadmgt.GetFUTTeamId()
  o.groupIndex = 1
  o.models = {
    AuctionHouseModel = AuctionHouseModel:new({
      api = o.api,
      loc = o.loc,
      nav = o.nav
    }),
    FormationModel = FormationModel:new({
      im = o.im,
      api = o.api,
      loc = o.loc,
      teamID = o.teamID,
      gamemode = "fut"
    })
  }
  o:restorePreviousFilterData()
  o:getAllSearchOptions()
  o:initFilters()
  o:updateGridFilters()
  o:checkMinBidPrice()
  o:checkMinBuyPrice()
  o:addDataBindings()
  o:addChangeBidValueActions()
  o:addSearchActions()
  o:addSearchTypeActionsAndBindings()
  o:addFilterOverlayBindings()
  setPlayerFilter()
  local leagueFilterSelection = Searching:getSelectedOrAnyID(o.filterLeague)
  o:enableClubFilter(leagueFilterSelection ~= FILTER_ID_ANY)
  if automation then
    automation.Add("AuctionHouseStartSearch", {
      AuctionHouseStartSearch = function()
        o:search()
      end
    })
  end
  return o
end

function Searching:restorePreviousFilterData()
  print("Searching:restorePreviousFilterData()")
  self.selectedFilters = self.services.items.GetPreviousAuctionHouseFilters()
  if self.selectedFilters.SEARCH_TYPE ~= nil then
    self.currSearchType = self.selectedFilters.SEARCH_TYPE
    self.amountMinBid = self.selectedFilters.MIN_PRICE
    self.amountMaxBid = self.selectedFilters.MAX_PRICE
    self.amountMinBuy = self.selectedFilters.MIN_BUY_NOW
    self.amountMaxBuy = self.selectedFilters.MAX_BUY_NOW
    if self.selectedFilters.CARD_NAME ~= nil then
      self.selectedName = self.selectedFilters.CARD_NAME
    else
      self.selectedName = ""
    end
    self.selectedCardID = self.selectedFilters.CARD_ID
  else
    self.currSearchType = DEFAULT_SEARCH_TYPE
    self.amountMinBid = 0
    self.amountMaxBid = 0
    self.amountMinBuy = 0
    self.amountMaxBuy = 0
    self.selectedName = ""
    self.selectedCardID = FILTER_ID_ANY
  end
  self.minBidData = {
    value = self.amountMinBid,
    locValue = self.loc.LocalizeInteger(self.amountMinBid)
  }
  self.maxBidData = {
    value = self.amountMaxBid,
    locValue = self.loc.LocalizeInteger(self.amountMaxBid)
  }
  self.minBuyData = {
    value = self.amountMinBuy,
    locValue = self.loc.LocalizeInteger(self.amountMinBuy)
  }
  self.maxBuyData = {
    value = self.amountMaxBuy,
    locValue = self.loc.LocalizeInteger(self.amountMaxBuy)
  }
end

function Searching:getAllSearchOptions()
  self.searchOptions = self.services.items.GetAllSearchOptions()
end

function Searching:initFilters()
  self.gridFilters = {}
  self.defaultFilterName = self.loc.LocalizeString("LTXT_CMN_ANY")
  self.filterLevel = {}
  self:setFilterDescription(self.filterLevel, "Player Name")
  self:setFilterMetaData(self.filterLevel, {
    imageType = "$Head",
    default = self.searchOptions.level.default,
    overlayTitle = self.loc.LocalizeString("LTXT_AH_SELECT_LEVEL"),
    rowsCount = 1,
    columnsCount = 3,
    overlayWidth = LEVEL_OVERLAY_TABLE_WIDTH,
    overlayHeight = LEVEL_OVERLAY_TABLE_HEIGHT,
    hasBullets = false,
    filterCellStyle = LEVEL_OVERLAY_TABLE_CELL_STYLE,
    name = playerFilter
  })
  self:setLevelFilterData()
  -- Rest of the function remains unchanged...
  self.filterStaffRoles = {}
  self:setFilterDescription(self.filterStaffRoles, self.loc.LocalizeString("LTXT_CMN_TYPE"))
  self:setFilterMetaData(self.filterStaffRoles, {
    imageType = "$AHIconStaffType",
    default = self.searchOptions.searchStaffRoles.default,
    overlayTitle = self.loc.LocalizeString("LTXT_AH_SELECT_STAFF_TYPE"),
    rowsCount = 2,
    columnsCount = 3
  })
  self:setStafFilterData()
  self.filterFormation = {}
  self:setFilterDescription(self.filterFormation, self.loc.LocalizeString("LTXT_SB_FORMATION"))
  self:setFilterMetaData(self.filterFormation, {
    imageType = "$AHIconFormation",
    defaultID = DEFAULT_FORMATION_ID,
    overlayTitle = self.loc.LocalizeString("LTXT_AH_SELECT_FORMATION"),
    rowsCount = 2,
    columnsCount = 3
  })
  self:setFormationFilterData()
  self.filterPosition = {}
  self:setFilterDescription(self.filterPosition, self.loc.LocalizeString("LTXT_SB_POSITION"))
  self:setFilterMetaData(self.filterPosition, {
    imageType = "$AHIconPosition",
    default = self.searchOptions.position.default,
    overlayTitle = self.loc.LocalizeString("LTXT_AH_SELECT_POSITION"),
    rowsCount = 2,
    columnsCount = 4
  })
  self:setPositionFilterData()
  self.filterNationality = {}
  self:setFilterDescription(self.filterNationality, self.loc.LocalizeString("LTXT_SB_NATIONALITY"))
  self:setFilterMetaData(self.filterNationality, {
    imageType = "$Flag128x128",
    defaultID = DEFAULT_COUNTRY_ID,
    overlayTitle = self.loc.LocalizeString("LTXT_AH_SELECT_NATIONALITY"),
    rowsCount = 2,
    columnsCount = 4,
    overlayContainerHeight = DEFAULT_OVERLAY_TABLE_HEIGHT + OVERLAY_COUNTRIES_INITIALS_HEIGHT
  })
  self:setCountryFilterData()
  self.filterLeague = {}
  self:setFilterDescription(self.filterLeague, self.loc.LocalizeString("LTXT_SB_LEAGUE"))
  self:setFilterMetaData(self.filterLeague, {
    imageType = "$LeagueLogos",
    defaultID = DEFAULT_LEAGUE_ID,
    overlayTitle = self.loc.LocalizeString("LTXT_AH_SELECT_LEAGUE"),
    rowsCount = 2,
    columnsCount = 3
  })
  self:setLeagueFilterData()
  self.filterClub = {}
  self:setFilterDescription(self.filterClub, self.loc.LocalizeString("LTXT_SB_CLUB"))
  self:setFilterMetaData(self.filterClub, {
    imageType = "$Crest",
    defaultID = DEFAULT_CLUB_ID,
    overlayTitle = self.loc.LocalizeString("LTXT_AH_SELECT_CLUB"),
    rowsCount = 2,
    columnsCount = 4
  })
  self:setClubFilterData()
  self.filterKitBadgesType = {}
  self:setFilterDescription(self.filterKitBadgesType, self.loc.LocalizeString("LTXT_CMN_TYPE"))
  self:setFilterMetaData(self.filterKitBadgesType, {
    imageType = "$AHIconKitBadgesType",
    overlayTitle = self.loc.LocalizeString("LTXT_AH_SELECT_KIT_BADGE_TYPE"),
    rowsCount = 2,
    columnsCount = 3
  })
  self:setKitBadgesTypeFilterData()
  self.filterEmpty = {gridIndex = INVALID_GRID_INDEX}
  self:setFilterDescription(self.filterEmpty, "", "", true)
  self.filterEmpty.data = {}
  self:setFilterMetaData(self.filterEmpty, {})
  self:setSearchTypeFilterData()
end

function Searching:setFilterDescription(filter, categoryName, isDisabled)
  categoryName = categoryName or ""
  isDisabled = isDisabled or false
  filter.desc = {}
  filter.desc.category = categoryName
  filter.desc.isDisabled = isDisabled
end

function Searching:updateFilterDescription(filterIndex, description)
  print("Searching:updateFilterDescription() filterIndex " .. tostring(filterIndex))
  self.gridFilters[filterIndex].desc.image = description.image
  self.gridFilters[filterIndex].desc.selectionName = description.label
  self.im.Refresh(filterCategoryDescBindings[filterIndex])
end

function Searching:getSelectedFilterDescription(filterIndex, dataID)
  local filter = self.gridFilters[filterIndex]
  local filterData
  if filter == self.filterNationality then
    filterData = filter.data.data
  else
    filterData = filter.data
  end
  for i = 1, #filterData do
    if filterData[i].id == dataID then
      return {
        image = filterData[i].image,
        label = filterData[i].label
      }
    end
  end
end

function Searching:setFilterMetaData(filter, metaData)
  metaData.name = metaData.name or self.defaultFilterName  -- Keep global default as fallback
  metaData.hasOverridingDefault = metaData.defaultID ~= nil
  metaData.defaultID = metaData.defaultID or FILTER_ID_ANY
  if metaData.hasBullets == nil then
    metaData.hasBullets = true
  end
  filter.overlayWidth = metaData.overlayWidth or DEFAULT_OVERLAY_TABLE_WIDTH
  filter.overlayHeight = metaData.overlayHeight or DEFAULT_OVERLAY_TABLE_HEIGHT
  filter.overlayContainerHeight = metaData.overlayContainerHeight or filter.overlayHeight
  filter.overlayTitle = metaData.overlayTitle or ""
  filter.filterCellStyle = metaData.filterCellStyle or DEFAULT_OVERLAY_TABLE_CELL_STYLE
  filter.imageType = metaData.imageType or ""
  filter.rowsCount = metaData.rowsCount
  filter.columnsCount = metaData.columnsCount
  filter.hasBullets = metaData.hasBullets
  filter.default = metaData.default or {
    name = metaData.name,  -- Use the custom name here
    value = metaData.defaultID
  }
  filter.hasOverridingDefault = metaData.hasOverridingDefault
  filter.defaultName = metaData.name  -- Explicitly store the custom name on the filter
end

function Searching:setFilterData(params)
  params.filter.data = {}
  local idKey = params.idKey
  local alternateBG = false
  for i = 1, #params.data do
    local dataID = params.data[i][idKey]
    table.insert(params.filter.data, {
      label = params.data[i].name,
      id = dataID,
      image = {
        name = params.image,
        id = dataID
      },
      alternateBackground = alternateBG,
      imageWidth = 100,
      imageHeight = 100
    })
    if params.filter.columnsCount % 2 == 1 then
      alternateBG = not alternateBG
    elseif i % params.filter.columnsCount ~= 0 then
      alternateBG = not alternateBG
    end
  end
  
  -- Update LEAGUEINE if there's a selected ID
  if params.selectedID then
    LEAGUEINE = params.selectedID
    LASTACCESSEDFILTER = params.filter -- This might be redundant if always called from onFilterOptionSelected, but safe to include
    self:updatePlaceholderVariable()
  end
  
  self:restorePreviousSelectedFilterID({
    filter = params.filter,
    id = params.selectedID
  })
end

function Searching:restorePreviousSelectedFilterID(params)
  local filter = params.filter
  if params.id == nil or params.id == FILTER_ID_ANY then
    filter.selectedID = filter.default.value
  else
    filter.selectedID = params.id
  end
end

function Searching:updateGridFilters()
  print("Searching:updateGridFilters() self.currSearchType " .. tostring(self.currSearchType))
  if self.currSearchType == AuctionHouseModel.SEARCH_TYPE_PLAYER then
    self:setFilters({
      self.filterLevel,
      self.filterLeague,
      self.filterClub,
      self.filterNationality,
      self.filterFormation,
      self.filterPosition
    })
  elseif self.currSearchType == AuctionHouseModel.SEARCH_TYPE_STAFF then
    self:setFilters({
      self.filterLevel,
      self.filterStaffRoles
    })
  elseif self.currSearchType == AuctionHouseModel.SEARCH_TYPE_KITS_AND_BADGES then
    self:setFilters({
      self.filterLevel,
      self.filterLeague,
      self.filterClub,
      self.filterKitBadgesType
    })
  elseif self.currSearchType == AuctionHouseModel.SEARCH_TYPE_STADIUM then
    self:setFilters({
      self.filterLevel
    })
  elseif self.currSearchType == AuctionHouseModel.SEARCH_TYPE_BALL then
    self:setFilters({})
  end
  self:updateSelectedFilterIDs()
end

function Searching:setFilters(newFilters)
  for i = 1, FILTERS_COUNT do
    if self.gridFilters[i] then
      self.gridFilters[i].gridIndex = INVALID_GRID_INDEX
    end
  end
  local newFiltersCount = #newFilters
  for i = 1, newFiltersCount do
    self.gridFilters[i] = newFilters[i]
    self.gridFilters[i].gridIndex = i
  end
  local nextFilterIndex = newFiltersCount + 1
  for i = nextFilterIndex, FILTERS_COUNT do
    self.gridFilters[i] = self.filterEmpty
    self.gridFilters[i].gridIndex = INVALID_GRID_INDEX
  end
end

function Searching:updateSelectedFilterIDs()
  for i = 1, FILTERS_COUNT do
    local filter = self.gridFilters[i]
    if not filter.desc.isDisabled then
      local selectedID = filter.selectedID
      local defaultID = filter.default.value
      if selectedID and selectedID ~= defaultID then
        self:setSelectedFilterID(i, selectedID)
      else
        self:setSelectedFilterAny(i)
      end
    end
  end
end

function Searching:setSelectedFilterID(filterIndex, selectedID)
  local filter = self.gridFilters[filterIndex]
  filter.selectedID = selectedID
  local description = self:getSelectedFilterDescription(filterIndex, selectedID)
  if description ~= nil then
    self:updateFilterDescription(filterIndex, description)
  end
  self:updateCellsSelectedStatus(filter)
end

function Searching:setSelectedFilterAny(filterIndex)
  local filter = self.gridFilters[filterIndex]
  filter.selectedID = filter.default.value
  local defaultImage = {
    name = filter.imageType,
    id = filter.default.value
  }
  self:updateFilterDescription(filterIndex, {
    image = defaultImage,
    label = filter.defaultName or self.defaultFilterName  -- Use filter-specific name, fallback to global
  })
  self:updateCellsSelectedStatus(filter)
end

function Searching:updateCellsSelectedStatus(filter)
  local filterData
  if filter == self.filterNationality then
    filterData = filter.data.data
  else
    filterData = filter.data
  end
  for i = 1, #filterData do
    filterData[i].selected = filter.selectedID == filterData[i].id
  end
end

function Searching:addDataBindings()
  print("Searching:addDataBindings()")
  self.im.Subscribe(BND_MAX_VALUE, function()
    self:setMaxValue()
  end)
  self.im.Subscribe(BND_MIN_VALUE, function()
    self:setMinValue()
  end)
  self.im.Subscribe(BND_MIN_BID, function()
    self.im.Publish(BND_MIN_BID, self.minBidData)
  end)
  self.im.Subscribe(BND_MAX_BID, function()
    self.im.Publish(BND_MAX_BID, self.maxBidData)
  end)
  self.im.Subscribe(BND_MIN_BUY, function()
    self.im.Publish(BND_MIN_BUY, self.minBuyData)
  end)
  self.im.Subscribe(BND_MAX_BUY, function()
    self.im.Publish(BND_MAX_BUY, self.maxBuyData)
  end)
  self.im.Subscribe(BND_SEARCH_BY_NAME_VISIBLE, function()
    self.im.Publish(BND_SEARCH_BY_NAME_VISIBLE, self.playerNameSearchDisabled == false)
  end)
  self.im.Subscribe(BND_AUTO_COMPLETE_LIST_VISIBLE, function()
    self.im.Publish(BND_AUTO_COMPLETE_LIST_VISIBLE, false)
  end)
  self.im.Subscribe(BND_AUTO_COMPLETE_LIST, function()
    self:publishAutoCompleteList()
  end)
  self.im.Subscribe(BND_AUTO_COMPLETE_TEXT, function()
    self:publishAutoCompleteText()
  end)
  self.im.Subscribe(bndSearchTypeIndex, function()
    self:publishSearchTypeIndex()
  end)
  self.im.Subscribe(bndSearchTypeList, function()
    self:publishSearchType()
  end)
  for i = 1, #filterCategoryDescBindings do
    self.im.Subscribe(filterCategoryDescBindings[i], function()
      self.im.Publish(filterCategoryDescBindings[i], self.gridFilters[i].desc)
    end)
  end
  self.filterOverlayData = {}
  self.filterOverlayData.selected = false
  self.im.Subscribe(BND_FILTER_CATEGORY_DATA, function()
    self.im.Publish(BND_FILTER_CATEGORY_DATA, self.filterOverlayData)
  end)
end

function Searching:addChangeBidValueActions()
  self.im.RegisterAction(ACT_AMOUNT_DECREASE, function(actionName, id)
    print("[Searching]: " .. actionName .. "(" .. id .. ")")
    local binding = ""
    if id == ID_MIN_BID then
      self.amountMinBid = self.models.AuctionHouseModel:decreaseBid(self.amountMinBid)
      binding = BND_MIN_BID
    elseif id == ID_MAX_BID then
      self.amountMaxBid = self.models.AuctionHouseModel:decreaseBid(self.amountMaxBid)
      self:checkMinBidPrice()
      self:checkMaxBidPrice()
      binding = BND_MAX_BID
    elseif id == ID_MIN_BUY then
      self.amountMinBuy = self.models.AuctionHouseModel:decreaseBid(self.amountMinBuy)
      binding = BND_MIN_BUY
    elseif id == ID_MAX_BUY then
      self.amountMaxBuy = self.models.AuctionHouseModel:decreaseBid(self.amountMaxBuy)
      self:checkMinBuyPrice()
      self:checkMaxBuyPrice()
      binding = BND_MAX_BUY
    end
    self:publishAmountSelector(binding)
  end)
  self.im.RegisterAction(ACT_AMOUNT_INCREASE, function(actionName, id)
    print("[Searching]: " .. actionName .. "(" .. id .. ")")
    local binding = ""
    if id == ID_MIN_BID then
      self.amountMinBid = self.models.AuctionHouseModel:increaseBid(self.amountMinBid)
      self:checkMaxBidPrice()
      binding = BND_MIN_BID
    elseif id == ID_MAX_BID then
      self.amountMaxBid = self.models.AuctionHouseModel:increaseBid(self.amountMaxBid)
      self:checkMaxBidPrice()
      binding = BND_MAX_BID
    elseif id == ID_MIN_BUY then
      self.amountMinBuy = self.models.AuctionHouseModel:increaseBid(self.amountMinBuy)
      self:checkMaxBuyPrice()
      binding = BND_MIN_BUY
    elseif id == ID_MAX_BUY then
      self.amountMaxBuy = self.models.AuctionHouseModel:increaseBid(self.amountMaxBuy)
      self:checkMaxBuyPrice()
      binding = BND_MAX_BUY
    end
    self:publishAmountSelector(binding)
  end)
  self.im.RegisterAction(actMinBidChange, function(actionName, data)
    data.text = tonumber(data.text)
    if not data.text then
      data.text = 0
    end
    self.amountMinBid = data.text
    local data = {
      value = self.amountMinBid,
      locValue = self.loc.LocalizeInteger(data.text)
    }
    self.im.Publish(BND_MIN_BID, data)
  end)
  self.im.RegisterAction(actMaxBidChange, function(actionName, data)
    data.text = tonumber(data.text)
    if not data.text then
      data.text = 0
    end
    self.amountMaxBid = data.text
    local data = {
      value = self.amountMaxBid,
      locValue = self.loc.LocalizeInteger(data.text)
    }
    self.im.Publish(BND_MAX_BID, data)
  end)
  self.im.RegisterAction(actMinBuyChange, function(actionName, data)
    data.text = tonumber(data.text)
    if not data.text then
      data.text = 0
    end
    self.amountMinBuy = data.text
    local data = {
      value = self.amountMinBuy,
      locValue = self.loc.LocalizeInteger(data.text)
    }
    self.im.Publish(BND_MIN_BUY, data)
  end)
  self.im.RegisterAction(actMaxBuyChange, function(actionName, data)
    data.text = tonumber(data.text)
    if not data.text then
      data.text = 0
    end
    self.amountMaxBuy = data.text
    local data = {
      value = self.amountMaxBuy,
      locValue = self.loc.LocalizeInteger(data.text)
    }
    self.im.Publish(BND_MAX_BUY, data)
  end)
  self.im.RegisterAction(ACT_MIN_BID_FOCUSOUT, function(actionName)
    self.amountMinBid = self.models.AuctionHouseModel:checkValue(self.amountMinBid)
    if self.amountMinBid < MIN_VALUE and self.amountMinBid ~= 0 then
      self.amountMinBid = MIN_VALUE
    end
    self:checkMaxBidPrice()
    self:publishAmountSelector(BND_MIN_BID)
  end)
  self.im.RegisterAction(ACT_MAX_BID_FOCUSOUT, function(actionName)
    self.amountMaxBid = self.models.AuctionHouseModel:checkValue(self.amountMaxBid)
    if self.amountMaxBid < MIN_VALUE and self.amountMaxBid ~= 0 then
      self.amountMaxBid = MIN_VALUE
    end
    if self.amountMaxBid ~= 0 then
      self:checkMinBidPrice()
    end
    self:checkMaxBidPrice()
    self:publishAmountSelector(BND_MAX_BID)
  end)
  self.im.RegisterAction(ACT_MIN_BUY_FOCUSOUT, function(actionName)
    self.amountMinBuy = self.models.AuctionHouseModel:checkValue(self.amountMinBuy)
    if self.amountMinBuy < MIN_VALUE and self.amountMinBuy ~= 0 then
      self.amountMinBuy = MIN_VALUE
    end
    self:checkMaxBuyPrice()
    self:publishAmountSelector(BND_MIN_BUY)
  end)
  self.im.RegisterAction(ACT_MAX_BUY_FOCUSOUT, function(actionName)
    self.amountMaxBuy = self.models.AuctionHouseModel:checkValue(self.amountMaxBuy)
    if self.amountMaxBuy < MIN_VALUE and self.amountMaxBuy ~= 0 then
      self.amountMaxBuy = MIN_VALUE
    end
    if self.amountMaxBuy ~= 0 then
      self:checkMinBuyPrice()
    end
    self:checkMaxBuyPrice()
    self:publishAmountSelector(BND_MAX_BUY)
  end)
end

function Searching:addSearchActions()
  self.im.RegisterAction(ACT_TEXT_CHANGE, function(actionName, data)
    if data.text == "" then
      self.autoCompleteList = nil
      self.selectedName = ""
      self.selectedCardID = FILTER_ID_ANY
      GLOBAL_NAME = ""  -- Clear GLOBAL_NAME when text is empty
    else
      self.autoCompleteList = self.services.card.FindAllCardsWithName(data.text)
      local len = table.getn(self.autoCompleteList)
      for i = 1, len do
        self.autoCompleteList[i].data.clickAction = ACT_CHANGE_OPTION
      end
      self.selectedName = data.text
      GLOBAL_NAME = data.text
    end
    self:publishAutoCompleteList()
  end)
  self.im.RegisterAction(ACT_CHANGE_OPTION, function(actionName, data)
    local index = data.id + 1
    self.selectedName = self.autoCompleteList[index].data.NAME
    self.selectedCardID = self.autoCompleteList[index].data.CARD_ID
    GLOBAL_NAME = self.selectedName
    self:publishAutoCompleteText()
    self.im.Publish(BND_AUTO_COMPLETE_LIST_VISIBLE, false)
  end)
  self.im.RegisterAction(ACT_FOCUS_OUT, function(actionName, data)
    self.selectedName = ""
    self.selectedCardID = FILTER_ID_ANY
    GLOBAL_NAME = ""
    self:publishAutoCompleteText()
    self.im.Publish(BND_AUTO_COMPLETE_LIST_VISIBLE, false)
  end)
  self.im.RegisterAction(actSearch, function(bindingName, actionName, index)
    self:search()
  end)
  self.im.RegisterAction(actReset, function(bindingName, actionName, index)
    self:resetAllFilters()
  end)
  for i = 1, #ACT_FILTER_CATEGORY do
    self.im.RegisterAction(ACT_FILTER_CATEGORY[i], function()
      self.groupIndex = i
      self:updateFilterStyles()
      self:getCountriesData()
      self.im.Publish(BND_FILTER_CATEGORY_DATA, self.filterOverlayData)
    end)
  end
end

function Searching:search()
  print("Searching:search()")
  self.params = {}
  if self.currSearchType == AuctionHouseModel.SEARCH_TYPE_PLAYER then
    if self.selectedCardID ~= FILTER_ID_ANY then
      self.params.CARD_ID = self.selectedCardID
      self.params.CARD_NAME = self.selectedName
      SelectedName = self.selectedName
    end
    self.params.CARD_LEVEL = self:getSelectedOrAnyID(self.gridFilters[1])
    self.params.LEAGUE = self:getSelectedOrAnyID(self.gridFilters[2])
    self.params.CLUB = self:getSelectedOrAnyID(self.gridFilters[3])
    self.params.NATIONALITY = self:getSelectedOrAnyID(self.gridFilters[4])
    self.params.FORMATION = self:getSelectedOrAnyID(self.gridFilters[5])
    self.params.POSITION = self:getSelectedOrAnyID(self.gridFilters[6])
  elseif self.currSearchType == AuctionHouseModel.SEARCH_TYPE_STAFF then
    self.params.CARD_LEVEL = self:getSelectedOrAnyID(self.gridFilters[1])
    self.params.ROLE = self:getSelectedOrAnyID(self.gridFilters[2])
  elseif self.currSearchType == AuctionHouseModel.SEARCH_TYPE_KITS_AND_BADGES then
    self.params.CARD_LEVEL = self:getSelectedOrAnyID(self.gridFilters[1])
    self.params.LEAGUE = self:getSelectedOrAnyID(self.gridFilters[2])
    self.params.CLUB = self:getSelectedOrAnyID(self.gridFilters[3])
    self.params.KITBADGE_TYPE = self:getSelectedOrAnyID(self.gridFilters[4])
  elseif self.currSearchType == AuctionHouseModel.SEARCH_TYPE_STADIUM then
    self.params.CARD_LEVEL = self:getSelectedOrAnyID(self.gridFilters[1])
  elseif self.currSearchType == AuctionHouseModel.SEARCH_TYPE_BALL then
  end
  self.params.START = 0
  self.params.NUMBER_RESULTS = 10
  self.params.SEARCH_TYPE = self.currSearchType
  self.params.SEARCH_TYPE_INDEX = self.currSearchType
  self.params.MIN_PRICE = self.amountMinBid
  self.params.MAX_PRICE = self.amountMaxBid
  self.params.MIN_BUY_NOW = self.amountMinBuy
  self.params.MAX_BUY_NOW = self.amountMaxBuy
  self.nav.Event(nil, "evt_to_auction_search_results", {
    param = self.params
  })
end

function Searching:getSelectedOrAnyID(filter)
  if filter.hasOverridingDefault and filter.selectedID == filter.default.value then
    return FILTER_ID_ANY
  end
  return filter.selectedID
end

function Searching:resetAllFilters()
  self:resetFilterSelectedIDs()
  self.selectedName = ""
  self.selectedCardID = FILTER_ID_ANY
  self.autoCompleteList = nil
  self.amountMinBid = 0
  self.amountMaxBid = 0
  self.amountMinBuy = 0
  self.amountMaxBuy = 0
  self:setClubFilterData()
  self:updateGridFilters()
  self:publishAutoCompleteText()
  self:publishSearchTypeIndex()
  self:publishSearchType()
  self:publishAllFilterDescriptions()
  self:publishAmountSelector()
end

function Searching:resetFilterSelectedIDs()
  self.filterStaffRoles.selectedID = self.filterStaffRoles.default.value
  self.filterLevel.selectedID = self.filterLevel.default.value
  self.filterFormation.selectedID = self.filterFormation.default.value
  self.filterPosition.selectedID = self.filterPosition.default.value
  self.filterNationality.selectedID = self.filterNationality.default.value
  self.filterLeague.selectedID = self.filterLeague.default.value
  self.filterClub.selectedID = self.filterClub.default.value
  self.filterKitBadgesType.selectedID = self.filterKitBadgesType.default.value
end

function Searching:addSearchTypeActionsAndBindings()
  self.im.RegisterDataAction(bndSearchTypeIndex, actSearchTypeChange, function(bindingName, actionName, index)
    self:setFilterOverlayVisibility(false)
    self.currSearchType = self.searchType[index + 1].id
    self:resetFilterSelectedIDs()
    self:updateGridFilters()
    self:cascadeLeagueFilterSelection()
    self:publishSearchTypeIndex()
    self:publishAllFilterDescriptions()
  end)
  self.searchTypeToggleEnabled = true
  self.im.Subscribe(BND_SEARCH_TYPE_ENABLED, function()
    self.im.Publish(BND_SEARCH_TYPE_ENABLED, self.searchTypeToggleEnabled)
  end)
end

function Searching:addFilterOverlayBindings()
  self.isFilterOverlayVisible = false
  self.im.Subscribe(BND_FILTER_OVERLAY_VISIBILITY, function()
    self.im.Publish(BND_FILTER_OVERLAY_VISIBILITY, self.isFilterOverlayVisible)
  end)
  self.filterOverlayTitle = ""
  self.im.Subscribe(BND_FILTER_OVERLAY_TITLE, function()
    self.im.Publish(BND_FILTER_OVERLAY_TITLE, self.filterOverlayTitle)
  end)
  self.filterOverlayTableRowsCount = 0
  self.im.Subscribe(BND_FILTER_TABLE_ROWS, function()
    self.im.Publish(BND_FILTER_TABLE_ROWS, self.filterOverlayTableRowsCount)
  end)
  self.filterOverlayTableColumnsCount = 0
  self.im.Subscribe(BND_FILTER_TABLE_COLUMNS, function()
    self.im.Publish(BND_FILTER_TABLE_COLUMNS, self.filterOverlayTableColumnsCount)
  end)
  self.filterOverlayTableWidth = 0
  self.im.Subscribe(BND_FILTER_TABLE_WIDTH, function()
    self.im.Publish(BND_FILTER_TABLE_WIDTH, self.filterOverlayTableWidth)
  end)
  self.filterOverlayTableHeight = 0
  self.im.Subscribe(BND_FILTER_TABLE_HEIGHT, function()
    self.im.Publish(BND_FILTER_TABLE_HEIGHT, self.filterOverlayTableHeight)
  end)
  self.filterOverlayTableCellStyleName = ""
  self.im.Subscribe(BND_FILTER_TABLE_CELL_STYLE, function()
    self.im.Publish(BND_FILTER_TABLE_CELL_STYLE, self.filterOverlayTableCellStyleName)
  end)
  self.filterOverlayTableHasBullets = true
  self.im.Subscribe(BND_FILTER_TABLE_HAS_BULLETS, function()
    self.im.Publish(BND_FILTER_TABLE_HAS_BULLETS, self.filterOverlayTableHasBullets)
  end)
  self.filterGridYPos = 0
  self.im.Subscribe(BND_FILTER_GRID_Y_POS, function()
    self.im.Publish(BND_FILTER_GRID_Y_POS, self.filterGridYPos)
  end)
  self.filterOverlayContainerHeight = 0
  self.im.Subscribe(BND_FILTER_TABLE_CONTAINER_HEIGHT, function()
    self.im.Publish(BND_FILTER_TABLE_CONTAINER_HEIGHT, self.filterOverlayContainerHeight)
  end)
  self.countryInitialsVisible = false
  self.im.Subscribe(BND_COUNTRY_INITIALS_VISIBLE, function()
    self.im.Publish(BND_COUNTRY_INITIALS_VISIBLE, self.countryInitialsVisible)
  end)
  self.defaultCellData = {
    label = "",
    image = {},
    id = FILTER_ID_ANY,
    imageWidth = 100,
    imageHeight = 100
  }
  self.im.Subscribe(BND_DEFAULT_CELL_DATA, function()
    self.im.Publish(BND_DEFAULT_CELL_DATA, self.defaultCellData)
  end)
  for i = 1, #showFilterOverlayActions do
    self.im.RegisterAction(showFilterOverlayActions[i], function(actionName)
      self:disableFilterTileActions()
      self:showFilterOverlay(i)
    end)
  end
  for i = 1, #BND_FILTER_COLOR do
    self.im.Subscribe(BND_FILTER_COLOR[i], function()
      self:updateFilterStyles()
    end)
  end
  self.im.RegisterDataAction(BND_FILTER_INDEX, ACT_CHANGE_FILTER_INDEX, function(bindingName, actionName, selectedID)
    self:onFilterOptionSelected(selectedID)
  end)
  self.clubFilterIsEnabled = false
  self.im.Subscribe(BND_CLUB_FILTER_ENABLED, function()
    self.im.Publish(BND_CLUB_FILTER_ENABLED, self.clubFilterIsEnabled)
  end)
  self.im.RegisterAction(ACT_FILTER_OVERLAY_CANCEL, function(actionName)
    self:onFilterOptionCancelSelected()
  end)
  self.im.RegisterAction(ACT_FILTER_OVERLAY_ANY, function(actionName)
    self:onFilterOptionAnySelected()
  end)
end

function Searching:disableFilterTileActions()
  for i = 1, #showFilterOverlayActions do
    self.im.ChangeActionState(showFilterOverlayActions[i], self.im.GetActionState("INVALID"))
  end
end

function Searching:enableFilterTileActions()
  for i = 1, #showFilterOverlayActions do
    self.im.ChangeActionState(showFilterOverlayActions[i], self.im.GetActionState("VALID"))
  end
end

function Searching:updateFilterStyles()
  for i = 1, #BND_FILTER_COLOR do
    self.im.Publish(BND_FILTER_COLOR[i], COLOR_NORMAL)
  end
  self.im.Publish(BND_FILTER_COLOR[self.groupIndex], COLOR_SELECTED)
end

function Searching:onFilterOptionSelected(selectedID)
  print("Searching:onFilterOptionSelected() selectedID " .. tostring(selectedID))
  self:setSelectedFilterID(self.overlayFilterIndex, selectedID)
  
  -- Update LASTACCESSEDFILTER to track which filter was last accessed
  if self.overlayFilterIndex == self.filterClub.gridIndex then
    LASTACCESSEDFILTER = self.filterClub
  elseif self.overlayFilterIndex == self.filterLeague.gridIndex then
    LASTACCESSEDFILTER = self.filterLeague
  elseif self.overlayFilterIndex == self.filterNationality.gridIndex then
    LASTACCESSEDFILTER = self.filterNationality
  elseif self.overlayFilterIndex == self.filterPosition.gridIndex then
    LASTACCESSEDFILTER = self.filterPosition
    -- Add more conditions for other filters if needed
  end
  
  -- Update LEAGUEINE with the selected ID
  LEAGUEINE = selectedID
  
  -- Update the corresponding placeholder variable
  self:updatePlaceholderVariable()
  
  self:checkAndCascadeLeagueFilterSelection()
  self:setFilterOverlayVisibility(false)
end

function Searching:updatePlaceholderVariable()
  if LASTACCESSEDFILTER == self.filterClub then
    CURRENTCLUBID = LEAGUEINE
  elseif LASTACCESSEDFILTER == self.filterLeague then
    CURRENTLEAGUEID = LEAGUEINE
  elseif LASTACCESSEDFILTER == self.filterNationality then
    CURRENTNATIONALITYID = LEAGUEINE
  elseif LASTACCESSEDFILTER == self.filterPosition then
    CURRENTPOSITIONID = LEAGUEINE
    -- Add more conditions for other filters if needed
  end
end

function Searching:onFilterOptionAnySelected()
  print("Searching:onFilterOptionAnySelected()")
  self:setSelectedFilterAny(self.overlayFilterIndex)
  self:checkAndCascadeLeagueFilterSelection()
  self:setFilterOverlayVisibility(false)
end

function Searching:checkAndCascadeLeagueFilterSelection()
  print("Searching:checkAndCascadeLeagueFilterSelection()")
  if self.overlayFilterIndex == self.filterLeague.gridIndex and self.filterClub.gridIndex ~= INVALID_GRID_INDEX and self.filterClub.gridIndex ~= nil then
    self:setSelectedFilterAny(self.filterClub.gridIndex)
    self:setClubFilterData()
    self:publishClubList()
    local leagueFilterSelection = Searching:getSelectedOrAnyID(self.filterLeague)
    self:enableClubFilter(leagueFilterSelection ~= FILTER_ID_ANY)
  end
end

function Searching:cascadeLeagueFilterSelection()
  print("Searching:cascadeLeagueFilterSelection()")
  if self.filterClub.gridIndex ~= INVALID_GRID_INDEX and self.filterClub.gridIndex ~= nil then
    self:setSelectedFilterAny(self.filterClub.gridIndex)
    self:setClubFilterData()
    self:publishClubList()
    local leagueFilterSelection = Searching:getSelectedOrAnyID(self.filterLeague)
    self:enableClubFilter(leagueFilterSelection ~= FILTER_ID_ANY)
  end
end

function Searching:onFilterOptionCancelSelected()
  self:setFilterOverlayVisibility(false)
end

function Searching:showFilterOverlay(filterIndex)
  if self.isFilterOverlayVisible then
    return
  end
  print("Searching:showFilterOverlay() filterIndex " .. tostring(filterIndex))
  print("Searching:showFilterOverlay() categoryName " .. tostring(self.gridFilters[filterIndex].category))
  local selectedFilter = self.gridFilters[filterIndex]
  if selectedFilter ~= self.filterEmpty then
    self.overlayFilterIndex = filterIndex
    if selectedFilter == self.filterNationality then
      self.filterGridYPos = OVERLAY_COUNTRIES_INITIALS_HEIGHT
      self.im.Refresh(BND_FILTER_GRID_Y_POS)
      self.countryInitialsVisible = true
      self.im.Refresh(BND_COUNTRY_INITIALS_VISIBLE)
    else
      self.filterGridYPos = 0
      self.im.Refresh(BND_FILTER_GRID_Y_POS)
      self.countryInitialsVisible = false
      self.im.Refresh(BND_COUNTRY_INITIALS_VISIBLE)
    end
    self:setFilterOverlayTableWidth(selectedFilter.overlayWidth)
    self:setFilterOverlayTableHeight(selectedFilter.overlayHeight)
    self:setFilterOverlayTableRows(selectedFilter.rowsCount)
    self:setFilterOverlayTableColumns(selectedFilter.columnsCount)
    self:setFilterOverlayTableCellStyle(selectedFilter.filterCellStyle)
    self:setFilterOverlayTableHasBullets(selectedFilter.hasBullets)
    self:setFilterOvelayContainerHeight(selectedFilter.overlayContainerHeight)
    self:updateFilterOverlayTitle(selectedFilter.overlayTitle)
    self:setFilterOverlayData(selectedFilter.data)
    self:setFilterOverlayVisibility(true)
  end
end

function Searching:setFilterOverlayTableWidth(overlayWidth)
  self.filterOverlayTableWidth = overlayWidth
  self.im.Refresh(BND_FILTER_TABLE_WIDTH)
end

function Searching:setFilterOverlayTableHeight(overlayHeight)
  self.filterOverlayTableHeight = overlayHeight
  self.im.Refresh(BND_FILTER_TABLE_HEIGHT)
end

function Searching:setFilterOverlayTableRows(rowsCount)
  self.filterOverlayTableRowsCount = rowsCount
  self.im.Refresh(BND_FILTER_TABLE_ROWS)
end

function Searching:setFilterOverlayTableColumns(columnsCount)
  self.filterOverlayTableColumnsCount = columnsCount
  self.im.Refresh(BND_FILTER_TABLE_COLUMNS)
end

function Searching:setFilterOverlayTableCellStyle(styleName)
  self.filterOverlayTableCellStyleName = styleName
  self.im.Refresh(BND_FILTER_TABLE_CELL_STYLE)
end

function Searching:setFilterOverlayTableHasBullets(hasBullets)
  self.filterOverlayTableHasBullets = hasBullets
  self.im.Refresh(BND_FILTER_TABLE_HAS_BULLETS)
end

function Searching:updateFilterOverlayTitle(title)
  self.filterOverlayTitle = title
  self.im.Refresh(BND_FILTER_OVERLAY_TITLE)
end

function Searching:setFilterOverlayData(data)
  self.filterOverlayData = data
  self.im.Refresh(BND_FILTER_CATEGORY_DATA)
end

function Searching:setFilterOverlayVisibility(visible)
  print("Searching:setFilterOverlayVisibility() visible " .. tostring(visible))
  if self.isFilterOverlayVisible ~= visible then
    if visible == false then
      self:enableFilterTileActions()
    end
    self.isFilterOverlayVisible = visible
    self.im.Refresh(BND_FILTER_OVERLAY_VISIBILITY)
    self.searchTypeToggleEnabled = not self.isFilterOverlayVisible
    self.im.Refresh(BND_SEARCH_TYPE_ENABLED)
  end
end

function Searching:setFilterOvelayContainerHeight(overlayHeight)
  self.filterOverlayContainerHeight = overlayHeight
  self.im.Refresh(BND_FILTER_TABLE_CONTAINER_HEIGHT)
end

function Searching:enableClubFilter(value)
  print("Searching:enableClubFilter() enable: " .. tostring(value))
  if self.clubFilterIsEnabled ~= value then
    self.clubFilterIsEnabled = value
    self.im.Refresh(BND_CLUB_FILTER_ENABLED)
  end
end

function Searching:checkMinBidPrice()
  if self.amountMaxBid ~= 0 then
    if self.amountMinBid >= self.amountMaxBid then
      self.amountMinBid = self.models.AuctionHouseModel:decreaseBid(self.amountMaxBid)
    end
    self:publishAmountSelector(BND_MIN_BID)
  end
end

function Searching:checkMaxBidPrice()
  if self.amountMaxBid ~= 0 then
    if self.amountMinBid >= self.amountMaxBid then
      self.amountMaxBid = self.models.AuctionHouseModel:increaseBid(self.amountMinBid)
    end
    self:publishAmountSelector(BND_MAX_BID)
  end
end

function Searching:checkMinBuyPrice()
  if self.amountMaxBuy ~= 0 then
    if self.amountMinBuy >= self.amountMaxBuy then
      self.amountMinBuy = self.models.AuctionHouseModel:decreaseBid(self.amountMaxBuy)
    end
    self:publishAmountSelector(BND_MIN_BUY)
  end
end

function Searching:checkMaxBuyPrice()
  if self.amountMaxBuy ~= 0 then
    if self.amountMinBuy >= self.amountMaxBuy then
      self.amountMaxBuy = self.models.AuctionHouseModel:increaseBid(self.amountMinBuy)
    end
    self:publishAmountSelector(BND_MAX_BUY)
  end
end

function Searching:setMaxValue()
  local data = {
    value = MAX_VALUE,
    locValue = self.loc.LocalizeInteger(MAX_VALUE)
  }
  self.im.Publish(BND_MAX_VALUE, data)
end

function Searching:setMinValue()
  local data = {
    value = NIL_VALUE,
    locValue = self.loc.LocalizeInteger(NIL_VALUE)
  }
  self.im.Publish(BND_MIN_VALUE, data)
end

function Searching:setSearchTypeFilterData()
  print("Searching:setSearchTypeFilterData()")
  local searchTypeData = self.searchOptions.searchType.data.data
  self.searchType = {}
  for i = 1, #searchTypeData do
    table.insert(self.searchType, {
      text = searchTypeData[i].name,
      GLOBAL_NAME = text,
      id = searchTypeData[i].value
    })
  end
end

function Searching:setStafFilterData()
  print("Searching:setStafFilterData()")
  local staffData = self.searchOptions.searchStaffRoles.data.data
  self:setFilterData({
    filter = self.filterStaffRoles,
    data = staffData,
    idKey = "value",
    image = self.filterStaffRoles.imageType,
    selectedID = self.selectedFilters.ROLE
  })
end

function Searching:setLevelFilterData()
  print("Searching:setLevelFilterData()")
  local levelData = self.searchOptions.level.data.data
  self:setFilterData({
    filter = self.filterLevel,
    data = levelData,
    idKey = "value",
    image = self.filterLevel.imageType,
    selectedID = self.selectedFilters.CARD_LEVEL
  })
end

function Searching:setPositionFilterData()
  print("Searching:setPositionFilterData()")
  local positionData = self.searchOptions.position.data.data
  self:setFilterData({
    filter = self.filterPosition,
    data = positionData,
    idKey = "value",
    image = self.filterPosition.imageType,
    selectedID = self.selectedFilters.POSITION
  })
end

function Searching:setConsumableTypeFilterData()
  print("Searching:setConsumableTypeFilterData()")
  local consumableTypeData = self.searchOptions.consumableType.data.data
  self:setFilterData({
    filter = self.filterConsumablesType,
    data = consumableTypeData,
    idKey = "value",
    image = self.filterConsumablesType.imageType,
    selectedID = self.selectedFilters.DEVELOPMENT_TYPE
  })
end

function Searching:setKitBadgesTypeFilterData()
  print("Searching:setKitBadgesTypeFilterData()")
  local kitBadgesData = self.searchOptions.kitBadgesType.data.data
  self:setFilterData({
    filter = self.filterKitBadgesType,
    data = kitBadgesData,
    idKey = "value",
    image = self.filterKitBadgesType.imageType,
    selectedID = self.selectedFilters.KITBADGE_TYPE
  })
end

function Searching:setTrainingTypeFilterData()
  print("Searching:setTrainingTypeFilterData()")
  local trainingTypeData = self.searchOptions.trainingTypes.data.data
  self:setFilterData({
    filter = self.filterTrainingType,
    data = trainingTypeData,
    idKey = "value",
    image = self.filterTrainingType.imageType,
    selectedID = self.selectedFilters.TRAINING_TYPE
  })
end

function Searching:setFormationFilterData()
  print("Searching:setFormationFilterData()")
  local formations = self.models.FormationModel:getFormationList()
  self:setFilterData({
    filter = self.filterFormation,
    data = formations,
    idKey = "id",
    image = self.filterFormation.imageType,
    selectedID = self.selectedFilters.FORMATION
  })
end

function Searching:setCountryFilterData()
  print("Searching:setCountryFilterData()")
  local prevID = self.selectedFilters.NATIONALITY
  if prevID == nil or prevID == FILTER_ID_ANY then
    self:getCountriesData()
  else
    local found = false
    for i = 1, #ACT_FILTER_CATEGORY do
      self.groupIndex = i
      self:getCountriesData()
      local filterData = self.filterNationality.data.data
      for i = 1, #filterData do
        if filterData[i].id == prevID then
          found = true
          break
        end
      end
      if found == true then
        break
      end
    end
  end
  self:restorePreviousSelectedFilterID({
    filter = self.filterNationality,
    id = self.selectedFilters.NATIONALITY
  })
end

function Searching:getCountriesData()
  print("Searching:getCountriesData")
  local countryNames = {}
  local sortAscending = true
  self.countriesData = nil
  self.countriesData = self.services.country.GetGroupIDs(sortAscending, self.groupIndex)
  local alternateBG = false
  for i = 1, #self.countriesData do
    local countryData = self.countriesData[i]
    table.insert(countryNames, {
      label = countryData.name,
      image = {
        name = "$Flag128x128",
        id = countryData.id
      },
      id = countryData.id,
      alternateBackground = alternateBG,
      imageWidth = 128,
      imageHeight = 128
    })
    if i % 4 ~= 0 then
      alternateBG = not alternateBG
    end
  end
  self.filterNationality.data = {
    index = self.groupIndex,
    data = countryNames
  }
  self.filterOverlayData = self.filterNationality.data
end

-- Define a global placeholder for the selected league and club
GlobalSelections = {
  leagueID = nil,
  clubID = nil
}

function Searching:setLeagueFilterData()
  print("Searching:setLeagueFilterData()")
  
  -- Define the allowed leagues with their respective crests
  self.leagueIDs = { -- Predefined league IDs
    13, 14, 60, 2216, 16, 17, 2218, 19, 20, 2235,
    2254, 78, 2136, 31, 32, 83, 2237, 341, 2237, 10,
    308, 76, 77, 350, 50, 347, 53, 54, 2222, 2252,
    68, 39, 2221, 2260, 365, 353, 4, 7, 1245, 1246,2231
  }

  
  -- Clear existing data and set new data for the league filter
  self.filterLeague.data = {}
  local alternateBG = false
  for i = 1, #self.leagueIDs do
    table.insert(self.filterLeague.data, {
      label = self.loc.LocalizeString("LeagueName_Abbr15_" .. self.leagueIDs[i]), -- Use label based on the ID
      image = {
        name = "$LeagueCrest",
        id = self.leagueIDs[i]
      },
      id = i,
      alternateBackground = alternateBG,
      imageWidth = 256,
      imageHeight = 80
    })
    alternateBG = not alternateBG
  end
  
  -- Store the selected league in the global placeholder
  GlobalSelections.leagueID = self.filterLeague.selectedID
  
  -- Restore previous selected league filter if applicable
  self:restorePreviousSelectedFilterID({
    filter = self.filterLeague,
    id = self.selectedFilters.LEAGUE
  })
end

function Searching:setClubFilterData()
  print("Searching:setClubFilterData() self.filterLeague.selectedID " .. tostring(self.filterLeague.selectedID))
  
  -- Declare teamIDs here, it will be set based on leagueIndex
  
  -- Assign teamIDs based on leagueIndex
  local teams = self.services.TeamService.GetTeams(self.leagueIDs[self.filterLeague.selectedID], 0, 0, false) -- Fetch real team I
  teamIDs = {}
  for i = 1, #teams do
    table.insert(teamIDs, teams[i].id)
  end
  
  currentLeagueIndex = self.filterLeague.selectedID

  -- Function to get the team name and crest for a given team ID
  local function getTeamInfo(teamID)
    return {
      id = teamID,
      name = self.loc.LocalizeString("TeamName_Abbr15_"..teamID),
      crest = "crest_" .. teamID  -- Crest based on teamID
    }
  end
  
  -- Prepare the team data based on the selected league
  local teamData = {}
  for _, teamID in ipairs(teamIDs) do
    if teamID ~= currentSelectedTeamID then
      table.insert(teamData, getTeamInfo(teamID))
    end
  end

  -- Store the selected club in the global placeholder as the teamID on the grid
  GlobalSelections.clubID = self.filterClub.selectedID  -- This is now the actual teamID
  
  -- Set the filter data with the prepared team data
  self:setFilterData({
    filter = self.filterClub,
    data = teamData,
    idKey = "id",
    image = self.filterClub.imageType,
    selectedID = self.selectedFilters.CLUB,
    imageWidth = 100,
    imageHeight = 100
  })
end

function Searching:publishClubList()
  self.filterClub.selectedID = self.filterClub.default.value
  self.im.Refresh(filterCategoryDescBindings[3])
end

function Searching:publishSearchTypeIndex()
  self.im.Publish(bndSearchTypeIndex, self:getIndexFromSearchType(self.currSearchType))
  local isSearchByNameVisible = self.currSearchType == AuctionHouseModel.SEARCH_TYPE_PLAYER and self.playerNameSearchDisabled == false
  self.im.Publish(BND_SEARCH_BY_NAME_VISIBLE, isSearchByNameVisible)
end

function Searching:publishSearchType()
  self.im.Publish(bndSearchTypeList, {
    data = self.searchType,
    index = self:getIndexFromSearchType(self.currSearchType)
  })
end

function Searching:publishAmountSelector(bindingName)
  if bindingName == nil then
    self:publishAmountSelector(BND_MIN_BID)
    self:publishAmountSelector(BND_MAX_BID)
    self:publishAmountSelector(BND_MIN_BUY)
    self:publishAmountSelector(BND_MAX_BUY)
  else
    if bindingName == BND_MIN_BID then
      self.minBidData.value = self.amountMinBid
      self.minBidData.locValue = self.loc.LocalizeInteger(self.amountMinBid)
    elseif bindingName == BND_MAX_BID then
      self.maxBidData.value = self.amountMaxBid
      self.maxBidData.locValue = self.loc.LocalizeInteger(self.amountMaxBid)
    elseif bindingName == BND_MIN_BUY then
      self.minBuyData.value = self.amountMinBuy
      self.minBuyData.locValue = self.loc.LocalizeInteger(self.amountMinBuy)
    elseif bindingName == BND_MAX_BUY then
      self.maxBuyData.value = self.amountMaxBuy
      self.maxBuyData.locValue = self.loc.LocalizeInteger(self.amountMaxBuy)
    end
    self.im.Refresh(bindingName)
  end
end

function Searching:publishAllFilterDescriptions()
  for i = 1, #filterCategoryDescBindings do
    self.im.Refresh(filterCategoryDescBindings[i])
  end
end

function Searching:publishAutoCompleteList()
  if self.autoCompleteList == nil then
    self.im.Publish(BND_AUTO_COMPLETE_LIST_VISIBLE, false)
  else
    self.im.Publish(BND_AUTO_COMPLETE_LIST, self.autoCompleteList)
    self.im.Publish(BND_AUTO_COMPLETE_LIST_VISIBLE, true)
  end
end

function Searching:publishAutoCompleteText()
  self.im.Publish(BND_AUTO_COMPLETE_TEXT, {
    data = self.selectedName
  })
end

function Searching:getIndexFromSearchType(searchType)
  local toggleIndex = 0
  for i = 1, #self.searchType do
    if self.searchType[i].id == searchType then
      toggleIndex = i - 1
    end
  end
  return toggleIndex
end

function Searching:finalize()
  self.models.FormationModel:finalize()
  self.models.AuctionHouseModel:finalize()
  self.im.Unsubscribe(BND_MIN_BID)
  self.im.Unsubscribe(BND_MAX_BID)
  self.im.Unsubscribe(BND_MIN_BUY)
  self.im.Unsubscribe(BND_MAX_BUY)
  self.im.Unsubscribe(BND_SEARCH_BY_NAME_VISIBLE)
  self.im.Unsubscribe(BND_AUTO_COMPLETE_LIST_VISIBLE)
  self.im.Unsubscribe(BND_AUTO_COMPLETE_LIST)
  self.im.Unsubscribe(BND_AUTO_COMPLETE_TEXT)
  self.im.Unsubscribe(BND_MIN_VALUE)
  self.im.Unsubscribe(BND_MAX_VALUE)
  for i = 1, #filterCategoryDescBindings do
    self.im.Unsubscribe(filterCategoryDescBindings[i])
  end
  self.im.Unsubscribe(bndSearchTypeList)
  self.im.Unsubscribe(bndSearchTypeIndex)
  self.im.Unsubscribe(BND_FILTER_CATEGORY_DATA)
  self.im.Unsubscribe(BND_FILTER_OVERLAY_VISIBILITY)
  self.im.Unsubscribe(BND_FILTER_OVERLAY_TITLE)
  self.im.Unsubscribe(BND_FILTER_TABLE_ROWS)
  self.im.Unsubscribe(BND_FILTER_TABLE_COLUMNS)
  self.im.Unsubscribe(BND_FILTER_TABLE_WIDTH)
  self.im.Unsubscribe(BND_FILTER_TABLE_HEIGHT)
  self.im.Unsubscribe(BND_FILTER_TABLE_CELL_STYLE)
  self.im.Unsubscribe(BND_FILTER_TABLE_HAS_BULLETS)
  self.im.Unsubscribe(BND_FILTER_GRID_Y_POS)
  self.im.Unsubscribe(BND_COUNTRY_INITIALS_VISIBLE)
  self.im.Unsubscribe(BND_FILTER_TABLE_CONTAINER_HEIGHT)
  self.im.Unsubscribe(BND_DEFAULT_CELL_DATA)
  for i = 1, #BND_FILTER_COLOR do
    self.im.Unsubscribe(BND_FILTER_COLOR[i])
  end
  self.im.UnregisterAction(ACT_AMOUNT_DECREASE)
  self.im.UnregisterAction(ACT_AMOUNT_INCREASE)
  self.im.UnregisterAction(actSearch)
  self.im.UnregisterAction(actReset)
  self.im.UnregisterAction(actMinBidChange)
  self.im.UnregisterAction(actMaxBidChange)
  self.im.UnregisterAction(actMinBuyChange)
  self.im.UnregisterAction(actMaxBuyChange)
  self.im.UnregisterDataAction(bndSearchTypeIndex, actSearchTypeChange)
  self.im.UnregisterDataAction(BND_FILTER_INDEX, ACT_CHANGE_FILTER_INDEX)
  self.im.UnregisterAction(ACT_MIN_BID_FOCUSOUT)
  self.im.UnregisterAction(ACT_MAX_BID_FOCUSOUT)
  self.im.UnregisterAction(ACT_MIN_BUY_FOCUSOUT)
  self.im.UnregisterAction(ACT_MAX_BUY_FOCUSOUT)
  self.im.UnregisterAction(ACT_TEXT_CHANGE)
  self.im.UnregisterAction(ACT_CHANGE_OPTION)
  self.im.UnregisterAction(ACT_FOCUS_OUT)
  for i = 1, #ACT_FILTER_CATEGORY do
    self.im.UnregisterAction(ACT_FILTER_CATEGORY[i])
  end
  for i = 1, #showFilterOverlayActions do
    self.im.UnregisterAction(showFilterOverlayActions[i])
  end
  self.im.Unsubscribe(BND_CLUB_FILTER_ENABLED)
  self.im.Unsubscribe(BND_SEARCH_TYPE_ENABLED)
  self.im.UnregisterAction(ACT_FILTER_OVERLAY_ANY)
  self.im.UnregisterAction(ACT_FILTER_OVERLAY_CANCEL)
  self.nav.Event(nil, "evt_hide_blocking_load")
end

return Searching
