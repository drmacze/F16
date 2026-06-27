
local TableUtil = (...)
local BND_TOGGLE_FORMATION = "bnd_toggle_formation"
local ACT_TOGGLE_FORMATION = "act_toggle_formation"
local BND_FORMATION_LIST = "bnd_formation_list"
local BND_FORMATION = "bnd_formation"
local FormationModel = {}
FormationModel.PLAYER_POSITIONS = {
  GK = 0,
  SW = 1,
  RWB = 2,
  RB = 3,
  RCB = 4,
  CB = 5,
  LCB = 6,
  LB = 7,
  LWB = 8,
  RDM = 9,
  CDM = 10,
  LDM = 11,
  RM = 12,
  RCM = 13,
  CM = 14,
  LCM = 15,
  LM = 16,
  RAM = 17,
  CAM = 18,
  LAM = 19,
  RF = 20,
  CF = 21,
  LF = 22,
  RW = 23,
  RS = 24,
  ST = 25,
  LS = 26,
  LW = 27
}
function FormationModel:new(init)
  print("FormationModel:new()")
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SquadManagementService = o.api("SquadMgtService"),
    FUTSquadManagementService = o.api("FUTSquadManagementService"),
    TacticsService = o.api("TacticsService")
  }
  o.formationNamesList = {}
  o.formationList = o:getFormationList()
  o.currentFormationID = o.services.TacticsService.GetFormation(0, o.teamID)
  o.defaultFormationIndex = o:getFormationIndexByID(o.currentFormationID)
  o.currentFormation = o:getCurrentFormationByID(o.currentFormationID)
  o.im.RegisterDataAction(BND_TOGGLE_FORMATION, ACT_TOGGLE_FORMATION, function(bindingName, actionName, formationIndex)
    o.currentFormationID = o.formationList[formationIndex + 1].id
    o.currentFormation = o:getCurrentFormationByID(o.currentFormationID)
    o:_publishFormation()
  end
  )
  o.im.Subscribe(BND_FORMATION_LIST, function()
    o:_publishFormationList()
  end
  )
  o.im.Subscribe(BND_FORMATION, function()
    o:_publishFormation()
  end
  )
  return o
end

function FormationModel:getFormationList()
  local formationList = {}
  local formationIDs = self.services.SquadManagementService.GetAvailableFormationIDs(false)
  local formationNames = self.services.TacticsService.GetAllFormationNames(false)
  local formationCoords = self.services.TacticsService.GetAllFormationCoords()
  local formationPositions = self:getFormationPositions()
  do
    do
      for _FORV_9_ = 1, #formationIDs do
        formationList[_FORV_9_] = {}
        formationList[_FORV_9_].id = formationIDs[_FORV_9_]
        formationList[_FORV_9_].name = formationNames[_FORV_9_].name
        formationList[_FORV_9_].coords = formationCoords[_FORV_9_]
        formationList[_FORV_9_].positions = formationPositions[_FORV_9_]
        self.formationNamesList[_FORV_9_] = {
          text = formationList[_FORV_9_].name
        }
        print("FormationModel::getFormationList()index=" .. _FORV_9_ .. " ID=" .. formationIDs[_FORV_9_] .. " NAME=" .. formationNames[_FORV_9_].name)
      end
    end
  end
  return formationList
end

