-- ANTIPUSH

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Anti-Push')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Editar
]])

local edit = setupUI([[
Panel
  height: 90
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Stack Items:

  BotContainer
    id: pushItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 65
]])
edit:hide()

if not storage.antiPush then
    storage.antiPush = {
      enabled = false,
      pushItems = { 3031, 3447, 3492 },
    }
end

local config = storage.antiPush

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  ui.title:setOn(config.enabled)
end

UI.Container(function()
    config.pushItems = edit.pushItems:getItems()
    end, true, nil, edit.pushItems) 
edit.pushItems:setItems(config.pushItems)


local antiPush = macro(100, function()
  if not config.enabled then return end

  local pos = player:getPosition()
  local tile = g_map.getTile(pos)

  if #tile:getItems() > 7 then return true end

  local topItem = tile:getTopUseThing():getId()

  for i, item in pairs(config.pushItems) do
    local drop = findItem(item.id)
    if drop and item.id ~= topItem then
      return g_game.move(drop,pos,1)
    end
  end

end)
