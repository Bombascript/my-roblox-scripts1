-- Monster6715 Blade Ball Script v2.0
-- Улучшенная версия с системой входа и полнофункциональным автоотбиванием

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Переменные
local autoBallEnabled = false
local autoFarmEnabled = false
local ballConnection = nil
local farmConnection = nil
local ballSpeed = 0.5 -- От 0.1 до 1.0
local farmEfficiency = 0.7 -- От 0.1 до 1.0

-- Правильный пароль
local correctPassword = "moster6715"
local authenticated = false

-- Создание основного ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Monster6715BladeballGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ============ СИСТЕМА ВХОДА ============

-- Затемнение на весь экран
local overlay = Instance.new("Frame")
overlay.Name = "LoginOverlay"
overlay.Parent = screenGui
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0
overlay.BorderSizePixel = 0
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.ZIndex = 1000

-- Анимация загрузки
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Parent = overlay
loadingFrame.BackgroundTransparency = 1
loadingFrame.Size = UDim2.new(0, 300, 0, 100)
loadingFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
loadingFrame.ZIndex = overlay.ZIndex + 1

local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Parent = loadingFrame
loadingText.BackgroundTransparency = 1
loadingText.Size = UDim2.new(1, 0, 0.5, 0)
loadingText.Position = UDim2.new(0, 0, 0, 0)
loadingText.Font = Enum.Font.GothamBold
loadingText.Text = "🗡️ Monster6715 Blade Ball"
loadingText.TextColor3 = Color3.fromRGB(0, 162, 255)
loadingText.TextSize = 24
loadingText.ZIndex = loadingFrame.ZIndex + 1

local loadingBar = Instance.new("Frame")
loadingBar.Name = "LoadingBar"
loadingBar.Parent = loadingFrame
loadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
loadingBar.BorderSizePixel = 0
loadingBar.Size = UDim2.new(1, 0, 0, 8)
loadingBar.Position = UDim2.new(0, 0, 0.7, 0)
loadingBar.ZIndex = loadingFrame.ZIndex + 1

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 4)
barCorner.Parent = loadingBar

local loadingFill = Instance.new("Frame")
loadingFill.Name = "Fill"
loadingFill.Parent = loadingBar
loadingFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
loadingFill.BorderSizePixel = 0
loadingFill.Size = UDim2.new(0, 0, 1, 0)
loadingFill.ZIndex = loadingBar.ZIndex + 1

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = loadingFill

-- Анимация загрузки
local loadingTween = TweenService:Create(loadingFill, TweenInfo.new(2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)})
loadingTween:Play()

-- Меню входа
local loginFrame = Instance.new("Frame")
loginFrame.Name = "LoginFrame"
loginFrame.Parent = overlay
loginFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
loginFrame.BackgroundTransparency = 0.1
loginFrame.BorderSizePixel = 0
loginFrame.Size = UDim2.new(0, 400, 0, 300)
loginFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
loginFrame.ZIndex = overlay.ZIndex + 1
loginFrame.Visible = false

local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 12)
loginCorner.Parent = loginFrame

-- Градиент для меню входа
local loginGradient = Instance.new("UIGradient")
loginGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
loginGradient.Rotation = 135
loginGradient.Parent = loginFrame

-- Заголовок входа
local loginTitle = Instance.new("TextLabel")
loginTitle.Name = "LoginTitle"
loginTitle.Parent = loginFrame
loginTitle.BackgroundTransparency = 1
loginTitle.Size = UDim2.new(1, 0, 0, 50)
loginTitle.Position = UDim2.new(0, 0, 0, 20)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.Text = "🔐 Введите пароль"
loginTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loginTitle.TextSize = 18
loginTitle.ZIndex = loginFrame.ZIndex + 1

-- Кнопка "Получить пароль"
local getPasswordButton = Instance.new("TextButton")
getPasswordButton.Name = "GetPasswordButton"
getPasswordButton.Parent = loginFrame
getPasswordButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
getPasswordButton.BackgroundTransparency = 0.2
getPasswordButton.BorderSizePixel = 0
getPasswordButton.Size = UDim2.new(0, 150, 0, 35)
getPasswordButton.Position = UDim2.new(0.5, -75, 0, 80)
getPasswordButton.Font = Enum.Font.GothamBold
getPasswordButton.Text = "Получить пароль"
getPasswordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getPasswordButton.TextSize = 14
getPasswordButton.ZIndex = loginFrame.ZIndex + 1

