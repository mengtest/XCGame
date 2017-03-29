-----------------
-- 场景
-----------------
module("editorphys", package.seeall)

clsPhysEditPanel = class("clsPhysEditPanel", ui.clsWindow)

function clsPhysEditPanel:ctor(Parent)
	Parent = Parent or KE_Director:GetLayerMgr():GetLayer(const.LAYER_PANEL)
	ui.clsWindow.ctor(self,Parent)
end

function clsPhysEditPanel:dtor()
	
end
