Inv = {}

local function isWeaponName(n) return n and n:lower():find('weapon_') end
local function isAmmoName(n)   return n and n:lower():find('ammo') end

function Inv.AutoCategory(entry)
  if entry.category then return entry.category end
  if entry.weapon or (entry.item and isWeaponName(entry.item)) or (entry.id and isWeaponName(entry.id)) then
    return 'Guns' end
  if (entry.item and isAmmoName(entry.item)) or (entry.id and isAmmoName(entry.id)) then
    return 'Ammo' end
  return 'Other'
end

function Inv.GetItemIcon(name)
  name = tostring(name or ''):lower()
  local base = (Config.Icon.bases or {}).ox
  if Config.Inventory == 'qb' then base = Config.Icon.bases.qb end
  if Config.Inventory == 'qs' then base = Config.Icon.bases.qs end
  if Config.Inventory == 'tgiann' then base = Config.Icon.bases.tgiann end
  if base then return (base .. name .. '.png') end
  return Config.Icon.fallback
end

if IsDuplicityVersion() then
  function Inv.AddItem(src, name, count, meta)
    if Config.Inventory == 'ox' and GetResourceState('ox_inventory') == 'started' then
      return exports.ox_inventory:AddItem(src, name, count or 1, meta)
    end
    if Config.Inventory == 'qb' and GetResourceState('qb-core') == 'started' then
      local QBCore = exports['qb-core']:GetCoreObject()
      return QBCore.Functions.GetPlayer(src).Functions.AddItem(name, count or 1, false, meta)
    end
    if Config.Inventory == 'qs' and GetResourceState('qs-inventory') == 'started' then
      return exports['qs-inventory']:AddItem(src, name, count or 1, meta)
    end
    if Config.Inventory == 'tgiann' and GetResourceState('tgiann-inventory') == 'started' then
      return exports['tgiann-inventory']:AddItem(src, name, count or 1, meta)
    end
    local xPlayer = FW.GetPlayer(src)
    if xPlayer then xPlayer.addInventoryItem(name, count or 1) return true end
    return false
  end

  function Inv.RemoveMoney(src, amount)
    if Config.Payment:find('account:') then
      local account = Config.Payment:sub(9)
      if FW.type == 'esx' then
        local xPlayer = FW.GetPlayer(src)
        if not xPlayer then return false end
        local acc = xPlayer.getAccount(account)
        if acc and acc.money >= amount then xPlayer.removeAccountMoney(account, amount) return true end
        return false
      elseif FW.type == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        return QBCore.Functions.GetPlayer(src).Functions.RemoveMoney(account, amount)
      end
    elseif Config.Payment:find('item:') then
      local item = Config.Payment:sub(6)
      if Config.Inventory == 'ox' then
        local c = exports.ox_inventory:Search(src, 'count', item)
        if c >= amount then exports.ox_inventory:RemoveItem(src, item, amount) return true end
        return false
      end
      if Config.Inventory == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local p = QBCore.Functions.GetPlayer(src)
        local it = p.Functions.GetItemByName(item)
        local have = it and it.amount or 0
        if have >= amount then p.Functions.RemoveItem(item, amount) return true end
        return false
      end
      if Config.Inventory == 'qs' and GetResourceState('qs-inventory') == 'started' then
        local count = exports['qs-inventory']:GetItemCount(src, item)
        if count >= amount then exports['qs-inventory']:RemoveItem(src, item, amount) return true end
        return false
      end
      if Config.Inventory == 'tgiann' and GetResourceState('tgiann-inventory') == 'started' then
        local count = exports['tgiann-inventory']:GetItemCount(src, item)
        if count >= amount then exports['tgiann-inventory']:RemoveItem(src, item, amount) return true end
        return false
      end
      local xPlayer = FW.GetPlayer(src)
      local have = xPlayer.getInventoryItem(item).count
      if have >= amount then xPlayer.removeInventoryItem(item, amount) return true end
      return false
    end
    return false
  end

  function Inv.GiveWeapon(src, weapon, ammo)
    ammo = ammo or 0
    if Config.Inventory == 'ox' then
      return exports.ox_inventory:AddItem(src, weapon, 1, { ammo = ammo })
    end
    if Config.Inventory == 'qb' then
      local QBCore = exports['qb-core']:GetCoreObject()
      return QBCore.Functions.GetPlayer(src).Functions.AddItem(weapon, 1, false, { ammo = ammo })
    end
    local xPlayer = FW.GetPlayer(src)
    if xPlayer then xPlayer.addWeapon(weapon, ammo) return true end
    return false
  end
end
