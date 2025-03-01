g_ui.loadUIFromString([[
ConfigWindow < MainWindow
  text: MACROS
  size: 180 250

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 6

  Panel
    id: lista
    anchors.fill: parent
    anchors.bottom: closeButton.top
    layout:
      type: grid
      cell-size: 175 16
      cell-spacing: 2

  Button
    id: closeButton
    text: Cerrar
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "configMacros"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

local rootWidget = g_ui.getRootWidget()
local configWindow

configWindow = UI.createWindow('ConfigWindow', rootWidget)
configWindow:hide()

local listaMacros = {}

-- Auto Mount
local AutoMount = macro(5000, "Auto Mount", function() 
    if isInPz() then return end
    if not player:isMounted() then player:mount() end
end)
table.insert(listaMacros, AutoMount)

-- Sin Letras Naranjas
local SinLetrasNaranjas = macro(100, "Sin Letras Naranjas", function() end)
onStaticText(function(thing, text)
    if SinLetrasNaranjas.isOff() then return end
    if not text:find('says:') then
        g_map.cleanTexts()
    end
end)
table.insert(listaMacros, SinLetrasNaranjas)

-- Esconder Sprite
local EsconderSprite = macro(100, "Esconder Sprite", function() end)
onAddThing(function(tile, thing)
    if EsconderSprite.isOff() then return end
    if thing:isEffect() then
        thing:hide()
    end
end)
table.insert(listaMacros, EsconderSprite)

-- Monster HP %
local MonsterHP = macro(5000, "Monster HP %", function() end)
onCreatureHealthPercentChange(function(creature, healthPercent)
    if MonsterHP:isOff() then return end
    if creature:isMonster() or creature:isPlayer() and creature:getPosition() and pos() then
        if getDistanceBetween(pos(), creature:getPosition()) <= 5 then
            creature:setText(healthPercent .. "%")
        else
            creature:clearText()
        end
    end
end)
table.insert(listaMacros, MonsterHP)

-- Bless
local function checkAndBless()
  if player:getBlessings() == 0 then
    say("!bless")
    schedule(2000, function()
      if player:getBlessings() == 0 then
        error("!! Blessings not bought !!")
      end
    end)
  end
end
local Bless = macro(1000, "Bless", checkAndBless)
table.insert(listaMacros, Bless)

-- BP Abierta
local function checkContainersAndOpenBackpack()
  local containers = getContainers()
  if #containers < 1 and containers[0] == nil then
    local bpItem = getBack()
    if bpItem ~= nil then
      g_game.open(bpItem)
    end
  end
end
local BPAbierta = macro(1000, "BP Abierta", checkContainersAndOpenBackpack)
table.insert(listaMacros, BPAbierta)

-- Suprimir Warning
local function warning()
    -- Made By MaDGENius
    -- This will remove lots of other warning messages too, be warned xD
    return
end
local SuprimirWarning = macro(1000, "Suprimir Warning", warning)
table.insert(listaMacros, SuprimirWarning)

local teztos = macro(1000, "Limpar Textos", function()
   
   modules.game_textmessage.clearMessages()
       g_map.cleanTexts()
       end)
       table.insert(listaMacros, teztos)

local cursorWidget = g_ui.getRootWidget():recursiveGetChildById('pointer')
local lastCursorPos = cursorWidget:getPosition()

function WallDetect(dir)
    local pos = g_game.getLocalPlayer():getPosition()  -- Usamos la posición del jugador
    if dir == 0 then
        pos.y = pos.y - 1
    elseif dir == 1 then
        pos.x = pos.x + 1
    elseif dir == 2 then
        pos.y = pos.y + 1
    elseif dir == 3 then
        pos.x = pos.x - 1
    end

    local tile = g_map.getTile(pos)
    if not tile then
        return
    end

    local levitateTile = tile
    if levitateTile and not levitateTile:isWalkable() then
        if levitateTile:getGround() then
            say('exani hur "up')
        else
            say('exani hur "down')
        end
    end
end

local exaniUpDown = macro(500, "Exani hur up/down", function()
    local currentCursorPos = cursorWidget:getPosition()

    if currentCursorPos.x ~= lastCursorPos.x or currentCursorPos.y ~= lastCursorPos.y then
        local diffX = currentCursorPos.x - lastCursorPos.x
        local diffY = currentCursorPos.y - lastCursorPos.y

        local direction
        if math.abs(diffX) > math.abs(diffY) then
            direction = diffX > 0 and 1 or 3
        else
            direction = diffY > 0 and 2 or 0
        end

        WallDetect(direction)

        lastCursorPos = currentCursorPos
    end
end)

table.insert(listaMacros, exaniUpDown)


local checkboxes = {}

for _, mac in ipairs(listaMacros) do
    local checkbox = g_ui.createWidget("CheckBox", configWindow.lista)
    checkbox:setText(mac.switch:getText())
    checkbox.onCheckChange = function(wid, isChecked)
        mac.setOn(isChecked and config.enabled)
    end
    checkbox:setChecked(mac.isOn())
    mac.switch:setVisible(false)
    table.insert(checkboxes, checkbox)
end

configWindow.closeButton.onClick = function(widget)
    configWindow:hide()
end

UI.SwitchAndButton({on = config.enabled, left = "Macros", right = "Menu"}, function(widget)
    config.enabled = not config.enabled
    for i, mac in ipairs(listaMacros) do
        mac.setOn(config.enabled and checkboxes[i]:isChecked())
    end
end, function()
    configWindow:show()
    configWindow:raise()
    configWindow:focus()
end)



