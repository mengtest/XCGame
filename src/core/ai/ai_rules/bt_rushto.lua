module("ai",package.seeall)

bt_rushto = class("bt_rushto", clsBehaviorTree)

function bt_rushto:ctor()
	clsBehaviorTree.ctor(self)
	
	self.nodeRunto = clsGoTo.new()
	
	self:SetRootNode(self.nodeRunto)
end
