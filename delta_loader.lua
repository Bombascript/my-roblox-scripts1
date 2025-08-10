if not isVisible then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            local showTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 320)})
            showTween:Play()
        endlocal RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local function createESP(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local character = targetPlayer.Character
    
    if character:FindFirstChild("ESP_Highlight") then
        character.ESP_Highlight:Destroy()
    end
    
    if character:FindFirstChild("ESP_Billboard") then
        character.ESP_Billboard:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(4, 0, 1, 0)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = humanoidRootPart
        billboard.LightInfluence = 0
        billboard.Parent = humanoidRootPart
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.Parent = billboard
    end
    
    return {
        highlight = highlight,
        billboard = billboard
    }
end

local function createNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

local function copyToClipboard(text)
    pcall(function()
        createNotification("Ссылка скопирована", "Теперь вы можете вставить её в браузере", 2)
        setclipboard(text)
    end)
end

local function animateElement(element, targetSize, targetPosition, duration, easeStyle)
    local tween = TweenService:Create(
        element,
        TweenInfo.new(duration or 0.3, easeStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = targetSize, Position = targetPosition}
    )
    tween:Play()
    return tween
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileBrainrotGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Modern Auth Frame
local AuthFrame = Instance.new("Frame")
AuthFrame.Size = UDim2.new(0, 280, 0, 350)
AuthFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
AuthFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AuthFrame.BorderSizePixel = 0
AuthFrame.Parent = ScreenGui

local UICornerAuth = Instance.new("UICorner")
UICornerAuth.CornerRadius = UDim.new(0, 15)
UICornerAuth.Parent = AuthFrame

-- Gradient for modern look
local UIGradientAuth = Instance.new("UIGradient")
UIGradientAuth.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
UIGradientAuth.Rotation = 45
UIGradientAuth.Parent = AuthFrame

-- Glow effect
local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.BackgroundTransparency = 1
Glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Glow.ImageColor3 = Color3.fromRGB(100, 150, 255)
Glow.ImageTransparency = 0.7
Glow.Position = UDim2.new(0, -50, 0, -50)
Glow.Size = UDim2.new(1, 100, 1, 100)
Glow.Parent = AuthFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -30, 0, 45)
TitleLabel.Position = UDim2.new(0, 15, 0, 20)
TitleLabel.Text = "🔐 АВТОРИЗАЦИЯ"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = AuthFrame

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(1, -30, 0, 25)
SubtitleLabel.Position = UDim2.new(0, 15, 0, 60)
SubtitleLabel.Text = "Введите ключ для доступа"
SubtitleLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextSize = 12
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
SubtitleLabel.Parent = AuthFrame

-- Modern Key Input
local KeyContainer = Instance.new("Frame")
KeyContainer.Size = UDim2.new(1, -30, 0, 45)
KeyContainer.Position = UDim2.new(0, 15, 0, 100)
KeyContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
KeyContainer.BorderSizePixel = 0
KeyContainer.Parent = AuthFrame

local UICornerKey = Instance.new("UICorner")
UICornerKey.CornerRadius = UDim.new(0, 10)
UICornerKey.Parent = KeyContainer

local KeyIcon = Instance.new("TextLabel")
KeyIcon.Size = UDim2.new(0, 35, 1, 0)
KeyIcon.Position = UDim2.new(0, 0, 0, 0)
KeyIcon.Text = "🔑"
KeyIcon.TextColor3 = Color3.fromRGB(100, 150, 255)
KeyIcon.Font = Enum.Font.Gotham
KeyIcon.TextSize = 16
KeyIcon.BackgroundTransparency = 1
KeyIcon.TextXAlignment = Enum.TextXAlignment.Center
KeyIcon.Parent = KeyContainer

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 1, -8)
KeyBox.Position = UDim2.new(0, 38, 0, 4)
KeyBox.PlaceholderText = "Введите ключ..."
KeyBox.Text = ""
KeyBox.BackgroundTransparency = 1
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextXAlignment = Enum.TextXAlignment.Left
KeyBox.Parent = KeyContainer

