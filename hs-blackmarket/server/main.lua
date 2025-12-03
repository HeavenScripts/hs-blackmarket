local Orders = {}

local function now() return os.time() end
local function makeId(seed) return ("%s_%d_%04d"):format(seed, now(), math.random(1000,9999)) end
local function pid(src) return (FW.Identifier and FW.Identifier(src)) or tostring(src) end

local function dbInsertOrder(identifier, order)
  if not Config.DB or not Config.DB.Persist then return end
  MySQL.insert.await([[
    INSERT INTO bm_orders (id, identifier, items_json, ready_at, x, y, z, h, state)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  ]], {
    order.id, identifier, json.encode(order.items), order.readyAt,
    order.drop.coords.x, order.drop.coords.y, order.drop.coords.z, order.drop.heading or 0.0, order.state
  })
end

local function dbUpdateState(orderId, state)
  if not (Config.DB and Config.DB.Persist) then return end
  MySQL.update.await('UPDATE bm_orders SET state = ? WHERE id = ?', { state, orderId })
end

local function dbDeleteOrder(orderId)
  if not (Config.DB and Config.DB.Persist) then return end
  MySQL.update.await('DELETE FROM bm_orders WHERE id = ?', { orderId })
end

local function sendWebhook(title, desc, color)
  if not Config.Webhook or Config.Webhook == '' then return end
  local embed = {{
    title = title,
    description = desc,
    color = color or Config.WebhookColor or 65280,
    footer = { text = os.date("%Y-%m-%d %H:%M:%S") }
  }}
  PerformHttpRequest(Config.Webhook, function() end, 'POST',
    json.encode({ username = 'Black Market', embeds = embed }),
    { ['Content-Type'] = 'application/json' })
end

-- CART ORDER
RegisterNetEvent('bm:placeCartServer', function(_, cart)
  local src = source
  local p = FW.GetPlayer(src); if not p then return end

  Orders[src] = Orders[src] or {}
  if #Orders[src] >= (Config.MaxOpenOrders or 1) then
    Notify.Server(src, Locales.too_many_orders, 'error'); return
  end

  local items, total = {}, 0
  for _, it in ipairs(cart or {}) do
    for _, e in ipairs(Config.Catalog or {}) do
      if e.id == it.id then
        local qty = math.max(1, tonumber(it.qty) or 1)
        table.insert(items, { id=e.id, label=e.label, weapon=e.weapon, item=e.item, price=e.price, qty=qty })
        total = total + (e.price * qty)
      end
    end
  end
  if #items == 0 then return end

  if not Inv.RemoveMoney(src, total) then
    Notify.Server(src, Locales.not_enough, 'error'); return
  end

  local drop = Config.DropLocations[math.random(#Config.DropLocations)]
  local order = { id = makeId(items[1].id), items = items, drop = drop, readyAt = now() + math.random(Config.DeliveryDelay.min, Config.DeliveryDelay.max), state = 'pending' }

  table.insert(Orders[src], order)
  Notify.Server(src, Locales.order_success)
  dbInsertOrder(pid(src), order)

  local name = GetPlayerName(src)
  local itemLines = {}
  for _, i in ipairs(items) do
    table.insert(itemLines, ('%sx %s ($%s)'):format(i.qty, i.label, i.price))
  end
  sendWebhook(
    "🛒 New Black Market Order",
    ("**Buyer:** %s\n**Total:** $%s\n\n**Items:**\n%s"):format(name, total, table.concat(itemLines, "\n")),
    65280
  )

  SetTimeout((order.readyAt - now())*1000, function()
    order.state = 'ready'
    dbUpdateState(order.id, 'ready')
    TriggerClientEvent('bm:orderReady', src, order)
    if Config.NotifyWhenReady == 'ox' then
      TriggerClientEvent('ox_lib:notify', src, { title='Black Market', description=Locales.order_ready, type='inform' })
    end
  end)
end)

-- COLLECT
RegisterNetEvent('bm:collectOrder', function(orderId)
  local src = source
  Orders[src] = Orders[src] or {}
  for i, ord in ipairs(Orders[src]) do
    if tostring(ord.id) == tostring(orderId) and ord.state ~= 'completed' then
      for _, it in ipairs(ord.items) do
        if it.weapon then
          for _=1,it.qty do Inv.GiveWeapon(src, it.weapon, 0) end
        elseif it.item then
          Inv.AddItem(src, it.item, it.qty or 1)
        end
      end
      ord.state = 'completed'
      dbDeleteOrder(orderId)
      TriggerClientEvent('bm:cleanupDrop', src, orderId)
      Notify.Server(src, Locales.collected)

      local name = GetPlayerName(src)
      sendWebhook(
        "📦 Order Collected",
        ("**Buyer:** %s\n**Order ID:** %s\n**Collected:** %s"):format(
          name, tostring(orderId), os.date("%Y-%m-%d %H:%M:%S")
        ),
        3447003
      )

      table.remove(Orders[src], i)
      return
    end
  end
end)
