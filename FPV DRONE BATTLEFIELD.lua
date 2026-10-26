-- =====================================================================
-- TWKS PURPLE MULTIHACK: ЧАСТЬ 1 ИЗ 3 (БАЗА ЧИТА, АИМЛОК И WALLBANG)
-- КРЕДИТЫ: BY CHO_NAX4 | TIKTOK: 6TORNADIKS7
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ТВОИ КОНФИГИ ЦВЕТОВ И НАСТРОЕК
_G.ESP_COLOR = Color3.fromRGB(157, 0, 255)
local DRONE_COLOR = Color3.fromRGB(0, 255, 255)
_G.TEXT_SIZE = 13
local TOGGLE_KEY = Enum.KeyCode.Insert

_G.ESP_ENABLED = true
_G.SHOW_BOX = true
_G.SHOW_SKELETON = true
_G.SHOW_TRACER = true
_G.SHOW_NAME = true
_G.SHOW_HEALTH = true
_G.SHOW_DRONES = true 
_G.TARGET_SPEED = 16

_G.INF_JUMP_ENABLED = true
_G.TARGET_JUMP_POWER = 50 
_G.AIMLOCK_ENABLED = true
_G.WALLBANG_ENABLED = false
local AIM_FOV = 300 
local AIM_SMOOTHNESS = 0.15 

_G.Cache = {}
_G.DroneCache = {}
_G.ActiveDrones = {}

-- ФУНКЦИЯ АИМЛОКА: ИЩЕТ БЛИЖАЙШУЮ ЦЕЛЬ К ЦЕНТРУ ЭКРАНА (ИГРОКОВ ИЛИ ДРОНОВ)
local function getClosestTarget()
    if not _G.AIMLOCK_ENABLED then return nil end
    local closestTarget = nil
    local shortestDistance = AIM_FOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if distance < shortestDistance then
                        closestTarget = head
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    for _, drone in pairs(_G.ActiveDrones) do
        local dData = _G.DroneCache[drone]
        if dData and dData.Part and dData.Part.Parent then
            local pos, onScreen = Camera:WorldToViewportPoint(dData.Part.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if distance < shortestDistance then
                    closestTarget = dData.Part
                    shortestDistance = distance
                end
            end
        end
    end
    return closestTarget
end

-- ЦИКЛ СКОРОСТИ БЕГА И НАВОДКИ ПРИ ЗАЖАТОМ ПКМ
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            local moveDir = hum.MoveDirection
            local currentVel = root.AssemblyLinearVelocity
            if _G.TARGET_SPEED > 16 then
                root.AssemblyLinearVelocity = Vector3.new(moveDir.X * _G.TARGET_SPEED, currentVel.Y, moveDir.Z * _G.TARGET_SPEED)
            end
        end
        
        if _G.AIMLOCK_ENABLED and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = getClosestTarget()
            if target then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 - AIM_SMOOTHNESS)
            end
        end
    end)
end)

-- ОПТИМИЗИРОВАННЫЙ ПРОСТРЕЛ СТЕН (ОТКЛЮЧЕНИЕ СТОЛКНОВЕНИЙ У ДРОНОВ)
local modifiedParts = {}
local lastWallbangState = false

RunService.Stepped:Connect(function()
    if _G.WALLBANG_ENABLED then
        lastWallbangState = true
        local char = LocalPlayer.Character
        local droneFolder = workspace:FindFirstChild("Drone")
        if droneFolder then
            for _, drone in ipairs(droneFolder:GetChildren()) do
                if drone:IsA("Model") and drone ~= char then
                    local mainPart = drone:FindFirstChild("MAIN") or drone:FindFirstChildOfClass("Part")
                    if mainPart and mainPart.CanCollide then
                        modifiedParts[mainPart] = true
                        mainPart.CanCollide = false
                    end
                end
            end
        end
    elseif lastWallbangState then
        lastWallbangState = false
        for part, _ in pairs(modifiedParts) do
            if part and part.Parent then
                part.CanCollide = true
            end
        end
        table.clear(modifiedParts)
    end
end)

