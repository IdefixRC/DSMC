-- Dynamic Sequential Mission Campaign -- TRACK SPAWNED module

local ModuleName  	= "SLOT"
local MainVersion 	= HOOK.DSMC_MainVersion
local SubVersion 	= HOOK.DSMC_SubVersion
local Build 		= HOOK.DSMC_Build
local Date			= HOOK.DSMC_Date

--## LIBS
local base 			= _G
module('SLOT', package.seeall)
local require 		= base.require		
local io 			= require('io')
local lfs 			= require('lfs')
local os 			= require('os')
local ME_DB   		= require('me_db_api')
local ME_U			= require('me_utilities')
local Terrain		= require('terrain')

HOOK.writeDebugDetail(ModuleName .. ": local required loaded")

-- ## LOCAL VARIABLES
SLOTloaded						= false
local addedGroups				= 0
local addedunits				= 0
local tblSlots					= {}
--local MaxSlotsPerHeliport		= 4 -- maximum number of created slots per heliport that could be generated. Not related to airport/airbase
--local MaxFlightPerAirport		= 2
--local slotOnAirbasePerType		= 2
local maxFlights				= 1 


-- ## MANUAL TABLES

local standardCallsigns = {
	["helicopter"] = {
		[1] = "Dodge",
		[2] = "Ford",
		[3] = "Chevy",
		[4] = "Pontiac",
		[5] = "Dodge",
		[6] = "Ford",
		[7] = "Chevy",
		[8] = "Pontiac",
		[9] = "Chevy",
	},
	["plane"] = {
		[1] = "Enfield",
		[2] = "Springfield",
		[3] = "Uzi",
		[4] = "Colt",
		[5] = "Enfield",
		[6] = "Springfield",
		[7] = "Uzi",
		[8] = "Colt",
		[9] = "Enfield",
	},
}

local standardPlaneTypes = {
	["Bf-109K-4"] = {
		["type"] = "Bf-109K-4",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 296,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["MW50TankContents"] = 1,
			["Flare_Gun"] = 1,
		}, -- end of ["AddPropAircraft"]
	},	
	
	["FW-190A8"] = {
		["type"] = "FW-190A8",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 409,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["FW_MW50TankContents"] = 0,
		}, -- end of ["AddPropAircraft"]
	},		
	
	["FW-190D9"] = {
		["type"] = "FW-190D9",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 409,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["FW_MW50TankContents"] = 0,
		}, -- end of ["AddPropAircraft"]
	},		
	
	
	["I-16"] = {
		["type"] = "I-16",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 191,
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["landingTorch"] = false,
		}, -- end of ["AddPropAircraft"]
	},			
	
	
	["P-47D-30"] = {
		["type"] = "P-47D-30",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 676.704,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["WaterTankContents"] = 1,
		}, -- end of ["AddPropAircraft"]
	},			
	
	["P-47D-30bl1"] = {
		["type"] = "P-47D-30bl1",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 676.704,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["WaterTankContents"] = 1,
		}, -- end of ["AddPropAircraft"]
	},
	
	["P-47D-40"] = {
		["type"] = "P-47D-40",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 676.704,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["WaterTankContents"] = 1,
		}, -- end of ["AddPropAircraft"]
	},	
	
	["P-51D"] = {
		["type"] = "P-51D",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 497.76,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	},	
	
	["P-51D-30-NA"] = {
		["type"] = "P-51D-30-NA",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 497.76,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	},	

	
	["SpitfireLFMkIX"] = {
		["type"] = "SpitfireLFMkIX",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 247,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	},
	
	["SpitfireLFMkIXCW"] = {
		["type"] = "SpitfireLFMkIXCW",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 247,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	
	["MosquitoFBMkVI"] = {
		["type"] = "MosquitoFBMkVI",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 996.6432,
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["A-10A"] = {
		["type"] = "A-10A",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 120,
			["ammo_type"] = 1,
			["chaff"] = 240,
			["gun"] = 100,
		}, -- end of ["payload"]
	},
	["A-10C"] = {
		["type"] = "A-10C",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 120,
			["ammo_type"] = 1,
			["chaff"] = 240,
			["gun"] = 100,
		}, -- end of ["payload"]
	},
	["A-10C_2"] = {
		["type"] = "A-10C_2",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 120,
			["ammo_type"] = 1,
			["chaff"] = 240,
			["gun"] = 100,
		}, -- end of ["payload"]
	},
	["AJS37"] = {
		["type"] = "AJS37",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 72,
			["chaff"] = 210,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["Rb04GroupTarget"] = 3,
			["WeapSafeHeight"] = 1,
			["Rb04VinkelHopp"] = 0,
			["MissionGeneratorSetting"] = 0,
		}, -- end of ["AddPropAircraft"]
	},
	["AV8BNA"] = {
		["type"] = "AV8BNA",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 120,
			["chaff"] = 60,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["EWDispenserTBL"] = 2,
			["EWDispenserBR"] = 2,
			["AAR_Zone3"] = 0,
			["AAR_Zone2"] = 0,
			["EWDispenserTFR"] = 1,
			["AAR_Zone1"] = 0,
			["ClockTime"] = 1,
			["RocketBurst"] = 1,
			["LaserCode100"] = 6,
			["LaserCode1"] = 8,
			["EWDispenserTFL"] = 1,
			["EWDispenserBL"] = 2,
			["EWDispenserTBR"] = 2,
			["LaserCode10"] = 8,
			["MountNVG"] = false,
		}, -- end of ["AddPropAircraft"]
	},

	["C-101CC"] = {
		["type"] = "C-101CC",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["F-14A-135-GR"] = {
		["type"] = "F-14A-135-GR",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 60,
			["ammo_type"] = 1,
			["chaff"] = 140,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["F-14B"] = {
		["type"] = "F-14B",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 60,
			["ammo_type"] = 1,
			["chaff"] = 140,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["F-15C"] = {
		["type"] = "F-15C",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 60,
			["chaff"] = 120,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["F-16C_50"] = {
		["type"] = "F-16C_50",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 60,
			["ammo_type"] = 5,
			["chaff"] = 60,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["F-5E-3"] = {
		["type"] = "F-5E-3",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 15,
			["ammo_type"] = 2,
			["chaff"] = 30,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["FA-18C_hornet"] = {
		["type"] = "FA-18C_hornet",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 30,
			["ammo_type"] = 1,
			["chaff"] = 60,
			["gun"] = 100,
		}, -- end of ["payload"]
		["dataCartridge"] = 
		{
			["GroupsPoints"] = 
			{
				["PB"] = 
				{
				}, -- end of ["PB"]
				["Sequence 2 Red"] = 
				{
				}, -- end of ["Sequence 2 Red"]
				["Start Location"] = 
				{
				}, -- end of ["Start Location"]
				["Sequence 1 Blue"] = 
				{
				}, -- end of ["Sequence 1 Blue"]
				["Sequence 3 Yellow"] = 
				{
				}, -- end of ["Sequence 3 Yellow"]
				["A/A Waypoint"] = 
				{
				}, -- end of ["A/A Waypoint"]
				["PP"] = 
				{
				}, -- end of ["PP"]
				["Initial Point"] = 
				{
				}, -- end of ["Initial Point"]
			}, -- end of ["GroupsPoints"]
			["Points"] = 
			{
			}, -- end of ["Points"]
		}, -- end of ["dataCartridge"]
		["AddPropAircraft"] = 
		{
		}, -- end of ["AddPropAircraft"]
		["hardpoint_racks"] = true,
	},

	["JF-17"] = {
		["type"] = "JF-17",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 32,
			["chaff"] = 36,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
		}, -- end of ["AddPropAircraft"]
		["hardpoint_racks"] = true,
	},

	["L-39ZA"] = {
		["type"] = "L-39ZA",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["NS430allow"] = true,
			["SoloFlight"] = false,
		}, -- end of ["AddPropAircraft"]
		["hardpoint_racks"] = true,
	},

	["M-2000C"] = {
		["type"] = "M-2000C",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 16,
			["chaff"] = 112,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["ForceINSRules"] = false,
			["LaserCode100"] = 6,
			["NoDDMSensor"] = false,
			["LaserCode1"] = 8,
			["WpBullseye"] = 0,
			["LoadNVGCase"] = false,
			["RocketBurst"] = 6,
			["LaserCode10"] = 8,
			["GunBurst"] = 1,
		}, -- end of ["AddPropAircraft"]
		["hardpoint_racks"] = true,
	},

	["MiG-19P"] = {
		["type"] = "MiG-19P",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 0,
			["ammo_type"] = 1,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
		["AddPropAircraft"] = 
		{
			["MissileToneVolume"] = 5,
			["ADF_Selected_Frequency"] = 1,
			["MountSIRENA"] = false,
			["ADF_NEAR_Frequency"] = 303,
			["ADF_FAR_Frequency"] = 625,
			["NAV_Initial_Hdg"] = 0,
		}, -- end of ["AddPropAircraft"]
		["hardpoint_racks"] = true,
	},

	["MiG-21Bis"] = {
		["type"] = "MiG-21Bis",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 40,
			["ammo_type"] = 1,
			["chaff"] = 18,
			["gun"] = 100,
		}, -- end of ["payload"]
		["hardpoint_racks"] = true,
	},

	["J-11A"] = {
		["type"] = "J-11A",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 96,
			["chaff"] = 96,
			["gun"] = 100,
		}, -- end of ["payload"]
		["hardpoint_racks"] = true,
	},

	["MiG-29S"] = {
		["type"] = "MiG-29S",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["MiG-29A"] = {
		["type"] = "MiG-29A",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["Su-25T"] = {
		["type"] = "Su-25T",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 128,
			["chaff"] = 128,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["Su-27"] = {
		["type"] = "Su-27",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 48,
			["chaff"] = 48,
			["gun"] = 100,
		}, -- end of ["payload"]
	},

	["Su-33"] = {
		["type"] = "Su-33",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 48,
			["chaff"] = 48,
			["gun"] = 100,
		}, -- end of ["payload"]
	},
}

