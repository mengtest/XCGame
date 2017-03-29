---------------------------
-- set和get方法注册
-- 计时器
---------------------------
local _Formator = string.format


clsCoreObject = class("clsCoreObject", clsEventSource)

-- 简化set和get函数的写法
function clsCoreObject:_reg_var(groupID, VarName, CheckFuncer)
	assert(type(CheckFuncer)=="function", "未定义数据类型检查方法")
	
	self._VarDefTable_ = self._VarDefTable_ or {}
	self._VarDefTable_[VarName] = CheckFuncer
	
	--Get接口
	assert(not self[_Formator("Get%s",VarName)], _Formator("函数被覆盖: Get%s",VarName))
	self[_Formator("Get%s",VarName)] = function(this)
		return this[groupID][VarName]
	end
	
	--Set接口，值变化时分发事件
	assert(not self[_Formator("Set%s",VarName)], _Formator("函数被覆盖: Set%s",VarName))
	self[_Formator("Set%s",VarName)] = function(this, Value)
		self._VarDefTable_[VarName](Value)
		
		local old_value = this[groupID][VarName]
		this[groupID][VarName] = Value
		
		if old_value == Value then return end
		this:FireEvent(VarName, Value, old_value)
	end
	
	--Set接口，不分发消息
	assert(not self[_Formator("Set%sSilent",VarName)], _Formator("函数被覆盖: Set%sSilent",VarName))
	self[_Formator("Set%sSilent",VarName)] = function(this, Value)
		self._VarDefTable_[VarName](Value)
		
		this[groupID][VarName] = Value
	end
	
	-- 注册事件名
	self:RegisterEventType(VarName)
end

-- 注册存盘属性，参与属性序列化操作,会影响到最终obj的存盘数据结构
function clsCoreObject:RegSaveVar(VarName, CheckFuncer)
	self.__InitSaveVar = true
	self:_reg_var(1, VarName, CheckFuncer)
end

--[[
-- 注册临时属性，参与属性序列化行为，生命周期为在线
function clsCoreObject:RegTmpOnlineVar(VarName, CheckFuncer)
	self.__InitTempOnlineVar = true
	self:_reg_var(0, VarName, CheckFuncer)
end

-- 注册临时属性，不参与属性序列化操作，生命周期为当前所在场景
function clsCoreObject:RegTmpVar(VarName, CheckFuncer)
	self.__InitTempVar = true
	self:_reg_var(-1, VarName, CheckFuncer)
end

-- 注册临时属性，不需要参与序列化行为，当 self[1] 发生变化时候，该列表会自动清空
function clsCoreObject:RegTmpResetVar(VarName, CheckFuncer)
	self.__InitTempResetVar = true
	self:_reg_var(-2, VarName, CheckFuncer)
end
]]--

-- 根据配置文件，生成Set和Get方法
function clsCoreObject:InitBySettingFile(filepath, key_name, attr_list)
	local CLIENT_CFG = setting.Get(filepath)
	assert(CLIENT_CFG, "读取配置文件失败："..filepath)
	self:InitByClientCfg(CLIENT_CFG, key_name, attr_list)
end

function clsCoreObject:InitByClientCfg(CLIENT_CFG, key_name, attr_list)
	assert(CLIENT_CFG, "无效的配置信息")
	assert(self["Get"..key_name], "无效的键："..key_name)
	assert(table.is_array(attr_list), "无效的attr_list")
	if not CLIENT_CFG then return end
	
	self._SETTING_INFO = CLIENT_CFG
	self._KEY_NAME = key_name
	self._ATTR_LIST = attr_list
	
	for _, info in ipairs(attr_list) do
		self:RegSaveVar(info[1], info[2])
	end
	
	-- 重写Set方法
	local VarName = key_name
	
	self[_Formator("Set%s",VarName)] = function(this, Value)
		self._VarDefTable_[VarName](Value)
		
		local old_value = this[1][VarName]
		if old_value == Value then return end
		
		this[1][VarName] = Value
		
		local CfgInfo = self._SETTING_INFO[Value]
		for _, AttrInfo in ipairs(attr_list) do
			this:SetAttr(AttrInfo[1], table.clone(CfgInfo[AttrInfo[1]]))
		end
		
		this:FireEvent(VarName, Value, old_value)
	end
	
	self[_Formator("Set%sSilent",VarName)] = function(this, Value)
		self._VarDefTable_[VarName](Value)
		
		local old_value = this[1][VarName]
		if old_value == Value then return end
		
		this[1][VarName] = Value
		
		local CfgInfo = self._SETTING_INFO[Value]
		for _, AttrInfo in ipairs(attr_list) do
			this:SetAttr(AttrInfo[1], table.clone(CfgInfo[AttrInfo[1]]))
		end
	end
