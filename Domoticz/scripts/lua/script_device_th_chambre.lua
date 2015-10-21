-- Greg FABRE - 2015
-- Thermostat Chambre

-- Variables
<<<<<<< HEAD
local hysteresis = 0.1
=======
<<<<<<< HEAD
local hysteresis = 0.1

-- Temperature
local thSonde = 'Module'
local thTarget = 'Temp_Chambre_Nuit'

-- Thermostat
local modechauffage = 'Chauffages'
local thermostat = 'Thermostat Chambre Parents' 
local radiateur = 'Chambre Parents'

-- Variables gestion montee en temperature

commandArray = {}

if (otherdevices[modechauffage] and (devicechanged[thermostat] == 'On' or (devicechanged[thSonde] and otherdevices[thermostat] == 'On'))) then
	
	--commandArray['SendNotification']='Thermostat#Theoomstat checked#0'
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
=======
local hysteresis = 0.5 -- Plus ou moins 1/2 deg
>>>>>>> origin/master

-- Temperature
local thSonde = 'Module'
local thTarget = 'Temp_Chambre_Nuit'

-- Thermostat
local modechauffage = 'Chauffages'
local thermostat = 'Thermostat Chambre Parents' 
local radiateur = 'Chambre Parents'

-- Variables gestion montee en temperature

commandArray = {}

if (otherdevices[modechauffage] and (devicechanged[thermostat] == 'On' or (devicechanged[thSonde] and otherdevices[thermostat] == 'On'))) then
	
	--commandArray['SendNotification']='Thermostat#Theoomstat checked#0'
	-- Get temperatures
	chTemp, chHumidity = otherdevices_svalues[thSonde]:match("([^;]+);([^;]+)")

        local temperature = tonumber(chTemp)
	local tempTarget = uservariables[thTarget]
	--local tempJour = otherdevices_svalues['Thermostat Absence']

	-- Check radiator state
	radiateurState = otherdevices[radiateur]
	print('[Chambre] Actual temperature : ' .. temperature .. '. Target : ' .. tempTarget.. ' ('..radiateurState..')')

	-- Thermostat on
	if (temperature < (tempTarget - hysteresis) and radiateurState == 'Off') then
		print(thermostat..' switched ON')
		commandArray[radiateur]='On'
	elseif (temperature > (tempTarget + hysteresis) and radiateurState == 'On') then
		print(thermostat..' switched OFF')
		commandArray[radiateur]='Off'
	end
end

<<<<<<< HEAD
if (devicechanged[thermostat] == 'Off') then
	radiateurState = otherdevices[radiateur]
        --if (radiateurState == 'On') then
                commandArray[radiateur]='Off'
        --end
=======
return commandArray
 (tempNuit + hysteresis) and radiateurState == 'On') then
			print(thermostat..' : Off')
			commandArray[radiateur]='Off'
		end
	end
>>>>>>> origin/master
>>>>>>> origin/master
end

return commandArray
