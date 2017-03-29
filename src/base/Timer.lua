-------------------------
-- 计时器。 采用了对象池
-------------------------
local clsTimerBase = class("clsTimerBase")

function clsTimerBase:ctor(iID, iInterval, func, bTickOnce)
	self.Uid = iID
	self._iInterval = iInterval
	self._passedTime = 0
	self._bPause = false
	self._bStoped = false
	
	if bTickOnce then 
		self._func = function()
			func()
			self._bStoped = true
			return true
		end
	else
		self._func = func
	end
end

function clsTimerBase:dtor()
	self._bStoped = true
	self._func = nil
end

function clsTimerBase:GetUid()
	return self.Uid
end

function clsTimerBase:Pause(bPause)
	if bPause == nil then bPause = true end
	self._bPause = bPause
end

function clsTimerBase:Stop()
	self._bStoped = true
	self._func = nil
end

---------------------------------------------

-- 基于帧
local clsTimer = class("clsTimer", clsTimerBase)

function clsTimer:ctor(iID, iInterval, func, bTickOnce)
	clsTimerBase.ctor(self, iID, iInterval, func, bTickOnce)
end

function clsTimer:TickPerFrame(deltaTime)
	if self._bStoped then 
		self._func = nil
		return true 
	end
	
	if self._bPause then return end
	
	self._passedTime = self._passedTime + 1
	
	if self._passedTime >= self._iInterval then
		self._passedTime = 0
		return self._func()
	end
end


-- 基于秒
local clsAbsTimer = class("clsAbsTimer", clsTimerBase)

function clsAbsTimer:ctor(iID, iInterval, func, bTickOnce)
	clsTimerBase.ctor(self, iID, iInterval, func, bTickOnce)
end

function clsAbsTimer:TickPerFrame(deltaTime)
	if self._bStoped then 
		self._func = nil
		return true 
	end
	
	if self._bPause then return end
	
	self._passedTime = self._passedTime + deltaTime
	
	if self._passedTime >= self._iInterval then
		self._passedTime = self._passedTime - self._iInterval
		return self._func()
	end
end

--------------------------分割线--------------------------

local _gTimerID = 0
local OP_ADD = 1
local OP_DEL = 2
local InstTmrPool = ClsObjectPool.new(clsTimer, 4)
local InstAbsTmrPool = ClsObjectPool.new(clsAbsTimer, 4)

ClsTimerMgr = class("ClsTimerMgr")
ClsTimerMgr.__is_singleton = true

function ClsTimerMgr:ctor()
	self._iPassedFrame = 0		--帧流逝
	self._iPassedTime = 0		--时间流逝
	
	self._isUpdating = false
	self._tAllTimerById = new_weak_table("v")
	self._tTimerList = {}
	self._tPrepareList_ = {}
end

function ClsTimerMgr:dtor()
	self._isUpdating = true
	self._tTimerList = nil
	self._tPrepareList_ = nil
	self._tAllTimerById = nil
end

function ClsTimerMgr:GetPassedFrame() return self._iPassedFrame end
function ClsTimerMgr:GetPassedTime() return self._iPassedTime end

--@每帧更新
function ClsTimerMgr:FrameUpdate(deltaTime)
	self._iPassedFrame = self._iPassedFrame + 1			--帧流逝
