clsListView = class("clsListView", function() return ccui.ListView:create() end)

function clsListView:ctor(parent)
	if parent then KE_SetParent(self, parent) end
end

function clsListView:dtor()
	KE_RemoveFromParent(self)
end

KE_ExtendClass(clsListView)
