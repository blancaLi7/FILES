g_ui.loadUIFromString([[
ConfigWindow < MainWindow
  text: Utilidades
  size: 185 170

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
      cell-size: 175 16
      cell-spacing: 2

  Button
    id: closeButton
    text: Cerrar
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "configUtilidad"
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

-- BWS Cuerpos
local urToolIdBWS = 5942
local knifeBodiesBWS = {4097, 4137, 8738, 18958}
local BWSCuerpos = macro(500, "Blessed Wooden Stake ", function()
  for i, tile in ipairs(g_map.getTiles(posz())) do
    local item = tile:getTopThing()
    if item and item:isContainer() then
      if math.max(math.abs(posx()-tile:getPosition().x), math.abs(posy()-tile:getPosition().y)) <= 5 then
        if table.find(knifeBodiesBWS, item:getId()) and findItem(urToolIdBWS) then
          useWith(urToolIdBWS, item)
          CaveBot.delay(500)
          return
        end
      end
    end
  end
end)
table.insert(listaMacros, BWSCuerpos)

-- Obsidian Knife Cuerpos
local urToolIdObsidian = 5908
local knifeBodiesObsidian = {4286, 4272, 4173, 4011, 4025, 4047, 4052, 4057, 4062, 4112, 4212, 4321, 4324, 4327, 10352, 10356, 10360, 10364}
local ObsidianCuerpos = macro(500, "Obsidian Knife", function()
  for i, tile in ipairs(g_map.getTiles(posz())) do
    local item = tile:getTopThing()
    if item and item:isContainer() then
      if math.max(math.abs(posx()-tile:getPosition().x), math.abs(posy()-tile:getPosition().y)) <= 5 then
        if table.find(knifeBodiesObsidian, item:getId()) and findItem(urToolIdObsidian) then
          useWith(urToolIdObsidian, item)
          CaveBot.delay(500)
          return
        end
      end
    end
  end
end)
table.insert(listaMacros, ObsidianCuerpos)

-- Auto Pescar
local waterIds = {4597,4598,4599,4600,4601,4602}
local minDistance = 7
local AutoPescar = macro(300, "Auto Pescar", function()
  local waterTiles = {}
  for _, tile in ipairs(g_map.getTiles(posz())) do
    if table.contains(waterIds, tile:getTopUseThing():getId()) and getDistanceBetween(pos(), tile:getPosition()) <= minDistance then
      table.insert(waterTiles, tile)
    end
  end
  if #waterTiles > 0 then
    useWith(3483, waterTiles[math.random(#waterTiles)]:getTopUseThing())
  end
end)
table.insert(listaMacros, AutoPescar)


-- Pescar Cuerpos
local urToolIdPescar = 3483
local knifeBodiesPescar = {9582}
local PescarCuerpos = macro(500, "Pescar Cuerpos", function()
  for i, tile in ipairs(g_map.getTiles(posz())) do
    local item = tile:getTopThing()
    if item and item:isContainer() then
      if math.max(math.abs(posx()-tile:getPosition().x), math.abs(posy()-tile:getPosition().y)) <= 5 then
        if table.find(knifeBodiesPescar, item:getId()) and findItem(urToolIdPescar) then
          useWith(urToolIdPescar, item)
          CaveBot.delay(500)
          return
        end
      end
    end
  end
end)
table.insert(listaMacros, PescarCuerpos)

-- Oberon reply
local talkToOberon = macro(1, 'Oberon Dialogos', function() end)

onTalk(function(name, level, mode, text, channelId, pos)
  if talkToOberon.isOff() then return end
  if mode == 34 then
    if string.find(text, "world will suffer for") then
      say("Are you ever going to fight or do you prefer talking!")
    elseif string.find(text, "feet when they see me") then
      say("Even before they smell your breath?")
    elseif string.find(text, "from this plane") then
      say("Too bad you barely exist at all!") 
    elseif string.find(text, "ESDO LO") then
      say("SEHWO ASIMO, TOLIDO ESD!") 
    elseif string.find(text, "will soon rule this world") then
      say("Excuse me but I still do not get the message!") 
    elseif string.find(text, "honourable and formidable") then
      say("Then why are we fighting alone right now?") 
    elseif string.find(text, "appear like a worm") then
      say("How appropriate, you look like something worms already got the better of!") 
    elseif string.find(text, "will be the end of mortal") then
      say("Then let me show you the concept of mortality before it!") 
    elseif string.find(text, "The true virtue of chivalry are my belief!") then
      say("Dare strike up a Minnesang and you will receive your last accolade!") 
    end
  end
end)

table.insert(listaMacros, talkToOberon)

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

UI.SwitchAndButton({on = config.enabled, left = "Utilidades", right = "Menu"}, function(widget)
    config.enabled = not config.enabled
    for i, mac in ipairs(listaMacros) do
        mac.setOn(config.enabled and checkboxes[i]:isChecked())
    end
end, function()
    configWindow:show()
    configWindow:raise()
    configWindow:focus()
end)



