------------------
-- 比武招亲界面
------------------
module("ui", package.seeall)

clsWuzhaoPanel = class("clsWuzhaoPanel", clsCommonFrame)

function clsWuzhaoPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_wuzhao/wuzhao_panel.lua", "比武招亲")
	
end

function clsWuzhaoPanel:dtor()
	
end
