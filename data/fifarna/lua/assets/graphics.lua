local GraphicsUpdate = function()
	local as = gSportsRNA
	local settingTable = as:GetTable("Settings")

	local effectsQuality = as:GetString(settingTable, "TextureQuality")
                                                     as:GetString(settingTable, "EffectsQuality")

	-- Force TextureQuality - 'Quality.High'
              if (levelOfDetail == "" or levelOfDetail == "high") then

	if (textureQuality == "" or textureQuality == Quality.High) then
        textureQuality = "Quality.High"

	as:SetGlobalString(settingTable, "TextureQuality", textureQuality)
	end

    -- Set TextureQuality settings
    applyQualitySettings("TextureQuality", {    	
        [Quality.High]=[=[
	Texture.SkipMipmapCount 0
	TextureStreaming.PoolSize 1400000
	TextureStreaming.PoolHeadroomSize 24576
	TerrainStreaming.HeightfieldAtlasSampleCountXFactor 1
	TerrainStreaming.HeightfieldAtlasSampleCountYFactor 2
	TerrainStreaming.MaskAtlasSampleCountXFactor 1
	TerrainStreaming.MaskAtlasSampleCountYFactor 2
	TerrainStreaming.ColorAtlasSampleCountXFactor 1
	TerrainStreaming.ColorAtlasSampleCountYFactor 2
	VisualTerrain.TextureAtlasSampleCountXFactor 1
	VisualTerrain.TextureAtlasSampleCountYFactor 2
	VisualTerrain.TextureRenderJobCount 2
	VisualTerrain.TextureRenderJobsLaunchedPerFrameCountMax 2
	VisualTerrain.TextureSkipMipSpeed 30
	VisualTerrain.Decal3dFarDrawDistanceScaleFactor 1.7
		
	WorldMobileRender.SkyEnvmapResolution 512
	WorldMobileRender.LocalIBLResolution 256
	WorldMobileRender.LocalIBLShadowmapResolution 512

	ShaderSystem.ShaderQualityLevel QualityLevel_High

             OptionsGraphicsMaxfps 100

             BitmapFilterQuality QualityLevel High

	]=],
})

    -- Texture filtering Quality
    applyQualitySettings("TextureFiltering", {    
         [Quality.High]=[=[
	WorldMobileRender.CullScreenAreaScale 1.5
	Mesh.GlobalLodScale 1.5
	Mesh.ShadowDistanceScale 1.5
	Mesh.TessellationEnable 1
	Mesh.TessellationMaxFactor 7
	MeshStreaming.PoolSize 170000
		
	VegetationSystem.MaxActiveDistance 300
	VegetationSystem.MaxPreSimsPerJob 4
	VegetationSystem.SimulationMemKbClient 4096
		
	Render.EdgeModelViewDistance 100

	WaterInteract.WaterQualityLevel High
		
	Crowd.LodScale 3
	Grass.PatchWidthScale 1.5

	-- Increase Player LOD - 0 = same look as 1080p - 4 = per pixel equality to 1080p - 8 = LODs mostly 1. 12 = all characters at least LOD1, sometimes LOD 0
		FifaTransformSpaceSettings.PlayerLodPercentageScale 4

	ClothSystem.ClientClothForceSkinned false
	-- Only have cloth rend side run on max four job cores
	ClothSystem.ClientClothWorldMobileThreadCount 8

	StrandHairRender.RasterizerProcessorCount 48
	Render.DynamicResolutionMinHeight 1080
	Render.DynamicResolutionMinWidth 1920

	FifaRendering.MeshComputeManagerSlotCount 35

	]=],
})

              if levelOfDetail == "" or levelOfDetail == "high" and 
   (settings["EffectsQuality"] == "" or settings["EffectsQuality"] == Quality.High or settings["EffectsQuality"] == Quality.Normal) then
      settings["EffectsQuality"] = Quality.High
              end

    -- Effects Quality
    applyQualitySettings("EffectsQuality", {    
         [Quality.High]=[=[
	DynamicTextureAtlas.EmitterBaseWidth 8192
	DynamicTextureAtlas.EmitterBaseHeight 8192
	DynamicTextureAtlas.EmitterBaseMipmapCount 6
	DynamicTextureAtlas.EmitterBaseSkipmipsCount 0
	DynamicTextureAtlas.EmitterNormalWidth 2048
	DynamicTextureAtlas.EmitterNormalHeight 2048
	DynamicTextureAtlas.EmitterNormalMipmapCount 4
	DynamicTextureAtlas.EmitterNormalSkipmipsCount 0
	EmitterSystem.QuadHalfResEnable 1
	EmitterSystem.QuadMaxCount 12000
	EmitterSystem.MeshMaxCount 4000
	EmitterSystem.CollisionRayCastMaxCount 150
	EmitterSystem.EmitterQualityLevel High
	EffectSystem.EffectQualityLevel High
	WorldMobileRender.HalfResLensFlaresEnable 1
		
	EARain.DensityLodScale 1

	]=],
})

