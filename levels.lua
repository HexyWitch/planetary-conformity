levels = {}

--Level 1
levels[#levels+1] = function(universe)
    universe.startMessage = "Click to select your planet, then convert the neutral planet"

    --Player
    universe:newPlanet(4.4, 4.8, 0.2, 2)

    --Neutrals
    universe:newPlanet(8.4, 4.8, 0.2, 1)

    --Hostiles
end

--Level 2
levels[#levels+1] = function(universe)
    universe.startMessage = "Red planets will fight back"

    --Player
    universe:newPlanet(4.4, 4.8, 0.3, 2)

    --Hostiles
    universe:newPlanet(8.4, 4.8, 0.2, 3)
end

--Level 3
levels[#levels+1] = function(universe)
    universe.startMessage = "Converted planets will assist you"

    --Player
    universe:newPlanet(4.4, 4.8, 0.2, 2)

    --Neutrals
    universe:newPlanet(3, 2, 0.2, 1)

    --Hostiles
    universe:newPlanet(8.4, 4.8, 0.23, 3)
end

--Level 4
levels[#levels+1] = function(universe)
    universe.startMessage = "Select a planet and right click to connect it to a friendly planet"

    --Player
    universe:newPlanet(4.4, 4.8, 0.2, 2)
    universe:newPlanet(4.4, 4, 0.2, 2)

    --Hostiles
    local hostile1 = universe:newPlanet(8.4, 4.8, 0.25, 3)
    local hostile2 = universe:newPlanet(9, 4.2, 0.15, 3)
    universe:connectPlanets(hostile1, hostile2)
end

--Level 5
levels[#levels+1] = function(universe)
    universe.startMessage = "You don't have to fight alone"

    --Player
    local friendly1 = universe:newPlanet(3, 5, 0.25, 2)
    local friendly2 = universe:newPlanet(3.5, 4.2, 0.2, 2)
    universe:connectPlanets(friendly1, friendly2)

    --Hostiles
    local hostile1 = universe:newPlanet(8.4, 4.8, 0.30, 3)
end

--Level 6
levels[#levels+1] = function(universe)
    universe.startMessage = "Know your enemy"

    --Player
    local friendly1 = universe:newPlanet(3, 5, 0.3, 2)

    --Hostiles
    local hostile1 = universe:newPlanet(8.4, 6, 0.4, 3)

    local hostile2 = universe:newPlanet(6, 3, 0.25, 3)
    local hostile3 = universe:newPlanet(6.7, 3.9, 0.20, 3)
    universe:connectPlanets(hostile2, hostile3)
end

--Level 7
levels[#levels+1] = function(universe)
    universe.startMessage = "Find the weak spot"

    --Player
    local friendly1 = universe:newPlanet(3, 5, 0.3, 2)

    --Hostiles
    local hostile1 = universe:newPlanet(9.1, 8, 0.6, 3)

    local hostile2 = universe:newPlanet(7, 2, 0.35, 3)
    local hostile3 = universe:newPlanet(7.5, 2.5, 0.20, 3)
    local hostile4 = universe:newPlanet(6.5, 2.5, 0.20, 3)
    local hostile5 = universe:newPlanet(6.5, 1.5, 0.20, 3)
    local hostile6 = universe:newPlanet(7.5, 1.5, 0.20, 3)
    universe:connectPlanets(hostile2, hostile3)
    universe:connectPlanets(hostile2, hostile4)
    universe:connectPlanets(hostile2, hostile5)
    universe:connectPlanets(hostile2, hostile6)

    universe:connectPlanets(hostile3, hostile4)
    universe:connectPlanets(hostile4, hostile5)
end


--Level 8
levels[#levels+1] = function(universe)
    universe.startMessage = "Military planets are strong, but have little defence and will not assist connected planets"

    --Player
    universe:newPlanet(3, 5, 0.3, 2)

    --Neutral
    universe:newPlanet(2, 2, 0.3, 2, "strong")

    --Hostiles
    local hostile1 = universe:newPlanet(6, 5, 0.4, 3)
end

--Level 9
levels[#levels+1] = function(universe)
    universe.startMessage = "Quantity isn't everything"

    --Player
    local friendly1 = universe:newPlanet(3, 5, 0.3, 2)
    local friendly2 = universe:newPlanet(2.3, 5.7, 0.3, 2)
    local friendly3 = universe:newPlanet(2.3, 4.3, 0.3, 2)
    local friendly4 = universe:newPlanet(2.1, 5, 0.3, 2, "strong")

    universe:connectPlanets(friendly1, friendly2)
    universe:connectPlanets(friendly1, friendly3)
    universe:connectPlanets(friendly1, friendly4)

    --Neutral

    --Hostiles
    local hostile1 = universe:newPlanet(6, 5, 0.5, 3)
end

--Level 10
levels[#levels+1] = function(universe)
    universe.startMessage = "Results may vary"

    --Player
    local friendly1 = universe:newPlanet(11, 8, 0.3, 2)

    --Neutral

    --Hostiles
    local hostile1 = universe:newPlanet(3, 3, 0.25, 3, "strong")
    local hostile2 = universe:newPlanet(2.5, 2, 0.25, 3)
    local hostile3 = universe:newPlanet(2, 2.5, 0.25, 3)
    universe:connectPlanets(hostile1, hostile2)
    universe:connectPlanets(hostile1, hostile3)
    universe:connectPlanets(hostile2, hostile3)


    local hostile1 = universe:newPlanet(8, 4, 0.25, 3, "strong")
    local hostile2 = universe:newPlanet(8.5, 3, 0.25, 3)
    local hostile3 = universe:newPlanet(9.3, 4.1, 0.25, 3)
    universe:connectPlanets(hostile1, hostile2)
    universe:connectPlanets(hostile2, hostile3)


    local hostile1 = universe:newPlanet(4, 8, 0.25, 3, "strong")
    local hostile2 = universe:newPlanet(3.6, 7.2, 0.25, 3)
    local hostile3 = universe:newPlanet(2.1, 8.6, 0.25, 3)
    universe:connectPlanets(hostile1, hostile2)
    universe:connectPlanets(hostile1, hostile3)
end


--Level 11
levels[#levels+1] = function(universe)
    universe.startMessage = "Fortified planets have a strong defence and will greatly assist connected planets, but are weak"

    --Player
    local friendly1 = universe:newPlanet(4, 3, 0.3, 2)

    --Neutral
    universe:newPlanet(3, 7, 0.3, 1, "healthy")

    --Hostiles
    local hostile1 = universe:newPlanet(10, 5, 0.5, 3)
end

--Level 12
levels[#levels+1] = function(universe)
    universe.startMessage = "Dynamic duo"

    --Player
    local friendly2 = universe:newPlanet(5.5, 5.1, 0.3, 2, "strong")
    local friendly3 = universe:newPlanet(7.0, 5.1, 0.3, 2, "healthy")
    universe:connectPlanets(friendly2, friendly3)


    --Hostiles
    local hostile1 = universe:newPlanet(10, 5, 0.5, 3)
    for a = 0, 6.28, 1.58 do
        local hostile2 = universe:newPlanet(10 + math.cos(a) * 1.5, 5 + math.sin(a) * 1.5, 0.3, 3, "healthy")
        universe:connectPlanets(hostile1, hostile2)
    end
end

--Level 13
levels[#levels+1] = function(universe)
    universe.startMessage = "The holy trinity"

    --Player
    local friendly1 = universe:newPlanet(5.3, 4, 0.2, 2)
    local friendly2 = universe:newPlanet(4.5, 5.1, 0.25, 2, "strong")
    local friendly3 = universe:newPlanet(6.0, 5.1, 0.2, 2, "healthy")


    --Hostiles
    local hostile1 = universe:newPlanet(2, 3, 0.8, 3, "strong")
    local hostile2 = universe:newPlanet(2.5, 2, 0.2, 3, "healthy")
    local hostile3 = universe:newPlanet(1.5, 2, 0.2, 3, "healthy")
    universe:connectPlanets(hostile1, hostile2)
    universe:connectPlanets(hostile1, hostile3)

    local hostile1 = universe:newPlanet(10, 5, 0.8, 3)
end


--Level 14
levels[#levels+1] = function(universe)
    universe.startMessage = "Diplomatic planets are weak on defence and offence, but boost the offence of any planet they're connected to"

    --Player
    local friendly1 = universe:newPlanet(4, 4.8, 0.4, 2)
    local friendly2 = universe:newPlanet(2.5, 4.8, 0.2, 2, "support")

    --Hostiles
    local hostile1 = universe:newPlanet(10, 4.8, 0.4, 3, "strong")
end

--Level 15
levels[#levels+1] = function(universe)
    universe.startMessage = "The circular fashion"

    --Player
    local friendly1 = universe:newPlanet(4, 8, 0.4, 2)

    --Hostiles
    local hostile1 = universe:newPlanet(10, 3, 0.4, 3, "healthy")
    local hostiles = {}
    for i = 1, 5 do
        local a = i * 6.28 / 5
        hostiles[i] = universe:newPlanet(10 + math.cos(a) * 1.5, 3 + math.sin(a) * 1.5, 0.2, 3, "support")
        universe:connectPlanets(hostiles[i], hostile1)
        if i > 1 then
            universe:connectPlanets(hostiles[i], hostiles[i-1])
        end
        if i == 5 then
            universe:connectPlanets(hostiles[i], hostiles[1])
        end
    end


    local hostile1 = universe:newPlanet(3, 3, 0.3, 3, "support")
    local hostiles = {}
    for i = 1, 5 do
        local a = i * 6.28 / 5
        hostiles[i] = universe:newPlanet(3 + math.cos(a) * 1, 3 + math.sin(a) * 1, 0.3, 3, "strong")
        universe:connectPlanets(hostiles[i], hostile1)
        if i > 1 then
            universe:connectPlanets(hostiles[i], hostiles[i-1])
        end
        if i == 5 then
            universe:connectPlanets(hostiles[i], hostiles[1])
        end
    end

end


--Level 16
levels[#levels+1] = function(universe)
    universe.startMessage = "Glass cannon"

    --Player
    universe:newPlanet(6.8, 4.4, 0.2, 2, "support")
    universe:newPlanet(7.5, 3.4, 0.2, 2, "support")
    universe:newPlanet(5.3, 5.3, 0.2, 2, "support")
    universe:newPlanet(6, 4, 0.3, 2, "strong")

    --Hostiles
    local hostile1 = universe:newPlanet(10, 8, 0.5, 3, "support")
    local hostile2 = universe:newPlanet(9, 7, 0.3, 3, "support")
    local hostile3 = universe:newPlanet(10, 7, 0.3, 3, "support")
    local hostile4 = universe:newPlanet(9, 9, 0.3, 3, "support")
    universe:connectPlanets(hostile1, hostile2)
    universe:connectPlanets(hostile1, hostile3)
    universe:connectPlanets(hostile1, hostile4)
    universe:connectPlanets(hostile2, hostile3)
    universe:connectPlanets(hostile2, hostile4)
    universe:connectPlanets(hostile3, hostile4)

    local hostile1 = universe:newPlanet(2, 2, 1.2, 3, "strong")


end


--Level 17
levels[#levels+1] = function(universe)
    universe.startMessage = "The Blockade"

    --Player
    universe:newPlanet(2, 2, 0.2, 2, "strong")


    --Neutral
    universe:newPlanet(8, 1, 0.2, 1)
    universe:newPlanet(3, 8, 0.2, 1)

    --Hostiles
    local hostiles1 = {}
    for y = 1, 9 do
        table.insert(hostiles1, universe:newPlanet(10, y, 0.3, 3, "healthy"))
    end
    for i,hostile in ipairs(hostiles1) do
        if i > 1 then
            universe:connectPlanets(hostile, hostiles1[i-1])
        end
    end

    local hostiles2 = {}
    for y = 1.5, 8.7 do
        table.insert(hostiles2, universe:newPlanet(11, y, 0.2, 3, "support"))
    end
    for i,hostile in ipairs(hostiles2) do
        if i ~= 7 then universe:connectPlanets(hostile, hostiles1[i]) end
        if i ~= 4 then universe:connectPlanets(hostile, hostiles1[i+1]) end
        if i > 1 then
            universe:connectPlanets(hostile, hostiles2[i-1])
        end
    end


end


--Level 18
levels[#levels+1] = function(universe)
    universe.startMessage = "The Citadel"

    --Player
    universe:newPlanet(1, 4.8, 0.4, 2)


    --Hostile
    local sun = universe:newPlanet(6.4, 4.8, 1.2, 3, "healthy")

    local bigPlanet = universe:newPlanet(6.8, 2.2, 0.8, 3, "healthy")
    universe:connectPlanets(bigPlanet, sun)


    local smallPlanet = universe:newPlanet(9, 8, 0.5, 3, "support")
    universe:connectPlanets(smallPlanet, sun)
    local smallMoon = universe:newPlanet(7.9, 8.9, 0.3, 3, "strong")
    universe:connectPlanets(smallPlanet, smallMoon)
    local smallMoon = universe:newPlanet(9.8, 7.1, 0.3, 3, "strong")
    universe:connectPlanets(smallPlanet, smallMoon)


    local smallPlanet = universe:newPlanet(4, 7, 0.6, 3, "healthy")
    universe:connectPlanets(smallPlanet, sun)
    local smallMoon = universe:newPlanet(4.7, 7.8, 0.3, 3, "strong")
    universe:connectPlanets(smallPlanet, smallMoon)

    local tinyMoon = universe:newPlanet(4.9, 7.1, 0.2, 3, "support")
    universe:connectPlanets(tinyMoon, smallMoon)
    local tinyMoon = universe:newPlanet(3.8, 8.2, 0.2, 3, "support")
    universe:connectPlanets(tinyMoon, smallMoon)




end