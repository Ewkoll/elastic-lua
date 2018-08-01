local json_safe = require("cjson.safe")

json_safe.decode_array_with_array_mt(true)

local json_decode = function(json_data)
    if nil == json_data then
        return
    end

    if "table" == type(json_data) then
        return json_data
    end

    return json_safe.decode(json_data)
end

local json_encode = function(json_data)
    if nil == json_data then
        return
    end
    
    if "string" == type(json_data) then
        return json_data
    end

    return json_safe.encode(json_data)
end

local convert_source = function(source)
    if nil ~= source and "table" == type(source) then
        local result
        for _, v in pairs(source) do
            if nil == result then
                result = tostring(v)
            else
                result = result .. "," .. tostring(v)
            end
        end
        return result
    end
end

return {
    convert_source = convert_source,
    json_decode = json_decode,
    json_encode = json_encode,
}
