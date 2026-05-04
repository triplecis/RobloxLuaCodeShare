--[[ Groupboxes ]]--
local HomeGroupbox = _Tabs.Home:AddLeftGroupbox('Home')
local InGameGroupbox = _Tabs.Home:AddLeftGroupbox('Games')

--[[ Functions ]]--
local function cleanGameName(name)
    -- Remove common tags like [UPD], [NEW], [BETA], (UPD), etc
    name = name:gsub('%[.-%]', '')   -- removes anything in [brackets]
    name = name:gsub('%(.-%)', '')   -- removes anything in (parentheses)
    name = name:gsub('%❗.-%❗', '') -- removes emoji wrapped text
    name = name:gsub('^%s+', '')     -- trim leading spaces
    name = name:gsub('%s+$', '')     -- trim trailing spaces
    name = name:gsub('%s+', ' ')     -- collapse multiple spaces

    -- Truncate to 12 chars if still too long
    if #name > 12 then
        name = name:sub(1, 12):match('(.-)%s*$') -- trim trailing space after cut
    end

    return name ~= '' and name or 'Game'
end

local gameName = cleanGameName(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

HomeGroupbox:AddLabel('Welcome to Silveria, ' .. _Player.Name .. '!')
InGameGroupbox:AddLabel('Current game: ' .. gameName)

game:GetService('Players').PlayerAdded:Connect(function(player)
    InGameGroupbox:AddLabel(player.Name .. ' has joined the game!')
end)
game:getService('Players').PlayerRemoving:Connect(function(player)
    InGameGroupbox:AddLabel(player.Name .. ' has left the game!')
end)