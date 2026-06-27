local ScoreboardSubstitutions = {}
local OverlaysIdContainer, OverlayParam, eventmanager = ...
local Overlays = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local initialized = false
local bndVisible = "bnd_visible"
local bndNationalization = "bnd_nationalization"
local bndData = "bnd_data"
local bndAlpha = "bnd_alpha"



EAFCInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x00D9D1",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0x000000",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x000000",
  
  bnd_bghome_color = "0x00D9D1",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x00D9D1",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 0
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

DFLInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x2E2E2E",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x2E2E2E",
  
  bnd_bghome_color = "0x2E2E2E",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x2E2E2E",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = "0_DFL"
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

EnglandInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x39003E",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xF5F5F5",
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x39003E",
  
  bnd_bghome_color = "0x39003E",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0x39003E",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 13
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

SpainInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0xFF5C41",
  bnd_bg1_width = 300,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0x151515",
  bnd_bghome_width = 90,
  bnd_bghome_height = 120,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x151515",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 53
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 95,
  bnd_logo_left = 0,
  bnd_logo_height = 16,
  bnd_logo_width = 80
}

SpainBInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x00F0FF",
  bnd_bg1_width = 300,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0x151515",
  bnd_bghome_width = 90,
  bnd_bghome_height = 120,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x151515",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 54
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 95,
  bnd_logo_left = 0,
  bnd_logo_height = 16,
  bnd_logo_width = 80
}

GermanyInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0xD10214",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0x000000",
  
  bnd_bghome_color = "0x333333",
  bnd_bghome_width = 90,
  bnd_bghome_height = 120,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x333333",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 19
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

franceInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x2E2E2E",
  bnd_bg1_width = 300,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x000000",
  
  bnd_bghome_color = "0x0040FF",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x0040FF",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = "16_1"
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

ItalyInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x14306F",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x000000",
  
  bnd_bghome_color = "0x14306F",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0x14306F",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 31
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

BrazilInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x0B173B",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x0B173B",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0x0B173B",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "TOP",
  bnd_bgaway_color = "0x0B173B",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 19
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

BrazilGloboInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x1C1C1C",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xBCFF79",
  
  bnd_bg2_color = "0x1C1C1C",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0x000000",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "TOP",
  bnd_bgaway_color = "0x000000",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 7
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

BrazilAmazonInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x000000",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x000000",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0x00A7FF",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "TOP",
  bnd_bgaway_color = "0x00A7FF",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 7
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

BrazilInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x0B173B",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x0B173B",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0x0B173B",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "TOP",
  bnd_bgaway_color = "0x0B173B",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 7
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

MexicoInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x1D3D66",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x1D3D66",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0xffffff",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "TOP",
  bnd_bgaway_color = "0xffffff",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 341
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

ArgentinaInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x1F3139",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x1F3139",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0x1F3139",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "TOP",
  bnd_bgaway_color = "0x1F3139",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 353
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

IndonesiaInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x001E6C",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xF5F5F5",
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x000000",
  
  bnd_bghome_color = "0x001E6C",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0x001E6C",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 13
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

SaudiArabiaInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x0B3861",
  bnd_bg1_width = 300,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0xFFFFFF",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0xFFFFFF",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 350
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

RussiaInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x000C50",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0xC4C8CC",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x1E1E1E",
  
  bnd_bghome_color = "0x000C50",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x000C50",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 67
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

LeaguePariInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x00D2BC",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0x000E08",
  
  bnd_bg2_color = "0x000E08",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x00D2BC",
  
  bnd_bghome_color = "0x00D2BC",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x00D2BC",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2245
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

UkraineInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x0039AB",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x000000",
  
  bnd_bghome_color = "0x0039AB",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x0039AB",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 332
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

InternationalInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0xD3AA32",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0xD3AA32",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0xD3AA32",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 78
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

--------- Tournaments ---------

UCLInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x091C94",
  bnd_bg1_width = 300,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x08187D",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0xFFFFFF",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0xFFFFFF",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 13
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

UELInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0xE14711",
  bnd_bg1_width = 300,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x000000",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0x000000",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x000000",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = "2238_1"
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

EuroCopaInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x1544F6",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x001852",
  
  bnd_bghome_color = "0x001852",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0x001852",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 13
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

NationsLeagueInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x4F6B7F",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xDBE2E3",
  
  bnd_bg2_color = "0xDBE2E3",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0x4F6B7F",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x4F6B7F",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2241
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

UefaWomensInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0x012652",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x0657A0",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0xFFFFFF",
  bnd_bghome_width = 60,
  bnd_bghome_height = 60,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "TOP",
  bnd_bgaway_color = "0xFFFFFF",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 60,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = "2240_1"
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

UCLClassicInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x0B3861",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xE5E5E5",
  
  bnd_bg2_color = "0xE5E5E5",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0x0B3861",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x0B3861",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2236
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

LibertadoresInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0xBC9751",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0x000000",
  
  bnd_bg2_color = "0x000000",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0xffffff",
  
  bnd_bghome_color = "0xBC9751",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0xBC9751",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2237
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

SudamericanaInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0xB3B3B3",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0x001650",
  
  bnd_bg2_color = "0x001650",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0xffffff",
  
  bnd_bghome_color = "0xB3B3B3",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0xB3B3B3",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2267
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

CopaAmericaInfo = { -- 300x120
  bnd_bg1homeaway_show = false,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "BOTTOM",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "BOTTOM",
  bnd_bg1_color = "0xE0E0E0",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0x000000",
  
  bnd_bg2_color = "0x000000",
  bnd_bg2_alignV = "TOP",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0x1B1365",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "TOP",
  bnd_bgaway_color = "0xB40309",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 19
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

WorldCupInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x146945",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0x281B63",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0x146945",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0x146945",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 365
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

WomenWorldCupInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x275759",
  bnd_bg1_width = 300,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xF7F9E1",
  
  bnd_bg2_color = "0xF7F9E1",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x1E1E1E",
  
  bnd_bghome_color = "0x1E1E1E",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0x1E1E1E",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 0
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

ClubWorldCupInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0xCDA31F",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0x000000",
  
  bnd_bg2_color = "0x000000",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0xFFFFFF",
  
  bnd_bghome_color = "0xCDA31F",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0xCDA31F",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2209
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

FacupInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0xA8222A",
  bnd_bg1_width = 300,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xFFFFFF",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0xA8222A",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0xA8222A",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = "13_2"
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

CoppaItaliaInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "RIGHT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "LEFT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0xBE0003",
  bnd_bg1_width = 120,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0x000000",
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x000000",
  
  bnd_bghome_color = "0xBE0003",
  bnd_bghome_width = 90,
  bnd_bghome_height = 90,
  bnd_bghome_left = -90,
  bnd_home_crest_alignV = "CENTER",
  bnd_home_crest_bottom = 0,
  bnd_home_crest_height = 75,
  bnd_home_crest_width = 75,
  bnd_bghomeaway_alignV = "BOTTOM",
  bnd_bgaway_color = "0xBE0003",
  bnd_bgaway_width = 90,
  bnd_bgaway_height = 90,
  bnd_bgaway_right = -90,
  bnd_away_crest_alignV = "CENTER",
  bnd_away_crest_bottom = 0,
  bnd_away_crest_height = 75,
  bnd_away_crest_width = 75,
  
  bnd_logo = {
    name = "$LeagueLogo1",
    id = "2231_1",
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = -15,
  bnd_logo_left = 330,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

SaudiSuperCupInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x2F0B3A",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0x2F0B3A",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x2F0B3A",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = 3350
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

KingCupInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x1E692D",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0x1E692D",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x1E692D",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = "350_5"
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

PaulistaoInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x00019D",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0x00019D",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x00019D",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_29"
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

CariocaInfo = { -- 300x120
  bnd_bg1homeaway_show = true,
  bnd_bg1home_alignH = "LEFT",
  bnd_bg1home_alignV = "TOP",
  bnd_bg1away_alignH = "RIGHT",
  bnd_bg1away_alignV = "TOP",
  bnd_bg1_color = "0x142a37",
  bnd_bg1_width = 150,
  bnd_bg1_height = 30,
  bnd_textsub_fontColor = "0xffffff",
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_alignV = "BOTTOM",
  bnd_InOut_name_fontColor = "0x151515",
  
  bnd_bghome_color = "0x142a37",
  bnd_bghome_width = 60,
  bnd_bghome_height = 120,
  bnd_bghome_left = -60,
  bnd_home_crest_alignV = "BOTTOM",
  bnd_home_crest_bottom = 10,
  bnd_home_crest_height = 50,
  bnd_home_crest_width = 50,
  bnd_bghomeaway_alignV = "CENTER",
  bnd_bgaway_color = "0x142a37",
  bnd_bgaway_width = 60,
  bnd_bgaway_height = 120,
  bnd_bgaway_right = -60,
  bnd_away_crest_alignV = "BOTTOM",
  bnd_away_crest_bottom = 10,
  bnd_away_crest_height = 50,
  bnd_away_crest_width = 50,
  
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_30"
  },
  bnd_logo_alignV = "TOP",
  bnd_logo_top = 5,
  bnd_logo_left = 0,
  bnd_logo_height = 50,
  bnd_logo_width = 50
}

function ScoreboardSubstitutions:new(init)
  print("[ScoreboardSubstitutions]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.nationalization = 2
  o.services = {
    eventManService = o.api("EventManagerService"),
    SquadManagementService = o.api("SquadMgtService"),
    GameSetupService = o.api("GameSetupService"),
    MatchInfoService = o.api("MatchInfoService"),
    OverlayService = o.api("OverlayService"),
    TeamService = o.api("TeamService")
  }
  local HOMETEAM = 0
  local AWAYTEAM = 1
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  
  homeTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(HOMETEAM, o.TeamsData[1].assetId, 0)
  awayTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(AWAYTEAM, o.TeamsData[2].assetId, 0)
  
  
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
      
      
      
  HomeTeamData = {
    teamAssetId = o.TeamsData[1].assetId,
    shortName = o.services.GameSetupService.GetTeamShortName(HOMETEAM),
    crest = {
      name = "$Crest",
      id = o.TeamsData[1].assetId
    }
  }

  AwayTeamData = {
    teamAssetId = o.TeamsData[2].assetId,
    shortName = o.services.GameSetupService.GetTeamShortName(AWAYTEAM),
    crest = {
      name = "$Crest",
      id = o.TeamsData[2].assetId
    }
  }

  o.handlerId = o.services.eventManService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  
  o.im.Subscribe(bndNationalization, function()
  end)
  o.im.Subscribe(bndVisible, function()
    o.im.Publish(bndVisible, false)
  end)
  o.im.Subscribe(bndAlpha, function()
  end)
  o.im.Subscribe(bndData, function()
  end)
  o.im.Subscribe("bnd_Inplayer_avatar", function()
  end)
  o.im.Subscribe("bnd_Inplayer_name", function()
  end)
  o.im.Subscribe("bnd_Inplayer_number", function()
  end)
  o.im.Subscribe("bnd_Outplayer_avatar", function()
  end)
  o.im.Subscribe("bnd_Outplayer_name", function()
  end)
  o.im.Subscribe("bnd_Outplayer_number", function()
  end)
  o.im.Subscribe("bnd_home_crest_show", function()
    o.im.Publish("bnd_home_crest_show", false)
  end)
  o.im.Subscribe("bnd_away_crest_show", function()
    o.im.Publish("bnd_away_crest_show", false)
  end)
  o.im.Subscribe("bnd_home_crest", function()
    o.im.Publish("bnd_home_crest", HomeTeamData.crest)
  end)
  o.im.Subscribe("bnd_away_crest", function()
    o.im.Publish("bnd_away_crest", AwayTeamData.crest)
  end)
  
    for k,v in pairs(o.currentEvent) do
    o.im.Subscribe(k, function()
      o.im.Publish(k, v)
    end)
  end
  
  return o
end

function ScoreboardSubstitutions:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeIngameSubstitution then
    self:updateScoreboardSubstitutions(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function ScoreboardSubstitutions:updateScoreboardSubstitutions(subtype, hideshow, subtypestr, msg)
  local params = OverlayParam.split(msg, "|")
  InplayerAvatar = {
    name = "$Head",
    id = 0
  }
  OutplayerAvatar = {
    name = "$Head",
    id = 0
  }
  if hideshow == "SHOW" then
    if initialized == false then
      self.im.Publish(bndNationalization, self.nationalization)
      initialized = true
    end
    if params and table.getn(params) > 0 then
      self.im.Publish(bndVisible, true)
      local subTeamId = params[2] + 0
      local substitutions = {
        teamName = params[3],
        inPlayer = params[4],
        outPlayer = params[5]
      }
      local teamside = 0
      if subTeamId == self.TeamsData[1].assetId then
        teamside = 0
      else
        teamside = 1
      end
      
      local InplayerInfo = self:getPlayerInfo(teamside, subTeamId, substitutions.inPlayer)
      local OutplayerInfo = self:getPlayerInfo(teamside, subTeamId, substitutions.outPlayer)
      InplayerAvatar.id = InplayerInfo.assetId
      OutplayerAvatar.id = OutplayerInfo.assetId
      self.im.Publish("bnd_Inplayer_avatar", InplayerAvatar)
      self.im.Publish("bnd_Outplayer_avatar", OutplayerAvatar)
      self.im.Publish("bnd_Inplayer_name", InplayerInfo.playerName)
      self.im.Publish("bnd_Outplayer_name", OutplayerInfo.playerName)
      self.im.Publish("bnd_Inplayer_number", InplayerInfo.jerseyNumber.."")
      self.im.Publish("bnd_Outplayer_number", OutplayerInfo.jerseyNumber.."")
      if teamside == 0 then
        self.im.Publish("bnd_home_crest_show", true)
        self.im.Publish("bnd_away_crest_show", false)
      else
        self.im.Publish("bnd_away_crest_show", true)
        self.im.Publish("bnd_home_crest_show", false)
      end
      self.im.Publish(bndData, substitutions)
    end
  elseif hideshow == "UPDATE" then
    self.im.Publish(bndAlpha, params[1] / 100)
    if params and table.getn(params) > 1 then
      self.im.Publish(bndVisible, true)
      local subTeamId = params[2] + 0
      local teamside = 0
      if subTeamId == self.TeamsData[1].assetId then
        teamside = 0
      else
        teamside = 1
      end
      local substitutions = {
        teamName = params[3],
        inPlayer = params[4],
        outPlayer = params[5]
      }
      local InplayerInfo = self:getPlayerInfo(teamside, subTeamId, substitutions.inPlayer)
      local OutplayerInfo = self:getPlayerInfo(teamside, subTeamId, substitutions.outPlayer)
      InplayerAvatar.id = InplayerInfo.assetId
      OutplayerAvatar.id = OutplayerInfo.assetId
      self.im.Publish("bnd_Inplayer_avatar", InplayerAvatar)
      self.im.Publish("bnd_Outplayer_avatar", OutplayerAvatar)
      self.im.Publish("bnd_Inplayer_name", InplayerInfo.playerName)
      self.im.Publish("bnd_Outplayer_name", OutplayerInfo.playerName)
      self.im.Publish("bnd_Inplayer_number", InplayerInfo.jerseyNumber.."")
      self.im.Publish("bnd_Outplayer_number", OutplayerInfo.jerseyNumber.."")
      if teamside == 0 then
        self.im.Publish("bnd_home_crest_show", true)
        self.im.Publish("bnd_away_crest_show", false)
      else
        self.im.Publish("bnd_away_crest_show", true)
        self.im.Publish("bnd_home_crest_show", false)
      end
      self.im.Publish(bndData, substitutions)
    end
  else
    self.im.Publish(bndVisible, false)
    self.im.Publish("bnd_home_crest_show", false)
    self.im.Publish("bnd_away_crest_show", false)
  end
end

function ScoreboardSubstitutions:getPlayerInfo(teamSide, teamID, playername)
  local playerInfo = {
    assetId = 0,
    jerseyNumber = 0,
    playerName = playername
  }
  local teamlineupData
  if teamSide == 0 then
    teamlineupData = homeTeamlineupData
  else 
    teamlineupData = awayTeamlineupData
  end
  
  if string.find(playername, "-") then
    playerInfo.playerName = string.gsub(playername, "%-", " ")
  end
  
  for _FORV_6_ = 1, table.getn(teamlineupData) do
    if string.find(playername, teamlineupData[_FORV_6_].playerName, 1, true) then
      playerInfo.assetId = teamlineupData[_FORV_6_].CARD_ID
      playerInfo.jerseyNumber = teamlineupData[_FORV_6_].jerseyNumber
      playerInfo.playerName = teamlineupData[_FORV_6_].playerName
    end
  end
  return playerInfo
end

function ScoreboardSubstitutions:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function ScoreboardSubstitutions:finalize()
  print("ScoreboardSubstitutions:finalize")
  self.services.eventManService.UnregisterHandler(self.handlerId)
  self.im.Unsubscribe(bndVisible)
  self.im.Unsubscribe(bndAlpha)
  self.im.Unsubscribe(bndData)
  self.im.Unsubscribe(bndNationalization)
  self.im.Unsubscribe("bnd_Inplayer_avatar")
  self.im.Unsubscribe("bnd_Inplayer_name")
  self.im.Unsubscribe("bnd_Inplayer_number")
  self.im.Unsubscribe("bnd_Outplayer_avatar")
  self.im.Unsubscribe("bnd_Outplayer_name")
  self.im.Unsubscribe("bnd_Outplayer_number")
  self.im.Unsubscribe("bnd_home_crest_show")
  self.im.Unsubscribe("bnd_away_crest_show")
  self.im.Unsubscribe("bnd_home_crest")
  self.im.Unsubscribe("bnd_away_crest")
  
  for k,v in pairs(EAFCInfo) do
    self.im.Unsubscribe(k)
  end
  self.services.eventManService.UnregisterHandler(self.handlerId)
end
return ScoreboardSubstitutions