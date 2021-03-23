local gpu = require("component").gpu

local Rectangle = require("libClass").newClass("Rectangle",require("libGUI/widget/Widget"))
Rectangle._width = 1
Rectangle._height = 1
Rectangle._color = 0
function Rectangle.setWidth(self,width) self._width = width or self:getWidth() end
function Rectangle.setHeight(self,height) self._height = height or self:getHeight() end
function Rectangle.setSize(self,width,height) self:setWidth(width) self:setHeight(height) end
function Rectangle.setColor(self,color) self._color =  color or self:getColor() end
function Rectangle.getWidth(self) return self._width end
function Rectangle.getHeight(self) return self._height end
function Rectangle.getSize(self) return self:getWidth(), self:getHeight() end
function Rectangle.getColor(self) return self._color end
function Rectangle.constructor(self,x,y,width,height,color) self:setWidth(width) self:setHeight(height) self:setColor(color) end
function Rectangle.collide(self,x,y)
  local wx1,wy1 = self:getPos()
  local wx2 = self:getX()+self:getWidth()-1
  local wy2 = self:getY()+self:getHeight()-1
  return ((x-wx1)*(wx2-x) >= 0 and (y-wy1)*(wy2-y) >= 0)
end
function Rectangle.draw(self)
  local bk = gpu.setBackground(self:getColor())
  gpu.fill(self:getX(),self:getY(),self:getWidth(),self:getHeight()," ")
  gpu.setBackground(bk)
end

return Rectangle
