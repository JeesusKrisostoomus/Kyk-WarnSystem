AddEventHandler('onClientResourceStart', function (resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent('chat:addSuggestion', '/warn', 'Warn a player', {
            { name="Player ID", help="Target player id" },
            { name="'Warn Reason'", help="Reason for the warn. !!Put the reason in '' if the reason is longer than one word!!" }
        })
        TriggerEvent('chat:addSuggestion', '/warns', 'Check player warns', {
            { name="Player ID", help="Target player id" }
        })
        TriggerEvent('chat:addSuggestion', '/removewarn', 'Remove a specific warn', {
            { name="Player ID", help="Target Player ID" },
            { name="Warn ID", help="Targets Warn ID" }
        })
        TriggerEvent('chat:addSuggestion', '/clearwarns', 'Clear all warns', {
            { name="Player ID", help="Target Player ID" }
        })
    end
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent('chat:removeSuggestion', '/warn')
        TriggerEvent('chat:removeSuggestion', '/warns')
        TriggerEvent('chat:removeSuggestion', '/removeWarn')
        TriggerEvent('chat:removeSuggestion', '/clearWarns')
    end
end)