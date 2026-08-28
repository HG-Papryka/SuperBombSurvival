--[[
    by potet
    tower heroes autofarm
    needs: Spectre / Lemonade Cat / Scientist
    run in lobby first, teleports to game automatically
    ~200 coins a hour (AUTOSKIP - ON)

Chef / Wizard (~105C/H)
https://github.com/HG-Papryka/RobloxScript/blob/main/TowerHerose/autofarm/0.lua
]]

print("Potetium Loaded")

_G.Spin = _G.Spin or false

local a = {}
local b = {}
local c = {}
local d = {}

local ts = game:GetService("TeleportService")
local gs = game:GetService("GuiService")
local ps = game:GetService("Players")
local rs = game:GetService("RunService")
local rep = game:GetService("ReplicatedStorage")
local vim = game:GetService("VirtualInputManager")

local lp = ps.LocalPlayer
local lobbyId = 4646477729

a.a1 = function()
    local target = (game.PlaceId ~= lobbyId) and lobbyId or game.PlaceId
    if queueteleport then
        queueteleport(([[game:GetService("TeleportService"):Teleport(%d)]]):format(target))
    end
    task.wait(1)
    pcall(function() ts:Teleport(target, lp) end)
end

a.a2 = function()
    gs.ErrorMessageChanged:Connect(function(msg)
        if msg and msg ~= "" then
            task.wait(5)
            a.a1()
        end
    end)

    lp.OnTeleport:Connect(function(st)
        if st == Enum.TeleportState.Failed then
            task.wait(3)
            a.a1()
        end
    end)

    local last = tick()
    rs.Heartbeat:Connect(function() last = tick() end)
    task.spawn(function()
        while true do
            task.wait(5)
            if tick() - last > 15 then
                a.a1()
            end
        end
    end)
end

a.a2()

if game.PlaceId == lobbyId then
    b.b1 = function()
        local list = {
            "Chef", "Hotdog Frank", "Volt", "Yasuke", "Mako", "Wizard",
            "Scientist", "Fracture", "Bunny", "Beebo", "Voca", "Branch",
            "Wafer", "Sparks Kilowatt", "Keith", "Soda Pop", "Quinn", "Lure",
            "Slime King", "Kart Kid", "Jester", "Hayes", "Buzzer",
            "Stella", "El Goblino", "Nuki Launcher", "Byte", "Dumpster Child",
            "Lemonade Cat", "Maitake", "Spectre", "Discount Dog", "Balloon Pal"
        }
        for _, name in ipairs(list) do
            local t = rep.Troops:FindFirstChild(name)
            if t then pcall(function() rep.Events.EquipTroop:InvokeServer(t) end) end
        end
        local loadout = {
            { name = "Lemonade Cat", slot = 2 },
            { name = "Scientist", slot = 3 },
            { name = "Spectre", slot = 4 }
        }
        for _, entry in ipairs(loadout) do
            local t = rep.Troops:FindFirstChild(entry.name)
            if t then pcall(function() rep.Events.EquipTroop:InvokeServer(t, entry.slot) end) end
        end
    end

    b.b2 = function()
        local remote = rep:WaitForChild("Events"):WaitForChild("PrivateServerEvent")
        remote:FireServer("Create", true)
        task.wait(0.05)
        remote:FireServer("Mode", "Challenge Mode")
        task.wait(0.05)
        remote:FireServer("Update", { Map = rep:WaitForChild("Maps"):WaitForChild("DoorsMap") })
        task.wait(0.05)
        remote:FireServer("Difficulty", 2)
        task.wait(0.05)
        remote:FireServer("Start")
    end

    task.spawn(function()
        task.wait(3)
        b.b1()
        b.b2()
    end)
    return
end

local troopPlace = rep:WaitForChild("Events"):WaitForChild("TroopPlace")
local troopEvent = rep:WaitForChild("Events"):WaitForChild("TroopEvent")
local troopFolder = workspace:WaitForChild("Troop")

