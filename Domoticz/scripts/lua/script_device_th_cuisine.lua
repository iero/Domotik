-- Greg FABRE - 2015
-- Thermostat Cuisine

-- Variables
local hysteresis = 0.1

-- Temperature
local thSonde = 'Salon'
local thTarget = 'Temp_Confort'

-- Thermostat
local thermostat = 'Thermostat Cuisine SDB haut' 
local radiateur = 'Cuisine'

commandArray = {}

if (devicechanged[thermostat] == 'On' or (devicechanged[thSonde] and otherdevices[thermostat] == 'On')) then
	
	-- Get temperatures
	local temperature = tonumber(otherdevices_svalues[thSonde])
	local tempTarget = uservariables[thTarget]
	--local tempJour = otherdevices_svalues['Thermostat Absence']

	print('Temperature/Target : ' .. temperature .. '/' .. tempTarget)

	-- Check radiator state
	radiateurState = otherdevices[radiateur]
	print('Radiateur is already '..radiateurState)

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
