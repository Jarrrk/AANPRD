-- Use Later
	-- PED::_CAN_PED_SEE_PED
	-- PLAYER::REPORT_CRIME

inPersuit = false
lastHitVehicle = nil

KeyClose = 177
GUIEnabled = false
NuiHasFocus = false

function EnableGUI(state)
	if state then
		SetNuiFocus(true)
		GUIEnabled = true
		NuiHasFocus = true

		SendNUIMessage({
			AANPRD_ACTIVE = true
		})
	elseif not state then
		SetNuiFocus(false)

		GUIEnabled = false
		NuiHasFocus = false

		SendNUIMessage({
			AANPRD_ACTIVE = false
		})
	end
end

function CheckGUI()
	DisableControlAction(0, 1, GUIEnabled) -- LookLeftRight
	DisableControlAction(0, 2, GUIEnabled) -- LookUpDown

	DisableControlAction(0, 142, GUIEnabled) -- MeleeAttackAlternate

	DisableControlAction(0, 106, GUIEnabled) -- VehicleMouseControlOverride

	if not GUIEnabled then

		EnableControlAction(0, 1, not GUIEnabled) -- LookLeftRight
		EnableControlAction(0, 2, not GUIEnabled) -- LookUpDown

		EnableControlAction(0, 142, not GUIEnabled) -- MeleeAttackAlternate

		EnableControlAction(0, 106, not GUIEnabled) -- VehicleMouseControlOverride
	end

	if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
		SendNUIMessage({
			eventType = 'click'
		})
	end
end

function GetVehicleInfrontOfEntity(vehicle)
	local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.0, 0.3)
	local coords2 = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, Config.AANPRD_ScanningDistance, 0.0)
	
	local rayhandle = CastRayPointToPoint(coords, coords2, 10, vehicle, 0)
	
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	
	if entityHit > 0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function GetEntityConvertedSpeed(entity)
	if DoesEntityExist(entity) then
		if Config.AANPRD_UnitOfSpeed == 1 then
			return (GetEntitySpeed(entity) * 2.236936) -- MPH
		else
			return (GetEntitySpeed(entity) * 3.6) -- KMH
		end
	end
end

function GetEntityDirection(entity)
	if DoesEntityExist(entity) then
		local entityHeading = GetEntityHeading(entity)

		if entityHeading then
			-- North
			if entityHeading > 0 and entityHeading < 22.5 then
				return {"N", "North"}
			end

			-- North East
			if entityHeading > 22.5 and entityHeading < 67.5 then
				return {"NE", "North East"}
			end

			-- East
			if entityHeading > 67.5 and entityHeading < 112.5 then
				return {"E", "East"}
			end

			-- South East
			if entityHeading > 112.5 and entityHeading < 157.5 then
				return {"SE", "South East"}
			end

			-- South
			if entityHeading > 157.5 and entityHeading < 202.5 then
				return {"S", "South"}
			end

			-- South West
			if entityHeading > 202.5 and entityHeading < 247.5 then
				return {"SW", "South West"}
			end

			-- West
			if entityHeading > 247.5 and entityHeading < 292.5 then
				return {"W", "West"}
			end

			-- North West
			if entityHeading > 292.5 and entityHeading < 337.5 then
				return {"NW", "North West"}
			end

			-- North
			if entityHeading > 337.5 and entityHeading < 360 then
				return {"N", "North"}
			end
		end
	end
end

function GetVehicleDamage(vehicle)
	if DoesEntityExist(vehicle) then
		local vehicleDamage = GetEntityHealth(vehicle)

		if vehicleDamage == 1000 then
			return "No Damage"
		end

		if vehicleDamage > 950 and vehicleDamage < 1000 then
			return "Cosmetic Damage"
		end

		if vehicleDamage > 700 and vehicleDamage < 950 then
			return "Visibly Damaged"
		end

		if vehicleDamage < 700 then
			return "Considerable Damage"
		end
	end
end

function GetPlayerVehicle()
	local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1))

	if DoesEntityExist(playerVehicle) then
		return playerVehicle
	else
		return nil
	end
end

function GetPlayerVehicleData()
	local playerVehicle = GetPlayerVehicle()

	if DoesEntityExist(playerVehicle) then
		local vehicleEntity = {}

		vehicleEntity.entity = playerVehicle
		vehicleEntity.model = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(playerVehicle)))
		vehicleEntity.name = GetLabelText(GetDisplayNameFromVehicleModel(vehicleEntity.model))
		vehicleEntity.registration = GetVehicleNumberPlateText(playerVehicle)
		vehicleEntity.sirens = IsVehicleSirenOn(playerVehicle)

		return vehicleEntity
	else
		return nil
	end
end

function GetVehicleData(vehicle)
	if DoesEntityExist(vehicle) then
		local vehicleEntity = {}

		vehicleEntity.model = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
		vehicleEntity.speed = GetEntityConvertedSpeed(vehicle)
		vehicleEntity.name = GetLabelText(GetDisplayNameFromVehicleModel(vehicleEntity.model))
		vehicleEntity.registration = GetVehicleNumberPlateText(vehicle)
		vehicleEntity.occupants = GetVehicleNumberOfPassengers(vehicle)
		vehicleEntity.direction = GetEntityDirection(vehicle) -- Key 1 single symbol (eg. N), Key 2 full name (eg. North)

		if not IsVehicleSeatFree(vehicle, -1) then
			vehicleEntity.occupants = vehicleEntity.occupants + 1
		end

		return vehicleEntity
	else
		return nil
	end
end

function StartTrafficStop()

end

function StartPersuit(targetVehicle)
	inPersuit = true
	
	DisplayNotification("Persuit started with vehicle: ")

	local playerVehicle = GetPlayerVehicle()
	
	if DoesEntityExist(targetVehicle) then
		SetVehicleIsWanted(targetVehicle, true)
	end

	if DoesEntityExist(playerVehicle) then
		SetVehicleSiren(playerVehicle, true)
		SetVehicleLightsMode(playerVehicle, 2)
		
		-- Roll down the front windows of the car
		RollDownWindow(playerVehicle, 0)
		RollDownWindow(playerVehicle, 1)
	end
end

function StopPersuit()
	inPersuit = false

	DisplayNotification("Persuit Ended")

	local playerVehicle = GetPlayerVehicle()

	if DoesEntityExist(targetVehicle) then
		SetVehicleIsWanted(targetVehicle, false)
	end	

	if DoesEntityExist(playerVehicle) then
		SetVehicleSiren(playerVehicle, false)
		SetVehicleLightsMode(playerVehicle, 0)

		-- Roll up the front windows of the car
		RollUpWindow(playerVehicle, 0)
		RollUpWindow(playerVehicle, 1)
	end
end

function RenderVehicleInfo(vehicle)
	-- Set the last vehicle so the display isn't blank
	lastHitVehicle = vehicle

	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.0, 0.55)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 65, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(
		"Vehicle Model: " .. vehicle.model .. 
		"\nVehicle Direction: (" .. vehicle.direction[1] .. ") " .. vehicle.direction[2] ..
		"\nVehicle Name: " .. vehicle.name .. 
		"\nVehicle Registration: " .. vehicle.registration ..
		"\nVehicle Occupants: " .. vehicle.occupants
	)
	DrawText(0.45, 0.75)
end

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))

	return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

-- Register IU endpoints

RegisterNUICallback('escape', function(data, cb)
	EnableGUI(false)

	print("this")

	cb('ok')
end)