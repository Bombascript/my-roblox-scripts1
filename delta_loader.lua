-- 📌 Улучшенное меню под стиль Ronix Hub

-- Создаём GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.IgnoreGuiInset = true

-- Главное окно
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 420, 0, 260)
Frame.Position = UDim2.new(0.5, -210, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Скруглённые углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.BackgroundTransparency = 0.2
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Text = "Ronix Hub Key System"
Title.BorderSizePixel = 0
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Подзаголовок
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 40)
Info.Position = UDim2.new(0, 10, 0, 45)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.fromRGB(220, 220, 220)
Info.Font = Enum.Font.Gotham
Info.TextSize = 15
Info.TextWrapped = true
Info.Text = "Complete a checkpoint to receive the key. Lootlabs is highly recommended, there's linkvertise as well."
Info.Parent = Frame

-- Функция для кнопок
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.1
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Text = text
    btn.Parent = Frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    -- Анимация при наведении
    btn.MouseEnter:Connect(function()
        btn:TweenSize(UDim2.new(0.92, 0, 0, 40), "Out", "Quad", 0.2, true)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    btn.MouseLeave:Connect(function()
        btn:TweenSize(UDim2.new(0.9, 0, 0, 38), "Out", "Quad", 0.2, true)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    -- Действие при нажатии
    btn.MouseButton1Click:Connect(function()
        print("Нажата кнопка: " .. text)
    end)
end

-- Кнопки
createButton("Join Discord", 95)
createButton("Get Key (LootLabs)", 140)
createButton("Get Key (Linkvertise)", 185)

-- Перетаскивание окна
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
