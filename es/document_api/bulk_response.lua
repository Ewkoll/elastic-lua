local object = require "es.object"
local utils = require "es.utils.utils"
local index_response = require "es.document_api.index_response"
local delete_response = require "es.document_api.delete_response"
local update_response = require "es.document_api.update_response"

local bulk_response = object:extend()

function bulk_response:new(response_data)
    bulk_response.super.new(self, "bulk_response")
    self._response_data = response_data
    self._response_json_data = utils.json_decode(response_data)
    self._items = {}
    self._has_result = (nil ~= self._response_json_data and "table" == type(self._response_json_data))
    if self._has_result then
        local items = self._response_json_data.items
        for _, v in pairs(items) do
            if nil ~= v.delete then
                table.insert(self._items, delete_response(v.delete))
            elseif nil ~= v.update then
                table.insert(self._items, update_response(v.update))
            elseif nil ~= v.index or nil ~= v.created then
                table.insert(self._items, index_response(v.index or v.created))
            end
        end
    end
end

function bulk_response:__tostring()
    return tostring(self._response_data)
end

--[[
    The index the document was fetched from.
--]]
function bulk_response:get_took()
    if self._has_result then
        return self._response_json_data.took
    end
end

--[[
    The index the document errors flags.
--]]
function bulk_response:errors()
    if self._has_result then
        return self._response_json_data.took
    end
end

--[[
    The response of bulk request.
--]]
function bulk_response:get_response()
    if self._has_result then
        return self._items
    end
end

return bulk_response
