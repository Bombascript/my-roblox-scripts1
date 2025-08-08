-- Monster6715 Blade Ball Script v3.0 - ESP Edition
-- Современный интерфейс с ESP функциями и улучшенным автоотбиванием

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- Переменные
local autoBallEnabled = false
local espEnabled = false
local boxESPEnabled = false
local boxFillESPEnabled = false
local nameESPEnabled = false
local healthESPEnabled = false
local ballSpeed = 0.5
local ballConnection = nil
local espConnections = {}
local espObjects = {}

-- Правильный пароль
local correctPassword = "monster6715"
local authenticated = false

-- Создание основного ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Monster6715BladeballGUI_v3"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ============ СИСТЕМА ВХОДА ============

local overlay = Instance.new("Frame")
overlay.Name = "LoginOverlay"
overlay.Parent = screenGui
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0
overlay.BorderSizePixel = 0
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.ZIndex = 1000

local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Parent = overlay
loadingFrame.BackgroundTransparency = 1
loadingFrame.Size = UDim2.new(0, 300, 0, 100)
loadingFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
loadingFrame.ZIndex = overlay.ZIndex + 1

local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Parent = loadingFrame
loadingText.BackgroundTransparency = 1
loadingText.Size = UDim2.new(1, 0, 0.5, 0)
loadingText.Position = UDim2.new(0, 0, 0, 0)
loadingText.Font = Enum.Font.GothamBold
loadingText.Text = "🗡️ Monster6715 Blade Ball v3.0"
loadingText.TextColor3 = Color3.fromRGB(255, 100, 100)
loadingText.TextSize = 24
loadingText.ZIndex = loadingFrame.ZIndex + 1

local loadingBar = Instance.new("Frame")
loadingBar.Name = "LoadingBar"
loadingBar.Parent = loadingFrame
loadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
loadingBar.BorderSizePixel = 0
loadingBar.Size = UDim2.new(1, 0, 0, 8)
loadingBar.Position = UDim2.new(0, 0, 0.7, 0)
loadingBar.ZIndex = loadingFrame.ZIndex + 1

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 4)
barCorner.Parent = loadingBar

local loadingFill = Instance.new("Frame")
loadingFill.Name = "Fill"
loadingFill.Parent = loadingBar
loadingFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
loadingFill.BorderSizePixel = 0
loadingFill.Size = UDim2.new(0, 0, 1, 0)
loadingFill.ZIndex = loadingBar.ZIndex + 1

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = loadingFill

local loadingTween = TweenService:Create(loadingFill, TweenInfo.new(2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)})
loadingTween:Play()

local loginFrame = Instance.new("Frame")
loginFrame.Name = "LoginFrame"
loginFrame.Parent = overlay
loginFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
loginFrame.BackgroundTransparency = 0
loginFrame.BorderSizePixel = 0
loginFrame.Size = UDim2.new(0, 400, 0, 300)
loginFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
loginFrame.ZIndex = overlay.ZIndex + 1
loginFrame.Visible = false

local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 8)
loginFrame.Parent = loginFrame

local loginTitle = Instance.new("TextLabel")
loginTitle.Name = "LoginTitle"
loginTitle.Parent = loginFrame
loginTitle.BackgroundTransparency = 1
loginTitle.Size = UDim2.new(1, 0, 0, 50)
loginTitle.Position = UDim2.new(0, 0, 0, 20)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.Text = "🔐 Введите пароль"
loginTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loginTitle.TextSize = 18
loginTitle.ZIndex = loginFrame.ZIndex + 1

local passwordBox = Instance.new("TextBox")
passwordBox.Name = "PasswordBox"
passwordBox.Parent = loginFrame
passwordBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
passwordBox.BorderSizePixel = 0
passwordBox.Size = UDim2.new(0, 250, 0, 40)
passwordBox.Position = UDim2.new(0.5, -125, 0, 120)
passwordBox.Font = Enum.Font.Gotham
passwordBox.PlaceholderText = "Введите пароль..."
passwordBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
passwordBox.Text = ""
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.TextSize = 14
passwordBox.ZIndex = loginFrame.ZIndex + 1

