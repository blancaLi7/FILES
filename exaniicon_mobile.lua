
-- Configuración del botón
local config = {
    id = 'CustomIcon',
    name = 'Exani Hur',
    options = {
        ['          UP    '] = 'exani hur "up"',
        ['        DOWN    '] = 'exani hur "down"',
    }
}

-- Función para mostrar el menú emergente
local function showCustomMenu()
    local menu = g_ui.createWidget('PopupMenu') -- Crear un menú emergente

    -- Obtener las opciones y ordenarlas alfabéticamente
    local sortedOptions = {}
    for optionName, command in pairs(config.options) do
        table.insert(sortedOptions, {name = optionName, command = command})
    end
    table.sort(sortedOptions, function(a, b) return a.name < b.name end)

    -- Agregar las opciones ordenadas al menú
    for _, option in ipairs(sortedOptions) do
        menu:addOption(option.name, function()
            g_game.talk(option.command) -- Ejecutar el comando correspondiente
        end)
    end

    menu:display() -- Mostrar el menú
end

-- Función para crear el ícono móvil
function createCustomIcon(xPosition, yPosition)
    local icon = addIcon(config.id, {item=3183, text=config.name, movable=true, switchable=false}, function()
        showCustomMenu() -- Mostrar el menú emergente al hacer clic en el ícono
    end)

    icon:breakAnchors()
    icon:move(xPosition, yPosition)
end

createCustomIcon(250, 200)



