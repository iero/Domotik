commandArray = {}

if (devicechanged['Dummy']) then
	print('Debug')
	--commandArray['MyOtherDeviceName']='On'
   	--for i, v in pairs(otherdevices) do print(i, v) end
	for i, v in pairs(otherdevices_svalues) do 
		print('--')
		--print(i, v) 
		print('Device : '..i)
		print('Value : '..otherdevices_svalues[i])
	end
end
return commandArray
