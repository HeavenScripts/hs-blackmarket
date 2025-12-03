FW = {}
FW.type = nil

CreateThread(function()
  if Config.Framework == 'qb' then
    FW.type = 'qb'
  elseif Config.Framework == 'esx' then
    FW.type = 'esx'
  else
    if GetResourceState('qb-core') == 'started' then FW.type = 'qb'
    elseif GetResourceState('es_extended') == 'started' then FW.type = 'esx' end
  end
  print('[hs-blackmarket] Framework:', FW.type or 'NONE')
end)

function FW.GetPlayer(src)
  if FW.type == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()
    return QBCore.Functions.GetPlayer(src)
  elseif FW.type == 'esx' then
    local ESX = exports['es_extended']:getSharedObject()
    return ESX.GetPlayerFromId(src)
  end
end

function FW.Identifier(src)
  if FW.type == 'qb' then
    local p = FW.GetPlayer(src)
    return p and p.PlayerData and p.PlayerData.citizenid
  elseif FW.type == 'esx' then
    local x = FW.GetPlayer(src)
    return x and x.identifier
  end
  return tostring(src)
end
