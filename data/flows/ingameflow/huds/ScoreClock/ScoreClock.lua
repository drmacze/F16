local ScoreClock = {}

local OverlaysIdContainer, OverlayParam, eventmanager, TableUtil = ...
local Overlays = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local EAFCScore = {
  bnd_fontFace = "$CruyffSans-Heavy",
  bnd_text_bold = false,
  bnd_width = 360,
  bnd_height = 60,
  bnd_top = 35,
  bnd_left = -65,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 60,
  bnd_logo_width = 42,
  bnd_logo_top = 0,
  bnd_logo_left = -35,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 0
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 21,
  bnd_homeRect_top = -19.3,
  bnd_homeRect_left = 90.5,
  bnd_homeRect_width = 4,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 21,
  bnd_awayRect_top = 1,
  bnd_awayRect_right = -90.5,
  bnd_awayRect_width = 4,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 105,
  bnd_homeBg_left = 40,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 0
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 90,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away2",
    id = 0
  },
  bnd_scoreBg_width = 85,
  bnd_scoreBg_height = 70,
  bnd_scoreBg_right = -40,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 0
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 11,
  bnd_homeName_top = -17,
  bnd_homeName_fontSize = 14,
  bnd_homeName_fontColor = "0x000000",
  bnd_awayName_text = "",
  bnd_awayName_right = -11,
  bnd_awayName_top = 2,
  bnd_awayName_fontSize = 14,
  bnd_awayName_fontColor = "0x000000",
  
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = 47,
  bnd_homeCrest_top = -18.5,
  bnd_homeCrest_width = 18,
  bnd_homeCrest_height = 18,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -47,
  bnd_awayCrest_top = 1.5,
  bnd_awayCrest_width = 18,
  bnd_awayCrest_height = 18,
  
  bnd_homeScore_text = "",
  bnd_homeScore_top = -17,
  bnd_homeScore_left = 73,
  bnd_homeScore_fontSize = 16,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 2,
  bnd_awayScore_right = -73,
  bnd_awayScore_fontSize = 16,
  bnd_awayScore_fontColor = "0x000000",
  
  bnd_score_text = "-",
  bnd_score_top = 1.25,
  bnd_score_left = -15000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x000000",

  bnd_time_width = 55.5,
  bnd_time_height = 35,
  bnd_time_top = 22,
  bnd_time_left = 173,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time1",
    id = 0
  },
  bnd_time_text = "",
  bnd_time_fontSize = 16,
  bnd_time_fontColor = "0xFFFFFF",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 35,
  bnd_extraTime_height = 35,
  bnd_extraTime_top = 22,
  bnd_extraTime_left = 235,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime1",
    id = 0
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 16,
  bnd_extraTime_fontColor = "0x00D9D1",

  bnd_stat_visible = false,
  bnd_stat_width = 60,
  bnd_stat_height = 60,
  bnd_stat_top = 0,
  bnd_stat_left = 270,
  bnd_stat_color = "0x000000",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 16,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = -17,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 0,
  bnd_away_stat_text_top = 2,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 22,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text_fontColor = "0xffffff",
  bnd_stat_text = ""
}

local DFLScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 34,
  bnd_top = 40,
  bnd_left = 70,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 35,
  bnd_logo_width = 77,
  bnd_logo_top = -32,
  bnd_logo_left = 5,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = "0_DFL"
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 34,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -115,
  bnd_homeRect_width = 8,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 34,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -125,
  bnd_awayRect_width = 8,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = "0_DFL"
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = "0_DFL"
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = "0_DFL"
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -77,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -83,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",
  
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0x2E2E2E",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -23,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0x2E2E2E",

  bnd_score_text = "|",
  bnd_score_top = 0,
  bnd_score_left = 4,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x2E2E2E",

  bnd_time_width = 80,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = 18,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = "0_DFL"
  },
  bnd_time_text = "",
  bnd_time_fontSize = 22,
  bnd_time_fontColor = "0xFFFFFF",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 37,
  bnd_extraTime_left = 18,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = "0_DFL"
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xFFFFFF",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 40,
  bnd_stat_top = 40,
  bnd_stat_left = 105,
  bnd_stat_color = "0x2E2E2E",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local EnglandScore = {
  bnd_fontFace = "$PremierLeague",
  bnd_text_bold = true,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 48,
  bnd_left = -15,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 40,
  bnd_logo_width = 125,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 13
  },

  bnd_cornerRaduis = 8,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 26,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -58,
  bnd_homeRect_width = 130,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 26,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -58,
  bnd_awayRect_width = 130,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 80,
  bnd_homeBg_left = -78,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home1",
    id = 13
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 80,
  bnd_awayBg_right = -78,
  bnd_awayBg_height = 30,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 13
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 30,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 13
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -94,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 23,
  bnd_homeName_fontColor = "",
  bnd_awayName_text = "",
  bnd_awayName_right = -89,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 23,
  bnd_awayName_fontColor = "",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  bnd_homeScore_text = "",
  bnd_homeScore_top = -2,
  bnd_homeScore_left = -34,
  bnd_homeScore_fontSize = 41,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = -2,
  bnd_awayScore_right = -30,
  bnd_awayScore_fontSize = 41,
  bnd_awayScore_fontColor = "0xffffff",
  bnd_score_text = "",
  bnd_score_top = 1.25,
  bnd_score_left = -1.5,
  bnd_score_fontSize = 25,
  bnd_score_fontColor = "0x34003A",
  bnd_time_width = 124,
  bnd_time_height = 42,
  bnd_time_top = 25,
  bnd_time_left = 178,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 13
  },
  bnd_time_text = "",
  bnd_time_fontSize = 15,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 124,
  bnd_extraTime_height = 42,
  bnd_extraTime_top = 46,
  bnd_extraTime_left = 178,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 13
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 17,
  bnd_extraTime_fontColor = "0xffffff",
  
  bnd_stat_visible = false,
  bnd_stat_width = 246,
  bnd_stat_height = 55,
  bnd_stat_top = 40,
  bnd_stat_left = 117,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x2F0B3A",
  bnd_home_stat_text_left = -85,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 85,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 15,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local SpainScore = {
  bnd_fontFace = "$LaLiga",
  bnd_text_bold = false,
  bnd_width = 360,
  bnd_height = 70,
  bnd_top = 35,
  bnd_left = -25,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 35,
  bnd_logo_width = 55,
  bnd_logo_top = -18,
  bnd_logo_left = -30,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 53
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 35.5,
  bnd_homeRect_top = -17,
  bnd_homeRect_left = 40,
  bnd_homeRect_width = 3,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 35.5,
  bnd_awayRect_top = 17,
  bnd_awayRect_right = -40,
  bnd_awayRect_width = 3,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 90,
  bnd_homeBg_left = -80,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home2",
    id = 53
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 90,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away2",
    id = 53
  },
  bnd_scoreBg_width = 85,
  bnd_scoreBg_height = 70,
  bnd_scoreBg_right = -40,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 53
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 17,
  bnd_homeName_top = -17,
  bnd_homeName_fontSize = 16,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -17,
  bnd_awayName_top = 18,
  bnd_awayName_fontSize = 16,
  bnd_awayName_fontColor = "0xFFFFFF",
  
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  
  bnd_homeScore_text = "",
  bnd_homeScore_top = -17,
  bnd_homeScore_left = 60,
  bnd_homeScore_fontSize = 31,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 18,
  bnd_awayScore_right = -59,
  bnd_awayScore_fontSize = 31,
  bnd_awayScore_fontColor = "0x000000",
  
  bnd_score_text = "-",
  bnd_score_top = 1.25,
  bnd_score_left = -15000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x34003A",

  bnd_time_width = 55.5,
  bnd_time_height = 35,
  bnd_time_top = 17,
  bnd_time_left = 122,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 53
  },
  bnd_time_text = "",
  bnd_time_fontSize = 17,
  bnd_time_fontColor = "0x000000",
  bnd_time_text_top = 1,
  bnd_time_text_left = -2,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 35,
  bnd_extraTime_height = 35,
  bnd_extraTime_top = 17,
  bnd_extraTime_left = 86,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 53
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 17,
  bnd_extraTime_fontColor = "0xFFFFFF",

  bnd_stat_visible = false,
  bnd_stat_width = 50,
  bnd_stat_height = 70,
  bnd_stat_top = 0,
  bnd_stat_left = 260,
  bnd_stat_color = "0x000000",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 17,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = -19,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 0,
  bnd_away_stat_text_top = 19,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text_fontColor = "0xffffff",
  bnd_stat_text = ""
}

local SpainBScore = {
  bnd_fontFace = "$LaLiga",
  bnd_text_bold = false,
  bnd_width = 360,
  bnd_height = 70,
  bnd_top = 35,
  bnd_left = -25,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 37,
  bnd_logo_width = 55,
  bnd_logo_top = -17,
  bnd_logo_left = -30,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 54
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 90,
  bnd_homeBg_left = -80,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home2",
    id = 53
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 90,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away2",
    id = 53
  },
  bnd_scoreBg_width = 85,
  bnd_scoreBg_height = 70,
  bnd_scoreBg_right = -40,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 53
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 17,
  bnd_homeName_top = -17,
  bnd_homeName_fontSize = 16,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -17,
  bnd_awayName_top = 18,
  bnd_awayName_fontSize = 16,
  bnd_awayName_fontColor = "0xFFFFFF",
  
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  
  bnd_homeScore_text = "",
  bnd_homeScore_top = -17,
  bnd_homeScore_left = 60,
  bnd_homeScore_fontSize = 31,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 18,
  bnd_awayScore_right = -59,
  bnd_awayScore_fontSize = 31,
  bnd_awayScore_fontColor = "0x000000",
  
  bnd_score_text = "-",
  bnd_score_top = 1.25,
  bnd_score_left = -15000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x34003A",

  bnd_time_width = 55.5,
  bnd_time_height = 33.5,
  bnd_time_top = 18,
  bnd_time_left = 122,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 53
  },
  bnd_time_text = "",
  bnd_time_fontSize = 16,
  bnd_time_fontColor = "0x000000",
  bnd_time_text_top = 1,
  bnd_time_text_left = -2,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 35,
  bnd_extraTime_height = 20,
  bnd_extraTime_top = 25.5,
  bnd_extraTime_left = 88.5,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 53
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 16,
  bnd_extraTime_fontColor = "0xFFFFFF",

  bnd_stat_visible = false,
  bnd_stat_width = 50,
  bnd_stat_height = 70,
  bnd_stat_top = 0,
  bnd_stat_left = 260,
  bnd_stat_color = "0x04D4D4",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 17,
  bnd_stat_fontColor = "0xFFFFFF",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = -18,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 0,
  bnd_away_stat_text_top = 18,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text_fontColor = "0x000000",
  bnd_stat_text = ""
}

