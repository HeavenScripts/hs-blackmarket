📦 HS Blackmarket

Advanced FiveM black market system featuring order handling, guarded drop locations, inventory integrations, and a modern NUI panel.

🚀 Features

🛒 Order system (multiple items, preparation time)

📍 Automatic drop locations with coordinates + heading

🛑 NPC guards protecting the drop

💼 Multi-framework support: ESX, QBCore, auto-detection

🎒 Inventory support: ox_inventory, qb-inventory, qs-inventory, tgiann

🎨 Modern NUI (animations, sounds, optional transparency)

💰 Multiple payment types: black money or item-based

🗃️ Optional SQL order persistence

🌐 Discord webhooks

🌍 Localization (English included, easily expandable)

🧩 Modular bridges for inventory/notify/target systems

📂 Resource Structure
hs-blackmarket/
│
├── config.lua               # Main configuration
├── fxmanifest.lua           # Resource manifest
├── db.sql                   # SQL table
│
├── client/
│   ├── main.lua             # Client logic (UI, orders, drops)
│   ├── guards.lua           # NPC guards
│   └── ui.lua               # UI handler
│
├── server/
│   └── main.lua             # Orders, DB, and webhooks
│
├── shared/
│   ├── framework.lua        # Auto/framework bridge
│   └── bridges/
│       ├── inventory.lua    # Inventory integrations
│       ├── notify.lua       # Notification system
│       └── target.lua       # Target system
│
└── html/
    ├── index.html
    ├── style.css
    └── app.js               # Frontend logic

🛠️ Installation

Drag the resource into your server’s directory:

resources/hs-blackmarket


Add it to your server.cfg:

ensure hs-blackmarket


(Optional) Import the SQL:

CREATE TABLE IF NOT EXISTS `bm_orders` (
  `id` VARCHAR(64) NOT NULL,
  `identifier` VARCHAR(128) NOT NULL,
  `items_json` LONGTEXT NOT NULL,
  `ready_at` INT NOT NULL,
  `x` FLOAT NOT NULL,
  `y` FLOAT NOT NULL,
  `z` FLOAT NOT NULL,
  `h` FLOAT NOT NULL,
  `state` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`id`)
);

⚙️ Configuration (config.lua)
Framework
Config.Framework = 'auto' -- auto | esx | qb

Inventory System
Config.Inventory = 'ox' -- ox | qb | qs | tgiann

Payment Method
Config.Payment = 'account:black_money'
-- or: 'item:markedbills'

UI Settings
Config.UI = 'nui'
Config.UIOptions = {
  Animations = true,
  Sound = true,
  TransparentRight = true,
}

Webhooks
Config.Webhook = 'YOUR_WEBHOOK_HERE'
Config.WebhookColor = 65280

Database order saving
Config.DB.Persist = true

💻 How It Works
Opening the Black Market

You can trigger it via:

target systems (ox_target / qb-target),

commands,

NPCs,

or any custom interaction you set.

Order Workflow

Player opens NUI panel

Selects items and categories

Pays using chosen payment type

Receives a drop location + preparation time

Goes to the location, deals with guards, collects the package

🔒 Guards System

NPC guard configuration is located in client/guards.lua.
You may customize:

ped models

weapons

accuracy

health

behavior

🌍 Localization

Languages are stored in the locales/ directory.
Defaults include: English
Create your own by duplicating en.lua.

🧪 Compatibility

ESX Legacy

QBCore

ox_inventory

qb-inventory

qs-inventory

tgiann-inventory

qb-target / ox_target
