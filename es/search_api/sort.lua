local object = require "es.object"
local utils = require "es.utils.utils"

local sort = object:extend()

function sort:new()
    sort.super.new(self, "sort")
    sort._sort = {}
    sort._geo_sort = {}
    sort._unmapped_type = {}
end

function sort:check_value(value)
    if nil == value or not self:is_string(value) then
        return false
    end
    return true
end

--[[
    "user": {
        "type": "keyword"
    }
    key.keyword
    mode "price": [20, 4]
--]]
function sort:sort_key(key, order, mode)
    if not self:check_value(key) or not self:check_value(order) or (nil ~= mode and not self:is_string(mode)) then
        return
    end

    if nil ~= order then
        if "asc" ~= order or "desc" ~= order then
            return
        end
    end

    if nil ~= order then
        if "min" ~= mode or "max" ~= mode or "sum" ~= mode or "avg" ~= mode or "median" ~= mode then
            return
        end
    end

    local sort_item = {}
    sort_item._key = key
    sort_item._order = order
    sort_item._mode = mode
    table.insert(sort._sort, sort_item)
end

function sort:unmapped_type(key, type_value)
    if not self:check_value(key) or not self:check_value(type_vale) then
        return
    end

    local sort_item = {}
    sort_item._key = key
    sort_item._type_value = type_value
    table.insert(sort._unmapped_type, sort_item)
end

--[[
    default to key:             pin.location
    default to order:           asc or desc
    default to unit:            km
    default to distance_type:   arc or plane(faster, but inaccurate on long distances and close to the poles)
--]]
function sort:geo_sort(key, lat, lon, order, mode, unit, distance_type)
    -- key              = key or "pin.location"
    -- order            = order or "asc"
    -- unit             = unit or "km"
    -- mode             = mode or "min"
    -- distance_type    = distance_type or "arc"

    local geo_item = {}
    geo_item._key = key
    geo_item._lat = lat
    geo_item._lon = lon
    geo_item._order = order
    geo_item._mode = mode
    geo_item._unit = unit
    geo_item._distance_type = distance_type
    table.insert(sort._geo_sort, geo_item)
end

function sort:to_content()
    local sort_result = {}

    for _, v in pairs(sort._sort) do
        local sort_data = {}
        sort_data[v._key] = {order = v._order, mode = v._mode}
        table.insert(sort_result, sort_data)
    end

    for _, v in pairs(sort._unmapped_type) do
        local sort_data = {}
        sort_data[v._key] = {unmapped_type = v._type_value}
        table.insert(sort_result, sort_data)
    end

    for _, v in pairs(sort._geo_sort) do
        local _geo_distance = {}
        _geo_distance[v._key] = {lat = v._lat, lon = v._lon}
        _geo_distance["order"] = v._order or "asc"
        _geo_distance["unit"] = v._unit or "km"
        _geo_distance["mode"] = v._mode
        _geo_distance["distance_type"] = v._distance_type
        table.insert(sort_result, {_geo_distance = _geo_distance})
    end

    return sort_result
end

function sort:__tostring()
    return utils.json_encode(self:to_content())
end

return sort
