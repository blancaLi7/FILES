-- Crear el macro
local comboMacro = macro(100, "Combo Spells", function()
  if storage[combozPanelName].spellzTablez and #storage[combozPanelName].spellzTablez > 0 then
    for _, entry in pairs(storage[combozPanelName].spellzTablez) do
      if entry.enabled and entry.originz == "Spell" and g_game.isAttacking() then
        say(entry.spellz)
        delay(500)
      end
    end
  end
end)

-- Configuración de la UI
local ui = setupUI([[
Panel
  height: 25

  Button
    id: edit
    anchors.top: parent.top 
    anchors.left: parent.left 
    anchors.right: parent.right
    margin-left: 2
    margin-top: 3
    height: 20
    text: --- Menu ---
    font: verdana-11px-monochrome 
]])

-- Asignar funcionalidad al botón "Edit"
ui.edit.onClick = function(widget)
  if combozWindow then
    combozWindow:show()
    combozWindow:raise()
    combozWindow:focus()
  end
end

g_ui.loadUIFromString([[
cPanel < Panel
  margin: 3
  margin-bottom: 17
  layout:
    type: verticalBox

cmbComboWindow < MainWindow
  !text: tr(' COMBOx ')
  font: verdana-11px-rounded
  size: 215 310
  color: white
  @onEscape: self:hide()

  TabBar
    id: cmbTabBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 40

  Panel
    id: cmbImagem
    anchors.top: cmbTabBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    image-border: 9

  Button
    id: closeButton
    !text: tr('cerrar')
    color: white
    font: verdana-11px-rounded
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 49 21
    margin-top: 13
    margin-right: 5
    margin-bottom: -5        
]])

local comboPanelName = "listt"
local ui = setupUI([[
Panel
  height: 1
]], parent)
ui:setId(comboPanelName)

if not storage[comboPanelName] then
  storage[comboPanelName] = {}
end

rootWidget = g_ui.getRootWidget()
if rootWidget then
    CombosWindow = UI.createWidget('cmbComboWindow', rootWidget)
    CombosWindow:hide()
    TabBar2 = CombosWindow.cmbTabBar
    TabBar2:setContentWidget(CombosWindow.cmbImagem)
    for v = 1, 1 do
        cmbPanel = g_ui.createWidget("cPanel") -- Creates Panel
        cmbPanel:setId("panelButtons") -- sets ID

        cmbPanel2 = g_ui.createWidget("cPanel") -- Creates Panel
        cmbPanel2:setId("2") -- sets ID

        cmbPanel3 = g_ui.createWidget("cPanel") -- Creates Panel
        cmbPanel:setId("panelButtons") -- sets ID

        cmbPanel4 = g_ui.createWidget("cPanel") -- Creates Panel
        cmbPanel:setId("panelButtons") -- sets ID

        TabBar2:addTab("Combo", cmbPanel)
    end
end

g_ui.loadUIFromString([[
spellzszourceBoxPopupMenu < ComboBoxPopupMenu
spellzszourceBoxPopupMenuButton < ComboBoxPopupMenuButton
spellzszourceBox < ComboBox
  @onSetup: |
    self:addOption("Spell")

spellzEntryz < Label
  background-color: alpha
  text-offset: 18 0
  focusable: true
  height: 16

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 15
    height: 15
    margin-top: 2
    margin-left: 3

  $focus:
    background-color: #00000055

  Button
    id: remove
    !text: tr('X')
    color: white
    anchors.right: parent.right
    margin-right: 15
    width: 15
    height: 15                       

spellzHealing < Panel
  image-border: 6
  padding: 3
  size: 400 200

  Label
    id: whenspellz
    anchors.left: spellzListz.right
    anchors.top: parent.top
    text: ----
    width: 28
    color: white
    font: verdana-11px-monochrome 
    margin-top: 10
    margin-left: 5

  spellzszourceBox
    id: spellzszource
    anchors.top: parent.top
    anchors.left: whenspellz.right
    margin-top: 5
    margin-left: 35
    width: 100

  Label
    id: castspellz
    anchors.left: whenspellz.left
    anchors.top: whenspellz.bottom
    text: Spell: 
    color: white
    font: verdana-11px-monochrome 
    margin-top: 9

  TextEdit
    id: spellzFormula
    color: black
    size: 100 21
    margin-left: -10
    anchors.left: spellzszource.left
    anchors.top: spellzszource.bottom
    anchors.right: spellzvaluez.right

  TextList
    id: spellzListz
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    padding: 1
    size: 210 180
    margin-bottom: 3
    margin-left: 3
    vertical-scrollbar: spellzListzScrollBar

  VerticalScrollBar
    id: spellzListzScrollBar
    anchors.top: spellzListz.top
    anchors.bottom: spellzListz.bottom
    anchors.right: spellzListz.right
    step: 14
    pixels-scroll: true

  Button
    id: addspellz
    anchors.left: castspellz.left
    anchors.bottom: castspellz.bottom
    margin-bottom: -40
    margin-right: 10
    text: Agregar
    size: 100 30
    color: white
    font: verdana-11px-rounded

  Button
    id: MoveUp
    anchors.right: addspellz.right
    anchors.bottom: addspellz.bottom
    margin-bottom: -35
    margin-right: -90
    text: Mover Arriba
    color : white
    size: 90 20
    font: verdana-11px-monochrome 

  Button
    id: MoveDown
    anchors.left: MoveUp.left
    anchors.bottom: MoveUp.bottom
    margin-bottom: 0
    margin-left: -100
    color : white
    text: Mover Abajo
    size: 90 20
    font: verdana-11px-monochrome 

combozWindow < MainWindow
  !text: tr('Combo Spells')
  size: 440 250
  color: white
  font: verdana-11px-rounded
  @onEscape: self:hide()

  spellzHealing
    id: spellzsz
    anchors.top: parent.top
    anchors.left: parent.left

  Button
    id: closeButton
    !text: tr('cerrar')
    color: white
    font: verdana-11px-rounded
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 5 
]])

