-- Librairie pour UI
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = library.CreateLib("Custom Aimbot Menu", "DarkTheme")

-- Section principale
local main = window:NewTab("Main")
local mainSection = main:NewSection("Aimbot Settings")

-- Options de l'aimbot
local aimbotEnabled = false
mainSection:NewToggle("Enabled", "Activer/Désactiver l'aimbot", function(state)
    aimbotEnabled = state
    print("Aimbot Enabled: ", aimbotEnabled)
end)

local toggleMode = false
mainSection:NewToggle("Toggle Mode", "Activer/Désactiver le mode toggle", function(state)
    toggleMode = state
    print("Toggle Mode: ", toggleMode)
end)

local lockPart = "Head"
mainSection:NewDropdown("Lock Part", "Choisissez la partie du corps", {"Head", "Torso", "Legs"}, function(selected)
    lockPart = selected
    print("Lock Part: ", lockPart)
end)

local sensitivity = 5
mainSection:NewSlider("Sensitivity", "Sensibilité de l'aimbot", 500, 0, function(value)
    sensitivity = value
    print("Sensitivity: ", sensitivity)
end)

local hotkey = Enum.KeyCode.E
mainSection:NewKeybind("Hotkey", "Définir une touche pour activer", hotkey, function()
    print("Aimbot Hotkey Pressed")
    aimbotEnabled = not aimbotEnabled
end)

-- Section des vérifications
local checks = window:NewTab("Checks")
local checksSection = checks:NewSection("Checks")

local teamCheck = false
checksSection:NewToggle("Team Check", "Vérifier l'équipe", function(state)
    teamCheck = state
    print("Team Check: ", teamCheck)
end)

local wallCheck = false
checksSection:NewToggle("Wall Check", "Vérifier les murs", function(state)
    wallCheck = state
    print("Wall Check: ", wallCheck)
end)

local aliveCheck = false
checksSection:NewToggle("Alive Check", "Vérifier si vivant", function(state)
    aliveCheck = state
    print("Alive Check: ", aliveCheck)
end)

-- Section du mode troisième personne
local thirdPerson = window:NewTab("Third Person")
local thirdPersonSection = thirdPerson:NewSection("Third Person")

local thirdPersonEnabled = false
thirdPersonSection:NewToggle("Enable Third Person", "Activer le mode troisième personne", function(state)
    thirdPersonEnabled = state
    print("Third Person Enabled: ", thirdPersonEnabled)
end)

local thirdPersonSensitivity = 5
thirdPersonSection:NewSlider("Third Person Sensitivity", "Sensibilité en troisième personne", 500, 1, function(value)
    thirdPersonSensitivity = value
    print("Third Person Sensitivity: ", thirdPersonSensitivity)
end)

-- Section des réglages FOV
local fov = window:NewTab("FOV")
local fovSection = fov:NewSection("Field of View")

local fovEnabled = false
fovSection:NewToggle("Enable FOV", "Activer le FOV", function(state)
    fovEnabled = state
    print("FOV Enabled: ", fovEnabled)
end)

local fovVisible = false
fovSection:NewToggle("Show FOV Circle", "Afficher le cercle FOV", function(state)
    fovVisible = state
    print("FOV Circle Visible: ", fovVisible)
end)

local fovAmount = 360
fovSection:NewSlider("FOV Amount", "Ajuster la taille du FOV", 360, 10, function(value)
    fovAmount = value
    print("FOV Amount: ", fovAmount)
end)

local transparency = 1
fovSection:NewSlider("Transparency", "Transparence du cercle", 1, 0, function(value)
    transparency = value
    print("Transparency: ", transparency)
end)

local thickness = 5
fovSection:NewSlider("Thickness", "Épaisseur du cercle", 5, 1, function(value)
    thickness = value
    print("Thickness: ", thickness)
end)

local sides = 100
fovSection:NewSlider("Sides", "Nombre de côtés", 100, 3, function(value)
    sides = value
    print("Sides: ", sides)
end)

-- Informations
local info = window:NewTab("Info")
local infoSection = info:NewSection("Script created by [Your Name].")

-- Instructions
infoSection:NewLabel("Personnalisez les réglages à votre convenance.")
infoSection:NewLabel("Activez ou désactivez les options pour tester.")

-- Fonction principale de l'aimbot (simple exemple)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local screenPoint = Camera:WorldToScreenPoint(humanoidRootPart.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude

            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local closestPlayer = getClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild(lockPart) then
            local targetPart = closestPlayer.Character:FindFirstChild(lockPart)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

-- Fonction pour dessiner le cercle FOV
local function drawFOV()
    local circle = Drawing.new("Circle")
    circle.Visible = fovVisible
    circle.Color = Color3.new(1, 0, 0)
    circle.Thickness = thickness
    circle.NumSides = sides
    circle.Transparency = transparency
    circle.Radius = fovAmount
    circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    RunService.RenderStepped:Connect(function()
        if fovEnabled then
            circle.Visible = fovVisible
            circle.Radius = fovAmount
            circle.Thickness = thickness
            circle.NumSides = sides
            circle.Transparency = transparency
            circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        else
            circle.Visible = false
        end
    end)
end

drawFOV()
