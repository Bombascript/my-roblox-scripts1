-- ServerScriptService içinde bir Script
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        
        -- Panelin oluşturulması (siyah panel)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = player:WaitForChild("PlayerGui")

        -- Siyah paneli oluştur
        local blackPanel = Instance.new("Frame")
        blackPanel.Parent = screenGui
        blackPanel.Size = UDim2.new(0.5, 0, 0.5, 0)  -- Panel boyutu
        blackPanel.Position = UDim2.new(0.25, 0, 0.25, 0)  -- Panel konumu
        blackPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        blackPanel.BackgroundTransparency = 0.5
        blackPanel.ZIndex = 10
        
        -- Panel üzerindeki başlık metni
        local panelText = Instance.new("TextLabel")
        panelText.Parent = blackPanel
        panelText.Size = UDim2.new(1, 0, 0.2, 0)
        panelText.Position = UDim2.new(0, 0, 0, 0)
        panelText.Text = "Korkunç Efektler"
        panelText.TextSize = 30
        panelText.TextColor3 = Color3.fromRGB(255, 255, 255)
        panelText.TextStrokeTransparency = 0.5
        panelText.TextAlign = Enum.TextAlign.Center
        panelText.BackgroundTransparency = 1
        
        -- Jumpscare Butonu
        local jumpscareButton = Instance.new("TextButton")
        jumpscareButton.Parent = blackPanel
        jumpscareButton.Size = UDim2.new(0.8, 0, 0.2, 0)
        jumpscareButton.Position = UDim2.new(0.1, 0, 0.3, 0)
        jumpscareButton.Text = "Jumpscare Başlat"
        jumpscareButton.TextSize = 20
        jumpscareButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpscareButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        jumpscareButton.BackgroundTransparency = 0.5
        jumpscareButton.ZIndex = 20
        
        -- Sticker Spam Butonu
        local stickerSpamButton = Instance.new("TextButton")
        stickerSpamButton.Parent = blackPanel
        stickerSpamButton.Size = UDim2.new(0.8, 0, 0.2, 0)
        stickerSpamButton.Position = UDim2.new(0.1, 0, 0.55, 0)
        stickerSpamButton.Text = "Sticker Spam Başlat"
        stickerSpamButton.TextSize = 20
        stickerSpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        stickerSpamButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        stickerSpamButton.BackgroundTransparency = 0.5
        stickerSpamButton.ZIndex = 20
        
        -- Chat Spam Butonu
        local chatSpamButton = Instance.new("TextButton")
        chatSpamButton.Parent = blackPanel
        chatSpamButton.Size = UDim2.new(0.8, 0, 0.2, 0)
        chatSpamButton.Position = UDim2.new(0.1, 0, 0.8, 0)
        chatSpamButton.Text = "Chat Spam Başlat"
        chatSpamButton.TextSize = 20
        chatSpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        chatSpamButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
        chatSpamButton.BackgroundTransparency = 0.5
        chatSpamButton.ZIndex = 20
        
        -- 1. Jumpscare Efektini Tetikleyen Fonksiyon
        jumpscareButton.MouseButton1Click:Connect(function()
            -- Jumpscare görselini yarat
            local jumpscare = Instance.new("ImageLabel")
            jumpscare.Parent = blackPanel
            jumpscare.Size = UDim2.new(1, 0, 0.9, 0)
            jumpscare.Position = UDim2.new(0, 0, 0.1, 0)
            jumpscare.BackgroundTransparency = 1
            jumpscare.Image = "rbxassetid://14836747649"  -- Verdiğiniz decal ID'sini kullandık
            jumpscare.ZIndex = 10  -- Görseli ön planda tutmak için

            -- Çığlık sesi ekle
            local screamSound = Instance.new("Sound")
            screamSound.SoundId = "rbxassetid://1833835660"  -- Korkunç çığlık sesi
            screamSound.Volume = 1  -- Sesin yüksekliği
            screamSound.Parent = character
            screamSound:Play()

            -- Görseli 1 saniye sonra kaldır
            wait(1)
            jumpscare:Destroy()
        end)
        
        -- 2. Sticker Spam Efektini Tetikleyen Fonksiyon
        stickerSpamButton.MouseButton1Click:Connect(function()
            -- Stickerları her duvara yerleştirmek için
            while true do
                -- Her oyuncu için Sticker ekle
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local sticker = Instance.new("BillboardGui")
                        sticker.Parent = p.Character.HumanoidRootPart
                        sticker.Size = UDim2.new(0, 100, 0, 100)
                        sticker.Adornee = p.Character.HumanoidRootPart
                        sticker.AlwaysOnTop = true  -- Her zaman görünür kıl
                        local img = Instance.new("ImageLabel")
                        img.Parent = sticker
                        img.Size = UDim2.new(1, 0, 1, 0)
                        img.Image = "rbxassetid://14836747649"  -- Sticker görseli için asset ID'sini buraya ekleyin
                    end
                end
                wait(1)  -- Her saniye bir sticker spawn olacak
            end
        end)
        
        -- 3. Chat Spam Efektini Tetikleyen Fonksiyon
        chatSpamButton.MouseButton1Click:Connect(function()
            -- Spam chat başlat (herkes için geçerli)
            while true do
                for _, p in pairs(game.Players:GetPlayers()) do
                    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("FR3ST1 JOINED THE GAME", "All")
                end
                wait(0.5)  -- Her yarım saniyede bir mesaj gönderecek
            end
        end)
    end)
end)
