-- ============================================================
-- TORNADO HUB v3.6 | Xeno Edition | Key: TORNADIK
-- ============================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

-- ============================================================
-- LANGUAGE
-- ============================================================
local Lang = {
    current = "ru",
    s = {
        ru = {
            title = "TORNADO HUB v3.6",
            home = "Главная", move = "Движение", vis = "Визуал",
            games = "Игры", troll = "Тролль", misc = "Прочее",
            settings = "Настройки",
            fly = "Полёт", speed = "Скорость", jump = "Сила прыжка",
            noclip = "Noclip", infjump = "Беск. прыжок",
            fullbright = "Fullbright", fov = "FOV", esp = "ESP (подсветка)",
            antiafk = "Анти-AFK", godmode = "God Mode",
            brookhaven = "Brookhaven", mm2 = "Murder Mystery 2",
            sab = "Steal a Brainrot", sae = "Steal an Egg",
            toh = "Tower of Hell", iy = "Infinite Yield",
            bloxfruit = "Blox Fruits", adoptme = "Adopt Me",
            arsenal = "Arsenal", bloxburg = "Bloxburg",
            pet = "Pet Simulator", doors = "Doors",
            jailbreak = "Jailbreak", dahood = "Da Hood",
            growgarden = "Grow a Garden", rivals = "Rivals",
            fling = "Fling игрока", bring = "Притянуть", freeze = "Заморозить",
            bang = "Bang", headsit = "Сесть на голову", orbit = "Орбита",
            follow = "Следовать (10с)", copyemote = "Копировать эмоцию",
            spin = "Крутить", void = "Утопить (Void)",
            selectplayer = "Выбрать игрока",
            search = "Поиск по имени",
            searchBtn = "Найти",
            selected = "Выбран: ", random = "Случайный",
            noTarget = "Нет цели", notFound = "Не найден",
            tpToPlayer = "ТП к игроку",
            tpSpawn = "ТП на спавн",
            tpForward = "ТП вперёд (по взгляду)",
            theme = "Сменить цвет",
            lang = "Сменить язык",
            keyOk = "Ключ принят"
        },
        en = {
            title = "TORNADO HUB v3.6",
            home = "Home", move = "Movement", vis = "Visuals",
            games = "Games", troll = "Troll", misc = "Misc",
            settings = "Settings",
            fly = "Fly", speed = "Speed", jump = "Jump Power",
            noclip = "Noclip", infjump = "Infinite Jump",
            fullbright = "Fullbright", fov = "FOV", esp = "ESP (Highlight)",
            antiafk = "Anti-AFK", godmode = "God Mode",
            brookhaven = "Brookhaven", mm2 = "Murder Mystery 2",
            sab = "Steal a Brainrot", sae = "Steal an Egg",
            toh = "Tower of Hell", iy = "Infinite Yield",
            bloxfruit = "Blox Fruits", adoptme = "Adopt Me",
            arsenal = "Arsenal", bloxburg = "Bloxburg",
            pet = "Pet Simulator", doors = "Doors",
            jailbreak = "Jailbreak", dahood = "Da Hood",
            growgarden = "Grow a Garden", rivals = "Rivals",
            fling = "Fling Player", bring = "Bring", freeze = "Freeze",
            bang = "Bang", headsit = "Head Sit", orbit = "Orbit",
            follow = "Follow (10s)", copyemote = "Copy Emote",
            spin = "Spin", void = "Void",
            selectplayer = "Select Player",
            search = "Search by Name",
            searchBtn = "Search",
            selected = "Selected: ", random = "Random",
            noTarget = "No target", notFound = "Not found",
            tpToPlayer = "TP to Player",
            tpSpawn = "TP to Spawn",
            tpForward = "TP Forward (look)",
            theme = "Change Theme",
            lang = "Change Language",
            keyOk = "Key accepted"
        }
    }
}
local function T(k)
    local t = Lang.s[Lang.current]
    return t[k] or k
end

-- ============================================================
-- KEY SYSTEM
-- ============================================================
local KEY = "TORNADIK"
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "TornadoKey"
keyGui.ResetOnSpawn = false
pcall(function() keyGui.Parent = CoreGui end)
if not keyGui.Parent then keyGui.Parent = PG end

