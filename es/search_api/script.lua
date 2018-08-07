local object = require "es.object"

local script = object:extend()

function script:new()
    script.super.new(self, "script")
    script._script = {}
end

function script:init(name, source, params)
    if nil == name or not self:is_string(name) then
        return
    end

    if nil == source or not self:is_string(source) then
        return
    end

    if nil == params or not self:is_table(params) then
        return
    end

    local script_item = {}
    script_item._name = name
    script_item._source = source
    script_item._params = params
    table.insert(script._script, script_item)
    return self
end

function script:to_content()
    local script_fields = {}
    for _, v in pairs(script._script) do
        local script_item = {}
        local data = {}
        data["lang"] = "painless"
        data["source"] = v._source
        data["params"] = v._params
        script_item[v._name] = {script = data}
        table.insert(script_fields, script_item)
    end
    return script_fields
end

return script
