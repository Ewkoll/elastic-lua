local object = require "es.object"

local ping_request = object:extend()

function ping_request:new()
    ping_request.super.new(self, "ping_request")
end

function ping_request:__tostring()
    return "ping_request"
end

function ping_request:init_request(call_back)
    local method = "HEAD"
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

return ping_request
