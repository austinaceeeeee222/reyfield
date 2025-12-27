--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║              🛡️ RAYSHIELD PRO - ULTIMATE AI DODGE SYSTEM 🛡️              ║
    ╠══════════════════════════════════════════════════════════════════════════╣
    ║  Version: 5.0.0 ULTRA                                                    ║
    ║  Author: RayShield Team                                                  ║
    ║                                                                          ║
    ║  Features:                                                               ║
    ║  • Advanced multi-layer ray detection                                    ║
    ║  • Spatial awareness (walkable space detection)                          ║
    ║  • Predictive dodge system                                               ║
    ║  • Wall/obstacle avoidance                                               ║
    ║  • Velocity-based threat prediction                                      ║
    ║  • Smart pathfinding dodge                                               ║
    ║  • Auto-face nearest + death switch                                      ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════════════════════════════
-- WELCOME NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════════════
local function ShowWelcomeNotification()
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "RayShield_Welcome"
    NotifGui.ResetOnSpawn = false
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotifGui.DisplayOrder = 1000
    NotifGui.Parent = PlayerGui

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 380, 0, 110)
    NotifFrame.Position = UDim2.new(0.5, -190, 0, -130)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifGui
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 15)

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(0, 255, 255)
    NotifStroke.Thickness = 2
    NotifStroke.Parent = NotifFrame

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 60, 0, 60)
    IconLabel.Position = UDim2.new(0, 15, 0.5, -30)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = "🛡️"
    IconLabel.TextSize = 45
    IconLabel.Parent = NotifFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 280, 0, 25)
    TitleLabel.Position = UDim2.new(0, 80, 0, 15)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "RAYSHIELD PRO ULTRA"
    TitleLabel.TextSize = 20
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(0, 280, 0, 20)
    SubLabel.Position = UDim2.new(0, 80, 0, 42)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = "✓ Advanced AI Dodge System Loaded!"
    SubLabel.TextSize = 14
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = NotifFrame

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 280, 0, 15)
    VersionLabel.Position = UDim2.new(0, 80, 0, 65)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = "v5.0 ULTRA | Spatial Awareness + Predictive Dodge"
    VersionLabel.TextSize = 11
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = NotifFrame

    local TipLabel = Instance.new("TextLabel")
    TipLabel.Size = UDim2.new(0, 280, 0, 15)
    TipLabel.Position = UDim2.new(0, 80, 0, 82)
    TipLabel.BackgroundTransparency = 1
    TipLabel.Text = "💡 Hold button to toggle | Click for settings"
    TipLabel.TextSize = 10
    TipLabel.Font = Enum.Font.Gotham
    TipLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
    TipLabel.TextXAlignment = Enum.TextXAlignment.Left
    TipLabel.Parent = NotifFrame

    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -190, 0, 20)
    }):Play()

    task.spawn(function()
        local hue = 0
        local startTime = tick()
        while NotifStroke and NotifStroke.Parent and tick() - startTime < 4 do
            hue = (hue + 0.01) % 1
            NotifStroke.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.03)
        end
    end)

    task.delay(3.5, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -190, 0, -130)
        }):Play()
        task.wait(0.5)
        if NotifGui and NotifGui.Parent then NotifGui:Destroy() end
    end)
end

ShowWelcomeNotification()

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DodgeAI_Ultra"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- System State
local Enabled = false
local DebugMode = false
local CurrentFaceTarget = nil
local LastTargetCheck = 0
local currentVelocity = Vector3.new(0, 0, 0)
local FaceGyro = nil
local LastDodgeDir = Vector3.new(0, 0, 0)
local DodgeMomentum = 0

-- Spatial Cache
local SpatialData = {
    WalkableDirections = {},
    BlockedDirections = {},
    AvailableSpace = 0,
    LastUpdate = 0,
    SafeZones = {},
}

