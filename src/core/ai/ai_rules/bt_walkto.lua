module("ai",package.seeall)

bt_walkto = class("bt_walkto", clsBehaviorTree)

function bt_walkto:ctor()
	clsBehaviorTree.ctor(self)
	
	self.nodeRunto = clsGoTo.new()
	
	self:SetRootNode(self.nodeRunto)
end
