g_ui.loadUIFromString([[
ConfigWindow < MainWindow
  text: Herramienta
  size: 120 155

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
      cell-size: 110 16
      cell-spacing: 2

  Button
    id: closeButton
    text: Cerrar
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "configHerra"
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

-- Shovel Macro
local fieldsShovel = {606, 593, 867, 608}
local Shovel = 3457
local ShovelMacro = macro(500, "Shovel", function()
    local tileArroundMe = getNearTiles(pos())
    for _, tile in ipairs(tileArroundMe) do
        if table.find(fieldsShovel, tile:getTopUseThing():getId()) then
            return useWith(Shovel, tile:getTopUseThing())
        end
    end
end)
table.insert(listaMacros, ShovelMacro)

-- Rope Macro
local fieldsRope = {17238, 12202, 12935, 386, 421, 21966, 14238}
local Rope = 3003
local RopeMacro = macro(500, "Rope", function()
    local tileArroundMe = getNearTiles(pos())
    for _, tile in ipairs(tileArroundMe) do
        if table.find(fieldsRope, tile:getTopUseThing():getId()) then
            return useWith(Rope, tile:getTopUseThing())
        end
    end
end)
table.insert(listaMacros, RopeMacro)

-- Scythe Macro
local fieldsScythe = {3653}
local Scythe = 3453
local ScytheMacro = macro(500, "Scythe", function()
    local tileArroundMe = getNearTiles(pos())
    for _, tile in ipairs(tileArroundMe) do
        if table.find(fieldsScythe, tile:getTopUseThing():getId()) then
            return useWith(Scythe, tile:getTopUseThing())
        end
    end
end)
table.insert(listaMacros, ScytheMacro)

-- Machete Macro
local fieldsMachete = {2130, 3696}
local Machete = 3308
local MacheteMacro = macro(500, "Machete", function()
    local tileArroundMe = getNearTiles(pos())
    for _, tile in ipairs(tileArroundMe) do
        if table.find(fieldsMachete, tile:getTopUseThing():getId()) then
            return useWith(Machete, tile:getTopUseThing())
        end
    end
end)
table.insert(listaMacros, MacheteMacro)

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

UI.SwitchAndButton({on = config.enabled, left = "Herramienta", right = "Menu"}, function(widget)
    config.enabled = not config.enabled
    for i, mac in ipairs(listaMacros) do
        mac.setOn(config.enabled and checkboxes[i]:isChecked())
    end
end, function()
    configWindow:show()
    configWindow:raise()
    configWindow:focus()
end)