-- Settings (ULTRA OPTIMIZED)
local Settings = {
    -- Detection
    DetectionRange = 120,
    DodgeDistance = 10,
    SafetyMargin = 4,
    
    -- Movement
    MaxSpeed = 28,
    Acceleration = 0.25,
    Deceleration = 0.15,
    DodgeSensitivity = 2.0,
    MomentumFactor = 0.3,
    
    -- Spatial Awareness
    SpaceCheckRadius = 15,
    SpaceCheckRays = 16,
    WallAvoidance = true,
    WallAvoidStrength = 1.5,
    MinSafeSpace = 5,
    
    -- Prediction
    PredictiveMode = true,
    PredictionTime = 0.3,
    VelocityTracking = true,
    
    -- Facing
    FaceEnabled = true,
    FaceNearest = true,
    FaceSpeed = 8000,
    LookAtHead = true,
    TargetCheckInterval = 0.3,
    
    -- Advanced
    MultiLayerDetection = true,
    HeadRayWeight = 1.0,
    BodyRayWeight = 0.6,
    ArmRayWeight = 0.4,
    PrioritizeSafeSpace = true,
}

-- Player velocity cache for prediction
local PlayerVelocities = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- UI CREATION
-- ═══════════════════════════════════════════════════════════════════════════

-- Main Button
local MainBtn = Instance.new("TextButton")
MainBtn.Size = UDim2.new(0, 70, 0, 70)
MainBtn.Position = UDim2.new(0, 10, 0.5, 200)
MainBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
MainBtn.Text = "🛡️"
MainBtn.TextSize = 35
MainBtn.Font = Enum.Font.GothamBold
MainBtn.TextColor3 = Color3.new(1, 1, 1)
MainBtn.Parent = ScreenGui
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 35)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 20, 0, 20)
StatusDot.Position = UDim2.new(1, -18, 0, -2)
StatusDot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
StatusDot.Parent = MainBtn
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(0, 10)

-- Status Panel (Expanded)
local StatusPanel = Instance.new("Frame")
StatusPanel.Size = UDim2.new(0, 220, 0, 175)
StatusPanel.Position = UDim2.new(0, 90, 0.5, 175)
StatusPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatusPanel.BackgroundTransparency = 0.1
StatusPanel.Visible = false
StatusPanel.Parent = ScreenGui
Instance.new("UICorner", StatusPanel).CornerRadius = UDim.new(0, 12)

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Color = Color3.fromRGB(0, 255, 255)
StatusStroke.Thickness = 1
StatusStroke.Transparency = 0.5
StatusStroke.Parent = StatusPanel

local function MakeLabel(y, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 0, 20)
    lbl.Position = UDim2.new(0, 8, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = StatusPanel
    return lbl
end

local TitleLbl = MakeLabel(5, "🛡️ AI DODGE ULTRA")
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleLbl.TextSize = 13

local ThreatLbl = MakeLabel(28, "👁 Threats: 0")
local DangerLbl = MakeLabel(46, "⚠️ Danger: 0%")
local SpaceLbl = MakeLabel(64, "📐 Space: 100%")
local FaceLbl = MakeLabel(82, "👤 Facing: None")
local ActionLbl = MakeLabel(100, "🎮 Status: Idle")
local PredictLbl = MakeLabel(118, "🎯 Predict: Off")
local SpeedLbl = MakeLabel(136, "💨 Speed: 0")
local DirsLbl = MakeLabel(154, "🧭 Safe Dirs: 0/16")

-- Settings Panel
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0.92, 0, 0.75, 0)
SettingsPanel.Position = UDim2.new(0.04, 0, 0.12, 0)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
SettingsPanel.Visible = false
SettingsPanel.Parent = ScreenGui
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 18)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
TitleBar.Parent = SettingsPanel
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 18)

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 18)
TitleFix.Position = UDim2.new(0, 0, 1, -18)
TitleFix.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.04, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚙️ AI DODGE ULTRA Settings"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -47, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, -55)
Scroll.Position = UDim2.new(0, 0, 0, 53)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 255)
Scroll.Parent = SettingsPanel

local scrollY = 8

local function AddSection(title)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(0.92, 0, 0, 28)
    sec.Position = UDim2.new(0.04, 0, 0, scrollY)
    sec.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    sec.BackgroundTransparency = 0.6
    sec.Text = "  " .. title
    sec.TextColor3 = Color3.new(1, 1, 1)
    sec.TextSize = 12
    sec.Font = Enum.Font.GothamBold
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = Scroll
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 8)
    scrollY = scrollY + 35
end

local function AddToggle(name, icon, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 40)
    frame.Position = UDim2.new(0.04, 0, 0, scrollY)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    frame.Parent = Scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 30, 1, 0)
    iconLbl.Position = UDim2.new(0, 5, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 16
    iconLbl.Parent = frame
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.55, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 35, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Color3.new(1, 1, 1)
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 26)
    btn.Position = UDim2.new(1, -58, 0.5, -13)
    btn.BackgroundColor3 = default and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(80, 80, 95)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local on = default
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        btn.BackgroundColor3 = on and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(80, 80, 95)
        callback(on)
    end)
    
    scrollY = scrollY + 47
