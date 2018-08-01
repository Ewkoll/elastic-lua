local object = require "es.object"

local abstract_query_builder = object:extend()

function abstract_query_builder:new(name)
    abstract_query_builder.super.new(self, name or "abstract_query_builder")
    abstract_query_builder._boost = 1.0
    abstract_query_builder._name_field = "_name"
    abstract_query_builder._boost_field = "boost"
end

function abstract_query_builder:__tostring()
    return string.format(
        "boost: %s, query_name: %s",
        tostring(abstract_query_builder._boost),
        tostring(abstract_query_builder._query_name)
    )
end

function abstract_query_builder:to_content()
    local content = {}
    self:fill_object(content, abstract_query_builder._boost_field, abstract_query_builder._boost)
    self:fill_object(content, abstract_query_builder._name_field, abstract_query_builder._query_name)
    return content
end

function abstract_query_builder:boost(boost)
    if self:is_number(boost) then
        abstract_query_builder._boost = boost
    end
    return self
end

function abstract_query_builder:query_name(query_name)
    if self:is_string(query_name) then
        abstract_query_builder._query_name = query_name
    end
    return self
end

return abstract_query_builder
