local L1_264
function L1_264(A0_265)
  local L1_266
  L1_266 = gRenderables
  L1_266:AddAsset(A0_265, 0, "shader", "data/fifarna/shader.big")
  L1_266:AddAsset(A0_265, 0, "playershadow", "data/sceneassets/body/playershadow_4_1_0.rx3")
  L1_266:CreateMaterial(A0_265, 0, "playershadow", "missingShader.fx")
  L1_266:AddAsset(A0_265, 1, "shader", "data/fifarna/shader.big")
  L1_266:AddAsset(A0_265, 1, "crowd_shadow", "data/sceneassets/crowd/crowd_shadow_0.rx3")
  L1_266:CreateMaterial(A0_265, 1, "crowd_shadow", "missingShader.fx")
end
FlatshadowAssetBind = L1_264
