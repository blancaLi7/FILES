local followThis = tostring(storage.followLeader)

FloorChangers = {
    Ladders = {
        Up = {1948, 5542, 16693, 16692, 8065, 8263, 7771, 20573, 20475, 21297 },
        Down = {432, 412, 469, 1080}
    },

    Holes = { -- teleports
        Up = {},
        Down = {293, 35500, 294, 595, 1949, 4728, 385, 9853, 37000, 37001, 35499, 35497, 29979, 25047, 25048, 25049, 25050, 
                25051, 25052, 25053, 25054, 25055, 25056, 25057, 25058, 21046, 21048 }
    },

    RopeSpots = { -- buracos pra usar corda
        Up = {386, 12202, 21965, 21966},
        Down = {}
    },

    Stairs = {
        Up = {16690, 1958, 7548, 7544, 1952, 1950, 1947, 7542, 855, 856, 1978, 1977, 6911, 6915, 1954, 5259, 20492, 1956, 775,
              5257, 5258, 22566, 22747, 30757, 20225, 17395, 1964, 1966, 20255, 29113, 28357, 30912, 30906, 30908, 30914, 
              30916, 30904, 30918, 20750, 20750, 20491, 20474, 20496 },

        Down = {482, 414, 437, 7731, 413, 434, 859, 438, 6127, 566, 7476, 4826, 484, 433, 369, 20259, 19960, 411,
                8690, 4825, 6130, 601, 1067, 567, 7768, 1067, 411, 600 }
    },

    Sewers = {
        Up = {1082},
        Down = {435,21298}
    },

    Levers = {
        Up = {2772, 2773, 1759, 1764, 21051, 7131, 7132, 39756},
        Down = {2772, 2773, 1759, 1764, 21051, 7131, 7132, 39756}
    },
}

local openDoors = { 34847, 1764, 21051, 30823, 6264, 5282, 20453, 11705, 6256, 2772, 27260, 2773, 1632, 6252, 5007, 1629, 5107, 5281, 1968, 31116, 31120, 30742, 31115, 31118, 20474, 5736, 5733, 31202, 31228, 31199, 31200, 33262, 30824, 5125, 5126, 5116, 8257, 8258, 8255, 8256, 5120, 30777, 30776, 23873, 23877, 5736, 6264, 31262, 31130, 6249, 5122, 30049, 7727, 25803, 16277, 5098, 5104, 5102, 5106, 5109, 5111, 5113, 5118, 5120, 5102, 5100, 1638, 1640, 19250, 3500, 3497, 3498, 3499, 2177, 17709, 1642, 23875, 1644, 5131, 5115, 28546, 6254, 28546, 30364, 30365, 30367, 30368, 30363, 30366, 31139, 31138, 31136, 31137, 4981, 4977, 11714, 7771, 9558, 9559, 20475, 2909, 2907, 8618, 31366, 1646, 1648, 4997, 22506, 8259, 27503, 27505, 27507, 31476, 31477, 31477, 31475, 31474, 8363, 5097, 1644, 7712, 7715, 11237, 11246, 9874, 6260, 33634, 33633, 22632, 22639, 1631, 1628, 20446, 20443, 20444, 2334, 9357, 9355 }

local target = followThis
local lastKnownPosition
local lastKnownDirection

