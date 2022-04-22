local QBCore = exports['qb-core']:GetCoreObject()

zoneEntered = false
deliveries = 0
gettingBox = false
amountOfBox = 0
gettingVehicle = false
Delivered = false
holdingBox = false
doingOxy = false
atOxy = false
currentCars = 0
currentBoxes = 0
carsRoute = 0

RegisterNetEvent("oxyrun:startCar")
AddEventHandler("oxyrun:startCar", function(pedNetId, route)
	while not NetworkDoesNetworkIdExist(pedNetId) do
		Wait(0)
	end
	local driverPed = NetToPed(pedNetId)
	local car = GetVehiclePedIsIn(driverPed, false)

	while car == 0 do 
		car = GetVehiclePedIsIn(driverPed, false)		
		Wait(0)
	end

	SetEntityAsMissionEntity(driverPed, true, true)
	SetEntityAsMissionEntity(car, true, true)
	SetEntityCanBeDamaged(car, false)
	SetVehicleDamageModifier(car, 0.0)
	SetVehicleEngineCanDegrade(car, false)
	SetEntityCanBeDamaged(driverPed, false)
	SetPedCanBeTargetted(driverPed, false)
	SetDriverAbility(driverPed, 1.0)
	SetDriverAggressiveness(driverPed, 0.0)
	SetBlockingOfNonTemporaryEvents(driverPed, true)
	SetPedConfigFlag(driverPed, 251, true)
	SetPedConfigFlag(driverPed, 64, true)
	SetPedStayInVehicleWhenJacked(driverPed, true)
	SetPedCanBeDraggedOut(driverPed, false)

	exports['qb-target']:AddTargetEntity(car, {
		options = {
			{
				type = "client",
				event = "oxyrun:client:deliverPackage",
				icon = "fas fa-hand-holding",
				label = "Handoff Package",
			},
		},
		distance = 3.0
	})

	local nextLocation = 2
	while true do
		local data = Config.Routes[route].locations[nextLocation]
		TaskVehicleDriveToCoordLongrange(driverPed, car, data.pos, 10.0, Config.DriveStyle, 25.0)	
		WaitTaskToEnd(driverPed, 567490903)
		if GetScriptTaskStatus(driverPed, 567490903) == 7 then -- Parking
			if data.stop == true then
				TaskVehicleDriveToCoordLongrange(driverPed, car, data.pos, 7.5, Config.DriveStyle, 4.0)
				WaitTaskToEnd(driverPed, 567490903)
				if GetScriptTaskStatus(driverPed, 567490903) == 7 then --Waiting
					while not Delivered do
						Wait(700)
					end
				end
			end
			if (nextLocation+1) > #Config.Routes[route].locations then
				nextLocation = 1
				DeleteVehicle(car)
				DeletePed(driverPed)
			else
				nextLocation = nextLocation + 1
			end
		end
		Wait(0)
	end	
end)

function WaitTaskToEnd(ped, task)
	while GetScriptTaskStatus(ped, task) == 0 do
		Wait(250)
	end
	while GetScriptTaskStatus(ped, task) == 1 do
		Wait(250)
	end
end

RegisterNetEvent("oxyrun:client:deliverPackage")
AddEventHandler("oxyrun:client:deliverPackage", function()
	if holdingBox then
		if currentCars <= deliveries then
			currentCars = currentCars + 1
			TriggerEvent('QBCore:Notify', 'Well done, (' .. currentCars .. '/' .. deliveries .. ')')
		end

		TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		TriggerServerEvent("oxyrun:server:deliver")
		TriggerEvent("oxyrun:client:hasPackage")
		Delivered = true
		Wait(1000)
		Delivered = false
		if currentCars == deliveries then
			TriggerEvent("oxyrun:client:endOxy")
			return
		end	
		Wait(Config.MinTimeBetweenCars*1000, Config.MaxTimeBetweenCars*1000)
		TriggerEvent("oxyrun:client:sendCar")
	else
		QBCore.Functions.Notify(Config.Text["nopackage"], 'error', 5000)
	end
end)

RegisterNetEvent("oxyrun:client:hasPackage")
AddEventHandler("oxyrun:client:hasPackage", function()
	local ped = PlayerPedId()

	QBCore.Functions.TriggerCallback('oxyrun:server:hasPackage', function(hasItems)
		if hasItems then
			TriggerEvent('animations:client:EmoteCommandStart', {"box"})
			holdingBox = true
		elseif holdingBox and not hasItems then
			TriggerEvent('animations:client:EmoteCommandStart', {"box"})
			Wait(250)
			TriggerEvent('animations:client:EmoteCommandStart', {"c"})
			holdingBox = false
		end
	end)
end)

