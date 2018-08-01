local object = require "es.object"
local utils = require "es.utils.utils"

local delete_request = object:extend()

function delete_request:new(index, type, document_id)
    delete_request.super.new(self, "delete_request")
    self._index = index
    self._type = type
    self._document_id = document_id
end

function delete_request:routing(routing)
    self._routing = routing
end

function delete_request:parent(parent)
    self._parent = parent
end

function delete_request:timeout(timeout)
    self._timeout = timeout
end

function delete_request:set_refresh_policy(policy)
    self._policy = policy
end

function delete_request:version(version)
    self._version = version
end

function delete_request:version_type(version_type)
    self._version_type = version_type
end

function delete_request:to_bulk()
    local ok, error = self:validate()
    if not ok then
        return ok, error
    end

    local delete = {delete = {_index = self._index, _type = self._type, _id = self._document_id}}
    return utils.json_encode(delete)
end

function delete_request:validate()
    return true
end

function delete_request:init_request(call_back)
    local ok, error = self:validate()
    if not ok then
        return call_back(nil, ok, error)
    end

    local method = "DELETE"
    local path = string.format("/%s/%s/%s", tostring(self._index), tostring(self._type), tostring(self._document_id))
    local headers = {}

    local query = {}
    self:fill_object(query, "routing", self._routing)
    self:fill_object(query, "timeout", self._timeout)
    self:fill_object(query, "parent", self._parent)
    self:fill_object(query, "refresh", self._policy)
    self:fill_object(query, "version", self._version)
    self:fill_object(query, "version_type", self._version_type)

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

return delete_request
