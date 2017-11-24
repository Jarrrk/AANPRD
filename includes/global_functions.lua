function List(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

function DisplayNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end