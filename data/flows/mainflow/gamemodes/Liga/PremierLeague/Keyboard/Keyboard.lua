-- Mod By MVN PROD --
-- League Mode Division --

local Keyboard = {}
local bndMatchList = "bnd_match_list"
local ACT_ADVANCE = "act_advance"
local ACT_Q = "act_q"
local ACT_W = "act_w"
local ACT_E = "act_e"
local ACT_R = "act_r"
local ACT_T = "act_t"
local ACT_Y = "act_y"
local ACT_U = "act_u"
local ACT_I = "act_i"
local ACT_O = "act_o"
local ACT_P = "act_p"
local ACT_A = "act_a"
local ACT_S = "act_s"
local ACT_D = "act_d"
local ACT_F = "act_f"
local ACT_G = "act_g"
local ACT_H = "act_h"
local ACT_J = "act_j"
local ACT_K = "act_k"
local ACT_L = "act_l"
local ACT_Z = "act_z"
local ACT_X = "act_x"
local ACT_C = "act_c"
local ACT_V = "act_v"
local ACT_B = "act_b"
local ACT_N = "act_n"
local ACT_M = "act_m"
local ACT_DOT = "act_dot"
local ACT_BACKSPACE = "act_backspace"
local ACT_SUBMIT = "act_submit"

KeyboardId = 1
if not round then
  round = 1
else 
  round = round
end

if not selectedteam then
  selectedteam = 1
else 
  selectedteam = selectedteam
end

if not text then
  text = ""
end

currentMatch = {
  HomeTeamID = 0,
  AwayTeamID = 0,
  HomeKitIndex = 0,
  AwayKitIndex = 1
}

-- Dev2
local rivalListData = {}
local matchesPlayed = 0  -- Counter to track the number of matches played

function Keyboard:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    settingsService = o.api("SettingsService"),
    SquadManagementService = o.api("SquadMgtService")
  }
  
  o.im.Subscribe("bnd_match_label", function()
    o:publishMatchLabel()
  end)
  
  o.im.Subscribe("bnd_point_label", function()

    o:publishMatchLabel()

  end)
  
  o.im.Subscribe("bnd_finish_label", function()
    o:publishFinishLabel()
  end)
  
  o.im.Subscribe("bnd_team_label", function()
    o:publishLabel()
  end)
  
  o.im.Subscribe("bnd_matchup_label", function()

    o:publishFinishLabel()

  end)
  
  o.im.Subscribe("bnd_matchday_label", function()

    o:publishLabel()

  end)
  
  o.im.Subscribe("bnd_league_label", function()

    o:publishFinishLabel()

  end)
  
  o.im.Subscribe("bnd_advance_label", function()

    o:publishFinishLabel()

  end)
  
  o.im.Subscribe("bnd_month_label", function()

    o:publishFinishLabel()

  end)
  
  o.im.RegisterAction(ACT_ADVANCE, function(actionName, data)
    o:nextt()
  end)
  o.im.RegisterAction(ACT_Q, function(actionName, data)
    o:q()
  end)
  o.im.RegisterAction(ACT_W, function(actionName, data)
    o:w()
  end)
  o.im.RegisterAction(ACT_E, function(actionName, data)
    o:e()
  end)
  o.im.RegisterAction(ACT_R, function(actionName, data)
    o:r()
  end)
  o.im.RegisterAction(ACT_T, function(actionName, data)
    o:t()
  end)
  o.im.RegisterAction(ACT_Y, function(actionName, data)
    o:y()
  end)
  o.im.RegisterAction(ACT_U, function(actionName, data)
    o:u()
  end)
  o.im.RegisterAction(ACT_I, function(actionName, data)
    o:i()
  end)
  o.im.RegisterAction(ACT_O, function(actionName, data)
    o:o()
  end)
  o.im.RegisterAction(ACT_P, function(actionName, data)
    o:p()
  end)
  o.im.RegisterAction(ACT_A, function(actionName, data)
    o:a()
  end)
  o.im.RegisterAction(ACT_S, function(actionName, data)
    o:s()
  end)
  o.im.RegisterAction(ACT_D, function(actionName, data)
    o:d()
  end)
  o.im.RegisterAction(ACT_F, function(actionName, data)
    o:f()
  end)
  o.im.RegisterAction(ACT_G, function(actionName, data)
    o:g()
  end)
  o.im.RegisterAction(ACT_H, function(actionName, data)
    o:h()
  end)
  o.im.RegisterAction(ACT_J, function(actionName, data)
    o:j()
  end)
  o.im.RegisterAction(ACT_K, function(actionName, data)
    o:k()
  end)
  o.im.RegisterAction(ACT_L, function(actionName, data)
    o:l()
  end)
  o.im.RegisterAction(ACT_Z, function(actionName, data)
    o:z()
  end)
  o.im.RegisterAction(ACT_X, function(actionName, data)
    o:x()
  end)
  o.im.RegisterAction(ACT_C, function(actionName, data)
    o:c()
  end)
  o.im.RegisterAction(ACT_V, function(actionName, data)
    o:v()
  end)
  o.im.RegisterAction(ACT_B, function(actionName, data)
    o:b()
  end)
  o.im.RegisterAction(ACT_N, function(actionName, data)
    o:n()
  end)
  o.im.RegisterAction(ACT_M, function(actionName, data)
    o:m()
  end)
  o.im.RegisterAction(ACT_DOT, function(actionName, data)
    o:dot()
  end)
  o.im.RegisterAction(ACT_BACKSPACE, function(actionName, data)
    o:backspace()
  end)
  o.im.RegisterAction(ACT_SUBMIT, function(actionName, data)
    o:submit()
  end)

  return o
