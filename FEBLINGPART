-- ============================================================
-- TORNADO PHYSICS HUB v3 | FTAP Style | Xeno
-- Ключ: TORNADIK2026
-- Физика + Полёт + Noclip
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

local CONFIG = {
    KEY = "FE10DAY",
    RANGE = 500,
    PULL_SPEED = 80,
    ORBIT_RADIUS = 8,
    ROTATION_SPEED = 1.5,
    SCAN_INTERVAL = 2,
    FLY_SPEED = 100,
    FLY_BOOST = 2.0,
}

local State = {
    physicsActive = false,
    flyActive = false,
    noclipActive = false,
    autoScan = true,
    grabMode = "orbit",
}

local cachedObjects = {}
local orbitAngle = 0
local flyBV, flyBG, flyConn = nil, nil, nil
local physicsConn = nil
local scanThread = nil

local Colors = {
    bgDark = Color3.fromRGB(15, 20, 15),
    bgMid = Color3.fromRGB(30, 40, 30),
    accent = Color3.fromRGB(80, 130, 60),
    accentDark = Color3.fromRGB(50, 90, 40),
    accentBright = Color3.fromRGB(120, 180, 90),
    text = Color3.fromRGB(200, 220, 180),
    danger = Color3.fromRGB(160, 40, 40),
    info = Color3.fromRGB(60, 100, 130),
}

-- КЛЮЧ
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "PHKey"
keyGui.ResetOnSpawn = false
pcall(function() keyGui.Parent = CoreGui end)
if not keyGui.Parent then keyGui.Parent = PG end

local kf = Instance.new("Frame")
kf.Size = UDim2.new(0, 320, 0, 200)
kf.Position = UDim2.new(0.5, -160, 0.5, -100)
kf.BackgroundColor3 = Colors.bgDark
kf.BorderSizePixel = 0
kf.Parent = keyGui
Instance.new("UICorner", kf).CornerRadius = UDim.new(0, 10)
local kStroke = Instance.new("UIStroke", kf)
kStroke.Color = Colors.accent
kStroke.Thickness = 2

local kTitle = Instance.new("TextLabel", kf)
kTitle.Size = UDim2.new(1, 0, 0, 50)
kTitle.BackgroundTransparency = 1
kTitle.Text = "🌀 TORNADO PHYSICS"
kTitle.TextColor3 = Colors.text
kTitle.Font = Enum.Font.GothamBold
kTitle.TextSize = 18

local kBox = Instance.new("TextBox", kf)
kBox.Size = UDim2.new(1, -60, 0, 36)
kBox.Position = UDim2.new(0, 30, 0, 78)
kBox.BackgroundColor3 = Colors.bgMid
kBox.BorderSizePixel = 0
kBox.PlaceholderText = "Enter key..."
kBox.Text = ""
kBox.TextColor3 = Colors.text
kBox.Font = Enum.Font.GothamSemibold
kBox.TextSize = 15
Instance.new("UICorner", kBox).CornerRadius = UDim.new(0, 6)

local kBtn = Instance.new("TextButton", kf)
kBtn.Size = UDim2.new(1, -60, 0, 36)
kBtn.Position = UDim2.new(0, 30, 0, 126)
kBtn.BackgroundColor3 = Colors.accent
kBtn.BorderSizePixel = 0
kBtn.Text = "LOGIN"
kBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kBtn.Font = Enum.Font.GothamBold
kBtn.TextSize = 15
Instance.new("UICorner", kBtn).CornerRadius = UDim.new(0, 6)

local kStatus = Instance.new("TextLabel", kf)
kStatus.Size = UDim2.new(1, 0, 0, 18)
kStatus.Position = UDim2.new(0, 0, 1, -22)
kStatus.BackgroundTransparency = 1
kStatus.Text = ""
kStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
kStatus.Font = Enum.Font.Gotham
kStatus.TextSize = 12

local keyPassed = false
kBtn.MouseButton1Click:Connect(function()
    if kBox.Text == CONFIG.KEY then
        keyPassed = true
        kStatus.TextColor3 = Color3.fromRGB(120, 255, 120)
        kStatus.Text = "Access granted"
        task.wait(0.4)
        keyGui:Destroy()
    else
        kStatus.Text = "Invalid key"
        kBox.Text = ""
    end
end)
while not keyPassed do task.wait(0.1) end

