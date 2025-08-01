local QBCore = exports['qb-core']:GetCoreObject()

-- Ziptie (one-time use)
RegisterNetEvent("pcrp-blindzip:server:ziptie", function(target)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not Player.Functions.RemoveItem(Config.ZiptieItem, 1) then
        TriggerClientEvent("QBCore:Notify", src, "No ziptie!", "error")
        return
    end
    TriggerClientEvent("pcrp-blindzip:client:ziptie", target)
    TriggerClientEvent("QBCore:Notify", src, "Ziptied player.", "success")
end)

-- Blindfold apply
RegisterNetEvent("pcrp-blindzip:server:blindfoldApply", function(target)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local blind = Player.Functions.RemoveItem(Config.BlindfoldItem, 1)
    if not blind then
        TriggerClientEvent("QBCore:Notify", src, "No blindfold!", "error")
        return
    end

    -- send to client: with remaining uses (always 5)
    TriggerClientEvent("pcrp-blindzip:client:blindfoldApply", target, 5)
    TriggerClientEvent("QBCore:Notify", src, "Applied blindfold.", "success")
end)

-- Blindfold remove (via target or radial)
RegisterNetEvent("pcrp-blindzip:server:blindfoldRemove", function(target)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- give back
    Player.Functions.AddItem(Config.BlindfoldItem, 1)
    TriggerClientEvent("pcrp-blindzip:client:blindfoldRemove", target)
    TriggerClientEvent("QBCore:Notify", src, "Removed blindfold.", "success")
end)
