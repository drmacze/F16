function StadiumUpdate(idx)
	local as = gSportsRNA
	local state = as:GetTable("wvState")
	local stadium = as:GetTable("wvStadium", idx)

	db.stadium[idx].lightType = as:GetInt(stadium, "stadLightType")
	db.stadium[idx].stadiumID = as:GetInt(stadium, "stadID")
	db.stadium[idx].mowPattern = as:GetInt(stadium, "pitchMowPattern")
	db.stadium[idx].wearPattern = as:GetInt(stadium, "pitchWearPattern")
	db.stadium[idx].skyCategoryId = as:GetInt(state, "wvAttribSkyCategory")
	db.stadium[idx].skyAssetId = as:GetInt(state, "wvAttribSkyID")
	
	db.stadium[idx].adboardID = as:GetInt(stadium, "adboardID" )
	db.stadium[idx].adboardGroup = as:GetInt(stadium, "adboardGroup" )
	
	db.stadium[idx].homeKitTeamID = as:GetInt(stadium, "homeKitTeamID" )
	db.stadium[idx].homeKitTypeID = as:GetInt(stadium, "homeKitTypeID" )
	db.stadium[idx].awayKitTeamID = as:GetInt(stadium, "awayKitTeamID" )
	db.stadium[idx].awayKitTypeID = as:GetInt(stadium, "awayKitTypeID" )
	
	db.stadium[idx].isHomeFCZ = as:GetInt(stadium, "isHomeCreationZone")
	db.stadium[idx].isAwayFCZ = as:GetInt(stadium, "isAwayCreationZone")
	
	db.stadium[idx].homeTeamAssetId = as:GetInt(stadium, "homeTeamAssetId")
	db.stadium[idx].hasCzCrestImage = as:GetInt(stadium, "hasCzCrestImage")
	
	db.stadium[idx].homePrimaryColour = as:GetInt(stadium, "homePrimaryColour")
	db.stadium[idx].homeSecondaryColour = as:GetInt(stadium, "homeSecondaryColour")
	db.stadium[idx].awayPrimaryColour = as:GetInt(stadium, "awayPrimaryColour")
	db.stadium[idx].awaySecondaryColour = as:GetInt(stadium, "awaySecondaryColour")
	
	db.stadium[idx].homeBannerId = db.stadium[idx].homeKitTeamID
	db.stadium[idx].awayBannerId = db.stadium[idx].awayKitTeamID
	
	db.stadium[idx].homeBannerPrimaryColour = 0xffff0000
	db.stadium[idx].homeBannerSecondaryColour = 0xff00ff00
	db.stadium[idx].awayBannerPrimaryColour = 0xffff0000
	db.stadium[idx].awayBannerSecondaryColour = 0xff00ff00
	
	db.stadium[idx].weather = as:GetInt(state, "wvAttribStadWeather" )

	
	if ( db.stadium[idx].isHomeFCZ == 1 ) then
		db.stadium[idx].homeBannerId = 7500
		db.stadium[idx].homeBannerPrimaryColour = db.stadium[idx].homePrimaryColour
		db.stadium[idx].homeBannerSecondaryColour = db.stadium[idx].homeSecondaryColour
	end
	
	if ( db.stadium[idx].isAwayFCZ == 1 ) then
		db.stadium[idx].awayBannerId = 7500
		db.stadium[idx].awayBannerPrimaryColour = db.stadium[idx].awayPrimaryColour
		db.stadium[idx].awayBannerSecondaryColour = db.stadium[idx].awaySecondaryColour
	end
	
	-- If we swap the home/away banners, don't draw the away banners (because they take up most of the stadium)
	local swapHomeAwayCrowd = as:GetInt(stadium, "swapHomeAwayCrowd")
	if ( swapHomeAwayCrowd == 1 ) then
		db.stadium[idx].homeBannerId, db.stadium[idx].awayBannerId = 0, db.stadium[idx].homeBannerId
		db.stadium[idx].homeBannerPrimaryColour, db.stadium[idx].awayBannerPrimaryColour = db.stadium[idx].awayBannerPrimaryColour, db.stadium[idx].homeBannerPrimaryColour
		db.stadium[idx].homeBannerSecondaryColour, db.stadium[idx].awayBannerSecondaryColour = db.stadium[idx].awayBannerSecondaryColour, db.stadium[idx].homeBannerSecondaryColour
	end
	
	db.stadium[idx].dressingAssetID = as:GetInt(stadium, "tournamentDressingID")

	--SetCustomStadium(idx, 100, 241)

	-- 0 - v7 默认草皮
	-- 1 - 方格草皮
	-- 2 - fifa22草皮
	-- 3 - 写实草皮
	-- 4 - 深色草皮
	-- 5 - 横条纹草皮1
	-- 6 - 足球世界草皮
	-- 7 - 横条纹草皮2 ()
	-- 8 - 竖条纹草皮

	
