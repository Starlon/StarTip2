local profile = ...

profile.unittooltip = {
    [1] = {
        name = "UnitName",
        left = [[
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
local afk = AFK(unit)
if afk then
    afk = " " .. Angle(afk)
else
    afk = ""
end
local dnd = DND(unit)
if dnd and afk == "" then
    afk = " " .. Angle(dnd)
end
local offline = Offline(unit)
if offline then
    afk = " " .. Angle(offline)
end
local dead = Dead(unit)
if dead then
    afk =  afk .. " " .. Angle(dead)
end
local port = StarTip:GetModule("Portrait")
local texture  = ""
if port and port.texture then
    texture = port.texture:GetTexture() 
end
if texture ~= "" then
    texture = Texture("", port.db.profile.size) .. " "
end
return texture .. Colorize((Name(unit, true) or Name(unit)) .. afk , r, g, b)
]],
        right = nil,
        bold = true,
        enabled = true,
        cols = 80,
        leftOutlined = 3,
    leftUpdating = true,
    update = 500
    },
    [2] = {
        name = L["Target"],
        left = 'return L["Target:"]',
        right = [[
-- Here's an example of how to deal with DogTag support.
-- Note that you have to consider which quote characters
-- you are using to contain the entire dog tag within,
-- as opposed what you're using inside. Here I'm using `'` surrounding 
-- everything, and I'm using `"` within the dog tag itself.
-- Also, each new line inside a string should end with a '\'.
-- Also note; you'll have to "escape" where you wish to enter a '\' character
-- inside your dog tag. Do that by repeating the '\' character.
-- Example: return "\\ FOO \\"
-- Would print "\ FOO \"

local unit = unit .. "target"

if not UnitExists(unit) then return L["None"] end

local dt = '\
[IsUnit("player") and "<YOU>":ClassColor or Color(Name, %f, %f, %f ) \
(if PvP then \
 "++":Red \
end)]'

local r, g, b
if UnitIsPlayer(unit) then
    r, g, b = ClassColor(unit)
else
    r, g, b = UnitSelectionColor(unit)
end

self.dogtagUnit = unit

return dt:format(r, g, b)
]],
        rightUpdating = true,
    leftUpdating = true,
        update = 500,
        enabled = true,
    dogtag = true
    },
    [3] = {
        name = L["Guild"],
        left = 'return L["Guild:"]',
        right = [[
return Guild(unit, true)
]],
        enabled = true
    },
    [4] = {
        name = L["Rank"],
        left = 'return L["Rank:"]',
        right = [[
local rank = Rank(unit)
local index = RankIndex(unit)
if rank then
  return format("%s (%d)", rank, index)
end
]],
        enabled = true,
    },
    [5] = {
        name = L["Realm"],
        left = 'if Realm(unit) then return L["Realm:"] end',
        right = [[
return Realm(unit)
]],
        enabled = true
    },
    [6] = {
        name = L["Level"],
        left = 'return L["Level:"]',
        right = [[
local classification = Classification(unit)
local lvl = Level(unit)
local str = ""
local r, g, b
if classification then
    str = classification
end
if lvl then
    str = str .. " (" .. lvl .. ")"
end
str = Colorize(str, DifficultyColor(unit))
return str
]],
        enabled = true,
    },
    [7] = {
        name = L["Gender"],
        left = 'return L["Gender:"]',
        right = [[
local sex = UnitSex(unit)
if sex == 2 then
    return L["Male"]
elseif sex == 3 then
    return L["Female"]
end
]],
        enabled = true
    },
    [8] = {
        name = L["Race"],
        left = 'return L["Race:"]',
        right = [[
return SmartRace(unit)
]],
        enabled = true,
    },
    [9] = {
        name = "Class",
        left = 'return L["Class:"]',
        right = [[
local class, tag = UnitClass(unit)
if class == UnitName(unit) then return end
local r, g, b
if UnitIsPlayer(unit) then
    r, g, b = ClassColor(unit)
else
    r, g, b = 1, 1, 1
end
return Texture(format("Interface\\Addons\\StarTip\\Media\\icons\\%s.tga", tag), 16) .. Colorize(" " .. class, r, g, b)
]],
        enabled = true,
        cols = 100
    },
    [10] = {
        name = L["Druid Form"],
        left = 'return L["Form:"]',
        right = [[
return DruidForm(unit)
]],
        enabled = true
    },
    [11] = {
        name = L["Faction"],
        left = 'return L["Faction:"]',
        right = [[
return Faction(unit)
]],
        enabled = true,
    },
    [12] = {
        name = L["Status"],
        left = 'return L["Status:"]',
        right = [[
if not UnitIsConnected(unit) then
    return L["Offline"]
elseif HasAura(unit, GetSpellInfo(19752)) then
    return L["Divine Intervention"]
elseif UnitIsFeignDeath(unit) then
    return L["Feigned Death"]
elseif UnitIsGhost(unit) then
    return L["Ghost"]
elseif UnitIsDead(unit) and HasAura(unit, GetSpellInfo(20707)) then
    return L["Soulstoned"]
elseif UnitIsDead(unit) then
    return L["Dead"]
end
return L["Alive"]
]],
        enabled = true,
    },
    [13] = {
        name = L["Health"],
        left = 'return L["Health:"]',
        right = [[
if not UnitExists(unit) then self:Stop(); return self.lastHealth end
local health, maxHealth = HP(unit), MaxHP(unit)
local r, g, b = HPColor(health, maxHealth)
local value = L["Unknown"]
if maxHealth == 100 then
    value = Colorize(health .. "%", r, g, b)
elseif maxHealth ~= 0 then
    value = Colorize(format("%s/%s (%d%%)", Short(health, true), Short(maxHealth, true), health/maxHealth*100), r, g, b)
end
self.lastHealth = value
return value
]],
        rightUpdating = true,
        update = 1000,
        enabled = true,
    events = {UNIT_HEALTH = true}
    },
    [14] = {
        name = L["Mana"],
        left = [[
return PowerName(unit)
]],
        right = [[
if not UnitExists(unit) then self:Stop(); return self.lastMana end
local mana = Power(unit)
local maxMana = MaxPower(unit)
local r, g, b = PowerColor(nil, unit)
local h, s, v = RGB2HSV(r, g, b)
s = .5
r, g, b = HSV2RGB(h, s, v)
local value = L["Unknown"]
if maxMana == 100 or maxMana == 120 then
    value = Colorize(tostring(mana), r, g, b)
elseif maxMana ~= 0 then
    value = Colorize(format("%s/%s (%d%%)", Short(mana, true), Short(maxMana, true), mana/maxMana*100), r, g, b)
end
self.lastMana = value
return value
]],
        rightUpdating = true,
        enabled = true,
        update = 0,
    colorR = "",
    unitOverride = false,
    events = {UNIT_POWER=true}
    },
    [15] = {
        name = L["Effects"],
        left = 'return L["Effects:"]',
        right = [[
local name = Name(unit)
local str = ""
if UnitIsBanished(unit) then
    str = str .. Angle(L["Banished"])
end
if UnitIsCharmed(unit) then
    str = str .. Angle(L["Charmed"])
end
if UnitIsConfused(unit) then
    str = str .. Angle(L["Confused"])
end
if UnitIsDisoriented(unit) then
    str = str .. Angle(L["Disoriented"])
end
if UnitIsFeared(unit) then
    str = str .. Angle(L["Feared"])
end
if UnitIsFrozen(unit) then
    str = str .. Angle(L["Frozen"])
end
if UnitIsHorrified(unit) then
    str = str .. Angle(L["Horrified"])
end
if UnitIsIncapacitated(unit) then
    str = str .. Angle(L["Incapacitated"])
end
if UnitIsPolymorphed(unit) then
    str = str .. Angle(L["Polymorphed"])
end
if UnitIsSapped(unit) then
    str = str .. Angle(L["Sapped"])
end
if UnitIsShackled(unit) then
    str = str .. Angle(L["Shackled"])
end
if UnitIsAsleep(unit) then
    str = str .. Angle(L["Asleep"])
end
if UnitIsStunned(unit) then
    str = str .. Angle(L["Stunned"])
end
if UnitIsTurned(unit) then
    str = str .. Angle(L["Turned"])
end
if UnitIsDisarmed(unit) then
    str = str .. Angle(L["Disarmed"])
end
if UnitIsPacified(unit) then
    str = str .. Angle(L["Pacified"])
end
if UnitIsRooted(unit) then
    str = str .. Angle(L["Rooted"])
end
if UnitIsSilenced(unit) then
    str = str .. Angle(L["Silenced"])
end
if UnitIsEnsnared(unit) then
    str = str .. Angle(L["Ensnared"])
end
if UnitIsEnraged(unit) then
    str = str .. Angle(L["Enraged"])
end
if UnitIsWounded(unit) then
    str = str .. Angle(L["Wounded"])
end
if str == "" then
    return L["Has Control"] .. " "
else
    return str .. " "
end
]],
        rightUpdating = true,
        enabled = true,
        update = 500,
    },
    [16] = {
        name = L["Marquee"],
        left = 'return "StarTip " .. StarTip.version',
        leftUpdating = true,
        enabled = false,
        marquee = true,
        cols = 40,
        bold = true,
        align = WidgetText.ALIGN_MARQUEE,
        update = 1000,
        speed = 200,
        direction = WidgetText.SCROLL_LEFT,
        dontRtrim = true,
    colorL = "return random(), random(), random(), 1"
    },
    [17] = {
        name = L["Memory Usage"],
        left = "return L['Memory Usage:']",
        right = [[
local mem, percent, memdiff, totalMem, totaldiff, memperc = GetMemUsage("StarTip", true)
if mem then
    local num = floor(memperc)
    if num < 1 then num = 1 end
    if num > 100 then num = 100 end
    local r, g, b = gradient[num][1], gradient[num][2], gradient[num][3]
    return Colorize(format("%s (%.2f%%)", memshort(mem), memperc), r, g, b)
end
]],
        rightUpdating = true,
        update = 1000
    },
    [18] = {
        name = L["CPU Usage"],
        desc = L["Note that you must turn on CPU profiling"],
        left = 'return "CPU Usage:"',
        right = [[
local cpu, percent, cpudiff, totalCPU, totaldiff, cpuperc = GetCPUUsage("StarTip", true)
if cpu then
    local num = floor(cpuperc)
    if num < 1 then num = 1 end
    if num > 100 then num = 100 end
    local r, g, b = gradient[num][1], gradient[num][2], gradient[num][3]
    return Colorize(format("%s (%.2f%%)", timeshort(cpu), cpuperc), r, g, b)
end
]],
        rightUpdating = true,
        update = 1000
    },
    [19] = {
        name = L["Talents"],
        left = "return L['Talents:']",
        right = [[
if not UnitExists(unit) then return lastTalents end
local str = SpecText(unit)
local ilvl = UnitILevel(unit, true)
if ilvl then
    str = format("%s (%s ilvl)", str, ilvl)
end
lastTalents = str
return str
]],
        rightUpdating = true,
        enabled = true,
        cols = 180,
        update = 1000
    },
    [20] = {
        name = "Current Role",
        left = [[
return "Current Role:"
]],
        right = [[
return GetRole(unit)
]],
        rightUpdating = true,
        enabled = true,
        update = 1000,
        deleted = true
    },
    [21] = {
        name = "Old Role",
        left = [[
return "Old Role:"
]],
        right = [[
return select(2, GetRole(unit))
]],
        rightUpdating = true,
        enabled = true,
        update = 1000,
        deleted = true
    },
    [22] = {
        name = "Avg Item Level",
        left = [[
if not UnitExists(unit) then return "" end
return "Item Level:"
]],
        right = [[
if not UnitExists(unit) then return "" end
return UnitILevel(unit)
]],
        rightUpdating = true,
        enabled = true,
        update = 1000,
        deleted = true
    },
    [23] = {
        name = L["Zone"],
        left = [[
-- This doesn't work. Leaving it here for now.
return L["Zone:"]
]],
        right = [[
return select(6, UnitGuildInfo(unit))
]],
        enabled = false
    },
    [24] = {
        name = L["Location"],
        left = [[
return L["Location:"]
]],
        right = [[
return select(3, GetUnitTooltipScan(unit))
]],
        enabled = true
    },
    [25] = {
        name = L["Range"],
        left = [[
if not UnitExists(unit) then return lastRange end
local min, max = RangeCheck:GetRange(unit)
local str
if not min then
    str = ""
elseif not max then
    str = format(L["Target is over %d yards"], min)
else
    str = format(L["Between %s and %s yards"], min, max)
end
lastRange = str
return str
]],
        leftUpdating = true,
        enabled = true,
        update = 500
    },
    [26] = {
        name = L["Movement"],
        left = [[
if not UnitExists(unit) then return "" end
local pitch = GetUnitPitch(unit)
local speed = GetUnitSpeed(unit)
local str = ""
if abs(pitch) > .01 then
    str = format("Pitch: %.1f", pitch)
end
if speed > 0 then
    if str ~= "" then
        str = str .. " - "
    end
    str = str .. format("Speed: %.1f", speed)
end
if str == "" then return "blank()" end
return str
]],
        leftUpdating = true,
        enabled = true,
        update = 500
    },
    [27] = {
        name = L["Guild Note"],
        left = [[
return L["Guild Note:"]
]],
        right = [[
return select(7, UnitGuildInfo(unit))
]],
        enabled = true
    },
    [28] = {
        name = L["Main"],
        left = [[
-- This requires Chatter
return L["Main:"]
]],
        right = [[
if not _G.Chatter then return end
local mod = _G.Chatter:GetModule("Alt Linking")
local name = UnitName(unit)
return mod.db.realm[name]
]],
        enabled = true
    },
    [29] = {
        name = "Recount",
        left = [[
return "Recount:"
]],
right = [[
local val, perc, persec, maxvalue, total = RecountUnitData(unit)
if val and val ~= 0 then
    local p = total ~= 0 and (val / maxvalue) or 1
    local r, g, b = Gradient(p)
    local prefix=""
    if persec then
        prefix = persec .. ", "
    end
    return Colorize(string.format("%d (%s%d%%)", val, prefix, perc), r, g, b)
end
]],
        enabled = true,
        rightUpdating = true,
        update = 1000
    },
    [30] = {
        name = "DPS",
        left = [[
return "DPS:"
]],
        right = [[
return UnitDPS(unit)
]],
        enabled = true,
        rightUpdating = true,
        update = 1000
    },
    [31] = {
        name = "Skada DPS",
        left = [[
return "Skada DPS:"
]],
        right = [[
local dps = SkadaUnitDPS(unit)
if dps then
    return format("%d", dps)
end
]],
        enabled = true,
        rightUpdating = true,
        update = 1000
    },
    [32] = {
        name = L["Spell Cast"],
        left = [[
local cast_data = CastData(unit)
if cast_data then
    if cast_data.channeling then
        return L["Channeling:"]
    end
    return L["Casting:"]
end
return ""
]],
        right = [[
local cast_data = CastData(unit)
if cast_data then
  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target
  local stop_time,stop_duration = cast_data.stop_time
  local i = -1
  if cast_data.casting then
    local start_time = cast_data.start_time
    i = (GetTime() - start_time) / (cast_data.end_time - start_time) * 100
  elseif cast_data.channeling then
    local end_time = cast_data.end_time
    i = (end_time - GetTime()) / (end_time - cast_data.start_time) * 100
  end
  local icon = Texture(format("Interface\\Addons\\StarTip\\Media\\gradient\\gradient-%d.blp", i), 12) .. " "
  
  if stop_time then
    stop_duration = GetTime() - stop_time
  end
  Alpha(-(stop_duration or 0) + 1)
  
  if stop_message then
    return stop_message
  elseif target then
    return icon .. format("%s (%s)",spell,target)
  else
    return icon .. spell 
  end
end
]],
        enabled = true,
        cols = 100,
        rightUpdating = true,
        update = 500
    },
    [33] = {
        name = L["Fails"],
        left = [[
local fails = NumFails(unit)
if fails and fails > 0 then
  return format(L["Fails: %d"], fails)
end
]],
        enabled = true
    },
    [34] = {
        name = L["Threat"],
        left = [[
local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation(unit, "target")
if not threatpct then return "" end
isTanking = isTanking and 0 or 1
return Colorize(format("%s: %d%% (%.2f%%)", L["Threat"], threatpct, rawthreatpct), 1, isTanking, isTanking)
]],
        enabled = true,
        update = 300,
        leftUpdating = true
    },
    [35] = {
        name = L["Feats"],
        left = [[
return L["Feats:"]; 
]],
        right = [[
if UnitExists(unit) and not UnitIsPlayer(unit) then return end
if not UnitExists(unit) then return lastFeats end
local feats = UnitFeats(unit)
local txt
if feats and feats > 0 then
    self:Stop()
    txt = feats
else
    txt = L["Loading Achievements..."]
end
lastFeats = txt
return txt
]],
        enabled = true,
        update = 500,
        rightUpdating = true
    },
    [36] = {
        name = L["PVP Rank"],
        left = [[
return L["PVP Rank:"]; 
]],
        right = [[
if UnitExists(unit) and not UnitIsPlayer(unit) then return end
if not UnitExists(unit) then return lastPVPRank end
lastPVPRank = PVPRank(unit)
return lastPVPRank  
]],
        enabled = true,
        update = 300,
        rightUpdating = true,
        cols = 50
    },
    [37] = {
        name = L["Arena 2s"],
        left = [[
if not UnitExists(unit) then return lastArena2 end
lastArena2 =  ArenaTeam(unit, 2)    
return lastArena2
]],
        enabled = true,
        update = 300,
        leftUpdating = true,
        cols = 100
    },
    [38] = {
        name = L["Arena 3s"],
        left = [[
if not UnitExists(unit) then return lastArena3 end
lastArena3 = ArenaTeam(unit, 3) 
return lastArena3
]],
        enabled = true,
        update = 300,
        leftUpdating = true,
        cols = 100
    },
    [39] = {
        name = L["Arena 5s"],
        left = [[
if not UnitExists(unit) then return lastArena5 end
lastArena5 = ArenaTeam(unit, 5)
return lastArena5
]],
        enabled = true,
        update = 300,
        leftUpdating = true,
        cols = 100
    },
    [40] = {
        name = L["Raid Group"],
        enabled = true,
        right = [[
if UnitInRaid(unit) then
 local size = GetNumRaidMembers()
 local uname=Name(unit)
 for i = 1, size do
  local name,_,subgroup = GetRaidRosterInfo(i)
  if uname==name then
   return format("Raid Group: %s", subgroup)
  end
 end
end
]],
    }
}


