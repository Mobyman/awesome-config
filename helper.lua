function string:split(pat)
	local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = self:find(fpat, 1)
    while s do
    	if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
    	end
    	last_end = e+1
    	s, e, cap = self:find(fpat, last_end)
    end
   	if last_end <= #self then
    	cap = self:sub(last_end)
    	table.insert(t, cap)
    end
    return t
end

function table_slice (values,i1,i2)
	local res = {}
	local n = #values
	i1 = i1 or 1
	i2 = i2 or n
	if i2 < 0 then
		i2 = n + i2 + 1
	elseif i2 > n then
		i2 = n
	end
	if i1 < 1 or i1 > n then
		return {}
	end
	local k = 1
	for i = i1,i2 do
		res[k] = values[i]
		k = k + 1
	end
	return res
end

function copy( orig )
	local o_type = type(orig)
	local cpy
	if o_type == 'table' then
		cpy = {}
		for orig_key, orig_val in next, orig, nil do
			cpy[copy(orig_key)] = copy(orig_val)
		end
		setmetatable(cpy, copy(getmetatable(orig)))
	else
		cpy = orig
	end
	return cpy
end

function getTableParts(tbl)
    local result = {
        keys = {};
        values = {};
    }
    for k, v in pairs(tbl) do
        result.keys[#result.keys+1] = k
        result.values[#result.values+1] = v
    end
    return result
end

function round(number)
    local low = math.floor(number)
    local high = math.ceil(number)

    if math.abs(number - low) < math.abs(number - high) then
        return low
    else
        return high
    end
end