local kf = Instance.new("Frame")
kf.Size = UDim2.new(0, 400, 0, 200)
kf.Position = UDim2.new(0.5, -200, 0.5, -100)
kf.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
kf.BorderSizePixel = 0
kf.Parent = keyGui
Instance.new("UICorner", kf).CornerRadius = UDim.new(0, 12)
local kfs = Instance.new("UIStroke", kf)
kfs.Color = Color3.fromRGB(160, 60, 240)
kfs.Thickness = 2

local ktitle = Instance.new("TextLabel", kf)
ktitle.Size = UDim2.new(1, 0, 0, 50)
ktitle.BackgroundTransparency = 1
ktitle.Text = "TORNADO HUB"
ktitle.TextColor3 = Color3.fromRGB(200, 130, 255)
ktitle.Font = Enum.Font.GothamBold
ktitle.TextSize = 22

local kbox = Instance.new("TextBox", kf)
kbox.Size = UDim2.new(1, -60, 0, 40)
kbox.Position = UDim2.new(0, 30, 0, 70)
kbox.BackgroundColor3 = Color3.fromRGB(35, 15, 55)
kbox.BorderSizePixel = 0
kbox.PlaceholderText = "Enter key..."
kbox.Text = ""
kbox.TextColor3 = Color3.fromRGB(240, 220, 255)
kbox.Font = Enum.Font.GothamSemibold
kbox.TextSize = 16
Instance.new("UICorner", kbox).CornerRadius = UDim.new(0, 8)

local kbtn = Instance.new("TextButton", kf)
kbtn.Size = UDim2.new(1, -60, 0, 40)
kbtn.Position = UDim2.new(0, 30, 0, 125)
kbtn.BackgroundColor3 = Color3.fromRGB(140, 50, 230)
kbtn.BorderSizePixel = 0
kbtn.Text = "LOGIN"
kbtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kbtn.Font = Enum.Font.GothamBold
kbtn.TextSize = 16
Instance.new("UICorner", kbtn).CornerRadius = UDim.new(0, 8)

local kstatus = Instance.new("TextLabel", kf)
kstatus.Size = UDim2.new(1, 0, 0, 20)
kstatus.Position = UDim2.new(0, 0, 1, -22)
kstatus.BackgroundTransparency = 1
kstatus.Text = ""
kstatus.TextColor3 = Color3.fromRGB(255, 80, 80)
kstatus.Font = Enum.Font.Gotham
kstatus.TextSize = 12

local keyPassed = false
kbtn.MouseButton1Click:Connect(function()
    if kbox.Text == KEY then
        keyPassed = true
        kstatus.TextColor3 = Color3.fromRGB(100, 255, 120)
        kstatus.Text = T("keyOk")
        task.wait(0.4)
        keyGui:Destroy()
    else
        kstatus.Text = "Invalid key"
        kbox.Text = ""
    end
end)

while not keyPassed do
    task.wait(0.1)
end

-- ============================================================
-- THEME
-- ============================================================
local Theme = {
    accent = Color3.fromRGB(160, 60, 240),
    bgDark = Color3.fromRGB(18, 8, 30),
    bgMid = Color3.fromRGB(35, 15, 60),
    text = Color3.fromRGB(220, 190, 255)
}

-- ============================================================
-- MAIN GUI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "TornadoHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = PG end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 620, 0, 440)
main.Position = UDim2.new(0.5, -310, 0.5, -220)
main.BackgroundColor3 = Theme.bgDark
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local ms = Instance.new("UIStroke", main)
ms.Color = Theme.accent
ms.Thickness = 2

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Theme.bgMid
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 18, 0, 0)
title.BackgroundTransparency = 1
title.Text = T("title")
title.TextColor3 = Color3.fromRGB(210, 150, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 150, 1, -60)
tabBar.Position = UDim2.new(0, 8, 0, 55)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local pageHolder = Instance.new("Frame")
pageHolder.Size = UDim2.new(1, -175, 1, -70)
pageHolder.Position = UDim2.new(0, 165, 0, 58)
pageHolder.BackgroundTransparency = 1
pageHolder.ClipsDescendants = true
pageHolder.Parent = main

local pages = {}
local activeBtn = nil
local activePage = nil

