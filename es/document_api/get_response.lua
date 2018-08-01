local object = require "es.object"
local utils = require "es.utils.utils"

local get_response = object:extend()

function get_response:new(response_data)
    get_response.super.new(self, "get_response")
    if "string" == type(response_data) then
        self._response_data = response_data
        self._response_json_data = utils.json_decode(response_data)
    else
        self._response_data = utils.json_encode(response_data)
        self._response_json_data = response_data
    end
    self._has_result = (nil ~= self._response_json_data and "table" == type(self._response_json_data))
end

function get_response:__tostring()
    return tostring(self._response_data)
end

--[[
    The index the document was fetched from.
--]]
function get_response:get_index()
    if self._has_result then
        return self._response_json_data._index
    end
end

--[[
    The type of the document.
--]]
function get_response:get_type()
    if self._has_result then
        return self._response_json_data._type
    end
end

--[[
    The id of the document.
--]]
function get_response:get_id()
    if self._has_result then
        return self._response_json_data._id
    end
end

--[[
    The version of the doc.
--]]
function get_response:get_version()
    if self._has_result then
        return self._response_json_data._version
    end
end

--[[
    The document is exists.
--]]
function get_response:is_exists()
    if self._has_result then
        return self._response_json_data.found
    end
end

--[[
    The source of the document (as a object).
--]]
function get_response:get_source()
    if self._has_result then
        return self._response_json_data._source
    end
end

--[[
    The source of the document (as a string).
--]]
function get_response:get_source_as_string()
    if self._has_result then
        return utils.json_encode(self._response_json_data._source)
    end
end

return get_response
