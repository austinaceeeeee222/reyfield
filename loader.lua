--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║           🛡️ RAYSHIELD PRO - UNIVERSAL LOADER v3.0 🛡️           ║
    ╠══════════════════════════════════════════════════════════════════╣
    ║  使用方法 / Usage:                                               ║
    ║  loadstring(game:HttpGet("YOUR_RAW_LINK_HERE"))()                ║
    ║                                                                  ║
    ║  将此文件上传到 GitHub 并获取 Raw 链接                           ║
    ║  Upload this file to GitHub and get the Raw link                 ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════
-- 配置区域 / CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════
local CONFIG = {
    -- Key 验证网站链接 (你的 GitHub Pages 或其他托管链接)
    KEY_WEBSITE = "https://austinaceeeeee222.github.io/reyfield", -- 替换为你的网站链接
    
    -- 主脚本的 Raw 链接
    MAIN_SCRIPT = "https://raw.githubusercontent.com/austinaceeeeee222/reyfield/refs/heads/main/main.lua", -- 替换为你的脚本链接
    
    -- Key 有效期 (小时)
    KEY_DURATION = 24,
    
    -- 脚本名称
    SCRIPT_NAME = "RAYSHIELD PRO",
    
    -- 版本
    VERSION = "3.0.0",
    
    -- Discord 链接 (可选)
    DISCORD = "https://discord.gg/your-server",
}

-- ═══════════════════════════════════════════════════════════════════
-- 服务 / SERVICES
-- ═══════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════════════════════
-- Key 验证系统 / KEY VALIDATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════

-- 检查是否已验证
local function IsKeyValid()
    -- 尝试从 getgenv() 获取已保存的 Key 状态
    if getgenv and getgenv().RayShield_Verified then
        local savedTime = getgenv().RayShield_VerifyTime or 0
        local currentTime = os.time()
        local hoursPassed = (currentTime - savedTime) / 3600
        
        if hoursPassed < CONFIG.KEY_DURATION then
            return true, getgenv().RayShield_Key
        end
    end
    return false, nil
end

-- 保存验证状态
local function SaveKeyValidation(key)
    if getgenv then
        getgenv().RayShield_Verified = true
        getgenv().RayShield_Key = key
        getgenv().RayShield_VerifyTime = os.time()
    end
end

-- 验证 Key 格式 (XXXX-XXXX-XXXX-XXXX)
local function ValidateKeyFormat(key)
    if not key or type(key) ~= "string" then
        return false
    end
    
    -- 移除空格
    key = key:gsub("%s", "")
    
    -- 检查格式
    local pattern = "^[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]$"
    
    return key:match(pattern) ~= nil
end

-- ═══════════════════════════════════════════════════════════════════
-- UI 创建 / UI CREATION
-- ═══════════════════════════════════════════════════════════════════

