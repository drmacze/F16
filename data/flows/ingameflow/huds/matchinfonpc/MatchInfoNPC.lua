local MatchInfoNPC = {}

local OverlaysIdContainer, OverlayParam, eventmanager = ...
local OVERLAY_TYPES = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes


EAFCREFINFO = {
  bnd_width_ref = 700,
  bnd_ref_height = 80,
  bnd_ref_width = 100,
  bnd_ref_top = -50,
  bnd_ref_left = -460,
  bnd_ref_color = "0x181818",
  bnd_ref_logo = {
    name = "$LeagueLogo",
    id = 0
  },
  bnd_ref_logo_height = 55,
  bnd_ref_logo_width = 55,
  bnd_ref_logo_left = 0,
  bnd_ref_logo_top = 0,

  bnd_reftitle_height = 20,
  bnd_reftitle_width = 300,
  bnd_reftitle_top = -100,
  bnd_reftitle_left = -260,
  bnd_reftitle_color = "0x000000",
  bnd_reftitle_text = "REFEREE",
  bnd_reftitle_fontSize = 16,
  bnd_reftitle_fontColor = "0xffffff",

  bnd_refimage_height = 30,
  bnd_refimage_width = 3,
  bnd_refimage1_top = -70,
  bnd_refimage1_left = -30000,
  bnd_refimage1_alignH = "LEFT",
  bnd_reficon_height = 30,
  bnd_reficon_width = 30,

  bnd_refimage2_top = -70,
  bnd_refimage2_right = 30000,
  bnd_refimage2_alignH = "RIGHT",

  bnd_ref_label_height = 80,
  bnd_ref_label_top = -50,
  bnd_ref_label_left = -260,
  bnd_ref_label_color = "0xE6E6E6",
  bnd_ref_Name_text = "",
  bnd_ref_Name_fontSize = 22,
  bnd_ref_Name_fontColor = "0x000000",
  bnd_ref_Name_left = 0,
  bnd_ref_Name_top = -20,

  bnd_ref_Country_text = "",
  bnd_ref_Country_fontSize = 20,
  bnd_ref_Country_fontColor = "0x000000",
  bnd_ref_Country_left = 0,
  bnd_ref_Country_top = 20
}

EAFCInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 0
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x00D9D1"
}

DFLInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 0
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x2E2E2E"
}

EnglandInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "13"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x58D3F7"
}

SpainInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "53"
  },
  bnd_logo_height = 20,
  bnd_logo_width = 80,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xFA4B43"
}

SpainBInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "54"
  },
  bnd_logo_height = 20,
  bnd_logo_width = 80,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x00EAFF"
}

GermanyInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "19"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xFF0300"
}

Germany2Info = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "20"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xFF0300"
}

FranceInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "16"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x0040FF"
}

ItalyInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "31"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x2E64FE"
}

BrazilInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_1"
  },
  bnd_logo_height = 65,
  bnd_logo_width = 65,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xD8D8D8"
}

BrazilGloboInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_globo"
  },
  bnd_logo_height = 65,
  bnd_logo_width = 65,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x000000"
}

BrazilAmazonInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_2"
  },
  bnd_logo_height = 65,
  bnd_logo_width = 65,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x00A7FF"
}

MexicoInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMENTARIO",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 341
  },
  bnd_logo_height = 65,
  bnd_logo_width = 65,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x1D3D66"
}

ArgentinaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMENTARIO",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 353
  },
  bnd_logo_height = 65,
  bnd_logo_width = 65,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x1F3139"
}

IndonesiaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "2235"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x2F437F"
}

SaudiArabiaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "350"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x4F546E"
}

WomensSuperLeagueInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0x512C77",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "2216_1"
  },
  bnd_logo_height = 45,
  bnd_logo_width = 45,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xffffff"
}

RussiaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 67
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x000C50"
}

LeaguePariInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2245
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x000E08"
}

UkraineInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 332
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x0039AB"
}

InternationalInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 78
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xD3AA32"
}

--------- Tournaments ---------

UCLInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2236
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x0431B4"
}

UELInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2238
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xDF7401"
}

EuroCopaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x0000FF",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2299
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x0000FF"
}

NationsInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2241
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xDBE2E3"
}

UCLWomenInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2240
  },
  bnd_logo_height = 50,
  bnd_logo_width = 50,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x28689D"
}

UCLClassicInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2236
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x0B3861"
}

LibertadoresInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2237
  },
  bnd_logo_height = 80,
  bnd_logo_width = 80,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x000000"
}

SudamericanaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2267
  },
  bnd_logo_height = 80,
  bnd_logo_width = 80,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x000564"
}

CopaAmericaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x0B2161",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2298
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x0B2161"
}

WorldCupInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 365
  },
  bnd_logo_height = 45,
  bnd_logo_width = 45,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x281B63"
}

WomensWorldCupInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2282
  },
  bnd_logo_height = 80,
  bnd_logo_width = 80,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x00FFA3"
}

ClubWorldCupInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2209
  },
  bnd_logo_height = 80,
  bnd_logo_width = 80,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x000000"
}

FACupInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "13_Cup"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xFF0018"
}

DfbPokalInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2219
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x808080"
}

CoppaItaliaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "2231_1"
  },
  bnd_logo_height = 65,
  bnd_logo_width = 65,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0xBE0003"
}

SaudiSuperCupInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x2F0B3A",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x2F0B3A",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xBF9A33",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = 3350
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x2F0B3A"
}

KingCupInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xE6E6E6",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "350_5"
  },
  bnd_logo_height = 55,
  bnd_logo_width = 55,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x1E692D"
}

PaulistaoInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_29"
  },
  bnd_logo_height = 65,
  bnd_logo_width = 65,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x0001CE"
}

CariocaInfo = {
  bnd_background_show = false,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$Comment",
    id = 0
  },
  bnd_title_alpha = 1,
  bnd_com_alignH = "CENTER",
  bnd_width_com = 500,
  bnd_com_height = 80,
  bnd_com_width = 300,
  bnd_com_top = -50,
  bnd_com_left = -260,
  bnd_com_color = "0xE6E6E6",
  bnd_com_alpha = 1,
  bnd_com1_text = "",
  bnd_com_fontSize = 20,
  bnd_com_fontColor = "0x000000",
  bnd_com1_text_alignH = "CENTER",
  bnd_com1_text_left = 0,
  bnd_com2_text = "",
  bnd_com2_text_alignH = "CENTER",
  bnd_com2_text_left = 0,
  bnd_com1_text_top = -20,
  bnd_com2_text_top = 27,
  bnd_comtitle_height = 20,
  bnd_comtitle_width = 300,
  bnd_comtitle_top = -100,
  bnd_comtitle_left = -260,
  bnd_comtitle_color = "0x000000",
  bnd_comtitle_text = "COMMENTARY",
  bnd_comtitle_fontSize = 18,
  bnd_comtitle_fontColor = "0xffffff",
  bnd_comtitle_text_alignH = "CENTER",
  bnd_comtitle_text_left = 0,
  bnd_comtitle_text2_alignH = "CENTER",
  bnd_comtitle_text_right = 60000,
  bnd_comimage_height = 40,
  bnd_comimage_width = 40,
  bnd_comimage1_top = -70,
  bnd_comimage1_left = -140,
  bnd_comimage1_alignH = "LEFT",
  bnd_comimage1_color = "0xD8D8D8",
  bnd_comimage_alpha = 1,
  bnd_comimage1 = {
    name = "$Commentators",
    id = 0
  },
  bnd_comimage_visible = true,

  bnd_comicon_visible = false,
  bnd_comicon_height = 30,
  bnd_comicon_width = 30,

  bnd_comimage2_top = -31,
  bnd_comimage2_left = -140,
  bnd_comimage2_alignH = "LEFT",
  bnd_comimage2 = {
    name = "$Commentators",
    id = 0
  },
  bnd_logo = {
    name = "$LeagueLogo",
    id = "7_30"
  },
  bnd_logo_height = 65,
  bnd_logo_width = 65,
  bnd_logo_left = -460,
  bnd_logo_top = -50,
  bnd_comlogo_width = 100,
  bnd_comlogo_height = 80,
  bnd_comlogo_alignH = "CENTER",
  bnd_comlogo_color = "0x142a37"
}

