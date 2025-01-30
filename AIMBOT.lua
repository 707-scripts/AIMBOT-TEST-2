-- Chargement sécurisé de la librairie UI
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Custom Aimbot Menu", "DarkTheme") -- Par défaut DarkTheme

-- Services Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Variables
local guiVisible = true
local aimbotEnabled = false
local silentAimEnabled = false
local lockPart = "Head"
local sensitivity = 0.15
local fovEnabled = false
local fovRadius = 150

-- Cercle FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.new(1, 0, 0)
fovCircle.Thickness = 1.5
fovCircle.NumSides = 100
fovCircle.Filled = false

-- MAJ du cercle FOV
RunService.RenderStepped:Connect(function()
    if fovEnabled then
        fovCircle.Visible = true
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        fovCircle.Radius = fovRadius
    else
        fovCircle.Visible = false
    end
end)

-- **🌟 Onglet Aimbot**
local mainTab = window:NewTab("Main")
local mainSection = mainTab:NewSection("Aimbot Settings")

mainSection:NewToggle("Aimbot", "Activer/Désactiver l'aimbot", function(state)
    aimbotEnabled = state
end)

mainSection:NewToggle("Silent Aim", "Activer/Désactiver Silent Aim", function(state)
    silentAimEnabled = state
end)

mainSection:NewDropdown("Lock Part", "Sélectionnez la partie du corps", {"Head", "Torso", "Legs"}, function(selected)
    lockPart = selected
end)

mainSection:NewSlider("Sensitivity", "Réglez la sensibilité", 100, 5, function(value)
    sensitivity = value / 500
end)

-- **🎯 Onglet FOV**
local fovTab = window:NewTab("FOV")
local fovSection = fovTab:NewSection("Field of View")

fovSection:NewToggle("Enable FOV", "Activer le cercle FOV", function(state)
    fovEnabled = state
end)

fovSection:NewSlider("FOV Radius", "Réglez le rayon du FOV", 300, 10, function(value)
    fovRadius = value
end)

-- **🎨 Onglet Couleur**
local colorTab = window:NewTab("Color")
local colorSection = colorTab:NewSection("Changer la couleur du GUI")

colorSection:NewDropdown("Theme", "Choisir un thème", {"DarkTheme", "LightTheme", "BloodTheme", "GrapeTheme"}, function(theme)
    library.ChangeTheme(theme)
end)

-- **📌 Raccourci pour afficher/masquer le GUI**
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        guiVisible = not guiVisible
        library:ToggleUI(guiVisible)
    end
end)

-- **🔎 Fonction pour trouver la meilleure cible**
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team ~= LocalPlayer.Team then
            local character = player.Character
            local root = character:FindFirstChild("HumanoidRootPart")
            local part = character:FindFirstChild(lockPart)

            if root and part then
                local screenPos = Camera:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                if distance < shortestDistance and distance <= fovRadius then
                    closest = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

-- **🎯 Aimbot optimisé (lissage amélioré)**
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(lockPart) then
            local part = target.Character:FindFirstChild(lockPart)
            if part then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), sensitivity)
            end
        end
    end
end)

-- **💀 Silent Aim amélioré (tir automatique sur la cible)**
mouse.TargetFilter = Workspace
RunService.RenderStepped:Connect(function()
    if silentAimEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(lockPart) then
            local part = target.Character:FindFirstChild(lockPart)
            if part then
                Mouse.Hit = part.CFrame
            end
        end
    end
end)

-- **📌 Onglet créateur**
local creatorTab = window:NewTab("Creator")
local creatorSection = creatorTab:NewSection("Script Creator")
creatorSection:NewLabel("Script créé par LA TEAM 707.")
creatorSection:NewLabel("Discord: https://discord.gg/GhQDgqx2HP")
