local Substitution = {}
local OverlaysIdContainer, OverlayParam, eventmanager = ...
local Overlays = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local bndNationalization = "bnd_nationalization"
local bndSubstitutionList = "bnd_subs_info"
local bndVisible = "bnd_visible"


EAFCInfo = {
  bnd_bg_crest_color = "0x00D9D1",
  --
  bnd_bg_textsub_color = "0x00D9D1",
  bnd_textsub_fontColor = "0x000000",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x000000",
  bnd_sub_text_fontColor = "0x000000"
}

DFLInfo = {
  bnd_bg_crest_color = "0x2E2E2E",
  --
  bnd_bg_textsub_color = "0xFFFFFF",
  bnd_textsub_fontColor = "0x2E2E2E",
  --
  bnd_bg_playersub_color = "0x2E2E2E",
  bnd_sub_num_fontColor = "0xffffff",
  bnd_sub_text_fontColor = "0xffffff"
}

EnglandInfo = {
  bnd_bg_crest_color = "0xF5F5F5",
  --
  bnd_bg_textsub_color = "0xF5F5F5",
  bnd_textsub_fontColor = "0x39003E",
  --
  bnd_bg_playersub_color = "0x39003E",
  bnd_sub_num_fontColor = "0xF5F5F5",
  bnd_sub_text_fontColor = "0xF5F5F5"
}

SpainInfo = {
  bnd_bg_crest_color = "0x151515",
  --
  bnd_bg_textsub_color = "0xFF5C41",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x151515",
  bnd_sub_text_fontColor = "0x151515"
}

SpainBInfo = {
  bnd_bg_crest_color = "0x151515",
  --
  bnd_bg_textsub_color = "0x00F0FF",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x151515",
  bnd_sub_text_fontColor = "0x151515"
}

GermanyInfo = {
  bnd_bg_crest_color = "0x333333",
  --
  bnd_bg_textsub_color = "0xD10214",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x151515",
  bnd_sub_text_fontColor = "0x151515"
}

franceInfo = {
  bnd_bg_crest_color = "0x0040FF",
  --
  bnd_bg_textsub_color = "0xffffff",
  bnd_textsub_fontColor = "0x000000",
  --
  bnd_bg_playersub_color = "0xffffff",
  bnd_sub_num_fontColor = "0x000000",
  bnd_sub_text_fontColor = "0x000000"
}

ItalyInfo = {
  bnd_bg_crest_color = "0x14306F",
  --
  bnd_bg_textsub_color = "0x14306F",
  bnd_textsub_fontColor = "0xffffff",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x000000",
  bnd_sub_text_fontColor = "0x000000"
}

