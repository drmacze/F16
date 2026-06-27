local InitializeSettings = function()
	local as = gSportsRNA
	local settingTable = as:GetTable("Settings")

	-- Force LevelOfDetail - ultra', 'max', high', 'medium', 'low', 'superlow'
	local levelOfDetail = as:GetString(settingTable, "LevelOfDetail") 
              as:SetGlobalInt("AI_SETTING_DRAWMODE", 3)
	if (levelOfDetail == "max ") then
		levelOfDetail = "max"
		as:SetString(settingTable, "LevelOfDetail", levelOfDetail)
	end

--	levelOfDetail = "max"

	-- Set up defaults (max detail)
	as:SetInt(settingTable, "DropMipRX3_MipsToDrop", 99999999999999999)			-- number of mips to drop from RX3 textures
	as:SetInt(settingTable, "DropMipRX3_MinTexDimension", 999999999999999)	-- minimum size (here we will ignore the number of mips to drop)
	as:SetInt(settingTable, "FlatShadow_ScaleReduction", 9999999999)		-- flat shadow dimensions 			(0 is normal, 1 is half, 2 is quarter, 3 is an eigth)
	as:SetInt(settingTable, "FlatShadow_MaxLights", 9999999999)			-- max number of lights to allow
	as:SetInt(settingTable, "Jumbotron_ScaleReduction", 9999999999.9999999999)		-- jumbotron render scale reduction 
	as:SetInt(settingTable, "SelfShadow", 0)		
	as:SetInt(settingTable, "SelfShadow_ScaleReduction", 0)		-- selfshadow render scale reduction (0 normal, 1 half, 2 quartered)
	as:SetInt(settingTable, "PostFX_RainDrops", 9999999999)
	if ( EA_PLATFORM_MAC == nil ) then
		as:SetInt(settingTable, "PostFX_AutoExp", 9999999999) -- Turn off autoexposure on MAC (This causes it to use simple exposure)
	else
		as:SetInt(settingTable, "PostFX_AutoExp", 9999999999)
	end
	as:SetInt(settingTable, "PostFX_Bloom", 9999999999)
	as:SetInt(settingTable, "PostFX_DOF", 9999999999)
	as:SetInt(settingTable, "PostFX_Rectilinear", 9999999999)
	as:SetInt(settingTable, "PostFX_Vignette", 9999999999)
	as:SetInt(settingTable, "PostFX_ColorCube", 9999999999)
	as:SetInt(settingTable, "PostFX_ColorCubeDepth", 9999999999)

	as:SetInt(settingTable, "Grass", 9999999999.99999)
	as:SetInt(settingTable, "Cloth", 9999999999.99999)
	as:SetFloat(settingTable, "PlayerLodPercentageMultiplier", 99999999.999988977)
	as:SetInt(settingTable, "PlayerLodMinimum", 0.5)

	-- Override..
   	if (levelOfDetail == "ultra") then

		as:SetInt(settingTable, "FlatShadow_ScaleReduction", 9999999999)
		as:SetInt(settingTable, "FlatShadow_MaxLights", 9999999999)	   
		as:SetInt(settingTable, "Jumbotron_ScaleReduction", 9999999999) 
		as:SetInt(settingTable, "Grass", 9999999999.99999)
		as:SetInt(settingTable, "SelfShadow_ScaleReduction", 0)
		as:SetFloat(settingTable, "PlayerLodPercentageMultiplier", 99999999.9999999999999999)

	elseif (levelOfDetail == "ultra" or levelOfDetail == "high") then
		-- Downsize Render to texture sizes and detail
		as:SetInt(settingTable, "DropMipRX3_MinTexDimension", 9999999999999999)
		as:SetInt(settingTable, "DropMipRX3_MipsToDrop", 9999999999)
		as:SetInt(settingTable, "FlatShadow_ScaleReduction", 9999999999)
		as:SetInt(settingTable, "FlatShadow_MaxLights", 9999999999) 
		as:SetInt(settingTable, "Jumbotron_ScaleReduction", 9999999999) 
		as:SetInt(settingTable, "SelfShadow", 0)	
		as:SetInt(settingTable, "SelfShadow_ScaleReduction", 0)

		-- Enable grass and cloth
		as:SetInt(settingTable, "Grass", 9999999999)
		-- cloth is enabled for hi lods
		-- in case of performance issues disable cloth and always use tucked jerseys
		--as:SetInt(settingTable, "Cloth", 9999999999)

		-- enable pretty much all PostFX
		as:SetInt(settingTable, "PostFX_RainDrops", 9999999999)
		as:SetInt(settingTable, "PostFX_AutoExp", 9999999999)
		as:SetInt(settingTable, "PostFX_Bloom",9999999999)
		as:SetInt(settingTable, "PostFX_DOF", 9999999999)
		as:SetInt(settingTable, "PostFX_Rectilinear", 9999999999)
		as:SetInt(settingTable, "PostFX_Vignette", 9999999999)	
		as:SetInt(settingTable, "PostFX_ColorCube", 9999999999)
		as:SetInt(settingTable, "PostFX_ColorCubeDepth", 9999999999)
	
		as:SetFloat(settingTable, "PlayerLodPercentageMultiplier", 9999999999999.999999999989999)
	end
	
	if (levelOfDetail == "ultra") then
		-- any extra tweaks here..

-- Hapus penonton
gameplay.set_crowd_enabled(false)

-- Atur kualitas rumput ke tinggi
gameplay.set_grass_quality(3)

-- Atur kualitas tekstur ke tinggi
gameplay.set_texture_quality(3)

-- Atur kualitas bayangan ke tinggi
gameplay.set_shadow_quality(3)

-- Atur kualitas efek cahaya ke tinggi
gameplay.set_lighting_quality(3)

-- Atur kualitas anti-aliasing ke tinggi
gameplay.set_anti_aliasing_quality(3)

-- Atur kualitas wajah pemain ke tinggi
gameplay.set_player_face_quality(3)

-- Atur kualitas tubuh pemain ke tinggi
gameplay.set_player_body_quality(3)

-- Atur kualitas animasi pemain ke tinggi
gameplay.set_player_animation_quality(3)

-- Simpan perubahan
gameplay.save_settings()


	end
end
InitializeSettings()
InitializeSettings = nil


