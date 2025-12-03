Notify = {}

function Notify.Server(src, msg, notiftype)
  if Config.NotifyWhenReady == 'ox' or Config.NotifyWhenReady == 'both' then
    TriggerClientEvent('ox_lib:notify', src, { title='Black Market', description=msg, type=notiftype or 'inform' })
  end

  if Config.NotifyWhenReady == 'phone' or Config.NotifyWhenReady == 'both' then
    local id = FW.Identifier(src)
    if GetResourceState('qb-phone') == 'started' then
      TriggerEvent('qb-phone:server:sendNewMail', { sender='Black Market', subject='Order', message=msg, citizenid=id })
    elseif GetResourceState('gksphone') == 'started' then
      exports['gksphone']:SendNewMail(src, { sender='Black Market', subject='Order', message=msg })
    elseif GetResourceState('qs-smartphone') == 'started' then
      exports['qs-smartphone']:sendMail(src, { sender='Black Market', subject='Order', message=msg })
    elseif GetResourceState('npwd') == 'started' then
      exports['npwd']:sendMail(src, { sender='Black Market', subject='Order', message=msg })
    elseif GetResourceState('renewed-phone') == 'started' then
      exports['renewed-phone']:sendMail(src, { sender='Black Market', subject='Order', message=msg })
    end
  end

  if (Config.NotifyWhenReady == 'none') then return end
  if FW.type == 'esx' then TriggerClientEvent('esx:showNotification', src, msg)
  elseif FW.type == 'qb' then TriggerClientEvent('QBCore:Notify', src, msg, notiftype or 'primary') end
end
