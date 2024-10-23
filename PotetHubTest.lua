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

-- Funkcja AntiAFK poruszająca postacią co 5 minut
local function antiAFK()
    while true do
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            -- Delikatny ruch postacią (zmiana pozycji o 0.1 jednostki)
            local currentPosition = Player.Character.HumanoidRootPart.Position
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPosition + Vector3.new(0.1, 0, 0))
            wait(0.1)
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPosition)  -- Powrót do pierwotnej pozycji
        end
        wait(300)  -- Odczekaj 5 minut (300 sekund)
    end
end

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
                    wait(0.1)  -- Krótkie opóźnienie
                end
            end
        end
        wait(0.1)  -- Krótkie opóźnienie między teleportacjami
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
        wait(0.1)  -- Krótkie opóźnienie

        -- Loop through the defined positions for tweening
        for _, pos in ipairs(positions) do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                tween = createTween(Player.Character.HumanoidRootPart, pos)
                tween:Play()
                tween.Completed:Wait()  -- Czekaj, aż tween się zakończy

                if getgenv().autofarm then
                    teleportToParts()  -- Teleportacja po tweeningu
                end
                wait(0.1)  -- Krótkie opóźnienie między tweenami
            end
        end
        wait(0.2)  -- Długie opóźnienie na powtórzenie pętli
    end
end

-- Uruchomienie AntiAFK w oddzielnym wątku
spawn(antiAFK)

if getgenv().autofarm then
    loopTween()
end