lp:GetMouse().Icon = "rbxasset://textures/Blank.png"

local places = {
    { name = "Spectre", x = 10.2540, y = 63.3995, z = 5.0784, rot = 4 },
    { name = "Scientist", x = 13.3558, y = 63.3995, z = 4.9185, rot = 0 },
    { name = "Scientist", x = 10.2099, y = 63.3995, z = 8.3131, rot = 0 },
    { name = "Scientist", x = 10.9268, y = 63.3995, z = 2.1417, rot = 0 },
    { name = "Scientist", x = 7.0622, y = 63.3995, z = 5.6291, rot = 0 },
    { name = "Scientist", x = 13.3136, y = 63.3995, z = 8.2517, rot = 0 },
    { name = "Lemonade Cat", x = 19.5783, y = 63.3495, z = 14.2713, rot = 2 },
    { name = "Lemonade Cat", x = 19.5856, y = 63.3495, z = 18.2217, rot = 2 },
    { name = "Lemonade Cat", x = 19.7608, y = 63.3495, z = 22.0081, rot = 2 },
    { name = "Lemonade Cat", x = 19.5466, y = 63.3495, z = 10.7319, rot = 2 }
}

local towerData = {
    { name = "Spectre", max = 1, texture = "rbxassetid://8273607953" },
    { name = "Scientist", max = 5, texture = "rbxassetid://7118338906" },
    { name = "Lemonade Cat", max = 4, texture = "rbxassetid://8273477941" }
}

local cardRefs = {}

c.c1 = function()
    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    sg.DisplayOrder = -1
    sg.Parent = lp:WaitForChild("PlayerGui")

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 130, 0, 0)
    f.Position = UDim2.new(0, 8, 0.5, 0)
    f.AnchorPoint = Vector2.new(0, 0.5)
    f.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    f.BorderSizePixel = 0
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.Parent = sg
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

    local pad = Instance.new("UIPadding", f)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)

    local list = Instance.new("UIListLayout", f)
    list.Padding = UDim.new(0, 6)
    list.FillDirection = Enum.FillDirection.Vertical

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 18)
    title.BackgroundTransparency = 1
    title.Text = "Potetium"
    title.TextColor3 = Color3.fromRGB(80, 200, 255)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = f

    for _, td in ipairs(towerData) do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 60)
        card.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        card.BorderSizePixel = 0
        card.Parent = f
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 44, 0, 44)
        img.Position = UDim2.new(0, 6, 0.5, 0)
        img.AnchorPoint = Vector2.new(0, 0.5)
        img.BackgroundTransparency = 1
        img.Image = td.texture
        img.Parent = card

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, -56, 0, 16)
        nl.Position = UDim2.new(0, 54, 0, 8)
        nl.BackgroundTransparency = 1
        nl.TextColor3 = Color3.fromRGB(220, 220, 230)
        nl.TextSize = 11
        nl.Font = Enum.Font.GothamBold
        nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.TextTruncate = Enum.TextTruncate.AtEnd
        nl.Text = td.name
        nl.Parent = card

        local cl = Instance.new("TextLabel")
        cl.Size = UDim2.new(1, -56, 0, 14)
        cl.Position = UDim2.new(0, 54, 0, 26)
        cl.BackgroundTransparency = 1
        cl.TextColor3 = Color3.fromRGB(120, 220, 160)
        cl.TextSize = 11
        cl.Font = Enum.Font.Gotham
        cl.TextXAlignment = Enum.TextXAlignment.Left
        cl.Text = "0 / " .. td.max
        cl.Parent = card

        cardRefs[td.name] = { card = card, countLabel = cl, img = img, max = td.max }
    end
end

