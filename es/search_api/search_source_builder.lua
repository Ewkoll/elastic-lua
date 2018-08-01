local object = require "es.object"
local utils = require "es.utils.utils"

local search_source_builder = object:extend()

function search_source_builder:new()
    search_source_builder.super.new(self, "search_source_builder")
    search_source_builder._from = 0
    search_source_builder._size = 10
    search_source_builder._timeout = "60s"
end

function search_source_builder:__tostring()
    return self:to_context()
end

--[[
    Sets the search query for this request.
--]]
function search_source_builder:query(query_builder)
    if nil ~= query_builder then
        --if query_builder:is(abstract_query_builder) then
            ngx.log(ngx.DEBUG, "3233")
            self._query_builder = query_builder
        --end
    end
    return self
end

--[[
    Sets a filter that will be executed after the query has been executed and
    only has affect on the search hits (not aggregations). This filter is
    always executed as last filtering mechanism.
--]]
function search_source_builder:post_filter(query_builder)
    if nil ~= query_builder and nil ~= query_builder.istypeof then
        if query_builder:istypeof("query_builder") then
            self._post_filter = query_builder
        end
    end
    return self
end

--[[
    From index to start the search from. Defaults to <tt>0</tt>.
--]]
function search_source_builder:from(from)
    if self:is_number(from) then
        if from >= 0 then
            self._from = from
        end
    end
    return self
end

--[[
    The number of search hits to return. Defaults to <tt>10</tt>.
--]]
function search_source_builder:size(size)
    if self:is_number(size) then
        if size >= 0 then
            self._size = size
        end
    end
    return self
end

--[[
    Sets the minimum score below which docs will be filtered out.
--]]
function search_source_builder:min_score(min_score)
    if self:is_number(min_score) then
        self._min_score = min_score
    end
    return self
end

--[[
    Should each be returned with an explanation of the hit (ranking).
--]]
function search_source_builder:explain(explain)
    if self:is_boolean(explain) then
        self._explain = explain
    end
    return self
end

--[[
    Should each be returned with a version associated with it.
--]]
function search_source_builder:version(version)
    if self:is_boolean(from) then
        self._version = version
    end
    return self
end

--[[
    An optional timeout to control how long search is allowed to take. defalt 60s
--]]
function search_source_builder:timeout(timeout)
    if self:is_string(from) then
        self._timeout = timeout
    end
    return self
end

--[[
    An optional terminate_after to terminate the search after collecting <code>terminateAfter</code> documents
--]]
function search_source_builder:terminate_after(terminate_after)
    if self:is_number(terminate_after) then
        if terminate_after >= 0 then
            self._terminate_after = terminate_after
        end
    end
    return self
end

--[[
    Adds a sort against the given field name and the sort ordering.
--]]
function search_source_builder:sort(name, order)
    if nil == self._sort then
        self._sort = {}
    end

    local sort = {}
    sort[name] = order
    table.insert(self._sort, sort)
    return self
end

--[[
    Applies when sorting, and controls if scores will be tracked as well. Defaults to <tt>false</tt>.
--]]
function search_source_builder:track_scores(track_scores)
    if self:is_boolean(track_scores) then
        self._track_scores = track_scores
    end
    return self
end

--[[
    Indicates if the total hit count for the query should be tracked.
--]]
function search_source_builder:track_total_hits(track_total_hits)
    if self:is_boolean(track_total_hits) then
        self._track_total_hits = track_total_hits
    end
    return self
end

--[[
    Set the sort values that indicates which docs this request should "search after".
--]]
function search_source_builder:search_after(search_after_builder)
    if nil ~= search_after_builder then
        self._search_after_builder = search_after_builder
    end
    return self
end

--[[
    Sets a filter that will restrict the search hits, the top hits and the aggregations
    to a slice of the results of the main query.
--]]
function search_source_builder:slice(slice_builder)
    if nil ~= slice_builder then
        self._slice_builder = slice_builder
    end
    return self
end

--[[
    A builder that enables field collapsing on search request.
--]]
function search_source_builder:collapse(collapse_builder)
    if nil ~= collapse_builder then
        self._collapse_builder = collapse_builder
    end
    return self
end

--[[
    Add an aggregation to perform as part of the search.
--]]
function search_source_builder:aggregation(aggregation_builder)
    if nil == self._aggregation_builders then
        self._aggregation_builders = {}
    end

    if nil ~= aggregation_builder then
        table.insert(self._aggregation_builders, aggregation_builder)
    end
    return self
end

