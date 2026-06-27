-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local ControlsHelp = {}

local TITLE_LABEL = "TITLE"
local SUBTITLE_LABEL = "SUBTITLE"
local CONTENT_LABEL = "CONTENT"
local IMAGE_NAME = "IMAGE"
local PASS_LABEL = "PASS"
local THROUGH_LABEL = "THROUGH"
local SHOOT_LABEL = "SHOOT"
local SPRINT_OFF_LABEL = "SPRINT_OFF"
local SWITCH_LABEL = "SWITCH"
local DEFENDER_2ND_LABEL = "2ND_DEFENDER"
local TACKLE_BASIC_LABEL = "TACKLE_BASIC"
local SPRINT_DEFF_LABEL = "SPRINT_DEFF"
local MENTALITY_LABEL = "MENTALITY"

local BND_PAGE_TITLE = "bnd_page_title"
local BND_SUBPAGE_TITLE = "bnd_subpage_title"
local BND_SUBPAGE_CONTENT = "bnd_subpage_content"
local BND_SUB_PAGE_IMAGE = "bnd_sub_page_image"
local BND_SWIPE = "bnd_swipe"

local ACT_GO_RIGHT = "act_go_right"
local ACT_GO_LEFT = "act_go_left"
local ACT_SWIPE = "act_swipe"
local ACT_ON_IMAGE_LOADED = "act_on_image_loaded"

local BND_SWITCH_VISIBLE = "bnd_switch_visible"
local BND_2ND_DEFENDER_VISIBLE = "bnd_2nd_defender_visible"
local BND_TACKLE_BASIC_VISIBLE = "bnd_tackle_basic_visible"
local BND_SPRINT_DEFFENCE_VISIBLE = "bnd_sprint_deffence_visible"
local BND_PASS_VISIBLE = "bnd_pass_visible"
local BND_THROUGH_VISIBLE = "bnd_through_visible"
local BND_SHOOT_VISIBLE = "bnd_shoot_visible"
local BND_SPRINT_OFFENCE_VISIBLE = "bnd_sprint_offence_visible"
local BND_MENTALITY_VISIBLE = "bnd_mentality_visible"

