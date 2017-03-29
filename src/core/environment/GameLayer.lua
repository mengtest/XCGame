clsGameLayer = class("clsGameLayer", clsLayer)

function clsGameLayer:ctor(iLayerId, Parent)
	assert(iLayerId and Parent)
	clsLayer.ctor(self)
	
	self.iLayerId = iLayerId
	
	self:AddScriptHandler(const.CORE_EVENT.cleanup, function()
		KE_Director:GetLayerMgr():OnLayerDel(self.iLayerId)
	end)
	
	KE_SetParent(self, Parent, iLayerId)
	KE_Director:GetLayerMgr():OnLayerNew(iLayerId, self)
end

function clsGameLayer:dtor()
	KE_Director:GetLayerMgr():OnLayerDel(self.iLayerId)
end
