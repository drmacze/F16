-- Menu Player Career --
-- Male Remode By Septiawan --

local Male = {}
local ACT_TAB_EPL = "act_tab_epl"
local ACT_TAB_LALIGA = "act_tab_laliga"
local ACT_TAB_SERIEA = "act_tab_seriea"
local ACT_TAB_BUNDESLIGA = "act_tab_bundesliga"
local ACT_TAB_LIGUE = "act_tab_ligue"
local ACT_CONFIRM_EPL = "act_confirm_epl"
local ACT_CONFIRM_LALIGA = "act_confirm_laliga"
local ACT_CONFIRM_SERIEA = "act_confirm_seriea"
local ACT_CONFIRM_BUNDESLIGA = "act_confirm_bundesliga"
local ACT_CONFIRM_LIGUE = "act_confirm_ligue"
local ACT_NEXT_UPDATE = "act_next_update"
function Male:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
  }
    o.playerbg = {
    name = "$_FC_PLAYER3DX",
    id = 0
  }
  o.leagueEpl = { name = "$LeaguePlayer", id = 13 }
  o.leagueLaliga = { name = "$LeaguePlayer", id = 53 }
  o.leagueSerieA  = { name = "$LeaguePlayer",  id = 31 }
  o.leagueBundesliga  = { name = "$LeaguePlayer",  id = 19 }
  o.leagueLigue  = { name = "$LeaguePlayer",  id = 16 }
  o.leaguesEpl = { name = "$LeaguesPlayer", id = 13 }
  o.leaguesLaliga = { name = "$LeaguesPlayer", id = 53 }
  o.leaguesSerieA = { name = "$LeaguesPlayer", id = 31 }
  o.leaguesBundesliga = { name = "$LeaguesPlayer", id = 19 }
  o.leaguesLigue = { name = "$LeaguesPlayer", id = 16 }
  o.flagEpl = { name = "$Flag128x128", id = 14 }
  o.flagLaliga = { name = "$Flag128x128", id = 45 }
  o.flagSerieA    = { name = "$Flag128x128",    id = 27 }
  o.flagBundesliga    = { name = "$Flag128x128",    id = 21 }
  o.flagLigue    = { name = "$Flag128x128",    id = 18 }
  o.iconEpl = { name = "$Icons_Mins" }
  o.iconLaliga = { name = "$Icons_Mins" }
  o.iconSerieA    = { name = "$Icons_Mins" }
  o.iconBundesliga    = { name = "$Icons_Mins" }
  o.iconLigue    = { name = "$Icons_Mins" } 
  o.iconsEpl = { name = "$Icons_Plus" }  
  o.iconsLaliga = { name = "$Icons_Plus" }
  o.iconsSerieA   = { name = "$Icons_Plus" }
  o.iconsBundesliga   = { name = "$Icons_Plus" }
  o.iconsLigue   = { name = "$Icons_Plus" }
  o.iconActive = { name = "$Icons_Active" }
  o.labelEPLOff = "Premier League"
  o.labelEPLOn = "Premier League"
  o.labelLaligaOff = "LaLiga EA Sports"
  o.labelLaligaOn = "LaLiga EA Sports"
  o.labelSerieAOff = "Serie A TIM"
  o.labelSerieAOn  = "Serie A TIM"
  o.labelBundesligaOff = "Bundesliga"
  o.labelBundesligaOn  = "Bundesliga"
  o.labelLigueOff = "Ligue 1 McDonald's"
  o.labelLigueOn  = "Ligue 1 McDonald's"
  o.activeTab = "none"
  
  math.randomseed(os.clock() * 1357 + os.time())
  local currentTime = os.date("%H") + 0
  local random2 = math.random(10)

  o.im.Subscribe("bnd_active_epl_on", function()
    o:OnConfirmEplClicked()
  end)
  o.im.Subscribe("bnd_active_laliga_on", function()
    o:OnConfirmLaligaClicked()
  end)
  o.im.Subscribe("bnd_active_seriea_on", function()
    o:OnConfirmSerieAClicked()
  end)
  o.im.Subscribe("bnd_active_bundesliga_on", function()
    o:OnConfirmBundesligaClicked()
  end)
  o.im.Subscribe("bnd_active_ligue_on", function()
    o:OnConfirmLigueClicked()
  end)
  o.im.Subscribe("bnd_true_epl_on", function()
    o:OnConfirmEplClicked()
  end)
  o.im.Subscribe("bnd_true_laliga_on", function()
    o:OnConfirmLaligaClicked()
  end)
  o.im.Subscribe("bnd_true_bundesliga_on", function()
    o:OnConfirmBundesligaClicked()
  end)
  o.im.Subscribe("bnd_true_seriea_on", function()
    o:OnConfirmSerieAClicked()
  end)
  o.im.Subscribe("bnd_true_ligue_on", function()
    o:OnConfirmLigueClicked()
  end)
  o.im.Subscribe("bnd_false_epl_off", function()
    o.im.Publish("bnd_false_epl_off", o.iconEpl)
  end)
  o.im.Subscribe("bnd_false_laliga_off", function()
    o.im.Publish("bnd_false_laliga_off", o.iconLaliga)
  end)
  o.im.Subscribe("bnd_false_bundesliga_off", function()
    o.im.Publish("bnd_false_bundesliga_off", o.iconBundesliga)
  end)
  o.im.Subscribe("bnd_false_seriea_off", function()
    o.im.Publish("bnd_false_seriea_off", o.iconSerieA)
  end)
  o.im.Subscribe("bnd_false_ligue_off", function()
    o.im.Publish("bnd_false_ligue_off", o.iconLigue)
  end)