combozPanelName = "Combo"
if not storage[combozPanelName] or not storage[combozPanelName].spellzTablez then
  storage[combozPanelName] = {
    enabled = false,
    checkboxz = false,
    spellzTablez = {},
  }
end

modules.game_interface.addMenuHook("category", "Combo",
  function()
    combozWindow:show()
  end,
  function(menuPosition, lookThing, useThing, creatureThing)
    if creatureThing and creatureThing == player then
      return true
    end
    return false
  end
)

rootWidget = g_ui.getRootWidget()
if rootWidget then
  combozWindow = UI.createWidget('combozWindow', rootWidget)
  combozWindow:hide()

  local refreshspellzszz = function()
    if storage[combozPanelName].spellzTablez and #storage[combozPanelName].spellzTablez > 0 then
      for i, child in pairs(combozWindow.spellzsz.spellzListz:getChildren()) do
        child:destroy()
      end
      for _, entry in pairs(storage[combozPanelName].spellzTablez) do
        local label = g_ui.createWidget("spellzEntryz", combozWindow.spellzsz.spellzListz)
        label.onDoubleClick = function(widget)
          for _, entry in pairs(storage[combozPanelName].spellzTablez) do
            table.removevalue(storage[combozPanelName].spellzTablez, entry)
            label:destroy()
            combozWindow.spellzsz.spellzFormula:setText(entry.spellz)
          end
        end
        label.enabled:setChecked(entry.enabled)
        label.enabled.onClick = function(widget)
          entry.enabled = not entry.enabled
          label.enabled:setChecked(entry.enabled)
        end
        label.remove.onClick = function(widget)
          table.removevalue(storage[combozPanelName].spellzTablez, entry)
          label:destroy()
          reindexTable(storage[combozPanelName].spellzTablez)
        end
        label:setText(entry.originz .. entry.valuez .. ":" .. " " .. entry.spellz)
        label:setColoredText({entry.originz, "white", " : ", "black", " ", "black", entry.spellz, "green"})
        label:setFont("verdana-11px-rounded")
      end
    end
  end
  refreshspellzszz()



  combozWindow.spellzsz.MoveUp.onClick = function(widget)
    local input = combozWindow.spellzsz.spellzListz:getFocusedChild()
    if not input then return end
    local index = combozWindow.spellzsz.spellzListz:getChildIndex(input)
    if index < 2 then return end

    local move
    local move2
    if storage[combozPanelName].spellzTablez and #storage[combozPanelName].spellzTablez > 0 then
      for _, entry in pairs(storage[combozPanelName].spellzTablez) do
        if entry.index == index -1 then
          move = entry
        end
        if entry.index == index then
          move2 = entry
        end
      end
      if move and move2 then
        move.index = index
        move2.index = index - 1
      end
    end
    table.sort(storage[combozPanelName].spellzTablez, function(a,b) return a.index < b.index end)

    combozWindow.spellzsz.spellzListz:moveChildToIndex(input, index - 1)
    combozWindow.spellzsz.spellzListz:ensureChildVisible(input)
  end

  combozWindow.spellzsz.MoveDown.onClick = function(widget)
    local input = combozWindow.spellzsz.spellzListz:getFocusedChild()
    if not input then return end
    local index = combozWindow.spellzsz.spellzListz:getChildIndex(input)
    if index >= combozWindow.spellzsz.spellzListz:getChildCount() then return end

    local move
    local move2
    if storage[combozPanelName].spellzTablez and #storage[combozPanelName].spellzTablez > 0 then
      for _, entry in pairs(storage[combozPanelName].spellzTablez) do
        if entry.index == index +1 then
          move = entry
        end
        if entry.index == index then
          move2 = entry
        end
      end
      if move and move2 then
        move.index = index
        move2.index = index + 1
      end
    end
    table.sort(storage[combozPanelName].spellzTablez, function(a,b) return a.index < b.index end)

    combozWindow.spellzsz.spellzListz:moveChildToIndex(input, index + 1)
    combozWindow.spellzsz.spellzListz:ensureChildVisible(input)
  end

  combozWindow.spellzsz.addspellz.onClick = function(widget)
    local spellzFormula = combozWindow.spellzsz.spellzFormula:getText():trim()
    local spellzTrigger = combozWindow.spellzsz:getText()
    local spellzszource = combozWindow.spellzsz.spellzszource:getCurrentOption().text
    local source
    local equasion

    if not spellzTrigger then  
      warn("Error") 
      combozWindow.spellzsz.spellzFormula:setText('')
      return 
    end

    if spellzszource == "Spell" then
      source = "Spell"
    end

    if spellzFormula:len() > 0 then
      table.insert(storage[combozPanelName].spellzTablez,  {index = #storage[combozPanelName].spellzTablez+1, spellz = spellzFormula, areas = spellzFormula, signz = equasion, originz = source, valuez = spellzTrigger, enabled = true})
      combozWindow.spellzsz.spellzFormula:setText('')
    end
    refreshspellzszz()
  end

  combozWindow.closeButton.onClick = function(widget)
    combozWindow:hide()
  end
end

CombosWindow.closeButton.onClick = function(widget)
  CombosWindow:hide()
end

