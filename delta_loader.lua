-- DELTA-STYLE LOADER WITH ANIMATION
local function CreateLoader()
    -- Создаём экран загрузки
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaLoaderUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Фон
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.Parent = screenGui

    -- Крутящееся колесо загрузки
    local loader = Instance.new("ImageLabel")
    loader.Name = "LoadingCircle"
    loader.Size = UDim2.new(0, 80, 0, 80)
    loader.Position = UDim2.new(0.5, -40, 0.5, -40)
    loader.BackgroundTransparency = 1
    loader.Image = "rbxassetid://3570695787" -- стандартный спиннер
    loader.Parent = frame

    -- Анимация вращения
    local spin = game:GetService("RunService").RenderStepped:Connect(function(delta)
        loader.Rotation = loader.Rotation + (delta * 180)
    end)

    -- Текст загрузки
    local text = Instance.new("TextLabel")
    text.Text = "DELTA LOADING..."
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Font = Enum.Font.Code
    text.Size = UDim2.new(1, 0, 0, 30)
    text.Position = UDim2.new(0, 0, 0.6, 0)
    text.BackgroundTransparency = 1
    text.TextSize = 20
    text.Parent = frame

    return {
        Destroy = function()
            spin:Disconnect()
            screenGui:Destroy()
        end,
        ShowMenu = function()
            -- Создаём пустое меню
            local menuFrame = Instance.new("Frame")
            menuFrame.Size = UDim2.new(0, 300, 0, 400)
            menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
            menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            menuFrame.Parent = screenGui
            
            -- Можно добавить элементы меню здесь
            local title = Instance.new("TextLabel")
            title.Text = "DELTA MENU"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.Size = UDim2.new(1, 0, 0, 40)
            title.Font = Enum.Font.Code
            title.TextSize = 24
            title.Parent = menuFrame
            
            text:Destroy()
            loader:Destroy()
        end
    }
end

-- Симуляция загрузки
local loader = CreateLoader()
wait(3) -- Задержка 3 секунды (имитация загрузки)
loader.ShowMenu() -- Показываем меню
-- loader.Destroy() -- Если нужно полностью убрать интерфейс
