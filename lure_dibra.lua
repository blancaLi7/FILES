
g_ui.loadUIFromString([[
LureButton < Panel
  height: 28
  margin-top: 3
  Button
    id: btn
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

LureScrollBar < Panel
  height: 28
  margin-top: 3

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  HorizontalScrollBar
    id: scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 0
    maximum: 10
    step: 1

LureTextEdit < Panel
  height: 40
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  TextEdit
    id: textEdit
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    minimum: 0
    maximum: 10
    step: 1
    text-align: center

LureItem < Panel
  height: 34
  margin-top: 7
  margin-left: 25
  margin-right: 25

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter

  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right


LureCheckBox < BotSwitch
  height: 20
  margin-top: 7

LureWindow < MainWindow
  !text: tr('Lure made by: Vivo Dibra :)')
  padding: 25

  Label
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: parent.top
    text-align: center

  Label
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  VerticalScrollBar
    id: contentScroll
    anchors.top: prev.bottom
    margin-top: 3
    anchors.right: parent.right
    anchors.bottom: separator.top
    step: 28
    pixels-scroll: true
    margin-right: -10
    margin-top: 5
    margin-bottom: 5

  ScrollablePanel
    id: content
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    vertical-scrollbar: contentScroll
    margin-bottom: 10
      
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

    VerticalSeparator
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  ResizeBorder
    id: bottomResizeBorder
    anchors.fill: separator
    height: 3
    minimum: 260
    maximum: 600
    margin-left: 3
    margin-right: 3
    background: #ffffff88    

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-right: 5  
]])

-- securing storage namespace
local panelName = "Lure"
if not storage[panelName] then
  storage[panelName] = {
    Positions = {},
    KillPos = nil
  }
end

local settings = storage[panelName]

-- basic elements
LureWindow = UI.createWindow('LureWindow', rootWidget)
LureWindow:hide()
LureWindow.closeButton.onClick = function(widget)
  LureWindow:hide()
end

LureWindow:setHeight(340)
LureWindow:setWidth(450)

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Lure')

  Button
    id: push
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])

ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {}
end

ui.title:setOn(settings.enabled)
ui.title.onClick = function(widget)
  settings.enabled = not settings.enabled
  widget:setOn(settings.enabled)
end

ui.push.onClick = function(widget)
  LureWindow:show()
  LureWindow:raise()
  LureWindow:focus()
end

-- available options for dest param
local rightPanel = LureWindow.content.right
local leftPanel = LureWindow.content.left

-- objects made by Kondrah - taken from creature editor, minor changes to adapt
local addCheckBox = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('LureCheckBox', dest)
  widget.onClick = function()
    widget:setOn(not widget:isOn())
    settings[id] = widget:isOn()
    
  end
  widget:setText(title)
  widget:setTooltip(tooltip)
  if settings[id] == nil then
    widget:setOn(defaultValue)
  else
    widget:setOn(settings[id])
  end
  settings[id] = widget:isOn()
end

local addItem = function(id, title, defaultItem, dest, tooltip)
  local widget = UI.createWidget('LureItem', dest)
  widget.text:setText(title)
  widget.text:setTooltip(tooltip)
  widget.item:setTooltip(tooltip)
  widget.item:setItemId(settings[id] or defaultItem)
  widget.item.onItemChange = function(widget)
    settings[id] = widget:getItemId()
  end
  settings[id] = settings[id] or defaultItem
end

local addTextEdit = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('LureTextEdit', dest)
  widget.text:setText(title)
  widget.textEdit:setText(settings[id] or defaultValue or "")
  widget.text:setTooltip(tooltip)
  widget.textEdit.onTextChange = function(widget,text)
    settings[id] = text
  end
  settings[id] = settings[id] or defaultValue or ""
end

local addScrollBar = function(id, title, min, max, defaultValue, dest, tooltip)
  local widget = UI.createWidget('LureScrollBar', dest)
  widget.text:setTooltip(tooltip)
  widget.scroll.onValueChange = function(scroll, value)
    widget.text:setText(title .. ": " .. value)
    if value == 0 then
      value = 1
    end
    settings[id] = value
  end
  widget.scroll:setRange(min, max)
  widget.scroll:setTooltip(tooltip)
  if max-min > 1000 then
    widget.scroll:setStep(100)
  elseif max-min > 100 then
    widget.scroll:setStep(10)
  end
  widget.scroll:setValue(settings[id] or defaultValue)
  widget.scroll.onValueChange(widget.scroll, widget.scroll:getValue())
end

local addButton = function(title, action, dest)
  local widget = UI.createWidget('LureButton', dest)
  widget.btn:setText(title)
  widget.btn.onClick = function()
    action()
  end
end

--Variables
local s = {}

s.states = {
  Walking = 1,
  Luring = 2,
  Killing = 3,
  Waiting = 4
}

s.currentState = s.states.Walking
s.lureIndex = 1
s.walkDelay = 500
s.standTime = now

--Functions
onPlayerPositionChange(function(x,y)
  s.standTime = now
end)

function standTime()
  return now - s.standTime
end

s.nextWalk = 0
s.autoWalk = function(position)
  if position and now > s.nextWalk and not player:isAutoWalking() and not table.equals(pos(), position) then 
    autoWalk(position, 124, { ignoreNonPathable=true, precision=1, ignoreStairs=false })
    s.nextWalk = now + s.walkDelay
  end
