-- REMOD BY LAOSIJI & icelee ID --
print("GameEvents.lua")
local GameEvents = {}
local OverlaysIdContainer, OverlayParam, eventmanager = ...
local Overlays = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes
local BND_VISIBLE = "bnd_visible"

local leagueIDs = {
  England = 0,
  France = 0,
  Germany = 0,
  Italy = 0,
  International = 0,
  UEFA = 0,
  UEFAEL = 0,
  Spain = 0
}




bndList = {
  "bnd_homename_text",
  "bnd_homecrest",
  "bnd_awayname_text",
  "bnd_awaycrest",
  "bnd_score_text",
  "bnd_homemessage_text",
  "bnd_awaymessage_text",
  "bnd_title_text"
}

EAFCInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

UEFAInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

UEFAELInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

EnglandInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}
  

InternationalInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

GermanyInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

ItalyInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

SpainInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
  bnd_homemessage_visible = false,
  bnd_awaymessage_visible = false
}

FranceInfo = {
   bnd_event_height = 60,
  bnd_event_width = 600,
  bnd_event_top = 25,
  bnd_event_left = 0,
  bnd_event_alpha = 1,
  bnd_homename_text = "",
  bnd_event_fontSize = 24,
  bnd_event_fontColor = "0x1E1E1E",
  bnd_homename_alignH = "CENTER",
  bnd_homename_text_fontColor = "0xFFFFFF",
  bnd_homename_height = 0,
  bnd_homename_width = 0,
  bnd_homename_color = "",
  bnd_homename_left = 150,
  bnd_homename_text_left = 0,
  bnd_awayname_text_right = 0,
  bnd_awayname_text = "",
  bnd_awayname_text_fontColor = "0xFFFFFF",
  bnd_awayname_alignH = "CENTER",
  bnd_awayname_right = 150,
  bnd_awayname_height = 0,
  bnd_awayname_width = 0,
  bnd_awayname_color = "",
  
  bnd_icelee_text_right = 0,
  bnd_icelee_text = " SERIE A",
  bnd_icelee_text_fontColor = "0xF7C849",
  bnd_icelee_alignH = "CENTER",
  bnd_icelee_right = 40,
  bnd_icelee_height = 0,
  bnd_icelee_width = 0,
  bnd_icelee_color = "",
    
  bnd_score_text = "",
  bnd_score_height = 0,
  bnd_score_width = 0,
  bnd_score_color = "0x1E1E1E",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_homecrest_top = 24,
  bnd_homecrest_left = -278.5,
  bnd_homecrest_color = "0xB22222",
  bnd_homecrest = {
    name = "$Crest",
    id = 0
  },
  bnd_homecrest_height = 45,
  bnd_homecrest_width = 45,
  bnd_awaycrest_top = 24,
  bnd_awaycrest_right = -281,
  bnd_awaycrest_color = "0xB22222",
  bnd_awaycrest = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_height = 45,
  bnd_awaycrest_width = 45,

  bnd_message_height = 0,
  bnd_message_width = 0,
  bnd_homemessage_top = -15,
  bnd_homemessage_left = -255,
  bnd_homemessage_color = "0x25C4CD",
  bnd_homemessage_text = "",
  bnd_message_fontSize = 13,
  bnd_message_fontColor = "0x25C4CD",
  bnd_awaymessage_right = 200,
  bnd_message_text_width = 200,
  bnd_awaymessage_top = -15,
  bnd_awaymessage_left = 255,
  bnd_awaymessage_color = "0x25C4CD",
  bnd_awaymessage_text = "",
--------进球显示
  bnd_logo_height = 0,
  bnd_logo_width = 0,
  bnd_logo_top = -80,
  bnd_logo_left = 0,
  bnd_logo_color = "0x1E1E1E",
  bnd_logo = {
    name = "$Background_EndMatch"
  },
  bnd_logowidth = 630,
  bnd_logoheight = 140,
 
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_top = 57,
  bnd_title_left = 0,
  bnd_title_text = "",
  bnd_title_color = "0xF7C849",
  bnd_title_fontColor = "0xFFFFFF",
  bnd_title_fontSize = 15,
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

  local EnglandTeams = o.services.TeamService.GetTeams(leagueIDs.England, 0, 0, true)
  local FranceTeams = o.services.TeamService.GetTeams(leagueIDs.France, 0, 0, true)
  local GermanyTeams = o.services.TeamService.GetTeams(leagueIDs.Germany, 0, 0, true)
  local SpainTeams = o.services.TeamService.GetTeams(leagueIDs.Spain, 0, 0, true)
  local ItalyTeams = o.services.TeamService.GetTeams(leagueIDs.Italy, 0, 0, true)
  local IndonesiaTeams = o.services.TeamService.GetTeams(leagueIDs.Indonesia, 0, 0, true)
  local SpainBTeams = o.services.TeamService.GetTeams(leagueIDs.SpainB, 0, 0, true)
  local ItalyBTeams = o.services.TeamService.GetTeams(leagueIDs.ItalyB, 0, 0, true)
  local BrazilTeams = o.services.TeamService.GetTeams(leagueIDs.Brazil, 0, 0, true)
  local FranceBTeams = o.services.TeamService.GetTeams(leagueIDs.FranceB, 0, 0, true)
  local InternationalTeams = o.services.TeamService.GetTeams(leagueIDs.International, 0, 0, true)
  local UefaEropaTeams = o.services.TeamService.GetTeams(leagueIDs.UefaEropa, 0, 0, true)
  local UEFATeams = o.services.TeamService.GetTeams(leagueIDs.UEFA, 0, 0, true)
  local UEFAELTeams = o.services.TeamService.GetTeams(leagueIDs.UEFAEL, 0, 0, true)
  local InternationalWomansTeams = o.services.TeamService.GetTeams(leagueIDs.InternationalWomans, 0, 0, true)
  local ClassicTeams = o.services.TeamService.GetTeams(leagueIDs.Classic, 0, 0, true)
  local GermanyBTeams = o.services.TeamService.GetTeams(leagueIDs.GermanyB, 0, 0, true)
  local UnitedStatesTeams = o.services.TeamService.GetTeams(leagueIDs.UnitedStates, 0, 0, true)
  local ArgentinaTeams = o.services.TeamService.GetTeams(leagueIDs.Argentina, 0, 0, true)


  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end
  )
  o.currentdata = nil
  if o:isInTable(o.TeamsData[1], EnglandTeams) and o:isInTable(o.TeamsData[2], EnglandTeams) then
    o.currentdata = EnglandInfo
  elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
    o.currentdata = InternationalInfo
  elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
    o.currentdata = FranceInfo
  elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
    o.currentdata = GermanyInfo
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, GermanyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, GermanyTeamsData)

  elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
    o.currentdata = SpainInfo
  elseif o:isInTable(o.TeamsData[1], UEFATeams) and o:isInTable(o.TeamsData[2], UEFATeams) then
    o.currentdata = UEFAInfo
  elseif o:isInTable(o.TeamsData[1], UEFAELTeams) and o:isInTable(o.TeamsData[2], UEFAELTeams) then
    o.currentdata = UEFAELInfo
  elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
    o.currentdata = ItalyInfo
  else 
    o.currentdata = EAFCInfo
  end

  --o.im.Subscribe(BND_NATIONALIZATION, function()
 -- end
--  )
  o.im.Subscribe(BND_VISIBLE, function()
     o.im.Publish(BND_VISIBLE, false)
  end
  )
  --o.im.Subscribe(BND_GAME_EVENT_INFO, function()
--  end
 -- )

  for k,v in pairs(o.currentdata) do
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
    --  self.im.Publish(BND_NATIONALIZATION, self.nationalization)
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
      self.score = params[5] .. " - " .. params[6]
      
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
        self.currentdata.bnd_homemessage_visible = false
      else
        self.currentdata.bnd_homemessage_visible = true
      end
      if params[6]+0 == 0 then
        self.currentdata.bnd_awaymessage_visible = false
      else
        self.currentdata.bnd_awaymessage_visible = true
      end
      

      self.currentdata.bnd_homename_text = gameevents.homeTeam
      self.currentdata.bnd_homecrest.id = gameevents.homeTeamId
      self.currentdata.bnd_awayname_text = gameevents.awayTeam
      self.currentdata.bnd_awaycrest.id = gameevents.awayTeamId
      self.currentdata.bnd_score_text = self.score
      self.currentdata.bnd_title_text = gameevents.message
      
      self.currentdata.bnd_homemessage_text = homeMsg
      self.currentdata.bnd_awaymessage_text = awayMsg
      -- self.im.Publish(BND_GAME_EVENT_INFO, gameevents)
      
    end
  else
    self.im.Publish(BND_VISIBLE, false)
  end
  self:_publishEventInfo()