o.im.Subscribe("bnd_label_epl_off", function()
    o.im.Publish("bnd_label_epl_off", o.labelEPLOff)
  end)
  o.im.Subscribe("bnd_label_epl_on", function()
    o.im.Publish("bnd_label_epl_on", "")
  end)
  o.im.Subscribe("bnd_logo_epl_off", function()
    o.im.Publish("bnd_logo_epl_off", o.leagueEpl)
  end)
  o.im.Subscribe("bnd_logo_epl_on", function()
    o.im.Publish("bnd_logo_epl_on", "")
  end)
  o.im.Subscribe("bnd_flag_epl_off", function()
    o.im.Publish("bnd_flag_epl_off", o.flagEpl)
  end)
  o.im.Subscribe("bnd_flag_epl_on", function()
    o.im.Publish("bnd_flag_epl_on", "")
  end)
  o.im.Subscribe("bnd_icon_epl_off", function()
    o.im.Publish("bnd_icon_epl_off", o.iconEpl)
  end)
  o.im.Subscribe("bnd_icon_epl_on", function()
    o.im.Publish("bnd_icon_epl_on", "")
  end)
  o.im.Subscribe("bnd_label_laliga_off", function()
    o.im.Publish("bnd_label_laliga_off", o.labelLaligaOff)
  end)
  o.im.Subscribe("bnd_label_laliga_on", function()
    o.im.Publish("bnd_label_laliga_on", "")
  end)
  o.im.Subscribe("bnd_logo_laliga_off", function()
    o.im.Publish("bnd_logo_laliga_off", o.leagueLaliga)
  end)
  o.im.Subscribe("bnd_logo_laliga_on", function()
    o.im.Publish("bnd_logo_laliga_on", "")
  end)
  o.im.Subscribe("bnd_flag_laliga_off", function()
    o.im.Publish("bnd_flag_laliga_off", o.flagLaliga)
  end)
  o.im.Subscribe("bnd_flag_laliga_on", function()
    o.im.Publish("bnd_flag_laliga_on", "")
  end)
  o.im.Subscribe("bnd_icon_laliga_off", function()
    o.im.Publish("bnd_icon_laliga_off", o.iconLaliga)
  end)
  o.im.Subscribe("bnd_icon_laliga_on", function()
    o.im.Publish("bnd_icon_laliga_on", "")
  end)
  o.im.Subscribe("bnd_label_seriea_off", function()
    o.im.Publish("bnd_label_seriea_off", o.labelSerieAOff)
  end)
  o.im.Subscribe("bnd_label_seriea_on", function()
    o.im.Publish("bnd_label_seriea_on", "")
  end)
  o.im.Subscribe("bnd_logo_seriea_off", function()
    o.im.Publish("bnd_logo_seriea_off", o.leagueSerieA)
  end)
  o.im.Subscribe("bnd_logo_seriea_on", function()
    o.im.Publish("bnd_logo_seriea_on", "")
  end)
  o.im.Subscribe("bnd_flag_seriea_off", function()
    o.im.Publish("bnd_flag_seriea_off", o.flagSerieA)
  end)
  o.im.Subscribe("bnd_flag_seriea_on", function()
    o.im.Publish("bnd_flag_seriea_on", "")
  end)
  o.im.Subscribe("bnd_icon_seriea_off", function()
    o.im.Publish("bnd_icon_seriea_off", o.iconSerieA)
  end)
  o.im.Subscribe("bnd_icon_seriea_on", function()
    o.im.Publish("bnd_icon_seriea_on", "")
  end)
  o.im.Subscribe("bnd_label_bundesliga_off", function()
    o.im.Publish("bnd_label_bundesliga_off", o.labelBundesligaOff)
  end)
  o.im.Subscribe("bnd_label_bundesliga_on", function()
    o.im.Publish("bnd_label_bundesliga_on", "")
  end)
  o.im.Subscribe("bnd_logo_bundesliga_off", function()
    o.im.Publish("bnd_logo_bundesliga_off", o.leagueBundesliga)
  end)
  o.im.Subscribe("bnd_logo_bundesliga_on", function()
    o.im.Publish("bnd_logo_bundesliga_on", "")
  end)
  o.im.Subscribe("bnd_flag_bundesliga_off", function()
    o.im.Publish("bnd_flag_bundesliga_off", o.flagBundesliga)
  end)
  o.im.Subscribe("bnd_flag_bundesliga_on", function()
    o.im.Publish("bnd_flag_bundesliga_on", "")
  end)
  o.im.Subscribe("bnd_icon_bundesliga_off", function()
    o.im.Publish("bnd_icon_bundesliga_off", o.iconBundesliga)
  end)
  o.im.Subscribe("bnd_icon_bundesliga_on", function()
    o.im.Publish("bnd_icon_bundesliga_on", "")
  end)
  o.im.Subscribe("bnd_label_ligue_off", function()
    o.im.Publish("bnd_label_ligue_off", o.labelLigueOff)
  end)
  o.im.Subscribe("bnd_label_ligue_on", function()
    o.im.Publish("bnd_label_ligue_on", "")
  end)
  o.im.Subscribe("bnd_logo_ligue_off", function()
    o.im.Publish("bnd_logo_ligue_off", o.leagueLigue)
  end)
  o.im.Subscribe("bnd_logo_ligue_on", function()
    o.im.Publish("bnd_logo_ligue_on", "")
  end)
  o.im.Subscribe("bnd_flag_ligue_off", function()
    o.im.Publish("bnd_flag_ligue_off", o.flagLigue)
  end)
  o.im.Subscribe("bnd_flag_ligue_on", function()
    o.im.Publish("bnd_flag_ligue_on", "")
  end)
  o.im.Subscribe("bnd_icon_ligue_off", function()
    o.im.Publish("bnd_icon_ligue_off", o.iconLigue)
  end)
  o.im.Subscribe("bnd_icon_ligue_on", function()
    o.im.Publish("bnd_icon_ligue_on", "")
  end) 
  o.im.RegisterAction(ACT_TAB_EPL, function()
    o:OnTabEplClicked()
  end)
  o.im.RegisterAction(ACT_TAB_LALIGA, function()
    o:OnTabLaligaClicked()
  end)
  o.im.RegisterAction(ACT_TAB_SERIEA, function()
    o:OnTabSerieAClicked()
  end)
  o.im.RegisterAction(ACT_TAB_BUNDESLIGA, function()
    o:OnTabBundesligaClicked()
  end)
  o.im.RegisterAction(ACT_TAB_LIGUE, function()
    o:OnTabLigueClicked()
  end)
  o.im.RegisterAction(ACT_CONFIRM_EPL, function()
    o:OnConfirmEplClicked()
  end)
  o.im.RegisterAction(ACT_CONFIRM_LALIGA, function()
    o:OnConfirmLaligaClicked()
  end)
  o.im.RegisterAction(ACT_CONFIRM_SERIEA, function()
    o:OnConfirmSerieAClicked()
  end)
  o.im.RegisterAction(ACT_CONFIRM_BUNDESLIGA, function()
    o:OnConfirmBundesligaClicked()
  end)
  o.im.RegisterAction(ACT_CONFIRM_LIGUE, function()
    o:OnConfirmLigueClicked()
  end)
  o.im.RegisterAction(ACT_NEXT_UPDATE, function()
    o:NextUpdate()
  end)

  o.im.Publish("bnd_label_epl_off", o.labelEPLOff)
  o.im.Publish("bnd_label_epl_on", "")
  o.im.Publish("bnd_logo_epl_off", o.leagueEpl)
  o.im.Publish("bnd_logo_epl_on", "")
  o.im.Publish("bnd_flag_epl_off", o.flagEpl)
  o.im.Publish("bnd_flag_epl_on", "")
  o.im.Publish("bnd_false_epl_off", o.iconEpl)
  o.im.Publish("bnd_false_laliga_off", o.iconLaliga)
  o.im.Publish("bnd_false_seriea_off", o.iconSerieA)
  o.im.Publish("bnd_false_bundesliga_off", o.iconBundesliga)
  o.im.Publish("bnd_icon_epl_off", o.iconEpl)
  o.im.Publish("bnd_icon_epl_on", "")
  o.im.Publish("bnd_label_laliga_off", o.labelLaligaOff)
  o.im.Publish("bnd_label_laliga_on", "")
  o.im.Publish("bnd_logo_laliga_off", o.leagueLaliga)
  o.im.Publish("bnd_logo_laliga_on", "")
  o.im.Publish("bnd_flag_laliga_off", o.flagLaliga)
  o.im.Publish("bnd_flag_laliga_on", "")
  o.im.Publish("bnd_icon_laliga_off", o.iconLaliga)
  o.im.Publish("bnd_icon_laliga_on", "")
  return o
