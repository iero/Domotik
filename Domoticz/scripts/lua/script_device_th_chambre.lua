-- Greg FABRE - 2015
-- Thermostat Chambre

-- Variables
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
end

return commandArray
