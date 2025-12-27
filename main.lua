--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                    🛡️ RAYSHIELD PRO - AI躲避系统 🛡️                       ║
    ╠══════════════════════════════════════════════════════════════════════════╣
    ║  版本 / Version: 3.0.0                                                   ║
    ║  作者 / Author: RayShield Team                                           ║
    ║                                                                          ║
    ║  功能 / Features:                                                         ║
    ║  • 智能射线检测躲避系统                                                   ║
    ║  • 自动面向最近玩家                                                       ║
    ║  • 可调节参数设置面板                                                     ║
    ║  • 调试可视化模式                                                         ║
    ║                                                                          ║
    ║  使用方法:                                                                ║
    ║  通过 loader.lua 加载，需要先完成 Key 验证                               ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════════════
-- 欢迎消息 / WELCOME MESSAGE
-- ═══════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 创建欢迎通知
local function ShowWelcomeNotification()
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "RayShield_Welcome"
    NotifGui.ResetOnSpawn = false
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotifGui.DisplayOrder = 1000
    NotifGui.Parent = PlayerGui

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotifFrame"
    NotifFrame.Size = UDim2.new(0, 350, 0, 100)
    NotifFrame.Position = UDim2.new(0.5, -175, 0, -120)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifGui

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 15)
    NotifCorner.Parent = NotifFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(0, 255, 255)
    NotifStroke.Thickness = 2
    NotifStroke.Parent = NotifFrame

    local NotifGradient = Instance.new("UIGradient")
    NotifGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
    })
    NotifGradient.Rotation = 45
    NotifGradient.Parent = NotifFrame

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 60, 0, 60)
    IconLabel.Position = UDim2.new(0, 15, 0.5, -30)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = "🛡️"
    IconLabel.TextSize = 45
    IconLabel.Parent = NotifFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 250, 0, 25)
    TitleLabel.Position = UDim2.new(0, 80, 0, 18)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "RAYSHIELD PRO"
    TitleLabel.TextSize = 20
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Name = "Sub"
    SubLabel.Size = UDim2.new(0, 250, 0, 20)
    SubLabel.Position = UDim2.new(0, 80, 0, 45)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = "✓ Script loaded successfully!"
    SubLabel.TextSize = 14
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = NotifFrame

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Name = "Version"
    VersionLabel.Size = UDim2.new(0, 250, 0, 15)
    VersionLabel.Position = UDim2.new(0, 80, 0, 68)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = "v3.0.0 | Hold button to toggle"
    VersionLabel.TextSize = 11
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = NotifFrame

    -- 动画进入
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -175, 0, 20)
    }):Play()

    -- 彩虹边框动画
    task.spawn(function()
        local hue = 0
        local startTime = tick()
        while NotifStroke and NotifStroke.Parent and tick() - startTime < 4 do
            hue = (hue + 0.01) % 1
            NotifStroke.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.03)
        end
    end)

    -- 3秒后淡出
    task.delay(3, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -175, 0, -120)
        }):Play()
        
        task.wait(0.5)
        if NotifGui and NotifGui.Parent then
            NotifGui:Destroy()
        end
    end)
end

-- 显示欢迎通知
ShowWelcomeNotification()

-- ═══════════════════════════════════════════════════════════════════════════
-- 以下是你的原始代码 (完整保留，未简化)
-- ═══════════════════════════════════════════════════════════════════════════

-- LocalScript 放在 StarterPlayerScripts 或 StarterGui 中

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DodgeAI_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 系统状态
local Enabled = false
local DebugMode = false
local CurrentFaceTarget = nil
local LastTargetSwitch = 0
local currentVelocity = Vector3.new(0, 0, 0)
local FaceGyro = nil

-- 设置
local Settings = {
    DetectionRange = 100,
    DodgeDistance = 8,
    SafetyMargin = 3,
    MaxSpeed = 24,
    DodgeSensitivity = 1.5,
    MoveSmooth = 0.15,
    FaceEnabled = true,
    FaceSpeed = 5000,
    TargetSwitchTime = 2.5,
    LookAtHead = true,
}

-- 主按钮
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

-- 状态面板
local StatusPanel = Instance.new("Frame")
StatusPanel.Size = UDim2.new(0, 200, 0, 130)
StatusPanel.Position = UDim2.new(0, 90, 0.5, 200)
StatusPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatusPanel.BackgroundTransparency = 0.15
StatusPanel.Visible = false
StatusPanel.Parent = ScreenGui
Instance.new("UICorner", StatusPanel).CornerRadius = UDim.new(0, 12)

