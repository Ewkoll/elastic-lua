local object = require "es.object"

local post_filter = object:extend()

function post_filter:new()
    post_filter.super.new(self, "post_filter")
end

function post_filter:init(key, value)
    self._key = key
    self._value = value
end

function post_filter:to_content()
    local term = {}
    term[self._key] = self._value
    return {term}
end

return post_filter