-- МЕНЮ
local gui = Instance.new("ScreenGui")
gui.Name = "TornadoPH"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = PG end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 440)
main.Position = UDim2.new(1, -300, 0.5, -220)
main.BackgroundColor3 = Colors.bgDark
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local ms = Instance.new("UIStroke", main)
ms.Color = Colors.accent
ms.Thickness = 2

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Colors.bgMid
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌀 TORNADO PHYSICS"
title.TextColor3 = Colors.text
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0.5, -14)
closeBtn.BackgroundColor3 = Colors.danger
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- ВКЛАДКИ (2 штуки)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 30)
tabBar.Position = UDim2.new(0, 10, 0, 44)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local tabs = {"Физика", "Полёт"}
local tabBtns = {}
local pages = {}

for i, name in ipairs(tabs) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.5, -2, 1, 0)
    b.Position = UDim2.new((i-1)*0.5, 2, 0, 0)
    b.BackgroundColor3 = Colors.bgMid
    b.BorderSizePixel = 0
    b.Text = name
    b.TextColor3 = Colors.text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Parent = tabBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    tabBtns[name] = b

    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, -20, 1, -100)
    p.Position = UDim2.new(0, 10, 0, 82)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Colors.accent
    p.CanvasSize = UDim2.new(0, 0, 0, 400)
    p.Visible = false
    p.Parent = main
    local pl = Instance.new("UIListLayout", p)
    pl.Padding = UDim.new(0, 5)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pages[name] = p
end

local activeTab = nil
local function switchTab(name)
    if activeTab then pages[activeTab].Visible = false end
    activeTab = name
    pages[name].Visible = true
    for n, b in pairs(tabBtns) do
        b.BackgroundColor3 = (n == name) and Colors.accent or Colors.bgMid
    end
end

for name, b in pairs(tabBtns) do
    b.MouseButton1Click:Connect(function() switchTab(name) end)
end
switchTab("Физика")

-- ФАБРИКИ
local function makeBtn(parent, text, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 32)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(cb)
        if not ok then warn("[PH] " .. tostring(err)) end
    end)
    return b
end

local function makeSlider(parent, text, minV, maxV, default, callback)
    local cont = Instance.new("Frame", parent)
    cont.Size = UDim2.new(1, -8, 0, 44)
    cont.BackgroundColor3 = Colors.bgMid
    cont.BorderSizePixel = 0
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(1, -20, 0, 16)
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Colors.text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", cont)
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0, 26)
    bar.BackgroundColor3 = Color3.fromRGB(60, 70, 60)
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = Colors.accent
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function upd(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = minV + (maxV - minV) * rel
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = text .. ": " .. string.format("%.0f", val)
        pcall(callback, val)
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; upd(i.Position.X)
        end
    end)
    bar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            upd(i.Position.X)
        end
    end)
end

-- ФУНКЦИИ
local function getCharPos()
    local c = LP.Character
    if not c then return nil end
    local r = c:FindFirstChild("HumanoidRootPart")
    return r and r.Position or nil
end

local function scanObjects()
    local myPos = getCharPos()
    if not myPos then return end

    local found = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored then
            local dist = (obj.Position - myPos).Magnitude
            if dist < CONFIG.RANGE and dist > 2 then
                local isChar = false
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr.Character and obj:IsDescendantOf(plr.Character) then
                        isChar = true; break
                    end
                end
                if not isChar then table.insert(found, obj) end
            end
        end
    end
    cachedObjects = found
end

local function startPhysics()
    State.physicsActive = true
    scanObjects()

    scanThread = task.spawn(function()
        while State.physicsActive do
            task.wait(CONFIG.SCAN_INTERVAL)
            if State.physicsActive and State.autoScan then scanObjects() end
        end
    end)

    physicsConn = RunService.Heartbeat:Connect(function(dt)
        if not State.physicsActive then return end
        local myPos = getCharPos()
        if not myPos then return end

        for _, obj in ipairs(cachedObjects) do
            if obj and obj.Parent and not obj.Anchored then
                local dir = (myPos - obj.Position)
                local dist = dir.Magnitude

                if State.grabMode == "orbit" then
                    if dist > CONFIG.ORBIT_RADIUS then
                        obj.CFrame = CFrame.new(obj.Position + dir.Unit * CONFIG.PULL_SPEED * dt)
                    else
                        orbitAngle = orbitAngle + CONFIG.ROTATION_SPEED * dt
                        local orbitPos = myPos + Vector3.new(
                            math.cos(orbitAngle) * CONFIG.ORBIT_RADIUS,
                            math.sin(orbitAngle * 2) * 2,
                            math.sin(orbitAngle) * CONFIG.ORBIT_RADIUS
                        )
                        obj.CFrame = CFrame.new(orbitPos)
                    end

                elseif State.grabMode == "fling" then
                    obj.AssemblyLinearVelocity = dir.Unit * 500

                elseif State.grabMode == "hold" then
                    obj.CFrame = CFrame.new(myPos + Vector3.new(0, 5, 0))

                elseif State.grabMode == "vortex" then
                    obj.CFrame = CFrame.new(obj.Position + dir.Unit * CONFIG.PULL_SPEED * dt) * CFrame.Angles(dt*10, dt*10, dt*10)
                end
            end
        end
    end)
