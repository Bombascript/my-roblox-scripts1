-- DELTA LOADER v2 (Modern UI)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Config
local LOAD_TIME = 3 -- seconds
local MENU_SIZE = UDim2.new(0, 350, 0, 450)
local ACCENT_COLOR = Color3.fromRGB(0, 168, 255) -- Delta blue

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaLoader"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Loading Screen
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(1, 0, 1, 0)
loadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadFrame.Parent = gui

-- Animated Circle
local circle = Instance.new("ImageLabel")
circle.Name = "LoaderCircle"
circle.Image = "rbxassetid://3570695787"
circle.Size = UDim2.new(0, 80, 0, 80)
circle.Position = UDim2.new(0.5, -40, 0.5, -40)
circle.BackgroundTransparency = 1
circle.ImageColor3 = ACCENT_COLOR
circle.Parent = loadFrame

-- Loading Text
local loadText = Instance.new("TextLabel")
loadText.Text = "DELTA // LOADING"
loadText.Font = Enum.Font.Code
loadText.TextSize = 18
loadText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadText.Size = UDim2.new(1, 0, 0, 30)
loadText.Position = UDim2.new(0, 0, 0.55, 0)
loadText.BackgroundTransparency = 1
loadText.Parent = loadFrame

-- Progress Bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0.4, 0, 0, 4)
progressBar.Position = UDim2.new(0.3, 0, 0.6, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressBar.BorderSizePixel = 0
progressBar.Parent = loadFrame

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = ACCENT_COLOR
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar

-- Rotation Animation
local spinConnection
spinConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
    circle.Rotation = circle.Rotation + (dt * 200)
end)

-- Loading Simulation
coroutine.wrap(function()
    for i = 1, 100 do
        progressFill.Size = UDim2.new(i/100, 0, 1, 0)
        task.wait(LOAD_TIME/100)
    end
    
    spinConnection:Disconnect()
    
    -- Fade Out Animation
    TweenService:Create(loadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    for _, v in ipairs(loadFrame:GetChildren()) do
        if v:IsA("GuiObject") then
            TweenService:Create(v, TweenInfo.new(0.5), {Transparency = 1}):Play()
        end
    end
    
    task.wait(0.5)
    loadFrame:Destroy()
    
    -- Create Empty Menu
    CreateMenu()
end)()

function CreateMenu()
    local menuFrame = Instance.new("Frame")
    menuFrame.Size = MENU_SIZE
    menuFrame.Position = UDim2.new(0.5, -MENU_SIZE.X.Offset/2, 0.5, -MENU_SIZE.Y.Offset/2)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    menuFrame.ClipsDescendants = true
    menuFrame.Parent = gui
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = ACCENT_COLOR
    topBar.BorderSizePixel = 0
    topBar.Parent = menuFrame
    
    local title = Instance.new("TextLabel")
    title.Text = "DELTA MENU"
    title.Font = Enum.Font.Code
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Size = UDim2.new(1, -10, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.Code
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = topBar
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Make draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = menuFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end
