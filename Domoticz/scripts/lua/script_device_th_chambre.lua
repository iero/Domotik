-- Greg FABRE - 2015
-- Thermostat Chambre

-- Variables
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

-- Sonde temperature
local tempInt = 'Module'
--local tempMaxAprem = ''

-- Thermostat
local thermostat = 'Thermostat Chambre Parents' 
local radiateurs = 'Chambre Parents'

commandArray = {}

-- time = os.date("*t")

--if (devicechanged['MyDeviceName'] == 'On' and otherdevices['MyOtherDeviceName'] == 'Off' and time.hour >= 22)
-- then
--    commandArray['MyOtherDeviceName']='On'
-- end

--if (devicechanged[tempInt]) then
if (tempInt < 18) then
	
	print('Temperature changed')
	print(tempInt)
	-- Get temperatures

	local tempNuit = otherdevices_svalues['Thermostat Chambre Nuit']
	local tempJour = otherdevices_svalues['Thermostat Absence']

	local temperature = devicechanged[string.format('%s_Temperature', tempInt)]

	-- Thermostat on
	if (otherdevices[thermostat]=='On') then
		if (temperature < (consigne - hysteresis) ) then
			print('Thermostat salon : On')
			commandArray[radiateurs]='Off'
		elseif (temperature > (consigne + hysteresis)) then
			print('Thermostat salon : Off')
			commandArray[radiateurs]='On'
		end
	end
end

return commandArray
 (tempNuit + hysteresis) and radiateurState == 'On') then
			print(thermostat..' : Off')
			commandArray[radiateur]='Off'
		end
	end
>>>>>>> origin/master
end

return commandArray
