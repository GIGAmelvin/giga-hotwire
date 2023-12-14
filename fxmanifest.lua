fx_version "bodacious"
games { "gta5", }
lua54 "yes"
author "GIGAmelvin <gigamelvin@proton.me>"
version "0.0.1"

shared_script "config.lua"

client_script "client.lua"

server_script "server.lua"

dependencies {
  "qb-core",
  "giga-util",
}
