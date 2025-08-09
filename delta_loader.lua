-- Monster6715 Ultimate Script Hub v4.0
-- Современный интерфейс с выбором режима, ESP и автофункциями

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- Основные переменные
local authenticated = false
local menuVisible = false
local dragging = false
local dragStart = nil
local startPos = nil

-- Ключ доступа
local correctKey = "MONSTER2024"

-- Создание основного интерфейса
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Monster6715UltimateHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ============ СИСТЕМА АВТОРИЗАЦИИ ============

local authOverlay = Instance.new("Frame")
authOverlay.Name = "AuthOverlay"
authOverlay.Parent = screenGui
authOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
authOverlay.BackgroundTransparency = 0.2
authOverlay.Size = UDim2.new(1, 0, 1, 0)
authOverlay.ZIndex = 1000

local authFrame = Instance.new("Frame")
authFrame.Name = "AuthFrame"
authFrame.Parent = authOverlay
authFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
authFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
authFrame.Size = UDim2.new(0, 400, 0, 300)
authFrame.ZIndex = 1001

local authCorner = Instance.new("UICorner")
authCorner.CornerRadius = UDim.new(0, 12)
authCorner.Parent = authFrame

local authTitle = Instance.new("TextLabel")
authTitle.Name = "AuthTitle"
authTitle.Parent = authFrame
authTitle.BackgroundTransparency = 1
authTitle.Position = UDim2.new(0, 0, 0, 30)
authTitle.Size = UDim2.new(1, 0, 0, 50)
authTitle.Font = Enum.Font.GothamBold
authTitle.Text = "🔒 MONSTER HUB"
authTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
authTitle.TextSize = 28
authTitle.ZIndex = 1002

local authSubtitle = Instance.new("TextLabel")
authSubtitle.Name = "AuthSubtitle"
authSubtitle.Parent = authFrame
authSubtitle.BackgroundTransparency = 1
authSubtitle.Position = UDim2.new(0, 0, 0, 80)
authSubtitle.Size = UDim2.new(1, 0, 0, 20)
authSubtitle.Font = Enum.Font.Gotham
authSubtitle.Text = "Введите ключ доступа"
authSubtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
authSubtitle.TextSize = 14
authSubtitle.ZIndex = 1002

local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
keyInput.Parent = authFrame
keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
keyInput.Position = UDim2.new(0.5, -150, 0.5, -20)
keyInput.Size = UDim2.new(0, 300, 0, 40)
keyInput.Font = Enum.Font.Gotham
keyInput.PlaceholderText = "Введите ключ..."
keyInput.Text = ""
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.TextSize = 16
keyInput.ZIndex = 1002

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyInput

local authButton = Instance.new("TextButton")
authButton.Name = "AuthButton"
authButton.Parent = authFrame
authButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
authButton.Position = UDim2.new(0.5, -100, 0.7, 0)
authButton.Size = UDim2.new(0, 200, 0, 45)
authButton.Font = Enum.Font.GothamBold
authButton.Text = "АКТИВИРОВАТЬ"
authButton.TextColor3 = Color3.fromRGB(255, 255, 255)
authButton.TextSize = 16
authButton.ZIndex = 1002

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = authButton

-- Анимация кнопки
authButton.MouseEnter:Connect(function()
    TweenService:Create(authButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    }):Play()
end)

authButton.MouseLeave:Connect(function()
    TweenService:Create(authButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    }):Play()
end)

-- ============ ОСНОВНОЕ МЕНЮ ============

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
mainFrame.Size = UDim2.new(0, 600, 0, 500)
mainFrame.Visible = false
mainFrame.ZIndex = 10

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.ZIndex = 11

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Parent = titleBar
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "MONSTER ULTIMATE HUB"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.ZIndex = 12

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.BackgroundTransparency = 1
closeButton.Size = UDim2.new(0, 40, 1, 0)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.ZIndex = 12

-- Контент меню
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Parent = mainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.ZIndex = 11