end

-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
function Keyboard:publishLabel()
  self.im.Publish("bnd_matchday_label", text)
end

function Keyboard:q()
  text = text .. "q"
  self:publishLabel()
end
function Keyboard:w()
  text = text .. "w"
  self:publishLabel()
end
function Keyboard:e()
  text = text .. "e"
  self:publishLabel()
end
function Keyboard:r()
  text = text .. "r"
  self:publishLabel()
end
function Keyboard:t()
  text = text .. "t"
  self:publishLabel()
end
function Keyboard:y()
  text = text .. "y"
  self:publishLabel()
end
function Keyboard:u()
  text = text .. "u"
  self:publishLabel()
end
function Keyboard:i()
  text = text .. "i"
  self:publishLabel()
end
function Keyboard:o()
  text = text .. "o"
  self:publishLabel()
end
function Keyboard:p()
  text = text .. "p"
  self:publishLabel()
end
function Keyboard:a()
  text = text .. "a"
  self:publishLabel()
end
function Keyboard:s()
  text = text .. "s"
  self:publishLabel()
end
function Keyboard:d()
  text = text .. "d"
  self:publishLabel()
end
function Keyboard:f()
  text = text .. "f"
  self:publishLabel()
end
function Keyboard:g()
  text = text .. "g"
  self:publishLabel()
end
function Keyboard:h()
  text = text .. "h"
  self:publishLabel()
end
function Keyboard:j()
  text = text .. "j"
  self:publishLabel()
end
function Keyboard:k()
  text = text .. "k"
  self:publishLabel()
end
function Keyboard:l()
  text = text .. "l"
  self:publishLabel()
end
function Keyboard:z()
  text = text .. "z"
  self:publishLabel()
end
function Keyboard:x()
  text = text .. "x"
  self:publishLabel()
end
function Keyboard:c()
  text = text .. "c"
  self:publishLabel()
end
function Keyboard:v()
  text = text .. "v"
  self:publishLabel()
end
function Keyboard:b()
  text = text .. "b"
  self:publishLabel()
end
function Keyboard:n()
  text = text .. "n"
  self:publishLabel()
end
function Keyboard:m()
  text = text .. "m"
  self:publishLabel()
end
function Keyboard:dot()
  text = text .. "."
  self:publishLabel()
end
function Keyboard:backspace()
    if #text > 0 then
        text = text:sub(1, 0)  -- Removes the last character
    end
    self:publishLabel()
end
function Keyboard:submit()
  setPlayerFilter()
  self:publishLabel()
  self.nav.Event(nil, "evt_back")
end


function Keyboard:finalize()
  self.im.UnregisterAction(ACT_ADVANCE)
  self.im.Unsubscribe("bnd_match_list")
  self.im.Unsubscribe("bnd_matchday_label")
  self.im.Unsubscribe("bnd_point_label")
  self.im.Unsubscribe("bnd_team_label")
  self.im.Unsubscribe("bnd_matchup_label")
  self.im.Unsubscribe("bnd_matchdate_label")
  self.im.Unsubscribe("bnd_league_label")
  self.im.Unsubscribe("bnd_advance_label")
  self.im.Unsubscribe("bnd_month_label")
  self.im.Unsubscribe("bnd_finish_label")
  rivalListData = {}
end

return Keyboard

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --