local object = require "es.object"
local utils = require "es.utils.utils"

local search_request = object:extend()

function search_request:new(index, types, source)
    search_request.super.new(self, "search_request")
    search_request._indices = "_all"
    search_request._batched_reduce_size = 512
    search_request._prefilter_shard_size = 128
    self:indices(index)
    self:types(types)
    self:source(source)
end

function search_request:__tostring()
    return string.format(
        "indices = %s, types = %s, routing = %s, preference = %s, search_type = %s, \
        source = %s, scroll = %s, request_cache = %s, batched_reduce_size = %d, \
        allow_partial_search_results = %s max_concurrent_shard_requests = %d, prefilter_shard_size = %d",
        (search_request._indices or ""),
        (search_request._types or ""),
        (search_request._routing or ""),
        (search_request._preference or ""),
        (search_request._search_type or ""),
        (search_request._source or ""),
        (search_request._scroll or ""),
        (search_request._cache or "false"),
        (search_request._batched_reduce_size or 512),
        (search_request._allow_partial_search_results or "false"),
        (search_request._max_concurrent_shard_requests or -1),
        (search_request._prefilter_shard_size or 128)
    )
end

--[[
    Sets the indices the search will be executed on.
--]]
function search_request:indices(index)
    if self:is_string(index) then
        search_request._indices = index
    elseif self:is_table(index) then
        search_request._indices = utils.convert_source(index)
    end
    return self
end

--[[
    The document types to execute the search against. Defaults to be executed against all types.
--]]
function search_request:types(types)
    if self:is_string(types) then
        search_request._types = types
    elseif self:is_table(types) then
        search_request._types = utils.convert_source(types)
    end
    return self
end

--[[
    The routing values to control the shards that the search will be executed on.
--]]
function search_request:routing(routing)
    if self:is_string(routing) then
        search_request._routing = routing
    end
    return self
end

--[[
    Sets the preference to execute the search. Defaults to randomize across shards. Can be set to
    <tt>_local</tt> to prefer local shards, <tt>_primary</tt> to execute only on primary shards, or
    a custom value, which guarantees that the same order will be used across different requests.
--]]
function search_request:preference(preference)
    if self:is_string(preference) then
        search_request._preference = preference
    end
    return self
end

--[[
    The search type to execute, defaults to QUERY_THEN_FETCH.
--]]
function search_request:search_type(search_type)
    if nil == search_type or not self:is_string(search_type) then
        return self
    end

    if "dfs_query_then_fetch" == search_type or "query_then_fetch" == search_type then
        search_request._search_type = search_type
    end
    return self
end

--[[
    Sets if this request should use the request cache or not, assuming that it can (for
    example, if "now" is used, it will never be cached). By default (not set, or null,
    will default to the index level setting if request cache is enabled or not).
--]]
function search_request:request_cache(cache)
    if self:is_boolean(cache) then
        search_request._cache = cache
    end
    return self
end

--[[
    Set to false to return an overall failure if the request would produce partial results.
    Defaults to true, which will allow partial results in the case of timeouts or partial failures.
--]]
function search_request:allow_partial_search_results(allow_partial_search_results)
    if self:is_boolean(allow_partial_search_results) then
        search_request._allow_partial_search_results = allow_partial_search_results
    end
    return self
end

--[[
    Sets the number of shard results that should be reduced at once on the coordinating node. This value should
    be used as a protection mechanism to reduce the memory overhead per search request if the potential number
    of shards in the request can be large. batched_reduce_size must be >= 2
--]]
function search_request:set_batched_reduce_size(batched_reduce_size)
    if self:is_number(batched_reduce_size) then
        if batched_reduce_size > 1 then
            search_request._batched_reduce_size = batched_reduce_size
        end
    end
    return self
end

--[[
    Sets the number of shard requests that should be executed concurrently. This value should be used as a
    protection mechanism to reduce the number of shard requests fired per high level search request. Searches
    that hit the entire cluster can be throttled with this number to reduce the cluster load. The default
    grows with the number of nodes in the cluster but is at most <tt>256</tt>.
--]]
function search_request:set_max_concurrent_shard_requests(max_concurrent_shard_requests)
    if self:is_number(max_concurrent_shard_requests) then
        if max_concurrent_shard_requests >= 1 and max_concurrent_shard_requests <= 256 then
            search_request._max_concurrent_shard_requests = max_concurrent_shard_requests
        end
    end
    return self
end

--[[
    Sets a threshold that enforces a pre-filter roundtrip to pre-filter search shards based on query rewriting
    if the number of shards the search request expands to exceeds the threshold. This filter roundtrip can limit
    the number of shards significantly if for instance a shard can not match any documents based on it's rewrite
    method ie. if date filters are mandatory to match but the shard bounds and the query are disjoint.
    The default is <tt>128</tt>
--]]
function search_request:set_prefilter_shard_size(prefilter_shard_size)
    if self:is_number(prefilter_shard_size) then
        if prefilter_shard_size >= 1 then
            search_request._prefilter_shard_size = prefilter_shard_size
        end
    end
    return self
end

--[[
    The maximum number of documents to collect for each shard, upon reaching which the query execution will
    terminate early. If set, the response will have a boolean field terminated_early to indicate whether
    the query execution has actually terminated_early. Defaults to no terminate_after.

    In case we only want to know if there are any documents matching a specific query, we can set the size
    to 0 to indicate that we are not interested in the search results. Also we can set terminate_after to
    1 to indicate that the query execution can be terminated whenever the first matching document was found (per shard).

    size=0&terminate_after=1
--]]
function search_request:terminate_after(terminate_after)
    if self:is_number(terminate_after) then
        search_request._terminate_after = terminate_after
    end
    return self
end

--[[
    The search type to source builder object.
--]]
function search_request:source(source)
    if nil ~= source and nil ~= source.is and source:is(search_source_builder) then
        search_request._source = source
    end
    return self
end

--[[
    If set, will enable scrolling of the search request.
--]]
function search_request:scroll(scroll)
    if nil ~= scroll and nil ~= scroll.is and scroll:is(scroll) then
        search_request._scroll = scroll
    end
    return self
end

function search_request:validate()
    if nil == search_request._source and nil == search_request._scroll then
        return false, "search source is not exists."
    end
    return true
end

function search_request:request_path()
    if nil == search_request._types then
        return string.format("/%s/_search", search_request._indices)
    else
        return string.format("/%s/%s/_search", search_request._indices, search_request._types)
    end
end

function search_request:request_body()
    if nil == search_request._source then
        return
    end

    local content = search_request._source:to_content()
    return utils.json_encode(content)
end

function search_request:init_request(call_back)
    local ok, error = self:validate()
    if not ok then
        return call_back(nil, ok, error)
    end

    local method = "POST"
    local path = self:request_path()
    local body = self:request_body()
    local headers = {["Content-Type"] = "application/json"}
    
    local query = {}
    self:fill_object(query, "routing", search_request._routing)
    self:fill_object(query, "search_type", search_request._search_type)

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

return search_request
