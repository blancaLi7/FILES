-- INMORTAL

local colors = {
  "#FF69B4", -- Hot Pink
  "#FF1493", -- Deep Pink
  "#FFB6C1", -- Light Pink
  "#FFC0CB", -- Pink
  "#DB7093", -- Pale Violet Red
  "#FF82AB", -- Hot Pink 1
  "#FF6EB4", -- Hot Pink 2
  "#FF34B3", -- Hot Pink 3
  "#FF3E96", -- Violet Red
  "#EE3A8C", -- Violet Red 1
  "#CD3278", -- Violet Red 2
  "#8B2252"  -- Violet Red 3
}

local function hexToRgb(hex)
  hex = hex:gsub("#","")
  return tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255
end

local function rgbToHex(r, g, b)
  return string.format("#%02X%02X%02X", r * 255, g * 255, b * 255)
end

local function interpolateColor(color1, color2, t)
  local r1, g1, b1 = hexToRgb(color1)
  local r2, g2, b2 = hexToRgb(color2)
  local r = r1 + (r2 - r1) * t
  local g = g1 + (g2 - g1) * t
  local b = b1 + (b2 - b1) * t
  return rgbToHex(r, g, b)
end

local label = UI.Label(" >>> INMORTAL <<< ")

macro(10, function()
  local time = os.clock() * 1.0 -- Aumenta la velocidad multiplicando por 1.0
  local colorIndex1 = math.floor(time) % #colors + 1
  local colorIndex2 = (colorIndex1 % #colors) + 1
  local t = time % 1
  local color = interpolateColor(colors[colorIndex1], colors[colorIndex2], t)
  
  label:setColor(color)
end)

-- INMORTAL

function theinmortal()
    local panelName = "theinmortal"
    local UI = setupUI([[
Panel
  height: 180
  margin-top: 5
  
  Label
    id: label1
    text: WAR
    anchors.top: parent.top
    anchors.left: parent.left
    margin-left: 50
    color: #f15976
    text-align: center
  
  Label
    id: labelSSA
    text: Ssa when = 50%:
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: label1.bottom
    margin-top: 5
    margin-left: 1
    color: #f8acba
    text-align: center

  HorizontalScrollBar
    id: scrollSSA
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: labelSSA.bottom
    margin-left: 5
    margin-right: 5
    margin-top: 5
    minimum: 1
    maximum: 100
    step: 1

  Label
    id: labelMR
    text: Might Ring when = 50%:
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: scrollSSA.bottom
    color: #f8acba
    margin-top: 5
    text-align: center

  HorizontalScrollBar
    id: scrollMR
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: labelMR.bottom
    margin-left: 5
    margin-right: 5
    margin-top: 5
    minimum: 1
    maximum: 100
    step: 1

  Label
    id: labelUtamo
    text: Utamo Ring when = 50%:
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: scrollMR.bottom
    color: #f8acba
    margin-top: 5
    text-align: center

  HorizontalScrollBar
    id: scrollUtamo
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: labelUtamo.bottom
    margin-left: 5
    margin-right: 5
    margin-top: 5
    minimum: 1
    maximum: 100
    step: 1

  BotSwitch
    id: switchUtamo
    anchors.top: scrollUtamo.top
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 30
    text-align: center
    text: Anillo Utamo

  BotSwitch
    id: switch
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    text-align: center
    width: 130
    height: 18
    !text: tr('Inmortal')



]])
    if not storage[panelName] then
        storage[panelName] = {
            ssaValue = 70,
            mrValue = 70,
            uRingValue = 30,
            btnInmortal = false,
            btnAnilloU = false
        }
    end

    UI.switch:setOn(storage[panelName].btnInmortal)
    UI.switch.onClick = function(widget)
        storage[panelName].btnInmortal = not storage[panelName].btnInmortal
        widget:setOn(storage[panelName].btnInmortal)
    end

    UI.switchUtamo:setOn(storage[panelName].btnAnilloU)
    UI.switchUtamo.onClick = function(widget)
        storage[panelName].btnAnilloU = not storage[panelName].btnAnilloU
        widget:setOn(storage[panelName].btnAnilloU)
    end

    UI.labelSSA:setText("Ssa = " .. storage[panelName].ssaValue .. "%")

    UI.scrollSSA:setValue(storage[panelName].ssaValue)
    UI.scrollSSA.onValueChange = function(scroll, value)
        storage[panelName].ssaValue = value
        UI.labelSSA:setText("Ssa = " .. value .. "%")
    end

    UI.labelMR:setText("Might Ring = " .. storage[panelName].mrValue .. "%")
    UI.scrollMR:setValue(storage[panelName].mrValue)
    UI.scrollMR.onValueChange = function(scroll, value)
        storage[panelName].mrValue = value
        UI.labelMR:setText("Might Ring = " .. value .. "%")
    end

    UI.labelUtamo:setText("Utamo Ring = " .. storage[panelName].uRingValue .. "%")
    UI.scrollUtamo:setValue(storage[panelName].uRingValue)
    UI.scrollUtamo.onValueChange = function(scroll, value)
        storage[panelName].uRingValue = value
        UI.labelUtamo:setText("Utamo Ring = " .. value .. "%")
    end

    local amulet = 3081
    local ring = 3048
    local ering = 3051
    local aering = 3088
    local lastAction = now

    function desequipar(value)
        local item = Item.create(value)
        g_game.equipItem(item)
    end

    -- basic ring check
    function defaultRingFind()
        if storage[panelName].ringEnabled then
            if getFinger() and (getFinger():getId() ~= ring and getFinger():getId() ~= getActiveItemId(ring)) then
                defaultRing = getInactiveItemId(getFinger():getId())
            else
                defaultRing = false
            end
        end
    end

    -- basic amulet check
    function defaultAmmyFind()
        if storage[panelName].ammyEnabled then
            if getNeck() and (getNeck():getId() ~= amulet and getNeck():getId() ~= getActiveItemId(amulet)) then
                defaultAmmy = getInactiveItemId(getNeck():getId())
            else
                defaultAmmy = false
            end
        end
    end

    macro(10, function()
        if now - lastAction < math.max(math.max(g_game.getPing() * 2, 150), 300) then
            return
        end
        if not storage[panelName].btnInmortal then
            return
        end

        local eringEquipped = getFinger() and (getFinger():getId() == aering)
        local ringEquipped = getFinger() and
                                 (getFinger():getId() == ring or getFinger():getId() == getActiveItemId(ring))
        local ssaEquipped = getNeck() and (getNeck():getId() == amulet or getNeck():getId() == getActiveItemId(amulet))

        if eringEquipped then
            -- SSA --
            if not ssaEquipped and storage[panelName].btnAnilloU then
                defaultAmmyFind()
                if hppercent() <= storage[panelName].ssaValue then
                    g_game.equipItemId(amulet)
                    lastAction = now
                    return
                end
            elseif ssaEquipped and hppercent() > storage[panelName].ssaValue then
                desequipar(amulet)
                lastAction = now
                return
            end
        end

        -- SI NO TIENE ACTIVADO EL BOTON DE E RING
        if not storage[panelName].btnAnilloU then
            if hasManaShield() then
                -- MIGHT RING --
                if not ringEquipped then
                    defaultRingFind()
                    if manapercent() <= storage[panelName].mrValue then
                        g_game.equipItemId(ring)
                        lastAction = now
                        return
                    end
                elseif ringEquipped then
                    if manapercent() > storage[panelName].mrValue then
                        desequipar(ring)
                        lastAction = now
                        return
                    end
                end

            elseif not hasManaShield() then
                -- MIGHT RING --
                if not ringEquipped then
                    defaultRingFind()
                    if hppercent() <= storage[panelName].mrValue then
                        g_game.equipItemId(ring)
                        lastAction = now
                        return
                    end
                elseif ringEquipped then
                    if hppercent() > storage[panelName].mrValue then
                        desequipar(ring)
                        lastAction = now
                        return
                    end
                end
            end

        end
        if storage[panelName].btnAnilloU then
            -- MIGHT RING --
            if not ringEquipped then
                defaultRingFind()
                if hppercent() <= storage[panelName].mrValue and hppercent() > storage[panelName].uRingValue then
                    g_game.equipItemId(ring)
                    lastAction = now
                    return
                elseif hppercent() <= storage[panelName].uRingValue or
                    (getFinger() == nil and hppercent() <= storage[panelName].uRingValue) then
                    g_game.equipItemId(ering)
                    lastAction = now
                    return
                elseif eringEquipped and hppercent() > storage[panelName].uRingValue then
                    desequipar(aering)
                    lastAction = now
                    return
                end
            elseif ringEquipped then
                if hppercent() > storage[panelName].mrValue then
                    desequipar(ring)
                    lastAction = now
                    return
                end
                if hppercent() <= storage[panelName].uRingValue then
                    g_game.equipItemId(ering)
                    lastAction = now
                    return
                end
            end
        end

        if storage[panelName].btnAnilloU and storage[panelName].mrValue <= storage[panelName].uRingValue then
            warn("NO PUEDES PONER MAS ALTO EL PORCENTAJE DEL ENERGY RING QUE EL DE MIGHT RING")
            storage[panelName].uRingValue = storage[panelName].mrValue - 10
            UI.scrollUtamo:setValue(storage[panelName].uRingValue)
            UI.labelUtamo:setText("UTAMO RING <= " .. storage[panelName].uRingValue .. "%")
            return
        end
        if hasManaShield() then
            -- SSA --
            if not ssaEquipped then
                defaultAmmyFind()
                if manapercent() <= storage[panelName].ssaValue then
                    g_game.equipItemId(amulet)
                    lastAction = now
                    return
                end
            elseif ssaEquipped and manapercent() > storage[panelName].ssaValue then
                desequipar(amulet)
                lastAction = now
                return
            end
        else
            -- SSA --
            if not ssaEquipped then
                defaultAmmyFind()
                if hppercent() <= storage[panelName].ssaValue then
                    g_game.equipItemId(amulet)
                    lastAction = now
                    return
                end
            elseif ssaEquipped and hppercent() > storage[panelName].ssaValue then
                desequipar(amulet)
                lastAction = now
                return
            end
        end

        
    end)
end

if g_game.getClientVersion() >= 1000 then
    theinmortal()
    
end

