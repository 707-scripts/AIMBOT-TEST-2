-- Chargement des services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Chargement de la librairie UI
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Advanced Aimbot Menu", "DarkTheme")

-- Variables
local aimbotEnabled = false
local silentAimEnabled = false
local fovEnabled = false
local fovSize = 100
local fovColor = Color3.new(1, 0, 0)
local aimbotKey = Enum.KeyCode.E
local menuKey = Enum.KeyCode.T
local lockPart = "Head"
local teamCheck = true

-- Création des onglets
local main = window:NewTab("Main")
local mainSection = main:NewSection("Aimbot Settings")
local visuals = window:NewTab("Visuals")
local visualsSection = visuals:NewSection("FOV Settings")
local misc = window:NewTab("Misc")
local miscSection = misc:NewSection("Extra Options")
local color = window:NewTab("Color")
local colorSection = color:NewSection("GUI Color")

-- Options de l'aimbot
mainSection:NewToggle("Enable Aimbot", "Active/Désactive l'aimbot", function(state)
    aimbotEnabled = state
end)

mainSection:NewToggle("Enable Silent Aim", "Active/Désactive le silent aim", function(state)
    silentAimEnabled = state
end)

mainSection:NewDropdown("Lock Part", "Choisissez la partie du corps", {"Head", "Torso", "Leg"}, function(selected)
    lockPart = selected
end)

mainSection:NewKeybind("Aimbot Key", "Touche pour activer l'aimbot", aimbotKey, function()
    aimbotEnabled = not aimbotEnabled
end)

-- Options du FOV
visualsSection:NewToggle("Enable FOV", "Active/Désactive l'affichage du FOV", function(state)
    fovEnabled = state
end)

visualsSection:NewSlider("FOV Size", "Taille du FOV", 300, 10, function(value)
    fovSize = value
end)

visualsSection:NewColorPicker("FOV Color", "Change la couleur du FOV", Color3.new(1, 0, 0), function(color)
    fovColor = color
end)

-- Fonction d'aimbot
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(lockPart) then
            local part = player.Character[lockPart]
            local screenPoint, onScreen = Camera:WorldToScreenPoint(part.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            
            if onScreen and distance < shortestDistance and distance < fovSize then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(lockPart) then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character[lockPart].Position), 0.2)
        end
    end
end)

-- Affichage du FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = fovColor
fovCircle.Radius = fovSize
fovCircle.Thickness = 2

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    fovCircle.Radius = fovSize
    fovCircle.Color = fovColor
    fovCircle.Visible = fovEnabled
end)

-- Gestion du menu
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == menuKey then
        library:ToggleUI()
    end
end)
