g_ui.loadUIFromString([[
menPanel < Panel
  margin: 2
  margin-bottom: 17
  layout:
    type: verticalBox

ConfigWindowDruid < MainWindow
  !text: tr('- ELDER DRUID -')
  font: terminus-10px
  color: green
  size: 230 210
  @onEscape: self:hide()

  TabBar
    id: spellsTabBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2

  Panel
    id: spellsImagem
    anchors.top: spellsTabBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    image-border: 2

  Button
    id: closeButton
    !text: tr('Cerrar')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 49 21
    margin-top: 1
    margin-right: -5
    margin-bottom: -5
]])

local panelName = "configDruid"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then
  configWindowDruid = UI.createWindow('ConfigWindowDruid', rootWidget)
  configWindowDruid:hide()
  local TabBarSpells = configWindowDruid.spellsTabBar
  TabBarSpells:setContentWidget(configWindowDruid.spellsImagem)

  -- Panel para macros Normales
  local normalPanel = g_ui.createWidget("menPanel")
  normalPanel:setId("panelNormal")
  TabBarSpells:addTab("PVP", normalPanel)

  -- Panel para macros No PK
  local noPkPanel = g_ui.createWidget("menPanel")
  noPkPanel:setId("panelNoPK")
  TabBarSpells:addTab("No PVP", noPkPanel)

  -- Panel para macros Wheel
  local wheelPanel = g_ui.createWidget("menPanel")
  wheelPanel:setId("panelWheel")
  TabBarSpells:addTab("WHEEL", wheelPanel)

  -- Panel para macros Más
  local masPanel = g_ui.createWidget("menPanel")
  masPanel:setId("panelMas")
  TabBarSpells:addTab("  +  ", masPanel)

  UI.Separator(normalPanel)
  UI.Separator(noPkPanel)
  UI.Separator(wheelPanel)
  UI.Separator(masPanel)

  local listaMacrosNormal = {}
  local listaMacrosNoPK = {}
  local listaMacrosWheel = {}
  local listaMacrosMas = {}

-- Macros para hechizos del Druid
local exevoGranMasFrigo = macro(4000, "Exevo Gran Mas Frigo", function()
    if g_game.isAttacking() then
        say("exevo gran mas frigo")
    end
end)

local exevoGranMasTera = macro(2500, "Exevo Gran Mas Tera", function()
    if g_game.isAttacking() then
        say("exevo gran mas tera")
        say("exevo gran mas tera")
        say("exevo gran mas tera")
    end
end)

local exevoFrigo = macro(1500, "Exevo Frigo hur", function()
    if g_game.isAttacking() then
        say("exevo frigo hur")
    end
end)

local exevoTera = macro(2000, "Exevo tera hur", function()
    if g_game.isAttacking() then
        say("exevo tera hur")
    end
end)

local exoriFrigo = macro(1300, "Exori Frigo", function()
    if g_game.isAttacking() then
        say("exori frigo")
    end
end)

local exoriTera = macro(1300, "Exori Tera", function()
    if g_game.isAttacking() then
        say("exori tera")
    end
end)

-- Agregando los macros a la lista
table.insert(listaMacrosNormal, exevoGranMasFrigo)
table.insert(listaMacrosNormal, exevoGranMasTera)
table.insert(listaMacrosNormal, exevoFrigo)
table.insert(listaMacrosNormal, exevoTera)
table.insert(listaMacrosNormal, exoriFrigo)
table.insert(listaMacrosNormal, exoriTera)

local MasfrigoNopk = macro(4010, "Exevo Gran Mas Frigo (No-Pk)", function()
    local playerInScreen = false
    if not g_game.isAttacking() then
        return
    end
    for i, mob in ipairs(getSpectators()) do
        if (getDistanceBetween(player:getPosition(), mob:getPosition()) <= 5 and mob:isPlayer()) and (player:getName() ~= mob:getName()) then
            playerInScreen = true
        end
    end
    if not playerInScreen then
        say("exevo gran mas frigo")
    end
end)


local MasteraNopk = macro(2500, "Exevo Gran Mas Tera (No-PK)", function()
    local playerInScreen = false
    if not g_game.isAttacking() then
        return
    end
    for i, mob in ipairs(getSpectators()) do
        if (getDistanceBetween(player:getPosition(), mob:getPosition()) <= 7 and mob:isPlayer()) and (player:getName() ~= mob:getName()) then
            playerInScreen = true
        end
    end
    if not playerInScreen then
        say("exevo gran mas tera")
    end
end)

table.insert(listaMacrosNoPK, MasfrigoNopk)
table.insert(listaMacrosNoPK, MasteraNopk)


local ulusFrigo = macro(11500, "Exevo Ulus Frigo", function()
    if g_game.isAttacking() then
        say("exevo ulus frigo")
    end
end)

local ulusTera = macro(11500, "Exevo Ulus Tera", function()
    if g_game.isAttacking() then
        say("exevo ulus tera")
    end
end)