end

s.nextLurePosition = function()
  s.lureIndex = s.lureIndex + 1  
  if s.lureIndex > #settings.Positions then
    s.lureIndex = 1
  end
end

s.clearTexts = function()
  for _, tile in ipairs(g_map.getTiles(posz())) do
    tile:setText('')
  end
end

s.setTileText = function(position, text)
  if position then
    local t = g_map.getTile(position)
    if t then
      t:setText(text)
    end
  end
end

function table.findTable(tbl, value)
  for i, v in ipairs(tbl) do
    if table.equal(v, value) then
      return i
    end
  end
  return nil
end

s.getOkMonsters = function()
  local monsters = {}
  for _, spec in ipairs(getSpectators(false)) do
    if spec:isMonster() and table.find(settings.Monsters:split('\n'), spec:getName(), true) then
      local mobPos = spec:getPosition()
      if mobPos and getDistanceBetween(pos(), mobPos) <=7 and findPath(pos(), mobPos, 20, {ignoreLastCreature=true}) then
        table.insert(monsters, spec)
      end
    end
  end
  return monsters
end

s.getClosestMob = function()
  local mobs = s.getOkMonsters()
  table.sort(mobs, function(a, b)
    local aDist = getDistanceBetween(pos(), a:getPosition())
    local bDist = getDistanceBetween(pos(), b:getPosition())
    return aDist < bDist
  end)
  return mobs[1]
end

s.setCurrentMob = function(mob)
  local mobs = s.getOkMonsters()
  for _, m in ipairs(mobs) do
    m:setText("")
  end
  mob:setText("Lure")
end

s.addOrRemoveLurePos = function()
  local p = pos()
  local i = table.findTable(settings.Positions, p) 
  if i then
    table.remove(settings.Positions, i)
  else
    table.insert(settings.Positions, p)
  end
  s.clearTexts() 
end

s.setKillPos = function()
  settings.KillPos = pos()
  s.clearTexts() 
end

if not settings.Monsters then
  settings.Monsters = 'rat\nbug\nspider'
end

s.openLureList = function()
  UI.MultilineEditorWindow(settings.Monsters, {title="Monsters", description='name\nname\nname'}, function(text)
    settings.Monsters = text
  end)
end

s.toggleTargetBot = function(on)
  if settings.TargetBot then
    TargetBot.setOn(on)
  end
end

s.clearAllPosition = function()
  settings.Positions = {}
  settings.KillPos = nil
  s.clearTexts()
end

--Macros
s.m_walking = macro(100, function()
  if not settings.enabled then return end
  if s.currentState ~= s.states.Walking then return end

  s.toggleTargetBot(false)
  local p = settings.Positions[s.lureIndex]
  if not p then return end  
  
  if getDistanceBetween(pos(), p) < 2 then    
    s.currentState = s.states.Luring
    return
  end  
  s.autoWalk(p)
end)

s.m_luring = macro(100, function()
  if not settings.enabled then return end
  if s.currentState ~= s.states.Luring then return end

  local p = settings.KillPos
  if not p then return end  

  if getDistanceBetween(pos(), p) == 0 then    
    s.nextLurePosition()
    if s.getClosestMob() then
      s.currentState = s.states.Killing
      s.toggleTargetBot(true)
    else
      s.currentState = s.states.Walking
    end
    return
  end  
  s.autoWalk(p)
end)

s.m_updateTexts = macro(100, function()
  s.setTileText(settings.KillPos, "Kill Pos")
  for _, p in ipairs(settings.Positions) do
    s.setTileText(p, "Walk Pos")
  end
end)

macro(50, function()
  if not settings.enabled then return end

  delay(settings.WalkTime)
  local mob = s.getClosestMob()

  if mob then
    s.setCurrentMob(mob)
    local cPos = mob:getPosition()
    local okDistance = cPos and getDistanceBetween(pos(), cPos) <= settings.KeepDistance
    local mobQtyOk = #s.getOkMonsters() >= settings.MinMobs
    if not mobQtyOk then return end

    if okDistance then
      s.currentState = s.states.Luring
    else
      s.currentState = s.states.Waiting
      g_game.cancelAttackAndFollow()
    end
  elseif s.currentState == s.states.Killing then
    s.currentState = s.states.Walking
  end
end)

addScrollBar("MinMobs", "Min Mobs", 0, 20, 1, leftPanel, "")
addScrollBar("KeepDistance", "Keep Distance", 0, 10, 3, leftPanel, "")
addScrollBar("WalkTime", "WalkTime (MS)", 0, 2000, 100, leftPanel, "")
addLabel("","", leftPanel):setColor("white")
addButton("Lure List", s.openLureList, leftPanel)
addCheckBox("TargetBot", "Set TargetBot On", false, leftPanel)

addButton("Set/Remove Lure Pos", s.addOrRemoveLurePos, rightPanel)
addButton("Set Kill Pos", s.setKillPos, rightPanel)

addLabel("",'\n\n', rightPanel):setColor("white")
addButton("Clear All", s.clearAllPosition, rightPanel)


macro(1000, function()
  if standTime() > 1000 * 10 then
    s.currentState = s.states.Walking
  end
end)

warning = function() end

