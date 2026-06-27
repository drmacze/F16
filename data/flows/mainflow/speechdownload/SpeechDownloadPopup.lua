-- REMOD BY YOUTUBE LAOSIJI --
local VirtualButton, speech_download_enums, EventManager, TableUtil = ...
local SpeechDownloadPopup = {}
local SpeechDownloadLocale = speech_download_enums.fifaids.SpeechDownloadLocale
local SpeechDownloadServiceListener = speech_download_enums.fifaids.SpeechDownloadServiceListener
local SpeechDownloadFEStatusUpdate = speech_download_enums.fifaids.SpeechDownloadFEStatusUpdate
local SpeechDownloadError = speech_download_enums.fifaids.SpeechDownloadError
local DOWNLOAD_NOT_STARTED = 0
local DOWNLOAD_PAUSED = 1
local DOWNLOAD_COMPLETE = 2
local BND_FOOTER = "bnd_footer"
local BND_LNG_INDEX = "bnd_lng_index"
local BND_COUNTRY_LIST = "bnd_country_list"
local BND_SPEECH_STATUS = "bnd_speech_download_status"
local BND_COUNTRY_SELECTED = "bnd_country_selected"
local ACT_OK_DOWNLOAD = "act_ok_speech_download"
local ACT_CANCEL_DOWNLOAD = "act_cancel_speech_download"
local ACT_PAUSE_DOWNLOAD = "act_pause_speech_download"
local ACT_CLOSE_POPUP = "act_close_speech_download"
local ACT_CHANGE = "act_change"
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
function SpeechDownloadPopup:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    ScreenInfoService = o.api("ScreenInfoService"),
    SpeechDownloadService = o.api("SpeechDownloadService"),
    CountryService = o.api("CountryService"),
    EventManagerService = o.api("EventManagerService"),
    ClientServerService = o.api("ClientServerService")
  }
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end
  )
  o.isConfirmPopupOpen = false
  o.isErrorPopupOpen = false
  o.footer = {}
  o.speechDownloadUpdateStatus = SpeechDownloadFEStatusUpdate.DOWNLOAD_NOT_STARTED
  o.errorCodeId = SpeechDownloadError.ERROR_NONE
  o.speechProgress = o.services.SpeechDownloadService.GetCurrentDownloadedProgress()
  o.speechStatus = o.services.SpeechDownloadService.GetCurrentDownloadedStatus()
  o.lockSpeechDownload = o.services.SpeechDownloadService.GetLockSpeechDownload()
  o.statusLabel = ("You can download or change the commentary in the audio settings menu")
  function o.speechDownloadProgressListener(...)
    o:updateProgress(...)
  end
  
  function o.speechDownloadStateUpdateListener(...)
    o:updateState(...)
  end
  
  o.services.SpeechDownloadService.RegisterListener(SpeechDownloadServiceListener.UPDATE_GUI_PROGRESS, o.speechDownloadProgressListener)
  o.services.SpeechDownloadService.RegisterListener(SpeechDownloadServiceListener.UPDATE_GUI_STATE, o.speechDownloadStateUpdateListener)
  self.countriesData = o.services.SpeechDownloadService.GetIDCountryList()
  o.currentDownloadedLocale = o.services.SpeechDownloadService.GetCurrentDownloadedLocalization()
  o.currentCountryID = o.currentDownloadedLocale
  o.selectedCellIndex = -1
  o.currentCellsData = o:_getCellsData()
  if o.speechStatus == 1 then
    o.speechDownloadUpdateStatus = SpeechDownloadFEStatusUpdate.DOWNLOAD_PAUSED
  elseif o.speechStatus == 2 then
    o.speechDownloadUpdateStatus = SpeechDownloadFEStatusUpdate.DOWNLOAD_COMPLETE
  else
    o.speechDownloadUpdateStatus = SpeechDownloadFEStatusUpdate.DOWNLOAD_NOT_STARTED
  end
  o.im.Subscribe(BND_FOOTER, function()
    o:_publishFooter()
  end
  )
  if o.currentCountryID == -1 then
    o.im.ChangeActionState(ACT_OK_DOWNLOAD, o.im.GetActionState("INVALID"))
  else
    o.im.ChangeActionState(ACT_OK_DOWNLOAD, o.im.GetActionState("VALID"))
  end
  o.im.RegisterAction(ACT_OK_DOWNLOAD, function(actionName, data)
    o.services.ClientServerService.CheckWIFIConnection()
    o.nav.Event(nil, "evt_show_blocking_load")
  end
  )
  o.im.RegisterAction(ACT_CANCEL_DOWNLOAD, function(actionName, data)
    o.services.SpeechDownloadService.CancelDownloadSpeech(false)
    o:_closePopup()
  end
  )
  o.im.RegisterAction(ACT_PAUSE_DOWNLOAD, function(actionName, data)
    o.services.SpeechDownloadService.PauseResumeDownloadSpeech(true)
    o.nav.Event(nil, "evt_hide_blocking_load")
  end
  )
  o.im.RegisterAction(ACT_CLOSE_POPUP, function(actionName, data)
    o:_closePopup()
  end
  )
  o.im.RegisterDataAction(BND_LNG_INDEX, ACT_CHANGE, function(bindingName, actionName, index)
    print("SpeechDownloadPopup: BND_LNG_INDEX" .. tostring(index))
    o:setSelectedCellIndex(index)
  end
  )
  o.im.Subscribe(BND_COUNTRY_LIST, function()
    o.im.Publish(BND_COUNTRY_LIST, o:_publishCountriesData())
  end
  )
  o.im.Subscribe(BND_SPEECH_STATUS, function()
    o.im.Publish(BND_SPEECH_STATUS, o.statusLabel)
  end
  )
  o.im.Subscribe(BND_COUNTRY_SELECTED, function()
    o.im.Publish(BND_COUNTRY_SELECTED, o.selectedCellIndex)
  end
  )
  o.services.ScreenInfoService.SetScreenName("SpeechDownloadPopup")
  return o