end

function GetHomeKitAssetSrc(idx)
	if ( db.stadium[idx].isHomeFCZ == 1 ) then
		if ( db.stadium[idx].hasCzCrestImage > 0 ) then
			return "data/ugc/cz_crest/${db.stadium[?].homeTeamAssetId}.png;data/ugc/cz_crest/1.png"
		else
			return "data/sceneassets/crest/crest_${db.stadium[?].homeTeamAssetId}.rx3"
		end
	else
		return "data/ui/imgassets/crest/l${db.stadium[?].homeKitTeamID}.dds"
	end
end

function GetCrestTexName(idx)
	if ( db.stadium[idx].hasCzCrestImage > 0 ) then
		return "png"
	else
		return ""
	end
end

function GetDynamicSkyTexture(idx)
	local random = math.random()
	if (random <= 0.25) then
		-- 白天
		local random1 = math.random(1, 2)
		db.stadium[idx].skyAssetId = random1
		return "data/sceneassets/sky/sky_1_${db.stadium[?].skyAssetId}.rx3;data/sceneassets/sky/sky_0_0.rx3"
	elseif (random <= 0.5 and random > 0.25) then
		-- 阴天
		local random1 = math.random(1, 3)
		db.stadium[idx].skyAssetId = random1
		return "data/sceneassets/sky/sky_2_${db.stadium[?].skyAssetId}.rx3;data/sceneassets/sky/sky_0_0.rx3"
	elseif (random <= 0.75 and random > 0.50) then
		-- 黄昏
		local random1 = math.random(1, 2)
		db.stadium[idx].skyAssetId = random1
		return "data/sceneassets/sky/sky_3_${db.stadium[?].skyAssetId}.rx3;data/sceneassets/sky/sky_0_0.rx3"
	else
		-- 夜晚
		local random1 = math.random(1, 4)
		db.stadium[idx].skyAssetId = random1
		return "data/sceneassets/sky/sky_4_${db.stadium[?].skyAssetId}.rx3;data/sceneassets/sky/sky_0_0.rx3"
	end
end

function GetDynamicStadiumPitch(idx, type)
	local pitchtype = db.stadium[idx].pitchtype
	local stadiumid = db.stadium[idx].stadiumID
	if not pitchtype then
		db.stadium[idx].pitchtype = 0
	end
	if (type == 1) then
		return "data/sceneassets/pitch/${db.stadium[?].pitchtype}/pitchmowpattern_${db.stadium[?].mowPattern}_textures.rx3;data/sceneassets/pitch/pitchmowpattern_${db.stadium[?].mowPattern}_textures.rx3"
	elseif (type == 2) then
		return "data/sceneassets/pitch/${db.stadium[?].pitchtype}/pitch_common_textures.rx3;data/sceneassets/pitch/pitch_common_textures.rx3"
	elseif (type == 3) then
		return "data/sceneassets/pitch/${db.stadium[?].pitchtype}/pitchcolor_0_textures.rx3;data/sceneassets/pitch/pitchcolor_0_textures.rx3"
	elseif (type == 4) then
		return "data/sceneassets/pitch/${db.stadium[?].pitchtype}/pitchwearpattern_${db.stadium[?].wearPattern}_textures.rx3;data/sceneassets/pitch/pitchwearpattern_${db.stadium[?].wearPattern}_textures.rx3"
	end
end


