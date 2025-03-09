-- Función para crear el ícono con funcionalidad de switchable
function createCityIcon(cityName, xPosition, yPosition)
  local icon = addIcon(cityName .. "San", {item=2994, text=cityName, movable=true, switchable=false}, function()
    NPC.say("hi")
    schedule(600, function() NPC.say(cityName) end)
    schedule(900, function() NPC.say("yes") end)
    schedule(1100, function() NPC.say("yes") end)
    schedule(2100, function() NPC.say("yes") end)
  end)

  icon:breakAnchors()  -- Rompe las restricciones de posición
  icon:move(xPosition, yPosition)  -- Mueve el ícono a la posición dada
end

-- Llamadas para crear los íconos para cada ciudad

createCityIcon("Venore", 240, 25)
createCityIcon("Edron", 280, 25)
createCityIcon("Carlin", 320, 25)
createCityIcon("Yalahar", 360, 25)
createCityIcon("Krailos", 400, 25)
createCityIcon("Cormaya", 440, 25)
-- abajo
createCityIcon("Thais", 200, 25)
createCityIcon("Port Hope", 200, 68)
createCityIcon("Ab'Dendriel", 200, 111)
createCityIcon("Svargrond", 200, 154)
createCityIcon("Liberty Bay", 200, 197)
createCityIcon("Roshamuul", 200, 240)
createCityIcon("Ankrahmun", 200, 283)
createCityIcon("Darashia", 200, 326)
createCityIcon("Farmine", 200, 369)
createCityIcon("Gray Beach", 200, 412)
createCityIcon("Rathleton", 200, 455)






