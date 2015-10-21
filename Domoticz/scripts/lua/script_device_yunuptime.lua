-- Greg FABRE - 2015
-- Yun uptime

<<<<<<< HEAD
-- Rebooted if uptime < 6 min
local cutoff = 400000 
=======
-- Rebooted if uptime < 5 min
local cutoff = 300000 
>>>>>>> origin/master

-- Thermostat
local yunuptime = 'Uptime'

commandArray = {}

if (devicechanged[yunuptime]) then
	local uptime = tonumber(otherdevices_svalues[yunuptime])
<<<<<<< HEAD
	--print('Yun uptime : '..uptime)
=======
	print('Uptime : '..uptime)
>>>>>>> origin/master
	if ( uptime <= cutoff) then
 		commandArray['SendNotification']='ieroYun#ieroYun just rebooted!#0'
		
		devices='['

		for i, v in pairs(otherdevices) do
                	if (v == 'On') then
				commandArray[i]='On'
				devices = devices .. i .. ','
                	end
        	end
                commandArray['SendNotification']='ieroYun rebooted#'.. devices .. '] restarted' .. '#0'
	end
end

return commandArray
