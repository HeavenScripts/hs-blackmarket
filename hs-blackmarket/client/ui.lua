local function enrichCatalog()
  local cats, out = {}, {}
  for _, e in ipairs(Config.Catalog or {}) do
    local entry = {}; for k,v in pairs(e) do entry[k]=v end
    entry.category = Inv.AutoCategory(entry)
    local iconName = entry.item or entry.weapon or entry.id
    entry.icon = Inv.GetItemIcon(iconName)
    table.insert(out, entry); cats[entry.category] = true
  end
  local ordered, pref = {}, (Config.UIOrder or {})
  for _,k in ipairs(pref) do if cats[k] then table.insert(ordered, k); cats[k]=nil end end
  for k,_ in pairs(cats) do table.insert(ordered, k) end
  return out, ordered
end

RegisterNetEvent('bm:open', function()
  SetNuiFocus(true,true)
  local catalog, categories = enrichCatalog()
  SendNUIMessage({ action='open', catalog=catalog, categories=categories })
end)

-- Confirm dialog (ox_lib)
RegisterNUICallback('bm:confirm', function(data, cb)
  local total = tonumber(data.total or 0) or 0
  local count = tonumber(data.count or 0) or 0
  local txt = ('Total: $%s\nItems: %d'):format(lib.math.groupdigits(total), count)
  local res = lib.alertDialog({ header='Black Market', content='Confirm purchase?\n'..txt, centered=true, cancel=true, labels={confirm='Purchase', cancel='Cancel'} })
  cb({ confirm = res == 'confirm' })
end)

-- Place cart
RegisterNUICallback('bm:placeCart', function(data, cb)
  TriggerServerEvent('bm:placeCartServer', nil, data.cart)
  cb({ ok = true })
end)

RegisterNUICallback('bm:close', function(_, cb)
  SetNuiFocus(false,false); cb(true)
end)
