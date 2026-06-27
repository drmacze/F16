--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

function PlayerUpdate(idx)
	local as = gSportsRNA
	local player = as:GetTable("wvPlayer", idx)
	local state = as:GetTable("wvState")
	
	db.player[idx].envLighting = as:GetInt(state, "wvAttribEnvLighting")
	db.player[idx].stadiumLightID = as:GetInt(state, "wvAttribStadLightID")
	db.player[idx].stadiumID = as:GetInt(state, "wvAttribStadID")
	local weather = as:GetInt(state, "wvAttribStadWeather" )
	if (weather == 1 or weather == 2) then
		db.player[idx].wet = 1
	else
		db.player[idx].wet = 0
	end
	
	db.player[idx].playerassetid = as:GetInt(player, "playerassetid") 
	db.player[idx].teamid = as:GetInt(player, "teamid") 
	db.player[idx].teamside = as:GetInt(player, "teamside") 
	db.player[idx].isgoalie = as:GetInt(player, "goalie") 
	
	db.player[idx].kit = as:GetInt(player, "kit") 
	db.player[idx].kitType = as:GetInt(player, "kitType") 
	db.player[idx].kitYear = as:GetInt(player, "kitYear") 

	local kitNumber = as:GetInt(player, "kitNumber") 
	db.player[idx].kitNumberTens = math.floor ( kitNumber / 10 )
	db.player[idx].kitNumberUnits = math.floor ( math.fmod(kitNumber, 10) )

	db.player[idx].kitNameFont = as:GetInt(player, "kitNameFont")
	db.player[idx].kitNumberFont = as:GetInt(player, "kitNumberFont")
	db.player[idx].kitNumberColor = as:GetInt(player, "kitNumberColor")
	db.player[idx].kitNameColor = as:GetInt(player, "kitNameColor")
	
	db.player[idx].shortsNumberFont = as:GetInt(player, "shortsNumberFont")
	db.player[idx].shortsNumberColor = as:GetInt(player, "shortsNumberColor")
	db.player[idx].jerseyNameVisible = as:GetInt(player, "jerseyNameVisible")
	db.player[idx].jerseyNameLayout = as:GetInt(player, "jerseyNameLayout")
	
	db.player[idx].head = as:GetInt(player, "playerHead") 
	db.player[idx].headClass = as:GetInt(player, "playerHeadClass") 
	
	db.player[idx].jerseyCollarType = as:GetInt(player, "jerseyCollarType") 
	db.player[idx].jerseySleeveLength = as:GetInt(player, "jerseySleeveLength") 
	db.player[idx].jerseyArmBand = as:GetInt(player, "jerseyArmBand") 
	db.player[idx].jerseyTucked = as:GetInt(player, "jerseyTucked") 
	db.player[idx].jerseyfit = as:GetInt(player, "jerseyfit") 
	db.player[idx].socklength = as:GetInt(player, "socklength")
	db.player[idx].shortstyle = as:GetInt(player, "shortstyle")
	
	db.player[idx].bodySkinToneType = as:GetInt(player, "playerBodySkinToneType")
	db.player[idx].headSkinToneType = as:GetInt(player, "playerHeadSkinToneType")
	db.player[idx].headSkinType = as:GetInt(player, "playerHeadSkinType")
	db.player[idx].playerBodySkinColor = as:GetInt(player, "playerBodySkinColor")
	db.player[idx].faceGenSkinToneType = as:GetInt(player, "faceGenSkinToneType")
	
	db.player[idx].shoeType = as:GetInt(player, "shoeType")
	db.player[idx].shoeDesign = as:GetInt(player, "shoeDesign")
	db.player[idx].shoeColorPri = as:GetInt(player, "shoeColorPrim")
	db.player[idx].shoeColorSec = as:GetInt(player, "shoeColorSec")
	db.player[idx].shoeColorTer = as:GetInt(player, "shoeColorTer")

	db.player[idx].faceType = as:GetInt(player, "faceType")
	db.player[idx].faceProxyHeadClass = as:GetInt(player, "faceProxyHeadClass")
	-- Faceproxyheadclass should never be greater than one including createplayer
	if (db.player[idx].faceProxyHeadClass == 2) then
		db.player[idx].faceProxyHeadClass = 1
	end
	
	db.player[idx].faceSideBurn = as:GetInt(player, "faceSideBurn")
	db.player[idx].facialHairColor = as:GetInt(player, "facialHairColor")
	db.player[idx].facialHairType = as:GetInt(player, "facialHairType")
	db.player[idx].eyebrow = as:GetInt(player, "eyebrow")
	
	db.player[idx].isVirtualPro = as:GetInt(player, "isVirtualPro")
	db.player[idx].isCreatePlayer = as:GetInt(player, "isCreatePlayer")
	db.player[idx].faceTexExtension = "rx3"
	
	db.player[idx].isCreationZone = as:GetInt(player, "isFCZ")
	db.player[idx].hasCzCrestImage = as:GetInt(player, "hasCzCrestImage")
	db.player[idx].crestAssetId = as:GetInt(player, "crestAssetId")
	db.player[idx].forceLowResBNM = as:GetInt(player, "forceLowResBNM")
	db.player[idx].forcePowerOfTwoBNM = as:GetInt(player, "forcePowerOfTwoBNM")
	db.player[idx].forceunderarm = as:GetInt(player, "forceunderarm")
	db.player[idx].forceundershorts = as:GetInt(player, "forceundershorts")
	db.player[idx].forceunderneck = as:GetInt(player, "forceunderneck")

	db.player[idx].sponsorAssetId = as:GetInt(player, "sponsorAssetId")
	db.player[idx].hotspotJerseySponsorL = as:GetFloat(player, "hotspotJerseySponsorL")
	db.player[idx].hotspotJerseySponsorT = as:GetFloat(player, "hotspotJerseySponsorT")
	db.player[idx].hotspotJerseySponsorR = as:GetFloat(player, "hotspotJerseySponsorR")
	db.player[idx].hotspotJerseySponsorB = as:GetFloat(player, "hotspotJerseySponsorB")
	
	db.player[idx].kitColourJerseyPri = as:GetInt(player, "kitColourJerseyPri")
	db.player[idx].kitColourJerseySec = as:GetInt(player, "kitColourJerseySec")
	db.player[idx].kitColourJerseyTer = as:GetInt(player, "kitColourJerseyTer")

	db.player[idx].kitColourShortPri = as:GetInt(player, "kitColourShortPri")
	db.player[idx].kitColourShortSec = as:GetInt(player, "kitColourShortSec")
	db.player[idx].kitColourShortTer = as:GetInt(player, "kitColourShortTer")

	db.player[idx].kitColourSocksPri = as:GetInt(player, "kitColourSocksPri")
	db.player[idx].kitColourSocksSec = as:GetInt(player, "kitColourSocksSec")
	db.player[idx].kitColourSocksTer = as:GetInt(player, "kitColourSocksTer")

	db.player[idx].sponsorcolour = as:GetInt(player, "sponsorcolour")

	db.player[idx].crestTexName = "crest_cm"
	
	if (db.player[idx].isCreationZone == 1 and db.player[idx].hasCzCrestImage > 0) then
		db.player[idx].crestTexName = "png";
	end

	if (db.player[idx].isVirtualPro == 1) then
		db.player[idx].faceTexExtension = "dds"
	end
	
	db.player[idx].faceTypeFallback = 0
	db.player[idx].headFallback = 0
	db.player[idx].faceSideBurnFallback = db.player[idx].faceSideBurn
	db.player[idx].facialHairColorFallback = db.player[idx].facialHairColor
	db.player[idx].facialHairTypeFallback = db.player[idx].facialHairType
	db.player[idx].headSkinTypeFallback = db.player[idx].headSkinType
	db.player[idx].headSkinToneTypeFallback = db.player[idx].headSkinToneType
	
	if(db.player[idx].headSkinToneTypeFallback == 1 or db.player[idx].headSkinToneTypeFallback == 3 or db.player[idx].headSkinToneTypeFallback == 7) then
		db.player[idx].headSkinToneTypeFallback = db.player[idx].headSkinToneTypeFallback + 1
	end
	

	-- If create player then we need the create player head
	-- head_{id}_{headClass}.rx2
	-- {id} == 0 is create player
	-- {id} == 1 is create player copy
	-- {id} == 2 is facegen head
	-- {id} == 3 is facegen head copy
 	if (db.player[idx].isCreatePlayer == 1) then
		db.player[idx].headClass = 2
		db.player[idx].faceProxyHeadClass = 1
		
		if (db.player[idx].isVirtualPro == 1) then
			db.player[idx].faceSideBurn = 0
			db.player[idx].facialHairColor = 0
			db.player[idx].facialHairType = 0
			db.player[idx].headSkinType = 0
			db.player[idx].headSkinToneType = 0
			
		end
		
	end
	
	
	db.player[idx].eyeColor = as:GetInt(player, "eyeColor")
	db.player[idx].hair = as:GetInt(player, "hair")
	db.player[idx].hairColor = as:GetInt(player, "hairColor") 
	
	
	--FACE
	db.player[idx].headClass = getPlayerFace(db.player[idx].playerassetid,db.player[idx].headClass)
	db.player[idx].faceProxyHeadClass = getPlayerFace(db.player[idx].playerassetid,db.player[idx].faceProxyHeadClass)
	

	if (db.player[idx].headClass == 0) then
	
		local playerassetid = db.player[idx].playerassetid
		
		db.player[idx].head = playerassetid 
		db.player[idx].eyeColor = playerassetid

		db.player[idx].eyebrow = 0
		db.player[idx].faceType = playerassetid
		db.player[idx].faceSideBurn = 0
		db.player[idx].facialHairColor = 0
		db.player[idx].facialHairType = 0
		db.player[idx].headSkinType = 0
		db.player[idx].headSkinToneType = 0

		db.player[idx].hair = playerassetid
		db.player[idx].hairColor = 0
	else
		if(db.player[idx].headSkinToneType == 1 or db.player[idx].headSkinToneType == 3 or db.player[idx].headSkinToneType == 7) then
			db.player[idx].headSkinToneType = db.player[idx].headSkinToneType + 1
		end
		--tmp
		-- db.player[idx].hairColorIdx = db.player[idx].hairColor
		-- db.player[idx].hairColor = 0	
	end
	
	
-- Seasonal Assets --
	-- These exist only here and not in the code:
	local seasonal = as:GetInt(player, "seasonaljersey")
	
	
	
	--local weather2 = as:GetInt(state, "wvAttribStadWeather" )
	
	--GET ACCESSORY WEATHER
	local winterAcc = getWinterAccessoriesWeather(weather)
	
	--GET PLAYER WINTER ACCESSORIES
	if (db.player[idx].kitType == 5) then
	seasonal = getRefereeWinterAccessories(seasonal)
	end
	
	seasonal = getWinterAccessories(db.player[idx].playerassetid,seasonal)
	
	--SLEEVE LENGTH
	db.player[idx].jerseySleeveLength = getSleeveLength(db.player[idx].playerassetid,db.player[idx].jerseySleeveLength)
		
	
	
	if (not winterAcc) then
	--if(db.player[idx].wet == 0) then
		seasonal = db.player[idx].jerseySleeveLength
	end
	
	if (seasonal == 1) then
		db.player[idx].jerseySleeveLength  = 1
		db.player[idx].underneck = -1
		db.player[idx].underarms = -1
		db.player[idx].armLength = 1
	-- Long Sleeves and just underarmor neck
	elseif (seasonal == 2) then
		db.player[idx].jerseySleeveLength = 1
		db.player[idx].underneck = 0    
		db.player[idx].underarms = -1
		db.player[idx].armLength = 1
	-- Short sleeves with underarmor arms no neck
	elseif (seasonal == 3) then
		db.player[idx].jerseySleeveLength  = 0
		db.player[idx].underneck = -1
		db.player[idx].underarms = 0
		db.player[idx].armLength = 1
	-- Short sleeves with underarmor neck and arms
	elseif (seasonal == 4) then
		db.player[idx].jerseySleeveLength  = 0
		db.player[idx].underneck = 0
		db.player[idx].underarms = 0
		db.player[idx].armLength = 1
	-- Short Sleeves no underarmor stuff
	else
		db.player[idx].jerseySleeveLength  = 0
		db.player[idx].underneck = -1
		db.player[idx].underarms = -1
		db.player[idx].armLength = 0
	end
	
	if (winterAcc or db.player[idx].isVirtualPro == 1 or db.player[idx].isCreatePlayer == 1) then
	--if (db.player[idx].wet > 0 or db.player[idx].isVirtualPro == 1 or db.player[idx].isCreatePlayer == 1) then
		db.player[idx].undershorts = 0 
	else
		db.player[idx].undershorts = -1
	end
		

	-- end of seasonal assets
	
	-- check if we need to force underwear for injuries
	if ( db.player[idx].forceunderarm == 1 ) then
		db.player[idx].jerseySleeveLength  = 0
		db.player[idx].underarms = 0
		db.player[idx].armLength = 1
	end
	
	if ( db.player[idx].forceundershorts == 1 ) then
		db.player[idx].undershorts = 0 
	end
	
	if ( db.player[idx].forceunderneck == 1 ) then
		db.player[idx].underneck = 0 
	end

	-- Goalie long pants, turn off necessary assets.
	if( db.player[idx].shortstyle == 1 ) then
		db.player[idx].socklength = -1
		db.player[idx].undershorts = -1
	end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
	
