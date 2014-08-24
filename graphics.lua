require "vec2"

love.graphics.dashline = function(x1, y1, x2, y2, dashlength, gaplength)
    local distance = vec2.distance({x2, y2}, {x1, y1})
    local magnitude = vec2.length(distance)
    local normal = vec2.normalize(distance)

    for i = 0, magnitude / (dashlength + gaplength) do
        local startLine = vec2.mul(normal, (dashlength + gaplength) * i)
        local endLine = vec2.add(startLine, vec2.mul(normal, dashlength))
        love.graphics.line(x1 + startLine[1], y1 + startLine[2], x1 + endLine[1], y1 + endLine[2])
    end
end