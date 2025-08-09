-- Ronix Hub Key System
-- Blade Ball Edition

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Настройки системы
local HUB_KEY = "Monster6715"
local authenticated = false
local menuVisible = false
local espEnabled = false
local espObjects = {}

-- Создание интерфейса
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RonixHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Главное меню (Key System)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Visible = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = mainFrame
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 0, 0, 10)
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.Text = "Ronix Hub Key System"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18

local keyLabel = Instance.new("TextLabel")
keyLabel.Name = "KeyLabel"
keyLabel.Parent = mainFrame
keyLabel.BackgroundTransparency = 1
keyLabel.Position = UDim2.new(0, 0, 0.2, 0)
keyLabel.Size = UDim2.new(1, 0, 0, 20)
keyLabel.Font = Enum.Font.GothamBold
keyLabel.Text = HUB_KEY
keyLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
keyLabel.TextSize = 16

-- Описание
local desc = Instance.new("TextLabel")
desc.Name = "Description"
desc.Parent = mainFrame
desc.BackgroundTransparency = 1
desc.Position = UDim2.new(0.1, 0, 0.35, 0)
desc.Size = UDim2.new(0.8, 0, 0, 40)
desc.Font = Enum.Font.Gotham
desc.Text = "How to get key?\nComplete a checkpoint to receive the key"
desc.TextColor3 = Color3.fromRGB(200, 200, 200)
desc.TextSize = 14
desc.TextWrapped = true

-- Кнопки меню
local buttons = {
    {name = "Join Discord", pos = 0.6},
    {name = "Get Key (LootLabs)", pos = 0.75},
    {name = "Get Key (Linkvertise)", pos = 0.9}
}

for _, btn in ipairs(buttons) do
    local button = Instance.new("TextButton")
    button.Name = btn.name
    button.Parent = mainFrame
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.Position = UDim2.new(0.1, 0, btn.pos, 0)
    button.Size = UDim2.new(0.8, 0, 0.1, 0)
    button.Font = Enum.Font.Gotham
    button.Text = btn.name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if btn.name == "Join Discord" then
            -- Логика для Discord
        elseif btn.name:find("LootLabs") then
            -- Логика для LootLabs
        else
            -- Логика для Linkvertise
        end
    end)
end

-- Blade Ball Menu
local bbFrame = Instance.new("Frame")
bbFrame.Name = "BladeBallMenu"
bbFrame.Parent = screenGui
bbFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
bbFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
bbFrame.Size = UDim2.new(0, 350, 0, 300)
bbFrame.Visible = false

local bbCorner = Instance.new("UICorner")
bbCorner.CornerRadius = UDim.new(0, 8)
bbCorner.Parent = bbFrame

-- Blade Ball Features
local features = {
    {name = "Auto Parry", y = 0.15, func = function() end},
    {name = "Auto Click", y = 0.25, func = function() end},
    {name = "Player ESP", y = 0.35, func = function() end},
    {name = "Ball Tracker", y = 0.45, func = function() end}
}

for _, feat in ipairs(features) do
    local frame = Instance.new("Frame")
    frame.Name = feat.name .. "Frame"
    frame.Parent = bbFrame
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0.1, 0, feat.y, 0)
    frame.Size = UDim2.new(0.8, 0, 0.1, 0)
    
    local label = Instance.new("TextLabel")
    label.Name = feat.name .. "Label"
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = feat.name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton")
    toggle.Name = feat.name .. "Toggle"
    toggle.Parent = frame
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggle.Position = UDim2.new(0.6, 0, 0.1, 0)
    toggle.Size = UDim2.new(0.4, 0, 0.8, 0)
    toggle.Font = Enum.Font.GothamBold
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 14
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 4)
    tCorner.Parent = toggle
    
    toggle.MouseButton1Click:Connect(function()
        local current = toggle.Text == "OFF"
        toggle.Text = current and "ON" or "OFF"
        toggle.BackgroundColor3 = current and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        feat.func(current)
    end)
end

-- Кнопка переключения между меню
local switchBtn = Instance.new("TextButton")
switchBtn.Name = "SwitchButton"
switchBtn.Parent = screenGui
switchBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
switchBtn.Position = UDim2.new(0, 20, 0, 20)
switchBtn.Size = UDim2.new(0, 120, 0, 40)
switchBtn.Font = Enum.Font.GothamBold
switchBtn.Text = "Blade Ball Menu"
switchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
switchBtn.TextSize = 14

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 4)
sCorner.Parent = switchBtn

switchBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    bbFrame.Visible = not bbFrame.Visible
    switchBtn.Text = mainFrame.Visible and "Blade Ball Menu" or "Key System"
end)

-- ESP функция
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if espEnabled and not highlight then
                highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(255, 80, 80)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            elseif not espEnabled and highlight then
                highlight:Destroy()
            end
        end
    end
end

-- Auto Parry функция
local function autoParry(enable)
    if enable then
        -- Логика автоотбивания
    else
        -- Отключение логики
    end
end

print("Ronix Hub Loaded | Key: "..HUB_KEY)
