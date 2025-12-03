fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'hs-blackmarket'
author 'pixelcrafter_1'
version '1.0.0'
description 'Black Market'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/app.js'
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua',
  'locales/en.lua',
  'shared/framework.lua',
  'shared/bridges/*.lua'
}

client_scripts {
  'client/main.lua',
  'client/ui.lua',
  'client/guards.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua'
}
