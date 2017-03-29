---------------------
-- 事件
---------------------
local EVENT_ID = 0
local function AllocEventId()
	EVENT_ID = EVENT_ID + 1
	return EVENT_ID
end

clsEventSource = class("clsEventSource")

function clsEventSource:RegisterEventType(evt_name)
	assert(type(evt_name)=="string" or type(evt_name)=="number")
	self._tAllEventType = self._tAllEventType or {}
	assert(not self._tAllEventType[evt_name], string.format("重复注册相同类型事件: %s",evt_name))
	self._tAllEventType[evt_name] = true
end

function clsEventSource:ctor()
	self._isFireing = false			-- 是否正在fire事件
	self._tAllEventByName = {}
	self._tAllEventByKey = {}
end

function clsEventSource:dtor()
	self:ClearAllEvents()
	self._tAllEventByName = nil
	self._tAllEventByKey = nil
end

function clsEventSource:FireEvent(evt_name, ...)
	assert(self._tAllEventType[evt_name], "未定义事件类型: "..evt_name)
	local listener_list = self._tAllEventByName[evt_name]
	if not listener_list then return end
	--------------------
	-- begin fire 
	self._isFireing = evt_name
	for _, EventObj in pairs(listener_list) do 
		EventObj[2](...)
	end
	self._isFireing = false
	-- end fire
	--------------------
end

function clsEventSource:IsEventExist(evt_name, handle_func)
	local listener_list = self._tAllEventByName[evt_name]
	if listener_list then
		for EventId, EventObj in pairs(listener_list) do
			if EventObj[2] == handle_func then
				return EventId 
			end
		end
	end 
end

function clsEventSource:AddListener(EventKey, evt_name, handle_func, bForceCall)
	assert(self._tAllEventType[evt_name], "未定义事件类型: "..evt_name)
	assert(is_function(handle_func), "回调函数错误")
	assert(EventKey~=nil)
	
--	local Info = debug.getinfo(2)
--	print("AddListener", evt_name, Info.short_src, Info.currentline)
	
	if self:IsEventExist(evt_name, handle_func) then
		assert( false, string.format("【Error:】event is already exist: %s",evt_name) )
		return 
	end
	
	local EventId = AllocEventId()
	local EventObj = { evt_name, handle_func, EventId, EventKey }
	
	self._tAllEventByName[evt_name] = self._tAllEventByName[evt_name] or {}
	self._tAllEventByName[evt_name][EventId] = EventObj
	
	self._tAllEventByKey[EventKey] = self._tAllEventByKey[EventKey] or {}
	self._tAllEventByKey[EventKey][EventId] = EventObj
	
	if bForceCall then handle_func() end
end

function clsEventSource:DelListener(EventKey)
	if EventKey == nil then return end
	local infolist = self._tAllEventByKey[EventKey]
	if not infolist then return end
	
	for EventId, EventObj in pairs(infolist) do 
		self._tAllEventByName[ EventObj[1] ][EventId] = nil
	end
	
	self._tAllEventByKey[EventKey] = nil
end

function clsEventSource:ClearAllEvents()
	self._tAllEventByName = {}
	self._tAllEventByKey = {}
end

function clsEventSource:ClearEventByName(evt_name)
	local infolist = self._tAllEventByName[evt_name]
	if not infolist then return end
	
	self._tAllEventByName[evt_name] = nil
	
	for EventId, EventObj in pairs(infolist) do
		local EventKey = EventObj[4]
		self._tAllEventByKey[EventKey][EventId] = nil
		if table.is_empty(self._tAllEventByKey[EventKey]) then
			self._tAllEventByKey[EventKey] = nil 
		end
	end
end

