-------------
-- 确认框
-------------
module("ui", package.seeall)

clsConfirmDlg = class("clsConfirmDlg", clsWindow)

function clsConfirmDlg:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_dialog/confirm_dlg.lua")
	self:setSwallowTouches(true)
	
    utils.RegButtonEvent(self:GetCompByName("btn_ok"), function()
		self:Show(false)
		if self.funcOk then self.funcOk() end 
	end)
	
	utils.RegButtonEvent(self:GetCompByName("btn_cancel"), function()
		self:Show(false)
		if self.funcCancel then self.funcCancel() end 
	end)
end

function clsConfirmDlg:dtor()
	
end

function clsConfirmDlg:Refresh(sTitle, sTips, OkCallback, NoCallback)
	self.funcOk = OkCallback
	self.funcCancel = NoCallback
	if sTitle then self:GetCompByName("label_title"):setString(sTitle) end
	if sTips then self:GetCompByName("label_tips"):setString(sTips) end
end
