local object = require "es.object"

local ping_response = object:extend()

function ping_response:new(success)
    ping_response.super.new(self, "ping_response")
    self._response = success
end

function ping_response:__tostring()
    return "ping_response"
end

function ping_response:get_response()
    return self._response
end

function ping_response:is_success()
    return nil ~= self._response and 200 == self._response
end

return ping_response