-- Шарим системные константы в глобалку для следующих частей
_G.DRONE_COLOR_VAL = DRONE_COLOR
_G.TOGGLE_KEY_VAL = TOGGLE_KEY
print("[CHO_NAX4 MULTIHACK]: Часть 1 успешно запущена.")
-- =====================================================================
-- TWKS PURPLE MULTIHACK: ЧАСТЬ 2 ИЗ 3 (МЕНЮ И КНОПКИ УПРАВЛЕНИЯ)
-- КРЕДИТЫ: BY CHO_NAX4 | TIKTOK: 6TORNADIKS7
-- =====================================================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ESP_COLOR = _G.ESP_COLOR
local TOGGLE_KEY = _G.TOGGLE_KEY_VAL

-- СБОР ФУНКЦИЙ ИЗ ПЕРВОЙ ЧАСТИ
UserInputService.JumpRequest:Connect(function()
    if _G.INF_JUMP_ENABLED then
        pcall(function()
            local char = game:GetService("Players").LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if hum and root then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                if _G.TARGET_JUMP_POWER > 50 then
                    root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, _G.TARGET_JUMP_POWER, root.AssemblyLinearVelocity.Z)
                end
            end
        end)
    end
end)

-- СОЗДАНИЕ ИНТЕРФЕЙСА ПАНЕЛИ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TwksEspMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

_G.MainFrame = Instance.new("Frame")
_G.MainFrame.Size = UDim2.new(0, 220, 0, 520) -- Высота с учетом копирайта
_G.MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
_G.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
_G.MainFrame.BorderColor3 = ESP_COLOR
_G.MainFrame.BorderSizePixel = 2
_G.MainFrame.Active = true
_G.MainFrame.Draggable = true
_G.MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "✦ TWKS PURPLE MULTIHACK ✦"
Title.TextColor3 = ESP_COLOR
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = _G.MainFrame

-- ТВОЙ АВТОРСКИЙ КОПИРАЙТ
local TwksCredits = Instance.new("TextLabel")
TwksCredits.Size = UDim2.new(1, 0, 0, 15)
TwksCredits.Position = UDim2.new(0, 0, 0, 24)
TwksCredits.BackgroundTransparency = 1
TwksCredits.Text = "by CHO_NAX4 | TT: 6TORNADIKS7"
TwksCredits.TextColor3 = Color3.fromRGB(255, 255, 255)
TwksCredits.TextSize = 11
TwksCredits.Font = Enum.Font.SourceSansItalic
TwksCredits.Parent = _G.MainFrame

local function createToggle(text, pos, default, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 180, 0, 30)
    Btn.Position = UDim2.new(0, 20, 0, pos)
    Btn.BackgroundColor3 = default and Color3.fromRGB(45, 20, 70) or Color3.fromRGB(30, 25, 35)
    Btn.Text = text .. (default and " [ВКЛ]" or " [ВЫКЛ]")
    Btn.TextColor3 = default and ESP_COLOR or Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 14
    Btn.Parent = _G.MainFrame
    
    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and Color3.fromRGB(45, 20, 70) or Color3.fromRGB(30, 25, 35)
        Btn.Text = text .. (state and " [ВКЛ]" or " [ВЫКЛ]")
        Btn.TextColor3 = state and ESP_COLOR or Color3.fromRGB(150, 150, 150)
        callback(state)
    end)
    return Btn
end

