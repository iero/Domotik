-- Greg FABRE - 2015

-- Max update 1 h (stop sending message after 1h05 min)
local maxupdate = 3600000 
local stopnotif = 3900000

commandArray = {}

-- Every 10 minutes 
time = os.date("*t")
if((time.min % 10)==0) then
	local outdated=0
	devices='['

	for i, v in pairs(otherdevices_temperature) do 	
	
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

		if ( (difference > maxupdate ) and (difference < stopnotif)) then
			print(i .. ' not updated')
                	devices = devices .. i .. ','
			outdated=outdated + 1
		end
         
		if (outdated > 0) then
			commandArray['SendNotification']=outdated .. ' sensors outdated#'.. devices .. '] not updated' .. '#0'
		end
	end

end

return commandArray
