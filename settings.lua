print('Settings module loaded')

print(type(_Linoria.ThemeManager))
print(_Linoria.ThemeManager)

for k, v in pairs(_Linoria.ThemeManager) do
    print(k, v)
end


--[[ Groupboxes ]]--
local SettingsMenu    = _Tabs.Settings:AddLeftGroupbox('Menu')
local SettingsDiscord = _Tabs.Settings:AddLeftGroupbox('Discord')

--[[ Menu ]]--
SettingsMenu:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightControl",
    NoUI = true,
    Text = "Toggle UI",
})

SettingsMenu:AddButton('Close UI', function()
    _Linoria.Library:Unload()
end)

--[[ Discord ]]--
SettingsDiscord:AddButton("Copy Discord", function()
    setclipboard("discord.gg/yPeD8tx2Vq")
end)

--[[ Themes and Configs ]]--
_Linoria.ThemeManager:ApplyToGroupbox(_Tabs.Settings:AddRightGroupbox('Themes'))
_Linoria.SaveManager:BuildConfigSection(_Tabs.Settings:AddRightGroupbox('Configs'))

_Linoria.Library.ToggleKeybind = Options.MenuKeybind