function ControlsHelp:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  o.controlsData = {
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "HS_Tut_Passing_1",
      [CONTENT_LABEL] = "LTXT_MOB_CASUAL_PASS",
      [IMAGE_NAME] = "$controls_help_Passing",
      [PASS_LABEL] = true,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "f13_shooting",
      [CONTENT_LABEL] = "LTXT_MOB_CASUAL_SHOOT",
      [IMAGE_NAME] = "$controls_help_Shooting",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = true,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "GP_Tut_FloatingDpad_1",
      [CONTENT_LABEL] = "LTXT_MOB_CASUAL_DPAD",
      [IMAGE_NAME] = "$controls_help_Floating_D_Pad",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "HS_Tut_HardStop_1",
      [CONTENT_LABEL] = "HS_Tut_HardStop_2",
      [IMAGE_NAME] = "$controls_help_Hard_Stop",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = true,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "FAQ_KnockForward",
      [CONTENT_LABEL] = "HS_Tut_KnockFoward",
      [IMAGE_NAME] = "$controls_help_Knock_Forward",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = true,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "HS_Tut_AutoDribble_1",
      [CONTENT_LABEL] = "HS_Tut_AutoDribble_2",
      [IMAGE_NAME] = "$controls_help_Move_Assistance",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "LTXT_MOB_CASUAL_PG",
      [CONTENT_LABEL] = "HS_Tut_PassAndGo_1",
      [IMAGE_NAME] = "$controls_help_Pass_Go",
      [PASS_LABEL] = true,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "f15_setpieces",
      [CONTENT_LABEL] = "LTXT_MOB_CASUAL_SETP",
      [IMAGE_NAME] = "$controls_help_Set_pieces",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "GP_Tut_Mentality_1",
      [CONTENT_LABEL] = "LTXT_MOB_CASUAL_CHANGE_MENT",
      [IMAGE_NAME] = "$controls_help_Change_Mentality",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = true
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "HS_Tut_Press_1",
      [CONTENT_LABEL] = "LTXT_MOB_CASUAL_SP_TACKLE",
      [IMAGE_NAME] = "$controls_help_Sprint_Tackle",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_COMMON",
      [SUBTITLE_LABEL] = "GP_Tut_PaceControlEnter_1",
      [CONTENT_LABEL] = "HS_Tut_SkilledDribble",
      [IMAGE_NAME] = "$controls_help_Skilled_Dribble",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROL_CASUAL",
      [SUBTITLE_LABEL] = "GS_Sliding_Tackle",
      [CONTENT_LABEL] = "HS_Tut_Slidetackle",
      [IMAGE_NAME] = "$controls_help_Slide_Tackle",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = true,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROL_CLASSIC",
      [SUBTITLE_LABEL] = "HS_Tut_Call2ndDef_1",
      [CONTENT_LABEL] = "HS_Tut_Call2ndDef_2",
      [IMAGE_NAME] = "$controls_help_Call_2nd_Defender",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = true,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROL_CLASSIC",
      [SUBTITLE_LABEL] = "HS_Tut_GroundAndLow_1",
      [CONTENT_LABEL] = "HS_Tut_GroundAndLow_2",
      [IMAGE_NAME] = "$controls_help_Ground_and_Low_Cross",
      [PASS_LABEL] = true,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROL_CLASSIC",
      [SUBTITLE_LABEL] = "HS_Tut_throughball_1",
      [CONTENT_LABEL] = "HS_Tut_throughball_2",
      [IMAGE_NAME] = "$controls_help_Through_Ball",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = true,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROL_CLASSIC",
      [SUBTITLE_LABEL] = "FAQ_ChipShot",
      [CONTENT_LABEL] = "HS_Tut_Chipshot",
      [IMAGE_NAME] = "$controls_help_Chip_Shot",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = true,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROL_CLASSIC",
      [SUBTITLE_LABEL] = "FAQ_FinesseShot",
      [CONTENT_LABEL] = "HS_Tut_FinesseShot_2",
      [IMAGE_NAME] = "$controls_help_Finesse_Shot",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = true,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROL_CLASSIC",
      [SUBTITLE_LABEL] = "f12_mm_gk_rush",
      [CONTENT_LABEL] = "LTXT_MOB_TUT_GKRUSH",
      [IMAGE_NAME] = "$controls_help_GK_Rush",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = true,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_TOUCH",
      [SUBTITLE_LABEL] = "HS_Tut_TouchPassing_1",
      [CONTENT_LABEL] = "HS_Tut_TouchPassing_2",
      [IMAGE_NAME] = "$controls_help_Touch_Controls_Passing",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_TOUCH",
      [SUBTITLE_LABEL] = "HS_Tut_TouchShooting_1",
      [CONTENT_LABEL] = "HS_Tut_TouchShooting_2",
      [IMAGE_NAME] = "$controls_help_Touch_Controls_Shooting",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    },
    {
      [TITLE_LABEL] = "LTXT_MOB_CONTROLS_TOUCH",
      [SUBTITLE_LABEL] = "HS_Tut_TouchShootingAdv_1",
      [CONTENT_LABEL] = "LTXT_MOB_CASUAL_SHOOT_ADV",
      [IMAGE_NAME] = "$controls_help_Touch_Controls_Shooting_advanced",
      [PASS_LABEL] = false,
      [THROUGH_LABEL] = false,
      [SHOOT_LABEL] = false,
      [SPRINT_OFF_LABEL] = false,
      [SWITCH_LABEL] = false,
      [DEFENDER_2ND_LABEL] = false,
      [TACKLE_BASIC_LABEL] = false,
      [SPRINT_DEFF_LABEL] = false,
      [MENTALITY_LABEL] = false
    }
  }
  
  o.subPageIndex = 1
  
  o.noOfPages = table.getn(o.controlsData)
  
  o.im.Subscribe(BND_PAGE_TITLE, function()
    o:publishPageTitle()
  end)
  o.im.Subscribe(BND_SUBPAGE_TITLE, function()
    o:publishSubPageTitle()
  end)
  o.im.Subscribe(BND_SUBPAGE_CONTENT, function()
    o:publishSubPageCnt()
  end)
  o.im.Subscribe(BND_SUB_PAGE_IMAGE, function()
    o:publishSubPageImage()
  end)
  o.im.Subscribe(BND_SWITCH_VISIBLE, function()
    o:_publishSwitchVisible(o.controlsData[o.subPageIndex][SWITCH_LABEL])
  end)
  o.im.Subscribe(BND_2ND_DEFENDER_VISIBLE, function()
    o:_publish2ndDefenderVisible(o.controlsData[o.subPageIndex][DEFENDER_2ND_LABEL])
  end)
  o.im.Subscribe(BND_TACKLE_BASIC_VISIBLE, function()
    o:_publishTackleBasicVisible(o.controlsData[o.subPageIndex][TACKLE_BASIC_LABEL])
  end)
  o.im.Subscribe(BND_SPRINT_DEFFENCE_VISIBLE, function()
    o:_publishSprintDeffVisible(o.controlsData[o.subPageIndex][SPRINT_DEFF_LABEL])
  end)
  o.im.Subscribe(BND_PASS_VISIBLE, function()
    o:_publishPassVisible(o.controlsData[o.subPageIndex][PASS_LABEL])
  end)
  o.im.Subscribe(BND_THROUGH_VISIBLE, function()
    o:_publishThroughVisible(o.controlsData[o.subPageIndex][THROUGH_LABEL])
  end)
  o.im.Subscribe(BND_SHOOT_VISIBLE, function()
    o:_publishShootVisible(o.controlsData[o.subPageIndex][SHOOT_LABEL])
  end)
  o.im.Subscribe(BND_SPRINT_OFFENCE_VISIBLE, function()
    o:_publishSprintOffVisible(o.controlsData[o.subPageIndex][SPRINT_OFF_LABEL])
  end)
  o.im.Subscribe(BND_MENTALITY_VISIBLE, function()
    o:_publishMentalityVisible(o.controlsData[o.subPageIndex][MENTALITY_LABEL])
  end)
  o.im.RegisterAction(ACT_GO_RIGHT, function()
    o:actGoRightFunction()
  end)
  o.im.RegisterAction(ACT_GO_LEFT, function()
    o:actGoLeftFunction()
  end)
  o.im.RegisterAction(ACT_ON_IMAGE_LOADED, function()
    o:_onActImageLoaded()
  end)
  o.im.RegisterDataAction(BND_SWIPE, ACT_SWIPE, function(bindingName, actionName, swipeEvent, evnt)
    if swipeEvent.swipeType == "SWIPE_LEFT" then
      o:actGoRightFunction()
    elseif swipeEvent.swipeType == "SWIPE_RIGHT" then
      o:actGoLeftFunction()
    end
  end)
  o:publishSubPageUpdate()
  return o
