g_ui.loadUIFromString([[
ItemUseWindow < MainWindow
  id: VentanaPrin
  text: ITEM SELLER / USE
  size: 200 240
  movable: false

  Label
    id: usernameLabel
    text: usar: 
    anchors.top: parent.top
    margin-top: 1
    margin-left: 10
    margin-right: 1
    anchors.left: parent.left
    font: verdana-11px-monochrome 

  CheckBox
    id: useCheckBox
    text: Recordar
    anchors.top: usernameLabel.top
    anchors.left: usernameLabel.right
    margin-left: 10

  BotItem
    id: useItem
    anchors.top: usernameLabel.top
    anchors.left: useCheckBox.right
    margin-left: 55
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
    text: usar:
    anchors.top: separator1.bottom
    margin-top: 8
    margin-left: 10
    margin-right: 1
    anchors.left: parent.left
    font: verdana-11px-monochrome 

  CheckBox
    id: secondUseCheckBox
    text: Recordar
    anchors.top: secondUsernameLabel.top
    anchors.left: secondUsernameLabel.right
    margin-left: 10

  BotItem
    id: secondUseItem
    anchors.top: secondUsernameLabel.top
    anchors.left: secondUseCheckBox.right
    margin-left: 55
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
local itemUseWindow = UI.createWindow('ItemUseWindow', rootWidget)
itemUseWindow:hide()

local panelName = "itemUsePanel"

-- Configuración del almacenamiento para el panel
storage[panelName] = storage[panelName] or {
  enabled = false,
  itemID = 0,
  waitTime = 1,
  useCheckBoxChecked = false,
  secondItemID = 0,
  secondWaitTime = 1,
  secondUseCheckBoxChecked = false,
}

-- Inicializa las variables desde el almacenamiento
itemUseWindow.useItem:setItemId(storage[panelName].itemID)
itemUseWindow.timeField:setText(tostring(storage[panelName].waitTime))
itemUseWindow.useCheckBox:setChecked(storage[panelName].useCheckBoxChecked)
itemUseWindow.secondUseItem:setItemId(storage[panelName].secondItemID)
itemUseWindow.secondTimeField:setText(tostring(storage[panelName].secondWaitTime))
itemUseWindow.secondUseCheckBox:setChecked(storage[panelName].secondUseCheckBoxChecked)

-- Función para crear un macro de uso de ítem
local function createUseMacro(itemIDKey, waitTimeKey, checkBoxKey, itemWidget, timeWidget, checkBoxWidget)
  return macro(100, function()
    if not storage[panelName].enabled then return end
    if not checkBoxWidget:isChecked() then return end

    local item = findItem(storage[panelName][itemIDKey])
    if item then
      g_game.use(item)
    end
    delay(storage[panelName][waitTimeKey] * 60 * 1000)
  end)
end

-- Crear macros para ambos ítems
local useMacro = createUseMacro("itemID", "waitTime", "useCheckBoxChecked", itemUseWindow.useItem, itemUseWindow.timeField, itemUseWindow.useCheckBox)
local secondUseMacro = createUseMacro("secondItemID", "secondWaitTime", "secondUseCheckBoxChecked", itemUseWindow.secondUseItem, itemUseWindow.secondTimeField, itemUseWindow.secondUseCheckBox)

-- Función para manejar cambios en los elementos
local function setupItemHandlers(itemWidget, timeWidget, checkBoxWidget, itemIDKey, waitTimeKey, checkBoxKey, macro)
  itemWidget.onItemChange = function(widget)
    storage[panelName][itemIDKey] = widget:getItemId()
  end

  timeWidget.onTextChange = function(widget)
    storage[panelName][waitTimeKey] = tonumber(widget:getText()) or 1
  end

  checkBoxWidget.onCheckChange = function(widget)
    storage[panelName][checkBoxKey] = widget:isChecked()
    macro.setOn(storage[panelName].enabled and widget:isChecked())
  end
end

-- Configurar manejadores para ambos ítems
setupItemHandlers(itemUseWindow.useItem, itemUseWindow.timeField, itemUseWindow.useCheckBox, "itemID", "waitTime", "useCheckBoxChecked", useMacro)
setupItemHandlers(itemUseWindow.secondUseItem, itemUseWindow.secondTimeField, itemUseWindow.secondUseCheckBox, "secondItemID", "secondWaitTime", "secondUseCheckBoxChecked", secondUseMacro)

-- Botón de cerrar
itemUseWindow.closeButton.onClick = function()
  itemUseWindow:hide()
end

-- Configuración del interruptor para activar/desactivar el panel
UI.SwitchAndButton({on = storage[panelName].enabled, left = "( Use )", right = "Menu"}, function(widget)
  storage[panelName].enabled = not storage[panelName].enabled
  useMacro.setOn(storage[panelName].enabled and itemUseWindow.useCheckBox:isChecked())
  secondUseMacro.setOn(storage[panelName].enabled and itemUseWindow.secondUseCheckBox:isChecked())
end, function()
  itemUseWindow:show()
  itemUseWindow:raise()
  itemUseWindow:focus()
end)


