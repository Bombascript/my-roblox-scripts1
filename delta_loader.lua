-- Monster6715 Mobile Hub v5.0
-- Адаптировано под телефон с удобным управлением

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- Основные настройки
local correctPassword = "monster6715"
local authenticated = false
local menuVisible = false
local espEnabled = false
local espObjects = {}

-- Создание интерфейса
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MonsterMobileHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Авторизация (боковое меню)
local authFrame = Instance.new("Frame")
authFrame.Name = "AuthFrame"
authFrame.Parent = screenGui
authFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
authFrame.Position = UDim2.new(0, -200, 0.5, -100)
authFrame.Size = UDim2.new(0, 180, 0, 200)
authFrame.ZIndex = 100

local authCorner = Instance.new("UICorner")
authCorner.CornerRadius = UDim.new(0, 12)
authCorner.Parent = authFrame

local authInput = Instance.new("TextBox")
authInput.Name = "AuthInput"
authInput.Parent = authFrame
authInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
authInput.Position = UDim2.new(0.5, -80, 0.3, 0)
authInput.Size = UDim2.new(0, 160, 0, 40)
authInput.Font = Enum.Font.Gotham
authInput.PlaceholderText = "Введите пароль"
authInput.Text = ""
authInput.TextColor3 = Color3.fromRGB(255, 255, 255)
authInput.TextSize = 14

local authButton = Instance.new("TextButton")
authButton.Name = "AuthButton"
authButton.Parent = authFrame
authButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
authButton.Position = UDim2.new(0.5, -70, 0.6, 0)
authButton.Size = UDim2.new(0, 140, 0, 40)
authButton.Font = Enum.Font.GothamBold
authButton.Text = "Активировать"
authButton.TextColor3 = Color3.fromRGB(255, 255, 255)
authButton.TextSize = 14

local authToggle = Instance.new("TextButton")
authToggle.Name = "AuthToggle"
authToggle.Parent = screenGui
authToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
authToggle.Position = UDim2.new(0, 10, 0.5, -25)
authToggle.Size = UDim2.new(0, 40, 0, 50)
authToggle.Font = Enum.Font.GothamBold
authToggle.Text = "🔑"
authToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
authToggle.TextSize = 18
authToggle.ZIndex = 90

-- Главное меню
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Visible = false
mainFrame.ZIndex = 10

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Заголовок с кнопками
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.ZIndex = 11

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Parent = titleBar
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "MONSTER HUB"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16

local hideButton = Instance.new("TextButton")
hideButton.Name = "HideButton"
hideButton.Parent = titleBar
hideButton.BackgroundTransparency = 1
hideButton.Position = UDim2.new(0.7, 0, 0, 0)
hideButton.Size = UDim2.new(0.15, 0, 1, 0)
hideButton.Font = Enum.Font.GothamBold
hideButton.Text = "─"
hideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hideButton.TextSize = 18

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(0.85, 0, 0, 0)
closeButton.Size = UDim2.new(0.15, 0, 1, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20

-- Кнопки режимов
local modes = {
    {name = "BladeBall", color = Color3.fromRGB(255, 80, 80)},
    {name = "99 Night", color = Color3.fromRGB(80, 80, 255)},
    {name = "Steal a Brairot", color = Color3.fromRGB(80, 255, 80)}
}

local modeButtons = {}
for i, mode in ipairs(modes) do
    local btn = Instance.new("TextButton")
    btn.Name = mode.name .. "Btn"
    btn.Parent = mainFrame
    btn.BackgroundColor3 = mode.color
    btn.Position = UDim2.new(0.1, 0, 0.15 + (i-1)*0.25, 0)
    btn.Size = UDim2.new(0.8, 0, 0.2, 0)
    btn.Font = Enum.Font.GothamBold
    btn.Text = mode.name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    modeButtons[mode.name] = btn
end

-- Меню BladeBall
local bbFrame = Instance.new("Frame")
bbFrame.Name = "BladeBallFrame"
bbFrame.Parent = screenGui
bbFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
bbFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
bbFrame.Size = UDim2.new(0, 300, 0, 400)
bbFrame.Visible = false
bbFrame.ZIndex = 20

local bbTitle = Instance.new("Frame")
bbTitle.Name = "BBTitle"
bbTitle.Parent = bbFrame
bbTitle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
bbTitle.Size = UDim2.new(1, 0, 0, 40)
bbTitle.ZIndex = 21

local bbTitleText = Instance.new("TextLabel")
bbTitleText.Name = "BBTitleText"
bbTitleText.Parent = bbTitle
bbTitleText.BackgroundTransparency = 1
bbTitleText.Size = UDim2.new(0.6, 0, 1, 0)
bbTitleText.Font = Enum.Font.GothamBold
bbTitleText.Text = "BLADE BALL"
bbTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
bbTitleText.TextSize = 16

local bbBackBtn = Instance.new("TextButton")
bbBackBtn.Name = "BBBackBtn"
bbBackBtn.Parent = bbTitle
bbBackBtn.BackgroundTransparency = 1
bbBackBtn.Position = UDim2.new(0.6, 0, 0, 0)
bbBackBtn.Size = UDim2.new(0.2, 0, 1, 0)
bbBackBtn.Font = Enum.Font.GothamBold
bbBackBtn.Text = "←"
bbBackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bbBackBtn.TextSize = 18

local bbHideBtn = Instance.new("TextButton")
bbHideBtn.Name = "BBHideBtn"
bbHideBtn.Parent = bbTitle
bbHideBtn.BackgroundTransparency = 1
bbHideBtn.Position = UDim2.new(0.8, 0, 0, 0)
bbHideBtn.Size = UDim2.new(0.2, 0, 1, 0)
bbHideBtn.Font = Enum.Font.GothamBold
bbHideBtn.Text = "─"
bbHideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bbHideBtn.TextSize = 18

-- Настройки BladeBall
local bbSettings = {
    AutoParry = {enabled = false, y = 0.15},
    AutoClick = {enabled = false, y = 0.25},
    ESP = {enabled = false, y = 0.35},
    AntiCheatBypass = {enabled = false, y = 0.45}
}

for name, setting in pairs(bbSettings) do
    local frame = Instance.new("Frame")
    frame.Name = name .. "Frame"
    frame.Parent = bbFrame
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0.1, 0, setting.y, 0)
    frame.Size = UDim2.new(0.8, 0, 0.08, 0)
    
    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton")
    toggle.Name = name .. "Toggle"
    toggle.Parent = frame
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggle.Position = UDim2.new(0.7, 0, 0.1, 0)
    toggle.Size = UDim2.new(0.3, 0, 0.8, 0)
    toggle.Font = Enum.Font.GothamBold
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
end

