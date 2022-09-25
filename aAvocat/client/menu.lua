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

--------------------------- Menu F6 

local MenuF6 = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255,255,255}, Title = "Avocat" },
    Data = { currentMenu = "Intéraction", "Test" },
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result, slide)
            if btn.name == "Annonces" then
                OpenMenu("Annonces")
            elseif btn.name == "Annonce Ouverture" then
                TriggerServerEvent('ouvert')
            elseif btn.name == "Annonce Fermeture" then
                TriggerServerEvent('fermer')
            elseif btn.name == "Faire une Facture" then
                Facture()
            end
        end
    },

    Menu = {
        ["Intéraction"] = {
            b = {
                {name = "Annonces", ask = "→→", askX = true},
                {name = "Faire une Facture", ask = "→→", askX = true},
            }
        },
        ["Annonces"] = {
            b = {
                {name = "Annonce Ouverture", ask = "→→", askX = true},
                {name = "Annonce Fermeture", ask = "→→", askX = true},
            }
        },
    }
}

Citizen.CreateThread(function()

    while true do

        if IsControlJustPressed(1, 167) and ESX.PlayerData.job.name == 'avocat' then
            CreateMenu(MenuF6)
        end
        Citizen.Wait(0)
    end
end)

-- Facture

function Facture()
    ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'facture',
        {
            title = 'Donner une facture'
        },
        function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil or amount <= 0 then
                ESX.ShowNotification('Montant invalide')
            else
                menu.close()

                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Pas de joueurs proche')
                else
                    local playerPed        = GetPlayerPed(-1)

                    Citizen.CreateThread(function()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                        Citizen.Wait(5000)
                        ClearPedTasks(playerPed)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_avocat', 'Avocat', amount)
                        ESX.ShowNotification("~r~Vous avez bien envoyer la facture")
                    end)
                end
            end
        end,
        function(data, menu)
            menu.close()
    end)
end

-- Blips 

Citizen.CreateThread(function()

    local blip = AddBlipForCoord(Config.Pos.Blip)
	SetBlipSprite (blip, 40)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.9)
	SetBlipColour (blip, 38)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Avocat")
	EndTextCommandSetBlipName(blip)
end)