local standardHeloTypes = {
    ["Ka-50"] = {	
		["ropeLength"] = 15,
		["type"] = "Ka-50",
		["Radio"] = 
		{
			[1] = 
			{
				["modulations"] = 
				{
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[7] = 40,
					[1] = 21.5,
					[2] = 25.7,
					[4] = 28,
					[8] = 50,
					[9] = 55.5,
					[5] = 30,
					[10] = 59.9,
					[3] = 27,
					[6] = 32,
				}, -- end of ["channels"]
			}, -- end of [1]
			[2] = 
			{
				["modulations"] = 
				{
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[11] = 0.718,
					[13] = 0.583,
					[7] = 0.443,
					[1] = 0.625,
					[2] = 0.303,
					[15] = 0.995,
					[8] = 0.215,
					[16] = 1.21,
					[9] = 0.525,
					[5] = 0.408,
					[10] = 1.065,
					[14] = 0.283,
					[3] = 0.289,
					[6] = 0.803,
					[12] = 0.35,
					[4] = 0.591,
				}, -- end of ["channels"]
			}, -- end of [2]
		}, -- end of ["Radio"]
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0", -- "0"
			["flare"] = 128,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	}, -- end of [Ka-50]
	["Mi-8MT"] = 
	{
		["hardpoint_racks"] = true,
		["ropeLength"] = 15,
		["AddPropAircraft"] = 
		{
			["LeftEngineResource"] = 90,
			["RightEngineResource"] = 90,
			["NetCrewControlPriority"] = 1,
			["ExhaustScreen"] = true,
			["CargoHalfdoor"] = true,
			["GunnersAISkill"] = 90,
			["AdditionalArmor"] = true,
			["NS430allow"] = true,
		}, -- end of ["AddPropAircraft"]
		["type"] = "Mi-8MT",
		["Radio"] = 
		{
			[1] = 
			{
				["modulations"] = 
				{
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[1] = 127.5,
					[2] = 135,
					[4] = 127,
					[8] = 128,
					[16] = 132,
					[17] = 138,
					[9] = 126,
					[18] = 122,
					[5] = 125,
					[10] = 133,
					[20] = 137,
					[11] = 130,
					[3] = 136,
					[6] = 121,
					[12] = 129,
					[13] = 123,
					[7] = 141,
					[14] = 131,
					[15] = 134,
					[19] = 124,
				}, -- end of ["channels"]
			}, -- end of [1]
			[2] = 
			{
				["modulations"] = 
				{
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[7] = 40,
					[1] = 21.5,
					[2] = 25.7,
					[4] = 28,
					[8] = 50,
					[9] = 55.5,
					[5] = 30,
					[10] = 59.9,
					[3] = 27,
					[6] = 32,
				}, -- end of ["channels"]
			}, -- end of [2]
		}, -- end of ["Radio"]
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0",
			["flare"] = 128,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	}, -- end of [1]
	["UH-1H"] = 
	{
		["hardpoint_racks"] = true,
		["ropeLength"] = 15,
		["AddPropAircraft"] = 
		{
			["EngineResource"] = 90,
			["NetCrewControlPriority"] = 1,
			["GunnersAISkill"] = 90,
			["ExhaustScreen"] = true,
		}, -- end of ["AddPropAircraft"]
		["type"] = "UH-1H",
		["Radio"] = 
		{
			[1] = 
			{
				["modulations"] = 
				{
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[1] = 251,
					[2] = 264,
					[4] = 256,
					[8] = 257,
					[16] = 261,
					[17] = 267,
					[9] = 255,
					[18] = 251,
					[5] = 254,
					[10] = 262,
					[20] = 266,
					[11] = 259,
					[3] = 265,
					[6] = 250,
					[12] = 268,
					[13] = 269,
					[7] = 270,
					[14] = 260,
					[15] = 263,
					[19] = 253,
				}, -- end of ["channels"]
			}, -- end of [1]
		}, -- end of ["Radio"]
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = "0",
			["flare"] = 60,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	}, -- end of [1]
	["SA342L"] = 
	{	
		["hardpoint_racks"] = true,
		["ropeLength"] = 15,
		["type"] = "SA342L",
		["Radio"] = 
		{
			[1] = 
			{
				["modulations"] = 
				{
					[6] = 0,
					[2] = 0,
					[8] = 0,
					[3] = 0,
					[1] = 0,
					[4] = 0,
					[5] = 0,
					[7] = 0,
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[6] = 41,
					[2] = 31,
					[8] = 50,
					[3] = 32,
					[1] = 30,
					[4] = 33,
					[5] = 40,
					[7] = 42,
				}, -- end of ["channels"]
			}, -- end of [1]
		}, -- end of ["Radio"]
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 0,
			["flare"] = 32,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	}, -- end of [1]
	["SA342M"] = 
	{	
		["hardpoint_racks"] = true,
		["ropeLength"] = 15,
		["type"] = "SA342M",
		["Radio"] = 
		{
			[1] = 
			{
				["modulations"] = 
				{
					[6] = 0,
					[2] = 0,
					[8] = 0,
					[3] = 0,
					[1] = 0,
					[4] = 0,
					[5] = 0,
					[7] = 0,
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[6] = 41,
					[2] = 31,
					[8] = 50,
					[3] = 32,
					[1] = 30,
					[4] = 33,
					[5] = 40,
					[7] = 42,
				}, -- end of ["channels"]
			}, -- end of [1]
		}, -- end of ["Radio"]
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 0,
			["flare"] = 32,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	}, -- end of [1]
	["SA342Minigun"] = 
	{
		["hardpoint_racks"] = true,
		["ropeLength"] = 15,
		["type"] = "SA342Minigun",
		["Radio"] = 
		{
			[1] = 
			{
				["modulations"] = 
				{
					[6] = 0,
					[2] = 0,
					[8] = 0,
					[3] = 0,
					[1] = 0,
					[4] = 0,
					[5] = 0,
					[7] = 0,
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[6] = 41,
					[2] = 31,
					[8] = 50,
					[3] = 32,
					[1] = 30,
					[4] = 33,
					[5] = 40,
					[7] = 42,
				}, -- end of ["channels"]
			}, -- end of [1]
		}, -- end of ["Radio"]
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 0,
			["flare"] = 32,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	}, -- end of [1]
	["SA342Mistral"] = 
	{
		["hardpoint_racks"] = true,
		["ropeLength"] = 15,
		["type"] = "SA342Mistral",
		["Radio"] = 
		{
			[1] = 
			{
				["modulations"] = 
				{
					[6] = 0,
					[2] = 0,
					[8] = 0,
					[3] = 0,
					[1] = 0,
					[4] = 0,
					[5] = 0,
					[7] = 0,
				}, -- end of ["modulations"]
				["channels"] = 
				{
					[6] = 41,
					[2] = 31,
					[8] = 50,
					[3] = 32,
					[1] = 30,
					[4] = 33,
					[5] = 40,
					[7] = 42,
				}, -- end of ["channels"]
			}, -- end of [1]
		}, -- end of ["Radio"]
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 0,
			["flare"] = 32,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	}, -- end of [1]

	["Mi-24P"] = 
	{
		["ropeLength"] = 15,
		["AddPropAircraft"] = 
		{
			["SimplifiedAI"] = false,
			["ExhaustScreen"] = true,
			["GunnersAISkill"] = 90,
			["HideAngleBoxes"] = false,
			["NS430allow"] = true,
		}, -- end of ["AddPropAircraft"]
		["type"] = "Mi-24P",
		["payload"] = 
		{
			["pylons"] = 
			{
			}, -- end of ["pylons"]
			["fuel"] = 1701,
			["flare"] = 192,
			["chaff"] = 0,
			["gun"] = 100,
		}, -- end of ["payload"]
	}, -- end of [1]

}

