-- Windy.lua
-- Steal Brainrot AutoBuyer FINAL with Autosave + Anti-AFK

-- === Анти-АФК ===
pcall(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        print("[Anti-AFK] Sent fake input to prevent kick")
    end)
end)

-- === Найди RemoteEvent ===
local REMOTE_NAME = "BuyBrainrot" -- Замени на актуальное имя если надо!
local remote = nil
for _,v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find(REMOTE_NAME:lower()) then
        remote = v
        break
    end
end

if not remote then
    warn("[AutoBuy] RemoteEvent не найден!")
    return
else
    print("[AutoBuy] Найден RemoteEvent:", remote.Name)
end

-- === OrionLib ===
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Steal Brainrot AutoBuyer", HidePremium = false, IntroEnabled = false})

-- === Переменные ===
getgenv().SB_Settings = getgenv().SB_Settings or {
    Rarities = {},
    Mutations = {},
    Brainrots = {},
    Delay = 2
}

local selectedRarities = SB_Settings.Rarities
local selectedMutations = SB_Settings.Mutations
local selectedBrainrots = SB_Settings.Brainrots
local delay = SB_Settings.Delay or 2
local buying = false

local function saveSettings()
    SB_Settings.Rarities = selectedRarities
    SB_Settings.Mutations = selectedMutations
    SB_Settings.Brainrots = selectedBrainrots
    SB_Settings.Delay = delay
    print("[AutoBuy] Настройки сохранены!")
end

-- === UI ===
local Tab = Window:MakeTab({
    Name = "Auto Buyer",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddDropdown({
    Name = "Select Rarities",
    Options = {"Common", "Rare", "Epic", "Legendary", "Mythic", "Brainrot God", "Secret"},
    Default = selectedRarities,
    Multi = true,
    Callback = function(Value)
        selectedRarities = Value
        saveSettings()
    end
})

Tab:AddDropdown({
    Name = "Select Mutations",
    Options = {"golden", "diamond", "candy", "rainbow"},
    Default = selectedMutations,
    Multi = true,
    Callback = function(Value)
        selectedMutations = Value
        saveSettings()
    end
})

Tab:AddDropdown({
    Name = "Select Brainrots",
    Options = {
"Noobini Pizzanini","Lirilì Larilà","Tim Cheese","Fluriflura","Talpa Di Fero","Svinina Bombardino","Pipi Kiwi",
"Trippi Troppi","Tung Tung Tung Sahur","Gangster Footera","Bandito Bobritto","Boneca Ambalabu","Ta Ta Ta Ta Sahur",
"Tric Trac Baraboom","Cappuccino Assassino","Brr Brr Patapim","Trulimero Trulicina","Bambini Crostini",
"Bananita Dolphinita","Perochello Lemonchello","Brri Brri Bicus Dicus Bombicus","Burbaloni Loliloli",
"Chimpanzini Bananini","Ballerina Cappuccina","Chef Crabracadabra","Lionel Cactuseli","Glorbo Fruttodrillo",
"Blueberrinni Octopusini","Frigo Camelo","Orangutini Ananassini","Rhino Toasterino","Bombardiro Crocodilo",
"Bombombini Gusini","Cavallo Virtuoso","Cocofanto Elefanto","Gattatino Nyanino","Girafa Celestre","Matteo",
"Tralalero Tralala","Odin Din Din Dun","Unclito Samito","Trenostruzzo Turbo 3000","La Vacca Saturno Saturnita",
"Sammyni Spiderini","Los Tralaleritos","Graipuss Medussi","La Grande Combinazione","Garama and Madundung",
"Lucky Block","Orcalero Orcala","Pot Hotspot"
    },
    Default = selectedBrainrots,
    Multi = true,
    Callback = function(Value)
        selectedBrainrots = Value
        saveSettings()
    end
})

Tab:AddSlider({
    Name = "Delay Between Buys (sec)",
    Min = 1,
    Max = 10,
    Default = delay,
    Increment = 1,
    ValueName = "seconds",
    Callback = function(Value)
        delay = Value
        saveSettings()
    end
})

Tab:AddButton({
    Name = "▶️ Start Auto Buying",
    Callback = function()
        if buying then
            OrionLib:MakeNotification({
                Name = "Already Running",
                Content = "Stop first before restarting",
                Time = 2
            })
            return
        end

        buying = true
        OrionLib:MakeNotification({
            Name = "Started",
            Content = "AutoBuyer started!",
            Time = 2
        })

        while buying do
            for _, rarity in ipairs(selectedRarities) do
                for _, mutation in ipairs(selectedMutations) do
                    for _, brainrot in ipairs(selectedBrainrots) do
                        local args = {
                            Rarity = rarity,
                            Name = brainrot,
                            Mutation = mutation
                        }
                        print("[AutoBuy] Buying:", rarity, mutation, brainrot)
                        remote:FireServer(args)
                        task.wait(delay)
                    end
                end
            end
        end
    end
})

Tab:AddButton({
    Name = "⏹ Stop Auto Buying",
    Callback = function()
        buying = false
        OrionLib:MakeNotification({
            Name = "Stopped",
            Content = "AutoBuyer stopped.",
            Time = 2
        })
    end
})
