-- Final GAG (Grow A Garden) UI + ESP + AutoCollect
-- Для Delta / Synapse и т.п.
-- Вставлять целиком. Использует client-side GUI, BillboardGui для ESP и попытки взаимодействия с ProximityPrompt / firetouchinterest.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ====== Конфигурация ======
local CORRECT_KEY = "monster6715"
local MAIN_W, MAIN_H = 560, 380

local EXPENSIVE_FRUITS = {
    "dragon", "moon", "pineapple", "mango", "traveler", "ember", "hive", "sugar"
}
local CHEAP_FRUITS = {
    "apple", "banana", "straw", "carrot", "orange"
}

-- ====== Вспомогательные твины ======
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.25, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

-- ====== Камера статичная (сохранение/восстановление) ======
local Camera = workspace.CurrentCamera
local origCameraType = Camera.CameraType
local origCameraCFrame = Camera.CFrame
local function freezeCamera()
    pcall(function()
        origCameraType = Camera.CameraType
        origCameraCFrame = Camera.CFrame
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = origCameraCFrame
    end)
end
local function restoreCamera()
    pcall(function()
        Camera.CameraType = origCameraType
        Camera.CFrame = origCameraCFrame
    end)
end

-- ====== Размытие ======
local blur = Instance.new("BlurEffect")
blur.Parent = Lighting
blur.Size = 0
local function tweenBlur(target, dur)
    dur = dur or 0.35
    local steps = 18
    local start = blur.Size
    local step = (target - start) / steps
    for i = 1, steps do
        blur.Size = blur.Size + step
        task.wait(dur/steps)
    end
    blur.Size = target
end

-- ====== Утилиты GUI ======
local function makeScreenGui(name)
    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name = name
    sg.ResetOnSpawn = false
    sg:SetAttribute("GagByScript", true)
    return sg
end

local function centerPos()
    return UDim2.new(0.5, 0, 0.5, 0)
end

local function makeFrame(parent, w, h)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0, w, 0, h)
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = centerPos()
    f.BackgroundColor3 = Color3.fromRGB(24,24,24)
    f.BorderSizePixel = 0
    local uc = Instance.new("UICorner", f); uc.CornerRadius = UDim.new(0,10)
    return f
end

