local ZONES = {
    {
        id = "trucking_depot",
        coords = vec3(1208.83, -3116.34, 4.54),
        radius = 40.0,
        url = "https://icecast.omroep.nl/radio6-bb-mp3",  ---
        volume = 0.25
    },
    {
        id = "gas_stations_music",
        coords = {
            vec3(-70.69, -1761.69, 31.3),   -- grove st gas
            vec3(-319.07, -1473.35, 33.04),  -- near bennys
            vec3(265.08, -1261.47, 33.51),      -- near olympic fwy
            vec3(-724.07, -935.68, 21.23),     --little seoul
            vec3(-1436.65, -277.59, 49.13),   -- south rockford dr
            vec3(620.81, 268.94, 106.06),      --vinewood
            vec3(1181.08, -330.32, 71.4),       -- mirrior park
            vec3(1207.89, -1402.99, 38.45),     --capital blvd
            vec3(818.99, -1028.69, 28.3),       --popular st
            vec3(-525.2, -1211.45, 19.91),       --calais ave
            vec3(-2096.82, -320.23, 16.3),    -- great ocean/del perro beach
            vec3(177.19, -1562.97, 28.27),      --Davis ave
        },
        radius = 60.0,
        url = "https://stream.laut.fm/festival",
        volume = 0.45
    }
}

local activeZone = nil
local activeCoord = nil

CreateThread(function()
    while true do
        Wait(1000)

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local foundZone = nil
        local foundCoord = nil

        for _, zone in pairs(ZONES) do
            for _, coord in pairs(zone.coords) do
                if #(pos - coord) < zone.radius then
                    foundZone = zone
                    foundCoord = coord
                    break
                end
            end
            if foundZone then break end
        end

        if foundZone and not activeZone then
            activeZone = foundZone
            activeCoord = foundCoord

            exports.xsound:PlayUrlPos(
                activeZone.id,
                activeZone.url,
                activeZone.volume,
                activeCoord
            )

            exports.xsound:Distance(activeZone.id, activeZone.radius)
        end

        if not foundZone and activeZone then
            exports.xsound:Destroy(activeZone.id)
            activeZone = nil
            activeCoord = nil
        end
    end
end)
