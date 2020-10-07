resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script "cl.lua"

server_script "sv.lua"
server_script "@mysql-async/lib/MySQL.lua"

ui_page "html/index.html"
files {
    'html/index.html',
    'html/index.js',
    'html/maze.png',
    'html/index.css'
}