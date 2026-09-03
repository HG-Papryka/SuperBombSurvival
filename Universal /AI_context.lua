print("WeLovePotet")

local StarterGui = game:GetService("StarterGui")

local a = {}
local b = {}
local c = {}

a.a1 = {
    services = {
        "Workspace",
        "ReplicatedStorage",
        "ServerScriptService",
        "ServerStorage",
        "StarterGui",
        "StarterPlayer",
        "Lighting",
        "SoundService",
        "MaterialService"
    },
    ignoredNames = {
        Chat = true,
        TextChatService = true,
        CoreGui = true
    },
    ignoredClasses = {
        Camera = true,
        Terrain = true,
        Players = true,
        NetworkClient = true,
        CorePackages = true,
        HttpService = true,
        TestService = true,
        VoiceChatService = true,
        LocalizationService = true
    },
    meshClasses = {
        "SpecialMesh",
        "BlockMesh",
        "CylinderMesh"
    },
    visualClasses = {
        "Decal",
        "Texture",
        "SurfaceAppearance"
    },
    fmt = {
        service = "▼ ",
        branch = "├─► ",
        last = "└─► ",
        vertical = "│   ",
        space = "    "
    }
}

a.a2 = function(inst)
    return a.a1.ignoredNames[inst.Name] == true or a.a1.ignoredClasses[inst.ClassName] == true
end

a.a3 = function(inst)
    local className = inst.ClassName
    if inst:IsA("SpecialMesh") then
        return className .. " | " .. inst.MeshType.Name
    end
    if inst:IsA("BasePart") then
        local hasMesh = false
        for _, meshClass in ipairs(a.a1.meshClasses) do
            if inst:FindFirstChildOfClass(meshClass) then
                hasMesh = true
                break
            end
        end
        
        local hasVisual = false
        for _, visClass in ipairs(a.a1.visualClasses) do
            if inst:FindFirstChildOfClass(visClass) then
                hasVisual = true
                break
            end
        end

        if hasMesh and hasVisual then
            return className .. " + Mesh + Texture"
        elseif hasMesh then
            return className .. " + Mesh"
        elseif hasVisual then
            return className .. " + Texture"
        end
    end
    return className
end

c.c1 = function(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2
        })
    end)
end

b.b1 = function(inst, indent, buffer)
    indent = indent or ""
    local validChildren = {}
    
    for _, child in ipairs(inst:GetChildren()) do
        if not a.a2(child) then
            table.insert(validChildren, child)
        end
    end

    local nodeCount = 0
    local total = #validChildren

    for i, child in ipairs(validChildren) do
        local isLast = (i == total)
        local pointer = isLast and a.a1.fmt.last or a.a1.fmt.branch
        local nextIndent = indent .. (isLast and a.a1.fmt.space or a.a1.fmt.vertical)

        local detail = a.a3(child)
        table.insert(buffer, indent .. pointer .. child.Name .. " (" .. detail .. ")")
        nodeCount = nodeCount + 1 + b.b1(child, nextIndent, buffer)
    end

    return nodeCount
end

b.b2 = function()
    local buffer = {}

    for _, serviceName in ipairs(a.a1.services) do
        local service = game:GetService(serviceName)
        local headerIndex = #buffer + 1
        
        table.insert(buffer, a.a1.fmt.service .. service.Name)
        local count = b.b1(service, "", buffer)

        if count == 0 then
            table.remove(buffer, headerIndex)
        else
            table.insert(buffer, "")
        end
    end

    local result = table.concat(buffer, "\n")

    if setclipboard then
        setclipboard(result)
        c.c1("Potetium", "Copied!")
    else
        print(result)
        c.c1("Potetium", "Whoops!")
    end
end

b.b2()
