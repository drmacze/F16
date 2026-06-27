local GameEvents = {}
local OverlaysIdContainer, OverlayParam, eventmanager = ...
local Overlays = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes
local BND_VISIBLE = "bnd_visible"

bndList = {
  "bnd_homename_text",
  "bnd_homecrest",
  "bnd_awayname_text",
  "bnd_awaycrest",
  "bnd_score_text",
  "bnd_homeScore_text",
  "bnd_awayScore_text",
  "bnd_homemessage_text",
  "bnd_awaymessage_text",
  "bnd_title_text"
}

EAFCInfo = {
  bnd_fontFace = "$CruyffSans-Heavy",
  bnd_team_name_visible = false,
  bnd_short_name_visible = true,
  bnd_background_show = true,
  bnd_background_height = 61,
  bnd_background_width = 520,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 25,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -30,
  bnd_event_left = 0,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 17,
  bnd_event_fontColor = "0x000000",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0x000000",
  bnd_homename_height = 50,
  bnd_homename_width = 350,
  bnd_homename_color = "0x181818",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 20,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0x000000",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 350,
  bnd_awayname_color = "0x181818",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 120,
  bnd_score_right = -70,
  bnd_score_left = -70,
  bnd_score_color = "0xFF7600",
  bnd_crest_height = 60,
  bnd_crest_width = 60,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -30,
  bnd_homecrest_left = 195,
  bnd_homecrest_color = "0xFF7600",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 35,
  bnd_homecrest_width = 35,
  bnd_awaycrest_top = -30,
  bnd_awaycrest_right = 195,
  bnd_awaycrest_color = "0xFF7600",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 35,
  bnd_awaycrest_width = 35,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,
  
  bnd_message_height = 10,
  bnd_message_width = 260,
  bnd_homemessage_top = 5,
  bnd_homemessage_left = -130,
  bnd_homemessage_color = "0x00D9D1",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 12,
  bnd_message_fontColor = "0x000000",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = 5,
  bnd_awaymessage_left = 130,
  bnd_awaymessage_color = "0x00D9D1",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 35,
  bnd_logo_width = 35,
  bnd_logo_top = -30,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0xFFFFFF",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "0"
  },
  bnd_logowidth = 35,
  bnd_logoheight = 35,
  
  bnd_title_height = 15,
  bnd_title_width = 100,
  bnd_title_top = 5,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x00D9D1",
  bnd_title_fontColor = "0x000000",
  bnd_title_fontSize = 12,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

DFLInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,

  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 40,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 600,
  bnd_event_top = -60,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 22,
  bnd_event_fontColor = "0x2E2E2E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 50,
  bnd_homename_width = 250,
  bnd_homename_color = "0x2E2E2E",
  bnd_homename_left = 10,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 10,
  bnd_awayname_height = 50,
  bnd_awayname_width = 250,
  bnd_awayname_color = "0x2E2E2E",
  bnd_score_visible = false,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 50,
  bnd_score_width = 80,
  bnd_score_color = "0xFFFFFF",
  bnd_score_right = 0,
  bnd_score_left = 0,
  bnd_crest_color_visible = false,
  bnd_crest_height = 50,
  bnd_crest_width = 50,
  bnd_homecrest_top = -60,
  bnd_homecrest_left = 30,
  bnd_homecrest_color = "0x2E2E2E",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 50,
  bnd_homecrest_width = 50,
  bnd_awaycrest_top = -60,
  bnd_awaycrest_right = 30,
  bnd_awaycrest_color = "0x2E2E2E",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 50,
  bnd_awaycrest_width = 50,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 20,
  bnd_message_width = 250,
  bnd_homemessage_top = -21,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xFFFFFF",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x2E2E2E",
  bnd_awaymessage_right = 235,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = -21,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xFFFFFF",
  bnd_awaymessage_text = "",

  bnd_logo_height = 50,
  bnd_logo_width = 80,
  bnd_logo_top = -5,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 0
  },
  bnd_logowidth = 40,
  bnd_logoheight = 40,
  
  bnd_title_height = 25,
  bnd_title_width = 200,
  bnd_title_top = -100,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x2E2E2E",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

EnglandInfo = {
  bnd_fontFace = "$PremierLeague",
  bnd_forceCaps = false,
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = 0,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = 0,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 75,
  bnd_name_text_top = 0,
  bnd_score_text_top = -1.3,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 20,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_height = 20,
  bnd_homename_width = 300,
  bnd_homename_color = "0xffffff",
  bnd_homename_left = 100,
  bnd_homename_text_left = -30,
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_text_right = -30,
  bnd_awayname_text = "",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 100,
  bnd_awayname_height = 20,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0xffffff",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_right = -50,
  bnd_score_left = -50,
  bnd_score_color = "",
  bnd_crest_color_visible = false,
  bnd_crest_height = 85,
  bnd_crest_width = 85,
  bnd_homecrest_top = -35,
  bnd_homecrest_left = -20,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 100,
  bnd_homecrest_width = 100,
  bnd_awaycrest_top = -35,
  bnd_awaycrest_right = -20,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 100,
  bnd_awaycrest_width = 100,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 30,
  bnd_message_width = 300,
  bnd_homemessage_top = -10,
  bnd_homemessage_left = -150,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x460240",
  bnd_message_text_width = 255,
  bnd_awaymessage_right = 260,
  bnd_awaymessage_top = -10,
  bnd_awaymessage_left = 150,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",

  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -50,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "13_event"
  },
  bnd_logowidth =185,
  bnd_logoheight = 80,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -10,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x460240",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

SpainInfo = {
  bnd_fontFace = "$LaLiga",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 60,
  bnd_background_width = 920,
  bnd_background = {
    name = "$Event",
    id = 53
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 1,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 9945,
  bnd_away_rect_left = 50,
  bnd_away_rect_top = 9945,

  bnd_event_height = 50,
  bnd_event_width = 1024,
  bnd_event_top = -100,
  bnd_event_left = 0,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0x1E1E1E",

  bnd_homename_alignH = "RIGHT",
  bnd_homename_text_fontColor = "0x1E1E1E",
  bnd_homename_height = 50,
  bnd_homename_width = 400,
  bnd_homename_color = "0x061329",
  bnd_homename_left = 50,
  bnd_homename_text_left = 0,
  bnd_homename_text_right = 175,

  bnd_awayname_text_left = 160,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0x1E1E1E",
  bnd_awayname_alignH = "LEFT",
  bnd_awayname_right = 50,
  bnd_awayname_height = 50,
  bnd_awayname_width = 400,
  bnd_awayname_color = "0x061329",
  bnd_name_text_top = 70,

  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 160,
  bnd_score_right = -100,
  bnd_score_left = -100,
  bnd_score_color = "0x1E1E1E",
  bnd_score_fontSize = 50,
  bnd_score_text_top = 70,

  bnd_crest_height = 40,
  bnd_crest_width = 40,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -31,
  bnd_homecrest_left = 163,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$LaLigaTeamCrest",
    id = 0
  },
  bnd_homecrest_height = 38,
  bnd_homecrest_width = 38,

  bnd_awaycrest_top = -31,
  bnd_awaycrest_right = 162,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$LaLigaTeamCrest",
    id = 0
  },
  bnd_awaycrest_height = 38,
  bnd_awaycrest_width = 38,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 30,
  bnd_message_width = 318,
  bnd_homemessage_top = -72,
  bnd_homemessage_left = -294.5,
  bnd_homemessage_color = "0xff594c",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xffffff",

  bnd_awaymessage_right = 296,
  bnd_message_text_width = 290,
  bnd_awaymessage_top = -72,
  bnd_awaymessage_left = 293.5,
  bnd_awaymessage_color = "0xff594c",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 20,
  bnd_logo_width = 50,
  bnd_logo_top = -30,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo",
    id = 53
  },
  bnd_logowidth = 85,
  bnd_logoheight = 20,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -11000,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xc7f20a",
  bnd_title_fontColor = "0x12242b",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

