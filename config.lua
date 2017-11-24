Config = {}

Config.AANPRD_Version = 0.1

Config.AANPRD_ScanningDistance = 70.0 -- AANPRD scanning distance (Metres)
Config.AANPRD_ScanningInterval = 1 -- AANPRD will scan for a vehicle every x seconds (0.5 is also applicable, 0 for live scanning)
Config.AANPRD_UnitOfSpeed = 1 -- 1 = MPH, 2 = KMH 

-- Vehicles allowed to use AANPRD
Config.AANPRD_Vehicles = List {
	'police',
	'police2',
	'police3',
	'police4',
	-- 'policeb', -- Police Bike
	-- 'policet', -- Police Transporter
}