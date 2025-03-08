-- CITY TRAVEL

-- Lista de NPCs y las ciudades a las que pueden transportar
local npcCities = {
  ['Captain Bluebear'] = {'Carlin', 'Ab\'Dendriel', 'Venore', 'Port Hope', 'Liberty Bay', 'Svargrond', 'Yalahar', 'Roshamuul', 'Oramond', 'Edron'},
  ['Scrutinon'] = {'Ab\'Dendriel', 'Darashia', 'Edron', 'venore'},
  ['Captain Greyhound'] = {'Thais', 'Ab\'Dendriel', 'Venore', 'Svargrond', 'Yalahar', 'Edron'},
  ['Captain Fearless'] = {'Issavi', 'Krailos', 'Thais', 'Carlin', 'Ab\'Dendriel', 'Port Hope', 'Edron', 'Darashia', 'Liberty Bay', 'Svargrond', 'Yalahar', 'Gray Island', 'Ankrahmun'},
  ['Captain Seagull'] = {'Thais', 'Carlin', 'Venore', 'Yalahar', 'Edron', 'Gray Island'},
  ['Captain Cookie'] = {'Liberty Bay'},
  ['Jack Fate'] = {'Edron', 'Thais', 'Venore', 'Darashia', 'Ankrahmun', 'Yalahar', 'Port Hope'},
  ['Charles'] = {'Thais', 'Darashia', 'Venore', 'Liberty Bay', 'Ankrahmun', 'Yalahar', 'Edron'},
  ['Karith'] = {'Ab\'Dendriel', 'Darashia', 'Venore', 'Ankrahmun', 'Port Hope', 'Thais', 'Liberty Bay', 'Carlin'},
  ['Captain Max'] = {'Calassa', 'Yalahar', 'Liberty Bay'},
  ['Captain Seahorse'] = {'Krailos', 'Thais', 'Carlin', 'Ab\'Dendriel', 'Venore', 'Port Hope', 'Ankrahmun', 'Liberty Bay', 'Gray Island', 'Cormaya'},
  ['Pemaret'] = {'Edron', 'Eremo'},
  ['Eremo'] = {'Cormaya'},
  ['Captain Pelagia'] = {'Edron', 'Darashia', 'Oramond', 'Venore'},
  ['Captain Gulliver'] = {'Thais', 'Krailos'},
  ['Captain Chelop'] = {'Thais'},
  ['Captain Harava'] = {'Oramond', 'Krailos', 'Venore', 'Darashia'},
  ['Captain sinbeard'] = {'Darashia', 'Venore', 'Liberty Bay', 'Port Hope', 'Yalahar', 'Edron', 'Travora'},
  ['Maris'] = {'Mistrock', 'Fenrock', 'Yalahar'},
  ['Petros'] = {'venore', 'Port Hope', 'Liberty Bay', 'Yalahar', 'Gray Island', 'Ankrahmun', 'Krailos', 'Issavi', 'Travora'}
}

-- Lista de NPCs
local npcs = {
  'Captain Bluebear',
  'Captain Greyhound',
  'Captain Fearless',
  'Captain Seagull',
  'Captain Cookie',
  'Jack Fate',
  'Maris',
  'Charles',
  'Karith',
  'Captain Max',
  'Captain Seahorse',
  'Pemaret',
  'Eremo',
  'Captain Pelagia',
  'Captain Gulliver',
  'Captain Chelop',
  'Captain sinbeard',
  'Petros',
  'Scrutinon',
  'Captain Harava'
}

-- Interfaz de usuario
g_ui.loadUIFromString([[
CityTravelWindow < MainWindow
  text: Viajar a
  size: 120 70

  ComboBox
    id: travelOptions
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: -3
    width: 100
    height: 20
    &menuScroll: true
    &menuHeight: 155
    &menuScrollStep: 25
]])

-- Configuración de almacenamiento
local panelName = "cityTravel"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

-- Crear la ventana de viaje
rootWidget = g_ui.getRootWidget()
if rootWidget then
  local cityTravelWindow = UI.createWindow('CityTravelWindow', rootWidget)
  cityTravelWindow:hide()

  -- Función para actualizar las opciones de viaje según el NPC
  local function updateTravelOptions(npcName)
    cityTravelWindow:recursiveGetChildById('travelOptions'):clearOptions()
    cityTravelWindow:recursiveGetChildById('travelOptions'):addOption("Ninguna")
    if npcCities[npcName] then
      for _, city in ipairs(npcCities[npcName]) do
        cityTravelWindow:recursiveGetChildById('travelOptions'):addOption(city)
      end
    end
  end

  -- Macro para detectar NPCs cercanos
  macro(200, function()
    for _, npcName in ipairs(npcs) do
      local findNpc = getCreatureByName(npcName)
      local playerPos = pos()
      if findNpc and getDistanceBetween(playerPos, findNpc:getPosition()) <= 3 then
        updateTravelOptions(npcName)
        cityTravelWindow:show()
        break
      else
        cityTravelWindow:hide()
      end
    end
  end)

  -- Función para viajar a la ciudad seleccionada
  cityTravelWindow:recursiveGetChildById('travelOptions').onOptionChange = function(widget, option, data)
    if option ~= "Ninguna" then
      NPC.say("hi") -- Saluda al NPC
      schedule(600, function() NPC.say(option) end) -- Dice la ciudad seleccionada
      schedule(900, function() NPC.say("yes") end) -- Primer "yes"
      schedule(1100, function() NPC.say("yes") end) -- Segundo "yes"
      schedule(2100, function() NPC.say("yes") end) -- Tercer "yes"
      schedule(3100, function() NPC.say("yes") end)
    end
  end
end

