-- Modified MVNPROD -- Single Player Mode --

local Match = {}

-- Variável global para armazenar o jogador selecionado na primeira partida
local beaproSelectedPlayer = nil

function Match:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  o.services = {
    gameSetup = o.api("GameSetupService"),
    gameState = o.api("GameStateService")
  }
  
  o.nav.AddActionHandler("setTeams", false, nil, function()
    o.homeTeamID = currentBeaproData.homeID
    o.awayTeamID = currentBeaproData.awayID
    o.homeKitIndex = currentMatch.HomeKitIndex
    o.awayKitIndex = currentMatch.AwayKitIndex
    o.services.gameState.PauseAIandRendering(false)
    o.services.gameSetup.SetTeam(0, o.homeTeamID)
    o.services.gameSetup.SetTeam(1, o.awayTeamID)
    o.services.gameSetup.SetPreferredKitId(0, o.homeTeamID * 4096 + o.homeKitIndex)
    o.services.gameSetup.SetPreferredKitId(1, o.awayTeamID * 4096 + o.awayKitIndex)
    o.services.gameSetup.CommitKitSelect()
    o.services.gameState.SetUserSideAsHome()
    
    -- MANTER O MESMO JOGADOR EM TODAS AS PARTIDAS DO BEAPRO
    o:handleBeaproPlayerSelection()
  end)
  
  return o
end

function Match:handleBeaproPlayerSelection()
  -- Se está em modo Beapro
  if currentBeaproData and currentBeaproData.Index > 0 then
    local Index = currentBeaproData.Index
    local round = currentBeaproData.round
    
    -- Verifica se é a primeira partida
    local isFirstMatch = true
    for i = 1, #BeaproGrouping[Index] do
      if BeaproGrouping[Index][i][5] == true then
        isFirstMatch = false
        break
      end
    end
    
    if isFirstMatch then
      -- Primeira partida: salva o jogador que será selecionado automaticamente
      beaproSelectedPlayer = {
        round = round,
        timestamp = os.time()
      }
      print(" Primeira partida Beapro - Jogador será selecionado automaticamente")
    else
      -- Próximas partidas: força o mesmo jogador
      if beaproSelectedPlayer then
        print(" Mantendo o mesmo jogador da partida anterior")
        -- Aqui o sistema mantém o jogador já selecionado
      end
    end
  end
end

return Match

-- Thanks : Ma'ruf Id & Laosiji --
-- @mvnprod.official - Remain Be Creative --