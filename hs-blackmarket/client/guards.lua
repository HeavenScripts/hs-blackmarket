local drops = {}

RegisterNetEvent('bm:orderReady', function(order)
    local id = tostring(order.id)
    local pos = order.drop.coords
    local heading = order.drop.heading or 0.0

    drops[id] = { blip = nil, markerActive = true, peds = {}, prop = nil, center = pos }

    if Config.PickupUX.enableBlip then
        local b = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(b, 501)
        SetBlipColour(b, 2)
        SetBlipScale(b, 0.9)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Package Pickup')
        EndTextCommandSetBlipName(b)
        drops[id].blip = b
    end

    -- spawn prop
    RequestModel(Config.Package.prop)
    while not HasModelLoaded(Config.Package.prop) do Wait(10) end
    local prop = CreateObject(GetHashKey(Config.Package.prop), pos.x, pos.y, pos.z - 1.0, true, true)
    SetEntityHeading(prop, heading)
    FreezeEntityPosition(prop, true)
    drops[id].prop = prop

    -- add target for pickup
    local mode = Config.TargetSystem
    if mode == 'ox_target' and GetResourceState('ox_target') == 'started' then
        exports.ox_target:addLocalEntity(prop, {{
            name = 'bm_pickup_' .. id,
            icon = 'fa-solid fa-box-open',
            label = 'Pick up Package',
            distance = 2.0,
            onSelect = function()
                TriggerServerEvent('bm:collectOrder', id)
            end
        }})
    elseif mode == 'qb-target' and GetResourceState('qb-target') == 'started' then
        exports['qb-target']:AddTargetEntity(prop, {
            options = {{
                icon = 'fa-solid fa-box-open',
                label = 'Pick up Package',
                action = function()
                    TriggerServerEvent('bm:collectOrder', id)
                end
            }},
            distance = 2.0
        })
    elseif mode == 'qtarget' and GetResourceState('qtarget') == 'started' then
        exports.qtarget:AddTargetEntity(prop, {
            options = {{
                icon = 'fa-solid fa-box-open',
                label = 'Pick up Package',
                action = function()
                    TriggerServerEvent('bm:collectOrder', id)
                end
            }},
            distance = 2.0
        })
    else
        -- fallback 3D text pickup
        CreateThread(function()
            while drops[id] and DoesEntityExist(prop) do
                local ped = PlayerPedId()
                local dist = #(GetEntityCoords(ped) - pos)
                if dist < (Config.Package.pickupRadius or 2.0) then
                    if Config.PickupUX.textUI then
                        lib.showTextUI('[E] Pick up Package')
                    end
                    if IsControlJustReleased(0, 38) then
                        if Config.PickupUX.textUI then lib.hideTextUI() end
                        TriggerServerEvent('bm:collectOrder', id)
                        break
                    end
                else
                    if Config.PickupUX.textUI then lib.hideTextUI() end
                end
                Wait(0)
            end
        end)
    end

    -- guards spawn
    local function spawnGuard(model, off, boss)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
        local p = CreatePed(30, GetHashKey(model), pos.x + off.x, pos.y + off.y, pos.z, heading, true, true)
        SetPedArmour(p, Config.Guards.armor)
        SetEntityHealth(p, Config.Guards.health)
        local w = boss and Config.Guards.weaponBoss or Config.Guards.weaponGuards
        GiveWeaponToPed(p, GetHashKey(w), 200, false, true)
        if Config.GuardsAggressive then
            SetPedAccuracy(p, Config.Guards.accuracy)
            SetPedRelationshipGroupHash(p, `HATES_PLAYER`)
            SetPedCombatAttributes(p, 46, true)
            SetPedCombatAbility(p, 2)
        else
            SetPedSeeingRange(p, 0.0)
            SetPedHearingRange(p, 0.0)
            SetBlockingOfNonTemporaryEvents(p, true)
            SetPedAlertness(p, 0)
        end
        return p
    end

    local offs = { vec3(1.5, 0, 0), vec3(2, 0, 0), vec3(-2, 0, 0), vec3(0, 2, 0), vec3(0, -2, 0) }
    drops[id].peds[#drops[id].peds + 1] = spawnGuard(Config.Guards.bossModel, offs[1], true)
    for i = 2, 5 do
        drops[id].peds[#drops[id].peds + 1] = spawnGuard(Config.Guards.guardModels[i - 1], offs[i])
    end
end)

RegisterNetEvent('bm:cleanupDrop', function(id)
    local d = drops[id]
    if not d then return end
    if d.blip then RemoveBlip(d.blip) end
    if d.prop and DoesEntityExist(d.prop) then DeleteEntity(d.prop) end
    for _, p in ipairs(d.peds) do
        if DoesEntityExist(p) then DeletePed(p) end
    end
    drops[id] = nil
end)
