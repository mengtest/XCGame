clsNode = class("clsNode", function() return cc.Node:create() end)

function clsNode:ctor(parent)
	if parent then KE_SetParent(self, parent) end
end

function clsNode:dtor()
	self:DisableNodeEvents()
	KE_RemoveFromParent(self)
end

KE_ExtendClass(clsNode)