end

function SpeechDownloadPopup:_proceedWithDownload()
  print("SpeechDownloadPopup _proceedWithDownload")
  self:_downloadSpeechforSelectedCellIndex()
end

function SpeechDownloadPopup:_getCellsData()
  local cellsData = {}
  if self.countriesData ~= nil then
    do
      for _FORV_5_ = 1, #self.countriesData do
        local cellData = self.countriesData[_FORV_5_]
        local hasCellAltBackground = true
        local isCellSelected = false
        local currentCellProgress = 0
        local currentCellStatus = 0
        if _FORV_5_ % 2 == 0 then
          hasCellAltBackground = false
        end
        if self.currentCountryID == cellData.country_id then
          self.selectedCellIndex = cellData.cell_id
          print("selectedCellIndex=" .. tostring(self.selectedCellIndex) .. " currentDownloadedLocale==" .. tostring(self.currentDownloadedLocale))
          isCellSelected = true
        end
        if cellData.country_id == self.currentDownloadedLocale then
          currentCellProgress = self.speechProgress
          currentCellStatus = self.speechStatus
        end
        table.insert(cellsData, {
          label = cellData.name,
          image = {
            name = "$Flag128x128",
            id = cellData.flag_asset_id
          },
          id = cellData.cell_id,
          alternateBackground = hasCellAltBackground,
          selected = isCellSelected,
          progress = currentCellProgress,
          downloadStatus = currentCellStatus
        })
      end
    end
  end
  TableUtil.print(cellsData)
  print("selectedCellIndex==" .. tostring(self.selectedCellIndex))
  return cellsData
end

function SpeechDownloadPopup:_publishCountriesData()
  return {
    index = self.selectedCellIndex,
    data = self.currentCellsData
  }
end

function SpeechDownloadPopup:setSelectedCellIndex(index)
  if index == -1 or self.speechDownloadUpdateStatus == SpeechDownloadFEStatusUpdate.DOWNLOAD_IN_PROGRESS then
    return
  end
  if self.selectedCellIndex == index then
    return
  end
  if self.currentCountryID ~= self.countriesData[index + 1].country_id then
    self.currentCountryID = self.countriesData[index + 1].country_id
    self.currentCellsData = self:_getCellsData()
    if self.currentCellsData[index + 1].downloadStatus == 0 then
      if self.speechDownloadUpdateStatus ~= SpeechDownloadFEStatusUpdate.DOWNLOAD_NOT_STARTED then
        self.speechDownloadUpdateStatus = SpeechDownloadFEStatusUpdate.DOWNLOAD_NOT_STARTED
        self.im.Refresh(BND_FOOTER)
      end
    elseif self.currentCellsData[index + 1].downloadStatus == 1 then
      self.speechDownloadUpdateStatus = SpeechDownloadFEStatusUpdate.DOWNLOAD_PAUSED
      self.im.Refresh(BND_FOOTER)
    elseif self.currentCellsData[index + 1].downloadStatus == 2 then
      self.speechDownloadUpdateStatus = SpeechDownloadFEStatusUpdate.DOWNLOAD_COMPLETE
      self.im.Refresh(BND_FOOTER)
    end
    self.im.Refresh(BND_COUNTRY_LIST)
    self.im.ChangeActionState(ACT_OK_DOWNLOAD, self.im.GetActionState("VALID"))
  end
  print("SpeechDownloadPopup::selectedCellIndex==" .. tostring(self.selectedCellIndex) .. " index==" .. tostring(index))
