--[[
Potetium - fps boost script

    toggles:
    _G.Cam         = false -- true = sky cam (fov 1), false = normal
    _G.Transparent = true  -- true = invisible parts, false = gray plastic
    _G.Gui         = true  -- true = keep ui on, false = hide ui

    features:
    - removes textures, decals, particles, sound & lighting
    - boosts new items instantly via descendantadded
    - batching prevents lag spikes on load
    - ignores bss collectibles
--]]

print("Potetium Loaded")

_G.Cam = (_G.Cam ~= nil) and _G.Cam or false
_G.Transparent = (_G.Transparent ~= nil) and _G.Transparent or true
_G.Gui = (_G.Gui ~= nil) and _G.Gui or true

local a = {}
local b = {}
local c = {}

local p = game:GetService("Players")
local lp = p.LocalPlayer
local bss = (game.PlaceId == 1537690962)
local d = bss and workspace:FindFirstChild("Collectibles")

a.a1 = function(v)
    if not v or not v.Parent then return end

    if bss and d and v:IsDescendantOf(d) then
        return
    end

    if not _G.Gui and (v:IsA("ScreenGui") or v:IsA("BillboardGui") or v:IsA("SurfaceGui")) then
        if v.Parent ~= lp.PlayerGui then
            v.Enabled = false
        end
    end

    if v:IsA("Decal") or v:IsA("Texture") or v:IsA("Clothing") or v:IsA("SurfaceAppearance") then
        v:Destroy()
    elseif v:IsA("PostEffect") or v:IsA("Light") or v:IsA("Sound") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
        v.Enabled = false
    elseif v:IsA("BasePart") then
        v.Material = Enum.Material.Plastic
        v.Reflectance = 0
        v.Color = Color3.fromRGB(163, 162, 165)
        pcall(function() v.CastShadow = false end)
        if _G.Transparent then
            v.Transparency = 1
        end
    end
end

a.a2 = function()
    local e = {workspace, game:GetService("Lighting"), game:GetService("MaterialService")}
    local count = 0
    for _, k in ipairs(e) do
        for _, v in ipairs(k:GetDescendants()) do
            a.a1(v)
            count += 1
            if count % 350 == 0 then
                task.wait()
            end
        end
    end
end

a.a3 = function()
    workspace.DescendantAdded:Connect(function(v)
        if v and v.Parent then
            task.defer(a.a1, v)
        end
    end)
end

b.b1 = function()
    local l = game:GetService("Lighting")
    pcall(function()
        l.GlobalShadows = false
        l.FogEnd = 9e9
        l.Technology = Enum.Technology.Compatibility
    end)
    pcall(function()
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    end)
end

c.c1 = function()
    if not _G.Cam then return end
    local r = game:GetService("RunService")
    local cm = workspace.CurrentCamera
    cm.FieldOfView = 1
    r.RenderStepped:Connect(function()
        local ch = lp.Character
        local rt = ch and ch:FindFirstChild("HumanoidRootPart")
        if rt then
            cm.CameraType = Enum.CameraType.Scriptable
            cm.CFrame = CFrame.new(rt.Position, rt.Position + Vector3.new(0, 1000, 0))
        end
    end)
end

b.b1()
a.a2()
a.a3()
c.c1()
