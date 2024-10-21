-- AutoFarm control at the start
local AutoFarm = {}
AutoFarm.Potet = true  -- Default to true for autofarming to be enabled initially

-- Now we can continue with the rest of the script
local Remotes = game:GetService("ReplicatedStorage").Remotes
Remotes.chooseOption:FireServer("afk", false)
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Points the character will move between, with intermediate points added for smoothness
local points = {
    CFrame.new(121, 272, 181),  -- Starting point
    CFrame.new(121, 272, 135),  -- Intermediate point 1
    CFrame.new(120, 272, 80),   -- Intermediate point 2
    CFrame.new(120, 272, 28),   -- Point 2
    CFrame.new(60, 272, 28),    -- Intermediate point 3
    CFrame.new(10, 272, 28),    -- Intermediate point 4
    CFrame.new(-34, 272, 29),   -- Point 3
    CFrame.new(-34, 272, 80),   -- Intermediate point 5
    CFrame.new(-34, 272, 135),  -- Intermediate point 6
    CFrame.new(-34, 272, 183),  -- Point 4
    CFrame.new(25, 272, 181)    -- New intermediate point between 183 and 181
}

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)

local MAXDISTANCE = 5  -- Maximum allowed distance from the target point
local TWEEN_TIMEOUT = 5  -- Timeout for the tween to finish
local FIXED_HEIGHT = 272  -- Height at which the character will move

-- Function to perform a tween to a specific position
local function tweenToPosition(cframe)
    humanoidRootPart.CanCollide = false

    -- Enforcing constant height before every tween
    local currentPos = humanoidRootPart.Position
    humanoidRootPart.CFrame = CFrame.new(currentPos.X, FIXED_HEIGHT, currentPos.Z)

    -- Adjusting the target position to always be at a fixed height
    local adjustedCFrame = CFrame.new(cframe.Position.X, FIXED_HEIGHT, cframe.Position.Z)

    -- Create and play the tween
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = adjustedCFrame})
    tween:Play()

    -- Wait for the tween to complete before continuing
    tween.Completed:Wait()

    humanoidRootPart.CanCollide = true
end

-- Main function - moves the character between points
local function walkToPoints()
    while AutoFarm.Potet do  -- Check if AutoFarm is enabled
        for _, point in ipairs(points) do
            if not AutoFarm.Potet then
                return  -- Stop if AutoFarm is disabled
            end
            tweenToPosition(point)
        end
    end
end

-- Start movement if AutoFarm is enabled
if AutoFarm.Potet then
    walkToPoints()
end