-- Распределение кнопок с правильным смещением
createToggle("Мастер Тумблер", 60, _G.ESP_ENABLED, function(v) _G.ESP_ENABLED = v end)
createToggle("Квадраты (Box)", 95, _G.SHOW_BOX, function(v) _G.SHOW_BOX = v end)
createToggle("Скелеты (Skeleton)", 130, _G.SHOW_SKELETON, function(v) _G.SHOW_SKELETON = v end)
createToggle("Трейсера (Tracers)", 165, _G.SHOW_TRACER, function(v) _G.SHOW_TRACER = v end)
createToggle("Никнеймы (Names)", 200, _G.SHOW_NAME, function(v) _G.SHOW_NAME = v end)
createToggle("Полоска ХП (Health)", 235, _G.SHOW_HEALTH, function(v) _G.SHOW_HEALTH = v end)
createToggle("Дроны (Drone ESP)", 270, _G.SHOW_DRONES, function(v) _G.SHOW_DRONES = v end)
createToggle("Беск. Прыжок", 305, _G.INF_JUMP_ENABLED, function(v) _G.INF_JUMP_ENABLED = v end)
createToggle("Smart Aim (ПКМ)", 340, _G.AIMLOCK_ENABLED, function(v) _G.AIMLOCK_ENABLED = v end)
createToggle("Прострел Стен", 375, false, function(v) _G.WALLBANG_ENABLED = v end)

local JumpPowerBtn = Instance.new("TextButton")
JumpPowerBtn.Size = UDim2.new(0, 180, 0, 30)
JumpPowerBtn.Position = UDim2.new(0, 20, 0, 410)
JumpPowerBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 70)
JumpPowerBtn.Text = "Сила прыжка: [Дефолт]"
JumpPowerBtn.TextColor3 = ESP_COLOR
JumpPowerBtn.Font = Enum.Font.SourceSans
JumpPowerBtn.TextSize = 14
JumpPowerBtn.Parent = _G.MainFrame

local jumpPowers = {50, 75, 110, 160}
local jumpIdx = 1
JumpPowerBtn.MouseButton1Click:Connect(function()
    jumpIdx = jumpIdx + 1
    if jumpIdx > #jumpPowers then jumpIdx = 1 end
    _G.TARGET_JUMP_POWER = jumpPowers[jumpIdx]
    JumpPowerBtn.Text = "Сила прыжка: [" .. (_G.TARGET_JUMP_POWER == 50 and "Дефолт" or tostring(_G.TARGET_JUMP_POWER)) .. "]"
end)

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0, 180, 0, 30)
SpeedBtn.Position = UDim2.new(0, 20, 0, 445)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 70)
SpeedBtn.Text = "Скорость бега: [Дефолт]"
SpeedBtn.TextColor3 = ESP_COLOR
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.TextSize = 14
SpeedBtn.Parent = _G.MainFrame

local speeds = {16, 35, 60, 100, 150}
local speedIdx = 1
SpeedBtn.MouseButton1Click:Connect(function()
    speedIdx = speedIdx + 1
    if speedIdx > #speeds then speedIdx = 1 end
    _G.TARGET_SPEED = speeds[speedIdx]
    SpeedBtn.Text = "Скорость бега: [" .. tostring(_G.TARGET_SPEED) .. "]"
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == TOGGLE_KEY and _G.MainFrame then
        _G.MainFrame.Visible = not _G.MainFrame.Visible
    end
end)

print("[CHO_NAX4 MULTIHACK]: Часть 2 успешно запущена.")
-- =====================================================================
-- TWKS PURPLE MULTIHACK: ЧАСТЬ 3 ИЗ 3 (РЕГИСТРАЦИЯ ДРОНОВ И РЕНДЕР ESP)
-- КРЕДИТЫ: BY CHO_NAX4 | TIKTOK: 6TORNADIKS7
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local DRONE_COLOR = _G.DRONE_COLOR_VAL
local TEXT_SIZE = _G.TEXT_SIZE

local function removeDroneCache(drone)
    local data = _G.DroneCache[drone] 
    if data then 
        pcall(function() data.Box:Remove() data.Tracer:Remove() data.Tag:Remove() end) 
        _G.DroneCache[drone] = nil 
    end
end

