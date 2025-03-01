
--INICIA IMBUEMENTS 

UI.Label("Imbuements")

local imbueUI = setupUI([[
Panel
  height: 20

  Button
    id: editPlayerList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 1
    height: 18
    text: LEECH
]], parent)

g_ui.loadUIFromString([[
ImbueWindow < MainWindow
  text: IMBUEMENTS
  size: 150 150
  
  Label
    id: leechLabel
    text: SELECCIONA: 
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    font: verdana-11px-rounded

  Button
    id: lifeLeechButton
    text: Life Leech
    anchors.top: leechLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded
  
  Button
    id: manaLeechButton
    text: Mana Leech
    anchors.top: lifeLeechButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: manaLeechButton.bottom
    margin-top: 6
    margin-bottom: 6

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "imbuePanel"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then
  local imbueWindow = UI.createWindow('ImbueWindow', rootWidget)
  imbueWindow:hide()

  imbueUI.editPlayerList.onClick = function(widget)
    imbueWindow:show()
    imbueWindow:raise()
    imbueWindow:focus()
  end

  imbueWindow.closeButton.onClick = function(widget)
    imbueWindow:hide()
  end
  
  local lifeLeechButton = imbueWindow:recursiveGetChildById('lifeLeechButton')
  lifeLeechButton.onClick = function()
    NPC.say("hi")
    schedule(1000, function() NPC.say("trade") end)
    if NPC.isTradeOpen then
      schedule(2000, function() NPC.buy(9633, 15) end)
      schedule(3000, function() NPC.buy(9685, 25) end)
      schedule(4000, function() NPC.buy(9663, 5) end)
    end
    schedule(5000, function() NPC.closeTrade() end)
    schedule(6000, function() NPC.say("bye") end)
  end
  
  local manaLeechButton = imbueWindow:recursiveGetChildById('manaLeechButton')
  manaLeechButton.onClick = function()
    NPC.say("hi")
    schedule(1000, function() NPC.say("trade") end)
    if NPC.isTradeOpen then
      schedule(2000, function() NPC.buy(11492, 25) end)
      schedule(3000, function() NPC.buy(20200, 25) end)
      schedule(4000, function() NPC.buy(22730, 5) end)
    end
    schedule(5000, function() NPC.closeTrade() end)
    schedule(6000, function() NPC.say("bye") end)
  end
end



local skillUI = setupUI([[
Panel
  height: 20

  Button
    id: editPlayerList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 1
    height: 18
    text: UP SKILL
]], parent)

g_ui.loadUIFromString([[
SkillWindow < MainWindow
  text: IMBUEMENTS
  size: 150 210
  
  Label
    id: skillLabel
    text: SELECCIONA: 
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    font: verdana-11px-rounded

  Button
    id: distanceButton
    text: Distance
    anchors.top: skillLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded
  
  Button
    id: magicLevelButton
    text: Magic Level
    anchors.top: distanceButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: clubButton
    text: Club
    anchors.top: magicLevelButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: axeButton
    text: Axe
    anchors.top: clubButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: swordButton
    text: Swod
    anchors.top: axeButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: swordButton.bottom
    margin-top: 6
    margin-bottom: 6

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "skillPanel"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then
  local skillWindow = UI.createWindow('SkillWindow', rootWidget)
  skillWindow:hide()

  skillUI.editPlayerList.onClick = function(widget)
    skillWindow:show()
    skillWindow:raise()
    skillWindow:focus()
  end

  skillWindow.closeButton.onClick = function(widget)
    skillWindow:hide()
  end
  
  local skillButtons = {
    {id = 'distanceButton', items = {11464, 25, 18994, 20, 10298, 10}},
    {id = 'magicLevelButton', items = {9635, 25, 11452, 15, 10304, 15}},
    {id = 'clubButton', items = {9657, 20, 22189, 15, 10405, 10}},
    {id = 'axeButton', items = {10196, 20, 11447, 25, 21200, 20}},
    {id = 'swordButton', items = {9691, 25, 21202, 25, 9654, 5}},
  }

  for _, buttonInfo in ipairs(skillButtons) do
    local button = skillWindow:recursiveGetChildById(buttonInfo.id)
    button.onClick = function()
      NPC.say("hi")
      schedule(1000, function() NPC.say("trade") end)
      if NPC.isTradeOpen then
        schedule(2000, function() NPC.buy(buttonInfo.items[1], buttonInfo.items[2]) end)
        schedule(3000, function() NPC.buy(buttonInfo.items[3], buttonInfo.items[4]) end)
        schedule(4000, function() NPC.buy(buttonInfo.items[5], buttonInfo.items[6]) end)
      end
      schedule(5000, function() NPC.closeTrade() end)
      schedule(6000, function() NPC.say("bye") end)
    end
  end
end



local protectionUI = setupUI([[
Panel
  height: 20

  Button
    id: editPlayerList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 1
    height: 18
    text: PROTECTION
]], parent)

g_ui.loadUIFromString([[
ProtectionWindow < MainWindow
  text: IMBUEMENTS
  size: 150 260
  
  Label
    id: protectionLabel
    text: SELECCIONA: 
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    font: verdana-11px-rounded

  Button
    id: shieldButton
    text: Shield
    anchors.top: protectionLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded
  
  Button
    id: protectHolyButton
    text: Holy
    anchors.top: shieldButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: protectDeathButton
    text: Death
    anchors.top: protectHolyButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: protectEnergyButton
    text: Energy
    anchors.top: protectDeathButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: protectFireButton
    text: Fire
    anchors.top: protectEnergyButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: protectIceButton
    text: Ice
    anchors.top: protectFireButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: protectEarthButton
    text: Earth
    anchors.top: protectIceButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: protectEarthButton.bottom
    margin-top: 6
    margin-bottom: 6

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "protectionPanel"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then
  local protectionWindow = UI.createWindow('ProtectionWindow', rootWidget)
  protectionWindow:hide()

  protectionUI.editPlayerList.onClick = function(widget)
    protectionWindow:show()
    protectionWindow:raise()
    protectionWindow:focus()
  end

  protectionWindow.closeButton.onClick = function(widget)
    protectionWindow:hide()
  end
  
  local protectionButtons = {
    {id = 'shieldButton', items = {9641, 20, 11703, 25, 20199, 25}},
    {id = 'protectHolyButton', items = {9639, 25, 9638, 25, 10304, 20}},
    {id = 'protectDeathButton', items = {11446, 25, 22007, 20, 9660, 5}},
    {id = 'protectEnergyButton', items = {9644, 20, 14079, 15, 9665, 10}},
    {id = 'protectFireButton', items = {5877, 20, 16131, 10, 11658, 5}},
    {id = 'protectIceButton', items = {10295, 25, 10307, 15, 14012, 10}},
    {id = 'protectEarthButton', items = {17823, 25, 9694, 20, 11702, 10}},
  }

  for _, buttonInfo in ipairs(protectionButtons) do
    local button = protectionWindow:recursiveGetChildById(buttonInfo.id)
    button.onClick = function()
      NPC.say("hi")
      schedule(1000, function() NPC.say("trade") end)
      if NPC.isTradeOpen then
        schedule(2000, function() NPC.buy(buttonInfo.items[1], buttonInfo.items[2]) end)
        schedule(3000, function() NPC.buy(buttonInfo.items[3], buttonInfo.items[4]) end)
        schedule(4000, function() NPC.buy(buttonInfo.items[5], buttonInfo.items[6]) end)
      end
      schedule(5000, function() NPC.closeTrade() end)
      schedule(6000, function() NPC.say("bye") end)
    end
  end
end


local elementalDamageUI = setupUI([[
Panel
  height: 20

  Button
    id: editPlayerList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 1
    height: 18
    text: ELEMENTAL DAMAGE
]], parent)

g_ui.loadUIFromString([[
ElementalDamageWindow < MainWindow
  text: IMBUEMENTS
  size: 150 210
  
  Label
    id: elementalDamageLabel
    text: SELECCIONA: 
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    font: verdana-11px-rounded

  Button
    id: deathButton
    text: Death
    anchors.top: elementalDamageLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded
  
  Button
    id: energyButton
    text: Energy
    anchors.top: deathButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: earthButton
    text: Earth
    anchors.top: energyButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: frostButton
    text: Frost
    anchors.top: earthButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: fireButton
    text: Fire
    anchors.top: frostButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: fireButton.bottom
    margin-top: 6
    margin-bottom: 6

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "elementalDamagePanel"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then
  local elementalDamageWindow = UI.createWindow('ElementalDamageWindow', rootWidget)
  elementalDamageWindow:hide()

  elementalDamageUI.editPlayerList.onClick = function(widget)
    elementalDamageWindow:show()
    elementalDamageWindow:raise()
    elementalDamageWindow:focus()
  end

  elementalDamageWindow.closeButton.onClick = function(widget)
    elementalDamageWindow:hide()
  end
  
  local elementalDamageButtons = {
    {id = 'deathButton', items = {11484, 25, 9647, 20, 10402, 5}},
    {id = 'energyButton', items = {18993, 25, 21975, 5, 23508, 5}},
    {id = 'earthButton', items = {9686, 25, 9640, 20, 21194, 2}},
    {id = 'frostButton', items = {9661, 25, 21801, 10, 9650, 5}},
    {id = 'fireButton', items = {9636, 25, 5920, 5, 5954, 5}},
  }

  for _, buttonInfo in ipairs(elementalDamageButtons) do
    local button = elementalDamageWindow:recursiveGetChildById(buttonInfo.id)
    button.onClick = function()
      NPC.say("hi")
      schedule(1000, function() NPC.say("trade") end)
      if NPC.isTradeOpen then
        schedule(2000, function() NPC.buy(buttonInfo.items[1], buttonInfo.items[2]) end)
        schedule(3000, function() NPC.buy(buttonInfo.items[3], buttonInfo.items[4]) end)
        schedule(4000, function() NPC.buy(buttonInfo.items[5], buttonInfo.items[6]) end)
      end
      schedule(5000, function() NPC.closeTrade() end)
      schedule(6000, function() NPC.say("bye") end)
    end
  end
end


local supportUI = setupUI([[
Panel
  height: 20

  Button
    id: editSupportList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 1
    height: 18
    text: SUPORTE
]], parent)

g_ui.loadUIFromString([[
SupportWindow < MainWindow
  text: IMBUEMENTS
  size: 150 200
  
  Label
    id: supportLabel
    text: SELECCIONA: 
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    font: verdana-11px-rounded

  Button
    id: criticalButton
    text: Critical
    anchors.top: supportLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded
  
  Button
    id: capacityButton
    text: Capacity
    anchors.top: criticalButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: speedButton
    text: Speed
    anchors.top: capacityButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  Button
    id: removeParalyzeButton
    text: Remove Paralyze
    anchors.top: speedButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 3
    height: 20
    font: verdana-11px-rounded

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: removeParalyzeButton.bottom
    margin-top: 6
    margin-bottom: 6

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "supportPanel"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then
  local supportWindow = UI.createWindow('SupportWindow', rootWidget)
  supportWindow:hide()

  supportUI.editSupportList.onClick = function(widget)
    supportWindow:show()
    supportWindow:raise()
    supportWindow:focus()
  end

  supportWindow.closeButton.onClick = function(widget)
    supportWindow:hide()
  end
  
  local supportButtons = {
    {id = 'criticalButton', items = {11444, 20, 10311, 25, 22728, 5}},
    {id = 'capacityButton', items = {25694, 25, 25702, 10, 20205, 5}},
    {id = 'speedButton', items = {17458, 15, 10302, 25, 14081, 20}},
    {id = 'removeParalyzeButton', items = {22053, 20, 23507, 15, 28567, 5}},
  }

  for _, buttonInfo in ipairs(supportButtons) do
    local button = supportWindow:recursiveGetChildById(buttonInfo.id)
    button.onClick = function()
      NPC.say("hi")
      schedule(1000, function() NPC.say("trade") end)
      if NPC.isTradeOpen then
        schedule(2000, function() NPC.buy(buttonInfo.items[1], buttonInfo.items[2]) end)
        schedule(3000, function() NPC.buy(buttonInfo.items[3], buttonInfo.items[4]) end)
        schedule(4000, function() NPC.buy(buttonInfo.items[5], buttonInfo.items[6]) end)
      end
      schedule(5000, function() NPC.closeTrade() end)
      schedule(6000, function() NPC.say("bye") end)
    end
  end
end