-- Выбор режима
local modeTitle = Instance.new("TextLabel")
modeTitle.Name = "ModeTitle"
modeTitle.Parent = contentFrame
modeTitle.BackgroundTransparency = 1
modeTitle.Position = UDim2.new(0, 20, 0, 20)
modeTitle.Size = UDim2.new(1, -40, 0, 30)
modeTitle.Font = Enum.Font.GothamBold
modeTitle.Text = "ВЫБЕРИТЕ РЕЖИМ"
modeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
modeTitle.TextSize = 20
modeTitle.TextXAlignment = Enum.TextXAlignment.Left
modeTitle.ZIndex = 12

-- Кнопки режимов
local modes = {
    {name = "BladeBall", icon = "⚔️", color = Color3.fromRGB(255, 80, 80)},
    {name = "99 Night", icon = "🌙", color = Color3.fromRGB(80, 80, 255)},
    {name = "Steal a Brairot", icon = "💰", color = Color3.fromRGB(80, 255, 80)},
}

local modeButtons = {}

for i, mode in ipairs(modes) do
    local modeButton = Instance.new("TextButton")
    modeButton.Name = mode.name .. "Button"
    modeButton.Parent = contentFrame
    modeButton.BackgroundColor3 = mode.color
    modeButton.Position = UDim2.new(0.5, -250, 0, 70 + (i-1)*110)
    modeButton.Size = UDim2.new(0, 500, 0, 90)
    modeButton.Font = Enum.Font.GothamBold
    modeButton.Text = mode.icon .. "  " .. mode.name .. "  " .. mode.icon
    modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeButton.TextSize = 20
    modeButton.ZIndex = 12
    
    local modeCorner = Instance.new("UICorner")
    modeCorner.CornerRadius = UDim.new(0, 10)
    modeCorner.Parent = modeButton
    
    -- Анимация кнопки
    modeButton.MouseEnter:Connect(function()
        TweenService:Create(modeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(
                math.clamp(mode.color.R * 255 + 20, 0, 255),
                math.clamp(mode.color.G * 255 + 20, 0, 255),
                math.clamp(mode.color.B * 255 + 20, 0, 255)
            ) / 255
        }):Play()
    end)
    
    modeButton.MouseLeave:Connect(function()
        TweenService:Create(modeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = mode.color
        }):Play()
    end)
    
    modeButtons[mode.name] = modeButton
end

-- Кнопка переключения меню
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = screenGui
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "MONSTER HUB"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.Visible = false
toggleButton.ZIndex = 100

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Анимация кнопки
toggleButton.MouseEnter:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    }):Play()
end)

toggleButton.MouseLeave:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    }):Play()
end)

-- ============ BLADE BALL МЕНЮ ============

local bladeBallFrame = Instance.new("Frame")
bladeBallFrame.Name = "BladeBallFrame"
bladeBallFrame.Parent = screenGui
bladeBallFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
bladeBallFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
bladeBallFrame.Size = UDim2.new(0, 600, 0, 500)
bladeBallFrame.Visible = false
bladeBallFrame.ZIndex = 20

local bbCorner = Instance.new("UICorner")
bbCorner.CornerRadius = UDim.new(0, 12)
bbCorner.Parent = bladeBallFrame

-- Заголовок Blade Ball
local bbTitleBar = Instance.new("Frame")
bbTitleBar.Name = "BBTitleBar"
bbTitleBar.Parent = bladeBallFrame
bbTitleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
bbTitleBar.Size = UDim2.new(1, 0, 0, 40)
bbTitleBar.ZIndex = 21

local bbTitleCorner = Instance.new("UICorner")
bbTitleCorner.CornerRadius = UDim.new(0, 12)
bbTitleCorner.Parent = bbTitleBar

local bbTitleText = Instance.new("TextLabel")
bbTitleText.Name = "BBTitleText"
bbTitleText.Parent = bbTitleBar
bbTitleText.BackgroundTransparency = 1
bbTitleText.Size = UDim2.new(1, -100, 1, 0)
bbTitleText.Font = Enum.Font.GothamBold
bbTitleText.Text = "BLADE BALL - MONSTER HUB"
bbTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
bbTitleText.TextSize = 18
bbTitleText.TextXAlignment = Enum.TextXAlignment.Left
bbTitleText.Position = UDim2.new(0, 15, 0, 0)
bbTitleText.ZIndex = 22

