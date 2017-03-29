--------------------
--键盘事件
--------------------
module("keyboard", package.seeall)

function InitKeboardEvent(self, cur_scene)
	if device.platform ~= "windows" then return end
	assert(cur_scene, "注册键盘事件失败")
	
	self:ClearAllListener()
	
	--
	local function onKeyPressed(key_code, event)
		self.PressTbl[key_code] = true
		for callback, _ in pairs(self._press_listeners) do
			callback(key_code, event)
		end
	end
	local function onKeyReleased(key_code, event)
		self.PressTbl[key_code] = false
		for callback, _ in pairs(self._release_listeners) do
			callback(key_code, event)
		end
	end
	local evt_layer = cc.Layer:create()
	cur_scene:addChild(evt_layer, const.LAYER_TOPEST+1)
	local listener = cc.EventListenerKeyboard:create()
	listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
	evt_layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, evt_layer)
	
	--[[
	evt_layer:registerScriptHandler(function(state)
		if state == "exitTransitionStart" then
			self:ClearAllListener()
		end
	end)
	]]--
end

function ClearAllListener(self)
	self.PressTbl = {}
	self._press_listeners = {} -- new_weak_table("kv")
	self._release_listeners = {} -- new_weak_table("kv")
end

function AddKeyPressListener(self, OnKeyPressed)
	if not self._press_listeners then 
		assert(false, "注册键盘事件失败")
		return 
	end
	if device.platform ~= "windows" then return end
	self._press_listeners[OnKeyPressed] = true
end

function AddKeyReleaseListener(self, OnKeyReleased)
	if not self._release_listeners then 
		assert(false, "注册键盘事件失败")
		return 
	end 
	if device.platform ~= "windows" then return end
	self._release_listeners[OnKeyReleased] = true
end

function IsKeyPressed(self, key_code)
	return self.PressTbl[key_code]
end

function IsTheseKeyPressed(self, key_code_list)
	for _, key_code in ipairs(key_code_list) do 
		if not self.PressTbl[key_code] then
			return false 
		end
	end
	return true 
end
