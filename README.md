# OxyRuns-QBCore
OxyRuns for qb core

qbcore/shered/items
["bands"] 					 = {["name"] = "bands", 			 	["label"] = "Band Of Notes", 		        ["weight"] = 100, 		["type"] = "item", 		["image"] = "cashstack.png", 				["unique"] = false, 		["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Band of Notes"},
["rolls"] 					 = {["name"] = "rolls", 			 	["label"] = "Roll Of Small Notes", 		        ["weight"] = 100, 		["type"] = "item", 		["image"] = "cashroll.png", 				["unique"] = false, 		["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Roll of Small Notes"},
['markedbills'] 				 = {['name'] = 'markedbills', 			  	  	['label'] = 'Marked Money', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'markedbills.png', 			['unique'] = false, 		['useable'] = false, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = ''},
["package"] 					 = {["name"] = "package", 			 	["label"] = "Suspicious Package", 		        ["weight"] = 25000, 		["type"] = "item", 		["image"] = "package.png", 				["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Package covered in tape and milk stickers.\nMarked for Police Seizure"},

For qb-targer/Config
["OxyPed"] = {
		model = 'a_m_m_og_boss_01', 
		coords = vector4(-1563.44, -441.36, 36.96, 97.07),
		minusOne = true, 
		freeze = true, 
		invincible = true, 
		blockevents = true,
		scenario = 'WORLD_HUMAN_DRUG_DEALER',
		target = { 
			options = {
				{
					type="client",
					event = "oxyrun:client:sendToOxy",
					icon = "fas fa-user-secret",
					label = "Start Oxy"
				}
			},
		 distance = 3,
	 	}
	},
	["OxyBoxPed"] = {
		model = 'a_m_m_salton_03', 
		coords = vector4(-2981.43, 1586.23, 23.69, 13.68),
		minusOne = true, 
		freeze = true, 
		invincible = true, 
		blockevents = true,
		target = {
			options = {
				{
					type="client",
					event = oxyrun:client:getBox,
					icon = "fas fa-user-secret",
					label = "Grab Package"
				}
			},
		 distance = 3,
	 	}
	},
  
  Qb-inventory or lj-inventory
  -- THIS EVENT NEEDS TO BE ADDED IN YOUR INVENTORY SCRIPT

TriggerEvent("oxyrun:client:hasPackage")

-- ADD IT UNDER ALL THE DIFFRENT PLACES WHERE THE INVENTORY UPDATES. (Open., closeinventory, open trunk, open glovebox, open drop, stash etc.)

