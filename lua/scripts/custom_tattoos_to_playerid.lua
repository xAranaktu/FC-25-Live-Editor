--- This script can add/update leftarm tattoos from your mod manager
--- You need to edit "tattoos_map" by yourself, pattern is simple:
--- [playerid] = tattooid,
--- by default it updates these tattoos:
--- 070 : Roberto Firmino 201942
--- 071 : Manuel Lanzini 188988
--- 072 : Dani Ceballos 222509
--- 073 : Emerson Palmieri 210736
--- 074 : Isco 197781
--- 075 : James Maddison 220697
--- 076 : Christian Pulisic 227796
--- 077 : Ricardo Quaresma 20775
--- 078 : Santi Mina 212623
--- 079 : Saul 208421
--- 080 : Arturo Vidal 181872
--- 081 : Maro Icardi 201399
--- 082 : Marcelo 176676
--- 083 : Nainggolan 178518
--- 084 : Gabriel Jesus 230666
--- 085 : Leonardo Bonucci 184344
--- 086 : Samu Castillejo 210617
--- 087 : Coutinho 189242
--- 088 : Joao Cancelo 210514
--- 089 : Milinkovic-Savic 223848
--- 090 : Perotti 183900
--- 091 : Pellegrini 228251
--- 092 : Spinazzola 202884
--- 093 : Douglas Costa 190483
--- 666 : Sergio Ramos 155862
require 'imports/core/common'


local tattoos_map = {
    [201942] = 70,
    [188988] = 71,
    [222509] = 72,
    [210736] = 73,
    [197781] = 74,
    [220697] = 75,
    [227796] = 76,
    [20775] = 77,
    [212623] = 78,
    [208421] = 79,
    [181872] = 80,
    [201399] = 81,
    [176676] = 82,
    [178518] = 83,
    [230666] = 84,
    [184344] = 85,
    [210617] = 86,
    [189242] = 87,
    [210514] = 88,
    [223848] = 89,
    [183900] = 90,
    [228251] = 91,
    [202884] = 92,
    [190483] = 93,
    [155862] = 666,
}

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()

local updated_players = 0
local players_count = table_count(headmodels_map)

local playerid = 0
local tattooid = nil
while current_record > 0 do
    playerid = players_table:GetRecordFieldValue(current_record, "playerid")

    tattooid = tattoos_map[playerid]
    if (tattooid) then
        players_table:SetRecordFieldValue(current_record, "tattooleftarm", tattooid)

        updated_players = updated_players + 1
    end

    -- Break the loop if we already updated all players
    if (updated_players == players_count) then
        break
    end

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", string.format("Edited %d players\n", updated_players))
