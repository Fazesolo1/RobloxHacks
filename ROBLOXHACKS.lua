-- Create the GUI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame behind buttons
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(0, 220, 0, 300)
buttonFrame.Position = UDim2.new(0, 10, 0.5, -195) -- Centering the frame
buttonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
buttonFrame.BackgroundTransparency = 0.3
buttonFrame.BorderSizePixel = 0
buttonFrame.Parent = screenGui

-- Highlight & Show Distance button
local combinedButton = Instance.new("TextButton")
combinedButton.Size = UDim2.new(0, 200, 0, 50)
combinedButton.Position = UDim2.new(0, 10, 0, 10) -- Positioning inside the frame
combinedButton.Text = "Highlight & Show Distance"
combinedButton.BackgroundColor3 = Color3.fromRGB(169, 169, 169)
combinedButton.TextColor3 = Color3.fromRGB(0, 0, 0)
combinedButton.Parent = buttonFrame

-- Infinite Jump button
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0, 200, 0, 50)
jumpButton.Position = UDim2.new(0, 10, 0, 70) -- Positioning inside the frame
jumpButton.Text = "Infinite Jump"
jumpButton.BackgroundColor3 = Color3.fromRGB(211, 211, 211)
jumpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
jumpButton.Parent = buttonFrame

-- Invisible button
local invisibleButton = Instance.new("TextButton")
invisibleButton.Size = UDim2.new(0, 200, 0, 50)
invisibleButton.Position = UDim2.new(0, 10, 0, 130) -- Positioning inside the frame
invisibleButton.Text = "Invisible"
invisibleButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
invisibleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibleButton.Parent = buttonFrame

-- Walk Through Walls button
local walkThroughWallsButton = Instance.new("TextButton")
walkThroughWallsButton.Size = UDim2.new(0, 200, 0, 50)
walkThroughWallsButton.Position = UDim2.new(0, 10, 0, 190) -- Positioning inside the frame
walkThroughWallsButton.Text = "Walk Through Walls"
walkThroughWallsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
walkThroughWallsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
walkThroughWallsButton.Parent = buttonFrame

-- Fly button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 200, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0, 250) -- Positioning inside the frame
flyButton.Text = "Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Parent = buttonFrame

local highlighted = false
local beams = {}
local distanceLabels = {}
local isShowingDistances = false
local isInfiniteJumpEnabled = false
local isInvisible = false
local canWalkThroughWalls = false
local isFlying = false
local mouse = game.Players.LocalPlayer:GetMouse()

-- Function to toggle highlighting and distances
local function toggleHighlightAndDistances()
    -- Clear previous beams and labels
    for _, beam in pairs(beams) do
        beam:Destroy()
    end
    beams = {}
    for _, label in pairs(distanceLabels) do
        label:Destroy()
    end
    distanceLabels = {}

    -- Toggle highlighting and distances
    for _, player in pairs(game.Players:GetPlayers()) do
        local character = player.Character
        if character then
            -- Highlight players
            if highlighted then
                local highlight = character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            else
                local highlight = Instance.new("Highlight")
                highlight.Adornee = character
                highlight.Parent = character
            end

            -- Show distances
            if character:FindFirstChild("HumanoidRootPart") then
                -- Create and configure a beam
                local attachment0 = Instance.new("Attachment", game.Players.LocalPlayer.Character.HumanoidRootPart)
                local attachment1 = Instance.new("Attachment", character.HumanoidRootPart)
                local beam = Instance.new("Beam")
                beam.Attachment0 = attachment0
                beam.Attachment1 = attachment1
                beam.FaceCamera = true
                beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                beam.Width0 = 0.1
                beam.Width1 = 0.1
                beam.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
                table.insert(beams, beam)

                -- Create a BillboardGui for the distance
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Size = UDim2.new(0, 200, 0, 50)
                billboardGui.StudsOffset = Vector3.new(0, 3, 0)
                billboardGui.AlwaysOnTop = true
                billboardGui.Parent = character:FindFirstChild("HumanoidRootPart")

                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Size = UDim2.new(1, 0, 1, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                distanceLabel.TextStrokeTransparency = 0
                distanceLabel.Parent = billboardGui
                table.insert(distanceLabels, distanceLabel)
            end
        end
    end

    highlighted = not highlighted
    isShowingDistances = not isShowingDistances

    if isShowingDistances then
        coroutine.wrap(function()
            while isShowingDistances do
                local localPlayer = game.Players.LocalPlayer
                local localCharacter = localPlayer.Character
                local localPosition = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and localCharacter.HumanoidRootPart.Position

                if localPosition then
                    for i, player in pairs(game.Players:GetPlayers()) do
                        local character = player.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local distance = (character.HumanoidRootPart.Position - localPosition).magnitude
                            distanceLabels[i].Text = string.format("%.2f", distance) .. " studs"
                        end
                    end
                end
                wait(0.1)
            end
        end)()
    end

    combinedButton.Text = highlighted and "Unhighlight & Hide Distance" or "Highlight & Show Distance"
end

-- Function to enable infinite jump
local function toggleInfiniteJump()
    if isInfiniteJumpEnabled then
        isInfiniteJumpEnabled = false
        jumpButton.Text = "Infinite Jump"
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
        end
    else
        isInfiniteJumpEnabled = true
        jumpButton.Text = "Disable Infinite Jump"
        infiniteJumpConnection = mouse.KeyDown:Connect(function(key)
            if key == " " then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Function to toggle invisibility
local function toggleInvisibility()
    local character = game.Players.LocalPlayer.Character
    if isInvisible then
        isInvisible = false
        invisibleButton.Text = "Invisible"
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 0
            end
        end
    else
        isInvisible = true
        invisibleButton.Text = "Visible"
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            end
        end
    end
end

-- Function to enable walking through walls
local function toggleWalkThroughWalls()
    if canWalkThroughWalls then
        canWalkThroughWalls = false
        walkThroughWallsButton.Text = "Walk Through Walls"
        local character = game.Players.LocalPlayer.Character
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    else
        canWalkThroughWalls = true
        walkThroughWallsButton.Text = "Disable Walk Through Walls"
        local character = game.Players.LocalPlayer.Character
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