--#PlayerId, JerseySleeve, Cuff, SockLength, ShoeType


--Arsenal
CustomPlayer		(idx, 233934, 0, 0, 0, 229) -- Aaron Ramsdale
CustomPlayer		(idx, 232580, 0, 1, 0, 44) -- Gabriel Magalhaes
CustomPlayer		(idx, 231936, 0, 0, 0, 141) -- Ben White
CustomPlayer		(idx, 232938, 0, 1, 0, 50) -- Takehiro Tomiyasu
CustomPlayer		(idx, 226491, 0, 0, 0, 152) -- Kieran Tierney
CustomPlayer		(idx, 228295, 0, 0, 0, 49) -- Rob Holding
CustomPlayer		(idx, 199503, 0, 0, 0, 79) -- Granit Xhaka
CustomPlayer		(idx, 256958, 0, 1, 0, 152) -- Fábio Vieira
CustomPlayer		(idx, 240273, 0, 1, 1, 137) --Smith Rowe
CustomPlayer		(idx, 222665, 0, 1, 0, 57) -- Martin Odegaard
CustomPlayer		(idx, 205498, 0, 0, 0, 54) -- Jorginho
CustomPlayer		(idx, 209989, 0, 0, 0, 52) -- Thomas Partey
CustomPlayer		(idx, 251566, 0, 1, 0, 79) -- Gabriel Martinelli
CustomPlayer		(idx, 246669, 0, 0, 0, 213) -- Bukayo Saka
CustomPlayer		(idx, 207421, 0, 0, 1, 175) -- Leandro Trossard
CustomPlayer		(idx, 230666, 0, 0, 1, 32) -- Gabriel Jesus


--Chelsea
CustomPlayer		(idx, 206585, 1, 0, 0, 21) -- Kepa
CustomPlayer		(idx, 238074, 0, 0, 1, 229) -- Reece James
CustomPlayer		(idx, 248695, 0, 0, 1, 29) -- Wesley Fofana
CustomPlayer		(idx, 164240, 0, 1, 0, 50) -- Thiago Silva
CustomPlayer		(idx, 201024, 0, 0, 0, 65) -- Koulibaly
CustomPlayer		(idx, 229984, 0, 1, 0, 49) -- Ben Chilwell
CustomPlayer		(idx, 239231, 0, 1, 0, 29) -- Marc Cucurella
CustomPlayer		(idx, 184432, 0, 0, 0, 31) -- Azpilicueta
CustomPlayer		(idx, 230918, 0, 1, 0, 240) -- Trevoh Chalobah
CustomPlayer		(idx, 242578, 0, 0, 0, 167) -- Badiashile
CustomPlayer		(idx, 247090, 0, 0, 0, 232) -- Enzo Fernandez
CustomPlayer		(idx, 235790, 0, 1, 0, 195) -- Kai Havertz
CustomPlayer		(idx, 207410, 0, 0, 0, 58) -- Mateo Kovavic
CustomPlayer		(idx, 233064, 0, 1, 0, 232) -- Mason Mount
CustomPlayer		(idx, 215914, 0, 1, 0, 32) -- N'golo Kante
CustomPlayer		(idx, 229261, 0, 1, 0, 50) -- Denis Zakaria
CustomPlayer		(idx, 213666, 0, 1, 0, 32) -- Loftus Cheek
CustomPlayer		(idx, 238216, 0, 0, 0, 216) -- Conor Gallagher
CustomPlayer		(idx, 259356, 0, 0, 0, 200) -- Chukwuemeka
CustomPlayer		(idx, 242444, 0, 1, 0, 45) -- Joao Felix
CustomPlayer		(idx, 202652, 0, 0, 0, 58) -- Raheem Sterling
CustomPlayer		(idx, 246340, 0, 1, 1, 216) -- Mykhalio Mudryk
CustomPlayer		(idx, 208670, 0, 1, 0, 32) -- Hakim Ziyech
CustomPlayer		(idx, 227796, 0, 0, 0, 31) -- Christian Pulisic
CustomPlayer		(idx, 254796, 0, 0, 0, 46) -- Noni Madueke


CustomPlayer		(idx, 246516, 1, 0, 1, 76) -- Johan Cruyff
CustomPlayer		(idx, 192181, 0, 0, 1, 32) -- Van Basten
CustomPlayer		(idx, 190042, 0, 0, 1, 251) -- Maradona
CustomPlayer		(idx, 190043, 0, 0, 1, 244) -- Pele
CustomPlayer		(idx, 41, 0, 0, 0, 50) -- Iniesta
CustomPlayer		(idx, 7763, 1, 0, 0, 55) -- Pirlo
CustomPlayer		(idx, 1040, 1, 0, 0, 29) -- Roberto Carlos
CustomPlayer		(idx, 161840, 0, 0, 1, 31) -- F. Hierro
CustomPlayer		(idx, 1620, 1, 0, 0, 215) -- Petit
CustomPlayer		(idx, 20801, 0, 1, 0, 58) -- Cristiano Ronaldo
CustomPlayer		(idx, 158023, 0, 1, 0, 26) -- Lionel Messi
CustomPlayer		(idx, 190871, 0, 0, 0, 47) -- Neymar
CustomPlayer		(idx, 155862, 0, 1, 0, 54) -- Sergio Ramos
CustomPlayer		(idx, 182521, 0, 0, 0, 207) -- Toni Kroos
CustomPlayer		(idx, 177003, 0, 1, 0, 58) -- Luka Modrić
CustomPlayer		(idx, 165153, 0, 0, 0, 32) -- Karim Benzema
CustomPlayer		(idx, 251854, 0, 1, 1, 145) -- Pedri
CustomPlayer		(idx, 205988, 0, 1, 1, 32) -- Luke Shaw
CustomPlayer		(idx, 231281, 0, 1, 1, 164) -- Trent Alexander Arnold
CustomPlayer		(idx, 203376, 0, 1, 0, 55) -- Virgil Van Dijk
CustomPlayer		(idx, 183711, 0, 1, 0, 52) -- Jordan Henderson
CustomPlayer		(idx, 209499, 0, 1, 0, 32) -- Fabinho
CustomPlayer		(idx, 218667, 0, 1, 1, 32) -- Bernardo Silva
CustomPlayer		(idx, 206517, 0, 1, 1, 47) -- Jack Grealish
CustomPlayer		(idx, 237692, 0, 1, 0, 49) -- Phil Foden
CustomPlayer		(idx, 246191, 0, 0, 0, 169) -- Julián Álvarez
CustomPlayer		(idx, 239053, 0, 1, 0, 22) -- Federico Valverde
CustomPlayer		(idx, 268438, 0, 1, 0, 162) -- Alejandro Garnacho
CustomPlayer		(idx, 239085, 0, 1, 0, 16) -- Erling Haaland
CustomPlayer		(idx, 223689, 0, 0, 0, 21) -- Wout Weghorst
CustomPlayer		(idx, 242516, 0, 1, 0, 243) -- Cody Gakpo
CustomPlayer		(idx, 253072, 0, 0, 0, 150) -- Darwin Núñez
CustomPlayer		(idx, 188545, 0, 1, 0, 46) -- Robert Lewandowski
CustomPlayer		(idx, 200104, 0, 1, 0, 32) -- Son Heung-min
CustomPlayer		(idx, 201153, 1, 0, 0, 32) -- Alvaro Morata
CustomPlayer		(idx, 200145, 0, 1, 0, 58) -- Casemiro
CustomPlayer		(idx, 231677, 0, 0, 0, 225) -- Marcus Rashford
CustomPlayer		(idx, 228618, 0, 1, 0, 47) -- Ferland Mendy
CustomPlayer		(idx, 209331, 0, 1, 0, 32) -- Mohamed Salah
CustomPlayer		(idx, 192985, 0, 0, 0, 59) -- Kevin De Bruyne
CustomPlayer		(idx, 201535, 1, 0, 0, 50) -- Raphael Varane
CustomPlayer		(idx, 228702, 0, 1, 0, 49) -- Frankie De Jong
CustomPlayer		(idx, 229880, 0, 1, 0, 143) -- Aaron Wan-bissaka
CustomPlayer		(idx, 239301, 0, 0, 0, 131) -- Lisandro Martínez
CustomPlayer		(idx, 209297, 0, 0, 0, 57) -- Fred
CustomPlayer		(idx, 255475, 0, 0, 0, 31) -- Antony
CustomPlayer		(idx, 233049, 0, 0, 0, 218) -- Jadon Sancho
CustomPlayer		(idx, 208722, 0, 0, 0, 57) -- Sadio Mane
CustomPlayer		(idx, 192505, 0, 1, 0, 231) -- Romelu Lukaku
CustomPlayer		(idx, 220621, 0, 1, 0, 32) -- Said Benrahma
CustomPlayer		(idx, 247635, 0, 1, 1, 176) -- Khvicha Kvaratskhelia
CustomPlayer		(idx, 253002, 0, 0, 0, 216) -- Giacomo Raspadori
CustomPlayer		(idx, 241390, 0, 0, 0, 245) -- Eljif Elmas
CustomPlayer		(idx, 246430, 0, 1, 0, 47) -- Dušan Vlahović
CustomPlayer		(idx, 256790, 0, 1, 0, 156) -- Jamal Musiala
CustomPlayer		(idx, 212194, 0, 1, 0, 58) -- Julian Brandt
CustomPlayer		(idx, 264240, 0, 1, 0, 153) -- Pablo Gavi
CustomPlayer		(idx, 208574, 0, 1, 0, 49) -- Filip Kostić
CustomPlayer		(idx, 231866, 0, 0, 0, 215) -- Rodri
CustomPlayer		(idx, 205693, 0, 1, 0, 57) -- Sébastien Haller
CustomPlayer		(idx, 235805, 0, 1, 0, 47) -- Federico Chiesa
CustomPlayer		(idx, 199304, 0, 1, 0, 57) -- Danilo
CustomPlayer		(idx, 208333, 0, 1, 0, 32) -- Emre Can
CustomPlayer		(idx, 255565, 0, 1, 0, 220) -- Kaoru Mitoma
CustomPlayer		(idx, 213661, 0, 1, 0, 32) -- Andreas Christensen
CustomPlayer		(idx, 231443, 1, 0, 0, 184) -- Ousmane Dembélé
CustomPlayer		(idx, 208830, 0, 1, 0, 49) -- Jamie Vardy
CustomPlayer		(idx, 189242, 0, 0, 0, 57) -- Philippe Coutinho
CustomPlayer		(idx, 224371, 0, 1, 0, 76) -- Jarrod Bowen
CustomPlayer		(idx, 186146, 0, 1, 0, 181) -- Danny Welbeck
CustomPlayer		(idx, 225719, 0, 0, 0, 57) -- Kelechi Iheanacho
CustomPlayer		(idx, 226766, 0, 1, 0, 186) -- Daniel Podence
CustomPlayer		(idx, 190460, 0, 1, 0, 52) -- Christian Eriksen
CustomPlayer		(idx, 243585,
 0, 1, 0, 44) -- Gavin Bazunu
CustomPlayer		(idx, 227927,
 1, 0, 0, 47) -- Kyle Walker-Peters
