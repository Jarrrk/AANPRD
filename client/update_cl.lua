print("You're running AANPRD v0.1 by Jarrrk")

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000) -- Wait a second before checking the players current vehicle

		local playerVehicle = GetPlayerVehicleData()

		if playerVehicle ~= nil then
			if Config.AANPRD_Vehicles[playerVehicle.model] then -- Check whether they're in a valid AANPRD vehicle
				DisplayNotification("AANPRD activated")

				EnableGUI(true)

				isScanning = true

				while isScanning do
					Citizen.Wait(0)

					CheckGUI()

					-- If player is out of vehicle
					if not DoesEntityExist(GetVehiclePedIsIn(GetPlayerPed(-1))) then
						DisplayNotification("AANPRD deactivated")

						EnableGUI(false)
						
						isScanning = false
					
						break
					end
					
					local requestTargetVehicle = GetVehicleInfrontOfEntity(GetVehiclePedIsIn(GetPlayerPed(-1)))
					
					if DoesEntityExist(requestTargetVehicle) then
						RenderVehicleInfo(GetVehicleData(requestTargetVehicle))
					else if lastHitVehicle ~= nil then
							RenderVehicleInfo(lastHitVehicle)
						end
					end

					if IsControlJustPressed(1, 176) and not inPersuit then -- Enter
						if DoesEntityExist(requestTargetVehicle) then
							StartPersuit(requestTargetVehicle)
						end
					end

					if IsControlJustPressed(1, 177) and inPersuit then -- Enter
						StopPersuit()
					end
				end
			end
		end
	end
end)