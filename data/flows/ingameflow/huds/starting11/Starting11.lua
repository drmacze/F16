local Starting11 = {}
local TableUtil, FormationModel, OverlaysIdContainer, OverlayParam, eventmanager = ...
local OVERLAY_TYPES = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

EAFCInfo = {
  bnd_fontFace = "$CruyffSans-Heavy",
  bnd_field_width = 1386,
  bnd_field_height = 640,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 0
  },
  bnd_formation_left = -135,
  bnd_formation_top = 105,
  bnd_bg_number_color = "0x00D9D1",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0x00D9D1",
  bnd_player_name_fontColor = "0x000000",
  --TeamCrest
  bnd_team_crest_width = 55,
  bnd_team_crest_height = 55,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "CENTER",
  bnd_team_crest_left = 300,
  bnd_team_crest_top = -145,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 17,
  bnd_team_name_fontColor = "0x000000",
  bnd_team_name_alignV = "CENTER",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 870,
  bnd_team_name_top = -160,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0x000000",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 870,
  bnd_team_formation_top = -130,
  --Subt
  bnd_posisi_sub_left = 280,
  bnd_posisi_sub_top = -50,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0x000000",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0x000000",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 0
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

DFLInfo = {
  bnd_fontFace = "$DINPro-Bold",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = "0_DFL"
  },
  bnd_formation_left = 112,
  bnd_formation_top = 40,
  bnd_bg_number_color = "0xffffff",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xffffff",
  bnd_player_name_fontColor = "0x000000",
  --TeamCrest
  bnd_team_crest_width = 45,
  bnd_team_crest_height = 45,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 382,
  bnd_team_crest_top = 15,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 465,
  bnd_team_name_top = 27,
  --TeamFormation
  bnd_team_formation_fontSize = 23,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = -330,
  bnd_team_formation_top = 200,
  --Subt
  bnd_posisi_sub_left = -315,
  bnd_posisi_sub_top = -100,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = -10,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 0
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

EnglandInfo = {
  bnd_fontFace = "$PremierLeague",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 13
  },
  bnd_formation_left = -120,
  bnd_formation_top = 20,
  bnd_bg_number_color = "0x39003E",
  bnd_player_number_fontColor = "0xF5F5F5",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x39003E",
  --TeamCrest
  bnd_team_crest_width = 75,
  bnd_team_crest_height = 75,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 0,
  bnd_team_crest_right = 194,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0x39003E",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 100,
  bnd_team_name_top = 50,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0x39003E",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 633,
  bnd_team_formation_top = 53,
  --Subt
  bnd_posisi_sub_left = 350,
  bnd_posisi_sub_top = -170,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = -10,
  bnd_playersub_fontSize = 20,
  bnd_playersub_fontColor = "0x39003E",
  bnd_playergksub_fontColor = "0x39003E",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 28,
  bnd_team_crest2_right = 168,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 13
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 195,
  bnd_logo_bottom = 0
}

SpainInfo = {
  bnd_fontFace = "$LaLiga",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 50,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 53
  },
  bnd_formation_left = -105,
  bnd_formation_top = 45,
  bnd_bg_number_color = "0xFF6F57",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 60,
  bnd_team_crest_height = 60,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 172,
  bnd_team_crest_top = 30,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 24,
  bnd_team_name_fontColor = "0x000000",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 350,
  bnd_team_name_top = 35,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0x000000",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 395,
  bnd_team_formation_top = 70,
  --Subt
  bnd_posisi_sub_left = 170,
  bnd_posisi_sub_top = -143,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0x000000",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0xFF6F57",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 53
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 195,
  bnd_logo_bottom = 0
}

SpainBInfo = {
  bnd_fontFace = "$LaLiga",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 54
  },
  bnd_formation_left = -115,
  bnd_formation_top = 45,
  bnd_bg_number_color = "0x00F3FF",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 60,
  bnd_team_crest_height = 60,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 162,
  bnd_team_crest_top = 30,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 24,
  bnd_team_name_fontColor = "0x000000",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 340,
  bnd_team_name_top = 35,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0x000000",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 385,
  bnd_team_formation_top = 70,
  --Subt
  bnd_posisi_sub_left = 160,
  bnd_posisi_sub_top = -143,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0x000000",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0x00F3FF",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 54
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

GermanyInfo = {
  bnd_fontFace = "$Bundesliga",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = -10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 19
  },
  bnd_formation_left = -147,
  bnd_formation_top = 25,
  bnd_bg_number_color = "0xFF0001",
  bnd_player_number_fontColor = "0xFFFFFF",
  bnd_bg_name_color = "0xFF0001",
  bnd_player_name_fontColor = "0xFFFFFF",
  --TeamCrest
  bnd_team_crest_width = 75,
  bnd_team_crest_height = 75,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = -200,
  bnd_team_crest_right = 160,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xFFFFFF",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "CENTER",
  bnd_team_name_left = 285,
  bnd_team_name_top = 90,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xFFFFFF",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = -150,
  bnd_team_formation_top = 233,
  --Subt
  bnd_posisi_sub_left = 210,
  bnd_posisi_sub_top = -65,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = -15,
  bnd_playersub_fontSize = 20,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0x000000",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 28,
  bnd_team_crest2_right = 168,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 19
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 195,
  bnd_logo_bottom = 0
}