CustomPlayer		(idx, 225782, 0, 1, 0, 181) -- Maitland-Niles
CustomPlayer		(idx, 262118, 0, 1, 0, 196) -- Valentino Livramento
CustomPlayer		(idx, 204935, 0, 0, 1, 235) -- Jordan Pickford
CustomPlayer		(idx, 220633, 0, 1, 0, 32) -- Demarai Gray
CustomPlayer		(idx, 225793, 0, 1, 0, 213) -- Ben Godfrey
CustomPlayer		(idx, 208135, 0, 1, 0, 52) -- Abdoulaye Doucouré
CustomPlayer		(idx, 221479, 0, 0, 0, 209) -- Dominic Calvert-Lewin
CustomPlayer		(idx, 235410, 0, 0, 0, 43) -- Youssef En-Nesyri
CustomPlayer		(idx, 178213, 0, 1, 0, 57) -- Etienne Capoue
CustomPlayer		(idx, 180819, 0, 1, 0, 65) -- Adam Lallana
CustomPlayer		(idx, 220901, 0, 1, 0, 186) -- David Raya
CustomPlayer		(idx, 228789, 0, 1, 0, 209) -- Robert Sánchez
CustomPlayer		(idx, 212188, 0, 1, 0, 32) -- Timo Werner
CustomPlayer		(idx, 208448, 0, 1, 0, 57) -- Emil Forsberg
CustomPlayer		(idx, 215698, 0, 1, 0, 225) -- Mike Maignan
CustomPlayer		(idx, 256261, 0, 0, 0, 161) -- Malick Thiaw
CustomPlayer		(idx, 179645, 0, 1, 0, 52) -- Simon Kjær
CustomPlayer		(idx, 232756, 0, 0, 0, 197) -- Fikayo Tomori
CustomPlayer		(idx, 232656, 0, 1, 0, 182) -- Théo Hernandez
CustomPlayer		(idx, 226754, 0, 0, 0, 218) -- Ismaël Bennacer
CustomPlayer		(idx, 220018, 0, 1, 0, 169) -- Ante Rebić
CustomPlayer		(idx, 231410, 0, 1, 0, 47) -- Brahim Díaz
CustomPlayer		(idx, 241721, 0, 0, 0, 208) -- Rafael Leão
CustomPlayer		(idx, 178509, 0, 0, 0, 63) -- Olivier Giroud
CustomPlayer		(idx, 214979, 0, 1, 0, 153) -- Juan Musso
CustomPlayer		(idx, 216266, 0, 1, 0, 32) -- Kenny Tete
CustomPlayer		(idx, 220710, 0, 1, 0, 32) -- Harry Wilson
CustomPlayer		(idx, 242835, 0, 1, 0, 43) -- Leonardo Balerdi
CustomPlayer		(idx, 184941, 0, 1, 0, 56) -- Alexis Sánchez
CustomPlayer		(idx, 246923, 0, 1, 0, 250) -- Jacob Ramsey
CustomPlayer		(idx, 227174, 0, 0, 0, 164) -- Matty Cash
CustomPlayer		(idx, 217036, 0, 0, 0, 211) -- Álex Moreno
CustomPlayer		(idx, 227678, 0, 1, 0, 205) -- Ezri Konsa
CustomPlayer		(idx, 152908, 0, 0, 0, 32) -- Ashley Young
CustomPlayer		(idx, 236499, 0, 0, 0, 226) -- Douglas Luiz
CustomPlayer		(idx, 229906, 0, 1, 0, 57) -- Leon Bailey
CustomPlayer		(idx, 221697, 0, 0, 0, 58) -- Ollie Watkins
CustomPlayer		(idx, 210635, 0, 1, 0, 49) -- Kortney Hause
CustomPlayer		(idx, 216433, 0, 1, 0, 58) -- Anwar El Ghazi
CustomPlayer		(idx, 236015, 0, 1, 0, 50) -- Morgan Gibbs-White
CustomPlayer		(idx, 218339, 0, 1, 0, 21) -- Mahmoud Dahoud
CustomPlayer		(idx, 188350, 0, 0, 0, 65) -- Marco Reus
CustomPlayer		(idx, 231447, 0, 0, 0, 254) -- Donyell Malen
CustomPlayer		(idx, 240833, 0, 1, 0, 131) -- Youssoufa Moukoko
CustomPlayer		(idx, 192119, 0, 1, 0, 50) -- Thibaut Courtois
CustomPlayer		(idx, 253163, 0, 1, 0, 156) -- Ronald Araújo
CustomPlayer		(idx, 251809, 0, 0, 0, 238) -- Sven Botman
CustomPlayer		(idx, 242964, 0, 1, 0, 39) -- Anthony Gordon
CustomPlayer		(idx, 237329, 0, 0, 0, 239) -- Joe Willock
CustomPlayer		(idx, 230977, 0, 0, 0, 234) -- Miguel Almirón
CustomPlayer		(idx, 210935, 0, 1, 0, 231) -- Domenico Berardi
CustomPlayer		(idx, 197891, 0, 1, 0, 32) -- Juanmi Jiménez
CustomPlayer		(idx, 230578, 0, 1, 0, 43) -- Mouctar Diakhaby
CustomPlayer		(idx, 248243, 0, 1, 0, 236) -- Eduardo Camavinga
CustomPlayer		(idx, 189332, 0, 1, 0, 31) -- Jordi Alba
CustomPlayer		(idx, 241461, 0, 0, 0, 197) -- Ferran Torres
CustomPlayer		(idx, 255654, 0, 1, 0, 192) -- Pierre Kalulu
CustomPlayer		(idx, 41236, 0, 1, 0, 57) -- Zlatan Ibrahimović
CustomPlayer		(idx, 189881, 0, 1, 0, 54) -- Chris Smalling
CustomPlayer		(idx, 202884, 0, 0, 0, 238) -- Leonardo Spinazzola
CustomPlayer		(idx, 262113, 0, 1, 0, 211) -- Nicola Zalewski
CustomPlayer		(idx, 191043, 0, 1, 0, 58) -- Alex Sandro
CustomPlayer		(idx, 198176, 0, 0, 0, 55) -- Stefan de Vrij
CustomPlayer		(idx, 232363, 0, 0, 0, 208) -- Milan Škriniar
CustomPlayer		(idx, 237383, 0, 0, 0, 32) -- Alessandro Bastoni
CustomPlayer		(idx, 224232, 0, 1, 0, 174) -- Nicolò Barella
CustomPlayer		(idx, 210406, 0, 0, 1, 57) -- Piotr Zieliński
CustomPlayer		(idx, 216435, 0, 0, 0, 46) -- Stanislav Lobotka
CustomPlayer		(idx, 199189, 0, 1, 0, 49) -- Ross Barkley
CustomPlayer		(idx, 194765, 1, 0, 0, 65) -- Antoine Griezmann
CustomPlayer		(idx, 227236, 0, 1, 0, 169) -- Zambo Anguissa
CustomPlayer		(idx, 235569, 0, 0, 0, 47) -- Tanguy Ndombèlé
CustomPlayer		(idx, 221992, 0, 0, 1, 58) -- Hirving Lozano
CustomPlayer		(idx, 216409, 0, 0, 1, 235) -- Matteo Politano
CustomPlayer		(idx, 198329, 0, 1, 0, 58) -- Rodrigo Moreno
CustomPlayer		(idx, 242656, 0, 1, 0, 39) -- Illan Meslier
CustomPlayer		(idx, 206534, 0, 1, 0, 32) -- Patrick Bamford
CustomPlayer		(idx, 239360, 0, 1, 0, 160) -- Pascal Struijk
CustomPlayer		(idx, 167495, 1, 0, 0, 21) -- Manuel Neuer
CustomPlayer		(idx, 177683, 0, 1, 0, 50) -- Yann Sommer
CustomPlayer		(idx, 234396, 0, 1, 0, 135) -- Alphonso Davies
CustomPlayer		(idx, 209658, 0, 0, 0, 58) -- Leon Goretzka
CustomPlayer		(idx, 222492, 0, 1, 0, 58) -- Leroy Sané
CustomPlayer		(idx, 189596, 0, 1, 0, 32) -- Thomas Müller
CustomPlayer		(idx, 183569, 0, 1, 0, 65) -- Maxim Choupo-Moting
CustomPlayer		(idx, 202857, 1, 0, 0, 58) -- Karim Bellarabi
CustomPlayer		(idx, 253149, 0, 1, 0, 23) -- Jeremie Frimpong
CustomPlayer		(idx, 256630, 0, 1, 0, 155) -- Florian Wirtz
CustomPlayer		(idx, 213331, 0, 1, 0, 54) -- Jonathan Tah
CustomPlayer		(idx, 234236, 0, 1, 0, 58) -- Patrik Schick
CustomPlayer		(idx, 216380, 0, 1, 0, 58) -- Daley Sinkgraven
CustomPlayer		(idx, 206594, 0, 1, 0, 32) -- Solomon March
CustomPlayer		(idx, 229558, 0, 0, 0, 29) -- Dayot Upamecano
CustomPlayer		(idx, 206113, 0, 0, 0, 235) -- Serge Gnabry
CustomPlayer		(idx, 246147, 0, 1, 0, 50) -- Mason Greenwood
CustomPlayer		(idx, 212523, 0, 0, 0, 156) -- Anderson Talisca
CustomPlayer		(idx, 226627, 0, 1, 0, 21) -- Takumi Minamino
CustomPlayer		(idx, 189805, 0, 1, 0, 164) -- Luuk de Jong
CustomPlayer		(idx, 204529, 0, 1, 0, 164) -- Michy Batshuayi
CustomPlayer		(idx, 202556, 0, 0, 1, 196) -- Memphis Depay
CustomPlayer		(idx, 211110, 0, 0, 1, 58) -- Paulo Dybala
CustomPlayer		(idx, 189509, 0, 0, 1, 32) -- Thiago Alcantara
CustomPlayer		(idx, 228881, 0, 0, 1, 32) -- Davide Calabria
CustomPlayer		(idx, 226268, 0, 0, 1, 57) -- Federico Dimarco
CustomPlayer		(idx, 229348, 0, 0, 1, 50) -- Antonee Robinson
CustomPlayer		(idx, 189690, 0, 0, 0, 21) -- Guaita
CustomPlayer		(idx, 206304, 0, 0, 0, 143) -- Luka Milivojević
CustomPlayer		(idx, 198717, 0, 1, 0, 57) -- Wilfried Zaha
CustomPlayer		(idx, 247827, 0, 1, 0, 213) -- Michael Olise
CustomPlayer		(idx, 235794, 0, 1, 0, 223) -- Eberechi Eze
CustomPlayer		(idx, 200759, 0, 1, 0, 31) -- Jeffrey Schlupp
CustomPlayer		(idx, 240947, 0, 1, 0, 242) -- Tyrick Mitchell
CustomPlayer		(idx, 197756, 0, 0, 0, 234) -- Jordan Ayew
CustomPlayer		(idx, 247497, 0, 1, 0, 229) -- Armel Bella Kotchap
CustomPlayer		(idx, 247204, 0, 1, 0, 194) -- Emerson Royal
CustomPlayer		(idx, 211575, 0, 1, 0, 172) -- André Gomes
CustomPlayer		(idx, 231554, 0, 1, 0, 206) -- James Justin
CustomPlayer		(idx, 234742, 0, 1, 0, 207) -- Harvey Barnes
CustomPlayer		(idx, 198219, 0, 1, 1, 32) -- Lorenzo Insigne
CustomPlayer		(idx, 227928, 0, 1, 0, 58) -- Nélson Semedo
CustomPlayer		(idx, 216547, 0, 1, 0, 172) -- Rafa Silva
CustomPlayer		(idx, 237679, 0, 1, 0, 145) -- Randal Kolo Muani
CustomPlayer		(idx, 232730, 0, 1, 0, 51) -- Daichi Kamada
CustomPlayer		(idx, 225116, 0, 1, 0, 228) -- Alex Meret
CustomPlayer		(idx, 220971, 0, 1, 0, 46) -- Naby Keïta
CustomPlayer		(idx, 225100, 0, 1, 0, 52) -- Joe Gomez
CustomPlayer		(idx, 167948, 0, 1, 0, 46) -- Hugo Lloris
CustomPlayer		(idx, 227535, 0, 1, 0, 32) -- Rodrigo Bentancur
CustomPlayer		(idx, 236480, 0, 1, 0, 56) -- Yves Bissouma
CustomPlayer		(idx, 236276, 0, 1, 0, 183) -- Arnaut Danjuma
CustomPlayer		(idx, 186153, 0, 1, 0, 46) -- Wojciech Szczęsny
CustomPlayer		(idx, 198950, 0, 1, 0, 57) -- Pablo Sarabia
CustomPlayer		(idx, 216267, 0, 1, 0, 52) -- Andrew Robertson
CustomPlayer		(idx, 241496, 0, 1, 0, 237) -- Timothy Weah
CustomPlayer		(idx, 204970, 0, 1, 0, 197) -- Florian Thauvin
CustomPlayer		(idx, 255125, 0, 1, 0, 43) -- Azzedine Ounahi
CustomPlayer		(idx, 207616, 0, 0, 0, 140) -- Adam Webster
CustomPlayer		(idx, 199915, 0, 0, 0, 52) -- Lewis Dunk
CustomPlayer		(idx, 210257, 0, 1, 0, 52) -- Ederson Moraes
CustomPlayer		(idx, 229237, 0, 1, 0, 50) -- Manuel Akanji
CustomPlayer		(idx, 203574, 0, 1, 0, 31) -- John Stones
CustomPlayer		(idx, 229391, 0, 0, 0, 175) -- João Palhinha
CustomPlayer		(idx, 208949, 0, 0, 0, 139) -- Nawaf Al-Abed
CustomPlayer		(idx, 253004, 0, 0, 0, 47) -- Ansu Fati
CustomPlayer		(idx, 202126, 0, 0, 0, 49) -- Harry Kane
CustomPlayer		(idx, 236532, 0, 0, 0, 45) -- Robin Koch
CustomPlayer		(idx, 240716, 0, 1, 0, 218) -- Mathías Olivera
CustomPlayer		(idx, 240938, 0, 0, 0, 68) -- Junior Messias
CustomPlayer		(idx, 229582, 0, 0, 0, 247) -- Gianluca Mancini
CustomPlayer		(idx, 242087, 0, 0, 0, 141) -- Hidemasa Morita
CustomPlayer		(idx, 232905, 0, 0, 0, 181) -- Junya Ito
CustomPlayer		(idx, 234205, 0, 0, 0, 175) -- Hiroki Ito
CustomPlayer		(idx, 197445, 0, 0, 0, 31) -- David Alaba
CustomPlayer		(idx, 205452, 0, 0, 0, 233) -- Antonio Rüdiger
CustomPlayer		(idx, 243812, 0, 0, 0, 213) -- Rodrygo Goes
CustomPlayer		(idx, 238794, 0, 0, 0, 47) -- Vinícius Jr.
CustomPlayer		(idx, 220834, 0, 0, 0, 58) -- Marco Asensio
CustomPlayer		(idx, 204963, 1, 0, 0, 54) -- Dani Carvajal
CustomPlayer		(idx, 240130, 0, 0, 0, 154) -- Éder Militão
CustomPlayer		(idx, 233419, 0, 0, 0, 239) -- Raphinha
CustomPlayer		(idx, 208461, 0, 0, 0, 247) -- Marten de Roon
CustomPlayer		(idx, 217196, 0, 0, 0, 57) -- José Luis Palomino
CustomPlayer		(idx, 187598, 0, 0, 0, 57) -- Rafael Tolói
CustomPlayer		(idx, 226753, 0, 1, 0, 21) -- André Onana
CustomPlayer		(idx, 208128, 0, 0, 0, 32) -- Hakan Çalhanoğlu
CustomPlayer		(idx, 240679, 0, 1, 0, 68) -- Teun Koopmeiners
CustomPlayer		(idx, 173221, 0, 1, 0, 162) -- Antonio Candreva
CustomPlayer		(idx, 205566, 0, 1, 0, 32) -- Alberto Moreno
CustomPlayer		(idx, 189513, 0, 1, 0, 21) -- Daniel Parejo
CustomPlayer		(idx, 224309, 0, 0, 0, 174) -- Joan Jordán
CustomPlayer		(idx, 205193, 0, 0, 0, 180) -- Karim Rekik
CustomPlayer		(idx, 224334, 0, 0, 0, 151) -- Marcos Acuña
CustomPlayer		(idx, 212462, 0, 0, 0, 46) -- Alex Telles
CustomPlayer		(idx, 241197, 0, 0, 0, 45) -- Abdulelah Ali Al-Amri
CustomPlayer		(idx, 202935, 0, 1, 0, 68) -- Álvaro González Soberón
CustomPlayer		(idx, 242117, 0, 0, 0, 174) -- Abdulrahman Ghareeb
CustomPlayer		(idx, 210923, 1, 0, 0, 54) -- Mohammed Al-Owais
CustomPlayer		(idx, 210140, 0, 1, 0, 154) -- Abdullah Al-Mayouf
CustomPlayer		(idx, 241522, 0, 1, 0, 186) -- Jonas Wind