local GermanyScore = {
  bnd_fontFace = "$Bundesliga",
  bnd_text_bold = false,
  bnd_width = 360,
  bnd_height = 70,
  bnd_top = 35,
  bnd_left = -15,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 46,
  bnd_logo_width = 55,
  bnd_logo_top = 12,
  bnd_logo_left = -30,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 19
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 70,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 25,
  bnd_homeRect_width = 55,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 70,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -80,
  bnd_awayRect_width = 55,

  bnd_homeBg_visible = false,
  bnd_homeBg_width = 55,
  bnd_homeBg_left = 25,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 19
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 55,
  bnd_awayBg_right = -80,
  bnd_awayBg_height = 70,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 19
  },
  bnd_scoreBg_width = 150,
  bnd_scoreBg_height = 70,
  bnd_scoreBg_right = -8000,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 19
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 24,
  bnd_homeName_top = -20,
  bnd_homeName_fontSize = 18,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = -20,
  bnd_awayName_fontSize = 18,
  bnd_awayName_fontColor = "0xFFFFFF",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  bnd_homeScore_text = "",
  bnd_homeScore_top = 10,
  bnd_homeScore_left = 23,
  bnd_homeScore_fontSize = 30,
  bnd_homeScore_fontColor = "0xCDFB0A",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 10,
  bnd_awayScore_right = -79,
  bnd_awayScore_fontSize = 30,
  bnd_awayScore_fontColor = "0xCDFB0A",
  bnd_score_text = "-",
  bnd_score_top = 1.25,
  bnd_score_left = -15000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x34003A",

  bnd_time_width = 55.5,
  bnd_time_height = 24,
  bnd_time_top = -23,
  bnd_time_left = 122,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 19
  },
  bnd_time_text = "",
  bnd_time_fontSize = 14,
  bnd_time_fontColor = "0xFFFFFF",
  bnd_time_text_top = 0,
  bnd_time_text_left = -1,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 30,
  bnd_extraTime_height = 23,
  bnd_extraTime_top = -23.5,
  bnd_extraTime_left = 92,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 19
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 14,
  bnd_extraTime_fontColor = "0x34003a",

  bnd_stat_visible = false,
  bnd_stat_width = 165,
  bnd_stat_height = 40,
  bnd_stat_top = 60,
  bnd_stat_left = 122,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 18,
  bnd_stat_fontColor = "0x34003a",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 55,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = -54,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text = ""
}

local Germany2Score = {
  bnd_fontFace = "$Bundesliga",
  bnd_text_bold = false,
  bnd_width = 360,
  bnd_height = 70,
  bnd_top = 35,
  bnd_left = -15,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 46,
  bnd_logo_width = 55,
  bnd_logo_top = 12,
  bnd_logo_left = -30,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 19
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 70,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 25,
  bnd_homeRect_width = 55,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 70,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -80,
  bnd_awayRect_width = 55,

  bnd_homeBg_visible = false,
  bnd_homeBg_width = 55,
  bnd_homeBg_left = 25,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 20
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 55,
  bnd_awayBg_right = -80,
  bnd_awayBg_height = 70,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 20
  },
  bnd_scoreBg_width = 150,
  bnd_scoreBg_height = 70,
  bnd_scoreBg_right = -8000,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 19
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 24,
  bnd_homeName_top = -20,
  bnd_homeName_fontSize = 18,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = -20,
  bnd_awayName_fontSize = 18,
  bnd_awayName_fontColor = "0xFFFFFF",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  bnd_homeScore_text = "",
  bnd_homeScore_top = 10,
  bnd_homeScore_left = 23,
  bnd_homeScore_fontSize = 30,
  bnd_homeScore_fontColor = "0xCDFB0A",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 10,
  bnd_awayScore_right = -79,
  bnd_awayScore_fontSize = 30,
  bnd_awayScore_fontColor = "0xCDFB0A",
  bnd_score_text = "-",
  bnd_score_top = 1.25,
  bnd_score_left = -15000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x34003A",

  bnd_time_width = 55.5,
  bnd_time_height = 24,
  bnd_time_top = -23,
  bnd_time_left = 122,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 19
  },
  bnd_time_text = "",
  bnd_time_fontSize = 14,
  bnd_time_fontColor = "0xFFFFFF",
  bnd_time_text_top = 0,
  bnd_time_text_left = -1,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 30,
  bnd_extraTime_height = 23,
  bnd_extraTime_top = -23.5,
  bnd_extraTime_left = 92,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 19
  },
   bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 14,
  bnd_extraTime_fontColor = "0x34003a",

  bnd_stat_visible = false,
  bnd_stat_width = 165,
  bnd_stat_height = 40,
  bnd_stat_top = 60,
  bnd_stat_left = 122,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 18,
  bnd_stat_fontColor = "0x34003a",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 55,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = -54,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text = ""
}

local FranceScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 55,
  bnd_top = 40,
  bnd_left = 95,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_top = 0,
  bnd_logo_left = -235,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 16
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 27,
  bnd_homeRect_top = -14,
  bnd_homeRect_left = -122,
  bnd_homeRect_width = 7,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 27,
  bnd_awayRect_top = 14,
  bnd_awayRect_right = 122,
  bnd_awayRect_width = 7,

  bnd_homeBg_visible = false,
  bnd_homeBg_width = 90,
  bnd_homeBg_left = -170,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 16
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_right = 150,
  bnd_awayBg_height = 60,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 16
  },
  bnd_scoreBg_width = 35,
  bnd_scoreBg_height = 32,
  bnd_scoreBg_right = 105,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 16
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -183,
  bnd_homeName_top = -14,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = 183,
  bnd_awayName_top = 14,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",
  bnd_homeCrest = {
    name = "$CrestOff",
    id = 0
  },
  bnd_homeCrest_left = -210,
  bnd_homeCrest_top = -14,
  bnd_homeCrest_width = 25,
  bnd_homeCrest_height = 25,
  bnd_awayCrest = {
    name = "$CrestOff",
    id = 0
  },
  bnd_awayCrest_right = 210,
  bnd_awayCrest_top = 14,
  bnd_awayCrest_width = 25,
  bnd_awayCrest_height = 25,

  bnd_homeScore_text = "",
  bnd_homeScore_top = -14,
  bnd_homeScore_left = -142,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0xffffff",

  bnd_awayScore_text = "",
  bnd_awayScore_top = 14,
  bnd_awayScore_right = 142,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "",
  bnd_score_top = 0.5,
  bnd_score_left = -3000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 55,
  bnd_time_height = 25,
  bnd_time_top = 40,
  bnd_time_left = -42,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 16
  },
  bnd_time_text = "",
  bnd_time_fontSize = 15,
  bnd_time_fontColor = "0x00000",
  bnd_time_text_left = 0,
  bnd_time_text_top = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 30,
  bnd_extraTime_height = 25,
  bnd_extraTime_top = 40,
  bnd_extraTime_left = 15,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 16
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 15,
  bnd_extraTime_fontColor = "0xFFFFFF",
  
  bnd_stat_visible = false,
  bnd_stat_width = 45,
  bnd_stat_height = 55,
  bnd_stat_top = 0.5,
  bnd_stat_left = 102,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 16,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = -17,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 0,
  bnd_away_stat_text_top = 17,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text = ""
}

local ItalyScore = {
  bnd_fontFace = "$SerieA",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 55,
  bnd_top = 38,
  bnd_left = -15,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 100,
  bnd_logo_width = 100,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 31
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 201,
  bnd_homeBg_left = 40,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 31
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 130,
  bnd_awayBg_right = -80,
  bnd_awayBg_height = 38,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 31
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 38,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 31
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -22,
  bnd_homeName_top = -4,
  bnd_homeName_fontSize = 22,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -97,
  bnd_awayName_top = -4,
  bnd_awayName_fontSize = 22,
  bnd_awayName_fontColor = "0xFFFFFF",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,

  bnd_homeScore_text = "",
  bnd_homeScore_top = -4,
  bnd_homeScore_left = 25,
  bnd_homeScore_fontSize = 22,
  bnd_homeScore_fontColor = "0x221B68",

  bnd_awayScore_text = "",
  bnd_awayScore_top = -4,
  bnd_awayScore_right = -51,
  bnd_awayScore_fontSize = 22,
  bnd_awayScore_fontColor = "0x221B68",

  bnd_score_text = "-",
  bnd_score_top = -4,
  bnd_score_left = 38,
  bnd_score_fontSize = 18,
  bnd_score_fontColor = "0x221B68",

  bnd_time_width = 146,
  bnd_time_height = 55,
  bnd_time_top = 0,
  bnd_time_left = 46,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 31
  },
  bnd_time_text = "",
  bnd_time_fontSize = 19,
  bnd_time_fontColor = "0x221B68",
  bnd_time_text_left = 8,
  bnd_time_text_top = -4,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 52,
  bnd_extraTime_height = 55,
  bnd_extraTime_top = 0,
  bnd_extraTime_left = 345,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 31
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 19,
  bnd_extraTime_fontColor = "0x000000",

  bnd_stat_visible = false,
  bnd_stat_width = 185,
  bnd_stat_height = 40,
  bnd_stat_top = 32,
  bnd_stat_left = 159,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 18,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -65,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 65,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local BrazilScore = {
  bnd_fontFace = "$Brasil-Sportv",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 85,
  bnd_top = 28,
  bnd_left = 60,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 100,
  bnd_logo_width = 100,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 7
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 34.95,
  bnd_homeRect_top = -18.5,
  bnd_homeRect_left = -210,
  bnd_homeRect_width = 14,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 34.95,
  bnd_awayRect_top = 17.9,
  bnd_awayRect_right = 210,
  bnd_awayRect_width = 14,

  bnd_homeBg_visible = false,
  bnd_homeBg_width = 135,
  bnd_homeBg_left = -150,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 7
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 120,
  bnd_awayBg_right = 150,
  bnd_awayBg_height = 39,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 7
  },
  bnd_scoreBg_width = 35,
  bnd_scoreBg_height = 32,
  bnd_scoreBg_right = 105,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 7
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -170,
  bnd_homeName_top = -17,
  bnd_homeName_fontSize = 26,
  bnd_homeName_fontColor = "0x0B2161",
  bnd_awayName_text = "",
  bnd_awayName_right = 170,
  bnd_awayName_top = 19,
  bnd_awayName_fontSize = 26,
  bnd_awayName_fontColor = "0x0B2161",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 50,
  bnd_homeCrest_height = 50,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 50,
  bnd_awayCrest_height = 50,

  bnd_homeScore_text = "",
  bnd_homeScore_top = -18,
  bnd_homeScore_left = -114,
  bnd_homeScore_fontSize = 27,
  bnd_homeScore_fontColor = "0x00FFFF",

  bnd_awayScore_text = "",
  bnd_awayScore_top = 18,
  bnd_awayScore_right = 114,
  bnd_awayScore_fontSize = 27,
  bnd_awayScore_fontColor = "0x00FFFF",

  bnd_score_text = "-",
  bnd_score_top = 0.5,
  bnd_score_left = -3000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x221B68",

  bnd_time_width = 123.4,
  bnd_time_height = 34,
  bnd_time_top = 54.9,
  bnd_time_left = 3.4,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 7
  },
  bnd_time_text = "",
  bnd_time_fontSize = 22,
  bnd_time_fontColor = "0x0B2161",
  bnd_time_text_left = 12,
  bnd_time_text_top = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 45,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 54.9,
  bnd_extraTime_left = 127,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 7
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 25,
  bnd_extraTime_fontColor = "0x0B2161",
  
  bnd_stat_visible = false,
  bnd_stat_width = 45,
  bnd_stat_height = 72,
  bnd_stat_top = 0,
  bnd_stat_left = 127,
  bnd_stat_color = "0x0B173B",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 18,
  bnd_stat_fontColor = "0x00FFFF",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = -19,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 0,
  bnd_away_stat_text_top = 20,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text = ""
}