local function switchTab(name, btn)
    if activeBtn == btn then return end
    for _, pg in pairs(pages) do
        pg.Position = UDim2.new(0, 99999, 0, 0)
    end
    pages[name].Position = UDim2.new(0, 0, 0, 0)
    activePage = pages[name]
    if activeBtn then
        TweenService:Create(activeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.bgMid}):Play()
    end
    activeBtn = btn
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.accent}):Play()
end

local tabs = {
    {"home", "home"}, {"move", "move"}, {"vis", "vis"},
    {"games", "games"}, {"troll", "troll"}, {"misc", "misc"}, {"settings", "settings"}
}

for i, t in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 42)
    btn.BackgroundColor3 = Theme.bgMid
    btn.BorderSizePixel = 0
    btn.Text = T(t[2])
    btn.TextColor3 = Theme.text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = tabBar
    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft = UDim.new(0, 12)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local pg = Instance.new("Frame")
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.Position = UDim2.new(0, 99999, 0, 0)
    pg.BackgroundTransparency = 1
    pg.BorderSizePixel = 0
    pg.ClipsDescendants = true
    pg.Parent = pageHolder

    pages[t[1]] = pg
    btn.MouseButton1Click:Connect(function() switchTab(t[1], btn) end)
end

local pageY = {}
for name, _ in pairs(pages) do
    pageY[name] = 4
end

-- ============================================================
-- ELEMENTS
-- ============================================================
local function makeToggle(parent, pageName, text, default, cb)
    local y = pageY[pageName]
    pageY[pageName] = y + 42
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 36)
    b.Position = UDim2.new(0, 4, 0, y)
    b.BackgroundColor3 = Theme.bgMid
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Theme.text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = parent
    local pad = Instance.new("UIPadding", b)
    pad.PaddingLeft = UDim.new(0, 12)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    local ind = Instance.new("Frame", b)
    ind.Size = UDim2.new(0, 36, 0, 18)
    ind.Position = UDim2.new(1, -46, 0.5, -9)
    ind.BackgroundColor3 = default and Theme.accent or Color3.fromRGB(55, 35, 75)
    ind.BorderSizePixel = 0
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", ind)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local state = default
    b.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(ind, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Theme.accent or Color3.fromRGB(55, 35, 75)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        pcall(cb, state)
    end)
end

local function makeButton(parent, pageName, text, cb)
    local y = pageY[pageName]
    pageY[pageName] = y + 42
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 36)
    b.Position = UDim2.new(0, 4, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(55, 25, 90)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(240, 220, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Theme.accent}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(55, 25, 90)}):Play()
    end)
    b.MouseButton1Click:Connect(function() pcall(cb) end)
    return b
end

local function makeSlider(parent, pageName, text, minV, maxV, default, cb)
    local y = pageY[pageName]
    pageY[pageName] = y + 60
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -8, 0, 54)
    cont.Position = UDim2.new(0, 4, 0, y)
    cont.BackgroundColor3 = Theme.bgMid
    cont.BorderSizePixel = 0
    cont.Parent = parent
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 7)
    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Theme.text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local bar = Instance.new("Frame", cont)
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0, 36)
    bar.BackgroundColor3 = Color3.fromRGB(55, 35, 75)
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = Theme.accent
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function upd(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = minV + (maxV - minV) * rel
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = text .. ": " .. string.format("%.1f", val)
        pcall(cb, val)
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            upd(i.Position.X)
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

-- TextBox для поиска игрока
local function makeTextBox(parent, pageName, placeholder, onEnter)
    local y = pageY[pageName]
    pageY[pageName] = y + 46
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -8, 0, 38)
    box.Position = UDim2.new(0, 4, 0, y)
    box.BackgroundColor3 = Theme.bgMid
    box.BorderSizePixel = 0
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Theme.text
    box.PlaceholderColor3 = Color3.fromRGB(120, 100, 150)
    box.Font = Enum.Font.GothamSemibold
    box.TextSize = 13
    box.ClearTextOnFocus = false
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            pcall(onEnter, box.Text)
        end
    end)
    return box
end

-- ============================================================
-- STATE
-- ============================================================
local State = {fly = false, noclip = false, infjump = false, antiafk = true, esp = false}
local FLY_SPEED = 60
local flyBV, flyBG, flyConn
local selectedPlayer = nil
local espFolder = Instance.new("Folder")
espFolder.Name = "TornadoESP"
espFolder.Parent = Workspace

