-- Современное GUI Monster6715 (только меню)
-- Без загрузки - сразу рабочее меню

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создание основного ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Monster6715ModernGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Создание основного меню
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
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

-- Эффект стекла
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

-- Делаем скругление только сверху
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

-- Анимация кнопки закрытия
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        BackgroundTransparency = 0
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        BackgroundTransparency = 0.2
    }):Play()
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

-- Содержимое меню
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Parent = mainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.ZIndex = mainFrame.ZIndex + 1

-- Декоративная линия
local decorLine = Instance.new("Frame")
decorLine.Name = "DecorativeLine"
decorLine.Parent = contentFrame
decorLine.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
decorLine.BackgroundTransparency = 0.7
decorLine.BorderSizePixel = 0
decorLine.Position = UDim2.new(0, 20, 0, 20)
decorLine.Size = UDim2.new(1, -40, 0, 2)
decorLine.ZIndex = contentFrame.ZIndex + 1

-- Текст в меню
local placeholderText = Instance.new("TextLabel")
placeholderText.Name = "MenuText"
placeholderText.Parent = contentFrame
placeholderText.BackgroundTransparency = 1
placeholderText.Position = UDim2.new(0, 20, 0, 40)
placeholderText.Size = UDim2.new(1, -40, 0, 80)
placeholderText.Font = Enum.Font.Gotham
placeholderText.Text = "🎮 Monster6715 Menu\n\n✨ Современное меню готово!\nЗдесь можно добавить ваши функции."
placeholderText.TextColor3 = Color3.fromRGB(150, 150, 160)
placeholderText.TextSize = 14
placeholderText.TextWrapped = true
placeholderText.TextYAlignment = Enum.TextYAlignment.Top
placeholderText.ZIndex = contentFrame.ZIndex + 1

-- Анимация появления меню
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundTransparency = 1

wait(0.1) -- Небольшая задержка для загрузки

local showTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = isMobile() and UDim2.new(0.95, 0, 0.4, 0) or UDim2.new(0, 400, 0, 300),
    BackgroundTransparency = 0.1
})
showTween:Play()

print("Monster6715 Menu загружен успешно!")