end

function Male:OnTabEplClicked()
  self.activeTab = "EPL"
  self.im.Publish("bnd_true_laliga_on", "")
  self.im.Publish("bnd_true_seriea_on", "")
  self.im.Publish("bnd_true_bundesliga_on", "")
  self.im.Publish("bnd_true_ligue_on", "")
  self.im.Publish("bnd_active_laliga_on", "")
  self.im.Publish("bnd_active_seriea_on", "")
  self.im.Publish("bnd_active_bundesliga_on", "")
  self.im.Publish("bnd_active_ligue_on", "")
  self.im.Publish("bnd_icon_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_icon_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_icon_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_icon_ligue_off", self.iconLigue)
  self.im.Publish("bnd_false_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_false_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_false_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_false_ligue_off", self.iconLigue)  
  self.nav.Event(nil, "evt_tab2")
  self:RefreshLabels()
end

function Male:OnTabLaligaClicked()
  self.activeTab = "LALIGA"
  self.im.Publish("bnd_true_epl_on", "")
  self.im.Publish("bnd_true_seriea_on", "")
  self.im.Publish("bnd_true_bundesliga_on", "")
  self.im.Publish("bnd_true_ligue_on", "")
  self.im.Publish("bnd_active_epl_on", "")
  self.im.Publish("bnd_active_seriea_on", "")
  self.im.Publish("bnd_active_bundesliga_on", "")
  self.im.Publish("bnd_active_ligue_on", "")
  self.im.Publish("bnd_icon_epl_off", self.iconEpl)
  self.im.Publish("bnd_icon_seriea_off", self.iconSerieA)  
  self.im.Publish("bnd_icon_bundesliga_off", self.iconBundesliga)  
  self.im.Publish("bnd_icon_ligue_off", self.iconLigue)
  self.im.Publish("bnd_false_epl_off", self.iconEpl)
  self.im.Publish("bnd_false_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_false_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_false_ligue_off", self.iconLigue)  
  self.nav.Event(nil, "evt_tab3")
  self:RefreshLabels()