end
function ControlsHelp:_publishSwitchVisible(boolValue)
  self.im.Publish(BND_SWITCH_VISIBLE, boolValue)
end
function ControlsHelp:_publish2ndDefenderVisible(boolValue)
  self.im.Publish(BND_2ND_DEFENDER_VISIBLE, boolValue)
end
function ControlsHelp:_publishTackleBasicVisible(boolValue)
  self.im.Publish(BND_TACKLE_BASIC_VISIBLE, boolValue)
end
function ControlsHelp:_publishSprintDeffVisible(boolValue)
  self.im.Publish(BND_SPRINT_DEFFENCE_VISIBLE, boolValue)
end
function ControlsHelp:_publishPassVisible(boolValue)
  self.im.Publish(BND_PASS_VISIBLE, boolValue)
end
function ControlsHelp:_publishThroughVisible(boolValue)
  self.im.Publish(BND_THROUGH_VISIBLE, boolValue)
end
function ControlsHelp:_publishShootVisible(boolValue)
  self.im.Publish(BND_SHOOT_VISIBLE, boolValue)
end
function ControlsHelp:_publishSprintOffVisible(boolValue)
  self.im.Publish(BND_SPRINT_OFFENCE_VISIBLE, boolValue)
end
function ControlsHelp:publishPageTitle()
  local dataToInsert = self.loc.LocalizeString(self.controlsData[self.subPageIndex][TITLE_LABEL])
  self.im.Publish(BND_PAGE_TITLE, dataToInsert)
end
function ControlsHelp:publishSubPageTitle()
  local dataToInsert = self.loc.LocalizeString(self.controlsData[self.subPageIndex][SUBTITLE_LABEL])
  self.im.Publish(BND_SUBPAGE_TITLE, dataToInsert)
end
function ControlsHelp:publishSubPageCnt()
  local dataToInsert = self.loc.LocalizeString(self.controlsData[self.subPageIndex][CONTENT_LABEL])
  self.im.Publish(BND_SUBPAGE_CONTENT, dataToInsert)
