local EventInfo = {}

local OverlaysIdContainer, OverlayParam, eventmanager = ...
local Overlays = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local goalStatistics = {}
--local isinitialized = 0
local initialized = false

local BND_VISIBLE = "bnd_visible"
local BND_NATIONALIZATION = "bnd_nationalization"
local BND_DATA = "bnd_data"
local BND_ALPHA = "bnd_alpha"

local beforeHomeScore = 0
local beforeAwayScore = 0
local nowHomeScore = 0
local nowAwayScore = 0

local goalStatistics = {}
--local isinitialized = 0

EAFCInfo = {
  bnd_fontFace = "$CruyffSans-Heavy",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0xFFFFFF",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x00D9D1",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xFFFFFF",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0x000000",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0x000000",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

DFLInfo = {
  bnd_fontFace = "$DINPro-Bold",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x2E2E2E",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x2E2E2E",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xFFFFFF",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x2E2E2E",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

EnglandInfo = {
  bnd_fontFace = "$PremierLeague",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x461648",
  bnd_bg1_color_alignH = "LEFT",
  bnd_bg1_color_width = 300,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x461648",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 15,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xF5F5F5",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 20,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xF5F5F5",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0x461648",
  bnd_goal_player_level_fontSize = 15,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xF5F5F5",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 18,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 5,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x461648",
  bnd_goal_player_desc_fontSize = 10,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x461648",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

SpainInfo = {
  bnd_fontFace = "$LaLiga",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x151515",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xFF5C41",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 30,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xFF5C41",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 80,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xF5F5F5",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 25,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xF5F5F5",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 20,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 25,
  bnd_goal_type_right = 0
}

SpainBInfo = {
  bnd_fontFace = "$LaLiga",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x151515",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x00F0FF",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 30,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xFF5C41",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 80,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xF5F5F5",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 25,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xF5F5F5",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 20,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 25,
  bnd_goal_type_right = 0
}

GermanyInfo = {
  bnd_fontFace = "$Bundesliga",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0xFFFFFF",
  bnd_bg1_color_alignH = "LEFT",
  bnd_bg1_color_width = 300,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xD10214",
  bnd_bg2_color_alignH = "LEFT",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xD10214",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 20,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xD10214",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 21,
  bnd_goal_player_name_bottom = 0,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 20,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 19,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 15,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 80,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 10,
  bnd_goal_player_desc_alignV = "TOP",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 3,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 18,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 0,
  bnd_goal_type_bottom = 15,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 15
}

FranceInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x0040FF",
  bnd_bg1_color_alignH = "LEFT",
  bnd_bg1_color_width = 300,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x2E2E2E",
  bnd_bg2_color_alignH = "LEFT",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xffffff",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x2E2E2E",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xffffff",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 20,
  -- Level
  bnd_goal_player_level_fontColor = "0xffffff",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 80,
  -- Count
  bnd_goal_player_count_fontColor = "0xffffff",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xffffff",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "RIGHT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 0,
  bnd_goal_player_desc_right = 50,
  -- Type
  bnd_goal_type_fontColor = "0xffffff",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 20
}

ItalyInfo = {
  bnd_fontFace = "$SerieA",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x14306F",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x14306F",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 30,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xFF5C41",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 80,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xF5F5F5",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 25,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xF5F5F5",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 20,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 25,
  bnd_goal_type_right = 0
}

BrazilInfo = {
  bnd_fontFace = "$Brasil-Sportv",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x0B173B",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x0B173B",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x0B173B",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x0B173B",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

BrazilGloboInfo = {
  bnd_fontFace = "$Brasil-Globo",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x000000",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x000000",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x000000",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x000000",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xBCFF79",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

BrazilAmazonInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x00A7FF",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x00A7FF",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x00A7FF",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x00A7FF",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

MexicoInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x1D3D66",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x1D3D66",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x1D3D66",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x1D3D66",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

ArgentinaInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x1F3139",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x1F3139",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x1F3139",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x1F3139",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

IndonesiaInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x001E6C",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xffffff",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x001E6C",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xffffff",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xffffff",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xF5F5F5",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x461648",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x001E6C",
  bnd_goal_type_fontSize = 17,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

SaudiArabiaInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0xFFFFFF",
  bnd_bg1_color_alignH = "LEFT",
  bnd_bg1_color_width = 300,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x0B3861",
  bnd_bg2_color_alignH = "LEFT",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x0B3861",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 20,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x0B3861",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 21,
  bnd_goal_player_name_bottom = 0,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 20,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 19,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 15,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 80,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 10,
  bnd_goal_player_desc_alignV = "TOP",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 3,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 18,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 0,
  bnd_goal_type_bottom = 15,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 15
}

RussiaInfo = {
  bnd_fontFace = "$Russian",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0xC4C8CC",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xC4C8CC",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x000C50",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xC4C8CC",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0x1E1E1E",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0x1E1E1E",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x1E1E1E",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x1E1E1E",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x1E1E1E",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

LeaguePariInfo = {
  bnd_fontFace = "$KnulExtraBold",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x000E08",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x000E08",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x00D2BC",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x000E08",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0x00D2BC",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0x00D2BC",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x00D2BC",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x00D2BC",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x00D2BC",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

UkraineInfo = {
  bnd_fontFace = "$KnulExtraBold",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x0039AB",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x0039AB",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x0039AB",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x0039AB",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

InternationalInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0xD3AA32",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xffffff",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xD3AA32",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xffffff",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xffffff",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xF5F5F5",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x461648",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xD3AA32",
  bnd_goal_type_fontSize = 17,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

--------- Tournaments ---------

UCLInfo = {
  bnd_fontFace = "$UCL-Regular",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x0C1D83",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x0C1D83",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 15,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x0C1D83",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 20,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 10,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

UELInfo = {
  bnd_fontFace = "$UEL-Bold",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 90,
  -- Background
  bnd_bg1_color = "0x000000",
  bnd_bg1_color_alignH = "LEFT",
  bnd_bg1_color_width = 300,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xE14711",
  bnd_bg2_color_alignH = "LEFT",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xFFFFFF",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 40,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x474BE5",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 21,
  bnd_goal_player_name_bottom = 0,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 20,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 19,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 15,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 80,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 18,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "CENTER",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 15,
  bnd_goal_player_desc_left = 0,
  bnd_goal_player_desc_right = 10,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 18,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "LEFT",
  bnd_goal_type_top = 0,
  bnd_goal_type_bottom = 15,
  bnd_goal_type_left = 20,
  bnd_goal_type_right = 0
}

EuroCopaInfo = {
  bnd_fontFace = "$UEFAEuro-Bold",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x1544F6",
  bnd_bg1_color_alignH = "LEFT",
  bnd_bg1_color_width = 300,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_color_alignH = "LEFT",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x001852",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x001852",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xffffff",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 20,
  -- Level
  bnd_goal_player_level_fontColor = "0xffffff",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 80,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "RIGHT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 0,
  bnd_goal_player_desc_right = 50,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 20
}

NationsLeagueInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0xDBE2E3",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xffffff",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xDBE2E3",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0x000000",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0x000000",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 17,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

UefaWomensInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x0657A0",
  bnd_bg1_color_alignH = "LEFT",
  bnd_bg1_color_width = 300,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xFFFFFF",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x012652",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 15,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x012652",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 20,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xF5F5F5",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0x000000",
  bnd_goal_player_level_fontSize = 15,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xF5F5F5",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 18,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 8,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 10,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

UCLClassicInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x0B3861",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xffffff",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x0B3861",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xffffff",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xffffff",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xF5F5F5",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x461648",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x0B3861",
  bnd_goal_type_fontSize = 17,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

LibertadoresInfo = {
  bnd_fontFace = "$Libertadores",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0xBC9751",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x000000",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xBC9751",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 30,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x000000",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 80,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xF5F5F5",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 25,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xF5F5F5",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xffffff",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xffffff",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 20,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xffffff",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 25,
  bnd_goal_type_right = 0
}

SudamericanaInfo = {
  bnd_fontFace = "$Libertadores",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0xB3B3B3",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x001650",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xB3B3B3",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 30,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x001650",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 80,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0x001650",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 25,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0x001650",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xffffff",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xffffff",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 20,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xffffff",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 25,
  bnd_goal_type_right = 0
}

CopaAmericaInfo = {
  bnd_fontFace = "$CopaAmerica",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x000000",
  bnd_bg1_color_alignH = "LEFT",
  bnd_bg1_color_width = 300,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xB40309",
  bnd_bg2_color_alignH = "LEFT",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x0C1D83",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 20,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x0C1D83",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 21,
  bnd_goal_player_name_bottom = 0,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 20,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 19,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 15,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 80,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 10,
  bnd_goal_player_desc_alignV = "TOP",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 3,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 18,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 0,
  bnd_goal_type_bottom = 15,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 15
}

WorldCupInfo = {
  bnd_fontFace = "$Anybody-Bold",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x281B63",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x146945",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x146945",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 30,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x281B63",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 80,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 25,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 20,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 25,
  bnd_goal_type_right = 0
}

WomensWorldCupInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x151515",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xE0E0E0",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x2D7F95",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 30,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x2D7F95",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 80,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xF5F5F5",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 25,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xF5F5F5",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 20,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 25,
  bnd_goal_type_right = 0
}

ClubWorldCupInfo = {
  bnd_fontFace = "$DINPro-Bold",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x000000",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x000000",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x000000",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x000000",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xCDA31F",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

FACupInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0xFF0018",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xffffff",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xFF0018",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xffffff",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xffffff",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xF5F5F5",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x461648",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFF0018",
  bnd_goal_type_fontSize = 17,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

CoppaItaliaInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0xBD0008",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xF5F5F5",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xBD0008",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 30,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0xFF5C41",
  bnd_bg_crest_color_alpha = 0,
  bnd_team_crest_width = 35,
  bnd_team_crest_height = 35,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 15,
  bnd_team_crest_left = 80,
  bnd_team_crest_right = -10,
  -- Name
  bnd_goal_player_name_fontColor = "0xF5F5F5",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 25,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xF5F5F5",
  bnd_goal_player_level_fontSize = 18,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 0,
  bnd_goal_player_level_bottom = 15,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0x000000",
  bnd_goal_player_count_fontSize = 18,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 18,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 19,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x000000",
  bnd_goal_player_desc_fontSize = 15,
  bnd_goal_player_desc_alignV = "CENTER",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 20,
  bnd_goal_player_desc_bottom = 0,
  bnd_goal_player_desc_left = 20,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x000000",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 25,
  bnd_goal_type_right = 0
}

SaudiSuperCupInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x2F0B3A",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xffffff",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x2F0B3A",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xffffff",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xffffff",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xF5F5F5",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x461648",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x2F0B3A",
  bnd_goal_type_fontSize = 17,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

KingCupInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 100,
  -- Background
  bnd_bg1_color = "0x1E692D",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0xffffff",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0xffffff",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x1E692D",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xffffff",
  bnd_goal_player_name_fontSize = 18,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xffffff",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xF5F5F5",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0x461648",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0x1E692D",
  bnd_goal_type_fontSize = 17,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

PaulistaoInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x00019D",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x00019D",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x00019D",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x00019D",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

CariocaInfo = {
  bnd_fontFace = "$Title",
  -- Posisi
  bnd_eventinfo_alignV = "BOTTOM",
  bnd_eventinfo_alignH = "LEFT",
  bnd_eventinfo_bottom = 65,
  bnd_eventinfo_left = 50,
  -- Background
  bnd_bg1_color = "0x142a37",
  bnd_bg1_color_alignH = "CENTER",
  bnd_bg1_color_width = 350,
  bnd_bg1_color_left = 0,
  
  bnd_bg2_color = "0x142a37",
  bnd_bg2_color_alignH = "CENTER",
  bnd_bg2_color_width = 350,
  bnd_bg2_color_left = 0,
  -- Avatar
  bnd_bg_avatar_color = "0x142a37",
  bnd_goal_player_avatar_alignV = "CENTER",
  bnd_goal_player_avatar_alignH = "LEFT",
  bnd_goal_player_avatar_top = 0,
  bnd_goal_player_avatar_bottom = 0,
  bnd_goal_player_avatar_left = 0,
  bnd_goal_player_avatar_right = 0,
  -- Crest
  bnd_bg_crest_color = "0x142a37",
  bnd_bg_crest_color_alpha = 1,
  bnd_team_crest_width = 0,
  bnd_team_crest_height = 0,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_top = 0,
  bnd_team_crest_bottom = 0,
  bnd_team_crest_left = 0,
  bnd_team_crest_right = 0,
  -- Name
  bnd_goal_player_name_fontColor = "0xFFFFFF",
  bnd_goal_player_name_fontSize = 21,
  bnd_goal_player_name_alignV = "CENTER",
  bnd_goal_player_name_alignH = "CENTER",
  bnd_goal_player_name_top = 0,
  bnd_goal_player_name_bottom = 15,
  bnd_goal_player_name_left = 0,
  bnd_goal_player_name_right = 0,
  -- Level
  bnd_goal_player_level_fontColor = "0xFFFFFF",
  bnd_goal_player_level_fontSize = 0,
  bnd_goal_player_level_alignV = "CENTER",
  bnd_goal_player_level_alignH = "RIGHT",
  bnd_goal_player_level_top = 20,
  bnd_goal_player_level_bottom = 0,
  bnd_goal_player_level_left = 0,
  bnd_goal_player_level_right = 20,
  -- Count
  bnd_goal_player_count_fontColor = "0xFFFFFF",
  bnd_goal_player_count_fontSize = 40,
  bnd_goal_player_count_alignV = "CENTER",
  bnd_goal_player_count_alignH = "RIGHT",
  bnd_goal_player_count_top = 0,
  bnd_goal_player_count_bottom = 0,
  bnd_goal_player_count_left = 0,
  bnd_goal_player_count_right = 15,
  -- PlayerDesc
  bnd_goal_player_desc_fontColor = "0xFFFFFF",
  bnd_goal_player_desc_fontSize = 0,
  bnd_goal_player_desc_alignV = "BOTTOM",
  bnd_goal_player_desc_alignH = "LEFT",
  bnd_goal_player_desc_top = 0,
  bnd_goal_player_desc_bottom = 2,
  bnd_goal_player_desc_left = 10,
  bnd_goal_player_desc_right = 0,
  -- Type
  bnd_goal_type_fontColor = "0xFFFFFF",
  bnd_goal_type_fontSize = 15,
  bnd_goal_type_alignV = "CENTER",
  bnd_goal_type_alignH = "CENTER",
  bnd_goal_type_top = 20,
  bnd_goal_type_bottom = 0,
  bnd_goal_type_left = 0,
  bnd_goal_type_right = 0
}

function EventInfo:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.nationalization = 2
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    SquadManagementService = o.api("SquadMgtService"),
    MatchInfoService = o.api("MatchInfoService"),
    TeamService = o.api("TeamService")
  }
  local HOMETEAM = 0
  local AWAYTEAM = 1
  
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  homeTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(HOMETEAM, o.TeamsData[1].assetId, 0)
  awayTeamlineupData = o.services.SquadManagementService.GetCurrentPlayerLineup(AWAYTEAM, o.TeamsData[2].assetId, 0)
 
  
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
      o.currentEvent = FACupInfo
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
    o.currentEvent = FACupInfo
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
    o.currentEvent = FranceInfo
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
      
  o.isinitialized = 0
  
  local facts = o:getMatchFacts()
  nowHomeScore = facts[1].data.value + 0
  nowAwayScore = facts[1].data.valueRight + 0

  teamCrest = {
    name = "$Crest",
    id = 0
  }
  playerAvatar = {
    name = "$Head",
    id = 0
  }
   teamCrest = {
    name = "$Crest",
    id = 0
  }
  
  o.im.Subscribe(BND_NATIONALIZATION, function()
  end)
  o.im.Subscribe(BND_VISIBLE, function()
    o.im.Publish(BND_VISIBLE, false)
  end)
  o.im.Subscribe("bnd_player_visible", function()
    o.im.Publish("bnd_player_visible", false)
  end)
  o.im.Subscribe(BND_ALPHA, function()
  end)
  o.im.Subscribe(BND_DATA, function()
  end)
  o.im.Subscribe("bnd_text", function()
  end)
  o.im.Subscribe("bnd_team_crest", function()
  end)
  o.im.Subscribe("bnd_goal_player_avatar", function()
  end)
  o.im.Subscribe("bnd_goal_player_name", function()
  end)
  o.im.Subscribe("bnd_goal_team_name", function()
  end)
  o.im.Subscribe("bnd_goal_player_level", function()
  end)
  o.im.Subscribe("bnd_goal_player_count", function()
  end)
  o.im.Subscribe("bnd_goal_player_desc", function()
  end)
  o.im.Subscribe("bnd_goal_time", function()
  end)
  o.im.Subscribe("bnd_goal_type", function()
  end)
  o.im.Subscribe("bnd_goal_desc", function()
  end)
  
    for k,v in pairs(o.currentEvent) do
    o.im.Subscribe(k, function()
      o.im.Publish(k, v)
    end)
  end
  
  return o
end

function EventInfo:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeIngameCardInjury then
    self:updateEventInfo(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
  if eventType == EventTypes.OverlayTypeGoal then
    self:updateGoalScored(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function EventInfo:updateEventInfo(subtype, hideshow, subtypestr, msg)
  local params = OverlayParam.split(msg, "|")
  if hideshow == "SHOW" then
    if initialized == false then
      self.im.Publish(BND_NATIONALIZATION, self.nationalization)
      initialized = true
    end
    if params and table.getn(params) > 0 then
      self.im.Publish(BND_VISIBLE, true)
      local bottomText = ""
      local showBottomText = false
      if #params == 7 then
        bottomText = params[7]
        showBottomText = true
      end
      local eventInfo = {
        team = params[3],
        kitNumber = params[5],
        playerName = params[6],
        teamName = params[2],
        bottomText = bottomText,
        showBottomText = showBottomText,
        iconType = params[4] + 0
      }
      
      local teamName = ""
      if teamside == 0 then
       teamName = params[2] or "HOME"
      else
        teamName = params[4] or "AWAY"
     end
     
      teamCrest.id = params[2] + 0
      self.im.Publish("bnd_team_crest", teamCrest)
      playerAvatar.id = params[2] + 0
      self.im.Publish("bnd_goal_team_name", teamName)
      self.im.Publish("bnd_goal_player_avatar", playerAvatar)
      
      local eventdesc = ""
      local eventtype = params[4] + 0
      local playerName = params[6]
      local teamSide = 0

      if tostring(params[3]) == tostring(self.TeamsData[1].name) then
        teamSide = 0
      else
        teamSide = 1
      end

      local playerInfo = self:getPlayerInfo(teamSide, params[2] + 0, playerName, false)
            playerAvatar.id = playerInfo.assetId
      self.im.Publish("bnd_goal_player_avatar", playerAvatar)

     if eventtype == 0 then 
            eventdesc = "Injured"
     elseif eventtype == 1 then
            eventdesc = "Yellow Card"
     elseif eventtype == 2 then
            eventdesc = "Red Card"
     elseif eventtype == 3 then
            eventdesc = "Second Yellow"
     end

      self.im.Publish("bnd_goal_type", eventdesc)
      self.im.Publish("bnd_goal_player_name", playerInfo.playerName)
      self.im.Publish("bnd_goal_team_name", teamName)     
      self.im.Publish(BND_DATA, eventInfo)
    end
  elseif hideshow == "UPDATE" then
    self.im.Publish(BND_ALPHA, params[1] / 100)
  else
    self.im.Publish(BND_VISIBLE, false)
  end
end

function EventInfo:addDaysToDate(dateStr, daysToAdd)
    local d, m, y = dateStr:match("(%d%d)/(%d%d)/(%d%d)")
    local timestamp = os.time({ day = tonumber(d), month = tonumber(m), year = 2000 + tonumber(y) })  
    local newTimestamp = timestamp + (daysToAdd * 86400)
    local newDate = os.date("%d/%m/%y", newTimestamp)  
    return newDate
end

function EventInfo:updateGoalScored(subtype, hideshow, subtypestr, msg)

    if hideshow ~= "HIDE" then
        
        if initialized == false then
            self.im.Publish(BND_NATIONALIZATION, self.nationalization)
            initialized = true
        end

        local params = OverlayParam.split(msg, "|")
        if not params or #params == 0 then return end

        self.isinitialized = self.isinitialized + 1

        if self.isinitialized == 1 then
            beforeHomeScore = nowHomeScore
            beforeAwayScore = nowAwayScore
        end

        local goalScored = {
            kitNumber = "",
            bottomText = "",
            showBottomText = false,
            iconType = params[13] + 0,
            playerName = params[14],
            team = params[15]
        }

        nowHomeScore = params[5] + 0
        nowAwayScore = params[6] + 0

        local isOg = string.find(goalScored.playerName, "(OG)")
        local isPenalty = string.find(goalScored.playerName, "(Pen)")
        local currentTime = string.gsub(params[7], "%'", " ")

        local teamside = 0

        if nowHomeScore > beforeHomeScore then
            teamCrest.id = params[1] + 0
            teamside = 0
            if isOg then teamCrest.id = params[3] + 0 end
        elseif nowAwayScore > beforeAwayScore then
            teamCrest.id = params[3] + 0
            teamside = 1
            if isOg then teamCrest.id = params[1] + 0 end
        end

        self.im.Publish("bnd_team_crest", teamCrest)
        self.im.Publish("bnd_goal_desc", "Time : ")

        local playerName = goalScored.playerName
        local playerInfo = self:getPlayerInfo(teamside, teamCrest.id, playerName, isOg)
        playerAvatar.id = playerInfo.assetId

        if not ProcessedGoals then ProcessedGoals = {} end

        local goalKey = tostring(playerInfo.assetId) .. "_" .. tostring(params[7]) .. "_" .. tostring(params[5]) .. "_" .. tostring(params[6])

        if not ProcessedGoals[goalKey] then
            ProcessedGoals[goalKey] = true

            local tourId = GlobalTournamentSettings and GlobalTournamentSettings.tourId 
                           or (currentTourData and currentTourData.tourIndex)

            if tourId then
                if not TournamentStats[tourId] then
                    TournamentStats[tourId] = { Goals = {} }
                end
                if not TournamentStats[tourId].Goals[playerInfo.assetId] then
                    TournamentStats[tourId].Goals[playerInfo.assetId] = 0
                end

                TournamentStats[tourId].Goals[playerInfo.assetId] =
                    TournamentStats[tourId].Goals[playerInfo.assetId] + 1
            end

            if not GOALS then GOALS = {} end
            if not GOALS[playerInfo.assetId] then GOALS[playerInfo.assetId] = 0 end
            GOALS[playerInfo.assetId] = GOALS[playerInfo.assetId] + 1
        end

        if self.isinitialized == 1 then
            if goalStatistics[playerInfo.assetId] then
                goalStatistics[playerInfo.assetId] = goalStatistics[playerInfo.assetId] + 1
            else
                goalStatistics[playerInfo.assetId] = 1
            end
        end

        local goalDesc = "SHOOT"

        local goalType = ""
        if isOg then
            goalType = "GOALS"
        elseif isPenalty then
            goalType = "PENALTY"
        else
            goalType = "GOALS"
        end

        local teamName = (teamside == 0) and (params[2] or "HOME") or (params[4] or "AWAY")

        self.im.Publish("bnd_goal_player_name", string.gsub(playerInfo.playerName, "%b()", " "))
        self.im.Publish("bnd_goal_team_name", teamName)
        self.im.Publish("bnd_goal_player_avatar", playerAvatar)
        self.im.Publish("bnd_goal_player_level", ""..playerInfo.level)

        if currentTime + 0 > 90 then
            self.im.Publish("bnd_goal_player_desc", " ")
        else
            self.im.Publish("bnd_goal_player_desc", goalDesc)
        end

if playerShots == nil then playerShots = {} end

local pid = tostring(playerInfo.assetId)

playerShots[pid] = (playerShots[pid] or 0) + 1

self.im.Publish("bnd_goal_time", tostring(playerShots[pid]))
        self.im.Publish("bnd_goal_type", goalType)
        self.im.Publish("bnd_goal_player_count", ""..(goalStatistics[playerInfo.assetId] or 1))
        self.im.Publish(BND_VISIBLE, true)

        if playerInfo.assetId == 0 then
            self.im.Publish("bnd_player_visible", false)
        else
            self.im.Publish("bnd_player_visible", true)
        end

        self.im.Publish(BND_DATA, goalScored)

    else
        
        self.im.Publish(BND_VISIBLE, false)
        self.im.Publish("bnd_player_visible", false)

        if self.isinitialized >= 2 then
            self.isinitialized = 0
        end
    end
end

function EventInfo:split(str, delimiter)
  local index = {}
  local oid = {}
  for k = 1,string.len(str) do
    if string.sub(str,k,k) == delimiter then
      table.insert(index,k)
    end
  end

  table.insert(oid,string.sub(str,1,index[1]-1))
    for k=1,#index-1 do
      table.insert(oid,string.sub(str,index[k]+1,index[k+1]-1))
    end
  table.insert(oid,string.sub(str,index[#index]+1,string.len(str)))
  return oid
end

function EventInfo:getPlayerInfo(teamSide, teamID, playername, isOg)
  local count = 0
  local specialString = false
  local playerInfo = {
    assetId = 0,
    level = 0,
    playerName = playername
  }
  local teamlineupData = nil
  if isOg then 
    if teamSide == 0 then
       teamSide = 1
    else
       teamSide = 0
    end
  end
  
  if teamSide == 0 then
    teamlineupData = homeTeamlineupData
  else
    teamlineupData = awayTeamlineupData
  end
  if string.find(playername, "-") or string.find(playername, "%.") then
    specialString = true
  end
 
  if specialString == false then
    count = 0
    playerInfo.playerName =  string.gsub(playername, "%b()", " ")
    playerInfo.playerName =  string.gsub(playerInfo.playerName, "^%s*(.-)%s*$", "%1")
  end
  
  for _FORV_6_ = 1, table.getn(teamlineupData) do
    if specialString == true then
       if string.find(playername, teamlineupData[_FORV_6_].playerName,1,true) then 
        if count == 0 then
          count = count + 1
          playerInfo.assetId = teamlineupData[_FORV_6_].CARD_ID
          playerInfo.level = teamlineupData[_FORV_6_].jerseyNumber
          playerInfo.playerName = teamlineupData[_FORV_6_].playerName
        end
      end
    else
    if string.find(playerInfo.playerName, teamlineupData[_FORV_6_].playerName,1,true) and playerInfo.playerName == teamlineupData[_FORV_6_].playerName then
      if count == 0 then
       count = count + 1
       playerInfo.assetId = teamlineupData[_FORV_6_].CARD_ID
       playerInfo.level = teamlineupData[_FORV_6_].jerseyNumber
       playerInfo.playerName = teamlineupData[_FORV_6_].playerName
      end
    end
    end
  end
  return playerInfo
end

function EventInfo:k_include(tab, value)
  for k,v in pairs(tab) do
    if k == value then
        return true
    end
  end
  return false
end

function EventInfo:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function EventInfo:getMatchFacts()
  local facts = self.services.MatchInfoService.GetMatchFacts(true)
  local o = facts.homeData
  for i, v in ipairs(o) do
    v.data.valueRight = facts.awayData[i].data.value
  end
  return o
end

function EventInfo:finalize()
  self.im.Unsubscribe(BND_VISIBLE)
  self.im.Unsubscribe(BND_ALPHA)
  self.im.Unsubscribe(BND_DATA)
  self.im.Unsubscribe(BND_NATIONALIZATION)
  self.im.Unsubscribe("bnd_text")
  self.im.Unsubscribe("bnd_team_crest")
  self.im.Unsubscribe("bnd_goal_player_avatar")
  self.im.Unsubscribe("bnd_goal_player_name")
  self.im.Unsubscribe("bnd_goal_team_name")
  self.im.Unsubscribe("bnd_goal_player_level")
  self.im.Unsubscribe("bnd_goal_player_desc")
  self.im.Unsubscribe("bnd_goal_player_count")
  self.im.Unsubscribe("bnd_player_visible")
  self.im.Unsubscribe("bnd_goal_time")
  self.im.Unsubscribe("bnd_goal_type")
  self.im.Unsubscribe("bnd_goal_desc")
  for k,v in pairs(EAFCInfo) do
    self.im.Unsubscribe(k)
  end
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
  
end

return EventInfo