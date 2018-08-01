local object = require "es.object"

local info_request = object:extend()

function info_request:new()
    info_request.super.new(self, "info_request")
end

function info_request:__tostring()
    return "info_request"
end

function info_request:init_request(call_back)
    local method = "GET"
    local path = "/"
    local headers = {}
    
    return call_back(
        {
            method = method,
            body = body,
            path = path,
            headers = headers,
            query = query
        },
        true
    )
end

return info_request