end

local function AddSlider(name, icon, min, max, default, unit, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 55)
    frame.Position = UDim2.new(0.04, 0, 0, scrollY)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    frame.Parent = Scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 25, 0, 20)
    iconLbl.Position = UDim2.new(0, 6, 0, 4)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 14
    iconLbl.Parent = frame
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.5, 0, 0, 20)
    nameLbl.Position = UDim2.new(0, 32, 0, 4)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Color3.new(1, 1, 1)
    nameLbl.TextSize = 11
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = frame
    
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 50, 0, 20)
    valLbl.Position = UDim2.new(1, -55, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = default .. unit
    valLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
    valLbl.TextSize = 11
    valLbl.Font = Enum.Font.GothamBold
    valLbl.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.88, 0, 0, 12)
    sliderBg.Position = UDim2.new(0.06, 0, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 6)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 6)
    
    local sliderHit = Instance.new("TextButton")
    sliderHit.Size = UDim2.new(1, 0, 1, 10)
    sliderHit.Position = UDim2.new(0, 0, 0, -5)
    sliderHit.BackgroundTransparency = 1
    sliderHit.Text = ""
    sliderHit.Parent = sliderBg
    
    local dragging = false
    
    local function update(input)
        local rel = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * rel
        if max - min > 5 then
            val = math.floor(val)
        else
            val = math.floor(val * 10) / 10
        end
        sliderFill.Size = UDim2.new(rel, 0, 1, 0)
        valLbl.Text = val .. unit
        callback(val)
    end
    
    sliderHit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    scrollY = scrollY + 62
end

-- Settings Options
AddSection("⚡ Main Controls")
AddToggle("Enable System", "🛡️", false, function(v)
    Enabled = v
    StatusDot.BackgroundColor3 = v and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(100, 100, 100)
    StatusPanel.Visible = v
    if not v and FaceGyro then FaceGyro:Destroy() FaceGyro = nil end
end)
AddToggle("Debug Mode", "🔍", false, function(v) DebugMode = v end)

AddSection("🧠 Advanced AI")
AddToggle("Predictive Dodge", "🎯", true, function(v) Settings.PredictiveMode = v end)
AddToggle("Wall Avoidance", "🧱", true, function(v) Settings.WallAvoidance = v end)
AddToggle("Multi-Layer Detection", "📡", true, function(v) Settings.MultiLayerDetection = v end)
AddToggle("Prioritize Safe Space", "🛡️", true, function(v) Settings.PrioritizeSafeSpace = v end)

AddSection("📐 Spatial Awareness")
AddSlider("Space Check Radius", "📏", 5, 30, 15, "m", function(v) Settings.SpaceCheckRadius = v end)
AddSlider("Min Safe Space", "🔒", 2, 15, 5, "m", function(v) Settings.MinSafeSpace = v end)
AddSlider("Wall Avoid Strength", "🧱", 0.5, 3, 1.5, "x", function(v) Settings.WallAvoidStrength = v end)

AddSection("👤 Facing Settings")
AddToggle("Face Players", "🎯", true, function(v) Settings.FaceEnabled = v end)
AddToggle("Face Nearest", "📍", true, function(v) Settings.FaceNearest = v end)
AddToggle("Look at Head", "👁️", true, function(v) Settings.LookAtHead = v end)
AddSlider("Turn Speed", "🔄", 2000, 15000, 8000, "", function(v) Settings.FaceSpeed = v end)

AddSection("🏃 Dodge Settings")
AddSlider("Detection Range", "📡", 50, 200, 120, "m", function(v) Settings.DetectionRange = v end)
AddSlider("Dodge Distance", "↔️", 5, 25, 10, "m", function(v) Settings.DodgeDistance = v end)
AddSlider("Safety Margin", "🔒", 2, 15, 4, "m", function(v) Settings.SafetyMargin = v end)
AddSlider("Max Speed", "💨", 20, 50, 28, "", function(v) Settings.MaxSpeed = v end)
AddSlider("Sensitivity", "⚡", 1, 4, 2, "x", function(v) Settings.DodgeSensitivity = v end)
AddSlider("Acceleration", "🚀", 0.1, 0.5, 0.25, "", function(v) Settings.Acceleration = v end)

