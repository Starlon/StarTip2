local addon, profile = ...

local WidgetText = {}
WidgetText.ALIGN_LEFT, WidgetText.ALIGN_CENTER, WidgetText.ALIGN_RIGHT, WidgetText.ALIGN_MARQUEE, WidgetText.ALIGN_AUTOMATIC, WidgetText.ALIGN_PINGPONG = 1, 2, 3, 4, 5, 6
WidgetText.SCROLL_RIGHT, WidgetText.SCROLL_LEFT = 1, 2

profile.lines = {
    [1] = {
        id = "unitname",
        name = "UnitName",
        left = [[
local name = Name(unit)
if not name then return end
local pvp = UnitIsPVP(unit) and Angle("PVP") or ""
local afk = AFK(unit) and Angle(AFK(unit)) or ""
local offline = Offline(unit) and Angle(Offline(unit)) or ""

local r, g, b
if UnitIsPlayer(unit) then
    r, g, b = ClassColor(unit)
else
    if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
        r, g, b = .5, .5, .5
    else
        r, g, b = UnitSelectionColor(unit)
    end
end

if name then
    return Colorize(("%s %s%s%s"):format(name, afk, offline, pvp), r, g, b)
end
]],
        enabled = true,
        update = 1000,
        leftUpdating = true,
        fontSize = 15
    },
    [2] = {
        id = "guild",
        name = "Guild/Title",
        left = [[
return Guild(unit, true)
]],
        enabled = true
    },

    [3] = {
        id = "info",
        name = "Info",
        left = [[
local lvl = Level(unit) or "??"
return Colorize("Level " .. lvl, DifficultyColor(unit))
]],
        right = [[
return Colorize(Race(unit) or " ", ClassColor(unit))
]],
        enabled = true
    },
    [5] = {
        id = "target",
        name = "Target",
        left = "return 'Target:'",
        right = [[
local pvp = UnitIsPVP(unit .. "target") and "++" or " "
local lvl = Level(unit .. "target")
local class = Class(unit .. "target")
local name = Name(unit.."target") or "None"
local txt = string.format("%s%s%s%s",  name, pvp, lvl and " ("..lvl..") " or "", class and " ("..class..")" or "")
return  class and Colorize(txt, ClassColor(unit.."target")) or Colorize(txt, DifficultyColor(unit.."target"))
]],
        rightUpdating = true,
        update = 500,
        enabled = true,
    },
    [6] = {
        id = "location",
        name = "Location",
        left = "return Location(unit)",
        enabled = true
    },
}

profile.bars = {
    [1] = {
        name = "Health Bar",
        type = "bar",
        expression = [[
self.lastHealthBar = Health(unit)
return self.lastHealthBar or 0
]],
        min = "return 0",
        max = [[
self.lastHealthBarMax = MaxHP(unit)
return self.lastHealthBarMax or 0
]],
        color1 = [[
if not Health(unit) then return 1, 1, 1 end
return Gradient(Health(unit) / MaxHP(unit))
]],
        height = 6,
        length = 0,
        enabled = true,
        update = 300,
        layer = 1, 
        level = 100,
        points = {
            {"TOPLEFT", "StarTipTooltipMain", "BOTTOMLEFT", 0, 0}, 
            {"TOPRIGHT", "StarTipTooltipMain", "BOTTOMRIGHT", 0, 0}}
    },

}

profile.borders = {
    [1] = {
        name = "class or relation",
        expression = [[
if Class(unit) then 
    local r, g, b = ClassColor(unit)
    return r, g, b, .5
end
local r, g, b = DifficultyColor(unit)
return r, g, b, .5
]],
        update = 300,
        repeating = true,
        borderSize = 3
    }
}


profile.animation = {
    animationsOn = false,
    animationSpeed = 1000,
    animationInit = [[
gravity = true
t = 0
]],
    animationBegin = [[
t = t - 5
v = 0
]],
    animationPoint = [[
d=(v*0.3); r=t+i*PI*0.02; x=cos(r)*d; y=sin(r)*d
]]
}

profile.portrait = {
        size = 36,
        tooltipMain = true,
        tooltipUnit = false,
        tooltipItem = true,
        tooltipSpell = true,
        animated = false,
        enabled = true
        
}
StarTip:InitializeProfile("Natural", profile)

