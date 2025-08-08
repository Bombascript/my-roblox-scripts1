-- Monster6715 Blade Ball Script
-- Автоотбивание мяча + Автофарм + Современное меню

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Переменные для функций
local autoBallEnabled = false
local autoFarmEnabled = false
local ballConnection = nil
local farmConnection = nil

-- Создание основного ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Monster6715BladeballGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Главная кнопка для показа/скрытия меню
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = screenGui
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
toggleButton.BackgroundTransparency = 0.2
toggleButton.BorderSizePixel = 0
toggleButton.Position = UDim2.new(0, 20, 0, 100)
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "Monster6715"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.ZIndex = 100

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Создание основного меню
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 5
mainFrame.Visible = false

-- Адаптация для мобильных устройств
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

if isMobile() then
    mainFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
else
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end

mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Скругленные углы
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Градиентный фон
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
mainGradient.Rotation = 135
mainGradient.Parent = mainFrame

-- Заголовок меню
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.ZIndex = mainFrame.ZIndex + 2

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Нижняя часть заголовка
local titleBarBottom = Instance.new("Frame")
titleBarBottom.Parent = titleBar
titleBarBottom.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
titleBarBottom.BackgroundTransparency = 0.2
titleBarBottom.BorderSizePixel = 0
titleBarBottom.Position = UDim2.new(0, 0, 0.7, 0)
titleBarBottom.Size = UDim2.new(1, 0, 0.3, 0)
titleBarBottom.ZIndex = titleBar.ZIndex

-- Текст заголовка
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Parent = titleBar
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "🗡️ Blade Ball Script"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = titleBar.ZIndex + 1

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeButton.BackgroundTransparency = 0.2
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(1, -40, 0.5, 0)
closeButton.AnchorPoint = Vector2.new(0.5, 0.5)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.ZIndex = titleBar.ZIndex + 1

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Содержимое меню
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "Content"
contentFrame.Parent = mainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
contentFrame.ZIndex = mainFrame.ZIndex + 1

-- AUTO BLADE BALL СЕКЦИЯ
local autoBallFrame = Instance.new("Frame")
autoBallFrame.Name = "AutoBallSection"
autoBallFrame.Parent = contentFrame
autoBallFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
autoBallFrame.BackgroundTransparency = 0.3
autoBallFrame.BorderSizePixel = 0
autoBallFrame.Position = UDim2.new(0, 15, 0, 15)
autoBallFrame.Size = UDim2.new(1, -30, 0, 120)
autoBallFrame.ZIndex = contentFrame.ZIndex + 1

local autoBallCorner = Instance.new("UICorner")
autoBallCorner.CornerRadius = UDim.new(0, 8)
autoBallCorner.Parent = autoBallFrame

-- Кнопка Auto Blade Ball
local autoBallButton = Instance.new("TextButton")
autoBallButton.Name = "AutoBallButton"
autoBallButton.Parent = autoBallFrame
autoBallButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
autoBallButton.BackgroundTransparency = 0.2
autoBallButton.BorderSizePixel = 0
autoBallButton.Position = UDim2.new(0, 15, 0, 15)
autoBallButton.Size = UDim2.new(1, -30, 0, 35)
autoBallButton.Font = Enum.Font.GothamBold
autoBallButton.Text = "⚡ Auto BladeBall (OFF)"
autoBallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBallButton.TextSize = 14
autoBallButton.ZIndex = autoBallFrame.ZIndex + 1

local autoBallBtnCorner = Instance.new("UICorner")
autoBallBtnCorner.CornerRadius = UDim.new(0, 6)
autoBallBtnCorner.Parent = autoBallButton

-- Кнопка включения/выключения
local enableBallButton = Instance.new("TextButton")
enableBallButton.Name = "EnableBall"
enableBallButton.Parent = autoBallFrame
enableBallButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
enableBallButton.BorderSizePixel = 0
enableBallButton.Position = UDim2.new(0, 15, 0, 60)
enableBallButton.Size = UDim2.new(0, 80, 0, 25)
enableBallButton.Font = Enum.Font.Gotham
enableBallButton.Text = "Включить"
enableBallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
enableBallButton.TextSize = 12
enableBallButton.ZIndex = autoBallFrame.ZIndex + 1
enableBallButton.Visible = false

local enableBallCorner = Instance.new("UICorner")
enableBallCorner.CornerRadius = UDim.new(0, 4)
enableBallCorner.Parent = enableBallButton

-- Ползунок скорости
local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Parent = autoBallFrame
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.BorderSizePixel = 0
speedSlider.Position = UDim2.new(0, 110, 0, 62)
speedSlider.Size = UDim2.new(0, 150, 0, 20)
speedSlider.ZIndex = autoBallFrame.ZIndex + 1
speedSlider.Visible = false

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = speedSlider