local function goLastKnown()
    if getDistanceBetween(pos(), {x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z}) > 1 then
        local newTile = g_map.getTile({x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(100, 400))
        end
    end
end

local function handleUse(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(100, 400))
        end
    end
end

local function handleStep(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        autoWalk(pos)
        delay(math.random(100, 400))
    end
end

local function handleRope(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
            useWith(storage.extras.rope, newTile:getTopUseThing())
            delay(math.random(100, 400))
        end
    end
end

local floorChangeSelector = {
    Ladders = {Up = handleUse, Down = handleStep},
    Holes = {Up = handleStep, Down = handleStep},
    RopeSpots = {Up = handleRope, Down = handleRope},
    Stairs = {Up = handleStep, Down = handleStep},
    Sewers = {Up = handleUse, Down = handleUse},
    Levers = {Up = handleUse, Down = handleUse},
}

local function checkTargetPos()
    local c = getCreatureByName(target)
    if c and c:getPosition().z == posz() then
        lastKnownPosition = c:getPosition()
    end
end

local function distance(pos1, pos2)
    local pos2 = pos2 or lastKnownPosition or pos()
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function lastTurnDir()
    local target = getCreatureByName(storage.followLeader)
    local pdir = player:getDirection()
  if target then
        local tdir = target:getDirection()
        toChangeDir[tdir] = tdir
    end
    local p = toChangeDir[tdir]
    if not p then
        return
    end
    if targetZ:getDirection() ~= player:getDirection() then
        turn(pdir)
    end
end

local function turnDir()
    local targetZ = getCreatureByName(storage.followLeader)
    local pdir = player:getDirection()
    for _, n in ipairs(getSpectators(true)) do
        if n:getName() == storage.followLeader then
            targetZ = n
        end
    end
    if not targetZ then return end
    local targetDir = targetZ:getDirection()
    if targetZ and targetZ:getPosition().z == posz() and targetZ:getDirection() ~= player:getDirection() then
        turn(targetDir)
    end
end

local function WallDetect()

    local targetZ = getCreatureByName(storage.followLeader)
    local position = player:getPosition()

  for _, n in ipairs(getSpectators(true)) do
        if n:getName() == storage.followLeader then
            targetZ = n
        end
    end
    if not targetZ then return end

    local targetZ = getCreatureByName(storage.followLeader)
    local position = player:getPosition()

  for _, n in ipairs(getSpectators(true)) do
        if n:getName() == storage.followLeader then
            targetZ = n
        end
    end
    if not targetZ then return end
    local targetDir = targetZ:getDirection()
    if targetZ and targetZ:getPosition().z ~= posz() and targetZ:getDirection() ~= player:getDirection() then
        lastKnownDirection = targetZ:getDirection()
    end
    local tile
    if lastKnownDirection == 0 then -- north
        turn(lastKnownDirection)
        position.y = position.y - 1
        tile = g_map.getTile(position)
    elseif lastKnownDirection == 1 then -- east
        turn(lastKnownDirection)
        position.x = position.x + 1
        tile = g_map.getTile(position)
    elseif lastKnownDirection == 2 then -- south
        turn(lastKnownDirection)
        position.y = position.y + 1
        tile = g_map.getTile(position)
    elseif lastKnownDirection == 3 then -- west
        turn(lastKnownDirection)
        position.x = position.x - 1
        tile = g_map.getTile(position)
    end
  
    if targetZ:getPosition().z == posz() then return true
    elseif targetZ:getPosition().z - posz() >= 1 then say('exani hur "down') -- jump "down"
            delay(math.random(100, 400))
    elseif targetZ:getPosition().z - posz() <= -1 then say('exani hur "up') -- jump "up"
            delay(math.random(100, 400))
    end
end

local function executeClosest(possibilities)
    local closest
    local closestDistance = 99999
    for _, data in ipairs(possibilities) do
        local dist = distance(data.pos)
        if dist < closestDistance then
            closest = data
            closestDistance = dist
        end
    end

    if closest then
        closest.changer(closest.pos)
    end
end

local function handleFloorChange()
    local c = getCreatureByName(target)
    local range = 2
    local p = pos()
    local possibleChangers = {}
    local checkZ = {}
    local targetZ = nil
    for _, n in ipairs(getSpectators(true)) do
        if n:getName() == target then
            targetZ = n
        end
    end
    if not targetZ then table.insert(checkZ,"Down")
    elseif targetZ:getPosition().z == posz() then return true
    elseif targetZ:getPosition().z - posz() >= 1 then table.insert(checkZ,"Down")
    elseif targetZ:getPosition().z - posz() <= -1 then table.insert(checkZ,"Up")
    end
    for _, dir in ipairs(checkZ) do
        for changer, data in pairs(FloorChangers) do
            for x = -range, range do
                for y = -range, range do
                    local tile = g_map.getTile({x = p.x + x, y = p.y + y, z = p.z})
                    if tile then
                        if table.find(data[dir], tile:getTopUseThing():getId()) then
                            table.insert(possibleChangers, {changer = floorChangeSelector[changer][dir], pos = {x = p.x + x, y = p.y + y, z = p.z}})
                        end
                    end
                end
            end
        end
    end
    executeClosest(possibleChangers)
end

local function targetMissing()
    for _, n in ipairs(getSpectators(false)) do
        if n:getName() == target then
            return n:getPosition().z ~= posz()
        end
    end
    return true
end

followChange = macro(200, "Cambiar Follow", function() end)

local toFollowPos = {}

AdvancedFollow = macro(20, "Follow Agresivo", "", function(macro)
if followMacro.isOn() then followMacro.setOff() end
    local target = getCreatureByName(storage.followLeader)
    local pPos = player:getPosition()
    if target then
        local tpos = target:getPosition()
        toFollowPos[tpos.z] = tpos
    end
    if player:isWalking() then
        return
    end
    local p = toFollowPos[posz()]
    if not p then
        return
    end
    if autoWalk(p, 20, {ignoreNonPathable=true, precision=1}) then
        delay(tonumber(1))
    end

  turnDir()
  
    checkTargetPos()
    if targetMissing() and lastKnownPosition then
        handleFloorChange()
    end
    if targetMissing() and lastKnownPosition and possibleChangers == nil then
        WallDetect()
    end
    if not targetMissing() and getDistanceBetween(pos(), target:getPosition()) >= 3 then
     for _, NEWtile in pairs(g_map.getTiles(posz())) do
      if distanceFromPlayer(NEWtile:getPosition()) == 1 then
       if table.find(openDoors, NEWtile:getTopUseThing():getId()) then
        g_game.use(NEWtile:getTopUseThing())
        delay(math.random(500, 800))
       end
      end
     end
    end
end)


followled = addTextEdit("playerToFollow", storage.followLeader or "Leader name", function(widget, text)
    storage.followLeader = text
    target = tostring(text)
end)
onPlayerPositionChange(function(newPos, oldPos)
  if followChange:isOff() then return end
  if (g_game.isFollowing()) then
    tfollow = g_game.getFollowingCreature()
    if tfollow then
      if tfollow:getName() ~= storage.followLeader then
        followled:setText(tfollow:getName())
        storage.followLeader = tfollow:getName()
      end
    end
  end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
    if creature:getName() == storage.followLeader and newPos then
        toFollowPos[newPos.z] = newPos
    end
end)



followdist = "disttofollow"
if not storage[followdist] then
 storage[followdist] = { dist = "3" }
end
UI.Label("Distancia:")
UI.TextEdit(storage[followdist].dist or "3", function(widget, newText)
    storage[followdist].dist = newText
end)

UI.Label("delay pasos")

UI.TextEdit(storage.delayf or "100", function(widget, newText)
    storage.delayf = newText
end)

followMacro = macro(20, "Follow Distancia", function()
if AdvancedFollow.isOn() then AdvancedFollow.setOff() end
    local target = getCreatureByName(storage.followLeader)
    local pPos = player:getPosition()
    if target then
        local tpos = target:getPosition()
        toFollowPos[tpos.z] = tpos
    end
    if player:isWalking() then
        return
    end
    local p = toFollowPos[posz()]
    if not p then
        return
    end
    if autoWalk(p, 20, {ignoreNonPathable=true, precision=1, marginMin=tonumber(storage[followdist].dist), marginMax=tonumber(storage[followdist].dist)}) then
        delay(tonumber(storage.delayf))
    end
end)
