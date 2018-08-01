local object = require "es.object"
local utils = require "es.utils.utils"

local update_request = object:extend()

function update_request:new(index, type, document_id)
    update_request.super.new(self, "update_request")
    self._index = index
    self._type = type
    self._document_id = document_id
end

function update_request:doc(doc)
    if nil == doc then
        return
    end

    if "string" == type(doc) then
        doc = utils.json_decode(doc)
    end

    local update_document = {doc = doc}
    self._doc = utils.json_encode(update_document)
end

function update_request:routing(routing)
    if nil ~= routing and "string" == type(routing) then
        self._routing = routing
    end
end

function update_request:parent(parent)
    if nil ~= parent and "string" == type(parent) then
        self._parent = parent
    end
end

function update_request:timeout(timeout)
    if nil ~= timeout and "string" == type(timeout) then
        self._timeout = timeout
    end
end

function update_request:set_refresh_policy(policy)
    if nil ~= policy and "string" == type(policy) then
        if "false" == policy or "ture" == policy or "wait_for" == policy then
            self._policy = policy
        end
    end
end

function update_request:retry_on_conflict(count)
    if nil ~= count and "number" == type(count) then
        self._retry_on_conflict = count
    end
end

function update_request:fetch_source(source)
    if nil ~= source and "boolean" == type(source) then
        self._source = source
    end
end

function update_request:fetch_include_source(content)
    if nil ~= content and "table" == type(content) then
        self._fetch_include_source = utils.convert_source(content)
    end
end

function update_request:fetch_exclues_source(content)
    if nil ~= content and "table" == type(content) then
        self._fetch_exclues_source = utils.convert_source(content)
    end
end

function update_request:detect_noop(noop)
    if nil ~= noop and "boolean" == type(noop) then
        self._detect_noop = noop
    end
end

function update_request:scripted_upsert(upsert)
    if nil ~= upsert and "boolean" == type(upsert) then
        self._scripted_upsert = upsert
    end
end

function update_request:doc_as_upsert(upsert)
    if nil ~= upsert and "boolean" == type(upsert) then
        self._doc_as_upsert = upsert
    end
end

function update_request:version(version)
    if nil ~= version and "number" == type(version) then
        self._version = version
    end
end

function update_request:wait_for_active_shards(wait_size)
    if nil ~= wait_size and "number" == type(wait_size) then
        if -1 == wait_size then
            self._wait_for_active_shards = "all"
        else
            self._wait_for_active_shards = tostring(wait_size)
        end
    end
end

function update_request:version_type(version_type)
    self._version_type = version_type
end

function update_request:to_bulk()
    local ok, error = self:validate()
    if not ok then
        return ok, error
    end

    local update = {update = {_index = self._index, _type = self._type, _id = self._document_id}}
    return utils.json_encode(update) .. "\n" .. (self._doc or "")
end

function update_request:validate()
    return true
end

function update_request:init_request(call_back)
    local ok, error = self:validate()
    if not ok then
        return call_back(nil, ok, error)
    end

    local method = "POST"
    local path =
        string.format("/%s/%s/%s/_update", tostring(self._index), tostring(self._type), tostring(self._document_id))
    local body = self._doc or ""
    local headers = {["Content-Type"] = "application/json"}

    local query = {}
    self:fill_object(query, "routing", self._routing)
    self:fill_object(query, "parent", self._parent)
    self:fill_object(query, "timeout", self._timeout)
    self:fill_object(query, "refresh", self._policy)
    self:fill_object(query, "retry_on_conflict", self._retry_on_conflict)
    self:fill_object(query, "_source", self._source)
    self:fill_object(query, "_source_include", self._fetch_include_source)
    self:fill_object(query, "_source_exclude", self._fetch_exclues_source)
    self:fill_object(query, "version", self._version)
    self:fill_object(query, "version_type", self._version_type)
    self:fill_object(query, "doc_as_upsert", self._doc_as_upsert)
    self:fill_object(query, "wait_for_active_shards", self._wait_for_active_shards)

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

return update_request
