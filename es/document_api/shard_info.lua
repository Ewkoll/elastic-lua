local object = require "es.object"
local utils = require "es.utils.utils"

local shard_info = object:extend()

function shard_info:new(shard_data)
    shard_info.super.new(self, "shard_info")
    self._shard_json_data = utils.json_decode(shard_data)
    self._has_result = (nil ~= self._shard_json_data and "table" == type(self._shard_json_data))
end

function shard_info:__tostring()
    return utils.json_encode(self._shard_json_data)
end

function shard_info:get_total()
    if self._has_result then
        return self._shard_json_data.total
    end
end

function shard_info:get_successful()
    if self._has_result then
        return self._shard_json_data.successful
    end
end

function shard_info:get_failed()
    if self._has_result then
        return self._shard_json_data.failed
    end
end

function shard_info:get_failures()
    if self._has_result then
        return self._shard_json_data.failures
    end
end

return shard_info
