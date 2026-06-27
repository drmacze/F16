-------------------------------------------
-- MOD Created By Ma'ruf ID --
-------------------------------------------

local MatchInfoNPC = {}

local OverlaysIdContainer, OverlayParam, eventmanager = ...
local OVERLAY_TYPES = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

function MatchInfoNPC:new(init)
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
  
  o.npcInfo = nil

  o.visibleKomentator = false
  o.visibleWasit = false

  o.im.Subscribe("bnd_visible_komentator", function()
    o:_publishVisibleKomentator()
  end)
  o.im.Subscribe("bnd_visible_wasit", function()
    o:_publishVisibleWasit()
  end)

  o.im.Subscribe("bnd_nationalization", function()
  end)
  
  o.im.Subscribe("bnd_npc_info", function()
    o:_publishNPCInfo()
  end)
  
  return o
end

function MatchInfoNPC:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeCommentators then
    self:updateMatchInfoCommentators(data.subtype, data.hideshow, data.subtypestr, data.msg)
  elseif eventType == EventTypes.OverlayTypeIntroSequenceReferee then
    self:updateMatchInfoReferees(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

-- Bagian Info Komentator --
function MatchInfoNPC:updateMatchInfoCommentators(subtype, hideshow, subtypestr, msg)
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      self.im.Publish("bnd_nationalization", self.nationalization)
      local mainCommentator = params[3]
      local colorCommentator = params[4]
      self.npcInfo = {
        overlayTitle = "MATCH COMMENTARY",
        topText = "",
        middleText = mainCommentator,
        bottomText = colorCommentator
      }
      self.visibleKomentator = true
    end
  else
    self.visibleKomentator = false
  end
  self:_publishNPCInfo()
  self:_publishVisibleKomentator()
end

-- Bagian Info Wasit --
function MatchInfoNPC:updateMatchInfoReferees(subtype, hideshow, subtypestr, msg)
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      self.im.Publish("bnd_nationalization", self.nationalization)
      local refereeName = params[3]
      local refereesCountry = params[4]
      self.npcInfo = {
        overlayTitle = "MATCH REFEREE",
        topText = "",
        middleText = refereeName,
        bottomText = refereesCountry
      }
      self.visibleWasit = true
    end
  else
    self.visibleWasit = false
  end
  self:_publishNPCInfo()
  self:_publishVisibleWasit()
end

function MatchInfoNPC:_publishVisibleKomentator()
  self.im.Publish("bnd_visible_komentator", self.visibleKomentator)
end
function MatchInfoNPC:_publishVisibleWasit()
  self.im.Publish("bnd_visible_wasit", self.visibleWasit)
end

function MatchInfoNPC:_publishNPCInfo()
  if self.npcInfo == nil then
    return
  end
  self.im.Publish("bnd_npc_info", self.npcInfo)
end

function MatchInfoNPC:finalize()

  self.im.Unsubscribe("bnd_nationalization")
  
  self.im.Unsubscribe("bnd_npc_info")
  
  self.im.Unsubscribe("bnd_visible_komentator")
  self.im.Unsubscribe("bnd_visible_wasit")
  
  self.services.eventManService.UnregisterHandler(self.handlerId)
  
end

return MatchInfoNPC