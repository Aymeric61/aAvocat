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

--------------------------- Garage 

local VestiaireAvocat = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255,255,255}, Title = "Avocat" },
    Data = { currentMenu = "Les Tenues : ", "Test" },
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result, slide)
            if btn.name == "🙎‍♂️ Remettre sa Tenue" then
                TenueCivil()
            elseif btn.name == "🧍 Tenue Avocat" then
                Avocat()
            end
        end
    },

    Menu = {
        ["Les Tenues : "] = {
            b = {
                {name = "🙎‍♂️ Remettre sa Tenue", askX = true},
                {name = "                      ↓ ~r~Tenues de Service~s~ ↓"},
                {name = "🧍 Tenue Avocat", askX = true},
            }
        }
    }
}

Citizen.CreateThread(function()

    while true do

        local pos = GetEntityCoords(PlayerPedId())
        local menu = Config.Pos.Vestiaire
        local dist = #(pos - menu)

        if dist <= 2 and ESX.PlayerData.job.name == 'avocat' then

        ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir les ~b~Vestiaires")
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 249, 51, 200)

            if IsControlJustPressed(1, 38) then
                CreateMenu(VestiaireAvocat)
            end
        end
        Citizen.Wait(0)
    end
end)

function Avocat()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Config.Tenue.Service.H
        else
            uniformObject = Config.Tenue.Service.F
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function TenueCivil()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
    TriggerEvent('skinchanger:loadSkin', skin)
    end)
end