profile.bars = {
    [1] = {
        name = "Health Bar",
        type = "bar",
        expression = [[
if not UnitExists(unit) then return self.lastHealthBar end
self.lastHealthBar = UnitHealth(unit)
return self.lastHealthBar
]],
        min = "return 0",
        max = [[
if not UnitExists(unit) then return self.lastHealthBarMax end
self.lastHealthBarMax = UnitHealthMax(unit)
return self.lastHealthBarMax
]],
        color1 = [[
if not UnitExists(unit) then return self.lastR, self.lastG, self.lastB end
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
self.lastR, self.lastG, self.lastB = r, g, b
return r, g, b
]],
        height = 6,
        length = 0,
        points = {{"BOTTOM", "StarTipTooltipMain", "TOP", 0, 0}, {"LEFT", "StarTipTooltipMain", "LEFT", 5, 0}, {"RIGHT", "StarTipTooltipMain", "RIGHT", -5, 0}},
        texture1 = LSM:GetDefault("statusbar"),
        enabled = true,
        layer = 1, 
        level = 100,
        parent = "StarTipTooltipMain"
    },
    [2] = {
        name = "Mana Bar",
        type = "bar",
        expression = [[
if not UnitExists(unit) then return self.lastManaBar end
self.lastManaBar = UnitPower(unit)
return self.lastManaBar
]],
        min = "return 0",
        max = [[
if not UnitExists(unit) then return self.lastManaMax end
self.lastManaMax = UnitManaMax('mouseover')
return self.lastManaMax
]],
        color1 = [[
if not UnitExists(unit) then return self.lastR, self.lastG, self.lastB end
self.lastR, self.lastG, self.lastB = PowerColor(nil, unit)
return self.lastR, self.lastG, self.lastB
]],
        height = 6,
        length = 0,
        points = {{"TOP", "StarTipTooltipMain", "BOTTOM", 0, 0}, {"LEFT", "StarTipTooltipMain", "LEFT", 5, 0}, {"RIGHT", "StarTipTooltipMain", "RIGHT", -5, 0}},
        texture1 = LSM:GetDefault("statusbar"),
        enabled = true,
        layer = 1,
        level = 100,
        parent = "StarTipTooltipMain"
    },
    [3] = {
        name = "Threat Bar",
        type = "bar",
        expression = [[
if not UnitExists(unit) then return self.lastthreatpct end
local _,_,threatpct = UnitDetailedThreatSituation(unit, "target")
self.lastthreatpct = threatpct or 0
return self.lastthreatpct
]],
        color1 = [[
if not UnitExists(unit) then return self.lastStatus end
local _, status = UnitDetailedThreatSituation(unit, "target")
self.lastStatus = status 
return status
]],
        length = 6,
        height = 0,
        points = {{"LEFT", "StarTipTooltipMain", "RIGHT", 0, 0}, {"TOP", "StarTipTooltipMain", "TOP", 0, -5}, {"BOTTOM", "StarTipTooltipMain", "BOTTOM", 0, 5}},
        texture = LSM:GetDefault("statusbar"),
        min = "return 0",
        max = "return 100",
        enabled = true,
        layer = 1,
        level = 100,
        parent = "StarTipTooltipMain",
        orientation = WidgetBar.ORIENTATION_VERTICAL
    }

}

