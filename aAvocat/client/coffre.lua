ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end  
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    Citizen.Wait(5000)
end)

------ Coffre

function OpenGetStocksavocatMenu()
	ESX.TriggerServerCallback('aAvocat:prendreitem', function(items)
		local elements = {}

		for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'police',
			title    = 'stockage',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                css      = 'police',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('aAvocat:prendreitems', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksavocatMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksavocatMenu()
	ESX.TriggerServerCallback('aAvocat:inventairejoueur', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'aAvocat',
			title    = 'inventaire',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                css      = 'aAvocat',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('aAvocat:stockitem', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksavocatMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

local coffre = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255, 255, 255}, Title = "Coffre entreprise" },
    Data = { currentMenu = "Coffre :", "Test"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)
    
            if btn.name == "Prendre" then
                OpenGetStocksavocatMenu()
                CloseMenu()
            elseif btn.name == "Deposer" then
                OpenPutStocksavocatMenu()
                CloseMenu()
            end 
    end,
},
    Menu = {
        ["Coffre :"] = {
            b = {
                {name = "Prendre", ask = '>>', askX = true},
                {name = "Deposer", ask = '>>', askX = true},
            }
        },
    }
} 

Citizen.CreateThread(function()

    while true do

        local pos = GetEntityCoords(PlayerPedId())
        local menu = Config.Pos.Coffre
        local dist = #(pos - menu)

        if dist <= 2 and ESX.PlayerData.job.name == 'avocat' then

        ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~Coffre")
        DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 249, 51, 200)

            if IsControlJustPressed(1, 38) then
                CreateMenu(coffre)
            end

        end
        Citizen.Wait(0)
    end
end)