local function MakeLabel(y, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 0, 22)
    lbl.Position = UDim2.new(0, 8, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = StatusPanel
    return lbl
end

local TitleLbl = MakeLabel(5, "🛡️ AI躲避系统")
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextColor3 = Color3.fromRGB(100, 200, 255)

local ThreatLbl = MakeLabel(28, "👁 威胁: 0")
local DangerLbl = MakeLabel(50, "⚠️ 危险: 0%")
local FaceLbl = MakeLabel(72, "👤 面向: 无")
local ActionLbl = MakeLabel(94, "🎮 动作: 待机")

-- 设置面板
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0.9, 0, 0.7, 0)
SettingsPanel.Position = UDim2.new(0.05, 0, 0.15, 0)
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
TitleText.Text = "⚙️ AI躲避设置"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.TextSize = 17
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
    sec.TextSize = 13
    sec.Font = Enum.Font.GothamBold
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = Scroll
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 8)
    scrollY = scrollY + 35
end

local function AddToggle(name, icon, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 45)
    frame.Position = UDim2.new(0.04, 0, 0, scrollY)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    frame.Parent = Scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 35, 1, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 18
    iconLbl.Parent = frame
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.55, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 38, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Color3.new(1, 1, 1)
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 0, 28)
    btn.Position = UDim2.new(1, -63, 0.5, -14)
    btn.BackgroundColor3 = default and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(80, 80, 95)
    btn.Text = default and "开" or "关"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local on = default
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "开" or "关"
        btn.BackgroundColor3 = on and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(80, 80, 95)
        callback(on)
    end)
    
    scrollY = scrollY + 52
end

local function AddSlider(name, icon, min, max, default, unit, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 60)
    frame.Position = UDim2.new(0.04, 0, 0, scrollY)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    frame.Parent = Scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 30, 0, 24)
    iconLbl.Position = UDim2.new(0, 6, 0, 4)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 16
    iconLbl.Parent = frame
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.5, 0, 0, 24)
    nameLbl.Position = UDim2.new(0, 36, 0, 4)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = Color3.new(1, 1, 1)
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = frame
    
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 50, 0, 24)
    valLbl.Position = UDim2.new(1, -55, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = default .. unit
    valLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
    valLbl.TextSize = 12
    valLbl.Font = Enum.Font.GothamBold
    valLbl.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.88, 0, 0, 14)
    sliderBg.Position = UDim2.new(0.06, 0, 0, 36)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 7)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 7)
    
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
    
    scrollY = scrollY + 67
end

-- 设置选项
AddSection("⚡ 主控制")
AddToggle("启用系统", "🛡️", false, function(v)
    Enabled = v
    StatusDot.BackgroundColor3 = v and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(100, 100, 100)
    StatusPanel.Visible = v
    
    -- 清理BodyGyro
    if not v and FaceGyro then
        FaceGyro:Destroy()
        FaceGyro = nil
    end
end)
AddToggle("调试模式", "🔍", false, function(v) DebugMode = v end)

AddSection("👤 面向设置")
AddToggle("面向随机玩家", "🎯", true, function(v) Settings.FaceEnabled = v end)
AddToggle("看向头部", "👁️", true, function(v) Settings.LookAtHead = v end)
AddSlider("切换间隔", "⏰", 1, 8, 2.5, "s", function(v) Settings.TargetSwitchTime = v end)
AddSlider("转向速度", "🔄", 1000, 20000, 5000, "", function(v) Settings.FaceSpeed = v end)

AddSection("🏃 躲避设置")
AddSlider("检测范围", "📡", 30, 200, 100, "m", function(v) Settings.DetectionRange = v end)
AddSlider("躲避距离", "↔️", 3, 20, 8, "m", function(v) Settings.DodgeDistance = v end)
AddSlider("安全边距", "🔒", 1, 10, 3, "m", function(v) Settings.SafetyMargin = v end)
AddSlider("最大速度", "💨", 16, 40, 24, "", function(v) Settings.MaxSpeed = v end)
AddSlider("灵敏度", "⚡", 0.5, 3, 1.5, "x", function(v) Settings.DodgeSensitivity = v end)

