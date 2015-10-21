-- Greg FABRE - 2015
-- Thermostat Salon

-- Variables
local hysteresis = 0.1 -- Plus ou moins 1/2 deg

-- Sonde temperature
local sondeTemp = 'Salon'

-- Thermostat
local thTarget = 'Temp_Confort'

local modechauffage = 'Chauffages'
local thermostat = 'Thermostat Salon' 
local radiateur1 = 'Salon Projecteur'
local radiateur2 = 'Salon Table'
local radiateur3 = 'Salon Horloge'

commandArray = {}

--if (otherdevices[modechauffage] and (devicechanged[thermostat] == 'On' or (devicechanged[sondeTemp] and otherdevices[thermostat] == 'On'))) then
if (devicechanged[thermostat] == 'On' or (devicechanged[sondeTemp] and otherdevices[thermostat] == 'On')) then
	
	--commandArray['SendNotification']='Thermostat#Theoomstat checked#0'
	-- Get temperatures
	salonTemp, salonHumidity, salonFeelsLike, salonPressure = otherdevices_svalues[sondeTemp]:match("([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
	local temperature = tonumber(salonTemp)
	local tempTarget = uservariables[thTarget]

	print('[Salon] Actual temperature of ' .. temperature .. ' with objective of ' .. tempTarget)

	-- Check radiator state
	radiateur1State = otherdevices[radiateur1]
	radiateur2State = otherdevices[radiateur2]
	radiateur3State = otherdevices[radiateur3]
	print('[Salon] Actual temperature : ' .. temperature .. '. Target : ' .. tempTarget.. ' ('..radiateur1State..')')

	-- Thermostat on
	if (temperature < (tempTarget - hysteresis)) then
		if (radiateur1State == 'Off') then
			print(radiateur1..' : On')
			commandArray[radiateur1]='On'
		end
		if (radiateur2State == 'Off') then
			print(radiateur2..' : On')
			commandArray[radiateur2]='On'
		end
		if (radiateur3State == 'Off') then
			print(radiateur3..' : On')
			commandArray[radiateur3]='On'
		end
	elseif (temperature > (tempTarget + hysteresis)) then
		if (radiateur1State == 'On') then
			print(radiateur1..' : Off')
			commandArray[radiateur1]='Off'
		end
		if (radiateur2State == 'On') then
			print(radiateur2..' : Off')
			commandArray[radiateur2]='Off'
		end
		if (radiateur3State == 'On') then
			print(radiateur3..' : Off')
			commandArray[radiateur3]='Off'
		end
	end
end

if (devicechanged[thermostat] == 'Off') then
	print('[Salon] Thermostat OFF')
	radiateur1State = otherdevices[radiateur1]
        radiateur2State = otherdevices[radiateur2]
        radiateur3State = otherdevices[radiateur3]

        --if (radiateurState1 == 'On') then
                commandArray[radiateur1]='Off'
        --end
        --if (radiateurState2 == 'On') then
		commandArray[radiateur2]='Off'
        --end
        --if (radiateurState3 == 'On') then
		commandArray[radiateur3]='Off'
	--end
end

return commandArray
