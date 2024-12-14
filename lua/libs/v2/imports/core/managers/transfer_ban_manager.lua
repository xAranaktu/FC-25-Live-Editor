local TRANSFER_BAN_MANAGER = {}

local ENUM_TRANSFER_BAN_TEAM = 0;
local ENUM_TRANSFER_BAN_PLAYER = 1;

function TRANSFER_BAN_MANAGER:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "TRANSFER_BAN_MANAGER"

    return o
end

function TRANSFER_BAN_MANAGER:AddTeam(teamid, date)
    cAddTransferBan(teamid, date, ENUM_TRANSFER_BAN_TEAM)
end

function TRANSFER_BAN_MANAGER:AddPlayer(playerid, date)
    cAddTransferBan(playerid, date, ENUM_TRANSFER_BAN_PLAYER)
end

function TRANSFER_BAN_MANAGER:RemoveTeam(teamid)
    cRemoveTransferBan(teamid, ENUM_TRANSFER_BAN_TEAM)
end

function TRANSFER_BAN_MANAGER:RemovePlayer(playerid)
    cRemoveTransferBan(playerid, ENUM_TRANSFER_BAN_TEAM)
end

function TRANSFER_BAN_MANAGER:IsTeamBanned(teamid)
    local all_bans = self:GetAllBans()
    for i=1, #all_bans do
        local transfer_ban = all_bans[i]
        if transfer_ban.member_type == ENUM_TRANSFER_BAN_TEAM and transfer_ban.id == teamid then
            return true
        end
    end

    return false
end

function TRANSFER_BAN_MANAGER:IsPlayerBanned(playerid)
    local all_bans = self:GetAllBans()
    for i=1, #all_bans do
        local transfer_ban = all_bans[i]
        if transfer_ban.member_type == ENUM_TRANSFER_BAN_PLAYER and transfer_ban.id == playerid then
            return true
        end
    end

    return false
end

function TRANSFER_BAN_MANAGER:GetAllBans()
    return cGetTransferBans()
end

function TRANSFER_BAN_MANAGER:Save()
    return cSaveTransferBans()
end

return TRANSFER_BAN_MANAGER;