-- David - 2015
-- Ce script permet de maintenir la température du salon
-- en fonction des moment de la journée dès lors que l'interrupteur 
-- virtuel 'Thermostat salon' est activé.
 
-- 2 radiateurs et 2 sonde dans la même pièce
 
--------------------------------
------ Variables à éditer ------
--------------------------------
local consigne = 20  --Température de consigne
local hysteresis = 0.5 --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens
local sondesalon = 'Salon' --Nom de la sonde de température
local sondecuisine = 'Cuisine' --Nom de la sonde de température
local thermostat = 'Thermostat salon' --Nom de l'interrupteur virtuel du thermostat
local radiateurcuisine = 'Radiateur cuisine' --Nom du radiateur à allumer/éteindre
local radiateursalon = 'Radiateur salon' --Nom du radiateur à allumer/éteindre
--------------------------------
-- Fin des variables à éditer --
--------------------------------
 
commandArray = {}
--La sonde Oregon 'bureau' emet toutes les 40 secondes. Ce sera approximativement la fréquence 
-- d'exécution de ce script.
if (devicechanged[sondesalon]) then
--print('t° salon : ' .. devicechanged[string.format('%s_Temperature', sondesalon)])
local temperaturesalon =  devicechanged[string.format('%s_Temperature', sondesalon)]
local temperaturecuisine = string.sub(otherdevices_svalues[sondecuisine], 0, string.find(otherdevices_svalues[sondecuisine], ";")-1)
--print('t° cuisine : ' .. temperaturecuisineone);
 
    --On n'agit que si le "Thermostat" est actif
    if (otherdevices[thermostat]=='On') then
--        print('-- Gestion du thermostat pour le bureau --')
	local h = tonumber(os.date('%H'))
 
 
	if (h < 8) then
		consigne = consigne - 3; -- 0-8h : 17°
	elseif (h < 12) then
		consigne = consigne - 1; -- 8-12h : 19°
	elseif (h < 14) then
		consigne = consigne - 0; -- 12-14h 20°
	elseif (h < 19) then
		consigne = consigne - 2; -- 14-19h 18°
	elseif (h < 22) then
		consigne = consigne - 0; -- 19-22h 20°
	else
		consigne = consigne - 3; -- 19-22h 20°
	end
 
-- Coté salon
	local temperature = ((temperaturesalon * 2) + temperaturecuisine)/3;
	if (otherdevices[radiateursalon]=='On' and temperature < (consigne - hysteresis) ) then
            print('Allumage du chauffage dans le salon (t° : ' .. temperature .. ')')
            commandArray[radiateursalon]='Off'
 
        elseif (otherdevices[radiateursalon]=='Off' and temperature > (consigne + hysteresis)) then
            print('Extinction du chauffage dans le salon (t° : ' .. temperature .. ')')
            commandArray[radiateursalon]='On'
 
        end
 
-- Coté cuisine
	temperature = ((temperaturecuisine * 2) + temperaturesalon)/3;
	if (otherdevices[radiateurcuisine]=='On' and temperature < (consigne - hysteresis) ) then
            print('Allumage du chauffage dans le cuisine (t° : ' .. temperature .. ')')
            commandArray[radiateurcuisine]='Off'
 
        elseif (otherdevices[radiateurcuisine]=='Off' and temperature > (consigne + hysteresis)) then
            print('Extinction du chauffage dans le cuisine (t° : ' .. temperature .. ')')
            commandArray[radiateurcuisine]='On'
 
        end
    end
end
return commandArray