--	self._iPassedTime = self._iPassedTime + deltaTime	--时间流逝
	
	-----------------------------
	--begin tick
	self._isUpdating = true 
	
	local needDels = {}
	local timer_list = self._tTimerList
	for _, Tmr in ipairs(timer_list) do
		if Tmr:TickPerFrame(deltaTime) then
			needDels[#needDels+1] = Tmr
		end
	end
	for _, tmDel in ipairs(needDels) do
		self:_DelTimer_(tmDel:GetUid())
	end
	needDels = nil
	
	self._isUpdating = false 
	--end tick
	-----------------------------
	
	for _, data in ipairs(self._tPrepareList_) do
		if data[1] == OP_ADD then
			self:_AddTimer_(data[2]:GetUid(), data[2])
		else
			self:_DelTimer_(data[2])
		end
	end
	self._tPrepareList_ = {}
end

function ClsTimerMgr:_has_timer(func)
	return false 
end

function ClsTimerMgr:_AddTimer_(tmID, Tmr)
	assert(not self:_has_timer(Tmr._func), "【错误】重复添加相同计时器")
	table.insert(self._tTimerList, Tmr)
	self._tAllTimerById[tmID] = Tmr 
end

function ClsTimerMgr:_DelTimer_(tmID)
	if self._tAllTimerById[tmID] then
		self._tAllTimerById[tmID]:delete()
		ClsObjectPool.FreeObject(self._tAllTimerById[tmID])
		
		for i, Tmr in ipairs(self._tTimerList) do
			if Tmr:GetUid() == tmID then
				table.remove(self._tTimerList, i)
				break 
			end
		end
		self._tAllTimerById[tmID] = nil
	end
end	

-- 创建计时器（基于帧）
function ClsTimerMgr:CreateTimer(iInterval, func, bTickOnce)
	assert(iInterval>=0 and is_function(func))
	_gTimerID = _gTimerID + 1
	
	local Tmr = InstTmrPool:AllocObject()
	Tmr:ctor(_gTimerID, iInterval, func, bTickOnce)
	
	if self._isUpdating then
		table.insert(self._tPrepareList_, {OP_ADD, Tmr})
	else
		self:_AddTimer_(_gTimerID, Tmr)
	end

	return _gTimerID
end

-- 创建计时器（基于时间）
function ClsTimerMgr:CreateAbsTimer(iInterval, func, bTickOnce)
	assert(iInterval>=0 and is_function(func))
	_gTimerID = _gTimerID + 1
	
	local Tmr = InstAbsTmrPool:AllocObject()
	Tmr:ctor(_gTimerID, iInterval, func, bTickOnce)
	
	if self._isUpdating then
		table.insert(self._tPrepareList_, {OP_ADD, Tmr})
	else
		self:_AddTimer_(_gTimerID, Tmr)
	end

	return _gTimerID
end

-- 销毁计时器
function ClsTimerMgr:KillTimer(tmID)
	if (tmID == nil) or (not self._tAllTimerById[tmID]) then return end
	self._tAllTimerById[tmID]:Stop()
	if self._isUpdating then
		table.insert(self._tPrepareList_, {OP_DEL, tmID})
	else
		self:_DelTimer_(tmID)
	end
end

-- 暂停计时器
function ClsTimerMgr:PauseTimer(tmID, bPause)
	if tmID == nil then return end
	if self._tAllTimerById[tmID] then
		self._tAllTimerById[tmID]:Pause(bPause)
	end
end

function ClsTimerMgr:DumpDebugInfo()
--	for tmID, Tmr in pairs(self._tAllTimerById) do
--		print( string.format("定时器ID：%d    回调：%s    是否暂停：%s", tmID, tostring(Tmr._func), Tmr._bPause) )
--	end
	InstTmrPool:DumpDebugInfo()
	InstAbsTmrPool:DumpDebugInfo()
	print("计时器数量：",table.size(self._tAllTimerById),#self._tTimerList)
end

-----------------------分割线------------------------------------

local tmrInstance = ClsTimerMgr.GetInstance()

KE_SetInterval = function(iInterval, func) 
	return tmrInstance:CreateTimer(iInterval, func) 
end

KE_SetTimeout = function(iDelay, func) 
	return tmrInstance:CreateTimer(iDelay, func, true) 
end

KE_SetAbsInterval = function(iInterval, func) 
	return tmrInstance:CreateAbsTimer(iInterval, func) 
end

KE_SetAbsTimeout = function(iDelay, func) 
	return tmrInstance:CreateAbsTimer(iDelay, func, true) 
end

KE_KillTimer = function(tmID)
	if not tmID then return end
	tmrInstance:KillTimer(tmID)
end

KE_PauseTimer = function(tmID, bPause)
	if not tmID then return end
	assert(is_boolean(bPause))
	tmrInstance:PauseTimer(tmID, bPause)
end
