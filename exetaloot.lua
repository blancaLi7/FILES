
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 120
    !text: tr('Exeta Loot')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Editar
]])

local edit = setupUI([[
Panel
  height: 150
  width: 200
  layout: verticalBox
]])
edit:hide()

-- Valores locales configurables
local settings = {
  capmin = storage.capmin or 200,
  distance = storage.distance or 1,
  maxMonsters = storage.maxMonsters or 0,
  caveBotDelay = storage.caveBotDelay or 600,
}

-- Agregar TextEdits para editar los valores
addLabel("capminLabel", "Capacidad Minima:", edit)
addTextEdit("capminValue", tostring(settings.capmin), function(widget, text)
  settings.capmin = tonumber(text) or 200
  storage.capmin = settings.capmin
end, edit)

addLabel("distanceLabel", "Distancia Maxima (sqm):", edit)
addTextEdit("distanceValue", tostring(settings.distance), function(widget, text)
  settings.distance = tonumber(text) or 1
  storage.distance = settings.distance
end, edit)

addLabel("maxMonstersLabel", "Monstruos Maximos:", edit)
addTextEdit("maxMonstersValue", tostring(settings.maxMonsters), function(widget, text)
  settings.maxMonsters = tonumber(text) or 0
  storage.maxMonsters = settings.maxMonsters
end, edit)

addLabel("caveBotDelayLabel", "Delay del CaveBot (ms):", edit)
addTextEdit("caveBotDelayValue", tostring(settings.caveBotDelay), function(widget, text)
  settings.caveBotDelay = tonumber(text) or 600
  storage.caveBotDelay = settings.caveBotDelay
end, edit)

-- Mostrar u ocultar la ventana de edición
local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end

-- BotSwitch para controlar el estado del macro
local config = { enabled = storage.enabled or false } -- Cargar estado desde storage
ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  ui.title:setOn(config.enabled)
  storage.enabled = config.enabled -- Guardar estado en storage
end

-- Tabla para evitar duplicados
local processedCreatures = {}

-- Macro para "Exeta Loot"
local autoExetaLoot = macro(100, function()
  if not config.enabled then return end

  onCreatureDisappear(function(creature)
    if not config.enabled then return end -- Verificación adicional
    if not creature:isMonster() then return end
    local pos = creature:getPosition()
    if pos.z ~= posz() then return end

    -- Verificar si ya procesamos esta criatura
    if processedCreatures[creature:getId()] then return end
    processedCreatures[creature:getId()] = true

    local tile = g_map.getTile(pos)
    if not tile then return end
    local tilePos = tile:getPosition()
    local pPos = player:getPosition()

    -- Verificar distancia
    if math.abs(pPos.x - tilePos.x) > settings.distance or math.abs(pPos.y - tilePos.y) > settings.distance then return end

    -- Verificar capacidad
    if freecap() < settings.capmin then return end

    -- Verificar cantidad de monstruos cercanos
    if getMonsters(settings.distance) <= settings.maxMonsters then
      say("exeta loot")
      CaveBot.delay(settings.caveBotDelay)
      delay(500)
    end
  end)
end)

-- Limpiar la tabla periódicamente para evitar que crezca indefinidamente
macro(60000, function()
  processedCreatures = {}
end)
