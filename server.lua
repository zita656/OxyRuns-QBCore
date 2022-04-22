local QBCore = exports['qb-core']:GetCoreObject()

local oxyStarted = false
players = {}
entities = {}

RegisterNetEvent("oxyrun:server:sendCar")
AddEventHandler("oxyrun:server:sendCar", function(carsRoute)
	if oxyStarted == false then 
		--for route = 1, #Config.Routes do
		Citizen.CreateThread(function()
			local oxyNum = 1
			local curr = Config.Routes[carsRoute]
			if oxyNum <= curr.info.oxyNum then
				local curr = curr
				local position = curr.locations[1].pos
				local heading = curr.info.startHeading
				local hash = Config.Cars

				local vehicle = CreateVehicle(GetHashKey(hash[math.random(#Config.Cars)]), position, heading, true, true)
				
				Wait(100)
				while not DoesEntityExist(vehicle) do
					local pos = GetEntityCoords(vehicle)
					local errorPos = vector3(math.ceil(pos.x), math.ceil(pos.y), math.ceil(pos.z))
					if errorPos == vector3(0, 0, 1) then
						vehicle = CreateVehicle(GetHashKey(hash[math.random(#Config.Cars)]), position, heading, true, true)
					end
					Wait(300)
				end	
				SetEntityDistanceCullingRadius(vehicle, 999999999.0)
				
				local ped = CreatePedInsideVehicle(vehicle, 0, GetHashKey(Config.DriverPed), -1, true, false)
				Wait(100)
				while not DoesEntityExist(ped) do
					local pos = GetEntityCoords(ped)
					local errorPos = vector3(math.ceil(pos.x), math.ceil(pos.y), math.ceil(pos.z))
					if errorPos == vector3(0, 0, 1) then
						ped = CreatePedInsideVehicle(vehicle, 0, GetHashKey(Config.DriverPed), -1, true, false)
					end
					Wait(300)
				end
				SetEntityDistanceCullingRadius(vehicle, 999999999.0)
				table.insert(entities, vehicle)
				table.insert(entities, ped)
				
				local pedOwner = NetworkGetEntityOwner(ped)
				local pedNetId = NetworkGetNetworkIdFromEntity(ped)
				local oxyNetId = NetworkGetNetworkIdFromEntity(vehicle)

				-- Added for first time entering server (need to test)
				--while players[pedOwner] == nil do Wait(1) end
				
				table.insert(players[pedOwner], {pedNetId = pedNetId, routeNumber = route, oxyNumber = oxyNum, nextStop = 2})

				TriggerClientEvent("oxyrun:startCar", pedOwner, pedNetId, carsRoute)

				oxyNum = oxyNum + 1
			end
		end)
	end
end)

RegisterNetEvent("oxyrun:server:deliver")
AddEventHandler("oxyrun:server:deliver", function()
	local Player = QBCore.Functions.GetPlayer(source)
	local hasPackage = Player.Functions.GetItemByName("package")
	local hasBags = Player.Functions.GetItemByName("markedbills")
	local hasBands = Player.Functions.GetItemByName("bands")
	local hasRolls = Player.Functions.GetItemByName("rolls")

	local chance = math.random(0,100)

	if hasPackage then
		print(chance)
		if Config.GiveItem then
			Player.Functions.AddItem(Config.ItemReward, math.random(Config.MinItemReward, Config.MaxItemReward))
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ItemReward], "add")
		end

		if Config.CleanMoney then

			if chance < Config.BagChance then
				if hasBags then
					bagAmount = math.random(Player.Functions.GetItemByName("markedbills").amount)
					Player.Functions.AddMoney('cash', bagAmount*math.random(Config.BagMinPayout, Config.BagMaxPayout))

					Player.Functions.RemoveItem("markedbills", bagAmount)
					TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["markedbills"], "remove")
				end
			end

			if chance < Config.BandChance then
				if hasBands then
					bandAmount = math.random(Player.Functions.GetItemByName("bands").amount)
					Player.Functions.AddMoney('cash', bandAmount*math.random(Config.BandMinPayout, Config.BandMaxPayout))

					Player.Functions.RemoveItem("bands", bandAmount)
					TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["bands"], "remove")
				end
			end

			if chance < Config.RollChance then
				if hasRolls then
					rollAmount = math.random(Player.Functions.GetItemByName("rolls").amount)
					Player.Functions.AddMoney('cash', rollAmount*math.random(Config.RollMinPayout, Config.RollMaxPayout))

					Player.Functions.RemoveItem("rolls", rollAmount)
					TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["rolls"], "remove")
				end
			end
		end
	
		Player.Functions.RemoveItem("package", 1)
		TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['package'], "remove")
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	for i=1, 1000 do
		if GetPlayerPed(i) ~= 0 then
			players[i] = {}
			SetPlayerCullingRadius(i, 999999999.0)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end
	CleanUp()
end)

function CleanUp()
	for _, entity in ipairs(entities) do
		if DoesEntityExist(entity) then
			DeleteEntity(entity)
		end
	end
	for k,v in pairs(players) do
		SetPlayerCullingRadius(k, 0.0)
	end
	players = {}
	entities = {}
	oxyStarted = false
end

QBCore.Functions.CreateCallback('oxyrun:server:hasPackage', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local hasPackage = Player.Functions.GetItemByName("package")
 
	if hasPackage ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('oxyrun:server:canCarry', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
 
	if Player.Functions.AddItem("package", 1) then
		cb(true)
		TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['package'], "add")
	else
		cb(false)
	end
end)