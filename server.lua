local oldPrint = print
print = function(trash)
	oldPrint('^7[^2KYK Warns^7] '..trash..'^0')
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
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
    elseif (GetPlayerPing(target) == 0) then
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
    else
        if (warnReason == "") then warnReason = "No Reason Specified" end
        MySQL.Async.execute("INSERT INTO user_warnings (source, target, reason, date) VALUES (@source,@target,@reason,@date)", {
            ['@source'] = GetPlayerName(source),
            ['@target'] = steam, 
            ['@reason'] = warnReason,
            ['@date'] = os.date('%d.%m.%Y')
        })
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "^1"..GetPlayerName(target).." ^7has been warned." }, color = 255,255,255 })
        TriggerClientEvent('chat:addMessage', target, { args = { '^7[^3Warning^7]^2', "You have been warned by: ^1"..GetPlayerName(source).." ^7For: ^1"..warnReason }, color = 255,255,255 })
    end
    
end, true)

--[[
    Show all the warns that the player has
]]
RegisterCommand("warns", function(source, args, rawCommand)
    
    local totalWarns = 0
    local target = tonumber(args[1])
    local steam
    
    if (args[1] == nil) then target = source end
    for k,v in ipairs(GetPlayerIdentifiers(target)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            steam = v
        end
    end

    if target == nil then
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
    elseif (GetPlayerPing(target) == 0) then
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
    else
        MySQL.Async.fetchAll('SELECT * FROM `user_warnings` WHERE `target` = @target', {
            ['@target'] = steam
        }, function(data)
            for i,v in ipairs(data) do totalWarns = totalWarns + 1 end
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Warn Info^7]^2', "-- Showing Warns For: ^1"..GetPlayerName(target).." ^7| ^7Total warns: ^1"..totalWarns.." ^7--" }, color = 255,255,255 }) 
            for i,v in ipairs(data) do
                TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Warn Info^7]^2', "ID: "..v.id.." ^7| Warned By: ^1"..v.source.." ^7| ^7Reason: ^1"..v.reason.." ^7| ^7Date: ^1"..v.date }, color = 255,255,255 }) 
            end
            TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Warn Info^7]^2', "--------------------------------------------------------------------" }, color = 255,255,255 }) 
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
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
    elseif (GetPlayerPing(target) == 0) then
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
    else
        MySQL.Async.execute("DELETE FROM user_warnings WHERE target = @target AND id = @id", {
            ['@target'] = steam,
            ['@id'] = args[2]
        })
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Success^7]^2', "^7Removed Warn ID: ^1"..args[2].." ^7from ^1"..GetPlayerName(target) }, color = 255,255,255 })
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
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
    elseif (GetPlayerPing(target) == 0) then
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "^1Invalid Target." }, color = 255,255,255 })
    else
        MySQL.Async.execute("DELETE FROM user_warnings WHERE target = @target", {
            ['@target'] = steam, 
        })
        TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Success^7]^2', "^2Cleared all warns for ^1"..GetPlayerName(target) }, color = 255,255,255 })
    end
end, true)