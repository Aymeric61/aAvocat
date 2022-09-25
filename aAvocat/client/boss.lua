ESX = nil

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    PlayerLoaded = true
    ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()

    while true do

        local pos = GetEntityCoords(PlayerPedId())
        local menu = Config.Pos.Boss
        local dist = #(pos - menu)

        if dist <= 2.0 and ESX.PlayerData.job.name == 'avocat' and ESX.PlayerData.job.grade_name == 'boss' then

        ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir l'~b~ordinateur")
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 249, 51, 200)

            if IsControlJustPressed(1, 38) then
                TriggerEvent('esx_society:openBossMenu', 'avocat', function(data, menu)
                    menu.close()
                end, {wash = true})
            end
        end
        Citizen.Wait(0)
    end
end)