-- Chargement sécurisé de la librairie UI
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Custom Aimbot Menu", "DarkTheme") -- Par défaut DarkTheme

-- Services Roblox encapsulés
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ws = workspace
local cam = ws.CurrentCamera
local lp = plrs.LocalPlayer
local mouse = lp:GetMouse()

-- Variables globales
local guiVisible = true
local aimbot = false
local silentAim = false
local lockPart = "Head"
local sensitivity = 0.1
local fovEnabled = false
local fovRadius = 200

-- Cercle FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.new(1, 0, 0)
fovCircle.Thickness = 1.5
fovCircle.NumSides = 100
fovCircle.Filled = false

-- Mise à jour du cercle FOV
rs.RenderStepped:Connect(function()
    if fovEnabled then
        fovCircle.Visible = true
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
        fovCircle.Radius = fovRadius
    else
        fovCircle.Visible = false
    end
end)

-- Onglet principal
local mainTab = window:NewTab("Main")
local mainSection = mainTab:NewSection("Aimbot Settings")

mainSection:NewToggle("Aimbot", "Activer ou désactiver l'aimbot", function(state)
    aimbot = state
end)

mainSection:NewToggle("Silent Aim", "Activer ou désactiver le Silent Aim", function(state)
    silentAim = state
end)

mainSection:NewDropdown("Lock Part", "Choisissez une partie du corps", {"Head", "Torso", "Legs"}, function(part)
    lockPart = part
end)

mainSection:NewSlider("Sensitivity", "Ajuster la sensibilité", 100, 1, function(value)
    sensitivity = value / 1000
end)

-- Onglet FOV
local fovTab = window:NewTab("FOV")
local fovSection = fovTab:NewSection("Field of View")

fovSection:NewToggle("Enable FOV", "Activer le cercle FOV", function(state)
    fovEnabled = state
end)

fovSection:NewSlider("FOV Radius", "Ajuster le rayon du FOV", 300, 10, function(value)
    fovRadius = value
end)

-- Onglet Couleur
local colorTab = window:NewTab("Color")
local colorSection = colorTab:NewSection("Changer la couleur du GUI")

colorSection:NewDropdown("Theme", "Choisir un thème", {"DarkTheme", "LightTheme", "BloodTheme", "GrapeTheme"}, function(theme)
    library.ChangeTheme(theme)
end)

-- Fonction pour trouver le joueur le plus proche
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in ipairs(plrs:GetPlayers()) do
        if player ~= lp and player.Team ~= lp.Team and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local part = char:FindFirstChild(lockPart)

            if root and part then
                local screenPos = cam:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

                if distance < shortestDistance and distance <= fovRadius then
                    closest = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

-- Aimbot
rs.RenderStepped:Connect(function()
    if aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(lockPart) then
            local part = target.Character:FindFirstChild(lockPart)
            if part then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, part.Position), sensitivity)
            end
        end
    end
end)

-- Silent Aim
mouse.TargetFilter = ws
rs.RenderStepped:Connect(function()
    if silentAim then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(lockPart) then
            local part = target.Character:FindFirstChild(lockPart)
            if part then
                mouse.Hit = part.CFrame
            end
        end
    end
end)

-- Fonction pour gérer la visibilité du GUI
uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then -- Raccourci pour cacher/afficher l'interface
        guiVisible = not guiVisible
        library:ToggleUI(guiVisible)
    end
end)

-- Onglet créateur
local creatorTab = window:NewTab("Creator")
local creatorSection = creatorTab:NewSection("Script Creator")
creatorSection:NewLabel("Script créé par LA TEAM 707.")
creatorSection:NewLabel("Discord: https://discord.gg/GhQDgqx2HP")
