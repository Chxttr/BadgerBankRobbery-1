-------------------------
--- BadgerBankRobbery ---
-------------------------
--- Server ---
robberyActive = false
-- Config
prefix = '^5[^10-99^5] ^3';
roleList = {
    ['Police'] = 1, -- Change 1 with your Discord role ID
}

--- CODE ---
function sendMsg(src, msg)
    TriggerClientEvent('chat:addMessage', src, {
        args = { prefix .. msg }
    })
end

isCop = {}
AddEventHandler('playerDropped', function (reason) 
  -- Clear their lists 
  local src = source;
  isCop[src] = nil;
end)

RegisterNetEvent('BadgerBankRobbery:CheckPerms')
AddEventHandler('BadgerBankRobbery:CheckPerms', function()
    local src = source;
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end
    -- TriggerClientEvent("FaxDisVeh:CheckPermission:Return", src, true, false)
    if identifierDiscord then
        local roles = exports.discord_perms:GetRoles(src)
        if not (roles == false) then
            for i = 1, #roles do
                for roleName, roleID in pairs(roleList) do
                    if tonumber(roles[i]) == tonumber(roleID) then
                        -- Return the index back to the Client script
                        isCop[tonumber(src)] = true;
                        print(GetPlayerName(src) .. " received BadgerBankRobbery permissions SUCCESS")
                    end
                end
            end
        else
            print(GetPlayerName(src) .. " did not receive BadgerBankRobbery permissions because roles == false")
        end
    elseif identifierDiscord == nil then
        print("identifierDiscord == nil")
    end
end)

locationTracker = {}
idCounter = 0;
function mod(a, b)
    return a - (math.floor(a/b)*b)
end

RegisterNetEvent('BadgerBankRobbery:bankrobberyalert')
AddEventHandler('BadgerBankRobbery:bankrobberyalert', function()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(source)));
    for _, id in ipairs(GetPlayers()) do 
        if isCop[tonumber(id)] ~= nil and isCop[tonumber(id)] == true then 
            -- They are a cop, send them it 
            TriggerClientEvent('BadgerBankRobbery:bankblipalert', source)
        end
    end
end)

RegisterNetEvent('BadgerBankRobbery:IsActive')
AddEventHandler('BadgerBankRobbery:IsActive', function()
	-- Check if active or not
	if robberyActive then
		-- One is active
		TriggerClientEvent('BadgerBankRobbery:IsActive:Return', source, true)
	else
		-- One is not active
		TriggerClientEvent('BadgerBankRobbery:IsActive:Return', source, false)
	end
end)

RegisterNetEvent('BadgerBankRobbery:SetActive')
AddEventHandler('BadgerBankRobbery:SetActive', function(bool)
	robberyActive = bool
	if bool then
		Wait((1000 * 60 * config.robberyCooldown)) -- Wait 15 minutes
		robberyActive = false
	end
end)

RegisterNetEvent('Print:PrintDebug')
AddEventHandler('Print:PrintDebug', function(msg)
	print(msg)
	TriggerClientEvent('chatMessage', -1, "^7[^1Badger's Scripts^7] ^1DEBUG ^7" .. msg)
end)
RegisterNetEvent('PrintBR:PrintMessage')
AddEventHandler('PrintBR:PrintMessage', function(msg)
	TriggerClientEvent('chatMessage', -1, msg)
end)
