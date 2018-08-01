local object = require "es.object"

local http_host = object:extend()

function http_host:new(ip, port)
    http_host.super.new(self, "http_host")
    self._ip = ip
    self._port = port
end

function http_host:get_ip()
    return self._ip
end

function http_host:get_port()
    return self._port
end

function http_host:__tostring()
    return string.format("http_host: ip = %s, port = %d", self._ip, self._port)
end

return http_host
