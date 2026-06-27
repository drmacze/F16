local L0_1, L1_1

function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = gSportsRNA
  L3_2 = L1_2

  L2_2 = L1_2.GetTable
  L4_2 = "wvGoalNet"
  L5_2 = A0_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)

  L8_2 = L1_2.GetTable
  L9_2 = "wvWipe"
  L8_2 = L8_2(L3_2, L9_2, A0_2)


  L3_2 = db
  L3_2 = L3_2.goalnet
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetInt
  L6_2 = L8_2
  L7_2 = "homeTeamAssetID"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.homeTeamAssetId = L4_2

  L3_2 = db
  L3_2 = L3_2.goalnet
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetInt
  L6_2 = L2_2
  L7_2 = "stadLightType"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.lightType = L4_2

  L3_2 = db
  L3_2 = L3_2.goalnet
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetInt
  L6_2 = L2_2
  L7_2 = "stadID"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.stadiumID = L4_2

  L3_2 = db
  L3_2 = L3_2.goalnet
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetString
  L6_2 = L2_2
  L7_2 = "stadNamePrefix"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.prefix = L4_2
  L3_2 = db
  L3_2 = L3_2.goalnet
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetInt
  L6_2 = L2_2
  L7_2 = "netTexture"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.netID = L4_2
  L3_2 = db
  L3_2 = L3_2.goalnet
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetInt
  L6_2 = L2_2
  L7_2 = "colorTexture"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.netColorID = L4_2
  L3_2 = db
  L3_2 = L3_2.goalnet
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetInt
  L6_2 = L2_2
  L7_2 = "goalType"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.goalType = L4_2
end
GoalNetUpdate = L0_1

function GetGoalNetModel(idx)
  return "data/sceneassets/goalnet/goalnet_0_${db.goalnet[idx].homeTeamAssetId}.rx3;data/sceneassets/goalnet/goalnet_${db.goalnet[?].netID}.rx3"
end

function GetGoalNetTextures(idx)
  return "data/sceneassets/goalnet/netcolor_0_${db.goalnet[idx].homeTeamAssetId}_textures.rx3;data/sceneassets/goalnet/netcolor_${db.goalnet[?].netColorID}_textures.rx3"
end

