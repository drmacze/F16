-- 自定义球员手套配饰
function assignGloveAccessoryID(idx, playeridx, playerid, gloveType)
	if (db.player[playeridx].playerassetid == playerid) then
		db.accessory[idx].isGlove = 1
		db.accessory[idx].gloveType = gloveType
		db.accessory[idx].model = 10000
		--db.accessory[idx].modelvar = 0
	
	end
end

function AccessoryUpdate(idx)
	local as = gSportsRNA
	local accessory = as:GetTable("wvAccessory", idx)
	
	local state = as:GetTable("wvState") -- to get the lighting and weather
	db.accessory[idx].stadiumLightID = as:GetInt(state, "wvAttribStadLightID")
	db.accessory[idx].stadiumID = as:GetInt(state, "wvAttribStadID")
	db.accessory[idx].envLighting = as:GetInt(state, "wvAttribEnvLighting")

	local playeridx = math.floor(idx/10)
	local player = as:GetTable("wvPlayer", playeridx)
	db.player[playeridx].playerassetid = as:GetInt(player, "playerassetid") 

    -- Calculation below is to minimize the amount of textures loaded for accessories. Forces the sharing of 1 colormap for left/right meshes.
    -- This is assuming all accessories that require left and right variations have model = even# for left, odd# for right
    -- AND
    -- all single-variation accessories have even# for model
    -- Ideal solution: retrieve modelvar from database so that we don't have to make assumptions here
    local modelNum = as:GetInt(accessory, "accessoryModel")
	db.accessory[idx].model = modelNum - math.abs(modelNum % 2)
	db.accessory[idx].modelvar = math.abs(modelNum % 2)
	db.accessory[idx].color = as:GetInt(accessory, "accessoryColor")
	db.accessory[idx].material = "accessory"
	db.accessory[idx].accessoryname = "accessory"
	db.accessory[idx].coloridx = 0
	db.accessory[idx].isgkglove = 0
	db.accessory[idx].isGlove = 0

	assignGloveAccessoryID(idx, playeridx, 209297, 0)
	assignGloveAccessoryID(idx, playeridx, 204485, 0)
	assignGloveAccessoryID(idx, playeridx, 213956, 0)
    assignGloveAccessoryID(idx, playeridx, 223689, 0)
    assignGloveAccessoryID(idx, playeridx, 201535, 0)
    assignGloveAccessoryID(idx, playeridx, 210257, 5)
    assignGloveAccessoryID(idx, playeridx, 233934, 72)
    assignGloveAccessoryID(idx, playeridx, 222464, 65)

    if ( db.accessory[idx].model == 10000 ) then
	    db.accessory[idx].model = 1
		--db.accessory[idx].model = 0
		db.accessory[idx].accessoryname = "gkglove"
		db.accessory[idx].material = "gkglove"
	-- special case for gkgloves
	elseif ( db.accessory[idx].model == 18 ) then
		db.accessory[idx].model = db.accessory[idx].color
		--db.accessory[idx].model = 0
		db.accessory[idx].accessoryname = "gkglove"
		db.accessory[idx].material = "gkglove"
		db.accessory[idx].isgkglove = 1
	elseif (db.accessory[idx].model > 27 and db.accessory[idx].model < 32) then
		-- referee cards are 28 and 30, just use diffuse.
		db.accessory[idx].material = "accessories_matte"
	elseif (db.accessory[idx].model > 4) then
		db.accessory[idx].coloridx = db.accessory[idx].color
		db.accessory[idx].color = 0  -- use 0 for runtime recolouring
		
	else
		-- referee watches, referee earpieces
		db.accessory[idx].material = "accessories_matte"
	end
	
	
end



---------------------------------------------------------------------------------------------------
-- Get accessory color to dispatch to shader 
function GetAccessoryColorARGB(idx)
	-- gamma'd list r*r g*g b*b
	accessoryColorList = { 0x00ffffff, 0x000a0a0a, 0x00000072, 0x00720000, 
						   0x00cece00, 0x00000900, 0x009b0900, 0x00090026, 
						   0x00060000, 0x00e112e1, 0x00130001, 0x000038e1, 
						   0x0000001f, 0x003f3f3f }

	local clr = accessoryColorList[db.accessory[idx].coloridx + 1] 
	
	if (clr == nil) then
		clr = 0x00ffffff
	end
	return clr
end

---------------------------------------------------------------------------------------------------
function GetAccessoryMesh(idx)
	local res = "data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_${db.accessory[?].model}_${db.accessory[?].modelvar}.rx3"
	if (db.accessory[idx].isgkglove == 1) then
		res = "data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_${db.accessory[?].model}.rx3;data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_1.rx3"
	end
	if (db.accessory[idx].isGlove == 1) then
		res = "data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_${db.accessory[?].model}.rx3;data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_1.rx3"
	end
	return res
end

---------------------------------------------------------------------------------------------------
function GetAccessoryTexture(idx)
	local res = "data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_${db.accessory[?].model}_${db.accessory[?].color}_textures.rx3"
	if (db.accessory[idx].isgkglove == 1) then
		res = "data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_${db.accessory[?].model}_textures.rx3;data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_1_textures.rx3"
	end
	if (db.accessory[idx].isGlove == 1) then
		res = "data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_${db.accessory[?].gloveType}_textures.rx3;data/sceneassets/${db.accessory[?].accessoryname}/${db.accessory[?].accessoryname}_0_textures.rx3"
	end
	return res
end

---------------------------------------------------------------------------------------------------
function AccessoryAssetBind(accessory)
	local gr = gRenderables
   	local lod = 0
	
	gr:AddCallback(accessory, lod, "AccessoryUpdate(?)")
	gr:AddAsset(accessory, lod, "shader", "data/fifarna/shader.big")
	gr:AddAsset(accessory, lod, "accessorymesh", "${GetAccessoryMesh(?)}")
	gr:AddAsset(accessory, lod, "accessorytex", "${GetAccessoryTexture(?)}" )
	gr:AddAsset(accessory, lod, "charcmn", "data/sceneassets/charactercmn/charactercmn_${db.accessory[?].envLighting}.rx3")	
	
	local part = "accessorymesh"
	gr:CreateMaterialFromAttribulator(accessory, lod, part, "accessory", "${db.accessory[?].material}" )
	gr:SetTexture(accessory, lod, part, "textures", "diffuseTexture", "accessorytex", "${db.accessory[?].accessoryname}_cm")
	gr:SetTexture(accessory, lod, part, "textures", "normalMap", "accessorytex", "${db.accessory[?].accessoryname}_nm")
	gr:SetTexture(accessory, lod, part, "textures", "coeffMap", "accessorytex", "${db.accessory[?].accessoryname}_coeff")
	gr:SetTexture(accessory, lod, part, "textures", "envDiffuseTexture", "charcmn", "envd_")
	gr:SetTexture(accessory, lod, part, "textures", "envSpecTexture", "charcmn", "envs_")
	gr:SetConstantARGB(accessory, lod, part, "global", "MaterialColour", "${GetAccessoryColorARGB(?)}")
	gr:SetTextureFromRuntime(accessory, lod, part, "textures", "coverageMap", "covmap_${db.accessory[?].stadiumID}_${db.accessory[?].stadiumLightID}")
	
	return accessory
end