function FormationModel:getFormationPositions()
  local STRING_GK = ("")
  local STRING_RCB = ("")
  local STRING_RB = ("")
  local STRING_RWB = ("")
  local STRING_CB = ("")
  local STRING_LCB = ("")
  local STRING_RM = ("")
  local STRING_RDM = ("")
  local STRING_LB = ("")
  local STRING_RCM = ("")
  local STRING_LDM = ("")
  local STRING_CDM = ("")
  local STRING_LCM = ("")
  local STRING_LM = ("")
  local STRING_CAM = ("")
  local STRING_RS = ("")
  local STRING_LS = ("")
  local STRING_RF = ("")
  local STRING_LF = ("")
  local STRING_ST = ("")
  local STRING_RW = ("")
  local STRING_LW = ("")
  local STRING_RAM = ("")
  local STRING_LAM = ("")
  local STRING_CM = ("")
  local STRING_LWB = ("")
  local STRING_CF = ("")
  local realFormationPositions = {
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 205,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = 44,
        yPos = 83
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -234,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RM,
        name = STRING_RM,
        xPos = 283,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 123,
        yPos = -25
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -158,
        yPos = -25
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LM,
        name = STRING_LM,
        xPos = -310,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CAM,
        name = STRING_CAM,
        xPos = -17,
        yPos = -168
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 148,
        yPos = -130
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LS,
        name = STRING_LS,
        xPos = -180,
        yPos = -130
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 205,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = 44,
        yPos = 83
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -234,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RM,
        name = STRING_RM,
        xPos = 283,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 123,
        yPos = -25
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -158,
        yPos = -25
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LM,
        name = STRING_LM,
        xPos = -310,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RF,
        name = STRING_RF,
        xPos = 152,
        yPos = -130
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LF,
        name = STRING_LF,
        xPos = -180,
        yPos = -130
      },
      {
        id = FormationModel.PLAYER_POSITIONS.ST,
        name = STRING_ST,
        xPos = 20,
        yPos = -105
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 205,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = 44,
        yPos = 83
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -234,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RM,
        name = STRING_RM,
        xPos = 283,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 123,
        yPos = -25
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -158,
        yPos = -25
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LM,
        name = STRING_LM,
        xPos = -310,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RW,
        name = STRING_RW,
        xPos = 202,
        yPos = -132
      },
      {
        id = FormationModel.PLAYER_POSITIONS.ST,
        name = STRING_ST,
        xPos = 42,
        yPos = -136
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_LW,
        xPos = -232,
        yPos = -132
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 212,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = 44,
        yPos = 83
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -237,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RDM,
        name = STRING_RM,
        xPos = 297,
        yPos = -45
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LDM,
        name = STRING_LM,
        xPos = -321,
        yPos = -45
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RM,
        name = STRING_RCM,
        xPos = 126,
        yPos = -14
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LM,
        name = STRING_LCM,
        xPos = -155,
        yPos = -14
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CAM,
        name = STRING_CAM,
        xPos = -14,
        yPos = -140
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 136,
        yPos = -132
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LS,
        name = STRING_LS,
        xPos = -180,
        yPos = -132
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 255,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 138,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -168,
        yPos = 90
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CDM,
        name = STRING_CDM,
        xPos = 42,
        yPos = 19
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RM,
        name = STRING_RM,
        xPos = 188,
        yPos = -54
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LM,
        name = STRING_LM,
        xPos = -218,
        yPos = -54
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CAM,
        name = STRING_CAM,
        xPos = -14,
        yPos = -140
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 138,
        yPos = -141
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LS,
        name = STRING_LS,
        xPos = -180,
        yPos = -141
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 255,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 138,
        yPos = 128
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -168,
        yPos = 128
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RDM,
        name = STRING_RDM,
        xPos = 136,
        yPos = 34
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LDM,
        name = STRING_LDM,
        xPos = -166,
        yPos = 34
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RAM,
        name = STRING_RAM,
        xPos = 225,
        yPos = -60
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LAM,
        name = STRING_LAM,
        xPos = -257,
        yPos = -60
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CAM,
        name = STRING_CAM,
        xPos = -17,
        yPos = 38
      },
      {
        id = FormationModel.PLAYER_POSITIONS.ST,
        name = STRING_ST,
        xPos = 42,
        yPos = -130
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 255,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 138,
        yPos = 118
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -170,
        yPos = 118
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RDM,
        name = STRING_RDM,
        xPos = 108,
        yPos = 24
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LDM,
        name = STRING_LDM,
        xPos = -138,
        yPos = 24
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RAM,
        name = STRING_RAM,
        xPos = 209,
        yPos = -71
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LAM,
        name = STRING_LAM,
        xPos = -243,
        yPos = -71
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 100,
        yPos = -142
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LS,
        name = STRING_LS,
        xPos = -138,
        yPos = -142
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 255,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 138,
        yPos = 118
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -170,
        yPos = 118
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 178,
        yPos = -22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_CM,
        xPos = 43,
        yPos = 20
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -209,
        yPos = -22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CAM,
        name = STRING_CAM,
        xPos = -17,
        yPos = -167
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 149,
        yPos = -131
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LS,
        name = STRING_LS,
        xPos = -183,
        yPos = -131
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 255,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 138,
        yPos = 118
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -170,
        yPos = 118
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 178,
        yPos = -22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_CM,
        xPos = 43,
        yPos = 20
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -209,
        yPos = -22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RF,
        name = STRING_RF,
        xPos = 152,
        yPos = -131
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LF,
        name = STRING_LF,
        xPos = -180,
        yPos = -131
      },
      {
        id = FormationModel.PLAYER_POSITIONS.ST,
        name = STRING_ST,
        xPos = -20,
        yPos = -86
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 255,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 138,
        yPos = 110
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -170,
        yPos = 110
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 178,
        yPos = -22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_CM,
        xPos = 43,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -209,
        yPos = -22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RW,
        name = STRING_RW,
        xPos = 188,
        yPos = -93
      },
      {
        id = FormationModel.PLAYER_POSITIONS.ST,
        name = STRING_ST,
        xPos = 42,
        yPos = -130
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_LW,
        xPos = -215,
        yPos = -93
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 248,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 138,
        yPos = 140
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -170,
        yPos = 140
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RM,
        name = STRING_RM,
        xPos = 248,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 117,
        yPos = -69
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -144,
        yPos = -69
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LM,
        name = STRING_LM,
        xPos = -267,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CF,
        name = STRING_CF,
        xPos = -10,
        yPos = 22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.ST,
        name = STRING_ST,
        xPos = 42,
        yPos = -132
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 248,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 116,
        yPos = 140
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -150,
        yPos = 140
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RM,
        name = STRING_RM,
        xPos = 248,
        yPos = 4
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 116,
        yPos = -94
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -150,
        yPos = -94
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LM,
        name = STRING_LM,
        xPos = -300,
        yPos = 4
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 100,
        yPos = -140
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LS,
        name = STRING_LS,
        xPos = -127,
        yPos = -140
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RB,
        name = STRING_RB,
        xPos = 248,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 116,
        yPos = 142
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -150,
        yPos = 142
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LB,
        name = STRING_LB,
        xPos = -300,
        yPos = 63
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RM,
        name = STRING_RM,
        xPos = 248,
        yPos = -4
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_CM,
        xPos = -13,
        yPos = 65
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LM,
        name = STRING_LM,
        xPos = -300,
        yPos = -4
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RAM,
        name = STRING_RAM,
        xPos = 116,
        yPos = -114
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LAM,
        name = STRING_LAM,
        xPos = -150,
        yPos = -114
      },
      {
        id = FormationModel.PLAYER_POSITIONS.ST,
        name = STRING_ST,
        xPos = 42,
        yPos = -140
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RWB,
        xPos = 308,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 195,
        yPos = 105
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = -10,
        yPos = -20
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -226,
        yPos = 105
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LWB,
        xPos = -340,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 131,
        yPos = -26
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -158,
        yPos = -26
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CAM,
        name = STRING_CAM,
        xPos = -17,
        yPos = -167
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 146,
        yPos = -126
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LS,
        name = STRING_LS,
        xPos = -170,
        yPos = -126
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RWB,
        xPos = 308,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 195,
        yPos = 105
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = -10,
        yPos = -20
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -226,
        yPos = 105
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LWB,
        xPos = -340,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 131,
        yPos = -41
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -158,
        yPos = -41
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RW,
        name = STRING_RW,
        xPos = 131,
        yPos = -135
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_LW,
        xPos = -151,
        yPos = -135
      },
      {
        id = FormationModel.PLAYER_POSITIONS.ST,
        name = STRING_ST,
        xPos = -20,
        yPos = -85
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RWB,
        xPos = 279,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 150,
        yPos = 110
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = 43,
        yPos = 52
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -180,
        yPos = 110
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LWB,
        xPos = -303,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RCM,
        xPos = 177,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_CM,
        xPos = 42,
        yPos = -28
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LCM,
        xPos = -202,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 109,
        yPos = -143
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_LS,
        xPos = -138,
        yPos = -143
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RWB,
        xPos = 279,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_LCB,
        xPos = 155,
        yPos = 113
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = 43,
        yPos = 52
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_RCB,
        xPos = -185,
        yPos = 113
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LWB,
        xPos = -303,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RM,
        xPos = 175,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_RCM,
        xPos = 10,
        yPos = -28
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LM,
        xPos = -202,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_LCM,
        xPos = -45,
        yPos = -28
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_ST,
        xPos = 42,
        yPos = -140
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RB,
        xPos = 255,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 140,
        yPos = 113
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CDM,
        xPos = 43,
        yPos = 0
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -165,
        yPos = 113
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LB,
        xPos = -290,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RM,
        xPos = 250,
        yPos = -22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_RW,
        xPos = 175,
        yPos = -150
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LM,
        xPos = -300,
        yPos = -22
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_ST,
        xPos = 50,
        yPos = -150
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_LW,
        xPos = -200,
        yPos = -150
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RB,
        xPos = 260,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 140,
        yPos = 113
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CDM,
        xPos = 43,
        yPos = 25
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -165,
        yPos = 113
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LB,
        xPos = -290,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RM,
        xPos = 185,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_CM,
        xPos = 42,
        yPos = -28
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LM,
        xPos = -210,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 115,
        yPos = -143
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_LS,
        xPos = -145,
        yPos = -143
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RCB,
        xPos = 215,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCM,
        xPos = 170,
        yPos = -28
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = 43,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCM,
        xPos = -203,
        yPos = -28
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LCB,
        xPos = -240,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RM,
        xPos = 300,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_CM,
        xPos = 42,
        yPos = -28
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LM,
        xPos = -315,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_CF,
        xPos = 50,
        yPos = -125
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_ST,
        xPos = 50,
        yPos = -235
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RCB,
        xPos = 200,
        yPos = 110
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCM,
        xPos = 145,
        yPos = -30
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_CB,
        xPos = 43,
        yPos = 55
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCM,
        xPos = -165,
        yPos = -30
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LCB,
        xPos = -220,
        yPos = 110
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RM,
        xPos = 265,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_CDM,
        xPos = 42,
        yPos = -15
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LM,
        xPos = -300,
        yPos = -62
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 95,
        yPos = -175
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_LS,
        xPos = -125,
        yPos = -175
      }
    },
    {
      {
        id = FormationModel.PLAYER_POSITIONS.GK,
        name = STRING_GK,
        xPos = 42,
        yPos = 190
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RWB,
        name = STRING_RWB,
        xPos = 265,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCB,
        name = STRING_RCB,
        xPos = 145,
        yPos = 113
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CB,
        name = STRING_LCM,
        xPos = -145,
        yPos = 10
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCB,
        name = STRING_LCB,
        xPos = -175,
        yPos = 113
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LWB,
        name = STRING_LWB,
        xPos = -295,
        yPos = 70
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RCM,
        name = STRING_RW,
        xPos = 195,
        yPos = -75
      },
      {
        id = FormationModel.PLAYER_POSITIONS.CM,
        name = STRING_RCM,
        xPos = 115,
        yPos = 10
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LCM,
        name = STRING_LW,
        xPos = -220,
        yPos = -75
      },
      {
        id = FormationModel.PLAYER_POSITIONS.RS,
        name = STRING_RS,
        xPos = 100,
        yPos = -143
      },
      {
        id = FormationModel.PLAYER_POSITIONS.LW,
        name = STRING_LS,
        xPos = -130,
        yPos = -143
      }
    }
  }
  return realFormationPositions
