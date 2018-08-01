local object = require "es.object"
local utils = require "es.utils.utils"

local main_response = object:extend()

function main_response:new(response_data)
    main_response.super.new(self, "main_response")
    if "string" == type(response_data) then
        self._response_data = response_data
        self._response_json_data = utils.json_decode(response_data)
    else
        self._response_data = utils.json_encode(response_data)
        self._response_json_data = response_data
    end
    self._has_result = (nil ~= self._response_json_data and "table" == type(self._response_json_data))
end

function main_response:__tostring()
    return "main_response"
end

function main_response:get_version()
    if self._has_result then
        return self._response_json_data.version
    end
end

function main_response:get_cluster_name()
    if self._has_result then
        return self._response_json_data.cluster_name
    end
end

function main_response:get_cluster_uuid()
    if self._has_result then
        return self._response_json_data.cluster_uuid
    end
end

function main_response:get_name()
    if self._has_result then
        return self._response_json_data.name
    end
end

function main_response:get_tagline()
    if self._has_result then
        return self._response_json_data.tagline
    end
end

return main_response
