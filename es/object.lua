local classic = require "es.vendor.classic"

local object = classic:extend()

function object:new(name)
    self._name = name
end

function object:name()
    return self._name
end

function object:istypeof(name)
    return self._name == name
end

function object:isluatypeof(obj, typename)
    return typename == type(obj)
end

function object:is_string(obj)
    return nil ~= obj and "string" == type(obj)
end

function object:is_table(obj)
    return nil ~= obj and "table" == type(obj)
end

function object:is_number(obj)
    return nil ~= obj and "number" == type(obj)
end

function object:is_boolean(obj)
    return nil ~= obj and "boolean" == type(obj)
end

function object:fill_object(obj, key, value)
    if nil ~= value then
        obj[key] = value
    end
end

function object:log(log_data, level)
    level = level or ngx.DEBUG

    if "string" ~= type(log_data) then
        if nil ~= log_data and nil == log_data.__tostring then
            log_data = tostring(log_data)
        end
    end

    ngx.log(level, log_data)
end

return object
