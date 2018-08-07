local object = require "es.object"

local highlighter = object:extend()

function highlighter:new()
    highlighter.super.new(self, "highlighter")
    highlighter._fields = {}
end

function highlighter:type(type)
    if nil == type or not self:is_string(type) then
        return self
    end

    if "unified" ~= type and "plain" ~= type and "fvh" ~= type then
        return self
    end

    highlighter._type = type
    return self
end

function highlighter:order()
    highlighter._order = "score"
    return self
end

function highlighter:fields(field)
    if nil ~= field and nil ~= field.is and field:is(highlighter_fields) then
        table.insert(highlighter._fields, field)
    end
    return self
end

function highlighter:fragment_size(fragment_size)
    if nil ~= fragment_size and self:is_number(fragment_size) then
        highlighter._fragment_size = fragment_size
    end
    return self
end

function highlighter:number_of_fragments(number_of_fragments)
    if nil ~= number_of_fragments and self:is_number(number_of_fragments) then
        highlighter._number_of_fragments = number_of_fragments
    end
    return self
end

function highlighter:to_content()
    local content = {}
    self:fill_object(content, "fragmenter", self._fragmenter)
    self:fill_object(content, "fragment_size", self._fragment_size)
    self:fill_object(content, "type", self._type)
    self:fill_object(content, "order", self._order)
    self:fill_object(content, "fields", self._fields)
    return content
end

return highlighter
