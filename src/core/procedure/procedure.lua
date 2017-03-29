-------------------
-- 节点
-------------------
module("procedure",package.seeall)

clsProcedure = class("clsProcedure",clsCoreObject)

clsProcedure:RegSaveVar("Priority",TYPE_CHECKER.INT) 
clsProcedure:RegSaveVar("Duration",TYPE_CHECKER.INT_NIL)
clsProcedure:RegSaveVar("DelWhenChgScene",TYPE_CHECKER.BOOL)
clsProcedure:RegSaveVar("CurState", TYPE_CHECKER.INT)
clsProcedure:RegSaveVar("BindScene", TYPE_CHECKER.STRING_NIL)

function clsProcedure:ctor(ProcFunc, EndCallback)
	clsCoreObject.ctor(self)
	assert(is_function(ProcFunc))
	assert(is_function(EndCallback) or EndCallback==nil)
	
	self._ProcFunc = ProcFunc
	self._EndCallback = EndCallback
	
	self:SetCurState(1)
	self:SetPriority(0)
end

function clsProcedure:dtor()
	self:DestroyTimer("tm_delay")
	self:OnEnd()
	self._ProcFunc = nil
	self._EndCallback = nil
end

function clsProcedure:OnStart()
	self:SetCurState(2)
	
	self._ProcFunc()
	self._ProcFunc = nil
	
	if self:GetDuration() then
		self:CreateTimerDelay("tm_delay", self:GetDuration(), function()
			self:DestroyTimer("tm_delay")
			self:OnEnd()
		end)
	end
end

function clsProcedure:OnEnd()
	self:DestroyTimer("tm_delay")
	if self:GetCurState()==3 then return end
	self:SetCurState(3)
	
	if self._EndCallback then
		self._EndCallback()
		self._EndCallback = nil
	end 
	
	ClsProcedureMgr.GetInstance():OnProcedureEnd(self)
end