local sliderFill = Instance.new("Frame")
sliderFill.Name = "Fill"
sliderFill.Parent = speedSlider
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.ZIndex = speedSlider.ZIndex + 1

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = sliderFill

-- Текст скорости
local speedText = Instance.new("TextLabel")
speedText.Name = "SpeedText"
speedText.Parent = autoBallFrame
speedText.BackgroundTransparency = 1
speedText.Position = UDim2.new(0, 110, 0, 85)
speedText.Size = UDim2.new(0, 150, 0, 20)
speedText.Font = Enum.Font.Gotham
speedText.Text = "Скорость: 50%"
speedText.TextColor3 = Color3.fromRGB(180, 180, 200)
speedText.TextSize = 11
speedText.ZIndex = autoBallFrame.ZIndex + 1
speedText.Visible = false

-- AUTO FARM СЕКЦИЯ
local autoFarmFrame = Instance.new("Frame")
autoFarmFrame.Name = "AutoFarmSection"
autoFarmFrame.Parent = contentFrame
autoFarmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
autoFarmFrame.BackgroundTransparency = 0.3
autoFarmFrame.BorderSizePixel = 0
autoFarmFrame.Position = UDim2.new(0, 15, 0, 150)
autoFarmFrame.Size = UDim2.new(1, -30, 0, 120)
autoFarmFrame.ZIndex = contentFrame.ZIndex + 1

local autoFarmCorner = Instance.new("UICorner")
autoFarmCorner.CornerRadius = UDim.new(0, 8)
autoFarmCorner.Parent = autoFarmFrame

-- Кнопка Auto Farm
local autoFarmButton = Instance.new("TextButton")
autoFarmButton.Name = "AutoFarmButton"
autoFarmButton.Parent = autoFarmFrame
autoFarmButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
autoFarmButton.BackgroundTransparency = 0.2
autoFarmButton.BorderSizePixel = 0
autoFarmButton.Position = UDim2.new(0, 15, 0, 15)
autoFarmButton.Size = UDim2.new(1, -30, 0, 35)
autoFarmButton.Font = Enum.Font.GothamBold
autoFarmButton.Text = "🚜 Auto Farm (OFF)"
autoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFarmButton.TextSize = 14
autoFarmButton.ZIndex = autoFarmFrame.ZIndex + 1

local autoFarmBtnCorner = Instance.new("UICorner")
autoFarmBtnCorner.CornerRadius = UDim.new(0, 6)
autoFarmBtnCorner.Parent = autoFarmButton

-- Кнопка включения фарма
local enableFarmButton = Instance.new("TextButton")
enableFarmButton.Name = "EnableFarm"
enableFarmButton.Parent = autoFarmFrame
enableFarmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
enableFarmButton.BorderSizePixel = 0
enableFarmButton.Position = UDim2.new(0, 15, 0, 60)
enableFarmButton.Size = UDim2.new(0, 80, 0, 25)
enableFarmButton.Font = Enum.Font.Gotham
enableFarmButton.Text = "Включить"
enableFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
enableFarmButton.TextSize = 12
enableFarmButton.ZIndex = autoFarmFrame.ZIndex + 1
enableFarmButton.Visible = false

local enableFarmCorner = Instance.new("UICorner")
enableFarmCorner.CornerRadius = UDim.new(0, 4)
enableFarmCorner.Parent = enableFarmButton

-- Ползунок фарма
local farmSlider = Instance.new("Frame")
farmSlider.Name = "FarmSlider"
farmSlider.Parent = autoFarmFrame
farmSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
farmSlider.BorderSizePixel = 0
farmSlider.Position = UDim2.new(0, 110, 0, 62)
farmSlider.Size = UDim2.new(0, 150, 0, 20)
farmSlider.ZIndex = autoFarmFrame.ZIndex + 1
farmSlider.Visible = false

local farmSliderCorner = Instance.new("UICorner")
farmSliderCorner.CornerRadius = UDim.new(0, 10)
farmSliderCorner.Parent = farmSlider

local farmSliderFill = Instance.new("Frame")
farmSliderFill.Name = "Fill"
farmSliderFill.Parent = farmSlider
farmSliderFill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
farmSliderFill.BorderSizePixel = 0
farmSliderFill.Size = UDim2.new(0.7, 0, 1, 0)
farmSliderFill.ZIndex = farmSlider.ZIndex + 1

local farmFillCorner = Instance.new("UICorner")
farmFillCorner.CornerRadius = UDim.new(0, 10)
farmFillCorner.Parent = farmSliderFill

