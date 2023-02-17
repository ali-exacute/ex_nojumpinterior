ESX, playerData = nil, nil
ESXTimeout = false

Citizen.CreateThread(function()
    Citizen.SetTimeout(2000, function()
        ESXTimeout = true
    end)

    while not ESX and not ESXTimeout do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(50)
    end

    if ESX then
        PlayerData = ESX.GetPlayerData()

    	RegisterNetEvent('esx:playerLoaded')
    	AddEventHandler('esx:playerLoaded', function(xPlayer)
    		PlayerData = xPlayer
    	end)


    	RegisterNetEvent('esx:setJob')
    	AddEventHandler('esx:setJob', function(job)
    		PlayerData.job = job
    	end)
	end
	loaded = true
end)

function shouldDisableInteriorJump()
	local cantJump = Config.default.disableJumpInInterior
	local cantSprint = Config.default.disableSprintInInterior
	local playerPed = PlayerPedId()
	local playerModel = GetEntityModel(playerPed)
	local interiorId = GetInteriorFromEntity(playerPed)
	if interiorId ~= 0 then
		if ESX then
			for configInteriorId, configInteriorData in pairs(Config.excludeForJobs) do
				if tonumber(configInteriorId) and (tonumber(configInteriorId) == interiorId) then
					local InteriorJobInfo = configInteriorData[PlayerData.job.name]
					if InteriorJobInfo then
						cantSprint = InteriorJobInfo.disableSprintInInterior
						cantJump = InteriorJobInfo.disableJumpInInterior
					end
				end
			end
		end

		for configPlayerModel, playerData in pairs(Config.excludePed) do
			if configPlayerModel == playerModel then
				playerInteriorData = playerData[interiorId]
				if playerInteriorData then
					cantSprint = playerInteriorData.disableSprintInInterior
					cantJump = playerInteriorData.disableJumpInInterior
				end
			end
		end

		return true, cantJump, cantSprint
	end
	return false, false, false
end

function draw2DText(msg, offsetx, offsety)
    SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.35)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
    AddTextComponentString(msg)
	EndTextCommandDisplayText(0.0+(offsetx/10), 0.0+(offsety/30))
end

Citizen.CreateThread(function()
	while not loaded do Wait(200) end
	while true do
		Wait(5)
		local inInterior, cantJump, cantSprint = shouldDisableInteriorJump()
		if inInterior then
			if cantSprint then
				DisableControlAction(0, 21, true) -- Left shift for sprint
			end
			if cantJump then
				DisableControlAction(0, 22, true) -- Space for Jump
			end

			if Config.debugmode then
				draw2DText("player in Interior : "..(inInterior and "~g~Yes" or "~r~No"), 0.2, 14)
				draw2DText("Can sprint : "..(cantSprint and "~r~No" or "~g~Yes"), 0.2, 15)
				draw2DText("Can jump : "..(cantJump and "~r~No" or "~g~Yes"), 1.2, 15)

				if IsDisabledControlPressed(0, 21) then
					draw2DText("~b~SHIFT pressed", 0.2, 16)
				end

				if IsDisabledControlPressed(0, 22) then
					draw2DText("~b~SPACE pressed", 1.2, 16)
				end
			end
		else
			Wait(300)
		end
	end
end)

if Config.getInteriorID_command and Config.getInteriorID_command ~= "" then
	RegisterCommand(Config.getInteriorID_command, function(source, args, rawCommand)
		local playerPed = PlayerPedId()
		local interiorId = GetInteriorFromEntity(playerPed)
		if interiorId ~= 0 then
			local roomHash = GetRoomKeyFromEntity(playerPed)
			local roomId = GetInteriorRoomIndexByHash(interiorId, roomHash)

			print("^4Interior ID : ^2"..interiorId.."^0 <-- you need this one")
			if roomId ~= -1 then
				print("^4Interior Room ID : ^2"..roomId.."^0")
				print("^4Interior Room Name : ^2"..GetInteriorRoomName(interiorId, roomId).."^0")
			end
		else
			print("^1You are not in any Interior^0")
		end
	end)
end
