-- Final stable UI + ESP + AutoCollect (Delta / Synapse)
-- Вставлять целиком в исполнителе (Local script style, клиентский скрипт)

-- Настройки
local CORRECT_KEY = "monster6715"
local MAIN_W, MAIN_H = 560, 380

local EXPENSIVE_FRUITS = {
    "dragon", "moon", "pineapple", "mango", "traveler", "ember", "hive", "sugar"
}
local CHEAP_FRUITS = {
    "apple", "banana", "straw", "carrot", "orange"
}

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ========== Камера / Blur ==========
local Camera = workspace.CurrentCamera
local origCameraType, origCameraCFrame
local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Parent = Lighting
    blur.Size = 0
end

local function tweenBlur(target, dur)
    dur = dur or 0.28
    local start = blur.Size
    local steps = 18
    local step = (target - start) / math.max(1, steps)
    for i = 1, steps do
        blur.Size = blur.Size + step
        task.wait(dur / steps)
    end
    blur.Size = target
end

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
        if origCameraType then Camera.CameraType = origCameraType end
        if origCameraCFrame then Camera.CFrame = origCameraCFrame end
    end)
end

-- ========== Утилиты GUI ==========
local function makeScreenGui(name)
    local sg = Instance.new("ScreenGui")
    sg.Name = name
    sg.ResetOnSpawn = false
    sg.Parent = PlayerGui
    sg:SetAttribute("GAG_ByScript", true)
    return sg
end

local function centerFrame(parent, w, h)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0, w, 0, h)
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.new(0.5, 0, 0.5, 0)
    f.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    f.BorderSizePixel = 0
    local uc = Instance.new("UICorner", f); uc.CornerRadius = UDim.new(0, 10)
    return f
end

