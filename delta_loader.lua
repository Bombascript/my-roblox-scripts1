--[[
  Надёжный клиентский Lua-скрипт для Delta/Synapse-подобных инструментов
  - Центрированные окна
  - Статичная камера пока открыто (Scriptable), восстанавливается при закрытии
  - Loading -> Key (monster6715) -> Transition -> Menu "Что хотите выбрать"
  - Кнопки: 99night (ошибка), Steal A brainrot (ошибка), Grow a garden (успех -> вторая загрузка -> пустое меню)
  - Свернуть в мини-панель и вернуть (мини-панель тоже центрируется и двигается)
  - ESP для "дорогих" фруктов (billboard), AutoCollect для "дешёвых" (вкл/выкл вручную)
  - Много pcall/проверок чтобы скрипт не падал
--]]

-- ------------------------------
-- Конфигурация
-- ------------------------------
local CORRECT_KEY = "monster6715"

local MAIN_WIDTH = 560
local MAIN_HEIGHT = 380

-- подстроки имён для распознавания (добавляй варианты по необходимости)
local EXPENSIVE_FRUITS = { "dragon", "moon", "pineapple", "mango", "traveler", "ember", "hive", "sugar" }
local CHEAP_FRUITS      = { "apple", "banana", "straw", "carrot", "orange" }

-- ------------------------------
-- Сервисы и игрок
-- ------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    -- иногда LocalPlayer может не появиться мгновенно в некоторых средах
    LocalPlayer = Players:GetPropertyChangedSignal("LocalPlayer") and Players.LocalPlayer or nil
    while not LocalPlayer do
        task.wait(0.1)
        LocalPlayer = Players.LocalPlayer
    end
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ------------------------------
-- Камера и Blur (фиксированный фон)
-- ------------------------------
local Camera = Workspace.CurrentCamera
local origCameraType, origCameraCFrame = nil, nil

-- Найдём или создадим BlurEffect
local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Parent = Lighting
    blur.Size = 0
end

local function safeTweenBlur(target, duration)
    duration = duration or 0.28
    local ok, err = pcall(function()
        local start = blur.Size or 0
        local steps = 18
        local step = (target - start) / (steps == 0 and 1 or steps)
        for i = 1, steps do
            blur.Size = blur.Size + step
            task.wait(duration / steps)
        end
        blur.Size = target
    end)
    if not ok then
        warn("blur tween failed:", err)
        -- попытка просто установить
        pcall(function() blur.Size = target end)
    end
end

local function freezeCamera()
    pcall(function()
        if not Camera then Camera = Workspace.CurrentCamera end
        origCameraType = Camera.CameraType
        origCameraCFrame = Camera.CFrame
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = origCameraCFrame
    end)
end

local function restoreCamera()
    pcall(function()
        if Camera and origCameraType then
            Camera.CameraType = origCameraType
        end
        if Camera and origCameraCFrame then
            Camera.CFrame = origCameraCFrame
        end
    end)
end

-- ------------------------------
-- Общие GUI-хелперы
-- ------------------------------
local function makeScreenGui(name)
    local ok, sg = pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = name or "GAG_SG"
        g.ResetOnSpawn = false
        g.Parent = PlayerGui
        g:SetAttribute("GAG_ByScript", true)
        return g
    end)
    if ok then return sg else return nil end
end

local function centerFrame(parent, w, h)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0, w, 0, h)
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.new(0.5, 0, 0.5, 0)
    f.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    f.BorderSizePixel = 0
    local uc = Instance.new("UICorner", f); uc.CornerRadius = UDim.new(0, 12)
    return f
end

