Config = {}
Config.DriveStyle = 39 -- THIS CAN BE CHANGED AT https://www.vespura.com/fivem/drivingstyle/
Config.MaxDeliveries = 5 -- AMOUNT OF DELIVERIES TO COMPLETE OXYRUN, LEAVE SAME FOR NOT RANDOM
Config.MinDeliveries = 3 -- AMOUNT OF DELIVERIES TO COMPLETE OXYRUN, LEAVE SAME FOR NOT RANDOM
Config.Cars = {"adder", "ingot"} -- CAR MODELS
Config.MaxTimeBetweenCars = 20 -- SECONDS
Config.MinTimeBetweenCars = 10 -- SECONDS
Config.DriverPed = "s_m_m_gentransport" -- DRIVER PED, !! IF CARS DON'T SPAWN SOME OF THESE MAY NEEDS TO BE CHANGED OR REMOVED !!
Config.DebugPoly = false -- IF POLYZONES SHOULD BE SHOWN

Config.CleanMoney = true -- IF THE CUSTOMERS SHOULD ALSO TAKE SOME BILLS, NOTES OR BAGS FOR MONEY

-- BAGS
Config.BagMaxPayout = 5000
Config.BagMinPayout = 2000
Config.BagChance = 10 -- HOW MANY PROCENT THERE IS FOR A CUSTOMER FOR TAKING BAGS

-- BILLS
Config.BandMaxPayout = 2000
Config.BandMinPayout = 750
Config.BandChance = 15 -- HOW MANY PROCENT THERE IS FOR A CUSTOMER FOR TAKING BANDS

-- ROLLS
Config.RollMaxPayout = 750
Config.RollMinPayout = 250
Config.RollChance = 20 -- HOW MANY PROCENT THERE IS FOR A CUSTOMER FOR TAKING ROLL


Config.GiveItem = true -- IF THERE SHOULD BE GIVEN AN ITEM ON DELIVER
Config.ItemReward = "oxy"
Config.MaxItemReward = 3
Config.MinItemReward = 1

Config.Routes = { -- HERE YOU CAN ADD AS MANY LOCATIONS AS YOU WANT TO
	{
		info = {
			occupied = false,
			hash = "", -- DON'T TOUCH
			oxyNum = 1, -- DON'T TOUCH
			routeNum = 1, -- NEENDS TO BE SET TO THE ORDER IT COMES IN THE LIST
			startHeading = 157.05 -- HEADING OF CAR WHEN IT SPAWNS IN
		},
		locations = {
			{ pos = vector3(259.13, -125.32, 67.76), stop = false }, -- SPAWN POINT
			{ pos = vector3(220.58, -166.64, 56.64), stop = true }, -- WAIT FOR DELIVER
			{ pos = vector3(73.81, -25.48, 68.59), stop = false }, -- DESPAWN POINT
		}
	},
	{
		info = { 
			occupied = false,
			hash = "", -- DON'T TOUCH
			oxyNum = 1, -- DON'T TOUCH
			routeNum = 2, -- NEENDS TO BE SET TO THE ORDER IT COMES IN THE LIST
			startHeading = 157.19 -- HEADING OF CAR WHEN IT SPAWNS IN
		},
		locations = {
			{ pos = vector3(19.9, -51.4, 64.95), stop = false }, -- SPAWN POINT
			{ pos = vector3(-15.09, -77.05, 57.07), stop = true }, -- WAIT FOR DELIVER
			{ pos = vector3(-80.28, 43.64, 71.83), stop = false }, -- DESPAWN POINT
		}
	},
}

Config.Text = {
    ['noroutes'] = "Could't find a route for you, try again later...",
	['stealveh'] = "Find and steal a vehicle to use as a transport!",
	['getboxes'] = "Go to the supplier and ask for the goods!",
	['drivetohandoff'] = "Drive to the handoff location with the transport vehicle!",
	['atlocation'] = "You at the location, wait for the customers",
	['done'] = "Done, for today.",
	['nopackage'] = "You're not holding a package!",
}