local bbBackButton = Instance.new("TextButton")
bbBackButton.Name = "BBBackButton"
bbBackButton.Parent = bbTitleBar
bbBackButton.BackgroundTransparency = 1
bbBackButton.Size = UDim2.new(0, 40, 1, 0)
bbBackButton.Position = UDim2.new(0, 5, 0, 0)
bbBackButton.Font = Enum.Font.GothamBold
bbBackButton.Text = "←"
bbBackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bbBackButton.TextSize = 24
bbBackButton.ZIndex = 22

local bbCloseButton = Instance.new("TextButton")
bbCloseButton.Name = "BBCloseButton"
bbCloseButton.Parent = bbTitleBar
bbCloseButton.BackgroundTransparency = 1
bbCloseButton.Size = UDim2.new(0, 40, 1, 0)
bbCloseButton.Position = UDim2.new(1, -40, 0, 0)
bbCloseButton.Font = Enum.Font.GothamBold
bbCloseButton.Text = "×"
bbCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bbCloseButton.TextSize = 24
bbCloseButton.ZIndex = 22

-- Контент Blade Ball
local bbContent = Instance.new("Frame")
bbContent.Name = "BBContent"
bbContent.Parent = bladeBallFrame
bbContent.BackgroundTransparency = 1
bbContent.Position = UDim2.new(0, 0, 0, 40)
bbContent.Size = UDim2.new(1, 0, 1, -40)
bbContent.ZIndex = 21

-- Настройки Blade Ball
local bbSettings = {
    AutoParry = {enabled = false, y = 20},
    AutoClick = {enabled = false, y = 70},
    BallSpeed = {value = 50, y = 120, min = 10, max = 100},
    ESP = {enabled = false, y = 170},
    BoxESP = {enabled = false, y = 220},
    NameESP = {enabled = false, y = 270},
    HealthESP = {enabled = false, y = 320}
}

-- Создание элементов управления
for settingName, settingData in pairs(bbSettings) do
    local settingFrame = Instance.new("Frame")
    settingFrame.Name = settingName .. "Frame"
    settingFrame.Parent = bbContent
    settingFrame.BackgroundTransparency = 1
    settingFrame.Position = UDim2.new(0, 20, 0, settingData.y)
    settingFrame.Size = UDim2.new(1, -40, 0, 40)
    settingFrame.ZIndex = 22
    
    local settingLabel = Instance.new("TextLabel")
    settingLabel.Name = settingName .. "Label"
    settingLabel.Parent = settingFrame
    settingLabel.BackgroundTransparency = 1
    settingLabel.Size = UDim2.new(0.6, 0, 1, 0)
    settingLabel.Font = Enum.Font.Gotham
    settingLabel.Text = settingName
    settingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingLabel.TextSize = 16
    settingLabel.TextXAlignment = Enum.TextXAlignment.Left
    settingLabel.ZIndex = 23
    
    if settingName == "BallSpeed" then
        -- Слайдер для скорости мяча
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "SliderFrame"
        sliderFrame.Parent = settingFrame
        sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        sliderFrame.Position = UDim2.new(0.6, 0, 0.5, -10)
        sliderFrame.Size = UDim2.new(0.4, 0, 0, 20)
        sliderFrame.ZIndex = 23
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 10)
        sliderCorner.Parent = sliderFrame
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "SliderFill"
        sliderFill.Parent = sliderFrame
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        sliderFill.Size = UDim2.new(settingData.value / 100, 0, 1, 0)
        sliderFill.ZIndex = 24
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 10)
        fillCorner.Parent = sliderFill
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "ValueLabel"
        valueLabel.Parent = settingFrame
        valueLabel.BackgroundTransparency = 1
        valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
        valueLabel.Size = UDim2.new(0.4, 0, 1, 0)
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.Text = tostring(settingData.value) .. "%"
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 16
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.ZIndex = 23
        
        -- Логика слайдера
        local dragging = false
        
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                
                local percent = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
                percent = math.clamp(percent, 0, 1)
                
                local value = math.floor(settingData.min + percent * (settingData.max - settingData.min))
                bbSettings[settingName].value = value
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = tostring(value) .. "%"
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
                percent = math.clamp(percent, 0, 1)
                
                local value = math.floor(settingData.min + percent * (settingData.max - settingData.min))
                bbSettings[settingName].value = value
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = tostring(value) .. "%"
            end
        end)
    else
        -- Чекбокс для булевых настроек
        local checkbox = Instance.new("TextButton")
        checkbox.Name = settingName .. "Checkbox"
        checkbox.Parent = settingFrame
        checkbox.BackgroundColor3 = settingData.enabled and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(40, 40, 50)
        checkbox.Position = UDim2.new(0.9, -30, 0.5, -15)
        checkbox.Size = UDim2.new(0, 30, 0, 30)
        checkbox.Font = Enum.Font.GothamBold
        checkbox.Text = settingData.enabled and "✓" or ""
        checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        checkbox.TextSize = 16
        checkbox.ZIndex = 23
        
        local checkboxCorner = Instance.new("UICorner")
        checkboxCorner.CornerRadius = UDim.new(0, 6)
        checkboxCorner.Parent = checkbox
        
        checkbox.MouseButton1Click:Connect(function()
            bbSettings[settingName].enabled = not bbSettings[settingName].enabled
            checkbox.Text = bbSettings[settingName].enabled and "✓" or ""
            checkbox.BackgroundColor3 = bbSettings[settingName].enabled and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(40, 40, 50)
            
            -- Включение/выключение функций
            if settingName == "AutoParry" then
                if bbSettings[settingName].enabled then
                    startAutoParry()
                else
                    stopAutoParry()
                end
            elseif settingName == "AutoClick" then
                if bbSettings[settingName].enabled then
                    startAutoClick()
                else
                    stopAutoClick()
                end
            end
        end)
    end
