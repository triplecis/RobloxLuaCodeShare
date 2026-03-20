print('Settings module loaded')

--[[ Setup ]]--
_Linoria.ThemeManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:IgnoreThemeSettings()
_Linoria.ThemeManager:SetFolder('SMILE/themes')
_Linoria.SaveManager:SetFolder('SMILE/configs')

--[[ Groupboxes ]]--
local SettingsMenu    = _Tabs.Settings:AddLeftGroupbox('Menu')
local SettingsThemes  = _Tabs.Settings:AddRightGroupbox('Themes')
local SettingsConfigs = _Tabs.Settings:AddRightGroupbox('Configs')
local SettingsDiscord = _Tabs.Settings:AddLeftGroupbox('Discord')

--[[ Menu ]]--
SettingsMenu:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightControl",
    NoUI = true,
    Text = "Toggle UI",
    Callback = function()
        _Linoria.Library.ToggleKeybind = Options.MenuKeybind.Value
    end
})

SettingsMenu:AddButton('Close UI', function()
    _Linoria.Library:Unload()
end)

--[[ Themes and Configs ]]--
_Linoria.ThemeManager:BuildThemeSection(SettingsThemes)
_Linoria.SaveManager:BuildConfigSection(SettingsConfigs)

--[[ Discord ]]--
SettingsDiscord:AddButton("Copy Discord", function()
    setclipboard("discord.gg/yPeD8tx2Vq")
end)