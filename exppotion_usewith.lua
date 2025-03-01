g_ui.loadUIFromString([[
ItemUseWithWindow < MainWindow
  id: VentanaPrin
  text: EXP POTION / USE WITH
  size: 200 240
  movable: false

  Label
    id: usernameLabel
    text: usar con: 
    anchors.top: parent.top
    margin-top: 1
    margin-left: 10
    margin-right: 1
    anchors.left: parent.left
    font: verdana-11px-monochrome 

  CheckBox
    id: useWithCheckBox
    text: Recordar
    anchors.top: usernameLabel.top
    anchors.left: usernameLabel.right
    margin-left: 10

  BotItem
    id: useWithItem
    anchors.top: usernameLabel.top
    anchors.left: useWithCheckBox.right
    margin-left: 30
    anchors.right: parent.right
    margin-right: 15
    margin-top: -8

  Label
    id: timeLabel
    text: Tiempo en minutos:
    anchors.top: usernameLabel.bottom
    margin-top: 10
    margin-left: 10
    anchors.left: parent.left
    font: verdana-11px-monochrome

  TextEdit
    id: timeField
    width: 130
    text: 1
    anchors.top: timeLabel.bottom
    margin-top: 5
    margin-left: 10
    anchors.left: parent.left
    font: verdana-11px-monochrome 

  Label
    id: separator1
    text: ---------------------------------
    anchors.top: timeField.bottom
    margin-top: 10
    margin-left: -1
    margin-right: -1
    anchors.left: parent.left
    font: verdana-11px-rounded

  Label
    id: secondUsernameLabel
    text: usar con:
    anchors.top: separator1.bottom
    margin-top: 8
    margin-left: 10
    margin-right: 1
    anchors.left: parent.left
    font: verdana-11px-monochrome 

  CheckBox
    id: secondUseWithCheckBox
    text: Recordar
    anchors.top: secondUsernameLabel.top
    anchors.left: secondUsernameLabel.right
    margin-left: 10

  BotItem
    id: secondUseWithItem
    anchors.top: secondUsernameLabel.top
    anchors.left: secondUseWithCheckBox.right
    margin-left: 30
    anchors.right: parent.right
    margin-right: 15
    margin-top: -8

  Label
    id: secondTimeLabel
    text: Tiempo en minutos:
    anchors.top: secondUsernameLabel.bottom
    margin-top: 10
    margin-left: 10
    anchors.left: parent.left
    font: verdana-11px-monochrome

  TextEdit
    id: secondTimeField
    width: 130
    text: 1
    anchors.top: secondTimeLabel.bottom
    margin-top: 5
    margin-left: 10
    anchors.left: parent.left
    font: verdana-11px-monochrome 

  Button
    id: closeButton
    text: close
    width: 45
    anchors.top: secondTimeField.bottom
    margin-top: 10
    anchors.right: parent.right
    color: white
    font: verdana-11px-rounded
]])

local rootWidget = g_ui.getRootWidget()
local itemUseWithWindow = UI.createWindow('ItemUseWithWindow', rootWidget)
itemUseWithWindow:hide()

local panelName = "itemUseWithPanel"

-- Configuración del almacenamiento para el panel
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
    itemID = 0,
    waitTime = 1,
    useWithCheckBoxChecked = false,
    secondItemID = 0,
    secondWaitTime = 1,
    secondUseWithCheckBoxChecked = false,
  }
end

-- Inicializa las variables desde el almacenamiento
itemUseWithWindow.useWithItem:setItemId(storage[panelName].itemID)
itemUseWithWindow.timeField:setText(tostring(storage[panelName].waitTime))
itemUseWithWindow.useWithCheckBox:setChecked(storage[panelName].useWithCheckBoxChecked)
itemUseWithWindow.secondUseWithItem:setItemId(storage[panelName].secondItemID)
itemUseWithWindow.secondTimeField:setText(tostring(storage[panelName].secondWaitTime))
itemUseWithWindow.secondUseWithCheckBox:setChecked(storage[panelName].secondUseWithCheckBoxChecked)

-- Configuración del macro de "Use With"
local useWithMacro = macro(100, function()
    if not storage[panelName].enabled then return end  -- Verifica si el switch está apagado
    if not itemUseWithWindow.useWithCheckBox:isChecked() then return end -- Verifica si el checkbox está marcado

    local player = g_game.getLocalPlayer()
    if not player then return end -- Verifica que el jugador exista

    local item = findItem(storage[panelName].itemID)
    if item then
        useWith(storage[panelName].itemID, player) -- Usa el ítem con el jugador
    end
    delay(storage[panelName].waitTime * 60 * 1000)
end)

-- Configuración del macro de "Use With" para el segundo ítem
local secondUseWithMacro = macro(100, function()
    if not storage[panelName].enabled then return end  -- Verifica si el switch está apagado
    if not itemUseWithWindow.secondUseWithCheckBox:isChecked() then return end -- Verifica si el checkbox está marcado

    local player = g_game.getLocalPlayer()
    if not player then return end -- Verifica que el jugador exista

    local item = findItem(storage[panelName].secondItemID)
    if item then
        useWith(storage[panelName].secondItemID, player) -- Usa el ítem con el jugador
    end
    delay(storage[panelName].secondWaitTime * 60 * 1000)
end)

-- Función para manejar los cambios en los elementos de la primera sección
itemUseWithWindow.useWithCheckBox.onCheckChange = function(widget)
  storage[panelName].useWithCheckBoxChecked = widget:isChecked()
  -- Si el checkbox está marcado, el macro se activa solo si el switch está encendido
  useWithMacro.setOn(storage[panelName].enabled and widget:isChecked())
end

itemUseWithWindow.useWithItem.onItemChange = function(widget)
  storage[panelName].itemID = widget:getItemId()
end

itemUseWithWindow.timeField.onTextChange = function(widget)
  storage[panelName].waitTime = tonumber(widget:getText()) or 1
end

-- Función para manejar los cambios en los elementos de la segunda sección
itemUseWithWindow.secondUseWithCheckBox.onCheckChange = function(widget)
  storage[panelName].secondUseWithCheckBoxChecked = widget:isChecked()
  -- Si el checkbox está marcado, el macro se activa solo si el switch está encendido
  secondUseWithMacro.setOn(storage[panelName].enabled and widget:isChecked())
end

itemUseWithWindow.secondUseWithItem.onItemChange = function(widget)
  storage[panelName].secondItemID = widget:getItemId()
end

itemUseWithWindow.secondTimeField.onTextChange = function(widget)
  storage[panelName].secondWaitTime = tonumber(widget:getText()) or 1
end

-- Botón de cerrar
itemUseWithWindow.closeButton.onClick = function()
  itemUseWithWindow:hide()
end

-- Configuración del interruptor para activar/desactivar el panel
UI.SwitchAndButton({on = storage[panelName].enabled, left = " ( Use With )", right = "Menu"}, function(widget)
  storage[panelName].enabled = not storage[panelName].enabled
  -- Cuando el switch cambia, se activa o desactiva el macro según el estado de los checkboxes
  useWithMacro.setOn(storage[panelName].enabled and itemUseWithWindow.useWithCheckBox:isChecked())
  secondUseWithMacro.setOn(storage[panelName].enabled and itemUseWithWindow.secondUseWithCheckBox:isChecked())
end, function()
  itemUseWithWindow:show()
  itemUseWithWindow:raise()
  itemUseWithWindow:focus()
end)

