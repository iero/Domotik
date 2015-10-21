-- Greg FABRE - 2016
-- Thermostat Entree

-- Variables
local hysteresis = 0.1

-- Temperature
local thSonde = 'Entree'
local thTarget = 'Temp_Confort'

-- Thermostat
local thermostat = 'Thermostat Entree' 
local radiateur = 'Rad_Entree'

commandArray = {}

if (devicechanged[thermostat] == 'On' or (devicechanged[thSonde] and otherdevices[thermostat] == 'On')) then
	
	-- Get temperatures
	chTemp, chHumidity = otherdevices_svalues[thSonde]:match("([^;]+);([^;]+)")
        local temperature = tonumber(chTemp)
	local tempTarget = uservariables[thTarget]
	--local tempJour = otherdevices_svalues['Thermostat Absence']

	-- Check radiator state
	radiateurState = otherdevices[radiateur]
	print('[Entree] Actual temperature : ' .. temperature .. '. Target : ' .. tempTarget.. ' ('..radiateurState..')')

	-- Thermostat on
	if (temperature < (tempTarget - hysteresis) and radiateurState == 'Off') then
		print(thermostat..' : On')
		commandArray[radiateur]='On'
	elseif (temperature > (tempTarget + hysteresis) and radiateurState == 'On') then
		print(thermostat..' : Off')
		commandArray[radiateur]='Off'
	end
end

if (devicechanged[thermostat] == 'Off') then
	radiateurState = otherdevices[radiateur]
	if (radiateurState == 'On') then
		commandArray[radiateur]='Off'
	end
end

return commandArray
