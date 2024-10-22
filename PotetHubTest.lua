-- Ensure global variables exist, but do not overwrite false values
getgenv().autofarm = getgenv().autofarm or true
getgenv().collectHalloweenCandy = getgenv().collectHalloweenCandy or true
getgenv().collect_EventIcon = getgenv().collect_EventIcon or true
getgenv().collect_HeartPickup = getgenv().collect_HeartPickup or true



-- Main functionality
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local isPaused = false
local tween
local Remotes = game:GetService("ReplicatedStorage").Remotes
local targetNames = {
    "Coin_copper",      -- Copper coins
    "Coin_silver",      -- Silver coins
    "Coin_gold",        -- Golden coins
    "Coin_red",         -- Red coins
    "Coin_purple",      -- Purple coins
    "EventIcon",
    "HalloweenCandy",
    "HeartPickup"
}

-- Define the area for collecting coins
local function isInCollectionArea(position)
    local minX = math.min(121, 120, -34, -34)
    local maxX = math.max(121, 120, -34, -34)
    local minZ = math.min(181, 28, 29, 183)
    local maxZ = math.max(181, 28, 29, 183)

    return position.X >= minX and position.X <= maxX and position.Z >= minZ and position.Z <= maxZ
end

-- Check if the EventIcon is on the ground
local function isEventIconOnGround(eventIcon)
    local groundHeight = 5 -- Define the height above ground
    return eventIcon.Position.Y <= groundHeight
end

local function createTween(part, goalPosition)
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local goal = {CFrame = goalPosition}
    return TweenService:Create(part, tweenInfo, goal)
end

local function teleportToParts()
    for _, part in ipairs(workspace.Bombs:GetChildren()) do
        if part and part.Parent and table.find(targetNames, part.Name) then
            -- Collect coins only if in the defined area
            if (part.Name == "HalloweenCandy" and getgenv().collectHalloweenCandy) or
               (part.Name == "HeartPickup" and getgenv().collect_HeartPickup) or
               (getgenv().collect_Coins and (part.Name == "Coin_copper" or 
                                              part.Name == "Coin_silver" or 
                                              part.Name == "Coin_gold" or 
                                              part.Name == "Coin_red" or 
                                              part.Name == "Coin_purple") and 
                isInCollectionArea(part.Position) ) or
               (part.Name == "EventIcon" and getgenv().collect_EventIcon and 
                isEventIconOnGround(part)) then

                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    print("Teleporting to: " .. part.Name)
                    Player.Character.HumanoidRootPart.CFrame = part.CFrame
                    wait(0.5)
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

        for _, pos in ipairs(positions) do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                tween = createTween(Player.Character.HumanoidRootPart, pos)
                tween:Play()
                tween.Completed:Wait()

                if getgenv().autofarm then
                    teleportToParts()
                end
            end
            wait(0.1)
        end
    end
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

if getgenv().autofarm then
    loopTween()
end

