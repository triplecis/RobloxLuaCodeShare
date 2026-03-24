local ReplicatedMaps = _ReplicatedStorage:WaitForChild('Maps')
local currentMap = nil

local function onMapLoaded(mapName)
    print('Map loaded: ' .. mapName)
    -- your map specific code here
end

local function onMapUnloaded(mapName)
    print('Map unloaded: ' .. mapName)
    -- cleanup code here
end

local function checkWorkspaceForMap()
    for _, map in pairs(ReplicatedMaps:GetChildren()) do
        if workspace:FindFirstChild(map.Name) then
            return workspace:FindFirstChild(map.Name)
        end
    end
    return nil
end

workspace.ChildAdded:Connect(function(child)
    if ReplicatedMaps:FindFirstChild(child.Name) then
        currentMap = child
        onMapLoaded(child.Name)

        child.AncestryChanged:Connect(function()
            if not child:IsDescendantOf(workspace) then
                onMapUnloaded(child.Name)
                currentMap = nil
            end
        end)
    end
end)

local existingMap = checkWorkspaceForMap()
if existingMap then
    currentMap = existingMap
    onMapLoaded(existingMap.Name)

    existingMap.AncestryChanged:Connect(function()
        if not existingMap:IsDescendantOf(workspace) then
            onMapUnloaded(existingMap.Name)
            currentMap = nil
        end
    end)
end

local function paintAll()
    if not currentMap then
        warn('No map loaded')
        return
    end

    for _, obj in pairs(currentMap:GetDescendants()) do
        -- Skip non-paintable instances
        if not obj:IsA("BasePart") then continue end
        if not obj:FindFirstChildOfClass("SelectionBox") then continue end

        -- Get the center of the part on screen
        local screenPos, onScreen = _CurrentCamera:WorldToViewportPoint(obj.Position)
        if not onScreen then
            -- Temporarily move camera focus or just fire without screen pos
            _VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)
        end

        -- Simulate left click on the part
        local success = pcall(function()
            _VirtualInputManager:SendMouseButtonEvent(
                screenPos.X,
                screenPos.Y,
                0,      -- 0 = left mouse button
                true,   -- true = pressed
                game,
                0
            )
            task.wait(0.05)
            _VirtualInputManager:SendMouseButtonEvent(
                screenPos.X,
                screenPos.Y,
                0,
                false,  -- false = released
                game,
                0
            )
        end)

        task.wait(0.05) -- small delay between clicks
    end
end

--[[ Linoria ]]--
local LeftGroup = _Tabs.Game:AddLeftGroupbox('Color Book')
local RightGroupAF = _Tabs.Game:AddRightGroupbox('Autofarm')

--[[ Linoria UI]]
LeftGroup:AddLabel('No real game specific features yet, check back later!')
LeftGroup:AddButton('Paint All', function()
    paintAll()
end)

RightGroupAF:AddLabel('No game specific features yet, check back later!') -- Goes through all maps in the game and paints all unpainted tiles.
RightGroupAF:AddToggle('AutofarmToggle', {
    Text = 'Autofarm',
    Default = false,
    Tooltip = 'Automatically paints all unpainted tiles in the game',
    Callback = function(state)
        print('Autofarm toggled: ' .. tostring(state))
    end
})