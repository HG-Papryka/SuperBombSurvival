local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local isPaused = false
local tween
local Remotes = game:GetService("ReplicatedStorage").Remotes

local defaultSettings = {
    autofarm = true,
    collect_HalloweenCandy = false,
    collect_EventIcon = true,
    collect_Coins = true,
    collect_HeartPickup = true
}

getgenv().autofarm = getgenv().autofarm or defaultSettings.autofarm
getgenv().collect_HalloweenCandy = getgenv().collect_HalloweenCandy or defaultSettings.collect_HalloweenCandy
getgenv().collect_EventIcon = getgenv().collect_EventIcon or defaultSettings.collect_EventIcon
getgenv().collect_Coins = getgenv().collect_Coins or defaultSettings.collect_Coins
getgenv().collect_HeartPickup = getgenv().collect_HeartPickup or defaultSettings.collect_HeartPickup

local targetNames = {
    "Coin_copper",
    "Coin_silver",
    "Coin_gold",
    "Coin_red",
    "Coin_purple",
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
               (part.Name == "HeartPickup" and getgenv().collect_HeartPickup) or
               (string.match(part.Name, "Coin_") and getgenv().collect_Coins) then

                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = part.CFrame
                    task.wait(0.2)
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
            while isPaused do task.wait() end
        end

        Remotes.chooseOption:FireServer("afk", false)

        for _, pos in ipairs(positions) do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                tween = createTween(Player.Character.HumanoidRootPart, pos)
                tween:Play()
                tween.Completed:Wait()

                if getgenv().autofarm then
                    teleportToParts()
                    task.wait(0.5)
                end
            end
        end
        task.wait(1)
    end
end

if getgenv().autofarm == true then
    loopTween()
end