-- PostProcess Quality
    ApplyQualitySettings("PostProcessQuality", {    
        [Quality.High] = [=[    
	PostProcess.SpriteDofEnable 0
	PostProcess.DofMethod DofMethod_Sprite
	PostProcess.BlurMethod BlurMethod_Gaussian
	PostProcess.BlurPyramidQuarterResEnable 0
	WorldMobileRender.DistortionEnable 0
	WorldMobileRender.MotionBlurEnable 0
	WorldMobileRender.MotionBlurMaxSampleCount 16
	WorldMobileRender.FastHdrEnable 1
	Render.RenderScaleResampleMode ScaleResampleMode_BicubicSharp
	WorldMobileRender.TranslucencyAutoThicknessEnable 1

	]=],
})

------ Terrain Quality
applyQualitySettings("TerrainQuality", {
	[Quality.High]=[=[
	VisualTerrain.TessellatedTriWidth 12
	VisualTerrain.LodScale 1.1
	VisualTerrain.TerrainShadowsQualityLevel QualityLevel_High
	VisualTerrain.DetailDisplacementQualityLevel QualityLevel_High
	]=],
})

------ Terrain Decoration Quality
 applyQualitySettings("UndergrowthQuality", {    
        [Quality.High] = [=[    
	VisualTerrain.MeshScatteringBuildChannelCount 6
	VisualTerrain.MeshScatteringBuildChannelsLaunchedPerFrameCountMax 4
	VisualTerrain.MeshScatteringDistanceScaleFactor 1.5
	VisualTerrain.MeshScatteringDensityScaleFactor 1
	VisualTerrain.MeshScatteringInstancesPerCellMax 4096
	VisualTerrain.MeshScatteringQualityLevel High
	]=],
})

------ Light quality
    applyQualitySettings("LightingQuality", {    
        [Quality.High] = [=[    
	WorldMobileRender.SunShadowmapLevel QualityLevel_High
	WorldMobileRender.ShadowmapViewDistance 200
	WorldMobileRender.ShadowmapResolution 2048
	WorldMobileRender.GameplayShadowmapResolution 2048
	WorldMobileRender.ShadowmapSliceCount 3
	WorldMobileRender.ShadowmapQuality 1
	WorldMobileRender.TransparencyShadowmapsEnable 1
	WorldMobileRender.PunctualLightShadowLevel QualityLevel_High
	WorldMobileRender.AreaLightShadowLevel QualityLevel_High
	WorldMobileRender.LocalLightCastVolumetricLevel QualityLevel_High
	WorldMobileRender.PunctualLightCastVolumetricShadowmapEnableLevel QualityLevel_High;
	WorldMobileRender.AreaLightCastVolumetricShadowmapEnableLevel QualityLevel_High;
	Mesh.CastShadowQualityLevel High
	Mesh.CastDynamicReflectionQualityLevel High
	Mesh.CastStaticReflectionQualityLevel High
	Mesh.CastPlanarReflectionQualityLevel High
	VegetationSystem.UseShadowLodOffset 0
	WorldMobileRender.SubSurfaceScatteringEnable 1
	WorldMobileRender.LocalLightTranslucencyEnable 1
	WorldMobileRender.VolumetricCloudsQuality QualityLevel_High
	WorldMobileRender.VolumetricCloudsRenderTargetResolutionDivider 3
	WorldMobileRender.VolumetricCloudsReflectionRenderTargetResolutionDivider 3
	Enlighten.CubeMapsEnable 1
	]=],
})

-- Antialiasing

