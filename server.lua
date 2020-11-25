local oldPrint = print
print = function(trash)
	oldPrint('^7[^2Kyk-WarnSystem^7] '..trash..'^0')
end

--[[
    Warns the player
]]
RegisterCommand("warn", function(source, args, rawCommand)
    local warnReason = table.concat(args, " ",2)
    local target = tonumber(args[1])
    local steam

    for k,v in ipairs(GetPlayerIdentifiers(target)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            steam = v
        end
    end

    if target == nil then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'error', text = 'Invalid Target!' })
        else
            print('^7[^1Error^7] ^1Invalid Target.^7')

        end
    elseif (GetPlayerPing(target) == 0) then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'error', text = 'Invalid Target!' })
        else
            print('^7[^1Error^7] ^1Invalid Target.^7')
        end
    else
        if source ~= 0 then
            if (warnReason == "") then warnReason = "No Reason Specified" end
            MySQL.Async.execute("INSERT INTO user_warnings (source, target, reason, date) VALUES (@source,@target,@reason,@date)", {
                ['@source'] = GetPlayerName(source),
                ['@target'] = steam, 
                ['@reason'] = warnReason,
                ['@date'] = os.date('%d.%m.%Y')
            })
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "^1"..GetPlayerName(target).." ^7has been warned." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'success', text = GetPlayerName(target)..' has been warned.' })
    
            TriggerClientEvent('chat:addMessage', target, { args = { '^7[^3Warning^7]^2', "You have been warned by: ^1"..GetPlayerName(source).." ^7For: ^1"..warnReason }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', target, { type = 'warning', text = 'You have been warned by: '..GetPlayerName(source)..' For: '..warnReason })
            if Config.warnsToDiscord then
                sendToDiscord('New Warning','***Target:*** '..GetPlayerName(target)..'\n***Warned By:*** '..GetPlayerName(source)..'\n***Reason:*** '..warnReason)
            end
        else
            if (warnReason == "") then warnReason = "No Reason Specified" end
            MySQL.Async.execute("INSERT INTO user_warnings (source, target, reason, date) VALUES (@source,@target,@reason,@date)", {
                ['@source'] = 'Console',
                ['@target'] = steam, 
                ['@reason'] = warnReason,
                ['@date'] = os.date('%d.%m.%Y')
            })
            print('^7[^2Success^7]^1'..GetPlayerName(target)..' ^7has been warned.')

            TriggerClientEvent('chat:addMessage', target, { args = { '^7[^3Warning^7]^2', "You have been warned by: ^1Console ^7For: ^1"..warnReason }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', target, { type = 'warning', text = 'You have been warned by: Console For: '..warnReason })
            if Config.warnsToDiscord then
                sendToDiscord('New Warning','***Target: ***'..GetPlayerName(target)..'\n***Warned By:*** Console\n***Reason:*** '..warnReason)
            end
        end
    end
    
end, true)

--[[
    Show all the warns that the player has
]]
RegisterCommand("warns", function(source, args, rawCommand)
    local totalWarns = 0
    local target = tonumber(args[1])
    local steam
    local wonke = {} --[[ Do not ask why i decided to call it wonke cus i have absolutely no idea]]

    if (args[1] == nil) then target = source end
    for k,v in ipairs(GetPlayerIdentifiers(target)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            steam = v
        end
    end

    if target == nil then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'error', text = 'Invalid Target!' })
        else
            print('^7[^1Error^7] ^1Invalid Target.^7')
        end
    elseif (GetPlayerPing(target) == 0) then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'error', text = 'Invalid Target!' })
        else
            print('^7[^1Error^7] ^1Invalid Target.^7')
        end
    else
        MySQL.Async.fetchAll('SELECT * FROM `user_warnings` WHERE `target` = @target', {
            ['@target'] = steam
        }, function(data)
            for i,v in ipairs(data) do totalWarns = totalWarns + 1 end
            
            if totalWarns == 0 then
                if source ~= 0 then
                    TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Warn Info^7]^2', "This player doesn\'t have any warnings." }, color = 255,255,255 }) 
                else
                    print('This player doesn\'t have any warnings.')
                end
            else
                if source ~= 0 then
                    TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Warn Info^7]^2', "-- Showing Warns For: ^1"..GetPlayerName(target).." ^7| ^7Total warns: ^1"..totalWarns.." ^7--" }, color = 255,255,255 })
                    wonke = {} 
                    for i,v in ipairs(data) do
                        table.insert(wonke, "ID: ^1"..v.id.."^7 | Warned By: ^1"..v.source.."^7 | Reason: ^1"..v.reason.."^7 | Date: ^1"..v.date.."^7;")
                    end
                    warnsmsg = string.gsub(table.concat(wonke),";","\n")
                    TriggerClientEvent("chat:addMessage", source, {
                        color = {255, 255, 255},
                        multiline = true,
                        args = { warnsmsg }
                    })
                    TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Warn Info^7]^2', "--------------------------------------------------------------------" }, color = 255,255,255 })
                    warnsmsg = ""
                else
                    print('^7[^2Warn Info^7]^2 ------ ^7Showing Warns For: ^1'..GetPlayerName(target)..' ^7| ^7Total warns: ^1'..totalWarns..' ^2------^7')
                    wonke = {}
                    for i,v in ipairs(data) do
                        table.insert(wonke, "ID: ^1"..v.id.."^7 | Warned By: ^1"..v.source.."^7 | Reason: ^1"..v.reason.."^7 | Date: ^1"..v.date.."^7;")
                    end
                    warnsmsg = string.gsub(table.concat(wonke),";","\n")
                    print(warnsmsg)
                    print('^7[^2Warn Info^7]^2 ---------------------------------------------------------------------')
                    warnsmsg = ""
                end
            end
        end)
    end