end



function clsCoreObject:ctor()
	clsEventSource.ctor(self)
	
	if self.__InitSaveVar then self[1] = {} end
	if self.__InitTempOnlineVar then self[0] = {} end
	if self.__InitTempVar then self[-1] = {} end
	if self.__InitTempResetVar then self[-2] = {} end
	
	self._tTimerList = {}			--存放计时器
end

function clsCoreObject:dtor()
	g_EventMgr:DelListener(self)
	g_EventMgr:DelListener(self.__cname)
	self:DestroyAllTimer()
end

--------------------------
-- 属性
--------------------------
function clsCoreObject:GetAttr(VarName)
	assert(self._VarDefTable_[VarName], "未定义的变量名："..VarName)
	return self[1][VarName]
end
	
function clsCoreObject:SetAttr(VarName, Value)
	self._VarDefTable_[VarName](Value)
	
	local old_value = self[1][VarName]
	if old_value == Value then return end
	
	self[1][VarName] = Value
	
	if VarName == self._KEY_NAME then
		local CfgInfo = self._SETTING_INFO[Value]
		local attr_list = self._ATTR_LIST
		for _, AttrInfo in ipairs(attr_list) do
			self:SetAttr(AttrInfo[1], table.clone(CfgInfo[AttrInfo[1]]))
		end
	end
	
	self:FireEvent(VarName, Value, old_value)
end
	
function clsCoreObject:SetAttrSilent(VarName, Value)
	self._VarDefTable_[VarName](Value)
	
	local old_value = self[1][VarName]
	if old_value == Value then return end
	
	self[1][VarName] = Value
	
	if VarName == self._KEY_NAME then
		local CfgInfo = self._SETTING_INFO[Value]
		local attr_list = self._ATTR_LIST
		for _, AttrInfo in ipairs(attr_list) do
			self:SetAttr(AttrInfo[1], table.clone(CfgInfo[AttrInfo[1]]))
		end
	end
end
	
function clsCoreObject:BatchSetAttr(tInfo)
	if tInfo == nil then return end
	for k, v in pairs(tInfo) do
		self:SetAttr(k, v)
	end
end

--------------------------
-- 计时器
--------------------------
function clsCoreObject:CreateTimerDelay(tmKey, iDelay, handleFunc)
	assert(not self._tTimerList[tmKey], "该计时器名已被使用: "..tmKey)
	self._tTimerList[tmKey] = KE_SetTimeout(iDelay, handleFunc)
end

function clsCoreObject:CreateTimerLoop(tmKey, iInterval, handleFunc)
	assert(not self._tTimerList[tmKey], "该计时器名已被使用: "..tmKey)
	self._tTimerList[tmKey] = KE_SetInterval(iInterval, handleFunc)
end

function clsCoreObject:CreateAbsTimerDelay(tmKey, iDelay, handleFunc)
	assert(not self._tTimerList[tmKey], "该计时器名已被使用: "..tmKey)
	self._tTimerList[tmKey] = KE_SetAbsTimeout(iDelay, handleFunc)
end

function clsCoreObject:CreateAbsTimerLoop(tmKey, iInterval, handleFunc)
	assert(not self._tTimerList[tmKey], "该计时器名已被使用: "..tmKey)
	self._tTimerList[tmKey] = KE_SetAbsInterval(iInterval, handleFunc)
end

function clsCoreObject:DestroyTimer(tmKey)
	KE_KillTimer(self._tTimerList[tmKey])
	self._tTimerList[tmKey] = nil
end

function clsCoreObject:DestroyAllTimer()
	for tmKey, tm in pairs(self._tTimerList) do
		KE_KillTimer(self._tTimerList[tmKey])
	end
	self._tTimerList = {}
end

function clsCoreObject:PauseTimer(tmKey, bPause)
	if self._tTimerList[tmKey] then
		KE_PauseTimer(self._tTimerList[tmKey], bPause)
	end
end

function clsCoreObject:PauseAllTimer(bPause)
	for tmKey, tm in pairs(self._tTimerList) do
		self:PauseTimer(tmKey, bPause)
	end
end

function clsCoreObject:HasTimer(tmKey)
	return self._tTimerList[tmKey]
end

