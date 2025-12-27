--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║           🛡️ RAYSHIELD PRO - SECURE LOADER v4.0 🛡️              ║
    ╠══════════════════════════════════════════════════════════════════╣
    ║  Usage:                                                          ║
    ║  loadstring(game:HttpGet("YOUR_RAW_LINK_HERE"))()                ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════
-- CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════
local CONFIG = {
    KEY_WEBSITE = "https://austinaceeeeee222.github.io/reyfield/",
    MAIN_SCRIPT = "https://raw.githubusercontent.com/austinaceeeeee222/reyfield/main/main.lua",
    KEY_DURATION = 24, -- hours
    SCRIPT_NAME = "RAYSHIELD PRO",
    VERSION = "4.0.0",
}

-- ═══════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════════════════════
-- DEVICE FINGERPRINT (matches website)
-- ═══════════════════════════════════════════════════════════════════
local function GenerateDeviceFingerprint()
    local data = table.concat({
        game:GetService("UserInputService"):GetPlatform().Name or "Unknown",
        tostring(LocalPlayer.UserId),
        tostring(game.PlaceId),
        tostring(game.GameId),
    }, "|")
    
    local hash = 0
    for i = 1, #data do
        local char = string.byte(data, i)
        hash = bit32.bxor(bit32.lshift(hash, 5) - hash + char, 0)
    end
    return "DEV-" .. string.format("%08X", math.abs(hash))
end

local DEVICE_ID = GenerateDeviceFingerprint()

-- ═══════════════════════════════════════════════════════════════════
-- KEY VALIDATION
-- ═══════════════════════════════════════════════════════════════════
local function ValidateKeyFormat(key)
    if not key or type(key) ~= "string" then return false end
    key = key:upper():gsub("%s", "")
    
    -- Format: XXXX-XXXX-XXXX-XXXX
    if not key:match("^[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[0-9][0-9][0-9][0-9]$") then
        return false
    end
    
    -- Validate checksum (last 4 digits)
    local keyWithoutChecksum = key:sub(1, -5)
    local providedChecksum = tonumber(key:sub(-4))
    
    local calculatedChecksum = 0
    for i = 1, #keyWithoutChecksum do
        calculatedChecksum = calculatedChecksum + string.byte(keyWithoutChecksum, i)
    end
    calculatedChecksum = calculatedChecksum % 10000
    
    return providedChecksum == calculatedChecksum
end

-- Check saved verification
local function IsAlreadyVerified()
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

