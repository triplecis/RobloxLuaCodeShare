print('Main load')

local ok, rawVersion = pcall(function()
    return game:HttpGet('https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/version.txt')
end)
local version = ok and rawVersion:gsub('%s+', '') or 'Unknown'

--[[ Services ]]--
_Players = game:GetService("Players")
_RunService = game:GetService("RunService")
_UserInputService = game:GetService("UserInputService")
_TweenService = game:GetService("TweenService")
_HttpService = game:GetService("HttpService")
_ReplicatedStorage = game:GetService("ReplicatedStorage")
_SoundService = game:GetService("SoundService")
_PathfindingService = game:GetService("PathfindingService")
_VirtualInputManager = game:GetService("VirtualInputManager")
_ContextActionService = game:GetService("ContextActionService")

_CurrentCamera = workspace.CurrentCamera
_Player = _Players.LocalPlayer
_LocalCharacter = _Player.Character or _Player.CharacterAdded:Wait()
_LocalHumanoid = _LocalCharacter:WaitForChild("Humanoid")
_LocalRoot = _LocalCharacter:WaitForChild("HumanoidRootPart")
_Mouse = _Player:GetMouse()
_Workspace = workspace or Workspace

--[[ Executor / Game Info ]]--
local Executor = identifyexecutor and identifyexecutor() or "Unknown"
PlaceId = game.PlaceId
JobId = game.JobId
GameId = game.GameId

--[[ Linoria ]]--
_Linoria = {
    Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))(),
    ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))(),
    SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))(),
}

local _linoriaScreenGUI = _Linoria.Library.ScreenGui
_linoriaScreenGUI.Name = '◈ Silveria'

_Linoria.ThemeManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:IgnoreThemeSettings()
_Linoria.ThemeManager:SetFolder('Silveria/themes')
_Linoria.SaveManager:SetFolder('Silveria/configs')

_Window = _Linoria.Library:CreateWindow({
    Title = '◈ Silveria' .. (version ~= 'Unknown' and (' | v' .. version) or ''),
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    --Position = float (optional)
    --Size = 600
})

local GameModules = {
    [5523851880] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/8ballpoolclassic.lua', name = '8BPC' },
    [6722921118] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/colorbook.lua', name = 'Color Book' },
    [277751860] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/epicminigames.lua', name = 'EMG' },
    [16732694052] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/fisch.lua', name = 'Fisch' },
    [893973440] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/fleethefacility.lua', name = 'FTF' },
    [621129760] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/kat.lua', name = 'KAT' },
    [111163066268338] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/katOffbrand.lua', name = 'KAT2' },
    [142823291] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/murdermystery2.lua', name = 'MM2' },
    [15092647980] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/projectsmash.lua', name = 'Project Smash' },
    [12196278347] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/refinerycaves2.lua', name = 'RC2' },
    [11379739543] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/timebombduels.lua', name = 'TBD' },
    [2653064683] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/wordbomb.lua', name = 'Word Bomb' },
    [192800] = { url = 'https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/Games/workatapizzaplace.lua', name = 'WAAPP' },
}

local hasGameModule = GameModules[PlaceId] ~= nil
local gameName = hasGameModule and GameModules[PlaceId].name or 'Game'

_Tabs = {
    Home = _Window:AddTab('Main'),
    Universal = _Window:AddTab('Universal'),
    Game = hasGameModule and _Window:AddTab(gameName) or nil,
    Scripts = _Window:AddTab('Scripts'),
    Lobby = _Window:AddTab('Lobby'),
    Settings = _Window:AddTab('Settings'),
    Control = _Window:AddTab('Control'),
}

--[[ Functions ]]--
local function loadModule(url)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url .. '?t=' .. os.time()))()
    end)
    if not ok then
        warn('Failed to load: ' .. url .. '\n' .. err)
    end
end
loadModule('https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/home.lua') -- Home
loadModule('https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/universal.lua') -- Universal
loadModule('https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/scripts.lua') -- Scripts
--loadModule('https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/ranks.lua') -- Ranks
loadModule('https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/settings.lua') -- Settings
--loadModule('https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/control.lua') -- Control
loadModule('https://raw.githubusercontent.com/triplecis/Silveria/refs/heads/main/lobby.lua') -- Lobby

if hasGameModule then
    loadModule(GameModules[PlaceId].url)
else
    print('No specific module for this game, universal only.')
end