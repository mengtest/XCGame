----------------
-- 添加任务 执行任务 执行完毕后处理
-- 任务与行为树为一对多关系：相当于采用不同的策略完成某任务
-- 有些行为是可以并行的（如一边唱歌一边跳舞），有些是互斥的（如一边跑步一边打坐）
----------------
module("ai",package.seeall)

clsAiBrain = class("clsAiBrain", clsCoreObject)

function clsAiBrain:ctor(theOwner)
	clsCoreObject.ctor(self)
	assert(theOwner)
	
	self.mOwner = theOwner
	self.mBlackBoard = clsBlackBoard.new(theOwner)
	self.tSerialList = {}
	self.tAllTaskById = new_weak_table("v")
	
	self.tBtList = {}
	self:_init_listeners()
end

function clsAiBrain:dtor()
	for _, objTask in pairs(self.tAllTaskById) do
		KE_SafeDelete(objTask)
	end
	self.tSerialList = nil
	self.tAllTaskById = nil
	
	if self.mBlackBoard then
		KE_SafeDelete(self.mBlackBoard)
		self.mBlackBoard = nil 
	end
end

function clsAiBrain:GetBlackBoard()
	return self.mBlackBoard
end

-------------------------------------------------

--[[
TaskInfo = {
	Id = 10001,
	Desc = "对话#G水镜先生#n",
	AiCmdStr = "bt_talk_to,-1,100101",
}
]]--

function clsAiBrain:AjustSerialList()
	local CurFirstBt = self.tSerialList[1]
	if not CurFirstBt then return end
	table.sort(self.tSerialList, function(a,b) return a:GetPriority() > b:GetPriority() end)
	
	local Cnt = #self.tSerialList
	for i=2, Cnt do
		self.tSerialList[i]:Interrupt()
	end
	self.tSerialList[1]:Execute()
	
	self:DumpDebugInfo()
end

function clsAiBrain:AddSerialTask(objTask)
	assert(not self.tAllTaskById[objTask:GetTaskId()], "已经添加过该任务："..objTask:GetTaskId())
	table.insert(self.tSerialList, objTask)
	self.tAllTaskById[objTask:GetTaskId()] = objTask
	print("添加任务",objTask:GetTaskId(),objTask:GetBtName(),self:GetTaskCount())
	
	self:AjustSerialList()
end

function clsAiBrain:AddSerialTaskFirst(objTask)
	assert(not self.tAllTaskById[objTask:GetTaskId()], "已经添加过该任务："..objTask:GetTaskId())
	table.insert(self.tSerialList, 1, objTask)
	self.tAllTaskById[objTask:GetTaskId()] = objTask
	print("插入任务",objTask:GetTaskId(),objTask:GetBtName(),self:GetTaskCount())
	
	self:AjustSerialList()
end

function clsAiBrain:RemoveTaskObj(objTask)
	local TaskId = objTask:GetTaskId()
	self:RemoveTaskById(TaskId)
end

function clsAiBrain:RemoveTaskById(TaskId)
	if self.tAllTaskById[TaskId] then
		KE_SafeDelete(self.tAllTaskById[TaskId])
		self.tAllTaskById[TaskId] = nil
		print("移除任务", TaskId)
		
		for i, task_obj in ipairs(self.tSerialList) do
			if task_obj:GetTaskId() == TaskId then
				table.remove(self.tSerialList, i)
				if self.tSerialList[1] then
					print("自动取下一条任务", self.tSerialList[1]:GetTaskId())
					self.tSerialList[1]:Execute()
				end
				return
			end
		end
	end
end

------------------------------------------------

function clsAiBrain:GetTaskCount()
	return table.size(self.tAllTaskById)
end

function clsAiBrain:GetTaskById(TaskId)
	return self.tAllTaskById[TaskId]
end

function clsAiBrain:DumpDebugInfo()
	for i, task_obj in ipairs(self.tSerialList) do
		print( string.format("Idx:%d  TaskId:%s  BtName:%s State:%s IsOver:%s", 
						i, 
						task_obj:GetTaskId(), 
						task_obj:GetBtName(), 
						task_obj:GetCurState(),
						task_obj:IsOver()
			))
	end
end

-----------------
--
-----------------

local function funcCheckFinish()
	local InstFight = fight.ClsFightSystem.GetInstance()
	if not InstFight:IsCombating() then
		if InstFight:GetFightResult().bWin then
			return BT_TASK_STATE.SUCCESS
		else
			return BT_TASK_STATE.FAIL
		end
	end
end

-- 监听事件，触发AI
function clsAiBrain:_init_listeners()
	g_EventMgr:AddListener(self, "START_COMBAT", function()
		self:OnAiEvent(AI_EVENT.START_COMBAT)
	end)
	g_EventMgr:AddListener(self, "END_COMBAT", function()
		self:OnAiEvent(AI_EVENT.END_COMBAT)
	end)
end

function clsAiBrain:OnAiEvent(evtName)
	local fight_ai = self.mOwner:GetProp("fight_ai")
	assert(fight_ai,"未定义fight_ai，请检查配置: "..self.mOwner:GetProp("TypeId"))
	
	local info = ParseAiCmdStr(fight_ai) or {}
	
	if evtName == AI_EVENT.START_COMBAT then
		local ai_name = info.ai_name
		local interval = info.interval or 5
		local arglist = info.arglist
		local objTask = clsBtTask.new("fight_ai", ai_name, self.mOwner, ai_interval, funcCheckFinish)
		self:AddSerialTask(objTask)
	elseif evtName == AI_EVENT.END_COMBAT then
		self:RemoveTaskById("fight_ai")
	end
end
