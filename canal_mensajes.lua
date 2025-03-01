g_ui.loadUIFromString([[
menPanel < Panel
  margin: 2
  margin-bottom: 17
  layout:
    type: verticalBox

MensagemWindow < MainWindow
  !text: tr( 'Mensajes')
  font: verdana-9px-italic
  color: orange
  size: 210 220
  @onEscape: self:hide()

  TabBar
    id: msgsTabBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2

  Panel
    id: msgssImagem
    anchors.top: msgsTabBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    image-border: 2

  Button
    id: closeButton
    !text: tr('Cerrar')
    color: white
    font: verdana-11px-monochrome
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 49 21
    margin-top: 13
    margin-right: 5
    margin-bottom: -3
]])

local msgtPanelName = "listt"
local ui = setupUI([[
Panel
  height: 19

  Button
    id: editMsg
    color: orange
    font: verdana-11px-monochrome
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 18
    text: CANAL DE MENSAJES
]], parent)
ui:setId(msgtPanelName)

if not storage[msgtPanelName] then
  storage[msgtPanelName] = {}
end

rootWidget = g_ui.getRootWidget()
if rootWidget then
  msgsWindow = UI.createWindow('MensagemWindow', rootWidget)
  msgsWindow:hide()
  local TabBar5 = msgsWindow.msgsTabBar
  TabBar5:setContentWidget(msgsWindow.msgssImagem)

  -- Panel para mensajes generales
  local menPanel = g_ui.createWidget("menPanel")
  menPanel:setId("panelMensajes")
  TabBar5:addTab("Mensajes", menPanel)

  UI.Separator(menPanel)

  -- Casillas de verificación para habilitar macros
  local tradeCheckBox = g_ui.createWidget("CheckBox", menPanel)
  tradeCheckBox:setId("enableTradeMacro")
  tradeCheckBox:setText("Mensaje En [Advertising]")
  tradeCheckBox:setChecked(storage.enableTradeMacro or false)

  local tradeTextEdit = g_ui.createWidget("TextEdit", menPanel)
  tradeTextEdit:setId("tradeTextEdit")
  tradeTextEdit:setText(storage.autoTradeMessage or "hi")
  tradeTextEdit:setWidth(180)
  tradeTextEdit:setHeight(20)

  local helpCheckBox = g_ui.createWidget("CheckBox", menPanel)
  helpCheckBox:setId("enableHelpMacro")
  helpCheckBox:setText("Mensaje En [Help]")
  helpCheckBox:setChecked(storage.enableHelpMacro or false)

  local helpTextEdit = g_ui.createWidget("TextEdit", menPanel)
  helpTextEdit:setId("helpTextEdit")
  helpTextEdit:setText(storage.autoHelpMessage or "hi")
  helpTextEdit:setWidth(180)
  helpTextEdit:setHeight(20)

  -- Casilla de verificación y cuadro de texto para mensaje de Word Chat
  local wordChatCheckBox = g_ui.createWidget("CheckBox", menPanel)
  wordChatCheckBox:setId("enableWordChatMacro")
  wordChatCheckBox:setText("Mensaje En [Word Chat]")
  wordChatCheckBox:setChecked(storage.enableWordChatMacro or false)

  local wordChatTextEdit = g_ui.createWidget("TextEdit", menPanel)
  wordChatTextEdit:setId("wordChatTextEdit")
  wordChatTextEdit:setText(storage.wordChatMessage or "Mensaje de Word Chat")
  wordChatTextEdit:setWidth(180)
  wordChatTextEdit:setHeight(20)

  -- Macro para mensaje de trade
  macro(6000, function()
    if tradeCheckBox:isChecked() then
      local Trade = getChannelId("advertising")
      if Trade and storage.autoTradeMessage:len() > 0 then    
        sayChannel(Trade, storage.autoTradeMessage)
      end
    end
  end, menPanel)

  -- Macro para mensaje de ayuda
  macro(6000, function()
    if helpCheckBox:isChecked() then
      local Help = getChannelId("Help")
      if Help and storage.autoHelpMessage:len() > 0 then    
        sayChannel(Help, storage.autoHelpMessage)
      end
    end
  end, menPanel)

  -- Macro para mensaje de Word Chat
  macro(6000, function()
    if wordChatCheckBox:isChecked() then
      local WordChat = getChannelId("wordchat")
      if WordChat and storage.wordChatMessage:len() > 0 then    
        sayChannel(WordChat, storage.wordChatMessage)
      end
    end
  end, menPanel)

  -- Actualizar mensajes en almacenamiento cuando cambian los cuadros de texto
  tradeTextEdit.onTextChange = function(widget, text)
    storage.autoTradeMessage = text
  end

  helpTextEdit.onTextChange = function(widget, text)
    storage.autoHelpMessage = text
  end

  wordChatTextEdit.onTextChange = function(widget, text)
    storage.wordChatMessage = text
  end

  -- Actualiza los estados de los macros en el almacenamiento
  tradeCheckBox.onCheckChange = function(widget)
    storage.enableTradeMacro = widget:isChecked()
  end

  helpCheckBox.onCheckChange = function(widget)
    storage.enableHelpMacro = widget:isChecked()
  end

  wordChatCheckBox.onCheckChange = function(widget)
    storage.enableWordChatMacro = widget:isChecked()
  end

  -- Panel para AFK personalizado
  local menPanel2 = g_ui.createWidget("menPanel")
  menPanel2:setId("panelAfk")
  TabBar5:addTab("Mensaje Afk", menPanel2)

  UI.Separator(menPanel2)

-- Casilla de verificación y cuadro de texto para mensaje AFK
local afkCheckBox = g_ui.createWidget("CheckBox", menPanel2)
afkCheckBox:setId("enableAfkMacro")
afkCheckBox:setText("Mensaje AFK")
afkCheckBox:setChecked(storage.enableAfkMacro or false)

local afkTextEdit = g_ui.createWidget("TextEdit", menPanel2)
afkTextEdit:setId("afkTextEdit")
afkTextEdit:setText(storage.afkMsg or "manda mensaje mas tarde, ando afk")
afkTextEdit:setWidth(180)
afkTextEdit:setHeight(20)

-- Estado inicial del mensaje AFK
local afkMsg = storage.enableAfkMacro or false

-- Macro para mensaje AFK
onTalk(function(name, level, mode, text, channelId, pos) -- cuando recibas una pm, responderá con la respuesta seleccionada
    if mode == 4 and afkCheckBox:isChecked() then
        g_game.talkPrivate(5, name, storage.afkMsg)
        delay(5000)
    end
end)

-- Actualiza el mensaje AFK cuando cambia el texto
afkTextEdit.onTextChange = function(widget, newText)
    storage.afkMsg = newText
end

-- Actualiza el estado del checkbox en almacenamiento
afkCheckBox.onCheckChange = function(widget)
    storage.enableAfkMacro = widget:isChecked()
end


  UI.Separator(menPanel2)

end

msgsWindow.closeButton.onClick = function(widget)
  msgsWindow:hide()
end

ui.editMsg.onClick = function(widget)
  msgsWindow:show()
  msgsWindow:raise()
  msgsWindow:focus()
end

