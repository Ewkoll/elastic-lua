local global = require "es.document_api.global"
local index_request = require "es.document_api.index_request"
local index_response = require "es.document_api.index_response"
local get_request = require "es.document_api.get_request"
local get_response = require "es.document_api.get_response"
local delete_request = require "es.document_api.delete_request"
local delete_response = require "es.document_api.delete_response"
local shard_info = require "es.document_api.shard_info"
local http_host = require "es.http_host"
local rest_high_level_client = require "es.rest_high_level_client"

local query_builders = require "es.search_api.query_builders"
local search_request = require "es.search_api.search_request"
local search_source_builder = require "es.search_api.search_source_builder"

return {
    query_builders = query_builders,
    search_request = search_request,
    search_source_builder = search_source_builder,
    
    global = global,
    index_request = index_request,
    index_response = index_response,
    get_request = get_request,
    get_response = get_response,
    delete_request = delete_request,
    delete_response = delete_response,
    shard_info = shard_info,
    http_host = http_host,
    rest_high_level_client = rest_high_level_client
}
