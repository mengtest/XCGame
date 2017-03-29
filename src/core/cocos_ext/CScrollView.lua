clsScrollView = class("clsScrollView", function() return ccui.ScrollView:create() end)

function clsScrollView:ctor(parent)
	if parent then KE_SetParent(self, parent) end
end

function clsScrollView:dtor()
	KE_RemoveFromParent(self)
end

KE_ExtendClass(clsScrollView)
