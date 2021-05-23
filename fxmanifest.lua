fx_version "adamant"
game "gta5"

author "Wolf"
description "Emprego de Pedreiro inspirado no BGO do MTA"
version "1.0.0"

client_scripts { 
    "@vrp/lib/utils.lua",
    "config.lua",
    "kclient.lua"
}

server_script {
    "@vrp/lib/utils.lua",
    "kserver.lua"
}