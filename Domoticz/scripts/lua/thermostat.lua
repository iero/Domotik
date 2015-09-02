-- Greg FABRE - 2015
-- Thermostat Salon

-- Variables
local tempConfort = otherdevices_svalues['Thermostat Salon Confort']
local hysteresis = 0.5 -- Plus ou moins 1/2 deg

-- Sonde temperature
local tempInt = 'Salon'
--local tempMaxAprem = ''

-- Thermostat
local thermostat = 'Thermostat Salon'
--local radiateurs = 'Chauffages Salon'
local radiateurs = 'Dummy Test'

commandArray = {}

time = os.date("*t")

--if (devicechanged['MyDeviceName'] == 'On' and otherdevices['MyOtherDeviceName'] == 'Off' and time.hour >= 22)
-- then
--    commandArray['MyOtherDeviceName']='On'
-- end

if (devicechanged[tempInt]) then
	-- Get temperatures
	local temperature = devicechanged[string.format('%s_Temperature', tempInt)]

	-- Thermostat on
	if (otherdevices[thermostat]=='On') then
		if (temperature < (consigne - hysteresis) ) then
			print ('Thermostat salon : On')
			commandArray[radiateurs]='Off'
		elseif (temperature > (consigne + hysteresis)) then
			print ('Thermostat salon : Off')
			commandArray[radiateurs]='On'
		end
	end
end

return commandArray
