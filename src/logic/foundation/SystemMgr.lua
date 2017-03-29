--------------------
-- 功能系统管理器
--------------------
ClsSystemMgr = class("ClsSystemMgr", clsCoreObject)
ClsSystemMgr.__is_singleton = true

ClsSystemMgr:RegisterEventType("e_open_new_system")		--新系统开启
ClsSystemMgr:RegisterEventType("e_enter_system")		--进入模块
ClsSystemMgr:RegisterEventType("e_leave_system")		--离开模块

function ClsSystemMgr:ctor()
	clsCoreObject.ctor(self)
	self._tOpenedList = {}
	self._CountInfo = {}		--统计进入某模块的次数
end

function ClsSystemMgr:dtor()
	
end

function ClsSystemMgr:InitOpenedList(openlist)
	self._tOpenedList = openlist or {}
end

function ClsSystemMgr:IsSystemOpened(sSystemKey)
	assert(setting.T_system_cfg[sSystemKey], "未配置的系统："..sSystemKey)
	return self._tOpenedList[sSystemKey] and self:CanEnterSystem(sSystemKey)
end

function ClsSystemMgr:OpenNewSystem(sSystemKey)
	assert(setting.T_system_cfg[sSystemKey], "未配置的系统："..sSystemKey)
	if not self:CanEnterSystem(sSystemKey) then
		log_error("并没有开启", sSystemKey)
		return
	end
	self._tOpenedList[sSystemKey] = true
	self:FireEvent("e_open_new_system", sSystemKey)
end

function ClsSystemMgr:CanEnterSystem(sSystemKey)
	assert(setting.T_system_cfg[sSystemKey], "未配置的系统："..sSystemKey)
	return api.CheckConditions(setting.T_system_cfg[sSystemKey].open_condition)
end

function ClsSystemMgr:EnterSystem(sSystemKey, ...)
	assert(setting.T_system_cfg[sSystemKey], "未配置的系统："..sSystemKey)
	if not self:CanEnterSystem(sSystemKey) then
		print("进入系统失败，尚未开启", sSystemKey)
		return false
	end
	
	local EnterFunc = setting.T_system_cfg[sSystemKey].enter_func
	local wnd = EnterFunc(...)
	
	if not wnd then
		print("进入系统失败，尚未实现", sSystemKey)
		return false
	end
	
	print("进入系统", sSystemKey)
	wnd:AddScriptHandler(const.CORE_EVENT.cleanup,function()
		print("离开系统", sSystemKey)
		self:FireEvent("e_leave_system", sSystemKey)
	end)
	
	self._CountInfo[sSystemKey] = self._CountInfo[sSystemKey] or 0
	self._CountInfo[sSystemKey] = self._CountInfo[sSystemKey] + 1
	
	self:FireEvent("e_enter_system", sSystemKey)
	
	return true
end

function ClsSystemMgr:DumpDebugInfo()
	for sSystemKey, Cnt in pairs(self._CountInfo) do
		print(sSystemKey, Cnt)
	end
end