CustomPlayer		(idx, 1, 0, 1, 0, 145)
CustomPlayer		(idx, 2, 0, 1, 0, 184)
CustomPlayer		(idx, 24, 0, 1, 0, 204)
CustomPlayer		(idx, 23, 0, 1, 0, 31)
CustomPlayer		(idx, 21, 0, 1, 0, 235)
CustomPlayer		(idx, 8, 0, 1, 0, 251)
CustomPlayer		(idx, 22, 0, 1, 0, 239)
CustomPlayer		(idx, 7, 0, 1, 1, 235)
CustomPlayer		(idx, 20, 0, 1, 1, 22)
CustomPlayer		(idx, 6, 0, 1, 1, 58)
CustomPlayer		(idx, 9, 0, 1, 1, 145)
CustomPlayer		(idx, 4, 0, 1, 1, 184)
CustomPlayer		(idx, 19, 0, 1, 1, 204)
CustomPlayer		(idx, 18, 0, 1, 1, 45)
CustomPlayer		(idx, 32, 0, 1, 1, 235)
CustomPlayer		(idx, 5, 0, 1, 1, 203)
CustomPlayer		(idx, 14, 0, 1, 1, 239)
CustomPlayer		(idx, 15, 0, 1, 1, 58)
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------	 
  db.player[idx].useTextureComposition = as:GetInt(player, "useTextureComposition")
	
	
	
	
	--COUNTER
	if (idx == 0) then
	if (idx ~= oldplayeridx) then
	assignCustomItems()
	end
	end
	oldplayeridx = idx
	
	
	local stadium = as:GetTable("wvStadium", 1)
	
	-- db.stadium[1].homeKitTeamID = 0
	-- db.stadium[1].awayKitTeamID = 0
	-- db.stadium[1].homeKitTypeID = 0
	-- db.stadium[1].awayKitTypeID = 0
	
	db.stadium[1].homeKitTeamID = as:GetInt(stadium, "homeKitTeamID" )
	db.stadium[1].awayKitTeamID = as:GetInt(stadium, "awayKitTeamID" )
	db.stadium[1].homeKitTypeID = as:GetInt(stadium, "homeKitTypeID" )
	db.stadium[1].awayKitTypeID = as:GetInt(stadium, "awayKitTypeID" )
	
	
	local wipe3d = as:GetTable("wvWipe", 1)
	
	-- db.wipe3d[1].leagueID = 0
	
	db.wipe3d[1].leagueID = as:GetInt(wipe3d, "leagueID")
	
	db.wipe3d[1].leagueID = getTournamentGraphics(db.wipe3d[1].leagueID)
	


	--IF GENERIC KIT
	db.player[idx].speckitType = -1
	if (db.player[idx].teamid == db.player[idx].kit) then
	db.player[idx].genkit = db.player[idx].teamid
	else
	db.player[idx].genkit = db.player[idx].kit
	if (db.player[idx].kitType ~= 5) then
	db.player[idx].kit = db.player[idx].teamid
	end
	end
	
	if ((db.player[idx].kitYear == 0) and true) then
	db.player[idx].tournid = db.wipe3d[1].leagueID
	else
	db.player[idx].tournid = db.player[idx].kitYear
	end
	
	db.player[idx].defaulttournid = -1
	if (db.player[idx].kitType == 5) then
	if (teamTournament[db.stadium[1].homeKitTeamID] ~= nil) then
	db.player[idx].defaulttournid = teamTournament[db.stadium[1].homeKitTeamID]
	end
	else
	if (teamTournament[db.player[idx].teamid] ~= nil) then
	db.player[idx].defaulttournid = teamTournament[db.player[idx].teamid]
	end
	end
	
	
	--GK KIT SPEC
	if (db.player[idx].kitType == 2) then
	db.player[idx].kit = getSpecificGKKit(db.player[idx].teamid,db.player[idx].kit)
	end
	
	--ARENA PLAYER KIT
	if (idx == 0) then
	db.player[idx].kit = getHomeArenaKit(db.player[idx].teamid,db.player[idx].kit)
	db.player[idx].kitType = getHomeArenaKitType(db.player[idx].teamid,db.player[idx].kitType)
	db.player[idx].kitYear = 0
	db.player[idx].speckitType = 91
	end

	--ARENA GK KIT
	if (idx == 1) then
	db.player[idx].kit = getAwayArenaKit(db.player[idx].teamid,db.player[idx].kit)
	db.player[idx].kitType = getAwayArenaKitType(db.player[idx].teamid,db.player[idx].kitType)
	db.player[idx].kitYear = 0
	db.player[idx].speckitType = 92
	end
	
	--TRAINING KIT HOME
	if ((db.player[idx].genkit == 7000) and (db.player[idx].kitType == 6)) then
	db.player[idx].kit = getHomeTrainingKit(db.player[idx].teamid,db.player[idx].kit)
	db.player[idx].kitType = getHomeTrainingKitType(db.player[idx].teamid,db.player[idx].kitType)
	db.player[idx].speckitType = 93
	end
	
	--TRAINING KIT AWAY
	if ((db.player[idx].genkit == 7000) and (db.player[idx].kitType == 7)) then
	db.player[idx].kit = getAwayTrainingKit(db.player[idx].teamid,db.player[idx].kit)
	db.player[idx].kitType = getAwayTrainingKitType(db.player[idx].teamid,db.player[idx].kitType)
	db.player[idx].speckitType = 94
	end

	
	--GK KITS
	if ((db.player[idx].kitType == 2) and (idx > 1)) then
	
	local isHome = true
	local outidx = 3
	
	if ((idx == 13) or (idx > 26)) then
	isHome = false
	outidx = 14
	end
	
	--CLASSIC GK KIT
	local outplayer = as:GetTable("wvPlayer", outidx)
	local kitYearOutfield = as:GetInt(outplayer, "kitYear")
	db.player[idx].kitYear = getClassicGKKit(db.player[idx].kit,kitYearOutfield,db.player[idx].kitYear)
	
	if (db.player[idx].kitYear == 0) then
	if (isHome) then
	--if (db.player[idx].kit == db.stadium[1].homeKitTeamID) then
	db.player[idx].kitType = getGKKit(db.player[idx].kit,db.stadium[1].homeKitTypeID,db.stadium[1].homeKitTeamID,db.stadium[1].awayKitTeamID,db.player[idx].kitType)
	else
	db.player[idx].kitType = getGKKit(db.player[idx].kit,db.stadium[1].awayKitTypeID,db.stadium[1].homeKitTeamID,db.stadium[1].awayKitTeamID,db.player[idx].kitType)
	end
	end
	
	--NON GK KIT
	else
	
	--SPECIFIC MATCH KIT
	if (db.player[idx].kitYear == 0) then
	db.player[idx].kitType = getGameKit(db.player[idx].kit,db.stadium[1].homeKitTeamID,db.stadium[1].awayKitTeamID,db.player[idx].kitType)
	end
	
	end
	
	
	--PLAYER KIT SET
	if ((db.player[idx].kitType ~= 5) and (db.player[idx].kitYear == 0)) then
	db.player[idx].kitYear = getTournamentPlayerKits(db.player[idx].kit,db.wipe3d[1].leagueID,db.player[idx].kitYear)
	elseif ((db.player[idx].kitType ~= 5) and (db.player[idx].kitYear ~= 0)) then
	db.wipe3d[1].leagueID = db.player[idx].kitYear
	end
	
	
	--KIT DETAILS
	db.player[idx].kitNameFont = getKitNameFont(db.player[idx].kit,db.player[idx].kitType,db.player[idx].kitNameFont,db.wipe3d[1].leagueID,db.player[idx].teamid)
	db.player[idx].kitNumberFont = getKitNumberSet(db.player[idx].kit,db.player[idx].kitType,db.player[idx].kitNumberFont,db.wipe3d[1].leagueID,db.player[idx].teamid)
	db.player[idx].kitNumberColor = getKitNumberColourShirt(db.player[idx].kit,db.player[idx].kitType,db.player[idx].kitNumberColor,db.wipe3d[1].leagueID)
	db.player[idx].kitNameColor = getKitNameColour(db.player[idx].kit,db.player[idx].kitType,db.player[idx].kitNameColor,db.wipe3d[1].leagueID)
	db.player[idx].shortsNumberFont = getKitNumberSet(db.player[idx].kit,db.player[idx].kitType,db.player[idx].shortsNumberFont,db.wipe3d[1].leagueID,db.player[idx].teamid)
	db.player[idx].shortsNumberColor = getKitNumberColourShort(db.player[idx].kit,db.player[idx].kitType,db.player[idx].shortsNumberColor,db.wipe3d[1].leagueID)
	db.player[idx].jerseyNameLayout = getKitNameCurve(db.player[idx].kit,db.player[idx].kitType,db.player[idx].jerseyNameLayout,db.wipe3d[1].leagueID)
	db.player[idx].jerseyCollarType = getKitCollar(db.player[idx].kit,db.player[idx].kitType,db.player[idx].jerseyCollarType,db.wipe3d[1].leagueID)
	db.player[idx].jerseyfit = getKitFit(db.player[idx].kit,db.player[idx].kitType,db.player[idx].jerseyfit,db.wipe3d[1].leagueID,db.player[idx].playerassetid)

	

	--REF KITS
	if (db.player[idx].kitType == 5) then
	
	if (db.player[idx].kit > 6100) then
	db.player[idx].kit = db.player[idx].kit - 100
	end
	
	db.player[idx].kitYear = getTournamentRefereeKits(db.wipe3d[1].leagueID,db.player[idx].kitYear,db.stadium[1].homeKitTeamID)
	db.player[idx].jerseyCollarType = getTournamentRefereeKitsCollar(db.wipe3d[1].leagueID,db.player[idx].jerseyCollarType,db.stadium[1].homeKitTeamID)
	end
	
	
	
	

	
	--BOOTS
	db.player[idx].shoeType = getPlayerBoot(db.player[idx].playerassetid,db.player[idx].shoeType)
	if (db.player[idx].shoeType > 0) then
	db.player[idx].shoeDesign = 0
	db.player[idx].shoeColorPri = hex("FF0000")
	db.player[idx].shoeColorSec = hex("00FF00")
	db.player[idx].shoeColorTer = hex("0000FF")
	end
	
	--GK PANTS
	db.player[idx].shortstyle = getGKPants(db.player[idx].playerassetid,db.player[idx].shortstyle)
	db.player[idx].shortstyleset = getTeamGKPants(db.player[idx].kit,0)
	
	--SKIN TONE
	db.player[idx].bodySkinToneType = getPlayerPlayerSkinTone(db.player[idx].playerassetid,db.player[idx].bodySkinToneType)
	
	--JERSEY TUCK
	db.player[idx].jerseyTucked = getJerseyTuck(db.player[idx].playerassetid,db.player[idx].jerseyTucked)
	
	--SOCK HEIGHT
	db.player[idx].socklength = getSockHeight(db.player[idx].playerassetid,db.player[idx].socklength)
	
	--IF GENERIC KIT
	-- if (db.player[idx].genkit == 0) then
	-- db.player[idx].genkit = ""
	-- else
	-- db.player[idx].genkit = ";data/sceneassets/kit/kit_"..db.player[idx].genkit.."_"..db.player[idx].kitType.."_"..db.player[idx].kitYear..".rx3"
	-- end

	
	

