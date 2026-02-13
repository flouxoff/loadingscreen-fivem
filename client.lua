-- Client.lua - FiveM Loading Screen Logic
-- This script handles the loading screen functionality

-- Configuration
local showDebugInfo = false -- Set to true for debugging

-- Event to send loading progress to the loading screen
RegisterNetEvent('loadscreen:sendLoadingProgress')
AddEventHandler('loadscreen:sendLoadingProgress', function(progress)
    SendNUIMessage({
        eventName = 'loadProgress',
        loadFraction = progress
    })
end)

-- Event to update server information
RegisterNetEvent('loadscreen:updateServerInfo')
AddEventHandler('loadscreen:updateServerInfo', function(data)
    SendNUIMessage({
        eventName = 'updateServerInfo',
        data = data
    })
end)

-- Event to control loading screen visibility
RegisterNetEvent('loadscreen:toggleVisibility')
AddEventHandler('loadscreen:toggleVisibility', function(visible)
    SendNUIMessage({
        eventName = 'toggleVisibility',
        visible = visible
    })
end)

-- Function to get current loading state
local function getLoadingState()
    local state = {
        loading = true,
        progress = 0,
        players = 0,
        maxPlayers = 0,
        serverName = "Unknown Server"
    }
    
    -- Get player count
    if NetworkIsSessionStarted() then
        state.loading = false
    end
    
    -- Get player count from network
    state.players = NetworkGetNumConnectedPlayers()
    state.maxPlayers = GetMaxPlayers()
    
    return state
end

-- Send loading progress at regular intervals
Citizen.CreateThread(function()
    local progress = 0
    
    while true do
        Citizen.Wait(1000) -- Update every second
        
        -- Simulate loading progress (this is a placeholder - actual progress comes from game)
        if progress < 100 then
            progress = progress + math.random(1, 5)
            if progress > 100 then progress = 100 end
            
            SendNUIMessage({
                eventName = 'loadProgress',
                loadFraction = progress / 100
            })
        end
    end
end)

-- Handle NUI callbacks from loading screen
RegisterNUICallback('loadingComplete', function(data, cb)
    -- Loading screen is complete
    cb('ok')
end)

RegisterNUICallback('getServerInfo', function(data, cb)
    -- Return server information
    cb(json.encode(getLoadingState()))
end)

-- Debug function
if showDebugInfo then
    RegisterNetEvent('loadscreen:debug')
    AddEventHandler('loadscreen:debug', function(message)
        print("^1[LoadingScreen Debug]^7 " .. message)
    end)
end

-- Initialize loading screen
AddEventHandler('onClientMapStart', function()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)

-- Alternative loading screen functions
function ShutdownLoadingScreenNui()
    SendNUIMessage({
        eventName = 'shutdown'
    })
end

-- Play sound when loading is complete
function PlayLoadingCompleteSound()
    SendNUIMessage({
        eventName = 'playSound',
        soundName = 'complete'
    })
end

-- Export functions for other resources
exports('setLoadingProgress', function(progress)
    SendNUIMessage({
        eventName = 'loadProgress',
        loadFraction = progress
    })
end)

exports('setServerInfo', function(info)
    SendNUIMessage({
        eventName = 'updateServerInfo',
        data = info
    })
end)

