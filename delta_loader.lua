-- 📌 Улучшенное меню с размытием, проверкой ключа и загрузкой

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

-- 🎬 Эффект размытия заднего фона
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- Анимация размытия
local function TweenBlur(target)
    local step = (target - blur.Size) / 20
    for i = 1, 20 do
        blur.Size = blur.Size + step
        task.wait(0.01)
    end
end

-- === НАЧАЛЬНАЯ ЗАГРУЗКА ===
local LoadingGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local LoadingFrame = Instance.new("Frame", LoadingGui)
LoadingFrame.Size = UDim2.new(0, 300, 0, 100)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 8)

local LoadingText = Instance.new("TextLabel", LoadingFrame)
LoadingText.Size = UDim2.new(1, 0, 1, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 20
LoadingText.Text = "Loading..."

TweenBlur(20) -- размытие при загрузке
task.wait(2)
LoadingGui:Destroy()

-- === ФУНКЦИЯ СОЗДАНИЯ МЕНЮ ===
local function createMainMenu(isEmpty)
    local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    ScreenGui.IgnoreGuiInset = true

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 480, 0, 320)
    Frame.Position = UDim2.new(0.5, -240, 0.5, -160)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BackgroundTransparency = 0.15
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    -- Заголовок
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, -35, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Title.BackgroundTransparency = 0.2
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Text = isEmpty and "Main Menu" or "Ronix Hub Key System"
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

    -- Крестик для закрытия
    local CloseBtn = Instance.new("TextButton", Frame)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -32, 0, 2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    CloseBtn.MouseButton1Click:Connect(function()
        TweenBlur(0)
        ScreenGui:Destroy()
    end)

    if not isEmpty then
        -- Текст
        local Info = Instance.new("TextLabel", Frame)
        Info.Size = UDim2.new(1, -20, 0, 40)
        Info.Position = UDim2.new(0, 10, 0, 45)
        Info.BackgroundTransparency = 1
        Info.TextColor3 = Color3.fromRGB(220, 220, 220)
        Info.Font = Enum.Font.Gotham
        Info.TextSize = 15
        Info.TextWrapped = true
        Info.Text = "Complete a checkpoint to receive the key."

        -- Функция кнопок
        local function createButton(text, posY)
            local btn = Instance.new("TextButton", Frame)
            btn.Size = UDim2.new(0.9, 0, 0, 38)
            btn.Position = UDim2.new(0.05, 0, 0, posY)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.BackgroundTransparency = 0.1
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 15
            btn.Text = text
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            btn.MouseEnter:Connect(function()
                btn:TweenSize(UDim2.new(0.92, 0, 0, 40), "Out", "Quad", 0.2, true)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)
            btn.MouseLeave:Connect(function()
                btn:TweenSize(UDim2.new(0.9, 0, 0, 38), "Out", "Quad", 0.2, true)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end)
        end

        createButton("Join Discord", 95)
        createButton("Get Key (LootLabs)", 140)
        createButton("Get Key (Linkvertise)", 185)

        -- Поле для ввода ключа
        local KeyLabel = Instance.new("TextLabel", Frame)
        KeyLabel.Size = UDim2.new(1, -20, 0, 25)
        KeyLabel.Position = UDim2.new(0, 10, 0, 230)
        KeyLabel.BackgroundTransparency = 1
        KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyLabel.Font = Enum.Font.Gotham
        KeyLabel.TextSize = 14
        KeyLabel.Text = "Введите ключ:"

        local KeyBox = Instance.new("TextBox", Frame)
        KeyBox.Size = UDim2.new(0.9, 0, 0, 30)
        KeyBox.Position = UDim2.new(0.05, 0, 0, 255)
        KeyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyBox.PlaceholderText = "Введите ключ здесь"
        KeyBox.Font = Enum.Font.Gotham
        KeyBox.TextSize = 14
        Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)

        local EnterBtn = Instance.new("TextButton", Frame)
        EnterBtn.Size = UDim2.new(0.9, 0, 0, 30)
        EnterBtn.Position = UDim2.new(0.05, 0, 0, 290)
        EnterBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        EnterBtn.Text = "Проверить ключ"
        EnterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        EnterBtn.Font = Enum.Font.GothamBold
        EnterBtn.TextSize = 14
        Instance.new("UICorner", EnterBtn).CornerRadius = UDim.new(0, 6)

        EnterBtn.MouseButton1Click:Connect(function()
            if KeyBox.Text == "monster6715" then
                ScreenGui:Destroy()
                createMainMenu(true) -- пустое меню
            else
                KeyBox.Text = ""
                KeyBox.PlaceholderText = "Неверный ключ!"
            end
        end)
    end

    -- Перетаскивание (ПК + телефон)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)
    Title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
end

-- Запуск
createMainMenu(false)
