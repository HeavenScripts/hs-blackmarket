BMTarget = {}

local function targetType()
  local t = Config.TargetSystem
  if t == 'ox_target' and GetResourceState('ox_target') == 'started' then return 'ox' end
  if t == 'qb-target' and GetResourceState('qb-target') == 'started' then return 'qb' end
  if t == 'qtarget' and GetResourceState('qtarget') == 'started' then return 'qt' end

  if GetResourceState('ox_target') == 'started' then return 'ox' end
  if GetResourceState('qb-target') == 'started' then return 'qb' end
  if GetResourceState('qtarget') == 'started' then return 'qt' end

  return '3d'
end

local mode = targetType()
print(('[hs-blackmarket] Target mode: %s'):format(mode))

function BMTarget.AddPedTarget(ped, label)
  if mode == 'ox' then
    exports.ox_target:addLocalEntity(ped, {{
      name='hs_bm_open',
      icon='fa-solid fa-sack-dollar',
      label=label or 'Black Market',
      distance=2.0,
      onSelect=function() TriggerEvent('bm:open') end
    }})
    return
  end

  if mode == 'qb' then
    exports['qb-target']:AddTargetEntity(ped, {
      options = {{
        icon='fa-solid fa-sack-dollar',
        label=label or 'Black Market',
        action=function() TriggerEvent('bm:open') end
      }},
      distance=2.0
    })
    return
  end

  if mode == 'qt' then
    exports.qtarget:AddTargetEntity(ped, {
      options = {{
        icon='fa-solid fa-sack-dollar',
        label=label or 'Black Market',
        action=function() TriggerEvent('bm:open') end
      }},
      distance=2.0
    })
    return
  end

  print('^3[hs-blackmarket]^0 Using 3D Text fallback (no target).')
  CreateThread(function()
    while DoesEntityExist(ped) do
      local p = PlayerPedId()
      local dist = #(GetEntityCoords(p) - GetEntityCoords(ped))
      if dist < 2.0 then
        if Config.PickupUX.textUI then
          lib.showTextUI('[E] '..(label or 'Black Market'))
        else
          SetTextCentre(true); SetTextFont(4); SetTextScale(0.35,0.35); SetTextEntry('STRING')
          AddTextComponentString('~g~E~s~ '..(label or 'Black Market')); DrawText(0.5,0.9)
        end
        if IsControlJustReleased(0,38) then TriggerEvent('bm:open') end
      else
        if Config.PickupUX.textUI then lib.hideTextUI() end
        Wait(250)
      end
      Wait(0)
    end
  end)
end