function SetCustomStadiumPitch(idx, stadiumid, pitchtype)
	if (db.stadium[idx].stadiumID == stadiumid and pitchtype and pitchtype ~= "") then
		db.stadium[idx].pitchtype = pitchtype
	end
end

function SetCustomStadium(idx, stadiumid, teamid)
	if teamid and teamid ~= "" and stadiumid and stadiumid ~= "" and db.stadium[idx].homeTeamAssetId == teamid then
		db.stadium[idx].stadiumID = stadiumid
		-- db.stadium[idx].stadiumAssetID = stadiumid
	end
end

function GetDynamicAdboardsTexture(idx)
	-- if (db.stadium[idx].stadiumID == 147) then
	-- 	return "data/sceneassets/adboard/adboard_${db.stadium[?].stadiumID}_0.rx3;data/sceneassets/adboard/adboard_0_0.rx3"
	-- else
	-- 	local random = math.random(1, 5)
	-- 	db.stadium[idx].adboardID = random
	-- 	return "data/sceneassets/adboard/adboard_${db.stadium[?].homeTeamAssetId}_0.rx3;data/sceneassets/adboard/adboard_0_${db.stadium[?].adboardID}.rx3;data/sceneassets/adboard/adboard_0_0.rx3"
	-- end
	local random = math.random(1, 6)
	db.stadium[idx].adboardID = random
	return "data/sceneassets/adboard/adboard_${db.stadium[?].homeTeamAssetId}_0.rx3;data/sceneassets/adboard/stadium_adboard_${db.stadium[?].stadiumID}_0.rx3;data/sceneassets/adboard/adboard_0_${db.stadium[?].adboardID}.rx3;data/sceneassets/adboard/adboard_0_0.rx3"
	
end

function GetStadiumModel(idx)
	db.stadium[idx].stadiumAssetID = db.stadium[idx].stadiumID
	return "data/sceneassets/stadium/stadium_${db.stadium[?].stadiumAssetID}.rx3;data/sceneassets/stadium/stadium_195.rx3"
	
end

function GetStadiumTexture(idx)
	
	db.stadium[idx].stadiumAssetID = db.stadium[idx].stadiumID
	return "data/sceneassets/stadium/stadium_${db.stadium[?].stadiumAssetID}_${db.stadium[?].lightType}_textures.rx3;data/sceneassets/stadium/stadium_195_1_textures.rx3"

end