end


---------------------------------------------------------------------------------------------------
-- Get hair color for generic hair recoloring 
function GetHairColorARGB(idx)
	hairColourList = { 0x00edac57, 0x000e0e0d, 0x00a07741, 0x001f160e, 
                       0x00ffd286, 0x006e4d2b, 0x003b2816, 0x00782c08, 
                       0x00c8c9cf, 0x00525355, 0x00345a34, 0x00263f67,
                       0x00f62f0a }

	local clr = 0x00FF0000
	if (db.player[idx].headClass > 0) then
		clr = hairColourList[db.player[idx].hairColor + 1]
		if (clr == nil) then
			clr = 0x00FF0000
		end
	else
		clr = 0x00808080
	end
	return clr
end

---------------------------------------------------------------------------------------------------
function EASWMorphFile(idx)
	if (db.player[idx].isVirtualPro == 1) then
		return string.format("data/easw/deltas_%d.easwmorph", db.player[idx].faceType) --12366)
	else
		return "dummyasset.easwmorph"
	end
end

---------------------------------------------------------------------------------------------------
function GetHeadAndHairAssetType(idx)
	if (db.player[idx].isCreatePlayer == 1) then
		return "cloneasset"
	else
		return ""
	end
end

---------------------------------------------------------------------------------------------------
function MorphFile(idx)
	if (db.player[idx].isCreatePlayer == 1 and db.player[idx].isVirtualPro == 0) then
		return "data/sceneassets/createplayer/head_0_2_0_1_morphtargets.rx3"
	else
		return "dummyasset.rx3"
	end
end

---------------------------------------------------------------------------------------------------
function PlayerAssetShadow(player, lod)
	local gr = gRenderables
	gr:AddAsset(player, lod, "shadow", "data/sceneassets/body/playershadow_4_1_0.rx3")
	gr:CreateMaterial(player, lod, "shadow", "missingShader.fx")
end

---------------------------------------------------------------------------------------------------
function GetCrestAsset(idx)
	if (db.player[idx].isCreationZone == 1) then
		if (db.player[idx].hasCzCrestImage > 0) then
			-- // The "\\" is so that the mounted image can be found properly by Apt
			return "data\\ugc/cz_crest/${db.player[?].crestAssetId}.png;data/ugc/cz_crest/1.png"
		else
			return "data/sceneassets/crest/crest_${db.player[?].crestAssetId}.rx3"
		end
	else
		return getKitFile()
	end

end

---------------------------------------------------------------------------------------------------
function GetSkinTone(idx, lod)
	local useLight = false
	if db.player[idx].isVirtualPro == 1 then
		-- // 0 is light, 1 is dark
		useLight =  db.player[idx].faceGenSkinToneType == 0 
	else
		useLight =  db.player[idx].bodySkinToneType < 5 
	end
	useLight = false
	if  useLight  then
		return  "skin_light" or "skin_lod_light"
	else
		return  "skin_dark" or "skin_lod_dark"
	end
end

---------------------------------------------------------------------------------------------------
function GetFaceTone(idx, lod)
	local useLight = false
	if db.player[idx].isVirtualPro == 1 then
		-- // 0 is light, 1 is dark
		useLight =  db.player[idx].faceGenSkinToneType == 0 
	else
		useLight =  db.player[idx].bodySkinToneType < 5 
	end
	useLight = false
	if  useLight  then
		return  "face_light" or "face_lod_light"
	else
		return  "face_dark" or "face_lod_dark"
	end
end