end

function Male:OnTabSerieAClicked()
  self.activeTab = "SERIEA"
  self.im.Publish("bnd_true_epl_on", "")
  self.im.Publish("bnd_true_laliga_on", "")
  self.im.Publish("bnd_true_bundesliga_on", "")
  self.im.Publish("bnd_true_ligue_on", "")
  self.im.Publish("bnd_active_epl_on", "")
  self.im.Publish("bnd_active_laliga_on", "")
  self.im.Publish("bnd_active_bundesliga_on", "")
  self.im.Publish("bnd_active_ligue_on", "") 
  self.im.Publish("bnd_icon_epl_off", self.iconEpl)
  self.im.Publish("bnd_icon_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_icon_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_icon_ligue_off", self.iconLigue)
  self.im.Publish("bnd_false_epl_off", self.iconEpl)
  self.im.Publish("bnd_false_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_false_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_false_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_false_ligue_off", self.iconLigue)
  self.nav.Event(nil, "evt_tab4")
  self:RefreshLabels()
end

function Male:OnTabBundesligaClicked()
  self.activeTab = "BUNDESLIGA"
  self.im.Publish("bnd_true_epl_on", "")
  self.im.Publish("bnd_true_laliga_on", "")
  self.im.Publish("bnd_true_seriea_on", "")
  self.im.Publish("bnd_true_ligue_on", "")
  self.im.Publish("bnd_active_epl_on", "")  
  self.im.Publish("bnd_active_laliga_on", "")  
  self.im.Publish("bnd_active_seriea_on", "")
  self.im.Publish("bnd_active_ligue_on", "")  
  self.im.Publish("bnd_icon_epl_off", self.iconEpl)
  self.im.Publish("bnd_icon_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_icon_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_icon_ligue_off", self.iconLigue)
  self.im.Publish("bnd_false_epl_off", self.iconEpl)
  self.im.Publish("bnd_false_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_false_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_false_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_false_ligue_off", self.iconLigue)
  self.nav.Event(nil, "evt_tab5")
  self:RefreshLabels()