local BrazilGloboScore = {
  bnd_fontFace = "$Brasil-Globo",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 65,
  bnd_left = -35,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 45,
  bnd_logo_width = 215.1,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = "7_1"
  },

  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 45,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -54.7,
  bnd_homeRect_width = 105,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 45,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -54.7,
  bnd_awayRect_width = 105,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 80,
  bnd_homeBg_left = -78,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home1",
    id = "7_1"
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 80,
  bnd_awayBg_right = -78,
  bnd_awayBg_height = 30,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = "7_1"
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 30,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = "7_1"
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -76,
  bnd_homeName_top = 1.5,
  bnd_homeName_fontSize = 24,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -70,
  bnd_awayName_top = 1.5,
  bnd_awayName_fontSize = 24,
  bnd_awayName_fontColor = "0xFFFFFF",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  
  bnd_homeScore_text = "",
  bnd_homeScore_top = 3,
  bnd_homeScore_left = -26,
  bnd_homeScore_fontSize = 46,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 3,
  bnd_awayScore_right = -22,
  bnd_awayScore_fontSize = 46,
  bnd_awayScore_fontColor = "0xffffff",
  
  bnd_score_text = "",
  bnd_score_top = 1.25,
  bnd_score_left = -1.5,
  bnd_score_fontSize = 25,
  bnd_score_fontColor = "0x34003A",
  
  bnd_time_width = 120,
  bnd_time_height = 29,
  bnd_time_top = -42,
  bnd_time_left = 178,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = "7_1"
  },
  bnd_time_text = "",
  bnd_time_fontSize = 25,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 1.7,
  bnd_time_text_left = 15,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 29,
  bnd_extraTime_height = 29,
  bnd_extraTime_top = -42,
  bnd_extraTime_left = 295,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = "7_1"
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0x000000",
  
  bnd_stat_visible = false,
  bnd_stat_width = 215,
  bnd_stat_height = 40,
  bnd_stat_top = 45,
  bnd_stat_left = 132,
  bnd_stat_color = "0x000000",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 18,
  bnd_stat_fontColor = "0xBCFF79",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local BrazilAmazonScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 65,
  bnd_top = 35,
  bnd_left = -35,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 75,
  bnd_logo_width = 190,
  bnd_logo_top = 15,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = "7_2"
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 34,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -75,
  bnd_homeRect_width = 80,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 34,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -75,
  bnd_awayRect_width = 80,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 250,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home1",
    id = "7_2"
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = "7_2"
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = "7_2"
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -89,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 23,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -85,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 23,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -34,
  bnd_homeScore_fontSize = 23,
  bnd_homeScore_fontColor = "0xFFFFFF",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -30,
  bnd_awayScore_fontSize = 23,
  bnd_awayScore_fontColor = "0xFFFFFF",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 80,
  bnd_time_height = 34,
  bnd_time_top = 34,
  bnd_time_left = 177,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time1",
    id = "7_2"
  },
  bnd_time_text = "",
  bnd_time_fontSize = 18,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 68,
  bnd_extraTime_left = 180,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = "7_2"
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xFFFFFF",
  bnd_stat_visible = false,
  bnd_stat_width = 230,
  bnd_stat_height = 55,
  bnd_stat_top = 44,
  bnd_stat_left = 105,
  bnd_stat_color = "0x000000",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xFFFFFF",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 15,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local MexicoScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 80,
  bnd_top = 35,
  bnd_left = 20,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 25,
  bnd_logo_width = 125,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 341
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "0x0025FF",
  bnd_homeRect_height = 30,
  bnd_homeRect_top = -8,
  bnd_homeRect_left = -113,
  bnd_homeRect_width = 7,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "0xFF1100",
  bnd_awayRect_height = 30,
  bnd_awayRect_top = -8,
  bnd_awayRect_right = -121,
  bnd_awayRect_width = 7,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 288,
  bnd_homeBg_left = -20,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 341
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 341
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 341
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -75,
  bnd_homeName_top = -7,
  bnd_homeName_fontSize = 25,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = -7,
  bnd_awayName_fontSize = 25,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = -7,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 25,
  bnd_homeScore_fontColor = "0x0F2F68",
  bnd_awayScore_text = "",
  bnd_awayScore_top = -7,
  bnd_awayScore_right = -21,
  bnd_awayScore_fontSize = 25,
  bnd_awayScore_fontColor = "0x0F2F68",

  bnd_score_text = "-",
  bnd_score_top = -7,
  bnd_score_left = 3,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x0F2F68",

  bnd_time_width = 190,
  bnd_time_height = 80,
  bnd_time_top = 0,
  bnd_time_left = 344,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 341
  },
  bnd_time_text = "",
  bnd_time_fontSize = 25,
  bnd_time_fontColor = "0x0F2F68",
  bnd_time_text_top = -7,
  bnd_time_text_left = -49,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 95,
  bnd_extraTime_height = 32,
  bnd_extraTime_top = 24,
  bnd_extraTime_left = 345,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 341
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0x1E324C",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 30,
  bnd_stat_top = 58,
  bnd_stat_left = 105,
  bnd_stat_color = "0x000000",
  bnd_stat_alpha = 0.4,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -70,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 70,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local ArgentinaScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 33,
  bnd_left = -10,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 30,
  bnd_logo_width = 30,
  bnd_logo_top = 0,
  bnd_logo_left = -123,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 353
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 30,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -100,
  bnd_homeRect_width = 8,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 30,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -110,
  bnd_awayRect_width = 8,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 210,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 353
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 353
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 353
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -68,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 22,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -73,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 22,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -17,
  bnd_homeScore_fontSize = 22,
  bnd_homeScore_fontColor = "0x58F4E9",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -25,
  bnd_awayScore_fontSize = 22,
  bnd_awayScore_fontColor = "0x58F4E9",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = 0,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 110,
  bnd_time_height = 30,
  bnd_time_top = 0,
  bnd_time_left = 338,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 353
  },
  bnd_time_text = "",
  bnd_time_fontSize = 22,
  bnd_time_fontColor = "0x000000",
  bnd_time_text_top = 0,
  bnd_time_text_left = 15,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 79,
  bnd_extraTime_height = 30,
  bnd_extraTime_top = 30,
  bnd_extraTime_left = 368.5,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 353
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 22,
  bnd_extraTime_fontColor = "0x58F4E9",
  bnd_stat_visible = false,
  bnd_stat_width = 210,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 120,
  bnd_stat_color = "0xffffff",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -70,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 70,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local IndonesiaScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 48,
  bnd_left = -25,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 46,
  bnd_logo_width = 196,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2235
  },

  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 31,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -58,
  bnd_homeRect_width = 135,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 31,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -58,
  bnd_awayRect_width = 135,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 80,
  bnd_homeBg_left = -78,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home1",
    id = 2235
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 80,
  bnd_awayBg_right = -78,
  bnd_awayBg_height = 30,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 2235
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 30,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 2235
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -90,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 24,
  bnd_homeName_fontColor = "",
  bnd_awayName_text = "",
  bnd_awayName_right = -84,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 24,
  bnd_awayName_fontColor = "",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  bnd_homeScore_text = "",
  bnd_homeScore_top = -4,
  bnd_homeScore_left = -34,
  bnd_homeScore_fontSize = 43,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = -4,
  bnd_awayScore_right = -30,
  bnd_awayScore_fontSize = 43,
  bnd_awayScore_fontColor = "0xffffff",
  bnd_score_text = "",
  bnd_score_top = 1.25,
  bnd_score_left = -1.5,
  bnd_score_fontSize = 25,
  bnd_score_fontColor = "0x34003A",
  bnd_time_width = 88,
  bnd_time_height = 34,
  bnd_time_top = 28.3,
  bnd_time_left = 195,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2235
  },
  bnd_time_text = "",
  bnd_time_fontSize = 15,
  bnd_time_fontColor = "0x3D5290",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 34,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 28.3,
  bnd_extraTime_left = 270,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2235
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 17,
  bnd_extraTime_fontColor = "0xffffff",
  
  bnd_stat_visible = false,
  bnd_stat_width = 250,
  bnd_stat_height = 55,
  bnd_stat_top = 40,
  bnd_stat_left = 115.6,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x3D5290",
  bnd_home_stat_text_left = -85,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 85,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 15,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local SaudiArabiaScore = {
  bnd_fontFace = "$PremierLeague",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 48,
  bnd_left = -15,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 40,
  bnd_logo_width = 125,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 350
  },

  bnd_cornerRaduis = 4,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 26,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -61,
  bnd_homeRect_width = 140,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 26,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -61,
  bnd_awayRect_width = 140,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 80,
  bnd_homeBg_left = -78,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home1",
    id = 350
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 80,
  bnd_awayBg_right = -78,
  bnd_awayBg_height = 30,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 350
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 30,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 350
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -76,
  bnd_homeName_top = 0.5,
  bnd_homeName_fontSize = 23,
  bnd_homeName_fontColor = "",
  bnd_awayName_text = "",
  bnd_awayName_right = -76,
  bnd_awayName_top = 0.5,
  bnd_awayName_fontSize = 23,
  bnd_awayName_fontColor = "",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -118,
  bnd_homeCrest_width = 23,
  bnd_homeCrest_height = 23,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -118,
  bnd_awayCrest_width = 23,
  bnd_awayCrest_height = 23,
  bnd_homeScore_text = "",
  bnd_homeScore_top = -2,
  bnd_homeScore_left = -34,
  bnd_homeScore_fontSize = 41,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = -2,
  bnd_awayScore_right = -31.5,
  bnd_awayScore_fontSize = 41,
  bnd_awayScore_fontColor = "0xffffff",
  bnd_score_text = "",
  bnd_score_top = 1.25,
  bnd_score_left = -1.5,
  bnd_score_fontSize = 25,
  bnd_score_fontColor = "0x34003A",
  bnd_time_width = 105,
  bnd_time_height = 36,
  bnd_time_top = 22.5,
  bnd_time_left = 187.3,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 350
  },
  bnd_time_text = "",
  bnd_time_fontSize = 15,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 105,
  bnd_extraTime_height = 15,
  bnd_extraTime_top = 40,
  bnd_extraTime_left = 187.3,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 350
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 15,
  bnd_extraTime_fontColor = "0xffffff",
  
  bnd_stat_visible = false,
  bnd_stat_width = 260,
  bnd_stat_height = 55,
  bnd_stat_top = 40,
  bnd_stat_left = 110,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x00052E",
  bnd_home_stat_text_left = -85,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 85,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 15,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local WomensSuperLeagueScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 45,
  bnd_top = 38,
  bnd_left = -70,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 100,
  bnd_logo_width = 100,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2216
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 140,
  bnd_homeBg_left = 0,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2216
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 120,
  bnd_awayBg_right = -91,
  bnd_awayBg_height = 45,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2216
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 30,
  bnd_scoreBg_right = -11180,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2216
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 0,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 25,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -120,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 25,
  bnd_awayName_fontColor = "0xFFFFFF",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = 45,
  bnd_homeScore_fontSize = 25,
  bnd_homeScore_fontColor = "0xffffff",

  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -80,
  bnd_awayScore_fontSize = 25,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "",
  bnd_score_top = 0.5,
  bnd_score_left = -15,
  bnd_score_fontSize = 25,
  bnd_score_fontColor = "0x221B68",

  bnd_time_width = 100,
  bnd_time_height = 35,
  bnd_time_top = 0,
  bnd_time_left = 365,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2216
  },
  bnd_time_text = "",
  bnd_time_fontSize = 25,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_left = 2,
  bnd_time_text_top = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 50,
  bnd_extraTime_height = 44,
  bnd_extraTime_top = 25,
  bnd_extraTime_left = 365,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2216
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 19,
  bnd_extraTime_fontColor = "0xFFFFFF"
}

local UnitedStatesScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 28,
  bnd_top = 35,
  bnd_left = 90,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 25,
  bnd_logo_width = 125,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 39
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 28,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -106,
  bnd_homeRect_width = 23,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 28,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -114,
  bnd_awayRect_width = 23,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 39
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 39
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 39
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -60,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0x000000",
  bnd_awayName_text = "",
  bnd_awayName_right = -69,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0x000000",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -21,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0x000000",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = -1,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x000000",

  bnd_time_width = 90,
  bnd_time_height = 28,
  bnd_time_top = 0,
  bnd_time_left = 8,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 39
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 90,
  bnd_extraTime_height = 28,
  bnd_extraTime_top = 33,
  bnd_extraTime_left = 8,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 39
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xffffff",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 50,
  bnd_stat_top = 40,
  bnd_stat_left = 105,
  bnd_stat_color = "0xffffff",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local RussiaScore = {
  bnd_fontFace = "$Russian",
  bnd_text_bold = false,
  bnd_width = 375,
  bnd_height = 55,
  bnd_top = 38,
  bnd_left = 45,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 75,
  bnd_logo_width = 85,
  bnd_logo_top = 0,
  bnd_logo_left = 61,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 67
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 10,
  bnd_homeRect_top = -3.6,
  bnd_homeRect_left = -57,
  bnd_homeRect_width = 10,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 10,
  bnd_awayRect_top = -3.6,
  bnd_awayRect_right = -172,
  bnd_awayRect_width = 10,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 265,
  bnd_homeBg_left = 58,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 67
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 120,
  bnd_awayBg_right = -152,
  bnd_awayBg_height = 42,
  bnd_awayBg_top= -1,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 67
  },
  bnd_scoreBg_width = 140,
  bnd_scoreBg_height = 31,
  bnd_scoreBg_right = -60,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 67
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -30,
  bnd_homeName_top = -3.9,
  bnd_homeName_fontSize = 16,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -144,
  bnd_awayName_top = -3.9,
  bnd_awayName_fontSize = 16,
  bnd_awayName_fontColor = "0xffffff",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -11140,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -11140,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,

  bnd_homeScore_text = "",
  bnd_homeScore_top = -3.9,
  bnd_homeScore_left = 18,
  bnd_homeScore_fontSize = 23,
  bnd_homeScore_fontColor = "0x1E1E1E",

  bnd_awayScore_text = "",
  bnd_awayScore_top = -3.9,
  bnd_awayScore_right = -97,
  bnd_awayScore_fontSize = 23,
  bnd_awayScore_fontColor = "0x1E1E1E",

  bnd_score_text = "АвторМодаTelegramFIFA16mobileRPL",
  bnd_score_top = -35,
  bnd_score_left = 910,
  bnd_score_fontSize = 18,
  bnd_score_fontColor = "0xffffff",
    
  bnd_time_width = 90,
  bnd_time_height = 20,
  bnd_time_top = 30,
  bnd_time_left = 188,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 67
  },
  bnd_time_text = "",
  bnd_time_fontSize = 18,
  bnd_time_fontColor = "0x1E1E1E",
  bnd_time_text_left = 0,
  bnd_time_text_top = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 30,
  bnd_extraTime_height = 20,
  bnd_extraTime_top = 30,
  bnd_extraTime_left = 265,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 67
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 18,
  bnd_extraTime_fontColor = "0xFFFFFF",
  
  bnd_stat_visible = false,
  bnd_stat_width = 248,
  bnd_stat_height = 50,
  bnd_stat_top = 38,
  bnd_stat_left = 109,
  bnd_stat_color = "0xC4C8CC",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x1E1E1E",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 13,
  bnd_stat_text_fontSize = 15,
  bnd_stat_text = ""
}

local LeaguePariScore = {
  bnd_fontFace = "$KnulExtraBold",
  bnd_text_bold = true,
  bnd_width = 360,
  bnd_height = 70,
  bnd_top = 35,
  bnd_left = -15,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 70,
  bnd_logo_width = 176,
  bnd_logo_top = 0,
  bnd_logo_left = 23,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2245
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 70,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 24,
  bnd_homeRect_width = 60,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 70,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -81,
  bnd_awayRect_width = 60,

  bnd_homeBg_visible = false,
  bnd_homeBg_width = 176,
  bnd_homeBg_left = 25,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home1",
    id = 2245
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 55,
  bnd_awayBg_right = -80,
  bnd_awayBg_height = 70,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 2245
  },
  bnd_scoreBg_width = 150,
  bnd_scoreBg_height = 70,
  bnd_scoreBg_right = -8000,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 2245
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 22,
  bnd_homeName_top = -23,
  bnd_homeName_fontSize = 18,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = -23,
  bnd_awayName_fontSize = 18,
  bnd_awayName_fontColor = "0xFFFFFF",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  bnd_homeScore_text = "",
  bnd_homeScore_top = 10,
  bnd_homeScore_left = 22,
  bnd_homeScore_fontSize = 35,
  bnd_homeScore_fontColor = "0xFFFFFF",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 10,
  bnd_awayScore_right = -79,
  bnd_awayScore_fontSize = 35,
  bnd_awayScore_fontColor = "0xFFFFFF",
  bnd_score_text = "-",
  bnd_score_top = 1.25,
  bnd_score_left = -15000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x34003A",

  bnd_time_width = 57.5,
  bnd_time_height = 20,
  bnd_time_top = 24,
  bnd_time_left = 116,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time1",
    id = 2245
  },
  bnd_time_text = "",
  bnd_time_fontSize = 14,
  bnd_time_fontColor = "0x00D2BC",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 57.5,
  bnd_extraTime_height = 20,
  bnd_extraTime_top = 24,
  bnd_extraTime_left = 116,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2245
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 14,
  bnd_extraTime_fontColor = "0x000E08",

  bnd_stat_visible = false,
  bnd_stat_width = 176,
  bnd_stat_height = 40,
  bnd_stat_top = 57,
  bnd_stat_left = 115,
  bnd_stat_color = "0x000E08",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 18,
  bnd_stat_fontColor = "0x00D2BC",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 55,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = -54,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text = ""
}

local UkraineScore = {
  bnd_text_bold = false,
  bnd_width = 360,
  bnd_height = 70,
  bnd_top = 35,
  bnd_left = 10,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 70,
  bnd_logo_width = 70,
  bnd_logo_top = 0,
  bnd_logo_left = -58,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 332
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 37,
  bnd_homeRect_top = -17,
  bnd_homeRect_left = 47,
  bnd_homeRect_width = 4,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 37,
  bnd_awayRect_top = 17,
  bnd_awayRect_right = -47,
  bnd_awayRect_width = 4,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 107,
  bnd_homeBg_left = 30,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 332
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 90,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away2",
    id = 332
  },
  bnd_scoreBg_width = 85,
  bnd_scoreBg_height = 80,
  bnd_scoreBg_right = -40,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 332
  },
  bnd_homeName_text = "",
  bnd_homeName_left = 9,
  bnd_homeName_top = -17,
  bnd_homeName_fontSize = 24,
  bnd_homeName_fontColor = "0x000000",
  bnd_awayName_text = "",
  bnd_awayName_right = -9,
  bnd_awayName_top = 18,
  bnd_awayName_fontSize = 24,
  bnd_awayName_fontColor = "0x000000",
  
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  
  bnd_homeScore_text = "",
  bnd_homeScore_top = -17,
  bnd_homeScore_left = 64,
  bnd_homeScore_fontSize = 24,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 18,
  bnd_awayScore_right = -64,
  bnd_awayScore_fontSize = 24,
  bnd_awayScore_fontColor = "0xffffff",
  
  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = -15000,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x34003A",

  bnd_time_width = 70,
  bnd_time_height = 70,
  bnd_time_top = 0,
  bnd_time_left = 87,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 332
  },
  bnd_time_text = "",
  bnd_time_fontSize = 23,
  bnd_time_fontColor = "0x000000",
  bnd_time_text_top = 17,
  bnd_time_text_left = -2,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 70,
  bnd_extraTime_height = 30,
  bnd_extraTime_top = 50,
  bnd_extraTime_left = 87,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 332
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 24,
  bnd_extraTime_fontColor = "0x000000",

  bnd_stat_visible = false,
  bnd_stat_width = 70,
  bnd_stat_height = 70,
  bnd_stat_top = 0,
  bnd_stat_left = 265,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 17,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = -18,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 0,
  bnd_away_stat_text_top = 18,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text_fontColor = "0x000000",
  bnd_stat_text = ""
}

local InternationalScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 64,
  bnd_top = 28,
  bnd_left = 55,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 100,
  bnd_logo_width = 100,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 78
  },
  bnd_homeBg_visible = true,
  bnd_homeBg_width = 120,
  bnd_homeBg_left = -82,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 78
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 176,
  bnd_awayBg_height = 29,
  bnd_awayBg_right = 130,
  bnd_awayBg_top = -29,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 78
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "0xFFFFFF",
  bnd_homeRect_height = 42,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -14,
  bnd_homeRect_width = 44,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "0xFFFFFF",
  bnd_awayRect_height = 42,
  bnd_awayRect_top = 43,
  bnd_awayRect_right = 14,
  bnd_awayRect_width = 44,
  
  bnd_scoreBg_width = 36,
  bnd_scoreBg_height = 64,
  bnd_scoreBg_right = 25,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 78
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -80,
  bnd_homeName_top = -17,
  bnd_homeName_fontSize = 25,
  bnd_homeName_fontColor = "0x000000",
  bnd_awayName_text = "",
  bnd_awayName_right = 80,
  bnd_awayName_top = 16,
  bnd_awayName_fontSize = 24,
  bnd_awayName_fontColor = "0x000000",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -120,
  bnd_homeCrest_top = -17,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = 120,
  bnd_awayCrest_top = 16,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,

  bnd_homeScore_text = "",
  bnd_homeScore_top = -17,
  bnd_homeScore_left = -26,
  bnd_homeScore_fontSize = 26,
  bnd_homeScore_fontColor = "0xFFFFFF",

  bnd_awayScore_text = "",
  bnd_awayScore_top = 16,
  bnd_awayScore_right = 26,
  bnd_awayScore_fontSize = 26,
  bnd_awayScore_fontColor = "0xFFFFFF",

  bnd_score_text = "International",
  bnd_score_top = -46,
  bnd_score_left = -167,
  bnd_score_fontSize = 15,
  bnd_score_fontColor = "0xFFFFFF",

  bnd_time_width = 75,
  bnd_time_height = 34,
  bnd_time_top = -15,
  bnd_time_left = 3,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 78
  },
  bnd_time_text = "",
  bnd_time_fontSize = 23,
  bnd_time_fontColor = "0x000000",
  bnd_time_text_left = 0,
  bnd_time_text_top = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 75,
  bnd_extraTime_height = 32,
  bnd_extraTime_top = 16,
  bnd_extraTime_left = 3,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 78
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 23,
  bnd_extraTime_fontColor = "0x000000",
  
  bnd_stat_visible = false,
  bnd_stat_width = 60,
  bnd_stat_height = 64,
  bnd_stat_top = 0,
  bnd_stat_left = 214,
  bnd_stat_color = "0x000000",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 19,
  bnd_stat_fontColor = "0xFFFFFF",
  bnd_home_stat_text_left = 0,
  bnd_home_stat_text_top = -17,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 0,
  bnd_away_stat_text_top = 16,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = -40,
  bnd_stat_text_fontSize = 12,
  bnd_stat_text = ""
}

--------- Tournaments ---------

