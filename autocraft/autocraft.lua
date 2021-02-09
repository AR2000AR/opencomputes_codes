local component = require("component")
local modem = require("component").modem
local io = require("io")
local fs = require("filesystem")
local serialization = require("serialization")
local event = require("event")

local transposers = {}
-- put all transposers in a list
for addresse,type in pairs(component.list("transposer")) do
  table.insert(transposers,component.proxy(addresse))
end

local CONFIG_DIR = "/etc/autocraft/"
local CONFIG_FILE = CONFIG_DIR.."autocraft.cfg"
local PORT = 550

local MACHINES_NAMES = {furnace="minecraft:furnace"}

local chests = {io={},chest={}}
local machines = {robot={modem="",transposer="",side=0}}

local function scanInventory()
  print("Inserer 1 item dans le coffre d'entrée / sortie")
  for _,transposer in pairs(transposers) do
    for side=0,5 do
      local invName = transposer.getInventoryName(side)
      if(invName) then
        if(invName == "opencomputers:robot") then
          modem.broadcast(PORT,"ping")
          local _,_,robotAdd = event.pull(5,"modem_message")
          if(robotAdd) then
            print("Robot trouvé")
            machines.robot = {}
            machines.robot.transposer = transposer.address
            machines.robot.side = side
            machines.robot.modem = robotAdd
          end
        elseif(invName == MACHINES_NAMES.furnace) then
          print("Four trouvé")
          machines.furnace = {}
          machines.furnace.transposer = transposer.address
          machines.furnace.side = side
        else
          local slotStackSize = transposer.getSlotStackSize(side,1)
          if(slotStackSize and slotStackSize > 0) then
            print("Coffre d'entrée / sortie trouvé")
            chests.io={transposer=transposer.address,side=side}
          else
            print("Inventaire trouvé : "..invName)
            local chest = {transposer=transposer.address,side=side}
            table.insert(chests.chest,chest)
          end
        end
      end
    end
  end
end

-- CONFIG
if(not fs.isDirectory(CONFIG_DIR)) then
  fs.makeDirectory(CONFIG_DIR)
end
if(not (fs.exists(CONFIG_FILE) and not fs.isDirectory(CONFIG_FILE))) then
  scanInventory()
  local configFile = io.open(CONFIG_FILE,"w")
  configFile:write(serialization.serialize(chests).."\n")
  configFile:write(serialization.serialize(machines))
  configFile:close()
end
