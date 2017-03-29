----------------
-- 任务对象
----------------
module("ai",package.seeall)

local function DefaultChecker(bt_result)
	if bt_result == BT_SUCCESS then 
		return BT_TASK_STATE.SUCCESS
	elseif bt_result == BT_FAIL then
		return BT_TASK_STATE.FAIL
	end
end

clsBtTask = class("clsBtTask", clsCoreObject)

--@param	TaskId			#int		任务ID
--@param	ai_name			#string		ai名，对应ai_rules中定义的行为树类名
--@param	theOwner		#int		执行者
--@param	iInterval		#string		执行周期
--@param	funcCheckFinish	#int		检查任务是否结束的接口
--@param	OnTaskOver		#string		任务结束时的回调
function clsBtTask:ctor(TaskId, ai_name, theOwner, iInterval, funcCheckFinish, OnTaskOver)
	clsCoreObject.ctor(self)
	assert(TaskId~=nil, "TaskId不可为空")
	assert(theOwner, "任务所属者不可为空")
	assert(type(funcCheckFinish)=="function" or funcCheckFinish==nil)
	assert(type(OnTaskOver)=="function" or OnTaskOver==nil)
	self._TaskId = TaskId
	self._mOwner = theOwner
	self._BtStrategy = ClsBTFactory.GetInstance():GetBT(ai_name)
	self._Interval = iInterval or 0
	self._funcCheckFinish = funcCheckFinish or DefaultChecker
	self._OnTaskOver = OnTaskOver
	self._iPriority = 0
	
	self:_set_cur_state(BT_TASK_STATE.WAITING)
end

function clsBtTask:dtor()
	self:DestroyTimer("run_task")
	if self._BtStrategy then
		self._BtStrategy:Interrupt(self._mOwner)
	end
	self._mOwner = nil
	self._BtStrategy = nil
	self._funcCheckFinish = nil
	self._OnTaskOver = nil
end

function clsBtTask:_set_cur_state(iCurState)
	print("clsBtTask._set_cur_state", self._mOwner:GetUid(), self._BtStrategy.__cname, self._CurState, iCurState)
	self._CurState = iCurState
end

-- 设置任务优先级
function clsBtTask:SetPriority(iPriority)
	if self._iPriority == iPriority then return end
	self._iPriority = iPriority
	self._mOwner:GetAiBrain():AjustSerialList()
end

-- 任务结束时调用
function clsBtTask:OnOver(TaskResult)
	assert(TaskResult==BT_TASK_STATE.SUCCESS or TaskResult==BT_TASK_STATE.FAIL)
	self:DestroyTimer("run_task")
	self:_set_cur_state(TaskResult)
	
	local OnTaskOver = self._OnTaskOver
	self._OnTaskOver = nil
	
	print("本任务结束：", TaskResult, self._TaskId, self:GetBtName(), self._mOwner:GetUid())
	
	self._mOwner:GetAiBrain():RemoveTaskObj(self)
	
	if OnTaskOver then
		OnTaskOver(TaskResult, self._TaskId, self:GetBtName(), self._mOwner)
	end
end

function clsBtTask:CallCheck(btResult)
	local TaskResult = self._funcCheckFinish(btResult)
	if TaskResult==BT_TASK_STATE.SUCCESS or TaskResult==BT_TASK_STATE.FAIL then
		self:_set_cur_state(TaskResult)
		self:DestroyTimer("run_task")
		self:OnOver(TaskResult)
	end
end

-- 执行本任务
function clsBtTask:Execute()
	if self:IsOver() then 
		utils.TellMe("该任务已经执行完毕")
		assert(not self:HasTimer("run_task"))
		return
	end
	if self._CurState == BT_TASK_STATE.RUNNING then 
		utils.TellMe("该任务已经在执行中 "..self._CurState)
		assert(self:HasTimer("run_task"), "哧溜："..self:GetBtName()..self._CurState)
		return
	end
	
	print("执行本任务：", self._TaskId, self:GetBtName())
	self:_set_cur_state(BT_TASK_STATE.RUNNING)
	
	local onfinish = function(objBT, result)
		print("监听到AI结果", self._TaskId, objBT.__cname, result)
		self:CallCheck(result)
	end
	
	self:CreateTimerLoop("run_task", self._Interval, function()
		if CanThink(self._mOwner) and not self:IsOver() then
			local btResult = self._BtStrategy:Execute(self._mOwner)
			self:CallCheck(btResult)
		end
	end)
end

-- 打断本任务，只是打断挂起，并未结束掉
function clsBtTask:Interrupt()
	print("打断本任务：", self._TaskId, self:GetBtName())
	self:DestroyTimer("run_task")
	if self._BtStrategy then
		self._BtStrategy:Interrupt(self._mOwner)
	end
	print("滴滴滴滴滴", self:GetBtName())
	self:_set_cur_state(BT_TASK_STATE.WAITING)
end

-- 挂起本任务
function clsBtTask:Pause(bPause)
	self.bPause = bPause
	self:PauseTimer("run_task", bPause)
end

-- 绑定另一个行为树，相当于采用另一个策略完成本任务
function clsBtTask:ReBindBTtree(ai_name)
	if self._BtStrategy then
		self._BtStrategy:Interrupt(self._mOwner)
	end
	self._BtStrategy = ClsBTFactory.GetInstance():GetBT(ai_name)
end


------------ getter --------------------
	
function clsBtTask:GetPriority()
	return self._iPriority
end

function clsBtTask:GetTaskId()
	return self._TaskId
end

function clsBtTask:GetOwner()
	return self._mOwner
end

function clsBtTask:GetBtName()
	return ClsBTFactory.GetInstance():GetBtName(self._BtStrategy)
end

function clsBtTask:GetCurState()
	return self._CurState 
end

function clsBtTask:IsOver()
	return self._CurState==BT_TASK_STATE.SUCCESS or self._CurState==BT_TASK_STATE.FAIL
end

function clsBtTask:IsRunning()
	return self._CurState==BT_TASK_STATE.RUNNING
end

function clsBtTask:IsPaused()
	return self.bPause
end