end

function Male:OnTabLigueClicked()
  self.activeTab = "LIGUE"
  self.im.Publish("bnd_true_epl_on", "")
  self.im.Publish("bnd_true_laliga_on", "")
  self.im.Publish("bnd_true_seriea_on", "")
  self.im.Publish("bnd_true_bundesliga_on", "")
  self.im.Publish("bnd_active_epl_on", "")  
  self.im.Publish("bnd_active_laliga_on", "") 
  self.im.Publish("bnd_active_seriea_on", "")  
  self.im.Publish("bnd_active_bundesliga_on", "")
  self.im.Publish("bnd_icon_epl_off", self.iconEpl)
  self.im.Publish("bnd_icon_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_icon_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_icon_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_false_epl_off", self.iconEpl)
  self.im.Publish("bnd_false_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_false_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_false_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_false_ligue_off", self.iconLigue)
  self.nav.Event(nil, "evt_tab6")
  self:RefreshLabels()
end

function Male:RefreshLabels()
  self.im.Publish("bnd_label_epl_off", self.labelEPLOff)
  self.im.Publish("bnd_label_epl_on", "")
  self.im.Publish("bnd_logo_epl_off", self.leagueEpl)
  self.im.Publish("bnd_logo_epl_on", "")
  self.im.Publish("bnd_flag_epl_off", self.flagEpl)
  self.im.Publish("bnd_flag_epl_on", "")
  self.im.Publish("bnd_icon_epl_off", self.iconEpl)
  self.im.Publish("bnd_icon_epl_on", "")
  self.im.Publish("bnd_label_laliga_off", self.labelLaligaOff)
  self.im.Publish("bnd_label_laliga_on", "")
  self.im.Publish("bnd_logo_laliga_off", self.leagueLaliga)
  self.im.Publish("bnd_logo_laliga_on", "")
  self.im.Publish("bnd_flag_laliga_off", self.flagLaliga)
  self.im.Publish("bnd_flag_laliga_on", "")
  self.im.Publish("bnd_icon_laliga_off", self.iconLaliga)
  self.im.Publish("bnd_icon_laliga_on", "")
  self.im.Publish("bnd_label_seriea_off", self.labelSerieAOff)
  self.im.Publish("bnd_label_seriea_on", "")
  self.im.Publish("bnd_logo_seriea_off", self.leagueSerieA)
  self.im.Publish("bnd_logo_seriea_on", "")
  self.im.Publish("bnd_flag_seriea_off", self.flagSerieA)
  self.im.Publish("bnd_flag_seriea_on", "")
  self.im.Publish("bnd_icon_seriea_off", self.iconSerieA)
  self.im.Publish("bnd_icon_seriea_on", "")
  self.im.Publish("bnd_label_bundesliga_off", self.labelBundesligaOff)
  self.im.Publish("bnd_label_bundesliga_on", "")
  self.im.Publish("bnd_logo_bundesliga_off", self.leagueBundesliga)
  self.im.Publish("bnd_logo_bundesliga_on", "")
  self.im.Publish("bnd_flag_bundesliga_off", self.flagBundesliga)
  self.im.Publish("bnd_flag_bundesliga_on", "")
  self.im.Publish("bnd_icon_bundesliga_off", self.iconBundesliga)
  self.im.Publish("bnd_icon_bundesliga_on", "")
  self.im.Publish("bnd_label_ligue_off", self.labelLigueOff)
  self.im.Publish("bnd_label_ligue_on", "")
  self.im.Publish("bnd_logo_ligue_off", self.leagueLigue)
  self.im.Publish("bnd_logo_ligue_on", "")
  self.im.Publish("bnd_flag_ligue_off", self.flagLigue)
  self.im.Publish("bnd_flag_ligue_on", "")
  self.im.Publish("bnd_icon_ligue_off", self.iconLigue)
  self.im.Publish("bnd_icon_ligue_on", "")
  if self.activeTab == "EPL" then
    self.im.Publish("bnd_label_epl_off", "")
    self.im.Publish("bnd_label_epl_on", self.labelEPLOn)
    self.im.Publish("bnd_logo_epl_off", "")
    self.im.Publish("bnd_logo_epl_on", self.leagueEpl)    
    self.im.Publish("bnd_flag_epl_off", "")
    self.im.Publish("bnd_flag_epl_on", self.flagEpl)
    self.im.Publish("bnd_icon_epl_off", "")
    self.im.Publish("bnd_icon_epl_on", self.iconsEpl)
  elseif self.activeTab == "LALIGA" then
    self.im.Publish("bnd_label_laliga_off", "")
    self.im.Publish("bnd_label_laliga_on", self.labelLaligaOn)
    self.im.Publish("bnd_logo_laliga_off", "")
    self.im.Publish("bnd_logo_laliga_on", self.leagueLaliga)
    self.im.Publish("bnd_flag_laliga_off", "")
    self.im.Publish("bnd_flag_laliga_on", self.flagLaliga)
    self.im.Publish("bnd_icon_laliga_off", "")
    self.im.Publish("bnd_icon_laliga_on", self.iconsLaliga)
  elseif self.activeTab == "SERIEA" then
    self.im.Publish("bnd_label_seriea_off", "")
    self.im.Publish("bnd_label_seriea_on", self.labelSerieAOn)
    self.im.Publish("bnd_logo_seriea_off", "")
    self.im.Publish("bnd_logo_seriea_on", self.leagueSerieA)
    self.im.Publish("bnd_flag_seriea_off", "")
    self.im.Publish("bnd_flag_seriea_on", self.flagSerieA)
    self.im.Publish("bnd_icon_seriea_off", "")
    self.im.Publish("bnd_icon_seriea_on", self.iconsSerieA)
  elseif self.activeTab == "BUNDESLIGA" then
    self.im.Publish("bnd_label_bundesliga_off", "")
    self.im.Publish("bnd_label_bundesliga_on", self.labelBundesligaOn)
    self.im.Publish("bnd_logo_bundesliga_off", "")
    self.im.Publish("bnd_logo_bundesliga_on", self.leagueBundesliga)
    self.im.Publish("bnd_flag_bundesliga_off", "")
    self.im.Publish("bnd_flag_bundesliga_on", self.flagBundesliga)
    self.im.Publish("bnd_icon_bundesliga_off", "")
    self.im.Publish("bnd_icon_bundesliga_on", self.iconsBundesliga)
  elseif self.activeTab == "LIGUE" then
    self.im.Publish("bnd_label_ligue_off", "")
    self.im.Publish("bnd_label_ligue_on", self.labelLigueOn)
    self.im.Publish("bnd_logo_ligue_off", "")
    self.im.Publish("bnd_logo_ligue_on", self.leagueLigue)
    self.im.Publish("bnd_flag_ligue_off", "")
    self.im.Publish("bnd_flag_ligue_on", self.flagLigue)
    self.im.Publish("bnd_icon_ligue_off", "")
    self.im.Publish("bnd_icon_ligue_on", self.iconsLigue)
  end
