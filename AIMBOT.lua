-- Librairie pour UI
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Custom Aimbot Menu", "DarkTheme")

-- Services Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()
local LocalPlayer = Players.LocalPlayer

-- Vérification si tout est chargé
if not Camera or not Players then
    warn("Les services nécessaires n'ont pas été trouvés !")
    return
end

-- Section principale
local main = window:NewTab("Main")
local mainSection = main:NewSection("Aimbot Settings")

-- Options de l'aimbot
local aimbotEnabled = false
local silenceAimEnabled = false

mainSection:NewToggle("Aimbot Enabled", "Activer/Désactiver l'aimbot", function(state)
    aimbotEnabled = state
end)

mainSection:NewToggle("Silence Aim Enabled", "Activer/Désactiver le silence aim", function(state)
    silenceAimEnabled = state
end)

local lockPart = "Head"
mainSection:NewDropdown("Lock Part", "Choisissez la partie du corps", {"Head", "Torso", "Legs"}, function(selected)
    lockPart = selected
end)

local sensitivity = 5
mainSection:NewSlider("Sensitivity", "Sensibilité de l'aimbot", 500, 0, function(value)
    sensitivity = value / 100 -- Réduction pour une transition fluide
end)

-- Section des réglages FOV
local fov = window:NewTab("FOV")
local fovSection = fov:NewSection("Field of View")

local fovEnabled = false
fovSection:NewToggle("Enable FOV", "Activer le FOV", function(state)
    fovEnabled = state
end)

local fovVisible = true
fovSection:NewToggle("Show FOV Circle", "Afficher le cercle FOV", function(state)
    fovVisible = state
end)

local fovAmount = 200
fovSection:NewSlider("FOV Amount", "Ajuster la taille du FOV", 360, 10, function(value)
    fovAmount = value
end)

local circle = Drawing.new("Circle")
circle.Color = Color3.new(1, 0, 0)
circle.Thickness = 2
circle.NumSides = 100
circle.Filled = false
circle.Transparency = 1

RunService.RenderStepped:Connect(function()
    if fovVisible and fovEnabled then
        circle.Visible = true
        circle.Radius = fovAmount
        circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36) -- Ajustement pour s'aligner avec le curseur
    else
        circle.Visible = false
    end
end)

-- Fonction pour trouver le joueur le plus proche dans le FOV
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
            local character = player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local targetPart = character and character:FindFirstChild(lockPart)

            if humanoidRootPart and targetPart then
                local screenPoint = Camera:WorldToScreenPoint(targetPart.Position)
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                if distance < shortestDistance and distance <= fovAmount then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

-- Fonction principale pour l'aimbot
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local closestPlayer = getClosestPlayer()
        if closestPlayer then
            local character = closestPlayer.Character
            local targetPart = character and character:FindFirstChild(lockPart)

            if targetPart then
                -- Transition fluide vers la cible
                local targetPosition = targetPart.Position
                local cameraPosition = Camera.CFrame.Position
                local direction = (targetPosition - cameraPosition).Unit
                local smoothCFrame = CFrame.new(cameraPosition, cameraPosition + direction)
                Camera.CFrame = Camera.CFrame:Lerp(smoothCFrame, sensitivity)
            end
        end
    end

    if silenceAimEnabled then
        local closestPlayer = getClosestPlayer()
        if closestPlayer then
            local character = closestPlayer.Character
            local targetPart = character and character:FindFirstChild(lockPart)

            if targetPart then
                -- Alignement des tirs sur la cible
                Mouse.TargetFilter = workspace
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    end
end)

-- Interface
local creator = window:NewTab("Creator")
local creatorSection = creator:NewSection("Script Creator")

creatorSection:NewLabel("Script created by LA TEAM 707")
creatorSection:NewLabel("Discord: https://discord.gg/GhQDgqx2HP")
