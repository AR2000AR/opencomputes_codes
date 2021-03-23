local text = require("text")
local gpu = require("component").gpu
local event = require("event")
local string = require("string")

local TextInput = require("libClass").newClass("Text",require("libGUI/widget/Text"))

TextInput._focused = false
TextInput._keyboardEventListenerId = -1
TextInput._touchEventListenerId = -1

function TextInput.isFocused(self) return self._focused end
function TextInput.setFocused(self,focused) self._focused = focused end

function TextInput._callback(self,...)
  if(self:isFocused() == true) then
    self:setFocused(true)
    self._keyboardEventListenerId = event.listen("key_down",function(eventName,componentUUID,charNum)
      if(charNum ~= 0) then
        if(charNum ~= 8) then
          self:setText(self:getText()..string.char(charNum))
        else
          self:setText(string.sub(self:getText(),1,-2))
        end
      end
    end)
    -- if we detect a other click we want to loose focus
    self._touchEventListenerId = event.listen("touch",function(...) self:tirgger() end)
  else
    event.cancel(self._keyboardEventListenerId)
    event.cancel(self._touchEventListenerId)
    self._keyboardEventListenerId = -1
    self._touchEventListenerId = -1
    self:setFocused(false)
  end
end
