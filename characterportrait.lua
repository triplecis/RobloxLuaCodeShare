--[[ Character Portrait ]]--
local function createPortrait()
    local linoriaGui = game.CoreGui:FindFirstChild("LinoriaLib") 

    if not linoriaGui then return end

    local portrait = Instance.new("ViewportFrame")
    portrait.Size = UDim2.new(0, 100, 0, 100)
    portrait.Position = UDim2.new(0, 10, 0, 10)
    portrait.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    portrait.BorderSizePixel = 0
    portrait.Name = "CharacterPortrait"
    portrait.Parent = linoriaGui

    -- Round corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = portrait

    -- Border
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Parent = portrait

    -- Clone character into viewport
    local function updateCharacter()
        portrait:ClearAllChildren()
        corner.Parent = portrait
        stroke.Parent = portrait

        if not _LocalCharacter then return end

        local clone = _LocalCharacter:Clone()
        -- Remove scripts from clone
        for _, v in pairs(clone:GetDescendants()) do
            if v:IsA("Script") or v:IsA("LocalScript") then
                v:Destroy()
            end
        end
        clone.Parent = portrait

        -- Camera for viewport
        local camera = Instance.new("Camera")
        camera.Parent = portrait
        portrait.CurrentCamera = camera

        local hrp = clone:FindFirstChild("HumanoidRootPart")
        if hrp then
            camera.CFrame = CFrame.new(
                hrp.Position + Vector3.new(0, 1, 4),
                hrp.Position + Vector3.new(0, 1, 0)
            )
        end

        -- Animate to face forward
        local humanoid = clone:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    end

    updateCharacter()

    -- Update portrait when character respawns
    _Player.CharacterAdded:Connect(function()
        task.wait(1)
        updateCharacter()
    end)

    -- Rotate character slowly
    local angle = 0
    _RunService.RenderStepped:Connect(function()
        if not portrait.CurrentCamera then return end
        local hrp = portrait:FindFirstChild(_LocalCharacter and "HumanoidRootPart" or "", true)
        if hrp then
            angle = angle + 0.5
            local dist = 4
            portrait.CurrentCamera.CFrame = CFrame.new(
                hrp.Position + Vector3.new(math.sin(math.rad(angle)) * dist, 1, math.cos(math.rad(angle)) * dist),
                hrp.Position + Vector3.new(0, 1, 0)
            )
        end
    end)
end

-- Add to main tab
local MainPortrait = _Tabs.Main:AddLeftGroupbox('Character')
MainPortrait:AddLabel('') -- spacer for portrait height

task.delay(1, createPortrait)