local function makeLabel(parent, y, text, size, bold, align)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -28, 0, size or 24)
    lbl.Position = UDim2.new(0, 14, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or ""
    lbl.Font = bold and Enum.Font.SourceSansBold or Enum.Font.SourceSans
    lbl.TextSize = math.max(12, (size and (size-2) or 16))
    lbl.TextColor3 = Color3.fromRGB(240,240,240)
    lbl.TextWrapped = true
    lbl.TextXAlignment = align or Enum.TextXAlignment.Center
    return lbl
end

local function makeButton(parent, y, text, widthPercent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(widthPercent or 0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(44,44,44)
    btn.BorderSizePixel = 0
    local uc = Instance.new("UICorner", btn); uc.CornerRadius = UDim.new(0,8)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.AutoButtonColor = true
    btn.TextColor3 = Color3.fromRGB(245,245,245)
    btn.Text = text or "Button"
    return btn
end

local function tweenObject(obj, props, time, style, dir)
    time = time or 0.22
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local ok, t = pcall(function()
        local info = TweenInfo.new(time, style, dir)
        local tw = TweenService:Create(obj, info, props)
        tw:Play()
        return tw
    end)
    if not ok then
        warn("tween failed:", t)
    end
end

local function clearOurGui()
    -- удаляем все SG созданные этим скриптом
    for _, v in ipairs(PlayerGui:GetChildren()) do
        if v:GetAttribute and v:GetAttribute("GAG_ByScript") then
            pcall(function() v:Destroy() end)
        end
    end
    restoreCamera()
    pcall(function() safeTweenBlur(0, 0.18) end)
end

-- центрировать при изменении окна (чтобы на мобилке оставалось по центру)
local function ensureCenter(frame)
    if not frame then return end
    pcall(function()
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    end)
end

-- ------------------------------
-- Loading
-- ------------------------------
local function showLoading(text, dur)
    dur = dur or 1.6
    local sg = makeScreenGui("GAG_Loading")
    if not sg then return end
    local frame = centerFrame(sg, 320, 110)
    frame.ZIndex = 10
    local lbl = makeLabel(frame, 18, text or "Loading...", 22, true)
    safeTweenBlur(18, 0.26)
    freezeCamera()
    task.wait(dur)
    pcall(function() sg:Destroy() end)
end

-- ------------------------------
-- ESP & AutoCollect (функции, фоновые петли)
-- ------------------------------
local espActive = false
local autoActive = false
local espMap = {}  -- part -> BillboardGui

local function nameMatchesAny(name, patterns)
    if not name then return false end
    local ln = name:lower()
    for _, p in ipairs(patterns) do
        local pat = p:lower()
        if string.find(ln, pat) or string.find(ln, pat:gsub("%s","")) then
            return true
        end
    end
    return false
end

local function createBillboard(part, col, labelText)
    if not part or not part:IsA("BasePart") then return end
    if espMap[part] then return end
    local ok, bg = pcall(function()
        local gui = Instance.new("BillboardGui")
        gui.Adornee = part
        gui.Size = UDim2.new(0, 150, 0, 36)
        gui.AlwaysOnTop = true
        gui.StudsOffset = Vector3.new(0, 1.6, 0)
        gui.Parent = PlayerGui

        local txt = Instance.new("TextLabel", gui)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.SourceSansBold
        txt.TextSize = 13
        txt.Text = labelText or part.Name
        txt.TextColor3 = col or Color3.fromRGB(255,200,60)
        return gui
    end)
    if ok and bg then
        espMap[part] = bg
    end
end

local function clearEsp()
    for p, g in pairs(espMap) do
        pcall(function()
            if g and g.Parent then g:Destroy() end
        end)
    end
    espMap = {}
end

local function scanAndMarkEsp()
    if not espActive then
        clearEsp()
        return
    end
    -- ищем объекты в workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Parent then
            if nameMatchesAny(obj.Name, EXPENSIVE_FRUITS) then
                pcall(createBillboard, obj, Color3.fromRGB(255,200,60), "Дорогой: "..tostring(obj.Name))
            end
        end
    end
end

local function tryCollect(part)
    if not part or not part.Parent then return false end
    -- пробуем ProximityPrompt
    for _, d in ipairs(part:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            pcall(function()
                d:InputHoldBegin()
                task.wait(0.06)
                d:InputHoldEnd()
            end)
            return true
        end
    end
    -- firetouchinterest fallback
    local hrp = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if hrp then
        if typeof(firetouchinterest) == "function" then
            pcall(function()
                firetouchinterest(hrp, part, 0)
                firetouchinterest(hrp, part, 1)
            end)
            return true
        else
            -- короткое телепортирование (если возможно)
            local ok, prev = pcall(function() return hrp.CFrame end)
            if ok and prev then
                pcall(function()
                    hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.08)
                    hrp.CFrame = prev
                end)
                return true
            end
        end
    end
    return false
end

local function scanAndCollectCheap()
    if not autoActive then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Parent then
            if nameMatchesAny(obj.Name, CHEAP_FRUITS) then
                pcall(tryCollect, obj)
            end
        end
    end
end

-- фоновые петли (не блокируют основной поток)
spawn(function()
    while true do
        pcall(scanAndMarkEsp)
        task.wait(1.1)
    end
end)

spawn(function()
    while true do
        pcall(scanAndCollectCheap)
        task.wait(0.9)
    end
end)

-- ------------------------------
-- UI: Key -> Main Menu -> Empty Menu
-- ------------------------------
local function createKeyUI()
    clearOurGui()
    local sg = makeScreenGui("GAG_KeyUI")
    if not sg then return end
    local frame = centerFrame(sg, 420, 260)
    frame.ZIndex = 5

    local title = makeLabel(frame, 12, "Ronix Hub Key System", 22, true)
    title.TextXAlignment = Enum.TextXAlignment.Center

    makeLabel(frame, 56, "Введите ключ чтобы продолжить:", 14, false)

    -- textbox
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.9, 0, 0, 36)
    box.Position = UDim2.new(0.05, 0, 0, 104)
    box.BackgroundColor3 = Color3.fromRGB(36,36,36)
    box.PlaceholderText = "Введите ключ..."
    box.Font = Enum.Font.SourceSans
    box.TextSize = 16
    box.TextColor3 = Color3.fromRGB(240,240,240)
    local ub = Instance.new("UICorner", box); ub.CornerRadius = UDim.new(0,6)

    local enter = makeButton(frame, 156, "Проверить ключ")
    local feedback = makeLabel(frame, 200, "", 14, false)

    -- центрирование при изменении окна
    UserInputService.WindowSizeChanged:Connect(function()
        ensureCenter(frame)
    end)

    enter.MouseButton1Click:Connect(function()
        local text = tostring(box.Text or "")
        if text == CORRECT_KEY then
            feedback.Text = "Ключ верный. Запуск..."
            feedback.TextColor3 = Color3.fromRGB(140, 255, 150)
            -- имбовый переход
            tweenObject(frame, {Size = UDim2.new(0, MAIN_WIDTH + 40, 0, MAIN_HEIGHT + 40)}, 0.22)
            safeTweenBlur(20, 0.28)
            freezeCamera()
            task.wait(0.26)
            pcall(function() sg:Destroy() end)
            showLoading("Применение настроек...", 1.0)
            createMainMenu(false)
        else
            feedback.Text = "Неверный ключ!"
            feedback.TextColor3 = Color3.fromRGB(255,150,150)
            box.Text = ""
        end
    end)
end

-- createMainMenu: isEmpty == true -> пустое меню того же размера
function createMainMenu(isEmpty)
    isEmpty = isEmpty and true or false
    clearOurGui()
    local sg = makeScreenGui("GAG_MainMenu")
    if not sg then return end
    local frame = centerFrame(sg, MAIN_WIDTH, MAIN_HEIGHT)
    frame.ZIndex = 6

    -- header
    local header = Instance.new("Frame", frame)
    header.Size = UDim2.new(1, -36, 0, 48)
    header.Position = UDim2.new(0, 18, 0, 12)
    header.BackgroundTransparency = 1

    local titleText = isEmpty and "" or "Что хотите выбрать"
    local title = makeLabel(header, 0, titleText, 18, true)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Center

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -36, 0, 6)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 14
    closeBtn.BackgroundColor3 = Color3.fromRGB(190,55,55)
    local cc = Instance.new("UICorner", closeBtn); cc.CornerRadius = UDim.new(0, 6)

    closeBtn.MouseButton1Click:Connect(function()
        clearOurGui()
    end)

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -76, 0, 6)
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.SourceSansBold
    minBtn.TextSize = 18
    minBtn.BackgroundColor3 = Color3.fromRGB(105,105,105)
    local mc = Instance.new("UICorner", minBtn); mc.CornerRadius = UDim.new(0,6)

    -- main content
    local offsetY = 72
    if not isEmpty then
        local b1 = makeButton(frame, offsetY, "99night"); offsetY = offsetY + 50
        local b2 = makeButton(frame, offsetY, "Steal A brainrot"); offsetY = offsetY + 50
        local b3 = makeButton(frame, offsetY, "Grow a garden"); offsetY = offsetY + 50

        local feedback = makeLabel(frame, offsetY, "", 14, false); offsetY = offsetY + 36

        -- toggles (по ширине две кнопки)
        local espBtn = makeButton(frame, offsetY, "ESP (дорогие): ВЫКЛ", 0.47)
        espBtn.Position = UDim2.new(0.05, 0, 0, offsetY)
        local acBtn = makeButton(frame, offsetY, "AutoCollect (деш): ВЫКЛ", 0.47)
        acBtn.Position = UDim2.new(0.52, 0, 0, offsetY)
        offsetY = offsetY + 44

        b1.MouseButton1Click:Connect(function()
            feedback.Text = "Ошибка: не готово."
            feedback.TextColor3 = Color3.fromRGB(255,140,140)
        end)
        b2.MouseButton1Click:Connect(function()
            feedback.Text = "Ошибка: не готово."
            feedback.TextColor3 = Color3.fromRGB(255,140,140)
        end)

        b3.MouseButton1Click:Connect(function()
            feedback.Text = "Успешно. Запуск Grow a garden..."
            feedback.TextColor3 = Color3.fromRGB(130, 255, 140)
            tweenObject(frame, {BackgroundTransparency = 0.6}, 0.18)
            task.wait(0.18)
            showLoading("Применение Grow a Garden...", 1.6)
            -- после загрузки удаляем меню и создаём пустое (тот же размер)
            pcall(function() sg:Destroy() end)
            createMainMenu(true)
            -- в пустом меню пользователь сможет включить ESP/Auto
        end)

        espBtn.MouseButton1Click:Connect(function()
            espActive = not espActive
            espBtn.Text = "ESP (дорогие): " .. (espActive and "ВКЛ" or "ВЫКЛ")
            espBtn.BackgroundColor3 = espActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(44,44,44)
            if not espActive then clearEsp() end
        end)

        acBtn.MouseButton1Click:Connect(function()
            autoActive = not autoActive
            acBtn.Text = "AutoCollect (деш): " .. (autoActive and "ВКЛ" or "ВЫКЛ")
            acBtn.BackgroundColor3 = autoActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(44,44,44)
        end)
    else
        -- пустое меню: те же размеры, переключатели внизу для включения функций
        makeLabel(frame, 120, "Меню пусто. Размер и позиция такие же.", 14, false)
        local ypos = 170
        local espBtn2 = makeButton(frame, ypos, "ESP (дорогие): ВЫКЛ", 0.47)
        espBtn2.Position = UDim2.new(0.05, 0, 0, ypos)
        local acBtn2 = makeButton(frame, ypos, "AutoCollect (деш): ВЫКЛ", 0.47)
        acBtn2.Position = UDim2.new(0.52, 0, 0, ypos)

        espBtn2.MouseButton1Click:Connect(function()
            espActive = not espActive
            espBtn2.Text = "ESP (дорогие): " .. (espActive and "ВКЛ" or "ВЫКЛ")
            espBtn2.BackgroundColor3 = espActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(44,44,44)
            if not espActive then clearEsp() end
        end)

        acBtn2.MouseButton1Click:Connect(function()
            autoActive = not autoActive
            acBtn2.Text = "AutoCollect (деш): " .. (autoActive and "ВКЛ" or "ВЫКЛ")
            acBtn2.BackgroundColor3 = autoActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(44,44,44)
        end)
    end

    -- Dragging header (pc + mobile)
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    header.InputEnded:Connect(function() dragging = false end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Minimize -> mini panel (центрированная)
    local miniGui
    minBtn.MouseButton1Click:Connect(function()
        sg.Enabled = false
        miniGui = makeScreenGui("GAG_Mini")
        if not miniGui then return end

        local mini = Instance.new("Frame", miniGui)
        mini.Size = UDim2.new(0, 90, 0, 90)
        mini.AnchorPoint = Vector2.new(0.5, 0.5)
        mini.Position = UDim2.new(0.5, 0.5, 0, 0)
        mini.BackgroundColor3 = Color3.fromRGB(28,28,28)
        local ucm = Instance.new("UICorner", mini); ucm.CornerRadius = UDim.new(0, 18)

        local plus = Instance.new("TextButton", mini)
        plus.Size = UDim2.new(0.75, 0, 0.75, 0)
        plus.Position = UDim2.new(0.125, 0, 0.125, 0)
        plus.Text = "+"; plus.Font = Enum.Font.SourceSansBold; plus.TextSize = 30
        plus.BackgroundTransparency = 1; plus.TextColor3 = Color3.fromRGB(240,240,240)

        -- drag mini
        local md, ms, msp = false, nil, nil
        plus.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                md = true
                ms = i.Position
                msp = mini.Position
            end
        end)
        plus.InputEnded:Connect(function() md = false end)
        UserInputService.InputChanged:Connect(function(i)
            if md and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local delta = i.Position - ms
                mini.Position = UDim2.new(msp.X.Scale, msp.X.Offset + delta.X, msp.Y.Scale, msp.Y.Offset + delta.Y)
            end
        end)

        plus.MouseButton1Click:Connect(function()
            pcall(function() if miniGui and miniGui.Parent then miniGui:Destroy() end end)
            sg.Enabled = true
        end)
    end)
end

-- ------------------------------
-- Start sequence
-- ------------------------------
clearOurGui()
showLoading("Loading...", 1.6)
createKeyUI()

-- ------------------------------
-- Окончание
-- ------------------------------
-- Если скрипт не запустился — пришли, пожалуйста:
-- 1) Какой эксплойт (Delta / Synapse / Fluxus)? 
-- 2) Текст ошибки (ошибка в консоли/всплывающий). 
-- Я быстро поправлю.
