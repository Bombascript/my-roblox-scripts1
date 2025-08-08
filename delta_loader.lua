-- Современное GUI для Roblox Delta
-- Создано с красивым дизайном и мобильной адаптацией

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создание основного ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Monster6715ModernGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Функция для создания эффекта свечения
local function createGlow(parent, color, size)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Parent = parent
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    glow.ImageColor3 = color or Color3.fromRGB(0, 162, 255)
    glow.ImageTransparency = 0.8
    glow.Size = size or UDim2.new(1.2, 0, 1.2, 0)
    glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
    glow.ZIndex = parent.ZIndex - 1
    return glow
end

-- Создание экрана загрузки
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingScreen"
loadingFrame.Parent = screenGui
loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.ZIndex = 10

-- Градиентный фон для загрузки
local loadingGradient = Instance.new("UIGradient")
loadingGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
loadingGradient.Rotation = 45
loadingGradient.Parent = loadingFrame

-- Логотип Delta
local logo = Instance.new("TextLabel")
logo.Name = "Logo"
logo.Parent = loadingFrame
logo.BackgroundTransparency = 1
logo.Position = UDim2.new(0.5, 0, 0.35, 0)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.Size = UDim2.new(0, 200, 0, 60)
logo.Font = Enum.Font.GothamBold
logo.Text = "MONSTER6715"
logo.TextColor3 = Color3.fromRGB(0, 162, 255)
logo.TextSize = 48
logo.TextTransparency = 1
logo.ZIndex = 11

-- Анимация появления логотипа
local logoTween = TweenService:Create(logo, TweenInfo.new(1, Enum.EasingStyle.Back), {TextTransparency = 0})
logoTween:Play()

-- Прогресс бар
local progressBarBg = Instance.new("Frame")
progressBarBg.Name = "ProgressBarBackground"
progressBarBg.Parent = loadingFrame
progressBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
progressBarBg.BorderSizePixel = 0
progressBarBg.Position = UDim2.new(0.5, 0, 0.6, 0)
progressBarBg.AnchorPoint = Vector2.new(0.5, 0.5)
progressBarBg.Size = UDim2.new(0, 300, 0, 4)
progressBarBg.ZIndex = 11

local progressBarBgCorner = Instance.new("UICorner")
progressBarBgCorner.CornerRadius = UDim.new(0, 8)
progressBarBgCorner.Parent = progressBarBg

local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Parent = progressBarBg
progressBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
progressBar.BorderSizePixel = 0
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.ZIndex = 12

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 8)
progressBarCorner.Parent = progressBar

-- Градиент для прогресс бара
local progressGradient = Instance.new("UIGradient")
progressGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 162, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 162))
}
progressGradient.Parent = progressBar

-- Текст загрузки
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Parent = loadingFrame
loadingText.BackgroundTransparency = 1
loadingText.Position = UDim2.new(0.5, 0, 0.7, 0)
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.Size = UDim2.new(0, 200, 0, 30)
loadingText.Font = Enum.Font.Gotham
loadingText.Text = "Загрузка..."
loadingText.TextColor3 = Color3.fromRGB(150, 150, 160)
loadingText.TextSize = 16
loadingText.ZIndex = 11

-- Анимация загрузки
local function animateLoading()
    local loadingSteps = {"Загрузка...", "Инициализация...", "Подготовка интерфейса...", "Завершение..."}
    for i = 1, #loadingSteps do
        loadingText.Text = loadingSteps[i]
        local progressTween = TweenService:Create(progressBar, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
            Size = UDim2.new(i / #loadingSteps, 0, 1, 0)
        })
        progressTween:Play()
        wait(1)
    end
end

-- Запуск анимации загрузки
spawn(animateLoading)

-- Создание основного меню (появится после загрузки)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 5

-- Адаптация для мобильных устройств
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

if isMobile() then
    -- Размеры для телефона
    mainFrame.Size = UDim2.new(0.95, 0, 0.4, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
else
    -- Размеры для ПК
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end

mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Скругленные углы
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Градиентный фон меню
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
mainGradient.Rotation = 135
mainGradient.Parent = mainFrame

-- Эффект стекла (блюр эффект)
local blurEffect = Instance.new("Frame")
blurEffect.Name = "BlurEffect"
blurEffect.Parent = mainFrame
blurEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
blurEffect.BackgroundTransparency = 0.95
blurEffect.Size = UDim2.new(1, 0, 1, 0)
blurEffect.ZIndex = mainFrame.ZIndex + 1

local blurCorner = Instance.new("UICorner")
blurCorner.CornerRadius = UDim.new(0, 12)
blurCorner.Parent = blurEffect

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

-- Делаем так, чтобы скругление было только сверху
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
titleText.Text = "Monster6715 Menu"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = titleBar.ZIndex + 1

-- Кнопка закрытия (крестик)
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
closeButton.TextSize = 20
closeButton.ZIndex = titleBar.ZIndex + 1

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Анимация при наведении на кнопку закрытия
closeButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        BackgroundTransparency = 0
    })
    hoverTween:Play()
end)

closeButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        BackgroundTransparency = 0.2
    })
    leaveTween:Play()
end)

-- Функция закрытия меню
closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Система перетаскивания меню
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

-- Содержимое меню (пустое, но с красивым оформлением)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Parent = mainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.ZIndex = mainFrame.ZIndex + 1

-- Декоративный элемент
local decorLine = Instance.new("Frame")
decorLine.Name = "DecorativeLine"
decorLine.Parent = contentFrame
decorLine.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
decorLine.BackgroundTransparency = 0.7
decorLine.BorderSizePixel = 0
decorLine.Position = UDim2.new(0, 20, 0, 20)
decorLine.Size = UDim2.new(1, -40, 0, 2)
decorLine.ZIndex = contentFrame.ZIndex + 1

-- Текст-заглушка для демонстрации
local placeholderText = Instance.new("TextLabel")
placeholderText.Name = "Placeholder"
placeholderText.Parent = contentFrame
placeholderText.BackgroundTransparency = 1
placeholderText.Position = UDim2.new(0, 20, 0, 40)
placeholderText.Size = UDim2.new(1, -40, 0, 50)
placeholderText.Font = Enum.Font.Gotham
placeholderText.Text = "Современное меню готово!\nЗдесь можно добавить ваш контент."
placeholderText.TextColor3 = Color3.fromRGB(150, 150, 160)
placeholderText.TextSize = 14
placeholderText.TextWrapped = true
placeholderText.TextYAlignment = Enum.TextYAlignment.Top
placeholderText.ZIndex = contentFrame.ZIndex + 1

-- Завершение загрузки и показ меню
wait(4.2) -- Ждем завершения загрузки

-- Скрытие экрана загрузки с задержкой для корректного отображения
local function showMainMenu()
    loadingFrame.Visible = false
    
    -- Показ основного меню
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    
    local targetSize = isMobile() and UDim2.new(0.95, 0, 0.4, 0) or UDim2.new(0, 400, 0, 300)
    local showMenuTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = targetSize,
        BackgroundTransparency = 0.1
    })
    showMenuTween:Play()
end

-- Анимация скрытия загрузки
local hideLoadingTween = TweenService:Create(loadingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 1
})

-- Скрытие элементов загрузки
for _, element in ipairs({logo, progressBarBg, loadingText}) do
    TweenService:Create(element, TweenInfo.new(0.4), {
        TextTransparency = 1,
        BackgroundTransparency = 1
    }):Play()
end

hideLoadingTween:Play()
hideLoadingTween.Completed:Connect(showMainMenu)

print("Monster6715 Modern GUI загружен успешно!")
