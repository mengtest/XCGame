--------------------------------------
-- 行为树基类
--------------------------------------
module("ai",package.seeall)

-- 行为树基类
clsBehaviorTree = class("clsBehaviorTree")

function clsBehaviorTree:ctor()
	self.mRootNode = nil
end

function clsBehaviorTree:dtor()
	if self.mRootNode then
		KE_SafeDelete(self.mRootNode)
		self.mRootNode = nil
	end
	assert(false)
end

-- 设置根节点
function clsBehaviorTree:SetRootNode(objBtNode)
	assert(not self.mRootNode, "只能有一个根节点")
	self.mRootNode = objBtNode
	objBtNode:SetBTTree(self)
end

-- 是否在执行中
function clsBehaviorTree:IsRunning(theOwner)
	return theOwner:GetBlackBoard():HasRunningNodeOfBt(self)
end

-- 执行
function clsBehaviorTree:Execute(theOwner, Callback)
	local final_result
	
	if self:IsRunning(theOwner) then
		final_result = BT_RUNNING
	else
		theOwner:GetBlackBoard():TellBTBegin(self, Callback)
		final_result = self.mRootNode:Execute(theOwner)
	end
	
	assert(IsValidBtNodeState(final_result))
	
	return final_result
end

-- 中断执行
function clsBehaviorTree:Interrupt(theOwner)
	local running_nodes = theOwner:GetBlackBoard():GetRunningNodesOfBt(self)
	if running_nodes then
		theOwner:GetBlackBoard():SetIsInterruptingSilent(true)
		for _, DealNode in ipairs(running_nodes) do 
			DealNode:Interrupt(theOwner)
		end
		theOwner:GetBlackBoard():SetIsInterruptingSilent(false)
		theOwner:GetBlackBoard():TellBTInterrupt(self)
	end
	return true
end