BrazilInfo = {
  bnd_bg_crest_color = "0x0B173B",
  --
  bnd_bg_textsub_color = "0x0B173B",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0x0B173B",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

BrazilGloboInfo = {
  bnd_bg_crest_color = "0x000000",
  --
  bnd_bg_textsub_color = "0x000000",
  bnd_textsub_fontColor = "0xBCFF79",
  --
  bnd_bg_playersub_color = "0x1C1C1C",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

BrazilAmazonInfo = {
  bnd_bg_crest_color = "0x00A7FF",
  --
  bnd_bg_textsub_color = "0x00A7FF",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0x000000",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

MexicoInfo = {
  bnd_bg_crest_color = "0x1D3D66",
  --
  bnd_bg_textsub_color = "0xffffff",
  bnd_textsub_fontColor = "0x1D3D66",
  --
  bnd_bg_playersub_color = "0x1D3D66",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

ArgentinaInfo = {
  bnd_bg_crest_color = "0x1F3139",
  --
  bnd_bg_textsub_color = "0x1F3139",
  bnd_textsub_fontColor = "0x39DFE3",
  --
  bnd_bg_playersub_color = "0x1F3139",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

IndonesiaInfo = {
  bnd_bg_crest_color = "0x001E6C",
  --
  bnd_bg_textsub_color = "0x001E6C",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x000000",
  bnd_sub_text_fontColor = "0x000000"
}

SaudiArabiaInfo = {
  bnd_bg_crest_color = "0xFFFFFF",
  --
  bnd_bg_textsub_color = "0x0B3861",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x151515",
  bnd_sub_text_fontColor = "0x151515"
}

RussiaInfo = {
  bnd_bg_crest_color = "0x000C50",
  --
  bnd_bg_textsub_color = "0x000C50",
  bnd_textsub_fontColor = "0xffffff",
  --
  bnd_bg_playersub_color = "0xC4C8CC",
  bnd_sub_num_fontColor = "0x1E1E1E",
  bnd_sub_text_fontColor = "0x1E1E1E"
}

LeaguePariInfo = {
  bnd_bg_crest_color = "0x00D2BC",
  --
  bnd_bg_textsub_color = "0x000E08",
  bnd_textsub_fontColor = "0x00D2BC",
  --
  bnd_bg_playersub_color = "0x000E08",
  bnd_sub_num_fontColor = "0x00D2BC",
  bnd_sub_text_fontColor = "0x00D2BC"
}

UkraineInfo = {
  bnd_bg_crest_color = "0x0039AB",
  --
  bnd_bg_textsub_color = "0x0039AB",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x000000",
  bnd_sub_text_fontColor = "0x000000"
}

InternationalInfo = {
  bnd_bg_crest_color = "0xD3AA32",
  --
  bnd_bg_textsub_color = "0xD3AA32",
  bnd_textsub_fontColor = "0xffffff",
  --
  bnd_bg_playersub_color = "0xffffff",
  bnd_sub_num_fontColor = "0xD3AA32",
  bnd_sub_text_fontColor = "0xD3AA32"
}

--------- Tournaments ---------

UCLInfo = {
  bnd_bg_crest_color = "0xFFFFFF",
  --
  bnd_bg_textsub_color = "0x041750",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0x08187D",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

UELInfo = {
  bnd_bg_crest_color = "0x000000",
  --
  bnd_bg_textsub_color = "0xE14711",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0x000000",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

EuroCopaInfo = {
  bnd_bg_crest_color = "0x001852",
  --
  bnd_bg_textsub_color = "0xF5F5F5",
  bnd_textsub_fontColor = "0x000000",
  --
  bnd_bg_playersub_color = "0x1544F6",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

NationsLeagueInfo = {
  bnd_bg_crest_color = "0x4F6B7F",
  --
  bnd_bg_textsub_color = "0x4F6B7F",
  bnd_textsub_fontColor = "0xDBE2E3",
  --
  bnd_bg_playersub_color = "0xDBE2E3",
  bnd_sub_num_fontColor = "0x4F6B7F",
  bnd_sub_text_fontColor = "0x4F6B7F"
}

UefaWomensInfo = {
  bnd_bg_crest_color = "0xFFFFFF",
  --
  bnd_bg_textsub_color = "0x012652",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0x0657A0",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

UCLClassicInfo = {
  bnd_bg_crest_color = "0x0B3861",
  --
  bnd_bg_textsub_color = "0x0B3861",
  bnd_textsub_fontColor = "0xE5E5E5",
  --
  bnd_bg_playersub_color = "0xE5E5E5",
  bnd_sub_num_fontColor = "0x0B3861",
  bnd_sub_text_fontColor = "0x0B3861"
}

LibertadoresInfo = {
  bnd_bg_crest_color = "0xBC9751",
  --
  bnd_bg_textsub_color = "0xBC9751",
  bnd_textsub_fontColor = "0xffffff",
  --
  bnd_bg_playersub_color = "0x000000",
  bnd_sub_num_fontColor = "0xffffff",
  bnd_sub_text_fontColor = "0xffffff"
}

SudamericanaInfo = {
  bnd_bg_crest_color = "0xB3B3B3",
  --
  bnd_bg_textsub_color = "0xB3B3B3",
  bnd_textsub_fontColor = "0x001650",
  --
  bnd_bg_playersub_color = "0x001650",
  bnd_sub_num_fontColor = "0xffffff",
  bnd_sub_text_fontColor = "0xffffff"
}

CopaAmericaInfo = {
  bnd_bg_crest_color = "0xB40309",
  --
  bnd_bg_textsub_color = "0x1B1365",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0x000000",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

WorldCupInfo = {
  bnd_bg_crest_color = "0x146945",
  --
  bnd_bg_textsub_color = "0x146945",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0x281B63",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

WomensWorldCupInfo = {
  bnd_bg_crest_color = "0x1E1E1E",
  --
  bnd_bg_textsub_color = "0x275759",
  bnd_textsub_fontColor = "0xF7F9E1",
  --
  bnd_bg_playersub_color = "0xF7F9E1",
  bnd_sub_num_fontColor = "0x1E1E1E",
  bnd_sub_text_fontColor = "0x1E1E1E"
}

ClubWorldCupInfo = {
  bnd_bg_crest_color = "0x000000",
  --
  bnd_bg_textsub_color = "0xCDA31F",
  bnd_textsub_fontColor = "0x000000",
  --
  bnd_bg_playersub_color = "0x000000",
  bnd_sub_num_fontColor = "0xFFFFFF",
  bnd_sub_text_fontColor = "0xFFFFFF"
}

FacupInfo = {
  bnd_bg_crest_color = "0xA8222A",
  --
  bnd_bg_textsub_color = "0xA8222A",
  bnd_textsub_fontColor = "0xFFFFFF",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x151515",
  bnd_sub_text_fontColor = "0x151515"
}

CoppaItaliaInfo = {
  bnd_bg_crest_color = "0xBE0003",
  --
  bnd_bg_textsub_color = "0xBE0003",
  bnd_textsub_fontColor = "0x000000",
  --
  bnd_bg_playersub_color = "0xFFFFFF",
  bnd_sub_num_fontColor = "0x000000",
  bnd_sub_text_fontColor = "0xBE0003"
}

SaudiSuperCupInfo = {
  bnd_bg_crest_color = "0x2F0B3A",
  --
  bnd_bg_textsub_color = "0x2F0B3A",
  bnd_textsub_fontColor = "0xffffff",
  --
  bnd_bg_playersub_color = "0xffffff",
  bnd_sub_num_fontColor = "0x2F0B3A",
  bnd_sub_text_fontColor = "0x2F0B3A"
}

KingCupInfo = {
  bnd_bg_crest_color = "0x1E692D",
  --
  bnd_bg_textsub_color = "0x1E692D",
  bnd_textsub_fontColor = "0xffffff",
  --
  bnd_bg_playersub_color = "0xffffff",
  bnd_sub_num_fontColor = "0x1E692D",
  bnd_sub_text_fontColor = "0x1E692D"
}

PaulistaoInfo = {
  bnd_bg_crest_color = "0x00019D",
  --
  bnd_bg_textsub_color = "0x00019D",
  bnd_textsub_fontColor = "0xffffff",
  --
  bnd_bg_playersub_color = "0xffffff",
  bnd_sub_num_fontColor = "0x000000",
  bnd_sub_text_fontColor = "0x000000"
}

CariocaInfo = {
  bnd_bg_crest_color = "0x142a37",
  --
  bnd_bg_textsub_color = "0x142a37",
  bnd_textsub_fontColor = "0xffffff",
  --
  bnd_bg_playersub_color = "0xffffff",
  bnd_sub_num_fontColor = "0x000000",
  bnd_sub_text_fontColor = "0x000000"
}

function Substitution:new(init)
  print("[Substitution]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.nationalization = 2
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    MatchInfoService = o.api("MatchInfoService"),
    TeamService = o.api("TeamService")
  }
  
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  
  
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  
    o.currentEvent = nil
  
  if currentCupData.cupIndex > 0 then
    if currentCupData.cupIndex == 1 then
      o.currentEvent = UCLInfo
    elseif currentCupData.cupIndex == 2 then
      o.currentEvent = UELInfo
    elseif currentCupData.cupIndex == 3 then
      o.currentEvent = EuroCopaInfo
    elseif currentCupData.cupIndex == 4 then
      o.currentEvent = NationsLeagueInfo
    elseif currentCupData.cupIndex == 5 then
      o.currentEvent = UefaWomensInfo
    elseif currentCupData.cupIndex == 6 then
      o.currentEvent = LibertadoresInfo
    elseif currentCupData.cupIndex == 7 then
      o.currentEvent = SudamericanaInfo
    elseif currentCupData.cupIndex == 8 then
      o.currentEvent = CopaAmericaInfo
    elseif currentCupData.cupIndex == 9 then
      o.currentEvent = ClubWorldCupInfo
    elseif currentCupData.cupIndex == 10 then
      o.currentEvent = WorldCupInfo
    elseif currentCupData.cupIndex == 11 then
      o.currentEvent = FacupInfo
    elseif currentCupData.cupIndex == 12 then
      o.currentEvent = EAFCInfo
    elseif currentCupData.cupIndex == 13 then
      o.currentEvent = CoppaItaliaInfo
    elseif currentCupData.cupIndex == 14 then
      o.currentEvent = EAFCInfo
    elseif currentCupData.cupIndex == 15 then
      o.currentEvent = EAFCInfo
    elseif currentCupData.cupIndex == 16 then
      o.currentEvent = BrazilAmazonInfo
    elseif currentCupData.cupIndex == 17 then
      o.currentEvent = PaulistaoInfo
    else 
      o.currentEvent = EAFCInfo
  end
    
    elseif currentTourData and currentTourData.tourIndex and currentTourData.tourIndex > 0 then
    if currentTourData.tourIndex == 1 then
    o.currentEvent = UCLInfo
  elseif currentTourData.tourIndex == 2 then
    o.currentEvent = UELInfo
  elseif currentTourData.tourIndex == 3 then
    o.currentEvent = EuroCopaInfo
  elseif currentTourData.tourIndex == 4 then
    o.currentEvent = NationsLeagueInfo
  elseif currentTourData.tourIndex == 5 then
    o.currentEvent = UefaWomensInfo
  elseif currentTourData.tourIndex == 6 then
    o.currentEvent = LibertadoresInfo
  elseif currentTourData.tourIndex == 7 then
    o.currentEvent = SudamericanaInfo
  elseif currentTourData.tourIndex == 8 then
    o.currentEvent = CopaAmericaInfo
  elseif currentTourData.tourIndex == 9 then
    o.currentEvent = ClubWorldCupInfo
  elseif currentTourData.tourIndex == 10 then
    o.currentEvent = WorldCupInfo
  elseif currentTourData.tourIndex == 11 then
    o.currentEvent = FacupInfo
  elseif currentTourData.tourIndex == 12 then
    o.currentEvent = EAFCInfo
  elseif currentTourData.tourIndex == 13 then
    o.currentEvent = CoppaItaliaInfo
  elseif currentTourData.tourIndex == 14 then
    o.currentEvent = EAFCInfo
  elseif currentTourData.tourIndex == 15 then
    o.currentEvent = EAFCInfo
  elseif currentTourData.tourIndex == 16 then
    o.currentEvent = BrazilAmazonInfo
  else 
    o.currentEvent = EAFCInfo
  end
    
  else
  if o:isInTable(o.TeamsData[1], EnglandTeams) and o:isInTable(o.TeamsData[2], EnglandTeams) then
    o.currentEvent = EnglandInfo
  elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
    o.currentEvent = SpainInfo
  elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
    o.currentEvent = SpainBInfo
  elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
    o.currentEvent = GermanyInfo
  elseif o:isInTable(o.TeamsData[1], Germany2Teams) and o:isInTable(o.TeamsData[2], Germany2Teams) then
    o.currentEvent = GermanyInfo
  elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
    o.currentEvent = franceInfo
  elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
    o.currentEvent = ItalyInfo
  elseif o:isInTable(o.TeamsData[1], BrazilTeams) and o:isInTable(o.TeamsData[2], BrazilTeams) then
    o.currentEvent = BrazilGloboInfo
  elseif o:isInTable(o.TeamsData[1], BrazilBTeams) and o:isInTable(o.TeamsData[2], BrazilBTeams) then
    o.currentEvent = BrazilInfo
  elseif o:isInTable(o.TeamsData[1], MexicoTeams) and o:isInTable(o.TeamsData[2], MexicoTeams) then
    o.currentEvent = MexicoInfo
  elseif o:isInTable(o.TeamsData[1], ArgentinaTeams) and o:isInTable(o.TeamsData[2], ArgentinaTeams) then
    o.currentEvent = ArgentinaInfo
  elseif o:isInTable(o.TeamsData[1], IndonesiaTeams) and o:isInTable(o.TeamsData[2], IndonesiaTeams) then
    o.currentEvent = IndonesiaInfo
  elseif o:isInTable(o.TeamsData[1], SaudiArabiaTeams) and o:isInTable(o.TeamsData[2], SaudiArabiaTeams) then
    o.currentEvent = SaudiArabiaInfo
  elseif o:isInTable(o.TeamsData[1], WomensSuperLeagueTeams) and o:isInTable(o.TeamsData[2], WomensSuperLeagueTeams) then
    o.currentEvent = EAFCInfo
  elseif o:isInTable(o.TeamsData[1], UnitedStatesTeams) and o:isInTable(o.TeamsData[2], UnitedStatesTeams) then
    o.currentEvent = EAFCInfo
  elseif o:isInTable(o.TeamsData[1], RussiaTeams) and o:isInTable(o.TeamsData[2], RussiaTeams) then
    o.currentEvent = RussiaInfo
  elseif o:isInTable(o.TeamsData[1], LeaguePariTeams) and o:isInTable(o.TeamsData[2], LeaguePariTeams) then
    o.currentEvent = LeaguePariInfo
  elseif o:isInTable(o.TeamsData[1], UkraineTeams) and o:isInTable(o.TeamsData[2], UkraineTeams) then
    o.currentEvent = UkraineInfo
  elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
    o.currentEvent = InternationalInfo
  else  
    o.currentEvent = EAFCInfo
  end
  end
      
      
  o.bndList = {
  bnd_sub_crest = {
    name = "$Crest",
    id = 0
  },
  bnd_subin1_visible = false,
  bnd_subin2_visible = false,
  bnd_subin3_visible = false,
  bnd_subout1_visible = false,
  bnd_subout2_visible = false,
  bnd_subout3_visible = false,

  bnd_subin_num1 = "",
  bnd_subin_text1 = "",
  bnd_subin_num2 = "",
  bnd_subin_text2 = "",
  bnd_subin_num3 = "",
  bnd_subin_text3 = "",

  bnd_subout_num1 = "",
  bnd_subout_text1 = "",
  bnd_subout_num2 = "",
  bnd_subout_text2 = "",
  bnd_subout_num3 = "",
  bnd_subout_text3 = ""
}

  for k,v in pairs(o.bndList) do
    o.im.Subscribe(k, function()
    end)
  end
  
  o.im.Subscribe(bndVisible, function()
    o.im.Publish(bndVisible, false)
  end)
  
  o.im.Subscribe(bndNationalization, function()
  end)
  
  o.im.Subscribe(bndSubstitutionList, function()
  end)

  for k,v in pairs(o.currentEvent) do
    o.im.Subscribe(k, function()
      o.im.Publish(k, v)
    end)
  end

  return o
end

function Substitution:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeSubstitutionOut then
    self:updateSubstitution(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function Substitution:updateSubstitution(subtype, hideshow, subtypestr, msg)
  print("updateSubstitution " .. msg)
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      self.im.Publish(bndVisible, true)
      self.bndList.bnd_sub_crest.id = params[1]
      self.im.Publish("bnd_sub_crest", self.bndList.bnd_sub_crest)
      TeamId = params[1] + 0
      
      local substitutionsInfo = {
        NumberofSubs = params[3] + 0,
        SubIn1Text = params[4],
        SubIn1NumText = params[5],
        SubIn2Text = params[6],
        SubIn2NumText = params[7],
        SubIn3Text = params[8],
        SubIn3NumText = params[9],
        SubOut1Text = params[11],
        SubOut1NumText = params[12],
        SubOut2Text = params[13],
        SubOut2NumText = params[14],
        SubOut3Text = params[15],
        SubOut3NumText = params[16],
        overlayTitle = ("换人"),
        TeamId = params[1] + 0
      }
      
      if substitutionsInfo.SubIn2NumText == "-1" then
        self.im.Publish("bnd_subin1_visible", true)
        self.im.Publish("bnd_subin2_visible", false)
        self.im.Publish("bnd_subin3_visible", false)
      elseif substitutionsInfo.SubIn3NumText == "-1" then
        self.im.Publish("bnd_subin2_visible", true)
        self.im.Publish("bnd_subin1_visible", false)
        self.im.Publish("bnd_subin3_visible", false)
      elseif substitutionsInfo.SubIn3NumText ~= "-1" then
        self.im.Publish("bnd_subin3_visible", true)
        self.im.Publish("bnd_subin1_visible", false)
        self.im.Publish("bnd_subin2_visible", false)
       else
         self.im.Publish("bnd_subin3_visible", true)
        self.im.Publish("bnd_subin1_visible", false)
        self.im.Publish("bnd_subin2_visible", false)
      end
      if substitutionsInfo.SubOut2NumText == "-1" then
        self.im.Publish("bnd_subout1_visible", true)
        self.im.Publish("bnd_subout2_visible", false)
       self.im.Publish("bnd_subout3_visible", false)
      elseif substitutionsInfo.SubOut3NumText == "-1" then
        self.im.Publish("bnd_subout2_visible", true)
       self.im.Publish("bnd_subout1_visible", false)
       self.im.Publish("bnd_subout3_visible", false)
      elseif substitutionsInfo.SubOut3NumText ~= "-1" then
        self.im.Publish("bnd_subout3_visible", true)
      self.im.Publish("bnd_subout1_visible", false)
       self.im.Publish("bnd_subout2_visible", false)
       else
         self.im.Publish("bnd_subout3_visible", true)
      self.im.Publish("bnd_subout1_visible", false)
       self.im.Publish("bnd_subout2_visible", false)
      end
      self.im.Publish("bnd_subin_num1", substitutionsInfo.SubIn1NumText)
      self.im.Publish("bnd_subin_text1", substitutionsInfo.SubIn1Text)
      self.im.Publish("bnd_subin_num2", substitutionsInfo.SubIn2NumText)
      self.im.Publish("bnd_subin_text2", substitutionsInfo.SubIn2Text)
      self.im.Publish("bnd_subin_num3", substitutionsInfo.SubIn3NumText)
      self.im.Publish("bnd_subin_text3", substitutionsInfo.SubIn3Text)

      self.im.Publish("bnd_subout_num1", substitutionsInfo.SubOut1NumText)
      self.im.Publish("bnd_subout_text1", substitutionsInfo.SubOut1Text)
      self.im.Publish("bnd_subout_num2", substitutionsInfo.SubOut2NumText)
      self.im.Publish("bnd_subout_text2", substitutionsInfo.SubOut2Text)
      self.im.Publish("bnd_subout_num3", substitutionsInfo.SubOut3NumText)
      self.im.Publish("bnd_subout_text3", substitutionsInfo.SubOut3Text)
    end
  else
    self.im.Publish(bndVisible, false)
    self.im.Publish("bnd_subin1_visible", false)
    self.im.Publish("bnd_subin2_visible", false)
    self.im.Publish("bnd_subin3_visible", false)
    self.im.Publish("bnd_subout1_visible", false)
    self.im.Publish("bnd_subout2_visible", false)
    self.im.Publish("bnd_subout3_visible", false)
  end
end

function Substitution:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function Substitution:finalize()
  self.im.Unsubscribe(bndVisible)
  self.im.Unsubscribe(bndSubstitutionList)
  self.im.Unsubscribe(bndNationalization)
  
  for k,v in pairs(self.bndList) do
    self.im.Unsubscribe(k)
  end
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  
end

return Substitution