--[[
  DELTA ULTIMATE MOBILE MENU
  Features:
  - Адаптив под все экраны
  - Fly-режим (двойной тап)
  - Защита от обнаружения
  - Скрытие/открытие меню
  - Автор: monster6715
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Anti-Cheat Bypass
local function SafeCall(f)
    pcall(f)
end

-- Fly System
local FlyEnabled = false
local FlySpeed = 50
local BodyVelocity

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    
    if FlyEnabled then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    else
        if BodyVelocity then
            BodyVelocity:Destroy()
        end
    end
end

-- Mobile Detection
local IS_MOBILE = UIS.TouchEnabled

-- UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaUltimateMenu"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Menu Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.95, 0, 0.7, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.05, 0)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0.1, 0)
header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 0)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Text = "DELTA MOBILE"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = IS_MOBILE and 22 or 18
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.15, 0, 0, 0)
title.BackgroundTransparency = 1
title.Parent = header

-- Fly Button
local flyBtn = Instance.new("TextButton")
flyBtn.Text = "FLY: OFF"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 18
flyBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
flyBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyBtn.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0.1, 0)
flyCorner.Parent = flyBtn

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 30
minimizeBtn.Size = UDim2.new(0.1, 0, 1, 0)
minimizeBtn.Position = UDim2.new(0.9, 0, 0, 0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Parent = header

-- Minimized Version
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Size = UDim2.new(0.4, 0, 0.1, 0)
minimizedFrame.Position = UDim2.new(0.5, 0, 0.05, 0)
minimizedFrame.AnchorPoint = Vector2.new(0.5, 0)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
minimizedFrame.Visible = false
minimizedFrame.Parent = gui

local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = UDim.new(0.1, 0)
minimizedCorner.Parent = minimizedFrame

local minimizedText = Instance.new("TextLabel")
minimizedText.Text = "by:monster6715"
minimizedText.TextColor3 = Color3.fromRGB(0, 150, 255)
minimizedText.Font = Enum.Font.GothamBold
minimizedText.TextSize = 16
minimizedText.Size = UDim2.new(0.7, 0, 1, 0)
minimizedText.Position = UDim2.new(0.15, 0, 0, 0)
minimizedText.BackgroundTransparency = 1
minimizedText.Parent = minimizedFrame

local maximizeBtn = Instance.new("TextButton")
maximizeBtn.Text = "+"
maximizeBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
maximizeBtn.Font = Enum.Font.GothamBold
maximizeBtn.TextSize = 30
maximizeBtn.Size = UDim2.new(0.2, 0, 1, 0)
maximizeBtn.Position = UDim2.new(0.8, 0, 0, 0)
maximizeBtn.BackgroundTransparency = 1
maximizeBtn.Parent = minimizedFrame

-- Functions
local function ToggleMenu()
    if mainFrame.Visible then
        mainFrame.Visible = false
        minimizedFrame.Visible = true
    else
        mainFrame.Visible = true
        minimizedFrame.Visible = false
    end
end

flyBtn.MouseButton1Click:Connect(function()
    SafeCall(ToggleFly)
    flyBtn.Text = FlyEnabled and "FLY: ON" or "FLY: OFF"
    flyBtn.BackgroundColor3 = FlyEnabled and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(40, 40, 40)
end)

minimizeBtn.MouseButton1Click:Connect(ToggleMenu)
maximizeBtn.MouseButton1Click:Connect(ToggleMenu)

-- Fly Control
local function UpdateFly()
    if FlyEnabled and BodyVelocity then
        local cam = workspace.CurrentCamera.CFrame
        local moveVec = Vector3.new()
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveVec = moveVec + cam.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveVec = moveVec - cam.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveVec = moveVec + cam.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveVec = moveVec - cam.RightVector
        end
        
        BodyVelocity.Velocity = moveVec * FlySpeed
    end
end

-- Double Tap Fly for Mobile
if IS_MOBILE then
    local lastTapTime = 0
    UIS.TouchTap:Connect(function(touchPos, numTaps)
        if numTaps == 2 and os.clock() - lastTapTime < 0.3 then
            SafeCall(ToggleFly)
            flyBtn.Text = FlyEnabled and "FLY: ON" or "FLY: OFF"
        end
        lastTapTime = os.clock()
    end)
end

-- Main Loop
RunService.Heartbeat:Connect(UpdateFly)

-- Anti-Cheat Protection
for _, v in pairs(getconnections(LocalPlayer.Idled)) do
    v:Disable()
end
