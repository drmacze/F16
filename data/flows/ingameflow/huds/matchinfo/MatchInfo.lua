local MatchInfo = {}
local OverlaysIdContainer, OverlayParam, eventmanager, TableUtil = ...
local OVERLAY_TYPES = OverlaysIdContainer.Overlays.OVERLAY_TYPE
local EventTypes = eventmanager.FE.FIFA.EventTypes

local bndRainVisible = "bnd_rain_visible"
local bndSnowVisible = "bnd_snow_visible"
local bndWeather = "bnd_weather_type"
local BND_REALTIME = "bnd_realtime"

FriendlyTeamsData = {
  { teamid = 1, homeColor = "0x9d1a27", awayColor = "0x000000", homeFontColor = "0xFFFFFF", awayFontColor = "0x942528" },
  { teamid = 2, homeColor = "0x5c253f", awayColor ="0x80a5ca",homeFontColor = "0x80a5ca", awayFontColor = "0x000000"},
  { teamid = 5, homeColor = "0x084B8A", awayColor ="0x084B8A",homeFontColor = "0xFFFFFF", awayFontColor = "0xffffff"},
  { teamid = 7, homeColor = "0x1e406d", awayColor = "0xe19bc7",homeFontColor = "0xFFFFFF", awayFontColor = "0x1e406d" },
  { teamid = 9, homeColor = "0x942528", awayColor = "0xFFFFFF",homeFontColor = "0xFFFFFF", awayFontColor = "0x942528"},
  { teamid = 10, homeColor = "0x58D3F7", awayColor = "0xD7DF01",homeFontColor = "0xFFFFFF", awayFontColor = "0x0A122A"},
  { teamid = 11, homeColor = "0xb7243b", awayColor ="0x0B2161",homeFontColor ="0xFFFFFF" , awayFontColor = "0xb7243b"},
  { teamid = 13, homeColor = "0x000000" , awayColor ="0x088A68",homeFontColor = "0xFFFFFF", awayFontColor = "0x000000"},
  { teamid = 17, homeColor = "0xc5c4c3", awayColor = "0x9ebabb",homeFontColor = "0xD8D8D8", awayFontColor = "0xD01818"},
  { teamid = 18, homeColor = "0xedecea", awayColor ="0x424242",homeFontColor = "0x424242", awayFontColor = "0xedecea"},
  { teamid = 19, homeColor = "0x743846" , awayColor = "0x30302e",homeFontColor ="0x80a5ca" , awayFontColor ="0x000000" },  
  { teamid = 8, homeColor = "0xc9c8c7", awayColor ="0xd3d188",homeFontColor = "0xd2d1d0", awayFontColor = "0xaa2327"},  
  { teamid = 14, homeColor = "0xb51e1f", awayColor ="0xe6da4a",homeFontColor = "0xa51b21", awayFontColor = "0xf9f8f8"},  
  { teamid = 110, homeColor = "0xFFBF00", awayColor ="0x386a54",homeFontColor = "0x000000", awayFontColor = "0xFFBF00"},  
  { teamid = 144, homeColor ="0xe9e8e7" , awayColor ="0x7fcabf",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 1796, homeColor = "0x743846" , awayColor = "0x743846",homeFontColor ="0x58D3F7" , awayFontColor ="0x58D3F7" },  
  { teamid = 1799, homeColor ="0xd62d25" , awayColor ="0xcbcbc9",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 1808, homeColor ="0x205da0" , awayColor ="0xd23531",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 1923, homeColor = "0xFF8000" , awayColor = "0xFF8000",homeFontColor ="0x0B3861" , awayFontColor ="0x0B3861" },  
  { teamid = 1925, homeColor ="0xb52328" , awayColor ="0x8dabc9",homeFontColor = "0xFFFFFF", awayFontColor ="0xb52328" },
  { teamid = 1943, homeColor ="0xae272f" , awayColor ="0x5b669d",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 95, homeColor = "0x08088A", awayColor ="0xffffff",homeFontColor = "0xFFFFFF", awayFontColor = "0x08088A"},
  { teamid = 94, homeColor = "0x08298A", awayColor ="0xffffff",homeFontColor = "0xFFFFFF", awayFontColor = "0x08298A"},
  { teamid = 17, homeColor = "0xDF0101", awayColor ="0xffffff",homeFontColor = "0xFFFFFF", awayFontColor = "0xDF0101"},
  { teamid = 57, homeColor = "0xffffff", awayColor = "0x084B8A" },
  { teamid = 1530, homeColor = "0x000000", awayColor = "0xffffff" },
  { teamid = 69, homeColor = "0xDF0101", awayColor = "0x2E2E2E" },
  { teamid = 1819, homeColor = "0x088A4B", awayColor = "0xffffff" },
  { teamid = 71, homeColor = "0xD7DF01", awayColor = "0x000000" },
  { teamid = 1738, homeColor = "0x0489B1", awayColor = "0xffffff" },
  { teamid = 65, homeColor = "0xB40404", awayColor = "0xffffff" },
  { teamid = 70, homeColor = "0x0B2161", awayColor = "0xffffff" },
  { teamid = 72, homeColor = "0xDF0101", awayColor = "0xffffff" },
  { teamid = 66, homeColor = "0xffffff", awayColor = "0x000000" },
  { teamid = 219, homeColor = "0xffffff", awayColor = "0x0B4C5F" },
  { teamid = 73, homeColor = "0x0B2161", awayColor = "0xffffff" },
  { teamid = 64, homeColor = "0xFFBF00", awayColor = "0x585858" },
  { teamid = 76, homeColor = "0x08088A", awayColor = "0xffffff" },
  { teamid = 378, homeColor = "0xffffff", awayColor = "0x084B8A" },
  { teamid = 379, homeColor = "0xDF0101", awayColor = "0x848484" },
  { teamid = 74, homeColor = "0xDF0101", awayColor = "0xffffff" },
  { teamid = 1809, homeColor = "0x380B61", awayColor = "0xffffff" },
  { teamid = 240, homeColor = "0xb73036", awayColor = "0x202123", homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0" },
  { teamid = 241, homeColor = "0x00069D", awayColor ="0x000000",homeFontColor = "0x101010", awayFontColor = "0xF8D000"},
  { teamid = 1968, homeColor = "0xe0d12d", awayColor ="0x262d43",homeFontColor = "0x30B060", awayFontColor = "0xE0E0E0"},
  { teamid = 243, homeColor = "0xFFFFFF", awayColor = "0xFF9400",homeFontColor = "0xE01820", awayFontColor = "0xE0E0E0" },
  { teamid = 448, homeColor = "0xb92931", awayColor = "0x2a2929",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 449, homeColor = "0x267a48", awayColor = "0x26456f",homeFontColor = "0xE0E0E0", awayFontColor = "0x2838A0"},
  { teamid = 450, homeColor = "0x7db7c7", awayColor ="0x232322",homeFontColor ="0xE0E0E0" , awayFontColor = "0x289880"},
  { teamid = 452, homeColor = "0x1c54b0" , awayColor ="0xe68ab2",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 457, homeColor = "0x364172", awayColor = "0x2a2a28",homeFontColor = "0xD8D8D8", awayFontColor = "0xD01818"},
  { teamid = 453, homeColor = "0xb31f23", awayColor ="0x2b2b2b",homeFontColor = "0xE0E0E0", awayFontColor = "0x50A830"},
  { teamid = 461, homeColor = "0xd5d5d4" , awayColor = "0x282827",homeFontColor ="0x363535" , awayFontColor ="0xd1d1d0" },  
  { teamid = 462, homeColor ="0x664266" , awayColor = "0x502276",homeFontColor = "0xcec29a", awayFontColor = "0xcec29a"},  
  { teamid = 468, homeColor = "0xd2d2d0", awayColor ="0x186237",homeFontColor = "0xd2d1d0", awayFontColor = "0xaa2327"},  
  { teamid = 480, homeColor = "0xd1d0cf", awayColor ="0xca2635",homeFontColor = "0xa51b21", awayFontColor = "0xf9f8f8"},  
  { teamid = 481, homeColor = "0xe2e1e0", awayColor ="0xab202e",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},  
  { teamid = 483, homeColor ="0xdede1b" , awayColor ="0x676276",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 479, homeColor ="0x85232b" , awayColor ="0x2c2c2b",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 1860, homeColor ="0x213a96" , awayColor ="0xb61c33",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 1861, homeColor ="0xbf2729" , awayColor ="0x35abd4",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 110062, homeColor ="0xa32126" , awayColor ="0xfab723",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 21, homeColor = "0xB80018", awayColor = "0xE0E0E0", homeFontColor = "0xE0E0E0", awayFontColor = "0xB80018" },
  { teamid = 22, homeColor = "0xF8D000", awayColor ="0x101010",homeFontColor = "0x101010", awayFontColor = "0xF8D000"},
  { teamid = 23, homeColor = "0xE0E0E0", awayColor ="0x30B060",homeFontColor = "0x30B060", awayFontColor = "0xE0E0E0"},
  { teamid = 25, homeColor = "0x9c2225", awayColor ="0x3e4041",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 31, homeColor = "0xE0E0E0", awayColor = "0xE01820",homeFontColor = "0xE01820", awayFontColor = "0xE0E0E0" },
  { teamid = 32, homeColor = "0xB81020", awayColor = "0x101010",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 36, homeColor = "0xd3d4d3", awayColor ="0xc62432",homeFontColor ="0xc62432" , awayFontColor = "0xd3d4d3"},
  { teamid = 38, homeColor = "0x289880", awayColor ="0xE1B5AD",homeFontColor ="0xE0E0E0" , awayFontColor = "0x289880"},
  { teamid = 160, homeColor ="0x1d3552" , awayColor ="0x65a7d4",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 169, homeColor = "0xD01818", awayColor = "0xD8D8D8",homeFontColor = "0xD8D8D8", awayFontColor = "0xD01818"},
  { teamid = 175, homeColor = "0x50A830", awayColor ="0x383C3D",homeFontColor = "0xE0E0E0", awayFontColor = "0x50A830"},
  { teamid = 1824, homeColor ="0xD7D7D5" , awayColor ="0x323231",homeFontColor = "0x323231", awayFontColor ="0xD7D7D5" },  
  { teamid = 1831, homeColor ="0xbc1e20" , awayColor ="0xd5cbbb",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 10029, homeColor ="0x204390" , awayColor = "0xcec29a",homeFontColor = "0xcec29a", awayFontColor = "0x204390"},  
  { teamid = 100409, homeColor = "0xaa2327", awayColor ="0xd2d1d0",homeFontColor = "0xd2d1d0", awayFontColor = "0xaa2327"}, 
  { teamid = 112172, homeColor = "0xf9f8f8", awayColor ="0xa51b21",homeFontColor = "0xa51b21", awayFontColor = "0xf9f8f8"},   
  { teamid = 111235, homeColor = "0xC7181D", awayColor = "0x2958A0",homeFontColor = "0x2958A0", awayFontColor = "0xC7181D"},
  { teamid = 110502, homeColor = "0xD0CFCE", awatColor = "0x313447", homeFontColor = "0x313447", awayFontColor = "0xD0CFCE"},
  { teamid = 27, homeColor ="0x1D4382", awayColor = "0xC3C2C1", homeFontColor = "0xC3C2C1", awayFontColor = "0x1D4382"},
  { teamid = 28, homeColor = "0xD0CFCE", awayColor = "0x313447", homeFontColor = "0x313447", awayFontColor = "0xD0CFCE"},
  { teamid = 29, homeColor ="0xB80018", awayColor = "0xC3C2C1", homeFontColor = "0xC3C2C1", awayFontColor = "0xB80018"},
  { teamid = 34, homeColor = "0x2838A0", awayColor = "0xD8D8D8",homeFontColor = "0xE0E0E0", awayFontColor = "0x2838A0"},
  -- { teamid = 159, homeColor = "0x2838A0", awayColor = "0xD8D8D8",homeFontColor = "0xE0E0E0", awayFontColor = "0x2838A0"},
  { teamid = 165, homeColor = "0x61D386" , awayColor ="0x000000",homeFontColor = "0x000000", awayFontColor = "0x61D386"},
  { teamid = 166, homeColor = "0x284090" , awayColor ="0x182038",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 171, homeColor = "0x3D181F", awayColor = "0xDFD5D3", homeFontColor = "0xDFD5D3", awayFontColor = "0x3D181F" },
  { teamid = 485, homeColor = "0xC73C40", awayColor = "0x3E4743", homeFontColor = "0xffffff", awayFontColor = "0xffffff" },
  -- { teamid = 543, homeColor = "0xD9D8D7", awayColor = "0xBD3640", homeFontColor = "0xBD3640", awayFontColor = "0xD9D8D7" },
  { teamid = 576, homeColor = "0x355E9B", awayColor = "0xD4D4D2", homeFontColor = "0xD4D4D2", awayFontColor = "0x355E9B" },
  { teamid = 1832, homeColor = "0x284390", awayColor = "0xF3E8E6", homeFontColor = "0xF3E8E6", awayFontColor = "0x284390" },
  { teamid = 10030, homeColor = "0x2F519B", awayColor = "0xEC242E", homeFontColor = "0xEC242E", awayFontColor = "0x2F519B" },
  -- { teamid = 110178, homeColor = "0xFEFEFE", awayColor ="0x1B1B1B", homeFontColor = "0x1B1B1B", awayFontColor = "0xFEFEFE"},
  { teamid = 110329, homeColor = "0x4B3A33", awayColor = "0xE3E2E0", homeFontColor = "0xE3E2E0", awayFontColor = "0x4B3A33"},
  { teamid = 110500, homeColor = "0xFFE313", awayColor = "0x2D64B7", homeFontColor = "0x2D64B7", awayFontColor = "0xFFE313"},
  { teamid = 110588, homeColor = "0x0D3362", awayColor ="0x0F0F0F",homeFontColor = "0x0F0F0F", awayFontColor = "0xffffff"},
  { teamid = 110636, homeColor = "0x891321", awayColor ="0xFFFFFD",homeFontColor = "0xFFFFFD", awayFontColor = "0x891321"},
  { teamid = 492, homeColor = "0x252524", awayColor ="0x6D9FB2",homeFontColor = "0xffffff", awayFontColor = "0x382B47"},
  { teamid = 487, homeColor = "0x633D86", awayColor ="0xBEBEC0",homeFontColor = "0xFFFFFF", awayFontColor = "0x633485"},
  { teamid = 605, homeColor = "0x01A9DB", awayColor = "0x01A9DB" },
  { teamid = 607, homeColor = "0x000000", awayColor = "0xD8D8D8" },
  { teamid = 111674, homeColor = "0xE6E6E6", awayColor = "0x424242" },
  { teamid = 112139, homeColor = "0xD7DF01", awayColor = "0x0B3861" },
  { teamid = 112387, homeColor = "0x0B6138", awayColor = "0x0B6138" },
  { teamid = 112390, homeColor = "0x08088A", awayColor = "0xD8D8D8" },
  { teamid = 112392, homeColor = "0xB40404", awayColor = "0xB40404" },
  { teamid = 112393, homeColor = "0xD7DF01", awayColor = "0xD8D8D8" },
  { teamid = 687, homeColor = "0xEBE205", awayColor = "0x000000", homeFontColor = "0x000000", awayFontColor = "0xEBE205" },
  { teamid = 688, homeColor = "0x0B0908", awayColor ="0xE30423",homeFontColor = "0xE30423", awayFontColor = "0x0B0908"},
  { teamid = 689, homeColor = "0xCF0D2C", awayColor ="0xEAE3D6",homeFontColor = "0xEAE3D6", awayFontColor = "0xCF0D2C"},
  { teamid = 691, homeColor = "0x8C809F", awayColor = "0x051434",homeFontColor = "0x051434", awayFontColor = "0x8C809F" },
  { teamid = 693, homeColor = "0xFB0404", awayColor = "0xffffff",homeFontColor = "0xffffff", awayFontColor = "0xFB0404"},
  { teamid = 694, homeColor = "0x9A0835", awayColor = "0xC5CBD6",homeFontColor = "0xC5CBD6", awayFontColor = "0x9A0835"},
  { teamid = 695, homeColor = "0xD5315B", awayColor ="0xD21443",homeFontColor ="0xFFFFFF" , awayFontColor = "0xFFFFFF"},
  { teamid = 696, homeColor = "0xAABED4", awayColor ="0x0C2D5C",homeFontColor ="0x0C2D5C" , awayFontColor = "0xAABED4"},
  { teamid = 697, homeColor = "0x284090" , awayColor ="0x0E2446",homeFontColor = "0xffff00", awayFontColor = "0xE0E0E0"},
  { teamid = 698, homeColor = "0xEC9233", awayColor = "0x000000",homeFontColor = "0x000000", awayFontColor = "0xEC9233"},
  { teamid = 101112, homeColor = "0x93BBE3", awayColor ="0x0B3A7C",homeFontColor = "0x0B3A7C", awayFontColor = "0x93BBE3"},
  { teamid = 111065, homeColor = "0xA02F39" , awayColor = "0x0B3A7C",homeFontColor ="0x0B3A7C" , awayFontColor ="0xA02F39" },
  { teamid = 111138, homeColor ="0x080D27" , awayColor = "0xA4CDE7",homeFontColor = "0xA4CDE7", awayFontColor = "0x080D27"},  
  { teamid = 111139, homeColor = "0x060D1A", awayColor ="0xD1CDCD",homeFontColor = "0xD1CDCD", awayFontColor = "0x060D1A"},
  { teamid = 111140, homeColor ="0x083C07" , awayColor ="0xA02F39",homeFontColor = "0xE0E0E0", awayFontColor ="0x083C07" },
  { teamid = 111144, homeColor = "0x5CA404", awayColor ="0xE8E8E8",homeFontColor = "0xE8E8E8", awayFontColor = "0x3D3D3D"},
  { teamid = 114161, homeColor = "0x09AE42", awayColor ="0x1F1836",homeFontColor = "0x1F1836", awayFontColor = "0x09AE42"},  
  { teamid = 114162, homeColor = "0xE4E35D", awayColor ="0x1F1836",homeFontColor = "0x1F1836", awayFontColor = "0xE4E35D"},  
  { teamid = 111651, homeColor = "0xAA061D", awayColor ="0x2B2B2B",homeFontColor = "0x2B2B2B", awayFontColor = "0xAA061D"},  
  { teamid = 111928, homeColor ="0x053A97" , awayColor ="0xE2DCDE",homeFontColor = "0xE2DCDE", awayFontColor ="0x053A97" }, 
  { teamid = 112134, homeColor ="0x212339" , awayColor = "0x33A4D2",homeFontColor = "0x33A4D2", awayFontColor = "0x212339"},  
  { teamid = 112606, homeColor = "0x5F299E", awayColor ="0xDBCAAA",homeFontColor = "0xDBCAAA", awayFontColor = "0x5F299E"},
  { teamid = 112828, homeColor = "0x7BA5DB", awayColor ="0x212339",homeFontColor = "0xE9760C", awayFontColor = "0xE9760C"},  
  { teamid = 112885, homeColor = "0x830404", awayColor ="0x1C1C1C",homeFontColor = "0x998959", awayFontColor = "0x998959"},  
  { teamid = 112893, homeColor ="0xEFB2C9" , awayColor ="0x040404",homeFontColor = "0x040404", awayFontColor ="0xEFB2C9" },  
  { teamid = 112996, homeColor ="0xE7E7E7" , awayColor ="0x040404",homeFontColor = "0xC3A363", awayFontColor ="0xC3A363" },
  { teamid = 113149, homeColor ="0x1B3265" , awayColor = "0xF26B3C",homeFontColor = "0xF26B3C", awayFontColor = "0x1B3265"},  
  { teamid = 114640, homeColor = "0x1484CC", awayColor ="0x3040505",homeFontColor = "0xC7CCCE", awayFontColor = "0xC7CCCE"},
  { teamid = 155600, homeColor = "0x00177B", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x00177B"},
   { teamid = 155607, homeColor = "0xEA0022", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0xEA0022"},
   { teamid = 155606, homeColor = "0xffffff", awayColor = "0xFF7B30", homeFontColor = "0xFF7B30", awayFontColor ="0xFFFFFF"},
   { teamid = 155611, homeColor = "0x373737", awayColor = "0xffffff", homeFontColor = "0xEDCF5C", awayFontColor ="0x373737"},
   { teamid = 155614, homeColor = "0xDD2829", awayColor = "0x353535", homeFontColor = "0x353535", awayFontColor ="0xffffff"},
   { teamid = 155621, homeColor = "0xE71925", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0xE71925"},
   { teamid = 155604, homeColor = "0x0B6400", awayColor = "0xffffff", homeFontColor = "0xFAFF00", awayFontColor ="0x0B6400"},
   { teamid = 155602, homeColor = "0x007AE3", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x007AE3"},
   { teamid = 155603, homeColor = "0xFF1900", awayColor = "0xffffff", homeFontColor = "0xFFD800", awayFontColor ="0xFF1900"},
   { teamid = 155612, homeColor = "0x7B00D7", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0xD90010"},
   { teamid = 155616, homeColor = "0xD50500", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0xD50500"},
   { teamid = 155617, homeColor = "0x6925DE", awayColor = "0xFFF9DD", homeFontColor = "0xffffff", awayFontColor ="0x6925DE"},
   { teamid = 155620, homeColor = "0x66D8CC", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x66D8CC"},
   { teamid = 155605, homeColor = "0x3338AF", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x3338AF"},
   { teamid = 155601, homeColor = "0xCE2C32", awayColor = "0xF2F2F2", homeFontColor = "0xffffff", awayFontColor ="0xCE2C32"},
   { teamid = 155615, homeColor = "0x008548", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x008548"},
   { teamid = 155610, homeColor = "0xFFE300", awayColor = "0x343434", homeFontColor = "0xffffff", awayFontColor ="0xFFE300"},
   { teamid = 155618, homeColor = "0xFF3029", awayColor = "0xFFD400", homeFontColor = "0xffffff", awayFontColor ="0x000000"},
   { teamid = 383, homeColor = "0x0B6121", awayColor = "0xE6E6E6" },
  { teamid = 517, homeColor = "0x000000", awayColor = "0xFFFFFF" },
  { teamid = 567, homeColor = "0x610B38", awayColor = "0xFFFFFF" },
  { teamid = 568, homeColor = "0x0404B4", awayColor = "0xFFFFFF" },
  { teamid = 598, homeColor = "0xFFFFFF", awayColor = "0xB40404" },
  { teamid = 1035, homeColor = "0x000000", awayColor = "0xBDBDBD" },
  { teamid = 1039, homeColor = "0xB40404", awayColor = "0x81BEF7" },
  { teamid = 1041, homeColor = "0xFFFFFF", awayColor = "0x000000" },
  { teamid = 1043, homeColor = "0xB40404", awayColor = "0xFFFFFF" },
  { teamid = 1048, homeColor = "0xDF013A", awayColor = "0xE6E6E6" },
  { teamid = 1053, homeColor = "0xFFFFFF", awayColor = "0x000000" },
  { teamid = 1629, homeColor = "0x58ACFA", awayColor = "0xFFFFFF" },
  { teamid = 1884, homeColor = "0x0431B4", awayColor = "0xFFFFFF" },
  { teamid = 111059, homeColor = "0x000000", awayColor = "0xFFFFFF" },
  { teamid = 111976, homeColor = "0x2E64FE", awayColor = "0xE6E6E6" },
  { teamid = 112001, homeColor = "0x088A29", awayColor = "0xFFFFFF" },
  { teamid = 112119, homeColor = "0xB40431", awayColor = "0xFFFFFF" },
  { teamid = 112472, homeColor = "0xFFFFFF", awayColor = "0x1C1C1C" },
  { teamid = 111046, homeColor = "0xFACC2E", awayColor = "0xffffff" },
  { teamid = 111057, homeColor = "0xD81900", awayColor = "0xFFD200" },
  { teamid = 130361, homeColor = "0xFFF500", awayColor = "0xFFEC00" },
  { teamid = 111059, homeColor = "0x000000", awayColor = "0xffffff" },
  { teamid = 110059, homeColor = "0x000000", awayColor = "0xffffff" }
}

UCLTeamsData = {
  { teamid = 1, homeColor = "0x9d1a27", awayColor = "0x000000", homeFontColor = "0xFFFFFF", awayFontColor = "0x942528" },
  { teamid = 2, homeColor = "0x5c253f", awayColor ="0x80a5ca",homeFontColor = "0x80a5ca", awayFontColor = "0x000000"},
  { teamid = 5, homeColor = "0x084B8A", awayColor ="0x084B8A",homeFontColor = "0xFFFFFF", awayFontColor = "0xffffff"},
  { teamid = 7, homeColor = "0x1e406d", awayColor = "0xe19bc7",homeFontColor = "0xFFFFFF", awayFontColor = "0x1e406d" },
  { teamid = 9, homeColor = "0x942528", awayColor = "0xFFFFFF",homeFontColor = "0xFFFFFF", awayFontColor = "0x942528"},
  { teamid = 10, homeColor = "0x58D3F7", awayColor = "0xD7DF01",homeFontColor = "0xFFFFFF", awayFontColor = "0x0A122A"},
  { teamid = 11, homeColor = "0xb7243b", awayColor ="0x0B2161",homeFontColor ="0xFFFFFF" , awayFontColor = "0xb7243b"},
  { teamid = 13, homeColor = "0x000000" , awayColor ="0x088A68",homeFontColor = "0xFFFFFF", awayFontColor = "0x000000"},
  { teamid = 17, homeColor = "0xc5c4c3", awayColor = "0x9ebabb",homeFontColor = "0xD8D8D8", awayFontColor = "0xD01818"},
  { teamid = 18, homeColor = "0xedecea", awayColor ="0x424242",homeFontColor = "0x424242", awayFontColor = "0xedecea"},
  { teamid = 19, homeColor = "0x743846" , awayColor = "0x30302e",homeFontColor ="0x80a5ca" , awayFontColor ="0x000000" },  
  { teamid = 8, homeColor = "0xc9c8c7", awayColor ="0xd3d188",homeFontColor = "0xd2d1d0", awayFontColor = "0xaa2327"},  
  { teamid = 14, homeColor = "0xb51e1f", awayColor ="0xe6da4a",homeFontColor = "0xa51b21", awayFontColor = "0xf9f8f8"},  
  { teamid = 110, homeColor = "0xFFBF00", awayColor ="0x386a54",homeFontColor = "0x000000", awayFontColor = "0xFFBF00"},  
  { teamid = 144, homeColor ="0xe9e8e7" , awayColor ="0x7fcabf",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 1796, homeColor = "0x743846" , awayColor = "0x743846",homeFontColor ="0x58D3F7" , awayFontColor ="0x58D3F7" },  
  { teamid = 1799, homeColor ="0xd62d25" , awayColor ="0xcbcbc9",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 1808, homeColor ="0x205da0" , awayColor ="0xd23531",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 1923, homeColor = "0xFF8000" , awayColor = "0xFF8000",homeFontColor ="0x0B3861" , awayFontColor ="0x0B3861" },  
  { teamid = 1925, homeColor ="0xb52328" , awayColor ="0x8dabc9",homeFontColor = "0xFFFFFF", awayFontColor ="0xb52328" },
  { teamid = 1943, homeColor ="0xae272f" , awayColor ="0x5b669d",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 95, homeColor = "0x08088A", awayColor ="0xffffff",homeFontColor = "0xFFFFFF", awayFontColor = "0x08088A"},
  { teamid = 94, homeColor = "0x08298A", awayColor ="0xffffff",homeFontColor = "0xFFFFFF", awayFontColor = "0x08298A"},
  { teamid = 17, homeColor = "0xDF0101", awayColor ="0xffffff",homeFontColor = "0xFFFFFF", awayFontColor = "0xDF0101"},
  { teamid = 57, homeColor = "0xffffff", awayColor = "0x084B8A" },
  { teamid = 1530, homeColor = "0x000000", awayColor = "0xffffff" },
  { teamid = 69, homeColor = "0xDF0101", awayColor = "0x2E2E2E" },
  { teamid = 1819, homeColor = "0x088A4B", awayColor = "0xffffff" },
  { teamid = 71, homeColor = "0xD7DF01", awayColor = "0x000000" },
  { teamid = 1738, homeColor = "0x0489B1", awayColor = "0xffffff" },
  { teamid = 65, homeColor = "0xB40404", awayColor = "0xffffff" },
  { teamid = 70, homeColor = "0x0B2161", awayColor = "0xffffff" },
  { teamid = 72, homeColor = "0xDF0101", awayColor = "0xffffff" },
  { teamid = 66, homeColor = "0xffffff", awayColor = "0x000000" },
  { teamid = 219, homeColor = "0xffffff", awayColor = "0x0B4C5F" },
  { teamid = 73, homeColor = "0x0B2161", awayColor = "0xffffff" },
  { teamid = 64, homeColor = "0xFFBF00", awayColor = "0x585858" },
  { teamid = 76, homeColor = "0x08088A", awayColor = "0xffffff" },
  { teamid = 378, homeColor = "0xffffff", awayColor = "0x084B8A" },
  { teamid = 379, homeColor = "0xDF0101", awayColor = "0x848484" },
  { teamid = 74, homeColor = "0xDF0101", awayColor = "0xffffff" },
  { teamid = 1809, homeColor = "0x380B61", awayColor = "0xffffff" },
  { teamid = 240, homeColor = "0xb73036", awayColor = "0x202123", homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0" },
  { teamid = 241, homeColor = "0x172F8A", awayColor ="0x000000",homeFontColor = "0x101010", awayFontColor = "0xF8D000"},
  { teamid = 1968, homeColor = "0xe0d12d", awayColor ="0x262d43",homeFontColor = "0x30B060", awayFontColor = "0xE0E0E0"},
  { teamid = 243, homeColor = "0xffffff", awayColor = "0xFF9600",homeFontColor = "0xE01820", awayFontColor = "0xE0E0E0" },
  { teamid = 448, homeColor = "0xb92931", awayColor = "0x2a2929",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 449, homeColor = "0x267a48", awayColor = "0x26456f",homeFontColor = "0xE0E0E0", awayFontColor = "0x2838A0"},
  { teamid = 450, homeColor = "0x7db7c7", awayColor ="0x232322",homeFontColor ="0xE0E0E0" , awayFontColor = "0x289880"},
  { teamid = 452, homeColor = "0x1c54b0" , awayColor ="0xe68ab2",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 457, homeColor = "0x364172", awayColor = "0x2a2a28",homeFontColor = "0xD8D8D8", awayFontColor = "0xD01818"},
  { teamid = 453, homeColor = "0xb31f23", awayColor ="0x2b2b2b",homeFontColor = "0xE0E0E0", awayFontColor = "0x50A830"},
  { teamid = 461, homeColor = "0xd5d5d4" , awayColor = "0x282827",homeFontColor ="0x363535" , awayFontColor ="0xd1d1d0" },  
  { teamid = 462, homeColor ="0x664266" , awayColor = "0x502276",homeFontColor = "0xcec29a", awayFontColor = "0xcec29a"},  
  { teamid = 468, homeColor = "0xd2d2d0", awayColor ="0x186237",homeFontColor = "0xd2d1d0", awayFontColor = "0xaa2327"},  
  { teamid = 480, homeColor = "0xd1d0cf", awayColor ="0xca2635",homeFontColor = "0xa51b21", awayFontColor = "0xf9f8f8"},  
  { teamid = 481, homeColor = "0xe2e1e0", awayColor ="0xab202e",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},  
  { teamid = 483, homeColor ="0xdede1b" , awayColor ="0x676276",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 479, homeColor ="0x85232b" , awayColor ="0x2c2c2b",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 1860, homeColor ="0x213a96" , awayColor ="0xb61c33",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 1861, homeColor ="0xbf2729" , awayColor ="0x35abd4",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 110062, homeColor ="0xa32126" , awayColor ="0xfab723",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 21, homeColor = "0xB80018", awayColor = "0xE0E0E0", homeFontColor = "0xE0E0E0", awayFontColor = "0xB80018" },
  { teamid = 22, homeColor = "0xF8D000", awayColor ="0x101010",homeFontColor = "0x101010", awayFontColor = "0xF8D000"},
  { teamid = 23, homeColor = "0xE0E0E0", awayColor ="0x30B060",homeFontColor = "0x30B060", awayFontColor = "0xE0E0E0"},
  { teamid = 25, homeColor = "0x9c2225", awayColor ="0x3e4041",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 31, homeColor = "0xE0E0E0", awayColor = "0xE01820",homeFontColor = "0xE01820", awayFontColor = "0xE0E0E0" },
  { teamid = 32, homeColor = "0xB81020", awayColor = "0x101010",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 36, homeColor = "0xd3d4d3", awayColor ="0xc62432",homeFontColor ="0xc62432" , awayFontColor = "0xd3d4d3"},
  { teamid = 38, homeColor = "0x289880", awayColor ="0xE1B5AD",homeFontColor ="0xE0E0E0" , awayFontColor = "0x289880"},
  { teamid = 160, homeColor ="0x1d3552" , awayColor ="0x65a7d4",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 169, homeColor = "0xD01818", awayColor = "0xD8D8D8",homeFontColor = "0xD8D8D8", awayFontColor = "0xD01818"},
  { teamid = 175, homeColor = "0x50A830", awayColor ="0x383C3D",homeFontColor = "0xE0E0E0", awayFontColor = "0x50A830"},
  { teamid = 1824, homeColor ="0xD7D7D5" , awayColor ="0x323231",homeFontColor = "0x323231", awayFontColor ="0xD7D7D5" },  
  { teamid = 1831, homeColor ="0xbc1e20" , awayColor ="0xd5cbbb",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 10029, homeColor ="0x204390" , awayColor = "0xcec29a",homeFontColor = "0xcec29a", awayFontColor = "0x204390"},  
  { teamid = 100409, homeColor = "0xaa2327", awayColor ="0xd2d1d0",homeFontColor = "0xd2d1d0", awayFontColor = "0xaa2327"}, 
  { teamid = 112172, homeColor = "0xf9f8f8", awayColor ="0xa51b21",homeFontColor = "0xa51b21", awayFontColor = "0xf9f8f8"},   
  { teamid = 111235, homeColor = "0xC7181D", awayColor = "0x2958A0",homeFontColor = "0x2958A0", awayFontColor = "0xC7181D"},
  { teamid = 110502, homeColor = "0xD0CFCE", awatColor = "0x313447", homeFontColor = "0x313447", awayFontColor = "0xD0CFCE"},
}

ConmebolTeamsData = {
  { teamid = 383, homeColor = "0x16B100", awayColor = "0xE6E6E6" },
  { teamid = 517, homeColor = "0x303030", awayColor = "0xE0E0E0" },
  { teamid = 567, homeColor = "0x610B38", awayColor = "0xE0E0E0" },
  { teamid = 568, homeColor = "0x0404B4", awayColor = "0xE0E0E0" },
  { teamid = 598, homeColor = "0xE0E0E0", awayColor = "0xB40404" },
  { teamid = 1035, homeColor = "0x303030", awayColor = "0xBDBDBD" },
  { teamid = 1039, homeColor = "0xB40404", awayColor = "0x81BEF7" },
  { teamid = 1041, homeColor = "0xE0E0E0", awayColor = "0x303030" },
  { teamid = 1043, homeColor = "0xB40404", awayColor = "0xE0E0E0" },
  { teamid = 1048, homeColor = "0xDF013A", awayColor = "0xE6E6E6" },
  { teamid = 1053, homeColor = "0xE0E0E0", awayColor = "0x303030" },
  { teamid = 1598, homeColor = "0x4D7AD8", awayColor = "0x4D7AD8" },
  { teamid = 1629, homeColor = "0x58ACFA", awayColor = "0xE0E0E0" },
  { teamid = 1719, homeColor = "0xC90005", awayColor = "0xE0E0E0" },
  { teamid = 1884, homeColor = "0x0431B4", awayColor = "0xE0E0E0" },
  { teamid = 111052, homeColor = "0x1346E3", awayColor = "0xE01A16" },
  { teamid = 111059, homeColor = "0x303030", awayColor = "0xE0E0E0" },
  { teamid = 111976, homeColor = "0x2E64FE", awayColor = "0xE6E6E6" },
  { teamid = 112001, homeColor = "0x088A29", awayColor = "0xE0E0E0" },
  { teamid = 112119, homeColor = "0xB40431", awayColor = "0xE0E0E0" },
  { teamid = 112472, homeColor = "0xE0E0E0", awayColor = "0x1C1C1C" },
  { teamid = 111046, homeColor = "0xFACC2E", awayColor = "0xE0E0E0" },
  { teamid = 111057, homeColor = "0xD81900", awayColor = "0xFFD200" },
  { teamid = 130361, homeColor = "0xFFF500", awayColor = "0xFFEC00" },
  { teamid = 111059, homeColor = "0x303030", awayColor = "0xE0E0E0" },
  { teamid = 110059, homeColor = "0x303030", awayColor = "0xE0E0E0" },
  { teamid = 1877, homeColor = "0x0300BA", awayColor = "0xE0E0E0" },
  { teamid = 1876, homeColor = "0xFFFFFF", awayColor = "0xDA0300" },
}

EnglandTeamsData = {
  { teamid = 1, homeColor = "0x9d1a27", awayColor = "0x001FA3", homeFontColor = "0xFFFFFF", awayFontColor = "0x9d1a27" },
  { teamid = 2, homeColor = "0x5c253f", awayColor ="0x1C1C1C",homeFontColor = "0x80a5ca", awayFontColor = "0xFFFFFF"},
  { teamid = 5, homeColor = "0x084B8A", awayColor ="0xF0F9F1",homeFontColor = "0xFFFFFF", awayFontColor = "0x255527"},
  { teamid = 7, homeColor = "0x1e406d", awayColor = "0xFFFBEC",homeFontColor = "0xFFFFFF", awayFontColor = "0x1e406d" },
  { teamid = 9, homeColor = "0x942528", awayColor = "0xFFFFFF",homeFontColor = "0xFFFFFF", awayFontColor = "0x942528"},
  { teamid = 10, homeColor = "0x58D3F7", awayColor = "0x2E2E2E",homeFontColor = "0xFFFFFF", awayFontColor = "0xFFFFFF"},
  { teamid = 11, homeColor = "0xb7243b", awayColor ="0xF4DCFF",homeFontColor ="0xFFFFFF" , awayFontColor = "0x36004E"},
  { teamid = 13, homeColor = "0x000000" , awayColor ="0x29AC50",homeFontColor = "0xFFFFFF", awayFontColor = "0x000000"},
  { teamid = 18, homeColor = "0xedecea", awayColor ="0x292929",homeFontColor = "0x424242", awayFontColor = "0xFFFFFF"},
  { teamid = 19, homeColor = "0x743846" , awayColor = "0x252525",homeFontColor ="0x80a5ca" , awayFontColor ="0x743846" },  
  { teamid = 8, homeColor = "0xF8F8F8", awayColor ="0xEAD02C",homeFontColor = "0x4356EE", awayFontColor = "0x4356EE"},  
  { teamid = 14, homeColor = "0xb51e1f", awayColor ="0xFAF8E4",homeFontColor = "0xFFFFFF", awayFontColor = "0xb51e1f"},  
  { teamid = 110, homeColor = "0xFFBF00", awayColor ="0x272727",homeFontColor = "0x000000", awayFontColor = "0xFFC600"},  
  { teamid = 144, homeColor ="0xe9e8e7" , awayColor ="0x7fcabf",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 1796, homeColor = "0x743846" , awayColor = "0x303030",homeFontColor ="0x58D3F7" , awayFontColor ="0xCF72C1" },  
  { teamid = 1799, homeColor ="0xd62d25" , awayColor ="0xFFEF18",homeFontColor = "0xE0E0E0", awayFontColor ="0x001E63" },
  { teamid = 1808, homeColor ="0x205da0" , awayColor ="0xFFB600",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 1925, homeColor ="0xb52328" , awayColor ="0xC98DC7",homeFontColor = "0xFFFFFF", awayFontColor ="0x5A3757" },
  { teamid = 1943, homeColor ="0xae272f" , awayColor ="0x5b669d",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 106, homeColor = "0xE23641", awayColor ="0x3D7BDE",homeFontColor = "0xFFFFFF", awayFontColor = "0xE23641"},
}

FranceTeamsData = {
  { teamid = 57, homeColor = "0xffffff", awayColor = "0x084B8A" },
  { teamid = 1530, homeColor = "0x000000", awayColor = "0xffffff" },
  { teamid = 69, homeColor = "0xDF0101", awayColor = "0x2E2E2E" },
  { teamid = 1819, homeColor = "0x088A4B", awayColor = "0xffffff" },
  { teamid = 71, homeColor = "0xD7DF01", awayColor = "0x000000" },
  { teamid = 1738, homeColor = "0x0489B1", awayColor = "0xffffff" },
  { teamid = 65, homeColor = "0xB40404", awayColor = "0xffffff" },
  { teamid = 70, homeColor = "0x0B2161", awayColor = "0xffffff" },
  { teamid = 72, homeColor = "0xDF0101", awayColor = "0xffffff" },
  { teamid = 66, homeColor = "0xffffff", awayColor = "0x000000" },
  { teamid = 219, homeColor = "0xffffff", awayColor = "0x0B4C5F" },
  { teamid = 73, homeColor = "0x0B2161", awayColor = "0xffffff" },
  { teamid = 64, homeColor = "0xFFBF00", awayColor = "0x585858" },
  { teamid = 76, homeColor = "0x08088A", awayColor = "0xffffff" },
  { teamid = 378, homeColor = "0xffffff", awayColor = "0x084B8A" },
  { teamid = 379, homeColor = "0xDF0101", awayColor = "0x848484" },
  { teamid = 74, homeColor = "0xDF0101", awayColor = "0xffffff" },
  { teamid = 1809, homeColor = "0x380B61", awayColor = "0xffffff" },
}

BrazilTeamsData = {
  { teamid = 383, homeColor = "0x16B100", awayColor = "0x16B100" },
  { teamid = 517, homeColor = "0x303030", awayColor = "0x303030" },
  { teamid = 567, homeColor = "0x610B38", awayColor = "0x610B38" },
  { teamid = 568, homeColor = "0x2162FF", awayColor = "0x2162FF" },
  { teamid = 569, homeColor = "0x0B0B0B", awayColor = "0x0B0B0B" },
  { teamid = 598, homeColor = "0xB40404", awayColor = "0xB40404" },
  { teamid = 1035, homeColor = "0x424242", awayColor = "0x424242" },
  { teamid = 1039, homeColor = "0xB40404", awayColor = "0xB40404" },
  { teamid = 1041, homeColor = "0x343434", awayColor = "0x343434" },
  { teamid = 1043, homeColor = "0xB40404", awayColor = "0xB40404" },
  { teamid = 1048, homeColor = "0xFF0300", awayColor = "0xFF0300" },
  { teamid = 1053, homeColor = "0x696969", awayColor = "0x696969" },
  { teamid = 1598, homeColor = "0x4D7AD8", awayColor = "0x4D7AD8" },
  { teamid = 1629, homeColor = "0x58ACFA", awayColor = "0x58ACFA" },
  { teamid = 1719, homeColor = "0xC90005", awayColor = "0xC90005" },
  { teamid = 1884, homeColor = "0x0431B4", awayColor = "0xE0E0E0" },
  { teamid = 110059, homeColor = "0x323232", awayColor = "0x323232" },
  { teamid = 111041, homeColor = "0x60C400", awayColor = "0x60C400" },
  { teamid = 111043, homeColor = "0xCCCCCC", awayColor = "0x323232" },
  { teamid = 111046, homeColor = "0xFACC2E", awayColor = "0xFACC2E" },
  { teamid = 111050, homeColor = "0xE31F05", awayColor = "0xF82400" },
  { teamid = 111052, homeColor = "0x1346E3", awayColor = "0x1346E3" },
  { teamid = 111057, homeColor = "0xD81900", awayColor = "0xD81900" },
  { teamid = 111059, homeColor = "0x323232", awayColor = "0x323232" },
  { teamid = 111976, homeColor = "0x2E64FE", awayColor = "0xE6E6E6" },
  { teamid = 112001, homeColor = "0x12B100", awayColor = "0xCCCCCC" },
  { teamid = 112119, homeColor = "0xB40431", awayColor = "0xE0E0E0" },
  { teamid = 112472, homeColor = "0xFF3500", awayColor = "0xFF3500" },
  { teamid = 130361, homeColor = "0xFFF500", awayColor = "0xFFF500" },
  { teamid = 132057, homeColor = "0xF1F1F1", awayColor = "0xE62C00" },
  { teamid = 132059, homeColor = "0xFFCC00", awayColor = "0xE4E4E4" },
  { teamid = 132062, homeColor = "0xEC2C00", awayColor = "0xEF2400" },
  { teamid = 132063, homeColor = "0x7AD5FF", awayColor = "0x94E7F8" },
  { teamid = 132065, homeColor = "0xFBFBFB", awayColor = "0xF22600" },
  { teamid = 132066, homeColor = "0x353535", awayColor = "0xF8F8F8" },
  { teamid = 132067, homeColor = "0xFFCC00", awayColor = "0xE4E4E4" },
  { teamid = 132068, homeColor = "0x2E2E2E", awayColor = "0xD6D6D6" },
}

PaulistaTeamsData = {
  { teamid = 383, homeColor = "0x16B100", awayColor = "0x16B100", homeFontColor = "0xFFFFFF", awayFontColor = "0xFFFFFF" },
  { teamid = 598, homeColor = "0xEEEEEE", awayColor ="0xE91E18",homeFontColor = "0x000000", awayFontColor = "0xFFFFFF"},
  { teamid = 1041, homeColor = "0xEEEEEE", awayColor ="0x000000",homeFontColor = "0x000000", awayFontColor = "0xFFFFFF"},
  { teamid = 1053, homeColor = "0xEEEEEE", awayColor = "0x000000",homeFontColor = "0x000000", awayFontColor = "0xFFFFFF" },
  { teamid = 112472, homeColor = "0xEEEEEE", awayColor = "0xEEEEEE",homeFontColor = "0xEB3506", awayFontColor = "0xEB3506"},
  { teamid = 132059, homeColor = "0xFFCC00", awayColor = "0xFFCC00",homeFontColor = "0x000000", awayFontColor = "0x000000"},
  { teamid = 132067, homeColor = "0xFFCC00", awayColor ="0xEEEEEE",homeFontColor ="0x000000" , awayFontColor = "0x000000"},
  { teamid = 130361, homeColor = "0xFFF500" , awayColor ="0xEEEEEE",homeFontColor = "0x00A316", awayFontColor = "0x00A316"},
}

GermanyTeamsData = {
  { teamid = 21, homeColor = "0xB80018", awayColor = "0xE0E0E0", homeFontColor = "0xE0E0E0", awayFontColor = "0xB80018" },
  { teamid = 22, homeColor = "0xF8D000", awayColor ="0x101010",homeFontColor = "0x101010", awayFontColor = "0xF8D000"},
  { teamid = 23, homeColor = "0xE0E0E0", awayColor ="0x30B060",homeFontColor = "0x30B060", awayFontColor = "0xE0E0E0"},
  { teamid = 25, homeColor = "0x9c2225", awayColor ="0x3e4041",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 31, homeColor = "0xE0E0E0", awayColor = "0xE01820",homeFontColor = "0xE01820", awayFontColor = "0xE0E0E0" },
  { teamid = 32, homeColor = "0xB81020", awayColor = "0x101010",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 36, homeColor = "0xd3d4d3", awayColor ="0xc62432",homeFontColor ="0xc62432" , awayFontColor = "0xd3d4d3"},
  { teamid = 38, homeColor = "0x289880", awayColor ="0xE1B5AD",homeFontColor ="0xE0E0E0" , awayFontColor = "0x289880"},
  { teamid = 160, homeColor ="0x1d3552" , awayColor ="0x65a7d4",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 169, homeColor = "0xD01818", awayColor = "0xD8D8D8",homeFontColor = "0xD8D8D8", awayFontColor = "0xD01818"},
  { teamid = 175, homeColor = "0x50A830", awayColor ="0x383C3D",homeFontColor = "0xE0E0E0", awayFontColor = "0x50A830"},
  { teamid = 1824, homeColor ="0xD7D7D5" , awayColor ="0x323231",homeFontColor = "0x323231", awayFontColor ="0xD7D7D5" },  
  { teamid = 1831, homeColor ="0xbc1e20" , awayColor ="0xd5cbbb",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 10029, homeColor ="0x204390" , awayColor = "0xcec29a",homeFontColor = "0xcec29a", awayFontColor = "0x204390"},  
  { teamid = 100409, homeColor = "0xaa2327", awayColor ="0xd2d1d0",homeFontColor = "0xd2d1d0", awayFontColor = "0xaa2327"}, 
  { teamid = 112172, homeColor = "0xf9f8f8", awayColor ="0xa51b21",homeFontColor = "0xa51b21", awayFontColor = "0xf9f8f8"},   
  { teamid = 111235, homeColor = "0xC7181D", awayColor = "0x2958A0",homeFontColor = "0x2958A0", awayFontColor = "0xC7181D"},
  { teamid = 110502, homeColor = "0xD0CFCE", awatColor = "0x313447", homeFontColor = "0x313447", awayFontColor = "0xD0CFCE"},
}

Germany2TeamsData = {
  { teamid = 27, homeColor ="0x1D4382", awayColor = "0xC3C2C1", homeFontColor = "0xC3C2C1", awayFontColor = "0x1D4382"},
  { teamid = 28, homeColor = "0xD0CFCE", awayColor = "0x313447", homeFontColor = "0x313447", awayFontColor = "0xD0CFCE"},
  { teamid = 29, homeColor ="0xB80018", awayColor = "0xC3C2C1", homeFontColor = "0xC3C2C1", awayFontColor = "0xB80018"},
  { teamid = 34, homeColor = "0x2838A0", awayColor = "0xD8D8D8",homeFontColor = "0xE0E0E0", awayFontColor = "0x2838A0"},
  -- { teamid = 159, homeColor = "0x2838A0", awayColor = "0xD8D8D8",homeFontColor = "0xE0E0E0", awayFontColor = "0x2838A0"},
  { teamid = 165, homeColor = "0x61D386" , awayColor ="0x000000",homeFontColor = "0x000000", awayFontColor = "0x61D386"},
  { teamid = 166, homeColor = "0x284090" , awayColor ="0x182038",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 171, homeColor = "0x3D181F", awayColor = "0xDFD5D3", homeFontColor = "0xDFD5D3", awayFontColor = "0x3D181F" },
  { teamid = 485, homeColor = "0xC73C40", awayColor = "0x3E4743", homeFontColor = "0xffffff", awayFontColor = "0xffffff" },
  -- { teamid = 543, homeColor = "0xD9D8D7", awayColor = "0xBD3640", homeFontColor = "0xBD3640", awayFontColor = "0xD9D8D7" },
  { teamid = 576, homeColor = "0x355E9B", awayColor = "0xD4D4D2", homeFontColor = "0xD4D4D2", awayFontColor = "0x355E9B" },
  { teamid = 1832, homeColor = "0x284390", awayColor = "0xF3E8E6", homeFontColor = "0xF3E8E6", awayFontColor = "0x284390" },
  { teamid = 10030, homeColor = "0x2F519B", awayColor = "0xEC242E", homeFontColor = "0xEC242E", awayFontColor = "0x2F519B" },
  -- { teamid = 110178, homeColor = "0xFEFEFE", awayColor ="0x1B1B1B", homeFontColor = "0x1B1B1B", awayFontColor = "0xFEFEFE"},
  { teamid = 110329, homeColor = "0x4B3A33", awayColor = "0xE3E2E0", homeFontColor = "0xE3E2E0", awayFontColor = "0x4B3A33"},
  { teamid = 110500, homeColor = "0xFFE313", awayColor = "0x2D64B7", homeFontColor = "0x2D64B7", awayFontColor = "0xFFE313"},
  { teamid = 110588, homeColor = "0x0D3362", awayColor ="0x0F0F0F",homeFontColor = "0x0F0F0F", awayFontColor = "0xffffff"},
  { teamid = 110636, homeColor = "0x891321", awayColor ="0xFFFFFD",homeFontColor = "0xFFFFFD", awayFontColor = "0x891321"},
  { teamid = 492, homeColor = "0x252524", awayColor ="0x6D9FB2",homeFontColor = "0xffffff", awayFontColor = "0x382B47"},
  { teamid = 487, homeColor = "0x633D86", awayColor ="0xBEBEC0",homeFontColor = "0xFFFFFF", awayFontColor = "0x633485"},
}

SpainTeamsData = {
  { teamid = 240, homeColor = "0xb73036", awayColor = "0x202123", homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0" },
  { teamid = 241, homeColor = "0x202581", awayColor ="0x000000",homeFontColor = "0x101010", awayFontColor = "0xF8D000"},
  { teamid = 1968, homeColor = "0xe0d12d", awayColor ="0x262d43",homeFontColor = "0x30B060", awayFontColor = "0xE0E0E0"},
  { teamid = 243, homeColor = "0xffffff", awayColor = "0xFF9B00",homeFontColor = "0xE01820", awayFontColor = "0xE0E0E0" },
  { teamid = 448, homeColor = "0xb92931", awayColor = "0x2a2929",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 449, homeColor = "0x267a48", awayColor = "0x26456f",homeFontColor = "0xE0E0E0", awayFontColor = "0x2838A0"},
  { teamid = 450, homeColor = "0x7db7c7", awayColor ="0x232322",homeFontColor ="0xE0E0E0" , awayFontColor = "0x289880"},
  { teamid = 452, homeColor = "0x1c54b0" , awayColor ="0xe68ab2",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},
  { teamid = 457, homeColor = "0x364172", awayColor = "0x2a2a28",homeFontColor = "0xD8D8D8", awayFontColor = "0xD01818"},
  { teamid = 453, homeColor = "0xb31f23", awayColor ="0x2b2b2b",homeFontColor = "0xE0E0E0", awayFontColor = "0x50A830"},
  { teamid = 461, homeColor = "0xd5d5d4" , awayColor = "0x282827",homeFontColor ="0x363535" , awayFontColor ="0xd1d1d0" },  
  { teamid = 462, homeColor ="0x664266" , awayColor = "0x502276",homeFontColor = "0xcec29a", awayFontColor = "0xcec29a"},  
  { teamid = 468, homeColor = "0xd2d2d0", awayColor ="0x186237",homeFontColor = "0xd2d1d0", awayFontColor = "0xaa2327"},  
  { teamid = 480, homeColor = "0xd1d0cf", awayColor ="0xca2635",homeFontColor = "0xa51b21", awayFontColor = "0xf9f8f8"},  
  { teamid = 481, homeColor = "0xe2e1e0", awayColor ="0xab202e",homeFontColor = "0xE0E0E0", awayFontColor = "0xE0E0E0"},  
  { teamid = 483, homeColor ="0xdede1b" , awayColor ="0x676276",homeFontColor = "0xd5cbbb", awayFontColor ="0xbc1e20" },  
  { teamid = 479, homeColor ="0x85232b" , awayColor ="0x2c2c2b",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 1860, homeColor ="0x213a96" , awayColor ="0xb61c33",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" }, 
  { teamid = 1861, homeColor ="0xbf2729" , awayColor ="0x35abd4",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
  { teamid = 110062, homeColor ="0xa32126" , awayColor ="0xfab723",homeFontColor = "0xE0E0E0", awayFontColor ="0x202838" },
}

SaudiArabiaTeamsData = {
  { teamid = 605, homeColor = "0x016ADB", awayColor = "0x016ADB", homeFontColor = "0xFFFFFF", awayFontColor ="0xFFFFFF" },
  { teamid = 607, homeColor = "0xFFE400", awayColor = "0xE8E8E8", homeFontColor = "0x000000", awayFontColor ="0x000000" },
  { teamid = 111674, homeColor = "0xE6E6E6", awayColor = "0x424242", homeFontColor = "0x000000", awayFontColor ="0xFFFFFF" },
  { teamid = 112096, homeColor = "0x007F1B", awayColor = "0x007F1B", homeFontColor = "0xFFFFFF", awayFontColor ="0xFFFFFF" },
  { teamid = 112139, homeColor = "0xF2E701", awayColor = "0xF2E701", homeFontColor = "0x000000", awayFontColor ="0x000000" },
  { teamid = 112387, homeColor = "0xDFDFDF", awayColor = "0x0B6138", homeFontColor = "0x000000", awayFontColor ="0xFFFFFF" },
  { teamid = 112390, homeColor = "0x08088A", awayColor = "0xD8D8D8", homeFontColor = "0xFFFFFF", awayFontColor ="0x000000" },
  { teamid = 112391, homeColor = "0xD50D00", awayColor = "0xE2E2E2", homeFontColor = "0xFFFFFF", awayFontColor ="0x000000" },
  { teamid = 112393, homeColor = "0xFFE300", awayColor = "0x424242", homeFontColor = "0x000000", awayFontColor ="0xFFFFFF" },
  { teamid = 112883, homeColor = "0xFFDB00", awayColor = "0x009419", homeFontColor = "0x000000", awayFontColor ="0xFFFFFF" },
  { teamid = 113037, homeColor = "0xD50D00", awayColor = "0xE2E2E2", homeFontColor = "0xFFFFFF", awayFontColor ="0x000000" },
  { teamid = 113057, homeColor = "0xFF7B00", awayColor = "0x00D0FF", homeFontColor = "0x000000", awayFontColor ="0xFFFFFF" },
  { teamid = 113060, homeColor = "0xECF7F8", awayColor = "0x19204D", homeFontColor = "0x000000", awayFontColor ="0xFFFFFF" },
  { teamid = 113222, homeColor = "0xFFE300", awayColor = "0x30416F", homeFontColor = "0xFFFFFF", awayFontColor ="0xFFFFFF" },
  { teamid = 115892, homeColor = "0x13A25B", awayColor = "0xDCDCDC", homeFontColor = "0xFFFFFF", awayFontColor ="0x000000" },
  { teamid = 131798, homeColor = "0xE6E6E6", awayColor = "0xD1D1D1", homeFontColor = "0x000000", awayFontColor ="0x000000" },
  { teamid = 131735, homeColor = "0x283817", awayColor = "0x83002C", homeFontColor = "0xFFFFFF", awayFontColor ="0xFFFFFF" },
  { teamid = 133217, homeColor = "0xB30D00", awayColor = "0xB30D00", homeFontColor = "0xFFFFFF", awayFontColor ="0xFFFFFF" },
}

UnitedStatesTeamsData = {
  { teamid = 687, homeColor = "0xEBE205", awayColor = "0x000000", homeFontColor = "0x000000", awayFontColor = "0xEBE205" },
  { teamid = 688, homeColor = "0x0B0908", awayColor ="0xE30423",homeFontColor = "0xE30423", awayFontColor = "0x0B0908"},
  { teamid = 689, homeColor = "0xCF0D2C", awayColor ="0xEAE3D6",homeFontColor = "0xEAE3D6", awayFontColor = "0xCF0D2C"},
  { teamid = 691, homeColor = "0x8C809F", awayColor = "0x051434",homeFontColor = "0x051434", awayFontColor = "0x8C809F" },
  { teamid = 693, homeColor = "0xFB0404", awayColor = "0xffffff",homeFontColor = "0xffffff", awayFontColor = "0xFB0404"},
  { teamid = 694, homeColor = "0x9A0835", awayColor = "0xC5CBD6",homeFontColor = "0xC5CBD6", awayFontColor = "0x9A0835"},
  { teamid = 695, homeColor = "0xD5315B", awayColor ="0xD21443",homeFontColor ="0xFFFFFF" , awayFontColor = "0xFFFFFF"},
  { teamid = 696, homeColor = "0xAABED4", awayColor ="0x0C2D5C",homeFontColor ="0x0C2D5C" , awayFontColor = "0xAABED4"},
  { teamid = 697, homeColor = "0x284090" , awayColor ="0x0E2446",homeFontColor = "0xffff00", awayFontColor = "0xE0E0E0"},
  { teamid = 698, homeColor = "0xEC9233", awayColor = "0x000000",homeFontColor = "0x000000", awayFontColor = "0xEC9233"},
  { teamid = 101112, homeColor = "0x93BBE3", awayColor ="0x0B3A7C",homeFontColor = "0x0B3A7C", awayFontColor = "0x93BBE3"},
  { teamid = 111065, homeColor = "0xA02F39" , awayColor = "0x0B3A7C",homeFontColor ="0x0B3A7C" , awayFontColor ="0xA02F39" },
  { teamid = 111138, homeColor ="0x080D27" , awayColor = "0xA4CDE7",homeFontColor = "0xA4CDE7", awayFontColor = "0x080D27"},  
  { teamid = 111139, homeColor = "0x060D1A", awayColor ="0xD1CDCD",homeFontColor = "0xD1CDCD", awayFontColor = "0x060D1A"},
  { teamid = 111140, homeColor ="0x083C07" , awayColor ="0xA02F39",homeFontColor = "0xE0E0E0", awayFontColor ="0x083C07" },
  { teamid = 111144, homeColor = "0x5CA404", awayColor ="0xE8E8E8",homeFontColor = "0xE8E8E8", awayFontColor = "0x3D3D3D"},
  { teamid = 114161, homeColor = "0x09AE42", awayColor ="0x1F1836",homeFontColor = "0x1F1836", awayFontColor = "0x09AE42"},  
  { teamid = 114162, homeColor = "0xE4E35D", awayColor ="0x1F1836",homeFontColor = "0x1F1836", awayFontColor = "0xE4E35D"},  
  { teamid = 111651, homeColor = "0xAA061D", awayColor ="0x2B2B2B",homeFontColor = "0x2B2B2B", awayFontColor = "0xAA061D"},  
  { teamid = 111928, homeColor ="0x053A97" , awayColor ="0xE2DCDE",homeFontColor = "0xE2DCDE", awayFontColor ="0x053A97" }, 
  { teamid = 112134, homeColor ="0x212339" , awayColor = "0x33A4D2",homeFontColor = "0x33A4D2", awayFontColor = "0x212339"},  
  { teamid = 112606, homeColor = "0x5F299E", awayColor ="0xDBCAAA",homeFontColor = "0xDBCAAA", awayFontColor = "0x5F299E"},
  { teamid = 112828, homeColor = "0x7BA5DB", awayColor ="0x212339",homeFontColor = "0xE9760C", awayFontColor = "0xE9760C"},  
  { teamid = 112885, homeColor = "0x830404", awayColor ="0x1C1C1C",homeFontColor = "0x998959", awayFontColor = "0x998959"},  
  { teamid = 112893, homeColor ="0xEFB2C9" , awayColor ="0x040404",homeFontColor = "0x040404", awayFontColor ="0xEFB2C9" },  
  { teamid = 112996, homeColor ="0xE7E7E7" , awayColor ="0x040404",homeFontColor = "0xC3A363", awayFontColor ="0xC3A363" },
  { teamid = 113149, homeColor ="0x1B3265" , awayColor = "0xF26B3C",homeFontColor = "0xF26B3C", awayFontColor = "0x1B3265"},  
  { teamid = 114640, homeColor = "0x1484CC", awayColor ="0x3040505",homeFontColor = "0xC7CCCE", awayFontColor = "0xC7CCCE"},
}

EuroCopaTeamsData = {
   { teamid = 1318, homeColor = "0xffffff", awayColor = "0x171717", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1319, homeColor = "0x8F0215", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1322, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1325, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1327, homeColor = "0x8F0215", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1328, homeColor = "0xffffff", awayColor = "0x2B2833", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1330, homeColor = "0x8F0215", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1331, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1334, homeColor = "0xffffff", awayColor = "0x33579D", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1335, homeColor = "0x353C50", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1337, homeColor = "0xf5f5f5", awayColor = "0x3B2B2D", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1338, homeColor = "0xffffff", awayColor = "0x066FB9", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1341, homeColor = "0x066FB9", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1343, homeColor = "0x2073BD", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1352, homeColor = "0xB3292D", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1353, homeColor = "0xffffff", awayColor = "0x93353B", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1354, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1355, homeColor = "0x1D834B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1356, homeColor = "0xD0AB20", awayColor = "0xBD2D28", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1357, homeColor = "0x622135", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1359, homeColor = "0x303743", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1360, homeColor = "0x0067A6", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1361, homeColor = "0xffffff", awayColor = "0x0456BE", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1362, homeColor = "0xB3282D", awayColor = "0xF3F781", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1363, homeColor = "0xEBBD35", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1365, homeColor = "0xffffff", awayColor = "0xD2001E", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1366, homeColor = "0xEDE12B", awayColor = "0x3869C0", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1367, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1886, homeColor = "0x9D212D", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 105013, homeColor = "0x0547B4", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 105022, homeColor = "0xF03430", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 105035, homeColor = "0xDB9F30", awayColor = "0x2B315B", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
}

InternationalTeamsData = {
   { teamid = 1318, homeColor = "0xffffff", awayColor = "0x171717", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1319, homeColor = "0x8F0215", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1322, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1325, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1327, homeColor = "0x8F0215", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1328, homeColor = "0xffffff", awayColor = "0x2B2833", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1330, homeColor = "0x8F0215", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1331, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1334, homeColor = "0xffffff", awayColor = "0x33579D", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1335, homeColor = "0x353C50", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1337, homeColor = "0xf5f5f5", awayColor = "0x3B2B2D", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1338, homeColor = "0xffffff", awayColor = "0x066FB9", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1341, homeColor = "0x066FB9", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1343, homeColor = "0x2073BD", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1352, homeColor = "0xB3292D", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1353, homeColor = "0xffffff", awayColor = "0x93353B", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1354, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1355, homeColor = "0x1D834B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1356, homeColor = "0xD0AB20", awayColor = "0xBD2D28", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1357, homeColor = "0x622135", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1359, homeColor = "0x303743", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1360, homeColor = "0x0067A6", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1361, homeColor = "0xffffff", awayColor = "0x0456BE", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1362, homeColor = "0xB3282D", awayColor = "0xF3F781", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1363, homeColor = "0xEBBD35", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1365, homeColor = "0xffffff", awayColor = "0xD2001E", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1366, homeColor = "0xEDE12B", awayColor = "0x3869C0", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1367, homeColor = "0x93353B", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 1886, homeColor = "0x9D212D", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 105013, homeColor = "0x0547B4", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 105022, homeColor = "0xF03430", awayColor = "0xffffff", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
   { teamid = 105035, homeColor = "0xDB9F30", awayColor = "0x2B315B", homeFontColor = "0x202B47", awayFontColor ="0xCD1539"},
}

IndonesiaTeamsData = {
   { teamid = 155600, homeColor = "0x00177B", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x00177B"},
   { teamid = 155607, homeColor = "0xEA0022", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0xEA0022"},
   { teamid = 155606, homeColor = "0xffffff", awayColor = "0xFF7B30", homeFontColor = "0xFF7B30", awayFontColor ="0xFFFFFF"},
   { teamid = 155611, homeColor = "0x373737", awayColor = "0xffffff", homeFontColor = "0xEDCF5C", awayFontColor ="0x373737"},
   { teamid = 155614, homeColor = "0xDD2829", awayColor = "0x353535", homeFontColor = "0x353535", awayFontColor ="0xffffff"},
   { teamid = 155621, homeColor = "0xE71925", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0xE71925"},
   { teamid = 155604, homeColor = "0x0B6400", awayColor = "0xffffff", homeFontColor = "0xFAFF00", awayFontColor ="0x0B6400"},
   { teamid = 155602, homeColor = "0x007AE3", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x007AE3"},
   { teamid = 155603, homeColor = "0xFF1900", awayColor = "0xffffff", homeFontColor = "0xFFD800", awayFontColor ="0xFF1900"},
   { teamid = 155612, homeColor = "0x7B00D7", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0xD90010"},
   { teamid = 155616, homeColor = "0xD50500", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0xD50500"},
   { teamid = 155617, homeColor = "0x6925DE", awayColor = "0xFFF9DD", homeFontColor = "0xffffff", awayFontColor ="0x6925DE"},
   { teamid = 155620, homeColor = "0x66D8CC", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x66D8CC"},
   { teamid = 155605, homeColor = "0x3338AF", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x3338AF"},
   { teamid = 155601, homeColor = "0xCE2C32", awayColor = "0xF2F2F2", homeFontColor = "0xffffff", awayFontColor ="0xCE2C32"},
   { teamid = 155615, homeColor = "0x008548", awayColor = "0xffffff", homeFontColor = "0xffffff", awayFontColor ="0x008548"},
   { teamid = 155610, homeColor = "0xFFE300", awayColor = "0x343434", homeFontColor = "0xffffff", awayFontColor ="0xFFE300"},
   { teamid = 155618, homeColor = "0xFF3029", awayColor = "0xFFD400", homeFontColor = "0xffffff", awayFontColor ="0x000000"},
}

RussiaTeamsData = {
  { teamid = 131743, homeColor = "0x0F0F0F", awayColor = "0xffff", homeFontColor = "0xffffff", awayFontColor = "0xffffff" },
  { teamid = 131742, homeColor = "0x103e7f", awayColor ="0xffffff",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 110239, homeColor = "0xed0d0d", awayColor ="0xf6c531",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 110227, homeColor = "0x850a0a", awayColor = "0x096b22",homeFontColor = "0xffffff", awayFontColor = "0xffffff" },
  { teamid = 112261, homeColor = "0x093066", awayColor = "0xffffff",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 112218, homeColor = "0x0a2c13", awayColor = "0xffffff",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 112217, homeColor = "0x136d7f", awayColor ="0xffffff",homeFontColor ="0xffffff" , awayFontColor = "0xffffff"},
  { teamid = 110232, homeColor = "0xffffff" , awayColor ="0x136d7f",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 110231, homeColor = "0xf6c531", awayColor = "0x093066",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 110109, homeColor = "0x169535", awayColor ="0xffffff",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 100769, homeColor = "0x30a2b9" , awayColor = "0xdfdfdf",homeFontColor ="0xffffff" , awayFontColor ="0xffffff" },  
  { teamid = 100767, homeColor ="0xfb0606" , awayColor = "0xffffff",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},  
  { teamid = 100765, homeColor = "0xc80e0e", awayColor ="0xffffff",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},  
  { teamid = 100764, homeColor = "0x5bc2d6", awayColor ="0xdfdfdf",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},  
  { teamid = 315, homeColor = "0xf11414", awayColor ="0xf7b275",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},  
  { teamid = 312, homeColor ="0xffffff" , awayColor ="0x1c5099",homeFontColor = "0xffffff", awayFontColor ="0xffffff" },
}

LeaguePariTeamsData = {
  { teamid = 110230, homeColor = "0xFF0008", awayColor = "0xFF0008", homeFontColor = "0xffffff", awayFontColor = "0xffffff" },
  { teamid = 110756, homeColor = "0xFFB800", awayColor ="0xFFB800",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 110822, homeColor = "0xB7000B", awayColor ="0xB7000B",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
  { teamid = 111264, homeColor = "0xFF8A00", awayColor = "0xFF8A00",homeFontColor = "0xffffff", awayFontColor = "0xffffff" }
}

UkraineTeamsData = {
  { teamid = 101047, homeColor = "0x0066D0", awayColor = "0x0066D0", homeFontColor = "0xffffff", awayFontColor = "0xffffff" },
  { teamid = 101059, homeColor = "0xFF7E00", awayColor ="0xFF7E00",homeFontColor = "0xffffff", awayFontColor = "0xffffff"},
}

leagueIDs = {
  England = 13,
  France = 16,
  Germany = 19,
  Germany2 = 20,
  Italy = 31,
  Spain = 53,
  SpainB = 54,
  Brazil = 7,
  Mexico = 341,
  Argentina = 353,
  WomensSuperLeague = 2216,
  Indonesia = 2235,
  SaudiArabia = 350,
  UnitedStates = 39,
  Russia = 67,
  LeaguePari = 2245,
  Ukraine = 332,
  International = 78
}

EnglandTeams = nil
FranceTeams = nil
GermanyTeams = nil
Germany2Teams = nil
SpainTeams = nil
SpainBTeams = nil
ItalyTeams = nil
BrazilTeams = nil
MexicoTeams = nil
ArgentinaTeams = nil
WomensSuperLeagueTeams = nil
IndonesiaTeams = nil
SaudiArabiaTeams = nil
UnitedStatesTeams = nil
RussiaTeams = nil
LeaguePariTeams = nil
UkraineTeams = nil
InternationalTeams = nil


EAFCInfo = {
	bnd_fontFace = "$CruyffSans-Heavy",
    bnd_forceCaps = true,
    bnd_short_name_visible = true,
    bnd_teamLabel_visible = false,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 725,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 0
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 0,
    bnd_homelabel_left = -150,
    bnd_homelabel_top = -70,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 30,
    bnd_homeLabel_fontColor = "0x000000",
    bnd_homelabel_short_fontcolor = "0x000000",
    bnd_awaylabel_left = -150,
    bnd_awaylabel_top = 70,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 30,
    bnd_awaylabel_fontColor = "0x000000",
    bnd_awaylabel_short_fontcolor = "0x000000",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 0,
    bnd_crest_image_width = 120,
    bnd_crest_image_height = 120,
    bnd_homecrest_left = 280,
    bnd_homecrest_top = -20,
    bnd_homecrest_color = "0x000000",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 280,
    bnd_awaycrest_top = 20,
    bnd_awaycrest_color = "0x000000",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 130,
    bnd_stadium_color = "0x000000",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 0,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -135,
    bnd_title_color = "0x000000",
    bnd_title_text = "",
    bnd_title_fontSize = 10,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "VS",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0x000000",
    bnd_vs_left = -150,
    bnd_vs_top = 0,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 0
    },
    bnd_logo_height = 100,
    bnd_logo_width = 100,
    bnd_logo_left = 0,
    bnd_logo_top = -100,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 210,
    bnd_homeLabel_rect_left = -256,
    bnd_homeLabel_rect_top = 89,
    bnd_awayLabel_rect_left = 256,
    bnd_awayLabel_rect_top = -91
}

DFLInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = "0_DFL"
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -180,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 180,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 203,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -198,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x000000",
    bnd_vs_left = -2,
    bnd_vs_top = 95,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 0
    },
    bnd_logo_height = 80,
    bnd_logo_width = 80,
    bnd_logo_left = 190,
    bnd_logo_top = 180,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

EnglandInfo = {
  bnd_fontFace = "$PremierLeague",
  bnd_forceCaps = true,
  bnd_short_name_visible = true,
  bnd_teamLabel_visible = false,
  bnd_background_show = true,
  --bnd_background_height = 1920,
  --bnd_background_width = 1080,
  bnd_background_alignV = "FILL",
  bnd_background_alignH = "FILL",
  bnd_background_bottom = 0,
  bnd_background = {
    name = "$MatchInfo",
    id = 13
  },
  bnd_background_alpha = 1,
  bnd_background_alpha_1 = 0.9,
  
  bnd_label_height = 1500,
  bnd_label_width = 700,
  bnd_label_text_top = 0,
  bnd_homelabel_left = -350,
  bnd_homelabel_top = -200,
  bnd_homelabel_color = "",
  bnd_homelabel_text = "",
  bnd_homelabel_fontSize = 0,
  bnd_homelabel_short = "",
  bnd_homelabel_short_fontSize = 70,
  bnd_homelabel_text_fontcolor = "0xffffff",
  bnd_homeLabel_alignH = "CENTER",
  
  bnd_awaylabel_left = 350,
  bnd_awaylabel_top = 150,
  bnd_awaylabel_color = "",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 0,
  bnd_awaylabel_short = "",
  bnd_awaylabel_short_fontSize = 70,
  bnd_awaylabel_text_fontcolor = "0xffffff",
  bnd_awayLabel_alignH = "CENTER",
  
  bnd_label_rect_height = 0,
  bnd_label_rect_width = 0,
  bnd_homelabel_rect_left = -350,
  bnd_homelabel_rect_top = 0,
  bnd_awaylabel_rect_left = 350,
  bnd_awaylabel_rect_top = 0,
  
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_crest_image_width = 180,
  bnd_crest_image_height = 180,
  bnd_homecrest_left = -120,
  bnd_homecrest_top = 300,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 120,
  bnd_awaycrest_top = -250,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 0,
  bnd_stadium_width = 0,
  bnd_stadium_left = -550,
  bnd_stadium_top = 250,
  bnd_stadium_color = "0x151515",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 0,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = 0,
  
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_left = 0,
  bnd_title_top = 0,
  bnd_title_color = "0x00fc7f",
  bnd_title_text = "",
  bnd_title_fontSize = 20,
  bnd_title_fontColor = "0x313131",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = 0,
  bnd_match_vs = "",
  bnd_vs_fontSize = 0,
  bnd_vs_fontColor = "0x000000",
  bnd_vs_left = 0,
  bnd_vs_top = 0,
  bnd_logo = {
    name = "$LeagueLogo",
    id = 13
  },
  bnd_logo_height = 200,
  bnd_logo_width = 200,
  bnd_logo_left = 0,
  bnd_logo_top = 0,
  bnd_logo_alpha = 1,
  
  bnd_realtime_fontSize = 0,
  bnd_realtime_fontColor = "0xFF4942",
  bnd_realtime_top = 0,
  bnd_realtime_left = 0
}

SpainInfo = {
  bnd_fontFace = "$LaLiga",
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 700,
  bnd_background_width = 1050,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_alpha = 1,
  bnd_background = {
    name = "$Background_Intro",
    id = 53
  },
  bnd_label_height = 0,
  bnd_label_width = 0,
  bnd_homelabel_left = -270,
  bnd_homelabel_top = 225,
  bnd_homeLabel_color = "0x191c25",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 35,
  bnd_homeLabel_fontColor = "0x000000",
  bnd_awaylabel_left = 270,
  bnd_awaylabel_top = 225,
  bnd_awaylabel_color = "0x191c25",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 35,
  bnd_awaylabel_fontColor = "0x000000",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_crest_image_width = 250,
  bnd_crest_image_height = 250,
  bnd_homecrest_left = 0,
  bnd_homecrest_top = -250,
  bnd_homecrest_color = "0x191c25",
  bnd_homecrest_image = {
    name = "$LaLigaTeamCrest",
    id = 0
  },
  bnd_awaycrest_left = 0,
  bnd_awaycrest_top = -250,
  bnd_awaycrest_color = "0x191c25",
  bnd_awaycrest_image = {
    name = "$LaLigaTeamCrest",
    id = 0
  },
  bnd_stadium_height = 0,
  bnd_stadium_width = 0,
  bnd_stadium_left = 1,
  bnd_stadium_top = -5,
  bnd_stadium_color = "0x151515",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 17,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = -6,
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_left = 0,
  bnd_title_top = -240,
  bnd_title_color = "0x151515",
  bnd_title_text = "08:56",
  bnd_title_fontSize = 35,
  bnd_title_fontColor = "0x151515",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = -3,
  
  bnd_match_hari = "",
  bnd_hari_fontSize = 30,
  bnd_hari_fontColor = "0x151515",
  bnd_hari_left = -3,
  bnd_hari_top = -170,
  bnd_match_bulan = "",
  bnd_bulan_fontSize = 25,
  bnd_bulan_fontColor = "0xFFFFFF",
  bnd_bulan_left = -3,
  bnd_bulan_top = -0,
  bnd_match_tgl = "22",
  bnd_tgl_fontSize = 40,
  bnd_tgl_fontColor = "0xFFFFFF",
  bnd_tgl_left = -3,
  bnd_tgl_top = -70,
  
  bnd_match_vs = "",
  bnd_vs_fontSize = 20,
  bnd_vs_fontColor = "0x151515",
  bnd_vs_left = -4,
  bnd_vs_top = 55,
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 53
  },
  bnd_logo_height = 34,
  bnd_logo_width = 150,
  bnd_logo_left = 0,
  bnd_logo_top = 390,
  bnd_logo_alpha = 1,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10000
}

SpainBInfo = {
  bnd_fontFace = "$LaLiga",
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 700,
  bnd_background_width = 1050,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_alpha = 0.9,
  bnd_background = {
    name = "$Background_Intro",
    id = 54
  },
  bnd_label_height = 0,
  bnd_label_width = 0,
  bnd_homelabel_left = -270,
  bnd_homelabel_top = 225,
  bnd_homeLabel_color = "0x191c25",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 35,
  bnd_homeLabel_fontColor = "0x000000",
  bnd_awaylabel_left = 270,
  bnd_awaylabel_top = 225,
  bnd_awaylabel_color = "0x191c25",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 35,
  bnd_awaylabel_fontColor = "0x000000",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_crest_image_width = 250,
  bnd_crest_image_height = 250,
  bnd_homecrest_left = 0,
  bnd_homecrest_top = -250,
  bnd_homecrest_color = "0x191c25",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 0,
  bnd_awaycrest_top = -250,
  bnd_awaycrest_color = "0x191c25",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 0,
  bnd_stadium_width = 0,
  bnd_stadium_left = 1,
  bnd_stadium_top = 85,
  bnd_stadium_color = "0x151515",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 17,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = -6,
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_left = 0,
  bnd_title_top = -240,
  bnd_title_color = "0x151515",
  bnd_title_text = "08:56",
  bnd_title_fontSize = 35,
  bnd_title_fontColor = "0x151515",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = -3,
  
  bnd_match_hari = "JORNADA",
  bnd_hari_fontSize = 30,
  bnd_hari_fontColor = "0x151515",
  bnd_hari_left = -3,
  bnd_hari_top = -170,
  bnd_match_bulan = "ENERO",
  bnd_bulan_fontSize = 25,
  bnd_bulan_fontColor = "0xFFFFFF",
  bnd_bulan_left = -3,
  bnd_bulan_top = -0,
  bnd_match_tgl = "22",
  bnd_tgl_fontSize = 40,
  bnd_tgl_fontColor = "0xFFFFFF",
  bnd_tgl_left = -3,
  bnd_tgl_top = -70,
  
  bnd_match_vs = "ESTADIO",
  bnd_vs_fontSize = 20,
  bnd_vs_fontColor = "0x151515",
  bnd_vs_left = -4,
  bnd_vs_top = 55,
  bnd_logo = {
    name = "$LeagueLogo",
    id = 54
  },
  bnd_logo_height = 34,
  bnd_logo_width = 150,
  bnd_logo_left = 0,
  bnd_logo_top = 390,
  bnd_logo_alpha = 1,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10000
}

GermanyInfo = {
  bnd_fontFace = "$Bundesliga",
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = false,
  bnd_background_height = 600,
  bnd_background_width = 700,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 13
  },
  bnd_background_alpha = 1,
  bnd_background_alpha_1 = 1,
  bnd_background_stadium_alpha = 1,
  bnd_label_height = 100,
  bnd_label_width = 350,
  bnd_homelabel_left = -173,
  bnd_homelabel_top = 194,
  bnd_homeLabel_color = "0x39003E",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 40,
  bnd_homeLabel_fontColor = "0xffffff",
  bnd_awaylabel_left = 176,
  bnd_awaylabel_top = 194,
  bnd_awaylabel_color = "0x39003E",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 40,
  bnd_awaylabel_fontColor = "0xffffff",
  bnd_homeLabel_alignH = "CENTER",
  bnd_awayLabel_alignH = "CENTER",
  bnd_crest_height = 300,
  bnd_crest_width = 350,
  bnd_crest_image_width = 256,
  bnd_crest_image_height = 256,
  bnd_homecrest_left = 0,
  bnd_homecrest_top = -199,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 0,
  bnd_awaycrest_top = -199,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 50,
  bnd_stadium_width = 700,
  bnd_stadium_left = 1,
  bnd_stadium_top = -180,
  bnd_stadium_color = "0x313131",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 20,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "LEFT",
  bnd_stadium_text_left = 60,
  bnd_title_height = 50,
  bnd_title_width = 700,
  bnd_title_left = 1,
  bnd_title_top = -230,
  bnd_title_color = "0xffffff",
  bnd_title_text = "",
  bnd_title_fontSize = 25,
  bnd_title_fontColor = "0x313131",
  bnd_title_text_alignH = "LEFT",
  bnd_title_text_left = 80,
  bnd_match_vs = "",
  bnd_vs_fontSize = 0,
  bnd_vs_fontColor = "0xffffff",
  bnd_vs_left = -20000,
  bnd_vs_top = 0,
  bnd_logo = {
    name = "$LeagueLogo",
    id = 19
  },
  bnd_logo_height = 64,
  bnd_logo_width = 64,
  bnd_logo_left = 10,
  bnd_logo_top = 0,
  bnd_logo_alpha = 1,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10,
  bnd_label_rect_height = 0,
  bnd_label_rect_width = 0,
  bnd_homeLabel_rect_left = -100,
  bnd_homeLabel_rect_top = -150,

  bnd_awayLabel_rect_left = 100,
  bnd_awayLabel_rect_top = -150
}

FranceInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 16
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -110,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xFFFFFF",
    bnd_awaylabel_left = 150,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xFFFFFF",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = 5,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 5,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 203,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -203,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0xffffff",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$",
      id = 16
    },
    bnd_logo_height = 95,
    bnd_logo_width = 95,
    bnd_logo_left = 0,
    bnd_logo_top = 180,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

ItalyInfo = {
  bnd_fontFace = "$SerieA",
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_alignH = "FILL",
  bnd_background_alignV = "FILL",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 31
  },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = 0,
    bnd_homelabel_top = -60,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 35,
    bnd_homeLabel_fontColor = "0xFFFFFF",
    bnd_awaylabel_left = 0,
    bnd_awaylabel_top = 60,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 35,
    bnd_awaylabel_fontColor = "0xFFFFFF",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -320,
    bnd_homecrest_top = 60,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 320,
    bnd_awaycrest_top = -60,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 215,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -135,
    bnd_title_color = "0x00FFD5",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0x00FFD5",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "VS",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0x00FFD5",
    bnd_vs_left = 0,
    bnd_vs_top = 0,
    bnd_logo = {
      name = "$LeagueLogo",
      id = 31
    },
    bnd_logo_height = 100,
    bnd_logo_width = 100,
    bnd_logo_left = 0,
    bnd_logo_top = -100,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

BrazilInfo = {
    bnd_fontFace = "$Brasil-Sportv",
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 425,
    bnd_background_width = 750,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 7
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -190,
    bnd_homelabel_top = 85,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 190,
    bnd_awaylabel_top = 85,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 100,
    bnd_crest_image_height = 100,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -80,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -80,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = -85,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$",
      id = 21
    },
    bnd_logo_height = 0,
    bnd_logo_width = 150,
    bnd_logo_left = 0,
    bnd_logo_top = 203,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

BrazilGloboInfo = {
	bnd_fontFace = "$Brasil-Globo",
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 430,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = "7_1"
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = 0,
    bnd_homelabel_top = -40,
    bnd_homeLabel_color = "0x000000",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 35,
    bnd_homeLabel_fontColor = "0xFFFFFF",
    bnd_awaylabel_left = 0,
    bnd_awaylabel_top = 40,
    bnd_awaylabel_color = "0x000000",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 35,
    bnd_awaylabel_fontColor = "0xFFFFFF",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 200,
    bnd_crest_image_height = 200,
    bnd_homecrest_left = -342,
    bnd_homecrest_top = 40,
    bnd_homecrest_color = "0x000000",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 342,
    bnd_awaycrest_top = -40,
    bnd_awaycrest_color = "0x000000",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 110,
    bnd_stadium_color = "0x000000",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xBCFF79",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -135,
    bnd_title_color = "0x00FFD5",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xBCFF79",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "x",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0xFFFFFF",
    bnd_vs_left = 0,
    bnd_vs_top = 0,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 7
    },
    bnd_logo_height = 100,
    bnd_logo_width = 100,
    bnd_logo_left = 0,
    bnd_logo_top = -100,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,
    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

BrazilAmazonInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 1000,
    bnd_background_width = 2117,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 32,
    bnd_background = {
      name = "$Background_Intro",
      id = "7_2"
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -180,
    bnd_homelabel_top = 205,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 180,
    bnd_awaylabel_top = 205,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 60,
    bnd_crest_image_height = 60,
    bnd_homecrest_left = -145,
    bnd_homecrest_top = 0,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 145,
    bnd_awaycrest_top = 0,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 250,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = -190,
    bnd_title_top = -198,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x000000",
    bnd_vs_left = -2,
    bnd_vs_top = 95,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = "7_2"
    },
    bnd_logo_height = 80,
    bnd_logo_width = 80,
    bnd_logo_left = 190,
    bnd_logo_top = 180,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

MexicoInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 341
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -180,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 180,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 203,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -198,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x000000",
    bnd_vs_left = -2,
    bnd_vs_top = 95,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 341
    },
    bnd_logo_height = 80,
    bnd_logo_width = 80,
    bnd_logo_left = 190,
    bnd_logo_top = 180,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,
    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

ArgentinaInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 160,
    bnd_background_width = 768,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 130,
    bnd_background = {
      name = "$Background_Intro",
      id = 353
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -110,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 20,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 210,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 20,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 60,
    bnd_crest_image_height = 60,
    bnd_homecrest_left = -115,
    bnd_homecrest_top = 10,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = -100,
    bnd_awaycrest_top = 10,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 167,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$",
      id = 21
    },
    bnd_logo_height = 0,
    bnd_logo_width = 150,
    bnd_logo_left = 0,
    bnd_logo_top = 203,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

IndonesiaInfo = {
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 500,
  bnd_background_width = 860,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background = {
    name = "$Background_Intro",
    id = 2235
  },
  bnd_label_height = 0,
  bnd_label_width = 0,
  bnd_homelabel_left = -250,
  bnd_homelabel_top = 190,
  bnd_homeLabel_color = "0xffffff",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 25,
  bnd_homeLabel_fontColor = "0x2C4C7C",
  bnd_awaylabel_left = 250,
  bnd_awaylabel_top = 190,
  bnd_awaylabel_color = "0xffffff",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 25,
  bnd_awaylabel_fontColor = "0x2C4C7C",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_crest_image_width = 220,
  bnd_crest_image_height = 220,
  bnd_homecrest_left = -10,
  bnd_homecrest_top = -170,
  bnd_homecrest_color = "0x2C4C7C",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 10,
  bnd_awaycrest_top = -170,
  bnd_awaycrest_color = "0x2C4C7C",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 0,
  bnd_stadium_width = 0,
  bnd_stadium_left = 1,
  bnd_stadium_top = -190,
  bnd_stadium_color = "0xffffff",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 30,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = -2,
  bnd_title_height = 0,
  bnd_title_width = 0,
  bnd_title_left = 0,
  bnd_title_top = -210,
  bnd_title_color = "0x00fc7f",
  bnd_title_text = "",
  bnd_title_fontSize = 50,
  bnd_title_fontColor = "0x313131",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = 0,
  bnd_match_vs = "",
  bnd_vs_fontSize = 50,
  bnd_vs_fontColor = "0x2C4C7C",
  bnd_vs_left = 0,
  bnd_vs_top = 210,
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2235
  },
  bnd_logo_height = 64,
  bnd_logo_width = 64,
  bnd_logo_left = 0,
  bnd_logo_top = 260,
  bnd_logo_alpha = 0,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10000
}

SaudiArabiaInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 650,
    bnd_background_width = 1150,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 350
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -300,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 32,
    bnd_homeLabel_fontColor = "0x000000",
    bnd_awaylabel_left = 125,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 32,
    bnd_awaylabel_fontColor = "0x000000",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = 0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 5,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 170,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0x000000",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = -100,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -165,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 28,
    bnd_title_fontColor = "0x000000",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = -100,
    bnd_match_vs = "VS",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0x000000",
    bnd_vs_left = -100,
    bnd_vs_top = 20,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 350
    },
    bnd_logo_height = 95,
    bnd_logo_width = 95,
    bnd_logo_left = 0,
    bnd_logo_top = 180,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 385,
    bnd_label_rect_width = 15,
    bnd_homeLabel_rect_left = -165,
    bnd_homeLabel_rect_top = -100,
    bnd_awayLabel_rect_left = 167,
    bnd_awayLabel_rect_top = -100
}

WomensSuperLeagueInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2216
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -190,
    bnd_homelabel_top = 80,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 190,
    bnd_awaylabel_top = 80,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -100,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -100,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = -10,
    bnd_stadium_top = 180,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$",
      id = 21
    },
    bnd_logo_height = 0,
    bnd_logo_width = 150,
    bnd_logo_left = 0,
    bnd_logo_top = 203,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

UnitedStatesInfo = {
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = false,
  bnd_background_height = 600,
  bnd_background_width = 700,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 13
  },
  bnd_background_alpha = 1,
  bnd_background_alpha_1 = 1,
  bnd_background_stadium_alpha = 1,
  bnd_label_height = 100,
  bnd_label_width = 350,
  bnd_homelabel_left = -173,
  bnd_homelabel_top = 154,
  bnd_homeLabel_color = "0x39003E",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 40,
  bnd_homeLabel_fontColor = "0xffffff",
  bnd_awaylabel_left = 176,
  bnd_awaylabel_top = 154,
  bnd_awaylabel_color = "0x39003E",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 40,
  bnd_awaylabel_fontColor = "0xffffff",
  bnd_homeLabel_alignH = "CENTER",
  bnd_awayLabel_alignH = "CENTER",
  bnd_crest_height = 300,
  bnd_crest_width = 350,
  bnd_crest_image_width = 256,
  bnd_crest_image_height = 256,
  bnd_homecrest_left = 0,
  bnd_homecrest_top = -199,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 0,
  bnd_awaycrest_top = -199,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 50,
  bnd_stadium_width = 700,
  bnd_stadium_left = 1,
  bnd_stadium_top = -220,
  bnd_stadium_color = "0x313131",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 20,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = 0,
  bnd_title_height = 30,
  bnd_title_width = 150,
  bnd_title_left = 1,
  bnd_title_top = 219,
  bnd_title_color = "0xffffff",
  bnd_title_text = "",
  bnd_title_fontSize = 20,
  bnd_title_fontColor = "0x313131",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = 0,
  bnd_match_vs = "",
  bnd_vs_fontSize = 0,
  bnd_vs_fontColor = "0xffffff",
  bnd_vs_left = -20000,
  bnd_vs_top = 0,
  bnd_logo = {
    name = "$LeagueLogo",
    id = 39
  },
  bnd_logo_height = 53,
  bnd_logo_width = 40,
  bnd_logo_left = 0,
  bnd_logo_top = -240,
  bnd_logo_alpha = 1,
  bnd_stadium_icon = {
    name = "$",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10,
  bnd_label_rect_height = 0,
  bnd_label_rect_width = 0,
  bnd_homeLabel_rect_left = -100,
  bnd_homeLabel_rect_top = -150,

  bnd_awayLabel_rect_left = 100,
  bnd_awayLabel_rect_top = -150
}

RussiaInfo = {
	bnd_fontFace = "$Russian",
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 425,
    bnd_background_width = 750,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 67
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -230,
    bnd_homelabel_top = 101,
    bnd_homeLabel_color = "0xffffff",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 20,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 230,
    bnd_awaylabel_top = 101,
    bnd_awaylabel_color = "0xffffff",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 20,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 220,
    bnd_crest_image_height = 220,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -180,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -180,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 190,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0x000000",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 25,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0xffffff",
    bnd_vs_left = 0,
    bnd_vs_top = 20,
    bnd_logo = {
      name = "$LeagueLogo67",
      id = "67"
    },
    bnd_logo_height = 95,
    bnd_logo_width = 95,
    bnd_logo_left = 0,
    bnd_logo_top = 450,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

 LeaguePariInfo = {
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 600,
    bnd_background_width = 1066,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2245
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 1,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 150,
    bnd_label_width = 370,
    bnd_homelabel_left = -355,
    bnd_homelabel_top = 225,
    bnd_homeLabel_color = "",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 355,
    bnd_awaylabel_top = 225,
    bnd_awaylabel_color = "",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 500,
    bnd_crest_width = 370,
    bnd_crest_image_width = 200,
    bnd_crest_image_height = 200,
    bnd_homecrest_left = 0,
    bnd_homecrest_top = -275,
    bnd_homecrest_color = "0xffffff",
    bnd_homecrest_image = {
     name = "$Crest",
     id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -275, 
    bnd_awaycrest_color = "0xffffff",
    bnd_awaycrest_image = {
     name = "$Crest",
     id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 700,
    bnd_stadium_left = 1,
    bnd_stadium_top = -220,
    bnd_stadium_color = "",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 150,
    bnd_title_left = 1,
    bnd_title_top = 219,
    bnd_title_color = "",
    bnd_title_text = "",
    bnd_title_fontSize = 20,
    bnd_title_fontColor = "0x313131",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 0,
    bnd_vs_fontColor = "0xffffff",
    bnd_vs_left = -20000,
    bnd_vs_top = 0,
    bnd_logo = {
     name = "$",
     id = 2245
    },
    bnd_logo_height = 0,
    bnd_logo_width = 40,
    bnd_logo_left = 0,
    bnd_logo_top = -240,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
     name = "$",
     id = 0
    },
    bnd_stadium_icon_height = 40,
    bnd_stadium_icon_width = 40,
    bnd_stadium_icon_top = 0,
    bnd_stadium_icon_left = 10,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
  }
  
  UkraineInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 457,
    bnd_background_width = 820,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 332
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -170,
    bnd_homelabel_top = 108,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 18,
    bnd_homeLabel_fontColor = "0x0039AB",
    bnd_awaylabel_left = 170,
    bnd_awaylabel_top = 108,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 18,
    bnd_awaylabel_fontColor = "0x0039AB",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 150,
    bnd_crest_image_height = 150,
    bnd_homecrest_left = 0,
    bnd_homecrest_top = -130,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -130,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 20,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 155,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xE5FF00",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$",
      id = 332
    },
    bnd_logo_height = 0,
    bnd_logo_width = 150,
    bnd_logo_left = 0,
    bnd_logo_top = 203,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

InternationalInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 78
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -180,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xD3AA32",
    bnd_awaylabel_left = 180,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xD3AA32",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 203,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0x000000",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = -190,
    bnd_title_top = -198,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0x000000",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "VS",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x000000",
    bnd_vs_left = 0,
    bnd_vs_top = 95,
    bnd_logo = {
      name = "$LeagueLogo",
      id = 78
    },
    bnd_logo_height = 80,
    bnd_logo_width = 80,
    bnd_logo_left = 190,
    bnd_logo_top = 170,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

--------- Tournaments ---------

UCLInfo = {
  bnd_fontFace = "$UCL-Regular",
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 500,
  bnd_background_width = 771,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 2236
  },
  bnd_background_alpha = 1,
  bnd_background_alpha_1 = 0,
  bnd_background_stadium_alpha = 0,
  
  bnd_label_height = 100,
  bnd_label_width = 360,
  bnd_homelabel_left = -185,
  bnd_homelabel_top = 100,
  bnd_homeLabel_color = "0x191c25",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 30,
  bnd_homeLabel_fontColor = "0xffffff",
  bnd_awaylabel_left = 185,
  bnd_awaylabel_top = 100,
  bnd_awaylabel_color = "0x191c25",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 30,
  bnd_awaylabel_fontColor = "0xffffff",
  bnd_homeLabel_alignH = "CENTER",
  bnd_awayLabel_alignH = "CENTER",
  bnd_crest_height = 300,
  bnd_crest_width = 360,
  bnd_crest_image_width = 210,
  bnd_crest_image_height = 210,
  bnd_homecrest_left = 0,
  bnd_homecrest_top = -150,
  bnd_homecrest_color = "0x191c25",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 0,
  bnd_awaycrest_top = -150,
  bnd_awaycrest_color = "0x191c25",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 50,
  bnd_stadium_width = 500,
  bnd_stadium_left = 0,
  bnd_stadium_top = 180,
  bnd_stadium_color = "0x252b39",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 20,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = -2,
  bnd_title_height = 50,
  bnd_title_width = 500,
  bnd_title_left = 0,
  bnd_title_top = -229,
  bnd_title_color = "0x00fc7f",
  bnd_title_text = "",
  bnd_title_fontSize = 28,
  bnd_title_fontColor = "0x313131",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = 0,
  bnd_match_vs = "",
  bnd_vs_fontSize = 40,
  bnd_vs_fontColor = "0xffffff",
  bnd_vs_left = 0,
  bnd_vs_top = -60000,
  bnd_logo = {
    name = "$LeagueLogo",
    id = "0_ea"
  },
  bnd_logo_height = 64,
  bnd_logo_width = 64,
  bnd_logo_left = 0,
  bnd_logo_top = 260,
  bnd_logo_alpha = 0,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10000,
  bnd_label_rect_height = 0,
  bnd_label_rect_width = 0,
  bnd_homeLabel_rect_left = -100,
  bnd_homeLabel_rect_top = -150,

  bnd_awayLabel_rect_left = 100,
  bnd_awayLabel_rect_top = -150
}

UELInfo = {
    bnd_fontFace = "$UEL-Bold",
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 450,
    bnd_background_width = 700,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2238
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 1,
    bnd_background_stadium_alpha = 1,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -150,
    bnd_homelabel_top = 120,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 150,
    bnd_awaylabel_top = 120,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 190,
    bnd_crest_image_height = 190,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -130,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -130,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 2,
    bnd_stadium_top = 170,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 23,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$LeagueLogo",
      id = 2238
    },
    bnd_logo_height = 75,
    bnd_logo_width = 75,
    bnd_logo_left = 0,
    bnd_logo_top = 30,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

EuroCopaInfo = {
  bnd_fontFace = "$UEFAEuro-Bold",
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 650,
  bnd_background_width = 1400,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 2299
  },
    bnd_background_alpha = 0.8,
  bnd_background_alpha_1 = 1,
  bnd_background_stadium_alpha = 1,
  bnd_label_height = 0,
  bnd_label_width = 0,
  bnd_homelabel_left = -190,
  bnd_homelabel_bottom = -170,
  bnd_homeLabel_color = "0x39003E",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 50,
  bnd_homeLabel_fontColor = "0xFDDA42",
  bnd_awaylabel_left = 230,
  bnd_awaylabel_bottom = -170,
  bnd_awaylabel_color = "0x39003E",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 50,
  bnd_awaylabel_fontColor = "0xFDDA42",
  bnd_homeLabel_alignH = "CENTER",
  bnd_awayLabel_alignH = "CENTER",
  bnd_crest_height = 0,
  bnd_crest_width = 0,
  bnd_crest_image_width = 170,
  bnd_crest_image_height = 170,
  bnd_homecrest_left = 0,
  bnd_homecrest_top = -200,
  bnd_homecrest_color = "0xffffff",
  bnd_homecrest_image = {
    name = "$CrestEuro",
    id = 0
  },
  bnd_awaycrest_right = -25,
  bnd_awaycrest_top = -200,
  bnd_awaycrest_color = "0xffffff",
  bnd_awaycrest_image = {
    name = "$CrestEuro",
    id = 0
  },
  bnd_stadium_height = 0,
  bnd_stadium_width = 650,
  bnd_stadium_left = 20,
  bnd_stadium_top = 100,
  bnd_stadium_color = "0x749CB4",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 20,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_right = -150,
  bnd_title_height = 0,
  bnd_title_width = 650,
  bnd_title_left = 0,
  bnd_title_top = -201,
  bnd_title_color = "0x000000",
  bnd_title_text = "UEFA EURO GERMANY",
  bnd_title_fontSize = 24,
  bnd_title_fontColor = "0xffffff",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = 1500,
  bnd_match_vs = "",
  bnd_vs_fontSize = 18,
  bnd_vs_fontColor = "0xffffff",
  bnd_vs_left = 0,
  bnd_vs_top = -185,
  bnd_logo = {
    name = "$LeagueLogo",
    id = 2299
  },
  bnd_logo_height = 100,
  bnd_logo_width = 100,
  bnd_logo_left = 20,
  bnd_logo_top = 180,
  bnd_logo_alpha = 1,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 0,
  bnd_stadium_icon_width = 0,
  bnd_stadium_icon_top = -2000,
  bnd_stadium_icon_left = 0,
  bnd_label_rect_height = 0,
  bnd_label_rect_width = 0,
  bnd_homeLabel_rect_left = -100,
  bnd_homeLabel_rect_top = -150,

  bnd_awayLabel_rect_left = 100,
  bnd_awayLabel_rect_top = -150
}

NationsInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 650,
    bnd_background_width = 1150,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2241
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -300,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 32,
    bnd_homeLabel_fontColor = "0x000000",
    bnd_awaylabel_left = 125,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 32,
    bnd_awaylabel_fontColor = "0x000000",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = 0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 5,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 170,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0x000000",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = -100,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -165,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 28,
    bnd_title_fontColor = "0x000000",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = -100,
    bnd_match_vs = "VS",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0x000000",
    bnd_vs_left = -100,
    bnd_vs_top = 20,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 2241
    },
    bnd_logo_height = 95,
    bnd_logo_width = 95,
    bnd_logo_left = 0,
    bnd_logo_top = 180,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 385,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -165,
    bnd_homeLabel_rect_top = -100,
    bnd_awayLabel_rect_left = 167,
    bnd_awayLabel_rect_top = -100
}

UCLWomensInfo = {
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 500,
  bnd_background_width = 771,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 2240
  },
  bnd_background_alpha = 1,
  bnd_background_alpha_1 = 0,
  bnd_background_stadium_alpha = 0,
  
  bnd_label_height = 100,
  bnd_label_width = 360,
  bnd_homelabel_left = -185,
  bnd_homelabel_top = 100,
  bnd_homeLabel_color = "0x191c25",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 30,
  bnd_homeLabel_fontColor = "0xffffff",
  bnd_awaylabel_left = 185,
  bnd_awaylabel_top = 100,
  bnd_awaylabel_color = "0x191c25",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 30,
  bnd_awaylabel_fontColor = "0xffffff",
  bnd_homeLabel_alignH = "CENTER",
  bnd_awayLabel_alignH = "CENTER",
  bnd_crest_height = 300,
  bnd_crest_width = 360,
  bnd_crest_image_width = 210,
  bnd_crest_image_height = 210,
  bnd_homecrest_left = 0,
  bnd_homecrest_top = -150,
  bnd_homecrest_color = "0x191c25",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 0,
  bnd_awaycrest_top = -150,
  bnd_awaycrest_color = "0x191c25",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 50,
  bnd_stadium_width = 500,
  bnd_stadium_left = 0,
  bnd_stadium_top = 180,
  bnd_stadium_color = "0x252b39",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 20,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = -2,
  bnd_title_height = 50,
  bnd_title_width = 500,
  bnd_title_left = 0,
  bnd_title_top = -229,
  bnd_title_color = "0x00fc7f",
  bnd_title_text = "",
  bnd_title_fontSize = 28,
  bnd_title_fontColor = "0x313131",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = 0,
  bnd_match_vs = "",
  bnd_vs_fontSize = 40,
  bnd_vs_fontColor = "0xffffff",
  bnd_vs_left = 0,
  bnd_vs_top = -60000,
  bnd_logo = {
    name = "$LeagueLogo",
    id = "0_ea"
  },
  bnd_logo_height = 64,
  bnd_logo_width = 64,
  bnd_logo_left = 0,
  bnd_logo_top = 260,
  bnd_logo_alpha = 0,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10000,
  bnd_label_rect_height = 0,
  bnd_label_rect_width = 0,
  bnd_homeLabel_rect_left = -100,
  bnd_homeLabel_rect_top = -150,

  bnd_awayLabel_rect_left = 100,
  bnd_awayLabel_rect_top = -150
}

UCLClassicInfo = {
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 500,
  bnd_background_width = 771,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 22366
  },
  bnd_background_alpha = 1,
  bnd_background_alpha_1 = 0,
  bnd_background_stadium_alpha = 0,
  
  bnd_label_height = 100,
  bnd_label_width = 360,
  bnd_homelabel_left = -185,
  bnd_homelabel_top = 131,
  bnd_homeLabel_color = "0x191c25",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 30,
  bnd_homeLabel_fontColor = "0x1B1743",
  bnd_awaylabel_left = 185,
  bnd_awaylabel_top = 131,
  bnd_awaylabel_color = "0x191c25",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 30,
  bnd_awaylabel_fontColor = "0x1B1743",
  bnd_homeLabel_alignH = "CENTER",
  bnd_awayLabel_alignH = "CENTER",
  bnd_crest_height = 300,
  bnd_crest_width = 360,
  bnd_crest_image_width = 210,
  bnd_crest_image_height = 210,
  bnd_homecrest_left = 0,
  bnd_homecrest_top = -150,
  bnd_homecrest_color = "0x191c25",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 0,
  bnd_awaycrest_top = -150,
  bnd_awaycrest_color = "0x191c25",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 50,
  bnd_stadium_width = 500,
  bnd_stadium_left = 0,
  bnd_stadium_top = 195,
  bnd_stadium_color = "0x252b39",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 20,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = -2,
  bnd_title_height = 50,
  bnd_title_width = 500,
  bnd_title_left = 0,
  bnd_title_top = -229,
  bnd_title_color = "0x00fc7f",
  bnd_title_text = "",
  bnd_title_fontSize = 28,
  bnd_title_fontColor = "0x313131",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = 0,
  bnd_match_vs = "",
  bnd_vs_fontSize = 40,
  bnd_vs_fontColor = "0xffffff",
  bnd_vs_left = 0,
  bnd_vs_top = -60000,
  bnd_logo = {
    name = "$LeagueLogo1",
    id = 2236
  },
  bnd_logo_height = 64,
  bnd_logo_width = 64,
  bnd_logo_left = 0,
  bnd_logo_top = 260,
  bnd_logo_alpha = 0,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10000,
  bnd_label_rect_height = 0,
  bnd_label_rect_width = 0,
  bnd_homeLabel_rect_left = -100,
  bnd_homeLabel_rect_top = -150,

  bnd_awayLabel_rect_left = 100,
  bnd_awayLabel_rect_top = -150
}

LibertadoresInfo = {
	bnd_fontFace = "$Libertadores",
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 425,
    bnd_background_width = 750,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2237
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -190,
    bnd_homelabel_top = -175,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 26,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 190,
    bnd_awaylabel_top = -175,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 26,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = 0,
    bnd_homecrest_top = 160,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = 160,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = -10,
    bnd_stadium_top = 120,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "V",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0xFFFFFF",
    bnd_vs_left = 0,
    bnd_vs_top = -5,
    bnd_logo = {
      name = "$",
      id = 2237
    },
    bnd_logo_height = 0,
    bnd_logo_width = 150,
    bnd_logo_left = 0,
    bnd_logo_top = 203,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,    
    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

SudamericanaInfo = {
	bnd_fontFace = "$Libertadores",
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 425,
    bnd_background_width = 750,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2267
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -190,
    bnd_homelabel_top = -175,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 26,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 190,
    bnd_awaylabel_top = -175,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 26,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = 0,
    bnd_homecrest_top = 160,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = 160,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = -10,
    bnd_stadium_top = 120,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "V",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0xFFFFFF",
    bnd_vs_left = 0,
    bnd_vs_top = -5,
    bnd_logo = {
      name = "$",
      id = 2267
    },
    bnd_logo_height = 0,
    bnd_logo_width = 150,
    bnd_logo_left = 0,
    bnd_logo_top = 203,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,    
    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

CopaAmericaInfo = {
    bnd_fontFace = "$CopaAmerica",
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2298
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -180,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 180,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 203,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -203,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0x000000",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 0
    },
    bnd_logo_height = 75,
    bnd_logo_width = 75,
    bnd_logo_left = 2,
    bnd_logo_top = 155,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

WorldCupInfo = {
  bnd_fontFace = "$Anybody-Bold",
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 150,
  bnd_background_width = 975,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "BOTTOM",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 365
  },
  bnd_background_alpha = 1,
  bnd_background_alpha_1 = 0,
  bnd_background_stadium_alpha = 0,
  
  bnd_label_height = 100,
  bnd_label_width = 360,
  bnd_homelabel_left = -160,
  bnd_homelabel_top = 245,
  bnd_homeLabel_color = "0x191c25",
  bnd_homeLabel_text = "",
  bnd_homeLabel_fontSize = 23,
  bnd_homeLabel_fontColor = "0xffffff",
  bnd_awaylabel_left = 160,
  bnd_awaylabel_top = 245,
  bnd_awaylabel_color = "0x191c25",
  bnd_awaylabel_text = "",
  bnd_awaylabel_fontSize = 23,
  bnd_awaylabel_fontColor = "0xffffff",
  bnd_homeLabel_alignH = "CENTER",
  bnd_awayLabel_alignH = "CENTER",
  bnd_crest_height = 80,
  bnd_crest_width = 80,
  bnd_crest_image_width = 60,
  bnd_crest_image_height = 60,
  bnd_homecrest_left = -235,
  bnd_homecrest_top = 0,
  bnd_homecrest_color = "0x191c25",
  bnd_homecrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_awaycrest_left = 235,
  bnd_awaycrest_top = 0,
  bnd_awaycrest_color = "0x191c25",
  bnd_awaycrest_image = {
    name = "$Crest",
    id = 0
  },
  bnd_stadium_height = 50,
  bnd_stadium_width = 500,
  bnd_stadium_left = 0,
  bnd_stadium_top = 300,
  bnd_stadium_color = "0x252b39",
  bnd_stadium_text = "",
  bnd_stadium_fontSize = 15,
  bnd_stadium_fontColor = "0xffffff",
  bnd_stadium_text_alignH = "CENTER",
  bnd_stadium_text_left = -2,
  bnd_title_height = 50,
  bnd_title_width = 500,
  bnd_title_left = 0,
  bnd_title_top = -229,
  bnd_title_color = "0x00fc7f",
  bnd_title_text = "",
  bnd_title_fontSize = 28,
  bnd_title_fontColor = "0x313131",
  bnd_title_text_alignH = "CENTER",
  bnd_title_text_left = 0,
  bnd_match_vs = "",
  bnd_vs_fontSize = 40,
  bnd_vs_fontColor = "0xffffff",
  bnd_vs_left = 0,
  bnd_vs_top = -60000,
  bnd_logo = {
    name = "$LeagueLogo",
    id = "0_ea"
  },
  bnd_logo_height = 64,
  bnd_logo_width = 64,
  bnd_logo_left = 0,
  bnd_logo_top = 260,
  bnd_logo_alpha = 0,
  bnd_stadium_icon = {
    name = "$StadiumIcon",
    id = 0
  },
  bnd_stadium_icon_height = 40,
  bnd_stadium_icon_width = 40,
  bnd_stadium_icon_top = 0,
  bnd_stadium_icon_left = 10000,
  bnd_label_rect_height = 0,
  bnd_label_rect_width = 0,
  bnd_homeLabel_rect_left = -100,
  bnd_homeLabel_rect_top = -150,

  bnd_awayLabel_rect_left = 100,
  bnd_awayLabel_rect_top = -150
}

WomensWorldCupInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2136
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -230,
    bnd_homelabel_top = 80,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 230,
    bnd_awaylabel_top = 80,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -100,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -100,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = -15,
    bnd_stadium_top = 180,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$",
      id = 21
    },
    bnd_logo_height = 0,
    bnd_logo_width = 150,
    bnd_logo_left = 0,
    bnd_logo_top = 203,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

ClubWorldCupInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 810,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2209
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -180,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 180,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 190,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 17,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -190,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 0
    },
    bnd_logo_height = 75,
    bnd_logo_width = 75,
    bnd_logo_left = 2,
    bnd_logo_top = 155,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

FACupInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 620,
    bnd_background_width = 850,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 1313
    },
    bnd_background_alpha = 0.9,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -190,
    bnd_homelabel_top = -183,
    bnd_homeLabel_color = "0x044C7C",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 20,
    bnd_homeLabel_fontColor = "0x151515",
    bnd_awaylabel_left = 190,
    bnd_awaylabel_top = -183,
    bnd_awaylabel_color = "0x044C7C",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 20,
    bnd_awaylabel_fontColor = "0x151515",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 210,
    bnd_crest_image_height = 210,
    bnd_homecrest_left = 10,
    bnd_homecrest_top = 180,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = -10,
    bnd_awaycrest_top = 180,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = -3,
    bnd_stadium_top = 175,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$",
      id = 2218
    },
    bnd_logo_height = 0,
    bnd_logo_width = 150,
    bnd_logo_left = 0,
    bnd_logo_top = 203,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,
    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

CoppaItaliaInfo = {
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 0,
  bnd_background_width = 0,
  bnd_background_alignH = "FILL",
  bnd_background_alignV = "FILL",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 2231
  },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = 0,
    bnd_homelabel_top = -60,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 35,
    bnd_homeLabel_fontColor = "0xFFFFFF",
    bnd_awaylabel_left = 0,
    bnd_awaylabel_top = 60,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 35,
    bnd_awaylabel_fontColor = "0xFFFFFF",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -320,
    bnd_homecrest_top = 60,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 320,
    bnd_awaycrest_top = -60,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 215,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -135,
    bnd_title_color = "0x00FFD5",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0x00FFD5",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "VS",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0x00FFD5",
    bnd_vs_left = 0,
    bnd_vs_top = 0,
    bnd_logo = {
      name = "$LeagueLogo",
      id = 2231
    },
    bnd_logo_height = 100,
    bnd_logo_width = 100,
    bnd_logo_left = 0,
    bnd_logo_top = -100,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

SaudiSuperCupInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 3350
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -180,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xBF9A33",
    bnd_awaylabel_left = 180,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xBF9A33",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 195,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 17,
    bnd_stadium_fontColor = "0xBF9A33",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -195,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0xBF9A33",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x484ae6",
    bnd_vs_left = -2,
    bnd_vs_top = 177,
    bnd_logo = {
      name = "$LeagueLogo",
      id = 3350
    },
    bnd_logo_height = 95,
    bnd_logo_width = 95,
    bnd_logo_left = 0,
    bnd_logo_top = 180,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

KingCupInfo = {
  bnd_forceCaps = true,
  bnd_short_name_visible = false,
  bnd_teamLabel_visible = true,
  bnd_background_show = true,
  bnd_background_height = 720,
  bnd_background_width = 1280,
  bnd_background_alignH = "CENTER",
  bnd_background_alignV = "CENTER",
  bnd_background_top = 0,
  bnd_background = {
    name = "$Background_Intro",
    id = 3500
  },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = 0,
    bnd_homelabel_top = -40,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 40,
    bnd_homeLabel_fontColor = "0xFFFFFF",
    bnd_awaylabel_left = 0,
    bnd_awaylabel_top = 60,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 40,
    bnd_awaylabel_fontColor = "0xFFFFFF",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 80,
    bnd_crest_image_height = 80,
    bnd_homecrest_left = -365,
    bnd_homecrest_top = 0,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 366,
    bnd_awaycrest_top = 10,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 280,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = 165,
    bnd_title_color = "0x00FFD5",
    bnd_title_text = "",
    bnd_title_fontSize = 20,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0xffffff",
    bnd_vs_left = 0,
    bnd_vs_top = 0,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = "350_5"
    },
    bnd_logo_height = 100,
    bnd_logo_width = 100,
    bnd_logo_left = 0,
    bnd_logo_top = -100,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 89,
    bnd_label_rect_width = 24,
    bnd_homeLabel_rect_left = 247,
    bnd_homeLabel_rect_top = 0,
    bnd_awayLabel_rect_left = -247,
    bnd_awayLabel_rect_top = 8
}

PaulistaoInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 425,
    bnd_background_width = 750,
    bnd_background_alignH = "FILL",
    bnd_background_alignV = "FILL",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2229
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -190,
    bnd_homelabel_top = 250,
    bnd_homeLabel_color = "0xffffff",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 30,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 190,
    bnd_awaylabel_top = 250,
    bnd_awaylabel_color = "0xffffff",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 30,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 150,
    bnd_crest_image_height = 150,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -250,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -250,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 200,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 20,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 0,
    bnd_title_width = 650,
    bnd_title_left = 2,
    bnd_title_top = -195,
    bnd_title_color = "0x044C7C",
    bnd_title_text = "",
    bnd_title_fontSize = 30,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "VS",
    bnd_vs_fontSize = 30,
    bnd_vs_fontColor = "0xffffff",
    bnd_vs_left = 0,
    bnd_vs_top = 20,
    bnd_logo = {
      name = "$LeagueLogo",
      id = "7_29"
    },
    bnd_logo_height = 95,
    bnd_logo_width = 95,
    bnd_logo_left = 0,
    bnd_logo_top = 450,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 310,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

CariocaInfo = {
    bnd_forceCaps = true,
    bnd_short_name_visible = false,
    bnd_teamLabel_visible = true,
    bnd_background_show = true,
    bnd_background_height = 500,
    bnd_background_width = 755,
    bnd_background_alignH = "CENTER",
    bnd_background_alignV = "CENTER",
    bnd_background_top = 0,
    bnd_background = {
      name = "$Background_Intro",
      id = 2230
    },
    bnd_background_alpha = 1,
    bnd_background_alpha_1 = 0,
    bnd_background_stadium_alpha = 0,
    bnd_label_height = 0,
    bnd_label_width = 290,
    bnd_homelabel_left = -180,
    bnd_homelabel_top = 100,
    bnd_homeLabel_color = "0xFFFFFF",
    bnd_homeLabel_text = "",
    bnd_homeLabel_fontSize = 25,
    bnd_homeLabel_fontColor = "0xffffff",
    bnd_awaylabel_left = 180,
    bnd_awaylabel_top = 100,
    bnd_awaylabel_color = "0xFFFFFF",
    bnd_awaylabel_text = "",
    bnd_awaylabel_fontSize = 25,
    bnd_awaylabel_fontColor = "0xffffff",
    bnd_homeLabel_alignH = "CENTER",
    bnd_awayLabel_alignH = "CENTER",
    bnd_crest_height = 0,
    bnd_crest_width = 255,
    bnd_crest_image_width = 160,
    bnd_crest_image_height = 160,
    bnd_homecrest_left = -0,
    bnd_homecrest_top = -120,
    bnd_homecrest_color = "0x586cf8",
    bnd_homecrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_awaycrest_left = 0,
    bnd_awaycrest_top = -120,
    bnd_awaycrest_color = "0x586cf8",
    bnd_awaycrest_image = {
      name = "$Crest",
      id = 0
    },
    bnd_stadium_height = 0,
    bnd_stadium_width = 650,
    bnd_stadium_left = 0,
    bnd_stadium_top = 203,
    bnd_stadium_color = "0x749CB4",
    bnd_stadium_text = "",
    bnd_stadium_fontSize = 15,
    bnd_stadium_fontColor = "0xffffff",
    bnd_stadium_text_alignH = "CENTER",
    bnd_stadium_text_left = 0,
    bnd_title_height = 50,
    bnd_title_width = 650,
    bnd_title_left = 0,
    bnd_title_top = -198,
    bnd_title_color = "0xffffff",
    bnd_title_text = "",
    bnd_title_fontSize = 23,
    bnd_title_fontColor = "0xffffff",
    bnd_title_text_alignH = "CENTER",
    bnd_title_text_left = 0,
    bnd_match_vs = "",
    bnd_vs_fontSize = 26,
    bnd_vs_fontColor = "0x000000",
    bnd_vs_left = -2,
    bnd_vs_top = 95,
    bnd_logo = {
      name = "$LeagueLogo1",
      id = 0
    },
    bnd_logo_height = 80,
    bnd_logo_width = 80,
    bnd_logo_left = 190,
    bnd_logo_top = 180,
    bnd_logo_alpha = 1,
    bnd_stadium_icon = {
      name = "$",
      id = 0
    },
    bnd_stadium_icon_height = 61,
    bnd_stadium_icon_width = 125,
    bnd_stadium_icon_top = 250,
    bnd_stadium_icon_left = 0,
    bnd_label_rect_height = 0,
    bnd_label_rect_width = 0,
    bnd_homeLabel_rect_left = -100,
    bnd_homeLabel_rect_top = -150,

    bnd_awayLabel_rect_left = 100,
    bnd_awayLabel_rect_top = -150
}

function MatchInfo:new(init)
  print("[MatchInfo]: new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SettingsService = o.api("SettingsService"),
    MatchInfoService = o.api("MatchInfoService"),
    EventManagerService = o.api("EventManagerService"),
    GameSetupService = o.api("GameSetupService"),
    TeamService = o.api("TeamService")
  }
  
  o.TeamsData = o.services.MatchInfoService.GetMatchTeams()
  o.currentOptions = o.services.SettingsService.GetCurrentOptions()
  o.handlerId = o.services.EventManagerService.RegisterHandler(function(...)
    o:handleEvent(...)
  end)


  o.im.Subscribe(bndDif, function()
      o.im.Publish(bndDif, o.currentOptions.difficulty)
  end)
  
  local HOMETEAM = 0
  local AWAYTEAM = 1
  o.currentEvent = nil
  
  EnglandTeams = o.services.TeamService.GetTeams(leagueIDs.England, 0, 0, true)
  FranceTeams = o.services.TeamService.GetTeams(leagueIDs.France, 0, 0, true)
  GermanyTeams = o.services.TeamService.GetTeams(leagueIDs.Germany, 0, 0, true)
  Germany2Teams = o.services.TeamService.GetTeams(leagueIDs.Germany2, 0, 0, true)
  SpainTeams = o.services.TeamService.GetTeams(leagueIDs.Spain, 0, 0, true)
  SpainBTeams = o.services.TeamService.GetTeams(leagueIDs.SpainB, 0, 0, true)
  ItalyTeams = o.services.TeamService.GetTeams(leagueIDs.Italy, 0, 0, true)
  BrazilTeams = o.services.TeamService.GetTeams(leagueIDs.Brazil, 0, 0, true)
  MexicoTeams = o.services.TeamService.GetTeams(leagueIDs.Mexico, 0, 0, true)
  ArgentinaTeams = o.services.TeamService.GetTeams(leagueIDs.Argentina, 0, 0, true)
  WomensSuperLeagueTeams = o.services.TeamService.GetTeams(leagueIDs.WomensSuperLeague, 0, 0, true)
  IndonesiaTeams = o.services.TeamService.GetTeams(leagueIDs.Indonesia, 0, 0, true)
  SaudiArabiaTeams = o.services.TeamService.GetTeams(leagueIDs.SaudiArabia, 0, 0, true)
  UnitedStatesTeams = o.services.TeamService.GetTeams(leagueIDs.UnitedStates, 0, 0, true)
  RussiaTeams = o.services.TeamService.GetTeams(leagueIDs.Russia, 0, 0, true)
  LeaguePariTeams = o.services.TeamService.GetTeams(leagueIDs.LeaguePari, 0, 0, true)
  UkraineTeams = o.services.TeamService.GetTeams(leagueIDs.Ukraine, 0, 0, true)
  InternationalTeams = o.services.TeamService.GetTeams(leagueIDs.International, 0, 0, true)
  
  homeCrest = {
    name = "$Crest",
    id = o.TeamsData[1].assetId
  }
  awaycrest = {
    name = "$Crest",
    id = o.TeamsData[2].assetId
  }
  
  if currentCupData.cupIndex > 0 then
    if currentCupData.cupIndex == 1 then
      o.currentEvent = UCLInfo
    elseif currentCupData.cupIndex == 2 then
      o.currentEvent = UELInfo
    elseif currentCupData.cupIndex == 3 then
      o.currentEvent = EuroCopaInfo
    elseif currentCupData.cupIndex == 4 then
      o.currentEvent = NationsInfo
      o.currentEvent.bnd_title_text = "UEFA NATIONS LEAGUE"
    elseif currentCupData.cupIndex == 5 then
      o.currentEvent = UCLWomensInfo
    elseif currentCupData.cupIndex == 6 then
      o.currentEvent = LibertadoresInfo
    elseif currentCupData.cupIndex == 7 then
      o.currentEvent = SudamericanaInfo
    elseif currentCupData.cupIndex == 8 then
      o.currentEvent = CopaAmericaInfo
    elseif currentCupData.cupIndex == 9 then
      o.currentEvent = ClubWorldCupInfo
      o.currentEvent.bnd_title_text = "Club World Cup"
    elseif currentCupData.cupIndex == 10 then
      o.currentEvent = WorldCupInfo
    elseif currentCupData.cupIndex == 11 then
      o.currentEvent = FACupInfo
    elseif currentCupData.cupIndex == 12 then
      o.currentEvent = EAFCInfo
    elseif currentCupData.cupIndex == 13 then
      o.currentEvent = CoppaItaliaInfo
      o.currentEvent.bnd_title_text = "Coppa Italia"
    elseif currentCupData.cupIndex == 14 then
      o.currentEvent = EAFCInfo
      o.currentEvent.bnd_title_text = "DFB-Pokal"
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
    o.currentEvent = NationsInfo
    o.currentEvent.bnd_title_text = "UEFA NATIONS LEAGUE"
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
    o.currentEvent.bnd_title_text = "Coppa Italia"
  elseif currentTourData.tourIndex == 14 then
    o.currentEvent = EAFCInfo
    o.currentEvent.bnd_title_text = "DFB-Pokal"
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
    o.currentEvent.bnd_homeLabel_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_awaylabel_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
  elseif o:isInTable(o.TeamsData[1], SpainTeams) and o:isInTable(o.TeamsData[2], SpainTeams) then
    o.currentEvent = SpainInfo
    local homeShortName = o.services.GameSetupService.GetTeamShortName(0)
    local awayShortName = o.services.GameSetupService.GetTeamShortName(1)
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, SpainTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, SpainTeamsData)
    o.currentEvent.bnd_homeLabel_color = homeColorList[1]
    o.currentEvent.bnd_awaylabel_color = awayColorList[1]
  elseif o:isInTable(o.TeamsData[1], SpainBTeams) and o:isInTable(o.TeamsData[2], SpainBTeams) then
    o.currentEvent = SpainBInfo
  elseif o:isInTable(o.TeamsData[1], GermanyTeams) and o:isInTable(o.TeamsData[2], GermanyTeams) then
    o.currentEvent = GermanyInfo
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, GermanyTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, GermanyTeamsData)
    o.currentEvent.bnd_homeLabel_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_homeLabel_fontColor = homeColorList[2]
    o.currentEvent.bnd_awaylabel_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
    o.currentEvent.bnd_awaylabel_fontColor = awayColorList[2]
    o.currentEvent.bnd_title_text = "1. Bundesliga"
  elseif o:isInTable(o.TeamsData[1], Germany2Teams) and o:isInTable(o.TeamsData[2], Germany2Teams) then
    o.currentEvent = GermanyInfo
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, Germany2TeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, Germany2TeamsData)
    o.currentEvent.bnd_homeLabel_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_homeLabel_fontColor = homeColorList[2]
    o.currentEvent.bnd_awaylabel_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
    o.currentEvent.bnd_awaylabel_fontColor = awayColorList[2]
    o.currentEvent.bnd_logo.id = 20
    o.currentEvent.bnd_title_text = "2. Bundesliga"
  elseif o:isInTable(o.TeamsData[1], FranceTeams) and o:isInTable(o.TeamsData[2], FranceTeams) then
    o.currentEvent = FranceInfo
  elseif o:isInTable(o.TeamsData[1], ItalyTeams) and o:isInTable(o.TeamsData[2], ItalyTeams) then
    o.currentEvent = ItalyInfo
    o.currentEvent.bnd_title_text = "ROUND 01"
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
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, SaudiArabiaTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, SaudiArabiaTeamsData)
    o.currentEvent.bnd_homeLabel_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_awaylabel_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
    o.currentEvent.bnd_title_text = "MATCHDAY"
  elseif o:isInTable(o.TeamsData[1], WomensSuperLeagueTeams) and o:isInTable(o.TeamsData[2], WomensSuperLeagueTeams) then
    o.currentEvent = WomensSuperLeagueInfo
  elseif o:isInTable(o.TeamsData[1], UnitedStatesTeams) and o:isInTable(o.TeamsData[2], UnitedStatesTeams) then
    o.currentEvent = UnitedStatesInfo
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, UnitedStatesTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, UnitedStatesTeamsData)
    o.currentEvent.bnd_homeLabel_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_homeLabel_fontColor = homeColorList[2]
    o.currentEvent.bnd_awaylabel_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
    o.currentEvent.bnd_awaylabel_fontColor = awayColorList[2]
    o.currentEvent.bnd_title_text = "MATCHDAY"
  elseif o:isInTable(o.TeamsData[1], RussiaTeams) and o:isInTable(o.TeamsData[2], RussiaTeams) then
    o.currentEvent = RussiaInfo
    o.currentEvent.bnd_title_text = ""
  elseif o:isInTable(o.TeamsData[1], LeaguePariTeams) and o:isInTable(o.TeamsData[2], LeaguePariTeams) then
    o.currentEvent = LeaguePariInfo
    local homeColorList = o:getTeamHomeColor(o.TeamsData[1].assetId, LeaguePariTeamsData)
    local awayColorList = o:getTeamAwayColor(o.TeamsData[2].assetId, LeaguePariTeamsData)
    o.currentEvent.bnd_homeLabel_color = homeColorList[1]
    o.currentEvent.bnd_homecrest_color = homeColorList[1]
    o.currentEvent.bnd_homeLabel_fontColor = homeColorList[2]
    o.currentEvent.bnd_awaylabel_color = awayColorList[1]
    o.currentEvent.bnd_awaycrest_color = awayColorList[1]
    o.currentEvent.bnd_awaylabel_fontColor = awayColorList[2]
    o.currentEvent.bnd_title_text = ""
  elseif o:isInTable(o.TeamsData[1], UkraineTeams) and o:isInTable(o.TeamsData[2], UkraineTeams) then
    o.currentEvent = UkraineInfo
    o.currentEvent.bnd_title_text = ""
  elseif o:isInTable(o.TeamsData[1], InternationalTeams) and o:isInTable(o.TeamsData[2], InternationalTeams) then
    o.currentEvent = InternationalInfo
    o.currentEvent.bnd_title_text = "FIFA date"
  else 
    o.currentEvent = EAFCInfo
    o.currentEvent.bnd_title_text = ""
  end
  end

  o.currentEvent.bnd_stadium_text = o.currentOptions.stadium
  o.currentEvent.bnd_homecrest_image.id = o.TeamsData[1].assetId
  o.currentEvent.bnd_awaycrest_image.id = o.TeamsData[2].assetId
  o.currentEvent.bnd_homeLabel_text = o.TeamsData[1].teamName
  o.currentEvent.bnd_awaylabel_text = o.TeamsData[2].teamName
  o.currentEvent.bnd_homelabel_short = o.services.GameSetupService.GetTeamShortName(HOMETEAM)
  o.currentEvent.bnd_awaylabel_short = o.services.GameSetupService.GetTeamShortName(AWAYTEAM)

  if o.currentOptions.stadium == "Arena MRV" then
    o.currentEvent.bnd_stadium_icon.id = 30
  elseif o.currentOptions.stadium == "Estádio Maracanã" then
    o.currentEvent.bnd_stadium_icon.id = 26
  elseif o.currentOptions.stadium == "Neo Química Arena" then
    o.currentEvent.bnd_stadium_icon.id = 42
  elseif o.currentOptions.stadium == "Arena Fonte Nova" then
    o.currentEvent.bnd_stadium_icon.id = 153
  elseif o.currentOptions.stadium == "Allianz Parque" then
    o.currentEvent.bnd_stadium_icon.id = 174
  elseif o.currentOptions.stadium == "São Januário" then
    o.currentEvent.bnd_stadium_icon.id = 177
  elseif o.currentOptions.stadium == "Estádio do Morumbi" then
    o.currentEvent.bnd_stadium_icon.id = 229
  elseif o.currentOptions.stadium == "Vila Belmiro" then
    o.currentEvent.bnd_stadium_icon.id = 260
  elseif o.currentOptions.stadium == "Olympiastadion Berlin"  then
    o.currentEvent.bnd_stadium_icon.id = 135
  end

weatherType = {
     name = "$Weather",
     id = 0
  }
  random = currentMatchWeather
  if currentMatchWeather == 1 then
    random = math.random(2, 8)
  end

  o.im.Subscribe(bndRainVisible, function()
    if random == 6 then
      o.im.Publish(bndRainVisible, true)
    else 
      o.im.Publish(bndRainVisible, false)
    end
  end)
  o.im.Subscribe(bndSnowVisible, function()
    if random == 8 then
      o.im.Publish(bndSnowVisible, true)
    else 
      o.im.Publish(bndSnowVisible, false)
    end
  end)
  o.im.Subscribe(bndWeather, function()
    if random == 3 then
       weatherType.id = 1
      o.im.Publish(bndWeather, weatherType)
    elseif random == 4 then
       weatherType.id = 2
    o.im.Publish(bndWeather, weatherType)
       
    elseif random == 5 or random == 6 then
       weatherType.id = 4
       o.im.Publish(bndWeather, weatherType)
       
    elseif random == 7 or random == 8 then
       weatherType.id = 3
      o.im.Publish(bndWeather, weatherType)
    else
       weatherType.id = 0
       o.im.Publish(bndWeather, weatherType)
    end
    o.im.Publish(bndWeather, weatherType)
  end)
  
  o.im.Subscribe(BND_REALTIME, function()
    local currentTime = os.date("December %d")
    local state = currentTime
    o.im.Publish(BND_REALTIME, state)
  end)
  
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

function MatchInfo:handleEvent(eventType, data)
  if eventType == EventTypes.OverlayTypeFixture then
    self:updateMatchInfo(data.subtype, data.hideshow, data.subtypestr, data.msg)
  end
end

function MatchInfo:updateMatchInfo(subtype, hideshow, subtypestr, msg)
  print("[MatchInfo]: updateMatchInfo(subtype = " .. tostring(subtype) .. ", hideshow = " .. tostring(hideshow) .. ", subtypestr = " .. tostring(subtypestr) .. ", msg = " .. tostring(msg) .. ")")
  if hideshow ~= "HIDE" then
    local params = OverlayParam.split(msg, "|")
    self.active = true
  else
    self.active = false
  end
  self:_publishActive()
end

function MatchInfo:_publishActive()
  self.im.Publish("bnd_active", self.active)
end

function MatchInfo:isInTable(value, tbl) 
  for i = 1, #tbl do
    if tbl[i].id == value.assetId then
      return true
    end
  end
  return false
end

function MatchInfo:getTeamHomeColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.homeColor
      result[2] = v.homeFontColor
    end
  end
  return result
end

function MatchInfo:getTeamAwayColor(teamid, tbl)
  local result = {}
  for k,v in pairs(tbl) do
    if v.teamid == teamid then
      result[1] = v.awayColor
      result[2] = v.awayFontColor
    end
  end
  return result
end

function MatchInfo:finalize()
  print("[MatchInfo]: finalize()")
  self.im.Unsubscribe("bnd_active")
  self.im.Unsubscribe(bndRainVisible)
  self.im.Unsubscribe(bndSnowVisible)
  self.im.Unsubscribe(bndWeather)
  self.im.Unsubscribe(BND_REALTIME)
  for k,v in pairs(EAFCInfo) do
    self.im.Unsubscribe(k)
  end
  self.services.EventManagerService.UnregisterHandler(self.handlerId)
end

return MatchInfo