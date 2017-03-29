module("ai",package.seeall)

bt_attack_3 = class("bt_attack_3", clsBehaviorTree)

function bt_attack_3:ctor()
	clsBehaviorTree.ctor(self)
	
	local nodeHasFightTarget = clsHasFightTarget.new()
	local nodeFindNear = clsFindNearestEnemy.new()
	local nodeCastSkill = clsCastSkill.new(3)
	
	self:SetRootNode(nodeHasFightTarget)
		nodeHasFightTarget:SetRightNode(nodeCastSkill)
		nodeHasFightTarget:SetLeftNode(nodeFindNear)
			nodeFindNear:SetRightNode(nodeCastSkill)
			nodeFindNear:SetLeftNode(nodeCastSkill)
end