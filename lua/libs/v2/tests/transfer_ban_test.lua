local TRANSFER_BAN_MANAGER = require 'imports/core/managers/transfer_ban_manager'

local transfer_ban_manager = TRANSFER_BAN_MANAGER:new()

transfer_ban_manager:AddPlayer(158023, 20240101)
transfer_ban_manager:AddTeam(1, 20240101)

local all_bans = transfer_ban_manager:GetAllBans()
for i=1, #all_bans do
    local transfer_ban = all_bans[i]
    
    print(transfer_ban.member_id)
end