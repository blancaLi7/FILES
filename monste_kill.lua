local monsterKillWindow = nil
local openButton = nil
local isScriptEnabled = storage.monsterKillEnabled or false

-- Configuración de la interfaz de usuario
local simpleUI = setupUI([[
Panel
  height: 35

  Button
    id: openMonsterKillWindowButton
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Monster kill

  Button
    id: toggleScriptButton
    anchors.top: openMonsterKillWindowButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 2
    margin-top: 2
    height: 18
    text: Prender/Apagar
]], parent)

-- Función para actualizar el estado del botón y almacenar el estado del script
local function updateToggleButton()
    if isScriptEnabled then
        simpleUI.toggleScriptButton:setText("Desactivar Monster Kill")
    else
        simpleUI.toggleScriptButton:setText("Activar Monster Kill")
    end
end

-- Al hacer clic en el botón de encender/apagar
simpleUI.toggleScriptButton.onClick = function(widget)
    isScriptEnabled = not isScriptEnabled
    storage.monsterKillEnabled = isScriptEnabled
    updateToggleButton()
end

-- Llamamos la función para asegurar que el botón muestre el estado correcto al inicio
updateToggleButton()

-- Definición de la ventana y su contenido
g_ui.loadUIFromString([[
MonsterKillWindow < MainWindow
  text: Conteo De Kills
  size: 240 210

  Label
    id: searchLabel
    text: "Buscar: "
    anchors.left: parent.left
    anchors.top: parent.top
    height: 20
    width: 50
    color: yellow
    font: verdana-11px-monochrome
    margin-left: 2

  BotTextEdit
    id: filter
    text-align: center
    anchors.left: searchLabel.right
    anchors.top: parent.top
    height: 18
    width: 110
    editable: true
    max-length: 255

  Button
    id: resetList
    anchors.left: filter.right
    anchors.top: filter.top
    width: 45
    height: 18
    margin-left: 5
    text: "Reset"
    color: red
    tooltip: "Resetear datos"

  ScrollablePanel
    id: content
    image-source: /images/ui/menubox
    image-border: 4
    image-border-top: 17
    anchors.top: resetList.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 100
    padding: 3
    vertical-scrollbar: mkScroll
    layout:
      type: verticalBox

  BotSmallScrollBar
    id: mkScroll
    anchors.top: content.top
    anchors.bottom: content.bottom
    anchors.right: content.right
    margin-top: 2
    margin-bottom: 2
    margin-right: 2

  HorizontalSeparator
    id: separator
    anchors.top: content.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 
    margin-left: 2
    margin-right: 2
    height: 2
    color: white

  Button
    id: closeButton
    text: Cerrar
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "monsterKill"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

-- Inicialización del panel de conteo de kills
local storageMonsters = { kills = {} }

local function saveKills(configFile, content)
    local status, result = pcall(function()
        return json.encode(content, 2)
    end)

    if not status then
        return onError("Error guardando configuración. Detalles: " .. result)
    end

    if result:len() > 100 * 1024 * 1024 then
        return onError("El archivo de configuración supera los 100MB, no será guardado.")
    end

    g_resources.writeFileContents(configFile, result)
end

local function readJson(filePath, callback)
    if g_resources.fileExists(filePath) then
        local status, result = pcall(function()
            return json.decode(g_resources.readFileContents(filePath))
        end)
        if not status then
            return onError("Error cargando archivo (" .. filePath .. "). Para corregir el problema, elimina el archivo. Detalles: " .. result)
        end

        callback(result)
    end
end

local MAIN_DIRECTORY = "/bot/" .. modules.game_bot.contentsPanel.config:getCurrentOption().text .. "/storage/" .. g_game.getWorldName() .. '/'
local STORAGE_DIRECTORY = MAIN_DIRECTORY .. panelName .. '.json'

if not g_resources.directoryExists(MAIN_DIRECTORY) then
    g_resources.makeDir(MAIN_DIRECTORY)
end

readJson(STORAGE_DIRECTORY, function(result)
    storageMonsters = result or { kills = {} }
end)

local lbls = {}

local function refreshMK()
    local searchText = monsterKillWindow.filter:getText():lower()
    if #lbls > 0 and (#storageMonsters.kills == #lbls) then
        local i = 1
        for k, v in pairs(storageMonsters.kills) do
            if searchText == "" or k:lower():find(searchText, 1, true) then
                lbls[i].name:setText(k .. ":")
                lbls[i].count:setText("x" .. v)
                i = i + 1
            end
        end
    else
        for _, child in pairs(monsterKillWindow.content:getChildren()) do
            child:destroy()
        end
        local i = 1
        for k, v in pairs(storageMonsters.kills) do
            if searchText == "" or k:lower():find(searchText, 1, true) then
                lbls[k] = g_ui.loadUIFromString([[
Panel
  height: 12
  margin-left: 2

  Label
    id: name
    text:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    text-auto-resize: true
    color: white
    font: verdana-11px-monochrome

  Label
    id: count
    text:
    anchors.top: name.top
    anchors.right: parent.right
    margin-right: 18
    text-auto-resize: true
    color: green
    font: verdana-11px-monochrome
  ]], monsterKillWindow.content)

                if lbls[k] then
                    lbls[k].name:setText(k .. ":")
                    lbls[k].count:setText("x" .. v)
                end
                monsterKillWindow.resetList.onClick = function(widget)
                    storageMonsters.kills[k] = nil
                    saveKills(STORAGE_DIRECTORY, storageMonsters)
                    refreshMK()
                end
                monsterKillWindow.resetList.onDoubleClick = function(widget)
                    storageMonsters.kills = {}
                    saveKills(STORAGE_DIRECTORY, storageMonsters)
                    refreshMK()
                end
                i = i + 1
            end
        end
    end
end

-- Solo refresca el conteo si el script está habilitado
function checkKillOnCreature(creature)
    if not isScriptEnabled then return end

    local creatureName = creature:getName()
    storageMonsters.kills[creatureName] = (storageMonsters.kills[creatureName] or 0) + 1
    refreshMK()
    saveKills(STORAGE_DIRECTORY, storageMonsters)
end

-- Funciones y eventos de la ventana
if rootWidget then
    monsterKillWindow = UI.createWindow('MonsterKillWindow', rootWidget)
    monsterKillWindow:hide()

    simpleUI.openMonsterKillWindowButton.onClick = function(widget)
        monsterKillWindow:show()
        monsterKillWindow:raise()
        monsterKillWindow:focus()
    end

    monsterKillWindow.closeButton.onClick = function(widget)
        monsterKillWindow:hide()
    end

    monsterKillWindow.filter.onTextChange = function(widget)
        refreshMK()
    end

    onCreatureHealthPercentChange(function(creature, percent)
        if not creature:isMonster() then return end
        if creature:getHealthPercent() <= 0 and g_game.getAttackingCreature() == creature then
            checkKillOnCreature(creature)
        end
    end)
end

