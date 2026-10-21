local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP_COLOR = Color3.fromRGB(157, 0, 255)
local DRONE_COLOR = Color3.fromRGB(0, 255, 255)
local TEXT_SIZE = 13
local TOGGLE_KEY = Enum.KeyCode.Insert

local ESP_ENABLED = true
local SHOW_BOX = true
local SHOW_SKELETON = true
local SHOW_TRACER = true
local SHOW_NAME = true
local SHOW_HEALTH = true
local SHOW_DRONES = true 
local TARGET_SPEED = 16

local INF_JUMP_ENABLED = true
local TARGET_JUMP_POWER = 50 
local AIMLOCK_ENABLED = true
local WALLBANG_ENABLED = false
local AIM_FOV = 300 
local AIM_SMOOTHNESS = 0.15 

local Cache = {}
local DroneCache = {}
local ActiveDrones = {}

local function getClosestTarget()
    if not AIMLOCK_ENABLED then return nil end
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
    
    for _, drone in pairs(ActiveDrones) do
        local dData = DroneCache[drone]
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

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            local moveDir = hum.MoveDirection
            local currentVel = root.AssemblyLinearVelocity
            if TARGET_SPEED > 16 then
                root.AssemblyLinearVelocity = Vector3.new(moveDir.X * TARGET_SPEED, currentVel.Y, moveDir.Z * TARGET_SPEED)
            end
        end
        
        if AIMLOCK_ENABLED and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = getClosestTarget()
            if target then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 - AIM_SMOOTHNESS)
            end
        end
    end)
end)
-- ОПТИМИЗИРОВАННЫЙ ПРОСТРЕЛ БЕЗ ГЛОБАЛЬНЫХ ЦИКЛОВ КАРТЫ
local modifiedParts = {}
local lastWallbangState = false

RunService.Stepped:Connect(function()
    if WALLBANG_ENABLED then
        lastWallbangState = true
        local char = LocalPlayer.Character
        -- Ловим только то, что находится в папке Drone в Workspace
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

UserInputService.JumpRequest:Connect(function()
    if INF_JUMP_ENABLED then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if hum and root then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                if TARGET_JUMP_POWER > 50 then
                    root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, TARGET_JUMP_POWER, root.AssemblyLinearVelocity.Z)
                end
            end
        end)
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TwksEspMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

_G.MainFrame = Instance.new("Frame")
_G.MainFrame.Size = UDim2.new(0, 220, 0, 495)
_G.MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
_G.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
_G.MainFrame.BorderColor3 = ESP_COLOR
_G.MainFrame.BorderSizePixel = 2
_G.MainFrame.Active = true
_G.MainFrame.Draggable = true
_G.MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
Title.Text = "✦ TWKS PURPLE MULTIHACK ✦"
Title.TextColor3 = ESP_COLOR
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = _G.MainFrame
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

createToggle("Мастер Тумблер", 45, ESP_ENABLED, function(v) ESP_ENABLED = v end)
createToggle("Квадраты (Box)", 80, SHOW_BOX, function(v) SHOW_BOX = v end)
createToggle("Скелеты (Skeleton)", 115, SHOW_SKELETON, function(v) SHOW_SKELETON = v end)
createToggle("Трейсера (Tracers)", 150, SHOW_TRACER, function(v) SHOW_TRACER = v end)
createToggle("Никнеймы (Names)", 185, SHOW_NAME, function(v) SHOW_NAME = v end)
createToggle("Полоска ХП (Health)", 220, SHOW_HEALTH, function(v) SHOW_HEALTH = v end)
createToggle("Дроны (Drone ESP)", 255, SHOW_DRONES, function(v) SHOW_DRONES = v end)
createToggle("Беск. Прыжок", 290, INF_JUMP_ENABLED, function(v) INF_JUMP_ENABLED = v end)
createToggle("Smart Aim (ПКМ)", 325, AIMLOCK_ENABLED, function(v) AIMLOCK_ENABLED = v end)
createToggle("Прострел Стен", 360, false, function(v) WALLBANG_ENABLED = v end)

local JumpPowerBtn = Instance.new("TextButton")
JumpPowerBtn.Size = UDim2.new(0, 180, 0, 30)
JumpPowerBtn.Position = UDim2.new(0, 20, 0, 395)
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
    TARGET_JUMP_POWER = jumpPowers[jumpIdx]
    JumpPowerBtn.Text = "Сила прыжка: [" .. (TARGET_JUMP_POWER == 50 and "Дефолт" or tostring(TARGET_JUMP_POWER)) .. "]"
end)

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0, 180, 0, 30)
SpeedBtn.Position = UDim2.new(0, 20, 0, 430)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 70)
SpeedBtn.Text = "Скорость бега:"
SpeedBtn.TextColor3 = ESP_COLOR
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.TextSize = 14
SpeedBtn.Parent = _G.MainFrame

