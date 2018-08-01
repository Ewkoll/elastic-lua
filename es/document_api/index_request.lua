local object = require "es.object"
local utils = require "es.utils.utils"

local index_request = object:extend()

function index_request:new(index, type, document_id)
    index_request.super.new(self, "index_request")
    self._index = index
    self._type = type
    self._document_id = document_id
end

function index_request:source(input_data)
    self._input_data = input_data
end

function index_request:routing(routing)
    self._routing = routing
end

function index_request:parent(parent)
    self._parent = parent
end

--[[
    timeout:    Timeout to wait for primary shard to become available as a TimeValue
                default value : 1m
--]]
function index_request:timeout(timeout)
    self._timeout = timeout
end

--[[
    false：     Don't refresh after this request. The default.
    true:       Force a refresh as part of this request. This refresh policy does not scale for high indexing or
                search throughput but is useful  to present a consistent view to for indices with very low traffic.
                And it is wonderful for tests!
    wait_for:   Leave this request open until a refresh has made the contents of this request visible to search.
                This refresh policy is compatible with high indexing and search throughput but it causes the
                request to wait to reply until a refresh occurs.
--]]
function index_request:set_refresh_policy(policy)
    self._policy = policy
end

function index_request:version(version)
    self._version = version
end

function index_request:version_type(version_type)
    self._version_type = version_type
end

--[[
    op_type: enum[create, index]
--]]
function index_request:op_type(op_type)
    self._op_type = op_type
end

--[[
    pipeline:   The name of the ingest pipeline to be executed before indexing the document
--]]
function index_request:set_pipeline(pipeline)
    self._pipeline = pipeline
end

function index_request:validate()
    if nil == self._index or nil == self._type or nil == self._document_id then
        return false, "index、type、document_id is nil value..."
    end

    return true
end

function index_request:init_request(call_back)
    local ok, error = self:validate()
    if not ok then
        return call_back(nil, ok, error)
    end

    local method = "PUT"
    local body = self._input_data
    local path = string.format("/%s/%s/%s", tostring(self._index), tostring(self._type), tostring(self._document_id))
    local headers = {["Content-Type"] = "application/json"}

    if self._op_type == "create" then
        path = path + "/_create"
    end

    local query = {}
    self:fill_object(query, "routing", self._routing)
    self:fill_object(query, "timeout", self._timeout)
    self:fill_object(query, "pipeline", self._pipeline)
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

return index_request