local UCLScore = {
  bnd_fontFace = "$UCL-Regular",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 34,
  bnd_top = 35,
  bnd_left = 90,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 25,
  bnd_logo_width = 125,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2236
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 34,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -115,
  bnd_homeRect_width = 8,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 34,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -125,
  bnd_awayRect_width = 8,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2236
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2236
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2236
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -75,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 24,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -84,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 24,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 24,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -23,
  bnd_awayScore_fontSize = 24,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = -1,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 116,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = -18,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2236
  },
  bnd_time_text = "",
  bnd_time_fontSize = 24,
  bnd_time_fontColor = "0x101010",
  bnd_time_text_top = 0,
  bnd_time_text_left = 15,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 60,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 36,
  bnd_extraTime_left = -18,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2236
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 24,
  bnd_extraTime_fontColor = "0x101010",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 105,
  bnd_stat_color = "0xffffff",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x010095",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local UELScore = {
  bnd_fontFace = "$UEL-Bold",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 35,
  bnd_left = 90,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 25,
  bnd_logo_width = 125,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2238
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2238
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away off",
    id = 2238
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score off",
    id = 2238
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -71,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 24,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -23,
  bnd_awayScore_fontSize = 24,
  bnd_awayScore_fontColor = "0x000000",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = -1,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 116,
  bnd_time_height = 30,
  bnd_time_top = 0,
  bnd_time_left = -11,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2238
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = -1,
  bnd_time_text_left = 15,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 36,
  bnd_extraTime_left = 15,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2238
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0x000000",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 105,
  bnd_stat_color = "0x000000",
  bnd_stat_alpha = 0.5,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local EuroCopaScore = {
  bnd_fontFace = "$UEFAEuro-Bold",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 38,
  bnd_left = 70,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 91,
  bnd_logo_width = 92,
  bnd_logo_top = 0,
  bnd_logo_left = -220,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2299
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 30,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -107,
  bnd_homeRect_width = 9,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 30,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -106,
  bnd_awayRect_width = 8,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 220,
  bnd_homeBg_left = 0,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2299
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 80,
  bnd_awayBg_height = 30,
  bnd_awayBg_right = -70,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 2299
  },
  bnd_scoreBg_width = 62,
  bnd_scoreBg_height = 30,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 2299
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -74,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 23,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -71,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 23,
  bnd_awayName_fontColor = "0xffffff",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -20000,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -20000,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -21.5,
  bnd_homeScore_fontSize = 23,
  bnd_homeScore_fontColor = "0x0101DF",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -19,
  bnd_awayScore_fontSize = 23,
  bnd_awayScore_fontColor = "0x0101DF",

  bnd_score_text = "",
  bnd_score_top = -1.5,
  bnd_score_left = 0,
  bnd_score_fontSize = 23,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 80,
  bnd_time_height = 30,
  bnd_time_top = 0,
  bnd_time_left = 30,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2299
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = -8,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 30,
  bnd_extraTime_top = 0,
  bnd_extraTime_left = 30,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2299
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xffffff",

  bnd_stat_visible = false,
  bnd_stat_width = 220,
  bnd_stat_height = 50,
  bnd_stat_top = 41,
  bnd_stat_left = 110,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 19,
  bnd_stat_fontColor = "0x0101DF",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local NationsScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 34,
  bnd_top = 35,
  bnd_left = 87,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 50,
  bnd_logo_width = 250,
  bnd_logo_top = -27,
  bnd_logo_left = -100,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2241
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 90,
  bnd_homeBg_left = -80,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2241
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2241
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2241
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -82,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0x000000",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0x000000",

  bnd_homeCrest = {
    name = "$NationalCrest",
    id = 0
  },
  bnd_homeCrest_left = -125,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$NationalCrest",
    id = 0
  },
  bnd_awayCrest_right = -125,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -22.5,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -19,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0x000000",

  bnd_score_text = "-",
  bnd_score_top = 0,
  bnd_score_left = -1,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x000000",

  bnd_time_width = 90,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = -10,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2241
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 90,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 34,
  bnd_extraTime_left = -10,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2241
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0x000000",
  bnd_stat_visible = false,
  bnd_stat_width = 250,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 95,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = "",
  bnd_stat_alpha = 1
}

local UefaWomensScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 38,
  bnd_top = 38,
  bnd_left = 95,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 100,
  bnd_logo_width = 100,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 2240
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 130,
  bnd_homeBg_left = -90,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2240
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 130,
  bnd_awayBg_height = 38,
  bnd_awayBg_right = -38,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2240
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 38,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2240
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -105,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 30,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -50,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 30,
  bnd_awayName_fontColor = "0xFFFFFF",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -50.5,
  bnd_homeScore_fontSize = 30,
  bnd_homeScore_fontColor = "0xFFFFFF",

  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = 8,
  bnd_awayScore_fontSize = 30,
  bnd_awayScore_fontColor = "0xFFFFFF",

  bnd_score_text = "",
  bnd_score_top = 0.5,
  bnd_score_left = -3,
  bnd_score_fontSize = 30,
  bnd_score_fontColor = "0x221B68",

  bnd_time_width = 95,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = -20,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2240
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0x221B68",
  bnd_time_text_left = 10,
  bnd_time_text_top = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 79,
  bnd_extraTime_height = 22,
  bnd_extraTime_top = 30,
  bnd_extraTime_left = -20,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2240
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 19,
  bnd_extraTime_fontColor = "0x000000",
  
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 50,
  bnd_stat_top = 37,
  bnd_stat_left = 76,
  bnd_stat_color = "0x4682B4",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xFFFFFF",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local UCLClassicScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 35,
  bnd_left = 90,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 25,
  bnd_logo_width = 125,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 22366
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 22366
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 22366
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 22366
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -76,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 25,
  bnd_homeName_fontColor = "0x0B3861",
  bnd_awayName_text = "",
  bnd_awayName_right = -86,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 25,
  bnd_awayName_fontColor = "0x0B3861",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 25,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -23,
  bnd_awayScore_fontSize = 25,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "-",
  bnd_score_top = 0,
  bnd_score_left = 3,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 116,
  bnd_time_height = 30,
  bnd_time_top = 0,
  bnd_time_left = -11,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 22366
  },
  bnd_time_text = "",
  bnd_time_fontSize = 23,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 15,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 30,
  bnd_extraTime_top = 31,
  bnd_extraTime_left = 21,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 22366
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0x101010",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 105,
  bnd_stat_color = "0x0B3861",
  bnd_stat_alpha = 0.5,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local LibertadoresScore = {
  bnd_fontFace = "$Libertadores",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 34,
  bnd_top = 35,
  bnd_left = 95,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 42,
  bnd_logo_width = 42,
  bnd_logo_top = 0,
  bnd_logo_left = -218,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2237
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 3,
  bnd_homeRect_top = 16,
  bnd_homeRect_left = -75,
  bnd_homeRect_width = 80,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 3,
  bnd_awayRect_top = 16,
  bnd_awayRect_right = -85,
  bnd_awayRect_width = 80,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2237
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2237
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2237
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -77,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -83,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -23,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "-",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 80,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = 25,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2237
  },
  bnd_time_text = "",
  bnd_time_fontSize = 22,
  bnd_time_fontColor = "0x101010",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 37,
  bnd_extraTime_left = 25,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2237
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xFFFFFF",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 40,
  bnd_stat_top = 40,
  bnd_stat_left = 105,
  bnd_stat_color = "0x000000",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local SudamericanaScore = {
  bnd_fontFace = "$Libertadores",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 34,
  bnd_top = 35,
  bnd_left = 75,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 42,
  bnd_logo_width = 42,
  bnd_logo_top = 0,
  bnd_logo_left = -218,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2267
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 3,
  bnd_homeRect_top = 16,
  bnd_homeRect_left = -75,
  bnd_homeRect_width = 80,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 3,
  bnd_awayRect_top = 16,
  bnd_awayRect_right = -85,
  bnd_awayRect_width = 80,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2267
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2267
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2267
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -77,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -83,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -23,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "-",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 80,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = 25,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2267
  },
  bnd_time_text = "",
  bnd_time_fontSize = 22,
  bnd_time_fontColor = "0x101010",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 37,
  bnd_extraTime_left = 25,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2267
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0x000000",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 40,
  bnd_stat_top = 40,
  bnd_stat_left = 105,
  bnd_stat_color = "0x000834",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local CopaAmericaScore = {
  bnd_fontFace = "$CopaAmerica",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 40,
  bnd_top = 35,
  bnd_left = 25,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 34,
  bnd_logo_width = 34,
  bnd_logo_top = 0,
  bnd_logo_left = -136,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2298
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 29,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -131,
  bnd_homeRect_width = 5,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 29,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -141,
  bnd_awayRect_width = 5,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 275,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2298
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 30,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2298
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 30,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2298
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -95,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 24,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -101,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 24,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -43,
  bnd_homeScore_fontSize = 24,
  bnd_homeScore_fontColor = "0x083C65",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -50,
  bnd_awayScore_fontSize = 24,
  bnd_awayScore_fontColor = "0x083C65",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 130,
  bnd_time_height = 30,
  bnd_time_top = 31,
  bnd_time_left = 160,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2298
  },
  bnd_time_text = "",
  bnd_time_fontSize = 24,
  bnd_time_fontColor = "0x083C65",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 50,
  bnd_extraTime_height = 30,
  bnd_extraTime_top = 31,
  bnd_extraTime_left = 267,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2298
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xffffff",
  bnd_stat_visible = false,
  bnd_stat_width = 265,
  bnd_stat_height = 50,
  bnd_stat_top = 41,
  bnd_stat_left = 92,
  bnd_stat_color = "0xffffff",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x083C65",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 16,
  bnd_stat_text_fontSize = 17,
  bnd_stat_text = ""
}

local WorldCupScore = {
  bnd_fontFace = "$Anybody-Bold",
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 40,
  bnd_top = 35,
  bnd_left = 20,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 42,
  bnd_logo_width = 42,
  bnd_logo_top = 0,
  bnd_logo_left = -218,
  bnd_logo_image = {
    name = "$ScoreBoard_LogoOff",
    id = 365
  },
  
  bnd_cornerRaduis = 20,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 8,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -95,
  bnd_homeRect_width = 8,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 8,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -86,
  bnd_awayRect_width = 8,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 316,
  bnd_homeBg_left = 3,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 365
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_AwayOff",
    id = 365
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_ScoreOff",
    id = 365
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -67,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 18,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -55,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 18,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -125,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -117,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -27,
  bnd_homeScore_fontSize = 23,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -16,
  bnd_awayScore_fontSize = 23,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 94,
  bnd_time_height = 40,
  bnd_time_top = 0,
  bnd_time_left = 355,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 365
  },
  bnd_time_text = "",
  bnd_time_fontSize = 18,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 94,
  bnd_extraTime_height = 40,
  bnd_extraTime_top = 0,
  bnd_extraTime_left = 420,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 365
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 18,
  bnd_extraTime_fontColor = "0x281B63",
  bnd_stat_visible = false,
  bnd_stat_width = 260,
  bnd_stat_height = 45,
  bnd_stat_top = 25,
  bnd_stat_left = 83,
  bnd_stat_color = "0x281B63",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 6,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 6,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 6,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local WomensWorldCupScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 34,
  bnd_top = 35,
  bnd_left = 90,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 35,
  bnd_logo_width = 150,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2282
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 115,
  bnd_homeBg_left = -82,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2282
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 115,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -82,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2282
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2282
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -73,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 26,
  bnd_homeName_fontColor = "0x000000",
  bnd_awayName_text = "",
  bnd_awayName_right = -71,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 26,
  bnd_awayName_fontColor = "0x000000",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -117,
  bnd_homeCrest_width = 37,
  bnd_homeCrest_height = 37,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -117,
  bnd_awayCrest_width = 37,
  bnd_awayCrest_height = 37,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -22.5,
  bnd_homeScore_fontSize = 24,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -19,
  bnd_awayScore_fontSize = 24,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "-",
  bnd_score_top = 0,
  bnd_score_left = -1,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 90,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = -14,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2282
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 90,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 34,
  bnd_extraTime_left = -14,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2282
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0x13C29F",
  bnd_stat_visible = false,
  bnd_stat_width = 250,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 95,
  bnd_stat_color = "0x086A87",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = "",
  bnd_stat_alpha = 1
}

