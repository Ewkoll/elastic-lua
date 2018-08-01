local object = require "es.object"
local utils = require "es.utils.utils"
local shard_info = require "es.document_api.shard_info"

local index_response = object:extend()

function index_response:new(response_data)
    index_response.super.new(self, "index_response")
    if "string" == type(response_data) then
        self._response_data = response_data
        self._response_json_data = utils.json_decode(response_data)
    else
        self._response_data = utils.json_encode(response_data)
        self._response_json_data = response_data
    end
    self._has_result = (nil ~= self._response_json_data and "table" == type(self._response_json_data))
end

function index_response:__tostring()
    return tostring(self._response_data)
end

--[[
    The index the document was changed in.
--]]
function index_response:get_index()
    if self._has_result then
        return self._response_json_data._index
    end
end

--[[
    The type of the document changed.
--]]
function index_response:get_type()
    if self._has_result then
        return self._response_json_data._type
    end
end

--[[
    The id of the document changed.
--]]
function index_response:get_id()
    if self._has_result then
        return self._response_json_data._id
    end
end

--[[
    Returns the current version of the doc.
--]]
function index_response:get_version()
    if self._has_result then
        return self._response_json_data._version
    end
end

--[[
    Returns the sequence number assigned for this change. Returns {@link SequenceNumbers#UNASSIGNED_SEQ_NO}
    if the operation wasn't performed (i.e., an update operation that resulted in a NOOP).
--]]
function index_response:get_seq_no()
    if self._has_result then
        return self._response_json_data._seq_no
    end
end

--[[
    The primary term for this change.
--]]
function index_response:get_primary_term()
    if self._has_result then
        return self._response_json_data._primary_term
    end
end

--[[
    The change that occurred to the document.
--]]
function index_response:get_result()
    if self._has_result then
        return self._response_json_data.result
    end
end

--[[
    Get the shared info.
--]]
function index_response:get_shardinfo()
    if self._has_result then
        if nil == self._response_shard_info then
            self._response_shard_info = shard_info(self._response_json_data._shards)
        end
        return self._response_shard_info
    end
end

return index_response
