local Squads = {}

function Squads:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o.services = init.services
  return o
end

-- Swaps a player with a substitute (if starter) or removes them (if substitute).
-- @param playerId The CARD_ID of the player to swap or remove.
-- @param team The team identifier.
-- @return A table of player IDs representing the modified squad.
function Squads:swapSoldPlayer(playerId, team)
  local squad = self.services.SquadManagementService.GetCurrentPlayerLineup(0, team, 0)
  local players = {}
  local playerIndex, repIndex = 0, 0
  local playerPosition = ""
  local playerRole = "Starter"

  -- Build initial player ID list and find player
  for i, player in ipairs(squad) do
    players[i] = player.CARD_ID
    if player.CARD_ID == playerId then
      playerIndex = i
      playerPosition = player.position
      playerRole = i > 11 and "Sub/Res" or "Starter"
    end
  end

  -- If player not found, return original squad
  if playerIndex == 0 then
    warn("Player ID " .. playerId .. " not found in squad")
    return players
  end

  -- If starter, find substitute with same position
  if playerRole == "Starter" then
    for i, player in ipairs(squad) do
      if i > 11 and player.position == playerPosition then
        repIndex = i
        break
      end
    end
    -- If no substitute found, return original squad
    if repIndex == 0 then
      warn("No substitute found for position " .. playerPosition)
      return players
    end
    -- Swap players
    players[playerIndex], players[repIndex] = players[repIndex], players[playerIndex]
  else
    -- For Sub/Res, remove the player
    table.remove(players, playerIndex)
  end

  return players
end

return Squads