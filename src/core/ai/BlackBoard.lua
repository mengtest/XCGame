-----------------------
-- AI记忆中心：AI相关数据存储
-----------------------
module("ai",package.seeall)

clsBlackBoard = class("clsBlackBoard", clsCoreObject)

clsBlackBoard:RegSaveVar("DensestPoint", TYPE_CHECKER.TABLE_NIL)	--敌人最密集的坐标点
clsBlackBoard:RegSaveVar("PatrolPos", TYPE_CHECKER.TABLE_NIL)		--围绕哪个坐标附近巡逻
clsBlackBoard:RegSaveVar("FightTargetId", TYPE_CHECKER.INT_NIL)		--当前攻击对象ID
clsBlackBoard:RegSaveVar("FollowTargetId", TYPE_CHECKER.INT_NIL)	--当前跟随对象ID
clsBlackBoard:RegSaveVar("SkillIndex", TYPE_CHECKER.INT_NIL)		--当前技能Index
clsBlackBoard:RegSaveVar("IsInterrupting", TYPE_CHECKER.BOOL)

clsBlackBoard:RegisterEventType("e_bt_begin")
clsBlackBoard:RegisterEventType("e_bt_end")

function clsBlackBoard:ctor(theOwner)
	clsCoreObject.ctor(self)
	assert(theOwner)
	self.mOwner = theOwner
	self.tRunningNodes = new_weak_table("k")	--所有处于BT_RUNNING状态的节点
end

function clsBlackBoard:dtor()
	self.tRunningNodes = nil
	self.mOwner = nil 
end

function clsBlackBoard:GetOwner() 
	return self.mOwner
end

------------------------------------------------------------------------

-- 行为树开始执行时，标记到BlackBoard
function clsBlackBoard:TellBTBegin(objBT, Callback)
	assert(not objBT:IsRunning(self.mOwner))
	print("开始BT", objBT.__cname)
	self._Callback = Callback
	self:FireEvent("e_bt_begin", objBT)
end 

-- 行为树执行完成时，标记到BlackBoard
function clsBlackBoard:TellBTResult(objBT, result)
	assert(not self:HasRunningNodeOfBt(objBT), "还有执行中的节点")
	print("结束BT", objBT.__cname)
	if self._Callback then 
		self._Callback(self, result) 
		self._Callback = nil 
	end
	self:FireEvent("e_bt_end", objBT, result)
end

-- 行为树被中断时，标记到BlackBoard
function clsBlackBoard:TellBTInterrupt(objBT)
	print("中断BT", objBT.__cname)
	self:TellBTResult(objBT, BT_FAIL)
end

-- 行为树节点开始执行前，标记到BlackBoard
function clsBlackBoard:AddRunningNode(RunningNode)
	assert(ClsBTFactory.GetInstance():HasBT(RunningNode:GetBTTree()))
	assert(not self:GetIsInterrupting(), "中断的时候不可以加节点哦")
	self.tRunningNodes[RunningNode] = BT_RUNNING
end

-- 行为树节点执行完成后，标记到BlackBoard
function clsBlackBoard:DelRunningNode(RunningNode, result)
	assert(ClsBTFactory.GetInstance():HasBT(RunningNode:GetBTTree()))
	assert(result==BT_SUCCESS or result==BT_FAIL)
	self.tRunningNodes[RunningNode] = nil
end

-- 有些行为树节点需要执行一段时间，在其执行完成后，需调用OnDealOver
function clsBlackBoard:ChgRunningNodeState(RunningNode, result)
	assert(ClsBTFactory.GetInstance():HasBT(RunningNode:GetBTTree()))
	assert(self.tRunningNodes[RunningNode] == BT_RUNNING)
	assert(IsValidBtNodeState(result))
	if result==BT_SUCCESS or result==BT_FAIL then
		RunningNode:OnDealOver(self.mOwner, result)
	end
end

------------------------------------------------------------------------

function clsBlackBoard:HasRunningNode(RunningNode)
	return self.tRunningNodes[RunningNode] == BT_RUNNING
end

function clsBlackBoard:HasRunningNodeOfBt(objBT)
	assert(ClsBTFactory.GetInstance():HasBT(objBT))
	for node, _ in pairs(self.tRunningNodes) do
		if node:GetBTTree() == objBT then
			return true
		end
	end
	return false
end

function clsBlackBoard:GetRunningNodesOfBt(objBT)
	assert(ClsBTFactory.GetInstance():HasBT(objBT))
	local running_nodes
	for node, _ in pairs(self.tRunningNodes) do
		if node:GetBTTree() == objBT then
			running_nodes = running_nodes or {}
			table.insert(running_nodes, node)
		end
	end
	return running_nodes
end

function clsBlackBoard:GetRunningBT()
	local running_bts 
	for RunningNode, _ in pairs(self.tRunningNodes) do 
		running_bts = running_bts or {}
		running_bts[RunningNode:GetBTTree()] = true
	end
	return running_bts
end
