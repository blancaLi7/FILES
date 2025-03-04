
local newInterfaceUI = setupUI([[
Panel
  height: 23

  Button
    id: openNewWindow
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 1
    height: 22
    text: !AutoLoot (add/remove)
    color: #FFC300
]], parent)

-- Definir el nombre del panel y la configuración
local panelName = "customRunPanel"
storage[panelName] = storage[panelName] or {
  customCommand = "!autoloot add, ", -- Comando predeterminado
  newComma = "!autoloot remove, ", -- Comando predeterminado para newComma
  botItemText = "golden helmet", -- Valor predeterminado para el texto del item
}

local config = storage[panelName]

-- Definir la ventana en formato UI
g_ui.loadUIFromString([[
NewWindow < MainWindow
  text: Comando AutoLoot
  size: 250 210

  Label
    id: customLabel
    text: AGREGAR = 
    font: terminus-14px-bold
    color: #27ae60
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 1
    margin-left: 1

  TextEdit
    id: customCommand
    anchors.top: parent.top
    anchors.left: customLabel.right
    margin-top: 1
    margin-left: 8
    width: 120
    height: 20
    text: !autoloot add, 

  CheckBox
    id: customCommandCheck
    anchors.top: parent.top
    anchors.left: customCommand.right
    margin-left: 5
    margin-top: 2
    width: 20
    height: 20

  Label
    id: newTextLabel
    text: REMOVER = 
    font: terminus-14px-bold
    color: #e74c3c
    anchors.top: customCommand.bottom
    anchors.left: parent.left
    margin-left: 1
    margin-top: 8

  TextEdit
    id: newComma
    anchors.top: customCommand.bottom
    anchors.left: newTextLabel.right
    margin-left: 10
    margin-top: 6
    width: 120
    height: 20
    text: !autoloot remove, 

  CheckBox
    id: newCommaCheck
    anchors.top: customCommand.bottom
    anchors.left: newComma.right
    margin-left: 5
    margin-top: 8
    width: 20
    height: 20

  Label
    id: itemNameLabel
    text: Nombre Item
    font: verdana-11px-monochrome
    color: orange
    anchors.top: newComma.bottom
    anchors.left: parent.left
    margin-left: 1
    margin-top: 12

  Label
    id: dragItemLabel
    text: Arrastre Item
    font: verdana-11px-monochrome
    color: orange
    anchors.top: newComma.bottom
    anchors.left: itemNameLabel.right
    margin-left: 40
    margin-top: 10

  TextEdit
    id: botItemText
    anchors.top: itemNameLabel.bottom
    anchors.left: parent.left
    margin-left: 1
    margin-top: 5
    width: 100
    height: 20
    text: golden helmet

  BotItem
    id: customBotItem
    size: 45 45
    anchors.top: itemNameLabel.bottom
    anchors.left: botItemText.right
    margin-left: 40
    margin-top: 5

  Button
    id: textEditButtonAdd
    text: ( + )
    anchors.top: botItemText.bottom
    anchors.left: parent.left
    margin-left: 1
    margin-top: 5
    size: 50 20
  
  Button
    id: textEditButtonRemove
    text: ( - )
    anchors.top: botItemText.bottom
    anchors.left: textEditButtonAdd.right
    margin-left: 1
    margin-top: 5
    size: 50 20

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    size: 40 22
]])

