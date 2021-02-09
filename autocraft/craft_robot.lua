local event = require("event")
local crafting = require("component").crafting
local modem = require("component").modem
local robot = require("component").robot

local PORT = 550

robot.select(4)
modem.open(PORT)

event.listen("modem_message",function(eventType,localAdd,distAdd,port,distance,mesg)
  if(mesg == "ping") then
    modem.send(distAdd,PORT,"pong")
  elseif(mesg == "craft") then
    modem.send(distAdd,PORT,"craft",crafting.craft(1))
  end
end)
