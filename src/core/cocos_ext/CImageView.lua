clsImageView = class("clsImageView", function() return ccui.ImageView:create() end)

function clsImageView:ctor(parent)
	if parent then KE_SetParent(self, parent) end
	self:setScale9Enabled(true)
	self:setTouchEnabled(true)
end

function clsImageView:dtor()
	KE_RemoveFromParent(self)
end

KE_ExtendClass(clsImageView)
