local QBCore = exports['qb-core']:GetCoreObject()
local isZiptied = false
local isBlindfolded = false
local phoneDisabled = false
local inventoryDisabled = false

local lastFallTime = 0
local blindfoldUses = 0

-- Useable Items
QBCore.Functions.CreateUseableItem(Config.ZiptieItem, function()
    local p, dist = GetClosestPlayer()
    if p ~= -1 and dist < 2.5 then
        TriggerServerEvent("pcrp-blindzip:server:ziptie", GetPlayerServerId(p))
    else
        QBCore.Functions.Notify("No player nearby.", "error")
    end
end)

QBCore.Functions.CreateUseableItem(Config.BlindfoldItem, function()
    local p, dist = GetClosestPlayer()
    if p ~= -1 and dist < 2.5 then
        TriggerServerEvent("pcrp-blindzip:server:blindfoldApply", GetPlayerServerId(p))
    else
        QBCore.Functions.Notify("No player nearby.", "error")
    end
end)

-- Receive ziptie
RegisterNetEvent("pcrp-blindzip:client:ziptie", function()
    isZiptied = true
    ClearPedTasksImmediately(PlayerPedId())
    RequestAnimDict("mp_arresting")
    while not HasAnimDictLoaded("mp_arresting") do Wait(0) end
    TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8, -8, -1, 49, 0, false, false, false)
    QBCore.Functions.Notify("You are ziptied.", "error")
end)

-- Receive blindfold
RegisterNetEvent("pcrp-blindzip:client:blindfoldApply", function(uses)
    if isBlindfolded then return end
    isBlindfolded = true
    blindfoldUses = uses or 5
    DoScreenFadeOut(1000)
    Wait(1200)
    CreateThread(function()
        while isBlindfolded do
            DrawRect(0.5,0.5,1.0,1.0,0,0,0,255)
            HideHudAndRadarThisFrame()
            Wait(0)
        end
    end)
    QBCore.Functions.Notify("You are blindfolded!", "error")
end)

-- Blindfold removed
RegisterNetEvent("pcrp-blindzip:client:blindfoldRemove", function()
    if not isBlindfolded then return end
    isBlindfolded = false
    DoScreenFadeIn(1000)
    QBCore.Functions.Notify("Blindfold removed!", "success")
end)

-- Controls & exports
CreateThread(function()
    while true do
        Wait(0)

        -- Disable controls if ziptied
        if isZiptied then
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 25, true)  -- Aim
            DisableControlAction(0, 37, true)  -- Weapon Wheel
            DisableControlAction(0, 23, true)  -- Enter vehicle
            DisableControlAction(0, 289, true) -- F2 (Inventory)
            DisableControlAction(0, 288, true) -- F1
            DisableControlAction(0, 170, true) -- F3
            DisableControlAction(0, 167, true) -- F6
            DisableControlAction(0, 73, true)  -- X (cancel)
            DisableControlAction(0, 38, true)  -- E
        end

        -- Manage phone & inventory
        if isZiptied or isBlindfolded then
            if not phoneDisabled then
                exports.yseries:ToggleDisabled(true)
                phoneDisabled = true
            end
            if not inventoryDisabled then
                exports["tgiann-inventory"]:SetInventoryActive(false)
                inventoryDisabled = true
            end
        else
            if phoneDisabled then
                exports.yseries:ToggleDisabled(false)
                phoneDisabled = false
            end
            if inventoryDisabled then
                exports["tgiann-inventory"]:SetInventoryActive(true)
                inventoryDisabled = false
            end
        end
    end
end)

-- Fall chance
CreateThread(function()
    while true do
        Wait(500)
        if isZiptied and IsPedRunning(PlayerPedId()) and GetGameTimer() - lastFallTime > Config.FallCooldown then
            if math.random(100) <= Config.FallChance then
                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.3)
                SetPedToRagdoll(PlayerPedId(),3000,3000,0,false,false,false)
            end
            lastFallTime = GetGameTimer()
        end
    end
end)

-- Get nearest player
function GetClosestPlayer()
    local players = GetActivePlayers()
    local pd = PlayerPedId(); local pc = GetEntityCoords(pd)
    local d, idx = -1, -1
    for _, i in ipairs(players) do
        local t = GetPlayerPed(i)
        if t ~= pd then
            local dist = #(pc - GetEntityCoords(t))
            if d < 0 or dist < d then d, idx = dist, i end
        end
    end
    return idx, d
end

-- Radial menu to remove own blindfold if not ziptied
exports['qb-radialmenu']:AddOption({
    id = "remove_blindfold_self",
    title = "Remove Blindfold",
    icon = "fas fa-eye-slash",
    event = function()
        if isBlindfolded and not isZiptied then
            TriggerServerEvent("pcrp-blindzip:server:blindfoldRemove", GetPlayerServerId(PlayerId()))
        end
    end,
    shouldShow = function()
        return isBlindfolded and not isZiptied
    end
})

-- qb-target: if player is ziptied and blindfolded, show remove option
Citizen.CreateThread(function()
    exports['qb-target']:AddTargetLocalPlayer({
        options = {
            {
                type = "client",
                event = "pcrp-blindzip:client:targetRemoveBlindfold",
                icon = "fas fa-eye-slash",
                label = "Remove Blindfold",
                canInteract = function(entity)
                    return isZiptied and isBlindfolded
                end
            }
        },
        distance = 2.5
    })
end)

RegisterNetEvent("pcrp-blindzip:client:targetRemoveBlindfold", function()
    local p = GetPlayerServerId(PlayerId())
    TriggerServerEvent("pcrp-blindzip:server:blindfoldRemove", p)
end)