end

function SpeechDownloadPopup:_publishFooter()
  self.footer = {
    {
      label = ("Cancel"),
      icon = "$",
      clickAction = ACT_CANCEL_DOWNLOAD
    }
  }
  if self.currentCountryID == -1 then
    table.insert(self.footer, {
      label = ("Download"),
      icon = "$",
      clickAction = ACT_OK_DOWNLOAD,
      enabled = false
    })
  elseif self.speechDownloadUpdateStatus == SpeechDownloadFEStatusUpdate.DOWNLOAD_NOT_STARTED then
    table.insert(self.footer, {
      label = ("Download"),
      icon = "$",
      clickAction = ACT_OK_DOWNLOAD
    })
  elseif self.speechDownloadUpdateStatus == SpeechDownloadFEStatusUpdate.DOWNLOAD_IN_PROGRESS then
    table.insert(self.footer, {
      label = ("Pause"),
      icon = "$",
      clickAction = ACT_PAUSE_DOWNLOAD
    })
  elseif self.speechDownloadUpdateStatus == SpeechDownloadFEStatusUpdate.DOWNLOAD_PAUSED then
    table.insert(self.footer, {
      label = ("Resume"),
      icon = "$",
      clickAction = ACT_OK_DOWNLOAD
    })
  elseif self.speechDownloadUpdateStatus == SpeechDownloadFEStatusUpdate.DOWNLOAD_COMPLETE then
    self.footer = {
      {
        label = ("OK"),
        icon = "$",
        clickAction = ACT_CLOSE_POPUP
      }
    }
  elseif self.speechDownloadUpdateStatus == SpeechDownloadFEStatusUpdate.DOWNLOAD_CONN_CHECK then
    table.insert(self.footer, {
      label = ("OK"),
      icon = "$",
      clickAction = ACT_OK_DOWNLOAD
    })
  end
  self.im.Publish(BND_FOOTER, self.footer)
end

function SpeechDownloadPopup:_closePopup()
  self.nav.Event(nil, "evt_hide_blocking_load")
  self.nav.Event(nil, "evt_hide_speechdownload_popup")
end

function SpeechDownloadPopup:_downloadSpeechforSelectedCellIndex()
  if self.selectedCellIndex ~= -1 then
    self.nav.Event(nil, "evt_show_blocking_load")
    self.services.SpeechDownloadService.DownloadSpeech(self.selectedCellIndex)
    self.currentCellsData = self:_getCellsData()
    self.currentDownloadedLocale = self.countriesData[self.selectedCellIndex + 1].country_id
    self.im.Refresh(BND_COUNTRY_LIST)
  end
end

function SpeechDownloadPopup:updateProgress(data)
  self.speechProgress = data
  self.currentCellsData = self:_getCellsData()
  self.im.Refresh(BND_COUNTRY_LIST)
end

function SpeechDownloadPopup:updateState(statusValue, errorCodeId)
  print("SpeechDownloadPopup::updateState::state==" .. tostring(statusValue))
  self.speechDownloadUpdateStatus = statusValue
  self.errorCodeId = errorCodeId
  if statusValue == SpeechDownloadFEStatusUpdate.DOWNLOAD_PAUSED then
    self.speechStatus = DOWNLOAD_PAUSED
  elseif statusValue == SpeechDownloadFEStatusUpdate.DOWNLOAD_COMPLETE then
    self.speechStatus = DOWNLOAD_COMPLETE
  else
    self.speechStatus = DOWNLOAD_NOT_STARTED
  end
  if self.errorCodeId > SpeechDownloadError.ERROR_NONE then
    self:_onError()
  end
  self:_updateStatusLabel(statusValue)
  self:_publishFooter()
end

function SpeechDownloadPopup:_onError()
  local buttonClose = VirtualButton:new({
    nav = self.nav,
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  })
  local popupMessage = ""
  if self.errorCodeId == SpeechDownloadError.ERROR_CONNECTION_ISSUE then
    popupMessage = "Connection error. Please check your connection settings and try again later"
  elseif self.errorCodeId == SpeechDownloadError.ERROR_NOT_ENOUGH_SPACE then
    popupMessage = "There is not enough space. Please delete unnecessary files and try again"
  elseif self.errorCodeId == SpeechDownloadError.ERROR_NO_INTERNET_CONNECTION then
    popupMessage = "There is no internet connection. Please check your internet connection settings and try again later"
  elseif self.errorCodeId == SpeechDownloadError.ERROR_SERVER_DOWN then
    popupMessage = "The server is temporarily unavailable. Please try again later"
  elseif self.errorCodeId == SpeechDownloadError.ERROR_RENAME_BIG then
    popupMessage = "Unable to rename file. Please reinstall the application"
  elseif self.errorCodeId == SpeechDownloadError.ERROR_UNSUPPORTED_LANGUAGE then
    popupMessage = "Unsupported language. Please use a supported language"
  elseif self.errorCodeId == SpeechDownloadError.ERROR_ALREADY_DOWNLOADED then
    popupMessage = "The commentary has been downloaded"
  elseif self.errorCodeId == SpeechDownloadError.ERROR_SPEECH_FILE_NOT_FOUND then
    popupMessage = "The commentary file was not found. Please download the explanation package again"
  end
  local popupData = {
    title = "Download failed",
    message = popupMessage,
    buttons = {buttonClose}
  }
  self.isErrorPopupOpen = true
  self.nav.Event(nil, "evt_show_popup", popupData)
  self.nav.Event(nil, "evt_hide_blocking_load")
