local object = require "es.object"
local utils = require "es.utils.utils"
local global = require "es.document_api.global"

local get_request = object:extend()

function get_request:new(index, type, document_id)
    get_request.super.new(self, "get_request")
    self._index = index
    self._type = type or "_all"
    self._document_id = document_id
end

--[[
    Controls the shard routing of the request. Using this value to hash the shard and not the id.
--]]
function get_request:routing(routing)
    self._routing = routing
end

--[[
    Sets the parent id of this document.
--]]
function get_request:parent(parent)
    self._parent = parent
end

--[[
    Sets the preference to execute the search. Defaults to randomize across shards. Can be set to
    <tt>_local</tt> to prefer local shards, <tt>_primary</tt> to execute only on primary shards, or
    a custom value, which guarantees that the same order will be used across different requests.
--]]
function get_request:preference(preference)
    self._preference = preference
end

--[[
    Allows setting the {@link FetchSourceContext} for this request, controlling if and how _source should be returned.
--]]
function get_request:not_fetchsource()
    self._source = false
end

--[[
    Allows setting the {@link FetchSourceContext} for this request, controlling if and how _source should be returned.
--]]
function get_request:fetch_include_source(content)
    self._fetch_include_source = utils.convert_source(content)
end

--[[
    Allows setting the {@link FetchSourceContext} for this request, controlling if and how _source should be returned.
--]]
function get_request:fetch_exclues_source(content)
    self._fetch_exclues_source = utils.convert_source(content)
end

--[[
    Explicitly specify the stored fields that will be returned. By default, the <tt>_source</tt> field will be returned.
--]]
function get_request:stored_fields(fields)
    self._stored_fields = convert_source(fields)
end

--[[
    Should a refresh be executed before this get operation causing the operation to
    return the latest value. Note, heavy get should not set this to <tt>true</tt>. Defaults to <tt>false</tt>.
--]]
function get_request:refresh(refresh)
    self._refresh = refresh
end

--[[
    Set realtime flag to false (true by default)
--]]
function get_request:realtime(realtime)
    self._realtime = realtime
end

--[[
    Sets the version, which will cause the get operation to only be performed if a matching
    version exists and no changes happened on the doc since then.
--]]
function get_request:version(version)
    self._version = version
end

--[[
    Sets the versioning type. Defaults to {@link org.elasticsearch.index.VersionType#INTERNAL}.
--]]
function get_request:version_type(version_type)
    self._version_type = version_type
end

--[[
    Init check exists params.
--]]
function get_request:init_exists_check()
    self:not_fetchsource()
    self:stored_fields({"_none_"})
end

--[[
    Used by multi get request.
--]]
function get_request:to_multi_request()
    local ok, error = self:validate()
    if not ok then
        return ok, error
    end

    local result = {}
    result["_index"] = self._index
    result["_type"] = self._type
    result["_id"] = self._document_id
    result["routing"] = self._routing
    result["parent"] = self._parent
    result["_source"] = self._source
    result["stored_fields"] = self._stored_fields
    result["version"] = self._version or global.Version.MATCH_ANY
    result["version_type"] = self._version_type or global.VersionType.INTERNAL
    return true, nil, result
end

function get_request:validate()
    return true
end

function get_request:init_request(call_back)
    local ok, error = self:validate()
    if not ok then
        return call_back(nil, ok, error)
    end

    local method = "GET"
    local path = string.format("/%s/%s/%s", tostring(self._index), tostring(self._type), tostring(self._document_id))
    local headers = {}

    local query = {}
    self:fill_object(query, "routing", self._routing)
    self:fill_object(query, "parent", self._parent)
    self:fill_object(query, "version", self._version)
    self:fill_object(query, "realtime", self._realtime)
    self:fill_object(query, "refresh", self._refresh)
    self:fill_object(query, "stored_fields", self._stored_fields)
    self:fill_object(query, "preference", self._preference)
    self:fill_object(query, "_source", self._source)
    self:fill_object(query, "_source_include", self._fetch_include_source)
    self:fill_object(query, "_source_exclude", self._fetch_exclues_source)

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

return get_request
