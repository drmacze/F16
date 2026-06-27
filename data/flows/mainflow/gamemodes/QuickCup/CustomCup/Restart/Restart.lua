-- Thanks For Laosiji & Ma'Ruf Id --
-- Reset For Tournament By MounTsa --

local Restart = {}

function Restart:new(init)
    local o = init or {}
    setmetatable(o, self)
    self.__index = self
    print("--- ⚠️ MERESET SEMUA DATA TURNAMEN (GLOBAL) ---")

	currentTourData = {
        matchIndex = 0,
        tourIndex = 0,
        homeID = 0,
        awayID = 0
    }
    GlobalTournamentSettings = {}

    currentTourInfo         = {}
    currentMatch           = {}
    GroupStandings         = {}
    QuickTourGrouping       = {}
    GroupStageTeams        = {}
    TeamList               = {}
    TeamListData           = {}
	TournamentStats = {}
	TeamPlayerCache = {}
    GOALS = {}
	
    o.nav.Event(nil, "evt_back") 
    return o
end

function Restart:finalize()

end

return Restart
