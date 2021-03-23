local libClass = require("libClass")
local Widget = require("libGUI/widget/Widget")
local Rectangle = require("libGUI/widget/Rectangle")
local event = require("event")

local Screen = libClass.newClass("Screen")

Screen.childs = {}
Screen._visible = true
Screen._enabled = true

Screen._touchEventListenerId = -1
--we need to be able to return the listener id so the main program can cancel it
function Screen.getTouchEventListenerId(self) return self._touchEventListenerId end

function Screen.addChild(self,child)
  if(not child.class) then
    error("arg #2 is not a class",2)
  elseif(not libClass.instanceOf(child,Widget) and not libClass.instanceOf(child,Screen)) then
    error("arg #2 is not a Widget",2)
  else
    table.insert(self.childs,child)
  end
end
function Screen.trigger(self,...)
  if(self:isEnabled()) then self._clickHandler(self,...) end
end

function Screen._clickHandler(self,eventName,uuid,x,y)
  if(eventName == "touch") then --filter only "touch" events
    for _,widget in ipairs(self.childs) do
      if(libClass.instanceOf(widget,Widget)) then
        if(widget:collide(x,y)) then --test colision
          widget:trigger(eventName,uuid,x,y)
        end
      else --widget is a Screen
        widget:trigger(eventName,uuid,x,y)
      end
    end
  end
end
function Screen.setVisible(self,visible) self._visible = visible end
function Screen.isVisible(self) return self._visible end
function Screen.enable(self,enable) self._enabled = enable end
function Screen.isEnabled(self) return self._enabled end
function Screen.draw(self)
  for _,widget in ipairs(self.childs) do
    if(widget:isVisible()) then widget:draw() end
  end
end

function Screen.constructor(self,touchHandler)
  if(touchHandler ~= nil touchHandler == true) then
    self._touchEventListenerId = event.listen("touch",function(...) self:trigger(...) end)
  end
end

return Screen