local getPassCorner = Instance.new("UICorner")
getPassCorner.CornerRadius = UDim.new(0, 6)
getPassCorner.Parent = getPasswordButton

-- Поле ввода пароля
local passwordBox = Instance.new("TextBox")
passwordBox.Name = "PasswordBox"
passwordBox.Parent = loginFrame
passwordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
passwordBox.BackgroundTransparency = 0.3
passwordBox.BorderSizePixel = 0
passwordBox.Size = UDim2.new(0, 250, 0, 40)
passwordBox.Position = UDim2.new(0.5, -125, 0, 140)
passwordBox.Font = Enum.Font.Gotham
passwordBox.PlaceholderText = "Введите пароль..."
passwordBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
passwordBox.Text = ""
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.TextSize = 14
passwordBox.ZIndex = loginFrame.ZIndex + 1

local passwordCorner = Instance.new("UICorner")
passwordCorner.CornerRadius = UDim.new(0, 6)
passwordCorner.Parent = passwordBox

-- Текст над кнопкой "Продолжить"
local continueLabel = Instance.new("TextLabel")
continueLabel.Name = "ContinueLabel"
continueLabel.Parent = loginFrame
continueLabel.BackgroundTransparency = 1
continueLabel.Size = UDim2.new(1, 0, 0, 20)
continueLabel.Position = UDim2.new(0, 0, 0, 200)
continueLabel.Font = Enum.Font.Gotham
continueLabel.Text = "Пароль: moster6715"
continueLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
continueLabel.TextSize = 12
continueLabel.ZIndex = loginFrame.ZIndex + 1

-- Кнопка "Продолжить"
local continueButton = Instance.new("TextButton")
continueButton.Name = "ContinueButton"
continueButton.Parent = loginFrame
continueButton.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
continueButton.BackgroundTransparency = 0.2
continueButton.BorderSizePixel = 0
continueButton.Size = UDim2.new(0, 120, 0, 35)
continueButton.Position = UDim2.new(0.5, -60, 0, 230)
continueButton.Font = Enum.Font.GothamBold
continueButton.Text = "Продолжить"
continueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
continueButton.TextSize = 14
continueButton.ZIndex = loginFrame.ZIndex + 1

local continueCorner = Instance.new("UICorner")
continueCorner.CornerRadius = UDim.new(0, 6)
continueCorner.Parent = continueButton

-- Показ меню входа после загрузки
loadingTween.Completed:Connect(function()
    wait(0.5)
    loadingFrame.Visible = false
    loginFrame.Visible = true
    
    -- Анимация появления меню входа
    loginFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(loginFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 300)
    }):Play()
end)

-- ============ ОСНОВНОЕ МЕНЮ ============

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
toggleButton.Visible = false

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Основное меню
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 5
mainFrame.Visible = false

-- Адаптация размера
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

if isMobile() then
    mainFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
else
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
end

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Градиент основного меню
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
mainGradient.Rotation = 135
mainGradient.Parent = mainFrame

-- Заголовок основного меню
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

local titleBarBottom = Instance.new("Frame")
titleBarBottom.Parent = titleBar
titleBarBottom.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
titleBarBottom.BackgroundTransparency = 0.2
titleBarBottom.BorderSizePixel = 0
titleBarBottom.Position = UDim2.new(0, 0, 0.7, 0)
titleBarBottom.Size = UDim2.new(1, 0, 0.3, 0)
titleBarBottom.ZIndex = titleBar.ZIndex

local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Parent = titleBar
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "🗡️ Blade Ball Script v2.0"
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
autoBallFrame.Size = UDim2.new(1, -30, 0, 180)
autoBallFrame.ZIndex = contentFrame.ZIndex + 1

local autoBallCorner = Instance.new("UICorner")
autoBallCorner.CornerRadius = UDim.new(0, 8)
autoBallCorner.Parent = autoBallFrame

-- Заголовок Auto Ball
local autoBallTitle = Instance.new("TextLabel")
autoBallTitle.Name = "Title"
autoBallTitle.Parent = autoBallFrame
autoBallTitle.BackgroundTransparency = 1
autoBallTitle.Position = UDim2.new(0, 15, 0, 10)
autoBallTitle.Size = UDim2.new(1, -30, 0, 30)
autoBallTitle.Font = Enum.Font.GothamBold
autoBallTitle.Text = "⚡ Auto BladeBall"
autoBallTitle.TextColor3 = Color3.fromRGB(0, 162, 255)
autoBallTitle.TextSize = 16
autoBallTitle.TextXAlignment = Enum.TextXAlignment.Left
autoBallTitle.ZIndex = autoBallFrame.ZIndex + 1