profile.background = {

        guild = [[

-- return r, g, b, a -- RGBA colorspace

-- You have a host of color functions you can use.

-- Color2RGBA(color, true) -- returns r, g, b and a, provide it with a 32bit color, i.e. 0xff77ff77 (a|r|g|b)

-- RGBA2Color(r, g, b, a) -- Returns a 32bit color based on RGBA values.

-- HSV2RGB(h, s, v) -- Convert HSV colorspace into RGB.

-- RGB2HSV(r, g, b) -- Convert RGB colorspace into HSV.

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.guild)

]],

        hostilePC = [[

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.hostilePC)

]],

        hostileNPC = [[

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.hostileNPC)

]],

        neutralNPC = [[

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.neutralNPC)

]],

        friendlyPC = [[

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.friendlyPC)

]],

        friendlyNPC = [[

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.friendlyNPC)

]],

        other = [[

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.other)

]],

        dead = [[

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.dead)

]],

        tapped = [[

local mod = StarTip:GetModule("Appearance")

local db = mod.db.profile.bgColor

return unpack(db.tapped)

]]



    }


profile.borders = {
            [1] = {
                name = "Border",
                enabled = true,
                expression = [[
if not UnitExists(unit) then return self.oldr, self.oldg, self.oldb end
if UnitIsPlayer(unit) then
    self.oldr, self.oldg, self.oldb = ClassColor(unit)
    return ClassColor(unit)
else
    self.oldr, self.oldg, self.oldb = UnitSelectionColor(unit)
    return UnitSelectionColor(unit)
end
]],
                update = 300
            }
        }