end

local function stopPhysics()
    State.physicsActive = false
    if physicsConn then physicsConn:Disconnect(); physicsConn = nil end
    if scanThread then task.cancel(scanThread); scanThread = nil end
    cachedObjects = {}
end

-- FLY
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    local c = LP.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
    end
    State.flyActive = false
end

local function startFly()
    if State.flyActive then return end
    local c = LP.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    local h = c:FindFirstChildOfClass("Humanoid")
    if not r or not h then return end

    h.PlatformStand = true
    State.flyActive = true

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBV.P = 1250
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = r

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBG.P = 3000
    flyBG.D = 50
    flyBG.CFrame = r.CFrame
    flyBG.Parent = r

    flyConn = RunService.RenderStepped:Connect(function(dt)
        if not State.flyActive or not flyBV or not flyBG then return end
        local cc = LP.Character
        if not cc then return end
        local rr = cc:FindFirstChild("HumanoidRootPart")
        if not rr then return end

        local cam = Camera.CFrame
        local look = cam.LookVector
        local right = cam.RightVector
        local mv = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + look end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - look end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + right end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - right end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mv = mv - Vector3.new(0,1,0) end

        local spd = CONFIG.FLY_SPEED
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then spd = spd * CONFIG.FLY_BOOST end

        local tgt = mv.Magnitude > 0 and mv.Unit * spd or Vector3.zero
        flyBV.Velocity = flyBV.Velocity:Lerp(tgt, 0.15 * (dt * 60))
        flyBG.CFrame = flyBG.CFrame:Lerp(CFrame.new(rr.Position, rr.Position + look), 0.15 * (dt * 60))
    end)
end

-- ВКЛАДКА ФИЗИКА
makeBtn(pages["Физика"], "🧲 ВКЛ/ВЫКЛ PULLER", Colors.accent, function()
    if State.physicsActive then stopPhysics() else startPhysics() end
end)

makeBtn(pages["Физика"], "🔄 РЕЖИМ: ORBIT", Colors.accentDark, function()
    State.grabMode = "orbit"
end)
makeBtn(pages["Физика"], "💥 РЕЖИМ: FLING", Colors.accentDark, function()
    State.grabMode = "fling"
end)
makeBtn(pages["Физика"], "✋ РЕЖИМ: HOLD", Colors.accentDark, function()
    State.grabMode = "hold"
end)
makeBtn(pages["Физика"], "🌀 РЕЖИМ: VORTEX", Colors.accentDark, function()
    State.grabMode = "vortex"
end)

makeBtn(pages["Физика"], "🔍 СКАНИРОВАТЬ", Colors.info, function()
    scanObjects()
    print("[PH] Объектов: " .. #cachedObjects)
end)

makeSlider(pages["Физика"], "Радиус поиска", 100, 1000, 500, function(v) CONFIG.RANGE = v end)
makeSlider(pages["Физика"], "Скорость притяжения", 20, 500, 80, function(v) CONFIG.PULL_SPEED = v end)
makeSlider(pages["Физика"], "Орбита (дистанция)", 3, 100, 8, function(v) CONFIG.ORBIT_RADIUS = v end)

-- ВКЛАДКА ПОЛЁТ
makeBtn(pages["Полёт"], "🚁 ВКЛ/ВЫКЛ FLY (F)", Colors.accent, function()
    if State.flyActive then stopFly() else startFly() end
end)

makeBtn(pages["Полёт"], "👻 NOCLIP", Colors.accentDark, function()
    State.noclipActive = not State.noclipActive
end)

makeSlider(pages["Полёт"], "Скорость полёта", 50, 500, 100, function(v) CONFIG.FLY_SPEED = v end)
makeSlider(pages["Полёт"], "Ускорение (Shift)", 1, 5, 2, function(v) CONFIG.FLY_BOOST = v end)

-- ЛОГИКА NOCLIP
RunService.Stepped:Connect(function()
    if State.noclipActive then
        local c = LP.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        if State.flyActive then stopFly() else startFly() end
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    stopPhysics()
    stopFly()
    gui:Destroy()
end)

print("[TORNADO PHYSICS v3] Загружено! Ключ: FE10DAY")