Germany2Info = {
  bnd_fontFace = "$Bundesliga",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = -10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 20
  },
  bnd_formation_left = -147,
  bnd_formation_top = 25,
  bnd_bg_number_color = "0xFF0001",
  bnd_player_number_fontColor = "0xFFFFFF",
  bnd_bg_name_color = "0xFF0001",
  bnd_player_name_fontColor = "0xFFFFFF",
  --TeamCrest
  bnd_team_crest_width = 75,
  bnd_team_crest_height = 75,
  bnd_team_crest_alignV = "CENTER",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = -200,
  bnd_team_crest_right = 160,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xFFFFFF",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "CENTER",
  bnd_team_name_left = 285,
  bnd_team_name_top = 90,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xFFFFFF",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = -150,
  bnd_team_formation_top = 233,
  --Subt
  bnd_posisi_sub_left = 210,
  bnd_posisi_sub_top = -65,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = -15,
  bnd_playersub_fontSize = 20,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0x000000",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 28,
  bnd_team_crest2_right = 168,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 20
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 195,
  bnd_logo_bottom = 0
}

FranceInfo = {
  bnd_fontFace = "$DINPro-Bold",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 16
  },
  bnd_formation_left = -115,
  bnd_formation_top = 30,
  bnd_bg_number_color = "0x007EFF",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 80,
  bnd_team_crest_height = 80,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 145,
  bnd_team_crest_right = 200,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 385,
  bnd_team_name_top = 35,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 775,
  bnd_team_formation_top = 110,
  --Subt
  bnd_posisi_sub_left = 240,
  bnd_posisi_sub_top = 0,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0xD4D900",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 13,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xD4D900",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 16
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

ItalyInfo = {
  bnd_fontFace = "$SerieA",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 31
  },
  bnd_formation_left = -115,
  bnd_formation_top = 40,
  bnd_bg_number_color = "0x007EFF",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 80,
  bnd_team_crest_height = 80,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 115,
  bnd_team_crest_right = 200,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 780,
  bnd_team_name_top = 85,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 780,
  bnd_team_formation_top = 205,
  --Subt
  bnd_posisi_sub_left = 255,
  bnd_posisi_sub_top = 0,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 13,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xD4D900",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 31
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

BrazilInfo = {
  bnd_fontFace = "$Brasil-Sportv",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 7
  },
  bnd_formation_left = 45,
  bnd_formation_top = 20,
  bnd_bg_number_color = "0x030052",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0xffffff",
  bnd_player_name_fontColor = "0x030052",
  --TeamCrest
  bnd_team_crest_width = 40,
  bnd_team_crest_height = 40,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 110,
  bnd_team_crest_top = 31,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 180,
  bnd_team_name_top = 39,
  --TeamFormation
  bnd_team_formation_fontSize = 23,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 318,
  bnd_team_formation_top = -190,
  --Subt
  bnd_posisi_sub_left = -375,
  bnd_posisi_sub_top = -100,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0x030052",
  bnd_text_sub_left = -10,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0x030052",
  bnd_playergksub_fontColor = "0x030052",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 7
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

BrazilGloboInfo = {
  bnd_fontFace = "$Brasil-Globo",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = "7_1"
  },
  bnd_formation_left = -110,
  bnd_formation_top = 25,
  bnd_bg_number_color = "0xBCFF79",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0x000000",
  bnd_player_name_fontColor = "0xffffff",
  --TeamCrest
  bnd_team_crest_width = 60,
  bnd_team_crest_height = 60,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 110,
  bnd_team_crest_top = 31,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 180,
  bnd_team_name_top = 41,
  --TeamFormation
  bnd_team_formation_fontSize = 23,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = -100,
  bnd_team_formation_top = -185,
  --Subt
  bnd_posisi_sub_left = 235,
  bnd_posisi_sub_top = -115,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xBCFF79",
  bnd_text_sub_left = -10,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xBCFF79",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = "7_2"
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

BrazilAmazonInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 2117,
  bnd_field_height = 1015,
  bnd_field_left = 0,
  bnd_field_top = -85,
  bnd_field = {
    name = "$FieldTeams",
    id = "7_2"
  },
  bnd_formation_left = -147,
  bnd_formation_top = 30,
  bnd_bg_number_color = "0x009BEC",
  bnd_player_number_fontColor = "0xFFFFFF",
  bnd_bg_name_color = "0x009BEC",
  bnd_player_name_fontColor = "0xFFFFFF",
  --TeamCrest
  bnd_team_crest_width = 70,
  bnd_team_crest_height = 70,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 116,
  bnd_team_crest_top = 20,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 200,
  bnd_team_name_top = 41,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = -15,
  bnd_team_formation_top = -187,
  --Subt
  bnd_posisi_sub_left = 195,
  bnd_posisi_sub_top = -115,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 20,
  bnd_text_sub_fontColor = "0xFFFFFF",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = -2,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0x282828",
  bnd_playergksub_fontColor = "0x282828",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = "7_2"
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

MexicoInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 341
  },
  bnd_formation_left = 120,
  bnd_formation_top = 45,
  bnd_bg_number_color = "0xffffff",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0xffffff",
  bnd_player_name_fontColor = "0x000000",
  --TeamCrest
  bnd_team_crest_width = 50,
  bnd_team_crest_height = 50,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 117,
  bnd_team_crest_top = 42,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 27,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 230,
  bnd_team_name_top = 55,
  --TeamFormation
  bnd_team_formation_fontSize = 23,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 250,
  bnd_team_formation_top = -175,
  --Subt
  bnd_posisi_sub_left = -370,
  bnd_posisi_sub_top = -100,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = -5,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 341
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

ArgentinaInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 353
  },
  bnd_formation_left = 90,
  bnd_formation_top = 30,
  bnd_bg_number_color = "0xffffff",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xffffff",
  bnd_player_name_fontColor = "0x000000",
  --TeamCrest
  bnd_team_crest_width = 40,
  bnd_team_crest_height = 40,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 110,
  bnd_team_crest_top = 31,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 180,
  bnd_team_name_top = 38,
  --TeamFormation
  bnd_team_formation_fontSize = 23,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 275,
  bnd_team_formation_top = -191,
  --Subt
  bnd_posisi_sub_left = -385,
  bnd_posisi_sub_top = -100,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = -5,
  bnd_text_sub_top = -20,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 353
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

IndonesiaInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2235
  },
  bnd_formation_left = 130,
  bnd_formation_top = 25,
  bnd_bg_number_color = "0xf5f5f5",
  bnd_player_number_fontColor = "0x1e1e1e",
  bnd_bg_name_color = "0xf5f5f5",
  bnd_player_name_fontColor = "0x1e1e1e",
  --TeamCrest
  bnd_team_crest_width = 70,
  bnd_team_crest_height = 70,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 310,
  bnd_team_crest_top = 60,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xf5f5f5",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 160,
  bnd_team_name_top = 90,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xf5f5f5",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 120,
  bnd_team_formation_top = 195,
  --Subt
  bnd_posisi_sub_left = -365,
  bnd_posisi_sub_top = -100,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xf5f5f5",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xf5f5f5",
  bnd_playergksub_fontColor = "0xf5f5f5",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2235
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 40,
  bnd_logo_right = 230,
  bnd_logo_bottom = 0
}

SaudiArabiaInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 80,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 350
  },
  bnd_formation_left = -75,
  bnd_formation_top = 45,
  bnd_bg_number_color = "0x282F51",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 40,
  bnd_team_crest_height = 40,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "CENTER",
  bnd_team_crest_left = 207,
  bnd_team_crest_top = 90,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0x000000",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "CENTER",
  bnd_team_name_left = 285,
  bnd_team_name_top = 102,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0x000000",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 320,
  bnd_team_formation_top = 200,
  --Subt
  bnd_posisi_sub_left = 230,
  bnd_posisi_sub_top = -90,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0x000000",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0x282F51",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 350
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

RussiaInfo = {
  bnd_fontFace = "$Russian",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 15,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 67
  },
  bnd_formation_left = 130,
  bnd_formation_top = 40,
  bnd_bg_number_color = "0xffffff",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xffffff",
  bnd_player_name_fontColor = "0x000000",
  --TeamCrest
  bnd_team_crest_width = 60,
  bnd_team_crest_height = 60,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 25,
  bnd_team_crest_right = 150,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 180,
  bnd_team_name_top = 37,
  --TeamFormation
  bnd_team_formation_fontSize = 23,
  bnd_team_formation_fontColor = "0x000000",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 100,
  bnd_team_formation_top = -190,
  --Subt
  bnd_posisi_sub_left = -345,
  bnd_posisi_sub_top = -85,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = -3,
  bnd_text_sub_top = -48,
  bnd_playersub_fontSize = 20,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0x000000",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 67
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

LeaguePariInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2245
  },
  bnd_formation_left = 107,
  bnd_formation_top = 20,
  bnd_bg_number_color = "0xf5f5f5",
  bnd_player_number_fontColor = "0x1e1e1e",
  bnd_bg_name_color = "0xf5f5f5",
  bnd_player_name_fontColor = "0x1e1e1e",
  --TeamCrest
  bnd_team_crest_width = 70,
  bnd_team_crest_height = 70,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 225,
  bnd_team_crest_top = 45,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 14,
  bnd_team_name_fontColor = "0xf5f5f5",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 190,
  bnd_team_name_top = 125,
  --TeamFormation
  bnd_team_formation_fontSize = 15,
  bnd_team_formation_fontColor = "0xf5f5f5",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 200,
  bnd_team_formation_top = 190,
  --Subt
  bnd_posisi_sub_left = -320,
  bnd_posisi_sub_top = -85,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 15,
  bnd_text_sub_fontColor = "0xf5f5f5",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xf5f5f5",
  bnd_playergksub_fontColor = "0xf5f5f5",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2245
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 40,
  bnd_logo_right = 230,
  bnd_logo_bottom = 0
}

UkraineInfo = {
  bnd_fontFace = "$Default",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 332
  },
  bnd_formation_left = 120,
  bnd_formation_top = 40,
  bnd_bg_number_color = "0x0039AB",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0x0039AB",
  bnd_player_name_fontColor = "0xffffff",
  --TeamCrest
  bnd_team_crest_width = 60,
  bnd_team_crest_height = 60,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 160,
  bnd_team_crest_top = 90,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 15,
  bnd_team_name_fontColor = "0x0061DA",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 230,
  bnd_team_name_top = 100,
  --TeamFormation
  bnd_team_formation_fontSize = 15,
  bnd_team_formation_fontColor = "0x0061DA",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = -290,
  bnd_team_formation_top = -117,
  --Subt
  bnd_posisi_sub_left = -330,
  bnd_posisi_sub_top = -40,
  bnd_text_sub = "SUBSTITUTION",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = -10,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 0
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

InternationalInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 80,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 78
  },
  bnd_formation_left = -75,
  bnd_formation_top = 45,
  bnd_bg_number_color = "0xD3AA32",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 40,
  bnd_team_crest_height = 40,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "CENTER",
  bnd_team_crest_left = 207,
  bnd_team_crest_top = 90,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0x000000",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "CENTER",
  bnd_team_name_left = 285,
  bnd_team_name_top = 102,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0x000000",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 320,
  bnd_team_formation_top = 200,
  --Subt
  bnd_posisi_sub_left = 230,
  bnd_posisi_sub_top = -90,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0x000000",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0xD3AA32",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 78
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

--------- Tournaments ---------

UCLInfo = {
  bnd_fontFace = "$UCL-Regular",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2236
  },
  bnd_formation_left = -65,
  bnd_formation_top = 38,
  bnd_bg_number_color = "0xf5f5f5",
  bnd_player_number_fontColor = "0x1e1e1e",
  bnd_bg_name_color = "0xf5f5f5",
  bnd_player_name_fontColor = "0x1e1e1e",
  --TeamCrest
  bnd_team_crest_width = 80,
  bnd_team_crest_height = 80,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 60,
  bnd_team_crest_top = 35,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0xf5f5f5",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 190,
  bnd_team_name_top = 40,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xf5f5f5",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 190,
  bnd_team_formation_top = 80,
  --Subt
  bnd_posisi_sub_left = 290,
  bnd_posisi_sub_top = -140,
  bnd_text_sub = "SUBSTITUTES ",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = -30,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2236
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 40,
  bnd_logo_right = 230,
  bnd_logo_bottom = 0
}

UELInfo = {
  bnd_fontFace = "$UEL-Bold",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2238
  },
  bnd_formation_left = 135,
  bnd_formation_top = 38,
  bnd_bg_number_color = "0xE14711",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0xffffff",
  bnd_player_name_fontColor = "0x000000",
  --TeamCrest
  bnd_team_crest_width = 80,
  bnd_team_crest_height = 80,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 40,
  bnd_team_crest_right = 25,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 280,
  bnd_team_name_top = 35,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 280,
  bnd_team_formation_top = 75,
  --Subt
  bnd_posisi_sub_left = -475,
  bnd_posisi_sub_top = -165,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "LEFT",
  bnd_team_crest2_left = 38,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = 0,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo",
    id = "2238_1"
  },
  bnd_logo_width = 100,
  bnd_logo_height = 100,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = -35,
  bnd_logo_top = -30,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

EuroCopaInfo = {
  bnd_team_crest3_show = false,
  bnd_fontFace = "$UEFAEuro-Bold",
  bnd_field_width = 1400,
  bnd_field_height = 640,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2299
  },
  bnd_formation_left = -86,
  bnd_formation_top = 30,
  bnd_bg_number_color = "0xFDDA42",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xffffff",
  bnd_player_name_fontColor = "0x000000",
  --TeamCrest
  bnd_team_crest_width = 100,
  bnd_team_crest_height = 100,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 0,
  bnd_team_crest_right = 30,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 27,
  bnd_team_name_fontColor = "0xFDDA42",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 150,
  bnd_team_name_top = 56,
  --TeamFormation
  bnd_team_formation_fontSize = 25,
  bnd_team_formation_fontColor = "0xFDDA42",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 630,
  bnd_team_formation_top = 58,
  --Subt
  bnd_posisi_sub_left = 380,
  bnd_posisi_sub_top = -65,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xFDDA42",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 4,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xF5F5F5",
  bnd_playergksub_fontColor = "0xF5F5F5",
  --Coach/Manager
  bnd_team_crest2_width = 0,
  bnd_team_crest2_height = 0,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 28,
  bnd_team_crest2_right = 168,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 13
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

NationsLeagueInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1150,
  bnd_field_height = 540,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2241
  },
  bnd_formation_left = -75,
  bnd_formation_top = 35,
  bnd_bg_number_color = "0x282F51",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 40,
  bnd_team_crest_height = 40,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "CENTER",
  bnd_team_crest_left = 222,
  bnd_team_crest_top = 90,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0x000000",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "CENTER",
  bnd_team_name_left = 305,
  bnd_team_name_top = 102,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0x000000",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 320,
  bnd_team_formation_top = 200,
  --Subt
  bnd_posisi_sub_left = 230,
  bnd_posisi_sub_top = -90,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0x000000",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0x000000",
  bnd_playergksub_fontColor = "0x282F51",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2241
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

UCLClassicInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = -18,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 22366
  },
  bnd_formation_left = -130,
  bnd_formation_top = 38,
  bnd_bg_number_color = "0xf5f5f5",
  bnd_player_number_fontColor = "0x1e1e1e",
  bnd_bg_name_color = "0xf5f5f5",
  bnd_player_name_fontColor = "0x1e1e1e",
  --TeamCrest
  bnd_team_crest_width = 80,
  bnd_team_crest_height = 80,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 25,
  bnd_team_crest_top = 20,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0x000000",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 120,
  bnd_team_name_top = 45,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xf5f5f5",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 280,
  bnd_team_formation_top = 200,
  --Subt
  bnd_posisi_sub_left = 275,
  bnd_posisi_sub_top = -135,
  bnd_text_sub = "SUBSTITUTION ",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0x000000",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = -43,
  bnd_playersub_fontSize = 20,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2236
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 40,
  bnd_logo_right = 230,
  bnd_logo_bottom = 0
}

