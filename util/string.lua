local function purify( str )
	local s = ""
	for i in str:gmatch( "%C+" ) do
		s = s .. i
	end
	return s
end

local function htmlSpecialChars(str)
	return purify(str)
		:gsub('&', '&amp;')
		:gsub('<', '&lt;')
		:gsub('>', '&gt;')
end

local function formatString(str, data)
   for key, value in pairs(data) do
       str = str:gsub('{' .. key .. '}', value)
   end
   return str
end

local function split(s, delimiter)
    result = {};
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
	end
	return result;
end


return {
	purify           = purify;
	htmlSpecialChars = htmlSpecialChars;
	format           = formatString;
	split 			 = split;
}