-- Modern Submit Button
local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(1, -30, 0, 40)
SubmitButton.Position = UDim2.new(0, 15, 0, 165)
SubmitButton.Text = "🚀 АКТИВИРОВАТЬ"
SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SubmitButton.TextColor3 = Color3.new(1, 1, 1)
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 14
SubmitButton.BorderSizePixel = 0
SubmitButton.Parent = AuthFrame

local UICornerSubmit = Instance.new("UICorner")
UICornerSubmit.CornerRadius = UDim.new(0, 10)
UICornerSubmit.Parent = SubmitButton

-- Modern Linkvertise Button
local LinkvertiseButton = Instance.new("TextButton")
LinkvertiseButton.Size = UDim2.new(1, -30, 0, 40)
LinkvertiseButton.Position = UDim2.new(0, 15, 0, 220)
LinkvertiseButton.Text = "🔗 ПОЛУЧИТЬ КЛЮЧ"
LinkvertiseButton.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
LinkvertiseButton.TextColor3 = Color3.new(1, 1, 1)
LinkvertiseButton.Font = Enum.Font.GothamBold
LinkvertiseButton.TextSize = 12
LinkvertiseButton.BorderSizePixel = 0
LinkvertiseButton.Parent = AuthFrame

local UICornerLink = Instance.new("UICorner")
UICornerLink.CornerRadius = UDim.new(0, 10)
UICornerLink.Parent = LinkvertiseButton

-- Modern Telegram Button
local TelegramLink = Instance.new("TextButton")
TelegramLink.Size = UDim2.new(1, -30, 0, 35)
TelegramLink.Position = UDim2.new(0, 15, 0, 275)
TelegramLink.Text = "💬 TELEGRAM"
TelegramLink.BackgroundColor3 = Color3.fromRGB(0, 136, 204)
TelegramLink.TextColor3 = Color3.new(1, 1, 1)
TelegramLink.Font = Enum.Font.GothamBold
TelegramLink.TextSize = 12
TelegramLink.BorderSizePixel = 0
TelegramLink.Parent = AuthFrame

local UICornerTelegram = Instance.new("UICorner")
UICornerTelegram.CornerRadius = UDim.new(0, 10)
UICornerTelegram.Parent = TelegramLink

local LINKVERTISE_LINK = "Пароль monster6715"
local TELEGRAM_LINK = "неа"
local CORRECT_KEY = "monster6715"

local function checkKey(inputKey)
    return inputKey == CORRECT_KEY
end

local random = math.random(1,6)
if random == 1 then 
    CORRECT_KEY = "monster6715"
    LINKVERTISE_LINK = "Пароль monster6715"
elseif random == 2 then
    CORRECT_KEY = "monster6715"
    LINKVERTISE_LINK = "Пароль monster6715"
elseif random == 3 then
    CORRECT_KEY = "monster6715"
    LINKVERTISE_LINK = "Пароль monster6715"
elseif random == 4 then
    CORRECT_KEY = "monster6715"
    LINKVERTISE_LINK = "Пароль monster6715"
elseif random == 5 then
    CORRECT_KEY = "monster6715"
    LINKVERTISE_LINK = "Пароль monster6715"
elseif random == 6 then
    CORRECT_KEY = "monster6715"
    LINKVERTISE_LINK = "Пароль monster6715"
end

local function handleKeySubmission(inputKey)
    if checkKey(inputKey) then
        return true
    else
        return false
    end
end

-- Button animations
local function animateButton(button)
    local originalSize = button.Size
    local tween1 = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset * 0.95, originalSize.Y.Scale * 0.95, originalSize.Y.Offset * 0.95)})
    local tween2 = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = originalSize})
    
    tween1:Play()
    tween1.Completed:Connect(function()
        tween2:Play()
    end)
end