local function makeLabel(parent, y, txt, size, bold)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, -24, 0, size or 24)
    l.Position = UDim2.new(0, 12, 0, y)
    l.BackgroundTransparency = 1
    l.Text = txt or ""
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = size and (size-4) or 16
    l.TextColor3 = Color3.fromRGB(240,240,240)
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local function makeButton(parent, y, text, widthPercent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(widthPercent or 0.9, 0, 0, 36)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.TextColor3 = Color3.fromRGB(245,245,245)
    local uc = Instance.new("UICorner", b); uc.CornerRadius = UDim.new(0,6)
    return b
end

local function createLoading(text, dur)
    dur = dur or 1.6
    local sg = makeScreenGui("GAG_Loading")
    local f = makeFrame(sg, 320, 110)
    local lbl = makeLabel(f, 18, text or "Loading...", 22, true)
    tweenBlur(20, 0.3)
    freezeCamera()
    task.wait(dur)
    sg:Destroy()
end

-- Очистка GUI и восстановление камеры
local function clearAll()
    for _,v in pairs(PlayerGui:GetChildren()) do
        if v:GetAttribute and v:GetAttribute("GagByScript") then
            v:Destroy()
        end
    end
    restoreCamera()
    tweenBlur(0, 0.25)
end

-- ====== ESP/AutoCollect логика ======
local espActive = false
local autoActive = false
local espGuis = {} -- map part -> billboard

local function isNameMatches(name, patterns)
    local ln = (name or ""):lower()
    for _,p in ipairs(patterns) do
        if string.find(ln, p:lower()) then return true end
    end
    return false
end

local function createBillboardFor(part, color, labelText)
    if not part or not part:IsA("BasePart") then return end
    if espGuis[part] then return end
    local bg = Instance.new("BillboardGui")
    bg.Adornee = part
    bg.Size = UDim2.new(0,140,0,40)
    bg.AlwaysOnTop = true
    bg.Parent = PlayerGui
    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = labelText or part.Name
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.TextColor3 = color
    espGuis[part] = bg
end

local function clearEsp()
    for part, gui in pairs(espGuis) do
        if gui and gui.Parent then gui:Destroy() end
    end
    espGuis = {}
end

local function scanAndMarkEsp()
    if not espActive then
        clearEsp()
        return
    end
    -- Ищем Parts / MeshParts в workspace
    for _,obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Parent then
            local nm = obj.Name
            if isNameMatches(nm, EXPENSIVE_FRUITS) then
                createBillboardFor(obj, Color3.fromRGB(255,200,60), "Дорогой: "..nm)
            end
        end
    end
end

local function attemptCollect(part)
    if not part or not part.Parent then return false end
    -- ProximityPrompt
    for _,d in ipairs(part:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            pcall(function()
                d:InputHoldBegin()
                task.wait(0.05)
                d:InputHoldEnd()
            end)
            return true
        end
    end
    -- firetouchinterest если доступна
    local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        if typeof(firetouchinterest) == "function" then
            pcall(function()
                firetouchinterest(hrp, part, 0)
                firetouchinterest(hrp, part, 1)
            end)
            return true
        else
            -- запасной телепорт (короткий)
            local prev = hrp.CFrame
            pcall(function()
                hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
                task.wait(0.08)
                hrp.CFrame = prev
            end)
            return true
        end
    end
    return false
end

local function scanAndCollectCheap()
    if not autoActive then return end
    for _,obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Parent then
            if isNameMatches(obj.Name, CHEAP_FRUITS) then
                pcall(function() attemptCollect(obj) end)
            end
        end
    end
end

-- Background loops
spawn(function()
    while true do
        if espActive then pcall(scanAndMarkEsp) end
        task.wait(1.2)
    end
end)
spawn(function()
    while true do
        if autoActive then pcall(scanAndCollectCheap) end
        task.wait(0.9)
    end
end)

-- ====== UI: Key entry -> Main Menu -> Actions ======
local function createKeyUI()
    local sg = makeScreenGui("GAG_KeyUI")
    local frame = makeFrame(sg, 420, 260)
    -- Header
    local hdr = Instance.new("Frame", frame); hdr.Size = UDim2.new(1, -24, 0, 46); hdr.Position = UDim2.new(0,12,0,10); hdr.BackgroundTransparency = 1
    local title = makeLabel(hdr, 0, "Ronix Hub Key System", 22, true); title.Position = UDim2.new(0, 0, 0, 0); title.TextXAlignment = Enum.TextXAlignment.Center
    -- Info
    makeLabel(frame, 64, "Введите ключ чтобы продолжить:", 16)
    -- TextBox
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.9, 0, 0, 36)
    box.Position = UDim2.new(0.05, 0, 0, 110)
    box.BackgroundColor3 = Color3.fromRGB(36,36,36)
    box.PlaceholderText = "Введите ключ..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.TextColor3 = Color3.fromRGB(240,240,240)
    local ub = Instance.new("UICorner", box); ub.CornerRadius = UDim.new(0,6)

    local enter = makeButton(frame, 158, "Проверить ключ")
    local feedback = makeLabel(frame, 206, "", 16)

    enter.MouseButton1Click:Connect(function()
        if box.Text == CORRECT_KEY then
            feedback.Text = "Ключ верный. Запуск..."
            feedback.TextColor3 = Color3.fromRGB(150,255,150)
            -- имбовый переход
            tween(frame, {Size = UDim2.new(0, MAIN_W+40, 0, MAIN_H+40)}, 0.22, "Back", "Out")
            tweenBlur(20, 0.28)
            freezeCamera()
            task.wait(0.28)
            sg:Destroy()
            createLoading("Применение настроек...", 1.0)
            createMainMenu(false)
        else
            feedback.Text = "Неверный ключ!"
            feedback.TextColor3 = Color3.fromRGB(255,140,140)
            box.Text = ""
        end
    end)
end

function createMainMenu(isEmpty)
    isEmpty = isEmpty or false
    local sg = makeScreenGui("GAG_MainMenu")
    local frame = makeFrame(sg, MAIN_W, MAIN_H)

    -- header
    local header = Instance.new("Frame", frame); header.Size = UDim2.new(1, -40, 0, 46); header.Position = UDim2.new(0, 20, 0, 10); header.BackgroundTransparency = 1
    local title = makeLabel(header, 0, isEmpty and "" or "Что хотите выбрать", 20, true)
    title.Position = UDim2.new(0,0,0,0)
    title.TextXAlignment = Enum.TextXAlignment.Center

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0,28,0,28); closeBtn.Position = UDim2.new(1, -36, 0, 6); closeBtn.Text="X"; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=14
    closeBtn.BackgroundColor3 = Color3.fromRGB(190,55,55)
    local uc = Instance.new("UICorner", closeBtn); uc.CornerRadius = UDim.new(0,6)
    closeBtn.MouseButton1Click:Connect(function() clearAll() end)

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0,28,0,28); minBtn.Position = UDim2.new(1, -74, 0, 6); minBtn.Text="-"; minBtn.Font=Enum.Font.GothamBold; minBtn.TextSize=20
    minBtn.BackgroundColor3 = Color3.fromRGB(95,95,95)
    local um = Instance.new("UICorner", minBtn); um.CornerRadius = UDim.new(0,6)

    if not isEmpty then
        -- Buttons area
        local startY = 70
        local b1 = makeButton(frame, startY, "99night"); startY = startY + 48
        local b2 = makeButton(frame, startY, "Steal A brainrot"); startY = startY + 48
        local b3 = makeButton(frame, startY, "Grow a garden"); startY = startY + 48

        local fb = makeLabel(frame, startY, "", 16); startY = startY + 36

        -- toggles
        local espBtn = makeButton(frame, startY, "ESP (дорогие): ВЫКЛ", 0.47); espBtn.Position = UDim2.new(0.05,0,0,startY)
        local acBtn  = makeButton(frame, startY, "AutoCollect (деш): ВЫКЛ", 0.47); acBtn.Position = UDim2.new(0.52,0,0,startY)
        startY = startY + 46

        -- handlers
        b1.MouseButton1Click:Connect(function()
            fb.Text = "Ошибка: не готово."
            fb.TextColor3 = Color3.fromRGB(255,140,140)
        end)
        b2.MouseButton1Click:Connect(function()
            fb.Text = "Ошибка: не готово."
            fb.TextColor3 = Color3.fromRGB(255,140,140)
        end)

        b3.MouseButton1Click:Connect(function()
            fb.Text = "Успешно. Запуск Grow a garden..."
            fb.TextColor3 = Color3.fromRGB(150,255,150)
            tween(frame, {BackgroundTransparency = 0.6}, 0.22)
            task.wait(0.18)
            createLoading("Применение Grow a Garden...", 1.6)
            -- удаляем меню и создаём пустое такое же
            sg:Destroy()
            createMainMenu(true)
            -- разблокируем возможности: пользователь сам включает esp/auto через переключатели в пустом меню (поддержка одинакового размера)
        end)

        espBtn.MouseButton1Click:Connect(function()
            espActive = not espActive
            espBtn.Text = "ESP (дорогие): " .. (espActive and "ВКЛ" or "ВЫКЛ")
            espBtn.BackgroundColor3 = espActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(40,40,40)
            if not espActive then clearEsp() end
        end)

        acBtn.MouseButton1Click:Connect(function()
            autoActive = not autoActive
            acBtn.Text = "AutoCollect (деш): " .. (autoActive and "ВКЛ" or "ВЫКЛ")
            acBtn.BackgroundColor3 = autoActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(40,40,40)
        end)
    else
        -- пустое меню (такой же размер)
        makeLabel(frame, 120, "Меню пусто. То же место и размер.", 16)
        -- добавим переключатели для включения уже после Grow a garden (чтобы пользователь мог включить ESP/Auto)
        local yd = 170
        local espBtn2 = makeButton(frame, yd, "ESP (дорогие): ВЫКЛ", 0.47); espBtn2.Position = UDim2.new(0.05,0,0,yd)
        local acBtn2  = makeButton(frame, yd, "AutoCollect (деш): ВЫКЛ", 0.47); acBtn2.Position = UDim2.new(0.52,0,0,yd)
        espBtn2.MouseButton1Click:Connect(function()
            espActive = not espActive
            espBtn2.Text = "ESP (дорогие): " .. (espActive and "ВКЛ" or "ВЫКЛ")
            espBtn2.BackgroundColor3 = espActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(40,40,40)
            if not espActive then clearEsp() end
        end)
        acBtn2.MouseButton1Click:Connect(function()
            autoActive = not autoActive
            acBtn2.Text = "AutoCollect (деш): " .. (autoActive and "ВКЛ" or "ВЫКЛ")
            acBtn2.BackgroundColor3 = autoActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(40,40,40)
        end)
    end

    -- Перетаскивание (header)
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)
    header.InputEnded:Connect(function() dragging = false end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Minimize -> create centered mini panel
    local miniGui
    minBtn.MouseButton1Click:Connect(function()
        sg.Enabled = false
        miniGui = makeScreenGui("GAG_Mini")
        local mini = Instance.new("Frame", miniGui)
        mini.Size = UDim2.new(0,90,0,90)
        mini.AnchorPoint = Vector2.new(0.5,0.5)
        mini.Position = centerPos()
        mini.BackgroundColor3 = Color3.fromRGB(28,28,28)
        local mc = Instance.new("UICorner", mini); mc.CornerRadius = UDim.new(0,16)

        local plus = Instance.new("TextButton", mini)
        plus.Size = UDim2.new(0.75,0,0.75,0); plus.Position = UDim2.new(0.125,0,0.125,0)
        plus.Text = "+"
        plus.Font = Enum.Font.GothamBold
        plus.TextSize = 30
        plus.BackgroundTransparency = 1
        plus.TextColor3 = Color3.fromRGB(240,240,240)

        -- mini drag
        local md, ms, msp
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
            miniGui:Destroy()
            sg.Enabled = true
        end)
    end)
end

-- ====== Start sequence ======
clearAll()
createLoading("Loading...", 1.6)
createKeyUI()
-- end of script