table.insert(listaMacrosWheel, ulusFrigo)
table.insert(listaMacrosWheel, ulusTera)

macro(100, "Exevo Frigo hur (target)", function()
  local spell = "exevo frigo hur"
  local max_distance = 4
  local exhausted = 1550

  local enemy = target()
  if not enemy then return true end
  local pos = player:getPosition()
  local cpos = enemy:getPosition()
  if getDistanceBetween(pos, cpos) > max_distance then return true end
  local diffx = cpos.x - pos.x
  local diffy = cpos.y - pos.y
  if diffx > 0 and diffy == 0 then turn(1) cast(spell) delay(exhausted)
  elseif diffx < 0 and diffy == 0 then turn(3) cast(spell) delay(exhausted)
  elseif diffx == 0 and diffy > 0 then turn(2) cast(spell) delay(exhausted)
  elseif diffx == 0 and diffy < 0 then turn(0) cast(spell) delay(exhausted)
  end
end, masPanel)



macro(100, "Exevo Tera Hur (target)", function()
  local spell = "exevo tera hur"
  local max_distance = 5
  local exhausted = 2000

  local enemy = target()
  if not enemy then return true end
  local pos = player:getPosition()
  local cpos = enemy:getPosition()
  if getDistanceBetween(pos, cpos) > max_distance then return true end
  local diffx = cpos.x - pos.x
  local diffy = cpos.y - pos.y
  if diffx > 0 and diffy == 0 then turn(1) cast(spell) delay(exhausted)
  elseif diffx < 0 and diffy == 0 then turn(3) cast(spell) delay(exhausted)
  elseif diffx == 0 and diffy > 0 then turn(2) cast(spell) delay(exhausted)
  elseif diffx == 0 and diffy < 0 then turn(0) cast(spell) delay(exhausted)
  end
end, masPanel)




  local checkboxesNormal = {}
  local checkboxesNoPK = {}
  local checkboxesWheel = {}
  local checkboxesMas = {}

  -- Agregar checkboxes para el panel Normal
  for _, mac in ipairs(listaMacrosNormal) do
      local checkbox = g_ui.createWidget("CheckBox", normalPanel)
      checkbox:setText(mac.switch:getText())
      checkbox.onCheckChange = function(wid, isChecked)
          mac.setOn(isChecked and config.enabled)
      end
      checkbox:setChecked(mac.isOn())
      mac.switch:setVisible(false)
      table.insert(checkboxesNormal, checkbox)
  end

  -- Agregar checkboxes para el panel No PK
  for _, mac in ipairs(listaMacrosNoPK) do
      local checkbox = g_ui.createWidget("CheckBox", noPkPanel)
      checkbox:setText(mac.switch:getText())
      checkbox.onCheckChange = function(wid, isChecked)
          mac.setOn(isChecked and config.enabled)
      end
      checkbox:setChecked(mac.isOn())
      mac.switch:setVisible(false)
      table.insert(checkboxesNoPK, checkbox)
  end

  -- Agregar checkboxes para el panel Wheel
  for _, mac in ipairs(listaMacrosWheel) do
      local checkbox = g_ui.createWidget("CheckBox", wheelPanel)
      checkbox:setText(mac.switch:getText())
      checkbox.onCheckChange = function(wid, isChecked)
          mac.setOn(isChecked and config.enabled)
      end
      checkbox:setChecked(mac.isOn())
      mac.switch:setVisible(false)
      table.insert(checkboxesWheel, checkbox)
  end

  -- Agregar checkboxes para el panel Más
  for _, mac in ipairs(listaMacrosMas) do
      local checkbox = g_ui.createWidget("CheckBox", masPanel)
      checkbox:setText(mac.switch:getText())
      checkbox.onCheckChange = function(wid, isChecked)
          mac.setOn(isChecked and config.enabled)
      end
      checkbox:setChecked(mac.isOn())
      mac.switch:setVisible(false)
      table.insert(checkboxesMas, checkbox)
  end

  configWindowDruid.closeButton.onClick = function(widget)
      configWindowDruid:hide()
  end

  -- Switch para habilitar/deshabilitar los macros
  UI.SwitchAndButton({on = config.enabled, left = "Druid Spells", right = "Menu"}, function(widget)
      config.enabled = not config.enabled
      for i, mac in ipairs(listaMacrosNormal) do
          mac.setOn(config.enabled and checkboxesNormal[i]:isChecked())
      end
      for i, mac in ipairs(listaMacrosNoPK) do
          mac.setOn(config.enabled and checkboxesNoPK[i]:isChecked())
      end
      for i, mac in ipairs(listaMacrosWheel) do
          mac.setOn(config.enabled and checkboxesWheel[i]:isChecked())
      end
      for i, mac in ipairs(listaMacrosMas) do
          mac.setOn(config.enabled and checkboxesMas[i]:isChecked())
      end
  end, function()
      configWindowDruid:show()
      configWindowDruid:raise()
      configWindowDruid:focus()
  end)
end