function MatchInfoNPC:new(init)
  print("[MatchInfoNPC]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    eventManService = o.api("EventManagerService"),
    MatchInfoService = o.api("MatchInfoService"),
    TeamService = o.api("TeamService")
  }
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  

  o.handlerId = o.services.eventManService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)
  o.nationalization = 2
  o.isActiveCom = false
  o.isActiveRef = false
  o.npcInfo = nil

  o.currentEvent = nil
  o.refdata = EAFCREFINFO
  
  if currentCupData.cupIndex > 0 then
    if currentCupData.cupIndex == 1 then
       o.currentEvent = UCLInfo
       o.refdata.bnd_ref_color = "0x0431B4"
       o.refdata.bnd_ref_logo.id = 2236
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
    elseif currentCupData.cupIndex == 2 then
       o.currentEvent = UELInfo
       o.refdata.bnd_ref_color = "0xDF7401"
       o.refdata.bnd_ref_logo.id = 2238
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
   elseif currentCupData.cupIndex == 3 then
       o.currentEvent = EuroCopaInfo
       o.refdata.bnd_ref_color = "0x0000FF"
       o.refdata.bnd_ref_logo.id = 0
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
    elseif currentCupData.cupIndex == 4 then
       o.currentEvent = NationsInfo
       o.refdata.bnd_ref_color = "0xDBE2E3"
       o.refdata.bnd_ref_logo.id = 2241
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
    elseif currentCupData.cupIndex == 5 then
       o.currentEvent = UCLWomenInfo
       o.refdata.bnd_ref_color = "0x28689D"
       o.refdata.bnd_ref_logo.id = 2240
       o.refdata.bnd_ref_logo_height = 50
       o.refdata.bnd_ref_logo_width = 50
    elseif currentCupData.cupIndex == 6 then
       o.currentEvent = LibertadoresInfo
       o.refdata.bnd_ref_color = "0x000000"
       o.refdata.bnd_ref_logo.id = 2237
       o.refdata.bnd_ref_logo_height = 80
       o.refdata.bnd_ref_logo_width = 80
    elseif currentCupData.cupIndex == 7 then
       o.currentEvent = SudamericanaInfo
       o.refdata.bnd_ref_logo.id = 2267
       o.refdata.bnd_ref_color = "0x000564"
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentCupData.cupIndex == 8 then
       o.currentEvent = CopaAmericaInfo
       o.refdata.bnd_ref_color = "0x0B2161"
       o.refdata.bnd_ref_logo.id = 2298
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentCupData.cupIndex == 9 then
       o.currentEvent = ClubWorldCupInfo
       o.refdata.bnd_ref_color = "0x000000"
       o.refdata.bnd_ref_logo.id = 2209
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentCupData.cupIndex == 10 then
       o.currentEvent = WorldCupInfo
       o.refdata.bnd_ref_color = "0x281B63"
       o.refdata.bnd_ref_logo.id = 365
       o.refdata.bnd_ref_logo_height = 45
       o.refdata.bnd_ref_logo_width = 45
     elseif currentCupData.cupIndex == 11 then
       o.currentEvent = FACupInfo
       o.refdata.bnd_ref_color = "0xFF0018"
       o.refdata.bnd_ref_logo.id = "13_Cup"
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentCupData.cupIndex == 12 then
       o.currentEvent = EAFCInfo
       o.refdata.bnd_ref_color = "0x2E2E2E"
       o.refdata.bnd_ref_logo.id = 0
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
    elseif currentCupData.cupIndex == 13 then
       o.currentEvent = CoppaItaliaInfo
       o.refdata.bnd_ref_color = "0xBE0003"
       o.refdata.bnd_ref_logo.id = "2231_1"
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentCupData.cupIndex == 14 then
       o.currentEvent = DfbPokalInfo
       o.refdata.bnd_ref_color = "0x808080"
       o.refdata.bnd_ref_logo.id = 2219
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentCupData.cupIndex == 15 then
       o.currentEvent = EAFCInfo
       o.refdata.bnd_ref_color = "0x2E2E2E"
       o.refdata.bnd_ref_logo.id = 0
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentCupData.cupIndex == 16 then
       o.currentEvent = BrazilAmazonInfo
       o.refdata.bnd_ref_color = "0x00A7FF"
       o.refdata.bnd_ref_logo.id = "7_2"
       o.refdata.bnd_ref_logo_height = 65
       o.refdata.bnd_ref_logo_width = 65
     elseif currentCupData.cupIndex == 17 then
       o.currentEvent = PaulistaoInfo
       o.refdata.bnd_ref_color = "0x0001CE"
       o.refdata.bnd_ref_logo.id = "7_29"
       o.refdata.bnd_ref_logo_height = 65
       o.refdata.bnd_ref_logo_width = 65
       else 
       o.currentEvent = EAFCInfo
       o.refdata.bnd_ref_color = "0x00D9D1"
       o.refdata.bnd_ref_logo.id = 0
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
    end
    
   elseif currentTourData and currentTourData.tourIndex and currentTourData.tourIndex > 0 then
     if currentTourData.tourIndex == 1 then
       o.currentEvent = UCLInfo
       o.refdata.bnd_ref_color = "0x0431B4"
       o.refdata.bnd_ref_logo.id = 2236
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 2 then
       o.currentEvent = UELInfo
       o.refdata.bnd_ref_color = "0xDF7401"
       o.refdata.bnd_ref_logo.id = 2238
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 3 then
       o.currentEvent = EuroCopaInfo
       o.refdata.bnd_ref_color = "0x0000FF"
       o.refdata.bnd_ref_logo.id = 0
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 4 then
       o.currentEvent = NationsInfo
       o.refdata.bnd_ref_color = "0xDBE2E3"
       o.refdata.bnd_ref_logo.id = 2241
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 5 then
       o.currentEvent = UCLWomenInfo
       o.refdata.bnd_ref_color = "0x28689D"
       o.refdata.bnd_ref_logo.id = 2240
       o.refdata.bnd_ref_logo_height = 50
       o.refdata.bnd_ref_logo_width = 50
     elseif currentTourData.tourIndex == 6 then
       o.currentEvent = LibertadoresInfo
       o.refdata.bnd_ref_color = "0x000000"
       o.refdata.bnd_ref_logo.id = 2237
       o.refdata.bnd_ref_logo_height = 80
       o.refdata.bnd_ref_logo_width = 80
     elseif currentTourData.tourIndex == 7 then
       o.currentEvent = SudamericanaInfo
       o.refdata.bnd_ref_logo.id = 2267
       o.refdata.bnd_ref_color = "0x000564"
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 8 then
       o.currentEvent = CopaAmericaInfo
       o.refdata.bnd_ref_color = "0x0B2161"
       o.refdata.bnd_ref_logo.id = 2298
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 9 then
       o.currentEvent = ClubWorldCupInfo
       o.refdata.bnd_ref_color = "0x000000"
       o.refdata.bnd_ref_logo.id = 2209
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 10 then
       o.currentEvent = WorldCupInfo
       o.refdata.bnd_ref_color = "0x281B63"
       o.refdata.bnd_ref_logo.id = 365
       o.refdata.bnd_ref_logo_height = 45
       o.refdata.bnd_ref_logo_width = 45
     elseif currentTourData.tourIndex == 11 then
       o.currentEvent = FACupInfo
       o.refdata.bnd_ref_color = "0xFF0018"
       o.refdata.bnd_ref_logo.id = "13_Cup"
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 12 then
       o.currentEvent = EAFCInfo
       o.refdata.bnd_ref_color = "0x2E2E2E"
       o.refdata.bnd_ref_logo.id = 0
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 13 then
       o.currentEvent = CoppaItaliaInfo
       o.refdata.bnd_ref_color = "0xBE0003"
       o.refdata.bnd_ref_logo.id = "2231_1"
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 14 then
       o.currentEvent = DfbPokalInfo
       o.refdata.bnd_ref_color = "0x808080"
       o.refdata.bnd_ref_logo.id = 2219
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 15 then
       o.currentEvent = EAFCInfo
       o.refdata.bnd_ref_color = "0x2E2E2E"
       o.refdata.bnd_ref_logo.id = 0
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
     elseif currentTourData.tourIndex == 16 then
       o.currentEvent = BrazilAmazonInfo
       o.refdata.bnd_ref_color = "0x00A7FF"
       o.refdata.bnd_ref_logo.id = "7_2"
       o.refdata.bnd_ref_logo_height = 65
       o.refdata.bnd_ref_logo_width = 65
     else 
       o.currentEvent = EAFCInfo
       o.refdata.bnd_ref_color = "0x00D9D1"
       o.refdata.bnd_ref_logo.id = 0
       o.refdata.bnd_ref_logo_height = 55
       o.refdata.bnd_ref_logo_width = 55
    end
    
  else
     if o:isInTable(o.TeamsData[1], EnglandTeams) and o:isInTable(o.TeamsData[2], EnglandTeams) then
    o.currentEvent = EnglandInfo
    o.refdata.bnd_ref_color = "0x58D3F7"
    o.refdata.bnd_ref_logo.id = 13
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
   elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
    o.currentEvent = SpainInfo
    o.refdata.bnd_ref_color = "0xFA4B43"
    o.refdata.bnd_ref_logo.id = 53
    o.refdata.bnd_ref_logo_height = 20
    o.refdata.bnd_ref_logo_width = 80
  elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
    o.currentEvent = SpainBInfo
    o.refdata.bnd_ref_color = "0x00EAFF"
    o.refdata.bnd_ref_logo.id = 54
    o.refdata.bnd_ref_logo_height = 20
    o.refdata.bnd_ref_logo_width = 80
  elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
    o.currentEvent = GermanyInfo
    o.refdata.bnd_ref_color = "0xFF0300"
    o.refdata.bnd_ref_logo.id = 19
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  elseif o:isInTable(o.TeamsData[1], Germany2Teams) and o:isInTable(o.TeamsData[2], Germany2Teams) then
    o.currentEvent = Germany2Info
    o.refdata.bnd_ref_color = "0xFF0300"
    o.refdata.bnd_ref_logo.id = 20
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
    o.currentEvent = FranceInfo
    o.refdata.bnd_ref_color = "0x0040FF"
    o.refdata.bnd_ref_logo.id = 16
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
    o.currentEvent = ItalyInfo
    o.refdata.bnd_ref_color = "0xf2E64FE"
    o.refdata.bnd_ref_logo.id = "31_1"
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  elseif o:isInTable(o.TeamsData[1], BrazilTeams) and o:isInTable(o.TeamsData[2], BrazilTeams) then
    o.currentEvent = BrazilGloboInfo
    o.refdata.bnd_ref_color = "0x000000"
    o.refdata.bnd_ref_logo.id = "7_globo"
    o.refdata.bnd_ref_logo_height = 65
    o.refdata.bnd_ref_logo_width = 65
  elseif o:isInTable(o.TeamsData[1], BrazilBTeams) and o:isInTable(o.TeamsData[2], BrazilBTeams) then
    o.currentEvent = BrazilInfo
    o.refdata.bnd_ref_color = "0x000000"
    o.refdata.bnd_ref_logo.id = "7_globo"
    o.refdata.bnd_ref_logo_height = 65
    o.refdata.bnd_ref_logo_width = 65
  elseif o:isInTable(o.TeamsData[1], MexicoTeams) and o:isInTable(o.TeamsData[2], MexicoTeams) then
    o.currentEvent = MexicoInfo
    o.refdata.bnd_ref_color = "0x1D3D66"
    o.refdata.bnd_ref_logo.id = 341
    o.refdata.bnd_ref_logo_height = 65
    o.refdata.bnd_ref_logo_width = 65
  elseif o:isInTable(o.TeamsData[1], ArgentinaTeams) and o:isInTable(o.TeamsData[2], ArgentinaTeams) then
    o.currentEvent = ArgentinaInfo
    o.refdata.bnd_ref_color = "0x1F3139"
    o.refdata.bnd_ref_logo.id = 353
    o.refdata.bnd_ref_logo_height = 65
    o.refdata.bnd_ref_logo_width = 65
  elseif o:isInTable(o.TeamsData[1], IndonesiaTeams) and o:isInTable(o.TeamsData[2], IndonesiaTeams) then
    o.currentEvent = IndonesiaInfo
    o.refdata.bnd_ref_color = "0x2F437F"
    o.refdata.bnd_ref_logo.id = 2235
    o.refdata.bnd_ref_logo_height = 65
    o.refdata.bnd_ref_logo_width = 65
  elseif o:isInTable(o.TeamsData[1], SaudiArabiaTeams) and o:isInTable(o.TeamsData[2], SaudiArabiaTeams) then
    o.currentEvent = SaudiArabiaInfo
    o.refdata.bnd_ref_color = "0x4F546E"
    o.refdata.bnd_ref_logo.id = 350
    o.refdata.bnd_ref_logo_height = 65
    o.refdata.bnd_ref_logo_width = 65
  elseif o:isInTable(o.TeamsData[1], WomensSuperLeagueTeams) and o:isInTable(o.TeamsData[2], WomensSuperLeagueTeams) then
    o.currentEvent = WomensSuperLeagueInfo
    o.refdata.bnd_ref_color = "0x512C77"
    o.refdata.bnd_ref_logo.id = "2216_1"
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  elseif o:isInTable(o.TeamsData[1], UnitedStatesTeams) and o:isInTable(o.TeamsData[2], UnitedStatesTeams) then
    o.currentEvent = EAFCInfo
    o.refdata.bnd_ref_color = "0x2E2E2E"
    o.refdata.bnd_ref_logo.id = 39
    o.refdata.bnd_ref_logo_height = 65
    o.refdata.bnd_ref_logo_width = 65
  elseif o:isInTable(o.TeamsData[1], RussiaTeams) and o:isInTable(o.TeamsData[2], RussiaTeams) then
    o.currentEvent = RussiaInfo
    o.refdata.bnd_ref_color = "0x000C50"
    o.refdata.bnd_ref_logo.id = 67
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  elseif o:isInTable(o.TeamsData[1], LeaguePariTeams) and o:isInTable(o.TeamsData[2], LeaguePariTeams) then
    o.currentEvent = LeaguePariInfo
    o.refdata.bnd_ref_color = "0x000E08"
    o.refdata.bnd_ref_logo.id = 2245
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  elseif o:isInTable(o.TeamsData[1], UkraineTeams) and o:isInTable(o.TeamsData[2], UkraineTeams) then
    o.currentEvent = UkraineInfo
    o.refdata.bnd_ref_color = "0x0039AB"
    o.refdata.bnd_ref_logo.id = 332
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
    o.currentEvent = InternationalInfo
    o.refdata.bnd_ref_color = "0xD3AA32"
    o.refdata.bnd_ref_logo.id = 78
    o.refdata.bnd_ref_logo_height = 60
    o.refdata.bnd_ref_logo_width = 60