-- Save verification
local function SaveVerification(key)
    if getgenv then
        getgenv().RayShield_Verified = true
        getgenv().RayShield_Key = key
        getgenv().RayShield_VerifyTime = os.time()
        getgenv().RayShield_DeviceId = DEVICE_ID
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- UI CREATION
-- ═══════════════════════════════════════════════════════════════════
local function CreateKeyUI()
    if PlayerGui:FindFirstChild("RayShield_KeyUI") then
        PlayerGui.RayShield_KeyUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RayShield_KeyUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui

    -- Background blur
    local BlurFrame = Instance.new("Frame")
    BlurFrame.Name = "BlurFrame"
    BlurFrame.Size = UDim2.new(1, 0, 1, 0)
    BlurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlurFrame.BackgroundTransparency = 0.3
    BlurFrame.BorderSizePixel = 0
    BlurFrame.Parent = ScreenGui

    -- Particles
    local ParticleContainer = Instance.new("Frame")
    ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticleContainer.BackgroundTransparency = 1
    ParticleContainer.Parent = ScreenGui

    for i = 1, 15 do
        local Particle = Instance.new("Frame")
        Particle.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
        Particle.Position = UDim2.new(math.random() * 0.9 + 0.05, 0, math.random() * 0.9 + 0.05, 0)
        Particle.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        Particle.BackgroundTransparency = 0.5
        Particle.BorderSizePixel = 0
        Particle.Parent = ParticleContainer
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(1, 0)
        Corner.Parent = Particle
        
        task.spawn(function()
            while Particle and Particle.Parent do
                local tween = TweenService:Create(Particle, TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(math.random() * 0.9 + 0.05, 0, math.random() * 0.9 + 0.05, 0),
                    BackgroundTransparency = math.random(40, 80) / 100
                })
                tween:Play()
                tween.Completed:Wait()
            end
        end)
    end

    -- Main card
    local MainCard = Instance.new("Frame")
    MainCard.Name = "MainCard"
    MainCard.Size = UDim2.new(0, 420, 0, 480)
    MainCard.Position = UDim2.new(0.5, -210, 0.5, -240)
    MainCard.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainCard.BorderSizePixel = 0
    MainCard.Parent = ScreenGui

    Instance.new("UICorner", MainCard).CornerRadius = UDim.new(0, 20)

    local BorderGradient = Instance.new("UIStroke")
    BorderGradient.Color = Color3.fromRGB(0, 255, 255)
    BorderGradient.Thickness = 3
    BorderGradient.Parent = MainCard

    -- Title section
    local TitleSection = Instance.new("Frame")
    TitleSection.Size = UDim2.new(1, 0, 0, 120)
    TitleSection.BackgroundTransparency = 1
    TitleSection.Parent = MainCard

    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 80, 0, 80)
    Logo.Position = UDim2.new(0.5, -40, 0, 10)
    Logo.BackgroundTransparency = 1
    Logo.Text = "🛡️"
    Logo.TextSize = 55
    Logo.Parent = TitleSection

    task.spawn(function()
        while Logo and Logo.Parent do
            local tween = TweenService:Create(Logo, TweenInfo.new(1, Enum.EasingStyle.Sine), { TextSize = 60 })
            tween:Play()
            tween.Completed:Wait()
            tween = TweenService:Create(Logo, TweenInfo.new(1, Enum.EasingStyle.Sine), { TextSize = 55 })
            tween:Play()
            tween.Completed:Wait()
        end
    end)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 85)
    Title.BackgroundTransparency = 1
    Title.Text = CONFIG.SCRIPT_NAME
    Title.TextSize = 26
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Parent = TitleSection

    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(1, 0, 0, 20)
    Version.Position = UDim2.new(0, 0, 0, 110)
    Version.BackgroundTransparency = 1
    Version.Text = "v" .. CONFIG.VERSION .. " | SECURE KEY SYSTEM"
    Version.TextSize = 11
    Version.Font = Enum.Font.Gotham
    Version.TextColor3 = Color3.fromRGB(150, 150, 150)
    Version.Parent = TitleSection

    -- Content section
    local ContentSection = Instance.new("Frame")
    ContentSection.Size = UDim2.new(1, -40, 0, 280)
    ContentSection.Position = UDim2.new(0, 20, 0, 140)
    ContentSection.BackgroundTransparency = 1
    ContentSection.Parent = MainCard

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, 0, 0, 40)
    Description.BackgroundTransparency = 1
    Description.Text = "🔐 Enter your key to unlock\nGet a free key from the website"
    Description.TextSize = 13
    Description.Font = Enum.Font.Gotham
    Description.TextColor3 = Color3.fromRGB(200, 200, 200)
    Description.TextWrapped = true
    Description.Parent = ContentSection

    -- Device ID display
    local DeviceFrame = Instance.new("Frame")
    DeviceFrame.Size = UDim2.new(1, 0, 0, 30)
    DeviceFrame.Position = UDim2.new(0, 0, 0, 45)
    DeviceFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    DeviceFrame.BorderSizePixel = 0
    DeviceFrame.Parent = ContentSection
    Instance.new("UICorner", DeviceFrame).CornerRadius = UDim.new(0, 8)

    local DeviceLabel = Instance.new("TextLabel")
    DeviceLabel.Size = UDim2.new(1, -10, 1, 0)
    DeviceLabel.Position = UDim2.new(0, 5, 0, 0)
    DeviceLabel.BackgroundTransparency = 1
    DeviceLabel.Text = "🔒 Device: " .. DEVICE_ID
    DeviceLabel.TextSize = 11
    DeviceLabel.Font = Enum.Font.Code
    DeviceLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
    DeviceLabel.Parent = DeviceFrame

    -- Key input
    local InputBG = Instance.new("Frame")
    InputBG.Size = UDim2.new(1, 0, 0, 50)
    InputBG.Position = UDim2.new(0, 0, 0, 85)
    InputBG.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    InputBG.BorderSizePixel = 0
    InputBG.Parent = ContentSection
    Instance.new("UICorner", InputBG).CornerRadius = UDim.new(0, 12)

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(60, 60, 80)
    InputStroke.Thickness = 2
    InputStroke.Parent = InputBG

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.new(0, 10, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
    KeyInput.TextSize = 18
    KeyInput.Font = Enum.Font.Code
    KeyInput.TextColor3 = Color3.fromRGB(0, 255, 255)
    KeyInput.TextXAlignment = Enum.TextXAlignment.Center
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = InputBG

    -- Status
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0, 0, 0, 140)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.Parent = ContentSection

    -- Link display (for manual copy)
    local LinkBG = Instance.new("Frame")
    LinkBG.Size = UDim2.new(1, 0, 0, 0)
    LinkBG.Position = UDim2.new(0, 0, 0, 168)
    LinkBG.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    LinkBG.BorderSizePixel = 0
    LinkBG.ClipsDescendants = true
    LinkBG.Visible = false
    LinkBG.Parent = ContentSection
    Instance.new("UICorner", LinkBG).CornerRadius = UDim.new(0, 8)

    local LinkStroke = Instance.new("UIStroke")
    LinkStroke.Color = Color3.fromRGB(0, 255, 255)
    LinkStroke.Thickness = 1
    LinkStroke.Parent = LinkBG

    local LinkText = Instance.new("TextBox")
    LinkText.Size = UDim2.new(1, -10, 1, 0)
    LinkText.Position = UDim2.new(0, 5, 0, 0)
    LinkText.BackgroundTransparency = 1
    LinkText.Text = CONFIG.KEY_WEBSITE
    LinkText.TextSize = 10
    LinkText.Font = Enum.Font.Code
    LinkText.TextColor3 = Color3.fromRGB(0, 255, 255)
    LinkText.TextEditable = false
    LinkText.ClearTextOnFocus = false
    LinkText.Parent = LinkBG

    -- Get Key button
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(1, 0, 0, 45)
    GetKeyBtn.Position = UDim2.new(0, 0, 0, 175)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.Text = "🔗 GET FREE KEY"
    GetKeyBtn.TextSize = 16
    GetKeyBtn.Font = Enum.Font.GothamBlack
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.Parent = ContentSection
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 12)

    -- Verify button
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(1, 0, 0, 45)
    VerifyBtn.Position = UDim2.new(0, 0, 0, 228)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    VerifyBtn.BorderSizePixel = 0
    VerifyBtn.Text = "✓ VERIFY KEY"
    VerifyBtn.TextSize = 16
    VerifyBtn.Font = Enum.Font.GothamBlack
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Parent = ContentSection
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 12)

    -- Footer
    local Footer = Instance.new("TextLabel")
    Footer.Size = UDim2.new(1, 0, 0, 30)
    Footer.Position = UDim2.new(0, 0, 1, -40)
    Footer.BackgroundTransparency = 1
    Footer.Text = "🛡️ RAYSHIELD PRO © 2024\nSecure Key System v4.0"
    Footer.TextSize = 10
    Footer.Font = Enum.Font.Gotham
    Footer.TextColor3 = Color3.fromRGB(80, 80, 100)
    Footer.Parent = MainCard

    -- Rainbow border animation
    task.spawn(function()
        local hue = 0
        while BorderGradient and BorderGradient.Parent do
            hue = (hue + 0.005) % 1
            BorderGradient.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.03)
        end
    end)

    -- Button hover effects
    local function AddHover(btn, normalColor)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.new(
                    math.min(normalColor.R + 0.15, 1),
                    math.min(normalColor.G + 0.15, 1),
                    math.min(normalColor.B + 0.15, 1)
                )
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = normalColor }):Play()
        end)
    end

    AddHover(GetKeyBtn, Color3.fromRGB(255, 0, 255))
    AddHover(VerifyBtn, Color3.fromRGB(0, 200, 100))

    local linkShowing = false

    -- Get Key click
    GetKeyBtn.MouseButton1Click:Connect(function()
        if not linkShowing then
            linkShowing = true
            LinkBG.Visible = true
            
            TweenService:Create(LinkBG, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(1, 0, 0, 28)
            }):Play()
            
            TweenService:Create(GetKeyBtn, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 0, 0, 200)
            }):Play()
            TweenService:Create(VerifyBtn, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 0, 0, 253)
            }):Play()
            
            StatusLabel.Text = "👆 Copy the link above!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            GetKeyBtn.Text = "📋 LINK SHOWN ABOVE"
            
            LinkText:CaptureFocus()
        else
            TweenService:Create(LinkBG, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(0, 80, 80)
            }):Play()
            task.wait(0.1)
            TweenService:Create(LinkBG, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(20, 25, 35)
            }):Play()
            LinkText:CaptureFocus()
        end
    end)

    -- Verify click
    VerifyBtn.MouseButton1Click:Connect(function()
        local inputKey = KeyInput.Text:upper():gsub("%s", "")
        
        if inputKey == "" then
            StatusLabel.Text = "⚠️ Please enter a key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            local originalPos = InputBG.Position
            for i = 1, 4 do
                InputBG.Position = originalPos + UDim2.new(0, 5, 0, 0)
                task.wait(0.03)
                InputBG.Position = originalPos - UDim2.new(0, 5, 0, 0)
                task.wait(0.03)
            end
            InputBG.Position = originalPos
            return
        end
        
        if not ValidateKeyFormat(inputKey) then
            StatusLabel.Text = "❌ Invalid key! Get one from the website."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        VerifyBtn.Text = "⏳ VERIFYING..."
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        StatusLabel.Text = "Checking key..."
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        task.wait(1)
        
        -- Key is valid!
        StatusLabel.Text = "✅ KEY VERIFIED!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        VerifyBtn.Text = "✓ SUCCESS!"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        
        SaveVerification(inputKey)
        
        task.wait(1)
        
        -- Close UI
        local closeTween = TweenService:Create(MainCard, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        
        TweenService:Create(BlurFrame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
        
        closeTween.Completed:Wait()
        ScreenGui:Destroy()
    end)

    -- Input focus effects
    KeyInput.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(0, 255, 255) }):Play()
    end)
    KeyInput.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(60, 60, 80) }):Play()
    end)

    -- Entry animation
    MainCard.Size = UDim2.new(0, 0, 0, 0)
    MainCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    BlurFrame.BackgroundTransparency = 1
    
    TweenService:Create(BlurFrame, TweenInfo.new(0.3), { BackgroundTransparency = 0.3 }):Play()
    TweenService:Create(MainCard, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 480),
        Position = UDim2.new(0.5, -210, 0.5, -240)
    }):Play()

    return ScreenGui, VerifyBtn