applyQualitySettings("AntiAliasingDeferred", {

	[AntiAliasingDeferred.On]=[=[

SMAAMaxSearchStep 16
	]=],
	[AntiAliasingDeferred.MSAA4X]=[=[
		WorldMobileRender.MultisampleCount 4
	              SMAAThreshold 1.10
                                                        SMAAMaxSearchStepsDiag 6
                            SMAACornerRounding 0
                            ColorEdgeDetection 1
	]=],
})

-- | FXAA
-- Antialiasing Post

applyQualitySettings("AntiAliasingPost", {
	[AntiAliasingPost.High]=[=[
		WorldMobileRender.PostProcessAntialiasingMode PostProcessAAMode_None
	]=],
})

------ Ambient Occlusion
applyQualitySettings("AmbientOcclusion", {

	[AmbientOcclusion.On]=[=[
		PostProcess.DynamicAOEnable 1
	]=],
	[AmbientOcclusion.SSAO]=[=[
		PostProcess.DynamicAOEnable 1
		PostProcess.DynamicAOMethod DynamicAOMethod_SSAO
	]=],
	[AmbientOcclusion.HBAO]=[=[
		PostProcess.DynamicAOEnable 1
		PostProcess.DynamicAOMethod DynamicAOMethod_HBAO
		PostProcess.DynamicAOHorizonBased true

		PostProcess.DynamicAOTemporalFilterEnable 0
		PostProcess.DynamicAOSampleDirCount 4
		PostProcess.DynamicAOSampleStepCount 2
	]=],
	[AmbientOcclusion.HBAOFull]=[=[
		PostProcess.DynamicAOEnable 1
		PostProcess.DynamicAOMethod DynamicAOMethod_HBAO

		PostProcess.DynamicAOHorizonBased true

		PostProcess.DynamicAOTemporalFilterEnable 1
		PostProcess.DynamicAOSampleDirCount 8
		PostProcess.DynamicAOSampleStepCount 5
	]=],
})

-- resolution Override

applyQualitySettings("OverrideNISResolution", {
	[OverrideNISResolution.On]=[=[
		RenderDevice.OverrideNISResolution 1
})

------- Motion Blur
WorldMobileRender = WorldMobileRender or {}
-- 'MotionBlur' (a nil value)"
WorldMobileRender.MotionBlurScale = settings["MotionBlur"]

------- Weapon DOF
PostProcess.IronsightsDofEnable = settings["WeaponDOF"]

------- Screen resolution
RenderDevice = RenderDevice or {}
RenderDevice.FullscreenWidth = settings["ResolutionWidth"]
RenderDevice.FullscreenHeight = settings["ResolutionHeight"]

-- resolution detection
RenderDevice.AutodetectedResolution = settings["AutodetectedResolution"]
RenderDevice.FullscreenRefreshRate = settings["FullscreenRefreshRate"]
RenderDevice.Fullscreen = settings["FullscreenEnabled"]
RenderDevice.FullscreenOutputIndex = settings["FullscreenScreen"]
RenderDevice.VSyncEnable = settings["VSyncEnabled"]

--  enable vsync
Render.VSyncEnable = settings["VSyncEnabled"]

-- enable fifasetup.ini to vsync interval
RenderDevice.PresentInterval = settings["PresentInterval"]

-- interval settings dynamic
RenderDevice.PresentIntervalSettings = settings["PresentInterval"]

-- Resolution scale
Render.ResolutionScale = (settings["ResolutionScale"] 2.0 or "high")

-- Brightness
PostProcess.UIBrightnessNorm = (settings["Brightness"] or 260.0)

-- Contrast
PostProcess.UIContrastNorm = (settings["Contrast"] or 331.0)

-- settings and resolution detection
WorldMobileRender.HairStrandsEnabled = settings["StrandBasedHair"]
Render.DynamicResolutionScaleFeatureEnable = settings["DynamicResolution"]

FifaWorldMobileRender = FifaWorldMobileRender or {}
FifaWorldMobileRender.UseGoalNets3d = settings["UseGoalNets3d"]

--Scripts/GameView.cfg# Enable variable frame rate for faster.
Client.VsyncEnable true

-- GameView runs in (true) fullscreen mode. So need to do costly gather device infos etc.
RenderDevice.FullscreenModeEnable true

-- This is the "Game view" mode so want to be able to render using the debug renderer from the Editor.
Render.DebugRenderServiceEnable true
	end
end
