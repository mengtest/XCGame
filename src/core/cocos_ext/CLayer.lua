clsLayer = class("clsLayer", function() return cc.Layer:create() end)

function clsLayer:ctor(parent)
	if parent then KE_SetParent(self, parent) end
end

function clsLayer:dtor()
	KE_RemoveFromParent(self)
end

KE_ExtendClass(clsLayer)

function clsLayer:SwallowEvent(bSwallow)
	if bSwallow then
		self:getEventDispatcher():removeEventListener(self.mListener)
		self.mListener = nil
		
		local function onToucheBegan(touch, event)
			return utils.IsNodeRealyVisible(self.mBlockLayer)
		end
		local function onToucheMoved(touchs, event) 
			
		end
		local function onToucheEnded(touchs, event) 
			if self.OnClickBlock then self.OnClickBlock() end
		end
		self.mListener = cc.EventListenerTouchOneByOne:create()
		local listener = self.mListener
		listener:registerScriptHandler(onToucheBegan, cc.Handler.EVENT_TOUCH_BEGAN)
		listener:registerScriptHandler(onToucheMoved, cc.Handler.EVENT_TOUCH_MOVED)
		listener:registerScriptHandler(onToucheEnded, cc.Handler.EVENT_TOUCH_ENDED)
		self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
		listener:setSwallowTouches(true)
	else 
		self:getEventDispatcher():removeEventListener(self.mListener)
		self.mListener = nil
	end
end
