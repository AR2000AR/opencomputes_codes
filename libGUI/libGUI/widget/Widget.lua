local function emptyCallback(self) end

Widget = require("libClass").newClass("Widget")

--like in python the "_" is a convention for a private variable / methode in this code
Widget._x = 1
Widget._y = 1
Widget._callback = emptyCallback
Widget._visible = true
Widget._enabled = true

Widget.setVisible= function(self,visible) self._visible = visible end
Widget.isVisible = function(self) return self._visible end

Widget.enable = function(self,enable) self._enabled = enable end
Widget.isEnabled = function(self) return self._enabled end

Widget.setX = function(self,x) self._x = x or self:getX() end
Widget.setY = function(self,y) self._y = y or self:getY() end
Widget.setPos = function(self,x,y) self:setX(x) self:setY(y) end

Widget.getX = function(self) return self._x end
Widget.getY = function(self) return self._y end
Widget.getPos = function(self) return self:getX(), self:getY() end

Widget.setCallback = function(self,callback) self._callback = callback or emptyCallback end


Widget.getId = function(self) return self._id end

Widget.trigger = function(self,...) --call the callback function
  if(self:isEnabled()) then self._callback(self,...) end
end
Widget.collide = function(self,x,y)
  return (x == self:getX() and y == self:getY())
end
Widget.constructor = function(self,x,y) self:setPos(x,y) self._id = require("uuid").next() end

return Widget
