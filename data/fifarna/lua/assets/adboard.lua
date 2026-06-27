local L0_1, L1_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = gSportsRNA
  L3_2 = L1_2
  L2_2 = L1_2.GetTable
  L4_2 = "wvAdboard"
  L5_2 = A0_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = db
  L3_2 = L3_2.adboard
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetInt
  L6_2 = L2_2
  L7_2 = "adboardID"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.adboardID = L4_2
  L3_2 = db
  L3_2 = L3_2.adboard
  L3_2 = L3_2[A0_2]
  L5_2 = L1_2
  L4_2 = L1_2.GetInt
  L6_2 = L2_2
  L7_2 = "groupID"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.groupID = L4_2
end
AdboardUpdate = L0_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = gRenderables
  L2_2 = 0
  L4_2 = L1_2
  L3_2 = L1_2.AddCallback
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "AdboardUpdate(?)"
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = L1_2
  L3_2 = L1_2.AddAsset
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "adboardtex"
  L8_2 = "data/sceneassets/adboard/adboard_${db.adboard[?].adboardID}_${db.adboard[?].groupID}.rx3"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
AdboardAssetBind = L0_1
