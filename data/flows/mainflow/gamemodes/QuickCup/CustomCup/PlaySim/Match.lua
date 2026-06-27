
local Match = {}

function Match:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self

    o.services = {
        gameSetup = o.api("GameSetupService"),
        gameState = o.api("GameStateService")
    }

    o.nav.AddActionHandler("setTeams", false, nil, function()

        if not currentTourData or not currentTourData.homeID then
            print("❌ Match.lua: ERROR! currentTourData is not valid. Using default teams.")
            currentTourData = { homeID = 1, awayID = 10, homeKitIndex = 0, awayKitIndex = 1, isUserSideHome = 0 }
        end

        local homeID = currentTourData.homeID
        local awayID = currentTourData.awayID
        local homeKitIndex = currentTourData.homeKitIndex or 0
        local awayKitIndex = currentTourData.awayKitIndex or 1
        local userSide = currentTourData.isUserSideHome or 0

        print("🔧 Match.lua: Setting up match -> Home: " .. homeID .. ", Away: " .. awayID)
        o.services.gameState.PauseAIandRendering(false)

        -- 1. Atur Tim
        o.services.gameSetup.SetTeam(0, homeID)
        o.services.gameSetup.SetTeam(1, awayID)
        
        -- 2. Atur Kostum
        o.services.gameSetup.SetPreferredKitId(0, homeID * 4096 + homeKitIndex)
        o.services.gameSetup.SetPreferredKitId(1, awayID * 4096 + awayKitIndex)
        o.services.gameSetup.CommitKitSelect()

        -- 3. Atur Sisi Pengguna
        if userSide == 0 then
            print("✅ Match.lua: Setting user side as HOME")
            o.services.gameState.SetUserSideAsHome()
        else
            print("✅ Match.lua: Setting user side as AWAY")
            o.services.gameState.SetUserSideAsAway()
        end
    o:AutoAdvance()
end)
    return o
end

function Match:AutoAdvance()
  self.nav.Event(nil, "evt_advance")
end
return Match