local passwordCorner = Instance.new("UICorner")
passwordCorner.CornerRadius = UDim.new(0, 6)
passwordCorner.Parent = passwordBox

local continueButton = Instance.new("TextButton")
continueButton.Name = "ContinueButton"
continueButton.Parent = loginFrame
continueButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
continueButton.BorderSizePixel = 0
continueButton.Size = UDim2.new(0, 120, 0, 35)
continueButton.Position = UDim2.new(0.5, -60, 0, 200)
continueButton.Font = Enum.Font.GothamBold
continueButton.Text = "Продолжить"
continueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
continueButton.TextSize = 14
continueButton.ZIndex = loginFrame.ZIndex + 1

local continueCorner = Instance.new("UICorner")
continueCorner.CornerRadius = UDim.new(0, 6)
continueCorner.Parent = continueButton

-- ============ ОСНОВНОЕ МЕНЮ ============

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.ZIndex = 5
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.ZIndex = mainFrame.ZIndex + 1

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleBarBottom = Instance.new("Frame")
titleBarBottom.Parent = titleBar
titleBarBottom.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
titleBarBottom.BorderSizePixel = 0
titleBarBottom.Position = UDim2.new(0, 0, 0.7, 0)
titleBarBottom.Size = UDim2.new(1, 0, 0.3, 0)
titleBarBottom.ZIndex = titleBar.ZIndex

local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Parent = titleBar
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "Rise | Rivals"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = titleBar.ZIndex + 1

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = titleBar
minimizeButton.BackgroundTransparency = 1
minimizeButton.Position = UDim2.new(1, -70, 0, 0)
minimizeButton.Size = UDim2.new(0, 35, 1, 0)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "—"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.ZIndex = titleBar.ZIndex + 1

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Size = UDim2.new(0, 35, 1, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.ZIndex = titleBar.ZIndex + 1

-- Боковая панель навигации
local sideBar = Instance.new("Frame")
sideBar.Name = "SideBar"
sideBar.Parent = mainFrame
sideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
sideBar.BorderSizePixel = 0
sideBar.Position = UDim2.new(0, 0, 0, 35)
sideBar.Size = UDim2.new(0, 150, 1, -35)
sideBar.ZIndex = mainFrame.ZIndex + 1

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 0)
sideCorner.Parent = sideBar

-- Кнопки навигации
local navButtons = {
    {name = "Home", text = "Home", icon = "🏠"},
    {name = "Combat", text = "Combat", icon = "⚔️"},
    {name = "Visual", text = "Visual", icon = "👁️"},
    {name = "Player", text = "Player", icon = "👤"},
    {name = "Misc", text = "Misc", icon = "⚙️"}
}

local activeTab = "Visual"
local tabFrames = {}
local navButtonObjects = {}

for i, buttonData in ipairs(navButtons) do
    local navButton = Instance.new("TextButton")
    navButton.Name = buttonData.name .. "Button"
    navButton.Parent = sideBar
    navButton.BackgroundColor3 = buttonData.name == "Visual" and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(25, 25, 30)
    navButton.BorderSizePixel = 0
    navButton.Position = UDim2.new(0, 10, 0, 10 + (i-1) * 45)
    navButton.Size = UDim2.new(1, -20, 0, 35)
    navButton.Font = Enum.Font.Gotham
    navButton.Text = "  " .. buttonData.icon .. "  " .. buttonData.text
    navButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    navButton.TextSize = 14
    navButton.TextXAlignment = Enum.TextXAlignment.Left
    navButton.ZIndex = sideBar.ZIndex + 1
    
    local navCorner = Instance.new("UICorner")
    navCorner.CornerRadius = UDim.new(0, 6)
    navCorner.Parent = navButton
    
    navButtonObjects[buttonData.name] = navButton
end

-- Основная область контента
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Parent = mainFrame
contentArea.BackgroundTransparency = 1
contentArea.Position = UDim2.new(0, 150, 0, 35)
contentArea.Size = UDim2.new(1, -150, 1, -35)
contentArea.ZIndex = mainFrame.ZIndex + 1

