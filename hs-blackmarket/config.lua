Config = {}

-- Framework: 'auto' | 'esx' | 'qb'
Config.Framework = 'auto'

-- Inventory: 'ox' | 'qb' | 'qs' | 'tgiann'
Config.Inventory = 'ox'

-- Payment: 'account:black_money'  or  'item:markedbills' (ali drug item)
Config.Payment = 'account:black_money'

-- UI
Config.UI = 'nui'
Config.UIOptions = { Animations = true, Sound = true, TransparentRight = true }

-- DB persist (oxmysql)
Config.DB = { Persist = true }

-- Target system: 'ox_target' | 'qb-target' | 'qtarget' | '3d'
Config.TargetSystem = 'ox_target'

-- Phone / Notify
-- Options: 'ox' | 'phone' | 'both' | 'none'
Config.NotifyWhenReady = 'ox'
Config.Phones = { 'qb-phone','gksphone','qs-smartphone','npwd','renewed-phone' }

-- Dealers
Config.MarketEntries = {
  { label='Black Market', model='g_m_m_chiboss_01', coords=vec3(866.52, -2179.39, 30.32), heading=90.0 }
}

-- Drop UX
Config.PickupUX = {
  enableBlip = true,
  enableMarker = true,
  textUI = true
}

-- Guards AI
Config.GuardsAggressive = false

-- DropLocations
Config.DropLocations = {
  { coords = vec3(-553.32, 5324.18, 73.6), heading = 12.0 },
}

-- Guards setup
Config.Guards = {
  bossModel = 'g_m_m_armboss_01',
  guardModels = { 'g_m_m_armgoon_01','g_m_m_armgoon_02','g_m_m_armgoon_02','g_m_m_armgoon_01' },
  weaponBoss = 'weapon_assaultrifle',
  weaponGuards = 'weapon_microsmg',
  accuracy = 70, armor = 100, health = 250
}

-- Package
Config.Package = { prop = 'prop_security_case_01', pickupRadius = 2.0 }

-- Delivery
Config.DeliveryDelay = { min = 45, max = 90 }

-- Catalog
Config.Catalog = {
  { id='pistol',     label='Pistol',        weapon='weapon_pistol', price=8500, category='Guns' },
  { id='smg',        label='SMG',           weapon='weapon_smg',    price=19500, category='Guns' },
  { id='rifle',      label='Rifle',         weapon='weapon_smg',    price=19500, category='Guns' },
  { id='smg',        label='SMG',           weapon='weapon_smg',    price=19500, category='Guns' },
  { id='smg',      label='SMG',             weapon='weapon_smg',    price=19500, category='Guns' },
  { id='rifle',      label='Rifle',         weapon='weapon_smg',    price=19500, category='Guns' },
  { id='smg',        label='SMG',           weapon='weapon_smg',    price=19500, category='Guns' },
  { id='smg',      label='SMG',             weapon='weapon_smg',    price=19500, category='Guns' },
  { id='rifle',      label='Rifle',         weapon='weapon_smg',    price=19500, category='Guns' },
  { id='smg',        label='SMG',           weapon='weapon_smg',    price=19500, category='Guns' },
  { id='smg',      label='SMG',             weapon='weapon_smg',    price=19500, category='Guns' },
  { id='rifle',      label='Rifle',         weapon='weapon_smg',    price=19500, category='Guns' },
  { id='smg',        label='SMG',           weapon='weapon_smg',    price=19500, category='Guns' },
  { id='rifle_ammo', label='Rifle Ammo',    item='rifle_ammo',      price=2500, category='Ammo' },
  { id='rifle_ammo', label='Rifle Ammo',    item='rifle_ammo',      price=2500, category='Tools' },
  { id='rifle',        label='Rifle',           weapon='weapon_assaultrifle',    price=19500, category='Other' },
}

Config.MaxOpenOrders = 1
Config.Debug = false

-- ICON
Config.Icon = {
  bases = {
    ox      = 'nui://ox_inventory/web/images/',
    qb      = 'nui://qb-inventory/html/images/',
    qs      = 'nui://qs-inventory/html/images/',
    tgiann  = 'nui://inventory-images/images/',
  },
  fallback = 'https://i.imgur.com/8iRkX7R.png'
}

Config.Webhook = 'YOUR_WEBKOOH_HERE'
Config.WebhookColor = 65280

-- UI order
Config.UIOrder = { 'Guns', 'Ammo', 'Tools', 'Other' }