LinkvertiseButton.MouseButton1Click:Connect(function()
    animateButton(LinkvertiseButton)
    copyToClipboard(LINKVERTISE_LINK)
    LinkvertiseButton.Text = "✅ ССЫЛКА СКОПИРОВАНА!"
    task.wait(1.5)
    LinkvertiseButton.Text = "🔗 ПОЛУЧИТЬ КЛЮЧ"
end)

TelegramLink.MouseButton1Click:Connect(function()
    animateButton(TelegramLink)
    copyToClipboard(TELEGRAM_LINK)
    TelegramLink.Text = "✅ СКОПИРОВАНО!"
    task.wait(1.5)
    TelegramLink.Text = "💬 TELEGRAM"
end)

SubmitButton.MouseButton1Click:Connect(function()
    animateButton(SubmitButton)
    local inputKey = KeyBox.Text
    if handleKeySubmission(inputKey) then
        local fadeOut = TweenService:Create(AuthFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            AuthFrame:Destroy()
            loadMainGUI()
        end)
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "❌ Неверный ключ!"
        local shake = TweenService:Create(KeyContainer, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 30, 0, 140)})
        local shakeBack = TweenService:Create(KeyContainer, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 20, 0, 140)})
        shake:Play()
        shake.Completed:Connect(function()
            shakeBack:Play()
        end)
        task.wait(2)
        KeyBox.PlaceholderText = "Введите ваш ключ..."
    end
end)