c.c2 = function()
    local counts = {}
    for _, troop in ipairs(troopFolder:GetChildren()) do
        counts[troop.Name] = (counts[troop.Name] or 0) + 1
    end
    for name, ref in pairs(cardRefs) do
        local n = counts[name] or 0
        ref.countLabel.Text = n .. " / " .. ref.max
        local isEmpty = n == 0
        ref.card.BackgroundColor3 = isEmpty and Color3.fromRGB(18, 18, 22) or Color3.fromRGB(24, 24, 32)
        ref.img.ImageTransparency = isEmpty and 0.6 or 0
        ref.countLabel.TextColor3 = isEmpty and Color3.fromRGB(70, 70, 90) or Color3.fromRGB(120, 220, 160)
    end
end

c.c1()

d.d1 = function(btn)
    if not btn or not btn.Visible then return end
    pcall(function() btn.MouseButton1Click:Fire() end)
    local inset = gs:GetGuiInset()
    local pos = btn.AbsolutePosition
    local size = btn.AbsoluteSize
    local x = pos.X + size.X / 2
    local y = pos.Y + size.Y / 2 + inset.Y
    vim:SendMouseMoveEvent(x, y, game)
    task.wait(0.02)
    vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

d.d2 = function()
    local menu = lp.PlayerGui:FindFirstChild("Menu")
    if not menu then return end
    local skip = menu:FindFirstChild("Skip") and menu.Skip:FindFirstChild("Skip")
    if skip and skip.Visible then d.d1(skip) end

    local ready = menu:FindFirstChild("HeroFrame") and menu.HeroFrame:FindFirstChild("ServerFrame") and menu.HeroFrame.ServerFrame:FindFirstChild("Ready")
    if ready and ready.Visible and ready.AbsoluteSize ~= Vector2.zero then d.d1(ready) end

    local leave = menu:FindFirstChild("ResultScreen") and menu.ResultScreen:FindFirstChild("Leave")
    if leave and leave.Visible and leave.AbsoluteSize ~= Vector2.zero then d.d1(leave) end
end

d.d3 = function()
    for _, move in ipairs(places) do
        local t = rep:FindFirstChild("Troops") and rep.Troops:FindFirstChild(move.name)
        if t then
            pcall(function()
                troopPlace:FireServer(t, Vector3.new(move.x, move.y, move.z), move.rot)
            end)
        end
    end
end

d.d4 = function()
    local lemCount, sciCount = 0, 0
    for _, troop in ipairs(troopFolder:GetChildren()) do
        if troop.Name == "Lemonade Cat" and lemCount < 4 then
            pcall(function() troopEvent:FireServer("Upgrade", troop) end)
            lemCount += 1
        elseif troop.Name == "Scientist" and sciCount < 5 then
            pcall(function() troopEvent:FireServer("Upgrade", troop) end)
            sciCount += 1
        elseif troop.Name == "Spectre" then
            pcall(function() troopEvent:FireServer("Upgrade", troop) end)
        end
    end
end

task.spawn(function()
    while true do
        c.c2()
        d.d2()
        d.d3()
        d.d4()
        task.wait(0.5)
    end
end)

if _G.Spin then
    local function spin()
        local char = lp.Character or lp.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        if not root:FindFirstChild("PotetSpin") then
            local bav = Instance.new("BodyAngularVelocity")
            bav.Name = "PotetSpin"
            bav.AngularVelocity = Vector3.new(0, 10, 0)
            bav.MaxTorque = Vector3.new(0, math.huge, 0)
            bav.Parent = root
        end
    end
    spin()
    lp.CharacterAdded:Connect(spin)
end
--[[
this code is
stolen, vibecoded, skidded, leaked, obfuscated, deobfuscated, reobfuscated,
copy pasted from v3rmillion, reuploaded, re-reuploaded, grabbed from some
random pastebin from 2019, has 47 unresolved bugs, was made at 3am, untested,
shipped anyway, has memory leaks, probably rats u, definitely logs ur hwid,
sends ur ip to some discord server, written by a 9 year old, reviewed by nobody,
documented by accident, optimized never, refactored once and made worse,
originally for a different game, adapted badly, stolen again after that,
and if ur reading this ur already cooked
]]