-- ============ VISUAL TAB ============

local visualFrame = Instance.new("Frame")
visualFrame.Name = "VisualFrame"
visualFrame.Parent = contentArea
visualFrame.BackgroundTransparency = 1
visualFrame.Size = UDim2.new(1, 0, 1, 0)
visualFrame.ZIndex = contentArea.ZIndex + 1

local visualTitle = Instance.new("TextLabel")
visualTitle.Name = "VisualTitle"
visualTitle.Parent = visualFrame
visualTitle.BackgroundTransparency = 1
visualTitle.Position = UDim2.new(0, 20, 0, 20)
visualTitle.Size = UDim2.new(1, -40, 0, 30)
visualTitle.Font = Enum.Font.GothamBold
visualTitle.Text = "Visual"
visualTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
visualTitle.TextSize = 20
visualTitle.TextXAlignment = Enum.TextXAlignment.Left
visualTitle.ZIndex = visualFrame.ZIndex + 1

local visualSubtitle = Instance.new("TextLabel")
visualSubtitle.Name = "VisualSubtitle"
visualSubtitle.Parent = visualFrame
visualSubtitle.BackgroundTransparency = 1
visualSubtitle.Position = UDim2.new(0, 20, 0, 45)
visualSubtitle.Size = UDim2.new(1, -40, 0, 20)
visualSubtitle.Font = Enum.Font.Gotham
visualSubtitle.Text = "Esp and stuff"
visualSubtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
visualSubtitle.TextSize = 12
visualSubtitle.TextXAlignment = Enum.TextXAlignment.Left
visualTitle.ZIndex = visualFrame.ZIndex + 1

local espSection = Instance.new("TextLabel")
espSection.Name = "ESPSection"
espSection.Parent = visualFrame
espSection.BackgroundTransparency = 1
espSection.Position = UDim2.new(0, 20, 0, 85)
espSection.Size = UDim2.new(1, -40, 0, 25)
espSection.Font = Enum.Font.GothamBold
espSection.Text = "ESP & ESP Settings"
espSection.TextColor3 = Color3.fromRGB(255, 255, 255)
espSection.TextSize = 16
espSection.TextXAlignment = Enum.TextXAlignment.Left
espSection.ZIndex = visualFrame.ZIndex + 1

-- ESP Options
local espOptions = {
    {name = "ESP", var = "espEnabled", y = 120},
    {name = "Box ESP", var = "boxESPEnabled", y = 155},
    {name = "Box Fill ESP", var = "boxFillESPEnabled", y = 190},
    {name = "Name ESP", var = "nameESPEnabled", y = 225},
    {name = "Health ESP", var = "healthESPEnabled", y = 260}
}

local espCheckboxes = {}

for _, option in ipairs(espOptions) do
    local optionFrame = Instance.new("Frame")
    optionFrame.Name = option.name .. "Frame"
    optionFrame.Parent = visualFrame
    optionFrame.BackgroundTransparency = 1
    optionFrame.Position = UDim2.new(0, 20, 0, option.y)
    optionFrame.Size = UDim2.new(1, -40, 0, 25)
    optionFrame.ZIndex = visualFrame.ZIndex + 1
    
    local optionLabel = Instance.new("TextLabel")
    optionLabel.Name = "Label"
    optionLabel.Parent = optionFrame
    optionLabel.BackgroundTransparency = 1
    optionLabel.Size = UDim2.new(1, -30, 1, 0)
    optionLabel.Font = Enum.Font.Gotham
    optionLabel.Text = option.name
    optionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionLabel.TextSize = 14
    optionLabel.TextXAlignment = Enum.TextXAlignment.Left
    optionLabel.ZIndex = optionFrame.ZIndex + 1
    
    local checkbox = Instance.new("TextButton")
    checkbox.Name = "Checkbox"
    checkbox.Parent = optionFrame
    checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    checkbox.BorderSizePixel = 0
    checkbox.Position = UDim2.new(1, -20, 0.5, -8)
    checkbox.Size = UDim2.new(0, 16, 0, 16)
    checkbox.Text = ""
    checkbox.ZIndex = optionFrame.ZIndex + 1
    
    local checkboxCorner = Instance.new("UICorner")
    checkboxCorner.CornerRadius = UDim.new(0, 2)
    checkboxCorner.Parent = checkbox
    
    local checkmark = Instance.new("TextLabel")
    checkmark.Name = "Checkmark"
    checkmark.Parent = checkbox
    checkmark.BackgroundTransparency = 1
    checkmark.Size = UDim2.new(1, 0, 1, 0)
    checkmark.Font = Enum.Font.GothamBold
    checkmark.Text = option.name == "Name ESP" and "✓" or ""
    checkmark.TextColor3 = Color3.fromRGB(255, 100, 100)
    checkmark.TextSize = 12
    checkmark.ZIndex = checkbox.ZIndex + 1
    
    espCheckboxes[option.var] = {checkbox = checkbox, checkmark = checkmark}
    
    -- Если это Name ESP, установим его как активный по умолчанию
    if option.name == "Name ESP" then
        nameESPEnabled = true
        checkbox.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end