end, true)

--[[
    Removes a warn with the specific ID
]]
RegisterCommand("removewarn", function(source, args, rawCommand)
    local target = tonumber(args[1])
    local steam

    for k,v in ipairs(GetPlayerIdentifiers(target)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            steam = v
        end
    end

    if target == nil then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'error', text = 'Invalid Target!' })
        else
            print('^7[^1Error^7] ^1Invalid Target.')
        end
    elseif (GetPlayerPing(target) == 0) then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'error', text = 'Invalid Target!' })
        else
            print('^7[^1Error^7] ^1Invalid Target.')
        end
    else
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "^7Removed Warn ID: ^1"..args[2].." ^7from ^1"..GetPlayerName(target) }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'success', text = 'Removed Warn ID: '..args[2]..' from '..GetPlayerName(target) })
            if Config.warnsToDiscord then
                sendToDiscord('Warning Removed', GetPlayerName(source)..' Removed warning with ID: '..args[2]..' from: '..GetPlayerName(target))
            end
        else
            print('^7[^2Success^7] ^7Removed Warn ID: ^1'..args[2]..' ^7from ^1'..GetPlayerName(target))
            if Config.warnsToDiscord then
                sendToDiscord('Warning Removed', 'Console Removed warning with ID: '..args[2]..' from: '..GetPlayerName(target))
            end
        end
        MySQL.Async.execute("DELETE FROM user_warnings WHERE target = @target AND id = @id", {
            ['@target'] = steam,
            ['@id'] = args[2]
        })
    end
end, true)

--[[
    Clears ALL of the warns that the player has
]]
RegisterCommand("clearWarns", function(source, args, rawCommand)
    local target = tonumber(args[1])
    local steam

    for k,v in ipairs(GetPlayerIdentifiers(target)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            steam = v
        end
    end

    if target == nil then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'error', text = 'Invalid Target!' })
        else
            print('^7[^1Error^7] ^1Invalid Target.')
        end
    elseif (GetPlayerPing(target) == 0) then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'error', text = 'Invalid Target!' })
        else
            print('^7[^1Error^7] ^1Invalid Target.')
        end
    else
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', " ^2Cleared all warns for ^1"..GetPlayerName(target) }, color = 255,255,255 })
            TriggerClientEvent('kyk_warnsystem:SendAlert', source, { type = 'success', text = 'Cleared all warns for '..GetPlayerName(target) })
            if Config.warnsToDiscord then
                sendToDiscord('Warning Removed', GetPlayerName(source)..' Removed ***ALL*** warnings from: '..GetPlayerName(target))
            end
        else
            print('^7[^2Success^7] ^2Cleared all warns for ^1'..GetPlayerName(target))
            if Config.warnsToDiscord then
                sendToDiscord('Warning Removed', 'Console Removed ***ALL*** warnings from: '..GetPlayerName(target))
            end
        end
        MySQL.Async.execute("DELETE FROM user_warnings WHERE target = @target", {
            ['@target'] = steam, 
        })
    end
end, true)


--[[ Check for updates system ]]
if Config.checkForUpdates then
	local version = '1.2'
	local resourceName = "Kyk-WarnSystem ("..GetCurrentResourceName()..")"
    
	Citizen.CreateThread(function()
		function checkVersion(err,response, headers)
			if err == 200 then
				local data = json.decode(response)
                if version ~= data.warnSystemVersion and tonumber(version) < tonumber(data.warnSystemVersion) then
					print(""..resourceName.." ~r~is outdated.\nNewest Version: "..data.warnSystemVersion.."\nYour Version: "..version.."\nPlease get the latest update from https://github.com/JeesusKrisostoomus/Kyk-WarnSystem")
				elseif tonumber(version) > tonumber(data.warnSystemVersion) then
					print("Your version of "..resourceName.." seems to be higher than the current version.")
				else
					print(resourceName.. " is up to date!")
				end
			else
				print("Version Check failed! HTTP Error Code: "..err)
			end
			
			SetTimeout(3600000, checkVersionHTTPRequest) --[[ Makes the version check repeat every 1h ]]
		end
		function checkVersionHTTPRequest() --[[ Registers checkVersionHTTPRequest function ]]
			PerformHttpRequest("https://raw.githubusercontent.com/JeesusKrisostoomus/Kyk-Releases/main/versions.json", checkVersion, "GET") --[[ Sends GET http requests ]]
		end
		checkVersionHTTPRequest() --[[ Calls checkVersionHTTPRequest function ]]
	end)
end

function sendToDiscord(name, message)
    if message == nil or message == '' then
        print('[Kyk-WarnSystem] - Message was not set, therefor it wasn\'t sent')
        return
    end
    if discord_webhook == nil and discord_webhook == '' then
        print('[Kyk-WarnSystem] - Discord webhook not set, therefore message wasn\'t sent')
        return
    end

    local embeds = { {
        ['title'] = '['..name..']',
        ['type'] = 'rich',
        ['description'] = message,
        ['color'] = Config.webhookColor, --[[ Current Color: Orange]]
        ['footer'] = {
            ['text'] = 'Kyk-WarnSystem',
        }, } 
    }

    PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