local ClubWorldCupScore = {
  bnd_fontFace = "$DINPro-Bold",
  bnd_text_bold = true,
  bnd_width = 420,
  bnd_height = 45,
  bnd_top = 35,
  bnd_left = 55,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 34,
  bnd_logo_width = 34,
  bnd_logo_top = 0,
  bnd_logo_left = -136,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 2209
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 3,
  bnd_homeRect_top = 13.4,
  bnd_homeRect_left = -78,
  bnd_homeRect_width = 50,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 3,
  bnd_awayRect_top = 13.4,
  bnd_awayRect_right = -78,
  bnd_awayRect_width = 50,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 270,
  bnd_homeBg_left = 0,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2209
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 30,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 2209
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 2209
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -80,
  bnd_homeName_top = -1,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = -1,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -120,
  bnd_homeCrest_width = 25,
  bnd_homeCrest_height = 25,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -120,
  bnd_awayCrest_width = 25,
  bnd_awayCrest_height = 25,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -40,
  bnd_homeScore_fontSize = 26,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -38,
  bnd_awayScore_fontSize = 26,
  bnd_awayScore_fontColor = "0x000000",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 75,
  bnd_time_height = 45,
  bnd_time_top = 0,
  bnd_time_left = 10,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2209
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0x000000",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 75,
  bnd_extraTime_height = 45,
  bnd_extraTime_top = 32,
  bnd_extraTime_left = 10,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2209
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xCDA31F",
  bnd_stat_visible = false,
  bnd_stat_width = 270,
  bnd_stat_height = 30,
  bnd_stat_top = 32,
  bnd_stat_left = 85,
  bnd_stat_color = "0x000000",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 15,
  bnd_stat_text = ""
}

local FaCupScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 34,
  bnd_top = 63,
  bnd_left = -10,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 70,
  bnd_logo_width = 60,
  bnd_logo_top = -30,
  bnd_logo_left = 3,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2213
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 230,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2213
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2213
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2213
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -81,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0x000000",
  bnd_awayName_text = "",
  bnd_awayName_right = -88,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0x000000",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -42,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -50,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = -1,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 72,
  bnd_time_height = 30,
  bnd_time_top = 20,
  bnd_time_left = 189,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2213
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xFFFFFF",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 72,
  bnd_extraTime_height = 30,
  bnd_extraTime_top = 45,
  bnd_extraTime_left = 189,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2213
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0x101010",
  bnd_stat_visible = false,
  bnd_stat_width = 230,
  bnd_stat_height = 50,
  bnd_stat_top = 40,
  bnd_stat_left = 110,
  bnd_stat_color = "0xFFFFFF",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 14,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local DfbPokalScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 35,
  bnd_left = 90,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 25,
  bnd_logo_width = 125,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 2219
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 225,
  bnd_homeBg_left = 10,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2219
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2219
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 2219
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -60,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0x000000",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0x000000",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -5,
  bnd_homeScore_fontSize = 18,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -22,
  bnd_awayScore_fontSize = 18,
  bnd_awayScore_fontColor = "0x000000",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = -1,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x000000",

  bnd_time_width = 135,
  bnd_time_height = 39,
  bnd_time_top = -4,
  bnd_time_left = -25,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2219
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xFFFFFF",
  bnd_time_text_top = 4,
  bnd_time_text_left = 15,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 135,
  bnd_extraTime_height = 39,
  bnd_extraTime_top = 25,
  bnd_extraTime_left = -25,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2219
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xFFFFFF",
  bnd_stat_visible = false,
  bnd_stat_width = 225,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 117,
  bnd_stat_color = "0xD8D8D8",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local CoppaItaliaScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 55,
  bnd_top = 38,
  bnd_left = -15,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 100,
  bnd_logo_width = 100,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 2231
  },
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 0,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = 0,
  bnd_homeRect_width = 0,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 0,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = 0,
  bnd_awayRect_width = 0,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 201,
  bnd_homeBg_left = 40,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2231
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 130,
  bnd_awayBg_right = -80,
  bnd_awayBg_height = 38,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 2231
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 38,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 2231
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -22,
  bnd_homeName_top = -4,
  bnd_homeName_fontSize = 22,
  bnd_homeName_fontColor = "0xFFFFFF",
  bnd_awayName_text = "",
  bnd_awayName_right = -97,
  bnd_awayName_top = -4,
  bnd_awayName_fontSize = 22,
  bnd_awayName_fontColor = "0xFFFFFF",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,

  bnd_homeScore_text = "",
  bnd_homeScore_top = -4,
  bnd_homeScore_left = 25,
  bnd_homeScore_fontSize = 22,
  bnd_homeScore_fontColor = "0xAC0600",

  bnd_awayScore_text = "",
  bnd_awayScore_top = -4,
  bnd_awayScore_right = -51,
  bnd_awayScore_fontSize = 22,
  bnd_awayScore_fontColor = "0xAC0600",

  bnd_score_text = "-",
  bnd_score_top = -4,
  bnd_score_left = 38,
  bnd_score_fontSize = 18,
  bnd_score_fontColor = "0xAC0600",

  bnd_time_width = 146,
  bnd_time_height = 55,
  bnd_time_top = 0,
  bnd_time_left = 46,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2231
  },
  bnd_time_text = "",
  bnd_time_fontSize = 19,
  bnd_time_fontColor = "0xAC0600",
  bnd_time_text_left = 8,
  bnd_time_text_top = -4,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 52,
  bnd_extraTime_height = 55,
  bnd_extraTime_top = 0,
  bnd_extraTime_left = 345,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2231
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 19,
  bnd_extraTime_fontColor = "0x000000",

  bnd_stat_visible = false,
  bnd_stat_width = 185,
  bnd_stat_height = 40,
  bnd_stat_top = 32,
  bnd_stat_left = 159,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 18,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -65,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 65,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 0,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local FranceCupScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 32,
  bnd_top = 37,
  bnd_left = -20,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 50,
  bnd_logo_width = 52,
  bnd_logo_top = -26,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = 2200
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 3,
  bnd_homeRect_top = -1666,
  bnd_homeRect_left = -75,
  bnd_homeRect_width = 80,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 3,
  bnd_awayRect_top = -16666,
  bnd_awayRect_right = -85,
  bnd_awayRect_width = 80,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 250,
  bnd_homeBg_left = 0,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2200
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away off",
    id = 2200
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score off",
    id = 2200
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -85,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 25,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -82,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 25,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -20,
  bnd_homeScore_fontSize = 25,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -18,
  bnd_awayScore_fontSize = 25,
  bnd_awayScore_fontColor = "0x000000",

  bnd_score_text = "-",
  bnd_score_top = 0,
  bnd_score_left = 0,
  bnd_score_fontSize = 25,
  bnd_score_fontColor = "0x000000",

  bnd_time_width = 80,
  bnd_time_height = 32,
  bnd_time_top = 0,
  bnd_time_left = 347,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2200
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 1,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 28,
  bnd_extraTime_top = 29,
  bnd_extraTime_left = 347,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2200
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 22,
  bnd_extraTime_fontColor = "0x000000",
  bnd_stat_visible = false,
  bnd_stat_width = 250,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 95,
  bnd_stat_color = "0x000000",
  bnd_stat_alpha = 0.5,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local SaudiCupScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 29,
  bnd_top = 35,
  bnd_left = -5,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 34,
  bnd_logo_width = 34,
  bnd_logo_top = 0,
  bnd_logo_left = -136,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 2250
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = false,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 3,
  bnd_homeRect_top = 16,
  bnd_homeRect_left = -75,
  bnd_homeRect_width = 80,
  bnd_awayRect_visible = false,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 3,
  bnd_awayRect_top = 16,
  bnd_awayRect_right = -85,
  bnd_awayRect_width = 80,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2250
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 2250
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score",
    id = 2250
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -77,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -83,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -15,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0xB1CC06",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -23,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0xB1CC06",

  bnd_score_text = "-",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xB1CC06",

  bnd_time_width = 80,
  bnd_time_height = 29,
  bnd_time_top = 0,
  bnd_time_left = 345,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2250
  },
  bnd_time_text = "",
  bnd_time_fontSize = 19,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 29,
  bnd_extraTime_top = 30,
  bnd_extraTime_left = 345,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2250
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xFFFFFF",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 105,
  bnd_stat_color = "0x000000",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0xffffff",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local SaudiSuperCupScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 40,
  bnd_top = 35,
  bnd_left = 15,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 34,
  bnd_logo_width = 34,
  bnd_logo_top = 0,
  bnd_logo_left = -134,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 3350
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 3,
  bnd_homeRect_top = 13,
  bnd_homeRect_left = -2,
  bnd_homeRect_width = 96,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 3,
  bnd_awayRect_top = 13,
  bnd_awayRect_right = -95,
  bnd_awayRect_width = 98,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 318,
  bnd_homeBg_left = 5,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 3350
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 3350
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 3350
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -10,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xBF9A33",
  bnd_awayName_text = "",
  bnd_awayName_right = -100,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xBF9A33",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 0,
  bnd_homeScore_left = -50,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0x000000",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 0,
  bnd_awayScore_right = -140,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0x000000",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 80,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = 225,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time1",
    id = 3350
  },
  bnd_time_text = "",
  bnd_time_fontSize = 13,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 60,
  bnd_extraTime_height = 25,
  bnd_extraTime_top = 28,
  bnd_extraTime_left = 235,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 3350
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 16,
  bnd_extraTime_fontColor = "0xFFFFFF",
  bnd_stat_visible = false,
  bnd_stat_width = 196,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 169,
  bnd_stat_color = "0xffffff",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -65,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 65,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local KingCupScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 50,
  bnd_top = 20,
  bnd_left = -67,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 34,
  bnd_logo_width = 34,
  bnd_logo_top = 0,
  bnd_logo_left = -134,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 3500
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 4,
  bnd_homeRect_top = 23.6,
  bnd_homeRect_left = -7,
  bnd_homeRect_width = 129,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 4,
  bnd_awayRect_top = 23.6,
  bnd_awayRect_right = -119,
  bnd_awayRect_width = 123,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 189,
  bnd_homeBg_left = -60,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 3500
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 101,
  bnd_awayBg_height = 50,
  bnd_awayBg_right = -130,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away",
    id = 3500
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 3500
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -3,
  bnd_homeName_top = 5,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -115,
  bnd_awayName_top = 5,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 5,
  bnd_homeScore_left = -50,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 5,
  bnd_awayScore_right = -160,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "",
  bnd_score_top = 0,
  bnd_score_left = 5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 55,
  bnd_time_height = 50,
  bnd_time_top = 0,
  bnd_time_left = 250,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 3500
  },
  bnd_time_text = "",
  bnd_time_fontSize = 13,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 7,
  bnd_time_text_left = -1,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 40,
  bnd_extraTime_height = 25,
  bnd_extraTime_top = 36,
  bnd_extraTime_left = 256,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 3500
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 16,
  bnd_extraTime_fontColor = "0xFFFFFF",
  bnd_stat_visible = false,
  bnd_stat_width = 205,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 169,
  bnd_stat_color = "0xffffff",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -65,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 65,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local PaulistaoScore = {
  bnd_fontFace = "$Timer",
  bnd_text_bold = true,
  bnd_width = 420,
  bnd_height = 30,
  bnd_top = 48,
  bnd_left = -15,
  bnd_scoreboard_width = 360,
  bnd_logo_inside_visible = true,
  bnd_logo_outside_visible = true,
  bnd_logo_height = 51,
  bnd_logo_width = 160,
  bnd_logo_top = 0,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo",
    id = "7_29"
  },

  bnd_cornerRaduis = 10,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 36,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -60,
  bnd_homeRect_width = 110,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 36,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -60,
  bnd_awayRect_width = 110,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 80,
  bnd_homeBg_left = -78,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home1",
    id = "7_29"
  },
  bnd_awayBg_visible = true,
  bnd_awayBg_width = 80,
  bnd_awayBg_right = -78,
  bnd_awayBg_height = 30,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = "7_29"
  },
  bnd_scoreBg_width = 110,
  bnd_scoreBg_height = 30,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = "7_29"
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -83,
  bnd_homeName_top = 0,
  bnd_homeName_fontSize = 23,
  bnd_homeName_fontColor = "",
  bnd_awayName_text = "",
  bnd_awayName_right = -81,
  bnd_awayName_top = 0,
  bnd_awayName_fontSize = 23,
  bnd_awayName_fontColor = "",
  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -2020,
  bnd_homeCrest_width = 30,
  bnd_homeCrest_height = 30,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -2020,
  bnd_awayCrest_width = 30,
  bnd_awayCrest_height = 30,
  bnd_homeScore_text = "",
  bnd_homeScore_top = -1.3,
  bnd_homeScore_left = -26,
  bnd_homeScore_fontSize = 38,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = -1.3,
  bnd_awayScore_right = -23,
  bnd_awayScore_fontSize = 38,
  bnd_awayScore_fontColor = "0xffffff",
  bnd_score_text = "",
  bnd_score_top = 1.25,
  bnd_score_left = -1.5,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0x34003A",
  bnd_time_width = 103.9,
  bnd_time_height = 24,
  bnd_time_top = 29.8,
  bnd_time_left = 187.2,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = "7_29"
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 0,

  bnd_extraTime_visible = false,
  bnd_extraTime_width = 35,
  bnd_extraTime_height = 24,
  bnd_extraTime_top = 29.8,
  bnd_extraTime_left = 275,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = "7_29"
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xffffff",
  
  bnd_stat_visible = false,
  bnd_stat_width = 230,
  bnd_stat_height = 65,
  bnd_stat_top = 37,
  bnd_stat_left = 124.8,
  bnd_stat_color = "0xffffff",
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x000000",
  bnd_home_stat_text_left = -85,
  bnd_home_stat_text_top = 0,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 85,
  bnd_away_stat_text_top = 0,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 18,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