local permitAll = false
if HOOK.SLOT_coa_var == "all" then
	permitAll = true
	HOOK.writeDebugDetail(ModuleName .. ": all coalition will create slots")
end

local heloSlot = false
if HOOK.SLOT_var == true then
	heloSlot = true
	HOOK.writeDebugDetail(ModuleName .. ": DSMC will create slots on heliport")
end

local airbaseSlot = false
if HOOK.SLOT_add_ab == true then
	airbaseSlot = true
	HOOK.writeDebugDetail(ModuleName .. ": DSMC will create slots on airbases")
end

--[[
function getCategoryParkingAirport(a_listP, uCat)
	local keepList = {}
	--HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a1")
	HOOK.writeDebugDetail(ModuleName .. ": getCategoryParkingAirport, category: " .. tostring(uCat) .. ", a_listP pre:" .. tostring(#a_listP))
    --local unitDesc = ME_DB.unit_by_type[uType]
    --HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a2")
    local HEIGHT = 0 -- unitDesc.height
    local WIDTH  = 0 -- unitDesc.wing_span or unitDesc.rotor_diameter
    local LENGTH = 0 --unitDesc.length
    --HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a3")
    for k, v in pairs(a_listP) do
        --print("------name---",v.name)
        --print("---type=",group.units[1].type,"--WIDTH=",WIDTH,"--LENGTH=",LENGTH,"--HEIGHT",HEIGHT)
        --print("---in terrain-----WIDTH=",v.params.WIDTH,"--LENGTH=",v.params.LENGTH,"--HEIGHT",v.params.HEIGHT,"---FOR_HELICOPTERS---",v.params.FOR_HELICOPTERS)
		if (not((WIDTH < v.params.WIDTH) 
                and (LENGTH < v.params.LENGTH)
                and (HEIGHT < (v.params.HEIGHT or 1000)))) 
			or ((uCat == 'helicopter') and (v.params.FOR_HELICOPTERS == 0))
            or ((uCat == 'plane') and (v.params.FOR_AIRPLANES == 0))    then
			table.insert(keepList, k)
			--HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a4")
		end
	end
	
	for k,v in pairs(keepList) do
		a_listP[tonumber(v)] = nil
	end
	--HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a5")
	HOOK.writeDebugDetail(ModuleName .. ": getCategoryParkingAirport, a_listP post:" .. tostring(#a_listP))
	return a_listP
end

function getRightParkingAirport(a_listP, uType, uCat)
	local keepList = {}
	--HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a1")
	HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a_listP pre:" .. tostring(#a_listP))
    local unitDesc = ME_DB.unit_by_type[uType]
    --HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a2")
    local HEIGHT = unitDesc.height
    local WIDTH  = unitDesc.wing_span or unitDesc.rotor_diameter
    local LENGTH = unitDesc.length
    --HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a3")
    for k, v in pairs(a_listP) do
        --print("------name---",v.name)
        --print("---type=",group.units[1].type,"--WIDTH=",WIDTH,"--LENGTH=",LENGTH,"--HEIGHT",HEIGHT)
        --print("---in terrain-----WIDTH=",v.params.WIDTH,"--LENGTH=",v.params.LENGTH,"--HEIGHT",v.params.HEIGHT,"---FOR_HELICOPTERS---",v.params.FOR_HELICOPTERS)
		if (not((WIDTH < v.params.WIDTH) 
                and (LENGTH < v.params.LENGTH)
                and (HEIGHT < (v.params.HEIGHT or 1000)))) 
			or ((uCat == 'helicopter') and (v.params.FOR_HELICOPTERS == 0))
            or ((uCat == 'plane') and (v.params.FOR_AIRPLANES == 0))    then
			table.insert(keepList, k)
			--HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a4")
		end
	end
	
	for k,v in pairs(keepList) do
		a_listP[tonumber(v)] = nil
	end
	--HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a5")
	HOOK.writeDebugDetail(ModuleName .. ": getRightParkingAirport, a_listP post:" .. tostring(#a_listP))
	return a_listP
end


function getFirstFreeParkingSpot(availParkList, parkListComplete)
	--HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot started")	
	HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot, parkListComplete pre:" .. tostring(#parkListComplete))

	if #parkListComplete > 0 then
		-- get latest park position
		local usedPname = nil
		local usedPx = nil
		local usedPy = nil
		local max_pId = 0
		--UTIL.dumpTable("availParkList.lua", availParkList)
		HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot 1")
		for pId, pData in pairs(availParkList) do
			--HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot c5")
			if pId > max_pId then
				--HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot c6")
				max_pId		= pId
				usedPname 	= pData.name
				usedPx	 	= pData.x
				usedPy	  	= pData.y
			end
		end
		
		HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot, usedPname: " .. tostring(usedPname) .. ", usedPx: " .. tostring(usedPx) .. ", usedPy: " .. tostring(usedPy))
		if usedPname and usedPx and usedPy then

			for pkId, pkData in pairs(parkListComplete) do		
				if pkData.name == usedPname then
					HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot deleting park: " .. tostring(usedPname))
					parkListComplete[pkId] = nil
				end
			end
			--HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot added used parking spot to " ..tostring(airportID) .. ", park num = " ..tostring(usedPname))
			HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot, parkListComplete post:" .. tostring(#parkListComplete))
			return usedPname, usedPx, usedPy, parkListComplete
		else
			--HOOK.writeDebugDetail(ModuleName .. ": getFirstFreeParkingSpot no parking available")	
			return false
		end
	else
		return false
	end
end
--]]--

function getParkingForAircraftType(a_listP, uType, uCat)
	local keepList = {}

	HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType starting, a_listP pre:" .. tostring(#a_listP))
    local unitDesc = ME_DB.unit_by_type[uType]

    local HEIGHT = unitDesc.height
    local WIDTH  = unitDesc.wing_span or unitDesc.rotor_diameter
    local LENGTH = unitDesc.length

    for k, v in pairs(a_listP) do
		if (not((WIDTH < v.params.WIDTH) 
                and (LENGTH < v.params.LENGTH)
                and (HEIGHT < (v.params.HEIGHT or 1000)))) 
			or ((uCat == 'helicopters') and (v.params.FOR_HELICOPTERS == 0)) -- MODIFICATO PER LEGGERE WH
            or ((uCat == 'planes') and (v.params.FOR_AIRPLANES == 0))    then -- MODIFICATO PER LEGGERE WH
			table.insert(keepList, k)

		end
	end
	
	for k,v in pairs(keepList) do
		a_listP[tonumber(v)] = nil
	end

	HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType, a_listP post type filter:" .. tostring(#a_listP))

	if #a_listP > 0 then
		-- get latest park position
		local usedPname = nil
		local usedPx = nil
		local usedPy = nil
		local max_pId = 0
		--UTIL.dumpTable("availParkList.lua", availParkList)
		for pId, pData in pairs(a_listP) do
			--HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType c5")
			if pId > max_pId then
				--HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType c6")
				max_pId		= pId
				usedPname 	= pData.name
				usedPx	 	= pData.x
				usedPy	  	= pData.y
			end
		end
		
		HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType, max_pId: " .. tostring(max_pId) .. ", usedPname: " .. tostring(usedPname) .. ", usedPx: " .. tostring(usedPx) .. ", usedPy: " .. tostring(usedPy))
		if usedPname and usedPx and usedPy then
			for pkId, pkData in pairs(a_listP) do		
				if pkData.name == usedPname then
					HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType deleting park: " .. tostring(usedPname))
					--table.insert(remList, pkId)
					--table.remove(a_listP, pkId)
					a_listP[pkId] = nil
				end
			end

			local revList = {}
			for k,v in pairs(a_listP) do
				revList[#revList+1] = v
			end

			--HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType added used parking spot to " ..tostring(airportID) .. ", park num = " ..tostring(usedPname))
			HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType, a_listP post:" .. tostring(#revList))
			return usedPname, usedPx, usedPy, revList
		else
			--HOOK.writeDebugDetail(ModuleName .. ": getParkingForAircraftType no parking available")	
			return false
		end
	else
		return false
	end
end

function createCallsign(country, category)

	local flightID = math.random(1,9)
	local groupID = math.random(1,9)
	local flightNum = flightID

	local wes = true
	if ME_U then
		if ME_U.isWesternCountry(country) then
			wes = true
		else
			wes = false
		end
	end

	if wes then
		for c, v in pairs(standardCallsigns) do
			if c == category then
				for x, d in pairs(v) do
					if x == flightID then
						flightName = d
					end
				end
			end
		end
	end

	local n = nil
	if wes then
		n = tostring(flightName .. tostring(groupID))
	else
		n = tonumber(tostring(flightNum .. tostring(groupID)))
	end

	HOOK.writeDebugDetail(ModuleName .. ": createCallsign creating callsign name: " .. tostring(n))


	local Cls = {
		[1] =  flightNum,
		[2] =  tonumber(groupID),
		["name"] = n,
	}
	
	return Cls, wes

end

function createHeloGroups(mission) -- , dictionary
	local maxG, maxU = setMaxId(mission)
	local MaxDict = mission.maxDictId

	if #tblSlots > 0 then
		HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, tblSlots entries: " .. tostring(#tblSlots))
		for sId, sData in pairs(tblSlots) do
			HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, checking slot: " .. tostring(sId))
			-- looking for right address to insert the group
			for coalitionID,coalition in pairs(mission["coalition"]) do
				if string.lower(sData.coaID) == string.lower(coalitionID) then
					HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, coalition found: " .. tostring(coalitionID))
					for countryID,country in pairs(coalition["country"]) do
						if sData.cntyID == country.id then			
							HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, country found: " .. tostring(country.name))

							local there_are_helos = false
							for attrID,attr in pairs(country) do
								if (type(attr)=="table") then
									if attrID == "helicopter" then
										HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, helicopter table found")
										there_are_helos = true
									end
								end
							end
						
							if there_are_helos == false then
								HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, helicopter table not found, creating...")
								country["helicopter"] = {}
								country["helicopter"]["group"] = {}
								HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, helicopter table created")
							end

							for attrID,attr in pairs(country) do
								if (type(attr)=="table") then
									if attrID == "helicopter" then
										if attr.group then
											
											-- ## ADDING GROUP!

											-- set first parking SLOTloaded
											local park = 0
											addedGroups = addedGroups + 1

											--[[ set name
											MaxDict = MaxDict+1
											local gDictEntry = "DictKey_GroupName_" .. MaxDict
											addedGroups = addedGroups + 1
											local gNameEntry = sData.acfType .. "_DSMC_" .. tostring(addedGroups)	
											dictionary[gDictEntry] = gNameEntry
											HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, adding gNameEntry: " .. tostring(gNameEntry))
											--]]--

											-- set id
											maxG = maxG + 1

											-- set route first point
											local wptData = {}

											HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, linkType: " .. tostring(sData.linkType))
											wptData.alt = 0
											wptData.x = sData.x
											wptData.y = sData.y
							
											-- set wptname to ""
											--DICTPROBLEM
											--MaxDict = MaxDict+1
											--local WptDictEntry = "DictKey_WptName_" .. MaxDict
											--dictionary[WptDictEntry] = ""
											wptData.name = "" -- WptDictEntry
											HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, wptData updated")

											-- wp action
											wptData.action = "From Parking Area"
											wptData.alt_type = "BARO"
											wptData.speed = 41.666666666667
											wptData.ETA = 0
											wptData.ETA_locked = true
											wptData.type = "TakeOffParking"
											wptData.formation_template = ""
											wptData.speed_locked = true
											wptData.properties = 	{
												["addopt"] = 
												{
												}, -- end of ["addopt"]
											} -- end of ["properties"]
											wptData.task = {
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = 
													{
													}, -- end of ["tasks"]
												}, -- end of ["params"]
											} -- end of ["task"]

											if sData.linkType == "Heliport" then
												wptData.linkUnit = sData.link
												wptData.helipadId = sData.link
												HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, heliport type found")
											elseif sData.linkType == "Airport" then
												wptData.airdromeId = sData.airdrome
												HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, airport type found")
											else
												HOOK.writeDebugBase(ModuleName .. ": createHeloGroups, linkType not found! error")
												return false
											end
											
											local groupTable = {

												["y"] = sData.y,
												["x"] = sData.x,
												--	["name"] = gDictEntry,
												["groupId"] = maxG,
												["route"] = 
												{
													["points"] = 
													{
														[1] = wptData, -- end of [1]
													}, -- end of ["points"]
												}, -- end of ["route"]

												--NON MODIFIED PART
												["modulation"] = 0,
												["tasks"] = 
												{
												}, -- end of ["tasks"]
												["radioSet"] = false,
												["task"] = "Nothing",
												["uncontrolled"] = false,
												["taskSelected"] = true,
												["hidden"] = false,
												["communication"] = true,
												["start_time"] = 0,
												["uncontrollable"] = false,
												["frequency"] = 124,
											}

											-- now check standard unit
											local unitData = {}
											local cls_group = ""

											local ctryControl = _(country.name)
											local cls_base, cls_western = createCallsign(ctryControl, attrID)

											for i=1, sData.numUnits do
												for acfId, acfData in pairs(standardHeloTypes) do
													if acfId == sData.acfType then
														local uTbl = {}

														maxU = maxU + 1
														HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups adding unit, maxId: " .. tostring(maxU))
														uTbl.unitId = maxU
												
														--[[ set unit name
														MaxDict = MaxDict+1									
														local UnitDictEntry = "DictKey_UnitName_" .. MaxDict
														addedunits = addedunits + 1
														dictionary[UnitDictEntry] = gNameEntry .. "_unit_" .. addedunits
														HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups adding unit, uname: " .. tostring(sData.acfType .. "_unit_" .. addedunits))
														uTbl.name = UnitDictEntry
														--]]--
														

														--set coordinates
														local ParkFARP = true
														
														if sData.linkType == "Airport" then -- NOT MORE NECESSARY
															for id, data in pairs(sData.parkings) do
																if id == i then
																	uTbl.x = data.px
																	uTbl.y = data.py
																	uTbl.parking = tostring(data.pname)
																	uTbl.parking_id = tostring(data.pname) --tostring(tonumber(data.pname) + 1)
																	ParkFARP = false
																	HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups adding unit, park: " .. tostring(uTbl.parking))
																end
															end		
														else
															uTbl.x = sData.x
															uTbl.y = sData.y
														end
														
														uTbl.heading = sData.h
												
														--set parking
														if ParkFARP then
															park = park + 1
															HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups adding unit, park: " .. tostring(park))
															uTbl.parking = tostring(park)
															uTbl.parking_id = nil -- DSMC_ possibile error?
														end

														--set livery
														uTbl.livery_id = nil  -- DSMC_ possibile error?
														
														--set skill
														uTbl.skill = "Client"

														--rev callsign
														local cls = UTIL.deepCopy(cls_base)
														cls[3] = tonumber(i)
														local n = cls["name"]
														if cls_western == true then
															cls["name"] = tostring(n) .. tostring(i)
														else
															cls["name"] = tonumber(tostring(n) .. tostring(i))
														end

														uTbl.callsign = cls

														-- set unit name
														--DICTPROBLEM
														--MaxDict = MaxDict+1									
														--local UnitDictEntry = "DictKey_UnitName_" .. MaxDict
														--addedunits = addedunits + 1
														--dictionary[UnitDictEntry] = tostring(revCls["name"])

														HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups adding unit, uname: " .. tostring(cls["name"]))
														uTbl.name = tostring(cls["name"]) -- UnitDictEntry

														-- retrieve from standard
														uTbl.alt = 0
														uTbl.alt_type = "BARO"
														uTbl.ropeLength = acfData.ropeLength
														uTbl.speed = 0 -- 41.666666666667
														uTbl.type = acfData.type
														uTbl.Radio = acfData.Radio
														uTbl.psi = 0	
														uTbl.payload = acfData.payload
														uTbl.onboard_num = "050"
														uTbl.dataCartridge = acfData.dataCartridge
														uTbl.hardpoint_racks = acfData.hardpoint_racks
														uTbl.AddPropAircraft = acfData.AddPropAircraft

														unitData[#unitData+1] = uTbl
													end
												end
											end

											-- set name
											--DICTPROBLEM
											--MaxDict = MaxDict+1
											--local gDictEntry = "DictKey_GroupName_" .. MaxDict
											if #unitData > 0 then

												local gNameEntry = tostring(tostring(cls_base["name"]) .. "_" .. sData.acfType .. "_DSMC_" .. tostring(addedGroups))
												--dictionary[gDictEntry] = gNameEntry
												HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups, adding gNameEntry: " .. tostring(gNameEntry))

												groupTable.name = gNameEntry -- gDictEntry
												groupTable.units = unitData

												attr.group[#attr.group+1] = groupTable
												HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups adding unit, group added")
												--UTIL.dumpTable("groupTable_" .. tostring(addedGroups) .. ".lua", groupTable)
											else
												HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups unable to add unit, skip")
											end
										end
									end
								end
							end
						end 
					end
				end
			end
		end
	else
		HOOK.writeDebugBase(ModuleName .. ": createHeloGroups error, no slots in tblSlots")
	end

	-- reset maxDictId
	mission.maxDictId = MaxDict

	HOOK.writeDebugDetail(ModuleName .. ": createHeloGroups function done")
	return mission --, dictionary

end

function createPlaneGroups(mission) -- CHECK THIS
	local maxG, maxU = setMaxId(mission)
	local MaxDict = mission.maxDictId

	if #tblSlots > 0 then
		HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, tblSlots entries: " .. tostring(#tblSlots))
		for sId, sData in pairs(tblSlots) do
			if sData.linkType == "Airport" then
				if sData.parkings and #sData.parkings > 1 then

					HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, checking slot: " .. tostring(sId))
					-- looking for right address to insert the group
					for coalitionID,coalition in pairs(mission["coalition"]) do
						if string.lower(sData.coaID) == string.lower(coalitionID) then
							HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, coalition found: " .. tostring(coalitionID))
							for countryID,country in pairs(coalition["country"]) do
								HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, sData.cntyID: " .. tostring(sData.cntyID) .. ", country.id: " .. tostring(country.id))
								if sData.cntyID == country.id then			
									HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, country found: " .. tostring(country.name))

									local there_are_planes = false
									for attrID,attr in pairs(country) do
										if (type(attr)=="table") then
											if attrID == "plane" then
												HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, plane table found")
												there_are_planes = true
											end
										end
									end
								
									if there_are_planes == false then
										HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, plane table not found, creating...")
										country["plane"] = {}
										country["plane"]["group"] = {}
										HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, plane table created")
									end

									for attrID,attr in pairs(country) do
										if (type(attr)=="table") then
											if attrID == "plane" then
												if attr.group then
													
													-- ## ADDING GROUP!

													-- set first parking SLOTloaded
													local park = 0
													addedGroups = addedGroups + 1

													--[[ set name
													MaxDict = MaxDict+1
													local gDictEntry = "DictKey_GroupName_" .. MaxDict
													addedGroups = addedGroups + 1
													local gNameEntry = sData.acfType .. "_DSMC_" .. tostring(addedGroups)	
													dictionary[gDictEntry] = gNameEntry
													HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, adding gNameEntry: " .. tostring(gNameEntry))
													--]]--

													-- set id
													maxG = maxG + 1

													-- set route first point
													local wptData = {}

													HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, linkType: " .. tostring(sData.linkType))
													wptData.alt = 0
													wptData.x = sData.x
													wptData.y = sData.y
									
													-- set wptname to ""
													--DICTPROBLEM
													--MaxDict = MaxDict+1
													--local WptDictEntry = "DictKey_WptName_" .. MaxDict
													--dictionary[WptDictEntry] = ""
													wptData.name = "" -- WptDictEntry
													HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, wptData updated")

													-- wp action
													wptData.action = "From Parking Area"
													wptData.alt_type = "BARO"
													wptData.speed = 41.666666666667
													wptData.ETA = 0
													wptData.ETA_locked = true
													wptData.type = "TakeOffParking"
													wptData.formation_template = ""
													wptData.speed_locked = true
													wptData.properties = 	{
														["addopt"] = 
														{
														}, -- end of ["addopt"]
													} -- end of ["properties"]
													wptData.task = {
														["id"] = "ComboTask",
														["params"] = 
														{
															["tasks"] = 
															{
															}, -- end of ["tasks"]
														}, -- end of ["params"]
													} -- end of ["task"]

													if sData.linkType == "Airport" then
														wptData.airdromeId = sData.airdrome
														HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, airport type found")
													else
														HOOK.writeDebugBase(ModuleName .. ": createPlaneGroups, airport not found! error")
														return false
													end
													
													local groupTable = {

														["y"] = sData.y,
														["x"] = sData.x,
														--	["name"] = gDictEntry,
														["groupId"] = maxG,
														["route"] = 
														{
															["points"] = 
															{
																[1] = wptData, -- end of [1]
															}, -- end of ["points"]
														}, -- end of ["route"]

														--NON MODIFIED PART
														["modulation"] = 0,
														["tasks"] = 
														{
														}, -- end of ["tasks"]
														["radioSet"] = false,
														["task"] = "Nothing",
														["uncontrolled"] = false,
														["taskSelected"] = true,
														["hidden"] = false,
														["communication"] = true,
														["start_time"] = 0,
														["uncontrollable"] = false,
														["frequency"] = 124,
													}

													-- now check standard unit
													local unitData = {}

													local cls_group = ""

													local ctryControl = _(country.name)
													local cls_base, cls_western = createCallsign(ctryControl, attrID)

													for i=1, sData.numUnits do
														for acfId, acfData in pairs(standardPlaneTypes) do
															if acfId == sData.acfType then
																local uTbl = {}

																maxU = maxU + 1
																HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups adding unit, maxId: " .. tostring(maxU))
																uTbl.unitId = maxU
														
																--[[ set unit name
																MaxDict = MaxDict+1									
																local UnitDictEntry = "DictKey_UnitName_" .. MaxDict
																addedunits = addedunits + 1
																dictionary[UnitDictEntry] = gNameEntry .. "_unit_" .. addedunits
																HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups adding unit, uname: " .. tostring(sData.acfType .. "_unit_" .. addedunits))
																uTbl.name = UnitDictEntry
																--]]--

																--ParkFARP = true
																
																if sData.linkType == "Airport" then
																	for id, data in pairs(sData.parkings) do
																		if id == i then
																			uTbl.x = data.px
																			uTbl.y = data.py
																			uTbl.parking = tostring(data.pname)
																			uTbl.parking_id = tostring(data.pname) --tostring(tonumber(data.pname) + 1)
																			ParkFARP = false
																			HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups adding unit, park: " .. tostring(uTbl.parking))
																		end
																	end		
																else
																	HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups error on airport linktype")
																	return false
																end
																
																uTbl.heading = sData.h
														
																--[[set parking
																if ParkFARP then
																	park = park + 1
																	HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups adding unit, park: " .. tostring(park))
																	uTbl.parking = tostring(park)
																	uTbl.parking_id = nil -- DSMC_ possibile error?
																end
																--]]--

																--set livery
																uTbl.livery_id = nil  -- DSMC_ possibile error?
																
																--set skill
																uTbl.skill = "Client"

																--rev callsign
																local cls = UTIL.deepCopy(cls_base)
																cls[3] = tonumber(i)
																local n = cls["name"]
																if cls_western == true then
																	cls["name"] = tostring(n) .. tostring(i)
																else
																	cls["name"] = tonumber(tostring(n) .. tostring(i))
																end


																uTbl.callsign = cls
													
																-- set unit name
																--DICTPROBLEM
																--MaxDict = MaxDict+1									
																--local UnitDictEntry = "DictKey_UnitName_" .. MaxDict
																--addedunits = addedunits + 1
																--dictionary[UnitDictEntry] = tostring(revCls["name"])

																HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups adding unit, uname: " .. tostring(cls["name"]))
																uTbl.name = tostring(cls["name"]) -- UnitDictEntry

																-- retrieve from standard
																uTbl.alt = 0
																uTbl.alt_type = "BARO"
																--uTbl.ropeLength = acfData.ropeLength
																uTbl.speed = 0 -- 41.666666666667
																uTbl.type = acfData.type
																uTbl.Radio = acfData.Radio
																uTbl.psi = 0	
																uTbl.payload = acfData.payload
																uTbl.onboard_num = "010"
																uTbl.dataCartridge = acfData.dataCartridge
																uTbl.hardpoint_racks = acfData.hardpoint_racks
																uTbl.AddPropAircraft = acfData.AddPropAircraft

																unitData[#unitData+1] = uTbl
															end
														end
													end

													if #unitData > 0 then
														-- set name
														--DICTPROBLEM
														--MaxDict = MaxDict+1
														--local gDictEntry = "DictKey_GroupName_" .. MaxDict
														local gNameEntry = tostring(tostring(cls_base["name"]) .. "_" .. sData.acfType .. "_DSMC_" .. tostring(addedGroups))
														--dictionary[gDictEntry] = gNameEntry
														HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups, adding gNameEntry: " .. tostring(gNameEntry))

														groupTable.name = gNameEntry -- gDictEntry
														groupTable.units = unitData

														attr.group[#attr.group+1] = groupTable
														HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups adding unit, group added")
														--UTIL.dumpTable("groupTable_" .. tostring(addedGroups) .. ".lua", groupTable)
													else
														HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups unable to add unit, skip")
													end
												end
											end
										end
									end
								end 
							end
						end
					end

				else
					HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups skips, table parks is not 2 or nil")
				end
			else
				--if sData.linkType == "Airport" then
				HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups skips, it's not airport slots")
			end

		end
	else
		HOOK.writeDebugBase(ModuleName .. ": createPlaneGroups error, no slots in tblSlots")
	end

	-- reset maxDictId
	mission.maxDictId = MaxDict

	HOOK.writeDebugDetail(ModuleName .. ": createPlaneGroups function done")
	return mission --, dictionary

end

-- set maxId number
function setMaxId(mixfile)
	local curvalG = 0
	local curvalU = 0
	for coalitionID,coalition in pairs(mixfile["coalition"]) do
		for countryID,country in pairs(coalition["country"]) do
			for attrID,attr in pairs(country) do
				if (type(attr)=="table") then		
					for groupID,group in pairs(attr["group"]) do
						if (group) then
							if group.groupId then
								if curvalG < group.groupId then
									curvalG = group.groupId
								end
							end

							for unitID,unit in pairs(group["units"]) do
								if unit.unitId then
									if curvalU < unit.unitId then
										curvalU = unit.unitId
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if curvalG > 0 and curvalU > 0 then
		return curvalG, curvalU
	else
		HOOK.writeDebugBase(ModuleName .. ": setMaxId failed to get id results")
		return nil
	end
end

-- MAIN FUNCTION TO LAUNCH

function cleanSlots(missionEnv, warehouseEnv)

	-- add here separation between helos with the options active or airbase with options & unlimited.
	for coalitionID,coalition in pairs(missionEnv["coalition"]) do
		for countryID,country in pairs(coalition["country"]) do
			HOOK.writeDebugDetail(ModuleName .. ": cleanSlots, removing slots for: " .. tostring(country.name))
			for attrID,attr in pairs(country) do
				if (type(attr)=="table") then

					if attrID == "helicopter" or attrID == "plane" then
						if attr["group"] and type(attr["group"]) == "table" then
							for groupID, group in pairs(attr["group"]) do
								if (group) then	

									--HOOK.writeDebugDetail(ModuleName .. ": cleanSlots. checking groupId: " .. tostring(group.groupId))

									local isUser = false
									for _, unit in pairs(group["units"]) do
										if unit.skill == "Client" or unit.skill == "Player" then
											isUser = true
											HOOK.writeDebugDetail(ModuleName .. ": cleanSlots is a client or player. type: " .. tostring(unit.type))
										end
									end

									if isUser == true then
										for pId, pData in pairs(group["route"]["points"]) do
											if pId == 1 then
												if pData.airdromeId then
													if airbaseSlot == true then
														for afbType, afbIds in pairs(warehouseEnv) do
															if afbType == "airports" then
																for afbId, afbData in pairs(afbIds) do
																	if afbData.unlimitedAircrafts == false then
																		--HOOK.writeDebugDetail(ModuleName .. ": cleanSlots, airports: " .. tostring(afbId) .. " is limited")
																		if tonumber(pData.airdromeId) == tonumber(afbId) then	
																			HOOK.writeDebugDetail(ModuleName .. ": cleanSlots. airbaseSlot is true, removing slots. Check: " .. tostring(airbaseSlot))				
																			attr["group"][groupID]= nil
																			HOOK.writeDebugDetail(ModuleName .. ": cleanSlots. it's linked to helipad, static removing, pData.airdromeId: " .. tostring(pData.airdromeId))
																		end
																	end
																end
															end
														end
													end
												elseif pData.helipadId then
													if heloSlot == true then
														for afbType, afbIds in pairs(warehouseEnv) do
															if afbType == "warehouses" then
																for afbId, afbData in pairs(afbIds) do
																	if afbData.unlimitedAircrafts == false then
																		--HOOK.writeDebugDetail(ModuleName .. ": cleanSlots, warehouses: " .. tostring(afbId) .. " is limited")
																		if tonumber(pData.helipadId) == tonumber(afbId) then	

																			--check is static
																			local isStatic = false
																			for cID,c in pairs(missionEnv["coalition"]) do
																				for crId,cr in pairs(c["country"]) do
																					HOOK.writeDebugDetail(ModuleName .. ": cleanSlots, removing slots for: " .. tostring(cr.name))
																					for aID,a in pairs(cr) do
																						if (type(a)=="table") then
																							if aID == "static" then
																								for gID, g in pairs(a["group"]) do
																									if (g) then	
																										if a["group"] and type(a["group"]) == "table" then
																											for _, u in pairs(g["units"]) do
																												if tonumber(u.unitId) == tonumber(afbId) then
																													isStatic = true
																													HOOK.writeDebugDetail(ModuleName .. ": cleanSlots is a static. type: " .. tostring(u.type))
																												end
																											end
																										end
																									end
																								end
																							end
																						end
																					end
																				end
																			end

																			if isStatic == true then
																				HOOK.writeDebugDetail(ModuleName .. ": cleanSlots. isStatic is true, removing slots. Check: " .. tostring(heloSlot))				
																				attr["group"][groupID]= nil
																				HOOK.writeDebugDetail(ModuleName .. ": cleanSlots. it's linked to helipad, removing, pData.helipadId: " .. tostring(pData.helipadId))
																			else
																				HOOK.writeDebugDetail(ModuleName .. ": cleanSlots. isStatic is false, skipping")		
																			end
																		end
																	end
																end
															end
														end														
													end
												end
											end
										end
									end
								end
							end
						end

						-- check void groups
						if table.getn(attr["group"]) < 1 then -- next(attr.group) == nil
							HOOK.writeDebugDetail(ModuleName .. ": cleanSlots killing category no more groups")
							--table.remove(country, attrID)											
							attr["group"] = nil
							country[attrID] = nil
							HOOK.writeDebugDetail(ModuleName .. ": cleanSlots killed category no more groups")
						end
					end
				end
			end
		end
	end

	HOOK.writeDebugDetail(ModuleName .. ": cleanSlots cycle done")
	return missionEnv
end

function checkParkings(missionEnv, airbaseTbl)
	local tblPrksRemove = {}
	local AIslots = {}

	-- collect parkings
	for coalitionID,coalition in pairs(missionEnv["coalition"]) do
		for countryID,country in pairs(coalition["country"]) do
			for attrID,attr in pairs(country) do
				if (type(attr)=="table") then
					if attr["group"] and type(attr["group"]) == "table" then
						for groupID,group in pairs(attr["group"]) do
							if (group) then	
								local afbId = nil
								for pId, pData in pairs(group.route.points) do
									if pId == 1 then
										if pData.airdromeId then
											HOOK.writeDebugDetail(ModuleName .. ": checkParkings found group on airport. Airport: " .. tostring(pData.airdromeId) .. ", group: " .. tostring(group.name))
											afbId = pData.airdromeId
										end

									end
								end
								
								if afbId then
									for _, unit in pairs(group["units"]) do
										if unit.parking and unit.parking_id then
											HOOK.writeDebugDetail(ModuleName .. ": checkParkings removing park. Airport: " .. tostring(afbId) .. ", park: " .. tostring(unit.parking_id))
											tblPrksRemove[#tblPrksRemove+1] = {abId = afbId, prId = tostring(unit.parking_id), parDef = tostring(unit.parking), uType = unit.type}
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	-- remove parkings
	if #tblPrksRemove > 0 then
		UTIL.dumpTable("tblPrksRemove.lua", tblPrksRemove)
		HOOK.writeDebugDetail(ModuleName .. ": checkParkings tblPrksRemove has entries, n: " .. tostring(#tblPrksRemove))
		for pId, pData in pairs(tblPrksRemove) do
			for afId, afData in pairs(airbaseTbl) do
				if tonumber(pData.abId) == tonumber(afData.index) then
					for pkId, pkData in pairs(afData.parkings) do 
						if tostring(pData.prId) == tostring(pkData.name) then
							HOOK.writeDebugDetail(ModuleName .. ": checkParkings removing using park: " .. tostring(#pkData.name) .. ", in " .. tostring(afData.name))
							if pkData.params.FOR_HELICOPTERS == 1 then
								afData.rw_parkNum = afData.rw_parkNum - 1
							end
							if pkData.params.FOR_AIRPLANES == 1 then
								afData.fw_parkNum = afData.fw_parkNum - 1
							end

							afData.parkings[pkId] = nil
						end
					end

					local revTbl = {}
					for _, data in pairs(afData.parkings) do
						revTbl[#revTbl+1] = data
					end

					afData.parkings = revTbl

				end
			end
		end



	else
		HOOK.writeDebugDetail(ModuleName .. ": checkParkings tblPrksRemove is void, skip & close")
	end

	return airbaseTbl, tblPrksRemove
end

function buildHelipadSlot(missionEnv, warehouseEnv, tblSlots)
	for afbType, afbIds in pairs(warehouseEnv) do
		if afbType == "warehouses" then
			for afbId, afbData in pairs(afbIds) do
				HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, checking heliport: " .. tostring(afbId))

				if afbData.unlimitedAircrafts == false then
					HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, heliport is limited, adding slots")

					--local alt_val = 0
					local heading_val = nil
					local x_val = nil
					local y_val = nil
					local link_val = nil
					local link_type_val = nil
					local coa = afbData.coalition
					--HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, heliport: " .. tostring(afbId) .. ", coa:" ..tostring(coa))

					for coalitionID,coalition in pairs(missionEnv["coalition"]) do
						if coalitionID == HOOK.SLOT_coa_var or permitAll == true then
							--if string.lower(coa) == string.lower(coalitionID) then
								--HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, heliport: " .. tostring(afbId) .. ", c1")
								for countryID,country in pairs(coalition["country"]) do
									for attrID,attr in pairs(country) do
										if (type(attr)=="table") then		
											if attrID == "static" then
												for groupID,group in pairs(attr["group"]) do
													if (group) then
														for unitID,unit in pairs(group["units"]) do
															--HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, heliport: " .. tostring(afbId) .. ", c2 unit id: " .. tostring(unit.unitId))
															if tonumber(unit.unitId) == tonumber(afbId) then
																-- correct coalition
																if string.lower(coa) ~= string.lower(coalitionID) then
																	afbData.coalition = string.lower(coalitionID)
																	coa = string.lower(coalitionID)
																	HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, coalition has been fixed: " .. tostring(unit.unitId))
																end

																if coa ~= "NEUTRAL" and coa ~= "neutrals" then
																	-- proceed
																	HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, found unit.unitId-heliport: " .. tostring(unit.unitId))
																	
																	heading_val = unit.heading
																	x_val = unit.x
																	y_val = unit.y
																	link_val = unit.unitId
																	if unit.category == "Heliports" then
																		link_type_val = "Heliport"
																	end

																	local grNum = #group["units"]
																	local posTbl = {}
																	if grNum > 1 then
																		for _, uData in pairs(group["units"]) do
																			posTbl[#posTbl+1] = {x = uData.x, y = uData.x, l = uData.unitId, t = link_type_val}
																		end
																	end

																	if heading_val and x_val and y_val and link_val and coa and link_type_val then
																		HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, heliport check values is ok")
																		for catId, catData in pairs(afbData.aircrafts) do
																			if catId == "helicopters" then
																				for acfId, acfData in pairs(catData) do
																					for aId, aData in pairs(standardHeloTypes) do
																						--HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, acfId: " .. tostring(acfId) .. ", aId:" .. tostring(aId))
																						if acfId == aId then
																							local numberFlights = math.floor(acfData.initialAmount/2)

																							HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, acfId: " .. tostring(acfId) .. ", numberFlights: " .. tostring(numberFlights))
																							local nUnits = nil
																							local nGroups = 0
																							
																							if numberFlights > 0 and numberFlights < 1 then  -- single ship
																								nUnits = 1
																								nGroups = 1
																								--HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, adding " .. tostring(acfId) .. " on helipad " .. tostring(yId))
																								--tblSlots[#tblSlots+1] = {h= heading_val, x=x_val, y = y_val, link = link_val, linkType = link_type_val, cntyID = country.id, coaID = coa, acfType = acfId, numUnits = 1}
																								HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, creating 1 group, single ship")
																							elseif numberFlights == 1 then -- two ship
																								nUnits = 2
																								nGroups = 1
																								
																								--tblSlots[#tblSlots+1] = {h= heading_val, x=x_val, y = y_val, link = link_val, linkType = link_type_val, cntyID = country.id, coaID = coa, acfType = acfId, numUnits = 2}
																								HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, creating 1 group, 2ship")																							
																							elseif numberFlights < 2 and numberFlights > 1 then -- three ship
																								nUnits = 3
																								nGroups = 1
																								
																								--tblSlots[#tblSlots+1] = {h= heading_val, x=x_val, y = y_val, link = link_val, linkType = link_type_val, cntyID = country.id, coaID = coa, acfType = acfId, numUnits = 3}
																								HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, creating 1 group, 3ship")
																							elseif numberFlights >= 2 then -- 2x two ship
																								if numberFlights > maxFlights then
																									HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, numberFlights " .. tostring(numberFlights) .. " exceeded maxFlights, reducing to " .. tostring(maxFlights))
																									numberFlights = maxFlights
																								end
																						
																								nGroups = math.floor(numberFlights)
																								nUnits = 2

																								HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, creating " .. tostring(nGroups) .. " groups , 2 ships each")
																							else
																								HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, numberFlights is " .. tostring(numberFlights)  .. ": no availability for " .. tostring(acfId))
																							end

																							if #posTbl > 1 and nGroups > 0 then
																								HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, heliport is multi unit, adding all helo types on different helipad")
																								local currId = 1
																								
																								for i=1, nGroups do
																									for yId, yData in pairs(posTbl) do
																										if yId == currId then
																											tblSlots[#tblSlots+1] = {h= heading_val, x= yData.x, y = yData.y, link = yData.l, linkType = yData.t, cntyID = country.id, coaID = coa, acfType = acfId, numUnits = nUnits}
																											currId = currId + 1
																											if currId > #posTbl then
																												currId = 1
																											end
																										end
																									end	
																								end

																							elseif nGroups > 0 then
																								HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, heliport is single unit, adding on single helipad")
																								for i=1, nGroups do
																									HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, creating group i: " .. tostring(i) .. ", 2 ships")
																									tblSlots[#tblSlots+1] = {h= heading_val, x=x_val, y = y_val, link = link_val, linkType = link_type_val, cntyID = country.id, coaID = coa, acfType = acfId, numUnits = nUnits}
																								end
																							end
																						end
																					end
																				end
																			end
																		end
																	end

																end
															end
														end
													end
												end
											end
										end
									end
								end
							--end
						end
					end
				else
					HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, heliport is unlimited, skip")
				end
			end
		end
	end

	HOOK.writeDebugDetail(ModuleName .. ": buildHelipadSlot, loop done")
end

function buildAirbaseSlot(missionEnv, warehouseEnv, airbaseTbl, tblSlots, usedParkTbl)
	
	--check used parkings, removing items used by AI
	local whTbl = UTIL.deepCopy(warehouseEnv)

	-- this part checks for items in the wh and dimisish the item quantity based on the AI aircraft in the mission (clients have been removed before or base is unlimited)
	for jId, jData in pairs(usedParkTbl) do
		for afbType, afbIds in pairs(whTbl) do
			if afbType == "airports" then
				for afbId, afbData in pairs(afbIds) do	
					if tonumber(afbId) == tonumber(jData.abId) then
						if afbData.unlimitedAircrafts == false then
							for acfCat, acfTbl in pairs(afbData.aircrafts) do
								for acfName, acfData in pairs(acfTbl) do					
									if acfName == jData.uType then
										HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, AI used item, removing 1 " .. tostring(acfName) .. ", cur num = " .. tostring(acfData.initialAmount))
										acfData.initialAmount = acfData.initialAmount - 1
										if acfData.initialAmount < 0 then
											acfData.initialAmount = 0
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	-- built slot
	for afbType, afbIds in pairs(whTbl) do
		if afbType == "airports" then
			for afbId, afbData in pairs(afbIds) do
				if string.lower(afbData.coalition) == string.lower(HOOK.SLOT_coa_var) or permitAll == true then
					if string.lower(afbData.coalition) ~= "neutral" and string.lower(afbData.coalition) ~= "neutrals" then -- neutral don't create acf

						HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, checking airport: " .. tostring(afbId))

						if afbData.unlimitedAircrafts == false then
							HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, unlimitedAircrafts: " .. tostring(afbData.unlimitedAircrafts))
							
							-- rebuilt parking Table with categories
							local slotsToBuilt = {}

							-- reIndex parking
							local parking_tbl = {}
							for _, aData in pairs(airbaseTbl) do 
								if tonumber(aData.index) == tonumber(afbId) then
									if aData.parkings then
										if #aData.parkings > 0 then
											-- reindex parking to make an array
											for _, pData in pairs(aData.parkings) do
												parking_tbl[#parking_tbl+1] = pData
											end																
											HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, identified: " .. tostring(#parking_tbl) .. " free parkings")
										end
									end
								end
							end
							--UTIL.dumpTable("parking_tbl.lua", parking_tbl)

							if #parking_tbl > 0 then				
								for acfCat, acfTbl in pairs(afbData.aircrafts) do
									--if acfCat == "planes" then
										for acfName, acfData in pairs(acfTbl) do
											--HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, new plane check for : " .. tostring(acfName) .. ", parkings: " .. tostring(#parking_tbl))
											if #parking_tbl > 0 then
												if acfData.initialAmount > 1 then -- filtering at least 2 acf for 1 flight
													
													local isFlyable = false
													for pName, pData in pairs(standardPlaneTypes) do
														if pName == acfName	then
															HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, found plane: " .. tostring(acfName))
															isFlyable = true
														end				
													end

													for pName, pData in pairs(standardHeloTypes) do
														if pName == acfName	then
															HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, found helicopter: " .. tostring(acfName))
															isFlyable = true
														end				
													end

													if isFlyable then
														HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, found flyable: " .. tostring(acfData.initialAmount) .. " " .. tostring(acfName))
														
														local numGroups = math.floor(acfData.initialAmount/2)
														if numGroups > maxFlights then
															HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, reducing numGroups from: " .. tostring(numGroups) .. " to " .. tostring(maxFlights))
															numGroups = maxFlights
														end													
														
														-- update slotsToBuilt
														for r=1, numGroups do
															local assignedParkings = {}
															for i=1, 2 do
																local usedPname, usedPx, usedPy, revPark_tbl = getParkingForAircraftType(parking_tbl, acfName, acfCat)
																if usedPname and usedPx and usedPy then
																	assignedParkings[#assignedParkings+1] = {pname = usedPname, px = usedPx, py = usedPy}
																	parking_tbl = revPark_tbl
																end
															end

															if #assignedParkings > 1 then
																HOOK.writeDebugDetail(ModuleName .. ": buildAirbaseSlot, found 2 parkings for " .. tostring(acfName) .. ", parking left: " .. tostring(#parking_tbl))
																slotsToBuilt[#slotsToBuilt+1] = {acf = acfName, prk = assignedParkings}
															else
																HOOK.writeDebugDetail(ModuleName .. ": no sufficient parkings assigned: " .. tostring(#assignedParkings)) 
															end
														end
													end
												end
											else

											end
										end
									--end
								end
							end

							if #slotsToBuilt > 0 then
								--UTIL.dumpTable("slotsToBuilt.lua", slotsToBuilt)
								
								-- define base data
								local choose_coa = nil
								local choose_ctry = nil
								local coa = string.lower(afbData.coalition)
								for coalitionID, coalition in pairs(missionEnv["coalition"]) do
									if string.lower(coa) == string.lower(coalitionID) then
										choose_coa = coalitionID
										local minCx = 100000
										for _,country in pairs(coalition["country"]) do																		
											if country.id < minCx then
												minCx = country.id
												choose_ctry = country.id
											end
										end
									end
								end	


								for sId, sData in pairs(slotsToBuilt) do
									local x_val = nil
									local y_val = nil

									for pId, pData in pairs(sData.prk) do
										x_val = pData.px
										y_val = pData.py
									end

									if x_val and y_val and choose_coa then
										if #sData.prk > 1 then
											HOOK.writeDebugDetail(ModuleName .. ": addSlot, adding 2 slots of " .. tostring(sData.acf))
											tblSlots[#tblSlots+1] = {h= 0, x=x_val, y = y_val, airdrome = afbId, linkType = "Airport", parkings = sData.prk, cntyID = choose_ctry, coaID = choose_coa, acfType = sData.acf, numUnits = 2}
										else
											HOOK.writeDebugDetail(ModuleName .. ": addSlot, prk is less than 2")
										end
									else
										HOOK.writeDebugDetail(ModuleName .. ": addSlot, missed x_val and y_val")
									end
								end
							end
						else
							HOOK.writeDebugBase(ModuleName .. ": buildAirbaseSlot, unlimitedAircrafts: " .. tostring(afbData.unlimitedAircrafts) .. ", skipping creation process")
						end
					end
				end
			end
		end
	end
end


function addSlot(m, w) --, dictEnv

	-- clean all helos slot!
	local a = UTIL.deepCopy(tblAirbases)
	local m = cleanSlots(m, w)
	local a, p = checkParkings(m, a)

	addedGroups = 0
	addedunits = 0
	tblSlots = {}

	-- function buildHelipadSlot(missionEnv, warehouseEnv, tblSlots)
	if heloSlot then
		buildHelipadSlot(m, w, tblSlots)
		UTIL.dumpTable("tblSlots_heliport.lua", tblSlots)
	end

	if airbaseSlot then
		buildAirbaseSlot(m, w, a, tblSlots, p)
		UTIL.dumpTable("tblSlots_airbase.lua", tblSlots)
	end

	if tblSlots then
		if table.getn(tblSlots) > 0 then
			UTIL.dumpTable("tblSlots.lua", tblSlots)
			local m = createPlaneGroups(m) -- , dictEnv -- , newdict
			local m = createHeloGroups(m) -- , dictEnv -- , newdict
			if m then -- and newdict
				missionEnv = m
				--dictEnv = newdict
				HOOK.writeDebugDetail(ModuleName .. ": everything ok")
			else
				HOOK.writeDebugBase(ModuleName .. ": addSlot, error in createHeloGroups")
			end
		end
	end
end


HOOK.writeDebugBase(ModuleName .. ": Loaded " .. MainVersion .. "." .. SubVersion .. "." .. Build .. ", released " .. Date)
SLOTloaded = true
