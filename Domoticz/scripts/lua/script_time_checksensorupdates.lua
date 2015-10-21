-- Greg FABRE - 2015

<<<<<<< HEAD
-- Max update allowed 1h (allow to send message between 55 min and 1h05 min)
local update1hmin=3300
local update1hmax=3900

-- Max update 24h (allow to send message between 23h55 and 24h05 min)
local update24hmin=86100
local update24hmax=86700
=======
-- Max update 1 h (stop sending message after 1h05 min)
local maxupdate = 3600000 
local stopnotif = 3900000
>>>>>>> origin/master

commandArray = {}

-- Every 10 minutes 
time = os.date("*t")
if((time.min % 10)==0) then
	local outdated=0
	devices='['

	for i, v in pairs(otherdevices_temperature) do 	
<<<<<<< HEAD
		if ( i ~= "Unknown") then
			s = otherdevices_lastupdate[i]
			ye = string.sub(s, 1, 4)
			mo = string.sub(s, 6, 7)
			da = string.sub(s, 9, 10)
			ho = string.sub(s, 12, 13)
			mi = string.sub(s, 15, 16)
			se = string.sub(s, 18, 19)

			t1 = os.time()
			t2 = os.time{year=ye, month=mo, day=da, hour=ho, min=mi, sec=se}
			difference = (os.difftime (t1, t2))

			if ( (difference > update1hmin ) and (difference < update1hmax)) then
				print(i .. ' not updated since 1h')
                		devices = devices .. i .. ','
				outdated=outdated + 1
			end
			if ( (difference > update24hmin ) and (difference < update24hmax)) then
				print(i .. ' not updated since 24h')
                		devices = devices .. i .. ','
				outdated=outdated + 1
			end
		end
	end
	if (outdated > 0) then
		commandArray['SendNotification']=outdated .. ' sensors outdated#'.. devices .. '] not updated' .. '#0'
=======
	
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
>>>>>>> origin/master
	end

end

return commandArray
