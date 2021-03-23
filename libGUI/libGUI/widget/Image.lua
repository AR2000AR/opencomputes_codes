local ImageFile = require("libGUI/ImageFile")
local gpu = require("component").gpu

local Image = require("libClass").newClass("Image",require("libGUI/widget/Widget"))
Image.imageData = {}
function Image.constructor(self,x,y,img)
  if(type(img) == "string") then
    self.imageData = ImageFile(img)
  elseif(type("table") and img.class == "Image") then
    self.imageData = img
  end
end
function Image.getWidth(self) return self.imageData:getWidth() end
function Image.getHeight(self) return self.imageData:getHeight() end
function Image.getSize(self) return self.imageData:getSize() end
function Image.setWidth(self) error("Can change a image size",2) end
function Image.setHeight(self) error("Can change a image size",2) end
function Image.setSize(self) error("Can change a image size",2) end

function Image.draw(self)
  local background = gpu.getBackground()
  for deltaX, column in ipairs(self.imageData:getPixel()) do
    for deltaY, pixel in ipairs(column) do
      if(pixel ~= "nil") then
        gpu.setBackground(pixel)
        gpu.set(self:getX()+deltaX-1,self:getY()+deltaY-1," ")
      end
    end
  end
  gpu.setBackground(background)
end

return Image