local CariocaScore = {
  bnd_text_bold = false,
  bnd_width = 420,
  bnd_height = 34,
  bnd_top = 35,
  bnd_left = -35,
  bnd_scoreboard_width = 400,
  bnd_logo_inside_visible = false,
  bnd_logo_outside_visible = false,
  bnd_logo_height = 25,
  bnd_logo_width = 125,
  bnd_logo_top = -25,
  bnd_logo_left = 0,
  bnd_logo_image = {
    name = "$ScoreBoard_Logo1",
    id = 2230
  },
  
  bnd_cornerRaduis = 0,
  bnd_homeRect_visible = true,
  bnd_homeRect_color = "",
  bnd_homeRect_height = 34,
  bnd_homeRect_top = 0,
  bnd_homeRect_left = -30,
  bnd_homeRect_width = 10,
  bnd_awayRect_visible = true,
  bnd_awayRect_color = "",
  bnd_awayRect_height = 34,
  bnd_awayRect_top = 0,
  bnd_awayRect_right = -41,
  bnd_awayRect_width = 9,

  bnd_homeBg_visible = true,
  bnd_homeBg_width = 240,
  bnd_homeBg_left = 8,
  bnd_homeBg_image = {
    name = "$ScoreBoard_Home",
    id = 2230
  },
  bnd_awayBg_visible = false,
  bnd_awayBg_width = 90,
  bnd_awayBg_height = 34,
  bnd_awayBg_right = -80,
  bnd_awayBg_image = {
    name = "$ScoreBoard_Away1",
    id = 2230
  },
  bnd_scoreBg_width = 80,
  bnd_scoreBg_height = 34,
  bnd_scoreBg_right = 0,
  bnd_scoreBg_image = {
    name = "$ScoreBoard_Score1",
    id = 2230
  },
  bnd_homeName_text = "",
  bnd_homeName_left = -74,
  bnd_homeName_top = 1,
  bnd_homeName_fontSize = 20,
  bnd_homeName_fontColor = "0xffffff",
  bnd_awayName_text = "",
  bnd_awayName_right = -80,
  bnd_awayName_top = 1,
  bnd_awayName_fontSize = 20,
  bnd_awayName_fontColor = "0xffffff",

  bnd_homeCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homeCrest_left = -12500,
  bnd_homeCrest_width = 35,
  bnd_homeCrest_height = 35,
  bnd_awayCrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awayCrest_right = -12500,
  bnd_awayCrest_width = 35,
  bnd_awayCrest_height = 35,

  bnd_homeScore_text = "",
  bnd_homeScore_top = 1,
  bnd_homeScore_left = -13,
  bnd_homeScore_fontSize = 20,
  bnd_homeScore_fontColor = "0xffffff",
  bnd_awayScore_text = "",
  bnd_awayScore_top = 1,
  bnd_awayScore_right = -21,
  bnd_awayScore_fontSize = 20,
  bnd_awayScore_fontColor = "0xffffff",

  bnd_score_text = "-",
  bnd_score_top = 0,
  bnd_score_left = 3,
  bnd_score_fontSize = 20,
  bnd_score_fontColor = "0xffffff",

  bnd_time_width = 116,
  bnd_time_height = 34,
  bnd_time_top = 0,
  bnd_time_left = 342,
  bnd_timeBg_image = {
    name = "$ScoreBoard_Time",
    id = 2230
  },
  bnd_time_text = "",
  bnd_time_fontSize = 20,
  bnd_time_fontColor = "0xffffff",
  bnd_time_text_top = 0,
  bnd_time_text_left = 15,
  bnd_extraTime_visible = false,
  bnd_extraTime_width = 80,
  bnd_extraTime_height = 34,
  bnd_extraTime_top = 35,
  bnd_extraTime_left = 376,
  bnd_extraTimeBg_image = {
    name = "$ScoreBoard_ExtraTime",
    id = 2230
  },
  bnd_extraTime_text = "",
  bnd_extraTime_fontSize = 20,
  bnd_extraTime_fontColor = "0xffffff",
  bnd_stat_visible = false,
  bnd_stat_width = 240,
  bnd_stat_height = 50,
  bnd_stat_top = 42,
  bnd_stat_left = 105,
  bnd_stat_color = "0xffffff",
  bnd_stat_alpha = 0.7,
  bnd_home_stat_text = "",
  bnd_stat_fontSize = 20,
  bnd_stat_fontColor = "0x114D64",
  bnd_home_stat_text_left = -80,
  bnd_home_stat_text_top = 1,
  bnd_away_stat_text = "",
  bnd_away_stat_text_left = 80,
  bnd_away_stat_text_top = 1,
  bnd_stat_text_left = 0,
  bnd_stat_text_top = 1,
  bnd_stat_text_fontSize = 16,
  bnd_stat_text = ""
}

