-- Greg FABRE - 2016
-- Mode Day at home : On laisse les chauffages en fonction le jour

-- Variables
local dayathome = 'Day at home'

-- Thermostat
local modechauffage = 'Chauffages'
local thEntree = 'Thermostat Entree' 
local thSalon = 'Thermostat Salon'

commandArray = {}

time = os.date("*t")
if (time.hour >= 6 and time.hour <= 18) then
	if (otherdevices[dayathome] == 'On' and otherdevices[modechauffage] == 'On' ) then
		thEntreeState = otherdevices[thEntree]
		thSalonState = otherdevices[thSalon]
		if ( thEntreeState == 'Off') then
			commandArray[thEntree]='On'
		end
		if ( thSalonState == 'Off') then
			commandArray[thSalon]='On'
		end
	end
end

return commandArray
