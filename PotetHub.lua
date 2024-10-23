getgenv().autofarm = getgenv().autofarm or true
getgenv().collect_HalloweenCandy = getgenv().collect_HalloweenCandy or true
getgenv().collect_EventIcon = getgenv().collect_EventIcon or true
getgenv().collect_Coins = getgenv().collect_Coins or true
getgenv().collect_HeartPickup = getgenv().collect_HeartPickup or true

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
    for _, part in ipairs(workspace.Bombs:GetChildren()) do
        if table.find(targetNames, part.Name) then
            if (part.Name == "HalloweenCandy" and getgenv().collect_HalloweenCandy) or
               (part.Name == "EventIcon" and getgenv().collect_EventIcon) or
               ((part.Name == "Coin_copper" or part.Name == "Coin_silver") and getgenv().collect_Coins) or
               (part.Name == "HeartPickup" and getgenv().collect_HeartPickup) then

                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    print("Teleporting to: " .. part.Name)  -- Debugging line to verify teleport
                    Player.Character.HumanoidRootPart.CFrame = part.CFrame
                    wait(0.5)  -- Slight delay increased to ensure teleportation happens before next action
                end
            end
        end
        wait(0.2)  -- Add delay between teleports to avoid game overload
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
        wait(0.3)  -- Delay to prevent server overload

        -- Loop through the defined positions for tweening
        for _, pos in ipairs(positions) do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                tween = createTween(Player.Character.HumanoidRootPart, pos)
                tween:Play()
                tween.Completed:Wait()  -- Wait for the tween to complete before moving to the next position

                if getgenv().autofarm then
                    teleportToParts()  -- Teleport after tweening to the new position
                end
                wait(0.5)  -- Delay between tweens to reduce stress on the game
            end
        end
        wait(1)  -- Overall loop delay to further avoid performance issues
    end
end

if getgenv().autofarm then
    loopTween()
end