end

function SpeechDownloadPopup:_updateStatusLabel(statusValue)
  if statusValue ~= SpeechDownloadFEStatusUpdate.DOWNLOAD_CONN_CHECK then
    self.statusLabel = ("You can download or change the commentary later from the [Volume and Commentary] menu")
  else
    self.statusLabel = ("You will use traffic data to download a large file. Are you sure you want to continue?")
  end
  self.im.Refresh(BND_SPEECH_STATUS)
end

function SpeechDownloadPopup:_handleEvent(eventType, data)
  if eventType == EVENT_TYPES.SpeechDownloadStarted then
    self.nav.Event(nil, "evt_hide_blocking_load")
  elseif eventType == EVENT_TYPES.CheckWifiConnectionStatusData then
    self.nav.Event(nil, "evt_hide_blocking_load")
    local buttonOk = {
      label = "好的",
      clickEvents = {
        "evt_hide_popup"
      },
      clickCallback = function()
        self:_proceedWithDownload()
      end
      
    }
    local buttonCancel = {
      label = "Cancel",
      clickEvents = {
        "evt_hide_popup"
      }
    }
    local popupData = {
      title = "Large file download warning",
      message = "You are about to start a large download, but it seems that you are not connected to WI-FI. Do you still want to continue downloading?",
      buttons = {buttonCancel, buttonOk}
    }
    self.isConfirmPopupOpen = true
    self.nav.Event(nil, "evt_show_popup", popupData)
  elseif eventType == EVENT_TYPES.CheckWifiConnectionStatusWifi then
    self.nav.Event(nil, "evt_hide_blocking_load")
    local buttonOk = {
      label = "OK",
      clickEvents = {
        "evt_hide_popup"
      },
      clickCallback = function()
        self:_proceedWithDownload()
      end
      
    }
    local popupData = {
      title = "Large file download warning",
      message = "You are about to start a large file download. After the download starts, please ensure that your WI-FI connection is normal",
      buttons = {buttonOk}
    }
    self.isConfirmPopupOpen = true
    self.nav.Event(nil, "evt_show_popup", popupData)
  elseif eventType == EVENT_TYPES.OnBackPressed then
    print("[SpeechDownloadPopup]: _handleEvent() OnBackPressed isConfirmPopupOpen " .. tostring(self.isConfirmPopupOpen) .. " self.isErrorPopupOpen " .. tostring(self.isErrorPopupOpen))
    if self.isConfirmPopupOpen == true then
      self.isConfirmPopupOpen = false
    elseif self.isErrorPopupOpen == true then
      self.isErrorPopupOpen = false
    else
      self:_closePopup()
      self.services.SpeechDownloadService.CancelDownloadSpeech(false)
    end
  end
end

function SpeechDownloadPopup:finalize()
  print("[SpeechDownloadPopup]: finalize()")
  self.im.UnregisterAction(ACT_OK_DOWNLOAD)
  self.im.UnregisterAction(ACT_CANCEL_DOWNLOAD)
  self.im.UnregisterAction(ACT_PAUSE_DOWNLOAD)
  self.im.UnregisterAction(ACT_CLOSE_POPUP)
  self.im.Unsubscribe(BND_FOOTER)
  self.im.Unsubscribe(BND_SPEECH_STATUS)
  self.im.UnregisterDataAction(BND_LNG_INDEX, ACT_CHANGE)
  self.im.Unsubscribe(BND_COUNTRY_LIST)
  self.im.Unsubscribe(BND_COUNTRY_SELECTED)
  self.services.SpeechDownloadService.UnRegisterListener(SpeechDownloadServiceListener.UPDATE_GUI_PROGRESS)
  self.services.SpeechDownloadService.UnRegisterListener(SpeechDownloadServiceListener.UPDATE_GUI_STATE)
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  self.services.ScreenInfoService.UnsetScreenName("SpeechDownloadPopup")
end

return SpeechDownloadPopup
