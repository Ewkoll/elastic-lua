local abstract_query_builder = require "es.search_api.abstract_query_builder"
local utils = require "es.utils.utils"

local match_all_query = abstract_query_builder:extend()

function match_all_query:new()
    match_all_query.super.new(self, "match_all_query")
    match_all_query._NAME = "match_all"
end

function match_all_query:__tostring()
    return utils.json_encode(self:to_content())
end

function match_all_query:to_content()
    local content = {}
    content[match_all_query._NAME] = match_all_query.super:to_content()
    return content
end

return match_all_query