end
function ControlsHelp:publishSubPageImage()
  local dataToInsert = self.controlsData[self.subPageIndex][IMAGE_NAME]
  self.im.Publish(BND_SUB_PAGE_IMAGE, dataToInsert)
end
function ControlsHelp:publishTextsOnButtonsForClassicControls(configButtons)
  self:_publishSwitchVisible(configButtons[SWITCH_LABEL])
  self:_publish2ndDefenderVisible(configButtons[DEFENDER_2ND_LABEL])
  self:_publishTackleBasicVisible(configButtons[TACKLE_BASIC_LABEL])
  self:_publishSprintDeffVisible(configButtons[SPRINT_DEFF_LABEL])
  self:_publishPassVisible(configButtons[PASS_LABEL])
  self:_publishThroughVisible(configButtons[THROUGH_LABEL])
  self:_publishShootVisible(configButtons[SHOOT_LABEL])
  self:_publishSprintOffVisible(configButtons[SPRINT_OFF_LABEL])
  self:_publishMentalityVisible(configButtons[MENTALITY_LABEL])
end
function ControlsHelp:publishTextsOnButtonsForCasualControls(configButtons)
end
function ControlsHelp:publishTextsOnButtonsForHardwareControls(configButtons)
end
function ControlsHelp:publishTextsOnButtons()
  local configButtons = self.controlsData[self.subPageIndex]
  if self.subPageIndex >= 1 and self.subPageIndex <= 22 then
    self:publishTextsOnButtonsForClassicControls(configButtons)
  else
    self:publishTextsOnButtonsForHardwareControls(configButtons)
  end
end

function ControlsHelp:publishSubPageUpdate()
  self:publishSubPageImage()
  self:publishPageTitle()
  self:publishSubPageTitle()
  self:publishSubPageCnt()
end

function ControlsHelp:actGoRightFunction()
  self.subPageIndex = self.subPageIndex + 1
  if self.subPageIndex > self.noOfPages then
    self.subPageIndex = 1
  end
  self:hideAllLabels()
  self:publishSubPageUpdate()
end

function ControlsHelp:actGoLeftFunction()
  self.subPageIndex = self.subPageIndex - 1
  if self.subPageIndex < 1 then
    self.subPageIndex = self.noOfPages
  end
  self:hideAllLabels()
  self:publishSubPageUpdate()
end

function ControlsHelp:_publishMentalityVisible(boolValue)
  self.im.Publish(BND_MENTALITY_VISIBLE, boolValue)
end

function ControlsHelp:hideAllLabels()
  self:_publishSwitchVisible(false)
  self:_publish2ndDefenderVisible(false)
  self:_publishTackleBasicVisible(false)
  self:_publishSprintDeffVisible(false)
  self:_publishPassVisible(false)
  self:_publishThroughVisible(false)
  self:_publishShootVisible(false)
  self:_publishSprintOffVisible(false)
  self:_publishMentalityVisible(false)
end

function ControlsHelp:_onActImageLoaded()
  self:publishTextsOnButtons()
end

function ControlsHelp:finalize()
  self.im.Unsubscribe(BND_PAGE_TITLE)
  self.im.Unsubscribe(BND_SUBPAGE_TITLE)
  self.im.Unsubscribe(BND_SUBPAGE_CONTENT)
  self.im.Unsubscribe(BND_SUB_PAGE_IMAGE)
  self.im.Unsubscribe(BND_SWITCH_VISIBLE)
  self.im.Unsubscribe(BND_2ND_DEFENDER_VISIBLE)
  self.im.Unsubscribe(BND_TACKLE_BASIC_VISIBLE)
  self.im.Unsubscribe(BND_SPRINT_DEFFENCE_VISIBLE)
  self.im.Unsubscribe(BND_PASS_VISIBLE)
  self.im.Unsubscribe(BND_THROUGH_VISIBLE)
  self.im.Unsubscribe(BND_SHOOT_VISIBLE)
  self.im.Unsubscribe(BND_SPRINT_OFFENCE_VISIBLE)
  self.im.Unsubscribe(BND_MENTALITY_VISIBLE)
  self.im.UnregisterAction(ACT_GO_RIGHT)
  self.im.UnregisterAction(ACT_GO_LEFT)
  self.im.UnregisterAction(ACT_ON_IMAGE_LOADED)
  self.im.UnregisterDataAction(BND_SWIPE, ACT_SWIPE)
end

return ControlsHelp