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

mainSection:NewSlider("Sensitivity", "Sensibilité de l'aimbot", 5, 0, function(value)
    print("Sensitivity: ", value)
end)

mainSection:NewKeybind("Hotkey", "Définir une touche pour activer", Enum.KeyCode.E, function()
    print("Aimbot Hotkey Pressed")
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

thirdPersonSection:NewSlider("Third Person Sensitivity", "Sensibilité en troisième personne", 5, 1, function(value)
    print("Third Person Sensitivity: ", value)
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

fovSection:NewSlider("FOV Amount", "Ajuster la taille du FOV", 360, 10, function(value)
    print("FOV Amount: ", value)
end)

-- Apparence du cercle FOV
fovSection:NewSlider("Transparency", "Transparence du cercle", 1, 0, function(value)
    print("Transparency: ", value)
end)

fovSection:NewSlider("Thickness", "Épaisseur du cercle", 5, 1, function(value)
    print("Thickness: ", value)
end)

fovSection:NewSlider("Sides", "Nombre de côtés", 100, 3, function(value)
    print("Sides: ", value)
end)

-- Informations
local info = window:NewTab("Info")
local infoSection = info:NewSection("Script created by [Your Name].")

-- Instructions
infoSection:NewLabel("Personnalisez les réglages à votre convenance.")
infoSection:NewLabel("Activez ou désactivez les options pour tester.")

-- Fonction principale de l'aimbot (simple exemple)
game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled then
        print("Aimbot is running...")
        -- Implémentez ici votre logique pour verrouiller la caméra sur les ennemis
    end
end)
