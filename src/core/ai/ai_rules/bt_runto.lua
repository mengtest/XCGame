module("ai",package.seeall)

bt_runto = class("bt_runto", clsBehaviorTree)

function bt_runto:ctor()
	clsBehaviorTree.ctor(self)
	
	self.nodeRunto = clsGoTo.new()
	
	self:SetRootNode(self.nodeRunto)
end
