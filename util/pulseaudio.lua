local tonumber = tonumber
local io = io
local os = os
require('helper')

local pa = {}
local _ = {}
_.step = 65536 / 100


pa.getVolume = function ()
    local dmp = io.popen('pacmd dump | grep "set-sink-volume" | grep -Po "0x[0-9a-f]+"'):read()
    if dmp == nil then return 0 end
    return tonumber(dmp) / _.step
end

pa.volumeUp = function (callback)
    local currentVolume = pa.getVolume()
    if (round(currentVolume) > 99) then
        return currentVolume
    else
        os.execute('pacmd set-sink-volume 0 ' .. round((currentVolume + 1) * _.step))
        if callback ~= nil then callback(currentVolume + 1) end
        return currentVolume + 1
    end
end

pa.volumeDown = function (callback)
    local currentVolume = pa.getVolume()
    if (round(currentVolume) < 1) then
        return currentVolume
    else
        os.execute('pacmd set-sink-volume 0 ' .. round((currentVolume - 1) * _.step))
        if callback ~= nil then callback(currentVolume - 1) end
        return currentVolume - 1
    end
end

pa.isMuted = function ()
    return not not io.popen('pacmd dump | grep "set-sink-mute" | grep "yes"'):read()
end

pa.muteToggle = function (callback)
    if callback == nil then
        callback = function () end
    end
    local muted = pa.isMuted()
    if muted then
        os.execute('pacmd set-sink-mute 0 0')
        callback(muted)
        return muted
    else
        os.execute('pacmd set-sink-mute 0 1')
        callback(muted)
        return muted
    end
end

return pa