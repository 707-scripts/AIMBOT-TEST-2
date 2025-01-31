-- Chargement des services et librairies
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Chargement de l'interface utilisateur (UI Library)
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Ultimate Hack Menu", "DarkTheme")

-- Variables globales
local aimbotEnabled = false
local silentAimEnabled = false
local espEnabled = false
local killAllEnabled = false
local fovEnabled = false
local menuVisible = true
local fovCircle = Drawing.new("Circle")
local aimbotKey = Enum.KeyCode.E
local menuKey = Enum.KeyCode.T
local fovSize = 300
local espColor = Color3.fromRGB(255, 0, 0)
local silentAimDistance = 50
local targetPlayer = nil
local silentAimThreshold = 10  -- Distance en pixels pour activer le Silent Aim

-- Création des onglets
local main = window:NewTab("Main")
local mainSection = main:NewSection("Aimbot Settings")

local extras = window:NewTab("Extras")
local extrasSection = extras:NewSection("Extra Options")

local fov = window:NewTab("FOV")
local fovSection = fov:NewSection("FOV Settings")

local visuals = window:NewTab("Visuals")
local visualsSection = visuals:NewSection("ESP Settings")

-- Aimbot
mainSection:NewToggle("Enable Aimbot", "Active/désactive l'aimbot", function(state)
    aimbotEnabled = state
    if state then
        library:Notify("Aimbot activé")
    else
        library:Notify("Aimbot désactivé")
    end
end)

-- Silent Aim
mainSection:NewToggle("Enable Silent Aim", "Active/désactive le Silent Aim", function(state)
    silentAimEnabled = state
    if state then
        library:Notify("Silent Aim activé")
    else
        library:Notify("Silent Aim désactivé")
    end
end)

mainSection:NewSlider("Silent Aim Distance", "Distance d'activation du Silent Aim", 100, 10, function(value)
    silentAimDistance = value
end)

mainSection:NewSlider("Silent Aim Threshold", "Distance en pixels pour activer le Silent Aim", 50, 1, function(value)
    silentAimThreshold = value
end)

-- Kill All
extrasSection:NewToggle("Kill All", "Tue tous les joueurs", function(state)
    killAllEnabled = state
    if killAllEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = 1
            end
        end
    end
end)

-- ESP (Wallhack)
visualsSection:NewToggle("Enable ESP", "Affiche les joueurs à travers les murs", function(state)
    espEnabled = state
    if state then
        library:Notify("ESP activé")
    else
        library:Notify("ESP désactivé")
    end
end)

visualsSection:NewColorPicker("ESP Color", "Couleur de l'ESP", espColor, function(color)
    espColor = color
end)

-- FOV Settings
fovSection:NewToggle("Enable FOV", "Affiche le cercle de FOV", function(state)
    fovEnabled = state
    fovCircle.Visible = state
end)

fovSection:NewSlider("FOV Size", "Taille du FOV", 300, 10, function(value)
    fovSize = value
    fovCircle.Radius = value
end)

fovCircle.Thickness = 2
fovCircle.NumSides = 50
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 0, 0)

-- Fonction pour trouver le joueur le plus proche dans le FOV
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetPart = player.Character.HumanoidRootPart
            local screenPoint = Camera:WorldToScreenPoint(targetPart.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if distance < shortestDistance and distance < fovSize then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

-- Fonction pour viser le joueur cible
local function aimAtTarget(target)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
    end
end

-- Fonction pour vérifier la distance et activer le Silent Aim
local function checkSilentAimDistance(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
        return distance <= silentAimDistance
    end
    return false
end

-- Fonction pour corriger la visée
local function correctAim(target)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local headPos = target.Character.Head.Position
        local direction = (headPos - Camera.CFrame.Position).unit
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, headPos)
    end
end

-- Aimbot fonctionnel
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayerInFOV()
        if target then
            aimAtTarget(target)
        end
    end

    -- Silent Aim
    if silentAimEnabled then
        local target = getClosestPlayerInFOV()
        if target and checkSilentAimDistance(target) then
            local screenPoint = Camera:WorldToScreenPoint(target.Character.Head.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if distance < silentAimThreshold then
                correctAim(target)
            end
        end
    end

    -- ESP
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local highlight = Instance.new("Highlight", player.Character)
                highlight.FillColor = espColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
            end
        end
    end
end)

-- Gestion des raccourcis clavier
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == aimbotKey then
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            library:Notify("Aimbot activé")
        else
            library:Notify("Aimbot désactivé")
        end
    end
    if input.KeyCode == menuKey then
        menuVisible = not menuVisible
        library:ToggleUI(menuVisible)
    end
end)

-- Affichage du FOV
RunService.RenderStepped:Connect(function()
    if fovEnabled then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = fovSize
    end
end)

-- Affichage des touches dans le menu
mainSection:NewLabel("Touche pour activer/désactiver l'Aimbot: " .. aimbotKey.Name)
mainSection:NewLabel("Touche pour activer/désactiver le Silent Aim: " .. aimbotKey.Name)
extrasSection:NewLabel("Touche pour activer/désactiver le menu: " .. menuKey.Name)

print("Script chargé avec succès !")
