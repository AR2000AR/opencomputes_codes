local function emptyCallback(self) end

Widget = require("libClass").newClass("Widget")

--like in python the "_" is a convention for a private variable / methode in this code
Widget._x = 1
Widget._y = 1
Widget._callback = emptyCallback
Widget._visible = true
Widget._enabled = true

Widget.setVisible= function(self,visible) self._visible = visible end
function Widget.isVisible(self) return self._visible end

function Widget.enable(self,enable) self._enabled = enable end
function Widget.isEnabled(self) return self._enabled end

function Widget.setX(self,x) self._x = x or self:getX() end
function Widget.setY(self,y) self._y = y or self:getY() end
function Widget.setPos(self,x,y) self:setX(x) self:setY(y) end

function Widget.getX(self) return self._x end
function Widget.getY(self) return self._y end
function Widget.getPos(self) return self:getX(), self:getY() end

function Widget.setCallback(self,callback) self._callback = callback or emptyCallback end


function Widget.getId(self) return self._id end

function Widget.trigger(self,...) --call the callback function
  if(self:isEnabled()) then self._callback(self,...) end
end
function Widget.collide(self,x,y)
  return (x == self:getX() and y == self:getY())
end
function Widget.constructor(self,x,y) self:setPos(x,y) self._id = require("uuid").next() end

return Widget