-- Manejo de la ventana
local rootWidget = g_ui.getRootWidget()
if rootWidget then
  -- Crear la ventana
  local newWindow = UI.createWindow('NewWindow', rootWidget)
  newWindow:hide()

  -- Mostrar la ventana al hacer clic en el botón principal
  newInterfaceUI.openNewWindow.onClick = function(widget)
    newWindow:show()
    newWindow:raise()
    newWindow:focus()
  end

  -- Ocultar la ventana al presionar el botón "Close"
  newWindow.closeButton.onClick = function(widget)
    newWindow:hide()
  end

  -- Macro de Auto Loot basado en "Look"
  local doAutoLootLook = macro(5000, function() end)
  doAutoLootLook:setOff() -- Inicia apagado

  -- Función para manejar el AutoLoot con los comandos personalizados
  onTextMessage(function(mode, text)
    if mode == 20 and text:find("You see") and doAutoLootLook:isOn() then
      local regex = [[(?:an|a) ([a-zA-Z ]+)]]
      local data = regexMatch(text, regex)
      if data and data[1] then
        local itemName = data[1][2]:trim()

        -- Verificar si customCommandCheck está marcado
        if newWindow.customCommandCheck:isChecked() then
          local customCommand = newWindow.customCommand:getText() -- Obtener comando del TextEdit
          -- Guardar el nuevo comando en el storage
          storage[panelName].customCommand = customCommand
          say(storage[panelName].customCommand .. itemName)
        end

        -- Verificar si newCommaCheck está marcado
        if newWindow.newCommaCheck:isChecked() then
          local newComma = newWindow.newComma:getText() -- Obtener comando de newComma
          -- Guardar el nuevo comando en el storage
          storage[panelName].newComma = newComma
          say(storage[panelName].newComma .. itemName)
        end

        doAutoLootLook:setOff() -- Apagar el macro después de usar
      end
    end
  end)

  -- Función para buscar y dar "look" al ID del BotItem
  local function lookBotItem()
    if not newWindow.customBotItem:getItem() then return end
    local botItem = newWindow.customBotItem:getItem()
    if botItem then
      local itemId = botItem:getId()
      if itemId then
        -- Dar look en contenedores
        for _, container in pairs(g_game.getContainers()) do
          for _, item in ipairs(container:getItems()) do
            if item:getId() == itemId then
              g_game.look(item)
              return -- Salir tras encontrar y dar look
            end
          end
        end

        -- Dar look en tiles
        for _, tile in ipairs(g_map.getTiles(posz()) or {}) do
          local thing = tile:getTopUseThing()
          if thing and thing:getId() == itemId then
            g_game.look(thing)
            return -- Salir tras encontrar y dar look
          end
        end
      end
    end
  end

  -- Evento que se activa cuando cambia el ID del BotItem
  local previousItemId = nil
  newWindow.customBotItem.onItemChange = function(widget)
    local botItem = newWindow.customBotItem:getItem()
    if botItem then
      local itemId = botItem:getId()
      if itemId and itemId ~= previousItemId then
        previousItemId = itemId -- Actualizar el ID previo
        doAutoLootLook:setOn() -- Activar el macro
        lookBotItem() -- Buscar y dar "look" al nuevo ID
      end
    end
  end

  -- Función del botón Agregar (para customCommand)
  newWindow.textEditButtonAdd.onClick = function(widget)
    local customCommand = newWindow.customCommand:getText() -- Obtener el texto del comando
    local itemName = newWindow.botItemText:getText() -- Obtener el texto del nombre del ítem

    -- Verificar que ambos campos no estén vacíos
    if customCommand and itemName and customCommand:trim() ~= "" and itemName:trim() ~= "" then
      local fullCommand = customCommand .. itemName -- Combinar ambos textos
      say(fullCommand) -- Enviar el comando al chat
    else
      warn("Debes llenar el campo en blanco") --xD
    end
  end

  -- Función del botón Agregar (para newComma)
  newWindow.textEditButtonRemove.onClick = function(widget)
    local newComma = newWindow.newComma:getText() -- Obtener el texto del comando newComma
    local itemName = newWindow.botItemText:getText() -- Obtener el texto del nombre del ítem

    -- Verificar que ambos campos no estén vacíos
    if newComma and itemName and newComma:trim() ~= "" and itemName:trim() ~= "" then
      local fullCommand = newComma .. itemName -- Combinar ambos textos
      say(fullCommand) -- Enviar el comando al chat
    else
      warn("Debes llenar el campo en blanco") --xD
    end
  end

  -- Al cambiar el texto en el TextEdit, se actualiza el valor en storage
  newWindow.customCommand.onTextChange = function(widget, text)
    -- Guardar el texto actualizado en storage
    storage[panelName].customCommand = text
  end

  -- Restaurar el texto almacenado en storage al abrir la ventana
  newWindow.customCommand:setText(storage[panelName].customCommand)

  -- Actualizar el texto de newComma y botItemText
  newWindow.newComma:setText(storage[panelName].newComma)
  newWindow.botItemText:setText(storage[panelName].botItemText)
end