local function makeLabel(parent, y, text, size, bold)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -24, 0, size or 24)
    lbl.Position = UDim2.new(0, 12, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or ""
    lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextSize = (size and (size-4)) or 16
    lbl.TextColor3 = Color3.fromRGB(240,240,240)
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    return lbl
end

local function makeButton(parent, y, text, wPercent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(wPercent or 0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(42,42,42)
    btn.BorderSizePixel = 0
    local uc = Instance.new("UICorner", btn); uc.CornerRadius = UDim.new(0,6)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Text = text
    return btn
end

local function tweenObject(obj, props, time)
    local info = TweenInfo.new(time or 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function clearOurGui()
    for _, v in pairs(PlayerGui:GetChildren()) do
        if v:GetAttribute and v:GetAttribute("GAG_ByScript") then
            v:Destroy()
        end
    end
    restoreCamera()
    pcall(function() tweenBlur(0, 0.2) end)
end

-- ========== Loading ========== 
local function showLoading(text, dur)
    dur = dur or 1.6
    local sg = makeScreenGui("GAG_Loading")
    local frame = centerFrame(sg, 320, 110)
    local label = makeLabel(frame, 18, text or "Loading...", 22, true)
    tweenBlur(18, 0.25)
    freezeCamera()
    task.wait(dur)
    if sg and sg.Parent then sg:Destroy() end
end

-- ========== ESP & AutoCollect ==========
local espActive = false
local autoActive = false
local espMap = {} -- part -> billboard

local function nameMatchesAny(name, tbl)
    local ln = (name or ""):lower()
    for _, pat in ipairs(tbl) do
        if string.find(ln, pat:lower()) then
            return true
        end
    end
    return false
end

local function createBillboard(part, color, labelText)
    if not part or not part:IsA("BasePart") then return end
    if espMap[part] then return end
    local bg = Instance.new("BillboardGui")
    bg.Adornee = part
    bg.Size = UDim2.new(0,140,0,36)
    bg.AlwaysOnTop = true
    bg.StudsOffset = Vector3.new(0, 1.5, 0)
    bg.Parent = PlayerGui

    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.Text = labelText or part.Name
    txt.TextColor3 = color

    espMap[part] = bg
end

local function clearEsp()
    for p, gui in pairs(espMap) do
        if gui and gui.Parent then gui:Destroy() end
    end
    espMap = {}
end

local function scanEsp()
    if not espActive then 
        clearEsp()
        return 
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Parent then
            if nameMatchesAny(obj.Name, EXPENSIVE_FRUITS) then
                pcall(createBillboard, obj, Color3.fromRGB(255,200,60), "Дорогой: "..obj.Name)
            end
        end
    end
end

local function tryCollect(part)
    if not part or not part.Parent then return false end
    -- ProximityPrompt first
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
    -- firetouchinterest fallback (if available)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        if typeof(firetouchinterest) == "function" then
            pcall(function()
                firetouchinterest(hrp, part, 0)
                firetouchinterest(hrp, part, 1)
            end)
            return true
        else
            -- safe short teleport fallback
            local ok, prev = pcall(function() return hrp.CFrame end)
            if ok and prev then
                pcall(function()
                    hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.09)
                    hrp.CFrame = prev
                end)
                return true
            end
        end
    end
    return false
end

local function scanCollect()
    if not autoActive then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Parent then
            if nameMatchesAny(obj.Name, CHEAP_FRUITS) then
                pcall(tryCollect, obj)
            end
        end
    end
end

-- background loops (safe)
spawn(function()
    while true do
        if espActive then pcall(scanEsp) end
        task.wait(1.1)
    end
end)
spawn(function()
    while true do
        if autoActive then pcall(scanCollect) end
        task.wait(0.9)
    end
end)

-- ========== Build Key UI ==========
local function createKeyUI()
    local sg = makeScreenGui("GAG_KeyUI")
    local frame = centerFrame(sg, 420, 260)

    -- title
    local title = makeLabel(frame, 10, "Ronix Hub Key System", 22, true)
    -- info
    makeLabel(frame, 56, "Введите ключ чтобы продолжить:", 16, false)

    -- textbox
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.9, 0, 0, 36)
    box.Position = UDim2.new(0.05, 0, 0, 100)
    box.BackgroundColor3 = Color3.fromRGB(36,36,36)
    box.PlaceholderText = "Введите ключ..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.TextColor3 = Color3.fromRGB(240,240,240)
    local ub = Instance.new("UICorner", box); ub.CornerRadius = UDim.new(0,6)

    local enter = makeButton(frame, 152, "Проверить ключ")
    local feedback = makeLabel(frame, 196, "", 16, false)

    enter.MouseButton1Click:Connect(function()
        if box.Text == CORRECT_KEY then
            feedback.Text = "Ключ верный. Запуск..."
            feedback.TextColor3 = Color3.fromRGB(150,255,150)
            tweenObject(frame, {Size = UDim2.new(0, MAIN_W+40, 0, MAIN_H+40)}, 0.22)
            tweenBlur(20, 0.28)
            freezeCamera()
            task.wait(0.28)
            if sg and sg.Parent then sg:Destroy() end
            showLoading("Применение настроек...", 1.0)
            createMainMenu(false)
        else
            feedback.Text = "Неверный ключ!"
            feedback.TextColor3 = Color3.fromRGB(255,140,140)
            box.Text = ""
        end
    end)
end

-- ========== Build Main Menu ==========
function createMainMenu(isEmpty)
    isEmpty = isEmpty or false
    local sg = makeScreenGui("GAG_MainMenu")
    local frame = centerFrame(sg, MAIN_W, MAIN_H)

    -- header area (drag + title + controls)
    local header = Instance.new("Frame", frame)
    header.Size = UDim2.new(1, -40, 0, 48)
    header.Position = UDim2.new(0, 20, 0, 12)
    header.BackgroundTransparency = 1

    local title = makeLabel(header, 0, isEmpty and "" or "Что хотите выбрать", 20, true)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Center

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -36, 0, 6)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BackgroundColor3 = Color3.fromRGB(190,55,55)
    local cc = Instance.new("UICorner", closeBtn); cc.CornerRadius = UDim.new(0,6)
    closeBtn.MouseButton1Click:Connect(function() clearOurGui() end)

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -76, 0, 6)
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 20
    minBtn.BackgroundColor3 = Color3.fromRGB(110,110,110)
    local mc = Instance.new("UICorner", minBtn); mc.CornerRadius = UDim.new(0,6)

    -- main body
    local offsetY = 70
    if not isEmpty then
        -- buttons
        local b1 = makeButton(frame, offsetY, "99night"); offsetY = offsetY + 48
        local b2 = makeButton(frame, offsetY, "Steal A brainrot"); offsetY = offsetY + 48
        local b3 = makeButton(frame, offsetY, "Grow a garden"); offsetY = offsetY + 48

        local feedback = makeLabel(frame, offsetY, "", 16, false); offsetY = offsetY + 36

        local espBtn = makeButton(frame, offsetY, "ESP (дорогие): ВЫКЛ", 0.47)
        espBtn.Position = UDim2.new(0.05, 0, 0, offsetY)
        local acBtn = makeButton(frame, offsetY, "AutoCollect (деш): ВЫКЛ", 0.47)
        acBtn.Position = UDim2.new(0.52, 0, 0, offsetY)
        offsetY = offsetY + 46

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
            feedback.TextColor3 = Color3.fromRGB(150,255,150)
            tweenObject(frame, {BackgroundTransparency = 0.6}, 0.18)
            task.wait(0.18)
            showLoading("Применение Grow a Garden...", 1.6)
            if sg and sg.Parent then sg:Destroy() end
            createMainMenu(true) -- пустое меню того же размера
            -- теперь пользователь в пустом меню может включать ESP/Auto через переключатели
        end)

        espBtn.MouseButton1Click:Connect(function()
            espActive = not espActive
            espBtn.Text = "ESP (дорогие): " .. (espActive and "ВКЛ" or "ВЫКЛ")
            espBtn.BackgroundColor3 = espActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(42,42,42)
            if not espActive then clearEsp() end
        end)

        acBtn.MouseButton1Click:Connect(function()
            autoActive = not autoActive
            acBtn.Text = "AutoCollect (деш): " .. (autoActive and "ВКЛ" or "ВЫКЛ")
            acBtn.BackgroundColor3 = autoActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(42,42,42)
        end)
    else
        -- пустое меню: такие же размеры, переключатели внизу
        makeLabel(frame, 120, "Меню пусто. Размер и позиция те же.", 16, false)
        local ypos = 170
        local espBtn2 = makeButton(frame, ypos, "ESP (дорогие): ВЫКЛ", 0.47)
        espBtn2.Position = UDim2.new(0.05, 0, 0, ypos)
        local acBtn2 = makeButton(frame, ypos, "AutoCollect (деш): ВЫКЛ", 0.47)
        acBtn2.Position = UDim2.new(0.52, 0, 0, ypos)
        espBtn2.MouseButton1Click:Connect(function()
            espActive = not espActive
            espBtn2.Text = "ESP (дорогие): " .. (espActive and "ВКЛ" or "ВЫКЛ")
            espBtn2.BackgroundColor3 = espActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(42,42,42)
            if not espActive then clearEsp() end
        end)
        acBtn2.MouseButton1Click:Connect(function()
            autoActive = not autoActive
            acBtn2.Text = "AutoCollect (деш): " .. (autoActive and "ВКЛ" or "ВЫКЛ")
            acBtn2.BackgroundColor3 = autoActive and Color3.fromRGB(70,150,70) or Color3.fromRGB(42,42,42)
        end)
    end

    -- Dragging header (works on mobile & PC)
    local dragging, dragStart, startPos
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

    -- Minimize behavior: center mini panel
    local miniGui
    minBtn.MouseButton1Click:Connect(function()
        sg.Enabled = false
        miniGui = makeScreenGui("GAG_Mini")
        local mini = Instance.new("Frame", miniGui)
        mini.Size = UDim2.new(0, 90, 0, 90)
        mini.AnchorPoint = Vector2.new(0.5, 0.5)
        mini.Position = UDim2.new(0.5, 0.5, 0, 0)
        mini.BackgroundColor3 = Color3.fromRGB(28,28,28)
        local ucm = Instance.new("UICorner", mini); ucm.CornerRadius = UDim.new(0,18)
        local plus = Instance.new("TextButton", mini)
        plus.Size = UDim2.new(0.75,0,0.75,0); plus.Position = UDim2.new(0.125,0,0.125,0)
        plus.Text = "+"; plus.Font = Enum.Font.GothamBold; plus.TextSize = 30
        plus.BackgroundTransparency = 1; plus.TextColor3 = Color3.fromRGB(240,240,240)

        -- dragging mini
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
            if miniGui and miniGui.Parent then miniGui:Destroy() end
            sg.Enabled = true
        end)
    end)
end

-- ========== Sequence start ==========
clearOurGui()
showLoading("Loading...", 1.6)
createKeyUI()

-- Скрипт завершён. Если будут ошибки в эксплойтере, пришли текст ошибки или скрин — поправлю.