--[[
    Adds highlight to perform as part of the search.
--]]
function search_source_builder:highlighter(highlighter_builder)
    if nil ~= highlighter_builder then
        self._highlighter_builder = highlighter_builder
    end
    return self
end

--[[
    Defines how to perform suggesting. This builders allows a number of global options to be specified and
    an arbitrary number of {@link SuggestionBuilder} instances.
 
    Suggesting works by suggesting terms/phrases that appear in the suggest text that are similar compared
    to the terms in provided text. These suggestions are based on several options described in this class.
--]]
function search_source_builder:suggest(suggest_builder)
    if nil ~= suggest_builder then
        self._suggest_builder = suggest_builder
    end
    return self
end

--[[
    The abstract base builder for instances of {@link RescorerBuilder}.
--]]
function search_source_builder:add_rescorer(rescorer_builder)
    if nil == self._rescorer_builders then
        self._rescorer_builders = {}
    end

    if nil ~= rescorer_builder then
        table.insert(self._rescorer_builders, rescorer_builder)
    end
    return self
end

--[[
    Should the query be profiled. Defaults to <tt>false</tt>
--]]
function search_source_builder:profile(profile)
    if self:is_boolean(profile) then
        self._profile = profile
    end
    return self
end

--[[
    Indicates whether the response should contain the stored _source for every hit
--]]
function search_source_builder:fetch_source(fetch_source)
    if self:is_boolean(fetch_source) then
        self._fetch_source = fetch_source
    end
    return self
end

--[[
    Indicates whether the response should contain the stored _source for every hit
--]]
function search_source_builder:fetch_source(includes, excludes)
    self._fetch_source_includes = utils.convert_source(includes)
    self._fetch_source_excludes = utils.convert_source(excludes)
    return self
end

--[[
    Sets the stored fields to load and return as part of the search request. If none
    are specified, the source of the document will be returned.
--]]
function search_source_builder:stored_field(stored_field)
    if self:is_table(stored_field) then
        self._stored_field = stored_field
    end
    return self
end

--[[
    Adds a field to load from the docvalue and return as part of the search request.
--]]
function search_source_builder:doc_value_field(name)
    if nil == self._doc_value_fields then
        self._doc_value_fields = {}
    end

    if self:is_string(name) then
        table.insert(self._doc_value_fields, name)
    end
    return self
end

--[[
    Adds a script field under the given name with the provided script.
--]]
function search_source_builder:script_field(name, script, ignore_failure)
    if nil == self._script_fields then
        self._script_fields = {}
    end

    local script_data = {}
    script_data["name"] = name
    script_data["script"] = script
    script_data["ignore_failure"] = ignore_failure
    table.insert(self._script_fields, script_data)
    return self
end

--[[
    Sets the boost a specific index or alias will receive when the query is executed against it.
--]]
function search_source_builder:index_boost(index, index_boost)
    if nil == self._index_boosts then
        self._index_boosts = {}
    end

    local data = {}
    data[index] = index_boost
    table.insert(self._index_boosts, data)
    return self
end

--[[
    The stats groups this request will be aggregated under.
--]]
function search_source_builder:stats(stats_groups)
    self._stats_groups = stats_groups
    return self
end

--[[
    Intermediate serializable representation of a search ext section. To be subclassed by plugins that support
    a custom section as part of a search request, which will be provided within the ext element.
    Any state needs to be serialized as part of the {@link Writeable#writeTo(StreamOutput)} method and
    read from the incoming stream, usually done adding a constructor that takes {@link StreamInput} as
    an argument.

    Registration happens through {@link SearchPlugin#getSearchExts()}, which also needs a {@link CheckedFunction}
    that's able to parse the incoming request from the REST layer into the proper {@link SearchExtBuilder} subclass.

    {@link #getWriteableName()} must return the same name as the one used for the registration
    of the {@link SearchExtSpec}.
--]]
function search_source_builder:ext(search_ext_builders)
    if self:is_table(search_ext_builders) then
        self._search_ext_builders = search_ext_builders
    end
    return self
end

function search_source_builder:fill_query_builder(table, key, query_builder)
    if nil == query_builder or nil == query_builder.to_content then
        return
    end

    self:fill_object(table, key, query_builder:to_content())
end

--[[
    Generate request body
--]]
function search_source_builder:to_content()
    local content = {}
    self:fill_object(content, "from", self._from)
    self:fill_object(content, "size", self._size)
    self:fill_object(content, "timeout", self._timeout)
    self:fill_query_builder(content, "query", self._query_builder)
    return content
end

return search_source_builder