local function checkAndRegisterDrone(child)
    if child.Name == "FPVDrone" then
        task.defer(function()
            if not _G.DroneCache[child] then
                local mainPart = child:FindFirstChild("MAIN") or child:FindFirstChildOfClass("Part") or child:FindFirstChildOfClass("MeshPart")
                if mainPart then
                    _G.DroneCache[child] = {
                        Part = mainPart,
                        Box = Drawing.new("Square"),
                        Tracer = Drawing.new("Line"),
                        Tag = Drawing.new("Text")
                    }
                    _G.DroneCache[child].Box.Color = DRONE_COLOR
                    _G.DroneCache[child].Box.Thickness = 1.5
                    _G.DroneCache[child].Box.Filled = false
                    _G.DroneCache[child].Box.Visible = false
                    
                    _G.DroneCache[child].Tracer.Color = DRONE_COLOR
                    _G.DroneCache[child].Tracer.Thickness = 1.2
                    _G.DroneCache[child].Tracer.Visible = false
                    
                    _G.DroneCache[child].Tag.Color = DRONE_COLOR
                    _G.DroneCache[child].Tag.Size = TEXT_SIZE
                    _G.DroneCache[child].Tag.Center = true
                    _G.DroneCache[child].Tag.Visible = false
                end
            end
            if _G.DroneCache[child] and not table.find(_G.ActiveDrones, child) then 
                table.insert(_G.ActiveDrones, child) 
                print("[CHO_NAX4 HACK]: Новый дрон успешно взят на мушку.")
            end
        end)
    end
end

workspace.ChildAdded:Connect(checkAndRegisterDrone)
workspace.ChildRemoved:Connect(function(child)
    if child.Name == "FPVDrone" then 
        local idx = table.find(_G.ActiveDrones, child) 
        if idx then table.remove(_G.ActiveDrones, idx) end 
        removeDroneCache(child) 
    end
end)

for _, child in pairs(workspace:GetChildren()) do checkAndRegisterDrone(child) end

