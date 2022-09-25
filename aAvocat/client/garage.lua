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

function spawnCar(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(50)   
    end
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, 916.05, -163.00, 74.30, 146.15, false, false)
    SetVehicleNumberPlateText(vehicle, "Avocat")
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsNoLongerNeeded(vehicle)
end

--------------------------- Garage Voiture

local GarageAvocat = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255,255,255}, Title = "Avocat" },
    Data = { currentMenu = "Les Véhicules : ", "Test" },
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result, slide)
            if btn.name == "Avocat" then
                spawnCar('felon')
            elseif btn.name == "Voiture Patron" then
                spawnCar("sabregt2")
            end
        end
    },

    Menu = {
        ["Les Véhicules : "] = {
            b = {
                {name = "                      ↓ ~r~Véhicules de Service~s~ ↓"},
                {name = "Avocat", askX = true},
                {name = "Voiture Patron", askX = true},
            }
        }
    }
}

--------------------------- Spawn Voiture

Citizen.CreateThread(function()

    while true do

        local pos = GetEntityCoords(PlayerPedId())
        local menu = Config.Pos.Garage
        local dist = #(pos - menu)

        if dist <= 2 and ESX.PlayerData.job.name == 'avocat' then

        ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~Garage")

            if IsControlJustPressed(1, 38) then
                CreateMenu(GarageAvocat)
            end

        end
        Citizen.Wait(0)
    end
end)

--------------------------- Point supression

Citizen.CreateThread(function()

    while true do

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local menu = Config.Pos.GarageSupr
        local dist = #(pos - menu)

        if dist <= 5.0 and ESX.PlayerData.job.name == 'avocat' then

        ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~Menu")
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 249, 51, 200)

            if IsControlJustPressed(1, 38) then
                TriggerEvent('esx:deleteVehicle')
            end
        else
        Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)

--------------------------- Ped Garage

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.Name.garage)
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", Config.Name.garage, 906.18, -169.64, 73.10, 324.15, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end)