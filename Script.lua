-- Check if global variables already exist; if not, set default values
getgenv().autofarm = getgenv().autofarm or true
getgenv().collectHalloweenCandy = getgenv().collectHalloweenCandy or true
getgenv().collect_EventIcon = getgenv().collect_EventIcon or true
getgenv().collect_Coin = getgenv().collect_Coin or true
getgenv().collect_HeartPickup = getgenv().collect_HeartPickup or true

-- Main functionality
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local isPaused = false
local tween
local Remotes = game:GetService("ReplicatedStorage").Remotes
local targetNames = {
    "Coin_copper",
    "Coin_silver",
    "EventIcon",
    "HalloweenCandy",
    "HeartPickup"
}

local function createTween(part, goalPosition)
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local goal = {CFrame = goalPosition}
    return TweenService:Create(part, tweenInfo, goal)
end

local function teleportToParts()
    for _, part in ipairs(workspace.Bombs:GetChildren()) do  -- Added missing _
        if part and part.Parent and table.find(targetNames, part.Name) then
            if (part.Name == "HalloweenCandy" and getgenv().collectHalloweenCandy) or
               (part.Name == "EventIcon" and getgenv().collect_EventIcon) or
               (part.Name == "Coin_copper" and getgenv().collect_Coin) or
               (part.Name == "HeartPickup" and getgenv().collect_HeartPickup) then

                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    print("Teleporting to: " .. part.Name)  -- Debugging line
                    Player.Character.HumanoidRootPart.CFrame = part.CFrame
                    wait(0.5)  -- Increased delay to prevent crashes
                end
            end
        end
    end
end

local function loopTween()
    local positions = {
        CFrame.new(121, 272, 181),
        CFrame.new(120, 272, 28),
        CFrame.new(-34, 272, 29),
        CFrame.new(-34, 272, 183)
    }

    while true do
        if isPaused then
            while isPaused do wait() end
        end

        Remotes.chooseOption:FireServer("afk", false)

        -- Loop through defined positions for tweening
        for _, pos in ipairs(positions) do  -- Added missing _
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                tween = createTween(Player.Character.HumanoidRootPart, pos)
                tween:Play()
                tween.Completed:Wait()  -- Wait for tween to complete before moving to the next position

                if getgenv().autofarm then
                    teleportToParts()  -- Teleport after tweening to the new position
                end
            end
            wait(0.1)  -- Short delay to give the game some breathing room
        end
    end
end

if getgenv().autofarm then
    loopTween()
end

-- Anti-AFK
while true do
    wait(300)  -- Waits 300 seconds (5 minutes)
    local player = game.Players.LocalPlayer
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid:Move(Vector3.new(0, 0, 1))  -- Moves forward
        wait(1)  -- Short delay between movements
        humanoid:Move(Vector3.new(0, 0, -1))  -- Moves backward
    end
end