-- ============ COMBAT TAB ============

local combatFrame = Instance.new("Frame")
combatFrame.Name = "CombatFrame"
combatFrame.Parent = contentArea
combatFrame.BackgroundTransparency = 1
combatFrame.Size = UDim2.new(1, 0, 1, 0)
combatFrame.Visible = false
combatFrame.ZIndex = contentArea.ZIndex + 1

local combatTitle = Instance.new("TextLabel")
combatTitle.Name = "CombatTitle"
combatTitle.Parent = combatFrame
combatTitle.BackgroundTransparency = 1
combatTitle.Position = UDim2.new(0, 20, 0, 20)
combatTitle.Size = UDim2.new(1, -40, 0, 30)
combatTitle.Font = Enum.Font.GothamBold
combatTitle.Text = "Combat"
combatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
combatTitle.TextSize = 20
combatTitle.TextXAlignment = Enum.TextXAlignment.Left
combatTitle.ZIndex = combatFrame.ZIndex + 1

local autoBallSection = Instance.new("TextLabel")
autoBallSection.Name = "AutoBallSection"
autoBallSection.Parent = combatFrame
autoBallSection.BackgroundTransparency = 1
autoBallSection.Position = UDim2.new(0, 20, 0, 70)
autoBallSection.Size = UDim2.new(1, -40, 0, 25)
autoBallSection.Font = Enum.Font.GothamBold
autoBallSection.Text = "Auto BladeBall"
autoBallSection.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBallSection.TextSize = 16
autoBallSection.TextXAlignment = Enum.TextXAlignment.Left
autoBallSection.ZIndex = combatFrame.ZIndex + 1

-- Auto Ball Toggle
local autoBallFrame = Instance.new("Frame")
autoBallFrame.Name = "AutoBallFrame"
autoBallFrame.Parent = combatFrame
autoBallFrame.BackgroundTransparency = 1
autoBallFrame.Position = UDim2.new(0, 20, 0, 105)
autoBallFrame.Size = UDim2.new(1, -40, 0, 25)
autoBallFrame.ZIndex = combatFrame.ZIndex + 1

local autoBallLabel = Instance.new("TextLabel")
autoBallLabel.Name = "Label"
autoBallLabel.Parent = autoBallFrame
autoBallLabel.BackgroundTransparency = 1
autoBallLabel.Size = UDim2.new(1, -30, 1, 0)
autoBallLabel.Font = Enum.Font.Gotham
autoBallLabel.Text = "Авто отбивание Мячей"
autoBallLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBallLabel.TextSize = 14
autoBallLabel.TextXAlignment = Enum.TextXAlignment.Left
autoBallLabel.ZIndex = autoBallFrame.ZIndex + 1