profile.histogram = {
    [1] = {
        name = "Health",
        expression = "return UnitHealth(unit)",
        min = "return 0",
        max = "return UnitHealthMax(unit)",
        enabled = true,
        width = 10,
        height = 50,
        points = {{"TOPLEFT", "StarTipTooltipMain", "BOTTOMLEFT", 0, -12}},
        color = [[
return HPColor(UnitHealth(unit), UnitHealthMax(unit))
]],
        layer = 1,
        update = 1000,
        parent = "StarTipTooltipMain"
    },
    [2] = {
        name = "Power",
        expression = "return UnitMana(unit)",
        min = "return 0",
        max = "return UnitManaMax(unit)",
        enabled = true,
        width = 10,
        height = 50,
        points = {{"TOPRIGHT", "StarTipTooltipMain", "BOTTOMRIGHT", -100, -12}},
        color = [[
return PowerColor(nil, unit)
]],
        layer = 1,
        update = 1000,
        parent = "StarTipTooltipMain"
    },
    [3] = {
        name = "Mem",
        type = "histogram",
        expression = [[
local mem, percent, memdiff, totalMem, totaldiff, memperc = GetMemUsage("StarTip")
if mem then
    return memperc
end
]],
        color = [[
local mem, percent, memdiff, totalMem, totaldiff, memperc = GetMemUsage("StarTip")
if mem then
    local num = floor(memperc)
    if num < 1 then num = 1 end
    if num > 100 then num = 100 end
    local r, g, b = gradient[num][1], gradient[num][2], gradient[num][3]
    return r, g, b
end

]],
        min = "return 0",
        max = "return 100",
        enabled = false,
        reversed = true,
        char = "0",
        width = 10,
        height = 50,
        points = {{"TOPLEFT", "StarTipTooltipMain", "BOTTOMLEFT", 0, -77}},
        layer = 1,
        update = 1000,
        persistent = true,
        intersect = true,
        intersectPad = 1000,
        parent = "StarTipTooltipMain"
    },
    [4] = {
        name = "CPU",
        type = "histogram",
        expression = [[
if not scriptProfile then return 0 end
local cpu, percent, cpudiff, totalCPU, totaldiff, cpuperc = GetCPUUsage("StarTip")
return cpuperc
]],
        color = [[
if not scriptProfile then return 0, 1, 0 end
local cpu, percent, cpudiff, totalCPU, totaldiff, cpuperc = GetCPUUsage("StarTip")
if cpu then
    local num = floor(cpuperc)
    if num < 1 then num = 1 end
    if num > 100 then num = 100 end
    local r, g, b = gradient[num][1], gradient[num][2], gradient[num][3]
    return r, g, b
end

]],
        min = "return 0",
        max = "return 100",
        enabled = false,
        reversed = true,
        char = "0",
        width = 10,
        height = 50,
        points = {{"TOPRIGHT", "StarTipTooltipMain", "BOTTOMRIGHT", -100, -77}},
        layer = 1,
        update = 1000,
        persistent = true,
        intersect = true,
        intersectPad = 100
    },

}

StarTip:InitializeProfile("Default", profile)
