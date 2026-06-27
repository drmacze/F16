-- MOD Low Player Shadow By Ma'ruf ID YouTube --

-------------------------------------------------------
-- MOD Keren dari YouTube Ma'ruf ID --
-------------------------------------------------------

local InitializeSettings = function()

	local as = gSportsRNA
	local settingTable = as:GetTable("Settings")

	local levelOfDetail = as:GetString(settingTable, "LevelOfDetail")
	
	as:SetGlobalInt("USE_BLOB_SHADOWS", 1)
as:SetGlobalInt("AI_SETTING_DRAWMODE", 3)
end

InitializeSettings()

InitializeSettings = nil