-- Переключатель Auto Ball
local ballToggle = Instance.new("TextButton")
ballToggle.Name = "Toggle"
ballToggle.Parent = autoBallFrame
ballToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ballToggle.BorderSizePixel = 0
ballToggle.Position = UDim2.new(0, 15, 0, 50)
ballToggle.Size = UDim2.new(0, 100, 0, 30)
ballToggle.Font = Enum.Font.Gotham
ballToggle.Text = "ВЫКЛ"
ballToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ballToggle.TextSize = 12
ballToggle.ZIndex = autoBallFrame.ZIndex + 1

local ballToggleCorner = Instance.new("UICorner")
ballToggleCorner.CornerRadius = UDim.new(0, 6)
ballToggleCorner.Parent = ballToggle

-- Ползунок скорости
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = autoBallFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 15, 0, 90)
speedLabel.Size = UDim2.new(1, -30, 0, 20)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Скорость отбивания: 50%"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.ZIndex = autoBallFrame.ZIndex + 1

local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Parent = autoBallFrame
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.BorderSizePixel = 0
speedSlider.Position = UDim2.new(0, 15, 0, 115)
speedSlider.Size = UDim2.new(1, -30, 0, 20)
speedSlider.ZIndex = autoBallFrame.ZIndex + 1

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 10)
speedSliderCorner.Parent = speedSlider

local speedFill = Instance.new("Frame")
speedFill.Name = "Fill"
speedFill.Parent = speedSlider
speedFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
speedFill.BorderSizePixel = 0
speedFill.Size = UDim2.new(0.5, 0, 1, 0)
speedFill.ZIndex = speedSlider.ZIndex + 1

local speedFillCorner = Instance.new("UICorner")
speedFillCorner.CornerRadius = UDim.new(0, 10)
speedFillCorner.Parent = speedFill

local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Parent = speedSlider
speedButton.BackgroundTransparency = 1
speedButton.Size = UDim2.new(1, 0, 1, 0)
speedButton.Text = ""
speedButton.ZIndex = speedSlider.ZIndex + 2

-- AUTO FARM СЕКЦИЯ
local autoFarmFrame = Instance.new("Frame")
autoFarmFrame.Name = "AutoFarmSection"
autoFarmFrame.Parent = contentFrame
autoFarmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
autoFarmFrame.BackgroundTransparency = 0.3
autoFarmFrame.BorderSizePixel = 0
autoFarmFrame.Position = UDim2.new(0, 15, 0, 210)
autoFarmFrame.Size = UDim2.new(1, -30, 0, 180)
autoFarmFrame.ZIndex = contentFrame.ZIndex + 1

local autoFarmCorner = Instance.new("UICorner")
autoFarmCorner.CornerRadius = UDim.new(0, 8)
autoFarmCorner.Parent = autoFarmFrame

-- Заголовок Auto Farm
local autoFarmTitle = Instance.new("TextLabel")
autoFarmTitle.Name = "Title"
autoFarmTitle.Parent = autoFarmFrame
autoFarmTitle.BackgroundTransparency = 1
autoFarmTitle.Position = UDim2.new(0, 15, 0, 10)
autoFarmTitle.Size = UDim2.new(1, -30, 0, 30)
autoFarmTitle.Font = Enum.Font.GothamBold
autoFarmTitle.Text = "🚜 Auto Farm"
autoFarmTitle.TextColor3 = Color3.fromRGB(255, 140, 0)
autoFarmTitle.TextSize = 16
autoFarmTitle.TextXAlignment = Enum.TextXAlignment.Left
autoFarmTitle.ZIndex = autoFarmFrame.ZIndex + 1

-- Переключатель Auto Farm
local farmToggle = Instance.new("TextButton")
farmToggle.Name = "Toggle"
farmToggle.Parent = autoFarmFrame
farmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
farmToggle.BorderSizePixel = 0
farmToggle.Position = UDim2.new(0, 15, 0, 50)
farmToggle.Size = UDim2.new(0, 100, 0, 30)
farmToggle.Font = Enum.Font.Gotham
farmToggle.Text = "ВЫКЛ"
farmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
farmToggle.TextSize = 12
farmToggle.ZIndex = autoFarmFrame.ZIndex + 1

