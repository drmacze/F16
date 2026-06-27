-------------------------------------------
-- MOD By LAOSIJI --
-------------------------------------------

local Reindex = {}

function Reindex:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = {
    SquadManagementService = o.api("SquadMgtService")
  }

  -- Swap player with CARD_ID 239085 within teamID 10
  o:swapPlayersInTeam(GLOBAL_TEAMBUY, GLOBAL_PLAYERINSTALL)
  
  -- Perform the 'evt_back' event 15 times systematically
  return o
end

function Reindex:swapPlayersInTeam(teamID, cardIDToSwap)
  local players = self.services.SquadManagementService.GetCurrentPlayerLineup(0, teamID, 0)
  
  if not players or #players == 0 then
    print("[Reindex]: No players found for teamID " .. teamID)
    return
  end

  local playerToSwap, playerToSwapIndex = nil, nil
  local playerPositionToMatch = nil
  
  -- Find the player with the specified CARD_ID
  for index, player in ipairs(players) do
    if player.CARD_ID == cardIDToSwap then
      playerToSwap = player
      playerToSwapIndex = index
      playerPositionToMatch = player.position
      break
    end
  end

  if not playerToSwap then
    print("[Reindex]: Player with CARD_ID " .. cardIDToSwap .. " not found in teamID " .. teamID)
    return
  end

  -- Find the highest-rated player with the same position, not in the starting lineup (index 12+)
  local highestRatedReplacement = nil
  local highestRating = -1
  local replacementIndex = nil

  for index = 12, #players do -- Start from 12 to avoid starting lineup
    local player = players[index]
    if player.position == playerPositionToMatch and player.rating > highestRating then
      highestRatedReplacement = player
      highestRating = player.rating
      replacementIndex = index
    end
  end

  if highestRatedReplacement then
    -- Swap players
    players[playerToSwapIndex], players[replacementIndex] = players[replacementIndex], players[playerToSwapIndex]
    
    -- Update the lineup with new player positions
    local updatedPlayerIDs = {}
    for _, player in ipairs(players) do
      table.insert(updatedPlayerIDs, player.CARD_ID)
    end
    self.services.SquadManagementService.SetCurrentPlayerLineup(0, teamID, 0, 0, updatedPlayerIDs)
    
    print("[Reindex]: Swapped player " .. cardIDToSwap .. " with highest-rated " .. playerPositionToMatch .. " " .. highestRatedReplacement.CARD_ID .. " in teamID " .. teamID)
  else
    print("[Reindex]: No suitable replacement found for player with CARD_ID " .. cardIDToSwap .. " in teamID " .. teamID)
  end
end

function Reindex:finalize()
  -- Finalization logic, if any
end

return Reindex