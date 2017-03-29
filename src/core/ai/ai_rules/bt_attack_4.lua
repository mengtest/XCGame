module("ai",package.seeall)

bt_attack_4 = class("bt_attack_4", clsBehaviorTree)

function bt_attack_4:ctor()
	clsBehaviorTree.ctor(self)
	
	local nodeHasFightTarget = clsHasFightTarget.new()
	local nodeFindNear = clsFindNearestEnemy.new()
	local nodeCastSkill = clsCastSkill.new(4)
	
	self:SetRootNode(nodeHasFightTarget)
		nodeHasFightTarget:SetRightNode(nodeCastSkill)
		nodeHasFightTarget:SetLeftNode(nodeFindNear)
			nodeFindNear:SetRightNode(nodeCastSkill)
			nodeFindNear:SetLeftNode(nodeCastSkill)
end
