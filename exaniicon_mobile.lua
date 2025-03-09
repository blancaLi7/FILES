

-- Configuración del botón
local config = {
    id = 'CustomIcon',
    name = 'Exani Hur',
    options = {
        ['        UP    '] = 'exani hur "up"',
        ['     DOWN    '] = 'exani hur "down"',
    }
}

-- Función para mostrar el menú emergente
local function showCustomMenu()
    local menu = g_ui.createWidget('PopupMenu')

    local sortedOptions = {}
    for optionName, command in pairs(config.options) do
        table.insert(sortedOptions, {name = optionName, command = command})
    end
    table.sort(sortedOptions, function(a, b) return a.name < b.name end)

    for _, option in ipairs(sortedOptions) do
        menu:addOption(option.name, function()
            g_game.talk(option.command)
        end)
    end

    menu:display()
end

-- Función para hacer el icono arrastrable con F1
local function activeDrag(icon, nameStorage, position)
    icon:breakAnchors()
    icon:move(position.posX or 250, position.posY or 200)

    icon.onDragEnter = function(widget, mousePos)
        if not g_keyboard.isKeyPressed("F1") then
            return false
        end
        icon:breakAnchors()
        icon.movingReference = { x = mousePos.x - icon:getX(), y = mousePos.y - icon:getY() }
        return true
    end

    icon.onDragMove = function(widget, mousePos, moved)
        local parentRect = widget:getParent():getRect()
        local x = math.min(math.max(parentRect.x, mousePos.x - widget.movingReference.x), parentRect.x + parentRect.width - widget:getWidth())
        local y = math.min(math.max(parentRect.y - widget:getParent():getMarginTop(), mousePos.y - widget.movingReference.y), parentRect.y + parentRect.height - widget:getHeight())
        widget:move(x, y)
        icon.moving = { x = icon:getX(), y = icon:getY() }
        return true
    end

    icon.onDragLeave = function(widget, pos)
        storage[nameStorage] = { posX = icon.moving.x, posY = icon.moving.y }
    end
end

-- Función para crear el ícono móvil con la funcionalidad de arrastrar
function createCustomIcon(xPosition, yPosition)
    local icon = addIcon(config.id, {item=3183, text=config.name, movable=true, switchable=false}, function()
        showCustomMenu()
    end)

    activeDrag(icon, config.id .. "Position", storage[config.id .. "Position"] or {})
end

createCustomIcon(250, 200)


