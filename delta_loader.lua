local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")

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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileBrainrotGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Адаптированное под мобильный экран меню авторизации
local AuthFrame = Instance.new("Frame")
AuthFrame.Size = UDim2.new(0, 280, 0, 220)
AuthFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
AuthFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
AuthFrame.BorderSizePixel = 0
AuthFrame.Parent = ScreenGui

local UICornerAuth = Instance.new("UICorner")
UICornerAuth.CornerRadius = UDim.new(0, 12)
UICornerAuth.Parent = AuthFrame

-- Градиент для фона
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
UIGradient.Rotation = 45
UIGradient.Parent = AuthFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 35)
TitleLabel.Position = UDim2.new(0, 10, 0, 15)
TitleLabel.Text = "🔐 Авторизация"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = AuthFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.85, 0, 0, 40)
KeyBox.Position = UDim2.new(0.075, 0, 0.28, 0)
KeyBox.PlaceholderText = "Введите ключ..."
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Parent = AuthFrame

local UICornerKey = Instance.new("UICorner")
UICornerKey.CornerRadius = UDim.new(0, 8)
UICornerKey.Parent = KeyBox

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0.6, 0, 0, 35)
SubmitButton.Position = UDim2.new(0.2, 0, 0.5, 0)
SubmitButton.Text = "✓ Войти"
SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
SubmitButton.TextColor3 = Color3.new(1, 1, 1)
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 15
SubmitButton.Parent = AuthFrame

local UICornerSubmit = Instance.new("UICorner")
UICornerSubmit.CornerRadius = UDim.new(0, 8)
UICornerSubmit.Parent = SubmitButton

local LinkvertiseButton = Instance.new("TextButton")
LinkvertiseButton.Size = UDim2.new(0.85, 0, 0, 32)
LinkvertiseButton.Position = UDim2.new(0.075, 0, 0.7, 0)
LinkvertiseButton.Text = "🔑 Получить ключ"
LinkvertiseButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
LinkvertiseButton.TextColor3 = Color3.new(1, 1, 1)
LinkvertiseButton.Font = Enum.Font.Gotham
LinkvertiseButton.TextSize = 13
LinkvertiseButton.Parent = AuthFrame

local UICornerLink = Instance.new("UICorner")
UICornerLink.CornerRadius = UDim.new(0, 8)
UICornerLink.Parent = LinkvertiseButton

local TelegramLink = Instance.new("TextButton")
TelegramLink.Size = UDim2.new(0.4, 0, 0, 25)
TelegramLink.Position = UDim2.new(0.3, 0, 0.9, 0)
TelegramLink.Text = "📱 Telegram"
TelegramLink.BackgroundColor3 = Color3.fromRGB(0, 136, 204)
TelegramLink.TextColor3 = Color3.new(1, 1, 1)
TelegramLink.Font = Enum.Font.Gotham
TelegramLink.TextSize = 11
TelegramLink.Parent = AuthFrame

local UICornerTg = Instance.new("UICorner")
UICornerTg.CornerRadius = UDim.new(0, 6)
UICornerTg.Parent = TelegramLink

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

LinkvertiseButton.MouseButton1Click:Connect(function()
    copyToClipboard(LINKVERTISE_LINK)
    LinkvertiseButton.Text = "✅ Скопировано!"
    task.wait(1.5)
    LinkvertiseButton.Text = "🔑 Получить ключ"
end)

TelegramLink.MouseButton1Click:Connect(function()
    copyToClipboard(TELEGRAM_LINK)
    TelegramLink.Text = "✅ Готово!"
    task.wait(1.5)
    TelegramLink.Text = "📱 Telegram"
end)

SubmitButton.MouseButton1Click:Connect(function()
    local inputKey = KeyBox.Text
    if handleKeySubmission(inputKey) then
        AuthFrame:Destroy()
        loadMainGUI()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Неверный ключ!"
    end
end)

