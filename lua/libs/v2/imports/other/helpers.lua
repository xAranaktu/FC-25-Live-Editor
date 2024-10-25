DATE = require 'imports/core/date'
require 'imports/career_mode/helpers'
require 'imports/other/consts'

function GetPlayerPrimaryPositionName(pos_id)
    return CONST__PLAYER_PRIMARY_POS_NAME[pos_id] or "INVALID"
end

-- return FC::DATE (imports\core\date.lua)
function GetCurrentDate()
    local result = DATE:new()

    if not IsInCM() then return result end

    local calendar_manager = GetManagerObjByTypeId(ENUM_FCEGameModesFCECareerModeCalendarManager)

    result.day = MEMORY:ReadInt(calendar_manager + 0x34)
    result.month = MEMORY:ReadInt(calendar_manager + 0x38)
    result.year = MEMORY:ReadInt(calendar_manager + 0x3C)

    return result
end

function CalculatePlayerAge(current_date, birthdate)
    local age = current_date.year - birthdate.year

    if (current_date.month < birthdate.month or (current_date.month == birthdate.month and current_date.day < birthdate.day)) then
        age = age - 1
    end
    return age
end


function GetPlayerIDSForTeam(teamid)
    local result = {}
    if teamid <= 0 then return result end

    local teamplayerlinks_table = LE.db:GetTable("teamplayerlinks")

    local current_record = teamplayerlinks_table:GetFirstRecord()
    while current_record > 0 do
        local artificialkey = teamplayerlinks_table:GetRecordFieldValue(current_record, "artificialkey")

        if artificialkey > 0 and teamid == teamplayerlinks_table:GetRecordFieldValue(current_record, "teamid") then
            local playerid = teamplayerlinks_table:GetRecordFieldValue(current_record, "playerid")
            result[playerid] = true
            -- Log(string.format("%d", playerid))
        end
        current_record = teamplayerlinks_table:GetNextValidRecord()
    end

    return result
end

-- Return players that are goalkeepers
function GetGoalkeepers()
    local result = {}

    -- Get all rows for players table
    local players_table = LE.db:GetTable("players")
    local players_current_record = players_table:GetFirstRecord()

    local playerid = 0
    local preferredposition1 = 0
    while players_current_record > 0 do
        preferredposition1 = players_table:GetRecordFieldValue(players_current_record, "preferredposition1")

        -- If Is GK
        if preferredposition1 == 0 then
            -- Add to goalkeepers
            playerid = players_table:GetRecordFieldValue(players_current_record, "playerid")
            result[playerid] = true
        end

        players_current_record = players_table:GetNextValidRecord()
    end

    return result
end


