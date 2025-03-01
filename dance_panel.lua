g_ui.loadUIFromString([[
ConfigWindow < MainWindow
  text: DANCE ??
  size: 110 140

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
      cell-size: 100 16
      cell-spacing: 2

  Button
    id: closeButton
    text: Cerrar
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

-- Sección que define un nombre único de almacenamiento para este panel
local panelName = "configDance"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
    Suave = false,
    Rapido = false,
    Hyper = false
  }
end

local config = storage[panelName]

local rootWidget = g_ui.getRootWidget()
local configWindow

configWindow = UI.createWindow('ConfigWindow', rootWidget)
configWindow:hide()

local listaMacros = {}

-- Función para crear un macro con la estructura proporcionada
local function createMacro(interval, name, func)
    return macro(interval, name, function()
        if not config.enabled then return end
        func()
    end)
end

-- Suave
local Suave = createMacro(500, "Suave", function()
    if not config.Suave then return end
    turn(math.random(0, 3))
end)
table.insert(listaMacros, Suave)

-- Rapido
local Rapido = createMacro(100, "Rapido", function()
    if not config.Rapido then return end
    turn(math.random(0, 3))
end)
table.insert(listaMacros, Rapido)

-- Hyper
local Hyper = createMacro(10, "Hyper", function()
    if not config.Hyper then return end
    turn(math.random(0, 3))
end)
table.insert(listaMacros, Hyper)

-- Configuración de los checkboxes
local checkboxes = {}

local function createCheckbox(name, parent)
    local checkbox = g_ui.createWidget("CheckBox", parent)
    checkbox:setText(name)
    checkbox:setChecked(config[name] or false)
    checkbox.onCheckChange = function(widget, value)
        for _, cb in ipairs(checkboxes) do
            if cb:getText() ~= name then
                cb:setChecked(false)
                config[cb:getText()] = false
            end
        end
        config[name] = value
        storage[panelName] = config
        for i, mac in ipairs(listaMacros) do
            mac.setOn(config.enabled and checkboxes[i]:isChecked())
        end
    end
    table.insert(checkboxes, checkbox)
end

for _, mac in ipairs(listaMacros) do
    createCheckbox(mac.switch:getText(), configWindow.lista)
    mac.switch:setVisible(false)
end

configWindow.closeButton.onClick = function(widget)
    configWindow:hide()
end

UI.SwitchAndButton({on = config.enabled, left = "Dance", right = "Menu"}, function(widget)
    config.enabled = not config.enabled
    for i, mac in ipairs(listaMacros) do
        mac.setOn(config.enabled and checkboxes[i]:isChecked())
    end
    storage[panelName] = config
end, function()
    configWindow:show()
    configWindow:raise()
    configWindow:focus()
end)