end

-- ============ ФУНКЦИИ BLADE BALL ============

local autoParryConnection = nil
local autoClickConnection = nil

-- Автоотбивание мяча
function startAutoParry()
    if autoParryConnection then
        autoParryConnection:Disconnect()
    end
    
    autoParryConnection = RunService.Heartbeat:Connect(function()
        local ball = workspace:FindFirstChild("Ball")
        if not ball or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local character = player.Character
        local humanoidRootPart = character.HumanoidRootPart
        local ballPosition = ball.Position
        local playerPosition = humanoidRootPart.Position
        
        -- Вычисляем дистанцию до мяча
        local distance = (ballPosition - playerPosition).Magnitude
        
        -- Проверяем, летит ли мяч к игроку
        local ballVelocity = ball.AssemblyLinearVelocity or ball.Velocity or Vector3.new()
        local ballDirection = ballVelocity.Unit
        local toPlayer = (playerPosition - ballPosition).Unit
        
        -- Угол между направлением мяча и направлением к игроку
        local dotProduct = ballDirection:Dot(toPlayer)
        
        -- Если мяч летит к игроку и находится в радиусе отбивания
        if distance < 25 and dotProduct > 0.3 and ballVelocity.Magnitude > 5 then
            -- Вычисляем силу удара на основе настроек
            local hitForce = 0.1 + (bbSettings.BallSpeed.value / 100 * 0.9)
            
            -- Направление отбивания
            local hitDirection = CFrame.lookAt(playerPosition, ballPosition + Vector3.new(0, 2, 0))
            
            local args = {
                [1] = hitForce,
                [2] = hitDirection,
                [3] = {
                    [1] = ball,
                    [2] = ballPosition
                }
            }
            
            -- Попытка вызвать remote для отбивания
            pcall(function()
                if ReplicatedStorage:FindFirstChild("Remotes") then
                    local remotes = ReplicatedStorage.Remotes
                    if remotes:FindFirstChild("ParryAttempt") then
                        remotes.ParryAttempt:FireServer(unpack(args))
                    elseif remotes:FindFirstChild("Parry") then
                        remotes.Parry:FireServer(unpack(args))
                    end
                elseif ReplicatedStorage:FindFirstChild("ParryAttempt") then
                    ReplicatedStorage.ParryAttempt:FireServer(unpack(args))
                elseif ReplicatedStorage:FindFirstChild("Parry") then
                    ReplicatedStorage.Parry:FireServer(unpack(args))
                end
            end)
            
            wait(0.1)
        end
    end)
