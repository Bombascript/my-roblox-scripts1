-- DELTA LOADER v4 (Modern UI)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- CONFIG --
local LOAD_TIME = 2.5
local ACCENT_COLOR = Color3.fromRGB(0, 255, 187) -- Неоново-голубой
local MENU_SIZE = UDim2.new(0, 400, 0, 500) -- Увеличенный размер

-- MAIN GUI --
local gui = Instance.new("ScreenGui")
gui.Name = "MonsterLoader"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- LOADING SCREEN --
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(1, 0, 1, 0)
loadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
loadFrame.Parent = gui

-- ANIMATED LOGO --
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Image = "rbxassetid://14282392178" -- Замените на свой ID изображения
logo.Size = UDim2.new(0, 150, 0, 150)
logo.Position = UDim2.new(0.5, -75, 0.4, -75)
logo.BackgroundTransparency = 1
logo.Parent = loadFrame

-- LOADING TEXT --
local loadText = Instance.new("TextLabel")
loadText.Text = "Loading..."
loadText.Font = Enum.Font.GothamBold
loadText.TextSize = 24
loadText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadText.Size = UDim2.new(1, 0, 0, 30)
loadText.Position = UDim2.new(0, 0, 0.6, 0)
loadText.BackgroundTransparency = 1
loadText.Parent = loadFrame

-- CREDIT TEXT --
local credit = Instance.new("TextLabel")
credit.Text = "Script By: monster6715"
credit.Font = Enum.Font.Gotham
credit.TextSize = 18
credit.TextColor3 = Color3.fromRGB(150, 150, 150)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 0.9, 0)
credit.BackgroundTransparency = 1
credit.Parent = loadFrame

-- LOADING ANIMATION --
local spinConnection
spinConnection = RunService.RenderStepped:Connect(function(dt)
    logo.Rotation = logo.Rotation + (dt * 120)
end)

-- LOADING COMPLETION --
task.delay(LOAD_TIME, function()
    spinConnection:Disconnect()
    
    -- Fade out animation
    TweenService:Create(loadFrame, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
    for _, v in ipairs(loadFrame:GetChildren()) do
        if v:IsA("GuiObject") then
            TweenService:Create(v, TweenInfo.new(0.7), {Transparency = 1}):Play()
        end
    end
    
    task.wait(0.7)
    loadFrame:Destroy()
    CreateModernMenu()
end)

-- MODERN MENU --
function CreateModernMenu()
    local menuFrame = Instance.new("Frame")
    menuFrame.Size = MENU_SIZE
    menuFrame.Position = UDim2.new(0.5, -MENU_SIZE.X.Offset/2, 0.5, -MENU_SIZE.Y.Offset/2)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    menuFrame.BorderColor3 = ACCENT_COLOR
    menuFrame.BorderSizePixel = 1
    menuFrame.ClipsDescendants = true
    menuFrame.Parent = gui

    -- TOP BAR --
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = ACCENT_COLOR
    topBar.BorderSizePixel = 0
    topBar.Parent = menuFrame

    local title = Instance.new("TextLabel")
    title.Text = "MONSTER MENU"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Size = UDim2.new(1, -10, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    -- CLOSE BUTTON --
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = topBar

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- CONTENT FRAME --
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 5
    content.ScrollBarImageColor3 = ACCENT_COLOR
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = menuFrame

    -- EXAMPLE BUTTON --
    local btn = Instance.new("TextButton")
    btn.Text = "Example Feature"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Parent = content

    -- DRAGGABLE --
    local dragging, dragInput, dragStart, startPos

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