function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = gRenderables
  L2_2 = 0
  L4_2 = L1_2
  L3_2 = L1_2.AddCallback
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "GoalNetUpdate(?)"
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = L1_2
  L3_2 = L1_2.AddAsset
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "shader"
  L8_2 = "data/fifarna/shader.big"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L4_2 = L1_2
  L3_2 = L1_2.AddAsset
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "nettexture"
  L8_2 = "${GetGoalNetModel(?)}"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L4_2 = L1_2
  L3_2 = L1_2.AddAsset
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "colortexture"
  L8_2 = "${GetGoalNetTextures(?)}"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L4_2 = L1_2
  L3_2 = L1_2.AddAsset
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "stadium"
  L8_2 = "data/sceneassets/stadium/${db.goalnet[?].prefix}_${db.goalnet[?].stadiumID}.rx3"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L4_2 = L1_2
  L3_2 = L1_2.AddAsset
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "goalbase_textures"
  L8_2 = "data/sceneassets/goalnet/goalpost_${db.goalnet[?].goalType}_textures.rx3"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = "goalpost_static"
  L5_2 = L1_2
  L4_2 = L1_2.AddAsset
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = L3_2
  L9_2 = "data/sceneassets/goalnet/goalpost_${db.goalnet[?].goalType}.rx3"
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L5_2 = L1_2
  L4_2 = L1_2.CreateMaterialFromAttribulator
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = L3_2
  L9_2 = "goalbase_material"
  L10_2 = "goalbase"
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L5_2 = L1_2
  L4_2 = L1_2.SetSubMesh
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = L3_2
  L9_2 = "goalpost_static"
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L5_2 = L1_2
  L4_2 = L1_2.SetTexture
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = L3_2
  L9_2 = "textures"
  L10_2 = "diffuseTexture"
  L11_2 = "goalbase_textures"
  L12_2 = "goalpost_cm"
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L5_2 = L1_2
  L4_2 = L1_2.SetTextureFromRuntime
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = L3_2
  L9_2 = "textures"
  L10_2 = "coverageMap"
  L11_2 = "covmap_${db.goalnet[?].stadiumID}_${db.goalnet[?].lightType}"
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L4_2 = "goalpost_slide"
  L6_2 = L1_2
  L5_2 = L1_2.AddAsset
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = "data/sceneassets/goalnet/goalpost_${db.goalnet[?].goalType}.rx3"
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  L6_2 = L1_2
  L5_2 = L1_2.CreateMaterialFromAttribulator
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = "goalbase_material"
  L11_2 = "goalbase"
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = L1_2
  L5_2 = L1_2.SetSubMesh
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = "goalpost_slide"
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  L6_2 = L1_2
  L5_2 = L1_2.SetTexture
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = "textures"
  L11_2 = "diffuseTexture"
  L12_2 = "goalbase_textures"
  L13_2 = "goalpost_cm"
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L6_2 = L1_2
  L5_2 = L1_2.SetTextureFromRuntime
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = "textures"
  L11_2 = "coverageMap"
  L12_2 = "covmap_${db.goalnet[?].stadiumID}_${db.goalnet[?].lightType}"
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L5_2 = "goalpost_post"
  L7_2 = L1_2
  L6_2 = L1_2.AddAsset
  L8_2 = A0_2
  L9_2 = L2_2
  L10_2 = L5_2
  L11_2 = "data/sceneassets/goalnet/goalpost_${db.goalnet[?].goalType}.rx3"
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L7_2 = L1_2
  L6_2 = L1_2.CreateMaterialFromAttribulator
  L8_2 = A0_2
  L9_2 = L2_2
  L10_2 = L5_2
  L11_2 = "goalpost_material"
  L12_2 = "goalpost"
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = L1_2
  L6_2 = L1_2.SetSubMesh
  L8_2 = A0_2
  L9_2 = L2_2
  L10_2 = L5_2
  L11_2 = "goalpost_post"
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L7_2 = L1_2
  L6_2 = L1_2.SetTexture
  L8_2 = A0_2
  L9_2 = L2_2
  L10_2 = L5_2
  L11_2 = "textures"
  L12_2 = "diffuseTexture"
  L13_2 = "goalbase_textures"
  L14_2 = "goalpost_cm"
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L7_2 = L1_2
  L6_2 = L1_2.SetTextureFromRuntime
  L8_2 = A0_2
  L9_2 = L2_2
  L10_2 = L5_2
  L11_2 = "textures"
  L12_2 = "coverageMap"
  L13_2 = "covmap_${db.goalnet[?].stadiumID}_${db.goalnet[?].lightType}"
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L6_2 = "goalpost_netsupport"
  L8_2 = L1_2
  L7_2 = L1_2.AddAsset
  L9_2 = A0_2
  L10_2 = L2_2
  L11_2 = L6_2
  L12_2 = "data/sceneassets/goalnet/goalpost_${db.goalnet[?].goalType}.rx3"
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L8_2 = L1_2
  L7_2 = L1_2.CreateMaterialFromAttribulator
  L9_2 = A0_2
  L10_2 = L2_2
  L11_2 = L6_2
  L12_2 = "goalpost_material"
  L13_2 = "goalpost"
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L8_2 = L1_2
  L7_2 = L1_2.SetSubMesh
  L9_2 = A0_2
  L10_2 = L2_2
  L11_2 = L6_2
  L12_2 = "goalpost_netsupport"
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L8_2 = L1_2
  L7_2 = L1_2.SetTexture
  L9_2 = A0_2
  L10_2 = L2_2
  L11_2 = L6_2
  L12_2 = "textures"
  L13_2 = "diffuseTexture"
  L14_2 = "goalbase_textures"
  L15_2 = "goalpost_cm"
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L8_2 = L1_2
  L7_2 = L1_2.SetTextureFromRuntime
  L9_2 = A0_2
  L10_2 = L2_2
  L11_2 = L6_2
  L12_2 = "textures"
  L13_2 = "coverageMap"
  L14_2 = "covmap_${db.goalnet[?].stadiumID}_${db.goalnet[?].lightType}"
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  return A0_2
end
GoalNetAssetBind = L0_1