RunService.RenderStepped:Connect(function()
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and _G.Cache[plr] then
            local data = _G.Cache[plr] 
            local char = plr.Character 
            local root = char and char:FindFirstChild("HumanoidRootPart") 
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if _G.ESP_ENABLED and root and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local sizeX = math.clamp(2000 / pos.Z, 10, 300) 
                    local sizeY = math.clamp(3500 / pos.Z, 15, 500)
                    
                    if _G.SHOW_BOX then 
                        data.Box.Size = Vector2.new(sizeX, sizeY) 
                        data.Box.Position = Vector2.new(pos.X - sizeX/2, pos.Y - sizeY/2) 
                        data.Box.Visible = true 
                    else data.Box.Visible = false end
                    
                    if _G.SHOW_TRACER then 
                        data.Tracer.From = screenCenter 
                        data.Tracer.To = Vector2.new(pos.X, pos.Y + sizeY/2) 
                        data.Tracer.Visible = true 
                    else data.Tracer.Visible = false end
                    
                    if _G.SHOW_NAME then 
                        data.Name.Text = plr.Name .. " [by CHO_NAX4]"
                        data.Name.Position = Vector2.new(pos.X, pos.Y - sizeY/2 - 16) 
                        data.Name.Visible = true 
                    else data.Name.Visible = false end
                    
                    if _G.SHOW_HEALTH then
                        local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        data.HealthBarOutline.Size = Vector2.new(4, sizeY) 
                        data.HealthBarOutline.Position = Vector2.new(pos.X - sizeX/2 - 6, pos.Y - sizeY/2) 
                        data.HealthBarOutline.Visible = true
                        data.HealthBar.Size = Vector2.new(2, sizeY * hpPercent) 
                        data.HealthBar.Position = Vector2.new(pos.X - sizeX/2 - 5, pos.Y + sizeY/2 - (sizeY * hpPercent)) 
                        data.HealthBar.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0) 
                        data.HealthBar.Visible = true
                    else 
                        data.HealthBarOutline.Visible = false data.HealthBar.Visible = false 
                    end
                    
                    if _G.SHOW_SKELETON then
                        local bIndex = 1
                        local function drawBone(p1, p2)
                            local part1 = char:FindFirstChild(p1) 
                            local part2 = char:FindFirstChild(p2)
                            if part1 and part2 and data.Bones[bIndex] then
                                local v1, os1 = Camera:WorldToViewportPoint(part1.Position) 
                                local v2, os2 = Camera:WorldToViewportPoint(part2.Position)
                                if os1 and os2 then 
                                    data.Bones[bIndex].From = Vector2.new(v1.X, v1.Y) 
                                    data.Bones[bIndex].To = Vector2.new(v2.X, v2.Y) 
                                    data.Bones[bIndex].Visible = true 
                                    bIndex = bIndex + 1 
                                    return 
                                end
                            end
                            if data.Bones[bIndex] then data.Bones[bIndex].Visible = false bIndex = bIndex + 1 end
                        end
                        
                        if hum.RigType == Enum.HumanoidRigType.R15 then
                            drawBone("Head", "UpperTorso") drawBone("UpperTorso", "LowerTorso") 
                            drawBone("UpperTorso", "LeftUpperArm") drawBone("LeftUpperArm", "LeftLowerArm") 
                            drawBone("UpperTorso", "RightUpperArm") drawBone("RightUpperArm", "RightLowerArm") 
                            drawBone("LowerTorso", "LeftUpperLeg") drawBone("LeftUpperLeg", "LeftLowerLeg") 
                            drawBone("LowerTorso", "RightUpperLeg") drawBone("RightUpperLeg", "RightLowerLeg")
                        else
                            drawBone("Head", "Torso") drawBone("Torso", "Left Arm") 
                            drawBone("Torso", "Right Arm") drawBone("Torso", "Left Leg") 
                            drawBone("Torso", "Right Leg")
                        end
                        for i = bIndex, #data.Bones do data.Bones[i].Visible = false end
                    else 
                        for i = 1, #data.Bones do data.Bones[i].Visible = false end 
                    end
                else 
                    data.Box.Visible = false data.Tracer.Visible = false data.Name.Visible = false 
                    data.HealthBarOutline.Visible = false data.HealthBar.Visible = false 
                    for i = 1, #data.Bones do data.Bones[i].Visible = false end 
                end
            else 
                if data then data.Box.Visible = false data.Tracer.Visible = false data.Name.Visible = false data.HealthBarOutline.Visible = false data.HealthBar.Visible = false for i = 1, #data.Bones do data.Bones[i].Visible = false end end 
            end
        end
    end
    
    for i = #_G.ActiveDrones, 1, -1 do
        local obj = _G.ActiveDrones[i] 
        local dData = _G.DroneCache[obj]
        if dData then
            if _G.ESP_ENABLED and _G.SHOW_DRONES and dData.Part and dData.Part.Parent then
                local pos, onScreen = Camera:WorldToViewportPoint(dData.Part.Position)
                if onScreen then
                    local size = math.clamp(1200 / pos.Z, 5, 80)
                    if _G.SHOW_BOX then dData.Box.Size = Vector2.new(size, size) dData.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2) dData.Box.Visible = true else dData.Box.Visible = false end
                    if _G.SHOW_TRACER then dData.Tracer.From = screenCenter dData.Tracer.To = Vector2.new(pos.X, pos.Y + size/2) dData.Tracer.Visible = true else dData.Tracer.Visible = false end
                    dData.Tag.Text = string.format("[Дрон CHO_NAX4 | %dм]", math.floor(pos.Z)) 
                    dData.Tag.Position = Vector2.new(pos.X, pos.Y - size/2 - 14) 
                    dData.Tag.Visible = true
                else dData.Box.Visible = false dData.Tracer.Visible = false dData.Tag.Visible = false end
            else dData.Box.Visible = false dData.Tracer.Visible = false dData.Tag.Visible = false end
        else table.remove(_G.ActiveDrones, i) end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if _G.Cache[plr] then
        pcall(function()
            _G.Cache[plr].Box:Remove()
            _G.Cache[plr].Tracer:Remove()
            _G.Cache[plr].Name:Remove()
                    _G.Cache[plr].HealthBar:Remove()
_G.Cache[plr].HealthBarOutline:Remove()
for _, b in pairs(_G.Cache[plr].Bones) do b:Remove() end
end)
_G.Cache[plr] = nil
end
end)