end

function Male:OnConfirmEplClicked()
  if self.activeTab ~= "EPL" then
    return
  end
  self.im.Publish("bnd_true_epl_on", self.leaguesEpl)
  self.im.Publish("bnd_active_epl_on", self.iconActive)
  self.im.Publish("bnd_icon_epl_off", "")
  self.im.Publish("bnd_icon_epl_on", "")
  self.im.Publish("bnd_false_epl_off", "")
  self.im.Publish("bnd_false_laliga_off", "")
  self.im.Publish("bnd_false_seriea_off", "")
  self.im.Publish("bnd_false_bundesliga_off", "")
  self.im.Publish("bnd_false_ligue_off", "")  
end

function Male:OnConfirmLaligaClicked()
  if self.activeTab ~= "LALIGA" then
    return
  end
  self.im.Publish("bnd_true_laliga_on", self.leaguesLaliga)
  self.im.Publish("bnd_active_laliga_on", self.iconActive)
  self.im.Publish("bnd_icon_laliga_off", "")
  self.im.Publish("bnd_icon_laliga_on", "")
  self.im.Publish("bnd_false_laliga_off", "")
  self.im.Publish("bnd_false_epl_off", "")
  self.im.Publish("bnd_false_seriea_off", "")
  self.im.Publish("bnd_false_bundesliga_off", "")
  self.im.Publish("bnd_false_ligue_off", "")  
