local customRunUI = setupUI([[
Panel
  height: 22

  Button
    id: editCustomRunList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 1
    margin-right: 1
    height: 20
    text: Runas Custom
]], parent)

g_ui.loadUIFromString([[
CustomRunWindow < MainWindow
  text: CUSTOM RUNE
  size: 180 200

  BotSwitch
    id: customRunBotSwitch1
    text: Runa: 1.3 seg
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 1
    size: 100 20
  
  BotItem
    id: customRunBotItem1
    anchors.top: parent.top
    anchors.left: customRunBotSwitch1.right
    margin-left: 15
    margin-top: -8
    size: 35 35

  BotSwitch
    id: customRunBotSwitch2
    text: Runa: 1.5 seg
    anchors.top: customRunBotSwitch1.bottom
    anchors.left: parent.left
    margin-top: 17
    size: 100 20
  
  BotItem
    id: customRunBotItem2
    anchors.top: customRunBotSwitch2.bottom
    anchors.left: customRunBotSwitch2.right
    margin-left: 15
    margin-top: -25
    size: 35 35

  BotSwitch
    id: customRunBotSwitch3
    text: Runa: 1.8 seg
    anchors.top: customRunBotSwitch2.bottom
    anchors.left: parent.left
    margin-top: 20
    size: 100 20
  
  BotItem
    id: customRunBotItem3
    anchors.top: customRunBotSwitch3.bottom
    anchors.left: customRunBotSwitch3.right
    margin-left: 15
    margin-top: -25
    size: 35 35

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "customRunPanel"
storage[panelName] = storage[panelName] or {
  enabled1 = false,
  enabled2 = false,
  enabled3 = false,
  itemId1 = 0,
  itemId2 = 0,
  itemId3 = 0,
}

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then
  local customRunWindow = UI.createWindow('CustomRunWindow', rootWidget)
  customRunWindow:hide()

  customRunUI.editCustomRunList.onClick = function(widget)
    customRunWindow:show()
    customRunWindow:raise()
    customRunWindow:focus()
  end

  customRunWindow.closeButton.onClick = function(widget)
    customRunWindow:hide()
  end

  -- Primer BotSwitch
  local customRunBotSwitch1 = customRunWindow:getChildById('customRunBotSwitch1')
  customRunBotSwitch1:setOn(config.enabled1)
  customRunBotSwitch1.onClick = function(widget)
    config.enabled1 = not config.enabled1
    widget:setOn(config.enabled1)
  end

  -- Primer BotItem
  local customRunBotItem1 = customRunWindow:getChildById('customRunBotItem1')
  customRunBotItem1:setItemId(config.itemId1)
  customRunBotItem1.onItemChange = function(widget)
    config.itemId1 = widget:getItemId()
  end

  -- Segundo BotSwitch
  local customRunBotSwitch2 = customRunWindow:getChildById('customRunBotSwitch2')
  customRunBotSwitch2:setOn(config.enabled2)
  customRunBotSwitch2.onClick = function(widget)
    config.enabled2 = not config.enabled2
    widget:setOn(config.enabled2)
  end

  -- Segundo BotItem
  local customRunBotItem2 = customRunWindow:getChildById('customRunBotItem2')
  customRunBotItem2:setItemId(config.itemId2)
  customRunBotItem2.onItemChange = function(widget)
    config.itemId2 = widget:getItemId()
  end

  -- Tercer BotSwitch
  local customRunBotSwitch3 = customRunWindow:getChildById('customRunBotSwitch3')
  customRunBotSwitch3:setOn(config.enabled3)
  customRunBotSwitch3.onClick = function(widget)
    config.enabled3 = not config.enabled3
    widget:setOn(config.enabled3)
  end

  -- Tercer BotItem
  local customRunBotItem3 = customRunWindow:getChildById('customRunBotItem3')
  customRunBotItem3:setItemId(config.itemId3)
  customRunBotItem3.onItemChange = function(widget)
    config.itemId3 = widget:getItemId()
  end
end

-- Macro para el primer BotSwitch (1.3 segundos)
macro(1300, function()
  if not config.enabled1 then return end
  local target = g_game.getAttackingCreature()
  if not target or not g_game.isAttacking() or not target:canShoot() then return end
  useWith(config.itemId1, target)
end)

-- Macro para el segundo BotSwitch (1.5 segundos)
macro(1500, function()
  if not config.enabled2 then return end
  local target = g_game.getAttackingCreature()
  if not target or not g_game.isAttacking() or not target:canShoot() then return end
  useWith(config.itemId2, target)
end)

-- Macro para el tercer BotSwitch (1.8 segundos)
macro(1800, function()
  if not config.enabled3 then return end
  local target = g_game.getAttackingCreature()
  if not target or not g_game.isAttacking() or not target:canShoot() then return end
  useWith(config.itemId3, target)
end)