local speeds = {16, 35, 60, 100, 150}
local speedIdx = 1
SpeedBtn.MouseButton1Click:Connect(function()
    speedIdx = speedIdx + 1
    if speedIdx > #speeds then speedIdx = 1 end
    TARGET_SPEED = speeds[speedIdx]
    SpeedBtn.Text = "Скорость бега: [" .. tostring(TARGET_SPEED) .. "]"
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == TOGGLE_KEY and _G.MainFrame then
        _G.MainFrame.Visible = not _G.MainFrame.Visible
    end
end)
local function addDroneCache(drone)
    if DroneCache[drone] then return end
    local mainPart = drone:FindFirstChild("MAIN") or drone:FindFirstChildOfClass("Part") or drone:FindFirstChildOfClass("MeshPart")
    if mainPart then
        DroneCache[drone] = {
            Part = mainPart,
            Box = createDraw("Square", {Color = DRONE_COLOR, Thickness = 1.5, Filled = false, Visible = false}),
            Tracer = createDraw("Line", {Color = DRONE_COLOR, Thickness = 1.2, Visible = false}),
            Tag = createDraw("Text", {Color = DRONE_COLOR, Size = TEXT_SIZE, Center = true, Visible = false})
        }
    end
end

local function removeDroneCache(drone)
    local data = DroneCache[drone] 
    if data then 
        pcall(function() data.Box:Remove() data.Tracer:Remove() data.Tag:Remove() end) 
        DroneCache[drone] = nil 
    end
end

local function checkAndRegisterDrone(child)
    if child.Name == "FPVDrone" then
        task.defer(function()
            addDroneCache(child)
            if DroneCache[child] and not table.find(ActiveDrones, child) then 
                table.insert(ActiveDrones, child) 
            end
        end)
    end
end

workspace.ChildAdded:Connect(checkAndRegisterDrone)
workspace.ChildRemoved:Connect(function(child)
    if child.Name == "FPVDrone" then 
        local idx = table.find(ActiveDrones, child) 
        if idx then table.remove(ActiveDrones, idx) end 
        removeDroneCache(child) 
    end
end)

for _, child in pairs(workspace:GetChildren()) do checkAndRegisterDrone(child) end

RunService.RenderStepped:Connect(function()
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            addPlayerCache(plr)
            local data = Cache[plr] 
            local char = plr.Character 
            local root = char and char:FindFirstChild("HumanoidRootPart") 
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if ESP_ENABLED and root and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local sizeX = math.clamp(2000 / pos.Z, 10, 300) 
                    local sizeY = math.clamp(3500 / pos.Z, 15, 500)
                    
                    if SHOW_BOX then 
                        data.Box.Size = Vector2.new(sizeX, sizeY) 
                        data.Box.Position = Vector2.new(pos.X - sizeX/2, pos.Y - sizeY/2) 
                        data.Box.Visible = true 
                    else data.Box.Visible = false end
                    
                    if SHOW_TRACER then 
                        data.Tracer.From = screenCenter 
                        data.Tracer.To = Vector2.new(pos.X, pos.Y + sizeY/2) 
                        data.Tracer.Visible = true 
                    else data.Tracer.Visible = false end
                    
                    if SHOW_NAME then 
                        data.Name.Text = plr.Name 
                        data.Name.Position = Vector2.new(pos.X, pos.Y - sizeY/2 - 16) 
                        data.Name.Visible = true 
                    else data.Name.Visible = false end
                    
                    if SHOW_HEALTH then
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
                    
                    if SHOW_SKELETON then
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
    
    for i = #ActiveDrones, 1, -1 do
        local obj = ActiveDrones[i] 
        local dData = DroneCache[obj]
        if dData then
            if ESP_ENABLED and SHOW_DRONES and dData.Part and dData.Part.Parent then
                local pos, onScreen = Camera:WorldToViewportPoint(dData.Part.Position)
                if onScreen then
                    local size = math.clamp(1200 / pos.Z, 5, 80)
                    if SHOW_BOX then dData.Box.Size = Vector2.new(size, size) dData.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2) dData.Box.Visible = true else dData.Box.Visible = false end
                    if SHOW_TRACER then dData.Tracer.From = screenCenter dData.Tracer.To = Vector2.new(pos.X, pos.Y + size/2) dData.Tracer.Visible = true else dData.Tracer.Visible = false end
                    dData.Tag.Text = string.format("[Дрон | %dм]", math.floor(pos.Z)) 
                    dData.Tag.Position = Vector2.new(pos.X, pos.Y - size/2 - 14) 
                    dData.Tag.Visible = true
                else dData.Box.Visible = false dData.Tracer.Visible = false dData.Tag.Visible = false end
            else dData.Box.Visible = false dData.Tracer.Visible = false dData.Tag.Visible = false end
        else table.remove(ActiveDrones, i) end
    end
end)

Players.PlayerRemoving:Connect(removePlayerCache)
