local comandoUI = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 115
    font: verdana-11px-monochrome
    !text: tr('Comandos?')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Menu 
    font: verdana-11px-monochrome 
]])

local comandoEdit = setupUI([[
Panel
  height: 80

  Label
    id: label08
    anchors.top: parent.top
    anchors.left: parent.left
    margin-left: 5
    margin-top: 10
    text: Decir: 
    font: verdana-11px-rounded
    color: green

  BotTextEdit
    id: textedituno
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-top: -3
    margin-left: 5
    margin-right: 10
    width: 100
    height: 20
    !text: tr('*!deposit all')

  Label
    id: tiempoid
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-left: 5
    margin-top: 10
    text: Tiempo:
    font: verdana-11px-rounded
    color: yellow

  SpinBox
    id: spinbox09
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 5
    margin-right: 10
    margin-top: -3
    width: 30
    value: 1
    minimum: 1
    maximum: 100
    step: 1
    font: verdana-11px-monochrome
]])

comandoEdit:hide()

local showEdit = false
comandoUI.edit.onClick = function(widget)
    showEdit = not showEdit
    if showEdit then
        comandoEdit:show()
    else
        comandoEdit:hide()
    end
end

storage["Comandos"] = storage["Comandos"] or {
    enabled = false,
    text = "!deposit all",
    minutos = 1,
}
local config = storage["Comandos"]

comandoEdit.textedituno:setText(config.text)
comandoEdit.spinbox09:setValue(config.minutos)

comandoEdit.textedituno.onTextChange = function(widget, text)
    config.text = text
end

comandoEdit.spinbox09.onValueChange = function(widget, value)
    config.minutos = value
end

local timer = config.minutos * 60 * 1000
comandoEdit.spinbox09.onValueChange = function(widget, value)
    config.minutos = value
    timer = value * 60 * 1000
end

-- BotSwitch para controlar el macro
comandoUI.title:setOn(config.enabled)
comandoUI.title.onClick = function(widget)
    -- Cambiar el estado del BotSwitch y actualizar el macro
    config.enabled = not config.enabled
    widget:setOn(config.enabled)

    -- Si el BotSwitch está activado, iniciar el macro
    if config.enabled then
        macro(timer, function()  -- Usa el valor actualizado de `timer`
            say(config.text)
        end)
    end
end


