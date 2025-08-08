-- DELTA MOBILE LOADER (MINIMAL)
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Главное меню (адаптивное)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.95, 0, 0.7, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = gui

-- Скругленные углы
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = frame

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.Size = UDim2.new(0.1, 0, 0.1, 0)
closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Текст
local text = Instance.new("TextLabel")
text.Text = "by:monster6715"
text.TextColor3 = Color3.fromRGB(0, 255, 187)
text.Size = UDim2.new(1, 0, 0.8, 0)
text.Position = UDim2.new(0, 0, 0.2, 0)
text.BackgroundTransparency = 1
text.Parent = frame

print("Меню загружено!")
