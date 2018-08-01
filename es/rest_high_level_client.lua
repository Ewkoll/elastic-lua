local object = require "es.object"
local internal_http = require "es.internal_http"
local get_response = require "es.document_api.get_response"
local index_response = require "es.document_api.index_response"
local delete_response = require "es.document_api.delete_response"
local update_response = require "es.document_api.update_response"
local bulk_response = require "es.document_api.bulk_response"
local multi_get_response = require "es.document_api.multi_get_response"

local ping_request = require "es.misc_api.ping_request"
local ping_response = require "es.misc_api.ping_response"
local info_request = require "es.misc_api.info_request"
local main_response = require "es.misc_api.main_response"

local rest_high_level_client = object:extend()

function rest_high_level_client:new(...)
    rest_high_level_client.super.new(self, "rest_high_level_client")
    local hosts = {}
    for _, host in pairs({...}) do
        if nil ~= host.istypeof then
            if host:istypeof("http_host") then
                table.insert(hosts, host)
            end
        end
    end
    self._hosts = hosts
end

function rest_high_level_client:close()
    self._hosts = nil
end

function rest_high_level_client:get_host()
    if nil == self._hosts or nil == next(self._hosts) then
        return
    end

    local item = math.random(1, #self._hosts)
    return self._hosts[item]
end

function rest_high_level_client:info()
    local request = info_request()
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, body =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = main_response(body)
            return ok, err, rsp_obj
        end
    )
end

function rest_high_level_client:ping()
    local request = ping_request()
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, _, status =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = ping_response(status)
            return ok, err, rsp_obj
        end
    )
end

function rest_high_level_client:index(request)
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, body =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = index_response(body)
            return ok, err, rsp_obj
        end
    )
end

function rest_high_level_client:get(request)
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, body =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = get_response(body)
            return ok, err, rsp_obj
        end
    )
end

function rest_high_level_client:delete(request)
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, body =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = delete_response(body)
            return ok, err, rsp_obj
        end
    )
end

function rest_high_level_client:update(request)
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, body =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = update_response(body)
            return ok, err, rsp_obj
        end
    )
end

function rest_high_level_client:bulk(request)
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, body =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = bulk_response(body)
            return ok, err, rsp_obj
        end
    )
end

function rest_high_level_client:multi_get(request)
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, body =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = multi_get_response(body)
            return ok, err, rsp_obj
        end
    )
end

function rest_high_level_client:search(request)
    local host = self:get_host()

    return request:init_request(
        function(data, result, error)
            if false == result then
                return false, error
            end

            local ok, err, body =
                internal_http.http_client(
                host:get_ip(),
                host:get_port(),
                data.path,
                data.body,
                data.query,
                data.method,
                data.headers
            )

            if not ok then
                return false, err
            end

            local rsp_obj = body
            return ok, err, rsp_obj
        end
    )
end


return rest_high_level_client
