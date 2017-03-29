--------------------------------------
-- 行为树框架
-- 具体实现要继承自 clsDecoratorNode clsConditionNode clsActionNode clsImpulseNode
--------------------------------------
module("ai",package.seeall)

-- 节点基类
clsBehaviorNodeBase = class("clsBehaviorNodeBase")

function clsBehaviorNodeBase:ctor()
	self.mLeftNode = nil
	self.mRightNode = nil
	self.mParentNode = nil
end

function clsBehaviorNodeBase:dtor()
	self.mParentNode = nil 
	if self.mLeftNode then KE_SafeDelete(self.mLeftNode) self.mLeftNode = nil end
	if self.mRightNode then KE_SafeDelete(self.mRightNode) self.mRightNode = nil end
end

function clsBehaviorNodeBase:Proc(theOwner)
	assert(false, "must override this method")
end

-- 执行本节点
--@return if    BT_SUCCESS: 成功
--@return if    BT_FAIL: 失败
--@return if    BT_RUNNING: 执行中（需要处理一段时间才知道成功还是失败）
function clsBehaviorNodeBase:Execute(theOwner)
	if theOwner:GetBlackBoard():GetIsInterrupting() then return BT_FAIL end
	
	-- before deal
	theOwner:GetBlackBoard():AddRunningNode(self)
	
	-- dealing
	local result = self:Proc(theOwner)
	assert(IsValidBtNodeState(result))
	
	if result == BT_RUNNING then
		return BT_RUNNING
	end
	
	-- deal over 
	return self:OnDealOver(theOwner, result)
end

-- 执行完成后调用
function clsBehaviorNodeBase:OnDealOver(theOwner, result)
	assert(result==BT_SUCCESS or result==BT_FAIL)
	theOwner:GetBlackBoard():DelRunningNode(self, result)
	
	-- 成立则往右走，不成立则往左走
	if result == BT_SUCCESS then
		if self.mRightNode then 
			return self.mRightNode:Execute(theOwner) 
		end
	elseif result == BT_FAIL then
		if self.mLeftNode then 
			return self.mLeftNode:Execute(theOwner) 
		end
	end
	
	-- 没有孩子节点了，表明整棵树已经执行完成
	theOwner:GetBlackBoard():TellBTResult(self:GetBTTree(), result)
	
	return result
end

function clsBehaviorNodeBase:IsRunning(theOwner)
	return theOwner:GetBlackBoard():HasRunningNode(self)
end

function clsBehaviorNodeBase:OnInterrupt(theOwner)

end

function clsBehaviorNodeBase:Interrupt(theOwner)
	assert(self:IsRunning(theOwner), "该节点不在执行中，无需中断")
	self:OnInterrupt(theOwner)
	theOwner:GetBlackBoard():DelRunningNode(self, BT_FAIL)
end

function clsBehaviorNodeBase:SetRightNode(rNode)
	assert(rNode~=self and not self.mRightNode)
	self.mRightNode = rNode
	rNode.mParentNode = self
end

function clsBehaviorNodeBase:SetLeftNode(lNode)
	assert(lNode~=self and not self.mLeftNode)
	self.mLeftNode = lNode
	lNode.mParentNode = self
end

function clsBehaviorNodeBase:GetRoot()
	if self.mParentNode then
		return self.mParentNode:GetRoot()
	else
		return self
	end
end

function clsBehaviorNodeBase:SetBTTree(btTree)
	assert(not self.mBTTree, "已经设置过mBTTree")
	self.mBTTree = btTree
end

function clsBehaviorNodeBase:GetBTTree()
	if self.mBTTree then return self.mBTTree end
	self.mBTTree = self:GetRoot().mBTTree
	return self.mBTTree
end

function clsBehaviorNodeBase:GetRuntimeInfo(theOwner, result)
	return string.format("%20s: %5s   %s,%s,%s", 
						self.__cname,
						result,
						theOwner:GetActState(),
						theOwner:GetGrdMovState(),
						theOwner:GetSkyMovState())
end

-------------------------------------------------------------------------

--复合节点基类，不能为叶子节点
local clsICompositeNode = class("clsICompositeNode", clsBehaviorNodeBase)

function clsICompositeNode:ctor(child_list)
	clsBehaviorNodeBase.ctor(self)
	self.tChildList = {}
	for _, subNode in ipairs(child_list or {}) do
		self:AddElement(subNode)
	end
end

function clsICompositeNode:dtor()
	self:ClearElement()
end

function clsICompositeNode:AddElement(btNode)
	table.insert(self.tChildList, btNode)
end

function clsICompositeNode:RemoveElement(btNode)
	for i, node in ipairs(self.tChildList) do
		if node == btNode then
			table.remove(self.tChildList, i)
			return 
		end
	end
end

function clsICompositeNode:ClearElement()
	for _, node in ipairs(self.tChildList) do
		KE_SafeDelete(node)
	end
	self.tChildList = {}
end

-- 复合节点：与
clsAndCompositeNode = class("clsAndCompositeNode", clsICompositeNode)

function clsAndCompositeNode:ctor(child_list)
	clsICompositeNode.ctor(self,child_list)
end

function clsAndCompositeNode.dtor()

end

function clsAndCompositeNode:Proc(theOwner)
	for _, child in ipairs(self.tChildList) do
		if child:Proc(theOwner) == BT_FAIL then
			return BT_FAIL
		end
	end
	return BT_SUCCESS
end

-- 复合节点：或
clsOrCompositeNode = class("clsOrCompositeNode", clsICompositeNode)

function clsOrCompositeNode:ctor(child_list)
	clsICompositeNode.ctor(self,child_list)
end

function clsOrCompositeNode.dtor()

end

function clsOrCompositeNode:Proc(theOwner)
	for _, child in ipairs(self.tChildList) do
		if child:Proc(theOwner) == BT_SUCCESS then
			return BT_SUCCESS
		end
	end
	return BT_FAIL
end

--------------------------------------------------------------------

-- 装饰结点
clsDecoratorNode = class("clsDecoratorNode", clsBehaviorNodeBase)

function clsDecoratorNode:ctor(decTarget)
	clsBehaviorNodeBase.ctor(self)
	self:Proxy(decTarget)
end

function clsDecoratorNode:Proc(theOwner)
	return self._decorateTarget:Proc(theOwner)
end

function clsDecoratorNode:Proxy(decTarget)
	assert(decTarget)
	self._decorateTarget = decTarget
end

-- 神经冲动结点
clsImpulseNode = class("clsImpulseNode", clsBehaviorNodeBase)

function clsImpulseNode:ctor()
	clsBehaviorNodeBase.ctor(self)
end

-- 条件判断节点
clsConditionNode = class("clsConditionNode", clsBehaviorNodeBase)

function clsConditionNode:ctor()
	clsBehaviorNodeBase.ctor(self)
end

-- 动作节点
clsActionNode = class("clsActionNode", clsBehaviorNodeBase)

function clsActionNode:ctor()
	clsBehaviorNodeBase.ctor(self)
end