AddSection("🎯 Prediction")
AddSlider("Predict Time", "⏱️", 0.1, 1, 0.3, "s", function(v) Settings.PredictionTime = v end)
AddSlider("Head Ray Weight", "👤", 0.5, 2, 1, "x", function(v) Settings.HeadRayWeight = v end)
AddSlider("Body Ray Weight", "🫁", 0.2, 1.5, 0.6, "x", function(v) Settings.BodyRayWeight = v end)

Scroll.CanvasSize = UDim2.new(0, 0, 0, scrollY + 10)

-- ═══════════════════════════════════════════════════════════════════════════
-- DEBUG VISUALIZATION
-- ═══════════════════════════════════════════════════════════════════════════
local DebugParts = {}

local function ClearDebug()
    for _, p in pairs(DebugParts) do
        if p and p.Parent then p:Destroy() end
    end
    DebugParts = {}
end

local function DebugRay(from, dir, len, color, transparency)
    if not DebugMode then return end
    local to = from + dir * len
    local p = Instance.new("Part")
    p.Anchored, p.CanCollide = true, false
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Size = Vector3.new(0.1, 0.1, len)
    p.CFrame = CFrame.new((from + to) / 2, to)
    p.Transparency = transparency or 0.4
    p.Parent = Workspace
    table.insert(DebugParts, p)
    task.delay(0.1, function() if p.Parent then p:Destroy() end end)
end