-- ============================================================
-- FLY
-- ============================================================
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV and flyBV.Parent then flyBV:Destroy(); flyBV = nil end
    if flyBG and flyBG.Parent then flyBG:Destroy(); flyBG = nil end
    local c = LP.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
    end
end

local function startFly()
    local c = LP.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    local h = c:FindFirstChildOfClass("Humanoid")
    if not r or not h then return end
    h.PlatformStand = true
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
        if not State.fly then return end
        local cc = LP.Character
        if not cc then return end
        local rr = cc:FindFirstChild("HumanoidRootPart")
        if not rr or not flyBV or not flyBG then return end
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
        local spd = FLY_SPEED
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then spd = spd * 2.5 end
        local tgt = Vector3.zero
        if mv.Magnitude > 0 then tgt = mv.Unit * spd end
        flyBV.Velocity = flyBV.Velocity:Lerp(tgt, 0.15 * (dt * 60))
        flyBG.CFrame = flyBG.CFrame:Lerp(CFrame.new(rr.Position, rr.Position + look), 0.15 * (dt * 60))
    end)
end

-- ============================================================
-- PLAYER HELPERS
-- ============================================================
local function getRandomPlayer()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(list, p) end
    end
    if #list == 0 then return nil end
    return list[math.random(1, #list)]
end

local function getTargetPlayer()
    if selectedPlayer and selectedPlayer.Parent and selectedPlayer.Character then
        return selectedPlayer
    end
    return getRandomPlayer()
end

local function findPlayerByName(name)
    if not name or name == "" then return nil end
    name = string.lower(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and string.find(string.lower(p.Name), name, 1, true) then
            return p
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.DisplayName and string.find(string.lower(p.DisplayName), name, 1, true) then
            return p
        end
    end
    return nil
end

-- ============================================================
-- ESP
-- ============================================================
local function addESP(plr)
    if plr == LP then return end
    if espFolder:FindFirstChild(plr.Name) then return end

    local function onChar(char)
        if not State.esp then return end
        local old = espFolder:FindFirstChild(plr.Name)
        if old then old:Destroy() end
        local hl = Instance.new("Highlight")
        hl.Name = plr.Name
        hl.FillColor = Theme.accent
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.Adornee = char
        hl.Parent = espFolder
    end

    if plr.Character then onChar(plr.Character) end
    plr.CharacterAdded:Connect(onChar)
end

local function clearESP()
    for _, obj in ipairs(espFolder:GetChildren()) do
        obj:Destroy()
    end
end

-- ============================================================
-- BUILD: HOME
-- ============================================================
makeToggle(pages.home, "home", T("antiafk"), true, function(s) State.antiafk = s end)
makeButton(pages.home, "home", "Info", function() print("[TORNADO HUB] Active | Key: TORNADIK") end)

-- ============================================================
-- BUILD: MOVEMENT
-- ============================================================
makeToggle(pages.move, "move", T("fly"), false, function(s)
    State.fly = s
    if s then startFly() else stopFly() end
end)
makeSlider(pages.move, "move", "Fly Speed", 20, 300, 60, function(v) FLY_SPEED = v end)
makeSlider(pages.move, "move", T("speed"), 16, 300, 100, function(v)
    local c = LP.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end
end)
makeSlider(pages.move, "move", T("jump"), 50, 500, 50, function(v)
    local c = LP.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = v; h.UseJumpPower = true end
    end
end)
makeToggle(pages.move, "move", T("infjump"), false, function(s) State.infjump = s end)
makeToggle(pages.move, "move", T("noclip"), false, function(s) State.noclip = s end)

-- ============================================================
-- BUILD: VISUAL
-- ============================================================
makeToggle(pages.vis, "vis", T("fullbright"), false, function(s)
    if s then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.Brightness = 1
    end
end)
makeSlider(pages.vis, "vis", T("fov"), 70, 150, 70, function(v)
    Camera.FieldOfView = v
end)
makeToggle(pages.vis, "vis", T("esp"), false, function(s)
    State.esp = s
    if s then
        for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
        Players.PlayerAdded:Connect(function(p)
            if State.esp then addESP(p) end
        end)
    else
        clearESP()
    end
end)

-- ============================================================
-- BUILD: GAMES
-- ============================================================
local function safeLoad(url)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then warn("[TORNADO] " .. tostring(err)) end
end

makeButton(pages.games, "games", T("brookhaven"), function()
    safeLoad("https://raw.githubusercontent.com/as6cd0/SP_Hub/refs/heads/main/Brookhaven")
end)
makeButton(pages.games, "games", T("mm2"), function()
    safeLoad("https://raw.githubusercontent.com/thunderXhub/ThunderXHUB/refs/heads/main/loader")
end)
makeButton(pages.games, "games", T("sab"), function()
    safeLoad("https://raw.githubusercontent.com/vankien123/roblox-script-for-steal-a-brainrot-/refs/heads/main/script.lua")
end)
makeButton(pages.games, "games", T("sae"), function()
    safeLoad("https://raw.githubusercontent.com/XE3Scripts/Axur-sGamesHub/refs/heads/main/StealAnEgg")
end)
makeButton(pages.games, "games", T("toh"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("iy"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("bloxfruit"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("adoptme"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("arsenal"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("bloxburg"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("pet"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("doors"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("jailbreak"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("dahood"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("growgarden"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)
makeButton(pages.games, "games", T("rivals"), function()
    safeLoad("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)

-- ============================================================
-- BUILD: TROLL
-- ============================================================
-- Поиск игрока по имени
makeTextBox(pages.troll, "troll", T("search") .. "...", function(text)
    local found = findPlayerByName(text)
    if found then
        selectedPlayer = found
        if selectBtn then
            selectBtn.Text = T("selected") .. found.Name
        end
    else
        if selectBtn then
            selectBtn.Text = T("notFound")
        end
    end
end)

-- Кнопка выбора игрока (круговой перебор)
local selectBtn = Instance.new("TextButton")
local selectY = pageY["troll"]
pageY["troll"] = selectY + 42
selectBtn.Size = UDim2.new(1, -8, 0, 36)
selectBtn.Position = UDim2.new(0, 4, 0, selectY)
selectBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
selectBtn.BorderSizePixel = 0
selectBtn.Text = T("selectplayer") .. ": " .. T("random")
selectBtn.TextColor3 = Color3.fromRGB(255, 230, 255)
selectBtn.Font = Enum.Font.GothamBold
selectBtn.TextSize = 13
selectBtn.Parent = pages.troll
Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 7)

local playerIndex = 0
selectBtn.MouseButton1Click:Connect(function()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(list, p) end
    end
    if #list == 0 then
        selectBtn.Text = T("selectplayer") .. ": " .. T("noTarget")
        selectedPlayer = nil
        return
    end
    playerIndex = playerIndex % #list + 1
    selectedPlayer = list[playerIndex]
    selectBtn.Text = T("selected") .. selectedPlayer.Name
end)

-- Тролль-функции
makeButton(pages.troll, "troll", T("fling"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local thrp = t.Character:FindFirstChild("HumanoidRootPart")
    if not thrp then return end
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = thrp
    hrp.CFrame = thrp.CFrame
    task.wait(0.1)
    bv.Velocity = Vector3.new(50000, 50000, 50000)
    task.wait(0.2)
    bv:Destroy()
end)

makeButton(pages.troll, "troll", T("bring"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local thrp = t.Character:FindFirstChild("HumanoidRootPart")
    if not thrp then return end
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    thrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
end)

makeButton(pages.troll, "troll", T("freeze"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local thrp = t.Character:FindFirstChild("HumanoidRootPart")
    if not thrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = thrp
    task.delay(3, function() if bv and bv.Parent then bv:Destroy() end end)
end)

makeButton(pages.troll, "troll", T("bang"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local thrp = t.Character:FindFirstChild("HumanoidRootPart")
    if not thrp then return end
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for i = 1, 15 do
        hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 1.5)
        task.wait(0.04)
    end
end)

makeButton(pages.troll, "troll", T("headsit"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local head = t.Character:FindFirstChild("Head")
    if not head then return end
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = head.CFrame * CFrame.new(0, 2, 0)
end)

makeButton(pages.troll, "troll", T("orbit"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local thrp = t.Character:FindFirstChild("HumanoidRootPart")
    if not thrp then return end
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for i = 1, 60 do
        local angle = (i / 60) * math.pi * 2
        hrp.CFrame = thrp.CFrame * CFrame.new(math.cos(angle) * 5, 3, math.sin(angle) * 5)
        task.wait(0.03)
    end
end)

makeButton(pages.troll, "troll", T("follow"), function()
    local t = getTargetPlayer()
    if not t then return end
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then conn:Disconnect(); return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local tChar = t.Character
        if not tChar then return end
        local thrp = tChar:FindFirstChild("HumanoidRootPart")
        if not thrp then return end
        hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 4)
    end)
    task.delay(10, function() conn:Disconnect() end)
end)

makeButton(pages.troll, "troll", T("copyemote"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local th = t.Character:FindFirstChildOfClass("Humanoid")
    if not th then return end
    local anim = th:FindFirstChildOfClass("Animator")
    if not anim then return end
    local playing = anim:GetPlayingAnimationTracks()
    if #playing > 0 then
        local track = playing[1]
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        local a = h:FindFirstChildOfClass("Animator")
        if not a then return end
        local loaded = a:LoadAnimation(track.Animation)
        loaded:Play()
    end
end)

makeButton(pages.troll, "troll", T("spin"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local thrp = t.Character:FindFirstChild("HumanoidRootPart")
    if not thrp then return end
    for i = 1, 50 do
        thrp.CFrame = thrp.CFrame * CFrame.Angles(0, math.rad(30), 0)
        task.wait(0.02)
    end
end)

makeButton(pages.troll, "troll", T("void"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local thrp = t.Character:FindFirstChild("HumanoidRootPart")
    if not thrp then return end
    thrp.CFrame = CFrame.new(thrp.Position.X, -500, thrp.Position.Z)
end)

-- ============================================================
-- BUILD: MISC (Телепорт + God Mode)
-- ============================================================
makeButton(pages.misc, "misc", T("tpToPlayer"), function()
    local t = getTargetPlayer()
    if not t or not t.Character then return end
    local thrp = t.Character:FindFirstChild("HumanoidRootPart")
    if not thrp then return end
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = thrp.CFrame + Vector3.new(0, 0, 3)
end)

makeButton(pages.misc, "misc", T("tpSpawn"), function()
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then
        hrp.CFrame = spawn.CFrame + Vector3.new(0, 4, 0)
    end
end)

makeButton(pages.misc, "misc", T("tpForward"), function()
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = hrp.CFrame + Camera.CFrame.LookVector * 50
end)

makeToggle(pages.misc, "misc", T("godmode"), false, function(s)
    if s then
        RunService.Heartbeat:Connect(function()
            local c = LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then h.MaxHealth = math.huge; h.Health = math.huge end
            end
        end)
    end
end)

-- ============================================================
-- BUILD: SETTINGS
-- ============================================================
local colors = {
    {"Purple", Color3.fromRGB(160, 60, 240)},
    {"Blue", Color3.fromRGB(60, 120, 240)},
    {"Red", Color3.fromRGB(230, 60, 60)},
    {"Green", Color3.fromRGB(60, 220, 120)},
    {"Orange", Color3.fromRGB(240, 160, 60)},
    {"Pink", Color3.fromRGB(240, 90, 180)},
    {"Cyan", Color3.fromRGB(60, 220, 240)}
}
for _, c in ipairs(colors) do
    makeButton(pages.settings, "settings", T("theme") .. ": " .. c[1], function()
        Theme.accent = c[2]
        ms.Color = c[2]
    end)
end

makeButton(pages.settings, "settings", T("lang"), function()
    if Lang.current == "ru" then
        Lang.current = "en"
    else
        Lang.current = "ru"
    end
    print("[TORNADO] Language: " .. Lang.current)
end)

-- ============================================================
-- LOOPS
-- ============================================================
RunService.Stepped:Connect(function()
    if State.noclip then
        local c = LP.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.infjump then
        local c = LP.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

LP.Idled:Connect(function()
    if State.antiafk then
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(0.1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

-- ============================================================
-- CLOSE / TOGGLE
-- ============================================================
closeBtn.MouseButton1Click:Connect(function()
    stopFly()
    clearESP()
    gui:Destroy()
end)

UserInputService.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

pages.home.Position = UDim2.new(0, 0, 0, 0)
activePage = pages.home
activeBtn = tabBar:GetChildren()[1]
TweenService:Create(activeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.accent}):Play()

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "TORNADO HUB",
        Text = "Loaded! RightShift to toggle",
        Duration = 5
    })
end)
