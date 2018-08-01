local object = require "es.object"
local utils = require "es.utils.utils"

local multi_get_request = object:extend()

function multi_get_request:new()
    multi_get_request.super.new(self, "multi_get_request")
    multi_get_request._get_request = {}
end

--[[
    Can be set to <tt>_local</tt> to prefer local shards, <tt>_primary</tt> to execute only on primary shards
--]]
function multi_get_request:preference(preference)
    if nil ~= preference and "string" == type(preference) then
        self._preference = preference
    end
end

--[[
    Perform a refresh before retrieving the document (false by default)
--]]
function multi_get_request:refresh(refresh)
    if nil ~= refresh and "boolean" == type(refresh) then
        self._refresh = refresh
    end
end

--[[
    Set realtime flag to false (true by default)
--]]
function multi_get_request:realtime(realtime)
    if nil ~= realtime and "boolean" == type(realtime) then
        self._realtime = realtime
    end
end

function multi_get_request:add(get_request_object)
    if nil == get_request_object or nil == get_request_object.to_multi_request then
        return
    end

    table.insert(multi_get_request._get_request, get_request_object)
    return true
end

function multi_get_request:generate_body()
    local docs = {}
    for _, v in pairs(multi_get_request._get_request) do
        table.insert(docs, v:to_multi_request())
    end

    local result = {docs = docs}
    return utils.json_encode(result)
end

function multi_get_request:validate()
    return true
end

function multi_get_request:init_request(call_back)
    local ok, error = self:validate()
    if not ok then
        return call_back(nil, ok, error)
    end

    local method = "POST"
    local path = "/_mget"
    local body = self:generate_body()
    local headers = {["Content-Type"] = "application/json"}

    local query = {}
    self:fill_object(query, "realtime", self._realtime)
    self:fill_object(query, "refresh", self._refresh)
    self:fill_object(query, "preference", self._preference)

    ngx.log(ngx.DEBUG, utils.json_encode(query))
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

return multi_get_request
