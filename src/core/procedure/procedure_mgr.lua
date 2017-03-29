-------------------
-- 串行执行管理器
-------------------
module("procedure",package.seeall)

ClsProcedureMgr = class("ClsProcedureMgr",clsCoreObject)
ClsProcedureMgr.__is_singleton = true

function ClsProcedureMgr:ctor()
	clsCoreObject.ctor(self)
	
	self._CurProcedure = nil
	self._ProcedureList = {}
	
	g_EventMgr:AddListener(self, "LEAVE_SCENE", function()
		KE_SafeDelete(self._CurProcedure)
		self._CurProcedure = nil
		
		local Len = #self._ProcedureList
		for i=Len,1,-1 do
			if self._ProcedureList[i]:GetDelWhenChgScene() then
				KE_SafeDelete(self._ProcedureList[i])
				table.remove(self._ProcedureList,i)
			end
		end
	end)
	g_EventMgr:AddListener(self, "ENTER_SCENE", function()
		self:StepForward()
	end)
end

function ClsProcedureMgr:dtor()
	
end

function ClsProcedureMgr:PushBack(oProcedure)
	table.insert(self._ProcedureList, oProcedure)
	
	table.quick_sort(self._ProcedureList, function(a,b)
		return a:GetPriority() >= b:GetPriority()
	end)
	
	self:StepForward()
end

function ClsProcedureMgr:PushFirst(oProcedure)
	table.insert(self._ProcedureList,1,oProcedure)
	
	table.quick_sort(self._ProcedureList, function(a,b)
		return a:GetPriority() >= b:GetPriority()
	end)
	
	self:StepForward()
end

function ClsProcedureMgr:StepForward()
	if #self._ProcedureList <= 0 then 
		print("串行播放失败：队列已空")
		return 
	end
	if self._CurProcedure then 
		print("串行播放失败：正在播放中")
		return 
	end
	
	if ClsSceneMgr.GetInstance():IsSwitching() then 
		print("串行播放失败：等待场景切换完成")
		KE_SetTimeout(1, function()
			self:StepForward()
		end)
		return
	end
	
	for i, oProcedure in ipairs(self._ProcedureList) do
		if oProcedure:GetBindScene() then
			if oProcedure:GetBindScene() == ClsSceneMgr.GetInstance():GetCurSceneName() then
				self._CurProcedure = table.remove(self._ProcedureList, i)
				self._CurProcedure:OnStart()
				break
			end
		else
			self._CurProcedure = table.remove(self._ProcedureList, i)
			self._CurProcedure:OnStart()
			break
		end
	end
end

function ClsProcedureMgr:StopCurProcedure()
	if self._CurProcedure then
		self:OnProcedureEnd(self._CurProcedure)
	end
end

function ClsProcedureMgr:OnProcedureEnd(oProcedure)
	assert(oProcedure == self._CurProcedure)
	KE_SafeDelete(oProcedure)
	self._CurProcedure = nil
	
	self:StepForward()
end

function ClsProcedureMgr:DumpDebugInfo()
	print("当前播放节点：", self._CurProcedure or "nil", "剩余节点数量：", #self._ProcedureList)
end