LibertadoresInfo = {
  bnd_fontFace = "$Libertadores",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2237
  },
  bnd_formation_left = 90,
  bnd_formation_top = 10,
  bnd_bg_number_color = "0x000000",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0x000000",
  bnd_player_name_fontColor = "0xffffff",
  --TeamCrest
  bnd_team_crest_width = 50,
  bnd_team_crest_height = 50,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 195,
  bnd_team_crest_top = 5,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 280,
  bnd_team_name_top = 16,
  --TeamFormation
  bnd_team_formation_fontSize = 23,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 200,
  bnd_team_formation_top = -210,
  --Subt
  bnd_posisi_sub_left = -320,
  bnd_posisi_sub_top = -120,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = -10,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 2237
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

SudamericanaInfo = {
  bnd_fontFace = "$Libertadores",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2267
  },
  bnd_formation_left = 90,
  bnd_formation_top = 10,
  bnd_bg_number_color = "0x000741",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0x000741",
  bnd_player_name_fontColor = "0xffffff",
  --TeamCrest
  bnd_team_crest_width = 50,
  bnd_team_crest_height = 50,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 195,
  bnd_team_crest_top = 5,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 280,
  bnd_team_name_top = 16,
  --TeamFormation
  bnd_team_formation_fontSize = 23,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 200,
  bnd_team_formation_top = -210,
  --Subt
  bnd_posisi_sub_left = -320,
  bnd_posisi_sub_top = -120,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = -10,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 2267
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

CopaAmericaInfo = {
  bnd_fontFace = "$CopaAmerica",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2298
  },
  bnd_formation_left = -115,
  bnd_formation_top = 30,
  bnd_bg_number_color = "0xffffff",
  bnd_player_number_fontColor = "0x132041",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 170,
  bnd_team_crest_height = 170,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 130,
  bnd_team_crest_right = 10,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 750,
  bnd_team_name_top = 80,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 750,
  bnd_team_formation_top = 120,
  --Subt
  bnd_posisi_sub_left = 225,
  bnd_posisi_sub_top = 0,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 13,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2298
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

WorldCupInfo = {
  bnd_fontFace = "$Anybody-Bold",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 365
  },
  bnd_formation_left = 97,
  bnd_formation_top = 40,
  bnd_bg_number_color = "0xffffff",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0xffffff",
  bnd_player_name_fontColor = "0x000000",
  --TeamCrest
  bnd_team_crest_width = 60,
  bnd_team_crest_height = 60,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 145,
  bnd_team_crest_top = 20,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 280,
  bnd_team_name_top = 38,
  --TeamFormation
  bnd_team_formation_fontSize = 16,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "CENTER",
  bnd_team_formation_left = 295,
  bnd_team_formation_top = -120,
  --Subt
  bnd_posisi_sub_left = -320,
  bnd_posisi_sub_top = -120,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = -10,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$",
    id = 365
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

WomensWorldCupInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = "10_Cup"
  },
  bnd_formation_left = -115,
  bnd_formation_top = 30,
  bnd_bg_number_color = "0x275759",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0x275759",
  bnd_player_name_fontColor = "0xffffff",
  --TeamCrest
  bnd_team_crest_width = 170,
  bnd_team_crest_height = 170,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 130,
  bnd_team_crest_right = 10,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 750,
  bnd_team_name_top = 80,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 750,
  bnd_team_formation_top = 120,
  --Subt
  bnd_posisi_sub_left = 225,
  bnd_posisi_sub_top = 0,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 13,
  bnd_playersub_fontColor = "0xF7F9E1",
  bnd_playergksub_fontColor = "0xF7F9E1",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = "10_Cup"
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

ClubWorldCupInfo = {
  bnd_fontFace = "$DINPro-Bold",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 0,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2209
  },
  bnd_formation_left = -125,
  bnd_formation_top = 25,
  bnd_bg_number_color = "0xCDA31F",
  bnd_player_number_fontColor = "0x000000",
  bnd_bg_name_color = "0x000000",
  bnd_player_name_fontColor = "0xFFFFFF",
  --TeamCrest
  bnd_team_crest_width = 48,
  bnd_team_crest_height = 48,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 50,
  bnd_team_crest_top = -1,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 45,
  bnd_team_name_fontColor = "0xFFFFFF",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 220,
  bnd_team_name_top = -7,
  --TeamFormation
  bnd_team_formation_fontSize = 25,
  bnd_team_formation_fontColor = "0xFFFFFF",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 790,
  bnd_team_formation_top = 7,
  --Subt
  bnd_posisi_sub_left = 260,
  bnd_posisi_sub_top = -140,
  bnd_text_sub = "SUBSTITUTES ",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xCDA31F",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = -30,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2209
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 40,
  bnd_logo_right = 230,
  bnd_logo_bottom = 0
}

FAcupInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2213
  },
  bnd_formation_left = -115,
  bnd_formation_top = 30,
  bnd_bg_number_color = "0xffffff",
  bnd_player_number_fontColor = "0x132041",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 170,
  bnd_team_crest_height = 170,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 130,
  bnd_team_crest_right = 10,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 750,
  bnd_team_name_top = 80,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 750,
  bnd_team_formation_top = 120,
  --Subt
  bnd_posisi_sub_left = 225,
  bnd_posisi_sub_top = 0,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 13,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2213
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

CoppaItaliaInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2231
  },
  bnd_formation_left = -115,
  bnd_formation_top = 40,
  bnd_bg_number_color = "0xAA1100",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 80,
  bnd_team_crest_height = 80,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 115,
  bnd_team_crest_right = 200,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 780,
  bnd_team_name_top = 85,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 780,
  bnd_team_formation_top = 205,
  --Subt
  bnd_posisi_sub_left = 255,
  bnd_posisi_sub_top = 0,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 13,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xD4D900",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2231
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

SaudiSuperCupInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 3350
  },
  bnd_formation_left = -115,
  bnd_formation_top = 30,
  bnd_bg_number_color = "0xffffff",
  bnd_player_number_fontColor = "0x132041",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 170,
  bnd_team_crest_height = 170,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "RIGHT",
  bnd_team_crest_left = 0,
  bnd_team_crest_top = 130,
  bnd_team_crest_right = 10,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 30,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 750,
  bnd_team_name_top = 80,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "TOP",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 750,
  bnd_team_formation_top = 120,
  --Subt
  bnd_posisi_sub_left = 225,
  bnd_posisi_sub_top = 0,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 13,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2298
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

KingCupInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1200,
  bnd_field_height = 566,
  bnd_field_left = 40,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 3500
  },
  bnd_formation_left = -105,
  bnd_formation_top = 40,
  bnd_bg_number_color = "0x000000",
  bnd_player_number_fontColor = "0xffffff",
  bnd_bg_name_color = "0xF5F5F5",
  bnd_player_name_fontColor = "0x132041",
  --TeamCrest
  bnd_team_crest_width = 50,
  bnd_team_crest_height = 50,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 162,
  bnd_team_crest_top = 23,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 24,
  bnd_team_name_fontColor = "0xffffff",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 340,
  bnd_team_name_top = 35,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xffffff",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 780,
  bnd_team_formation_top = 200,
  --Subt
  bnd_posisi_sub_left = 175,
  bnd_posisi_sub_top = -143,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 17,
  bnd_text_sub_fontColor = "0xffffff",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xffffff",
  bnd_playergksub_fontColor = "0xffffff",
  --Coach/Manager
  bnd_team_crest2_width = 150,
  bnd_team_crest2_height = 150,
  bnd_team_crest2_alignV = "TOP",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 115,
  bnd_team_crest2_right = 160,
  bnd_team_crest2_bottom = 0,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo1",
    id = "350_5"
  },
  bnd_logo_width = 80,
  bnd_logo_height = 80,
  bnd_logo_alignV = "CENTER",
  bnd_logo_alignH = "RIGHT",
  bnd_logo_left = 0,
  bnd_logo_top = 5,
  bnd_logo_right = 205,
  bnd_logo_bottom = 0
}

PaulistaoInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2229
  },
  bnd_formation_left = 128,
  bnd_formation_top = 12,
  bnd_bg_number_color = "0xf5f5f5",
  bnd_player_number_fontColor = "0x1e1e1e",
  bnd_bg_name_color = "0xf5f5f5",
  bnd_player_name_fontColor = "0x1e1e1e",
  --TeamCrest
  bnd_team_crest_width = 20,
  bnd_team_crest_height = 20,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = -1000000,
  bnd_team_crest_top = 60,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xf5f5f5",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 160,
  bnd_team_name_top = 95,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xf5f5f5",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 120,
  bnd_team_formation_top = 195,
  --Subt
  bnd_posisi_sub_left = -365,
  bnd_posisi_sub_top = -100,
  bnd_text_sub = "SUBSTITUTES",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0xf5f5f5",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xf5f5f5",
  bnd_playergksub_fontColor = "0xf5f5f5",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_29"
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 122,
  bnd_logo_top = 27,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

CariocaInfo = {
  bnd_fontFace = "$Title",
  bnd_field_width = 1058,
  bnd_field_height = 500,
  bnd_field_left = 10,
  bnd_field_top = 0,
  bnd_field = {
    name = "$FieldTeams",
    id = 2230
  },
  bnd_formation_left = 128,
  bnd_formation_top = 12,
  bnd_bg_number_color = "0xf5f5f5",
  bnd_player_number_fontColor = "0x1e1e1e",
  bnd_bg_name_color = "0xf5f5f5",
  bnd_player_name_fontColor = "0x1e1e1e",
  --TeamCrest
  bnd_team_crest_width = 80,
  bnd_team_crest_height = 80,
  bnd_team_crest_alignV = "TOP",
  bnd_team_crest_alignH = "LEFT",
  bnd_team_crest_left = 73,
  bnd_team_crest_top = 10,
  bnd_team_crest_right = 0,
  bnd_team_crest_bottom = 0,
  --TeamName
  bnd_team_name_fontSize = 20,
  bnd_team_name_fontColor = "0xf5f5f5",
  bnd_team_name_alignV = "TOP",
  bnd_team_name_alignH = "LEFT",
  bnd_team_name_left = 160,
  bnd_team_name_top = 95,
  --TeamFormation
  bnd_team_formation_fontSize = 20,
  bnd_team_formation_fontColor = "0xf5f5f5",
  bnd_team_formation_alignV = "CENTER",
  bnd_team_formation_alignH = "LEFT",
  bnd_team_formation_left = 120,
  bnd_team_formation_top = 195,
  --Subt
  bnd_posisi_sub_left = -365,
  bnd_posisi_sub_top = -100,
  bnd_text_sub = "SUBSTITUTES:",
  bnd_text_sub_fontSize = 25,
  bnd_text_sub_fontColor = "0x00B4FF",
  bnd_text_sub_left = 0,
  bnd_text_sub_top = 10,
  bnd_playersub_fontSize = 15,
  bnd_playersub_fontColor = "0xf5f5f5",
  bnd_playergksub_fontColor = "0xf5f5f5",
  --Coach/Manager
  bnd_team_crest2_width = 200,
  bnd_team_crest2_height = 200,
  bnd_team_crest2_alignV = "BOTTOM",
  bnd_team_crest2_alignH = "RIGHT",
  bnd_team_crest2_left = 0,
  bnd_team_crest2_top = 0,
  bnd_team_crest2_right = -50,
  bnd_team_crest2_bottom = -5,
  --Logo
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_30"
  },
  bnd_logo_width = 70,
  bnd_logo_height = 70,
  bnd_logo_alignV = "TOP",
  bnd_logo_alignH = "LEFT",
  bnd_logo_left = 280,
  bnd_logo_top = 43,
  bnd_logo_right = 0,
  bnd_logo_bottom = 0
}

