print("Potetium Loaded")

if _G.Cam == nil then _G.Cam = false end
if _G.Transparent == nil then _G.Transparent = true end
if _G.Gui == nil then _G.Gui = true end
if _G.Render3D == nil then _G.Render3D = true end

local a = {}
local b = {}
local c = {}
local d = {}

local p = game:GetService("Players")
local lp = p.LocalPlayer
local r = game:GetService("RunService")
local w = workspace
local bss = (game.PlaceId == 1537690962)
local col = bss and w:FindFirstChild("Collectibles")
local flw = bss and w:FindFirstChild("FlowerZones")

a.a1 = function(v)
    if not v or not v.Parent then return end
    if lp.Character and v:IsDescendantOf(lp.Character) then return end
    if bss then
        if col and v:IsDescendantOf(col) then return end
        if flw and v:IsDescendantOf(flw) then return end
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
    local e = {w, game:GetService("Lighting"), game:GetService("MaterialService")}
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
    w.DescendantAdded:Connect(function(v)
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

b.b2 = function()
    if not _G.Render3D then
        pcall(function() r:Set3dRenderingEnabled(false) end)
    end
end

c.c1 = function()
    if not _G.Cam then return end
    local cm = w.CurrentCamera
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

d.d1 = function(v)
    if v:IsA("GuiObject") then
        v.BackgroundTransparency = 1
        v.BorderSizePixel = 0
        if v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v.ImageTransparency = 1
        end
    elseif v:IsA("UIStroke") or v:IsA("UIGradient") or v:IsA("UICorner") then
        v:Destroy()
    end
end

d.d2 = function()
    if _G.Gui then return end
    local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
    if pg then
        for _, v in ipairs(pg:GetDescendants()) do d.d1(v) end
        pg.DescendantAdded:Connect(d.d1)
    end
end

b.b1()
b.b2()
a.a2()
a.a3()
c.c1()
d.d2()
