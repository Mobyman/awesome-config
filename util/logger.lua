local logger = {}
local io = io
local pairs = pairs
local tostring = tostring

local function getIndentString(indent, symbol)
    indent = indent * 4
    if not symbol then symbol = ' ' end
    local string = ''
    for i = 1, indent do
        string = string .. symbol
    end
    return string
end

function logger:new(file, instantFlush)
    if instantFlush == nil then
        instantFlush = true
    end
    local loggerInstance = {
        file = io.open(file, 'a');
        flush = instantFlush
    }
    setmetatable(loggerInstance, logger)
    self.__index = self
    return loggerInstance
end

function logger:log(message)
    self.file:write(tostring(message) .. "\n")
    if self.flush then
        self.file:flush()
    end
    return self
end

function logger:logTable(tbl, indent)
    if not indent then indent = 0 end
    if type(tbl) ~= 'table' then
        self:log(tbl)
        return
    end
    self:log(getIndentString(indent) .. '{')
    for k, v in pairs(tbl) do
        if type(v) ~= 'table' then
            self:log(getIndentString(indent + 1) .. tostring(k) .. ' = ' .. tostring(v))
        else
            self:log(tostring(k) .. ' = ')
            self:logTable(v, indent + 1)
        end
    end
    self:log(getIndentString(indent) .. '}')
end

local globalLogger = logger:new(os.getenv('HOME') .. '/awesome.log')

return {
    new = function (file, instantFlush)
        return logger:new(file, instantFlush)
    end;
    globalLogger = globalLogger;
}