local autoBallCheckbox = Instance.new("TextButton")
autoBallCheckbox.Name = "Checkbox"
autoBallCheckbox.Parent = autoBallFrame
autoBallCheckbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
autoBallCheckbox.BorderSizePixel = 0
autoBallCheckbox.Position = UDim2.new(1, -20, 0.5, -8)
autoBallCheckbox.Size = UDim2.new(0, 16, 0, 16)
autoBallCheckbox.Text = ""
autoBallCheckbox.ZIndex = autoBallFrame.ZIndex + 1

local autoBallCorner = Instance.new("UICorner")
autoBallCorner.CornerRadius = UDim.new(0, 2)
autoBallCorner.Parent = autoBallCheckbox

local autoBallCheckmark = Instance.new("TextLabel")
autoBallCheckmark.Name = "Checkmark"
autoBallCheckmark.Parent = autoBallCheckbox
autoBallCheckmark.BackgroundTransparency = 1
autoBallCheckmark.Size = UDim2.new(1, 0, 1, 0)
autoBallCheckmark.Font = Enum.Font.GothamBold
autoBallCheckmark.Text = ""
autoBallCheckmark.TextColor3 = Color3.fromRGB(255, 100, 100)
autoBallCheckmark.TextSize = 12
autoBallCheckmark.ZIndex = autoBallCheckbox.ZIndex + 1

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = combatFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 20, 0, 150)
speedLabel.Size = UDim2.new(1, -40, 0, 20)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Скорость отбивания: 50%"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.ZIndex = combatFrame.ZIndex + 1

local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Parent = combatFrame
speedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
speedSlider.BorderSizePixel = 0
speedSlider.Position = UDim2.new(0, 20, 0, 175)
speedSlider.Size = UDim2.new(0, 200, 0, 20)
speedSlider.ZIndex = combatFrame.ZIndex + 1

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 10)
speedSliderCorner.Parent = speedSlider

local speedFill = Instance.new("Frame")
speedFill.Name = "Fill"
speedFill.Parent = speedSlider
speedFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
speedFill.BorderSizePixel = 0
speedFill.Size = UDim2.new(0.5, 0, 1, 0)
speedFill.ZIndex = speedSlider.ZIndex + 1

local speedFillCorner = Instance.new("UICorner")
speedFillCorner.CornerRadius = UDim.new(0, 10)
speedFillCorner.Parent = speedFill

local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Parent = speedSlider
speedButton.BackgroundTransparency = 1
speedButton.Size = UDim2.new(1, 0, 1, 0)
speedButton.Text = ""
speedButton.ZIndex = speedSlider.ZIndex + 2

tabFrames["Visual"] = visualFrame
tabFrames["Combat"] = combatFrame

-- Главная кнопка
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = screenGui
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
toggleButton.BorderSizePixel = 0
toggleButton.Position = UDim2.new(0, 20, 0, 100)
toggleButton.Size = UDim2.new(0, 120, 0, 35)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "Rise | Rivals"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.ZIndex = 100
toggleButton.Visible = false

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- ============ ESP ФУНКЦИИ ============

