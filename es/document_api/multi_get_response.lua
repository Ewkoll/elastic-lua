local object = require "es.object"
local utils = require "es.utils.utils"
local get_response = require "es.document_api.get_response"

local multi_get_response = object:extend()

function multi_get_response:new(response_data)
    multi_get_response.super.new(self, "multi_get_response")
    if "string" == type(response_data) then
        self._response_data = response_data
        self._response_json_data = utils.json_decode(response_data)
    else
        self._response_data = utils.json_encode(response_data)
        self._response_json_data = response_data
    end
    self._has_result = (nil ~= self._response_json_data and "table" == type(self._response_json_data))
end

function multi_get_response:__tostring()
    return tostring(self._response_data)
end

function multi_get_response:get_responses()
    if self._has_result then
        if nil == self._response then
            local response = {}
            local docs = self._response_json_data
            for _, v in pairs(docs) do
                table.insert(response, get_response(v))
            end
            self._response = response
        end
        return self._response
    end
end

return multi_get_response