-- Текст фарма
local farmText = Instance.new("TextLabel")
farmText.Name = "FarmText"
farmText.Parent = autoFarmFrame
farmText.BackgroundTransparency = 1
farmText.Position = UDim2.new(0, 110, 0, 85)
farmText.Size = UDim2.new(0, 150, 0, 20)
farmText.Font = Enum.Font.Gotham
farmText.Text = "Эффективность: 70%"
farmText.TextColor3 = Color3.fromRGB(180, 180, 200)
farmText.TextSize = 11
farmText.ZIndex = autoFarmFrame.ZIndex + 1
farmText.Visible = false

-- Установка размера скролла
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 290)

-- ФУНКЦИИ BLADE BALL

-- Функция автоотбивания мяча
local function autoBall()
    if ballConnection then
        ballConnection:Disconnect()
        ballConnection = nil
    end
    
    if not autoBallEnabled then return end
    
    ballConnection = RunService.Heartbeat:Connect(function()
        local ball = workspace:FindFirstChild("Ball")
        if ball and ball:FindFirstChild("BodyVelocity") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (ball.Position - player.Character.HumanoidRootPart.Position).Magnitude
            
            if distance < 15 then -- Дистанция отбивания
                local args = {
                    [1] = 0.5, -- Сила удара
                    [2] = CFrame.new(0, 0, 0), -- Направление
                    [3] = {
                        [1] = ball,
                        [2] = ball.Position
                    }
                }
                
                -- Попытка найти и вызвать remote для отбивания
                local success = pcall(function()
                    if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ParryAttempt") then
                        ReplicatedStorage.Remotes.ParryAttempt:FireServer(unpack(args))
                    elseif ReplicatedStorage:FindFirstChild("ParryAttempt") then
                        ReplicatedStorage.ParryAttempt:FireServer(unpack(args))
                    end
                end)
            end
        end
    end)
end

-- Функция автофарма
local function autoFarm()
    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end
    
    if not autoFarmEnabled then return end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Простой фарм - движение к центру карты
            local targetPosition = Vector3.new(0, player.Character.HumanoidRootPart.Position.Y, 0)
            local distance = (targetPosition - player.Character.HumanoidRootPart.Position).Magnitude
            
            if distance > 5 then
                player.Character.Humanoid:MoveTo(targetPosition)
            end
        end
    end)
end

-- ОБРАБОТЧИКИ СОБЫТИЙ

-- Показ/скрытие меню
local menuVisible = false
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    
    if menuVisible then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = isMobile() and UDim2.new(0.9, 0, 0.5, 0) or UDim2.new(0, 350, 0, 400)
        }):Play()
    end
end)

-- Закрытие меню
closeButton.MouseButton1Click:Connect(function()
    menuVisible = false
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    wait(0.3)
    mainFrame.Visible = false
end)

-- Auto Ball кнопка
autoBallButton.MouseButton1Click:Connect(function()
    enableBallButton.Visible = not enableBallButton.Visible
    speedSlider.Visible = not speedSlider.Visible
    speedText.Visible = not speedText.Visible
end)

-- Включить Auto Ball
enableBallButton.MouseButton1Click:Connect(function()
    autoBallEnabled = not autoBallEnabled
    
    if autoBallEnabled then
        enableBallButton.Text = "Выключить"
        enableBallButton.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
        autoBallButton.Text = "⚡ Auto BladeBall (ON)"
        autoBallButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        autoBall()
    else
        enableBallButton.Text = "Включить"
        enableBallButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        autoBallButton.Text = "⚡ Auto BladeBall (OFF)"
        autoBallButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        if ballConnection then
            ballConnection:Disconnect()
            ballConnection = nil
        end
    end
end)

-- Auto Farm кнопка
autoFarmButton.MouseButton1Click:Connect(function()
    enableFarmButton.Visible = not enableFarmButton.Visible
    farmSlider.Visible = not farmSlider.Visible
    farmText.Visible = not farmText.Visible
end)

-- Включить Auto Farm
enableFarmButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    
    if autoFarmEnabled then
        enableFarmButton.Text = "Выключить"
        enableFarmButton.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
        autoFarmButton.Text = "🚜 Auto Farm (ON)"
        autoFarmButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
        autoFarm()
    else
        enableFarmButton.Text = "Включить"
        enableFarmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        autoFarmButton.Text = "🚜 Auto Farm (OFF)"
        autoFarmButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- Система перетаскивания (без движения камеры)
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        -- Блокировка поворота камеры
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                connection:Disconnect()
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Анимации кнопок
local function addHoverEffect(button, hoverColor, normalColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

addHoverEffect(closeButton, Color3.fromRGB(255, 50, 50), Color3.fromRGB(255, 70, 70))
addHoverEffect(toggleButton, Color3.fromRGB(0, 140, 255), Color3.fromRGB(0, 162, 255))

print("🗡️ Monster6715 Blade Ball Script загружен!")
