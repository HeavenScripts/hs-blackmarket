CreateThread(function()
  for _, d in ipairs(Config.MarketEntries or {}) do
    RequestModel(d.model) while not HasModelLoaded(d.model) do Wait(10) end
    local ped = CreatePed(0, GetHashKey(d.model), d.coords.x, d.coords.y, d.coords.z-1.0, d.heading or 0.0, false, true)
    FreezeEntityPosition(ped, true); SetEntityInvincible(ped, true); SetBlockingOfNonTemporaryEvents(ped, true)
    BMTarget.AddPedTarget(ped, d.label or 'Black Market')
  end
end)

RegisterNetEvent('bm:open', function()
  SetNuiFocus(true, true)
  SendNUIMessage({ action = 'open' })
end)