end

-- ═══════════════════════════════════════════════════════════════════
-- MAIN
-- ═══════════════════════════════════════════════════════════════════
local function Main()
    print("═══════════════════════════════════════════")
    print("🛡️ " .. CONFIG.SCRIPT_NAME .. " v" .. CONFIG.VERSION)
    print("🔒 Device ID: " .. DEVICE_ID)
    print("═══════════════════════════════════════════")
    
    local isValid, savedKey = IsAlreadyVerified()
    
    if isValid then
        print("✅ Already verified: " .. savedKey)
        print("⏳ Loading script...")
        
        local success, err = pcall(function()
            loadstring(game:HttpGet(CONFIG.MAIN_SCRIPT))()
        end)
        
        if not success then
            warn("❌ Failed to load: " .. tostring(err))
        end
        return
    end
    
    print("🔐 Key verification required...")
    
    local ui, verifyBtn = CreateKeyUI()
    
    verifyBtn.MouseButton1Click:Connect(function()
        task.wait(2.5)
        
        if getgenv and getgenv().RayShield_Verified then
            print("✅ Verification successful!")
            print("⏳ Loading script...")
            
            local success, err = pcall(function()
                loadstring(game:HttpGet(CONFIG.MAIN_SCRIPT))()
            end)
            
            if not success then
                warn("❌ Failed to load: " .. tostring(err))
            end
        end
    end)
end

Main()