function ScoreClock:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    MatchInfoService = o.api("MatchInfoService"),
    EventManagerService = o.api("EventManagerService"),
    GameSetupService = o.api("GameSetupService"),
    OverlayService = o.api("OverlayService"),
    TeamService = o.api("TeamService")
  }
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  
  o.visible = false
  
  local HOMETEAM = 0
  local AWAYTEAM = 1
  o.statType = {
    possession = {
      label = "POS",
      value = 4
    },
    Shots = {
      label = "SHOTS",
      value = 2
    },
    tackle = {
      label = "TACKLE",
      value = 5
    }
  }
  o.currentEvent = nil
  
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  self.homeScore = o.services.OverlayService.GetCurrentScore(HOMETEAM)
  self.awayScore = o.services.OverlayService.GetCurrentScore(AWAYTEAM)
  
  

  o.statVisible = false
  o.homeStat = "0%"
  o.awayStat = "0%"

  o.facts = nil

  liveLogo = {
    name = "$LiveLogo",
    id = 0
  }
  
  if currentCupData.cupIndex > 0 then
    if currentCupData.cupIndex == 1 then
      o.currentEvent = UCLScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, UCLTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, UCLTeamsData)
      o.currentEvent.bnd_homeRect_color = homeColorList[1]
      o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 2
    elseif currentCupData.cupIndex == 2 then
      o.currentEvent = UELScore
    liveLogo.id = 8
    elseif currentCupData.cupIndex == 3 then
      o.currentEvent = EuroCopaScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, EuroCopaTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, EuroCopaTeamsData)
      o.currentEvent.bnd_homeRect_color = homeColorList[1]
      o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 8
    elseif currentCupData.cupIndex == 4 then
      o.currentEvent = NationsScore
    liveLogo.id = 2
    elseif currentCupData.cupIndex == 5 then
      o.currentEvent = UefaWomensScore
    liveLogo.id = 12
    elseif currentCupData.cupIndex == 6 then
      o.currentEvent = LibertadoresScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, ConmebolTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, ConmebolTeamsData)
      o.currentEvent.bnd_homeRect_color = homeColorList[1]
      o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 1
    elseif currentCupData.cupIndex == 7 then
      o.currentEvent = SudamericanaScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, ConmebolTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, ConmebolTeamsData)
      o.currentEvent.bnd_homeRect_color = homeColorList[1]
      o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 1
    elseif currentCupData.cupIndex == 8 then
      o.currentEvent = CopaAmericaScore
    liveLogo.id = 7
    elseif currentCupData.cupIndex == 9 then
      o.currentEvent = ClubWorldCupScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, FriendlyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, FriendlyTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 8
    elseif currentCupData.cupIndex == 10 then
      o.currentEvent = WorldCupScore
    liveLogo.id = 8
    elseif currentCupData.cupIndex == 11 then
      o.currentEvent = FaCupScore
    liveLogo.id = 1
    elseif currentCupData.cupIndex == 12 then
      o.currentEvent = EAFCScore
    liveLogo.id = 2
    elseif currentCupData.cupIndex == 13 then
      o.currentEvent = CoppaItaliaScore
    liveLogo.id = 8
    elseif currentCupData.cupIndex == 14 then
      o.currentEvent = DfbPokalScore
    liveLogo.id = 0
    elseif currentCupData.cupIndex == 15 then
      o.currentEvent = FranceCupScore
    liveLogo.id = 3
    elseif currentCupData.cupIndex == 16 then
      o.currentEvent = BrazilAmazonScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, BrazilTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, BrazilTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 11
    elseif currentCupData.cupIndex == 17 then
      o.currentEvent = PaulistaoScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, PaulistaTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, PaulistaTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_homeName_fontColor = homeColorList[2]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    o.currentEvent.bnd_awayName_fontColor = awayColorList[2]
    liveLogo.id = 8
    else 
      o.currentEvent = EAFCScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, FriendlyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, FriendlyTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 0
  end
    
  elseif currentTourData and currentTourData.tourIndex and currentTourData.tourIndex > 0 then
    matchType = "tournament"
  if currentTourData.tourIndex == 1 then
    o.currentEvent = UCLScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, UCLTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, UCLTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 2
  elseif currentTourData.tourIndex == 2 then
    o.currentEvent = UELScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, UCLTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, UCLTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 8
  elseif currentTourData.tourIndex == 3 then
    o.currentEvent = EuroCopaScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, EuroCopaTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, EuroCopaTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 8
  elseif currentTourData.tourIndex == 4 then
    o.currentEvent = NationsScore
    liveLogo.id = 1
  elseif currentTourData.tourIndex == 5 then
    o.currentEvent = UefaWomensScore
    liveLogo.id = 12
  elseif currentTourData.tourIndex == 6 then
    o.currentEvent = LibertadoresScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, ConmebolTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, ConmebolTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 1
  elseif currentTourData.tourIndex == 7 then
    o.currentEvent = SudamericanaScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, ConmebolTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, ConmebolTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 1
  elseif currentTourData.tourIndex == 8 then
    o.currentEvent = CopaAmericaScore
    liveLogo.id = 7
  elseif currentTourData.tourIndex == 9 then
    o.currentEvent = ClubWorldCupScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, FriendlyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, FriendlyTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 8
  elseif currentTourData.tourIndex == 10 then
    o.currentEvent = WorldCupScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, InternationalTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, InternationalTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 8
  elseif currentTourData.tourIndex == 11 then
    o.currentEvent = FaCupScore
    liveLogo.id = 1
  elseif currentTourData.tourIndex == 12 then
    o.currentEvent = EAFCScore
    liveLogo.id = 0
  elseif currentTourData.tourIndex == 13 then
    o.currentEvent = CoppaItaliaScore
    liveLogo.id = 8
  elseif currentTourData.tourIndex == 14 then
    o.currentEvent = DfbPokalScore
    liveLogo.id = 0
  elseif currentTourData.tourIndex == 15 then
    o.currentEvent = FranceCupScore
    liveLogo.id = 3
  elseif currentTourData.tourIndex == 16 then
    o.currentEvent = BrazilAmazonScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, BrazilTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, BrazilTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 11
    else 
      o.currentEvent = EAFCScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, FriendlyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, FriendlyTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 0
  end
    
  else
  if o:isInTable(o.TeamsData[1], EnglandTeams) and o:isInTable(o.TeamsData[2], EnglandTeams) then
    o.currentEvent = EnglandScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, EnglandTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, EnglandTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_homeName_fontColor = homeColorList[2]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    o.currentEvent.bnd_awayName_fontColor = awayColorList[2]
    liveLogo.id = 1
  elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
    o.currentEvent = SpainScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, SpainTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, SpainTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 1
  elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
    o.currentEvent = SpainBScore
    liveLogo.id = 1
  elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
    o.currentEvent = GermanyScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, GermanyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, GermanyTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_homeName_fontColor = homeColorList[2]
    o.currentEvent.bnd_homeScore_fontColor = homeColorList[2]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    o.currentEvent.bnd_awayName_fontColor = awayColorList[2]
    o.currentEvent.bnd_awayScore_fontColor = awayColorList[2]
    liveLogo.id = 8
  elseif o:isInTable(o.TeamsData[1], Germany2Teams) and o:isInTable(o.TeamsData[2], Germany2Teams) then
    o.currentEvent = Germany2Score
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, Germany2TeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, Germany2TeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_homeName_fontColor = homeColorList[2]
    o.currentEvent.bnd_homeScore_fontColor = homeColorList[2]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    o.currentEvent.bnd_awayName_fontColor = awayColorList[2]
    o.currentEvent.bnd_awayScore_fontColor = awayColorList[2]
    liveLogo.id = 0
  elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
    o.currentEvent = FranceScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, FranceTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, FranceTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 3
  elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
    o.currentEvent = ItalyScore
    liveLogo.id = 1
  elseif o:isInTable(o.TeamsData[1], BrazilTeams) and o:isInTable(o.TeamsData[2], BrazilTeams) then
    o.currentEvent = BrazilGloboScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, BrazilTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, BrazilTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 7
  elseif o:isInTable(o.TeamsData[1], BrazilBTeams) and o:isInTable(o.TeamsData[2], BrazilBTeams) then
    o.currentEvent = BrazilScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, BrazilTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, BrazilTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 13
  elseif o:isInTable(o.TeamsData[1], MexicoTeams) and o:isInTable(o.TeamsData[2], MexicoTeams) then
    o.currentEvent = MexicoScore
    liveLogo.id = 5
  elseif o:isInTable(o.TeamsData[1], ArgentinaTeams) and o:isInTable(o.TeamsData[2], ArgentinaTeams) then
    o.currentEvent = ArgentinaScore
    liveLogo.id = 6
  elseif o:isInTable(o.TeamsData[1], IndonesiaTeams) and o:isInTable(o.TeamsData[2], IndonesiaTeams) then
    o.currentEvent = IndonesiaScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, IndonesiaTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, IndonesiaTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_homeName_fontColor = homeColorList[2]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    o.currentEvent.bnd_awayName_fontColor = awayColorList[2]
    liveLogo.id = 10
  elseif o:isInTable(o.TeamsData[1], SaudiArabiaTeams) and o:isInTable(o.TeamsData[2], SaudiArabiaTeams) then
    o.currentEvent = SaudiArabiaScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, SaudiArabiaTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, SaudiArabiaTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_homeName_fontColor = homeColorList[2]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    o.currentEvent.bnd_awayName_fontColor = awayColorList[2]
    liveLogo.id = 4
  elseif o:isInTable(o.TeamsData[1], WomensSuperLeagueTeams) and o:isInTable(o.TeamsData[2], WomensSuperLeagueTeams) then
    o.currentEvent = WomensSuperLeagueScore
    liveLogo.id = 1
  elseif o:isInTable(o.TeamsData[1], UnitedStatesTeams) and o:isInTable(o.TeamsData[2], UnitedStatesTeams) then
    o.currentEvent = UnitedStatesScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, UnitedStatesTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, UnitedStatesTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 9
  elseif o:isInTable(o.TeamsData[1], RussiaTeams) and o:isInTable(o.TeamsData[2], RussiaTeams) then
    o.currentEvent = RussiaScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, RussiaTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, RussiaTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_homeName_fontColor = homeColorList[2]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    o.currentEvent.bnd_awayName_fontColor = awayColorList[2]
    liveLogo.id = 67
  elseif o:isInTable(o.TeamsData[1], LeaguePariTeams) and o:isInTable(o.TeamsData[2], LeaguePariTeams) then
    o.currentEvent = LeaguePariScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, LeaguePariTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, LeaguePariTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_homeName_fontColor = homeColorList[2]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    o.currentEvent.bnd_awayName_fontColor = awayColorList[2]
    liveLogo.id = 67
  elseif o:isInTable(o.TeamsData[1], UkraineTeams) and o:isInTable(o.TeamsData[2], UkraineTeams) then
    o.currentEvent = UkraineScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, UkraineTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, UkraineTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 332
  elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
    o.currentEvent = InternationalScore
    liveLogo.id = 0
  else 
    o.currentEvent = EAFCScore
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, FriendlyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, FriendlyTeamsData)
    o.currentEvent.bnd_homeRect_color = homeColorList[1]
    o.currentEvent.bnd_awayRect_color = awayColorList[1]
    liveLogo.id = 0
  end
  end

  o.currentEvent.bnd_homeCrest.id = o.TeamsData[1].assetId
  o.currentEvent.bnd_awayCrest.id = o.TeamsData[2].assetId

  o.currentEvent.bnd_homeName_text = o.services.GameSetupService.GetTeamShortName(HOMETEAM)
  o.currentEvent.bnd_awayName_text = o.services.GameSetupService.GetTeamShortName(AWAYTEAM)

  o.im.Subscribe("bnd_visible", function()
    o:publishVisible()
  end)
  
   for k,v in pairs(o.currentEvent) do
    o.im.Subscribe(k, function()
      if k == "bnd_homeScore_text" then
        o:publishScoreHome()
      elseif k == "bnd_awayScore_text" then
        o:publishScoreAway()
      elseif k == "bnd_time_text" then
        o:publishTime()
      elseif k == "bnd_extraTime_visible" then
        o:publishExtraTimeVisibility(false)
      elseif k == "bnd_extraTime_text" then
        o:publishExtraTime()
      elseif k == "bnd_home_stat_text" or k == "bnd_away_stat_text" then
        o:publishStat()
      else
        o.im.Publish(k, v)
      end
    end)
  end

 
  
  o.im.Subscribe("bnd_live_logo", function()
    o.im.Publish("bnd_live_logo", liveLogo)
  end)

  return o
end



-----------------------------------------------------------------------------------------------------------
function ScoreClock:publishScoreHome()
  self.im.Publish("bnd_homeScore_text", tostring(self.homeScore))
end
function ScoreClock:publishScoreAway()
  self.im.Publish("bnd_awayScore_text", tostring(self.awayScore))
end
function ScoreClock:publishTime()
  if self.gameTime ~= "" and self.gameTime ~= nil then
    self.im.Publish("bnd_time_text", tostring(self.gameTime))
  end
end
function ScoreClock:publishExtraTime()
  if self.gameExtraTime ~= "" and self.gameExtraTime ~= nil then
    self.im.Publish("bnd_extraTime_text", tostring(self.gameExtraTime))
  end
end

function ScoreClock:publishStat()
  local statTypeLabel = ""
  local statTypeValue = 0
  if self.gameTime ~= "" and self.gameTime ~= nil then
    local gameTime = string.sub(self.gameTime, 1, string.find(self.gameTime, ":") - 1)
    if (gameTime + 0 > 30 and gameTime + 0 < 35) or (gameTime + 0 > 60 and gameTime + 0 < 65) then
      statTypeLabel = self.statType.possession.label
      statTypeValue = self.statType.possession.value
    elseif (gameTime + 0 > 20 and gameTime + 0 < 25) or (gameTime + 0 > 50 and gameTime + 0 < 55) then
      statTypeLabel = self.statType.Shots.label
      statTypeValue = self.statType.Shots.value
    elseif (gameTime + 0 > 40 and gameTime + 0 < 45) or (gameTime + 0 > 70 and gameTime + 0 < 75) then
      statTypeLabel = self.statType.tackle.label
      statTypeValue = self.statType.tackle.value
    else
      self.facts = nil
      self.statVisible = false
    end
    if statTypeValue > 0 then
      if self.facts == nil then
        self.facts = self:getMatchFacts()
      end
      self.homeStat = self.facts[statTypeValue].data.value
      self.awayStat = self.facts[statTypeValue].data.valueRight
      self.statVisible = true
    end
    self.im.Publish("bnd_stat_text", statTypeLabel)
    self.im.Publish("bnd_stat_visible", self.statVisible)
    self.im.Publish("bnd_home_stat_text", tostring(self.homeStat))
    self.im.Publish("bnd_away_stat_text", tostring(self.awayStat))
  end
end


function ScoreClock:getMatchFacts()
  local facts = self.services.MatchInfoService.GetMatchFacts(true)
  local o = facts.homeData
  for i, v in ipairs(o) do
    v.data.valueRight = facts.awayData[i].data.value
  end
  return o
end
-----------------------------------------------------------------------------------------------------------

function ScoreClock:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeGumby then
    self:updateGameTime(data.subtype, data.hideshow, data.subtypestr, data.msg)
  elseif eventType == EventTypes.OverlayTypeGoal or eventType == EventTypes.OverlayTypeMatchEvents then
    self:updateGameScore(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function ScoreClock:updateGameTime(subtype, hideshow, subtypestr, msg)
  local params = OverlayParam.split(msg, "|")
  self.gameTime = ""
  self.gameExtraTime = ""
  if #params == 3 then
    if string.find(params[1], ":") then
      self.gameExtraTime = params[3]
      self:publishExtraTime()
      self:publishExtraTimeVisibility(true)
    end
    self.gameTime = params[1]
    self:publishTime()
    self:publishStat()
  elseif #params == 4 then
    self.im.Publish(bndAlpha, params[1] / 100)
  elseif params and table.getn(params) > 0 then
    if string.find(params[1], ":") then
      self.gameTime = params[1]
    end
    if params[1] == "" then
      self:publishExtraTimeVisibility(false)
    end
    self:publishTime()
    self:publishStat()
  end
  self.visible = hideshow == "SHOW" or hideshow == "UPDATE"
  self:publishVisible()
end

function ScoreClock:updateGameScore(subtype, hideshow, subtypestr, msg)
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) >= 6 then
      self.homeScore = params[5]
      self.awayScore = params[6]
      self:publishScoreHome()
      self:publishScoreAway()
    end
  end
end

function ScoreClock:publishExtraTimeVisibility(visible)
  self.im.Publish("bnd_extraTime_visible", visible)
end

function ScoreClock:publishVisible()
  self.im.Publish("bnd_visible", self.visible)
end

function ScoreClock:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function ScoreClock:getTeamHomeColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.homeColor
      result[2] = v.homeFontColor
    end
  end
  return result
end

function ScoreClock:getTeamAwayColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.awayColor
      result[2] = v.awayFontColor
    end
  end
  return result
end
    
function ScoreClock:finalize()
  for k,v in pairs(EAFCScore) do
    self.im.Unsubscribe(k)
  end
  self.im.Unsubscribe("bnd_live_logo")
  self.im.Unsubscribe("bnd_visible")
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
end

return ScoreClock