-- Создание ESP для игрока
local function createPlayerESP(targetPlayer)
    if targetPlayer == player or not targetPlayer.Character then return end
    
    local character = targetPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. targetPlayer.Name
    espFolder.Parent = character
    
    -- Box ESP
    local boxESP = Instance.new("BoxHandleAdornment")
    boxESP.Name = "BoxESP"
    boxESP.Parent = espFolder
    boxESP.Adornee = character
    boxESP.Size = Vector3.new(4, 6, 4)
    boxESP.Color3 = Color3.fromRGB(255, 100, 100)
    boxESP.Transparency = 0.7
    boxESP.AlwaysOnTop = true
    boxESP.ZIndex = 10
    boxESP.Visible = boxESPEnabled
    
    -- Box Fill ESP
    local boxFillESP = Instance.new("BoxHandleAdornment")
    boxFillESP.Name = "BoxFillESP"
    boxFillESP.Parent = espFolder
    boxFillESP.Adornee = character
    boxFillESP.Size = Vector3.new(4, 6, 4)
    boxFillESP.Color3 = Color3.fromRGB(255, 100, 100)
    boxFillESP.Transparency = 0.9
    boxFillESP.AlwaysOnTop = false
    boxFillESP.ZIndex = 5
    boxFillESP.Visible = boxFillESPEnabled
    
    -- Name ESP
    local nameESP = Instance.new("BillboardGui")
    nameESP.Name = "NameESP"
    nameESP.Parent = espFolder
    nameESP.Adornee = humanoidRootPart
    nameESP.Size = UDim2.new(0, 200, 0, 50)
    nameESP.StudsOffset = Vector3.new(0, 3, 0)
    nameESP.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Parent = nameESP
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    nameLabel.TextSize = 14
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    nameESP.Enabled = nameESPEnabled
    
    -- Health ESP
    local healthESP = Instance.new("BillboardGui")
    healthESP.Name = "HealthESP"
    healthESP.Parent = espFolder
    healthESP.Adornee = humanoidRootPart
    healthESP.Size = UDim2.new(0, 100, 0, 20)
    healthESP.StudsOffset = Vector3.new(0, -3, 0)
    healthESP.AlwaysOnTop = true
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Parent = healthESP
    healthBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    healthBar.BorderSizePixel = 0
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    
    local healthBarCorner = Instance.new("UICorner")
    healthBarCorner.CornerRadius = UDim.new(0, 4)
    healthBarCorner.Parent = healthBar
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Parent = healthBar
    healthFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    healthFill.BorderSizePixel = 0
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    
    local healthFillCorner = Instance.new("UICorner")
    healthFillCorner.CornerRadius = UDim.new(0, 4)
    healthFillCorner.Parent = healthFill
    
    healthESP.Enabled = healthESPEnabled
    
    -- Обновление здоровья
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local function updateHealth()
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
            
            if healthPercent > 0.6 then
                healthFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            elseif healthPercent > 0.3 then
                healthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
            else
                healthFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
        
        updateHealth()
        humanoid.HealthChanged:Connect(updateHealth)
    end
    
    espObjects[targetPlayer.Name] = espFolder
end

-- Удаление ESP
local function removePlayerESP(playerName)
    if espObjects[playerName] then
        espObjects[playerName]:Destroy()
        espObjects[playerName] = nil
    end
end

-- Обновление ESP
local function updateESP()
    for playerName, espFolder in pairs(espObjects) do
        if espFolder and espFolder.Parent then
            local boxESP = espFolder:FindFirstChild("BoxESP")
            local boxFillESP = espFolder:FindFirstChild("BoxFillESP")
            local nameESP = espFolder:FindFirstChild("NameESP")
            local healthESP = espFolder:FindFirstChild("HealthESP")
            
            if boxESP then boxESP.Visible = boxESPEnabled end
            if boxFillESP then boxFillESP.Visible = boxFillESPEnabled end
            if nameESP then nameESP.Enabled = nameESPEnabled end
            if healthESP then healthESP.Enabled = healthESPEnabled end
        end
    end
end

-- Инициализация ESP для всех игроков
local function initializeESP()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            createPlayerESP(targetPlayer)
        end
    end
end

-- Обработчики событий для ESP
local function onPlayerAdded(targetPlayer)
    if targetPlayer == player then return end
    
    local function onCharacterAdded(character)
        if espEnabled then
            wait(1) -- Ждем загрузки персонажа
            createPlayerESP(targetPlayer)
        end
    end
    
    if targetPlayer.Character then
        onCharacterAdded(targetPlayer.Character)
    end
    
    targetPlayer.CharacterAdded:Connect(onCharacterAdded)
end

local function onPlayerRemoving(targetPlayer)
    removePlayerESP(targetPlayer.Name)
end

-- ============ АВТООТБИВАНИЕ МЯЧА ============

