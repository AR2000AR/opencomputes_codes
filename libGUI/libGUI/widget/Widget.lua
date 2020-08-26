local function emptyCallback(self) end

Widget = require("libClass").newClass("Widget")
Widget.type = "Widget"
Widget.private = {id = "", x = 1, y = 1, callback = emptyCallback}
Widget.setPos = function(self,x,y) self:setX(x) self:setY(y) end
Widget.setX = function(self,x) self.private.x = x or self:getX() end
Widget.setY = function(self,y) self.private.y = y or self:getY() end
Widget.setCallback = function(self,callback) self.private.callback = callback or emptyCallback end
Widget.getX = function(self) return self.private.x end
Widget.getY = function(self) return self.private.y end
Widget.getPos = function(self) return self:getX(), self:getY() end
Widget.getId = function(self) return self.private.id end
Widget.trigger = function(self,widgetId) --call the callback function
  pcall(function()if(widgetId == self:getId()) then self.private:callback() end end)
end
Widget.constructor = function(self,x,y) self:setPos(x,y) self.private.id = require("uuid").next() end

return Widget