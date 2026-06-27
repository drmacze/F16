
local OverlaysIdContainer, OverlayParam, eventmanager = ...
local OVERLAY_TYPES = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local DistanceToGoal = {}

function DistanceToGoal:new(init)
  print("[DistanceToGoal]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    eventManService = o.api("EventManagerService")
  }
  o.handlerId = o.services.eventManService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  o.nationalization = 2
  o.isActive = false
  o.distanceInfo = nil
  
  o.im.Subscribe("bnd_nationalization", function()
  end)
  o.im.Subscribe("bnd_visible", function()
    o:_publishActivity()
  end)
  
  o.im.Subscribe("bnd_distance_info", function()
    o:_publishDistanceInfo()
  end)
  o.im.Subscribe("bnd_distance_info_num", function()
    o:_publishBndDistanceInfoNum()
  end)
  o.im.Subscribe("bnd_distance_info_sys", function()
    o:_publishBndDistanceInfoSys()
  end)
  o.im.Subscribe("bnd_xg_info_num", function()
    o:_publishBndXGInfoNum()
  end)
  return o
end


function DistanceToGoal:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeDistanceToGoal then
    self:updateDistance(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end


function DistanceToGoal:updateDistance(subtype, hideshow, subtypestr, msg)
  print("[DistanceToGoal]: updateDistanceToGoal(subtype = " .. tostring(subtype) .. ", hideshow = " .. tostring(hideshow) .. ", subtypestr = " .. tostring(subtypestr) .. ", msg = " .. tostring(msg) .. ")")
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      self.im.Publish("bnd_nationalization", self.nationalization)
      
      self.distanceInfo = {
        DistanceNumber = params[1],
        DistanceSystem = " "
      }
      self.isActive = true
      
      math.randomseed(os.clock() * 1000 + os.time())
      DNprecision = (math.random(-2, 2)* 0.1)
      
      DistanceNum = (params[1] - 0.5 )+ DNprecision
      DistanceSys = params[2] 
      
      Dnum = DistanceNum
       if Dnum >= 1 and Dnum <= 10 then XGNum = 70
       elseif Dnum >= 10 and Dnum <= 15 then XGNum = 50
       elseif Dnum >= 15 and Dnum <= 16 then XGNum = 45
       elseif Dnum >= 16.1 and Dnum <= 16.3 then XGNum = 41
       elseif Dnum >= 16.4 and Dnum <= 16.6 then XGNum = 40
       elseif Dnum >= 16.7 and Dnum <= 16.9 then XGNum = 32
       elseif Dnum >= 17 and Dnum <= 17.3 then XGNum = 37
       elseif Dnum >= 17.4 and Dnum <= 17.6 then XGNum = 35
       elseif Dnum >= 17.7 and Dnum <= 18 then XGNum = 33
       elseif Dnum >= 18.1 and Dnum <= 18.3 then XGNum = 31
       elseif Dnum >= 18.4 and Dnum <= 18.6 then XGNum = 30
       elseif Dnum >= 18.7 and Dnum <= 18.9 then XGNum = 29
       elseif Dnum >= 19 and Dnum <= 19.3 then XGNum = 27
       elseif Dnum >= 19.4 and Dnum <= 19.6 then XGNum = 24
       elseif Dnum >= 19.7 and Dnum <= 19.9 then XGNum = 22
       
       elseif Dnum >= 20 and Dnum <= 21 then XGNum = 20
       elseif Dnum >= 21.1 and Dnum <= 22 then XGNum = 19
       elseif Dnum >= 22.1 and Dnum <= 23 then XGNum = 18
       elseif Dnum >= 23.1 and Dnum <= 24 then XGNum = 17
       elseif Dnum >= 24.1 and Dnum <= 25 then XGNum = 16
       elseif Dnum >= 25.1 and Dnum <= 26 then XGNum = 15
       elseif Dnum >= 26.1 and Dnum <= 27 then XGNum = 14
       elseif Dnum >= 27.1 and Dnum <= 28 then XGNum = 13
       elseif Dnum >= 28.1 and Dnum <= 29 then XGNum = 12
       elseif Dnum >= 29.1 and Dnum <= 30 then XGNum = 9
       
       elseif Dnum >= 30.1 and Dnum <= 32 then XGNum = 11
       elseif Dnum >= 32.1 and Dnum <= 34 then XGNum = 10
       elseif Dnum >= 34.1 and Dnum <= 36 then XGNum = 9
       elseif Dnum >= 36.1 and Dnum <= 38 then XGNum = 8
       elseif Dnum >= 38.1 and Dnum <= 40 then XGNum = 7
       elseif Dnum >= 40.1 and Dnum <= 42 then XGNum = 6
       elseif Dnum >= 42.1 and Dnum <= 45 then XGNum = 5
       elseif Dnum >= 45.1 and Dnum <= 48 then XGNum = 4
       elseif Dnum >= 48.1 and Dnum <= 99 then XGNum = 1
       
       else XGNum = 10
       end
      
      self.DN = DistanceNum
      self.DNtransp= " "
      self.DS = DistanceSys
      self.XG = XGNum * 0.01
    end
  else
    self.isActive = false
  end
  self:_publishDistanceInfo()
  self:_publishActivity()
  self:_publishBndDistanceInfoNum()
  self:_publishBndDistanceInfoSys()
  self:_publishBndXGInfoNum()
end


function DistanceToGoal:_publishActivity()
  self.im.Publish("bnd_visible", self.isActive)
end

function DistanceToGoal:_publishBndDistanceInfoNum()
  self.im.Publish("bnd_distance_info_num", self.DN)
end
function DistanceToGoal:_publishBndDistanceInfoSys()
  self.im.Publish("bnd_distance_info_sys", self.DS)
end
function DistanceToGoal:_publishBndXGInfoNum()
  self.im.Publish("bnd_xg_info_num", self.XG)
end

function DistanceToGoal:_publishDistanceInfo()
  if self.distanceInfo == nil then
    return
  end
  self.im.Publish("bnd_distance_info", self.DNtransp)
end


function DistanceToGoal:finalize()
  print("[DistanceToGoal]: finalize()")
  self.im.Unsubscribe("bnd_nationalization")
  self.im.Unsubscribe("bnd_distance_info")
  self.im.Unsubscribe("bnd_visible")
  self.im.Unsubscribe("bnd_distance_info_num")
  self.im.Unsubscribe("bnd_distance_info_sys")
  self.im.Unsubscribe("bnd_xg_info_num")
  self.services.eventManService.UnregisterHandler(self.handlerId)
end
return DistanceToGoal
