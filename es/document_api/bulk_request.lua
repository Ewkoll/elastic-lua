local object = require "es.object"
local utils = require "es.utils.utils"

local bulk_request = object:extend()

function bulk_request:new()
    bulk_request.super.new(self, "bulk_request")
    self._bulk = {}
end

function bulk_request:timeout(timeout)
    if nil ~= timeout and "string" == type(timeout) then
        self._timeout = timeout
    end
end

function bulk_request:set_refresh_policy(policy)
    if nil ~= policy and "string" == type(policy) then
        if "false" == policy or "ture" == policy or "wait_for" == policy then
            self._policy = policy
        end
    end
end

function bulk_request:wait_for_active_shards(wait_size)
    if nil ~= wait_size and "number" == type(wait_size) then
        if -1 == wait_size then
            self._wait_for_active_shards = "all"
        else
            self._wait_for_active_shards = tostring(wait_size)
        end
    end
end

function bulk_request:add(bulk_object)
    if nil == bulk_object.istypeof or nil == bulk_object.to_bulk then
        return
    end

    if
        not bulk_object:istypeof("delete_request") or not bulk_object:istypeof("update_request") or
            not bulk_object:istypeof("index_request")
     then
        return
    end

    table.insert(self._bulk, bulk_object)
end

function bulk_request:validate()
    return true
end

function bulk_request:init_request(call_back)
    local ok, error = self:validate()
    if not ok then
        return call_back(nil, ok, error)
    end

    local method = "POST"
    local path = "/_bulk"
    local headers = {["Content-Type"] = "application/json"}

    local query = {}
    self:fill_object(query, "timeout", self._timeout)
    self:fill_object(query, "refresh", self._policy)
    self:fill_object(query, "wait_for_active_shards", self._wait_for_active_shards)

    local body = ""
    for _, v in pairs(self._bulk) do
        if "" == body then
            body = v:to_bulk()
        else
            body = body .. "\n" .. v:to_bulk()
        end
    end

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

return bulk_request
