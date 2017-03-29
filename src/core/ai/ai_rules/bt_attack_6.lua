module("ai",package.seeall)

bt_attack_6 = class("bt_attack_6", clsBehaviorTree)

function bt_attack_6:ctor()
	clsBehaviorTree.ctor(self)
	
	local nodeHasFightTarget = clsHasFightTarget.new()
	local nodeFindNear = clsFindNearestEnemy.new()
	local nodeCastSkill = clsCastSkill.new(6)
	
	self:SetRootNode(nodeHasFightTarget)
		nodeHasFightTarget:SetRightNode(nodeCastSkill)
		nodeHasFightTarget:SetLeftNode(nodeFindNear)
			nodeFindNear:SetRightNode(nodeCastSkill)
			nodeFindNear:SetLeftNode(nodeCastSkill)
end
