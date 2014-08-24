vec2 = {}

function vec2.distance(first, second)
    return {first[1] - second[1], first[2] - second[2]}
end

function vec2.magnitude(first, second)
    local distance = vec2.distance(first, second)
    return math.sqrt(distance[1] * distance[1] + distance[2] * distance[2])
end

function vec2.normalize(vec)
    local length = math.sqrt(vec[1] * vec[1] + vec[2] * vec[2])
    return {vec[1] / length, vec[2] / length}
end

function vec2.mul(vec, factor)
    if type(factor) == "table" then
        return {vec[1] * factor[1], vec[2] * factor[2]}
    else
        return {vec[1] * factor, vec[2] * factor}
    end
end

function vec2.add(first, second)
    if type(second) == "table" then
        return {first[1] + second[1], first[2] + second[2]}
    else
        return {first[1] + second, first[2] + second}
    end
end

function vec2.length(vec)
    return math.sqrt(vec[1] * vec[1] + vec[2] * vec[2])
end