function loadMainGUI()
    local draggingGG, dragInputGG, dragStartGG, startPosGG
    local draggingMain, dragInputMain, dragStartMain, startPosMain

    -- Компактная кнопка переключения
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
    ToggleBtn.Position = UDim2.new(0, 15, 0.5, -27.5)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "🎮"
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.TextSize = 24
    ToggleBtn.ZIndex = 2
    ToggleBtn.Parent = ScreenGui

    local UICornerGG = Instance.new("UICorner")
    UICornerGG.CornerRadius = UDim.new(0, 15)
    UICornerGG.Parent = ToggleBtn

    -- Градиент для кнопки
    local UIGradientBtn = Instance.new("UIGradient")
    UIGradientBtn.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    }
    UIGradientBtn.Rotation = 45
    UIGradientBtn.Parent = ToggleBtn

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

    -- Основное меню - адаптированное под мобильные устройства
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 200, 0, 320) -- Уменьшена ширина, увеличена высота
    MainFrame.Position = UDim2.new(0, 80, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Градиент для главного меню
    local UIGradientMain = Instance.new("UIGradient")
    UIGradientMain.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    }
    UIGradientMain.Rotation = 135
    UIGradientMain.Parent = MainFrame

    -- Заголовок меню
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Size = UDim2.new(1, -10, 0, 30)
    HeaderLabel.Position = UDim2.new(0, 5, 0, 5)
    HeaderLabel.Text = "⚡ Mobile Hack"
    HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.TextSize = 16
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Parent = MainFrame

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

    local function createButton(name, positionY, emoji)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.92, 0, 0, 35) -- Увеличена высота кнопок
        button.Position = UDim2.new(0.04, 0, 0.12 + positionY * 0.12, 0)
        button.Text = emoji .. " " .. name
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.Gotham
        button.TextSize = 12
        button.Parent = MainFrame
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 8)
        uiCorner.Parent = button
        
        -- Градиент для кнопок
        local btnGradient = Instance.new("UIGradient")
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 65)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
        }
        btnGradient.Rotation = 90
        btnGradient.Parent = button
        
        return button
    end

    local NoclipBtn = createButton("NoClip: OFF", 0, "👻")
    local ESPBtn = createButton("ESP: OFF", 1, "👁️")
    local FlyBtn = createButton("Fly: OFF", 2, "✈️")
    local SetBaseBtn = createButton("Set Base", 3, "🏠")
    local FloatBtn = createButton("Float to Base", 4, "🎈")
    local AutoStealBtn = createButton("Auto Steal: OFF", 5, "💰")
    local BoostSpeedBtn = createButton("Speed: OFF", 6, "⚡")

    local function toggleGUI()
        MainFrame.Visible = not MainFrame.Visible
    end

    ToggleBtn.MouseButton1Click:Connect(toggleGUI)

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

    -- Мобильное меню управления полетом
    local FlyGui = Instance.new("Frame")
    FlyGui.Size = UDim2.new(0, 120, 0, 80)
    FlyGui.Position = UDim2.new(0, 85, 1, -120)
    FlyGui.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    FlyGui.BackgroundTransparency = 0.1
    FlyGui.Visible = false
    FlyGui.Parent = ScreenGui

    local UICornerFly = Instance.new("UICorner")
    UICornerFly.CornerRadius = UDim.new(0, 12)
    UICornerFly.Parent = FlyGui

    local flyGradient = Instance.new("UIGradient")
    flyGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    }
    flyGradient.Rotation = 45
    flyGradient.Parent = FlyGui

    local FlyForwardBtn = Instance.new("TextButton")
    FlyForwardBtn.Size = UDim2.new(0.35, 0, 0.35, 0)
    FlyForwardBtn.Position = UDim2.new(0.325, 0, 0.1, 0)
    FlyForwardBtn.Text = "⬆️"
    FlyForwardBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    FlyForwardBtn.TextColor3 = Color3.new(1, 1, 1)
    FlyForwardBtn.TextSize = 16
    FlyForwardBtn.Parent = FlyGui

    local flyForwardCorner = Instance.new("UICorner")
    flyForwardCorner.CornerRadius = UDim.new(0, 8)
    flyForwardCorner.Parent = FlyForwardBtn

    local FlyBackwardBtn = Instance.new("TextButton")
    FlyBackwardBtn.Size = UDim2.new(0.35, 0, 0.35, 0)
    FlyBackwardBtn.Position = UDim2.new(0.325, 0, 0.55, 0)
    FlyBackwardBtn.Text = "⬇️"
    FlyBackwardBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    FlyBackwardBtn.TextColor3 = Color3.new(1, 1, 1)
    FlyBackwardBtn.TextSize = 16
    FlyBackwardBtn.Parent = FlyGui

    local flyBackwardCorner = Instance.new("UICorner")
    flyBackwardCorner.CornerRadius = UDim.new(0, 8)
    flyBackwardCorner.Parent = FlyBackwardBtn

    local function disableAllFunctions()
        if noclipActive then 
            noclipActive = false
            NoclipBtn.Text = "👻 NoClip: OFF"
            NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
        
        if flyActive then 
            flyActive = false
            FlyBtn.Text = "✈️ Fly: OFF"
            FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            FlyGui.Visible = false
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
        end
        
        if floatActive then 
            floatActive = false
            FloatBtn.Text = "🎈 Float to Base"
            if floatConnection then
                floatConnection:Disconnect()
                floatConnection = nil
            end
        end
        
        if boostSpeedActive then 
            boostSpeedActive = false
            BoostSpeedBtn.Text = "⚡ Speed: OFF"
            BoostSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            if boostSpeedConnection then
                boostSpeedConnection:Disconnect()
                boostSpeedConnection = nil
            end
        end
    end

    local function toggleNoclip()
        if autoStealActive then return end
        
        noclipActive = not noclipActive
        NoclipBtn.Text = "👻 NoClip: " .. (noclipActive and "ON" or "OFF")
        NoclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(40, 40, 55)
        
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
        ESPBtn.Text = "👁️ ESP: " .. (espActive and "ON" or "OFF")
        ESPBtn.BackgroundColor3 = espActive and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(40, 40, 55)
        
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
        FlyBtn.Text = "✈️ Fly: " .. (flyActive and "ON" or "OFF")
        FlyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(40, 40, 55)
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
        SetBaseBtn.Text = "🏠 Base Saved ✓"
        task.delay(1, function()
            SetBaseBtn.Text = "🏠 Set Base"
        end)
    end

    local function floatToBase()
        if not savedBasePosition then
            createNotification("Ошибка", "Базовая позиция не установлена", 3)
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
        
        FloatBtn.Text = "🎈 Floating..."
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
                FloatBtn.Text = "🎈 Float to Base"
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
                FloatBtn.Text = "🎈 Float to Base"
                return
            end
            
            if tick() - startTime > 15 then
                floatActive = false
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                floatConnection:Disconnect()
                FloatBtn.Text = "🎈 Float to Base"
                return
            end
            
            humanoidRootPart.Velocity = direction * speed
        end)
    end

    local function toggleAutoSteal()
        if autoStealCooldown then return end
        
        if not savedBasePosition then
            createNotification("Ошибка", "Сначала сохраните позицию базы", 3)
            return
        end
        
        autoStealActive = not autoStealActive
        AutoStealBtn.Text = "💰 Auto Steal: " .. (autoStealActive and "ON" or "OFF")
        AutoStealBtn.BackgroundColor3 = autoStealActive and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(40, 40, 55)
        
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
                AutoStealBtn.Text = "💰 Auto Steal: OFF"
                AutoStealBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                autoStealCooldown = false
                return
            end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then 
                autoStealActive = false
                AutoStealBtn.Text = "💰 Auto Steal: OFF"
                AutoStealBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
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
            AutoStealBtn.Text = "💰 Auto Steal: OFF"
            AutoStealBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
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
        BoostSpeedBtn.Text = "⚡ Speed: " .. (boostSpeedActive and "ON" or "OFF")
        BoostSpeedBtn.BackgroundColor3 = boostSpeedActive and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(40, 40, 55)
        
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
            NoclipBtn.Text = "👻 NoClip: OFF"
            NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
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
            FlyBtn.Text = "✈️ Fly: OFF"
            FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            FlyGui.Visible = false
        end
        
        if floatActive then
            floatActive = false
            FloatBtn.Text = "🎈 Float to Base"
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
            AutoStealBtn.Text = "💰 Auto Steal: OFF"
            AutoStealBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
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
            BoostSpeedBtn.Text = "⚡ Speed: OFF"
            BoostSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end
    end)

    NoclipBtn.MouseButton1Click:Connect(toggleNoclip)
    ESPBtn.MouseButton1Click:Connect(toggleESP)
    FlyBtn.MouseButton1Click:Connect(toggleFly)
    SetBaseBtn.MouseButton1Click:Connect(setBase)
    FloatBtn.MouseButton1Click:Connect(floatToBase)
    AutoStealBtn.MouseButton1Click:Connect(toggleAutoSteal)
    BoostSpeedBtn.MouseButton1Click:Connect(toggleBoostSpeed)
end
