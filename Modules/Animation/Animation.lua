--local addon, ns = ...
local mod = StarTip:NewModule("Animation")
local Evaluator = LibStub("LibScriptableUtilsEvaluator-1.0")
local Timer = LibStub("LibScriptableUtilsTimer-1.0")
local LibCore = LibStub("LibScriptableLCDCoreLite-1.0")

mod.environment = {}
mod.core = LibCore:New(mod.environment, "Animation")

mod.animation = {
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

function mod:RunFrame()
    Evaluator.ExecuteCode(mod.environment, "StarTip.Position.animationBegin", self.animation.animationBegin)
end

function mod:OnStartup()
end

function mod:RunInit()
    Evaluator.ExecuteCode(self.environment, "StarTip.Position.animationIni", self.animation.animationInit)
end

local random, floor = math.random, math.floor
function mod:RunPoint(x, y)
    local x, y = x or 0, y or 0
    if self.animation.animationsOn then
        mod.environment.i = (mod.environment.i or 0) + 1
        mod.environment.v = (mod.environment.v or 0) +  random()
        mod.environment.x = x
        mod.environment.y = y
        mod.environment.width = StarTip.tooltipMain:GetWidth()
        mod.environment.height = StarTip.tooltipMain:GetHeight()
        mod.environment.unit = StarTip.unit
        mod.environment.self = mod.environment.self or {}
        Evaluator.ExecuteCode(mod.environment, "Position.animationPoint", self.animation.animationPoint)

        local xx, yy = mod.environment.x or 0, mod.environment.y or 0
        if mod.environment.gravity then
                local speed = (6001 - self.animation.animationSpeed) / 5
                x = x + floor((((xx or 0) + 1.0) * UIParent:GetWidth() / speed))
                y = y + floor((((yy or 0) + 1.0) * UIParent:GetHeight() / speed))
        else
            x = xx
            y = yy
        end
    end
    return x, y
end

function mod:SetUnit()
    self:RunFrame()
end

function mod:Establish(anim)
    self.animation.animationsOn = anim and anim.animationsOn or self.animation.animationsOn
    self.animation.animationSpeed = anim and anim.animationSpeed or self.animation.animationSpeed
    self.animation.animationInit = anim and anim.animationInit or self.animation.animationInit
    self.animation.animationBegin = anim and anim.animationBegin or self.animation.animationBegin
    self.animation.animationPoint = anim and anim.animationPoint or self.animation.animationPoint
    self:RunInit()
end