end

function stopAutoParry()
    if autoParryConnection then
        autoParryConnection:Disconnect()
        autoParryConnection = nil
    end
end

-- Автокликер
function startAutoClick()
    if autoClickConnection then
        autoClickConnection:Disconnect()
    end
    
    autoClickConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChildOfClass("Tool") then
            local args = {
                [1] = player.Character:FindFirstChildOfClass("Tool"),
                [2] = CFrame.new()
            }
            
            pcall(function()
                if ReplicatedStorage:FindFirstChild("Remotes") then
                    local remotes = ReplicatedStorage.Remotes
                    if remotes:FindFirstChild("SwingSword") then
                        remotes.SwingSword:FireServer(unpack(args))
                    end
                end
            end)
            
            wait(0.1)
        end
    end)
end

function stopAutoClick()
    if autoClickConnection then
        autoClickConnection:Disconnect()
        autoClickConnection = nil
    end
end

-- ============ ОБРАБОТЧИКИ СОБЫТИЙ ============

-- Авторизация
authButton.MouseButton1Click:Connect(function()
    if keyInput.Text == correctKey then
        authenticated = true
        
        -- Анимация успешной авторизации
        TweenService:Create(authFrame, TweenInfo.new(0.5), {
            Position = UDim2.new(0.5, -200, 0.5, -200),
            Size = UDim2.new(0, 400, 0, 0)
        }):Play()
        
        TweenService:Create(authOverlay, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        
        wait(0.5)
        authOverlay.Visible = false
        
        -- Показываем кнопку меню
        toggleButton.Visible = true
        TweenService:Create(toggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0, 20, 0, 20)
        }):Play()
    else
        -- Анимация ошибки
        keyInput.Text = ""
        keyInput.PlaceholderText = "Неверный ключ!"
        keyInput.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        
        local originalPos = authFrame.Position
        for i = 1, 3 do
            TweenService:Create(authFrame, TweenInfo.new(0.05), {
                Position = originalPos + UDim2.new(0, 5, 0, 0)
            }):Play()
            wait(0.05)
            TweenService:Create(authFrame, TweenInfo.new(0.05), {
                Position = originalPos + UDim2.new(0, -5, 0, 0)
            }):Play()
            wait(0.05)
        end
        TweenService:Create(authFrame, TweenInfo.new(0.05), {
            Position = originalPos
        }):Play()
        
        wait(1)
        keyInput.PlaceholderText = "Введите ключ..."
        keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    end
end)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        authButton.MouseButton1Click:Fire()
    end
end)

-- Переключение меню
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    
    if menuVisible then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 600, 0, 500)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        wait(0.3)
        mainFrame.Visible = false
    end
end)

-- Закрытие меню
closeButton.MouseButton1Click:Connect(function()
    menuVisible = false
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    wait(0.3)
    mainFrame.Visible = false
end)

-- Выбор режима Blade Ball
modeButtons["BladeBall"].MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    bladeBallFrame.Visible = true
end)

-- Возврат из Blade Ball меню
bbBackButton.MouseButton1Click:Connect(function()
    bladeBallFrame.Visible = false
    mainFrame.Visible = true
end)

-- Закрытие Blade Ball меню
bbCloseButton.MouseButton1Click:Connect(function()
    bladeBallFrame.Visible = false
end)

-- Система перетаскивания
local function setupDrag(frame, dragElement)
    dragElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    dragElement.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Настройка перетаскивания для всех меню
setupDrag(mainFrame, titleBar)
setupDrag(bladeBallFrame, bbTitleBar)

print("MONSTER ULTIMATE HUB v4.0 загружен - требуется авторизация")
