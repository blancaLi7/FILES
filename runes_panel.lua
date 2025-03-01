g_ui.loadUIFromString([[
ConfigWindow < MainWindow
  text: RUNAS
  size: 140 195

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
      cell-size: 115 15
      cell-spacing: 2

  Button
    id: closeButton
    text: Cerrar
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "configrunas"
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

local Sd = macro(400, "Sd", function()
    if g_game.isAttacking() then
        usewith(3155, g_game.getAttackingCreature())
        delay(1200)
    end
end)

local Avalanche = macro(400, "Avalanche", function()
    if g_game.isAttacking() then
        usewith(3161, g_game.getAttackingCreature())
        delay(1200)
    end
end)

local GreatFireball = macro(400, "Great Fireball", function()
    if g_game.isAttacking() then
        usewith(3191, g_game.getAttackingCreature())
        delay(1200)
    end
end)

local StoneShower = macro(400, "Stone Shower", function()
    if g_game.isAttacking() then
        usewith(3175, g_game.getAttackingCreature())
        delay(1200)
    end
end)

local Thunderstorm = macro(400, "Thunderstorm", function()
    if g_game.isAttacking() then
        usewith(3202, g_game.getAttackingCreature())
        delay(1200)
    end
end)

local Paralyze = macro(400, "Paralyze", function()
    if g_game.isAttacking() then
        usewith(3165, g_game.getAttackingCreature())
        delay(10000)
    end
end)

table.insert(listaMacros, Sd)
table.insert(listaMacros, Avalanche)
table.insert(listaMacros, GreatFireball)
table.insert(listaMacros, StoneShower)
table.insert(listaMacros, Thunderstorm)
table.insert(listaMacros, Paralyze)

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

UI.SwitchAndButton({on = config.enabled, left = "Runas", right = "Editar"}, function(widget)
    config.enabled = not config.enabled
    for i, mac in ipairs(listaMacros) do
        mac.setOn(config.enabled and checkboxes[i]:isChecked())
    end
end, function()
    configWindow:show()
    configWindow:raise()
    configWindow:focus()
end)
