-- This script will export current season stats (goals scored, assists etc.) to CSV.
-- The SEASON_STATS.csv file will be created on Desktop.
-- The game resets stats at the beginning of every season, so you need to run the script at the end of every season.
require 'imports/other/helpers'

local desktop_path = string.format("%s\\Desktop", os.getenv('USERPROFILE'))
local current_date = GetCurrentDate()
local file_path = string.format("%s\\SEASON_STATS_%02d_%02d_%04d.csv", desktop_path, current_date.day, current_date.month, current_date.year)

-- Don't Touch
local columns = {
    "position",
    "playerid",
    "playername",
    "team",
    "competition",
    "appearances",
    "AVG",
    "MOTMs",
    "goals",
    "assists",
    "yellow_cards",
    "two_yellow",
    "red_cards",
    "saves",
    "goals_conceded",
    "cleansheets"
}

local col_to_key = {
    position = "position",
    playerid = "playerid",
    playername = "playername",
    team = "teamname",
    competition = "compname",
    appearances = "app",
    AVG = "avg",
    MOTMs = "motm",
    goals = "goals",
    assists = "assists",
    yellow_cards = "yellow",
    two_yellow = "two_yellow",
    red_cards = "red",
    saves = "saves",
    goals_conceded = "goals_conceded",
    cleansheets = "clean_sheets"
}

function get_players()
    local result = {}

    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()

    local playerid = 0
    local preferredposition1 = 0
    while current_record > 0 do
        local player = {}

        playerid = players_table:GetRecordFieldValue(current_record, "playerid")
        preferredposition1 = players_table:GetRecordFieldValue(current_record, "preferredposition1")

        player.position = GetPlayerPrimaryPositionName(preferredposition1)
        
        -- Get the names later, only if needed as it's very slow
        player.name = GetPlayerName(playerid)
        player.teamname = GetTeamName(GetTeamIdFromPlayerId(playerid))

        result[playerid] = player
    
        current_record = players_table:GetNextValidRecord()
    end

    return result
end

function get_stats(players)
    local result = {}
   
    local all_stats = GetPlayersStats()

    for i=1, #all_stats do
        local stat = all_stats[i]
        local playerid = stat.playerid
        local app = stat.app

        if playerid > 0 and playerid < 4294967295 and app > 0 then
            local player = players[playerid]
            if player ~= nil then
                if player.name == "" then
                    player.name = GetPlayerName(playerid)
                end
                
                local stats = player.stats or {}
                local compobjid = stat.compobjid
                stats[compobjid] = {}
                
                stats[compobjid]["playerid"] = playerid
                stats[compobjid]["playername"] = player.name
                stats[compobjid]["teamname"] = player.teamname
                stats[compobjid]["position"] = player.position
                
                stats[compobjid]["goals"] = stat.goals
                stats[compobjid]["yellow"] = stat.yellow
                stats[compobjid]["red"] = stat.red
                stats[compobjid]["assists"] = stat.assists
                stats[compobjid]["clean_sheets"] = stat.clean_sheets
                stats[compobjid]["compobjid"] = compobjid
                stats[compobjid]["compname"] = GetCompetitionNameByObjID(compobjid)
                
                -- Not sure
                stats[compobjid]["motm"] = stat.motm
                stats[compobjid]["saves"] = stat.saves
                stats[compobjid]["goals_conceded"] = stat.goals_conceded
                stats[compobjid]["two_yellow"] = stat.two_yellow
                
                local avg = stat.avg
                if app > 1 then 
                    avg = (avg / app) / 10 
                elseif app == 1 then
                    avg = avg / 10
                end
                
                stats[compobjid]["app"] = app
                stats[compobjid]["avg"] = string.format("%0.2f", avg)

                player.stats = stats
                result[playerid] = player

            end
        end
    end

    return result
end

assert(IsInCM(), "Script must be executed in career mode")

local file = io.open(file_path, "w+")
io.output(file)

io.write(table.concat(columns, ","))
io.write("\n")
local players_stats = get_stats(get_players())
for playerid, data in pairs(players_stats) do
    for compobjid, stat in pairs(data.stats) do
        local row = {}
        for i=1, #columns do
            local colname = columns[i]
            local _key = col_to_key[colname]
            table.insert(row, stat[_key])
        end
        io.write(table.concat(row, ","))
        io.write("\n")
    end

end

io.close(file)
LOGGER:LogInfo("Done")
