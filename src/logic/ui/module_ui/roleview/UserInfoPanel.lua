------------------
-- 角色信息面板
------------------
module("ui", package.seeall)

clsUserInfoPanel = class("clsUserInfoPanel", clsCommonFrame)

function clsUserInfoPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_role/userinfo_panel.lua", "角色信息")
end

function clsUserInfoPanel:dtor()
	
end

function clsUserInfoPanel:Refresh(UserId)
	self._UserId = UserId
end