end

function Male:OnConfirmSerieAClicked()
  if self.activeTab ~= "SERIEA" then
    return
  end
  self.im.Publish("bnd_true_seriea_on", self.leaguesSerieA)
  self.im.Publish("bnd_active_seriea_on", self.iconActive)
  self.im.Publish("bnd_icon_seriea_off", "")
  self.im.Publish("bnd_icon_seriea_on", "")
  self.im.Publish("bnd_false_seriea_off", "")
  self.im.Publish("bnd_false_laliga_off", "")
  self.im.Publish("bnd_false_epl_off", "")
  self.im.Publish("bnd_false_bundesliga_off", "")
  self.im.Publish("bnd_false_ligue_off", "")  
end

function Male:OnConfirmBundesligaClicked()
  if self.activeTab ~= "BUNDESLIGA" then
    return
  end
  self.im.Publish("bnd_true_bundesliga_on", self.leaguesBundesliga)
  self.im.Publish("bnd_active_bundesliga_on", self.iconActive)
  self.im.Publish("bnd_icon_bundesliga_off", "")
  self.im.Publish("bnd_icon_bundesliga_on", "")
  self.im.Publish("bnd_false_bundesliga_off", "")
  self.im.Publish("bnd_false_epl_off", "")
  self.im.Publish("bnd_false_laliga_off", "")
  self.im.Publish("bnd_false_seriea_off", "")
  self.im.Publish("bnd_false_ligue_off", "")  
end

function Male:OnConfirmLigueClicked()
  if self.activeTab ~= "LIGUE" then
    return
  end
  self.im.Publish("bnd_true_ligue_on", self.leaguesLigue)
  self.im.Publish("bnd_active_ligue_on", self.iconActive)
  self.im.Publish("bnd_icon_ligue_off", "")
  self.im.Publish("bnd_icon_ligue_on", "")
  self.im.Publish("bnd_false_ligue_off", "")
  self.im.Publish("bnd_false_epl_off", "")
  self.im.Publish("bnd_false_laliga_off", "")
  self.im.Publish("bnd_false_seriea_off", "")
  self.im.Publish("bnd_false_bundesliga_off", "")  
end

function Male:NextUpdate()
  local buttonNo = {
    icon = "$FooterIconNo",
    label = "Cancel",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local buttonYes = {
    icon = "$FooterIconYes",
    label = "Close",
    clickEvents = {
      "evt_hide_popup"
    }
  }
  local popupData = {
    title = "INFO",
    message = "For now the menu is not available, please wait for the next update.",
    buttons = {buttonYes}
  }
  self.nav.Event(nil, "evt_show_popup", popupData)
end

function Male:finalize()
  self.im.Unsubscribe("bnd_player_bg")  
end

return Male