local farmToggleCorner = Instance.new("UICorner")
farmToggleCorner.CornerRadius = UDim.new(0, 6)
farmToggleCorner.Parent = farmToggle

-- Ползунок эффективности фарма
local farmLabel = Instance.new("TextLabel")
farmLabel.Name = "FarmLabel"
farmLabel.Parent = autoFarmFrame
farmLabel.BackgroundTransparency = 1
farmLabel.Position = UDim2.new(0, 15, 0, 90)
farmLabel.Size = UDim2.new(1, -30, 0, 20)
farmLabel.Font = Enum.Font.Gotham
farmLabel.Text = "Эффективность: 70%"
farmLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
farmLabel.TextSize = 12
farmLabel.TextXAlignment = Enum.TextXAlignment.Left
farmLabel.ZIndex = autoFarmFrame.ZIndex + 1

local farmSlider = Instance.new("Frame")
farmSlider.Name = "FarmSlider"
farmSlider.Parent = autoFarmFrame
farmSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
farmSlider.BorderSizePixel = 0
farmSlider.Position = UDim2.new(0, 15, 0, 115)
farmSlider.Size = UDim2.new(1, -30, 0, 20)
farmSlider.ZIndex = autoFarmFrame.ZIndex + 1

local farmSliderCorner = Instance.new("UICorner")
farmSliderCorner.CornerRadius = UDim.new(0, 10)
farmSliderCorner.Parent = farmSlider

local farmFill = Instance.new("Frame")
farmFill.Name = "Fill"
farmFill.Parent = farmSlider
farmFill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
farmFill.BorderSizePixel = 0
farmFill.Size = UDim2.new(0.7, 0, 1, 0)
farmFill.ZIndex = farmSlider.ZIndex + 1

local farmFillCorner = Instance.new("UICorner")
farmFillCorner.CornerRadius = UDim.new(0, 10)
farmFillCorner.Parent = farmFill

local farmButton = Instance.new("TextButton")
farmButton.Name = "FarmButton"
farmButton.Parent = farmSlider
farmButton.BackgroundTransparency = 1
farmButton.Size = UDim2.new(1, 0, 1, 0)
farmButton.Text = ""
farmButton.ZIndex = farmSlider.ZIndex + 2

-- Установка размера скролла
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 410)

-- ============ ФУНКЦИИ BLADE BALL ============

-- Улучшенная функция автоотбивания мяча
local function autoBall()
    if ballConnection then
        ballConnection:Disconnect()
        ballConnection = nil
    end
    
    if not autoBallEnabled then return end
    
    ballConnection = RunService.Heartbeat:Connect(function()
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
        
        -- Если мяч летит к игроку (dotProduct > 0.5) и находится в радиусе отбивания
        if distance < 25 and dotProduct > 0.3 and ballVelocity.Magnitude > 5 then
            -- Вычисляем оптимальную силу удара на основе скорости
            local hitForce = 0.1 + (ballSpeed * 0.9) -- От 0.1 до 1.0
            
            -- Направление отбивания (немного вверх для лучшего контроля)
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
            local success = pcall(function()
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
            
            -- Добавляем небольшую задержку чтобы избежать спама
            wait(0.1)
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
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local character = player.Character
        local humanoidRootPart = character.HumanoidRootPart
        local humanoid = character:FindFirstChild("Humanoid")
        
        if not humanoid then return end
        
        -- Простая логика фарма - движение по карте
        local targetPosition = Vector3.new(
            math.sin(tick() * farmEfficiency) * 20,
            humanoidRootPart.Position.Y,
            math.cos(tick() * farmEfficiency) * 20
        )
        
        local distance = (targetPosition - humanoidRootPart.Position).Magnitude
        
        if distance > 3 then
            humanoid:MoveTo(targetPosition)
        end
    end)
end

-- ============ ОБРАБОТЧИКИ СОБЫТИЙ ============

-- Обработчик кнопки "Получить пароль"
getPasswordButton.MouseButton1Click:Connect(function()
    -- Показываем пароль
    continueLabel.Text = "Пароль: moster6715"
    TweenService:Create(continueLabel, TweenInfo.new(0.3), {
        TextColor3 = Color3.fromRGB(0, 255, 100)
    }):Play()
end)

-- Обработчик входа по паролю
continueButton.MouseButton1Click:Connect(function()
    if passwordBox.Text == correctPassword then
        authenticated = true
        
        -- Анимация исчезновения меню входа
        TweenService:Create(loginFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        -- Анимация исчезновения затемнения
        TweenService:Create(overlay, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        
        wait(0.5)
        overlay.Visible = false
        
        -- Показываем главную кнопку
        toggleButton.Visible = true
        TweenService:Create(toggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0, 20, 0, 100)
        }):Play()
        
        print("🗡️ Monster6715 Blade Ball Script v2.0 успешно загружен!")
    else
        -- Неправильный пароль
        passwordBox.Text = ""
        passwordBox.PlaceholderText = "Неправильный пароль!"
        
        TweenService:Create(loginFrame, TweenInfo.new(0.1), {
            Position = UDim2.new(0.5, -205, 0.5, -150)
        }):Play()
        TweenService:Create(loginFrame, TweenInfo.new(0.1), {
            Position = UDim2.new(0.5, -195, 0.5, -150)
        }):Play()
        TweenService:Create(loginFrame, TweenInfo.new(0.1), {
            Position = UDim2.new(0.5, -200, 0.5, -150)
        }):Play()
        
        wait(1)
        passwordBox.PlaceholderText = "Введите пароль..."
    end
end)

-- Показ/скрытие основного меню
local menuVisible = false
toggleButton.MouseButton1Click:Connect(function()
    if not authenticated then return end
    
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    
    if menuVisible then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = isMobile() and UDim2.new(0.9, 0, 0.7, 0) or UDim2.new(0, 400, 0, 500)
        }):Play()
    end
