local http = require "es.http.http"

local error_message = {
    "param error...",
    "http new failed..."
}

local http_client = function(host, port, path, body, query, method, headers, timeout)
    local recive_body = ""
    local result = false
    local ok, err, res, error
    for _ = 1, 1, 1 do
        if nil == host or nil == port or nil == path then
            error = error_message[1]
            break
        end

        local httpc = http.new()
        if nil == httpc then
            error = error_message[2]
            break
        end

        timeout = timeout or 5000
        httpc:set_timeout(timeout)

        ok, err = httpc:connect(host, tonumber(port))
        if not ok then
            error = err
            break
        end

        method = method or "POST"
        body = body or ""
        query = query or {}
        headers = headers or {["Content-Type"] = "application/json", ["charset"] = "UTF-8"}

        res, err =
            httpc:request(
            {
                method = method,
                path = path,
                query = query,
                body = body,
                headers = headers
            }
        )

        if not res then
            httpc:close()
            error = err
            break
        end

        local reader = res.body_reader
        local chunk
        repeat
            chunk, err = reader(8192)
            if err then
                httpc:close()
                error = err
                break
            end

            if chunk then
                recive_body = recive_body .. chunk
            end
        until not chunk

        if nil ~= error then
            break
        end

        ok, err = httpc:set_keepalive()
        if not ok then
            httpc:close()
            error = err
            break
        end

        result = true
    end
    return result, error, recive_body, res.status
end

return {
    http_client = http_client
}