function Starting11:new(init)
  print("[Starting11]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    TacticsService = o.api("TacticsService"),
    SquadManagementService = o.api("SquadMgtService"),
    eventManService = o.api("EventManagerService"),
    MatchInfoService = o.api("MatchInfoService"),
    OverlayService = o.api("OverlayService"),
    TeamService = o.api("TeamService")
  }
  o.handlerId = o.services.eventManService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)

  
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  
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
      o.currentEvent = EAFCInfo
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
      o.currentEvent = FAcupInfo
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
    o.currentEvent = EAFCInfo
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
    o.currentEvent = FAcupInfo
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
    o.currentEvent = Germany2Info
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


  o.gamemode = o.data.gamemode or "real"
  o.flow = o.data.flow or "offline"
  o.playerLineup = nil
  o.isActive = false
  o.isVisible = false
  o.models = {
    FormationModel = FormationModel:new({
      im = o.im,
      api = o.api,
      nav = o.nav,
      loc = o.loc,
      gamemode = o.gamemode
    })
  }
  o.bndList = {
    bnd_player1_name = "",
    bnd_player2_name = "",
    bnd_player3_name = "",
    bnd_player4_name = "",
    bnd_player5_name = "",
    bnd_player6_name = "",
    bnd_player7_name = "",
    bnd_player8_name = "",
    bnd_player9_name = "",
    bnd_player10_name = "",
    bnd_player11_name = "",
    bnd_player12_name = "",
    bnd_player13_name = "",
    bnd_player14_name = "",
    bnd_player15_name = "",
    bnd_player16_name = "",
    bnd_player17_name = "",
    bnd_player18_name = "",
    bnd_player1_number = "",
    bnd_player2_number = "",
    bnd_player3_number = "",
    bnd_player4_number = "",
    bnd_player5_number = "",
    bnd_player6_number = "",
    bnd_player7_number = "",
    bnd_player8_number = "",
    bnd_player9_number = "",
    bnd_player10_number = "",
    bnd_player11_number = "",
    bnd_player12_number = "",
    bnd_player13_number = "",
    bnd_player14_number = "",
    bnd_player15_number = "",
    bnd_player16_number = "",
    bnd_player17_number = "",
    bnd_player18_number = "",
    bnd_player1_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player2_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player3_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player4_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player5_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player6_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player7_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player8_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player9_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player10_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player11_avatar = {
      name = "$Head",
      id = 0
    },
    bnd_player1_bottom = 0,
    bnd_player2_bottom = 0,
    bnd_player3_bottom = 0,
    bnd_player4_bottom = 0,
    bnd_player5_bottom = 0,
    bnd_player6_bottom = 0,
    bnd_player7_bottom = 0,
    bnd_player8_bottom = 0,
    bnd_player9_bottom = 0,
    bnd_player10_bottom = 0,
    bnd_player11_bottom = 0,
    bnd_player1_left= 0,
    bnd_player2_left= 0,
    bnd_player3_left= 0,
    bnd_player4_left= 0,
    bnd_player5_left= 0,
    bnd_player6_left= 0,
    bnd_player7_left= 0,
    bnd_player8_left= 0,
    bnd_player9_left= 0,
    bnd_player10_left= 0,
    bnd_player11_left= 0
  }

  o.crest = {
    name = "$Crest",
    id = 0
  }
  o.crest2 = {
    name = "$ManagerCardOff",
    id = 0
  }

  o.formationName = ""

  o.teamName = ""

  o.im.Subscribe("bnd_active", function()
    o:_publishActivity()
  end
  )
  o.im.Subscribe("bnd_visible", function()
    o:_publishActivity()
  end
  )
  o.im.Subscribe("bnd_team_crest", function()
    o:_publishTeamCrest()
  end
  )
  o.im.Subscribe("bnd_team_crest2", function()
    o:_publishTeamCrest2()
  end
  )

  o.im.Subscribe("bnd_team_name", function()
    o:_publishTeamName()
  end
  )
  o.im.Subscribe("bnd_team_formation", function()
    o:_publishTeamFormation()
  end
  )
  for k,v in pairs(o.bndList) do
    o.im.Subscribe(k, function()
    end)
  end
  
  o.im.Subscribe("bnd_active", function()
    o:_publishActive()
  end)

  for k,v in pairs(o.currentEvent) do
    o.im.Subscribe(k, function()
      o.im.Publish(k, v)
    end)
  end
  return o