function StadiumAssetBind(stadium)
	local gr = gRenderables
	local enableVariablePitchSize = 0
	local lod = 0
	local priority = 1 -- set initial priority to 1 for stadium itself
	local banneridx = 0
	local maxbanners = 11
	local pitchMovType = 1
	local pitchCommonType = 2
	local pitchColorType = 3
	local pitchWearType = 4

	local stadiumAsset = "data/sceneassets/stadium/stadium_${db.stadium[?].stadiumID}.rx3;data/sceneassets/stadium/stadium_33.rx3"
	local stadiumTextureAsset = "data/sceneassets/stadium/stadium_${db.stadium[?].stadiumID}_${db.stadium[?].lightType}_textures.rx3;data/sceneassets/stadium/stadium_33_1_textures.rx3"
	
	
	-- Load all the stadium assets at a higher priority than the rest, so we can get it loaded early	
    gr:SetPriorityBoost(stadium, lod, 10)

	-- Get all assets we require in...
	gr:AddCallback(stadium, lod, "StadiumUpdate(?)")
	gr:AddAsset(stadium, lod, "shader", "data/fifarna/shader.big")

	gr:AddAsset(stadium, lod, "stadium",               "${GetStadiumModel(?)}", priority)
	gr:AddAsset(stadium, lod, "stadiumtextures",       "${GetStadiumTexture(?)}", priority)
	
	-- Assets we need to intercept
	gr:AddAsset(stadium, lod, "pitch",                            stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "pitchnoline",                      stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "jumbotron",                        stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "adboard",                          stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "adboardscrolling",                 stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "adboarddigital",                   stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "adboarddigitalglow",               stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "adboardsingledigital",             stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "adboardsingledigitalglow",         stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "genericad",                        stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "crest",                            stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "homeprimary",                      stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "homesecondary",                    stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "bannerhome",                       stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "banneraway",                       stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "diffuseshadow",                    stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "tournament",                       stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclockhalves",                     stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclocktimeanalog",                 stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclockminutesones",                stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclockminutestens",                stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclocksecondsones",                stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclocksecondstens",                stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclockscorehomeones",              stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclockscorehometens",              stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclockscoreawayones",              stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "sclockscoreawaytens",              stadiumAsset, priority)
	gr:AddAsset(stadium, lod, "diffusewet",                       stadiumAsset, priority)

	priority = 0 -- lower priority for the rest of assets
	
	-- Stadium Banners with dynamic distribution  (Not used on Fifa)
    --local bannermat
	--for banneridx=0, maxbanners-1 do 
	--	bannermat = string.format( "banner%sambient", banneridx )
	--	gr:AddAsset(stadium, lod, bannermat,                      stadiumAsset, priority)
	--end
	
	
	-- Additional assets to load
	gr:AddAsset(stadium, lod, "mow", "${GetDynamicStadiumPitch(?," .. pitchMovType .. ")}", priority)
	gr:AddAsset(stadium, lod, "cmn", "${GetDynamicStadiumPitch(?," .. pitchCommonType .. ")}", priority)
	gr:AddAsset(stadium, lod, "col", "${GetDynamicStadiumPitch(?," .. pitchColorType .. ")}", priority)
	gr:AddAsset(stadium, lod, "globaltex", "data/sceneassets/globaltex/globaltex_0.rx3", priority)
	gr:AddAsset(stadium, lod, "wear", "${GetDynamicStadiumPitch(?," .. pitchWearType .. ")}", priority)
	--TODO direct it into host city texture
	gr:AddAsset(stadium, lod, "adboardsingletex", "${GetDynamicAdboardsTexture(?)}", priority)
	gr:AddAssetEx(stadium, lod, "extracttexture ${GetCrestTexName(?)}", "homecresttex", "${GetHomeKitAssetSrc(?)}")
	gr:AddAsset(stadium, lod, "homebannertex", "data/sceneassets/banner/banner_${db.stadium[?].homeTeamAssetId}.rx3;data/sceneassets/banner/banner_0.rx3", priority)
	gr:AddAsset(stadium, lod, "awaybannertex", "data/sceneassets/banner/banner_${db.stadium[?].awayBannerId}.rx3;data/sceneassets/banner/banner_0.rx3", priority)
	gr:AddAsset(stadium, lod, "genericadtex", "data/sceneassets/genericad/genericad_${db.stadium[?].adboardID}.rx3;data/sceneassets/genericad/genericad_0.rx3", priority)
	-- gr:AddAsset(stadium, lod, "skytexture", "data/sceneassets/sky/sky_${db.stadium[?].skyCategoryId}_${db.stadium[?].skyAssetId}.rx3", priority)
	gr:AddAsset(stadium, lod, "skytexture", "${GetDynamicSkyTexture(?)}", priority)
	gr:AddAsset(stadium, lod, "weathertex", "data/sceneassets/weather/weather_${db.stadium[?].weather}.rx3", priority)
	gr:AddAsset(stadium, lod, "dressingtex", "data/sceneassets/tournament/tournament_${db.stadium[?].dressingAssetID}_0.rx3", priority)

	-- Now generate custom materials (these should be named after the shader they are to replace)
	
	part = "pitch"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "pitch_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "noiseTexture", "cmn", "multifreq_noise")
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "col", "grass_color")
	gr:SetTexture(stadium, lod, part, "textures", "normalMap", "mow", "grass_normal")
	gr:SetTexture(stadium, lod, part, "textures", "alphamask", "wear", "grass_wear")
	
	if ( enableVariablePitchSize == 0 )  then
		gr:SetTexture(stadium, lod, part, "textures", "pitchLinesMap", "cmn", "grass_pitchlines")
	else
		gr:SetTextureFromRuntime(stadium, lod, part, "textures", "pitchLinesMap", "grass_pitchlines[${?}]")
	end
	
	part = "pitchnoline"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "pitchnoline_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "noiseTexture", "cmn", "multifreq_noise")
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "col", "grass_color")

	-- Render to texture jumbotron
	part = "jumbotron"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "jumbotron_mtl", part)
	gr:SetTextureFromRuntime(stadium, lod, part, "textures", "jumbotronMap", "jumbotron")
	gr:SetTexture(stadium, lod, part, "textures", "LEDTexture", "globaltex", "led")
	
	part = "adboard"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "adboard_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "adboardsingletex", "adboard")
	
	part = "adboardscrolling"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "adboardscrolling_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "adboardsingletex", "adboard")

	part = "adboarddigital"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "adboarddigital_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "adboardsingletex", "adboard")
	gr:SetTexture(stadium, lod, part, "textures", "incandescenceMap", "globaltex", "digitalgrid")	

	part = "adboarddigitalglow"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "adboarddigitalglow_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "adboardsingletex", "adboard")

	-- The home team crest in the stadium
	part = "crest"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "homecrest_mtl", part)
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "homecresttex", "${GetCrestTexName(?)}")
	
	-- Stadium Banners
	part = "bannerhome"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "bannerhome_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "homebannertex", "banner_")
	gr:SetConstantARGB(stadium, lod, part, "global", "customColorPri", "${db.stadium[?].homeBannerPrimaryColour}")
	gr:SetConstantARGB(stadium, lod, part, "global", "customColorSec", "${db.stadium[?].homeBannerSecondaryColour}")
	
	part = "banneraway"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "banneraway_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "awaybannertex", "banner_")
	gr:SetConstantARGB(stadium, lod, part, "global", "customColorPri", "${db.stadium[?].awayBannerPrimaryColour}")
	gr:SetConstantARGB(stadium, lod, part, "global", "customColorSec", "${db.stadium[?].awayBannerSecondaryColour}")

    ------------------------------------------------------------------------------------------------------
	-- Stadium Banners with dynamic distribution (Not used on Fifa)
	--local texname
	--for banneridx=0, maxbanners-1 do 
	--	part = string.format( "banner%sambient", banneridx )
	--	texname = string.format( "banner%s", banneridx )
	--	gr:CreateMaterial(stadium, lod, part, "env_Diff.fx")
	--	gr:SetTextureFromRuntime(stadium, lod, part, "textures", "diffuseTexture", texname)
	--end
    ------------------------------------------------------------------------------------------------------
	
	-- Stadium Dressing
	part = "tournament"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "tournament_mtl", part)
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "dressingtex", "tournament")
	
	-- Team colours
	part = "homeprimary"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "homeprimary_mtl", part )
	gr:SetConstantARGB(stadium, lod, part, "global", "envColour", "${db.stadium[?].homePrimaryColour}")
	
	part = "homesecondary"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "homesecondary_mtl", part )
	gr:SetConstantARGB(stadium, lod, part, "global", "envColour", "${db.stadium[?].homeSecondaryColour}")
	
	-- Generic adboards
	part = "genericad"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "genericad_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "genericadtex", "genericad")
	
	-- Flatshadow enabled geometry
	part = "diffuseshadow"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "diffuseshadow_mtl", part )

	-- Dynamic Scoreclock
	part = "sclocktimeanalog"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "sctimeanalog_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_analog")
	
	part = "sclockhalves"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "schalvesnalog_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
	part = "sclockminutesones"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "scminutesones_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
	part = "sclockminutestens"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "scminutestens_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
	part = "sclocksecondsones"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "scsecondsones_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
	part = "sclocksecondstens"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "scsecondstens_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
	part = "sclockscorehomeones"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "scscorehomeones_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
	part = "sclockscorehometens"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "scscorehometens_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
	part = "sclockscoreawayones"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "scscoreawayones_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
	part = "sclockscoreawaytens"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "scscoreawaytens_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "globaltex", "sclock_digits")
	
-- Weather 
	part = "diffusewet"
	gr:CreateMaterialFromAttribulator(stadium, lod, part, "diffusewet_mtl", part )
	gr:SetTexture(stadium, lod, part, "textures", "diffuseTexture", "weathertex", "weather_cm")
	gr:SetTexture(stadium, lod, part, "textures", "coeffMap", "weathertex", "weather_coeff")
	gr:SetTexture(stadium, lod, part, "textures", "normalMap", "weathertex", "weather_nm")
	
end