local function DebugBall(pos, size, color, transparency)
    if not DebugMode then return end
    local p = Instance.new("Part")
    p.Shape = Enum.PartType.Ball
    p.Anchored, p.CanCollide = true, false
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Size = Vector3.new(size, size, size)
    p.Position = pos
    p.Transparency = transparency or 0.5
    p.Parent = Workspace
    table.insert(DebugParts, p)
    task.delay(0.1, function() if p.Parent then p:Destroy() end end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SPATIAL AWARENESS SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════
local RaycastParams = RaycastParams.new()
RaycastParams.FilterType = Enum.RaycastFilterType.Exclude

local function UpdateSpatialData(myPos, myChar)
    local now = tick()
    if now - SpatialData.LastUpdate < 0.05 then return end
    SpatialData.LastUpdate = now
    
    RaycastParams.FilterDescendantsInstances = {myChar}
    
    SpatialData.WalkableDirections = {}
    SpatialData.BlockedDirections = {}
    local walkableCount = 0
    local totalSpace = 0
    
    -- Cast rays in all directions
    local numRays = Settings.SpaceCheckRays
    for i = 0, numRays - 1 do
        local angle = (i / numRays) * math.pi * 2
        local dir = Vector3.new(math.cos(angle), 0, math.sin(angle))
        
        local origin = myPos + Vector3.new(0, 1, 0)
        local result = Workspace:Raycast(origin, dir * Settings.SpaceCheckRadius, RaycastParams)
        
        local distance = Settings.SpaceCheckRadius
        if result then
            distance = result.Distance
        end
        
        local dirData = {
            direction = dir,
            distance = distance,
            blocked = distance < Settings.MinSafeSpace,
            angle = angle,
        }
        
        if distance >= Settings.MinSafeSpace then
            table.insert(SpatialData.WalkableDirections, dirData)
            walkableCount = walkableCount + 1
            totalSpace = totalSpace + distance
        else
            table.insert(SpatialData.BlockedDirections, dirData)
        end
        
        -- Debug visualization
        if DebugMode then
            local color = distance >= Settings.MinSafeSpace and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            DebugRay(origin, dir, distance, color, 0.7)
        end
    end
    
    -- Calculate available space percentage
    SpatialData.AvailableSpace = (totalSpace / (numRays * Settings.SpaceCheckRadius)) * 100
    SpatialData.WalkableCount = walkableCount
end

-- Find best dodge direction considering space
local function GetBestDodgeDirection(baseDodgeDir, myPos, myChar)
    if not Settings.PrioritizeSafeSpace then
        return baseDodgeDir
    end
    
    UpdateSpatialData(myPos, myChar)
    
    if #SpatialData.WalkableDirections == 0 then
        return baseDodgeDir -- No safe directions, use base
    end
    
    -- Find walkable direction closest to desired dodge direction
    local bestDir = nil
    local bestScore = -math.huge
    
    for _, dirData in pairs(SpatialData.WalkableDirections) do
        -- Score based on: alignment with dodge direction + available space
        local alignment = baseDodgeDir:Dot(dirData.direction)
        local spaceBonus = dirData.distance / Settings.SpaceCheckRadius
        local score = alignment * 0.7 + spaceBonus * 0.3
        
        if score > bestScore then
            bestScore = score
            bestDir = dirData.direction
        end
    end
    
    if bestDir then
        -- Blend between base dodge and safe direction
        local blendFactor = 0.6
        return (baseDodgeDir * (1 - blendFactor) + bestDir * blendFactor).Unit
    end
    
    return baseDodgeDir
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PLAYER VELOCITY TRACKING (for prediction)
-- ═══════════════════════════════════════════════════════════════════════════
local function UpdatePlayerVelocities()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local prevData = PlayerVelocities[player.UserId]
                local currentPos = hrp.Position
                local currentTime = tick()
                
                if prevData then
                    local dt = currentTime - prevData.time
                    if dt > 0.01 then
                        local velocity = (currentPos - prevData.position) / dt
                        PlayerVelocities[player.UserId] = {
                            position = currentPos,
                            velocity = velocity,
                            time = currentTime,
                        }
                    end
                else
                    PlayerVelocities[player.UserId] = {
                        position = currentPos,
                        velocity = Vector3.zero,
                        time = currentTime,
                    }
                end
            end
        end
    end
end

local function GetPlayerVelocity(player)
    local data = PlayerVelocities[player.UserId]
    if data then
        return data.velocity
    end
    return Vector3.zero
end

-- ═══════════════════════════════════════════════════════════════════════════
-- THREAT DETECTION (ULTRA OPTIMIZED)
-- ═══════════════════════════════════════════════════════════════════════════
local function PointToRayDistance(point, origin, dir)
    local toPoint = point - origin
    local proj = toPoint:Dot(dir)
    if proj < 0 then return 999, nil, proj end
    local closest = origin + dir * proj
    return (point - closest).Magnitude, closest, proj
end

local function CalculateThreat(myPos, playerChar, playerVelocity)
    local threats = {}
    local totalDanger = 0
    
    local head = playerChar:FindFirstChild("Head")
    local hrp = playerChar:FindFirstChild("HumanoidRootPart")
    local leftArm = playerChar:FindFirstChild("Left Arm") or playerChar:FindFirstChild("LeftHand")
    local rightArm = playerChar:FindFirstChild("Right Arm") or playerChar:FindFirstChild("RightHand")
    
    if not head or not hrp then return threats, 0 end
    
    local dist = (hrp.Position - myPos).Magnitude
    if dist > Settings.DetectionRange then return threats, 0 end
    
    -- Predict future position if enabled
    local predictedPos = myPos
    if Settings.PredictiveMode then
        local myChar = LocalPlayer.Character
        if myChar then
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                -- Don't predict our own position, predict enemy's aim
            end
        end
    end
    
    -- Head ray (highest priority)
    local headDir = head.CFrame.LookVector
    if Settings.PredictiveMode and playerVelocity.Magnitude > 1 then
        -- Adjust look direction based on movement
        local moveInfluence = playerVelocity.Unit * 0.2
        headDir = (headDir + Vector3.new(moveInfluence.X, 0, moveInfluence.Z)).Unit
    end
    
    local headDist, headClosest, headProj = PointToRayDistance(myPos, head.Position, headDir)
    
    if headDist < Settings.DodgeDistance and headClosest then
        local danger = (1 - headDist / Settings.DodgeDistance) * Settings.HeadRayWeight
        
        -- Distance falloff
        local distFactor = 1 - (dist / Settings.DetectionRange) * 0.5
        danger = danger * distFactor
        
        totalDanger = totalDanger + danger
        
        table.insert(threats, {
            type = "head",
            closest = headClosest,
            distance = headDist,
            danger = danger,
            direction = headDir,
            origin = head.Position,
        })
        
        DebugRay(head.Position, headDir, 50, Color3.fromRGB(255, 50, 50), 0.3)
        DebugBall(headClosest, 0.6, Color3.fromRGB(255, 255, 0), 0.4)
    end
    
    -- Body ray
    local bodyDir = hrp.CFrame.LookVector
    local bodyDist, bodyClosest, bodyProj = PointToRayDistance(myPos, hrp.Position, bodyDir)
    
    if bodyDist < Settings.DodgeDistance * 0.9 and bodyClosest then
        local danger = (1 - bodyDist / (Settings.DodgeDistance * 0.9)) * Settings.BodyRayWeight
        totalDanger = totalDanger + danger
        
        table.insert(threats, {
            type = "body",
            closest = bodyClosest,
            distance = bodyDist,
            danger = danger,
            direction = bodyDir,
            origin = hrp.Position,
        })
        
        DebugRay(hrp.Position, bodyDir, 40, Color3.fromRGB(255, 150, 50), 0.4)
    end
    
    -- Arm rays (if multi-layer enabled)
    if Settings.MultiLayerDetection then
        local arms = {leftArm, rightArm}
        for _, arm in pairs(arms) do
            if arm then
                local armDir = arm.CFrame.LookVector
                local armDist, armClosest = PointToRayDistance(myPos, arm.Position, armDir)
                
                if armDist < Settings.DodgeDistance * 0.7 and armClosest then
                    local danger = (1 - armDist / (Settings.DodgeDistance * 0.7)) * Settings.ArmRayWeight
                    totalDanger = totalDanger + danger
                    
                    table.insert(threats, {
                        type = "arm",
                        closest = armClosest,
                        distance = armDist,
                        danger = danger,
                        direction = armDir,
                        origin = arm.Position,
                    })
                    
                    DebugRay(arm.Position, armDir, 30, Color3.fromRGB(255, 200, 50), 0.5)
                end
            end
        end
    end
    
    return threats, totalDanger
end

-- ═══════════════════════════════════════════════════════════════════════════
-- DODGE CALCULATION (ULTRA OPTIMIZED)
-- ═══════════════════════════════════════════════════════════════════════════
local function CalculateDodgeVector(myPos, allThreats)
    local dodgeDir = Vector3.zero
    local totalWeight = 0
    
    for _, threat in pairs(allThreats) do
        -- Calculate escape vector
        local away = myPos - threat.closest
        away = Vector3.new(away.X, 0, away.Z)
        
        if away.Magnitude > 0.1 then
            local weight = threat.danger * Settings.DodgeSensitivity
            dodgeDir = dodgeDir + away.Unit * weight
            totalWeight = totalWeight + weight
        else
            -- Too close to ray, dodge perpendicular
            local perp = threat.direction:Cross(Vector3.new(0, 1, 0))
            if perp.Magnitude > 0.1 then
                local dir = perp.Unit
                -- Choose side based on momentum
                if LastDodgeDir:Dot(dir) < 0 then
                    dir = -dir
                end
                local weight = threat.danger * Settings.DodgeSensitivity
                dodgeDir = dodgeDir + dir * weight
                totalWeight = totalWeight + weight
            end
        end
    end
    
    if dodgeDir.Magnitude < 0.1 then
        return Vector3.zero, 0
    end
    
    return dodgeDir.Unit, totalWeight
end

-- ═══════════════════════════════════════════════════════════════════════════
-- FACING SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════
local function GetOtherPlayers()
    local others = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChild("Humanoid")
            if head and hrp and hum and hum.Health > 0 then
                table.insert(others, {
                    Player = player,
                    Head = head,
                    HRP = hrp,
                    Humanoid = hum,
                })
            end
        end
    end
    return others
end

local function GetNearestPlayer(others, myPos)
    if #others == 0 then return nil end
    
    local nearest = nil
    local nearestDist = math.huge
    
    for _, data in pairs(others) do
        local dist = (data.HRP.Position - myPos).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearest = data
        end
    end
    
    return nearest
end

local function IsTargetValid(targetPlayer)
    if not targetPlayer then return false end
    if not targetPlayer.Character then return false end
    local hum = targetPlayer.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    return true
end

local function SelectFaceTarget(others, myPos)
    if #others == 0 then
        CurrentFaceTarget = nil
        return nil
    end
    
    local now = tick()
    local needNewTarget = not IsTargetValid(CurrentFaceTarget)
    
    if now - LastTargetCheck > Settings.TargetCheckInterval then
        LastTargetCheck = now
        if Settings.FaceNearest then
            needNewTarget = true
        end
    end
    
    if needNewTarget then
        if Settings.FaceNearest then
            local nearest = GetNearestPlayer(others, myPos)
            if nearest then
                CurrentFaceTarget = nearest.Player
            end
        else
            CurrentFaceTarget = others[math.random(#others)].Player
        end
    end
    
    for _, o in pairs(others) do
        if o.Player == CurrentFaceTarget then
            return o
        end
    end
    
    if Settings.FaceNearest then
        local nearest = GetNearestPlayer(others, myPos)
        if nearest then
            CurrentFaceTarget = nearest.Player
            return nearest
        end
    end
    
    return others[1]
end

local function GetOrCreateGyro(hrp)
    if FaceGyro and FaceGyro.Parent == hrp then
        return FaceGyro
    end
    if FaceGyro then FaceGyro:Destroy() end
    
    FaceGyro = Instance.new("BodyGyro")
    FaceGyro.Name = "FaceGyro"
    FaceGyro.MaxTorque = Vector3.new(0, Settings.FaceSpeed, 0)
    FaceGyro.P = 15000
    FaceGyro.D = 800
    FaceGyro.Parent = hrp
    
    return FaceGyro
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN LOOP
-- ═══════════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function(dt)
    if not Enabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    
    local myPos = hrp.Position
    local others = GetOtherPlayers()
    
    -- Update velocity tracking
    UpdatePlayerVelocities()
    
    -- Update spatial data
    UpdateSpatialData(myPos, char)
    
    -- Collect all threats
    local allThreats = {}
    local totalDanger = 0
    local threatCount = 0
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local playerVelocity = GetPlayerVelocity(player)
            local threats, danger = CalculateThreat(myPos, player.Character, playerVelocity)
            
            if danger > 0 then
                threatCount = threatCount + 1
                totalDanger = totalDanger + danger
                
                for _, threat in pairs(threats) do
                    table.insert(allThreats, threat)
                end
            end
        end
    end
    
    -- Calculate dodge direction
    local dodgeDir, dodgeWeight = CalculateDodgeVector(myPos, allThreats)
    
    -- Apply spatial awareness
    if dodgeDir.Magnitude > 0.1 then
        dodgeDir = GetBestDodgeDirection(dodgeDir, myPos, char)
    end
    
    -- Wall avoidance
    if Settings.WallAvoidance then
        for _, blocked in pairs(SpatialData.BlockedDirections) do
            local repulsion = -blocked.direction * (1 - blocked.distance / Settings.MinSafeSpace) * Settings.WallAvoidStrength
            dodgeDir = dodgeDir + Vector3.new(repulsion.X, 0, repulsion.Z)
        end
        if dodgeDir.Magnitude > 0.1 then
            dodgeDir = dodgeDir.Unit
        end
    end
    
    -- Update UI
    ThreatLbl.Text = "👁 Threats: " .. threatCount
    DangerLbl.Text = string.format("⚠️ Danger: %.0f%%", math.min(totalDanger, 1) * 100)
    SpaceLbl.Text = string.format("📐 Space: %.0f%%", SpatialData.AvailableSpace)
    DirsLbl.Text = string.format("🧭 Safe Dirs: %d/%d", SpatialData.WalkableCount or 0, Settings.SpaceCheckRays)
    PredictLbl.Text = "🎯 Predict: " .. (Settings.PredictiveMode and "ON" or "OFF")
    
    -- Danger colors
    if totalDanger > 0.7 then
        DangerLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    elseif totalDanger > 0.3 then
        DangerLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
    else
        DangerLbl.TextColor3 = Color3.fromRGB(80, 255, 80)
        StatusDot.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    end
    
    -- Space colors
    if SpatialData.AvailableSpace < 30 then
        SpaceLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
    elseif SpatialData.AvailableSpace < 60 then
        SpaceLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
    else
        SpaceLbl.TextColor3 = Color3.fromRGB(80, 255, 80)
    end
    
    -- Select face target
    local faceTarget = nil
    if Settings.FaceEnabled then
        faceTarget = SelectFaceTarget(others, myPos)
    end
    
    if CurrentFaceTarget then
        FaceLbl.Text = "👤 Facing: " .. CurrentFaceTarget.DisplayName
    else
        FaceLbl.Text = "👤 Facing: None"
    end
    
    -- Execute dodge movement
    if dodgeDir.Magnitude > 0.1 and totalDanger > 0.05 then
        -- Apply momentum
        if LastDodgeDir.Magnitude > 0.1 then
            dodgeDir = (dodgeDir + LastDodgeDir * Settings.MomentumFactor).Unit
        end
        LastDodgeDir = dodgeDir
        
        -- Calculate speed
        local speedFactor = math.min(1, totalDanger * Settings.DodgeSensitivity)
        local targetSpeed = Settings.MaxSpeed * speedFactor * 0.4
        
        -- Smooth acceleration
        DodgeMomentum = DodgeMomentum + (targetSpeed - DodgeMomentum) * Settings.Acceleration
        
        local targetVel = dodgeDir * DodgeMomentum
        currentVelocity = currentVelocity:Lerp(targetVel, Settings.Acceleration)
        
        local targetPos = myPos + currentVelocity
        hum:MoveTo(targetPos)
        
        -- Update UI
        local currentSpeed = currentVelocity.Magnitude
        SpeedLbl.Text = string.format("💨 Speed: %.1f", currentSpeed)
        
        if totalDanger > 0.7 then
            ActionLbl.Text = "🎮 EMERGENCY EVADE!"
            ActionLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        elseif totalDanger > 0.4 then
            ActionLbl.Text = "🎮 Evading..."
            ActionLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
        else
            ActionLbl.Text = "🎮 Dodging..."
            ActionLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        DebugRay(myPos, dodgeDir, 5, Color3.fromRGB(0, 255, 100), 0.2)
        DebugBall(targetPos, 0.5, Color3.fromRGB(0, 255, 100), 0.3)
    else
        -- Decelerate
        DodgeMomentum = DodgeMomentum * (1 - Settings.Deceleration)
        currentVelocity = currentVelocity:Lerp(Vector3.zero, Settings.Deceleration)
        LastDodgeDir = LastDodgeDir * 0.9
        
        SpeedLbl.Text = "💨 Speed: 0"
        ActionLbl.Text = "🎮 Monitoring..."
        ActionLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
    
    -- Face target
    if Settings.FaceEnabled and faceTarget then
        local lookAtPos = Settings.LookAtHead and faceTarget.Head.Position or faceTarget.HRP.Position
        local toTarget = lookAtPos - myPos
        toTarget = Vector3.new(toTarget.X, 0, toTarget.Z)
        
        if toTarget.Magnitude > 0.5 then
            local gyro = GetOrCreateGyro(hrp)
            gyro.MaxTorque = Vector3.new(0, Settings.FaceSpeed, 0)
            gyro.CFrame = CFrame.new(myPos, myPos + toTarget)
        end
    else
        if FaceGyro then FaceGyro:Destroy() FaceGyro = nil end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- UI EVENTS
-- ═══════════════════════════════════════════════════════════════════════════
MainBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = not SettingsPanel.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = false
end)

-- Long press toggle
local holding = false
MainBtn.MouseButton1Down:Connect(function()
    holding = true
    local start = tick()
    
    task.spawn(function()
        while holding do
            if tick() - start > 0.5 then
                Enabled = not Enabled
                StatusDot.BackgroundColor3 = Enabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(100, 100, 100)
                StatusPanel.Visible = Enabled
                
                if not Enabled and FaceGyro then FaceGyro:Destroy() FaceGyro = nil end
                
                MainBtn.Size = UDim2.new(0, 80, 0, 80)
                task.wait(0.1)
                MainBtn.Size = UDim2.new(0, 70, 0, 70)
                
                holding = false
                break
            end
            task.wait(0.05)
        end
    end)
end)

MainBtn.MouseButton1Up:Connect(function()
    holding = false
end)

LocalPlayer.CharacterAdded:Connect(function()
    currentVelocity = Vector3.zero
    CurrentFaceTarget = nil
    FaceGyro = nil
    LastDodgeDir = Vector3.zero
    DodgeMomentum = 0
    PlayerVelocities = {}
    ClearDebug()
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- STARTUP
-- ═══════════════════════════════════════════════════════════════════════════
print("═══════════════════════════════════════════════════════")
print("✅ RAYSHIELD PRO ULTRA v5.0 Loaded!")
print("🧠 Advanced AI with Spatial Awareness")
print("📐 Walkable Space Detection Active")
print("🎯 Predictive Dodge System Ready")
print("🧱 Wall Avoidance Enabled")
print("💡 Hold button to toggle | Click for settings")
print("═══════════════════════════════════════════════════════")