-- AntiCheat Label
local acLabel = Instance.new("TextLabel")
acLabel.Name = "ACLabel"
acLabel.Parent = bbFrame
acLabel.BackgroundTransparency = 1
acLabel.Position = UDim2.new(0.1, 0, 0.9, 0)
acLabel.Size = UDim2.new(0.8, 0, 0.05, 0)
acLabel.Font = Enum.Font.Gotham
acLabel.Text = "AntiCheat>by:monster"
acLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
acLabel.TextSize = 10

-- Функции ESP
local function createESP(target)
    if target == player then return end
    
    local char = target.Character
    if not char then return end
    
    local esp = Instance.new("Highlight")
    esp.Name = "ESP_" .. target.Name
    esp.Parent = char
    esp.OutlineColor = Color3.fromRGB(255, 80, 80)
    esp.FillColor = Color3.fromRGB(255, 80, 80)
    esp.FillTransparency = 0.8
    esp.OutlineTransparency = 0
    esp.Enabled = espEnabled
    
    espObjects[target.Name] = esp
end

local function updateESP()
    for _, esp in pairs(espObjects) do
        if esp then
            esp.Enabled = espEnabled
        end
    end
end

-- Автоотбивание
local autoParryConn = nil
local function startAutoParry()
    autoParryConn = RunService.Heartbeat:Connect(function()
        local ball = workspace:FindFirstChild("Ball")
        if not ball then return end
        
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local dist = (ball.Position - root.Position).Magnitude
        if dist < 20 then
            local args = {
                [1] = 0.5,
                [2] = CFrame.new(root.Position, ball.Position),
                [3] = {ball, ball.Position}
            }
            
            pcall(function()
                if ReplicatedStorage:FindFirstChild("Remotes") then
                    local remotes = ReplicatedStorage.Remotes
                    if remotes:FindFirstChild("ParryAttempt") then
                        remotes.ParryAttempt:FireServer(unpack(args))
                    elseif remotes:FindFirstChild("Parry") then
                        remotes.Parry:FireServer(unpack(args))
                    end
                end
            end)
        end
    end)
end

-- Обработчики событий
authButton.MouseButton1Click:Connect(function()
    if authInput.Text == correctPassword then
        authenticated = true
        TweenService:Create(authFrame, TweenInfo.new(0.3), {
            Position = UDim2.new(0, -200, 0.5, -100)
        }):Play()
    else
        authInput.Text = ""
        authInput.PlaceholderText = "Неверный пароль!"
        task.wait(1)
        authInput.PlaceholderText = "Введите пароль"
    end
end)

authToggle.MouseButton1Click:Connect(function()
    TweenService:Create(authFrame, TweenInfo.new(0.3), {
        Position = UDim2.new(0, 10, 0.5, -100)
    }):Play()
end)

-- Открытие главного меню
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Parent = screenGui
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
toggleBtn.Position = UDim2.new(0, 10, 0.1, 0)
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Text = "MENU"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Visible = authenticated
toggleBtn.ZIndex = 5

toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
end)

-- Выбор режима
modeButtons["BladeBall"].MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    bbFrame.Visible = true
end)

-- Назад в главное меню
bbBackBtn.MouseButton1Click:Connect(function()
    bbFrame.Visible = false
    mainFrame.Visible = true
end)

-- Скрытие меню
hideButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

bbHideBtn.MouseButton1Click:Connect(function()
    bbFrame.Visible = false
end)

-- Закрытие меню
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleBtn.Visible = false
end)

-- Переключение настроек BladeBall
for name, _ in pairs(bbSettings) do
    local toggle = bbFrame:FindFirstChild(name .. "Frame"):FindFirstChild(name .. "Toggle")
    if toggle then
        toggle.MouseButton1Click:Connect(function()
            bbSettings[name].enabled = not bbSettings[name].enabled
            toggle.Text = bbSettings[name].enabled and "ON" or "OFF"
            toggle.BackgroundColor3 = bbSettings[name].enabled and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(60, 60, 70)
            
            if name == "AutoParry" then
                if bbSettings[name].enabled then
                    startAutoParry()
                elseif autoParryConn then
                    autoParryConn:Disconnect()
                end
            elseif name == "ESP" then
                espEnabled = bbSettings[name].enabled
                updateESP()
            end
        end)
    end
end

-- Инициализация ESP для игроков
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if espEnabled then
            createESP(plr)
        end
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player and plr.Character then
        createESP(plr)
    end
end

print("Monster Mobile Hub v5.0 loaded | Password: monster6715")