---------------------------------------------------------------------------------------------------
function PlayerAssetHighLod(player, lod)
	local gr = gRenderables
	
    -- GEO's
	gr:AddAsset(player, lod, "jersey", "data/sceneassets/body/jersey_0_${db.player[?].jerseyCollarType}_${db.player[?].jerseySleeveLength}_${db.player[?].jerseyArmBand}_${db.player[?].jerseyTucked}_${db.player[?].jerseyfit}.rx3")
	gr:AddAsset(player, lod, "arms", "data/sceneassets/body/arms_0_${db.player[?].armLength}.rx3")
	gr:AddAsset(player, lod, "shorts", "data/sceneassets/body/shorts_0_${db.player[?].shortstyle}.rx3")
	gr:AddAsset(player, lod, "shoes",  "data/sceneassets/shoe/playershoe_${db.player[?].playerassetid}.rx3;data/sceneassets/shoe/shoe_${db.player[?].shoeType}.rx3")
	gr:AddAsset(player, lod, "socks", "data/sceneassets/body/sock_0_${db.player[?].socklength}.rx3")
	gr:AddAsset(player, lod, "legs",  "data/sceneassets/body/legs_0_${db.player[?].socklength}.rx3")
	gr:AddAssetEx(player, lod, "${GetHeadAndHairAssetType(?)}", "hair1", "data/sceneassets/hair/hair_${db.player[?].playerassetid}_0_0.rx3;data/sceneassets/hair/hair_${db.player[?].hair}_${db.player[?].faceProxyHeadClass}_0.rx3")
	gr:AddAssetEx(player, lod, "${GetHeadAndHairAssetType(?)}", "hair2", "data/sceneassets/hair/hair_${db.player[?].playerassetid}_0_0.rx3;data/sceneassets/hair/hair_${db.player[?].hair}_${db.player[?].faceProxyHeadClass}_0.rx3")
	gr:AddAssetEx(player, lod, "${GetHeadAndHairAssetType(?)}", "head",  "data/sceneassets/heads/head_${db.player[?].playerassetid}_0.rx3;data/sceneassets/heads/head_${db.player[?].head}_${db.player[?].headClass}.rx3;data/sceneassets/heads/head_0_0.rx3")
    -- Point the eyes to the same asset the head uses, whether it being cloned or not.
	gr:AddAssetEx(player, lod, "fromasset", "eyes", "head")
	-- non volume texture normalMap for socks
	gr:AddAsset(player, lod, "sockbnmlod", "data/sceneassets/kit/shorts_${db.player[?].shortstyle}_bnm_lod.rx3")
	
	-- Add the morph files
	
	local priority = 0	-- default priority
	local temporary = 1	-- mark as temporary asset
	gr:AddAsset(player, lod, "morphhead", "${MorphFile(?)}", priority, temporary)
	gr:AddAsset(player, lod, "easwmorph", "${EASWMorphFile(?)}")
	
	local part = "jersey"
    gr:CreateMaterialFromAttribulator(player, lod, "jersey", "jersey_material", "${AttribMaterial('jersey')}")
    gr:SetTexture(player, lod, "jersey", "textures", "diffuseTexture", "jersey_tex", "jersey_cm")
    gr:SetTexture(player, lod, "jersey", "textures", "specularMap", "kittex_common", "jersey_coeff")
    gr:SetTexture(player, lod, "jersey", "textures", "occlusionMap", "jerseyam", "jersey_am")
    gr:SetTexture(player, lod, "jersey", "textures", "envDiffuseTexture", "charcmn", "envd_")
    gr:SetTexture(player, lod, "jersey", "textures", "envSpecTexture", "charcmn", "envs_")
    gr:SetTextureToAtlas(player, lod, "jersey", "textures", "atlas", "cmnweave", "kit_weave", "jersey_weaveMapAtlas")
    gr:SetTexture(player, lod, "jersey", "textures", "wrinkleMap", "jerseybnm", "jersey_nm")
    gr:SetTextureToAtlas(player, lod, "jersey", "textures", "atlas", "kitnumbers", "numbers_${db.player[?].kitNumberFont}_${db.player[?].kitNumberColor}_${db.player[?].kitNumberTens}", "jersey_numTensAtlas")
    gr:SetTextureToAtlas(player, lod, "jersey", "textures", "atlas", "kitnumbers", "numbers_${db.player[?].kitNumberFont}_${db.player[?].kitNumberColor}_${db.player[?].kitNumberUnits}", "jersey_numUnitsAtlas")
    gr:SetTextureToAtlas(player, lod, "jersey", "textures", "atlas", "cresttex", "${db.player[?].crestTexName}", "jersey_decalAtlas")
    gr:SetTextureFromRuntimeToAtlas(player, lod, "jersey", "textures", "atlas", "namestamp${?}", "jersey_nameAtlas")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")
	
	gr:SetHotSpot(player, lod, part, "global", "jersey_decalBounds", "kithotspots", "jersey", "team")
	gr:SetHotSpot(player, lod, part, "global", "jersey_nameBound", "kithotspots", "jersey", "name")
	gr:SetHotSpot(player, lod, part, "global", "jersey_nameArcCenter", "kithotspots", "jersey", "name_arccenter")
		
	gr:SetConstantInt(player, lod, part, "global", "jersey_nameLayout", "${db.player[?].jerseyNameLayout}")
	
	gr:SetConstantARGB(player, lod, part, "global", "jersey_nameColor", "${db.player[?].kitNameColor}")

	skinTone = "${GetSkinTone(?,"..lod..")}"
	faceTone = "${GetFaceTone(?,"..lod..")}"
	
	part = "arms"
	gr:CreateMaterialFromAttribulator(player, lod, part, "head_material",  skinTone)
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "skintex", "body_")  
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "normalMap", "bodycmn", "body_nm")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "bodycmn", "body_coeff")
	gr:SetConstantARGB(player, lod, part, "global", "skincolor", "${db.player[?].playerBodySkinColor}")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	part = "legs"
	gr:CreateMaterialFromAttribulator(player, lod, part, "head_material", skinTone )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "skintex", "body_")	
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "normalMap", "bodycmn", "body_nm")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "bodycmn", "body_coeff")
	gr:SetConstantARGB(player, lod, part, "global", "skincolor", "${db.player[?].playerBodySkinColor}")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	part = "shorts"
	gr:CreateMaterialFromAttribulator(player, lod, part, "shorts_material", "${AttribMaterial('shorts')}") 
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "shortstex", "shorts_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "shortstex", "shorts_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "shortsam", "shorts_am")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "shortsbnm", "shorts_nm")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
    gr:SetTextureToAtlas(player, lod, "shorts", "textures", "atlas", "cmnweave", "kit_weave", "shorts_weaveMapAtlas")
    gr:SetTextureToAtlas(player, lod, "shorts", "textures", "atlas", "cresttex", "${db.player[?].crestTexName}", "shorts_decalAtlas")
    gr:SetTextureToAtlas(player, lod, "shorts", "textures", "atlas", "shortsnumbers", "numbers_${db.player[?].shortsNumberFont}_${db.player[?].shortsNumberColor}_${db.player[?].kitNumberTens}", "shorts_numTensAtlas")
    gr:SetTextureToAtlas(player, lod, "shorts", "textures", "atlas", "shortsnumbers", "numbers_${db.player[?].shortsNumberFont}_${db.player[?].shortsNumberColor}_${db.player[?].kitNumberUnits}", "shorts_numUnitsAtlas")
	gr:SetHotSpot(player, lod, part, "global", "shorts_decalBounds", "shortshotspots", "shorts", "team")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourShortPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourShortSec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourShortTer}")

	-- head
	part = "head"
	gr:CreateMaterialFromAttribulator(player, lod, part, "head_material", faceTone )
	gr:SetSubMesh(player, lod, part, "head")
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "facetex", "head_")
	gr:SetTexture(player, lod, part, "textures", "normalMap", "headcmn", "head_0_nm")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "headcmn", "head_coeff")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "headcmn", "head_nm_wkl.Raster")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMask", "headcmn", "head_nm_mask.Raster")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	-- Eyes
	part = "eyes"	 
	gr:CreateMaterialFromAttribulator(player, lod, part, "eye_material", "${AttribMaterial('eyes')}" )
	gr:SetSubMesh(player, lod, part, "eyes")
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "eyetex", "eyes_")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "headcmn", "eye_coeff")
	gr:SetTexture(player, lod, part, "textures", "normalMap", "headcmn", "eyes_nm")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "env_")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	-- hair1
	part = "hair1"
	gr:CreateMaterialFromAttribulator(player, lod, part, "hair_material", "${AttribMaterial('player_hair_kk_alphaA')}")
	gr:SetSubMesh(player, lod, part, "alphaA")
	gr:SetPriority(player, lod, part, 1)             -- haircap render before hair 2
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "hairtex", "hair_cm") 
	gr:SetTexture(player, lod, part, "textures", "specAlphaMap", "hairtex", "hair_coeff")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetConstantARGB(player, lod, part, "global", "hairColor", "${GetHairColorARGB(?)}")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	-- hair2
	part = "hair2"
	gr:CreateMaterialFromAttribulator(player, lod, part, "hair_material2", "${AttribMaterial('player_hair_kk_alphaB')}")
	gr:SetSubMesh(player, lod, part, "alphaB")
	gr:SetPriority(player, lod, part, 2)             -- strands render after hair 1
	gr:SetSelfShadowAlpha(player, lod, part)          -- will use different self shadow shader that accounts for alpha
	--gr:DisableSelfShadow(player, lod, part)          -- Don't render the hairstrands into the selfshadow.
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "hairtex", "hair_cm")
	gr:SetTexture(player, lod, part, "textures", "specAlphaMap", "hairtex", "hair_coeff")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetConstantARGB(player, lod, part, "global", "hairColor", "${GetHairColorARGB(?)}")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	-- socks
	part = "socks"
	gr:CreateMaterialFromAttribulator(player, lod, "socks", "socks_material", "${AttribMaterial('sock')}" )  
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "shortstex", "shorts_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "shortstex", "shorts_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "shortsam", "shorts_am")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "weavePatternNormalMap", "cmnweave", "kit_weave")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "sockbnmlod", "shorts_nm")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourSocksPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourSocksSec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourSocksTer}")

	-- shoes
	part = "shoes"
	gr:CreateMaterialFromAttribulator(player, lod, part, "shoe_material", "${AttribMaterial('shoe')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "shoetex", "shoe_cm")	
	gr:SetTexture(player, lod, part, "textures", "normalMap", "shoetex", "shoe_nm")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "shoetex", "shoe_coeff")	
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "customColorPri", "${db.player[?].shoeColorPri}")
	gr:SetConstantARGB(player, lod, part, "global", "customColorSec", "${db.player[?].shoeColorSec}")
	gr:SetConstantARGB(player, lod, part, "global", "customColorTer", "${db.player[?].shoeColorTer}")
	
	--underarmor neck
	local part = "underneck"
	gr:CreateMaterialFromAttribulator(player, lod, part, "underneck_material", "${AttribMaterial('undergear')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "jersey_tex", "jersey_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "kittex_common", "jersey_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "jerseyam", "jersey_am")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "weavePatternNormalMap", "cmnweave", "kit_weave")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "jerseybnm", "jersey_nm")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourJerseyPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourJerseySec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourJerseyTer}")
	
	--underarmor sleeves
	local part = "underarms"
	gr:CreateMaterialFromAttribulator(player, lod, part, "underarms_material", "${AttribMaterial('undergear')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "jersey_tex", "jersey_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "kittex_common", "jersey_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "jerseyam", "jersey_am")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "weavePatternNormalMap", "cmnweave", "kit_weave")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "jerseybnm", "jersey_nm")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")
	
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourJerseyPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourJerseySec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourJerseyTer}")

	--undershorts
	local part = "undershorts"
	gr:CreateMaterialFromAttribulator(player, lod, part, "undershorts_material", "${AttribMaterial('undergear')}") 
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "shortstex", "shorts_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "shortstex", "shorts_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "shortsam", "shorts_am")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "shortsbnm", "shorts_nm")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "weavePatternNormalMap", "cmnweave", "kit_weave")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourShortPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourShortSec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourShortTer}")
	
end