end

function GameEvents:_publishEventInfo()
  self.im.Publish("bnd_homemessage_visible", self.currentdata.bnd_homemessage_visible)
  self.im.Publish("bnd_awaymessage_visible", self.currentdata.bnd_awaymessage_visible)
  self.im.Publish("bnd_homename_text", self.currentdata.bnd_homename_text)
  self.im.Publish("bnd_homecrest", self.currentdata.bnd_homecrest)
  self.im.Publish("bnd_awayname_text", self.currentdata.bnd_awayname_text)
  self.im.Publish("bnd_awaycrest", self.currentdata.bnd_awaycrest)
  self.im.Publish("bnd_score_text", self.currentdata.bnd_score_text)
  self.im.Publish("bnd_homemessage_text", self.currentdata.bnd_homemessage_text)
  self.im.Publish("bnd_awaymessage_text", self.currentdata.bnd_awaymessage_text)
  self.im.Publish("bnd_title_text", self.currentdata.bnd_title_text)
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
 -- self.im.Unsubscribe(BND_GAME_EVENT_INFO)
  self.im.Unsubscribe(BND_VISIBLE)
  --self.im.Unsubscribe(BND_NATIONALIZATION)
  for k,v in pairs(EnglandInfo) do
    self.im.Unsubscribe(k)
  end
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end

return GameEvents
