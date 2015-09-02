-- Greg FABRE - 2015
-- Mode vacances : On arrete chauffe-eau et chauffages

-- Variables
local hysteresis = 0.1

local modevacances = 'Vacances'
local chaufeau = 'Chauffe-eau'

-- Temperature
local thSonde = 'Module'
local thTarget = 'Temp_Vacances'

-- Thermostat
local modechauffage = 'Chauffages'
local thermostat = 'Thermostat Chambre Parents' 
local radiateur = 'Chambre Parents'

-- Variables gestion montee en temperature

commandArray = {}

if (devicechanged[modevacances] == 'On' or (otherdevices[modevacances] == 'On' and devicechanged[chaufeau] == 'On' )) then
	chaufeauState = otherdevices[chaufeau]
	if ( chaufeauState == 'On') then
		commandArray[chaufeau]='Off'
	end
end

return commandArray