else 
    o.currentEvent = EAFCInfo
    o.refdata.bnd_ref_color = "0x00D9D1"
    o.refdata.bnd_ref_logo.id = 0
    o.refdata.bnd_ref_logo_height = 55
    o.refdata.bnd_ref_logo_width = 55
  end  
  end  

  o.im.Subscribe("bnd_nationalization", function()
  end)
  o.im.Subscribe("bnd_visible_com", function()
    o:_publishActivityCom()
  end)
  o.im.Subscribe("bnd_visible_ref", function()
    o:_publishActivityRef()
  end)

  for k,v in pairs(o.currentEvent) do
    o.im.Subscribe(k, function()
      if k == "bnd_comimage1" or k == "bnd_com1_text"  then
        o:_publishBndCom()
      elseif k == "bnd_comimage2" or k == "bnd_com2_text" then
        o:_publishBndCom2()
      else
        o.im.Publish(k, v)
      end
    end)
  end

  for k,v in pairs(o.refdata) do
    o.im.Subscribe(k, function()
      if k == "bnd_ref_Name_text" or k == "bnd_ref_Country_text" then
        o:_publishNPCInfo()
      else
        o.im.Publish(k, v)
      end
    end)
  end
  return o
end


function MatchInfoNPC:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeCommentators then
    self:updateMatchInfoCommentators(data.subtype, data.hideshow, data.subtypestr, data.msg)
  elseif eventType == EventTypes.OverlayTypeIntroSequenceReferee then
    self:updateMatchInfoReferees(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end


function MatchInfoNPC:updateMatchInfoCommentators(subtype, hideshow, subtypestr, msg)
  print("[MatchInfoNPC]: updateMatchInfoCommentators(subtype = " .. tostring(subtype) .. ", hideshow = " .. tostring(hideshow) .. ", subtypestr = " .. tostring(subtypestr) .. ", msg = " .. tostring(msg) .. ")")
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      self.im.Publish("bnd_nationalization", self.nationalization)
      local leagueId = params[7] + 0
      if leagueId == -1 then
        leagueId = 666
      end
       mainCommentator = params[3]
       colorCommentator = params[4]
      local gamemode = params[9]
      self.npcInfo = {
        topText = self.loc.LocalizeString("MatchCommentary"),
        middleText = " ",
        bottomText = " ",
        overlayTitle = mainCommentator.."   &   "..colorCommentator
      }
      if string.find(mainCommentator, "null") then
        self.isActiveCom = false
      else
         self.isActiveCom = true
      end

      self.currentEvent.bnd_comimage1.id = mainCommentator
      self.currentEvent.bnd_com1_text = mainCommentator
      self.comImage = self.currentEvent.bnd_comimage1
      self.currentEvent.bnd_comimage2.id = colorCommentator
      self.currentEvent.bnd_com2_text = colorCommentator
      self.comImage2 = self.currentEvent.bnd_comimage2
    end
  else
    self.isActiveCom = false
  end
  self:_publishActivityCom()
  self:_publishBndCom()
  self:_publishBndCom2()
end


function MatchInfoNPC:updateMatchInfoReferees(subtype, hideshow, subtypestr, msg)
  print("[MatchInfoNPC]: updateMatchInfoReferees(subtype = " .. tostring(subtype) .. ", hideshow = " .. tostring(hideshow) .. ", subtypestr = " .. tostring(subtypestr) .. ", msg = " .. tostring(msg) .. ")")
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    if params and table.getn(params) > 0 then
      self.im.Publish("bnd_nationalization", self.nationalization)
      local leagueId = params[5] + 0
      if leagueId == -1 then
        leagueId = 666
      end
      local refereeName = params[3]
      local refereesCountry = params[4]
      local gamemode = "友谊赛"
      self.npcInfo = {
        topText = gamemode,
        middleText = refereeName,
        bottomText = refereesCountry,
        overlayTitle = ("比赛裁判员"),
      }
      self.isActiveRef = true
    end
  else
    self.isActiveRef = false
  end
  self:_publishNPCInfo()
  self:_publishActivityRef()
end


function MatchInfoNPC:_publishActivityCom()
  self.im.Publish("bnd_visible_com", self.isActiveCom)
end
function MatchInfoNPC:_publishActivityRef()
  self.im.Publish("bnd_visible_ref", self.isActiveRef)
end
function MatchInfoNPC:_publishBndCom()
  self.im.Publish("bnd_comimage1", self.comImage)
  self.im.Publish("bnd_com1_text", self.currentEvent.bnd_com1_text)
end
function MatchInfoNPC:_publishBndCom2()
  self.im.Publish("bnd_comimage2", self.comImage2)
  self.im.Publish("bnd_com2_text", self.currentEvent.bnd_com2_text)
end

function MatchInfoNPC:_publishNPCInfo()
  if self.npcInfo == nil then
    return
  end
  self.im.Publish("bnd_ref_Name_text", self.npcInfo.middleText)
  self.im.Publish("bnd_ref_Country_text", self.npcInfo.bottomText)
end

function MatchInfoNPC:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end


function MatchInfoNPC:finalize()
  print("[MatchInfoNPC]: finalize()")
  self.im.Unsubscribe("bnd_nationalization")
  self.im.Unsubscribe("bnd_visible_com")
  self.im.Unsubscribe("bnd_visible_ref")
  
  for k,v in pairs(EAFCInfo) do
    self.im.Unsubscribe(k)
  end
  for k,v in pairs(EAFCREFINFO) do
    self.im.Unsubscribe(k)
  end
  self.services.eventManService.UnregisterHandler(self.handlerId)
end
return MatchInfoNPC