function loadMainGUI()
    local draggingGG, dragInputGG, dragStartGG, startPosGG
    local draggingMain, dragInputMain, dragStartMain, startPosMain

    -- Modern Toggle Button
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
    ToggleBtn.Position = UDim2.new(0, 10, 0.5, -27.5)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "⚡"
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 24
    ToggleBtn.ZIndex = 2
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Parent = ScreenGui

    local UICornerGG = Instance.new("UICorner")
    UICornerGG.CornerRadius = UDim.new(0, 15)
    UICornerGG.Parent = ToggleBtn

    local UIGradientGG = Instance.new("UIGradient")
    UIGradientGG.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 200))
    }
    UIGradientGG.Rotation = 45
    UIGradientGG.Parent = ToggleBtn

    -- Shadow effect for toggle button
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(1, 8, 1, 8)
    Shadow.Position = UDim2.new(0, -4, 0, -4)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.7
    Shadow.ZIndex = 1
    Shadow.Parent = ToggleBtn

    local UIShadowCorner = Instance.new("UICorner")
    UIShadowCorner.CornerRadius = UDim.new(0, 19)
    UIShadowCorner.Parent = Shadow

    local function updateGGInput(input)
        local delta = input.Position - dragStartGG
        ToggleBtn.Position = UDim2.new(0, startPosGG.X.Offset + delta.X, 0, startPosGG.Y.Offset + delta.Y)
    end

    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingGG = true
            dragStartGG = input.Position
            startPosGG = ToggleBtn.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingGG = false
                end
            end)
        end
    end)

    ToggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputGG = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingGG and (input == dragInputGG) then
            updateGGInput(input)
        end
    end)

    -- Modern Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 240, 0, 320)
    MainFrame.Position = UDim2.new(0, 75, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Visible = false
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    local UIGradientMain = Instance.new("UIGradient")
    UIGradientMain.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
    }
    UIGradientMain.Rotation = 45
    UIGradientMain.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local UICornerHeader = Instance.new("UICorner")
    UICornerHeader.CornerRadius = UDim.new(0, 12)
    UICornerHeader.Parent = Header

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Size = UDim2.new(1, -60, 1, 0)
    HeaderTitle.Position = UDim2.new(0, 10, 0, 0)
    HeaderTitle.Text = "🎯 HACK MENU"
    HeaderTitle.TextColor3 = Color3.new(1, 1, 1)
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextSize = 14
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = Header

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.Text = "✕"
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Header

    local UICornerClose = Instance.new("UICorner")
    UICornerClose.CornerRadius = UDim.new(0, 8)
    UICornerClose.Parent = CloseButton

    -- Fix header corners
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 12)
    HeaderFix.Position = UDim2.new(0, 0, 1, -12)
    HeaderFix.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header

    local function updateMainInput(input)
        local delta = input.Position - dragStartMain
        MainFrame.Position = UDim2.new(0, startPosMain.X.Offset + delta.X, 0, startPosMain.Y.Offset + delta.Y)
    end

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = true
            dragStartMain = input.Position
            startPosMain = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingMain = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputMain = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingMain and (input == dragInputMain) then
            updateMainInput(input)
        end
    end)

    -- Modern button creation function
    local function createModernButton(name, icon, positionY, isSpecial)
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Size = UDim2.new(1, -16, 0, 35)
        buttonContainer.Position = UDim2.new(0, 8, 0, 50 + positionY * 40)
        buttonContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        buttonContainer.BorderSizePixel = 0
        buttonContainer.Parent = MainFrame
        
        local uiCornerContainer = Instance.new("UICorner")
        uiCornerContainer.CornerRadius = UDim.new(0, 8)
        uiCornerContainer.Parent = buttonContainer

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Position = UDim2.new(0, 0, 0, 0)
        button.Text = icon .. " " .. name
        button.BackgroundTransparency = 1
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 12
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.Parent = buttonContainer
        
        local textPadding = Instance.new("UIPadding")
        textPadding.PaddingLeft = UDim.new(0, 10)
        textPadding.Parent = button

        -- Status indicator
        local statusIndicator = Instance.new("Frame")
        statusIndicator.Size = UDim2.new(0, 6, 0, 6)
        statusIndicator.Position = UDim2.new(1, -14, 0.5, -3)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        statusIndicator.BorderSizePixel = 0
        statusIndicator.Parent = buttonContainer

        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 3)
        statusCorner.Parent = statusIndicator

        -- Hover effects
        button.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(buttonContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)})
            hoverTween:Play()
        end)

        button.MouseLeave:Connect(function()
            local leaveTween = TweenService:Create(buttonContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)})
            leaveTween:Play()
        end)
        
        return {button = button, container = buttonContainer, indicator = statusIndicator}
    end

    local NoclipBtn = createModernButton("Ноуклип нерабочий: OFF", "👻", 0)
    local ESPBtn = createModernButton("ESP: OFF", "👁️", 1)
    local FlyBtn = createModernButton("Флай Нерабочий: OFF", "🚁", 2)
    local SetBaseBtn = createModernButton("Позиция Базы", "📍", 3)
    local FloatBtn = createModernButton("Тп на базу хз", "🎯", 4)
    local AutoStealBtn = createModernButton("Авто кража: OFF", "🔄", 5)
    local BoostSpeedBtn = createModernButton("Буст спид: OFF", "⚡", 6)

    local function toggleGUI()
        local isVisible = MainFrame.Visible
        MainFrame.Visible = not isVisible
        
        if not isVisible then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            local showTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 320)})
            showTween:Play()
        end
    end

    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        animateButton(CloseButton)
        local closeTween = TweenService:Create(ScreenGui, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Enabled = false})
        closeTween:Play()
        task.wait(0.5)
        ScreenGui:Destroy()
    end)
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        animateButton(ToggleBtn)
        toggleGUI()
    end)

    local noclipActive = false
    local espActive = false
    local floatActive = false
    local flyActive = false
    local autoStealActive = false
    local boostSpeedActive = false
    local savedBasePosition = nil
    local savedHeight = nil
    local espHandles = {}
    local flyConnection = nil
    local noclipConnection = nil
    local autoStealConnection = nil
    local boostSpeedConnection = nil
    local espConnection = nil
    local floatConnection = nil
    local autoStealTimer = nil
    local autoStealCooldown = false

    -- Modern Fly GUI
    local FlyGui = Instance.new("Frame")
    FlyGui.Size = UDim2.new(0, 120, 0, 90)
    FlyGui.Position = UDim2.new(0, 75, 1, -110)
    FlyGui.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    FlyGui.BackgroundTransparency = 0.1
    FlyGui.Visible = false
    FlyGui.BorderSizePixel = 0
    FlyGui.Parent = ScreenGui

    local UICornerFly = Instance.new("UICorner")
    UICornerFly.CornerRadius = UDim.new(0, 12)
    UICornerFly.Parent = FlyGui

    local UIGradientFly = Instance.new("UIGradient")
    UIGradientFly.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
    }
    UIGradientFly.Rotation = 45
    UIGradientFly.Parent = FlyGui

    local FlyForwardBtn = Instance.new("TextButton")
    FlyForwardBtn.Size = UDim2.new(0.7, 0, 0.35, 0)
    FlyForwardBtn.Position = UDim2.new(0.15, 0, 0.1, 0)
    FlyForwardBtn.Text = "⬆️ ВПЕРЕД"
    FlyForwardBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    FlyForwardBtn.TextColor3 = Color3.new(1, 1, 1)
    FlyForwardBtn.Font = Enum.Font.GothamBold
    FlyForwardBtn.TextSize = 10
    FlyForwardBtn.BorderSizePixel = 0
    FlyForwardBtn.Parent = FlyGui

    local UICornerFlyForward = Instance.new("UICorner")
    UICornerFlyForward.CornerRadius = UDim.new(0, 6)
    UICornerFlyForward.Parent = FlyForwardBtn

    local FlyBackwardBtn = Instance.new("TextButton")
    FlyBackwardBtn.Size = UDim2.new(0.7, 0, 0.35, 0)
    FlyBackwardBtn.Position = UDim2.new(0.15, 0, 0.55, 0)
    FlyBackwardBtn.Text = "⬇️ НАЗАД"
    FlyBackwardBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    FlyBackwardBtn.TextColor3 = Color3.new(1, 1, 1)
    FlyBackwardBtn.Font = Enum.Font.GothamBold
    FlyBackwardBtn.TextSize = 10
    FlyBackwardBtn.BorderSizePixel = 0
    FlyBackwardBtn.Parent = FlyGui

    local UICornerFlyBackward = Instance.new("UICorner")
    UICornerFlyBackward.CornerRadius = UDim.new(0, 6)
    UICornerFlyBackward.Parent = FlyBackwardBtn

    local function updateButtonState(button, indicator, isActive, activeText, inactiveText)
        if isActive then
            button.button.Text = button.button.Text:gsub("OFF", "ON"):gsub("❌", "✅")
            if not button.button.Text:find(activeText) then
                button.button.Text = activeText
            end
            local activeTween = TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(50, 255, 50)})
            activeTween:Play()
        else
            button.button.Text = button.button.Text:gsub("ON", "OFF"):gsub("✅", "❌")
            if not button.button.Text:find(inactiveText) then
                button.button.Text = inactiveText
            end
            local inactiveTween = TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)})
            inactiveTween:Play()
        end
    end

    local function disableAllFunctions()
        if noclipActive then 
            noclipActive = false
            updateButtonState(NoclipBtn, NoclipBtn.indicator, false, "", "👻 Ноуклип нерабочий: OFF")
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
        
        if flyActive then 
            flyActive = false
            updateButtonState(FlyBtn, FlyBtn.indicator, false, "", "🚁 Флай Нерабочий: OFF")
            FlyGui.Visible = false
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
        end
        
        if floatActive then 
            floatActive = false
            FloatBtn.button.Text = "🎯 Тп на базу хз"
            if floatConnection then
                floatConnection:Disconnect()
                floatConnection = nil
            end
        end
        
        if boostSpeedActive then 
            boostSpeedActive = false
            updateButtonState(BoostSpeedBtn, BoostSpeedBtn.indicator, false, "", "⚡ Буст спид: OFF")
            if boostSpeedConnection then
                boostSpeedConnection:Disconnect()
                boostSpeedConnection = nil
            end
        end
    end

    local function toggleNoclip()
        if autoStealActive then return end
        
        noclipActive = not noclipActive
        updateButtonState(NoclipBtn, NoclipBtn.indicator, noclipActive, "👻 Ноуклип нерабочий: ON", "👻 Ноуклип нерабочий: OFF")
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        if noclipActive then
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end

    local function toggleESP()
        espActive = not espActive
        updateButtonState(ESPBtn, ESPBtn.indicator, espActive, "👁️ ESP: ON", "👁️ ESP: OFF")
        
        for _, espData in pairs(espHandles) do
            if espData.highlight then espData.highlight:Destroy() end
            if espData.billboard then espData.billboard:Destroy() end
        end
        espHandles = {}
        
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        
        if espActive then
            local function setupESP(targetPlayer)
                if targetPlayer ~= player then
                    local espData = createESP(targetPlayer)
                    if espData then
                        espHandles[targetPlayer] = espData
                    end
                    
                    targetPlayer.CharacterAdded:Connect(function(character)
                        if espActive then
                            task.wait(1)
                            local espData = createESP(targetPlayer)
                            if espData then
                                espHandles[targetPlayer] = espData
                            end
                        end
                    end)
                end
            end
            
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                setupESP(targetPlayer)
            end
            
            Players.PlayerAdded:Connect(setupESP)
            
            espConnection = RunService.Heartbeat:Connect(function()
                if not espActive then return end
                
                for targetPlayer, espData in pairs(espHandles) do
                    if targetPlayer and targetPlayer.Character then
                        if espData.highlight then
                            espData.highlight.Adornee = targetPlayer.Character
                        end
                        if espData.billboard and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            espData.billboard.Adornee = targetPlayer.Character.HumanoidRootPart
                        end
                    end
                end
            end)
        end
    end

    local function toggleFly()
        if autoStealActive then return end
        
        flyActive = not flyActive
        updateButtonState(FlyBtn, FlyBtn.indicator, flyActive, "🚁 Флай Нерабочий: ON", "🚁 Флай Нерабочий: OFF")
        FlyGui.Visible = flyActive
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if flyActive then
            local character = player.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local flySpeed = 50
            local moveDirection = Vector3.new(0, 0, 0)
            local verticalSpeed = 0
            
            local forwardActive = false
            local backwardActive = false
            
            FlyForwardBtn.MouseButton1Down:Connect(function()
                forwardActive = true
            end)
            
            FlyForwardBtn.MouseButton1Up:Connect(function()
                forwardActive = false
            end)
            
            FlyBackwardBtn.MouseButton1Down:Connect(function()
                backwardActive = true
            end)
            
            FlyBackwardBtn.MouseButton1Up:Connect(function()
                backwardActive = false
            end)
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyActive or not character or not character.Parent then
                    if flyConnection then flyConnection:Disconnect() end
                    return
                end
                
                if not hrp or not hrp.Parent then
                    if flyConnection then flyConnection:Disconnect() end
                    return
                end
                
                local camera = workspace.CurrentCamera
                local lookVector = camera.CFrame.LookVector
                
                verticalSpeed = lookVector.Y * flySpeed
                
                moveDirection = Vector3.new(0, 0, 0)
                
                if forwardActive then
                    moveDirection = moveDirection + lookVector
                end
                
                if backwardActive then
                    moveDirection = moveDirection - lookVector
                end
                
                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit
                end
                
                hrp.Velocity = Vector3.new(
                    moveDirection.X * flySpeed,
                    verticalSpeed,
                    moveDirection.Z * flySpeed
                )
            end)
        else
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end

    local function setBase()
        if autoStealActive then return end
        
        local character = player.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        savedBasePosition = humanoidRootPart.Position + Vector3.new(0, 2, 0)
        SetBaseBtn.button.Text = "📍 База сохранена ✓"
        local saveTween = TweenService:Create(SetBaseBtn.indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(50, 255, 50)})
        saveTween:Play()
        task.delay(2, function()
            SetBaseBtn.button.Text = "📍 Позиция Базы"
            local resetTween = TweenService:Create(SetBaseBtn.indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(100, 150, 255)})
            resetTween:Play()
        end)
    end

    local function floatToBase()
        if not savedBasePosition then
            createNotification("❌ Ошибка", "Базовая позиция не установлена", 3)
            return 
        end
        
        floatActive = true
        
        local character = player.Character
        if not character then 
            floatActive = false
            return
        end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then 
            floatActive = false
            return
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end
        
        FloatBtn.button.Text = "🎯 Телепортация..."
        local startTime = tick()
        local speed = 40
        local minDistanceToStop = 3
        local targetHeight = savedBasePosition.Y
        
        if floatConnection then
            floatConnection:Disconnect()
        end
        
        floatConnection = RunService.Heartbeat:Connect(function()
            if not floatActive or not humanoidRootPart or not humanoid then
                floatConnection:Disconnect()
                FloatBtn.button.Text = "🎯 Тп на базу хз"
                return
            end
            
            local currentPos = humanoidRootPart.Position
            local targetPos = Vector3.new(savedBasePosition.X, targetHeight, savedBasePosition.Z)
            local direction = (targetPos - currentPos)
            local distance = direction.Magnitude
            direction = direction.Unit
            
            if distance < minDistanceToStop then
                floatActive = false
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                floatConnection:Disconnect()
                FloatBtn.button.Text = "🎯 Тп на базу хз"
                return
            end
            
            if tick() - startTime > 15 then
                floatActive = false
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                floatConnection:Disconnect()
                FloatBtn.button.Text = "🎯 Тп на базу хз"
                return
            end
            
            humanoidRootPart.Velocity = direction * speed
        end)
    end

    local function toggleAutoSteal()
        if autoStealCooldown then return end
        
        if not savedBasePosition then
            createNotification("❌ Ошибка", "Сначала сохраните позицию базы", 3)
            return
        end
        
        autoStealActive = not autoStealActive
        updateButtonState(AutoStealBtn, AutoStealBtn.indicator, autoStealActive, "🔄 Авто кража: ON", "🔄 Авто кража: OFF")
        
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
        
        if autoStealActive then
            autoStealCooldown = true
            disableAllFunctions()
            
            local character = player.Character
            if not character then 
                autoStealActive = false
                updateButtonState(AutoStealBtn, AutoStealBtn.indicator, false, "", "🔄 Авто кража: OFF")
                autoStealCooldown = false
                return
            end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then 
                autoStealActive = false
                updateButtonState(AutoStealBtn, AutoStealBtn.indicator, false, "", "🔄 Авто кража: OFF")
                autoStealCooldown = false
                return
            end
            
            savedHeight = humanoidRootPart.Position.Y
            
            local targetPosition = humanoidRootPart.Position + Vector3.new(0, 200, 0)
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
            task.wait(1)
            
            local skyBase = Vector3.new(savedBasePosition.X, humanoidRootPart.Position.Y, savedBasePosition.Z)
            local originalBase = savedBasePosition
            savedBasePosition = skyBase
            
            floatToBase()
            
            autoStealTimer = task.delay(15, function()
                if autoStealActive then
                    toggleAutoSteal()
                end
            end)
            
            while floatActive do
                task.wait()
            end
            
            local currentPos = humanoidRootPart.Position
            local finalPosition = Vector3.new(currentPos.X, savedHeight, currentPos.Z)
            humanoidRootPart.CFrame = CFrame.new(finalPosition)
            
            savedBasePosition = originalBase
            autoStealActive = false
            updateButtonState(AutoStealBtn, AutoStealBtn.indicator, false, "", "🔄 Авто кража: OFF")
            autoStealCooldown = false
        else
            if autoStealTimer then
                task.cancel(autoStealTimer)
                autoStealTimer = nil
            end
            autoStealCooldown = false
        end
    end

    local function toggleBoostSpeed()
        if autoStealActive then return end
        
        boostSpeedActive = not boostSpeedActive
        updateButtonState(BoostSpeedBtn, BoostSpeedBtn.indicator, boostSpeedActive, "⚡ Буст спид: ON", "⚡ Буст спид: OFF")
        
        if boostSpeedConnection then
            boostSpeedConnection:Disconnect()
            boostSpeedConnection = nil
        end
        
        if boostSpeedActive then
            local character = player.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local speed = 50
            
            boostSpeedConnection = RunService.Heartbeat:Connect(function()
                if not boostSpeedActive or not character or not character.Parent then
                    if boostSpeedConnection then boostSpeedConnection:Disconnect() end
                    return
                end
                
                if not hrp or not hrp.Parent then
                    if boostSpeedConnection then boostSpeedConnection:Disconnect() end
                    return
                end
                
                local camera = workspace.CurrentCamera
                local lookVector = camera.CFrame.LookVector
                lookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
                
                hrp.Velocity = lookVector * speed
            end)
        else
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end

    -- Character respawn handling
    player.CharacterAdded:Connect(function(character)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if not part:FindFirstChild("OriginalSize") then
                    local originalSize = Instance.new("Vector3Value")
                    originalSize.Name = "OriginalSize"
                    originalSize.Value = part.Size
                    originalSize.Parent = part
                end
            end
        end
        
        if noclipActive then
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            noclipActive = false
            updateButtonState(NoclipBtn, NoclipBtn.indicator, false, "", "👻 Ноуклип нерабочий: OFF")
        end
        
        if espActive then
            for _, espData in pairs(espHandles) do
                if espData.highlight then espData.highlight:Destroy() end
                if espData.billboard then espData.billboard:Destroy() end
            end
            espHandles = {}
            
            toggleESP()
            toggleESP()
        end
        
        if flyActive then
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            flyActive = false
            updateButtonState(FlyBtn, FlyBtn.indicator, false, "", "🚁 Флай Нерабочий: OFF")
            FlyGui.Visible = false
        end
        
        if floatActive then
            floatActive = false
            FloatBtn.button.Text = "🎯 Тп на базу хз"
            if floatConnection then
                floatConnection:Disconnect()
                floatConnection = nil
            end
        end
        
        if autoStealActive then
            if autoStealConnection then
                autoStealConnection:Disconnect()
                autoStealConnection = nil
            end
            autoStealActive = false
            updateButtonState(AutoStealBtn, AutoStealBtn.indicator, false, "", "🔄 Авто кража: OFF")
            if autoStealTimer then
                task.cancel(autoStealTimer)
                autoStealTimer = nil
            end
            autoStealCooldown = false
        end
        
        if boostSpeedActive then
            if boostSpeedConnection then
                boostSpeedConnection:Disconnect()
                boostSpeedConnection = nil
            end
            boostSpeedActive = false
            updateButtonState(BoostSpeedBtn, BoostSpeedBtn.indicator, false, "", "⚡ Буст спид: OFF")
        end
    end)

    -- Connect button functions
    NoclipBtn.button.MouseButton1Click:Connect(function()
        animateButton(NoclipBtn.button)
        toggleNoclip()
    end)
    
    ESPBtn.button.MouseButton1Click:Connect(function()
        animateButton(ESPBtn.button)
        toggleESP()
    end)
    
    FlyBtn.button.MouseButton1Click:Connect(function()
        animateButton(FlyBtn.button)
        toggleFly()
    end)
    
    SetBaseBtn.button.MouseButton1Click:Connect(function()
        animateButton(SetBaseBtn.button)
        setBase()
    end)
    
    FloatBtn.button.MouseButton1Click:Connect(function()
        animateButton(FloatBtn.button)
        floatToBase()
    end)
    
    AutoStealBtn.button.MouseButton1Click:Connect(function()
        animateButton(AutoStealBtn.button)
        toggleAutoSteal()
    end)
    
    BoostSpeedBtn.button.MouseButton1Click:Connect(function()
        animateButton(BoostSpeedBtn.button)
        toggleBoostSpeed()
    end)
end