end

function Starting11:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeIntroSequenceTeamList then
    self:updatePlayerLineup(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function Starting11:updatePlayerLineup(subtype, hideshow, subtypestr, msg)
  print("[Starting11]: updatePlayerLineup(subtype = " .. tostring(subtype) .. ", hideshow = " .. tostring(hideshow) .. ", subtypestr = " .. tostring(subtypestr) .. ", msg = " .. tostring(msg) .. ")")
  if hideshow ~= "HIDE" then
    self.isActive = true
    self.isVisible = true
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      local teamSide = tonumber(params[5])
      local teamID = tonumber(params[3])
      if teamSide == 0 then
        self.crest.id = self.TeamsData[1].assetId
      else
        self.crest.id = self.TeamsData[2].assetId
      end
      if teamSide == 0 then
        self.crest2.id = self.TeamsData[1].assetId
      else
        self.crest2.id = self.TeamsData[2].assetId
      end
      self.teamName = params[2]
      local lineup = self.services.SquadManagementService.GetCurrentPlayerLineup(teamSide, teamID, 0)
      local formationID = self.services.TacticsService.GetFormation(teamSide, teamID)
      if self.gamemode == "fut" then
        formationID = self.services.SquadManagementService.GetFUTRelativeSquadFormation(formationID)
      end
      local formation = self.models.FormationModel:getFormationInfoByID(formationID)
      local formationCoords = formation.coords
      local formationName = formation.name
      local formationPosition = formation.positions
      self.formationName = formationName
      self.playerLineup = {
        players = {},
        teamID = params[1],
        teamName = params[2],
        formationName = formationName,
        starting11Label = (""),
        subsLabel = ("")
      }
      do
        do
          for _FORV_16_ = 1, table.getn(lineup) do
            self.playerLineup.players[_FORV_16_] = {}
            self.playerLineup.players[_FORV_16_].assetId = lineup[_FORV_16_].CARD_ID
            self.playerLineup.players[_FORV_16_].name = lineup[_FORV_16_].playerName
            self.playerLineup.players[_FORV_16_].number = lineup[_FORV_16_].jerseyNumber
            self.playerLineup.players[_FORV_16_].hasYellowCard = false
            if _FORV_16_ <= 11 then
              self.playerLineup.players[_FORV_16_].coords = formationCoords[_FORV_16_]
              self.playerLineup.players[_FORV_16_].jerseyColor = "0x00FF00"
              if formationPosition[_FORV_16_] then
                self.playerLineup.players[_FORV_16_].position = {
                  xPos = 0,
                  yPos = 0
                }
                self.playerLineup.players[_FORV_16_].position.xPos = formationPosition[_FORV_16_].xPos
                self.playerLineup.players[_FORV_16_].position.yPos = formationPosition[_FORV_16_].yPos
              end
            end
          end
        end
      end
      self:_publishPlayerLineup()
      self:_publishTeamCrest()
      self:_publishTeamCrest2()
      self:_publishTeamName()
      self:_publishTeamFormation()
      
    end
  else
    self.isActive = false
    self.isVisible = false
  end
  self:_publishActivity()
end

function Starting11:_publishActive()
  self.im.Publish("bnd_active", self.active)
end

function Starting11:_publishActivity()
  self.im.Publish("bnd_active", self.isActive)
  self.im.Publish("bnd_visible", self.isVisible)
end

function Starting11:_publishTeamCrest()
  self.im.Publish("bnd_team_crest", self.crest)
end

function Starting11:_publishTeamCrest2()
  self.im.Publish("bnd_team_crest2", self.crest2)
end

function Starting11:_publishTeamName()
  self.im.Publish("bnd_team_name", self.teamName)
end

function Starting11:_publishTeamFormation()
  self.im.Publish("bnd_team_formation", self.formationName)
end

function Starting11:_publishPlayerLineup()
  if self.playerLineup == nil then
    return
  end
  for index = 1, table.getn(self.playerLineup.players) do
    local bindingPlayer = "bnd_player"..index
    local playerAvatar = {
      name = "$Head",
      id = 0
    }
    playerAvatar.id = self.playerLineup.players[index].assetId
    local formatName = self.playerLineup.players[index].name.." "
    self.im.Publish(bindingPlayer.."_name", formatName)
    self.im.Publish(bindingPlayer.."_number", self.playerLineup.players[index].number)
    if index <= 11 then
      self.im.Publish(bindingPlayer.."_avatar", playerAvatar)
      self.im.Publish(bindingPlayer.."_left", self.playerLineup.players[index].position.xPos)
      self.im.Publish(bindingPlayer.."_bottom", self.playerLineup.players[index].position.yPos)
    end
  end
end

function Starting11:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function Starting11:finalize()
  print("[Starting11]: finalize()")
  self.models.FormationModel:finalize()
  self.im.Unsubscribe("bnd_live_logo")
  self.im.Unsubscribe("bnd_active")
  self.im.Unsubscribe("bnd_visible")
  self.im.Unsubscribe("bnd_team_crest")
  self.im.Unsubscribe("bnd_team_crest2")
  self.im.Unsubscribe("bnd_team_name")
  self.im.Unsubscribe("bnd_team_formation")
  for k,v in pairs(self.bndList) do
    self.im.Unsubscribe(k)
  end
  self.services.eventManService.UnregisterHandler(self.handlerId)
end

return Starting11