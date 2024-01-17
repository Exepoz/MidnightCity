if GetResourceState('ps-inventory') ~= 'started' then return end

AddItem = function(src, item, count, metadata)
	return exports['ps-inventory']:AddItem(src, item, count, slot, metadata)
end

RemoveItem = function(src, item, count, metadata)
	return exports['ps-inventory']:RemoveItem(src, item, count, slot, metadata)
end