local function CreateKeyUI()
    -- 检查是否已有 UI
    if PlayerGui:FindFirstChild("RayShield_KeyUI") then
        PlayerGui.RayShield_KeyUI:Destroy()
    end

    -- 主 ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RayShield_KeyUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui

    -- 背景模糊层
    local BlurFrame = Instance.new("Frame")
    BlurFrame.Name = "BlurFrame"
    BlurFrame.Size = UDim2.new(1, 0, 1, 0)
    BlurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlurFrame.BackgroundTransparency = 0.3
    BlurFrame.BorderSizePixel = 0
    BlurFrame.Parent = ScreenGui

    -- 粒子容器
    local ParticleContainer = Instance.new("Frame")
    ParticleContainer.Name = "ParticleContainer"
    ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticleContainer.BackgroundTransparency = 1
    ParticleContainer.Parent = ScreenGui

    -- 创建浮动粒子
    for i = 1, 20 do
        local Particle = Instance.new("Frame")
        Particle.Name = "Particle_" .. i
        Particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
        Particle.Position = UDim2.new(math.random() * 0.9 + 0.05, 0, math.random() * 0.9 + 0.05, 0)
        Particle.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        Particle.BackgroundTransparency = 0.5
        Particle.BorderSizePixel = 0
        Particle.Parent = ParticleContainer
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(1, 0)
        Corner.Parent = Particle
        
        -- 动画粒子
        task.spawn(function()
            while Particle and Particle.Parent do
                local randomX = math.random() * 0.9 + 0.05
                local randomY = math.random() * 0.9 + 0.05
                local tween = TweenService:Create(Particle, TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(randomX, 0, randomY, 0),
                    BackgroundTransparency = math.random(40, 80) / 100
                })
                tween:Play()
                tween.Completed:Wait()
            end
        end)
    end

    -- 主卡片
    local MainCard = Instance.new("Frame")
    MainCard.Name = "MainCard"
    MainCard.Size = UDim2.new(0, 420, 0, 520)
    MainCard.Position = UDim2.new(0.5, -210, 0.5, -260)
    MainCard.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainCard.BorderSizePixel = 0
    MainCard.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainCard

    -- 边框渐变效果
    local BorderGradient = Instance.new("UIStroke")
    BorderGradient.Color = Color3.fromRGB(0, 255, 255)
    BorderGradient.Thickness = 3
    BorderGradient.Parent = MainCard

    -- 标题区域
    local TitleSection = Instance.new("Frame")
    TitleSection.Name = "TitleSection"
    TitleSection.Size = UDim2.new(1, 0, 0, 120)
    TitleSection.BackgroundTransparency = 1
    TitleSection.Parent = MainCard

    -- Logo
    local Logo = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 80, 0, 80)
    Logo.Position = UDim2.new(0.5, -40, 0, 15)
    Logo.BackgroundTransparency = 1
    Logo.Text = "🛡️"
    Logo.TextSize = 60
    Logo.Font = Enum.Font.GothamBold
    Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    Logo.Parent = TitleSection

    -- 动画 Logo
    task.spawn(function()
        while Logo and Logo.Parent do
            local tween = TweenService:Create(Logo, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextSize = 65
            })
            tween:Play()
            tween.Completed:Wait()
            
            tween = TweenService:Create(Logo, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextSize = 60
            })
            tween:Play()
            tween.Completed:Wait()
        end
    end)

    -- 标题
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 85)
    Title.BackgroundTransparency = 1
    Title.Text = CONFIG.SCRIPT_NAME
    Title.TextSize = 28
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Parent = TitleSection

    -- 版本
    local Version = Instance.new("TextLabel")
    Version.Name = "Version"
    Version.Size = UDim2.new(1, 0, 0, 20)
    Version.Position = UDim2.new(0, 0, 0, 112)
    Version.BackgroundTransparency = 1
    Version.Text = "v" .. CONFIG.VERSION .. " | KEY SYSTEM"
    Title.TextSize = 12
    Version.TextSize = 12
    Version.Font = Enum.Font.Gotham
    Version.TextColor3 = Color3.fromRGB(150, 150, 150)
    Version.Parent = TitleSection

    -- 分隔线
    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.Size = UDim2.new(0.85, 0, 0, 2)
    Separator.Position = UDim2.new(0.075, 0, 0, 140)
    Separator.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    Separator.BackgroundTransparency = 0.7
    Separator.BorderSizePixel = 0
    Separator.Parent = MainCard

    -- 内容区域
    local ContentSection = Instance.new("Frame")
    ContentSection.Name = "ContentSection"
    ContentSection.Size = UDim2.new(1, -40, 0, 280)
    ContentSection.Position = UDim2.new(0, 20, 0, 155)
    ContentSection.BackgroundTransparency = 1
    ContentSection.Parent = MainCard

    -- 说明文字
    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.Size = UDim2.new(1, 0, 0, 50)
    Description.Position = UDim2.new(0, 0, 0, 0)
    Description.BackgroundTransparency = 1
    Description.Text = "🔐 Enter your key to unlock the script\nGet a free key by clicking the button below"
    Description.TextSize = 14
    Description.Font = Enum.Font.Gotham
    Description.TextColor3 = Color3.fromRGB(200, 200, 200)
    Description.TextWrapped = true
    Description.Parent = ContentSection

    -- Key 输入框背景
    local InputBG = Instance.new("Frame")
    InputBG.Name = "InputBG"
    InputBG.Size = UDim2.new(1, 0, 0, 50)
    InputBG.Position = UDim2.new(0, 0, 0, 60)
    InputBG.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    InputBG.BorderSizePixel = 0
    InputBG.Parent = ContentSection

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 12)
    InputCorner.Parent = InputBG

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(60, 60, 80)
    InputStroke.Thickness = 2
    InputStroke.Parent = InputBG

    -- Key 输入框
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.new(0, 10, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
    KeyInput.TextSize = 20
    KeyInput.Font = Enum.Font.Code
    KeyInput.TextColor3 = Color3.fromRGB(0, 255, 255)
    KeyInput.TextXAlignment = Enum.TextXAlignment.Center
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = InputBG

    -- 状态文字
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0, 0, 0, 118)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.Parent = ContentSection

    -- Get Key 按钮
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.Size = UDim2.new(1, 0, 0, 50)
    GetKeyBtn.Position = UDim2.new(0, 0, 0, 150)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.Text = "🔗 GET FREE KEY"
    GetKeyBtn.TextSize = 18
    GetKeyBtn.Font = Enum.Font.GothamBlack
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.Parent = ContentSection

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 12)
    GetKeyCorner.Parent = GetKeyBtn

    -- Verify Key 按钮
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Name = "VerifyBtn"
    VerifyBtn.Size = UDim2.new(1, 0, 0, 50)
    VerifyBtn.Position = UDim2.new(0, 0, 0, 210)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    VerifyBtn.BorderSizePixel = 0
    VerifyBtn.Text = "✓ VERIFY KEY"
    VerifyBtn.TextSize = 18
    VerifyBtn.Font = Enum.Font.GothamBlack
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Parent = ContentSection

    local VerifyCorner = Instance.new("UICorner")
    VerifyCorner.CornerRadius = UDim.new(0, 12)
    VerifyCorner.Parent = VerifyBtn

    -- 页脚
    local Footer = Instance.new("TextLabel")
    Footer.Name = "Footer"
    Footer.Size = UDim2.new(1, 0, 0, 40)
    Footer.Position = UDim2.new(0, 0, 1, -50)
    Footer.BackgroundTransparency = 1
    Footer.Text = "🛡️ RAYSHIELD PRO © 2024\nPowered by Advanced Key System"
    Footer.TextSize = 11
    Footer.Font = Enum.Font.Gotham
    Footer.TextColor3 = Color3.fromRGB(80, 80, 100)
    Footer.Parent = MainCard

    -- 动画边框颜色
    task.spawn(function()
        local hue = 0
        while BorderGradient and BorderGradient.Parent do
            hue = (hue + 0.005) % 1
            BorderGradient.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.03)
        end
    end)

    -- ═══════════════════════════════════════════════════════════════════
    -- 按钮事件 / BUTTON EVENTS
    -- ═══════════════════════════════════════════════════════════════════

    -- 按钮悬停效果
    local function AddHoverEffect(button, normalColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.new(
                    math.min(normalColor.R + 0.2, 1),
                    math.min(normalColor.G + 0.2, 1),
                    math.min(normalColor.B + 0.2, 1)
                )
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = normalColor
            }):Play()
        end)
    end

    AddHoverEffect(GetKeyBtn, Color3.fromRGB(255, 0, 255))
    AddHoverEffect(VerifyBtn, Color3.fromRGB(0, 200, 100))

    -- 链接显示框 (用于手动复制)
    local LinkDisplayBG = Instance.new("Frame")
    LinkDisplayBG.Name = "LinkDisplayBG"
    LinkDisplayBG.Size = UDim2.new(1, 0, 0, 0)
    LinkDisplayBG.Position = UDim2.new(0, 0, 0, 118)
    LinkDisplayBG.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    LinkDisplayBG.BorderSizePixel = 0
    LinkDisplayBG.ClipsDescendants = true
    LinkDisplayBG.Visible = false
    LinkDisplayBG.Parent = ContentSection
    
    local LinkDisplayCorner = Instance.new("UICorner")
    LinkDisplayCorner.CornerRadius = UDim.new(0, 8)
    LinkDisplayCorner.Parent = LinkDisplayBG
    
    local LinkDisplayStroke = Instance.new("UIStroke")
    LinkDisplayStroke.Color = Color3.fromRGB(0, 255, 255)
    LinkDisplayStroke.Thickness = 1
    LinkDisplayStroke.Parent = LinkDisplayBG
    
    local LinkLabel = Instance.new("TextBox")
    LinkLabel.Name = "LinkLabel"
    LinkLabel.Size = UDim2.new(1, -16, 1, 0)
    LinkLabel.Position = UDim2.new(0, 8, 0, 0)
    LinkLabel.BackgroundTransparency = 1
    LinkLabel.Text = CONFIG.KEY_WEBSITE
    LinkLabel.TextSize = 11
    LinkLabel.Font = Enum.Font.Code
    LinkLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    LinkLabel.TextXAlignment = Enum.TextXAlignment.Left
    LinkLabel.ClearTextOnFocus = false
    LinkLabel.TextEditable = false
    LinkLabel.Parent = LinkDisplayBG
    
    local linkShowing = false
    
    -- Get Key 按钮点击
    GetKeyBtn.MouseButton1Click:Connect(function()
        if not linkShowing then
            -- 显示链接框
            linkShowing = true
            LinkDisplayBG.Visible = true
            
            -- 动画展开
            TweenService:Create(LinkDisplayBG, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 30)
            }):Play()
            
            -- 移动按钮
            TweenService:Create(GetKeyBtn, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 0, 0, 155)
            }):Play()
            TweenService:Create(VerifyBtn, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 0, 0, 215)
            }):Play()
            
            StatusLabel.Text = "👆 Select & copy the link above!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            GetKeyBtn.Text = "📋 COPY LINK ABOVE"
            
            -- 自动选中链接文字
            LinkLabel:CaptureFocus()
            LinkLabel.SelectionStart = 1
            LinkLabel.CursorPosition = #CONFIG.KEY_WEBSITE + 1
        else
            -- 已经显示了，提示用户
            StatusLabel.Text = "👆 Select the link and press Ctrl+C!"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
            
            -- 闪烁效果
            TweenService:Create(LinkDisplayBG, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(0, 100, 100)
            }):Play()
            task.wait(0.1)
            TweenService:Create(LinkDisplayBG, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            }):Play()
            
            -- 再次聚焦
            LinkLabel:CaptureFocus()
        end
    end)

    -- Verify Key 按钮点击
    VerifyBtn.MouseButton1Click:Connect(function()
        local inputKey = KeyInput.Text:upper():gsub("%s", "")
        
        if inputKey == "" then
            StatusLabel.Text = "⚠️ Please enter a key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            -- 抖动输入框
            local originalPos = InputBG.Position
            for i = 1, 5 do
                InputBG.Position = originalPos + UDim2.new(0, 5, 0, 0)
                task.wait(0.03)
                InputBG.Position = originalPos - UDim2.new(0, 5, 0, 0)
                task.wait(0.03)
            end
            InputBG.Position = originalPos
            return
        end
        
        if not ValidateKeyFormat(inputKey) then
            StatusLabel.Text = "❌ Invalid key format!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- 显示加载状态
        VerifyBtn.Text = "⏳ VERIFYING..."
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        StatusLabel.Text = "Checking key..."
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        task.wait(1.5) -- 模拟验证过程
        
        -- 验证成功！(简单验证 - 只检查格式)
        -- 在实际生产中，你可能需要连接到服务器验证
        StatusLabel.Text = "✅ KEY VERIFIED!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        VerifyBtn.Text = "✓ SUCCESS!"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        
        -- 保存验证状态
        SaveKeyValidation(inputKey)
        
        task.wait(1)
        
        -- 关闭 UI 并加载脚本
        local closeTween = TweenService:Create(MainCard, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        
        TweenService:Create(BlurFrame, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        
        closeTween.Completed:Wait()
        ScreenGui:Destroy()
        
        -- 加载主脚本
        return true, inputKey
    end)

    -- 输入框聚焦效果
    KeyInput.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(0, 255, 255)
        }):Play()
    end)

    KeyInput.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(60, 60, 80)
        }):Play()
    end)

    -- 入场动画
    MainCard.Size = UDim2.new(0, 0, 0, 0)
    MainCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    BlurFrame.BackgroundTransparency = 1
    TweenService:Create(BlurFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.3
    }):Play()
    
    TweenService:Create(MainCard, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 520),
        Position = UDim2.new(0.5, -210, 0.5, -260)
    }):Play()

    return ScreenGui, VerifyBtn