local function autoBall()
    if ballConnection then
        ballConnection:Disconnect()
        ballConnection = nil
    end
    
    if not autoBallEnabled then return end
    
    ballConnection = RunService.Heartbeat:Connect(function()
        local ball = workspace:FindFirstChild("Ball")
        if not ball or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local character = player.Character
        local humanoidRootPart = character.HumanoidRootPart
        local ballPosition = ball.Position
        local playerPosition = humanoidRootPart.Position
        
        -- Вычисляем дистанцию до мяча
        local distance = (ballPosition - playerPosition).Magnitude
        
        -- Проверяем, летит ли мяч к игроку
        local ballVelocity = ball.AssemblyLinearVelocity or ball.Velocity or Vector3.new()
        local ballDirection = ballVelocity.Unit
        local toPlayer = (playerPosition - ballPosition).Unit
        
        -- Угол между направлением мяча и направлением к игроку
        local dotProduct = ballDirection:Dot(toPlayer)
        
        -- Если мяч летит к игроку и находится в радиусе отбивания
        if distance < 25 and dotProduct > 0.3 and ballVelocity.Magnitude > 5 then
            -- Вычисляем оптимальную силу удара на основе скорости
            local hitForce = 0.1 + (ballSpeed * 0.9)
            
            -- Направление отбивания
            local hitDirection = CFrame.lookAt(playerPosition, ballPosition + Vector3.new(0, 2, 0))
            
            local args = {
                [1] = hitForce,
                [2] = hitDirection,
                [3] = {
                    [1] = ball,
                    [2] = ballPosition
                }
            }
            
            -- Попытка вызвать remote для отбивания
            local success = pcall(function()
                if ReplicatedStorage:FindFirstChild("Remotes") then
                    local remotes = ReplicatedStorage.Remotes
                    if remotes:FindFirstChild("ParryAttempt") then
                        remotes.ParryAttempt:FireServer(unpack(args))
                    elseif remotes:FindFirstChild("Parry") then
                        remotes.Parry:FireServer(unpack(args))
                    end
                elseif ReplicatedStorage:FindFirstChild("ParryAttempt") then
                    ReplicatedStorage.ParryAttempt:FireServer(unpack(args))
                elseif ReplicatedStorage:FindFirstChild("Parry") then
                    ReplicatedStorage.Parry:FireServer(unpack(args))
                end
            end)
            
            wait(0.1)
        end
    end)
end

-- ============ ОБРАБОТЧИКИ СОБЫТИЙ ============

-- Система входа
loadingTween.Completed:Connect(function()
    wait(0.5)
    loadingFrame.Visible = false
    loginFrame.Visible = true
    
    loginFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(loginFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 300)
    }):Play()
end)

continueButton.MouseButton1Click:Connect(function()
    if passwordBox.Text == correctPassword then
        authenticated = true
        
        TweenService:Create(loginFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        TweenService:Create(overlay, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        
        wait(0.5)
        overlay.Visible = false
        
        toggleButton.Visible = true
        TweenService:Create(toggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0, 20, 0, 100)
        }):Play()
        
        print("🗡️ Monster6715 Blade Ball Script v3.0 ESP Edition загружен!")
    else
        passwordBox.Text = ""
        passwordBox.PlaceholderText = "Неправильный пароль!"
        
        -- Анимация тряски
        local originalPos = loginFrame.Position
        for i = 1, 3 do
            TweenService:Create(loginFrame, TweenInfo.new(0.05), {
                Position = originalPos + UDim2.new(0, 5, 0, 0)
            }):Play()
            wait(0.05)
            TweenService:Create(loginFrame, TweenInfo.new(0.05), {
                Position = originalPos + UDim2.new(0, -5, 0, 0)
            }):Play()
            wait(0.05)
        end
        TweenService:Create(loginFrame, TweenInfo.new(0.05), {
            Position = originalPos
        }):Play()
        
        wait(1)
        passwordBox.PlaceholderText = "Введите пароль..."
    end
end)

passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and passwordBox.Text == correctPassword then
        continueButton.MouseButton1Click:Fire()
    end
end)

-- Показ/скрытие основного меню
local menuVisible = false
toggleButton.MouseButton1Click:Connect(function()
    if not authenticated then return end
    
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    
    if menuVisible then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 600, 0, 400)
        }):Play()
    end
end)

-- Закрытие меню
closeButton.MouseButton1Click:Connect(function()
    menuVisible = false
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    wait(0.3)
    mainFrame.Visible = false
end)

