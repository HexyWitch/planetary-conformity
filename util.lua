function printf(s, ...)
    print(s:format(...))
end

function debugLog(s, ...)
    if config.debug then
        printf(s, ...)
    end
end