SpainBInfo = {
  bnd_fontFace = "$LaLiga",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 60,
  bnd_background_width = 920,
  bnd_background = {
    name = "$Event",
    id = 54
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 1,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 9945,
  bnd_away_rect_left = 50,
  bnd_away_rect_top = 9945,

  bnd_event_height = 50,
  bnd_event_width = 1024,
  bnd_event_top = -100,
  bnd_event_left = 0,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0x1E1E1E",

  bnd_homename_alignH = "RIGHT",
  bnd_homename_text_fontColor = "0x1E1E1E",
  bnd_homename_height = 50,
  bnd_homename_width = 400,
  bnd_homename_color = "0x061329",
  bnd_homename_left = 50,
  bnd_homename_text_left = 0,
  bnd_homename_text_right = 175,

  bnd_awayname_text_left = 160,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0x1E1E1E",
  bnd_awayname_alignH = "LEFT",
  bnd_awayname_right = 50,
  bnd_awayname_height = 50,
  bnd_awayname_width = 400,
  bnd_awayname_color = "0x061329",
  bnd_name_text_top = 70,

  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 160,
  bnd_score_right = -100,
  bnd_score_left = -100,
  bnd_score_color = "0x1E1E1E",
  bnd_score_fontSize = 50,
  bnd_score_text_top = 70,

  bnd_crest_height = 40,
  bnd_crest_width = 40,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -31,
  bnd_homecrest_left = 163,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 38,
  bnd_homecrest_width = 38,

  bnd_awaycrest_top = -31,
  bnd_awaycrest_right = 162,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 38,
  bnd_awaycrest_width = 38,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 30,
  bnd_message_width = 318,
  bnd_homemessage_top = -72,
  bnd_homemessage_left = -294.5,
  bnd_homemessage_color = "0xff594c",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xffffff",

  bnd_awaymessage_right = 296,
  bnd_message_text_width = 290,
  bnd_awaymessage_top = -72,
  bnd_awaymessage_left = 293.5,
  bnd_awaymessage_color = "0xff594c",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 20,
  bnd_logo_width = 50,
  bnd_logo_top = -30,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo",
    id = 54
  },
  bnd_logowidth = 85,
  bnd_logoheight = 20,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -11000,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xc7f20a",
  bnd_title_fontColor = "0x12242b",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

GermanyInfo = {
  bnd_fontFace = "$Bundesliga",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 40,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 600,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_height = 50,
  bnd_homename_width = 250,
  bnd_homename_color = "0x38003d",
  bnd_homename_left = 0,
  bnd_homename_text_left = 0,
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 250,
  bnd_awayname_color = "0x38003d",
  bnd_score_visible = false,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 60,
  bnd_score_width = 100,
  bnd_score_right = 0,
  bnd_score_left = 0,
  bnd_score_color = "0x2e2b2e",
  bnd_crest_color_visible = true,
  bnd_crest_height = 75,
  bnd_crest_width = 75,
  bnd_homecrest_top = -62.5,
  bnd_homecrest_left = 0,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 60,
  bnd_homecrest_width = 60,
  bnd_awaycrest_top = -62.5,
  bnd_awaycrest_right = 0,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 60,
  bnd_awaycrest_width = 60,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 25,
  bnd_message_width = 275,
  bnd_homemessage_top = -87.5,
  bnd_homemessage_left = -137.5,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x38003d",
  bnd_message_text_width = 255,
  bnd_awaymessage_right = 260,
  bnd_awaymessage_top = -87.5,
  bnd_awaymessage_left = 137.5,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",

  bnd_logo_height = 50,
  bnd_logo_width = 80,
  bnd_logo_top = -10500,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "13_white"
  },
  bnd_logowidth = 34,
  bnd_logoheight = 40,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -10,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0x2e2b2e",
  bnd_title_fontSize = 20,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

Germany2Info = {
  bnd_fontFace = "$Bundesliga",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 40,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 600,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_height = 50,
  bnd_homename_width = 250,
  bnd_homename_color = "0x38003d",
  bnd_homename_left = 0,
  bnd_homename_text_left = 0,
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 250,
  bnd_awayname_color = "0x38003d",
  bnd_score_visible = false,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 60,
  bnd_score_width = 100,
  bnd_score_right = 0,
  bnd_score_left = 0,
  bnd_score_color = "0x2e2b2e",
  bnd_crest_color_visible = true,
  bnd_crest_height = 75,
  bnd_crest_width = 75,
  bnd_homecrest_top = -62.5,
  bnd_homecrest_left = 0,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 60,
  bnd_homecrest_width = 60,
  bnd_awaycrest_top = -62.5,
  bnd_awaycrest_right = 0,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 60,
  bnd_awaycrest_width = 60,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 25,
  bnd_message_width = 275,
  bnd_homemessage_top = -87.5,
  bnd_homemessage_left = -137.5,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x38003d",
  bnd_message_text_width = 255,
  bnd_awaymessage_right = 260,
  bnd_awaymessage_top = -87.5,
  bnd_awaymessage_left = 137.5,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",

  bnd_logo_height = 50,
  bnd_logo_width = 80,
  bnd_logo_top = -10500,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "13_white"
  },
  bnd_logowidth = 34,
  bnd_logoheight = 40,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -10,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0x2e2b2e",
  bnd_title_fontSize = 20,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

FranceInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0x000000",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0x007EFF",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0x000000",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x007EFF",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 200,
  bnd_score_right = -60,
  bnd_score_left = -60,
  bnd_score_color = "0x4B4B4B",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -95,
  bnd_homecrest_color = "0x007EFF",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -95,
  bnd_awaycrest_color = "0x007EFF",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 50,
  bnd_message_width = 350,
  bnd_homemessage_top = -100,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xFFFFFF",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x000000",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -100,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xFFFFFF",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 50,
  bnd_logo_width = 50,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x4B4B4B",
  bnd_logo = {
    name = "$LeagueLogo",
    id = 16
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -110,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x4B4B4B",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

ItalyInfo = {
  bnd_fontFace = "$SerieA",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0x1F3271",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0x1F3271",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x1F3271",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 200,
  bnd_score_right = -60,
  bnd_score_left = -60,
  bnd_score_color = "0xffffff",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -75,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -75,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,
  
  bnd_message_height = 35,
  bnd_message_width = 350,
  bnd_homemessage_top = -92,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x1F3271",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -92,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 95,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0xffffff",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "31_5",
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 35,
  bnd_title_width = 100,
  bnd_title_top = -92,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0x1F3271",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

BrazilInfo = {
  bnd_fontFace = "$Brasil-Sportv",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 150,
  bnd_background_width = 780,
  bnd_background = {
    name = "$Event",
    id = 7
  },
  bnd_background_bottom = 10,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 30,
  bnd_name_text_top = -32,
  bnd_score_text_top = -32,

  bnd_event_height = 0,
  bnd_event_width = 800,
  bnd_event_top = -53,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0x000000",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0x000000",
  bnd_homename_height = 0,
  bnd_homename_width = 300,
  bnd_homename_color = "0xffffff",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0x000000",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 0,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0xffffff",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 200,
  bnd_score_right = -26,
  bnd_score_left = -27,
  bnd_score_color = "0x000000",
  bnd_crest_height = 65,
  bnd_crest_width = 65,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -88,
  bnd_homecrest_left = -30,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 50,
  bnd_homecrest_width = 50,
  bnd_awaycrest_top = -88,
  bnd_awaycrest_right = -30,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 50,
  bnd_awaycrest_width = 50,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 30,
  bnd_message_width = 270,
  bnd_homemessage_top = -137,
  bnd_homemessage_left = -220,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_color_alpha = 0.5,
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x000000",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -137,
  bnd_awaymessage_left = 220,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_color_alpha = 0.5,
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x044C7C",
  bnd_logo = {
    name = "$",
    id = 0
  },
  bnd_logowidth = 45,
  bnd_logoheight = 60,
  
  bnd_title_height = 1,
  bnd_title_width = 1,
  bnd_title_top = -142,
  bnd_title_left = 2,
  bnd_title_text = "",
  bnd_title_color = "0x000000",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

BrazilGloboInfo = {
  bnd_fontFace = "$Brasil-Globo",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event1",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = 0,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = 0,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 50,
  bnd_name_text_top = 0,
  bnd_score_text_top = 2,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 20,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_height = 20,
  bnd_homename_width = 300,
  bnd_homename_color = "0xffffff",
  bnd_homename_left = 97,
  bnd_homename_text_left = -30,
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_text_right = -30,
  bnd_awayname_text = "",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 97,
  bnd_awayname_height = 20,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0xffffff",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_right = -40,
  bnd_score_left = -40,
  bnd_score_color = "",
  bnd_crest_color_visible = true,
  bnd_crest_height = 50,
  bnd_crest_width = 50,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = 0,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 50,
  bnd_homecrest_width = 50,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = 0,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 50,
  bnd_awaycrest_width = 50,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 30,
  bnd_message_width = 302,
  bnd_homemessage_top = -7,
  bnd_homemessage_left = -153,
  bnd_homemessage_color = "0x000000",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xFFFFFF",
  bnd_message_text_width = 255,
  bnd_awaymessage_right = 260,
  bnd_awaymessage_top = -7,
  bnd_awaymessage_left = 153,
  bnd_awaymessage_color = "0x000000",
  bnd_awaymessage_text = "",

  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -50,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_color_visible = false,
  bnd_logo_color = "",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_1_event"
  },
  bnd_logowidth = 530,
  bnd_logoheight = 50,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -95,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x000000",
  bnd_title_fontColor = "0xBCFF79",
  bnd_title_fontSize = 14,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

BrazilAmazonInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 1000,
  bnd_background_width = 2117,
  bnd_background = {
    name = "$Event",
    id = "7_2"
  },
  bnd_background_bottom = -253,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 30,
  bnd_name_text_top = -24,
  bnd_score_text_top = -24,

  bnd_event_height = 0,
  bnd_event_width = 800,
  bnd_event_top = -53,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 300,
  bnd_homename_color = "0xffffff",
  bnd_homename_left = 0,
  bnd_homename_text_left = 55,
  bnd_awayname_text_right = 55,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 0,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0xffffff",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 200,
  bnd_score_right = -45,
  bnd_score_left = -48,
  bnd_score_color = "0xffffff",
  bnd_crest_height = 35,
  bnd_crest_width = 35,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -76,
  bnd_homecrest_left = 2,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 60,
  bnd_homecrest_width = 60,
  bnd_awaycrest_top = -76,
  bnd_awaycrest_right = 2,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 60,
  bnd_awaycrest_width = 60,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -37,
  bnd_homemessage_left = -290,
  bnd_homemessage_color = "",
  bnd_homemessage_color_alpha = 0.5,
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xFFFFFF",
  bnd_awaymessage_right = 220,
  bnd_message_text_width = 210,
  bnd_awaymessage_top = -37,
  bnd_awaymessage_left = 290,
  bnd_awaymessage_color = "",
  bnd_awaymessage_color_alpha = 0.5,
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x044C7C",
  bnd_logo = {
    name = "$",
    id = 0
  },
  bnd_logowidth = 45,
  bnd_logoheight = 60,
  
  bnd_title_height = 1,
  bnd_title_width = 1,
  bnd_title_top = -33,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

MexicoInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0x1D3D66",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 350,
  bnd_homename_color = "0x1D3D66",
  bnd_homename_left = 60,
  bnd_homename_text_left = 30,
  bnd_awayname_text_right = 32,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 60,
  bnd_awayname_height = 50,
  bnd_awayname_width = 350,
  bnd_awayname_color = "0x1D3D66",
  bnd_score_text = "-",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 100,
  bnd_score_right = -20,
  bnd_score_left = -20,
  bnd_score_color = "0xFFFFFF",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -45,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -45,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,
  
  bnd_message_height = 35,
  bnd_message_width = 300,
  bnd_homemessage_top = -92,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x1D3D66",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = -92,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 95,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0xFFFFFF",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 341
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 35,
  bnd_title_width = 100,
  bnd_title_top = -92,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x1D3D66",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

ArgentinaInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0x39DFE3",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 350,
  bnd_homename_color = "0x1F3139",
  bnd_homename_left = 60,
  bnd_homename_text_left = 30,
  bnd_awayname_text_right = 32,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 60,
  bnd_awayname_height = 50,
  bnd_awayname_width = 350,
  bnd_awayname_color = "0x1F3139",
  bnd_score_text = "-",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 50,
  bnd_score_right = -20,
  bnd_score_left = -20,
  bnd_score_color = "0x1F3139",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -45,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -45,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,
  
  bnd_message_height = 35,
  bnd_message_width = 300,
  bnd_homemessage_top = -92,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x000000",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = -92,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 95,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x1F3139",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 353
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 35,
  bnd_title_width = 100,
  bnd_title_top = -92,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x1F3139",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

IndonesiaInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 2235
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 30,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0x001E6C",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0x001E6C",
  bnd_homename_left = 20,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 20,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x001E6C",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 180,
  bnd_score_right = -60,
  bnd_score_left = -65,
  bnd_score_color = "0xffffff",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -75,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -75,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 30,
  bnd_message_width = 350,
  bnd_homemessage_top = -10,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x001E6C",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -10,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 50,
  bnd_logo_width = 70,
  bnd_logo_top = -50,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = true,
  bnd_logo_color = "0x001E6C",
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2235
  },
  bnd_logowidth = 50,
  bnd_logoheight = 50,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -10,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0x001E6C",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

SaudiArabiaInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,

  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 40,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = -60,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0x000000",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 60,
  bnd_homename_width = 260,
  bnd_homename_color = "0x0B3861",
  bnd_homename_left = 0,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 60,
  bnd_awayname_width = 260,
  bnd_awayname_color = "0x0B3861",
  bnd_score_visible = false,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 60,
  bnd_score_width = 80,
  bnd_score_color = "0xffffff",
  bnd_score_right = 0,
  bnd_score_left = 0,
  bnd_crest_color_visible = true,
  bnd_crest_height = 60,
  bnd_crest_width = 60,
  bnd_homecrest_top = -60,
  bnd_homecrest_left = 0,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 56,
  bnd_homecrest_width = 56,
  bnd_awaycrest_top = -60,
  bnd_awaycrest_right = 0,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 56,
  bnd_awaycrest_width = 56,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 50,
  bnd_message_width = 250,
  bnd_homemessage_top = -5,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x000000",
  bnd_awaymessage_right = 235,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = -5,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",

  bnd_logo_height = 50,
  bnd_logo_width = 80,
  bnd_logo_top = -5,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = true,
  bnd_logo_color = "0xffffff",
  bnd_logo = {
    name = "$LeagueLogo",
    id = 350
  },
  bnd_logowidth = 45,
  bnd_logoheight = 45,
  
  bnd_title_height = 30,
  bnd_title_width = 80,
  bnd_title_top = -105,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0x000000",
  bnd_title_fontSize = 10,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

RussiaInfo = {
  bnd_fontFace = "$Russian",
  bnd_background_show = true,
  bnd_background_height = 93,
  bnd_background_width = 850,
  bnd_background = {
    name = "$Event",
    id = 67
  },
  bnd_background_bottom = 25,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 30,
  bnd_name_text_top = -27,
  bnd_score_text_top = -27,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 1,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 20,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "0x061329",
  bnd_homename_left = 120,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 120,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "0x061329",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_right = -63,
  bnd_score_left = -73,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -73,
  bnd_homecrest_left = -95,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -73,
  bnd_awaycrest_right = -95,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 25,
  bnd_message_width = 350,
  bnd_homemessage_top = -10,
  bnd_homemessage_left = -200,
  bnd_homemessage_color = "0x000C50",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 350,
  bnd_message_text_width = 350,
  bnd_awaymessage_top = -10,
  bnd_awaymessage_left = 200,
  bnd_awaymessage_color = "0x000C50",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 67
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 25,
  bnd_title_width = 100,
  bnd_title_top = -10,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xC4C8CC",
  bnd_title_fontColor = "0x1E1E1E",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

LeaguePariInfo = {
  bnd_fontFace = "$KnulExtraBold",
  bnd_background_show = true,
  bnd_background_height = 75,
  bnd_background_width = 827,
  bnd_background = {
    name = "$Event",
    id = 2245
  },
  bnd_background_bottom = 32,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 30,
  bnd_name_text_top = -27,
  bnd_score_text_top = -27,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 1,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 20,
  bnd_event_fontColor = "0xFFFFFF",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "0x061329",
  bnd_homename_left = 110,
  bnd_homename_text_left = 35,
  bnd_awayname_text_right = 35,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 110,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "0x061329",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_right = -63,
  bnd_score_left = -73,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 58,
  bnd_crest_width = 58,
  bnd_crest_color_visible = true,
  bnd_homecrest_top = -78,
  bnd_homecrest_left = -63,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = -78,
  bnd_awaycrest_right = -63,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 8,
  bnd_message_width = 350,
  bnd_homemessage_top = -39,
  bnd_homemessage_left = -230,
  bnd_homemessage_color = "0x000000",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 350,
  bnd_message_text_width = 350,
  bnd_awaymessage_top = -39,
  bnd_awaymessage_left = 230,
  bnd_awaymessage_color = "0x000000",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2245
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 8,
  bnd_title_width = 100,
  bnd_title_top = -40,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x000000",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 13,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

UkraineInfo = {
  bnd_fontFace = "$DINPro-Bold",
  bnd_background_show = true,
  bnd_background_height = 50,
  bnd_background_width = 277,
  bnd_background = {
    name = "$Event",
    id = 332
  },
  bnd_background_bottom = 25,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 28,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 20,
  bnd_event_fontColor = "0x0039AB",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 51,
  bnd_homename_width = 250,
  bnd_homename_color = "0x0039AB",
  bnd_homename_left = 13,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 13,
  bnd_awayname_height = 51,
  bnd_awayname_width = 250,
  bnd_awayname_color = "0x0039AB",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 0,
  bnd_score_right = -53,
  bnd_score_left = -53,
  bnd_score_color = "",
  bnd_crest_height = 50,
  bnd_crest_width = 50,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = 220,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = 220,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,
  
  bnd_message_height = 20,
  bnd_message_width = 390,
  bnd_homemessage_top = -11.5,
  bnd_homemessage_left = -192,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x000000",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = -11.5,
  bnd_awaymessage_left = 192,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 50,
  bnd_logo_width = 100,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0xFFFFFF",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 332
  },
  bnd_logowidth = 110,
  bnd_logoheight = 110,
  
  bnd_title_height = 20,
  bnd_title_width = 774,
  bnd_title_top = -88,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x0039AB",
  bnd_title_fontColor = "0xF5FF00",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

InternationalInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 78
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,

  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 40,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = -60,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0xD3AA32",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xD3AA32",
  bnd_homename_height = 60,
  bnd_homename_width = 260,
  bnd_homename_color = "0xffffff",
  bnd_homename_left = 0,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xD3AA32",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 60,
  bnd_awayname_width = 260,
  bnd_awayname_color = "0xffffff",
  bnd_score_visible = false,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 60,
  bnd_score_width = 80,
  bnd_score_color = "0xF2F2F2",
  bnd_score_right = 0,
  bnd_score_left = 0,
  bnd_crest_color_visible = true,
  bnd_crest_height = 60,
  bnd_crest_width = 60,
  bnd_homecrest_top = -60,
  bnd_homecrest_left = 0,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 56,
  bnd_homecrest_width = 56,
  bnd_awaycrest_top = -60,
  bnd_awaycrest_right = 0,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 56,
  bnd_awaycrest_width = 56,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 50,
  bnd_message_width = 250,
  bnd_homemessage_top = -5,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xF2F2F2",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xD3AA32",
  bnd_awaymessage_right = 235,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = -5,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xF2F2F2",
  bnd_awaymessage_text = "",

  bnd_logo_height = 50,
  bnd_logo_width = 80,
  bnd_logo_top = -5,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = true,
  bnd_logo_color = "0xD3AA32",
  bnd_logo = {
    name = "$LeagueLogo",
    id = 78
  },
  bnd_logowidth = 45,
  bnd_logoheight = 45,
  
  bnd_title_height = 30,
  bnd_title_width = 80,
  bnd_title_top = -105,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0xD3AA32",
  bnd_title_fontSize = 10,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

--------- Tournaments ---------

UCLInfo = {
  bnd_fontFace = "$UCL-Regular",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 50,
  bnd_background_width = 800,
  bnd_background = {
    name = "$Event",
    id = 2236
  },
  bnd_background_bottom = 25,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 3,
  bnd_score_text_top = 3,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 1,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0x061329",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x061329",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 200,
  bnd_score_right = -19,
  bnd_score_left = -18,
  bnd_score_color = "0xffffff",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -47,
  bnd_homecrest_left = -95,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -47,
  bnd_awaycrest_right = -95,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 35,
  bnd_message_width = 400,
  bnd_homemessage_top = -93,
  bnd_homemessage_left = -200,
  bnd_homemessage_color = "0x041750",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 350,
  bnd_message_text_width = 350,
  bnd_awaymessage_top = -93,
  bnd_awaymessage_left = 200,
  bnd_awaymessage_color = "0x041750",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "16_2"
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -93,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x153454",
  bnd_title_fontColor = "0x57e8e0",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

UELInfo = {
  bnd_fontFace = "$UEL-Bold",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 94,
  bnd_background_width = 780,
  bnd_background = {
    name = "$Event",
    id = 2238
  },
  bnd_background_bottom = 10,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 33,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 0,
  bnd_event_width = 800,
  bnd_event_top = -53,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0x000000",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 300,
  bnd_homename_color = "0x044C7C",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 0,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x044C7C",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 200,
  bnd_score_right = -30,
  bnd_score_left = -30,
  bnd_score_color = "0x000000",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -95,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -95,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 30,
  bnd_message_width = 350,
  bnd_homemessage_top = -88,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0x000000",
  bnd_homemessage_color_alpha = 0.5,
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -88,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0x000000",
  bnd_awaymessage_color_alpha = 0.5,
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x044C7C",
  bnd_logo = {
    name = "$",
    id = 0
  },
  bnd_logowidth = 45,
  bnd_logoheight = 60,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -88,
  bnd_title_left = 2,
  bnd_title_text = "",
  bnd_title_color = "0xFC6C04",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

EuroCopaInfo = {
  bnd_fontFace = "$UEFAEuro-Bold",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0x001852",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 350,
  bnd_homename_color = "0x1544F6",
  bnd_homename_left = -50,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = -50,
  bnd_awayname_height = 50,
  bnd_awayname_width = 350,
  bnd_awayname_color = "0x1544F6",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 200,
  bnd_score_right = -60,
  bnd_score_left = -60,
  bnd_score_color = "0xffffff",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -95,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -95,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 50,
  bnd_message_width = 350,
  bnd_homemessage_top = -100,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0x001852",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -100,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0x001852",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 95,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0xffffff",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "2299_1",
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -110,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x001852",
  bnd_title_fontColor = "0xFDDA42",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

NationsLeagueInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xDBE2E3",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0x4F6B7F",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0xDBE2E3",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0x4F6B7F",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0xDBE2E3",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 200,
  bnd_score_right = -60,
  bnd_score_left = -60,
  bnd_score_color = "0x4F6B7F",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -95,
  bnd_homecrest_color = "0xDBE2E3",
  bnd_homecrest = {
    name = "$NationalCrest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -95,
  bnd_awaycrest_color = "0xDBE2E3",
  bnd_awaycrest = {
    name = "$NationalCrest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 50,
  bnd_message_width = 350,
  bnd_homemessage_top = -100,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xFFFFFF",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x4F6B7F",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -100,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xFFFFFF",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 50,
  bnd_logo_width = 50,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x4F6B7F",
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2241
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -110,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xDBE2E3",
  bnd_title_fontColor = "0x4F6B7F",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

UefaWomensInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 94,
  bnd_background_width = 780,
  bnd_background = {
    name = "$Event",
    id = 2240
  },
  bnd_background_bottom = 10,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 33,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 0,
  bnd_event_width = 800,
  bnd_event_top = -53,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 300,
  bnd_homename_color = "0xffffff",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 0,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0xffffff",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 200,
  bnd_score_right = -30,
  bnd_score_left = -30,
  bnd_score_color = "0xffffff",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -95,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -95,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,
  bnd_message_height = 28,
  bnd_message_width = 300,
  bnd_homemessage_top = -87,
  bnd_homemessage_left = -200,
  bnd_homemessage_color = "0x012652",
  bnd_homemessage_color_alpha = 0.5,
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -87,
  bnd_awaymessage_left = 200,
  bnd_awaymessage_color = "0x012652",
  bnd_awaymessage_color_alpha = 0.5,
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x044C7C",
  bnd_logo = {
    name = "$",
    id = 0
  },
  bnd_logowidth = 45,
  bnd_logoheight = 60,
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = -88,
  bnd_title_left = 2,
  bnd_title_text = "",
  bnd_title_color = "",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

UCLClassicInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 45,
  bnd_background_width = 800,
  bnd_background = {
    name = "$Event",
    id = 22366
  },
  bnd_background_bottom = 27,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 1,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -48,
  bnd_event_left = 0,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0x0B3861",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0x061329",
  bnd_homename_left = 0,
  bnd_homename_text_left = 40,
  bnd_awayname_text_right = 40,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0x0B3861",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x061329",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 200,
  bnd_score_right = -20,
  bnd_score_left = -20,
  bnd_score_color = "0x083C65",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -48,
  bnd_homecrest_left = -55,
  bnd_homecrest_color = "0xF6F6F6",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 60,
  bnd_homecrest_width = 60,
  bnd_awaycrest_top = -48,
  bnd_awaycrest_right = -55,
  bnd_awaycrest_color = "0xF6F6F6",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 60,
  bnd_awaycrest_width = 60,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 40,
  bnd_message_width = 400,
  bnd_homemessage_top = -5,
  bnd_homemessage_left = -200,
  bnd_homemessage_color = "0xE5E5E5",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x0B3861",
  bnd_awaymessage_right = 350,
  bnd_message_text_width = 350,
  bnd_awaymessage_top = -5,
  bnd_awaymessage_left = 200,
  bnd_awaymessage_color = "0xE5E5E5",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2236
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -5,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xE5E5E5",
  bnd_title_fontColor = "0x0B3861",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

LibertadoresInfo = {
  bnd_fontFace = "$Libertadores",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 150,
  bnd_background_width = 800,
  bnd_background = {
    name = "$Event",
    id = 2237
  },
  bnd_background_bottom = -25,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 25,
  bnd_name_text_top = -25,
  bnd_score_text_top = -25,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 1,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 300,
  bnd_homename_color = "",
  bnd_homename_left = 0,
  bnd_homename_text_left = 30,
  bnd_awayname_text_right = 30,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 0,
  bnd_awayname_width = 300,
  bnd_awayname_color = "",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_right = -20,
  bnd_score_left = -22.5,
  bnd_score_color = "",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -65,
  bnd_homecrest_left = -55,
  bnd_homecrest_color = "",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 60,
  bnd_homecrest_width = 60,
  bnd_awaycrest_top = -65,
  bnd_awaycrest_right = -55,
  bnd_awaycrest_color = "",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 60,
  bnd_awaycrest_width = 60,
  
  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 0,
  bnd_message_width = 300,
  bnd_homemessage_top = -35,
  bnd_homemessage_left = -170,
  bnd_homemessage_color = "",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 15,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 265,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -35,
  bnd_awaymessage_left = 170,
  bnd_awaymessage_color = "",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 0
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -113,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "",
  bnd_title_fontColor = "0x000000",
  bnd_title_fontSize = 20,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

SudamericanaInfo = {
  bnd_fontFace = "$Libertadores",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 150,
  bnd_background_width = 800,
  bnd_background = {
    name = "$Event",
    id = 2267
  },
  bnd_background_bottom = -25,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 25,
  bnd_name_text_top = -25,
  bnd_score_text_top = -25,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 1,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 300,
  bnd_homename_color = "",
  bnd_homename_left = 0,
  bnd_homename_text_left = 30,
  bnd_awayname_text_right = 30,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 0,
  bnd_awayname_width = 300,
  bnd_awayname_color = "",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_right = -20,
  bnd_score_left = -22.5,
  bnd_score_color = "",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -65,
  bnd_homecrest_left = -55,
  bnd_homecrest_color = "",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 60,
  bnd_homecrest_width = 60,
  bnd_awaycrest_top = -65,
  bnd_awaycrest_right = -55,
  bnd_awaycrest_color = "",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 60,
  bnd_awaycrest_width = 60,
  
  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 0,
  bnd_message_width = 300,
  bnd_homemessage_top = -35,
  bnd_homemessage_left = -170,
  bnd_homemessage_color = "",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 15,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 265,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -35,
  bnd_awaymessage_left = 170,
  bnd_awaymessage_color = "",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 0
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -113,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "",
  bnd_title_fontColor = "0x000000",
  bnd_title_fontSize = 20,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

CopaAmericaInfo = {
  bnd_fontFace = "$CopaAmerica",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 45,
  bnd_background_width = 800,
  bnd_background = {
    name = "$Event",
    id = 2298
  },
  bnd_background_bottom = 27,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 1,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -48,
  bnd_event_left = 0,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0x083C65",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0x061329",
  bnd_homename_left = 0,
  bnd_homename_text_left = 40,
  bnd_awayname_text_right = 40,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x061329",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 200,
  bnd_score_right = -20,
  bnd_score_left = -20,
  bnd_score_color = "0x083C65",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -48,
  bnd_homecrest_left = -55,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 60,
  bnd_homecrest_width = 60,
  bnd_awaycrest_top = -48,
  bnd_awaycrest_right = -55,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 60,
  bnd_awaycrest_width = 60,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 40,
  bnd_message_width = 400,
  bnd_homemessage_top = -5,
  bnd_homemessage_left = -200,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x083C65",
  bnd_awaymessage_right = 350,
  bnd_message_text_width = 350,
  bnd_awaymessage_top = -5,
  bnd_awaymessage_left = 200,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x38003d",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = "00"
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -5,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0x083C65",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

WorldCupInfo = {
  bnd_fontFace = "$Anybody-Bold",
  bnd_forceCaps = true,
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 150,
  bnd_background_width = 975,
  bnd_background = {
    name = "$Event",
    id = 365
  },
  bnd_background_bottom = -45,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 25,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 300,
  bnd_homename_color = "",
  bnd_homename_left = 0,
  bnd_homename_text_left = 30,
  bnd_awayname_text_right = 30,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 0,
  bnd_awayname_width = 300,
  bnd_awayname_color = "",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_right = -30,
  bnd_score_left = -30,
  bnd_score_color = "",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -82,
  bnd_homecrest_color = "",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 60,
  bnd_homecrest_width = 60,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -82,
  bnd_awaycrest_color = "",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 60,
  bnd_awaycrest_width = 60,
  
  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 0,
  bnd_message_width = 300,
  bnd_homemessage_top = -3,
  bnd_homemessage_left = -170,
  bnd_homemessage_color = "",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 15,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 265,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -3,
  bnd_awaymessage_left = 170,
  bnd_awaymessage_color = "",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 0
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -94,
  bnd_title_left = -2,
  bnd_title_text = "",
  bnd_title_color = "",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

ClubWorldCupInfo = {
  bnd_fontFace = "$DINPro-Bold",
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = true,
  bnd_background_height = 100,
  bnd_background_width = 750,
  bnd_background = {
    name = "$Event",
    id = 2209
  },
  bnd_background_bottom = 25,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 30,
  bnd_name_text_top = -25,
  bnd_score_text_top = -25,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 1,
  bnd_event_alpha = 0,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0x000000",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 0,
  bnd_homename_width = 300,
  bnd_homename_color = "",
  bnd_homename_left = 0,
  bnd_homename_text_left = 30,
  bnd_awayname_text_right = 30,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 0,
  bnd_awayname_width = 300,
  bnd_awayname_color = "",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_right = -20,
  bnd_score_left = -22.5,
  bnd_score_color = "",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -75,
  bnd_homecrest_left = -55,
  bnd_homecrest_color = "",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = -75,
  bnd_awaycrest_right = -55,
  bnd_awaycrest_color = "",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,
  
  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 0,
  bnd_message_width = 300,
  bnd_homemessage_top = -112,
  bnd_homemessage_left = -170,
  bnd_homemessage_color = "",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 15,
  bnd_message_fontColor = "0xffffff",
  bnd_awaymessage_right = 265,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -112,
  bnd_awaymessage_left = 170,
  bnd_awaymessage_color = "",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = -490000,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 0
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -112,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "",
  bnd_title_fontColor = "0x000000",
  bnd_title_fontSize = 17,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

FACupInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,

  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 40,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 40,
  bnd_event_width = 700,
  bnd_event_top = -60,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 19,
  bnd_event_fontColor = "0xFFFFFF",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0x000000",
  bnd_homename_height = 50,
  bnd_homename_width = 320,
  bnd_homename_color = "0xFFFFFF",
  bnd_homename_left = 0,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0x000000",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 320,
  bnd_awayname_color = "0xFFFFFF",
  bnd_score_visible = false,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 40,
  bnd_score_width = 80,
  bnd_score_color = "0xA8222A",
  bnd_score_right = 0,
  bnd_score_left = 0,
  bnd_crest_color_visible = false,
  bnd_crest_height = 40,
  bnd_crest_width = 20,
  bnd_homecrest_top = -60,
  bnd_homecrest_left = 0,
  bnd_homecrest_color = "0xFFFFFF",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 56,
  bnd_homecrest_width = 56,
  bnd_awaycrest_top = -60,
  bnd_awaycrest_right = 0,
  bnd_awaycrest_color = "0xFFFFFF",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 56,
  bnd_awaycrest_width = 56,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 30,
  bnd_message_width = 325,
  bnd_homemessage_top = -25,
  bnd_homemessage_left = -160,
  bnd_homemessage_color = "0xA8222A",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xFFFFFF",
  bnd_awaymessage_right = 300,
  bnd_message_text_width = 285,
  bnd_awaymessage_top = -25,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xA8222A",
  bnd_awaymessage_text = "",

  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "13_Cup"
  },
  bnd_logowidth = 90,
  bnd_logoheight = 90,
  
  bnd_title_height = 30,
  bnd_title_width = 250,
  bnd_title_top = -95,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xA8222A",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 17,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

CoppaItaliaInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xBE0003",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0xBE0003",
  bnd_homename_left = 0,
  bnd_homename_text_left = 20,
  bnd_awayname_text_right = 22,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0xBE0003",
  bnd_score_text = "",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 200,
  bnd_score_right = -60,
  bnd_score_left = -60,
  bnd_score_color = "0xffffff",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -75,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -75,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 35,
  bnd_message_width = 350,
  bnd_homemessage_top = -92,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0xBE0003",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -92,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 70,
  bnd_logo_width = 95,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0xffffff",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "2231_1",
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 35,
  bnd_title_width = 100,
  bnd_title_top = -92,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0xBE0003",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

SaudiSuperCupInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event1",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,

  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 40,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = -60,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0xBF9A33",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xBF9A33",
  bnd_homename_height = 60,
  bnd_homename_width = 260,
  bnd_homename_color = "0x2F0B3A",
  bnd_homename_left = 0,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xBF9A33",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 60,
  bnd_awayname_width = 260,
  bnd_awayname_color = "0x2F0B3A",
  bnd_score_visible = false,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 60,
  bnd_score_width = 80,
  bnd_score_color = "0xffffff",
  bnd_score_right = 0,
  bnd_score_left = 0,
  bnd_crest_color_visible = true,
  bnd_crest_height = 60,
  bnd_crest_width = 60,
  bnd_homecrest_top = -60,
  bnd_homecrest_left = 0,
  bnd_homecrest_color = "0x2F0B3A",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 56,
  bnd_homecrest_width = 56,
  bnd_awaycrest_top = -60,
  bnd_awaycrest_right = 0,
  bnd_awaycrest_color = "0x2F0B3A",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 56,
  bnd_awaycrest_width = 56,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 50,
  bnd_message_width = 250,
  bnd_homemessage_top = -5,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x2F0B3A",
  bnd_awaymessage_right = 235,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = -5,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",

  bnd_logo_height = 50,
  bnd_logo_width = 80,
  bnd_logo_top = -5,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = true,
  bnd_logo_color = "0xffffff",
  bnd_logo = {
    name = "$LeagueLogo",
    id = 3350
  },
  bnd_logowidth = 45,
  bnd_logoheight = 45,
  
  bnd_title_height = 30,
  bnd_title_width = 80,
  bnd_title_top = -105,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x2F0B3A",
  bnd_title_fontColor = "0xBF9A33",
  bnd_title_fontSize = 10,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

KingCupInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 0
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,

  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 40,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = -60,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 25,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 60,
  bnd_homename_width = 260,
  bnd_homename_color = "0x1E692D",
  bnd_homename_left = 0,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 0,
  bnd_awayname_height = 60,
  bnd_awayname_width = 260,
  bnd_awayname_color = "0x1E692D",
  bnd_score_visible = false,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_text = "",
  bnd_score_height = 60,
  bnd_score_width = 80,
  bnd_score_color = "0x40453B",
  bnd_score_right = 0,
  bnd_score_left = 0,
  bnd_crest_color_visible = true,
  bnd_crest_height = 60,
  bnd_crest_width = 60,
  bnd_homecrest_top = -60,
  bnd_homecrest_left = 0,
  bnd_homecrest_color = "0x40453B",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 56,
  bnd_homecrest_width = 56,
  bnd_awaycrest_top = -60,
  bnd_awaycrest_right = 0,
  bnd_awaycrest_color = "0x40453B",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 56,
  bnd_awaycrest_width = 56,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,

  bnd_message_height = 50,
  bnd_message_width = 250,
  bnd_homemessage_top = -5,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xffffff",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x1E692D",
  bnd_awaymessage_right = 235,
  bnd_message_text_width = 230,
  bnd_awaymessage_top = -5,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xffffff",
  bnd_awaymessage_text = "",

  bnd_logo_height = 50,
  bnd_logo_width = 80,
  bnd_logo_top = -5,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = true,
  bnd_logo_color = "0xF2F2F2",
  bnd_logo = {
    name = "$LeagueLogo",
    id = "350_5"
  },
  bnd_logowidth = 45,
  bnd_logoheight = 45,
  
  bnd_title_height = 30,
  bnd_title_width = 80,
  bnd_title_top = -105,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0x1E692D",
  bnd_title_fontSize = 10,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

PaulistaoInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 2229
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0x00019D",
  bnd_homename_left = 50,
  bnd_homename_text_left = 30,
  bnd_awayname_text_right = 30,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 50,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x00019D",
  bnd_score_text = "-",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 100,
  bnd_score_right = -25,
  bnd_score_left = -25,
  bnd_score_color = "0xFF4100",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -50,
  bnd_homecrest_color = "0x00019D",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -50,
  bnd_awaycrest_color = "0x00019D",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 50,
  bnd_message_width = 350,
  bnd_homemessage_top = -100,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xFFFFFF",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x000000",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -100,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xFFFFFF",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 50,
  bnd_logo_width = 50,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x0001CE",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = "7_29"
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -110,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xffffff",
  bnd_title_fontColor = "0x00019D",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

CariocaInfo = {
  bnd_team_name_visible = true,
  bnd_short_name_visible = false,
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background = {
    name = "$Event",
    id = 2230
  },
  bnd_background_bottom = 0,
  bnd_color_alpha = 0,
  bnd_home_rect_left = -50,
  bnd_home_rect_top = 20,
  bnd_away_rect_left = -50,
  bnd_away_rect_top = 20,
  bnd_homename_text_right = 0,
  bnd_awayname_text_left = 0,
  bnd_score_fontSize = 23,
  bnd_name_text_top = 0,
  bnd_score_text_top = 0,

  bnd_event_height = 50,
  bnd_event_width = 800,
  bnd_event_top = -50,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 23,
  bnd_event_fontColor = "0xffffff",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xffffff",
  bnd_homename_height = 50,
  bnd_homename_width = 300,
  bnd_homename_color = "0x142a37",
  bnd_homename_left = 50,
  bnd_homename_text_left = 30,
  bnd_awayname_text_right = 30,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xffffff",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 50,
  bnd_awayname_height = 50,
  bnd_awayname_width = 300,
  bnd_awayname_color = "0x142a37",
  bnd_score_text = "-",
  bnd_score_visible = true,
  bnd_homeScore_text = "",
  bnd_awayScore_text = "",
  bnd_score_height = 50,
  bnd_score_width = 100,
  bnd_score_right = -25,
  bnd_score_left = -25,
  bnd_score_color = "0x142a37",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_color_visible = false,
  bnd_homecrest_top = -50,
  bnd_homecrest_left = -50,
  bnd_homecrest_color = "0x142a37",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 80,
  bnd_homecrest_width = 80,
  bnd_awaycrest_top = -50,
  bnd_awaycrest_right = -50,
  bnd_awaycrest_color = "0x142a37",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 80,
  bnd_awaycrest_width = 80,

  bnd_score_bg = {
    name = "$",
    id = 0
  },
  bnd_score_bg_visible = false,


  bnd_message_height = 50,
  bnd_message_width = 350,
  bnd_homemessage_top = -100,
  bnd_homemessage_left = -165,
  bnd_homemessage_color = "0xFFFFFF",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 16,
  bnd_message_fontColor = "0x142a37",
  bnd_awaymessage_right = 250,
  bnd_message_text_width = 250,
  bnd_awaymessage_top = -100,
  bnd_awaymessage_left = 165,
  bnd_awaymessage_color = "0xFFFFFF",
  bnd_awaymessage_text = "",
  
  bnd_logo_height = 50,
  bnd_logo_width = 50,
  bnd_logo_top = -49,
  bnd_logo_left = 0,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_color_visible = false,
  bnd_logo_color = "0x0001CE",
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2230
  },
  bnd_logowidth = 70,
  bnd_logoheight = 70,
  
  bnd_title_height = 30,
  bnd_title_width = 100,
  bnd_title_top = -110,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0x142a37",
  bnd_title_fontColor = "0xffffff",
  bnd_title_fontSize = 18,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

function GameEvents:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.nationalization = 2
  o.services = {
    EventManagerService = o.api("EventManagerService"),
    MatchInfoService = o.api("MatchInfoService"),
    SquadManagementService = o.api("SquadMgtService"),
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
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, EnglandTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, EnglandTeamsData)
    o.currentEvent.bnd_homename_color = homeColorList[1]
    o.currentEvent.bnd_homename_text_fontColor = homeColorList[2]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_awayname_color = awayColorList[1]
    o.currentEvent.bnd_awayname_text_fontColor = awayColorList[2]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
  elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
    o.currentEvent = SpainInfo
  elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
    o.currentEvent = SpainBInfo
  elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
    o.currentEvent = GermanyInfo
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, GermanyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, GermanyTeamsData)
    o.currentEvent.bnd_homename_color = homeColorList[1]
    o.currentEvent.bnd_homename_text_fontColor = homeColorList[2]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_awayname_color = awayColorList[1]
    o.currentEvent.bnd_awayname_text_fontColor = awayColorList[2]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
  elseif o:isInTable(o.TeamsData[1], Germany2Teams) and o:isInTable(o.TeamsData[2], Germany2Teams) then
    o.currentEvent = Germany2Info
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, Germany2TeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, Germany2TeamsData)
    o.currentEvent.bnd_homename_color = homeColorList[1]
    o.currentEvent.bnd_homename_text_fontColor = homeColorList[2]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_awayname_color = awayColorList[1]
    o.currentEvent.bnd_awayname_text_fontColor = awayColorList[2]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
  elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
    o.currentEvent = FranceInfo
  elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
    o.currentEvent = ItalyInfo
  elseif o:isInTable(o.TeamsData[1], BrazilTeams) and o:isInTable(o.TeamsData[2], BrazilTeams) then
    o.currentEvent = BrazilGloboInfo
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, BrazilTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, BrazilTeamsData)
    o.currentEvent.bnd_homename_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_awayname_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
  elseif o:isInTable(o.TeamsData[1], BrazilBTeams) and o:isInTable(o.TeamsData[2], BrazilBTeams) then
    o.currentEvent = BrazilInfo
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, BrazilTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, BrazilTeamsData)
    o.currentEvent.bnd_homename_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_awayname_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
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
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, LeaguePariTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, LeaguePariTeamsData)
    o.currentEvent.bnd_homename_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_awayname_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
  elseif o:isInTable(o.TeamsData[1], UkraineTeams) and o:isInTable(o.TeamsData[2], UkraineTeams) then
    o.currentEvent = UkraineInfo
  elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
    o.currentEvent = InternationalInfo
  else 
    o.currentEvent = EAFCInfo
  end
  end

  o.im.Subscribe(BND_VISIBLE, function()
     o.im.Publish(BND_VISIBLE, false)
  end
  )

  for k,v in pairs(o.currentEvent) do
    o.im.Subscribe(k, function()
      if o:isInArray(k, bndList) then
        o:_publishEventInfo()
     else
        o.im.Publish(k, v)
     end
    end)
  end
  return o
end

function GameEvents:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeMatchEvents then
    self:updateGameEvents(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function GameEvents:updateGameEvents(subtype, hideshow, subtypestr, msg)
  print("updateGameEvents " .. msg)
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      self.im.Publish(BND_VISIBLE, true)
      local index = 12
      self.arrEvents = {}
      local homeMsg = ""
      local awayMsg = ""
      local lng = (#params - 11) / 4
      do
        do
          for _FORV_11_ = 1, lng do
            self.arrEvents[_FORV_11_] = {}
            self.arrEvents[_FORV_11_].side = params[index]
            index = index + 1
            self.arrEvents[_FORV_11_].icon = params[index]
            index = index + 1
            self.arrEvents[_FORV_11_].label = params[index]
            index = index + 1
            self.arrEvents[_FORV_11_].teamAbbr = params[index]
            index = index + 1
            local label = self.arrEvents[_FORV_11_].label
            if self.arrEvents[_FORV_11_].icon + 0 > 2 then
              if self.arrEvents[_FORV_11_].side == "0" then
                homeMsg = homeMsg .. " " .. label
              else
                awayMsg = awayMsg .. " " .. label
              end
            end
          end
        end
      end
      if self.currentEvent.bnd_score_visible == true then
        self.homeScore = params[5]
        self.awayScore = params[6]
      else
        self.score = params[5] .. " - " .. params[6]
      end
      
      local gameevents = {
        homeTeamId = params[1] + 0,
        homeTeam = params[2],
        awayTeamId = params[3] + 0,
        awayTeam = params[4],
        score = self.score,
        message = params[7],
        aggMessage = params[8],
        events = self.arrEvents
      }
      
      
      if params[5]+0 == 0 then
        self.currentEvent.bnd_homemessage_visible = true
      else
        self.currentEvent.bnd_homemessage_visible = true
      end
      if params[6]+0 == 0 then
        self.currentEvent.bnd_awaymessage_visible = true
      else
        self.currentEvent.bnd_awaymessage_visible = true
      end
      

      self.currentEvent.bnd_homename_text = gameevents.homeTeam
      self.currentEvent.bnd_homecrest.id = gameevents.homeTeamId
      self.currentEvent.bnd_awayname_text = gameevents.awayTeam
      self.currentEvent.bnd_awaycrest.id = gameevents.awayTeamId
      if self.currentEvent.bnd_score_visible == true then
        self.currentEvent.bnd_homeScore_text = self.homeScore
        self.currentEvent.bnd_awayScore_text = self.awayScore
      else
        self.currentEvent.bnd_score_text = self.score
      end
      self.currentEvent.bnd_title_text = gameevents.message
      
      self.currentEvent.bnd_homemessage_text = homeMsg
      self.currentEvent.bnd_awaymessage_text = awayMsg
      
    end
  else
    self.im.Publish(BND_VISIBLE, false)
  end
  self:_publishEventInfo()
end

function GameEvents:_publishEventInfo()
  self.im.Publish("bnd_homemessage_visible", self.currentEvent.bnd_homemessage_visible)
  self.im.Publish("bnd_awaymessage_visible", self.currentEvent.bnd_awaymessage_visible)
  self.im.Publish("bnd_homename_text", self.currentEvent.bnd_homename_text)
  self.im.Publish("bnd_homecrest", self.currentEvent.bnd_homecrest)
  self.im.Publish("bnd_awayname_text", self.currentEvent.bnd_awayname_text)
  self.im.Publish("bnd_awaycrest", self.currentEvent.bnd_awaycrest)
  self.im.Publish("bnd_score_text", self.currentEvent.bnd_score_text)
  self.im.Publish("bnd_homeScore_text", self.currentEvent.bnd_homeScore_text)
  self.im.Publish("bnd_awayScore_text", self.currentEvent.bnd_awayScore_text)
  self.im.Publish("bnd_homemessage_text", self.currentEvent.bnd_homemessage_text)
  self.im.Publish("bnd_awaymessage_text", self.currentEvent.bnd_awaymessage_text)
  self.im.Publish("bnd_title_text", self.currentEvent.bnd_title_text)
end

function GameEvents:getTeamHomeColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.homeColor
      result[2] = v.homeFontColor
    end
  end
  return result
end

function GameEvents:getTeamAwayColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.awayColor
      result[2] = v.awayFontColor
    end
  end
  return result
end

function GameEvents:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function GameEvents:isInArray(value, tbl) 
  for k,v in pairs(tbl) do
    if tostring(v) == tostring(value) then
    return true
    end
  end
  return false
end

function GameEvents:getPlayerInfo(teamSide, playername, isOg)
  local flag = false
  local teamlineupData
  if teamSide == 0 then
    teamlineupData = homeTeamlineupData
  else 
    teamlineupData = awayTeamlineupData
  end
  if string.find(playername, "-") then
    playername = string.gsub(playername, "%-", " ")
  end
  for _FORV_6_ = 1, table.getn(teamlineupData) do
    if string.find(playername, teamlineupData[_FORV_6_].playerName,1,true) then
      flag = true
    end
  end
  if flag and isOg then
    flag = false
  elseif not flag and isOg then
    flag = true
  end
  return flag
end


function GameEvents:finalize()
  self.im.Unsubscribe(BND_VISIBLE)
  for k,v in pairs(EAFCInfo) do
    self.im.Unsubscribe(k)
  end
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end

return GameEvents