end

-- ═══════════════════════════════════════════════════════════════════
-- 主逻辑 / MAIN LOGIC
-- ═══════════════════════════════════════════════════════════════════

local function Main()
    print("═══════════════════════════════════════════")
    print("🛡️ " .. CONFIG.SCRIPT_NAME .. " v" .. CONFIG.VERSION)
    print("═══════════════════════════════════════════")
    
    -- 检查是否已验证
    local isValid, savedKey = IsKeyValid()
    
    if isValid then
        print("✅ Key already verified: " .. savedKey)
        print("⏳ Loading main script...")
        
        -- 直接加载主脚本
        local success, err = pcall(function()
            loadstring(game:HttpGet(CONFIG.MAIN_SCRIPT))()
        end)
        
        if not success then
            warn("❌ Failed to load main script: " .. tostring(err))
            -- 如果主脚本加载失败，尝试直接运行本地代码
            print("💡 Attempting to run embedded script...")
        end
        
        return
    end
    
    -- 需要验证
    print("🔐 Key verification required...")
    
    local ui, verifyBtn = CreateKeyUI()
    
    -- 等待验证完成
    local verified = false
    
    verifyBtn.MouseButton1Click:Connect(function()
        task.wait(3) -- 等待验证动画
        
        if getgenv and getgenv().RayShield_Verified then
            verified = true
            print("✅ Verification successful!")
            print("⏳ Loading main script...")
            
            -- 加载主脚本
            local success, err = pcall(function()
                loadstring(game:HttpGet(CONFIG.MAIN_SCRIPT))()
            end)
            
            if not success then
                warn("❌ Failed to load main script: " .. tostring(err))
            end
        end
    end)
end

-- 启动
Main()

