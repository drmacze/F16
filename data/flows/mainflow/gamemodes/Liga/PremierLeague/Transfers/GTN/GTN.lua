local GTN = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
local ACT_SETSCOUT = "act_setscout"
local ACT_SCOUTLIST = "act_scoutlist"
setupParam = 1

function GTN:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
  }
  
  o.im.Subscribe("bnd_matchday_label", function()
    o:publishLabel()
  end)
   
  o.im.RegisterAction(ACT_SETSCOUT, function(actionName, data)
    o:setScout()
  end)
  o.im.RegisterAction(ACT_SCOUTLIST, function(actionName, data)
    o:scoutList()
  end)

  return o
end
function GTN:publishLabel()
  self.im.Publish("bnd_matchday_label", "")
end

function GTN:setScout()
  local buttonYes = {
    icon = "$FooterIconNo",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "Scouts are currently unavailable.",
    buttons = {buttonYes}
  }
  if scoutassignment == "intransit" then
    popupData.message = "Scouts are not available."
    buttonYes.clickEvents = {"evt_hide_popup"}
    self.nav.Event(nil, "evt_show_popup", popupData)
  else
    buttonYes.clickEvents = {self.nav.Event(nil, "evt_tolist")}
  end
end
function GTN:scoutList()
    local buttonYes = {
        icon = "$FooterIconNo",
        label = "Close",
        clickEvents = {"evt_hide_popup"} -- Default, no need to reassign in most cases
    }
    local popupData = {
        title = "INFO",
        message = "",
        buttons = {buttonYes}
    }

    local function parseDate(dateStr)
        local day, month, year = dateStr:match("(%d%d)/(%d%d)/(%d%d)")
        return tonumber(day), tonumber(month), tonumber(year)
    end

    local function isDateBefore(date1, date2)
        local d1, m1, y1 = parseDate(date1)
        local d2, m2, y2 = parseDate(date2)
        return y1 < y2 or (y1 == y2 and (m1 < m2 or (m1 == m2 and d1 < d2)))
    end

    -- Handle scouting status
    if ScoutAssignments and ScoutAssignments["SCOUT_TIME"] then
        local currentDate = GLOBAL_DATE_PLACEHOLDER
        local scoutEndDate = ScoutAssignments["SCOUT_TIME"]
        if isDateBefore(currentDate, scoutEndDate) then
            popupData.message = "The scout is doing analysis. Wait until " .. scoutEndDate
            self.nav.Event(nil, "evt_show_popup", popupData)
            return -- Exit early after showing popup
        end
        -- If date is reached, fall through to proceed without popup
    elseif not ScoutSssignments then
        popupData.message = "You haven't set up the scout yet."
        self.nav.Event(nil, "evt_show_popup", popupData)
        return
    end

    -- If no popup conditions met, proceed to scouting screen
    buttonYes.clickEvents = {self.nav.Event(nil, "evt_toscout")} -- Corrected to event name, not execution
    -- Note: If evt_toscout needs to be triggered immediately, use self.nav.Event(nil, "evt_toscout")
end
function GTN:finalize()
  self.im.UnregisterAction(ACT_SETSCOUT)
  self.im.UnregisterAction(ACT_SCOUTLIST)
  self.im.Unsubscribe("bnd_matchday_label")
end
return GTN