Scroll.CanvasSize = UDim2.new(0, 0, 0, scrollY + 10)

-- 调试
local DebugParts = {}

local function ClearDebug()
    for _, p in pairs(DebugParts) do
        if p and p.Parent then p:Destroy() end
    end
    DebugParts = {}
end

local function DebugRay(from, dir, len, color)
    if not DebugMode then return end
    local to = from + dir * len
    local p = Instance.new("Part")
    p.Anchored, p.CanCollide = true, false
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Size = Vector3.new(0.12, 0.12, len)
    p.CFrame = CFrame.new((from + to) / 2, to)
    p.Transparency = 0.35
    p.Parent = Workspace
    table.insert(DebugParts, p)
    task.delay(0.12, function() if p.Parent then p:Destroy() end end)
end

local function DebugBall(pos, size, color)
    if not DebugMode then return end
    local p = Instance.new("Part")
    p.Shape = Enum.PartType.Ball
    p.Anchored, p.CanCollide = true, false
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Size = Vector3.new(size, size, size)
    p.Position = pos
    p.Transparency = 0.5
    p.Parent = Workspace
    table.insert(DebugParts, p)
    task.delay(0.12, function() if p.Parent then p:Destroy() end end)
end

-- 点到射线距离
local function PointToRay(point, origin, dir)
    local toPoint = point - origin
    local proj = toPoint:Dot(dir)
    if proj < 0 then return 999, nil end
    local closest = origin + dir * proj
    return (point - closest).Magnitude, closest
end

-- 获取其他玩家
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
                })
            end
        end
    end
    return others
end