end)

-- Закрытие основного меню
closeButton.MouseButton1Click:Connect(function()
    menuVisible = false
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    wait(0.3)
    mainFrame.Visible = false
end)

-- Переключатель Auto Ball
ballToggle.MouseButton1Click:Connect(function()
    autoBallEnabled = not autoBallEnabled
    
    if autoBallEnabled then
        ballToggle.Text = "ВКЛ"
        ballToggle.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
        autoBall()
    else
        ballToggle.Text = "ВЫКЛ"
        ballToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        if ballConnection then
            ballConnection:Disconnect()
            ballConnection = nil
        end
    end
end)

-- Переключатель Auto Farm
farmToggle.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    
    if autoFarmEnabled then
        farmToggle.Text = "ВКЛ"
        farmToggle.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
        autoFarm()
    else
        farmToggle.Text = "ВЫКЛ"
        farmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- Ползунок скорости отбивания
local speedDragging = false
speedButton.MouseButton1Down:Connect(function()
    speedDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = false
    end
end)

speedButton.MouseMoved:Connect(function(x, y)
    if speedDragging then
        local relativeX = x - speedSlider.AbsolutePosition.X
        local percentage = math.clamp(relativeX / speedSlider.AbsoluteSize.X, 0, 1)
        
        ballSpeed = 0.1 + (percentage * 0.9) -- От 0.1 до 1.0
        speedFill.Size = UDim2.new(percentage, 0, 1, 0)
        speedLabel.Text = "Скорость отбивания: " .. math.floor(percentage * 100) .. "%"
    end
end)

-- Ползунок эффективности фарма
local farmDragging = false
farmButton.MouseButton1Down:Connect(function()
    farmDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        farmDragging = false
    end
end)

farmButton.MouseMoved:Connect(function(x, y)
    if farmDragging then
        local relativeX = x - farmSlider.AbsolutePosition.X
        local percentage = math.clamp(relativeX / farmSlider.AbsoluteSize.X, 0, 1)
        
        farmEfficiency = 0.1 + (percentage * 0.9) -- От 0.1 до 1.0
        farmFill.Size = UDim2.new(percentage, 0, 1, 0)
        farmLabel.Text = "Эффективность: " .. math.floor(percentage * 100) .. "%"
    end
end)

-- Система перетаскивания основного меню
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
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

-- Анимации наведения на кнопки
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
addHoverEffect(getPasswordButton, Color3.fromRGB(0, 140, 255), Color3.fromRGB(0, 162, 255))
addHoverEffect(continueButton, Color3.fromRGB(50, 220, 50), Color3.fromRGB(70, 200, 70))

-- Обработчик Enter в поле пароля
passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and passwordBox.Text == correctPassword then
        continueButton.MouseButton1Click:Fire()
    end
end)

print("🔐 Monster6715 Blade Ball Script v2.0 инициализирован - требуется авторизация")