---------------------------------------------------------------------------------------------------
function PlayerAssetLowLod(player, lod)
	local gr = gRenderables

	skinLodTone = "${GetSkinTone(?,"..lod..")}"
	faceLodTone = "${GetFaceTone(?,"..lod..")}"


	-- GEO's
	if (lod == 1) then
		gr:AddAsset(player, lod, "jersey", "data/sceneassets/body/jersey_1_${db.player[?].jerseyCollarType}_${db.player[?].jerseySleeveLength}_${db.player[?].jerseyArmBand}_${db.player[?].jerseyTucked}_${db.player[?].jerseyfit}.rx3")
		gr:AddAsset(player, lod, "shorts", "data/sceneassets/body/shorts_1_${db.player[?].shortstyle}.rx3")
		gr:AddAsset(player, lod, "bodyskinlod", "data/sceneassets/body/body_1_${db.player[?].armLength}_0.rx3")
		gr:AddAsset(player, lod, "bodyshoelod", "data/sceneassets/body/shoes_1_0.rx3")
		gr:AddAsset(player, lod, "bodysocklod", "data/sceneassets/body/socks_1_${db.player[?].socklength}.rx3")
		gr:AddAsset(player, lod, "headlod",  "data/sceneassets/headlod/headlod_${db.player[?].head}_${db.player[?].headClass}_1.rx3;data/sceneassets/body/head_1.rx3")
		gr:AddAsset(player, lod, "eyeslod",  "data/sceneassets/headlod/headlod_${db.player[?].head}_${db.player[?].headClass}_1.rx3;data/sceneassets/body/head_1.rx3")
	elseif (lod == 2) then
		gr:AddAsset(player, lod, "jersey", "data/sceneassets/body/jersey_2_${db.player[?].jerseySleeveLength}_${db.player[?].jerseyArmBand}_${db.player[?].jerseyTucked}.rx3")
		gr:AddAsset(player, lod, "shorts", "data/sceneassets/body/shorts_2_${db.player[?].shortstyle}.rx3")
		gr:AddAsset(player, lod, "bodyskinlod", "data/sceneassets/body/body_2_${db.player[?].armLength}_0.rx3")
		gr:AddAsset(player, lod, "bodyshoelod", "data/sceneassets/body/shoes_2_0.rx3")
		gr:AddAsset(player, lod, "bodysocklod", "data/sceneassets/body/socks_2_${db.player[?].socklength}.rx3")
		gr:AddAsset(player, lod, "headlod",  "data/sceneassets/headlod/headlod_${db.player[?].head}_${db.player[?].headClass}_2.rx3;data/sceneassets/body/head_2.rx3")
		gr:AddAsset(player, lod, "eyeslod",  "data/sceneassets/headlod/headlod_${db.player[?].head}_${db.player[?].headClass}_2.rx3;data/sceneassets/body/head_2.rx3")
	end
	
	gr:AddAsset(player, lod, "hairlod",  "data/sceneassets/hairlod/hairlod_${db.player[?].playerassetid}_0_0.rx3;data/sceneassets/hairlod/hairlod_${db.player[?].hair}_${db.player[idx].faceProxyHeadClass}_0.rx3")
	gr:AddAsset(player, lod, "jerseybnmlod", "data/sceneassets/kit/jersey_${db.player[?].jerseyTucked}_${db.player[?].jerseyfit}_bnm_lod.rx3")
	gr:AddAsset(player, lod, "shortsbnmlod", "data/sceneassets/kit/shorts_${db.player[?].shortstyle}_bnm_lod.rx3")

	local part = "jersey"
	gr:CreateMaterialFromAttribulator(player, lod, part, "jersey_material", "${AttribMaterial('jerseylod')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "jersey_tex", "jersey_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "kittex_common", "jersey_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "jerseyam", "jersey_am")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
    gr:SetTextureToAtlas(player, lod, "jersey", "textures", "atlas", "cmnweave", "kit_weave", "jersey_weaveMapAtlas")
    gr:SetTexture(player, lod, "jersey", "textures", "wrinkleMap", "jerseybnmlod", "jersey_nm")
    gr:SetTextureToAtlas(player, lod, "jersey", "textures", "atlas", "kitnumbers", "numbers_${db.player[?].kitNumberFont}_${db.player[?].kitNumberColor}_${db.player[?].kitNumberTens}", "jersey_numTensAtlas")
    gr:SetTextureToAtlas(player, lod, "jersey", "textures", "atlas", "kitnumbers", "numbers_${db.player[?].kitNumberFont}_${db.player[?].kitNumberColor}_${db.player[?].kitNumberUnits}", "jersey_numUnitsAtlas")
    gr:SetTextureToAtlas(player, lod, "jersey", "textures", "atlas", "cresttex", "${db.player[?].crestTexName}", "jersey_decalAtlas")
    gr:SetTextureFromRuntimeToAtlas(player, lod, "jersey", "textures", "atlas", "namestamp${?}", "jersey_nameAtlas")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")
	
	gr:SetHotSpot(player, lod, part, "global", "jersey_decalBounds", "kithotspots", "jersey", "team")
	gr:SetHotSpot(player, lod, part, "global", "jersey_nameBound", "kithotspots", "jersey", "name")
	gr:SetHotSpot(player, lod, part, "global", "jersey_nameArcCenter", "kithotspots", "jersey", "name_arccenter")
	gr:SetConstantInt(player, lod, part, "global", "jersey_nameLayout", "${db.player[?].jerseyNameLayout}")
	
	gr:SetConstantARGB(player, lod, part, "global", "jersey_nameColor", "${db.player[?].kitNameColor}")

	part = "shorts"
	gr:CreateMaterialFromAttribulator(player, lod, part, "body_material", "${AttribMaterial('shortslod')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "shortstex", "shorts_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "shortstex", "shorts_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "shortsam", "shorts_am")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "shortsbnmlod", "shorts_nm")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
    gr:SetTextureToAtlas(player, lod, "shorts", "textures", "atlas", "cmnweave", "kit_weave", "shorts_weaveMapAtlas")
    gr:SetTextureToAtlas(player, lod, "shorts", "textures", "atlas", "cresttex", "${db.player[?].crestTexName}", "shorts_decalAtlas")
    gr:SetTextureToAtlas(player, lod, "shorts", "textures", "atlas", "shortsnumbers", "numbers_${db.player[?].shortsNumberFont}_${db.player[?].shortsNumberColor}_${db.player[?].kitNumberTens}", "shorts_numTensAtlas")
    gr:SetTextureToAtlas(player, lod, "shorts", "textures", "atlas", "shortsnumbers", "numbers_${db.player[?].shortsNumberFont}_${db.player[?].shortsNumberColor}_${db.player[?].kitNumberUnits}", "shorts_numUnitsAtlas")
	gr:SetHotSpot(player, lod, part, "global", "shorts_decalBounds", "shortshotspots", "shorts", "team")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourShortPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourShortSec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourShortTer}")

	part = "bodyskinlod"
	gr:CreateMaterialFromAttribulator(player, lod, part, "body_material", skinLodTone )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "skintex", "body_")  
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "normalMap", "bodycmn", "body_nm")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "bodycmn", "body_coeff")
	gr:SetConstantARGB(player, lod, part, "global", "skincolor", "${db.player[?].playerBodySkinColor}")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	part = "bodyshoelod"
	gr:CreateMaterialFromAttribulator(player, lod, part, "body_material", "${AttribMaterial('shoelod')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "shoetex", "shoe_cm")	
	gr:SetTexture(player, lod, part, "textures", "normalMap", "shoetex", "shoe_nm")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "shoetex", "shoe_coeff")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")	
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "customColorPri", "${db.player[?].shoeColorPri}")
	gr:SetConstantARGB(player, lod, part, "global", "customColorSec", "${db.player[?].shoeColorSec}")
	gr:SetConstantARGB(player, lod, part, "global", "customColorTer", "${db.player[?].shoeColorTer}")

	part = "bodysocklod"
	gr:CreateMaterialFromAttribulator(player, lod, part, "body_material", "${AttribMaterial('socklod')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "shortstex", "shorts_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "shortstex", "shorts_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "shortsam", "shorts_am")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "weavePatternNormalMap", "cmnweave", "kit_weave")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "shortsbnmlod", "shorts_nm")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourSocksPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourSocksSec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourSocksTer}")

	-- eyes
	part = "eyeslod"
	gr:CreateMaterialFromAttribulator(player, lod, part, "head_material", "${AttribMaterial('eyeslod')}" )
	gr:SetSubMesh(player, lod, part, "eye")
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "eyetex", "eyes_")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "headcmn", "eye_coeff")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "env_")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	-- head
	part = "headlod"
	gr:CreateMaterialFromAttribulator(player, lod, part, "head_material", faceLodTone )
	gr:SetSubMesh(player, lod, part, "head")
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "facetex", "head_")
	gr:SetTexture(player, lod, part, "textures", "normalMap", "headcmn", "head_0_nm")
	gr:SetTexture(player, lod, part, "textures", "coeffMap", "headcmn", "head_coeff")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	-- hair
	part = "hairlod"
	gr:CreateMaterialFromAttribulator(player, lod, part, "hair_material", "${AttribMaterial('player_hair_kk_alphaA_lod')}")
	gr:SetSubMesh(player, lod, part, "alphaA")
	gr:SetPriority(player, lod, part, 1)
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "hairtex", "hair_cm")
	gr:SetTexture(player, lod, part, "textures", "specAlphaMap", "hairtex", "hair_coeff")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetConstantARGB(player, lod, part, "global", "hairColor", "${GetHairColorARGB(?)}")
	
	--underarmor neck
	local part = "underneck"
	gr:CreateMaterialFromAttribulator(player, lod, part, "underneck_material", "${AttribMaterial('socklod')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "jersey_tex", "jersey_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "kittex_common", "jersey_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "jerseyam", "jersey_am")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "weavePatternNormalMap", "cmnweave", "kit_weave")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "jerseybnmlod", "jersey_nm")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourJerseyPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourJerseySec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourJerseyTer}")

	--underarmor sleeves
	local part = "underarms"
	gr:CreateMaterialFromAttribulator(player, lod, part, "underarms_material", "${AttribMaterial('socklod')}" )
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "jersey_tex", "jersey_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "kittex_common", "jersey_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "jerseyam", "jersey_am")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "weavePatternNormalMap", "cmnweave", "kit_weave")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "jerseybnm", "jersey_nm")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourJerseyPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourJerseySec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourJerseyTer}")

	
	--undershorts
	local part = "undershorts"
	gr:CreateMaterialFromAttribulator(player, lod, part, "undershorts_material", "${AttribMaterial('socklod')}") 
	gr:SetTexture(player, lod, part, "textures", "diffuseTexture", "shortstex", "shorts_cm")
	gr:SetTexture(player, lod, part, "textures", "specularMap", "shortstex", "shorts_coeff")
	gr:SetTexture(player, lod, part, "textures", "occlusionMap", "shortsam", "shorts_am")
	gr:SetTexture(player, lod, part, "textures", "wrinkleMap", "shortsbnmlod", "shorts_nm")
	gr:SetTexture(player, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(player, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetTexture(player, lod, part, "textures", "weavePatternNormalMap", "cmnweave", "kit_weave")
	gr:SetTextureFromRuntime(player, lod, part, "textures", "coverageMap", "covmap_${db.player[?].stadiumID}_${db.player[?].stadiumLightID}")

	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorPri", "${db.player[?].kitColourShortPri}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorSec", "${db.player[?].kitColourShortSec}")
	gr:SetConstantARGB(player, lod, part, "global", "jerseyCustomColorTer", "${db.player[?].kitColourShortTer}")
	
end

---------------------------------------------------------------------------------------------------
function GetFaceTexTemplate(idx)
	if(db.player[idx].isVirtualPro == 1) then
		--return "data/sceneassets/faces/face_"..db.player[idx].faceType.."_"..db.player[idx].faceProxyHeadClass.."_0_"..db.player[idx].eyebrow.."_"..db.player[idx].faceSideBurn.."_"..db.player[idx].facialHairColor.."_"..db.player[idx].facialHairType.."_"..db.player[idx].headSkinType.."_"..db.player[idx].headSkinToneType.."_textures."..db.player[idx].faceTexExtension..";data/sceneassets/faces/face_"..db.player[idx].faceTypeFallback.."_"..db.player[idx].faceProxyHeadClass.."_0_"..db.player[idx].eyebrow.."_"..db.player[idx].faceSideBurnFallback.."_"..db.player[idx].facialHairColorFallback.."_"..db.player[idx].facialHairTypeFallback.."_"..db.player[idx].headSkinTypeFallback.."_"..db.player[idx].headSkinToneTypeFallback.."_textures.rx3"
		facetex = string.format("data/easw/head_%d.dds", db.player[idx].faceType)
		return facetex..";data/sceneassets/faces/face_"..db.player[idx].faceTypeFallback.."_"..db.player[idx].faceProxyHeadClass.."_0_"..db.player[idx].eyebrow.."_"..db.player[idx].faceSideBurnFallback.."_"..db.player[idx].facialHairColorFallback.."_"..db.player[idx].facialHairTypeFallback.."_"..db.player[idx].headSkinTypeFallback.."_"..db.player[idx].headSkinToneTypeFallback.."_textures.rx3"
	else
		return "data/sceneassets/faces/face_"..db.player[idx].playerassetid.."_0_0_0_0_0_0_0_0_textures.rx3;data/sceneassets/faces/face_"..db.player[idx].faceType.."_"..db.player[idx].faceProxyHeadClass.."_0_"..db.player[idx].eyebrow.."_"..db.player[idx].faceSideBurn.."_"..db.player[idx].facialHairColor.."_"..db.player[idx].facialHairType.."_"..db.player[idx].headSkinType.."_"..db.player[idx].headSkinToneType.."_textures."..db.player[idx].faceTexExtension .. ";data/sceneassets/faces/face_0_0_0_0_0_0_0_0_0_textures.rx3"
	end
end

---------------------------------------------------------------------------------------------------
function GetJerseyBMN(idx)

	if(db.player[idx].forceLowResBNM == 1 or db.player[idx].forcePowerOfTwoBNM == 1) then
		return "data/sceneassets/kit/jersey_${db.player[?].jerseyTucked}_${db.player[?].jerseyfit}_bnm_x2.rx3"
	end
		
	return "data/sceneassets/kit/jersey_${db.player[?].jerseyTucked}_${db.player[?].jerseyfit}_bnm.rx3"
end

---------------------------------------------------------------------------------------------------
function GetShortsBMN(idx)

	if(db.player[idx].forcePowerOfTwoBNM == 1 or db.player[idx].forceLowResBNM == 1) then
		return "data/sceneassets/kit/shorts_0_bnm_x2.rx3"
	end
	
	return "data/sceneassets/kit/shorts_${db.player[idx].shortstyle}_bnm.rx3"
end

---------------------------------------------------------------------------------------------------
-- returns kit texture or goalie pants kit 5200
function GetShortsTex(idx)
	if(db.player[idx].shortstyle == 1) then
		return "data/sceneassets/kit/kit_5200_0_0.rx3"
	else
		return getKitFile()
	end
end

function GetKitTextureOperation(idx)
	if (db.player[idx].useTextureComposition == 1) then
		-- Creation Zone requires generated textures, describe the operation
		-- assetOperation generatetexture: "generatetexture texname width, height, mipCount, compression"
		return "generatetexture jersey_cm 1024,1024,9,eadxt1"
	else
		-- For others we do not need to generate the texture, so we just extract the source asset
		return "extracttexture jersey_cm"
	end
end

function GetKitTextureAssetName(idx)
	if (db.player[idx].useTextureComposition == 1) then
		-- Creation Zone requires generated textures, thus give the asset a unique name
		-- For CZ, kittype is always home, and year is always zero.
		return "gentex_kit_${db.player[?].kit}_${db.player[?].kitType}_${db.player[?].kitYear}_${db.player[?].teamside}_${db.player[?].kitColourJerseyPri}_${db.player[?].kitColourJerseySec}_${db.player[?].kitColourJerseyTer}"
	else
		-- Keep regular rx3 name as this is the source of the texture
		return getKitFile()
	end
end


---------------------------------------------------------------------------------------------------
function PlayerAssetLod(player, lod)
	local gr = gRenderables
	
	local defaultpriority = 0	-- default priority

	gr:AddCallback(player, lod, "PlayerUpdate(?)")
	
	local kitTexAsset = getKitFile()
	
	-- Generic files needed by all LODs
	gr:AddAsset(player, lod, "shader", "data/fifarna/shader.big")		
	gr:AddAsset(player, lod, "charcmn", "data/sceneassets/charactercmn/charactercmn_${db.player[?].envLighting}.rx3")	
	gr:AddAsset(player, lod, "bodycmn", "data/sceneassets/body/body_common_textures.rx3")	
	gr:AddAsset(player, lod, "headcmn", "data/sceneassets/heads/head_${db.player[?].playerassetid}_bump.rx3;data/sceneassets/heads/head_common_textures.rx3")	

	-- Sponsor image for stamping onto kit
	gr:AddAsset(player, lod, "sponsortex", "data/ugc/cz_sponsor/${db.player[?].sponsorAssetId}.png;data/ugc/cz_sponsor/1.png", defaultpriority, ALLOCTYPE_TEMP_AUTO_RELEASE)
	
	-- gr:AddAssetEx(asset, lod, assetOperation, assetPart, containerName)
	-- extracttexture will create an asset with just the texture you extract from the source asset, this way we can free the original rx3, freeing unused textures.
	gr:AddAssetEx(player, lod, "extracttexture jersey_coeff", "kittex_common" , kitTexAsset)
	gr:AddAssetEx(player, lod, "extracttexture shorts_cm,shorts_coeff", "shortstex" , "${GetShortsTex(?)}")
	gr:AddAssetEx(player, lod, "extracthotspots", "kithotspots" , kitTexAsset)
	gr:AddAssetEx(player, lod, "extracthotspots", "shortshotspots",  "${GetShortsTex(?)}")
    gr:AddAssetExToAtlas(player, lod, "extracttexturenofreezenokeep ${db.player[?].crestTexName}", "cresttex", "${GetCrestAsset(?)}") 	

	-- Texture composition code
	-- Add the template asset as a temporary asset, auto releasing it when it's not being used (after texture generation in this case)
	gr:AddAssetEx(player, lod, "extracttexture jersey_cm", "kittex_cm_template" , kitTexAsset, defaultpriority, ALLOCTYPE_TEMP_AUTO_RELEASE)
	local part = "jersey_tex"
	-- GetKitTextureOperation will determine if texture composition is needed.
	gr:AddAssetEx(player, lod, "${GetKitTextureOperation(?)}", part , "${GetKitTextureAssetName(?)}")
	-- Describe texture composition in case we have to generate the texture, this material won't be created if no composition is needed.
	gr:CreateMaterial(player, lod, part, "texcomp.fx" )
	gr:SetTexture(player, lod, part, "textures", "texcomp_tex0", "kittex_cm_template", "jersey_cm")
	gr:SetTexture(player, lod, part, "textures", "texcomp_tex1", "sponsortex", "png")
	gr:SetConstantARGB(player, lod, part, "global", "recolorCustomColorPri", "${db.player[?].kitColourJerseyPri}")
	gr:SetConstantARGB(player, lod, part, "global", "recolorCustomColorSec", "${db.player[?].kitColourJerseySec}")
	gr:SetConstantARGB(player, lod, part, "global", "recolorCustomColorTer", "${db.player[?].kitColourJerseyTer}")
	gr:SetConstantARGB(player, lod, part, "global", "recolourMult", "${db.player[?].sponsorcolour}")
	gr:SetConstantHotSpot(player, lod, part, "global", "samplerBounds1", "${db.player[?].hotspotJerseySponsorL};${db.player[?].hotspotJerseySponsorT};${db.player[?].hotspotJerseySponsorR};${db.player[?].hotspotJerseySponsorB}")
	-- End of texture composition
	
	-- Set the jersey texture as a runtime texture so we can use it outside of player
	gr:SetRuntimeTexture(player, lod, "jersey_${db.player[?].kit}_${db.player[?].kitType}_${db.player[?].isgoalie}_${db.player[?].teamside}" , "jersey_tex", "jersey_cm")
	
	gr:AddAsset(player, lod, "shoetex", "data/sceneassets/shoe/shoe_${db.player[?].playerassetid}_0_textures.rx3;data/sceneassets/shoe/shoe_${db.player[?].shoeType}_${db.player[?].shoeDesign}_textures.rx3;data/sceneassets/shoe/shoe_0_0_textures.rx3")
	gr:AddAsset(player, lod, "skintex", "data/sceneassets/body/playerskin_${db.player[?].playerassetid}_textures.rx3;data/sceneassets/body/skin_${db.player[?].bodySkinToneType}_textures.rx3")
	
	gr:AddAsset(player, lod, "hairtex", "data/sceneassets/hair/hair_${db.player[?].playerassetid}_0_textures.rx3;data/sceneassets/hair/hair_${db.player[?].hair}_${db.player[?].faceProxyHeadClass}_textures.rx3")
	gr:AddAsset(player, lod, "shortsam", "data/sceneassets/kit/shorts_${db.player[?].shortstyle}_${db.player[?].wet}_textures.rx3")
	gr:AddAsset(player, lod, "jerseyam", "data/sceneassets/kit/jersey_${db.player[?].jerseyTucked}_${db.player[?].wet}_textures.rx3")
	local jerseyBNM = "${GetJerseyBMN(?)}"
	gr:AddAsset(player, lod, "jerseybnm", jerseyBNM)

    gr:AddAssetExToAtlas(player, lod, "nofreezenokeep", "cmnweave", "data/sceneassets/kit/kitweave.rx3")


	local shortsBNM = "${GetShortsBMN(?)}"
	gr:AddAsset(player, lod, "shortsbnm", shortsBNM)
	
	-- Dirt masks not used in FIFARNA There is no runtime logic to drive them besides the expensiveness
	-- gr:AddAsset(player, lod, "shortsdk", "data/sceneassets/kit/shorts_dk.rx3")
	-- gr:AddAsset(player, lod, "jerseydk", "data/sceneassets/kit/jersey_dk.rx3")

	gr:AddAsset(player, lod, "eyetex", "data/sceneassets/heads/eyes_${db.player[?].playerassetid}_0_textures.rx3;data/sceneassets/heads/eyes_${db.player[?].eyeColor}_${db.player[?].faceProxyHeadClass}_textures.rx3;data/sceneassets/heads/eyes_${db.player[?].eyeColor}_1_textures.rx3;data/sceneassets/heads/eyes_0_0_textures.rx3")

	
	-- Add font as a temporary asset, because the font is used after the load (bind time), we still have to manually release it from the renderable
	-- TODO: add font stamping support to composite instead of having the renderable do this at bind time
	local kitnamestring = ""
	kitnamestring = kitnamestring.."data/sceneassets/jerseyfonts/specificfont_${db.player[?].teamid}_${db.player[?].tournid}.ttf;"
    kitnamestring = kitnamestring.."data/sceneassets/jerseyfonts/specificfont_0_${db.player[?].tournid}.ttf;"
    kitnamestring = kitnamestring.."data/sceneassets/jerseyfonts/specificfont_${db.player[?].teamid}_0.ttf;"
	kitnamestring = kitnamestring.."data/sceneassets/jerseyfonts/specificfont_0_${db.player[?].defaulttournid}.ttf;"
	kitnamestring = kitnamestring.."data/sceneassets/jerseyfonts/specificfont_0_0.ttf;"
	local kitnumberstring = ""
	kitnumberstring = kitnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_${db.player[?].teamid}_${db.player[?].tournid}_${db.player[?].kitNumberColor}.rx3;"
	kitnumberstring = kitnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_0_${db.player[?].tournid}_${db.player[?].kitNumberColor}.rx3;"
	kitnumberstring = kitnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_${db.player[?].teamid}_0_${db.player[?].kitNumberColor}.rx3;"
	kitnumberstring = kitnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_0_${db.player[?].defaulttournid}_${db.player[?].kitNumberColor}.rx3;"
	kitnumberstring = kitnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_0_0_${db.player[?].kitNumberColor}.rx3;"
	local shortnumberstring = ""
	shortnumberstring = shortnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_${db.player[?].teamid}_${db.player[?].tournid}_${db.player[?].shortsNumberColor}.rx3;"
	shortnumberstring = shortnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_0_${db.player[?].tournid}_${db.player[?].shortsNumberColor}.rx3;"
	shortnumberstring = shortnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_${db.player[?].teamid}_0_${db.player[?].shortsNumberColor}.rx3;"
	shortnumberstring = shortnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_0_${db.player[?].defaulttournid}_${db.player[?].shortsNumberColor}.rx3;"
	shortnumberstring = shortnumberstring.."data/sceneassets/kitnumbers/specifickitnumbers_0_0_${db.player[?].shortsNumberColor}.rx3;"
	gr:AddAsset(player, lod, "font", kitnamestring.."data/sceneassets/jerseyfonts/font_${db.player[?].kitNameFont}.ttf;data/sceneassets/jerseyfonts/font_6.ttf", defaultpriority, ALLOCTYPE_TEMP_MANUAL_RELEASE)
    gr:AddAssetExToAtlas(player, lod, "nofreezenokeep", "kitnumbers", "data/sceneassets/kitnumbers/kitnumbers_${db.player[?].kitNumberFont}_${db.player[?].kitNumberColor}.rx3;data/sceneassets/kitnumbers/kitnumbers_0_0.rx3")
    gr:AddAssetExToAtlas(player, lod, "nofreezenokeep", "shortsnumbers", "data/sceneassets/kitnumbers/kitnumbers_${db.player[?].shortsNumberFont}_${db.player[?].shortsNumberColor}.rx3;data/sceneassets/kitnumbers/kitnumbers_0_0.rx3")
	
	local faceGenTemplate = "${GetFaceTexTemplate(?)}"
	gr:AddAsset(player, lod, "facetex", faceGenTemplate)
	
	gr:AddAsset(player, lod, "underarms", "data/sceneassets/body/underarms_0_${db.player[?].underarms}.rx3")
	gr:AddAsset(player, lod, "underneck", "data/sceneassets/body/underneck_0_${db.player[?].underneck}.rx3")
	gr:AddAsset(player, lod, "undershorts", "data/sceneassets/body/undershorts_0_${db.player[?].undershorts}.rx3")


	if (lod == 0) then
		PlayerAssetHighLod(player, lod)
	elseif (lod == 1) then
		PlayerAssetLowLod(player, lod)	
	elseif (lod == 2) then
		PlayerAssetLowLod(player, lod)	
	elseif (lod == 3) then
		PlayerAssetShadow(player, lod)
	end	
	
end

---------------------------------------------------------------------------------------------------
function PlayerAssetBind(player)
	PlayerAssetLod(player, 0)
	PlayerAssetLod(player, 1)
	PlayerAssetLod(player, 2)
	PlayerAssetLod(player, 3)
	
end

function CustomPlayer(idxId, playerId, jerseySleeve, cuff, sockLength, shoeType)
  if db.player[idxId].playerassetid == playerId then
    if jerseySleeve ~= '' and jerseySleeve ~= 'Default' then
      db.player[idxId].jerseySleeveLength = jerseySleeve;
      db.player[idxId].armLength = jerseySleeve;
    end

    if cuff ~= '' and cuff ~= 'Default' then
      if cuff == 1 then
        db.player[idxId].jerseySleeveLength = 0
        db.player[idxId].underneck = -1
        db.player[idxId].underarms = 0
        db.player[idxId].armLength = 1
      else
        db.player[idxId].armLength = db.player[idxId].jerseySleeveLength
        db.player[idxId].underneck = -1
        db.player[idxId].underarms = -1
        db.player[idxId].undershorts = -1
      end
    end

    if sockLength ~= '' and sockLength ~= 'Default' then
      db.player[idxId].socklength = sockLength;
    end

    if shoeType ~= '' then
      db.player[idxId].shoeType = shoeType;
    end
  end
end

playerFace = {}

function assignPlayerFace(id)
playerFace[id] = 0
end

function getPlayerFace(id,headtype)

if (playerFace[id] ~= nil) then
return playerFace[id]
else
return headtype
end

end



function getTournamentGraphics(id)

if (gloTourn ~= nil) then
return gloTourn
end

if (id == -1) then
return frTourn
end

return id
end





weatherAcc = {}
weatherAcc[0] = 0
weatherAcc[1] = 1
weatherAcc[2] = 1

function setWinterAccessoriesWeather(weather,option)
weatherAcc[weather] = option
end

function getWinterAccessoriesWeather(weather)

if (weatherAcc[weather] ~= nil) then
return (weatherAcc[weather] == 1)
end

return true
end


winterAccessories = {}

function assignWinterAccessories(player,option)
winterAccessories[player] = option
end

function getWinterAccessories(player,option)

if (winterAccessories[player] ~= nil) then
return winterAccessories[player]
end

return option
end


sleeveLength = {}

function setSleeveLength(player,option)
sleeveLength[player] = option
end

function getSleeveLength(player,option)

if (sleeveLength[player] ~= nil) then
return sleeveLength[player]
end

return option
end



winterAccessoriesRef = nil

function useGlobalRefereeWinterAccessories(option)
winterAccessoriesRef = option
end

function getRefereeWinterAccessories(option)

if (winterAccessoriesRef ~= nil) then
return winterAccessoriesRef
end

return option
end


function getKitFile()
if (autoKits) then
local kitstring = ""
kitstring = kitstring.."data/sceneassets/kit/kit_${db.player[?].kit}_${db.player[?].speckitType}_0.rx3;"
kitstring = kitstring.."data/sceneassets/kit/kit_${db.player[?].kit}_${db.player[?].kitType}_${db.player[?].tournid}.rx3;"
kitstring = kitstring.."data/sceneassets/kit/kit_${db.player[?].kit}_${db.player[?].kitType}_${db.player[?].defaulttournid}.rx3;"
kitstring = kitstring.."data/sceneassets/kit/kit_${db.player[?].kit}_${db.player[?].kitType}_${db.player[?].kitYear}.rx3;"
kitstring = kitstring.."data/sceneassets/kit/kit_${db.player[?].kit}_${db.player[?].kitType}_0.rx3;"
kitstring = kitstring.."data/sceneassets/kit/kit_${db.player[?].genkit}_${db.player[?].kitType}_${db.player[?].kitYear}.rx3;"
kitstring = kitstring.."data/sceneassets/kit/kit_${db.player[?].genkit}_${db.player[?].kitType}_0.rx3"
return kitstring
end
return "data/sceneassets/kit/kit_${db.player[?].kit}_${db.player[?].kitType}_${db.player[?].kitYear}.rx3;data/sceneassets/kit/kit_${db.player[?].genkit}_${db.player[?].kitType}_${db.player[?].kitYear}.rx3"
end
--------------------------------------------------------------------------------------------------------------
--[Scouser09, Ramzidz15, AF ID, +1BotSwanNoMercy, Pedri Pesshop, Ahmad Rizki]
--V2.0
---------------------------------------------------------------------------------------------------------------------------------------------