-- Минимизация меню
minimizeButton.MouseButton1Click:Connect(function()
    menuVisible = false
    mainFrame.Visible = false
end)

-- Навигация между вкладками
local function switchTab(tabName)
    if activeTab == tabName then return end
    
    -- Скрыть все вкладки
    for name, frame in pairs(tabFrames) do
        frame.Visible = false
    end
    
    -- Сбросить цвета кнопок
    for name, button in pairs(navButtonObjects) do
        button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    end
    
    -- Показать выбранную вкладку
    if tabFrames[tabName] then
        tabFrames[tabName].Visible = true
    end
    
    -- Выделить активную кнопку
    if navButtonObjects[tabName] then
        navButtonObjects[tabName].BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    activeTab = tabName
end

-- Обработчики кнопок навигации
for name, button in pairs(navButtonObjects) do
    button.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ESP чекбоксы
for varName, checkboxData in pairs(espCheckboxes) do
    checkboxData.checkbox.MouseButton1Click:Connect(function()
        local currentValue = _G[varName] or false
        
        if varName == "espEnabled" then
            espEnabled = not espEnabled
            currentValue = espEnabled
        elseif varName == "boxESPEnabled" then
            boxESPEnabled = not boxESPEnabled
            currentValue = boxESPEnabled
        elseif varName == "boxFillESPEnabled" then
            boxFillESPEnabled = not boxFillESPEnabled
            currentValue = boxFillESPEnabled
        elseif varName == "nameESPEnabled" then
            nameESPEnabled = not nameESPEnabled
            currentValue = nameESPEnabled
        elseif varName == "healthESPEnabled" then
            healthESPEnabled = not healthESPEnabled
            currentValue = healthESPEnabled
        end
        
        if currentValue then
            checkboxData.checkmark.Text = "✓"
            checkboxData.checkbox.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            
            if varName == "espEnabled" then
                initializeESP()
                -- Подключаем обработчики событий
                Players.PlayerAdded:Connect(onPlayerAdded)
                Players.PlayerRemoving:Connect(onPlayerRemoving)
            end
        else
            checkboxData.checkmark.Text = ""
            checkboxData.checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            
            if varName == "espEnabled" then
                -- Удаляем все ESP объекты
                for playerName, _ in pairs(espObjects) do
                    removePlayerESP(playerName)
                end
            end
        end
        
        updateESP()
    end)
end

-- Auto Ball чекбокс
autoBallCheckbox.MouseButton1Click:Connect(function()
    autoBallEnabled = not autoBallEnabled
    
    if autoBallEnabled then
        autoBallCheckmark.Text = "✓"
        autoBallCheckbox.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        autoBall()
    else
        autoBallCheckmark.Text = ""
        autoBallCheckbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        if ballConnection then
            ballConnection:Disconnect()
            ballConnection = nil
        end
    end
end)

-- Speed Slider
local speedDragging = false
speedButton.MouseButton1Down:Connect(function()
    speedDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = false
    end
end)

speedButton.MouseMoved:Connect(function(x, y)
    if speedDragging then
        local relativeX = x - speedSlider.AbsolutePosition.X
        local percentage = math.clamp(relativeX / speedSlider.AbsoluteSize.X, 0, 1)
        
        ballSpeed = 0.1 + (percentage * 0.9)
        speedFill.Size = UDim2.new(percentage, 0, 1, 0)
        speedLabel.Text = "Скорость отбивания: " .. math.floor(percentage * 100) .. "%"
    end
end)

-- Система перетаскивания
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

-- Анимации наведения
local function addHoverEffect(button, hoverColor, normalColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

addHoverEffect(toggleButton, Color3.fromRGB(220, 80, 80), Color3.fromRGB(255, 100, 100))
addHoverEffect(continueButton, Color3.fromRGB(220, 80, 80), Color3.fromRGB(255, 100, 100))

-- Автоматическое включение Name ESP при загрузке
nameESPEnabled = true

print("🔐 Monster6715 Blade Ball Script v3.0 ESP Edition инициализирован - требуется авторизация")
