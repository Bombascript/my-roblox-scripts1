--[[
  Полный Lua-скрипт для Delta/Synapse
  Функции:
    - Loading -> key (monster6715) -> transition -> menu "Что хотите выбрать"
    - Кнопки 99night, Steal A brainrot (ошибка), Grow a garden (успешно -> вторая загрузка -> запускает ESP и AutoCollect для Grow a Garden)
    - Свернуть ("-") -> маленькое меню с "+" (перемещаемое)
    - Окно перетаскивается на ПК и мобильных
    - Камера статична (временно ставится Scriptable), восстанавливается при закрытии
    - ESP/AutoCollect не активны сразу; есть переключатели в меню
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ========== Параметры ==========
local CORRECT_KEY = "monster6715"
local MAIN_WIDTH = 520
local MAIN_HEIGHT = 360

-- Список "дорогих" фруктов (взяты типовые названия — можно дополнять)
local EXPENSIVE_FRUITS = {
    "Dragon Fruit", "Traveler's Fruit", "Moon Melon", "Pineapple",
    "Mango", "Sugar Apple", "Hive Fruit", "Ember Lily"
}

-- Список "дешёвых" фруктов (для автосбора)
local CHEAP_FRUITS = {
    "Apple", "Banana", "Strawberry", "Carrot", "Orange"
}

-- Вспомогательные функции (твины)
local function tweenGui(propTable, obj, time, style, dir)
    local info = TweenInfo.new(time or 0.25, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    local tween = TweenService:Create(obj, info, propTable)
    tween:Play()
    return tween
end

-- Сохранить оригинальную камеру, чтобы вернуть позже
local Camera = workspace.CurrentCamera
local origCameraType = Camera.CameraType
local origCameraCFrame = Camera.CFrame

local function freezeCamera()
    -- делаем камеру статичной (не реагирует на движение игрока)
    pcall(function()
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

-- Размытие фона (lighting blur)
local blur = Instance.new("BlurEffect")
blur.Parent = Lighting
blur.Size = 0

local function tweenBlur(target, dur)
    dur = dur or 0.4
    local start = blur.Size
    local steps = 20
    local step = (target - start) / steps
    for i = 1, steps do
        blur.Size = blur.Size + step
        task.wait(dur/steps)
    end
    blur.Size = target
end

-- Очистка GUI (удалить все, созданные этим скриптом)
local function clearOurGui()
    for _,v in ipairs(PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v:GetAttribute("GagByScript") then
            v:Destroy()
        end
    end
    restoreCamera()
    tweenBlur(0)
end

-- ========== Loading GUI ==========
local function createLoading(text, duration)
    duration = duration or 1.8
    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name = "GAG_Loading"
    sg:SetAttribute("GagByScript", true)

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 300, 0, 110)
    frame.Position = UDim2.new(0.5, -150, 0.5, -55)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.ZIndex = 5
    local corner = Instance.new("UICorner", frame); corner.CornerRadius = UDim.new(0,10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 1, -20)
    label.Position = UDim2.new(0,10,0,10)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.Text = text or "Loading..."

    tweenBlur(18, 0.35)
    freezeCamera()
    task.wait(duration)
    sg:Destroy()
end

-- ========== UI Creation Helpers ==========
local function makeScreenGui(name)
    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name = name
    sg.ResetOnSpawn = false
    sg:SetAttribute("GagByScript", true)
    return sg
end

local function makeFrame(parent, w, h, x, y)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0, w, 0, h)
    f.Position = UDim2.new(0.5, x - w/2, 0.5, y - h/2) -- x,y center coords
    f.BackgroundColor3 = Color3.fromRGB(22,22,22)
    f.BorderSizePixel = 0
    local c = Instance.new("UICorner", f); c.CornerRadius = UDim.new(0,10)
    return f
end

local function makeTextLabel(parent, posY, text, size)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -20, 0, size or 28)
    lbl.Position = UDim2.new(0, 10, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(235,235,235)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 15
    lbl.TextWrapped = true
    lbl.Text = text or ""
    return lbl
end

local function makeButton(parent, posY, txt, wPercent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(wPercent or 0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Text = txt
    local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0,6)
    return btn
end

-- ========== Main menu builder ==========
local function createMainMenu(isEmpty)
    isEmpty = isEmpty or false
    local sg = makeScreenGui("GAG_MainMenu")
    local frame = makeFrame(sg, MAIN_WIDTH, MAIN_HEIGHT, 0, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)

    -- header + close + minimize
    local header = Instance.new("Frame", frame)
    header.Size = UDim2.new(1, -40, 0, 44)
    header.Position = UDim2.new(0, 10, 0, 8)
    header.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Text = isEmpty and " " or "Ronix Hub Key System"
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0,30,0,30)
    closeBtn.Position = UDim2.new(1, -34, 0, 2)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BackgroundColor3 = Color3.fromRGB(190,55,55)
    local cc = Instance.new("UICorner", closeBtn); cc.CornerRadius = UDim.new(0,6)
    closeBtn.MouseButton1Click:Connect(function()
        clearOurGui()
    end)

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0,28,0,28)
    minBtn.Position = UDim2.new(1, -70, 0, 4)
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 18
    minBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
    local mc = Instance.new("UICorner", minBtn); mc.CornerRadius = UDim.new(0,6)

    -- Body
    local bodyY = 62
    if not isEmpty then
        local subtitle = makeTextLabel(frame, bodyY, "Что хотите выбрать", 26)
        subtitle.Font = Enum.Font.GothamBold
        subtitle.TextSize = 18
        bodyY = bodyY + 42

        -- buttons
        local b1 = makeButton(frame, bodyY, "99night")
        bodyY = bodyY + 46
        local b2 = makeButton(frame, bodyY, "Steal A brainrot")
        bodyY = bodyY + 46
        local b3 = makeButton(frame, bodyY, "Grow a garden")
        bodyY = bodyY + 46

        -- feedback label
        local fb = makeTextLabel(frame, bodyY, "", 22)
        bodyY = bodyY + 34

        -- переключатели ESP / AutoCollect (по умолчанию false)
        local togglesY = bodyY
        local espToggle = makeButton(frame, togglesY, "ESP (дорогие фрукты): ВЫКЛ", 0.44)
        espToggle.Position = UDim2.new(0.05, 0, 0, togglesY)
        local acToggle = makeButton(frame, togglesY, "AutoCollect (дешевые): ВЫКЛ", 0.44)
        acToggle.Position = UDim2.new(0.51, 0, 0, togglesY)
        bodyY = bodyY + 46

        -- скрываем активность функций сразу
        local espActive = false
        local autoActive = false

        -- Обработчики для 99night и Steal A brainrot
        b1.MouseButton1Click:Connect(function()
            fb.Text = "Ошибка: не готово."
            fb.TextColor3 = Color3.new(1,0.4,0.4)
        end)
        b2.MouseButton1Click:Connect(function()
            fb.Text = "Ошибка: не готово."
            fb.TextColor3 = Color3.new(1,0.4,0.4)
        end)

        -- Grow a garden handler
        b3.MouseButton1Click:Connect(function()
            fb.Text = "Успешно. Запуск Grow a garden..."
            fb.TextColor3 = Color3.new(0.6,1,0.6)
            -- имитация перехода + дополнительная загрузка
            tweenGui({BackgroundTransparency = 0.6}, frame, 0.25, "Quad", "Out")
            task.wait(0.25)
            createLoading("Applying Grow a Garden module...", 1.6)
            -- удалить меню и запустить пустое меню (как просил)
            sg:Destroy()
            createMainMenu(true) -- пустое меню такое же
            -- включать/запускать функционал модулей — оставляем выключенным, пользователь включит через переключатели
            -- запустим функции в фоновых корутинах, но они будут проверять espActive/autoActive
            -- (запускаем ниже в замыкании)
        end)

        -- переключатели
        espToggle.MouseButton1Click:Connect(function()
            espActive = not espActive
            espToggle.Text = "ESP (дорогие фрукты): " .. (espActive and "ВКЛ" or "ВЫКЛ")
            if espActive then
                espToggle.BackgroundColor3 = Color3.fromRGB(70,130,70)
            else
                espToggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
            end
        end)
        acToggle.MouseButton1Click:Connect(function()
            autoActive = not autoActive
            acToggle.Text = "AutoCollect (дешевые): " .. (autoActive and "ВКЛ" or "ВЫКЛ")
            if autoActive then
                acToggle.BackgroundColor3 = Color3.fromRGB(70,130,70)
            else
                acToggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
            end
        end)

        -- ========== ESP (дорогие фрукты) ==========
        local espObjects = {}

        local function clearEsp()
            for part, gui in pairs(espObjects) do
                if gui and gui.Parent then gui:Destroy() end
            end
            espObjects = {}
        end

        local function makeEspOnObject(obj)
            if not obj or not obj:IsA("BasePart") then return end
            if espObjects[obj] then return end
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = obj
            billboard.Size = UDim2.new(0,120,0,40)
            billboard.AlwaysOnTop = true
            billboard.Parent = PlayerGui

            local txt = Instance.new("TextLabel", billboard)
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.Text = obj.Name
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 14
            txt.TextColor3 = Color3.new(1,0.85,0.2)

            espObjects[obj] = billboard
        end

        local function updateEsp()
            if not espActive then
                clearEsp()
                return
            end
            -- проходим по workspace и ищем объекты, в названии которых есть имена дорогих фруктов
            for _, candidate in ipairs(workspace:GetDescendants()) do
                if candidate:IsA("BasePart") or candidate:IsA("MeshPart") then
                    local nm = candidate.Name:lower()
                    for _, fname in ipairs(EXPENSIVE_FRUITS) do
                        if string.find(nm, fname:lower():gsub("%s","")) or string.find(nm, fname:lower()) then
                            -- нашёл потенциальный дорогой фрукт
                            makeEspOnObject(candidate)
                        end
                    end
                end
            end
        end

        -- ========== AutoCollect (дешевые фрукты) ==========
        local function attemptCollect(part)
            if not part or not part:IsA("BasePart") then return end
            -- Если есть ProximityPrompt (часто в GAG могут быть интеракты) - нажмём
            for _, p in ipairs(part:GetDescendants()) do
                if p:IsA("ProximityPrompt") then
                    p:InputHoldBegin()
                    task.wait(0.05)
                    p:InputHoldEnd()
                    return true
                end
            end
            -- Попробуем firetouchinterest (некоторые эксплойты поддерживают)
            local hrp = Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Synapse-like function: firetouchinterest(humanoidRootPart, part, 0/1)
                -- Попытка обойти различия: если функция доступна, вызываем
                local succeed = false
                if typeof(firetouchinterest) == "function" then
                    pcall(function()
                        firetouchinterest(hrp, part, 0)
                        firetouchinterest(hrp, part, 1)
                        succeed = true
                    end)
                else
                    -- альтернативно: телепорт к объекту и назад (инвазивно)
                    local prev = hrp.CFrame
                    pcall(function()
                        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.12)
                        hrp.CFrame = prev
                    end)
                    succeed = true
                end
                return succeed
            end
            return false
        end

        local function updateAutoCollect()
            if not autoActive then return end
            -- ищем дешёвые фрукты в рабочем пространстве
            for _, candidate in ipairs(workspace:GetDescendants()) do
                if candidate:IsA("BasePart") or candidate:IsA("MeshPart") then
                    local nm = candidate.Name:lower()
                    for _, cheap in ipairs(CHEAP_FRUITS) do
                        if string.find(nm, cheap:lower():gsub("%s","")) or string.find(nm, cheap:lower()) then
                            -- пытаемся собрать
                            pcall(function() attemptCollect(candidate) end)
                        end
                    end
                end
            end
        end

        -- фоновые петли (корутины)
        spawn(function()
            while sg.Parent do
                if espActive then updateEsp() end
                task.wait(1.2)
            end
        end)

        spawn(function()
            while sg.Parent do
                if autoActive then updateAutoCollect() end
                task.wait(0.8)
            end
        end)
    else
        -- пустое меню: просто такое же окно (ничего неактивного внутри)
        local placeholder = makeTextLabel(frame, 120, "Меню пусто. Размер и место такие же.", 18)
        placeholder.Font = Enum.Font.Gotham
        placeholder.TextSize = 15
    end

    -- Перетаскивание для frame и для мобильных
    local dragging, dragStart, startPos, dragInput
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    header.InputEnded:Connect(function(input)
        dragging = false
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    -- ========== Minimize behavior (small floating panel) ==========
    local miniGui
    minBtn.MouseButton1Click:Connect(function()
        -- скрыть основной
        sg.Enabled = false
        -- создать маленькую панельку
        miniGui = makeScreenGui("GAG_Mini")
        local mini = Instance.new("Frame", miniGui)
        mini.Size = UDim2.new(0,70,0,70)
        mini.Position = UDim2.new(0.9, 0, 0.1, 0)
        mini.BackgroundColor3 = Color3.fromRGB(28,28,28)
        local mc = Instance.new("UICorner", mini); mc.CornerRadius = UDim.new(0,18)

        local plus = Instance.new("TextButton", mini)
        plus.Size = UDim2.new(1, -14, 1, -14)
        plus.Position = UDim2.new(0,7,0,7)
        plus.Text = "+"
        plus.Font = Enum.Font.GothamBold
        plus.TextSize = 28
        plus.BackgroundTransparency = 1
        plus.TextColor3 = Color3.fromRGB(220,220,220)

        -- мини-панель перетаскивание
        local d, ds, sp
        plus.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                d = true
                ds = i.Position
                sp = mini.Position
            end
        end)
        plus.InputEnded:Connect(function(i) d = false end)
        UserInputService.InputChanged:Connect(function(i)
            if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local delta = i.Position - ds
                mini.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
            end
        end)

        plus.MouseButton1Click:Connect(function()
            -- вернуть главное меню
            miniGui:Destroy()
            sg.Enabled = true
        end)
    end)
end

-- ========== Key input GUI ==========
local function createKeyGui()
    local sg = makeScreenGui("GAG_KeyGui")
    local frame = makeFrame(sg, 420, 260, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)

    local title = makeTextLabel(frame, 12, "Ronix Hub Key System", 24)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18

    local info = makeTextLabel(frame, 48, "Введите ключ чтобы продолжить:", 16)

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.9, 0, 0, 34)
    box.Position = UDim2.new(0.05, 0, 0, 100)
    box.PlaceholderText = "Введите ключ здесь"
    box.BackgroundColor3 = Color3.fromRGB(35,35,35)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    local bc = Instance.new("UICorner", box); bc.CornerRadius = UDim.new(0,6)

    local enter = makeButton(frame, 150, "Проверить ключ")
    local feedback = makeTextLabel(frame, 195, "", 18)

    enter.MouseButton1Click:Connect(function()
        if box.Text == CORRECT_KEY then
            feedback.Text = "Ключ верный. Запуск..."
            feedback.TextColor3 = Color3.new(0.6,1,0.6)
            -- имбовый переход (плавное увеличение/исчезание)
            tweenGui({Size = UDim2.new(0, MAIN_WIDTH+40, 0, MAIN_HEIGHT+40)}, frame, 0.22, "Back", "Out")
            tweenBlur(20, 0.3)
            task.wait(0.25)
            sg:Destroy()
            createLoading("Применение настроек...", 1.0)
            -- создаём основное меню
            createMainMenu(false)
        else
            feedback.Text = "Неверный ключ!"
            feedback.TextColor3 = Color3.new(1,0.4,0.4)
            box.Text = ""
        end
    end)
end

-- ========== Запуск последовательности ==========
-- Сначала очистим старые наши GUI
clearOurGui()
createLoading("Loading...", 1.8)
createKeyGui()

-- Важно: при закрытии всех GUI мы возвращаем камеру и убираем blur.
-- Пользователь может закрыть крестиком — вызовет clearOurGui().

-- Конец скрипта