Citizen.CreateThread(function()
	while doingOxy do
		if not atOxy then
			TriggerEvent("polyzonehelper:enter", "AtOxy")
			Wait(500)
		else
			TriggerEvent("polyzonehelper:exit", "AtOxy")
			Wait(500)
		end
	end

	while true do
		Wait(0)
		if gettingVehicle then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				gettingVehicle = false
				TriggerEvent('QBCore:Notify', Config.Text["getboxes"])
				oxyBlip = AddBlipForCoord(vector3(-2981.43, 1586.23, 23.69))
				SetBlipColour(oxyBlip, 3)
				SetBlipAlpha(oxyBlip, 0)
				SetBlipRoute(oxyBlip, true)
			end
		end
	end
end)

RegisterNetEvent('oxyrun:client:sendToOxy', function()
	deliveries = math.random(Config.MinDeliveries, Config.MaxDeliveries)

	-- if #Config.Routes == #occupiedRoutes then
	-- 	QBCore.Functions.Notify(Config.Text["noroutes"], 'error', 5000)
	-- 	return
	-- end

	--carsRoute = math.random(notOccupiedRoutes[1].info.routeNum, notOccupiedRoutes[#notOccupiedRoutes].info.routeNum)
	carsRoute = math.random(#Config.Routes)
	local carRoute = Config.Routes[carsRoute]

	-- table.remove(notOccupiedRoutes, carsRoute)
	-- table.insert(occupiedRoutes, carsRoute)
	-- print(carRoute.locations[1].pos)

	TriggerEvent('QBCore:Notify', Config.Text["stealveh"])
	gettingBox = true
	gettingVehicle = true
end)

RegisterNetEvent('oxyrun:client:getBox', function()
	if gettingBox then
		amountOfBox = deliveries

		QBCore.Functions.TriggerCallback('oxyrun:server:canCarry', function(canCarry)
			if canCarry then
				if currentBoxes < amountOfBox then
					TriggerEvent("oxyrun:client:hasPackage")
					currentBoxes = currentBoxes + 1
					TriggerEvent('QBCore:Notify', '('.. currentBoxes .. '/' .. amountOfBox .. ')')
					if currentBoxes == amountOfBox then
						TriggerEvent('QBCore:Notify', Config.Text["drivetohandoff"])
						TriggerEvent("oxyrun:client:startOxy")
						gettingBox = false
					end
				end
			end
		end)
	else
		QBCore.Functions.Notify("Something seems wrong...", 'error', 5000)
	end
end)

RegisterNetEvent('oxyrun:client:startOxy', function()
	local carRoute = Config.Routes[carsRoute]
	local carRoute = carRoute
	position = carRoute.locations[2].pos

	doingOxy = true
	oxyBlip = AddBlipForCoord(position)
	SetBlipSprite(oxyBlip, 524)
    SetBlipScale(oxyBlip, 1.0)
	SetBlipColour(oxyBlip, 3)
	SetBlipRoute(oxyBlip, true)
end)

AddEventHandler('polyzonehelper:enter', function(name)
    if LocalPlayer.state["isLoggedIn"] then
        if name == "AtOxy" then
            atOxy = true
			if doingOxy and atOxy and not zoneEntered then
				TriggerEvent("oxyrun:client:sendCar")
				TriggerEvent('QBCore:Notify', Config.Text["atlocation"])
				zoneEntered = true
			end
        end  
    end
end)

AddEventHandler('polyzonehelper:exit', function(name)
    if LocalPlayer.state["isLoggedIn"] then
        if name == "AtOxy" then
            atOxy = false
        end
    end
end)

RegisterNetEvent('oxyrun:client:sendCar', function()
	if doingOxy and atOxy then
		TriggerServerEvent("oxyrun:server:sendCar", carsRoute)
	end
end)

RegisterNetEvent('oxyrun:client:endOxy', function()  
	currentCars = 0 
	doingOxy = false
	atOxy = false
	carsRoute = 0
	currentBoxes = 0
	Delivered = false
	zoneEntered = false
	amountOfBox = 0
	deliveries = 0

	TriggerEvent('QBCore:Notify', Config.Text["done"])
	RemoveBlip(oxyBlip)
end)

AddEventHandler('onClientResourceStart', function (resourceName)
	if(GetCurrentResourceName() ~= resourceName) then
	  return
	end

	-- for route = 1, #Config.Routes do
	-- 	local curr = Config.Routes[route]
	-- 	local curr = curr
	-- 	local isOccupied = curr.info.occupied

	-- 	if not isOccupied then
	-- 		table.insert(notOccupiedRoutes, curr)
	-- 	else
	-- 		table.insert(occupiedRoutes, curr)
	-- 	end
	-- end
	
	RemoveBlip(oxyBlip)
	for route = 1, #Config.Routes do
		local curr = Config.Routes[route]
		local curr = curr
		local position = curr.locations[2].pos

		exports['polyzonehelper']:AddBoxZone("AtOxy", position, 15, 15, {
			name="AtOxy",
			heading=335.31,
			minZ=position.z-10,
			maxZ=position.z+5,
			debugPoly=false
		})
	end
  end)