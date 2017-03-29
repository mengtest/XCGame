-------------------
-- 邮件
-------------------
module("ui", package.seeall)

clsEmailPanel = class("clsEmailPanel", clsCommonFrame)

function clsEmailPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_email/email_panel.lua", "邮件")
end

function clsEmailPanel:dtor()
	
end
