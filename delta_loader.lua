-- DELTA MOBILE LOADER by monster6715
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Конфигурация
local ACCENT_COLOR = Color3.fromRGB(0, 255, 187)
local CORNER_RADIUS = UDim.new(0.2, 0) -- Сильное скругление углов

-- Определяем мобильное устройство
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Главный интерфейс
local gui = Instance.new("ScreenGui")
gui.Name = "MonsterMobileUI"
gui.ResetOnSpawn = false
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Функция создания скругленных рамок
local function createRoundedFrame(parent, size, position)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = CORNER_RADIUS
    corner.Parent = frame
    
    frame.Parent = parent
    return frame
end

-- Загрузочный экран
local loadFrame = createRoundedFrame(gui, UDim2.new(0.9, 0, 0.2, 0), UDim2.new(0.5, 0, 0.5, 0))
loadFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local loadText = Instance.new("TextLabel")
loadText.Text = "Loading..."
loadText.TextColor3 = ACCENT_COLOR
loadText.Font = Enum.Font.GothamBold
loadText.TextSize = IS_MOBILE and 24 or 20
loadText.Size = UDim2.new(1, 0, 0.5, 0)
loadText.Position = UDim2.new(0, 0, 0.25, 0)
loadText.BackgroundTransparency = 1
loadText.Parent = loadFrame

-- Анимация загрузки
task.spawn(function()
    for i = 1, 30 do
        loadText.Text = "Loading" .. string.rep(".", i % 4)
        task.wait(0.1)
    end
    
    TweenService:Create(loadFrame, TweenInfo.new(0.5), {Size = UDim2.new(0.95, 0, 0.7, 0)}):Play()
    task.wait(0.5)
    createMainMenu()
    loadFrame:Destroy()
end)

-- Главное меню
local mainMenu, minimizeBtn
local isMinimized = false

function createMainMenu()
    -- Основной контейнер
    mainMenu = createRoundedFrame(gui, UDim2.new(0.95, 0, 0.7, 0), UDim2.new(0.5, 0, 0.5, 0))
    mainMenu.AnchorPoint = Vector2.new(0.5, 0.5)
    mainMenu.ClipsDescendants = true

    -- Верхняя панель
    local topBar = createRoundedFrame(mainMenu, UDim2.new(1, 0, 0.1, 0), UDim2.new(0, 0, 0, 0))
    topBar.BackgroundColor3 = ACCENT_COLOR

    local title = Instance.new("TextLabel")
    title.Text = "MONSTER MENU"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = IS_MOBILE and 22 or 18
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0.15, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Parent = topBar

    -- Кнопка сворачивания
    minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 30
    minimizeBtn.Size = UDim2.new(0.1, 0, 1, 0)
    minimizeBtn.Position = UDim2.new(0.9, 0, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Parent = topBar

    -- Контент
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 0.85, -10)
    content.Position = UDim2.new(0, 5, 0.15, 5)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 5
    content.ScrollBarImageColor3 = ACCENT_COLOR
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = mainMenu

    -- Пример кнопки
    local btn = Instance.new("TextButton")
    btn.Text = "Example Button"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = CORNER_RADIUS
    corner.Parent = btn

    -- Минимизированная версия
    local minimizedFrame = createRoundedFrame(gui, UDim2.new(0.4, 0, 0.1, 0), UDim2.new(0.5, 0, 0.05, 0))
    minimizedFrame.AnchorPoint = Vector2.new(0.5, 0)
    minimizedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    minimizedFrame.Visible = false

    local creditText = Instance.new("TextLabel")
    creditText.Text = "by:monster6715"
    creditText.TextColor3 = ACCENT_COLOR
    creditText.Font = Enum.Font.GothamBold
    creditText.TextSize = 16
    creditText.Size = UDim2.new(0.7, 0, 1, 0)
    creditText.Position = UDim2.new(0.15, 0, 0, 0)
    creditText.BackgroundTransparency = 1
    creditText.Parent = minimizedFrame

    local maximizeBtn = Instance.new("TextButton")
    maximizeBtn.Text = "+"
    maximizeBtn.TextColor3 = ACCENT_COLOR
    maximizeBtn.Font = Enum.Font.GothamBold
    maximizeBtn.TextSize = 30
    maximizeBtn.Size = UDim2.new(0.2, 0, 1, 0)
    maximizeBtn.Position = UDim2.new(0.8, 0, 0, 0)
    maximizeBtn.BackgroundTransparency = 1
    maximizeBtn.Parent = minimizedFrame

    -- Логика сворачивания/разворачивания
    local function toggleMenu()
        if isMinimized then
            -- Разворачиваем
            minimizedFrame.Visible = false
            mainMenu.Visible = true
            minimizeBtn.Text = "-"
            isMinimized = false
        else
            -- Сворачиваем
            mainMenu.Visible = false
            minimizedFrame.Visible = true
            minimizeBtn.Text = "+"
            isMinimized = true
        end
    end

    minimizeBtn.MouseButton1Click: toggleMenu
    maximizeBtn.MouseButton1Click: toggleMenu

    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1, 0, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 26
    closeBtn.Size = UDim2.new(0.1, 0, 1, 0)
    closeBtn.Position = UDim2.new(0, 0, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = topBar

    closeBtn.MouseButton1Click:Connect(function()
        local confirmFrame = createRoundedFrame(gui, UDim2.new(0.6, 0, 0.25, 0), UDim2.new(0.5, 0, 0.5, 0))
        confirmFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        confirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        confirmFrame.ZIndex = 10

        local confirmText = Instance.new("TextLabel")
        confirmText.Text = "Точно хотите закрыть?"
        confirmText.TextColor3 = Color3.new(1, 1, 1)
        confirmText.Font = Enum.Font.Gotham
        confirmText.TextSize = 18
        confirmText.Size = UDim2.new(1, 0, 0.5, 0)
        confirmText.Position = UDim2.new(0, 0, 0.1, 0)
        confirmText.BackgroundTransparency = 1
        confirmText.Parent = confirmFrame

        local btnYes = Instance.new("TextButton")
        btnYes.Text = "Да"
        btnYes.TextColor3 = Color3.new(1, 1, 1)
        btnYes.Font = Enum.Font.GothamBold
        btnYes.TextSize = 18
        btnYes.Size = UDim2.new(0.4, 0, 0.3, 0)
        btnYes.Position = UDim2.new(0.05, 0, 0.6, 0)
        btnYes.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        btnYes.Parent = confirmFrame

        local cornerYes = Instance.new("UICorner")
        cornerYes.CornerRadius = CORNER_RADIUS
        cornerYes.Parent = btnYes

        local btnNo = Instance.new("TextButton")
        btnNo.Text = "Нет"
        btnNo.TextColor3 = Color3.new(1, 1, 1)
        btnNo.Font = Enum.Font.GothamBold
        btnNo.TextSize = 18
        btnNo.Size = UDim2.new(0.4, 0, 0.3, 0)
        btnNo.Position = UDim2.new(0.55, 0, 0.6, 0)
        btnNo.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        btnNo.Parent = confirmFrame

        local cornerNo = Instance.new("UICorner")
        cornerNo.CornerRadius = CORNER_RADIUS
        cornerNo.Parent = btnNo

        btnYes.MouseButton1Click:Connect(function()
            gui:Destroy()
        end)

        btnNo.MouseButton1Click:Connect(function()
            confirmFrame:Destroy()
        end)
    end)
end
