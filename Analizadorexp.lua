local launchTime = now
local startExp = exp()
local expTable = {}

local resetSessionData = function()
    launchTime = now
    startExp = exp()
    expTable = {}
end

local expGained = function()
    return exp() - startExp
end

local expLeft = function()
    local level = lvl() + 1
    local neededExp = math.floor((50 * level * level * level) / 3 - 100 * level * level + (850 * level) / 3 - 200)
    if neededExp < 0 then return 0 end
    return neededExp - exp()
end

local niceTimeFormat = function(v)
    local hours = string.format("%02.f", math.floor(v / 3600))
    local mins = string.format("%02.f", math.floor(v / 60 - (hours * 60)))
    return hours .. ":" .. mins .. "h"
end

local sessionTime = function()
    local uptime = math.floor((now - launchTime) / 1000)
    return niceTimeFormat(uptime)
end

local expPerHour = function()
    if #expTable == 0 then return "-" end
    local r = exp() - expTable[1]
    local uptime = (now - launchTime) / 1000
    if uptime < 15 * 60 then
        return math.ceil((r / uptime) * 60 * 60)
    else
        return math.ceil(r * 8)
    end
end

local timeToLevel = function()
    local eph = expPerHour()
    if eph == "-" or eph <= 0 then
        return "-"
    else
        local t = expLeft() / eph
        return niceTimeFormat(math.ceil(t * 60 * 60))
    end
end

macro(500, function()
    table.insert(expTable, exp())
    if #expTable > 15 * 60 then
        table.remove(expTable, 1)
    end
end)

local function format_thousand(num)
    if num == "-" then return "-" end
    return tostring(num):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
end

local ui = setupUI([[
Panel
  height: 130
  padding: 5

  Label
    id: glowLabel
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    text: ANALIZADOR EXP
    width: 300
    height: 18

  Label
    id: SessionLabel
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
    text: Activo tiempo:

  Label
    id: XpGainLabel
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
    text: Exp Ganada:

  Label
    id: XpHourLabel
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
    text: Exp x Hora: 

  Label
    id: NextLevelLabel
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
    text: Siguiente Level:

  Label
    id: one
    anchors.right: parent.right
    anchors.verticalCenter: SessionLabel.verticalCenter
    text-align: right
    text: 00:00h
    width: 150

  Label
    id: two
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    text-align: right
    text: 0
    width: 150

  Label
    id: three
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    text-align: right
    text: 0
    width: 150

  Label
    id: four
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    text-align: right
    text: 0
    width: 150

  Button
    id: resetButton
    anchors.top: prev.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    margin-top: 10
    text: - Reset -
]])

ui.resetButton.onClick = function()
    resetSessionData()
end

ui.one:setColor('#a9a9a9')
ui.two:setColor('#66ff66')
ui.three:setColor('#ffff99')
ui.four:setColor('#ff6666')

function setBrightWhiteGlowColor()
    return "#ffb84d"
end

local glowPosition = 1
local glowDirection = 1

macro(5, function()
    local text = 'Analizador De Experiencia'
    local coloredText = {}

    local numChars = #text
    local glowRange = math.max(1, math.floor(numChars / 20))

    for i = 1, numChars do
        local char = text:sub(i, i)
        local color = "#ff8c00"
        if math.abs(i - glowPosition) <= glowRange then
            color = setBrightWhiteGlowColor()
        end
        table.insert(coloredText, char)
        table.insert(coloredText, color)
    end

    glowPosition = glowPosition + glowDirection
    if glowPosition > numChars then
        glowPosition = numChars - 1
        glowDirection = -1
    elseif glowPosition < 1 then
        glowPosition = 2
        glowDirection = 1
    end

    if ui.glowLabel and ui.glowLabel.setColoredText then
        ui.glowLabel:setColoredText(coloredText)
    end
end)

macro(500, function()
    ui.one:setText(sessionTime())
    ui.two:setText(format_thousand(expGained()))
    ui.three:setText(format_thousand(expPerHour()))
    ui.four:setText(timeToLevel())
end)