end

function FormationModel:getFormationIndexByID(formationID)
  do
    for _FORV_5_ = 1, #self.formationList do
      if self.formationList[_FORV_5_].id == formationID then
        return _FORV_5_ - 1
      end
    end
  end
end

function FormationModel:getCurrentFormationID()
  return self.currentFormationID
end

function FormationModel:getCurrentFormationByID(formationID)
  do
    for _FORV_5_ = 1, #self.formationList do
      if self.formationList[_FORV_5_].id == formationID then
        return self.formationList[_FORV_5_]
      end
    end
  end
end

function FormationModel:getCurrentFormation()
  return self.currentFormation
end

function FormationModel:getFormationByID(formationID)
  return self.formationList[self:getFormationIndexByID(formationID)]
end

function FormationModel:_publishFormationList()
  self.im.Publish(BND_FORMATION_LIST, {
    index = self.defaultFormationIndex,
    data = self.formationNamesList
  })
end

function FormationModel:_publishFormation()
  self.im.Publish(BND_FORMATION, self.currentFormation)
end

function FormationModel:finalize()
  self.im.UnregisterDataAction(BND_TOGGLE_FORMATION, ACT_TOGGLE_FORMATION)
  self.im.Unsubscribe(BND_FORMATION_LIST)
  self.im.Unsubscribe(BND_FORMATION)
end

return FormationModel
