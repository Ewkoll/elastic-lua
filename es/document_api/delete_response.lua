local object = require "es.object"
local utils = require "es.utils.utils"

local delete_response = object:extend()

function delete_response:new(response_data)
    delete_response.super.new(self, "delete_response")
    if "string" == type(response_data) then
        self._response_data = response_data
        self._response_json_data = utils.json_decode(response_data)
    else
        self._response_data = utils.json_encode(response_data)
        self._response_json_data = response_data
    end
    self._has_result = (nil ~= self._response_json_data and "table" == type(self._response_json_data))
end

function delete_response:__tostring()
    return tostring(self._response_data)
end

--[[
    The index the document was fetched from.
--]]
function delete_response:get_index()
    if self._has_result then
        return self._response_json_data._index
    end
end

--[[
    The type of the document.
--]]
function delete_response:get_type()
    if self._has_result then
        return self._response_json_data._type
    end
end

--[[
    The id of the document.
--]]
function delete_response:get_id()
    if self._has_result then
        return self._response_json_data._id
    end
end

--[[
    The version of the doc.
--]]
function delete_response:get_version()
    if self._has_result then
        return self._response_json_data._version
    end
end

--[[
    The change that occurred to the document.
--]]
function delete_response:get_result()
    if self._has_result then
        return self._response_json_data.result
    end
end

--[[
    Get the shared info.
--]]
function delete_response:get_shardinfo()
    if self._has_result then
        if nil == self._response_shard_info then
            self._response_shard_info = shard_info(self._response_json_data._shards)
        end
        return self._response_shard_info
    end
end

return delete_response
