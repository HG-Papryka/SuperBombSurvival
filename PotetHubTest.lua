getgenv().autofarm = getgenv().autofarm or true
getgenv().collect_HalloweenCandy = getgenv().collect_HalloweenCandy or false
getgenv().collect_EventIcon = getgenv().collect_EventIcon or false
getgenv().collect_Coins = getgenv().collect_Coins or false
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

local fixedYPosition = 272  -- Stała wysokość, np. 272

-- Funkcja AntiAFK poruszająca postacią co 5 minut
local function antiAFK()
    while true do
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local currentPosition = Player.Character.HumanoidRootPart.Position
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPosition + Vector3.new(0.1, 0, 0))
            wait(0.1)
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPosition)
        end
        wait(300) -- 5 minut
    end
end

local function createTween(part, goalPosition)
    -- Ustawiamy stałą wysokość Y na fixedYPosition
    local newGoalPosition = CFrame.new(goalPosition.X, fixedYPosition, goalPosition.Z)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local goal = {CFrame = newGoalPosition}
    return TweenService:Create(part, tweenInfo, goal)
end

-- Funkcja teleportacji z opóźnieniem
local function teleportToParts()
    for _, part in ipairs(workspace.Bombs:GetChildren()) do
        if table.find(targetNames, part.Name) then
            if (part.Name == "HalloweenCandy" and getgenv().collect_HalloweenCandy) or
               (part.Name == "EventIcon" and getgenv().collect_EventIcon) or
               ((part.Name == "Coin_copper" or part.Name == "Coin_silver") and getgenv().collect_Coins) or
               (part.Name == "HeartPickup" and getgenv().collect_HeartPickup) then

                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    print("Teleporting to: " .. part.Name)
                    local newCFrame = CFrame.new(part.Position.X, fixedYPosition, part.Position.Z)
                    Player.Character.HumanoidRootPart.CFrame = newCFrame  -- Utrzymujemy stałą wysokość
                    wait(0.1)  -- Opóźnienie przy teleportacji
                end
            end
        end
    end
end

local function loopTween()
    local positions = {
        CFrame.new(121, fixedYPosition, 181),
        CFrame.new(120, fixedYPosition, 28),
        CFrame.new(-34, fixedYPosition, 29),
        CFrame.new(-34, fixedYPosition, 183)
    }

    while true do
        if isPaused then
            while isPaused do wait() end
        end

        Remotes.chooseOption:FireServer("afk", false)
        
        -- Tweenowanie pozycji bez przerwy
        for _, pos in ipairs(positions) do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                tween = createTween(Player.Character.HumanoidRootPart, pos)
                tween:Play()
                tween.Completed:Wait()  -- Czekaj na zakończenie tweena

                if getgenv().autofarm then
                    teleportToParts()  -- Teleportacja z opóźnieniem
                end
            end
        end
        wait(0.09)  -- Krótkie opóźnienie po tweeningu
    end
end

-- Uruchomienie AntiAFK w oddzielnym wątku
spawn(antiAFK)

if getgenv().autofarm then
    loopTween()
end
