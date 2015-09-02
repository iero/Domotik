-- Greg FABRE - 2015
-- Yun uptime

-- Max update 10 min
local maxupdate = 600000 

-- Thermostat
local dummy = 'Dummy'

commandArray = {}

if (devicechanged[dummy]) then
	--for i, v in pairs(otherdevices_svalues) do print("Idx=" ..  i .. " svalue=" .. v .. "<--") end
	devices='['

        for i, v in pairs(otherdevices) do
        	if (v == 'On') then
                       --commandArray[i]='On'
                       devices = devices .. i .. ','
                end
         end
         --commandArray['SendNotification']='ieroYun rebooted#'.. devices .. '] restarted' .. '#0'


	for i, v in pairs(otherdevices_temperature) do 	
		--print("Idx=" ..  i .. " lastpupdate=" .. otherdevices_lastupdate[i] .. "<--")
	
		s = otherdevices_lastupdate[i]
		year = string.sub(s, 1, 4)
		month = string.sub(s, 6, 7)
		day = string.sub(s, 9, 10)
		hour = string.sub(s, 12, 13)
		minutes = string.sub(s, 15, 16)
		seconds = string.sub(s, 18, 19)

		t1 = os.time()
		t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
		difference = (os.difftime (t1, t2))

		if ( difference > maxupdate ) then
			print(i .. ' not updated')
		end
	end

end

return commandArray
