Config                        	= {}
--Config.MinCopsOnline			= 2  -- use 0 to disable cop count check
Config.CopsScaleReward			= true

--Hash of the npc ped. Change only if you know what you are doing.
Config.NPCHash					= -261389155

--Random time societies will get alerted. This is a range in seconds.
Config.AlertCopsDelayRangeStart	= 15
Config.AlertCopsDelayRangeEnd	= 30

--If you want to notify more societies add them here. example { "mafia", "bikers" }
Config.AlertExtraSocieties 		= { }

--Self Explained
 Config.ReceleurLocation	= { x = 588.99, y = 608.42, z = 127.91, h = 250.02 } -- Debug Reception
-- Config.ReceleurLocation	= { x = 1208.53, y = -3114.85, z = 4.5, h = 250.02 }


Config.ZoneLivraison 	= {

		-- { x = 1225.53, y = -3099.30, z = 5.32 } -- Debug ZoneLivraison
		{ x = 731.89, y = 4172.27, z = 39.3 },
		{ x = 1959.28, y = 3845.48, z = 31.2 },
		{ x = 388.76, y = 3591.34, z = 32.09},
		{ x = 97.24, y = 3739.86, z = 38.8}

}


local recompense1 = (math.random(150,300))
local recompense2 = (math.random(800,1000))
local recompense3 = (math.random(2500,5000))

Config.Scenarios = {

	{
		SpawnPoint = { x = 590.99, y = 612.42, z = 127.91, h = 5.77 }, -- debug
		--SpawnPoint = { x = 1204.12, y = -3117.37, z = 4.5, h = 5.77 },
		DeliveryPoint = 6.0,
		MinCopsOnline = 0,
		vehlv = 1,
		VehRunCost = 0,
		VehRunReward = recompense1

	},
	{
		SpawnPoint = { x = 590.99, y = 612.42, z = 127.91, h = 5.77 }, -- debug
		--SpawnPoint = { x = 1204.12, y = -3117.37, z = 4.5, h = 5.77 },
		DeliveryPoint = 6.0,
		MinCopsOnline = 0,
		vehlv = 2,
		VehRunCost = 0,
		VehRunReward = recompense2

	},
	{
		SpawnPoint = { x = 590.99, y = 612.42, z = 127.91, h = 5.77 }, -- debug
		--SpawnPoint = { x = 1204.12, y = -3117.37, z = 4.5, h = 5.77 },
		DeliveryPoint = 6.0,
		MinCopsOnline = 0,
		vehlv = 3,
		VehRunCost = 0,
		VehRunReward = recompense3

	}
}