-- 选择面向目标
local function SelectFaceTarget(others)
    if #others == 0 then
        CurrentFaceTarget = nil
        return nil
    end
    
    local needSwitch = CurrentFaceTarget == nil or tick() - LastTargetSwitch > Settings.TargetSwitchTime
    
    if not needSwitch then
        local valid = false
        for _, o in pairs(others) do
            if o.Player == CurrentFaceTarget then
                valid = true
                break
            end
        end
        if not valid then needSwitch = true end
    end
    
    if needSwitch then
        CurrentFaceTarget = others[math.random(#others)].Player
        LastTargetSwitch = tick()
    end
    
    for _, o in pairs(others) do
        if o.Player == CurrentFaceTarget then
            return o
        end
    end
    
    return others[1]
end

-- 获取或创建 BodyGyro (用于转向，不干扰移动！)
local function GetOrCreateGyro(hrp)
    if FaceGyro and FaceGyro.Parent == hrp then
        return FaceGyro
    end
    
    if FaceGyro then
        FaceGyro:Destroy()
    end
    
    FaceGyro = Instance.new("BodyGyro")
    FaceGyro.Name = "FaceGyro"
    FaceGyro.MaxTorque = Vector3.new(0, Settings.FaceSpeed, 0) -- 只控制Y轴
    FaceGyro.P = 10000
    FaceGyro.D = 500
    FaceGyro.Parent = hrp
    
    return FaceGyro
end

-- 主循环
RunService.Heartbeat:Connect(function(dt)
    if not Enabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    
    local myPos = hrp.Position
    local others = GetOtherPlayers()
    
    -- 收集威胁
    local dodgeDir = Vector3.new(0, 0, 0)
    local totalDanger = 0
    local threatCount = 0
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local phrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if head and phrp then
                local dist = (head.Position - myPos).Magnitude
                
                if dist <= Settings.DetectionRange then
                    -- 头部射线
                    local headDir = head.CFrame.LookVector
                    local headDist, headClosest = PointToRay(myPos, head.Position, headDir)
                    
                    DebugRay(head.Position, headDir, 60, Color3.fromRGB(255, 50, 50))
                    
                    if headDist < Settings.DodgeDistance and headClosest then
                        local danger = (1 - headDist / Settings.DodgeDistance)
                        totalDanger = totalDanger + danger
                        threatCount = threatCount + 1
                        
                        local away = myPos - headClosest
                        away = Vector3.new(away.X, 0, away.Z)
                        
                        if away.Magnitude > 0.1 then
                            dodgeDir = dodgeDir + away.Unit * danger * Settings.DodgeSensitivity
                        else
                            local perp = headDir:Cross(Vector3.new(0, 1, 0))
                            if perp.Magnitude > 0.1 then
                                local dir = perp.Unit
                                if math.random() > 0.5 then dir = -dir end
                                dodgeDir = dodgeDir + dir * danger * Settings.DodgeSensitivity
                            end
                        end
                        
                        DebugBall(headClosest, 0.8, Color3.fromRGB(255, 255, 0))
                    end
                    
                    -- 身体射线
                    local bodyDir = phrp.CFrame.LookVector
                    local bodyDist, bodyClosest = PointToRay(myPos, phrp.Position, bodyDir)
                    
                    DebugRay(phrp.Position, bodyDir, 40, Color3.fromRGB(255, 150, 50))
                    
                    if bodyDist < Settings.DodgeDistance * 0.8 and bodyClosest then
                        local danger = (1 - bodyDist / (Settings.DodgeDistance * 0.8)) * 0.5
                        totalDanger = totalDanger + danger
                        
                        local away = myPos - bodyClosest
                        away = Vector3.new(away.X, 0, away.Z)
                        
                        if away.Magnitude > 0.1 then
                            dodgeDir = dodgeDir + away.Unit * danger * Settings.DodgeSensitivity * 0.5
                        end
                    end
                end
            end
        end
    end
    
    -- 更新UI
    ThreatLbl.Text = "👁 威胁: " .. threatCount .. " 人"
    DangerLbl.Text = string.format("⚠️ 危险: %.0f%%", math.min(totalDanger, 1) * 100)
    
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
    
    -- 选择面向目标
    local faceTarget = nil
    if Settings.FaceEnabled then
        faceTarget = SelectFaceTarget(others)
    end
    
    if CurrentFaceTarget then
        FaceLbl.Text = "👤 面向: " .. CurrentFaceTarget.DisplayName
    else
        FaceLbl.Text = "👤 面向: 无"
    end
    
    -- 执行躲避移动
    if dodgeDir.Magnitude > 0.1 and totalDanger > 0.1 then
        dodgeDir = dodgeDir.Unit
        
        local speed = Settings.MaxSpeed * math.min(1, totalDanger * Settings.DodgeSensitivity) * 0.3
        local targetVel = dodgeDir * speed
        
        currentVelocity = currentVelocity:Lerp(targetVel, Settings.MoveSmooth)
        
        local targetPos = myPos + currentVelocity
        hum:MoveTo(targetPos)
        
        ActionLbl.Text = totalDanger > 0.6 and "🎮 紧急躲避!" or "🎮 躲避中..."
        
        DebugRay(myPos, dodgeDir, 5, Color3.fromRGB(0, 255, 0))
        DebugBall(targetPos, 0.6, Color3.fromRGB(0, 255, 0))
    else
        currentVelocity = currentVelocity:Lerp(Vector3.new(0, 0, 0), 0.1)
        ActionLbl.Text = "🎮 监控中..."
    end
    
    -- 面向目标 (使用 BodyGyro，不干扰移动！)
    if Settings.FaceEnabled and faceTarget then
        local lookAtPos
        if Settings.LookAtHead then
            lookAtPos = faceTarget.Head.Position
        else
            lookAtPos = faceTarget.HRP.Position
        end
        
        local toTarget = lookAtPos - myPos
        toTarget = Vector3.new(toTarget.X, 0, toTarget.Z)
        
        if toTarget.Magnitude > 0.5 then
            local gyro = GetOrCreateGyro(hrp)
            gyro.MaxTorque = Vector3.new(0, Settings.FaceSpeed, 0)
            gyro.CFrame = CFrame.new(myPos, myPos + toTarget)
        end
    else
        -- 关闭面向时移除 Gyro
        if FaceGyro then
            FaceGyro:Destroy()
            FaceGyro = nil
        end
    end
end)

-- 事件
MainBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = not SettingsPanel.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = false
end)

-- 长按开关
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
                
                if not Enabled and FaceGyro then
                    FaceGyro:Destroy()
                    FaceGyro = nil
                end
                
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
    currentVelocity = Vector3.new(0, 0, 0)
    CurrentFaceTarget = nil
    FaceGyro = nil
    ClearDebug()
end)

print("═══════════════════════════════════════════")
print("✅ RAYSHIELD PRO AI躲避系统已加载!")
print("💡 长按按钮开关 | 点击打开设置")
print("🎯 使用BodyGyro转向，不干扰移动!")
print("🛡️ Powered by RayShield Key System v3.0")
print("═══════════════════════════════════════════")

